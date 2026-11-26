// play_by_message.mjs - a seat with NO shell plays Ring Switches beat by beat (S558, ALLPLAY1).
// Owner S557: "have it playtested by all agents and also you". Kalli, John, Maria (Grok chat bots) and Antigravity
// (agy -p: file tools only) cannot run play_cli.mjs, so this driver is their hands: it sends the tool's own lines,
// reads ONE plan line back, plays the beat, sends the result. After the last bout it asks for the report and the drawing.
//
//   node ops/Tools/play_by_message.mjs <seat> <dir> [via=grok|agy] [bouts=0:11,1:12,2:13]
//   S563: [tag=ALLPLAY2] reads ops/research/TASK_<tag>.md and names the report <tag>_<SEAT>.md; a bout opp:seed:t has TELLS ON
//     seat: kalli | john | maria | antigravity      dir: E:/FightCamp/tmp/allplay1/<seat> (agy: a folder under E:/FightCamp/wt)
// Resumable: <dir>/driver.json holds where it is; run the same command again. Everything said is in <dir>/driver.log.
// Ends with a line DRIVER DONE <seat> or DRIVER STALLED <seat> <why>.
import fs from 'node:fs';
import path from 'node:path';
import { execFileSync, spawnSync } from 'node:child_process';

const ROOT = path.resolve(path.dirname(new URL(import.meta.url).pathname.replace(/^\/([A-Za-z]:)/, '$1')), '..', '..');
const [seat, dirArg, ...rest] = process.argv.slice(2);
const arg = Object.fromEntries(rest.filter((a) => a.includes('=')).map((a) => a.split('=')));
if (!seat || !dirArg) { console.log('usage: play_by_message.mjs <seat> <dir> [via=grok|agy] [bouts=0:11,1:12,2:13]'); process.exit(2); }
const DIR = path.resolve(dirArg), VIA = arg.via || 'grok', SEAT = seat.toUpperCase();
const BOUTS = (arg.bouts || '0:11,1:12,2:13').split(',').map((b) => { const [opp, seed, t] = b.split(':'); return { opp: Number(opp), seed: Number(seed), tells: t === 't' }; });   /* S563: opp:seed:t = a TELLS1 bout */
const TAG = (arg.tag || 'ALLPLAY1').toUpperCase();   /* S563: ALLPLAY2 = the tells playtest, brief TASK_ALLPLAY2.md */
const OPP = ['The Jabber', 'The Slugger', 'The Body Snatcher'];
fs.mkdirSync(DIR, { recursive: true });
const LOG = path.join(DIR, 'driver.log'), STATE = path.join(DIR, 'driver.json');
const log = (s) => { fs.appendFileSync(LOG, `[${new Date().toISOString().slice(11, 19)}] ${s}\n`); };
const sleep = (ms) => new Promise((r) => setTimeout(r, ms));
const st = fs.existsSync(STATE) ? JSON.parse(fs.readFileSync(STATE, 'utf8')) : { bout: 0, phase: 'intro', n: 0, beats: 0 };
const save = () => fs.writeFileSync(STATE, JSON.stringify(st));
const stall = (why) => { log('STALLED ' + why); console.log(`DRIVER STALLED ${seat} ${why}`); process.exit(1); };

const cli = (...a) => { const r = spawnSync('node', ['proto/twohands/tools/play_cli.mjs', ...a], { cwd: ROOT, encoding: 'utf8' }); return { out: (r.stdout || '').trim(), code: r.status }; };
const boutFile = (i) => path.join(DIR, `b${i + 1}.json`);
const brief = fs.readFileSync(path.join(ROOT, `ops/research/TASK_${TAG}.md`), 'utf8');

// ---- the two ways to reach a seat: each takes the text of one message and gives back the seat's whole reply
async function grokAsk(text, want, maxMin) {
  const f = path.join(DIR, `msg_${String(++st.n).padStart(3, '0')}.txt`); fs.writeFileSync(f, text); save();
  // S558: three bots answered 1-2 beats in seconds, then the box started no more turns: keep a gap between messages (pace=<s>)
  const gap = Number(arg.pace || 0) * 1000 - (Date.now() - (grokAsk.lastSend || 0)); if (gap > 0) await sleep(gap); grokAsk.lastSend = Date.now();
  const sent = Date.now() - 5000;
  for (let t = 0; ; t++) {
    const r = spawnSync('node', ['ops/Tools/grokbot_direct.mjs', 'send', seat, f], { cwd: ROOT, encoding: 'utf8' });
    if ((r.stdout || '').includes('GROKBOT SENT')) break;
    log('send failed: ' + (r.stdout || r.stderr || '').trim().slice(-200)); if (t >= 4) stall('cannot send to ' + seat); await sleep(30000);
  }
  const tail = path.join(DIR, 'tail.json'); let last = '', lastAt = Date.now(), nudged = false;
  for (;;) {
    await sleep(9000);
    spawnSync('node', ['ops/Tools/grokbot_direct.mjs', 'tail', seat, '40', '--out', tail], { cwd: ROOT, encoding: 'utf8' });
    let data = null; try { data = JSON.parse(fs.readFileSync(tail, 'utf8')); } catch {}
    const mine = ((data && data.entries) || []).filter((e) => e.kind === 'send-message' && Number(e.timestampMs || 0) > sent && (e.message || {}).type === 'text');
    const reply = mine.map((e) => String(e.message.content || '')).join('\n\n');
    if (reply !== last) { last = reply; lastAt = Date.now(); }
    const quiet = (Date.now() - lastAt) / 1000;
    if (reply && want(reply) && quiet >= 12) return reply;
    if (!nudged && quiet > maxMin * 30) { nudged = true; log('nudge'); const nf = path.join(DIR, 'nudge.txt'); fs.writeFileSync(nf, 'I am waiting for your answer to my last message, in the exact form it asks for.'); spawnSync('node', ['ops/Tools/grokbot_direct.mjs', 'send', seat, nf], { cwd: ROOT, encoding: 'utf8' }); }
    if (quiet > maxMin * 60) { if (reply) return reply; stall('no reply in ' + maxMin + ' min'); }
  }
}
async function agyAsk(text, want, maxMin) {
  // agy -p keeps no memory between runs: the whole playtest so far is one file it reads, its answer is its stdout
  const all = path.join(DIR, 'playtest_so_far.md'); st.n++; save();
  fs.appendFileSync(all, `\n\n=== MESSAGE ${st.n} TO YOU ===\n${text}\n`);
  const agy = path.join(process.env.LOCALAPPDATA, 'agy', 'bin', 'agy.exe');
  const prompt = `You are a playtester. Read the file ${all.replace(/\\/g, '/')} from top to bottom with your file read tool: it is the whole playtest so far. Answer ONLY its LAST message, exactly in the form it asks for, as your final message. Use no other tool: no shell command, no file write, no search.`;
  for (let t = 0; t < 3; t++) {
    const r = spawnSync(agy, ['-p', prompt, '--mode', 'accept-edits', '--sandbox', '--print-timeout', `${maxMin * 60}s`], { cwd: DIR, encoding: 'utf8', timeout: (maxMin * 60 + 60) * 1000, windowsHide: true });
    const reply = (r.stdout || '').trim();
    if (reply && want(reply)) { fs.appendFileSync(all, `\n=== YOUR ANSWER TO MESSAGE ${st.n} ===\n${reply}\n`); return reply; }
    log(`agy try ${t + 1}: no usable answer (${reply.length} chars) ${String(r.stderr || '').trim().slice(-200)}`); text = ''; await sleep(5000);
  }
  stall('agy gave no usable answer');
}
// via=dola (S558, owner: "grokbots are out of quota, tgry dola now"): her desktop app through ops/Tools/cici/cici.py (CDP 9333).
// One fresh chat for the whole playtest; every message ends with a tag, and her answer is what the transcript holds after it.
async function dolaAsk(text, want, maxMin) {
  const tag = `[message ${++st.n} of this playtest]`, f = path.join(DIR, `msg_${String(st.n).padStart(3, '0')}.txt`), tr = path.join(DIR, 'transcript.txt');
  fs.writeFileSync(f, `${text}\n\n${tag}`);
  const r = spawnSync('python', ['ops/Tools/cici/cici.py', 'send', ...(st.dolaChat ? [] : ['--new']), '--file', f, '--wait', '150', '--out', tr], { cwd: ROOT, encoding: 'utf8', timeout: 300000 });
  log('dola send: ' + String(r.stdout || r.stderr || '').trim().split('\n').slice(-1)[0].slice(0, 160)); st.dolaChat = 1; save();
  // After 15 beats the whole-thread read lost my newer messages (her long chat keeps only part of its list): the answer to a
  // beat is read from the ON-SCREEN tail after my tag; a long answer (the report, the drawing) may also be the last block
  // of the whole-thread read - `want` (REPORT END, </html>) keeps an old beat answer from passing for it.
  const vis = path.join(DIR, 'visible.txt'), ui = /^(Show More|Show Less|Today \d.*|Yesterday.*|Chat|Create Videos|Create Images|Writing|Homework|Translate)$/;
  const clean = (s) => s.split(/\r?\n/).filter((l) => !ui.test(l.trim())).join('\n').trim();
  const after = () => { let all = ''; try { all = fs.readFileSync(vis, 'utf8'); } catch {} const i = all.lastIndexOf(tag); return i >= 0 ? clean(all.slice(i + tag.length)) : ''; };
  const lastBlock = () => { let all = ''; try { all = fs.readFileSync(tr, 'utf8'); } catch {} return clean(all.split('----- MESSAGE BREAK -----').pop() || ''); };
  const reread = (whole) => { spawnSync('python', ['ops/Tools/cici/cici.py', 'read', '--visible-only', '--out', vis], { cwd: ROOT, encoding: 'utf8', timeout: 120000 });
    if (whole) spawnSync('python', ['ops/Tools/cici/cici.py', 'read', '--out', tr], { cwd: ROOT, encoding: 'utf8', timeout: 180000 }); };
  const long = !/Answer with ONE line/.test(text.slice(-400));
  for (const t0 = Date.now(); ;) {
    reread(long); let reply = after(); if (long && !(reply && want(reply)) && want(lastBlock())) reply = lastBlock();
    if (reply && want(reply)) { await sleep(6000); reread(long); const again = long && want(lastBlock()) && lastBlock().length > after().length ? lastBlock() : after(); return again && want(again) ? again : reply; }
    if (Date.now() - t0 > maxMin * 60000) { if (reply) return reply; stall('no usable reply from dola in ' + maxMin + ' min'); }
    await sleep(15000);
  }
}
// via=test: no seat at all, a fixed answer to each kind of message (proves the driver end to end in seconds)
async function testAsk(full) { st.n++; fs.appendFileSync(path.join(DIR, 'sent.txt'), `\n=== ${st.n} ===\n${full}\n`); const text = full.slice(-900);
  return /DRAW your 10\/10/.test(text) ? 'Here:\n```html\n<!DOCTYPE html><html><body>ten</body></html>\n```' : /NOW WRITE YOUR REPORT/.test(text) ? 'x'.repeat(1600) + '\nREPORT END'
    : /Nothing is lost|NOT PLAYED/.test(text) ? 'lead=high rear=high feet=hold\nWHY: rest' : st.n % 4 === 0 ? 'clinch\nWHY: breath' : 'I think: `lead=jab rear=high feet=in order=feet,lead`\nWHY: test the jab'; }
const ask = VIA === 'agy' ? agyAsk : VIA === 'dola' ? dolaAsk : VIA === 'test' ? testAsk : grokAsk;

// ---- one plan line out of a reply: the last line that has lead= and rear=, or a bare "clinch"
function parsePlan(reply) {
  const lines = reply.split(/\r?\n/).map((l) => l.replace(/[`*>]/g, ' ').trim().toLowerCase());
  for (let i = lines.length - 1; i >= 0; i--) {
    const l = lines[i], lead = (l.match(/\blead\s*=\s*([a-z]+)/) || [])[1], rear = (l.match(/\brear\s*=\s*([a-z]+)/) || [])[1];
    if (lead && rear) { const feet = (l.match(/\bfeet\s*=\s*([a-z]+)/) || [])[1] || 'hold';
      const order = ((l.match(/\border\s*=\s*([a-z, ]+)/) || [])[1] || '').split(',').map((x) => x.trim().split(' ')[0]).filter((x) => ['feet', 'lead', 'rear'].includes(x));
      return [`lead=${lead}`, `rear=${rear}`, `feet=${feet}`, ...(order.length ? [`order=${order.join(',')}`] : [])]; }
    if (/^(plan\s*[:=]\s*)?clinch\W*$/.test(l)) return ['clinch'];
  }
  return null;
}
const FORM = 'Answer with ONE line: lead=<punch|high|low> rear=<punch|high|low> feet=in|hold|back order=<feet,lead,rear in your order>   (or the one word: clinch)\nand ONE line starting WHY: . Nothing else.';

// ---- the playtest
let carry = '';
if (st.phase === 'intro') {
  carry = `You are ${seat[0].toUpperCase() + seat.slice(1)}, and this is a PLAYTEST of a small boxing game. You have no shell here, so you play BY MESSAGE: I am your hands. I send you what the game shows, you send back your plan for the beat, I play it and send you what happened. ${BOUTS.length} bouts, played to win (the list is in the brief). Do not write the report until I ask for it after the last bout.\n\nTHE BRIEF (the part for a seat with no shell is yours):\n\n${brief}\n\nTHE GAME'S OWN HELP (all a player is told):\n\n${cli('help').out}\n`;
  st.phase = 'bout'; save();
}
while (st.phase === 'bout' && st.bout < BOUTS.length) {
  const b = BOUTS[st.bout], f = boutFile(st.bout);
  let shown;
  if (!fs.existsSync(f)) { shown = cli('new', f, `opp=${b.opp}`, `seed=${b.seed}`, ...(b.tells ? ['tells=1'] : [])).out; log(`bout ${st.bout + 1} new: ${OPP[b.opp]} seed ${b.seed}`); }
  else shown = '(the bout goes on)\n' + cli('show', f).out;
  let msg = `${carry}\n=== BOUT ${st.bout + 1} of ${BOUTS.length}, against ${OPP[b.opp]}${b.tells ? ', TELLS ON' : ', no tells'} ===\n${shown}\n\n${FORM}`; carry = '';
  for (;;) {
    const reply = await ask(msg, (r) => !!parsePlan(r), 12);
    const plan = parsePlan(reply); if (!plan) stall('no plan line in the reply');
    const why = (reply.split(/\r?\n/).find((l) => /^\W*why\b/i.test(l.trim())) || '').trim();
    const r = cli('beat', f, ...plan); st.beats++; save();
    log(`b${st.bout + 1} ${plan.join(' ')} | ${why.slice(0, 200)} | code ${r.code}`);
    fs.appendFileSync(path.join(DIR, `b${st.bout + 1}.why.txt`), `${plan.join(' ')}\n  ${why}\n`);
    const over = JSON.parse(fs.readFileSync(f, 'utf8')).over;
    if (over) { carry = `THE LAST BEAT OF BOUT ${st.bout + 1}:\n${r.out}\n`; break; }
    msg = `${r.out}\n\n${FORM}`;
  }
  st.bout++; save();
}
if (st.phase === 'bout') { st.phase = 'report'; save(); }
const fence = (t, lang) => { const m = t.match(new RegExp('```(?:' + lang + ')?\\s*\\n([\\s\\S]*?)```')); return m ? m[1] : t; };
if (st.phase === 'report') {
  const logs = BOUTS.map((b, i) => `--- BOUT ${i + 1} (${OPP[b.opp]}${b.tells ? ', tells on' : ''}) ---\n${fs.existsSync(boutFile(i) + '.log.txt') ? fs.readFileSync(boutFile(i) + '.log.txt', 'utf8') : ''}`).join('\n');
  /* S563: an ALLPLAY2 report must answer the owner's question in its own section; the ALLPLAY1 wording stays for that brief */
  const SECTIONS = TAG === 'ALLPLAY1'
    ? 'sections 2, 3 and 4 of the brief (FUN judged point by point, each with the bout, round and beat that proves it; the SCORES for FUN, DEPTH, CLARITY, VARIETY, 1 to 10, one line each, and what you could NOT judge from words; then TO REACH 10/10, the concrete changes, most important first, each tied to a beat you played)'
    : 'sections 2 to 5 of the brief: FUN judged point by point (each with the bout, round and beat that proves it, and the WITH TELLS questions); THE OWNER QUESTION in its own section (his whole plan shown before you choose / one body tell, usually true / as now with his last three beats: judge all three from beats you played, then pick one and say what must change for it to work); the SCORES for FUN, DEPTH, CLARITY, VARIETY, 1 to 10, once for the bouts with NO tells and once for the bouts WITH tells, and what you could NOT judge from words; then TO REACH 10/10, the concrete changes, most important first, each tied to a beat you played';
  const msg = `${carry}\nALL ${BOUTS.length} BOUTS ARE OVER. For your memory, every beat as it was played:\n\n${logs}\n\nNOW WRITE YOUR REPORT, ${TAG}_${SEAT}.md, as ONE message: the verdict first, then a NOT SURE list, then ${SECTIONS}. Do not draw the screen yet. End the message with the line: REPORT END`;
  const reply = await ask(msg, (r) => r.length > 1500 && /REPORT END/i.test(r), 25);
  fs.writeFileSync(path.join(DIR, `${TAG}_${SEAT}.md`), `# ${TAG} - ${seat} (played by message, driver ops/Tools/play_by_message.mjs, S558)\n\n${reply}\n`);
  log('report saved, ' + reply.length + ' chars'); st.phase = 'draw'; save();
}
if (st.phase === 'draw') {
  const msg = `Thank you. Last thing: DRAW your 10/10 fight screen for this game as ONE complete 1920x1080 HTML page (inline CSS only, no outside files, no script needed; real words and numbers from a beat you played). Send it as ONE message holding one \`\`\`html block that starts with <!DOCTYPE html> and ends with </html>.`;
  const reply = await ask(msg, (r) => /<\/html>/i.test(r), 25);
  fs.writeFileSync(path.join(DIR, 'ten.html'), fence(reply, 'html'));
  log('drawing saved'); st.phase = 'done'; save();
}
log('DONE'); console.log(`DRIVER DONE ${seat} beats=${st.beats} dir=${DIR}`);
