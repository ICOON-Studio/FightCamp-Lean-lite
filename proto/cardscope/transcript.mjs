// Prints one bout beat by beat: node proto/cardscope/transcript.mjs [seed] [player 0-3] [opponent 0-3] [tier]
import { NAME, PLAYERS, OPPONENTS } from './cards.mjs';
import { playBout } from './bout.mjs';
import { readerBot } from './bots.mjs';
const [seed, pi, oi, tier] = [2, 3, 4, 5].map((i, k) => Number(process.argv[i] ?? [7, 0, 1, 3][k]));
const t = [];
const st = playBout(PLAYERS[pi], OPPONENTS[oi], readerBot({ seed }), { seed, tier, transcript: t });
console.log(`Bout: ${PLAYERS[pi].style} (you) v ${OPPONENTS[oi].style}, class ${tier}, seed ${seed}`);
for (const e of t) {
  console.log(`R${e.round}.${e.exchange}  he lays: ${e.him.map((c, i) => (e.hidden[i] ? '[' + NAME[c] + ']' : NAME[c])).join(' | ')}   you: ${e.you.map((c) => NAME[c]).join(' | ')}`);
  for (const b of e.beats) console.log(`    beat ${b.beat}: you take ${b.toA}, he takes ${b.toB}${b.counterA ? ' (your counter)' : ''}${b.counterB ? ' (his counter)' : ''}`);
}
console.log(st.method === 'stop' ? `Stopped in round ${st.stopRound}: ${st.win ? 'you win' : 'he wins'}` : `Cards ${st.cards.map((c) => c.join('-')).join(', ')}: ${st.win ? 'you win' : 'he wins'}`);
console.log(`head taken: you ${st.headP}, he ${st.headO}; knockdowns scored: you ${st.kdP}, he ${st.kdO}`);
