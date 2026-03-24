#!/usr/bin/env node
/**
 * Creates Epics and Stories in Jira from scripts/jira-tickets-data.json.
 *
 * Requires:
 *   - JIRA_DOMAIN (e.g. niroopk.atlassian.net)
 *   - JIRA_EMAIL (your Atlassian account email)
 *   - JIRA_API_TOKEN (from https://id.atlassian.com/manage-profile/security/api-tokens)
 *   - JIRA_PROJECT_KEY (optional, default: S1 — use SAAS after creating that project)
 *
 * Run: node scripts/create-jira-tickets.mjs
 */

import https from 'https';
import { readFileSync, existsSync } from 'fs';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

const __dirname = dirname(fileURLToPath(import.meta.url));

// Load .env from repo root if present
const envPath = join(__dirname, '..', '.env');
if (existsSync(envPath)) {
  for (const line of readFileSync(envPath, 'utf8').split('\n')) {
    const m = line.match(/^\s*([A-Za-z_][A-Za-z0-9_]*)\s*=\s*(.*)\s*$/);
    if (m) process.env[m[1]] = m[2].replace(/^["']|["']$/g, '').trim();
  }
} else {
  console.error('No .env file at', envPath);
  console.error('  Copy: cp .env.example .env');
  console.error('  Then set JIRA_EMAIL and JIRA_API_TOKEN in .env');
}

const domain = process.env.JIRA_DOMAIN;
const email = process.env.JIRA_EMAIL;
const apiToken = process.env.JIRA_API_TOKEN;
const projectKey = process.env.JIRA_PROJECT_KEY || 'S1'; // S1 = existing "SaaS #1" project

if (!domain || !email || !apiToken) {
  console.error('Set JIRA_DOMAIN, JIRA_EMAIL, and JIRA_API_TOKEN in .env (or export them).');
  console.error('  API token: https://id.atlassian.com/manage-profile/security/api-tokens');
  if (!existsSync(envPath)) console.error('  Create .env from .env.example first.');
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
          else reject(new Error(JSON.stringify(parsed.errors || parsed.errorMessages || parsed)));
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
  const dataPath = join(__dirname, 'jira-tickets-data.json');
  const data = JSON.parse(readFileSync(dataPath, 'utf8'));

  console.log(`Project key: ${projectKey}`);
  const project = await jiraRequest('GET', `/project/${projectKey}`).catch((e) => {
    console.error('Failed to load project. Create it first (see docs/JIRA_SETUP_GUIDE.md) or use JIRA_PROJECT_KEY=S1.');
    throw e;
  });
  const projectId = project.id;
  const issueTypes = project.issueTypes || [];
  const epicType = issueTypes.find((t) => t.name === 'Epic' || t.name === 'epic');
  const storyType = issueTypes.find((t) => t.name === 'Story' || t.name === 'story');
  if (!epicType) console.warn('Epic issue type not found; creating Epics may fail. Available:', issueTypes.map((t) => t.name).join(', '));
  if (!storyType) console.warn('Story issue type not found; creating Stories may fail.');

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
      console.error(`Epic "${epic.name}": ${e.message}`);
      return null;
    });
    if (created) {
      createdEpics[epic.name] = created.key;
      console.log(`Created Epic ${created.key}: ${epic.name}`);
    }
  }

  for (const story of data.stories) {
    const parentKey = createdEpics[story.epic];
    const body = {
      fields: {
        project: { id: projectId },
        issuetype: { id: storyTypeId },
        summary: story.summary,
        ...(parentKey && { parent: { key: parentKey } }),
      },
    };
    const created = await jiraRequest('POST', '/issue', body).catch((e) => {
      console.error(`Story "${story.summary}": ${e.message}`);
      return null;
    });
    if (created) console.log(`Created Story ${created.key}: ${story.summary}`);
  }

  console.log('Done. Open your Jira project Backlog or Board to see the new Epics and Stories.');
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
