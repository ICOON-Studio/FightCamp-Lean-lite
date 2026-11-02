// grokbot_direct.mjs - drive the Grok bots (John Research, Kalli, Maria Art Director, Grok Dev) straight through the
// Grok Bot cloud box's gateway, without grok-bot-cli.
//
// WHY (S230, operator: "do a research how to use grokbots in this game process, the desktop app shows 0% used"):
// gbot 0.12.4 is dead two ways - it reads the app's gateway descriptor (v3 since app 0.70.2: "Unsupported descriptor
// version 3") and its own EnsureSandBox fallback sends client version 0.20.0 ("This version of Grok Bot is no longer
// supported"). The xAI API route (xai-research.yml) is a separate, paid team account (403 out of credits, S230).
// The bots themselves run on the operator's Grok Bot plan (the app's usage meter). gbot_wake.mjs already proves the
// path: EnsureSandBox with the PC's Cursor login + the INSTALLED app's version -> gatewayUrl/gatewayToken -> POST
// <gateway>/api/<method>. This file adds the three methods gbot used: listAgents, sendPrompt, getAgentTranscriptTail.
// The tokens live in memory only and go only to *.cursor.sh and the box gateway; nothing is printed or written.
//
// USE:
//   node Tools/grokbot_direct.mjs list
//   node Tools/grokbot_direct.mjs send  <bot> <message-file>           (bot: john | kalli | maria | dev | full name)
//   node Tools/grokbot_direct.mjs tail  <bot> [limit=20] [--out file]  (the bot's last transcript entries as JSON)
import { readFileSync, writeFileSync, existsSync } from 'node:fs';
import { join } from 'node:path';
import { randomUUID } from 'node:crypto';

const APPDATA = process.env.APPDATA || join(process.env.USERPROFILE || '', 'AppData', 'Roaming');
const BACKEND = 'https://api2.cursor.sh';
const SHORT = { john: 'John Research', kalli: 'Kalli', maria: 'Maria Art Director', dev: 'Grok Dev' };

function fail(why) { console.log('GROKBOT FAIL ' + why); process.exit(1); }

function cursorToken() {
  const env = (process.env.CURSOR_ACCESS_TOKEN || '').trim();
  if (env) return env;
  const p = join(APPDATA, 'Cursor', 'auth.json');
  if (!existsSync(p)) fail('no Cursor login on this PC - run `cursor-agent login` once');
  const t = JSON.parse(readFileSync(p, 'utf8')).accessToken;
  if (!t) fail('Cursor login file has no token');
  return String(t);
}

function clientVersion() {
  try { return String(JSON.parse(readFileSync(join(APPDATA, 'Grok Bot', 'desktop-status.json'), 'utf8')).appVersion || '0.71.2'); }
  catch { return '0.71.2'; }
}

async function ensureSandbox() {
  const token = cursorToken();
  const version = clientVersion();
  const started = Date.now();
  for (;;) {
    const res = await fetch(BACKEND + '/aiserver.v1.GrokBotService/EnsureSandBox', {
      method: 'POST', redirect: 'error', signal: AbortSignal.timeout(60000),
      headers: { 'content-type': 'application/json', 'connect-protocol-version': '1', authorization: 'Bearer ' + token,
        'x-cursor-client-type': 'sand', 'x-cursor-client-version': version, 'x-sand-box-namespace': 'prod' },
      body: JSON.stringify({ wake: true, supportsAsleepBox: true }),
    });
    const text = await res.text();
    let box = {};
    try { box = JSON.parse(text); } catch {}
    if (!res.ok) fail('EnsureSandBox ' + res.status + ': ' + String(box.message || text).replace(/[A-Za-z0-9_\-.]{40,}/g, '<long>').slice(0, 160));
    if (String(box.runState || '').endsWith('RUNNING') && box.gatewayUrl && box.gatewayToken) return box;
    if (Date.now() - started > 120000) fail('box not RUNNING after 120 s (' + box.runState + ')');
    await new Promise((r) => setTimeout(r, 5000));
  }
}

async function call(box, method, body = {}, timeoutMs = 60000) {
  const headers = { 'content-type': 'application/json', authorization: 'Bearer ' + box.gatewayToken };
  if (box.networkToken) headers['x-anyrun-network-token'] = box.networkToken;
  const res = await fetch(String(box.gatewayUrl).replace(/\/$/, '') + '/api/' + method, {
    method: 'POST', redirect: 'error', headers, body: JSON.stringify(body), signal: AbortSignal.timeout(timeoutMs),
  });
  const text = await res.text();
  let data = text;
  try { data = JSON.parse(text); } catch {}
  if (!res.ok) fail(method + ' ' + res.status + ' ' + (res.headers.get('x-anyrun-failure-reason') || '') + ' ' + String(text).slice(0, 200));
  return data;
}

function agentsOf(data) {
  const list = Array.isArray(data) ? data : (data.agents || data.items || data.records || []);
  return list.map((a) => ({ id: a.id || a.agentId, name: a.name || a.displayName || '', isGroup: !!a.isGroup }));
}

async function resolve(box, ref) {
  const want = (SHORT[String(ref).toLowerCase()] || ref).toLowerCase();
  const agents = agentsOf(await call(box, 'listAgents'));
  const hit = agents.find((a) => a.name.toLowerCase() === want) || agents.find((a) => a.name.toLowerCase().includes(want));
  if (!hit) fail('no bot named "' + ref + '" (have: ' + agents.map((a) => a.name).join(', ') + ')');
  return hit;
}

const [cmd, ...rest] = process.argv.slice(2);
const box = await ensureSandbox();
if (cmd === 'list') {
  for (const a of agentsOf(await call(box, 'listAgents'))) console.log((a.isGroup ? 'GROUP ' : 'BOT   ') + a.name);
} else if (cmd === 'send') {
  const [ref, file] = rest;
  if (!ref || !file) fail('usage: send <bot> <message-file>');
  const bot = await resolve(box, ref);
  const prompt = readFileSync(file, 'utf8');
  const data = await call(box, 'sendPrompt', { agentId: bot.id, prompt, clientNonce: randomUUID() }, 300000);
  console.log('GROKBOT SENT to ' + bot.name + ' (' + prompt.length + ' chars) ' + JSON.stringify(data).slice(0, 160));
} else if (cmd === 'tail') {
  const ref = rest[0];
  const outAt = rest.indexOf('--out');
  const out = outAt >= 0 ? rest[outAt + 1] : '';
  const limit = Math.min(200, Math.max(1, parseInt(rest[1] && rest[1] !== '--out' ? rest[1] : '20', 10) || 20));
  const bot = await resolve(box, ref);
  const data = await call(box, 'getAgentTranscriptTail', { id: bot.id, limit });
  const text = JSON.stringify(data, null, 2);
  if (out) writeFileSync(out, text, 'utf8');
  console.log('GROKBOT TAIL ' + bot.name + ' ' + text.length + ' chars' + (out ? ' -> ' + out : ''));
  if (!out) console.log(text.slice(0, 4000));
} else {
  fail('usage: list | send <bot> <file> | tail <bot> [limit] [--out file]');
}
