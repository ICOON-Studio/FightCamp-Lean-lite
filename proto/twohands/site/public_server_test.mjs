// PUBLIC_SERVER_TEST (S567): the public server run from a BUILT copy (tools/make_site.py), on a test port.
//   node proto/twohands/site/public_server_test.mjs <built copy folder>
// The codes are read from site/data/tester_codes.json on this PC and never printed.
import { spawn } from 'node:child_process';
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import assert from 'node:assert';

const here = path.dirname(new URL(import.meta.url).pathname.replace(/^\/([A-Za-z]:)/, '$1')), copy = path.resolve(process.argv[2] || ''), PORT = 8793;
assert.ok(fs.existsSync(path.join(copy, 'site', 'public_server.mjs')), 'give the built copy folder');
const codes = JSON.parse(fs.readFileSync(path.join(here, 'data', 'tester_codes.json'), 'utf8')), data = fs.mkdtempSync(path.join(os.tmpdir(), 'public_test_'));
const srv = spawn('node', ['site/public_server.mjs'], { cwd: copy, env: { ...process.env, PORT: String(PORT), GATE_SECRET: 'test-secret', GATE_DATA: data, MATCH_DATA: data, RENDER: '' }, stdio: ['ignore', 'pipe', 'pipe'] });
let errOut = ''; srv.stderr.on('data', (d) => { errOut += d; });
const B = `http://127.0.0.1:${PORT}`, sleep = (ms) => new Promise((r) => setTimeout(r, ms));
const jar = {}, hdr = (who) => (jar[who] ? { cookie: jar[who] } : {}), keep = (who, r) => { const c = r.headers.get('set-cookie'); if (c) jar[who] = c.split(';')[0]; return r; };
const get = (who, p) => fetch(B + p, { headers: hdr(who), redirect: 'manual' }).then((r) => keep(who, r));
const post = (who, p, body, type = 'application/x-www-form-urlencoded') => fetch(B + p, { method: 'POST', headers: { ...hdr(who), 'content-type': type }, body, redirect: 'manual' }).then((r) => keep(who, r));
let passed = 0; const ok = (name) => { passed++; console.log('ok ' + name); };
try {
  for (let i = 0; i < 50; i++) { try { await fetch(B + '/healthz'); break; } catch { await sleep(150); } }
  let r = await get('x', '/order.html'); let t = await r.text(); assert.equal(r.status, 200); assert.match(t, /Type the code you were given/); assert.doesNotMatch(t, /ring_ui\.js/); ok('no code: the sign-in page, nothing of the game');
  for (const p of ['/img/guard.webp', '/version.js', '/vtable.json']) { r = await get('x', p); assert.doesNotMatch(await r.text(), /RS_CHANGES|VT/); assert.notEqual(r.headers.get('content-type'), 'image/webp'); } ok('no code: no picture, no script, no table');
  r = await get('x', '/api/lobby'); assert.equal(r.status, 401); ok('no code: the match calls are refused');
  r = await post('x', '/_signin', 'email=a%40b.co&code=WRONG-CODE-0000'); assert.equal(r.status, 401); assert.equal(jar.x, undefined); ok('a wrong code signs nobody in');
  r = await post('bro', '/_signin', 'email=brother%40example.com&code=' + encodeURIComponent(codes.brother.toLowerCase())); assert.equal(r.status, 303); assert.ok(jar.bro); ok('the right code signs in (lower case and dashes accepted)');
  r = await get('bro', '/order.html'); t = await r.text(); assert.match(t, /before you play/); assert.doesNotMatch(t, /ring_ui\.js/); r = await get('bro', '/img/guard.webp'); assert.equal(r.status, 403); r = await get('bro', '/api/lobby'); assert.equal(r.status, 403); ok('signed in, not agreed: the notice, no game, no match calls');
  const hash = (t.match(/name="hash" value="([^"]+)"/) || [])[1]; r = await post('bro', '/_agree', 'hash=' + hash); assert.equal(r.status, 303);
  r = await get('bro', '/online.html'); t = await r.text(); assert.match(t, /online_ui\.js/); r = await get('bro', '/img/guard.webp'); assert.equal(r.status, 200); assert.equal(r.headers.get('content-type'), 'image/webp'); r = await get('bro', '/vtable.json'); assert.equal(r.status, 200); ok('after agreeing: the game page, pictures and table');
  for (const p of ['/site/testers.json', '/tools/rules.mjs', '/render.yaml', '/package.json', '/site/public_server.mjs']) { r = await get('bro', p); assert.equal(r.status, 404, p); } ok('our server files, the code hashes and the tools are never served');
  r = await get('bro', '/owner/log'); assert.equal(r.status, 403); ok('the log is refused to a tester');
  await post('own', '/_signin', 'email=owner%40example.com&code=' + encodeURIComponent(codes.owner)); t = await (await get('own', '/order.html')).text(); await post('own', '/_agree', 'hash=' + (t.match(/name="hash" value="([^"]+)"/) || [])[1]);
  r = await get('own', '/owner/log'); t = await r.text(); assert.equal(r.status, 200); assert.match(t, /brother@example\.com/); assert.match(t, /online\.html/); ok('the owner reads who signed in, who agreed and which pages were opened');
  const j1 = await (await post('bro', '/api/join', JSON.stringify({ name: 'Brother' }), 'application/json')).json(), j2 = await (await post('own', '/api/join', JSON.stringify({ name: 'Owner' }), 'application/json')).json(); assert.ok(j1.token && j2.token);
  await post('bro', '/api/find', JSON.stringify({ token: j1.token }), 'application/json'); const f = await (await post('own', '/api/find', JSON.stringify({ token: j2.token }), 'application/json')).json(); assert.ok(f.match);
  await post('bro', '/api/plan', JSON.stringify({ token: j1.token, lead: 'jab', rear: 'high', feet: 'in', order: 'feet,lead' }), 'application/json'); const p2 = await (await post('own', '/api/plan', JSON.stringify({ token: j2.token, lead: 'jab', rear: 'high', feet: 'hold' }), 'application/json')).json(); assert.equal(p2.resolved, true); assert.equal(p2.state.him, 'Brother'); ok('two signed-in testers are paired and a beat is played through the same address');
  const bad = Buffer.from(JSON.stringify({ label: 'owner', email: 'x@y.z', agreed: hash, exp: Date.now() + 1e9 })).toString('base64url') + '.' + '0'.repeat(32); r = await fetch(B + '/owner/log', { headers: { cookie: 'pc=' + bad }, redirect: 'manual' }); assert.match(await r.text(), /Type the code you were given/); ok('a forged cookie is not a sign-in');
  console.log(`PUBLIC_SERVER_TEST ${passed} passed`);
} catch (e) { console.log('FAIL ' + (e && e.message)); if (errOut) console.log(errOut.slice(0, 600)); console.log(`PUBLIC_SERVER_TEST ${passed} passed - FAILURES above`); process.exitCode = 1; } finally { srv.kill(); }
