// GATE TEST (S565): the test-link gate never serves the game to a stranger, shows the notice once, keeps both lists.
//   node proto/twohands/site/server_test.mjs
import { spawn } from 'node:child_process';
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import assert from 'node:assert/strict';
import { fileURLToPath } from 'node:url';

const here = path.dirname(fileURLToPath(import.meta.url)), data = fs.mkdtempSync(path.join(os.tmpdir(), 'gate-')), PORT = 18798 + Math.floor(Math.random() * 500);
const srv = spawn(process.execPath, [path.join(here, 'server.js')], { env: { ...process.env, PORT: String(PORT), GATE_DATA: data, OWNER_LOGIN: 'Owner@Example.test' }, stdio: ['ignore', 'pipe', 'inherit'] });
await new Promise((ok, bad) => { srv.stdout.on('data', (d) => /GATE up/.test(String(d)) && ok()); srv.on('exit', () => bad(new Error('the gate did not start'))); setTimeout(() => bad(new Error('timeout')), 8000); });
const get = (p, who, o = {}) => fetch(`http://127.0.0.1:${PORT}${p}`, { redirect: 'manual', ...o, headers: { ...(who ? { 'Tailscale-User-Login': who, 'Tailscale-User-Name': 'Test ' + who } : {}), ...(o.headers || {}) } });
const lines = (f) => { try { return fs.readFileSync(path.join(data, f), 'utf8').split('\n').filter(Boolean).map((l) => JSON.parse(l)); } catch (e) { return []; } };
let n = 0; const t = async (name, f) => { await f(); n++; console.log('ok ' + name); };
try {
  await t('a stranger (no Tailscale login) gets nothing: not a page, not a picture', async () => {
    for (const p of ['/', '/order.html', '/version.js', '/owner/log']) assert.equal((await get(p, null)).status, 403, p); });
  await t('a signed-in tester sees the notice first, and no game file before he agrees', async () => {
    const r = await get('/order.html', 'brother@example.test'), html = await r.text();
    assert.equal(r.status, 200); assert.match(html, /before you play/); assert.match(html, /I agree/); assert.match(html, /brother@example\.test/); assert.doesNotMatch(html, /id="mute"/);
    assert.equal((await get('/version.js', 'brother@example.test')).status, 403); assert.equal(lines('visits.jsonl').length, 0); });
  await t('agreeing is kept once, with the notice version and the hash of its words', async () => {
    const hash = (await (await get('/order.html', 'brother@example.test')).text()).match(/name="hash" value="([0-9a-f]+)"/)[1];
    const bad = await get('/_agree', 'brother@example.test', { method: 'POST', body: 'hash=wrong', headers: { 'Content-Type': 'application/x-www-form-urlencoded' } });
    assert.equal(bad.status, 303); assert.equal(lines('agreed.jsonl').length, 0, 'a wrong hash agrees to nothing');
    for (let i = 0; i < 2; i++) assert.equal((await get('/_agree', 'brother@example.test', { method: 'POST', body: 'hash=' + hash, headers: { 'Content-Type': 'application/x-www-form-urlencoded' } })).status, 303);
    const a = lines('agreed.jsonl'); assert.equal(a.length, 1); assert.equal(a[0].login, 'brother@example.test'); assert.equal(a[0].hash, hash); assert.ok(a[0].version && a[0].time); });
  await t('after that he gets the game, and each page he opens is in the log with the game version', async () => {
    const r = await get('/order.html', 'Brother@Example.test'), html = await r.text();
    assert.equal(r.status, 200); assert.match(html, /id="mute"/); assert.match(html, /Puncher's chance/);
    assert.equal((await get('/version.js', 'brother@example.test')).status, 200); assert.equal((await get('/changelog.html', 'brother@example.test')).status, 200);
    const v = lines('visits.jsonl'); assert.deepEqual(v.map((x) => x.page), ['order.html', 'changelog.html']); assert.match(v[0].version, /^0\.\d+\.\d+$/); assert.equal(v[0].login, 'brother@example.test'); });
  await t('our tools, this gate, the lists and anything outside the pages folder are never served', async () => {
    for (const p of ['/tools/balance.mjs', '/tools/make_wait.py', '/site/server.js', '/site/notice.txt', '/site/data/visits.jsonl', '/switch.html', '/index.html', '/..%2f..%2fCLAUDE.md', '/%2e%2e/%2e%2e/CLAUDE.md', '/nothing.html'])
      assert.equal((await get(p, 'brother@example.test')).status, 404, p); });
  await t('another tester has to agree for himself', async () => { assert.match(await (await get('/order.html', 'friend@example.test')).text(), /before you play/); });
  await t('the list of who played is for the owner only', async () => {
    assert.equal((await get('/owner/log', 'brother@example.test')).status, 403);
    assert.match(await (await get('/order.html', 'owner@example.test')).text(), /id="mute"/, 'the owner plays without signing his own notice');
    const html = await (await get('/owner/log', 'owner@example.test')).text(); assert.match(html, /who played/); assert.match(html, /brother@example\.test/); assert.match(html, /changelog\.html/);
    const csv = await (await get('/owner/log?csv=visits', 'owner@example.test')).text(); assert.match(csv.split('\n')[0], /time,login,page,version/); assert.equal(csv.trim().split('\n').length, 4);   /* the head line, the tester's two pages, the owner's one */ });
  console.log(`GATE_TEST ${n} passed`);
} finally { srv.kill(); fs.rmSync(data, { recursive: true, force: true }); }
