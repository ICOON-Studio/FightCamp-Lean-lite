// gbot_wake.mjs - wake the Grok Bot cloud pod so gbot (Kalli, John, Maria) works.
//
// WHY (S180, 2026-10-08, operator: "i do not want this to happen again fix it once and for all"):
// gbot failed with "417 Expectation Failed" for two sessions. The real answer was in the response headers:
// `x-anyrun-failure-reason: pod_hibernated`. Since ~10-05 the Grok Bot desktop app (0.66) parks the pod
// whenever its window is unfocused or the PC is idle (server gates sand_desktop_away_park /
// sand_desktop_present_park). gbot 0.12.4 talks to the parked pod through the app's cached gateway
// descriptor and has no wake call at all; its own EnsureSandBox fallback sends client version 0.20.0,
// which the backend now refuses ("This version of Grok Bot is no longer supported").
//
// WHAT: POST api2.cursor.sh GrokBotService/EnsureSandBox {wake:true, supportsAsleepBox:true} with the
// Cursor login of this PC (same account as the app: the Cursor CLI's %APPDATA%\Cursor\auth.json, or
// CURSOR_ACCESS_TOKEN) and the installed app's own client version, wait for RUNNING, then prove the
// gateway answers listAgents 200. The token is read in memory and sent only to *.cursor.sh; it is never
// printed, logged or written anywhere.
//
// USE: node Tools/gbot_wake.mjs            -> one line "GBOT WAKE ok ..." (exit 0) or "GBOT WAKE FAIL <why>" (exit 1)
//      python Tools/gbot.py <gbot args>    -> runs gbot, wakes + retries once on a parked pod (use this, not bare gbot)
import { readFileSync, existsSync } from 'node:fs';
import { join } from 'node:path';

const APPDATA = process.env.APPDATA || join(process.env.USERPROFILE || '', 'AppData', 'Roaming');
const BACKEND = 'https://api2.cursor.sh';
const FALLBACK_CLIENT_VERSION = '0.66.0'; // the app version that worked on 2026-10-08
const RUN_TIMEOUT_MS = 120000;

function fail(why) {
  console.log('GBOT WAKE FAIL ' + why);
  process.exit(1);
}

function cursorToken() {
  const env = (process.env.CURSOR_ACCESS_TOKEN || '').trim();
  if (env) return env;
  const p = join(APPDATA, 'Cursor', 'auth.json');
  if (!existsSync(p)) fail('no Cursor login on this PC (' + p + ' missing) - run `cursor-agent login` once');
  try {
    const t = JSON.parse(readFileSync(p, 'utf8')).accessToken;
    if (t) return String(t);
  } catch {}
  fail('Cursor login file unreadable: ' + p);
}

function clientVersion() {
  const p = join(APPDATA, 'Grok Bot', 'desktop-status.json');
  try {
    const v = JSON.parse(readFileSync(p, 'utf8')).appVersion;
    if (v) return String(v);
  } catch {}
  return FALLBACK_CLIENT_VERSION;
}

async function ensureSandbox(token, version) {
  const res = await fetch(BACKEND + '/aiserver.v1.GrokBotService/EnsureSandBox', {
    method: 'POST',
    redirect: 'error',
    signal: AbortSignal.timeout(60000),
    headers: {
      'content-type': 'application/json',
      'connect-protocol-version': '1',
      authorization: 'Bearer ' + token,
      'x-cursor-client-type': 'sand',
      'x-cursor-client-version': version,
      'x-sand-box-namespace': 'prod',
    },
    body: JSON.stringify({ wake: true, supportsAsleepBox: true }),
  });
  const text = await res.text();
  let body = {};
  try { body = JSON.parse(text); } catch {}
  if (!res.ok) {
    const msg = String(body.message || text || res.statusText).replace(/[A-Za-z0-9_\-.]{40,}/g, '<long>').slice(0, 200);
    if (/no longer supported/i.test(msg)) fail('the Grok Bot app ' + version + ' is too old for the backend - update it from cursor.com/sand (gbot_wake reads its version)');
    if (res.status === 401) fail('Cursor login refused (401: ' + msg + ') - run `cursor-agent login` once');
    fail('EnsureSandBox ' + res.status + ': ' + msg);
  }
  return body;
}

async function gatewayOk(box) {
  if (!box.gatewayUrl || !box.gatewayToken) return 'no gateway in the reply';
  const headers = { 'content-type': 'application/json', authorization: 'Bearer ' + box.gatewayToken };
  if (box.networkToken) headers['x-anyrun-network-token'] = box.networkToken;
  try {
    const res = await fetch(String(box.gatewayUrl).replace(/\/$/, '') + '/api/listAgents', {
      method: 'POST', redirect: 'error', headers, body: '{}', signal: AbortSignal.timeout(30000),
    });
    if (res.ok) return '';
    return res.status + ' ' + (res.headers.get('x-anyrun-failure-reason') || res.statusText);
  } catch (e) {
    return String(e && e.message || e).slice(0, 120);
  }
}

const token = cursorToken();
const version = clientVersion();
const started = Date.now();
let box = await ensureSandbox(token, version);
let gw = '';
for (;;) {
  const running = String(box.runState || '').endsWith('RUNNING');
  if (running) {
    gw = await gatewayOk(box);
    if (gw === '') break;
  }
  if (Date.now() - started > RUN_TIMEOUT_MS) {
    fail('pod not serving after ' + Math.round(RUN_TIMEOUT_MS / 1000) + ' s (runState ' + box.runState + ', gateway ' + (gw || 'not probed') + ')');
  }
  await new Promise((r) => setTimeout(r, 5000));
  box = await ensureSandbox(token, version);
}
const secs = ((Date.now() - started) / 1000).toFixed(1);
console.log('GBOT WAKE ok pod=' + box.podId + ' state=' + box.runState + ' gateway=200 client=' + version + ' in ' + secs + ' s');
