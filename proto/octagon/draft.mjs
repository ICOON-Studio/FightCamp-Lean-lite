// OCTAGON v4 DRAFT (S570): a snake draft of the middleweight pool (docs/OCTAGON_ATTRIBUTES_SPEC.md). Owner S570: "everyone
// drifts his favorite fighter and compete in the cup". Grok seats (john, kalli, maria) are asked through
// ops/Tools/grokbot_direct.mjs; the Claude seat writes <dir>/claude_pick.txt (one line: the fighter id).
//   node proto/octagon/draft.mjs <dir> seats=claude,john,kalli,maria [seed=5]
// Resumable (<dir>/draft.json). Ends with DRAFT DONE and the picks (first pick = the fighter he fights with).
import fs from 'node:fs';
import path from 'node:path';
import { spawn } from 'node:child_process';
import { useV4, POOL, poolText } from './fighters_v4.mjs';
useV4();
const [dirArg, ...rest] = process.argv.slice(2), arg = Object.fromEntries(rest.map((x) => x.split('='))), DIR = path.resolve(dirArg);
fs.mkdirSync(DIR, { recursive: true });
const ROOT = path.resolve(path.dirname(new URL(import.meta.url).pathname.replace(/^\/([A-Za-z]:)/, '$1')), '..', '..');
const STATE = path.join(DIR, 'draft.json'), LOG = path.join(DIR, 'draft.log'), log = (s) => { fs.appendFileSync(LOG, `[${new Date().toISOString().slice(11, 19)}] ${s}\n`); console.log(s); };
const sleep = (ms) => new Promise((r) => setTimeout(r, ms));
const run = (cmd, args) => new Promise((ok) => { const p = spawn(cmd, args, { cwd: ROOT, windowsHide: true }); let o = '', e = ''; p.stdout.on('data', (d) => { o += d; }); p.stderr.on('data', (d) => { e += d; }); p.on('close', () => ok({ out: o.trim(), err: e.trim() })); });
let st = fs.existsSync(STATE) ? JSON.parse(fs.readFileSync(STATE, 'utf8')) : null;
if (!st) { const seats = (arg.seats || 'claude,john,kalli,maria').split(','); let s = +(arg.seed || 5); const r = () => { s = (s * 9301 + 49297) % 233280; return s / 233280; };
  const order = [...seats].sort(() => r() - 0.5); st = { order, snake: [...order, ...[...order].reverse()], picks: [], n: 0 }; fs.writeFileSync(STATE, JSON.stringify(st)); log(`DRAFT order: ${order.join(' -> ')} (snake back)`); }
const left = () => Object.keys(POOL).filter((id) => !st.picks.some((p) => p.id === id));
const parse = (txt) => { const m = /PICK\s*[:=]\s*([a-z]+)/i.exec(txt || ''); const id = m && m[1].toLowerCase(); return id && left().includes(id) ? id : null; };
function prompt(seat, round) { return `You are ${seat[0].toUpperCase() + seat.slice(1)}. We are DRAFTING fighters for a small cup of Octagon Tactics (boxing, middleweight): a card game you have played before - one card each exchange, sealed; ATTACK beats FEINT, FEINT beats COUNTER, COUNTER beats ATTACK (only the attacks its card names), DEFEND covers one zone; the Lead; three rounds of six exchanges.
NEW: every fighter now has ATTRIBUTES (1-10) that change his numbers - POWER (damage of power punches), HAND SPEED (speed of every attack), REACH (7+: +1 speed at Long and a harder Step-In Jab; 1-3: +1 speed at Close), CHIN (head health and how hard it is to rock him), BODY (body health, how fast body shots shrink his stamina), CARDIO (stamina, and what comes back between rounds), RING IQ (7+: harder counters; more of his cards seen when you read him). Every fighter has 42 points: a different shape, not a better man. His STYLE sets his 20-card deck (Out-Fighter: jabs, straights, counters, circle out; Pressure: hooks, Overhand, Liver Hook, Cut the Cage; Counter-Puncher: slips, pull counters, check hook, feints).
THE POOL STILL OPEN:
${poolText().split('\n').filter((l) => left().includes(l.split(' = ')[0])).join('\n')}
PICKED SO FAR: ${st.picks.map((p) => `${p.seat}: ${p.id}`).join(', ') || 'none'}.
This is your ${round === 1 ? 'FIRST pick - the fighter you will fight the cup with' : 'SECOND pick - your reserve'}. Pick the one you most want to BE in the ring, and say why in two lines.
Answer with ONE line: PICK: <fighter id>  and one line starting WHY: . Nothing else.`; }
async function askGrok(seat, text) { const f = path.join(DIR, `${seat}_msg_${st.n}.txt`); fs.writeFileSync(f, text); const sent = Date.now() - 5000;
  for (let t = 0; t < 5; t++) { const r = await run('node', ['ops/Tools/grokbot_direct.mjs', 'send', seat, f]); if (r.out.includes('GROKBOT SENT')) break; log(`${seat} send failed: ${(r.out || r.err).slice(-160)}`); await sleep(30000); }
  const tail = path.join(DIR, `${seat}_tail.json`);
  for (const t0 = Date.now(); Date.now() - t0 < 15 * 60000;) { await sleep(10000); await run('node', ['ops/Tools/grokbot_direct.mjs', 'tail', seat, '40', '--out', tail]); let d = null; try { d = JSON.parse(fs.readFileSync(tail, 'utf8')); } catch {}
    const reply = ((d && d.entries) || []).filter((e) => e.kind === 'send-message' && Number(e.timestampMs || 0) > sent && (e.message || {}).type === 'text').map((e) => String(e.message.content || '')).join('\n');
    if (parse(reply)) return reply; }
  return ''; }
while (st.n < st.snake.length) { const seat = st.snake[st.n], round = st.n < st.order.length ? 1 : 2; let reply = '', id = null;
  if (seat === 'claude') { const f = path.join(DIR, 'claude_pick.txt'); fs.writeFileSync(path.join(DIR, 'claude_prompt.txt'), prompt(seat, round)); log(`waiting for Claude's pick ${round} (${f})`);
    for (;;) { if (fs.existsSync(f)) { reply = fs.readFileSync(f, 'utf8'); fs.unlinkSync(f); id = parse(reply); if (id) break; log('Claude pick not valid: ' + reply.trim()); } await sleep(3000); } }
  else { reply = await askGrok(seat, prompt(seat, round)); id = parse(reply); if (!id) { id = left()[0]; log(`${seat}: no valid pick, given ${id}`); } }
  const why = ((reply || '').split(/\r?\n/).find((l) => /^\W*why/i.test(l.trim())) || '').trim();
  st.picks.push({ seat, id, round, why }); st.n++; fs.writeFileSync(STATE, JSON.stringify(st)); log(`PICK ${st.n}: ${seat} -> ${id} (${POOL[id].n}) | ${why.slice(0, 180)}`); }
log('DRAFT DONE ' + st.order.map((s) => `${s}: ${st.picks.filter((p) => p.seat === s).map((p) => p.id).join(' / ')}`).join(' | '));
