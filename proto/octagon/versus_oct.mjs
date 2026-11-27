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
if (a.v2 === '1' || file === 'v2=1' || (file && fs.existsSync(file) && cmd !== 'new' && JSON.parse(fs.readFileSync(file, 'utf8')).v2)) useV2();   /* S570 v2: the cup's fixes */
const V2HELP = `
V2 RULES (after the first cup): STEP IN (step) and COVER UP (cover) are always in your hand - Step In: one range closer, 1 stamina, no damage, an Attack (a Check Hook answers it); Cover Up: head guard, 0 stamina. You get 1 stamina back every exchange. Add discard=<id> to throw one card away and draw one. The Lead gives +1 speed. Read Tendency shows 2 of his cards. A Liver Shot cuts his stamina cap once.`;
if (cmd === 'help' || !cmd) { console.log(HELP + (a.v2 === '1' || file === 'v2=1' ? V2HELP : '')); process.exit(0); }
const load = () => JSON.parse(fs.readFileSync(file, 'utf8')), save = (B) => fs.writeFileSync(file, JSON.stringify(B));
if (cmd === 'new') { const S = newBout(+(a.seed || 1), a.pa || 'out', a.pb || 'press', [a.a || 'A', a.b || 'B']); save({ S, sealed: [null, null], n: 0, over: null, v2: a.v2 === '1' ? 1 : 0 }); fs.writeFileSync(file + '.log.txt', `${a.a || 'A'} (${PROFILES[a.pa || 'out'].n}) v ${a.b || 'B'} (${PROFILES[a.pb || 'press'].n}), seed ${a.seed || 1}\n`); console.log('NEW BOUT'); process.exit(0); }
const B = load(), k = a.who === 'b' ? 1 : 0;
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
