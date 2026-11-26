// BEAT_SHOT (S560): play chosen beats on a page in headless Edge (nothing opens on a monitor) and keep a screenshot and
// the story lines after each. For "is the new rule SHOWN on the page": the words, the numbers, the picture.
//   node proto/twohands/tools/beat_shot.mjs <out_dir> <page.html> '<beats json>' [port]
//   beats: [{ "label": "pull", "range": 2, ["hp": [yours, his],] "mine": { "feet": "back", "lead": "jab", "ord": ["feet", "lead"] }, "his": { "hl": "low" } }, ..]
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
    await ev(`(() => { ${b.range ? `range = ${b.range};` : ''} ${b.hp ? `F[0].hp = ${b.hp[0]}; F[1].hp = ${b.hp[1]};` : ''} P = { ...plan0(), hl: P.hl, hr: P.hr, ...${JSON.stringify(b.mine || {})} }; if (!P.ord || !P.ord.length) P.ord = ordOf(P); hisNext = { at: round + ':' + beat, plan: { ...plan0(), ...${JSON.stringify(b.his || {})} } }; plan(); return 1; })()`);
    await sleep(300); await shot(`${tag}_${b.label}_plan.png`);
    /* S567: "part": "0:rear" (yours) or "1:lead" (his) = open that part's panel as a click on the boxer does, one more shot (<label>_part.png), the panel's lines printed. Parts: lead, rear, feet, clinch, head */
    if (b.part) { const got = await ev(`(() => { const [w, p] = ${JSON.stringify(b.part)}.split(':'), hd = () => document.querySelector('.side .hd').innerText.split('\\n')[0].toLowerCase(), want = { lead: 'lead hand', rear: 'rear hand', feet: 'feet', clinch: 'body', head: 'head' }[p];
        if (w === '0') { const q = document.querySelector('#sum button[data-k="0:' + p + '"]'); if (q) q.click(); return hd(); }
        const st = document.getElementById('glow').parentElement, r = st.querySelector('img').getBoundingClientRect(), click = (x, y) => st.dispatchEvent(new MouseEvent('click', { clientX: x, clientY: y, bubbles: true }));
        for (let v = 0.05; v < 0.95; v += 0.02) for (let u = 0.3; u < 0.95; u += 0.01) { const x = r.left + u * r.width, y = r.top + v * r.height, was = hd(); click(x, y); const now = hd(); if (now === 'his ' + want) return now; if (now !== was && now.startsWith('his ')) click(x, y); else if (now !== was) click(x, y); }
        return 'NOT FOUND'; })()`);
      await sleep(400); await shot(`${tag}_${b.label}_part.png`); console.log(`BEAT_SHOT ${b.label} part ${b.part}: ${got} :: ` + await ev("[...document.querySelectorAll('#his .row, #board .sw')].filter((e) => e.offsetParent).map((e) => e.innerText.replace(/\\n/g, ' ')).join(' | ')")); }
    /* S567: "js": an expression run on the page after the plan shot (a click on a button, a state read), its value printed; the "hold" shots follow it */
    if (b.js) console.log(`BEAT_SHOT ${b.label} js: ` + JSON.stringify(await ev(b.js)));
    /* S566 STRIP1: "hold": [ms, ..] = more plan shots after those waits (the preview of the chosen moves plays while he plans), the strip's state printed; "plan_only": the beat is not fought */
    for (const [j, ms] of (b.hold || []).entries()) { await sleep(ms); await shot(`${tag}_${b.label}_plan${j + 2}.png`); console.log(`BEAT_SHOT ${b.label} strip ${j + 2}: ` + JSON.stringify(await ev("window.stripState ? stripState() : null"))); }
    /* S566: "drag": [from, to] = a real mouse drag of the strip's card in slot `from` onto slot `to` (0-based), the order printed before and after */
    if (b.drag) { const mid = async (i) => ev(`(() => { const r = document.querySelectorAll('#strip .slot')[${i}].getBoundingClientRect(); return [r.left + r.width / 2, r.top + r.height / 2]; })()`);
      const [x0, y0] = await mid(b.drag[0]), [x1, y1] = await mid(b.drag[1]), before = await ev('P.ord.join(",")'), m = (type, x, y, buttons) => send('Input.dispatchMouseEvent', { type, x, y, button: 'left', buttons, clickCount: 1 });
      await m('mouseMoved', x0, y0, 0); await m('mousePressed', x0, y0, 1); for (let k = 1; k <= 8; k++) { await m('mouseMoved', x0 + (x1 - x0) * k / 8 + (x1 > x0 ? 30 : -30) * (k === 8), y0, 1); await sleep(30); } await shot(`${tag}_${b.label}_drag.png`); await m('mouseReleased', x1 + (x1 > x0 ? 30 : -30), y1, 0); await sleep(300);
      console.log(`BEAT_SHOT ${b.label} drag slot ${b.drag[0] + 1} -> ${b.drag[1] + 1}: ${before} => ` + await ev('P.ord.join(",")')); await shot(`${tag}_${b.label}_dragged.png`); }
    if (b.plan_only) continue;
    await ev("document.getElementById('go').click(), 1");
    const seen = [];   /* S561: the runs the beat played (the picture's file name without its frame number), for 'is the new run SHOWN' */
    for (let i = 0; i < 300; i++) { await sleep(50); const r = (await ev("(document.getElementById('pic').getAttribute('src') || '').split('/').pop().replace(/_\d+\.\w+$/, '')")); if (r && seen[seen.length - 1] !== r) seen.push(r); if ((await ev('phase')) !== 'play') break; }
    console.log(`BEAT_SHOT ${b.label} pictures: ` + seen.join(' > '));
    await sleep(800); await shot(`${tag}_${b.label}_after.png`);
    console.log(`BEAT_SHOT ${b.label}: ` + await ev("[...document.querySelectorAll('#story .srow')].map((d) => d.textContent.trim() + (d.title ? ' {tip: ' + d.title + '}' : '')).join(' | ')"));
  }
} catch (e) { console.log('BEAT_SHOT FAIL ' + e.message); process.exitCode = 1; } finally { try { ws && ws.close(); } catch (e) {} edge.kill(); await sleep(400); try { fs.rmSync(prof, { recursive: true, force: true }); } catch (e) {} }
