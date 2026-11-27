// CLOCK_TEST (S568): the decision clock on one.html, in headless Edge (nothing opens on a monitor).
// The guided first beat is not timed; once guided, a beat left alone is fought by itself when the clock runs out;
// switching the clock off stops that. Prints CLOCK_TEST <n> passed or FAIL lines; a screenshot of the running clock.
//   node proto/twohands/tools/clock_test.mjs [out_dir] [page=one.html] [port=8797]
import fs from 'node:fs';
import path from 'node:path';
import { spawn } from 'node:child_process';
import os from 'node:os';

const out = process.argv[2] || path.join(os.tmpdir(), 'clock_test'), page = process.argv[3] || 'one.html', base = `http://127.0.0.1:${process.argv[4] || 8797}/`;
const EDGE = 'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe';
fs.mkdirSync(out, { recursive: true });
const port = 9300 + Math.floor(Math.random() * 500), prof = fs.mkdtempSync(path.join(os.tmpdir(), 'clocktest-'));
const edge = spawn(EDGE, ['--headless=new', '--disable-gpu', '--hide-scrollbars', '--mute-audio', `--remote-debugging-port=${port}`, `--user-data-dir=${prof}`, '--window-size=1920,1080', 'about:blank'], { stdio: 'ignore' });
const sleep = (ms) => new Promise((r) => setTimeout(r, ms));
let ws, seq = 0, pass = 0, fail = 0; const wait = {};
const ok = (c, s) => { if (c) pass++; else { fail++; console.log('FAIL ' + s); } };
async function connect() { for (let i = 0; i < 50; i++) { try { const l = await (await fetch(`http://127.0.0.1:${port}/json/list`)).json(); const pg = l.find((t) => t.type === 'page'); if (pg) return pg.webSocketDebuggerUrl; } catch (e) {} await sleep(200); } throw new Error('no Edge'); }
const send = (method, params = {}) => new Promise((res, no) => { const id = ++seq; wait[id] = (m) => (m.error ? no(new Error(method + ': ' + m.error.message)) : res(m.result)); ws.send(JSON.stringify({ id, method, params })); });
const ev = async (expr) => { const r = await send('Runtime.evaluate', { expression: expr, awaitPromise: true, returnByValue: true }); if (r.exceptionDetails) throw new Error(expr.slice(0, 80) + ': ' + JSON.stringify(r.exceptionDetails).slice(0, 400)); return r.result.value; };
const shot = async (name) => { const r = await send('Page.captureScreenshot', { format: 'png', clip: { x: 0, y: 0, width: 1920, height: 1080, scale: 1 } }); fs.writeFileSync(path.join(out, name), Buffer.from(r.data, 'base64')); };
const at = () => ev('JSON.stringify({ phase, round, beat })').then(JSON.parse);
const untilPlan = async (ms) => { for (const t0 = Date.now(); Date.now() - t0 < ms; await sleep(250)) if ((await at()).phase === 'plan') return true; return false; };
try {
  ws = new WebSocket(await connect()); await new Promise((r) => { ws.onopen = r; });
  ws.onmessage = (e) => { const m = JSON.parse(e.data); if (m.id && wait[m.id]) { wait[m.id](m); delete wait[m.id]; } };
  await send('Emulation.setDeviceMetricsOverride', { width: 1920, height: 1080, deviceScaleFactor: 1, mobile: false });
  // 1. a new player: the guided first beat is NOT timed
  await send('Page.navigate', { url: base + page }); await sleep(2500);
  ok(await ev("!!document.getElementById('clockbtn')"), 'no Clock button in the top bar');
  await ev("document.getElementById('go').click(), 1"); await sleep(1500);
  let s = await ev('window.clockState ? clockState() : null'); ok(s && s.secs > 0, 'clock_ui.js not loaded: ' + JSON.stringify(s));
  ok(s && !s.armed, 'the guided first beat is timed: ' + JSON.stringify(s));
  // 2. a player who has been guided: the clock runs and fights the beat by itself
  await ev("localStorage.setItem('pc_guided', '1'), 1"); await send('Page.navigate', { url: base + page }); await sleep(2500);
  await ev("document.getElementById('go').click(), 1"); await sleep(1200);
  s = await ev('clockState()'); ok(s.armed && s.left > 0 && s.left < s.secs, 'the clock is not running: ' + JSON.stringify(s));
  ok(/· \d/.test(await ev("document.getElementById('go').textContent")), 'the Fight button shows no count');
  await shot(page.replace(/\.html$/, '') + '_clock.png');
  const b0 = await at(); await sleep(s.secs * 1000 + 800); const b1 = await at();
  ok(b1.phase !== 'plan' || b1.beat !== b0.beat || b1.round !== b0.round, 'the beat was not fought at 0: ' + JSON.stringify([b0, b1]));
  ok(await untilPlan(30000), 'never came back to planning');
  s = await ev('clockState()'); ok(s.armed, 'the clock did not restart on the next beat: ' + JSON.stringify(s));
  // 3. the Clock button switches it off: nothing is fought alone
  await ev("document.getElementById('clockbtn').click(), 1"); await sleep(300); s = await ev('clockState()'); ok(!s.on && !s.armed, 'switched off but still armed: ' + JSON.stringify(s));
  const c0 = await at(); await sleep((s.secs + 1.5) * 1000); const c1 = await at(); ok(c1.phase === 'plan' && c1.beat === c0.beat, 'fought with the clock off: ' + JSON.stringify([c0, c1]));
  // 4. the ROUND clock (S568, owner: "a real timer like 1 minute for the round"): ?round=8, no beat clock - left alone
  //    while choosing, the bell rings at 0 and round 2 starts
  await ev("localStorage.setItem('pc_clock', 'on'), 1"); await send('Page.navigate', { url: base + page + '?clock=0&round=8' }); await sleep(2500);
  await ev("document.getElementById('go').click(), 1"); await sleep(1000);
  const rc = await ev("(document.getElementById('rclock') || {}).textContent || ''"); ok(/^0:0[5-8]$/.test(rc), 'the round clock is not in the top bar: ' + JSON.stringify(rc));
  await sleep(9000); let r1 = await at(); ok(r1.round === 2 && r1.beat === 0, 'the bell did not ring at 0 while choosing: ' + JSON.stringify(r1));
  await shot(page.replace(/\.html$/, '') + '_roundclock.png');
  // 5. both clocks, ?round=6: the 5 s beat clock fights beat 1, the round runs out while it plays - the bell comes AFTER it
  await send('Page.navigate', { url: base + page + '?round=6' }); await sleep(2500); await ev("document.getElementById('go').click(), 1");
  let sawPlay = false; for (const t0 = Date.now(); Date.now() - t0 < 25000; await sleep(250)) { const x = await at(); if (x.phase === 'play') sawPlay = true; if (x.round === 2) break; }
  r1 = await at(); ok(sawPlay && r1.round === 2, 'the round clock did not ring after a playing beat: ' + JSON.stringify(r1) + ' ' + JSON.stringify(await ev('clockState()')) + ' rclock=' + (await ev("(document.getElementById('rclock') || {}).textContent")));
  // 6. order.html without ?clock stays untimed
  await send('Page.navigate', { url: base + 'order.html' }); await sleep(2500); ok(!(await ev("!!document.getElementById('clockbtn')")), 'order.html has a clock without ?clock=');
} catch (e) { fail++; console.log('FAIL ' + e.message); }
finally { try { ws.close(); } catch (e) {} edge.kill(); }
console.log(fail ? `CLOCK_TEST ${fail} failed, ${pass} passed` : `CLOCK_TEST ${pass} passed`); process.exit(fail ? 1 : 0);
