#!/usr/bin/env node
/**
 * Deletes the old Jira issues (S1-3 through S1-18), keeping only the
 * Epics and Stories created by create-jira-tickets.mjs (S1-19 through S1-37).
 *
 * Uses same .env as create-jira-tickets.mjs (JIRA_DOMAIN, JIRA_EMAIL, JIRA_API_TOKEN).
 * Run: node scripts/delete-old-jira-tickets.mjs
 *
 * If you get HTTP 403: your Jira user needs "Delete issues" permission on the project
 * (Project settings → People/Permissions). Or delete S1-3..S1-18 manually in Jira (Bulk change → Delete).
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

if (!domain || !email || !apiToken) {
  console.error('Set JIRA_DOMAIN, JIRA_EMAIL, and JIRA_API_TOKEN in .env');
  process.exit(1);
}

const auth = Buffer.from(`${email}:${apiToken}`).toString('base64');

function jiraRequest(method, path) {
  return new Promise((resolve, reject) => {
    const options = {
      hostname: domain,
      path: `/rest/api/3${path}`,
      method,
      headers: {
        'Accept': 'application/json',
        'Authorization': `Basic ${auth}`,
      },
    };
    const req = https.request(options, (res) => {
      let data = '';
      res.on('data', (ch) => (data += ch));
      res.on('end', () => {
        if (res.statusCode >= 200 && res.statusCode < 300) {
          resolve(data ? JSON.parse(data) : {});
        } else {
          const msg = data || res.statusMessage || `HTTP ${res.statusCode}`;
          try {
            const parsed = data ? JSON.parse(data) : {};
            reject(new Error(`HTTP ${res.statusCode}: ${JSON.stringify(parsed.errors || parsed.errorMessages || parsed || msg)}`));
          } catch (e) {
            reject(new Error(`HTTP ${res.statusCode}: ${msg}`));
          }
        }
      });
    });
    req.on('error', reject);
    req.end();
  });
}

// Old issue keys to remove (everything before S1-19)
const OLD_KEYS = [
  'S1-3', 'S1-6', 'S1-8', 'S1-9', 'S1-10', 'S1-11', 'S1-12', 'S1-13',
  'S1-14', 'S1-15', 'S1-16', 'S1-17', 'S1-18',
];

async function main() {
  for (const key of OLD_KEYS) {
    try {
      await jiraRequest('DELETE', `/issue/${key}?deleteSubtasks=true`);
      console.log('Deleted', key);
    } catch (e) {
      console.error('Failed to delete', key, ':', e.message);
    }
  }
  console.log('Done. Only S1-19 through S1-37 (Epics + Stories) remain.');
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
