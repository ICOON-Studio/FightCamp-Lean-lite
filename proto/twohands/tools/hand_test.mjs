// HAND_TEST (S568): the hand of cards (hand_ui.js) in headless Edge - nothing opens on a monitor.
// At Long: the guard bar, the reaching cards, the folded rest; a click on a card picks it; a REAL mouse drag of a card onto
// strip moment 2 puts it in moment 2; at Inside the hand changes; ?ui=body brings the body view back. Stills to <out>.
//   node proto/twohands/tools/hand_test.mjs [out_dir] [page=order.html]
import fs from 'node:fs'; import path from 'node:path'; import os from 'node:os'; import { spawn } from 'node:child_process';
const out = process.argv[2] || path.join(os.tmpdir(), 'hand_test'), page = process.argv[3] || 'order.html'; fs.mkdirSync(out, { recursive: true });
const EDGE = 'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe', port = 9300 + Math.floor(Math.random() * 500), prof = fs.mkdtempSync(path.join(os.tmpdir(), 'handtest-'));
const edge = spawn(EDGE, ['--headless=new', '--disable-gpu', '--hide-scrollbars', '--mute-audio', `--remote-debugging-port=${port}`, `--user-data-dir=${prof}`, '--window-size=1920,1080', 'about:blank'], { stdio: 'ignore' });
const sleep = (ms) => new Promise((r) => setTimeout(r, ms)); let ws, seq = 0, pass = 0, fail = 0; const wait = {};
const ok = (c, s) => { if (c) pass++; else { fail++; console.log('FAIL ' + s); } };
async function connect() { for (let i = 0; i < 50; i++) { try { const l = await (await fetch(`http://127.0.0.1:${port}/json/list`)).json(); const pg = l.find((t) => t.type === 'page'); if (pg) return pg.webSocketDebuggerUrl; } catch (e) {} await sleep(200); } throw new Error('no Edge'); }
const send = (method, params = {}) => new Promise((res, no) => { const id = ++seq; wait[id] = (m) => (m.error ? no(new Error(method + ': ' + m.error.message)) : res(m.result)); ws.send(JSON.stringify({ id, method, params })); });
const ev = async (expr) => { const r = await send('Runtime.evaluate', { expression: expr, awaitPromise: true, returnByValue: true }); if (r.exceptionDetails) throw new Error(expr.slice(0, 80) + ': ' + JSON.stringify(r.exceptionDetails).slice(0, 300)); return r.result.value; };
const shot = async (name, clip) => { const r = await send('Page.captureScreenshot', { format: 'png', clip: { ...clip, scale: 1 } }); fs.writeFileSync(path.join(out, name), Buffer.from(r.data, 'base64')); };
const mouse = (type, x, y) => send('Input.dispatchMouseEvent', { type, x, y, button: 'left', buttons: type === 'mouseReleased' ? 0 : 1, clickCount: 1, pointerType: 'mouse' });
const centre = (sel) => ev(`(() => { const r = document.querySelector(${JSON.stringify(sel)}).getBoundingClientRect(); return [r.left + r.width / 2, r.top + r.height / 2]; })()`);
const base = `http://127.0.0.1:8797/${page}`;
try {
  ws = new WebSocket(await connect()); await new Promise((r) => { ws.onopen = r; }); ws.onmessage = (e) => { const m = JSON.parse(e.data); if (m.id && wait[m.id]) { wait[m.id](m); delete wait[m.id]; } };
  await send('Emulation.setDeviceMetricsOverride', { width: 1920, height: 1080, deviceScaleFactor: 1, mobile: false });
  await send('Page.navigate', { url: base }); await sleep(2000); await ev("localStorage.setItem('pc_guided','1'), 1");
  await send('Page.navigate', { url: base }); await sleep(2500); await ev("document.getElementById('go').click(), 1"); await sleep(1500);
  let h = await ev('handState()'); ok(h.guard.length === 4, 'guard bar: ' + JSON.stringify(h.guard)); ok(h.cards.includes('lead:jab') && !h.cards.includes('rear:cross'), 'at Long the jab is in the hand, the cross folded: ' + JSON.stringify(h));
  ok(!h.cards.includes('clinch:x'), 'the clinch shows at Long');
  ok(await ev("document.getElementById('side').scrollHeight <= document.getElementById('side').clientHeight + 2"), 'the hand overflows its panel');
  await shot('hand_long.png', { x: 0, y: 230, width: 1920, height: 850 });
  // click a card
  await ev("document.querySelector('#cards .sw[data-g=\"feet\"][data-id=\"in\"]').click(), 1"); await sleep(500);
  ok(await ev("P.feet === 'in'"), 'clicking Step in did not pick it');
  // a real mouse drag of the Jab card onto strip moment 2
  const [x0, y0] = await centre('#cards .sw[data-g="lead"][data-id="jab"]'), [x1, y1] = await centre('#strip .slot:nth-of-type(2)');
  await mouse('mouseMoved', x0, y0); await mouse('mousePressed', x0, y0); for (let i = 1; i <= 12; i++) { await mouse('mouseMoved', x0 + (x1 - x0) * i / 12, y0 + (y1 - y0) * i / 12); await sleep(25); } await mouse('mouseReleased', x1, y1); await sleep(600);
  const ord = await ev('JSON.stringify({ lead: P.lead, ord: P.ord })'); ok(/"lead":"jab"/.test(ord) && /"ord":\["feet","lead"\]/.test(ord), 'the drag did not put the jab in moment 2: ' + ord);
  await shot('hand_drag.png', { x: 0, y: 230, width: 1920, height: 850 });
  ok(await ev("document.getElementById('side').scrollHeight <= document.getElementById('side').clientHeight + 2"), 'the hand overflows its panel at Mid');
  ok(await ev("[...document.querySelectorAll('#cards .sw')].every((b) => b.scrollWidth <= b.clientWidth + 1)"), 'a card is cut at its right edge');
  // Inside: a different hand
  await send('Page.navigate', { url: base }); await sleep(2500); await ev("document.getElementById('go').click(), 1"); await sleep(1200); await ev('range = 1, plan(), 1'); await sleep(500);
  h = await ev('handState()'); ok(h.cards.includes('rear:cross') && h.cards.includes('lead:hook'), 'at Inside the cross and hook are in the hand: ' + JSON.stringify(h.cards));
  ok(await ev("document.getElementById('side').scrollHeight <= document.getElementById('side').clientHeight + 2"), 'the hand overflows its panel at Inside: ' + (await ev("document.getElementById('side').scrollHeight + ' > ' + document.getElementById('side').clientHeight")));
  ok(await ev("new Set([...document.querySelectorAll('#guardbar .sw small')].map((x) => x.textContent)).size === 4"), 'the four guard buttons do not each say what they stop');
  await shot('hand_inside.png', { x: 0, y: 230, width: 400, height: 850 });
  // the body view is still reachable
  await send('Page.navigate', { url: base + '?ui=body' }); await sleep(2500); ok(!(await ev('!!window.handState')), '?ui=body still loads the hand');
} catch (e) { fail++; console.log('FAIL ' + e.message); }
finally { try { ws.close(); } catch (e) {} edge.kill(); }
console.log(fail ? `HAND_TEST ${fail} failed, ${pass} passed` : `HAND_TEST ${pass} passed`); process.exit(fail ? 1 : 0);
