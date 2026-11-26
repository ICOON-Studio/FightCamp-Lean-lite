// versus_by_message.mjs - TWO chat seats fight each other at Puncher's chance, beat by beat (S567).
// Owner S567: "can you make it so agents compete vs each other ?". The bout is proto/twohands/tools/versus.mjs (the page's
// own rules, each beat sealed before the other is seen); this driver is both seats' hands, as play_by_message.mjs is for one.
//
//   node ops/Tools/versus_by_message.mjs <dir> a=<seat>:<via> b=<seat>:<via> [seed=1] [pace=<s>]
//     seat: kalli | john | maria | antigravity | dola | claude       via: grok | agy | dola | claude (API) | worker (a console worker plays by itself) | test
//     dir:  E:/FightCamp/tmp/versus/<a>_v_<b>
// Resumable: <dir>/driver.json; everything said is in <dir>/driver.log and <dir>/<seat>/. After the bout each seat is asked
// for a short verdict (<dir>/VERSUS_<SEAT>.md). Ends with VERSUS DONE <result> or VERSUS STALLED <why>.
import fs from 'node:fs';
import path from 'node:path';
import { spawnSync, spawn } from 'node:child_process';

const ROOT = path.resolve(path.dirname(new URL(import.meta.url).pathname.replace(/^\/([A-Za-z]:)/, '$1')), '..', '..');
const [dirArg, ...rest] = process.argv.slice(2), arg = Object.fromEntries(rest.filter((a) => a.includes('=')).map((a) => a.split('=')));
if (!dirArg || !arg.a || !arg.b) { console.log('usage: versus_by_message.mjs <dir> a=<seat>:<via> b=<seat>:<via> [seed=1] [pace=<s>]'); process.exit(2); }
const DIR = path.resolve(dirArg); fs.mkdirSync(DIR, { recursive: true });
const SEATS = [arg.a, arg.b].map((s, k) => { const [seat, via] = s.split(':'), dir = path.join(DIR, seat); fs.mkdirSync(dir, { recursive: true }); return { seat, via: via || 'grok', dir, who: 'ab'[k], Name: seat[0].toUpperCase() + seat.slice(1), n: 0 }; });
const LOG = path.join(DIR, 'driver.log'), STATE = path.join(DIR, 'driver.json'), BOUT = path.join(DIR, 'bout.json');
const log = (s) => fs.appendFileSync(LOG, `[${new Date().toISOString().slice(11, 19)}] ${s}\n`);
const sleep = (ms) => new Promise((r) => setTimeout(r, ms));
const st = fs.existsSync(STATE) ? JSON.parse(fs.readFileSync(STATE, 'utf8')) : { phase: 'intro', n: [0, 0], verdict: [0, 0] };
const save = () => fs.writeFileSync(STATE, JSON.stringify(st));
const stall = (why) => { log('STALLED ' + why); console.log(`VERSUS STALLED ${why}`); process.exit(1); };
const run = (cmd, args, opt = {}) => new Promise((ok) => { const p = spawn(cmd, args, { cwd: ROOT, windowsHide: true, ...opt }); let o = '', e = ''; p.stdout.on('data', (d) => { o += d; }); p.stderr.on('data', (d) => { e += d; }); p.on('close', (code) => ok({ out: o.trim(), err: e.trim(), code })); p.on('error', (x) => ok({ out: '', err: String(x), code: -1 })); });
const vs = (...a) => { const r = spawnSync('node', ['proto/twohands/tools/versus.mjs', ...a], { cwd: ROOT, encoding: 'utf8' }); return { out: (r.stdout || '').trim(), code: r.status }; };

// ---- one message to one seat, the whole reply back (all async: the two seats think at the same time)
async function ask(S, k, text, want, maxMin) {
  const n = ++st.n[k]; save(); const f = path.join(S.dir, `msg_${String(n).padStart(3, '0')}.txt`); fs.writeFileSync(f, text);
  if (S.via === 'test') return /YOUR VERDICT/.test(text) ? 'x'.repeat(700) + '\nFUN 7 DEPTH 7 CLARITY 7 VARIETY 7\nVERDICT END' : /NOT PLAYED/.test(text) ? 'lead=high rear=high feet=hold\nWHY: rest' : n % 3 === 0 ? 'lead=jab rear=cross feet=hold\nWHY: one two' : 'lead=jab rear=high feet=in order=feet,lead\nWHY: close';
  if (S.via === 'agy') { const all = path.join(S.dir, 'match_so_far.md'); fs.appendFileSync(all, `\n\n=== MESSAGE ${n} TO YOU ===\n${text}\n`);
    const agy = path.join(process.env.LOCALAPPDATA, 'agy', 'bin', 'agy.exe'), prompt = `You are a boxer in a match. Read the file ${all.replace(/\\/g, '/')} from top to bottom with your file read tool: it is the whole match so far. Answer ONLY its LAST message, exactly in the form it asks for, as your final message. Use no other tool: no shell command, no file write, no search.`;
    for (let t = 0; t < 3; t++) { const r = await run(agy, ['-p', prompt, '--mode', 'accept-edits', '--sandbox', '--print-timeout', `${maxMin * 60}s`], { cwd: S.dir }); if (r.out && want(r.out)) { fs.appendFileSync(all, `\n=== YOUR ANSWER TO MESSAGE ${n} ===\n${r.out}\n`); return r.out; } log(`${S.seat} agy try ${t + 1}: no usable answer (${r.out.length} chars) ${r.err.slice(-160)}`); await sleep(5000); }
    stall(S.seat + ': agy gave no usable answer'); }
  if (S.via === 'claude') { /* S567 "you play also on opus": one Messages API call a beat (ops/Tools/claude_seat.py), the match so far as one file */
    const all = path.join(S.dir, 'match_so_far.md'); fs.appendFileSync(all, `

=== MESSAGE ${n} TO YOU ===
${text}
`);
    for (let t = 0; t < 3; t++) { const r = await run('python', ['ops/Tools/claude_seat.py', all, '--model', arg.claude || 'claude-opus-5-5', '--max-tokens', /YOUR VERDICT/.test(text) ? '1600' : '400']); if (r.out && want(r.out)) { fs.appendFileSync(all, `
=== YOUR ANSWER TO MESSAGE ${n} ===
${r.out}
`); return r.out; } log(`${S.seat} claude try ${t + 1}: no usable answer (${r.out.length} chars) ${r.err.slice(-200)}`); await sleep(5000); }
    stall(S.seat + ': the Claude seat gave no usable answer'); }
  if (S.via === 'dola') { const tag = `[message ${n} of this match]`, tr = path.join(S.dir, 'transcript.txt'), vis = path.join(S.dir, 'visible.txt'); fs.writeFileSync(f, `${text}\n\n${tag}`);
    const r = await run('python', ['ops/Tools/cici/cici.py', 'send', ...(st.dolaChat ? [] : ['--new']), '--file', f, '--wait', '150', '--out', tr]); log('dola send: ' + (r.out || r.err).split('\n').slice(-1)[0].slice(0, 160)); st.dolaChat = 1; save();
    const ui = /^(Show More|Show Less|Today \d.*|Yesterday.*|Chat|Create Videos|Create Images|Writing|Homework|Translate)$/, clean = (s) => s.split(/\r?\n/).filter((l) => !ui.test(l.trim())).join('\n').trim();
    for (const t0 = Date.now(); ;) { await run('python', ['ops/Tools/cici/cici.py', 'read', '--visible-only', '--out', vis]); let all = ''; try { all = fs.readFileSync(vis, 'utf8'); } catch {} const i = all.lastIndexOf(tag), reply = i >= 0 ? clean(all.slice(i + tag.length)) : '';
      if (reply && want(reply)) return reply; if (Date.now() - t0 > maxMin * 60000) { if (reply) return reply; stall('no usable reply from dola in ' + maxMin + ' min'); } await sleep(15000); } }
  // grok (Kalli, John, Maria): the same gateway calls as play_by_message.mjs, a gap between two messages to one bot
  const gap = Number(arg.pace || 20) * 1000 - (Date.now() - (S.lastSend || 0)); if (gap > 0) await sleep(gap); S.lastSend = Date.now(); const sent = Date.now() - 5000;
  for (let t = 0; ; t++) { const r = await run('node', ['ops/Tools/grokbot_direct.mjs', 'send', S.seat, f]); if (r.out.includes('GROKBOT SENT')) break; log(`${S.seat} send failed: ` + (r.out || r.err).slice(-200)); if (t >= 4) stall('cannot send to ' + S.seat); await sleep(30000); }
  const tail = path.join(S.dir, 'tail.json'); let last = '', lastAt = Date.now(), nudged = false;
  for (;;) { await sleep(9000); await run('node', ['ops/Tools/grokbot_direct.mjs', 'tail', S.seat, '40', '--out', tail]); let data = null; try { data = JSON.parse(fs.readFileSync(tail, 'utf8')); } catch {}
    const mine = ((data && data.entries) || []).filter((e) => e.kind === 'send-message' && Number(e.timestampMs || 0) > sent && (e.message || {}).type === 'text'), reply = mine.map((e) => String(e.message.content || '')).join('\n\n');
    if (reply !== last) { last = reply; lastAt = Date.now(); } const quiet = (Date.now() - lastAt) / 1000;
    if (reply && want(reply) && quiet >= 12) return reply;
    if (!nudged && quiet > maxMin * 30) { nudged = true; log(S.seat + ' nudge'); const nf = path.join(S.dir, 'nudge.txt'); fs.writeFileSync(nf, 'I am waiting for your answer to my last message, in the exact form it asks for.'); await run('node', ['ops/Tools/grokbot_direct.mjs', 'send', S.seat, nf]); }
    if (quiet > maxMin * 60) { if (reply) return reply; stall(S.seat + ': no reply in ' + maxMin + ' min'); } }
}
function parsePlan(reply) { const lines = reply.split(/\r?\n/).map((l) => l.replace(/[`*>]/g, ' ').trim().toLowerCase());
  for (let i = lines.length - 1; i >= 0; i--) { const l = lines[i], lead = (l.match(/\blead\s*=\s*([a-z]+)/) || [])[1], rear = (l.match(/\brear\s*=\s*([a-z]+)/) || [])[1];
    if (lead && rear) { const feet = (l.match(/\bfeet\s*=\s*([a-z]+)/) || [])[1] || 'hold', order = ((l.match(/\border\s*=\s*([a-z, ]+)/) || [])[1] || '').split(',').map((x) => x.trim().split(' ')[0]).filter((x) => ['feet', 'lead', 'rear'].includes(x));
      return [`lead=${lead}`, `rear=${rear}`, `feet=${feet}`, ...(order.length ? [`order=${order.join(',')}`] : [])]; }
    if (/^(plan\s*[:=]\s*)?clinch\W*$/.test(l)) return ['clinch']; }
  return null; }
const FORM = 'Answer with ONE line: lead=<punch|high|low> rear=<punch|high|low> feet=in|hold|back order=<feet,lead,rear in your order>   (or the one word: clinch)\nand ONE line starting WHY: . Nothing else.';
const help = spawnSync('node', ['proto/twohands/tools/play_cli.mjs', 'help'], { cwd: ROOT, encoding: 'utf8' }).stdout.split('\n').filter((l) => !/^Opponents:|HE READS HABITS/.test(l)).join('\n').trim();

if (st.phase === 'intro') { vs('new', BOUT, `a=${SEATS[0].Name}`, `b=${SEATS[1].Name}`, `seed=${arg.seed || 1}`); st.phase = 'bout'; st.first = 1; save(); log(`new bout ${SEATS[0].Name} v ${SEATS[1].Name}`); }
const intro = (S, o) => `You are ${S.Name}, and this is a MATCH: one bout of a small boxing game, Puncher's chance, against another AI agent, ${o.Name}. You both have the same boxer and the same rules. Each beat you each send your plan without seeing the other's; then the beat is played and you both see what happened. I am only the referee and your hands. Three rounds of six beats. PLAY TO WIN: read what ${o.Name} does and punish it.\n\nTHE GAME'S OWN HELP (all a player is told; there is no computer opponent here, only ${o.Name}):\n\n${help}\n`;
// one seat's beat: asked until the tool accepts the plan (three refusals: both hands held, feet still)
async function beat(k) { const S = SEATS[k];
  /* via=worker (S567, the league's Claude Opus player: a console worker that runs versus.mjs itself): nothing is sent, the driver waits until that side has sealed its beat */
  if (S.via === 'worker') { for (const t0 = Date.now(); ;) { const B = JSON.parse(fs.readFileSync(BOUT, 'utf8')); if (B.sealed[k] || B.over || B.n !== beat.n0) return; if (Date.now() - t0 > 20 * 60000) stall(S.seat + ': the worker sealed no beat in 20 min'); await sleep(4000); } } let msg = `${st.first ? intro(S, SEATS[1 - k]) + '\n' : ''}${vs('show', BOUT, `who=${S.who}`).out}\n\n${FORM}`;
  for (let t = 0; t < 3; t++) { const reply = await ask(S, k, msg, (r) => !!parsePlan(r), 12), plan = parsePlan(reply) || ['lead=high', 'rear=high', 'feet=hold'], why = (reply.split(/\r?\n/).find((l) => /^\W*why\b/i.test(l.trim())) || '').trim();
    fs.appendFileSync(path.join(DIR, 'why.txt'), `${S.Name}: ${plan.join(' ')}\n  ${why}\n`); const r = vs('plan', BOUT, `who=${S.who}`, ...plan); log(`${S.seat} ${plan.join(' ')} | ${why.slice(0, 160)} | code ${r.code}`);
    if (r.code === 0) return; msg = `${r.out}\nYour plan was not accepted; nothing is lost. Send another.\n\n${FORM}`; }
  vs('plan', BOUT, `who=${S.who}`, 'lead=high', 'rear=high', 'feet=hold'); log(S.seat + ': three refused plans, both hands held'); }
while (st.phase === 'bout') { const B = JSON.parse(fs.readFileSync(BOUT, 'utf8')); if (B.over) { st.phase = 'verdict'; save(); break; } beat.n0 = B.n;
  await Promise.all([0, 1].filter((k) => !B.sealed[k]).map((k) => beat(k))); st.first = 0; save(); }
const result = JSON.parse(fs.readFileSync(BOUT, 'utf8')).over, whole = fs.readFileSync(BOUT + '.log.txt', 'utf8');
await Promise.all([0, 1].map(async (k) => { if (st.verdict[k]) return; const S = SEATS[k], o = SEATS[1 - k];
  if (S.via === 'worker') { const vf = path.join(DIR, `VERSUS_${S.seat.toUpperCase()}.md`); for (const t0 = Date.now(); !fs.existsSync(vf) && Date.now() - t0 < 15 * 60000;) await sleep(5000); st.verdict[k] = 1; save(); log(S.seat + (fs.existsSync(vf) ? ' verdict file found' : ' wrote no verdict in 15 min')); return; }
  const msg = `THE BOUT IS OVER: ${result}\n\nEvery beat as it was played:\n\n${whole}\n\nYOUR VERDICT, as ONE message of at most 500 words: (1) why you won or lost - the two beats that decided it; (2) what ${o.Name} did that you could read, and what you could not; (3) was playing another agent more fun than a scripted opponent would be, and why; (4) one plan that felt too strong and one switch you never wanted; (5) one line each, 1 to 10: FUN, DEPTH, CLARITY, VARIETY; (6) TO REACH 10/10: the three changes to the game, most important first, each tied to a beat of this bout. End with the line: VERDICT END`;
  const reply = await ask(S, k, msg, (r) => r.length > 600 && /VERDICT END/i.test(r), 20); fs.writeFileSync(path.join(DIR, `VERSUS_${S.seat.toUpperCase()}.md`), `# ${S.Name} on ${SEATS[0].Name} v ${SEATS[1].Name} (${result})\n\n${reply}\n`); st.verdict[k] = 1; save(); log(S.seat + ' verdict saved'); }));
log('DONE ' + result); console.log(`VERSUS DONE ${result} dir=${DIR}`);
