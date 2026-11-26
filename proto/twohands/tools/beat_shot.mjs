// BEAT_SHOT (S560): play chosen beats on a page in headless Edge (nothing opens on a monitor) and keep a screenshot and
// the story lines after each. For "is the new rule SHOWN on the page": the words, the numbers, the picture.
//   node proto/twohands/tools/beat_shot.mjs <out_dir> <page.html> '<beats json>' [port]
//   beats: [{ "label": "pull", "range": 2, "mine": { "feet": "back", "lead": "jab", "ord": ["feet", "lead"] }, "his": { "hl": "low" } }, ..]
//   (server: python proto/cardgame/serve.py 8797 twohands)
import fs from 'node:fs';
import path from 'node:path';
import { spawn } from 'node:child_process';
import os from 'node:os';

const out = process.argv[2], page = process.argv[3] || 'order.html', beats = JSON.parse(process.argv[4] || '[]');
const url = `http://127.0.0.1:${process.argv[5] || 8797}/${page}`, tag = page.replace(/\.html$/, '');
const EDGE = 'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe';
fs.mkdirSync(out, { recursive: true });
const port = 9300 + Math.floor(Math.random() * 500), prof = fs.mkdtempSync(path.join(os.tmpdir(), 'beatshot-'));
const edge = spawn(EDGE, ['--headless=new', '--disable-gpu', '--hide-scrollbars', '--mute-audio', `--remote-debugging-port=${port}`, `--user-data-dir=${prof}`, '--window-size=1920,1080', 'about:blank'], { stdio: 'ignore' });
const sleep = (ms) => new Promise((r) => setTimeout(r, ms));
let ws, seq = 0; const wait = {};
async function connect() { for (let i = 0; i < 50; i++) { try { const l = await (await fetch(`http://127.0.0.1:${port}/json/list`)).json(); const pg = l.find((t) => t.type === 'page'); if (pg) return pg.webSocketDebuggerUrl; } catch (e) {} await sleep(200); } throw new Error('no Edge'); }
const send = (method, params = {}) => new Promise((ok, no) => { const id = ++seq; wait[id] = (m) => (m.error ? no(new Error(method + ': ' + m.error.message)) : ok(m.result)); ws.send(JSON.stringify({ id, method, params })); });
const ev = async (expr) => { const r = await send('Runtime.evaluate', { expression: expr, awaitPromise: true, returnByValue: true }); if (r.exceptionDetails) throw new Error(expr.slice(0, 80) + ': ' + JSON.stringify(r.exceptionDetails).slice(0, 400)); return r.result.value; };
const shot = async (name) => { const r = await send('Page.captureScreenshot', { format: 'png', clip: { x: 0, y: 0, width: 1920, height: 1080, scale: 1 } }); fs.writeFileSync(path.join(out, name), Buffer.from(r.data, 'base64')); };
try {
  ws = new WebSocket(await connect());
  await new Promise((ok) => { ws.onopen = ok; });
  ws.onmessage = (e) => { const m = JSON.parse(e.data); if (m.id && wait[m.id]) { wait[m.id](m); delete wait[m.id]; } };
  await send('Emulation.setDeviceMetricsOverride', { width: 1920, height: 1080, deviceScaleFactor: 1, mobile: false });
  await send('Page.navigate', { url }); await sleep(2500);
  await ev("document.getElementById('go').click(), 1"); await sleep(1500);   /* the first button starts the bout */
  for (const b of beats) {
    await ev(`(() => { ${b.range ? `range = ${b.range};` : ''} P = { ...plan0(), hl: P.hl, hr: P.hr, ...${JSON.stringify(b.mine || {})} }; if (!P.ord || !P.ord.length) P.ord = ordOf(P); hisNext = { at: round + ':' + beat, plan: { ...plan0(), ...${JSON.stringify(b.his || {})} } }; plan(); return 1; })()`);
    await sleep(300); await shot(`${tag}_${b.label}_plan.png`);
    await ev("document.getElementById('go').click(), 1");
    for (let i = 0; i < 300; i++) { await sleep(50); if ((await ev('phase')) !== 'play') break; }
    await sleep(800); await shot(`${tag}_${b.label}_after.png`);
    console.log(`BEAT_SHOT ${b.label}: ` + await ev("[...document.querySelectorAll('#story .srow')].map((d) => d.textContent.trim() + (d.title ? ' {tip: ' + d.title + '}' : '')).join(' | ')"));
  }
} catch (e) { console.log('BEAT_SHOT FAIL ' + e.message); process.exitCode = 1; } finally { try { ws && ws.close(); } catch (e) {} edge.kill(); await sleep(400); try { fs.rmSync(prof, { recursive: true, force: true }); } catch (e) {} }
