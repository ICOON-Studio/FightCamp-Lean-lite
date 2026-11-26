// RING SWITCHES IN WORDS (S556, owner: "Can ziva play test it and judge it on fun?"): one bout played beat by beat from a
// shell, on the page's own rules (rules.mjs reads order.html) and its own opponents. For a seat that cannot click a page.
//   node proto/twohands/tools/play_cli.mjs help
//   node proto/twohands/tools/play_cli.mjs new  <state.json> opp=0|1|2 [seed=1] [tells=1]   0 Jabber, 1 Slugger, 2 Body Snatcher; tells=1: the TELLS1 trial
//   node proto/twohands/tools/play_cli.mjs beat <state.json> lead=<punch|high|low> rear=<punch|high|low> feet=in|hold|back [order=feet,lead,rear]
//   node proto/twohands/tools/play_cli.mjs beat <state.json> clinch
//   node proto/twohands/tools/play_cli.mjs show <state.json>
// The state file is the whole bout; every beat is appended to <state.json>.log.txt. He chooses before he sees your beat.
import fs from 'node:fs';
import { load } from './rules.mjs';
import { CUES, MEANS, tellOf, ledger } from './tells.mjs';   /* TELLS1 (S563): a bout started with tells=1 shows one body cue of his before each beat */

const [cmd, file, ...rest] = process.argv.slice(2), arg = Object.fromEntries(rest.filter((a) => a.includes('=')).map((a) => a.split('=')));
const out = []; const say = (s) => { out.push(s); console.log(s); };
const R0 = load(1), { N, ACT, FEET, RNG, COVER } = R0, SP = ['', 'fast', 'medium', 'slow'];
// ZIVAFIX1 (S557): his last three beats, newest first, holds included, and what each of his hands did this round - as on his card on the page
const his3 = (S) => { const seen = S.seen || [], rd = S.seenRound || [], held = (sl, h) => rd.filter((p) => !p.clinch && !p[sl] && (sl === 'lead' ? p.hl : p.hr) === h).length, out = (sl) => rd.filter((p) => !p.clinch && p[sl]).length;
  return seen.length ? [`HIS LAST BEATS, newest first: ${[...seen].reverse().map((p) => R0.planWords(p)).join('  |  ')}`, `THIS ROUND (${rd.length} beat${rd.length === 1 ? '' : 's'}): his lead hand held high ${held('lead', 'high')}, held low ${held('lead', 'low')}, thrown ${out('lead')}; his rear hand held high ${held('rear', 'high')}, held low ${held('rear', 'low')}, thrown ${out('rear')}`] : []; };
const bars = (S) => { const [x, y] = S.F, m = (who, f) => `${who}: health ${f.hp}/${f.max}${f.kd ? ` (down ${f.kd}x${f.kd >= N.kd.length ? ' - ONE MORE ENDS IT' : ''})` : ''}, stamina ${f.st}/${f.cap}, guard ${f.g}/${N.guard}, ground given ${Math.min(2, f.ropes)}/2${f.ropes >= 2 ? ' ON THE ROPES' : ''}${f.held ? ', no clinch yet' : ''}`;
  return [`ROUND ${S.round} of ${N.rounds}, beat ${S.beat + 1} of ${N.beats}, range ${RNG[S.range]}. Points this round: you ${x.pts} - him ${y.pts}. Cards so far: ${S.cards.map((c) => c.join('-')).join(', ') || 'none'}`, m('YOU', x), m(`HIM (${R0.OPPS[S.opp].n})`, y), ...his3(S), ...(S.tells && S.tell && !S.over ? [`HIS TELL before this beat: ${CUES[S.tell.cue]}.`] : [])]; };
/* TELLS1: his next beat is chosen BEFORE yours (as always) and kept, so his cue can be shown first */
const prepNext = (S) => { const R2 = load(S.seed * 1000 + S.n + 777777); R2.setOpp(S.opp); S.next = R2.ai({ f: S.F, range: S.range, t: N.beats - S.beat }) || R2.plan0(); S.tell = tellOf(S.opp, S.next, { me: S.F[0], him: S.F[1], hisLast: (S.seen || []).slice(-1)[0] || null, meLanded: !!S.meLanded, blockedAny: !!S.blockedAny, blockedBody: !!S.blockedBody, range: S.range }, S.tells === 2 ? 2 : 1); };   /* TELLS2: tells=2 is version 2 (DESIGN_TELLS2.md); a state file with tells true is version 1 */
if (cmd === 'help' || !cmd) {
  say('RING SWITCHES. Each beat: one switch for the LEAD hand, one for the REAR hand, one for the FEET, and the ORDER you throw them (first meets his first).');
  say(`Health ${N.hp}, stamina ${N.st} (+${N.rec} a beat, +${N.hold} for each hand held), ${N.rounds} rounds of ${N.beats} beats. Down at 0 health: up on ${N.kd.join(' then ')}; the next time it is over.`);
  say('LEAD hand: ' + R0.LO.filter((o) => o.lead).map((o) => o.lead).join(', ') + ' | or held: high, low.   REAR hand: ' + R0.RO.filter((o) => o.rear).map((o) => o.rear).join(', ') + ' | or held: high, low.');
  for (const id in ACT) { const a = ACT[id]; say(`  ${id}: ${a.n}, ${a.st} stamina${a.d ? `, ${a.d} health, ${SP[a.sp]}, reaches ${a.reach.map((r) => RNG[r]).join(' and ')}, line: ${a.line}${a.body ? ', shortens his stamina bar' : ''}` : `. ${a.t || ''}`}`); }
  say(`A HELD hand blocks one line: lead high = ${COVER.high[0]}, lead low = ${COVER.low[0]}, rear high = ${COVER.high[1]}, rear low = ${COVER.low[1]}. A punching hand is out of its guard only in the moment it punches.`);
  for (const id in FEET) say(`  feet=${id}: ${FEET[id].n}, ${FEET[id].st} stamina. ${FEET[id].t}`);
  say('clinch: Inside only, 1 stamina, no punch lands, +2 stamina, the referee breaks you at Mid; not twice running.');
  say(`POINTS: 2 for a big punch landed (3 health or more on its line above), 1 for a small one, 3 for a knockdown; a counter adds health, not points. A body hook or body cross that lands shortens his stamina bar by 1 FOR THE REST OF THE BOUT (never under ${N.capMin}). The third knockdown ends the bout whatever the cards say.`);
  say('In one moment the faster punch lands first; a big one (3 health or more) that lands stops his slower punch. A punch of his that misses or is blocked makes your later punches counters (+1). A round level on points goes to the man who backed off less.');
  // S558, from the all-agents playtest: five rules every player had to learn by losing to them
  say(`A hand that punches is held HIGH in the other moments of the beat: to guard low, that hand must stay home. A man who goes down throws nothing more that beat.`);
  say(`THE JUDGES: more points takes the round 10-9, and 10-8 when you are ${N.wide} points or more ahead. GUARD ${N.guard}: blocking a big punch costs the blocker 1 guard, 1 comes back each beat; at 0 the guard is broken and blocks nothing that beat.`);
  say('HE READS HABITS: throw the same plan in two of your last three punching beats and he may answer exactly that. A step in and a back off in the same moment: the step in wins, the range closes anyway.');
  say(`Opponents: ${R0.OPPS.slice(0, 3).map((o, i) => `${i} ${o.n} (health ${o.hp}): ${o.t}`).join(' | ')}`);
  process.exit(0); }
if (cmd === 'new') { const opp = Number(arg.opp || 0), seed = Number(arg.seed || 1);
  const S = { opp, seed, n: 0, round: 1, beat: 0, range: 3, cards: [], over: '', F: [R0.man(N.hp), R0.man(R0.OPPS[opp].hp)], tells: arg.tells === '2' ? 2 : arg.tells === '1' };
  if (S.tells) { S.tellRound = []; prepNext(S); }
  fs.writeFileSync(file, JSON.stringify(S)); fs.writeFileSync(file + '.log.txt', `A bout against ${R0.OPPS[opp].n}, seed ${seed}\n`); say(`A new bout against ${R0.OPPS[opp].n}.`);
  if (S.tells) say(`TELLS ARE ON IN THIS BOUT. Before each beat you see ONE thing his body does, from the beat he has already chosen: ${Object.keys(CUES).filter((c) => S.tells === 2 || c !== 'backfoot').map((c) => `"${CUES[c]}" = ${MEANS[c]}`).join('; ')}. A tell is usually true, but this man lies by one fixed rule you can learn: after each beat you are told whether his tell was true, and at each bell how often each tell lied.`);
  bars(S).forEach(say); process.exit(0); }
const S = JSON.parse(fs.readFileSync(file, 'utf8'));
if (cmd === 'show') { bars(S).forEach(say); if (S.over) say(S.over); process.exit(0); }
if (cmd !== 'beat') { console.log('unknown command: ' + cmd); process.exit(2); }
if (S.over) { say('The bout is over: ' + S.over); process.exit(0); }
const R = load(S.seed * 1000 + S.n); R.setOpp(S.opp); const me = S.F[0];
let mine = R.plan0();
if (rest.includes('clinch')) mine.clinch = true;
else { const L = arg.lead || 'high', H = arg.rear || 'high';
  if (L === 'high' || L === 'low') mine.hl = L; else mine.lead = L; if (H === 'high' || H === 'low') mine.hr = H; else mine.rear = H; mine.feet = arg.feet || 'hold';
  const acts = [...(mine.feet !== 'hold' ? ['feet'] : []), ...(mine.lead ? ['lead'] : []), ...(mine.rear ? ['rear'] : [])], want = (arg.order || '').split(',').filter((x) => acts.includes(x));
  mine.ord = [...want, ...acts.filter((x) => !want.includes(x))]; }
const bad = mine.clinch ? (S.range > 1 ? 'the clinch works Inside only' : me.held ? 'the referee will not allow a clinch yet' : me.st < 1 ? 'no stamina' : '')
  : (mine.lead && (!ACT[mine.lead] || ACT[mine.lead].h !== 0)) ? `lead=${mine.lead} is not a lead-hand switch` : (mine.rear && (!ACT[mine.rear] || ACT[mine.rear].h !== 1)) ? `rear=${mine.rear} is not a rear-hand switch`
  : !FEET[mine.feet] ? `feet=${mine.feet}: in, hold or back` : R.cost(mine) > me.st ? `that costs ${R.cost(mine)} stamina, you have ${me.st}` : mine.feet === 'back' && me.ropes >= 2 ? 'you are on the ropes: no backing off until you step in' : mine.feet === 'in' && me.kept ? 'kept out: no step in this beat' : '';
// ZIVAFIX1 (S557): a plan the stamina cannot pay is never just refused - the same plan without its dearest switch is offered, ready to send
if (bad && /^that costs/.test(bad)) { let p = { ...mine }; const price = (sl) => (sl === 'feet' ? FEET[p.feet].st : ACT[p[sl]].st), off = [];
  while (R.cost(p) > me.st) { const sl = ['lead', 'rear', 'feet'].filter((x) => (x === 'feet' ? p.feet !== 'hold' : p[x])).sort((a, b) => price(b) - price(a))[0]; off.push(sl === 'feet' ? FEET[p.feet].n : ACT[p[sl]].n); if (sl === 'feet') p.feet = 'hold'; else p[sl] = null; }
  const ord = (mine.ord || []).filter((x) => (x === 'feet' ? p.feet !== 'hold' : p[x]));
  console.log(`NOT PLAYED: ${bad}. Nothing is lost: the beat waits for a plan you can pay for.`);
  console.log(`YOU CAN PAY FOR IT WITHOUT ${off.join(' and ').toUpperCase()}: lead=${p.lead || p.hl} rear=${p.rear || p.hr} feet=${p.feet}${ord.length ? ' order=' + ord.join(',') : ''}   (${R.cost(p)} stamina)`); process.exit(2); }
if (bad) { console.log('NOT PLAYED: ' + bad); process.exit(2); }
const T = { f: S.F, range: S.range, t: N.beats - S.beat }, his = (S.tells && S.next) || R.ai(T) || R.plan0();
say(`--- round ${S.round}, beat ${S.beat + 1}, at ${RNG[S.range]}`); say(`YOU: ${R.planWords(mine)}`); say(`HE:  ${R.planWords(his)}`);
if (his.readOf) say(`HE READ YOU: your ${R.planWords(his.readOf)} - 2 of your last 3 beats - and he picked the best answer to it.`);   /* S563: the habit read is shown */
if (S.tells && S.tell) { const t = S.tell; say(t.fake ? `HIS TELL WAS A FAKE: he showed "${CUES[t.cue]}" - his beat would have shown "${CUES[t.truth]}".` : `HIS TELL WAS TRUE: "${CUES[t.cue]}".`); S.tellRound = [...(S.tellRound || []), t]; }
const ev = R.resolve(T, [{ ...mine }, { ...his }]); R.endBeat(T); S.range = T.range; S.n++; S.seen = [...(S.seen || []), his].slice(-3); S.seenRound = [...(S.seenRound || []), his];
S.blockedBody = ev.some((e) => e.k === 1 && e.t === 'block' && ACT[e.id] && ACT[e.id].line === 'body');
S.blockedAny = ev.some((e) => e.k === 1 && e.t === 'block'); S.meLanded = ev.some((e) => e.k === 0 && e.t === 'hit');
if (S.tells === 2 && S.tell && S.tell.fake) { S.F[1].st = Math.max(0, S.F[1].st - 1); say('  (his fake cost him 1 stamina)'); }   /* TELLS2: a bluff costs the liar */
for (const e of ev) say(`  ${e.m != null ? `moment ${e.m + 1} ` : ''}${e.k === 0 ? 'YOU' : e.k === 1 ? 'HE' : ''}: ${e.a || e.t}${e.o ? ' - ' + e.o : ''}`);
for (const k of [0, 1]) if (S.F[k].hp <= 0 && !S.over) { S.F[k].kd++; S.F[1 - k].pts += 3; if (S.F[k].kd > N.kd.length) S.over = k ? 'YOU WIN - the referee stops it' : 'HE WINS - the referee stops it'; else { S.F[k].hp = N.kd[S.F[k].kd - 1]; say(`  ${k ? 'HE GOES' : 'YOU GO'} DOWN and ${k ? 'gets' : 'get'} up on ${S.F[k].hp} health.`); } }
S.beat++;
if (!S.over && S.beat >= N.beats) { const [x, y] = S.F, gx = x.gave || 0, gy = y.gave || 0, { sc, onGround: onG } = R.judge(x, y);
  S.cards.push(sc); say(`BELL. The judges give the round ${sc[0]}-${sc[1]}${onG ? ` (level on points: it goes to the man who backed off less - you ${gx}, him ${gy})` : ''}.`);
  if (S.tells) { const l = ledger(S.tellRound || []); if (l) say(l); S.tellRound = []; }
  if (S.round >= N.rounds) { const t = [0, 1].map((k) => S.cards.reduce((s, c) => s + c[k], 0)); S.over = t[0] === t[1] ? `A DRAW ${t[0]}-${t[1]}` : `${t[0] > t[1] ? 'YOU WIN' : 'HE WINS'} on the cards ${t[0]}-${t[1]}`; }
  else { S.round++; S.beat = 0; S.range = 3; S.seenRound = []; for (const m of S.F) { m.pts = 0; m.st = m.cap; m.g = N.guard; m.ropes = 0; m.held = 0; m.kept = 0; m.gave = 0; } } }
if (S.tells && !S.over) prepNext(S); else { S.next = null; S.tell = null; }
if (S.over) say(S.over); else bars(S).forEach(say);
fs.writeFileSync(file, JSON.stringify(S)); fs.appendFileSync(file + '.log.txt', out.join('\n') + '\n');
