// one bout turn by turn: node diag.mjs boxing karate [seed]
import { fighter } from './cards.mjs';
import { bout, posKey } from './engine.mjs';
import { aiPilot } from './plan.mjs';
const [a = 'boxing', b = 'karate', seed = 1] = process.argv.slice(2), AI = aiPilot();
const r = bout(fighter(a), fighter(b), [AI, AI], +seed, {
  onAnswer: (S, k, ans) => console.log(`  ${S.f[k].name} answers [${S.inc.map((p) => p.id).join(' ')}] with ${ans ? ans.id + '@' + ans.i : '-'}`),
  onAct: (S, k, seq) => console.log(`r${S.round + 1}t${S.turn + 1} ${S.f[k].name.padEnd(9)} at ${posKey(S, k)} hp ${S.f[k].hp} pts ${S.f[k].pts} wind ${S.f[k].wind} hand [${S.f[k].hand.join(' ')}] -> ${seq.join(' ') || '(nothing)'}`),
});
console.log(r.win === 0 ? a : b, 'wins by', r.how, '| hp', r.S.f.map((f) => f.hp), 'pts', r.S.f.map((f) => f.pts), 'dealt', r.S.f.map((f) => f.dealt));
