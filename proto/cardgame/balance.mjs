// FightCamp card game - balance harness.
//   node proto/cardgame/balance.mjs [bouts]
// Plays AI-vs-AI bouts (different boxers every time, never two identical ones),
// then prints: win share per style pair, how often each card is played and its
// win rate when played, and the share of bouts decided early by stoppage.
// Exit code 1 if a card breaks the design limits (a card that wins more than
// 65% of the time it is played, or one that is effectively never played).
import rules from './rules.js';

const N = Number(process.argv[2]) || 2000;
const CARDS = rules.CARDS, ORDER = rules.CARD_ORDER;
const stats = {
  bouts: 0, stoppage: 0, decision: 0, draws: 0, roundsStopped: [0, 0, 0, 0],
  exchanges: 0, knockdowns: 0
};
const stylePair = new Map();
const card = {};
for (const id of ORDER) card[id] = { plays: 0, wins: 0, dmg: 0 };

function bump(pair, key) { if (!pair[key]) pair[key] = { bouts: 0, wins: 0, losses: 0, draws: 0 }; pair[key].bouts++; pair[key][key === '' ? 'wins' : arguments[2]]++; }

for (let i = 0; i < N; i++) {
  const seed = rules.hashSeed('balance', i);
  const a = rules.BOXERS[i % rules.BOXERS.length];
  let b = rules.BOXERS[(rules.hashSeed('pair', i) >>> 0) % rules.BOXERS.length];
  if (b.id === a.id) b = rules.BOXERS[(rules.BOXERS.indexOf(b) + 1 + (i % 3)) % rules.BOXERS.length];
  if (b.id === a.id) continue; // never two identical boxers

  // both corners get the camp the AI would run for its own boxer: this table is
  // about style against style, not about who was prepared and who was not
  const { fight } = rules.simulateAiBout({ seed, playerBoxerId: a.id, opponentBoxerId: b.id, opponentCamp: true });
  stats.bouts++;
  const res = fight.result;

  const key = a.style + ' v ' + b.style;
  if (!stylePair.has(key)) stylePair.set(key, { bouts: 0, wins: 0, losses: 0, draws: 0 });
  const sp = stylePair.get(key);
  sp.bouts++;
  if (res.winner === 'player') sp.wins++;
  else if (res.winner === 'opponent') sp.losses++;
  else sp.draws++;

  if (res.method === 'stoppage') { stats.stoppage++; stats.roundsStopped[res.round] = (stats.roundsStopped[res.round] || 0) + 1; }
  else stats.decision++;
  if (res.winner === 'draw') stats.draws++;

  for (const ev of fight.events) {
    stats.exchanges++;
    stats.knockdowns += ev.knockdowns.length;
    const pWon = ev.player.dealt > ev.opponent.dealt;
    const oWon = ev.opponent.dealt > ev.player.dealt;
    card[ev.player.card].plays++; card[ev.player.card].dmg += ev.player.dealt;
    card[ev.opponent.card].plays++; card[ev.opponent.card].dmg += ev.opponent.dealt;
    if (pWon) card[ev.player.card].wins++;
    if (oWon) card[ev.opponent.card].wins++;
  }
}

function pct(n, d) { return d ? (100 * n / d).toFixed(1) + '%' : '-'; }
function pad(s, n) { s = String(s); return s.length >= n ? s : s + ' '.repeat(n - s.length); }
function lpad(s, n) { s = String(s); return s.length >= n ? s : ' '.repeat(n - s.length) + s; }

console.log('FightCamp card game - balance: ' + stats.bouts + ' AI-vs-AI boxing bouts');
console.log('');

console.log('Style pairs (left corner v right corner)');
console.log('  ' + pad('pair', 24) + lpad('bouts', 7) + lpad('left wins', 11) + lpad('right wins', 12) + lpad('draws', 8));
const pairs = [...stylePair.entries()].sort((x, y) => x[0] < y[0] ? -1 : 1);
for (const [key, s] of pairs) {
  console.log('  ' + pad(key, 24) + lpad(s.bouts, 7) + lpad(pct(s.wins, s.bouts), 11) + lpad(pct(s.losses, s.bouts), 12) + lpad(pct(s.draws, s.bouts), 8));
}

console.log('');
console.log('Cards: how often played (share of all exchanges, both corners) and win rate when played');
console.log('  ' + pad('card', 18) + pad('kind', 10) + lpad('plays', 8) + lpad('share', 9) + lpad('win when played', 16) + lpad('avg dmg', 9));
const defects = [];
for (const id of ORDER) {
  const c = card[id], plays = c.plays, share = stats.exchanges ? plays / stats.exchanges : 0;
  const winRate = plays ? c.wins / plays : 0;
  console.log('  ' + pad(CARDS[id].name, 18) + pad(rules.KIND_LABEL[CARDS[id].kind], 10) +
    lpad(plays, 8) + lpad(pct(plays, stats.exchanges), 9) + lpad(pct(c.wins, plays), 16) + lpad((plays ? c.dmg / plays : 0).toFixed(1), 9));
  if (plays && winRate > 0.65) defects.push(CARDS[id].name + ' wins ' + pct(c.wins, plays) + ' of the time it is played (limit 65%)');
  if (share < 0.01) defects.push(CARDS[id].name + ' is barely ever played (' + pct(plays, stats.exchanges) + ' of exchanges)');
}

console.log('');
console.log('How the bouts end');
console.log('  ' + pad('stoppage', 22) + lpad(stats.stoppage, 6) + lpad(pct(stats.stoppage, stats.bouts), 9) +
  '   (round 1: ' + (stats.roundsStopped[1] || 0) + ', round 2: ' + (stats.roundsStopped[2] || 0) +
  ', round 3: ' + (stats.roundsStopped[3] || 0) + ')');
console.log('  ' + pad('on the cards', 22) + lpad(stats.decision, 6) + lpad(pct(stats.decision, stats.bouts), 9));
console.log('  ' + pad('draws', 22) + lpad(stats.draws, 6) + lpad(pct(stats.draws, stats.bouts), 9));
console.log('  ' + pad('knockdowns / bout', 22) + lpad((stats.knockdowns / stats.bouts).toFixed(2), 6));
console.log('  ' + pad('exchanges / bout', 22) + lpad((stats.exchanges / stats.bouts).toFixed(1), 6));
console.log('');
if (defects.length) {
  for (const d of defects) console.log('DEFECT: ' + d);
  console.log('RESULT: FAIL - ' + defects.length + ' design defect(s) above');
  process.exit(1);
} else {
  console.log('RESULT: PASS - no card over 65% win-when-played, no card under 1% of exchanges played');
}
