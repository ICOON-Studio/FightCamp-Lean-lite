// VERSUS (S567, owner: "can you make it so agents compete vs each other ?"): one bout of Puncher's chance between TWO
// players, on the page's own rules (rules.mjs reads order.html). Each player seals his beat without seeing the other's;
// when both are sealed the beat is played. Nobody has an AI opponent, a habit read or a tell: only the other player.
//   node proto/twohands/tools/versus.mjs new  <state.json> a=<name> b=<name> [seed=1] [page=one.html]
//   node proto/twohands/tools/versus.mjs show <state.json> who=a|b            the bout as that player sees it (never the other's sealed beat)
//   node proto/twohands/tools/versus.mjs plan <state.json> who=a|b lead=<punch|high|low> rear=<punch|high|low> feet=in|hold|back [order=feet,lead,rear]
//   node proto/twohands/tools/versus.mjs plan <state.json> who=a|b clinch
// The rules text is play_cli.mjs help (the same switches). Every played beat is appended to <state.json>.log.txt.
import fs from 'node:fs';
import { load } from './rules.mjs';

const [cmd, file, ...rest] = process.argv.slice(2), arg = Object.fromEntries(rest.filter((a) => a.includes('=')).map((a) => a.split('=')));
/* S568 page=<file.html> (ONEACT1, owner: "test it fable vs dola" on the one-action page): the bout is fought on that page's
   rules; `new` stores the page in the state file, show / plan read it from there. Default order.html as before. */
const PAGE = (cmd === 'new' ? arg.page : (file && fs.existsSync(file) ? JSON.parse(fs.readFileSync(file, 'utf8')).page : '')) || 'order.html';
const R0 = load(1, PAGE), { N, ACT, FEET, RNG } = R0;
const out = []; const say = (s) => { out.push(s); console.log(s); };
if (!cmd || !file) { console.log('usage: versus.mjs new|show|plan <state.json> ...  (see the top of the file)'); process.exit(2); }
if (cmd === 'new') { const S = { vs: 1, page: PAGE, names: [arg.a || 'A', arg.b || 'B'], seed: Number(arg.seed || 1), n: 0, round: 1, beat: 0, range: 3, cards: [], over: '', F: [R0.man(N.hp), R0.man(N.hp)], sealed: [null, null], last: [] };
  fs.writeFileSync(file, JSON.stringify(S)); fs.writeFileSync(file + '.log.txt', `${S.names[0]} v ${S.names[1]}, seed ${S.seed}\n`); console.log(`A new bout: ${S.names[0]} v ${S.names[1]}. Both start at Long with ${N.hp} health.`); process.exit(0); }
const S = JSON.parse(fs.readFileSync(file, 'utf8')), who = arg.who === 'b' ? 1 : 0, nm = S.names;
// the bout as one player sees it: himself first, the other man second; never the other's sealed beat
const view = (k) => { const me = S.F[k], him = S.F[1 - k], m = (lab, f) => `${lab}: health ${f.hp}/${f.max}${f.kd ? ` (down ${f.kd}x${f.kd >= N.kd.length ? ' - ONE MORE ENDS IT' : ''})` : ''}, stamina ${f.st}/${f.cap}, guard ${f.g}/${N.guard}, ground given ${Math.min(2, f.ropes)}/2${f.ropes >= 2 ? ' ON THE ROPES' : ''}${f.held ? ', no clinch yet' : ''}`;
  const L = [`ROUND ${S.round} of ${N.rounds}, beat ${S.beat + 1} of ${N.beats}, range ${RNG[S.range]}. Points this round: you ${me.pts} - ${nm[1 - k]} ${him.pts}. Cards so far (you-him): ${S.cards.map((c) => c[k] + '-' + c[1 - k]).join(', ') || 'none'}`, m(`YOU (${nm[k]})`, me), m(`HIM (${nm[1 - k]})`, him)];
  const seen = (S.seen || []).map((p) => p[1 - k]); if (seen.length) L.push(`HIS LAST BEATS, newest first: ${[...seen].reverse().map((p) => R0.planWords(p)).join('  |  ')}`);
  if (S.last.length) L.push('THE LAST BEAT:', ...S.last.map((s) => '  ' + s));
  if (!S.over) L.push(S.sealed[k] ? 'Your beat is sealed. Waiting for him.' : 'Choose your beat.');
  return L; };
if (cmd === 'show') { view(who).forEach((s) => console.log(s)); if (S.over) console.log(S.over); process.exit(0); }
if (cmd !== 'plan') { console.log('unknown command: ' + cmd); process.exit(2); }
if (S.over) { console.log('The bout is over: ' + S.over); process.exit(0); }
if (S.sealed[who]) { console.log('NOT PLAYED: your beat is already sealed for this beat.'); process.exit(2); }
const R = load(S.seed * 1000 + S.n, PAGE), me = S.F[who];
let mine = R.plan0();
if (rest.includes('clinch')) mine.clinch = true;
else { /* S567, Kalli's first match: "my plan was rejected over the name bodycross" - a punch may be named as the help prints it, by its id, or with the hand left off; a refusal lists the legal words */
  const norm = (x) => String(x || '').toLowerCase().replace(/[^a-z]/g, ''), names = (h) => Object.keys(ACT).filter((id) => ACT[id].h === h), pick = (x, h) => { const n = norm(x); if (!n || n === 'high' || n === 'low') return n || 'high';
    const hit = names(h).filter((id) => [id, ACT[id].n, ACT[id].n.replace(/^(lead|rear) /i, ''), (h ? 'rear' : 'lead') + ACT[id].n].some((w) => norm(w) === n)); return hit.length === 1 ? hit[0] : x; };
  const L = pick(arg.lead, 0), H = pick(arg.rear, 1);
  if (L === 'high' || L === 'low') mine.hl = L; else mine.lead = L; if (H === 'high' || H === 'low') mine.hr = H; else mine.rear = H; mine.feet = arg.feet || 'hold';
  const acts = [...(mine.feet !== 'hold' ? ['feet'] : []), ...(mine.lead ? ['lead'] : []), ...(mine.rear ? ['rear'] : [])], want = (arg.order || '').split(',').filter((x) => acts.includes(x));
  mine.ord = [...want, ...acts.filter((x) => !want.includes(x))]; }
const bad = mine.clinch ? (S.range > 1 ? 'the clinch works Inside only' : me.held ? 'the referee will not allow a clinch yet' : me.st < 1 ? 'no stamina' : '')
  : (mine.lead && (!ACT[mine.lead] || ACT[mine.lead].h !== 0)) ? `lead=${mine.lead} is not a lead-hand switch` : (mine.rear && (!ACT[mine.rear] || ACT[mine.rear].h !== 1)) ? `rear=${mine.rear} is not a rear-hand switch`
  : !FEET[mine.feet] ? `feet=${mine.feet}: in, hold or back` : R.cost(mine) > me.st ? `that costs ${R.cost(mine)} stamina, you have ${me.st}` : mine.feet === 'back' && me.ropes >= 2 ? 'you are on the ropes: no backing off until you step in' : mine.feet === 'in' && me.kept ? 'kept out: no step in this beat' : '';
if (bad) { console.log('NOT PLAYED: ' + bad + (/is not a (lead|rear)-hand switch/.test(bad) ? `. LEAD hand words: ${Object.keys(ACT).filter((id) => ACT[id].h === 0).join(', ')}, high, low. REAR hand words: ${Object.keys(ACT).filter((id) => ACT[id].h === 1).join(', ')}, high, low.` : '')); process.exit(2); }
S.sealed[who] = mine;
if (!S.sealed[1 - who]) { fs.writeFileSync(file, JSON.stringify(S)); console.log(`SEALED for ${nm[who]}: ${R.planWords(mine)}. Waiting for ${nm[1 - who]}.`); process.exit(0); }
// both sealed: the beat is played, told with the two names (the same lines for both players)
const plans = S.sealed, T = { f: S.F, range: S.range, t: N.beats - S.beat }, named = (s) => String(s).replace(/\byou\b/gi, nm[0]).replace(/\bhe\b/gi, nm[1]).replace(/\byour\b/gi, nm[0] + "'s").replace(/\bhis\b/gi, nm[1] + "'s").replace(/\bhim\b/gi, nm[1]);
say(`--- round ${S.round}, beat ${S.beat + 1}, at ${RNG[S.range]}`); say(`${nm[0]}: ${R.planWords(plans[0])}`); say(`${nm[1]}: ${R.planWords(plans[1])}`);
const ev = R.resolve(T, [{ ...plans[0] }, { ...plans[1] }]); R.endBeat(T); S.range = T.range; S.n++; S.seen = [...(S.seen || []), plans].slice(-3); S.sealed = [null, null];
for (const e of ev) say(`  ${e.m != null ? `moment ${e.m + 1} ` : ''}${e.k === 0 ? nm[0] : e.k === 1 ? nm[1] : ''}: ${named(e.a || e.t)}${e.o ? ' - ' + named(e.o) : ''}`);
for (const k of [0, 1]) if (S.F[k].hp <= 0 && !S.over) { S.F[k].kd++; S.F[1 - k].pts += 3; if (S.F[k].kd > N.kd.length) S.over = `${nm[1 - k]} WINS - the referee stops it`; else { S.F[k].hp = N.kd[S.F[k].kd - 1]; say(`  ${nm[k]} GOES DOWN and gets up on ${S.F[k].hp} health.`); } }
S.beat++;
if (!S.over && S.beat >= N.beats) { const [x, y] = S.F, { sc, onGround: onG } = R.judge(x, y);
  S.cards.push(sc); say(`BELL. The judges give the round ${nm[0]} ${sc[0]} - ${sc[1]} ${nm[1]}${onG ? ` (level on points: it goes to the man who backed off less - ${nm[0]} ${x.gave || 0}, ${nm[1]} ${y.gave || 0})` : ''}.`);
  if (S.round >= N.rounds) { const t = [0, 1].map((k) => S.cards.reduce((s, c) => s + c[k], 0)); S.over = t[0] === t[1] ? `A DRAW ${t[0]}-${t[1]}` : `${nm[t[0] > t[1] ? 0 : 1]} WINS on the cards ${Math.max(...t)}-${Math.min(...t)}`; }
  else { S.round++; S.beat = 0; S.range = 3; for (const m of S.F) { m.pts = 0; m.st = m.cap; m.g = N.guard; m.ropes = 0; m.held = 0; m.kept = 0; m.gave = 0; } } }
if (S.over) say(S.over);
S.last = out.slice();
fs.writeFileSync(file, JSON.stringify(S)); fs.appendFileSync(file + '.log.txt', out.join('\n') + '\n');
