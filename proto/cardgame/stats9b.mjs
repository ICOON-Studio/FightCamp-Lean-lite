// ROUND 9b: 400 bot bouts boxing v jiu-jitsu, seats alternated, with how they end and how often each no-card move is used.
// node stats9b.mjs [name=value ...] sets a number of N for this run (baseOn=1, baseW=4, kdDmg=99 ...).
import { CARDS, N, fighter } from './cards.mjs';
import { bout } from './engine.mjs';
import { aiPilot } from './plan.mjs';
for (const kv of process.argv.slice(2)) { const [k, v] = kv.split('='); N[k] = +v; }
const n = 400, r = { box: 0, how: {}, kds: 0, ans: {}, acts: {}, sits: 0, holdOn: 0, escaped: 0, hpB: 0, s2: { topPunches: 0, pulls: 0, posts: 0, legHolds: 0, catches: 0, bentTurns: 0, guardTopTurns: 0, standInGuardTurns: 0 } };
for (let i = 0; i < n; i++) { const sw = i % 2, bj = sw ? 0 : 1, F = sw ? [fighter('bjj'), fighter('boxing')] : [fighter('boxing'), fighter('bjj')];
  const b = bout(F[0], F[1], [aiPilot(), aiPilot()], 500000000 + 7919 * i, {
    onAnswer(S, k, a) { if (a && a.id[0] === '@') { const key = (k === bj ? 'bjj ' : 'box ') + a.id; r.ans[key] = (r.ans[key] || 0) + 1; } },
    onAct(S, k, seq) { if (S.at[k] === 'gtop') { r.s2.guardTopTurns++; if (S.post === k) r.s2.bentTurns++; } if (S.at[k] === 'stand' && S.at[1 - k] === 'gbot') r.s2.standInGuardTurns++; for (const id of seq) if (id[0] === '@' || id === 'tieup') { const key = (k === bj ? 'bjj ' : 'box ') + id; r.acts[key] = (r.acts[key] || 0) + 1; } } });
  const w = b.win === bj ? 'bjj' : 'box'; r.box += w === 'box'; r.how[w + ':' + b.how] = (r.how[w + ':' + b.how] || 0) + 1; r.kds += b.st.kds || 0; r.sits += b.st.sits || 0; r.holdOn += b.st.holdOn; r.escaped += b.st.escaped; r.hpB += b.S.f[1 - bj].hp; for (const k of ['pulls', 'posts', 'legHolds', 'catches', 'topPunches']) r.s2[k] += b.st[k] || 0; }
console.log('boxing', (100 * r.box / n).toFixed(1) + '%', JSON.stringify(r.how), 'kds/bout', (r.kds / n).toFixed(2), 'holds laid/bout', (r.holdOn / n).toFixed(2), 'boxer hp end', (r.hpB / n).toFixed(1));
console.log('answers', JSON.stringify(r.ans)); console.log('acts', JSON.stringify(r.acts));
console.log('slice 2', JSON.stringify(r.s2)); // posture, the legs, the arm taken off a punch: how often the bots meet and use them
