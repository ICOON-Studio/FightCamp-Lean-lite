// MATCH_SERVER_TEST (S567): the match server on a test port, two scripted players, one whole bout.
//   node proto/twohands/site/match_server_test.mjs
import { spawn } from 'node:child_process';
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import assert from 'node:assert';

const here = path.dirname(new URL(import.meta.url).pathname.replace(/^\/([A-Za-z]:)/, '$1')), PORT = 8795, data = fs.mkdtempSync(path.join(os.tmpdir(), 'match_test_'));
const srv = spawn('node', [path.join(here, 'match_server.mjs')], { env: { ...process.env, MATCH_PORT: String(PORT), MATCH_DATA: data }, stdio: ['ignore', 'pipe', 'pipe'] });
const B = `http://127.0.0.1:${PORT}`, sleep = (ms) => new Promise((r) => setTimeout(r, ms));
const post = async (p, o) => (await fetch(B + p, { method: 'POST', headers: { 'content-type': 'application/json' }, body: JSON.stringify(o) })).json(), get = async (p) => (await fetch(B + p)).json();
let passed = 0; const ok = (name) => { passed++; console.log('ok ' + name); };
try {
  for (let i = 0; i < 40; i++) { try { await fetch(B + '/api/lobby'); break; } catch { await sleep(150); } }
  const help = await (await fetch(B + '/api/help')).text(); assert.match(help, /POST \/api\/join/); assert.match(help, /Overhand/); ok('help has the calls and the moves');
  const a = await post('/api/join', { name: 'Ann' }), b = await post('/api/join', { name: 'Bob' }); assert.ok(a.token && b.token); assert.equal((await post('/api/join', { name: 'ann' })).error.includes('in use'), true); ok('join gives a token; a name in use is refused');
  assert.equal((await post('/api/find', { token: a.token })).waiting, true); const f = await post('/api/find', { token: b.token }); assert.ok(f.match); assert.equal((await post('/api/find', { token: a.token })).match, f.match); ok('two players are paired');
  let s = await get(`/api/state?token=${a.token}`); assert.equal(s.yourTurn, true); assert.equal(s.him, 'Bob'); assert.equal(s.rangeName, 'Long'); assert.equal(s.lastBeat, null);
  const bad = await post('/api/plan', { token: a.token, lead: 'cross', rear: 'high' }); assert.equal(bad.ok, false); assert.match(bad.error, /not a lead-hand move/); ok('a refused plan says why and costs nothing');
  const p1 = await post('/api/plan', { token: a.token, lead: 'jab', rear: 'high', feet: 'in', order: 'feet,lead' }); assert.equal(p1.ok, true); assert.equal(p1.resolved, false);
  s = await get(`/api/state?token=${b.token}`); assert.equal(s.heSealed, true); assert.equal(s.lastBeat, null); assert.equal(JSON.stringify(s).includes('Step in'), false); ok('a sealed beat is not shown to the other player');
  const p2 = await post('/api/plan', { token: b.token, lead: 'Body jab', rear: 'bodycross', feet: 'hold' }); assert.equal(p2.resolved, true); assert.equal(p2.state.n, 1); assert.ok(p2.state.lastBeat.lines.length >= 3); assert.equal(p2.state.lastBeat.hisPlan.feet, 'in'); ok('both sealed: the beat is played and both plans are shown');
  let guard = 0;
  for (;;) { s = await get(`/api/state?token=${a.token}`); if (s.over) break; if (++guard >= 60) { console.log('STUCK ' + JSON.stringify({ n: s.n, round: s.round, beat: s.beat, yourTurn: s.yourTurn, heSealed: s.heSealed, me: s.me, he: s.he })); assert.fail('the bout ends'); }
    const pa = await post('/api/plan', { token: a.token, lead: guard % 2 ? 'jab' : 'high', rear: 'high', feet: guard % 3 ? 'hold' : 'in' }); if (!pa.ok) await post('/api/plan', { token: a.token, lead: 'high', rear: 'high', feet: 'hold' });
    const pb = await post('/api/plan', { token: b.token, lead: 'jab', rear: guard % 2 ? 'cross' : 'high', feet: 'hold' }); if (!pb.ok) { const pc = await post('/api/plan', { token: b.token, lead: 'high', rear: 'high', feet: 'hold' }); if (!pc.ok && guard > 50) console.log('B refused twice: ' + pb.error + ' / ' + pc.error); } if (!pa.ok && guard > 50) console.log('A refused: ' + pa.error); }
  assert.match(s.over, /WINS|DRAW/); const sb = await get(`/api/state?token=${b.token}&match=${f.match}`); assert.equal(sb.over, s.over); ok('a whole bout is played to a result: ' + s.over);
  const lob = await get('/api/lobby'); assert.equal(lob.table.length, 2); assert.equal(lob.table.reduce((n, t) => n + t.played, 0), 2); assert.ok(fs.readFileSync(path.join(data, 'matches.jsonl'), 'utf8').includes('Ann')); ok('the result is on file and in the table');
  console.log(`MATCH_SERVER_TEST ${passed} passed`);
} catch (e) { console.log('FAIL ' + (e && e.message)); console.log(`MATCH_SERVER_TEST ${passed} passed - FAILURES above`); process.exitCode = 1; } finally { srv.kill(); }
