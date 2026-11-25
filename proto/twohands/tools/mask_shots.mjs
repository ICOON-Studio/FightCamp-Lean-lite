// MASK1 (S559): the 8-part hover check of body.html in headless Edge (nothing opens on a monitor). For Long, Mid and
// Inside: the page put at that range, then the mouse on the middle of each part of each man (found on the part mask the
// page reads), a screenshot each; one more with the lead hand clicked (kept open). Prints what the panel says per part and
// whether the page scrolls at 1920x1080.
//   node proto/twohands/tools/mask_shots.mjs <out_dir> [url]      (the page server: python proto/cardgame/serve.py 8797 twohands)
import fs from 'node:fs';
import path from 'node:path';
import { spawn } from 'node:child_process';
import os from 'node:os';

const out = process.argv[2] || 'ops/previews/s559_mask';
const url = process.argv[3] || 'http://127.0.0.1:8797/body.html';
const EDGE = 'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe';
fs.mkdirSync(out, { recursive: true });
const port = 9300 + Math.floor(Math.random() * 500);
const prof = fs.mkdtempSync(path.join(os.tmpdir(), 'maskshots-'));
const edge = spawn(EDGE, ['--headless=new', '--disable-gpu', '--hide-scrollbars', '--mute-audio', `--remote-debugging-port=${port}`, `--user-data-dir=${prof}`, '--window-size=1920,1080', 'about:blank'], { stdio: 'ignore' });
const sleep = (ms) => new Promise((r) => setTimeout(r, ms));
let ws, seq = 0; const wait = {};
async function connect() { for (let i = 0; i < 50; i++) { try { const l = await (await fetch(`http://127.0.0.1:${port}/json/list`)).json(); const pg = l.find((t) => t.type === 'page'); if (pg) return pg.webSocketDebuggerUrl; } catch (e) {} await sleep(200); } throw new Error('no edge'); }
const send = (method, params = {}) => new Promise((ok, no) => { const id = ++seq; wait[id] = (m) => (m.error ? no(new Error(method + ': ' + m.error.message)) : ok(m.result)); ws.send(JSON.stringify({ id, method, params })); });
const ev = async (expr) => { const r = await send('Runtime.evaluate', { expression: expr, awaitPromise: true, returnByValue: true }); if (r.exceptionDetails) throw new Error(expr.slice(0, 80) + ': ' + JSON.stringify(r.exceptionDetails).slice(0, 300)); return r.result.value; };
const shot = async (name) => { const r = await send('Page.captureScreenshot', { format: 'png' }); fs.writeFileSync(path.join(out, name), Buffer.from(r.data, 'base64')); };
const move = (x, y) => send('Input.dispatchMouseEvent', { type: 'mouseMoved', x, y });
const click = async (x, y) => { await send('Input.dispatchMouseEvent', { type: 'mousePressed', x, y, button: 'left', clickCount: 1 }); await send('Input.dispatchMouseEvent', { type: 'mouseReleased', x, y, button: 'left', clickCount: 1 }); };
// the middle of each part on the mask of the picture on screen, in page pixels (the pixel of the part nearest its centre)
const FIND = `(async () => { const im = $('pic'), f = /img\\/anim\\/([^/?#]+\\.webp)/.exec(im.src); if (!f) return { err: 'no anim picture: ' + im.src };
  let mk = null; for (const n in ANIM) { const r = ANIM[n]; if (r.masks) { const i = r.files.indexOf(f[1]); if (i >= 0) mk = r.masks[i]; } } if (!mk) return { err: 'no mask for ' + f[1] };
  const m = new Image(); await new Promise((ok) => { m.onload = ok; m.src = 'img/anim/' + mk; }); const c = document.createElement('canvas'); c.width = m.naturalWidth; c.height = m.naturalHeight; const x = c.getContext('2d'); x.drawImage(m, 0, 0);
  const d = x.getImageData(0, 0, c.width, c.height).data, W = c.width, H = c.height;
  const P = [[255,0,0,'you:lead'],[0,255,0,'you:rear'],[0,0,255,'you:feet'],[255,255,0,'you:body'],[255,0,255,'him:lead'],[0,255,255,'him:rear'],[255,128,0,'him:feet'],[128,0,255,'him:body']];
  const r = im.getBoundingClientRect(), mir = parseFloat((/matrix\\(([^,]+)/.exec(getComputedStyle(im).transform) || [0, 1])[1]) < 0, res = {};
  for (const p of P) { const px = []; for (let i = 0; i < W * H; i++) if (d[i*4+3] > 128 && d[i*4] === p[0] && d[i*4+1] === p[1] && d[i*4+2] === p[2]) px.push(i);
    if (!px.length) { res[p[3]] = null; continue; } let sx = 0, sy = 0; for (const i of px) { sx += i % W; sy += (i / W) | 0; } sx /= px.length; sy /= px.length;
    let b = px[0], bd = 1e9; for (const i of px) { const dd = (i % W - sx) ** 2 + (((i / W) | 0) - sy) ** 2; if (dd < bd) { bd = dd; b = i; } }
    const u = (b % W + 0.5) / W, v = (((b / W) | 0) + 0.5) / H; res[p[3]] = { x: Math.round(r.left + (mir ? 1 - u : u) * r.width), y: Math.round(r.top + v * r.height), n: px.length }; }
  return { mask: mk, res }; })()`;
const report = [];
try {
  ws = new WebSocket(await connect());
  await new Promise((ok) => { ws.onopen = ok; });
  ws.onmessage = (e) => { const m = JSON.parse(e.data); if (m.id && wait[m.id]) { wait[m.id](m); delete wait[m.id]; } };
  await send('Emulation.setDeviceMetricsOverride', { width: 1920, height: 1080, deviceScaleFactor: 1, mobile: false });
  await send('Page.enable'); await send('Runtime.enable');
  await send('Page.navigate', { url }); await sleep(2500);
  await ev("mute = true; document.getElementById('go').click(); 1"); await sleep(2000);
  const scroll = await ev('[document.documentElement.scrollHeight, document.documentElement.clientHeight, document.documentElement.scrollWidth]');
  report.push(`page height ${scroll[0]} of ${scroll[1]}, width ${scroll[2]}: ${scroll[0] <= scroll[1] && scroll[2] <= 1920 ? 'no scroll' : 'SCROLLS'}`);
  await shot('mask_00_start.png');
  for (const [r, nm] of [[3, 'long'], [2, 'mid'], [1, 'inside']]) {
    await ev(`range = ${r}; heldShown = ''; plan(); 1`); for (let t = 0; t < 60; t++) { await sleep(500); if (await ev("/_6\\.webp$/.test($('pic').src)")) break; } await sleep(600);
    const f = await ev(FIND); if (f.err) { report.push(nm + ': ' + f.err); continue; }
    report.push(`${nm}: mask ${f.mask}`);
    for (const k of Object.keys(f.res)) { const p = f.res[k]; if (!p) { report.push(`  ${k}: NOT ON THE MASK`); continue; }
      await move(p.x, p.y); await sleep(350); const bm = await ev('JSON.stringify(window.bodyMask ? window.bodyMask() : null)');
      const said = await ev("(() => { const s = $('side'); return [s.className, s.querySelector('.hd').innerText.replace(/\\s+/g, ' '), [...s.querySelectorAll('.board .grp')].filter((g) => getComputedStyle(g).display !== 'none').map((g) => [...g.querySelectorAll('.sw')].filter((b) => getComputedStyle(b).display !== 'none').map((b) => b.innerText.replace(/\\s+/g, ' ')).join(' | ')).join(' // '), $('his').style.display === 'block' ? $('his').innerText.replace(/\\s+/g, ' ') : ''] })()");
      report.push(`  ${k} (${p.n} px) at ${p.x},${p.y} [page ${bm}]: panel ${said[0]} - ${said[1]}${said[2] ? ' :: ' + said[2] : ''}${said[3] ? ' :: ' + said[3] : ''}`);
      await shot(`mask_${nm}_${k.replace(':', '_')}.png`); }
    if (r === 3) { const p = f.res['you:lead']; await click(p.x, p.y); await move(5, 5); await sleep(400); await shot('mask_long_lead_pinned.png'); report.push('  lead clicked, mouse away: ' + (await ev("$('side').querySelector('.hd').innerText.replace(/\\s+/g, ' ')"))); await click(p.x, p.y); await move(5, 5); await sleep(200); }
    await move(5, 5); await sleep(200); }
} catch (e) { report.push('ERROR ' + e.message); }
fs.writeFileSync(path.join(out, 'mask_report.txt'), report.join('\n') + '\n');
console.log(report.join('\n'));
try { ws.close(); } catch (e) {}
edge.kill();
await sleep(500);
try { fs.rmSync(prof, { recursive: true, force: true }); } catch (e) {}
