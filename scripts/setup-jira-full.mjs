#!/usr/bin/env node
/**
 * Company-level Jira setup: creates a NEW project (if possible) and all Epics + Stories
 * from jira-full-structure.json, with UI vs Functionality breakdown and labels.
 *
 * Uses .env: JIRA_DOMAIN, JIRA_EMAIL, JIRA_API_TOKEN.
 * Optional: JIRA_PROJECT_KEY – if set, skip project creation and use this project.
 * Optional: JIRA_CREATE_PROJECT=true – try to create project (needs Jira admin).
 *
 * Run: node scripts/setup-jira-full.mjs
 */

import https from 'https';
import { readFileSync, existsSync } from 'fs';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

const __dirname = dirname(fileURLToPath(import.meta.url));

const envPath = join(__dirname, '..', '.env');
if (existsSync(envPath)) {
  for (const line of readFileSync(envPath, 'utf8').split('\n')) {
    const m = line.match(/^\s*([A-Za-z_][A-Za-z0-9_]*)\s*=\s*(.*)\s*$/);
    if (m) process.env[m[1]] = m[2].replace(/^["']|["']$/g, '').trim();
  }
}

const domain = process.env.JIRA_DOMAIN;
const email = process.env.JIRA_EMAIL;
const apiToken = process.env.JIRA_API_TOKEN;
const existingProjectKey = process.env.JIRA_PROJECT_KEY;
const tryCreateProject = process.env.JIRA_CREATE_PROJECT === 'true' || process.env.JIRA_CREATE_PROJECT === '1';

if (!domain || !email || !apiToken) {
  console.error('Set JIRA_DOMAIN, JIRA_EMAIL, and JIRA_API_TOKEN in .env');
  process.exit(1);
}

const auth = Buffer.from(`${email}:${apiToken}`).toString('base64');

function jiraRequest(method, path, body = null) {
  return new Promise((resolve, reject) => {
    const options = {
      hostname: domain,
      path: `/rest/api/3${path}`,
      method,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': `Basic ${auth}`,
      },
    };
    if (body) {
      options.headers['Content-Length'] = Buffer.byteLength(JSON.stringify(body));
    }
    const req = https.request(options, (res) => {
      let data = '';
      res.on('data', (ch) => (data += ch));
      res.on('end', () => {
        try {
          const parsed = data ? JSON.parse(data) : {};
          if (res.statusCode >= 200 && res.statusCode < 300) resolve(parsed);
          else reject(new Error(`HTTP ${res.statusCode}: ${JSON.stringify(parsed.errors || parsed.errorMessages || parsed)}`));
        } catch (e) {
          reject(new Error(data || res.statusMessage));
        }
      });
    });
    req.on('error', reject);
    if (body) req.write(JSON.stringify(body));
    req.end();
  });
}

function descriptionToAdf(text) {
  if (!text) return undefined;
  return {
    type: 'doc',
    version: 1,
    content: [{ type: 'paragraph', content: [{ type: 'text', text }] }],
  };
}

async function main() {
  const dataPath = join(__dirname, 'jira-full-structure.json');
  const data = JSON.parse(readFileSync(dataPath, 'utf8'));
  const projectConfig = data.project || { name: 'SaaS Website', key: 'SAAS', description: '' };
  const projectKey = existingProjectKey || projectConfig.key;

  let projectId;
  let createdProject = false;

  if (!existingProjectKey && tryCreateProject) {
    try {
      const me = await jiraRequest('GET', '/myself');
      const leadAccountId = me.accountId;
      const body = {
        name: projectConfig.name,
        key: projectConfig.key,
        projectTypeKey: 'software',
        projectTemplateKey: 'com.pyxis.greenhopper.jira:gh-simplified-agility-scrum',
        description: projectConfig.description || '',
        leadAccountId,
        assigneeType: 'PROJECT_LEAD',
      };
      const created = await jiraRequest('POST', '/project', body);
      projectId = created.id;
      createdProject = true;
      console.log('Created project', created.key, '(id:', created.id, ')');
    } catch (e) {
      console.warn('Could not create project (need Jira admin?):', e.message);
      console.warn('Create project manually: name', projectConfig.name, ', key', projectConfig.key, ', Scrum. Then set JIRA_PROJECT_KEY=' + projectConfig.key);
    }
  }

  if (!projectId) {
    const project = await jiraRequest('GET', `/project/${projectKey}`).catch((e) => {
      console.error('Project', projectKey, 'not found. Create it in Jira or set JIRA_PROJECT_KEY.');
      throw e;
    });
    projectId = project.id;
    if (!createdProject) console.log('Using existing project', projectKey);
  }

  const project = await jiraRequest('GET', `/project/${projectKey}`);
  const issueTypes = project.issueTypes || [];
  const epicType = issueTypes.find((t) => t.name === 'Epic' || t.name === 'epic');
  const storyType = issueTypes.find((t) => t.name === 'Story' || t.name === 'story');
  if (!epicType) console.warn('Epic type not found. Available:', issueTypes.map((t) => t.name).join(', '));
  if (!storyType) console.warn('Story type not found.');

  const epicTypeId = epicType?.id;
  const storyTypeId = storyType?.id;

  const createdEpics = {};
  for (const epic of data.epics) {
    const body = {
      fields: {
        project: { id: projectId },
        issuetype: { id: epicTypeId },
        summary: epic.name,
        description: descriptionToAdf(epic.description),
      },
    };
    const created = await jiraRequest('POST', '/issue', body).catch((e) => {
      console.error('Epic "' + epic.name + '":', e.message);
      return null;
    });
    if (created) {
      createdEpics[epic.name] = created.key;
      console.log('Epic', created.key, epic.name);
    }
  }

  for (const story of data.stories) {
    const parentKey = createdEpics[story.epic];
    const labels = Array.isArray(story.labels) ? story.labels : [];
    const body = {
      fields: {
        project: { id: projectId },
        issuetype: { id: storyTypeId },
        summary: story.summary,
        ...(labels.length > 0 && { labels }),
        ...(parentKey && { parent: { key: parentKey } }),
      },
    };
    const created = await jiraRequest('POST', '/issue', body).catch((e) => {
      console.error('Story "' + story.summary + '":', e.message);
      return null;
    });
    if (created) console.log('Story', created.key, story.summary);
  }

  console.log('\nDone. Open project', projectKey, '→ Backlog or Board. Filter by labels: ui, functionality, auth, dashboard, etc.');
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
