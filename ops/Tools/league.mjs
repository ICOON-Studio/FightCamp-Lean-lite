// league.mjs - THE AGENTS' LEAGUE at Puncher's chance (S567, owner: "make it a league with the agents and you play also on opus").
// Every seat fights every other once (ops/Tools/versus_by_message.mjs, one bout each: proto/twohands/tools/versus.mjs).
//   node ops/Tools/league.mjs run      plays every pairing still open, up to 3 matches at once, no seat in two matches; then the table
//   node ops/Tools/league.mjs table    writes ops/research/versus/LEAGUE.md from the bouts played so far and prints it
//   node ops/Tools/league.mjs turn <seat>   for a seat that plays by itself (the Claude worker): the bout where it must choose now
// Matches live in E:/FightCamp/tmp/versus/<a>_v_<b>/ (resumable). Win 3 points, draw 1.
import fs from 'node:fs';
import path from 'node:path';
import { spawn } from 'node:child_process';

const ROOT = path.resolve(path.dirname(new URL(import.meta.url).pathname.replace(/^\/([A-Za-z]:)/, '$1')), '..', '..'), DIR = 'E:/FightCamp/tmp/versus';
const SEATS = { kalli: 'grok', john: 'grok', maria: 'grok', dola: 'dola', claude: 'worker', ziva: 'worker' }   /* S567, owner: "count allmatches of antigravity as not done and finish the league" - Antigravity (its tool opened tabs in his browser) is not a seat: its one played bout is not counted */, NAMES = Object.keys(SEATS), Cap = (s) => s[0].toUpperCase() + s.slice(1);
const PAIRS = []; for (let i = 0; i < NAMES.length; i++) for (let j = i + 1; j < NAMES.length; j++) PAIRS.push([NAMES[i], NAMES[j]]);
const dirOf = ([a, b]) => [`${a}_v_${b}`, `${b}_v_${a}`].map((d) => path.join(DIR, d)).find((d) => fs.existsSync(path.join(d, 'bout.json'))) || path.join(DIR, `${a}_v_${b}`);
const bout = (p) => { try { return JSON.parse(fs.readFileSync(path.join(dirOf(p), 'bout.json'), 'utf8')); } catch { return null; } };
const fresh = (p) => { try { return Date.now() - fs.statSync(path.join(dirOf(p), 'driver.log')).mtimeMs < 6 * 60000; } catch { return false; } };
const driverDone = (p) => { try { return /\] DONE /.test(fs.readFileSync(path.join(dirOf(p), 'driver.log'), 'utf8')); } catch { return false; } };

function table() { const T = Object.fromEntries(NAMES.map((n) => [n, { p: 0, w: 0, d: 0, l: 0, kd: 0, pts: 0 }])), rows = [];
  for (const p of PAIRS) { const B = bout(p); if (!B || !B.over) { rows.push(`| ${Cap(p[0])} v ${Cap(p[1])} | ${B ? `being played (round ${B.round}, beat ${B.beat + 1})` : 'to play'} |`); continue; }
    const ids = B.names.map((n) => n.toLowerCase()), win = / WINS/.test(B.over) ? ids.find((n) => B.over.toLowerCase().startsWith(n)) : null;
    for (const k of [0, 1]) { const t = T[ids[k]]; if (!t) continue; t.p++; t.kd += B.F[1 - k].kd || 0; if (!win) { t.d++; t.pts += 1; } else if (win === ids[k]) { t.w++; t.pts += 3; } else t.l++; }
    rows.push(`| ${B.names[0]} v ${B.names[1]} | ${B.over} |`); }
  const order = NAMES.slice().sort((a, b) => T[b].pts - T[a].pts || T[b].w - T[a].w || T[b].kd - T[a].kd);
  const md = `# The agents' league at Puncher's chance (S567)\n\nOwner S567: "make it a league with the agents and you play also on opus". Every seat fights every other once, one bout of\nthree rounds, each beat sealed before the other is seen (ops/Tools/league.mjs). Win 3, draw 1. Claude plays as Opus 5.5 (a console worker); Ziva plays from its own chat in the Godot editor (owner S567: "use ziva too").\n\n| # | seat | played | won | drawn | lost | knockdowns scored | points |\n|---|---|---|---|---|---|---|---|\n${order.map((n, i) => `| ${i + 1} | ${Cap(n)} | ${T[n].p} | ${T[n].w} | ${T[n].d} | ${T[n].l} | ${T[n].kd} | ${T[n].pts} |`).join('\n')}\n\n## Matches\n| match | result |\n|---|---|\n${rows.join('\n')}\n`;
  fs.mkdirSync(path.join(ROOT, 'ops/research/versus'), { recursive: true }); fs.writeFileSync(path.join(ROOT, 'ops/research/versus/LEAGUE.md'), md); return md; }

const [cmd, who] = process.argv.slice(2);
if (cmd === 'table') { console.log(table()); process.exit(0); }
if (cmd === 'turn') { let open = 0;
  for (const p of PAIRS.filter((q) => q.includes(who))) { const B = bout(p); if (!B) { open++; continue; } const k = B.names.map((n) => n.toLowerCase()).indexOf(who), d = dirOf(p).replace(/\\/g, '/');
    if (B.over) { if (!fs.existsSync(path.join(d, `VERSUS_${who.toUpperCase()}.md`))) { console.log(`VERDICT ${d}/bout.json who=${'ab'[k]} -> write ${d}/VERSUS_${who.toUpperCase()}.md (${B.over})`); process.exit(0); } continue; }
    open++; if (!B.sealed[k]) { console.log(`YOUR TURN ${d}/bout.json who=${'ab'[k]}`); process.exit(0); } }
  console.log(open ? 'WAIT' : 'LEAGUE DONE'); process.exit(0); }
if (cmd !== 'run') { console.log('usage: league.mjs run | table | turn <seat>'); process.exit(2); }

const stalled = new Map(), busy = new Set(), live = new Map(), sleep = (ms) => new Promise((r) => setTimeout(r, ms));
for (;;) { const open = PAIRS.filter((p) => !(bout(p) && bout(p).over && driverDone(p)) && (stalled.get(p.join('_v_')) || 0) < 2);
  if (!open.length && !live.size) break;
  /* a match another process is playing takes its two seats FIRST, whatever its place in the list (S567: Maria was sent a second match's opening while her first one ran) */
  open.sort((a, b) => (fresh(b) && bout(b) && bout(b).n > 0 ? 1 : 0) - (fresh(a) && bout(a) && bout(a).n > 0 ? 1 : 0));
  for (const p of open) { const key = p.join('_v_'); if (live.has(key) || live.size >= 3 || p.some((s) => busy.has(s))) continue;
    if (fresh(p) && bout(p) && bout(p).n > 0) { p.forEach((s) => busy.add(s)); live.set(key, null); console.log(`LEAGUE ${key}: already being played elsewhere - watching`);
      const iv = setInterval(() => { if (!fresh(p)) { clearInterval(iv); live.delete(key); p.forEach((s) => busy.delete(s)); } }, 30000); continue; }
    const d = dirOf(p), names = path.basename(d).split('_v_'), seed = 20 + PAIRS.indexOf(p); p.forEach((s) => busy.add(s));
    const c = spawn('node', ['ops/Tools/versus_by_message.mjs', d, `a=${names[0]}:${SEATS[names[0]]}`, `b=${names[1]}:${SEATS[names[1]]}`, `seed=${seed}`, 'pace=25'], { cwd: ROOT, windowsHide: true, stdio: ['ignore', 'pipe', 'pipe'] }); let o = '';
    c.stdout.on('data', (x) => { o += x; }); live.set(key, c); console.log(`LEAGUE ${key}: started`);
    c.on('close', (code) => { live.delete(key); p.forEach((s) => busy.delete(s)); console.log(`LEAGUE ${key}: ${o.trim().split('\n').pop() || 'ended, code ' + code}`); table(); if (code !== 0) stalled.set(key, (stalled.get(key) || 0) + 1); }); }
  await sleep(15000); }
console.log(table()); console.log('LEAGUE DONE');
