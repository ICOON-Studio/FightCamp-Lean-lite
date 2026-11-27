// versus_by_message.mjs - TWO chat seats fight each other at Puncher's chance, beat by beat (S567).
// Owner S567: "can you make it so agents compete vs each other ?". The bout is proto/twohands/tools/versus.mjs (the page's
// own rules, each beat sealed before the other is seen); this driver is both seats' hands, as play_by_message.mjs is for one.
//
//   node ops/Tools/versus_by_message.mjs <dir> a=<seat>:<via> b=<seat>:<via> [seed=1] [pace=<s>] [server=http://127.0.0.1:8796] [page=one.html] [limit=<s>] [model=<ollama model>]
//     server=: fight on the match server (its lobby and table) instead of a local bout file (S568)
//     seat: kalli | john | maria | antigravity | dola | claude       via: grok | agy | dola | claude (API) | ollama (a local model, S568) | worker (a console worker plays by itself) | test
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
  if (S.via === 'ollama') { /* S568: a LOCAL model on this PC's GPU (ops/Tools/ollama_seat.py, ~1.4 s a beat): the rules part of the first message is kept as its system text, each call sends only the message from the state on */
    const rf = path.join(S.dir, 'rules.txt'), cut = text.indexOf('ROUND '); if (!fs.existsSync(rf) && cut > 0) fs.writeFileSync(rf, text.slice(0, cut));
    const mf = path.join(S.dir, `ask_${String(n).padStart(3, '0')}.txt`); fs.writeFileSync(mf, cut > 0 && !/YOUR VERDICT/.test(text) ? text.slice(cut) : text);
    for (let t = 0; t < 3; t++) { const r = await run('python', ['ops/Tools/ollama_seat.py', mf, '--rules', rf, '--model', arg.model || 'gemma4:12b', '--max-tokens', /YOUR VERDICT/.test(text) ? '900' : '20']   /* 20 tokens: the plan line only, ~1.5 s (with the WHY line ~4 s) */); log(`${S.seat} ${r.err.split('\n').slice(-1)[0]}`); if (r.out && want(r.out)) return r.out; await sleep(2000); }
    stall(S.seat + ': the local model gave no usable answer'); }
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

/* S568 server=<url> (the S567 handover: "point versus_by_message.mjs at the match server"): the bout is fought on the match
   server (proto/twohands/site/match_server.mjs, or the public one) instead of a local versus.mjs file - both seats join by
   name, are paired with vs=, and each plan goes in through /api/plan, so the bout shows in the lobby and the table beside
   people's bouts. The server plays a beat not sealed in its limit (BEAT_LIMIT_S, 600 s) as both hands held. */
const SERVER = (arg.server || '').replace(/\/$/, ''), LOGF = BOUT + '.log.txt';
/* S568 limit=<s>: real-time play - an answer that takes longer than this is played as both hands held, feet still */
const LIMIT = Number(arg.limit || 0);
function timed(S, secs, late) { if (!LIMIT) return; st.times = st.times || {}; (st.times[S.seat] = st.times[S.seat] || []).push(+secs.toFixed(1)); if (late) { st.late = st.late || {}; st.late[S.seat] = (st.late[S.seat] || 0) + 1; log(`${S.seat} LATE (${secs.toFixed(1)} s > ${LIMIT} s): both hands held`); } save(); }
async function api(p, o) { for (let t = 0; t < 6; t++) { try { const r = await fetch(SERVER + p, o ? { method: 'POST', headers: { 'content-type': 'application/json' }, body: JSON.stringify(o) } : undefined); return await r.json(); } catch (e) { log('server: ' + e); await sleep(5000); } } stall('the match server does not answer at ' + SERVER); }
const state = (k) => api(`/api/state?token=${st.tok[k]}&match=${st.match}`);
function serverText(s) { const m = (lab, f) => `${lab}: health ${f.health}/${f.healthMax}${f.downs ? ` (down ${f.downs}x)` : ''}, stamina ${f.stamina}/${f.staminaCap}, guard ${f.guard}, ground given ${f.groundGiven}/2${f.onTheRopes ? ' ON THE ROPES' : ''}${f.noClinchYet ? ', no clinch yet' : ''}${f.keptOut ? ', kept out (no step in this beat)' : ''}`;
  const L = [`ROUND ${s.round} of ${s.rounds}, beat ${s.beat} of ${s.beats}, range ${s.rangeName}. Points this round: you ${s.me.points} - ${s.him} ${s.he.points}. Cards so far (you-him): ${s.cards.map((c) => c.join('-')).join(', ') || 'none'}`, m(`YOU (${s.you})`, s.me), m(`HIM (${s.him})`, s.he)];
  if (s.hisLastBeats.length) L.push(`HIS LAST BEATS, newest first: ${s.hisLastBeats.join('  |  ')}`);
  if (s.lastBeat) L.push('THE LAST BEAT:', ...s.lastBeat.lines.map((x) => '  ' + x));
  L.push(s.over || (s.youSealed ? 'Your beat is sealed. Waiting for him.' : 'Choose your beat.')); return L.join('\n'); }
const planBody = (plan) => plan[0] === 'clinch' ? { clinch: true } : Object.fromEntries(plan.map((x) => x.split('=')));
if (SERVER && st.phase === 'intro') { st.tok = st.tok || [];   /* tokens saved as they come: a restarted driver reuses them (the server holds a name 15 min) */
  for (const S of SEATS.slice(st.tok.length)) { const j = await api('/api/join', { name: S.Name }); if (!j.token) stall(`${S.Name} cannot join: ${j.error}`); st.tok.push(j.token); save(); }
  for (const t0 = Date.now(); !st.match;) { for (const k of [0, 1]) { const f = await api('/api/find', { token: st.tok[k], vs: SEATS[1 - k].Name }); if (f.match) st.match = f.match; }
    if (!st.match && Date.now() - t0 > 60000) stall('the server paired nobody in a minute'); if (!st.match) await sleep(1500); }
  fs.writeFileSync(LOGF, `${SEATS[0].Name} v ${SEATS[1].Name} on ${SERVER}, bout ${st.match}\n`); st.phase = 'bout'; st.first = 1; st.logged = 0; save(); log(`server bout ${st.match} ${SEATS[0].Name} v ${SEATS[1].Name}`); }
async function serverBeat(k, s) { const S = SEATS[k];
  if (S.via === 'worker') { for (const t0 = Date.now(); ;) { const x = await state(k); if (!x.yourTurn || x.over) return; if (Date.now() - t0 > 20 * 60000) stall(S.seat + ': the worker sealed no beat in 20 min'); await sleep(4000); } }
  let msg = `${st.first ? intro(S, SEATS[1 - k]) + '\n' : ''}${serverText(s)}\n\n${FORM}`;
  for (let t = 0; t < 3; t++) { const t0 = Date.now(), reply = await ask(S, k, msg, (r) => !!parsePlan(r), 12), secs = (Date.now() - t0) / 1000, late = LIMIT && secs > LIMIT, plan = late ? ['lead=high', 'rear=high', 'feet=hold'] : parsePlan(reply) || ['lead=high', 'rear=high', 'feet=hold'], _t = timed(S, secs, late), why = (reply.split(/\r?\n/).find((l) => /^\W*why\b/i.test(l.trim())) || '').trim();
    fs.appendFileSync(path.join(DIR, 'why.txt'), `${S.Name}: ${plan.join(' ')}\n  ${why}\n`); const r = await api('/api/plan', { token: st.tok[k], match: st.match, ...planBody(plan) }); log(`${S.seat} ${plan.join(' ')} | ${why.slice(0, 160)} | ${r.ok ? 'sealed' : r.error}`);
    if (r.ok || /already sealed|is over/.test(r.error || '')) return; msg = `${r.error}\nYour plan was not accepted; nothing is lost. Send another.\n\n${FORM}`; }
  await api('/api/plan', { token: st.tok[k], match: st.match, lead: 'high', rear: 'high', feet: 'hold' }); log(S.seat + ': three refused plans, both hands held'); }
/* S568: a local model loads once (~10 s) before the first beat - not on the clock */
if (SEATS.some((S) => S.via === 'ollama') && st.phase !== 'verdict') { const wf = path.join(DIR, 'warm.txt'); fs.writeFileSync(wf, 'Say: ready'); const r = await run('python', ['ops/Tools/ollama_seat.py', wf, '--model', arg.model || 'gemma4:12b', '--max-tokens', '5']); log('warm-up: ' + r.err.trim().split(/\r?\n/).slice(-1)[0]); }
if (!SERVER && st.phase === 'intro') { vs('new', BOUT, `a=${SEATS[0].Name}`, `b=${SEATS[1].Name}`, `seed=${arg.seed || 1}`, ...(arg.page ? [`page=${arg.page}`] : [])); st.phase = 'bout'; st.first = 1; save(); log(`new bout ${SEATS[0].Name} v ${SEATS[1].Name}`); }
const intro = (S, o) => `You are ${S.Name}, and this is a MATCH: one bout of a small boxing game, Puncher's chance, against another AI agent, ${o.Name}. You both have the same boxer and the same rules. Each beat you each send your plan without seeing the other's; then the beat is played and you both see what happened. I am only the referee and your hands. Three rounds of six beats. PLAY TO WIN: read what ${o.Name} does and punish it.\n\nTHE GAME'S OWN HELP (all a player is told; there is no computer opponent here, only ${o.Name}):\n\n${help}\n`;
// one seat's beat: asked until the tool accepts the plan (three refusals: both hands held, feet still)
async function beat(k) { const S = SEATS[k];
  /* via=worker (S567, the league's Claude Opus player: a console worker that runs versus.mjs itself): nothing is sent, the driver waits until that side has sealed its beat */
  if (S.via === 'worker') { for (const t0 = Date.now(); ;) { const B = JSON.parse(fs.readFileSync(BOUT, 'utf8')); if (B.sealed[k] || B.over || B.n !== beat.n0) return; if (Date.now() - t0 > 20 * 60000) stall(S.seat + ': the worker sealed no beat in 20 min'); await sleep(4000); } } let msg = `${st.first ? intro(S, SEATS[1 - k]) + '\n' : ''}${vs('show', BOUT, `who=${S.who}`).out}\n\n${FORM}`;
  for (let t = 0; t < 3; t++) { const t0 = Date.now(), reply = await ask(S, k, msg, (r) => !!parsePlan(r), 12), secs = (Date.now() - t0) / 1000, late = LIMIT && secs > LIMIT, plan = late ? ['lead=high', 'rear=high', 'feet=hold'] : parsePlan(reply) || ['lead=high', 'rear=high', 'feet=hold'], _t = timed(S, secs, late), why = (reply.split(/\r?\n/).find((l) => /^\W*why\b/i.test(l.trim())) || '').trim();
    fs.appendFileSync(path.join(DIR, 'why.txt'), `${S.Name}: ${plan.join(' ')}\n  ${why}\n`); const r = vs('plan', BOUT, `who=${S.who}`, ...plan); log(`${S.seat} ${plan.join(' ')} | ${why.slice(0, 160)} | code ${r.code}`);
    if (r.code === 0) return; msg = `${r.out}\nYour plan was not accepted; nothing is lost. Send another.\n\n${FORM}`; }
  vs('plan', BOUT, `who=${S.who}`, 'lead=high', 'rear=high', 'feet=hold'); log(S.seat + ': three refused plans, both hands held'); }
while (SERVER && st.phase === 'bout') { const s0 = await state(0);
  if (s0.lastBeat && s0.n !== st.logged) { fs.appendFileSync(LOGF, s0.lastBeat.lines.join('\n') + '\n'); st.logged = s0.n; save(); }
  if (s0.over) { st.result = s0.over; st.phase = 'verdict'; save(); break; }
  await Promise.all([0, 1].map(async (k) => { const s = k ? await state(1) : s0; if (s.yourTurn) await serverBeat(k, s); }));
  for (const t0 = Date.now(); (await state(0)).n === s0.n && Date.now() - t0 < 15 * 60000;) await sleep(2000); st.first = 0; save(); }
while (!SERVER && st.phase === 'bout') { const B = JSON.parse(fs.readFileSync(BOUT, 'utf8')); if (B.over) { st.phase = 'verdict'; save(); break; } beat.n0 = B.n;
  await Promise.all([0, 1].filter((k) => !B.sealed[k]).map((k) => beat(k))); st.first = 0; save(); }
const result = SERVER ? st.result : JSON.parse(fs.readFileSync(BOUT, 'utf8')).over, whole = fs.readFileSync(LOGF, 'utf8');
await Promise.all([0, 1].map(async (k) => { if (st.verdict[k]) return; const S = SEATS[k], o = SEATS[1 - k];
  if (S.via === 'worker') { const vf = path.join(DIR, `VERSUS_${S.seat.toUpperCase()}.md`); for (const t0 = Date.now(); !fs.existsSync(vf) && Date.now() - t0 < 15 * 60000;) await sleep(5000); st.verdict[k] = 1; save(); log(S.seat + (fs.existsSync(vf) ? ' verdict file found' : ' wrote no verdict in 15 min')); return; }
  const msg = `THE BOUT IS OVER: ${result}\n\nEvery beat as it was played:\n\n${whole}\n\nYOUR VERDICT, as ONE message of at most 500 words: (1) why you won or lost - the two beats that decided it; (2) what ${o.Name} did that you could read, and what you could not; (3) was playing another agent more fun than a scripted opponent would be, and why; (4) one plan that felt too strong and one switch you never wanted; (5) one line each, 1 to 10: FUN, DEPTH, CLARITY, VARIETY; (6) TO REACH 10/10: the three changes to the game, most important first, each tied to a beat of this bout. End with the line: VERDICT END`;
  const reply = await ask(S, k, msg, (r) => r.length > 600 && /VERDICT END/i.test(r), 20); fs.writeFileSync(path.join(DIR, `VERSUS_${S.seat.toUpperCase()}.md`), `# ${S.Name} on ${SEATS[0].Name} v ${SEATS[1].Name} (${result})\n\n${reply}\n`); st.verdict[k] = 1; save(); log(S.seat + ' verdict saved'); }));
log('DONE ' + result + (st.times ? ' | answer seconds ' + JSON.stringify(st.times) + ' | late ' + JSON.stringify(st.late || {}) : '')); console.log(`VERSUS DONE ${result} dir=${DIR}`);
