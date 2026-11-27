// S569 jump recorder: play real beats of order.html in headless Edge (random cards, the page's own opponent) and log
// every picture the stage shows with its on-screen box. Analysed by jump_ana.py.
//   node proto/twohands/tools/jump_rec.mjs <out.json> <bouts> [page] [port]   then
//   python proto/twohands/tools/jump_ana.py <out.json> proto/twohands/img/anim [px]   (page server: serve.py 8797 twohands)
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { spawn } from 'node:child_process';

const out = process.argv[2], bouts = +(process.argv[3] || 2), page = process.argv[4] || 'order.html';
const url = `http://127.0.0.1:${process.argv[5] || 8797}/${page}`;
const EDGE = 'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe';
const port = 9300 + Math.floor(Math.random() * 500), prof = fs.mkdtempSync(path.join(os.tmpdir(), 'jumprec-'));
const edge = spawn(EDGE, ['--headless=new', '--disable-gpu', '--hide-scrollbars', '--mute-audio', `--remote-debugging-port=${port}`, `--user-data-dir=${prof}`, '--window-size=1920,1080', 'about:blank'], { stdio: 'ignore' });
const sleep = (ms) => new Promise((r) => setTimeout(r, ms));
let ws, seq = 0; const wait = {};
async function connect() { for (let i = 0; i < 50; i++) { try { const l = await (await fetch(`http://127.0.0.1:${port}/json/list`)).json(); const pg = l.find((t) => t.type === 'page'); if (pg) return pg.webSocketDebuggerUrl; } catch (e) {} await sleep(200); } throw new Error('no edge'); }
const send = (method, params = {}) => new Promise((ok, no) => { const id = ++seq; wait[id] = (m) => (m.error ? no(new Error(method + ': ' + m.error.message)) : ok(m.result)); ws.send(JSON.stringify({ id, method, params })); });
const ev = async (expr) => { const r = await send('Runtime.evaluate', { expression: expr, awaitPromise: true, returnByValue: true }); if (r.exceptionDetails) throw new Error(expr.slice(0, 80) + ': ' + JSON.stringify(r.exceptionDetails).slice(0, 300)); return r.result.value; };
const log = [];
try {
  ws = new WebSocket(await connect()); await new Promise((ok) => { ws.onopen = ok; });
  ws.onmessage = (e) => { const m = JSON.parse(e.data); if (m.id && wait[m.id]) { wait[m.id](m); delete wait[m.id]; } };
  await send('Emulation.setDeviceMetricsOverride', { width: 1920, height: 1080, deviceScaleFactor: 1, mobile: false });
  for (let bt = 0; bt < bouts; bt++) {
    await send('Page.navigate', { url }); await sleep(2500);
    await ev(`(() => { try { localStorage.setItem('pc_guided', '1'); } catch (e) {} const b = [...document.querySelectorAll('button')].find((x) => /^Fight/.test(x.textContent.trim())); if (b) b.click(); return 1; })()`);
    await sleep(800);
    await ev(`(() => { window.__log = []; const im = document.getElementById('pic');
      new MutationObserver(() => { const r = im.getBoundingClientRect(), f = (im.getAttribute('src') || '').split('/').pop(); const lays = [...document.querySelectorAll('#stage img.lay')].filter((e) => e.style.display !== 'none').map((e) => { const q = e.getBoundingClientRect(); return { f: (e.getAttribute('src') || '').split('/').pop(), l: q.left, w: q.width }; });   /* LAYERS0 (S570): ?layers=1 draws each man as his own picture */
        window.__log.push({ f, l: r.left, w: r.width, beat: round + ':' + beat, ph: phase, ord: (P.ord || []).join(','), feet: P.feet, range, lays }); }).observe(im, { attributes: true, attributeFilter: ['src'] });
      RATE = 3; return 1; })()`);
    for (let b = 0; b < 40; b++) {
      const ph = await ev('phase'); if (ph === 'over') break;
      if (ph !== 'plan') { await sleep(300); continue; }
      await ev(`(() => { const cs = [...document.querySelectorAll('#cards .sw')].filter((x) => !x.disabled); const pick = (g) => { const o = cs.filter((x) => x.dataset.g === g); if (o.length && Math.random() < 0.75) o[Math.floor(Math.random() * o.length)].click(); };
        pick('lead'); pick('rear'); pick('feet'); return 1; })()`);
      await sleep(150);
      await ev("document.getElementById('go').click(), 1");
      for (let i = 0; i < 400; i++) { await sleep(60); if ((await ev('phase')) !== 'play') break; }
      await sleep(400);
    }
    const got = await ev('window.__log'); log.push(...got.map((x) => ({ ...x, bout: bt }))); console.log(`JUMP_REC bout ${bt}: ${got.length} pictures`);
  }
  fs.writeFileSync(out, JSON.stringify(log));
} catch (e) { console.log('JUMP_REC FAIL ' + e.message); process.exitCode = 1; } finally { try { ws && ws.close(); } catch (e) {} edge.kill(); await sleep(400); try { fs.rmSync(prof, { recursive: true, force: true }); } catch (e) {} }
