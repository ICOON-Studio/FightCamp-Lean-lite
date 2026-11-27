// VERSUS for Octagon Tactics, boxing first (S570, TASK_OCTAGON1): one bout between TWO players, each card sealed before the
// other's is seen; when both are sealed the exchange is played. Same shape as proto/twohands/tools/versus.mjs, so
// ops/Tools/versus_by_message.mjs (game=octagon) can drive chat seats with it.
//   node proto/octagon/versus_oct.mjs new  <state.json> a=<name> b=<name> [seed=1] [pa=out|press] [pb=out|press]
//   node proto/octagon/versus_oct.mjs show <state.json> who=a|b
//   node proto/octagon/versus_oct.mjs plan <state.json> who=a|b card=<id>|none [then=<id>,<id>] [react=<id>]
//   node proto/octagon/versus_oct.mjs help
// Every exchange is appended to <state.json>.log.txt.
import fs from 'node:fs';
import { newBout, play, view, why, CARDS, PROFILES, ROUNDS, EXCHANGES, useV2 } from './engine.mjs';
import { useV3 } from './cards_v3.mjs';
import { useV4 } from './fighters_v4.mjs';
const [cmd, file, ...rest] = process.argv.slice(2), a = Object.fromEntries(rest.filter((x) => x.includes('=')).map((x) => x.split('=')));
export const HELP = `OCTAGON TACTICS (boxing) - ${ROUNDS} rounds of ${EXCHANGES} exchanges. Each exchange you both pick ONE card from your hand, sealed; then both are shown.
ORDER: movement (cards that step in or out; opposite steps cancel) -> the TRIANGLE -> speed -> damage -> the Lead.
THE TRIANGLE: ATTACK beats FEINT (you hit him while he fakes). FEINT beats COUNTER (he swings at air: -2 stamina, more for some feints).
COUNTER beats ATTACK - but only the attacks its card names (Slip & Cross: straight punches; Pull Counter: hooks and uppercuts; Check Hook: a man stepping in); against any other attack the counter whiffs and the attack lands.
DEFEND covers ONE zone: High Shell and Philly Shell stop HEAD attacks only - a BODY attack (Liver Shot) goes under them. Circle Out halves any attack. Second Wind blocks nothing. A Defend recovers stamina but gives up the Lead.
ATTACK v ATTACK: the faster card lands and cancels the slower (same speed: reach, then reflexes; still the same: both land).
THE LEAD (Initiative): win an exchange (land an Attack, land a Counter, bait a Counter with a Feint) and you hold it: +2 speed on your attacks, and a [Chain +1] card that connects lets you COMBO: add then=<id>[,<id>] - up to two more Attacks the same exchange, each +1 speed and +1 stamina; the 3rd card is a FINISHER (+2 dmg). You lose the Lead when your attack is blocked or countered, when you play a Defend, or at the end of the round.
AGAINST HIS COMBO: add react=<id> - a Counter or Defend card from your hand, used only if he combos.
DAMAGE: head and body health; 0 in either = KO / TKO. Every 5 body damage = -2 maximum stamina for the fight. 4+ head damage in one exchange (Pressure Boxer: 5+) = ROCKED: next exchange only a Counter or a Defend, and he gets the Lead.
STAMINA: a card costs its stamina when played; no stamina back between exchanges except Defend cards and Second Wind; between rounds your cardio comes back. CAGE SPACE: stepping out costs 1 cage space; at 0 your back is on the fence - you cannot step out and his attacks do +1.
NO KO: each round the judges score 10-9 for more damage + clean counters (10-8 for 8 or more ahead); most points after 3 rounds wins.
FIGHTERS: ${Object.values(PROFILES).map((p) => `${p.n} (head ${p.head}, body ${p.body}, stamina ${p.st}; ${p.trait})`).join(' | ')}`;
const saved = file && fs.existsSync(file) && cmd !== 'new' && !/=/.test(file) ? JSON.parse(fs.readFileSync(file, 'utf8')) : {};
if (a.v4 === '1' || file === 'v4=1' || saved.v4) useV4(); else if (a.v3 === '1' || file === 'v3=1' || saved.v3) useV3(); else if (a.v2 === '1' || file === 'v2=1' || saved.v2) useV2();   /* S570 v2: the cup's fixes */
const V2HELP = `
V2/V3 RULES: COVER UP (cover) is in your hand only while you are ROCKED (it halves the damage). If no card in your hand can be played, your hand is swapped for a fresh one. Add discard=<id> to throw one card away and draw one. The Lead gives +1 speed. Read shows 2 of his cards. Speed ties go to reach (the Out-Fighter), then reflexes.`;
if (cmd === 'help' || !cmd) { console.log(HELP + (a.v2 === '1' || file === 'v2=1' || a.v3 === '1' || file === 'v3=1' || a.v4 === '1' || file === 'v4=1' ? V2HELP : '') + (a.v3 === '1' || file === 'v3=1' || a.v4 === '1' || file === 'v4=1' ? ' V3: the cards are the boxing + Fight IQ cards of the 52-card database; Cut the Cage is a FEINT (it beats a Counter, a Check Hook included); a combo goes on after your first card is BLOCKED too (it only has to connect); two counters against each other: the quicker takes the Lead, the slower loses 1 stamina; between rounds each fighter gets 3 head health back.' : '') + (a.v4 === '1' || file === 'v4=1' ? ' V4 STAMINA (S571): a man under 3 stamina who plays neither an Attack nor a Feint gets 1 stamina back that exchange. Your hand is swapped for a fresh one only when the RANGE rules out every card in it (short of stamina, you keep your cards and wait), and that swap costs no stamina. V4.2: a man rocked last exchange can be hurt but not rocked again the next one; a punch pushes a man back only out of Close; when a jab (2 damage or less) is faster than a power punch, both land - the jab first, the power punch 2 less; RANGE JAB (feel) is always there at Long: Attack, speed 8 for everyone (no bonuses), 1 stamina, 1 to the head, no step in. V4.3: a jab that is faster than a man STEPPING IN with a power punch halves that punch (both land). Your hand shows each card at its real speed now (NOW), with every bonus; the top line says who wins a speed tie. V4.4: ELBOWS DOWN (elbows) is in every deck - a free Defend at Mid or Close that blocks a BODY attack (+1 stamina), the head goes over it; HOLD GROUND at Long parries a jab of 2 damage or less that does not step in (no damage, his Lead is gone); a round won by 12 or more scores 10-7. V4.5: a COUNTER adds half your power bonus (rounded down); CLINCH & HOLD (tieup) is there only when you are ROCKED - no damage that exchange, 3 stamina, he takes the Lead; Read Tendencies and the other speed boosts give +1 speed next exchange (not +2); every fighter has a quarter more health. V4.6: a RANGE JAB meets a man stepping in from Long - it lands before the range changes (and, faster, halves his punch); a counter baited by a feint costs 1 more stamina at most (3 in all).' : '')); process.exit(0); }
const load = () => JSON.parse(fs.readFileSync(file, 'utf8')), save = (B) => fs.writeFileSync(file, JSON.stringify(B));
if (cmd === 'new') { const S = newBout(+(a.seed || 1), a.pa || 'out', a.pb || 'press', [a.a || 'A', a.b || 'B']); save({ S, sealed: [null, null], n: 0, over: null, v2: a.v2 === '1' ? 1 : 0, v3: a.v3 === '1' ? 1 : 0, v4: a.v4 === '1' ? 1 : 0 }); fs.writeFileSync(file + '.log.txt', `${a.a || 'A'} (${PROFILES[a.pa || 'out'].n}) v ${a.b || 'B'} (${PROFILES[a.pb || 'press'].n}), seed ${a.seed || 1}\n`); console.log('NEW BOUT'); process.exit(0); }
const B = load(), k = a.who === 'b' ? 1 : 0;
/* S570: v3 cards carry ids like liver3 / slip3; a player who types the plain name (liver, slip, lhook, cross, read,
   pullc, checkh, circle, cage, upper) gets the card he holds - three refused plans had cost Kalli, Maria and John a turn */
const ALIAS = { liver: 'liver3', slip: 'slip3', lhook: 'lhook3', cross: 'cross3', read: 'read3', pullc: 'pull3', pull: 'pull3', checkh: 'check3', check: 'check3', circle: 'circle3', cage: 'cutc', upper: 'upper3', uppercut: 'upper3', hook: 'lhook3', guard: 'guard', shell: 'guard', breath: 'breath', wind: 'breath' };
const fix = (id) => { if (!id || id === 'none') return id; const h = B.S.f[k].hand; if (h.includes(id) || CARDS[id] && CARDS[id].virtual) return id; const al = ALIAS[id]; return al && (h.includes(al) || (CARDS[al] && CARDS[al].virtual)) ? al : id; };
for (const key of ['card', 'react', 'discard']) if (a[key]) a[key] = fix(a[key].toLowerCase().trim());
if (a.then) a.then = a.then.split(',').map((x) => fix(x.trim().toLowerCase())).join(',');
if (cmd === 'show') { console.log(B.over ? `THE BOUT IS OVER: ${B.over}` : view(B.S, k) + (B.sealed[k] ? '\n(your card for this exchange is sealed; waiting for him)' : '')); process.exit(0); }
if (cmd === 'plan') { if (B.over) { console.log('the bout is over'); process.exit(1); }
  const card = (a.card || '').toLowerCase().trim(), then = (a.then || '').split(',').map((x) => x.trim().toLowerCase()).filter(Boolean), react = (a.react || '').toLowerCase().trim() || null; const discard = (a.discard || '').toLowerCase().trim() || null;
  if (card !== 'none') { const w = why(B.S, k, card); if (w) { console.log(`REFUSED: ${card}: ${w}. Legal now: ${[...new Set(B.S.f[k].hand)].filter((id) => !why(B.S, k, id)).join(', ') || 'none (play card=none)'}`); process.exit(1); } }
  if (react && (!CARDS[react] || !['C', 'D'].includes(CARDS[react].type) || !B.S.f[k].hand.includes(react))) { console.log(`REFUSED: react=${react} must be a Counter or Defend card in your hand`); process.exit(1); }
  B.sealed[k] = { card, then, react, discard }; B.n = B.S.n;
  if (B.sealed[0] && B.sealed[1]) { const ev = play(B.S, B.sealed), S = B.S, nm = (x) => (x < 0 ? '' : S.f[x].name + ' ');
    fs.appendFileSync(file + '.log.txt', `R${S.log[S.log.length - 1].round} E${S.log[S.log.length - 1].ex}: ` + ev.map((e) => nm(e.k) + e.t).join('; ') + '\n');
    B.sealed = [null, null]; B.n = S.n; if (S.over) B.over = S.over.winner < 0 ? `DRAW ${S.over.score.join('-')}` : `${S.f[S.over.winner].name} wins by ${S.over.how}${S.over.score ? ' ' + Math.max(...S.over.score) + '-' + Math.min(...S.over.score) : ` in round ${S.over.round}`}`;
    if (B.over) fs.appendFileSync(file + '.log.txt', 'RESULT: ' + B.over + '\n'); }
  save(B); console.log('SEALED'); process.exit(0); }
console.log('unknown command'); process.exit(2);
