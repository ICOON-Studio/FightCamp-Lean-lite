// ONLINE_CLOCK_TEST (S568): a person on online.html?clock=5 against the local model (match_llm_bot.mjs), on a THROWAWAY
// match server - the person does nothing; the beat clock must seal each beat for him, the local model must answer
// inside the limit, the round clock must stay off (the server runs the rounds). Headless Edge: nothing opens on a monitor.
//   node proto/twohands/tools/online_clock_test.mjs [out_dir] [beats=4]
// Starts its own match server on 8793 (BEAT_LIMIT_S=8) and its own local-model player; stops both at the end.
import fs from 'node:fs';
import path from 'node:path';
import os from 'node:os';
import { spawn } from 'node:child_process';

const out = process.argv[2] || path.join(os.tmpdir(), 'online_clock_test'), BEATS = Number((process.argv.find((a) => a.startsWith('beats=')) || 'beats=4').slice(6));
fs.mkdirSync(out, { recursive: true });
const ROOT = path.resolve(path.dirname(new URL(import.meta.url).pathname.replace(/^\/([A-Za-z]:)/, '$1')), '..', '..', '..');
const sleep = (ms) => new Promise((r) => setTimeout(r, ms)); let pass = 0, fail = 0; const ok = (c, s) => { if (c) pass++; else { fail++; console.log('FAIL ' + s); } };
const kids = [];
const srv = spawn('node', ['proto/twohands/site/match_server.mjs'], { cwd: ROOT, env: { ...process.env, MATCH_PORT: '8793', MATCH_DATA: path.join(out, 'data'), BEAT_LIMIT_S: '8' }, stdio: 'ignore', windowsHide: true }); kids.push(srv);
await sleep(1500);
let botLog = ''; const bot = spawn('node', ['proto/twohands/site/match_llm_bot.mjs', 'server=http://127.0.0.1:8793', 'bouts=1'], { cwd: ROOT, windowsHide: true }); kids.push(bot); bot.stdout.on('data', (d) => { botLog += d; });
for (const t0 = Date.now(); !/waiting for an opponent/.test(botLog) && Date.now() - t0 < 90000;) await sleep(500);
ok(/waiting for an opponent/.test(botLog), 'the local model never reached the queue: ' + botLog.slice(-200));
const EDGE = 'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe', port = 9300 + Math.floor(Math.random() * 500), prof = fs.mkdtempSync(path.join(os.tmpdir(), 'onclock-'));
const edge = spawn(EDGE, ['--headless=new', '--disable-gpu', '--hide-scrollbars', '--mute-audio', `--remote-debugging-port=${port}`, `--user-data-dir=${prof}`, '--window-size=1920,1080', 'about:blank'], { stdio: 'ignore' }); kids.push(edge);
let ws, seq = 0; const wait = {};
async function connect() { for (let i = 0; i < 50; i++) { try { const l = await (await fetch(`http://127.0.0.1:${port}/json/list`)).json(); const pg = l.find((t) => t.type === 'page'); if (pg) return pg.webSocketDebuggerUrl; } catch (e) {} await sleep(200); } throw new Error('no Edge'); }
const send = (method, params = {}) => new Promise((res, no) => { const id = ++seq; wait[id] = (m) => (m.error ? no(new Error(method + ': ' + m.error.message)) : res(m.result)); ws.send(JSON.stringify({ id, method, params })); });
const ev = async (expr) => { const r = await send('Runtime.evaluate', { expression: expr, awaitPromise: true, returnByValue: true }); if (r.exceptionDetails) throw new Error(expr.slice(0, 80) + ': ' + JSON.stringify(r.exceptionDetails).slice(0, 300)); return r.result.value; };
try {
  ws = new WebSocket(await connect()); await new Promise((r) => { ws.onopen = r; }); ws.onmessage = (e) => { const m = JSON.parse(e.data); if (m.id && wait[m.id]) { wait[m.id](m); delete wait[m.id]; } };
  await send('Emulation.setDeviceMetricsOverride', { width: 1920, height: 1080, deviceScaleFactor: 1, mobile: false });
  await send('Page.navigate', { url: 'http://127.0.0.1:8797/online.html?clock=5&server=http://127.0.0.1:8793' }); await sleep(2500);
  await ev("localStorage.setItem('pc_guided', '1'), localStorage.setItem('pc_clock', 'on'), 1"); await send('Page.navigate', { url: 'http://127.0.0.1:8797/online.html?clock=5&server=http://127.0.0.1:8793' }); await sleep(2500);
  await ev("document.getElementById('onname').value = 'ClockTester', document.getElementById('onfind').click(), 1");
  let st = null; for (const t0 = Date.now(); Date.now() - t0 < 30000; await sleep(500)) { st = await (await fetch('http://127.0.0.1:8793/api/lobby')).json(); if (st.bouts.length) break; }
  ok(st && st.bouts.length === 1, 'no bout started: ' + JSON.stringify(st));
  const cs = await ev('window.clockState ? clockState() : null'); ok(cs && cs.roundSecs === 0, 'the round clock runs on the online page: ' + JSON.stringify(cs));
  await sleep(1500); const shot = await send('Page.captureScreenshot', { format: 'png' }); fs.writeFileSync(path.join(out, 'online_clock.png'), Buffer.from(shot.data, 'base64'));
  const t0 = Date.now(); let b = null; for (; Date.now() - t0 < BEATS * 15000; await sleep(1000)) { b = (await (await fetch('http://127.0.0.1:8793/api/lobby')).json()).bouts[0]; if (b && b.beat > BEATS) break; }
  const secs = (Date.now() - t0) / 1000; ok(b && b.beat > BEATS, `the clock did not carry ${BEATS} beats in ${secs.toFixed(0)} s: ${JSON.stringify(b)}`);
  console.log(`ONLINE_CLOCK_TEST ${BEATS} beats played with nobody clicking in ${secs.toFixed(0)} s (${(secs / BEATS).toFixed(1)} s a beat: 5 s clock + the pictures)`);
} catch (e) { fail++; console.log('FAIL ' + e.message); }
finally { try { ws.close(); } catch (e) {} for (const k of kids) try { k.kill(); } catch (e) {} }
console.log(fail ? `ONLINE_CLOCK_TEST ${fail} failed, ${pass} passed` : `ONLINE_CLOCK_TEST ${pass} passed`); process.exit(fail ? 1 : 0);
