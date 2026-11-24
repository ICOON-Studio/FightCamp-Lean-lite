// ROUND 9 (TASK_CARDROUND9): the bout desk - newBout, the round and turn loop, and the verdict. Split out of engine.mjs
// when the round-9 model pushed that file past the owner's 500-line limit; the rules themselves (declared, answered,
// resolved) live in engine.mjs as before. Same actions, same numbers, same seeds: the desk walks the turns and the
// engine decides each of them.
import { CARDS, N } from './cards.mjs';
import { newFighter, rng, beginTurn, answerOptions, doAnswer, startAct, declare, endAct, canAct, placeKey, cost, canPay, legalNow, groundStep, GUARD_KINDS, PAST_KINDS } from './engine.mjs';

export function newBout(F0, F1, seed) {
  const r = rng(seed);
  return { f: [newFighter(F0, r), newFighter(F1, r)], at: ['stand', 'stand'], j: { kind: 'apart', reach: 'K' }, inc: [], hold: null, tie: null, stall: 0, pass: 0, gpass: -1, gby: -1, gnp: [0, 0], idle: [0, 0], ctx: { prev: false, combo: 0 }, over: null, r, pj: null, round: 0, turn: 0, timid: [0, 0],
    st: { vis: 1, whiff: 0, stuffed: 0, downs: 0, holdOn: 0, holdDone: 0, escaped: 0, letGo: 0, refUps: 0, combos: 0, dec: [0, 0], turns: [0, 0], cards: [0, 0], quiet: [0, 0], choices: 0, steps: 0, maxCh: 0, held: [0, 0], secs: [0, 0], played: [{}, {}], log: [[], []], downTurns: [0, 0], refLog: [], warn: [], timid: 0, timidPts: 0, sits: 0, pulls: 0, sprawled: 0, upkicks: 0, riseHits: 0, sweeps: 0, rises: 0, bellEnds: 0 } };
}
// agents[k] = { answer(S,k,opts) -> {id,i}|null, act(S,k) -> [ids] }
export function bout(F0, F1, agents, seed, opt = {}) {
  const S = newBout(F0, F1, seed), st = S.st;
  let first = opt.first ?? (S.r() < 0.5 ? 0 : 1);
  const turn = (k, bell, noAct) => {
    beginTurn(S, k, bell);
    const opts = S.inc.length || (S.hold && S.hold.by !== k) ? answerOptions(S, k) : [null];
    const ans = opts.length > 1 ? agents[k].answer(S, k, opts) : null;
    if (opts.length > 1) st.dec[k]++;
    if (opt.onAnswer) opt.onAnswer(S, k, ans, opts);
    doAnswer(S, k, ans);
    if (bell || noAct || !canAct(S)) return;
    st.turns[k]++; startAct(S);
    const seq = agents[k].act(S, k).slice();
    if (opt.onAct) opt.onAct(S, k, seq);
    const at = [];
    for (const id of seq) {
      at.push(placeKey(S.pj, k));
      if (!canAct(S)) break;
      // a pilot that names a card it cannot lay (not in hand, not legal where it stands) does not crash the bout: the
      // card is not laid, exactly as a card whose moment has gone never resolves. The rules decide, never the pilot.
      if (id[0] !== '@' && !S.f[k].hand.includes(id)) continue;
      if (!legalNow(S.pj, k, id) || !canPay(S.f[k], cost(S, k, id))) continue;
      declare(S, k, id);
      if (id[0] !== '@') st.played[k][id] = 1;
    }
    st.dec[k] += seq.length + 1; st.cards[k] += seq.length; if (!seq.length) st.quiet[k]++;
    st.log[k].push({ pos: placeKey(S, k), at, kinds: seq.map((id) => (CARDS[id] ? CARDS[id].k : 'move')), kk: seq.map((id) => (CARDS[id]?.kick ? 'kick' : null)), ans: ans ? 1 : 0 });
    endAct(S, k);
    if (S.at[k] !== 'stand') st.downTurns[k]++;
  };
  for (let rd = 0; rd < N.rounds && !S.over; rd++) {
    S.round = rd; S.at = ['stand', 'stand']; S.j = { kind: 'apart', reach: 'K' }; S.inc = []; S.tie = null; S.hold = null; S.stall = 0; S.timid = [0, 0]; S.gnp = [0, 0]; S.idle = [0, 0];
    if (rd) for (const B of S.f) B.wind = Math.min(N.cap, B.wind + N.stool);
    for (let t = 0; t < N.turns && !S.over; t++) { S.turn = t; for (const k of [first, 1 - first]) if (!S.over) turn(k, false); }
    if (!S.over && S.inc.length) turn(first, true);
    if (S.hold) { st.bellEnds++; S.hold = null; } // the bell ends the round and any hold (rule 9, audit 2d)
    first = 1 - first;
  }
  const [A, B] = S.f; let win, how;
  if (S.over) ({ win, how } = S.over);
  else {
    const sa = (N.clkPts ? A.pts : 0) + A.dealt / N.dmgPer, sb = (N.clkPts ? B.pts : 0) + B.dealt / N.dmgPer;
    win = sa !== sb ? (sa > sb ? 0 : 1) : A.hp !== B.hp ? (A.hp > B.hp ? 0 : 1) : S.r() < 0.5 ? 0 : 1; how = 'cards';
  }
  return { win, how, early: !!S.over, st, S };
}
export { groundStep, GUARD_KINDS, PAST_KINDS };
