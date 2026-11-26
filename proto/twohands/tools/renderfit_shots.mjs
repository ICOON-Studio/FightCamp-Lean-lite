// RENDERFIT1 (S559): the owner's-camera pictures on a page, in headless Edge (nothing opens on a monitor). Plays fixed
// beats (his plan forced): a blue step in, a red step in, a red back off, a jab landed each way, (kick.html) a low kick
// and a teep, at Long / Mid / Inside. Every picture the page draws is logged with the slide and where each man's OUTER
// edge (his back boot / heel) lands on screen: the man who does not move must stay put across a run and into the next
// hold (a snap = his edge jumps). A screenshot at the end of each beat and on each contact.
//   node proto/twohands/tools/renderfit_shots.mjs <out_dir> <page.html> [port]   (server: python proto/cardgame/serve.py 8797 twohands)
import fs from 'node:fs';
import path from 'node:path';
import { spawn } from 'node:child_process';
import os from 'node:os';

const out = process.argv[2] || 'ops/previews/s559_newcam';
const page = process.argv[3] || 'order.html';
const url = `http://127.0.0.1:${process.argv[4] || 8797}/${page}`;
const tag = page.replace(/\.html$/, '');
const EDGE = 'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe';
fs.mkdirSync(out, { recursive: true });
const port = 9300 + Math.floor(Math.random() * 500);
const prof = fs.mkdtempSync(path.join(os.tmpdir(), 'renderfit-'));
const edge = spawn(EDGE, ['--headless=new', '--disable-gpu', '--hide-scrollbars', '--mute-audio', `--remote-debugging-port=${port}`, `--user-data-dir=${prof}`, '--window-size=1920,1080', 'about:blank'], { stdio: 'ignore' });
const sleep = (ms) => new Promise((r) => setTimeout(r, ms));
let ws, seq = 0; const wait = {};
async function connect() { for (let i = 0; i < 50; i++) { try { const l = await (await fetch(`http://127.0.0.1:${port}/json/list`)).json(); const pg = l.find((t) => t.type === 'page'); if (pg) return pg.webSocketDebuggerUrl; } catch (e) {} await sleep(200); } throw new Error('no Edge'); }
const send = (method, params = {}) => new Promise((ok, no) => { const id = ++seq; wait[id] = (m) => (m.error ? no(new Error(method + ': ' + m.error.message)) : ok(m.result)); ws.send(JSON.stringify({ id, method, params })); });
const ev = async (expr) => { const r = await send('Runtime.evaluate', { expression: expr, awaitPromise: true, returnByValue: true }); if (r.exceptionDetails) throw new Error(expr.slice(0, 80) + ': ' + JSON.stringify(r.exceptionDetails).slice(0, 400)); return r.result.value; };
const shot = async (name) => { const r = await send('Page.captureScreenshot', { format: 'png', clip: { x: 0, y: 0, width: 1920, height: 1080, scale: 1 } }); fs.writeFileSync(path.join(out, name), Buffer.from(r.data, 'base64')); };
// the logger, in the page: each picture's outer edges on screen, measured on the picture itself (alpha), after the slide
const LOGGER = `(() => { if (window.__rf) return 'again'; window.__rf = []; const im = $('pic'), C = {};
  const edges = (img) => { const k = img.src; if (C[k]) return C[k]; const c = document.createElement('canvas'); c.width = img.naturalWidth; c.height = img.naturalHeight; const x = c.getContext('2d'); x.drawImage(img, 0, 0);
    const d = x.getImageData(0, 0, c.width, c.height).data, W = c.width, H = c.height; let lo = W, hi = -1; const y0 = Math.floor(H * 0.6);
    for (let y = y0; y < H; y++) for (let i = 0; i < W; i++) if (d[(y * W + i) * 4 + 3] > 128) { if (i < lo) lo = i; if (i > hi) hi = i; }
    return (C[k] = { lo: lo / W, hi: hi / W }); };   /* below 60% of the height: boots and shins, never a reaching glove */
  const rec = () => { const t = performance.now(), f = (im.getAttribute('src') || '').split('/').pop(); const go = () => { const e = edges(im), r = im.getBoundingClientRect(), mir = /matrix\\(-/.test(getComputedStyle(im).transform);
      const sx = (u) => Math.round(r.left + (mir ? 1 - u : u) * r.width); window.__rf.push({ t: Math.round(t), f, slide: window.ringSlide ? window.ringSlide() : null, red: sx(e.lo), blue: sx(e.hi) }); };
    if (im.complete && im.naturalWidth) go(); else im.addEventListener('load', go, { once: true }); };
  new MutationObserver(rec).observe(im, { attributes: true, attributeFilter: ['src'] }); return 'ok'; })()`;
const report = [];
async function beat(label, mine, his) {
  await ev(`(() => { P = { ...plan0(), hl: P.hl, hr: P.hr, ...${JSON.stringify(mine)} }; P.ord = ordOf(P); hisNext = { at: round + ':' + beat, plan: { ...plan0(), ...${JSON.stringify(his)} } }; window.__rf.length = 0; document.getElementById('burst').className = 'burst'; board(); return 1; })()`);   /* the burst keeps 'go' after it fades: cleared so the contact shot waits for this beat's */
  const r0 = await ev('range');
  /* the contact: a promise in the page that settles the moment the burst starts (fx on the contact picture) */
  await ev("(window.__hit = new Promise((ok) => { const b = document.getElementById('burst'); const o = new MutationObserver(() => { if (/go/.test(b.className)) { o.disconnect(); const st0 = window.setTimeout; window.__thaw = () => { window.setTimeout = st0; for (const a of document.getAnimations()) a.play(); }; window.setTimeout = (f, ms, ...x) => st0(f, (ms || 0) + 4000, ...x); st0(() => { for (const a of document.getAnimations()) a.pause(); ok(1); }, 120); } });   /* frozen on the contact for the shot: the page's timers wait, the burst's animation stops */ o.observe(b, { attributes: true, attributeFilter: ['class'] }); setTimeout(() => { o.disconnect(); ok(0); }, 15000); }), 1)");
  await ev("document.getElementById('go').click(), 1");
  if (await ev('window.__hit')) { await shot(`${tag}_${label}_contact.png`); await ev('(window.__thaw && window.__thaw(), 1)'); }
  for (let i = 0; i < 200; i++) { await sleep(40); if ((await ev('phase')) === 'plan') break; }
  await sleep(700);
  await shot(`${tag}_${label}_after.png`);
  const log = await ev('window.__rf.slice()'), r1 = await ev('range'), story = await ev("[...document.querySelectorAll('#story .srow')].map((d) => d.textContent).join(' | ')");
  // the man who does not move: his edge's largest jump between two pictures in a row
  const moved = /red|he /.test(label) ? 'red' : 'blue', still = /red/.test(label) ? 'blue' : 'red';
  let jump = 0; for (let i = 1; i < log.length; i++) jump = Math.max(jump, Math.abs(log[i][still] - log[i - 1][still]));
  const row = { page: tag, beat: label, range: `${r0} -> ${r1}`, pictures: log.length, still_man: still, still_jump_px: jump, first: log[0], last: log[log.length - 1], story: story.slice(0, 240) };
  report.push(row); console.log(JSON.stringify(row));
  return log;
}
try {
  ws = new WebSocket(await connect());
  await new Promise((ok) => { ws.onopen = ok; });
  ws.onmessage = (e) => { const m = JSON.parse(e.data); if (m.id && wait[m.id]) { wait[m.id](m); delete wait[m.id]; } };
  await send('Emulation.setDeviceMetricsOverride', { width: 1920, height: 1080, deviceScaleFactor: 1, mobile: false });
  await send('Page.enable'); await send('Runtime.enable');
  await send('Page.navigate', { url }); await sleep(3000);
  await ev("(mute = true, document.getElementById('go').click(), 1)"); await sleep(800);
  console.log('logger', await ev(LOGGER));
  // warm every picture so a run never falls back to its still
  for (let i = 0; i < 100 && !(await ev('Object.keys(ANIM).length')); i++) await sleep(100);   /* the table first: warming an empty ANIM left head/body on their stills */
  await ev("warm(Object.keys(ANIM)).then(() => 1)");
  console.log('warm', await ev("JSON.stringify({ runs: Object.keys(ANIM).length, pre: Object.keys(PRE).length, broken: Object.keys(PRE).filter((f) => !PRE[f].naturalWidth).slice(0, 5), step: ready('blue_step_in_r2') })"));
  await shot(`${tag}_0_long_plan.png`);
  const logs = {};
  logs.blue_step_in = await beat('1_blue_step_in', { feet: 'in' }, { hl: 'high', hr: 'high' });
  logs.red_step_in = await beat('2_red_step_in', {}, { feet: 'in', hl: 'high', hr: 'high' });
  logs.red_back_off = await beat('3_red_back_off', {}, { feet: 'back', hl: 'high', hr: 'high' });
  logs.blue_jab = await beat('4_blue_jab_landed', { lead: 'jab' }, { hl: 'low', hr: 'high' });
  logs.red_jab = await beat('5_red_jab_landed', { hl: 'low' }, { lead: 'jab', hl: 'high', hr: 'high' });
  if (tag === 'kick') {
    logs.kick = await beat('6_blue_low_kick', { feet: 'low' }, { hl: 'high', hr: 'high' }).catch((e) => ({ err: String(e) }));
    logs.red_teep = await beat('7_red_teep', {}, { feet: 'teep', hl: 'high', hr: 'high' }).catch((e) => ({ err: String(e) }));
  }
  fs.writeFileSync(path.join(out, `${tag}_log.json`), JSON.stringify({ report, logs }, null, 1));
} catch (e) { console.log('ERROR', e.message); }
finally { try { ws && ws.close(); } catch (e) {} edge.kill(); await sleep(500); try { fs.rmSync(prof, { recursive: true, force: true }); } catch (e) {} }
