// S574 the card game on a page (owner: "yes put the card game on the board"). The bout flow with no page in it, so a
// node test plays the same code the page plays: you (corner 0) against the cup's reader bot (corner 1), on the same
// engine and rules the cup bouts use (useV6 + pure / lite, exactly as versus_oct.mjs sets them).
import { newBout, play, view, why, cost, legalCards, CARDS, PROFILES, TUNE, ROUNDS, EXCHANGES, RANGES } from './engine.mjs';
import { useV6 } from './cards_v6.mjs';
import { POOL, STYLES } from './fighters_v4.mjs';
export { CARDS, PROFILES, TUNE, ROUNDS, EXCHANGES, RANGES, POOL, STYLES };

export const VERSIONS = {
  ours: { label: 'Ours (v6.9)', opt: {} },
  lite: { label: 'Yours + the fewest fixes (lite)', opt: { lite: 1 } },
  pure: { label: 'Yours as written (v2.7)', opt: { pure: 1 } },
};
export const TYPE = { A: 'Attack', C: 'Counter', F: 'Feint', D: 'Defend' };
let rulesOn = null;
export function setRules(v) { if (rulesOn) return rulesOn; useV6(VERSIONS[v] ? VERSIONS[v].opt : {}); rulesOn = VERSIONS[v] ? v : 'ours'; return rulesOn; }   // once per page load: the rules change the engine's tables

/* the cup's reader bot (pool_sim.mjs reader): answers what you played most in your last three cards, guards when tired,
   hits a rocked man; with his tell he plays against your colour */
const ANSWER = { A: 'C', F: 'A', C: 'F' };
function bot(G, hint) { const S = G.S, k = 1, r = G.r, pick = (a) => a[Math.floor(r() * a.length)];
  const L0 = legalCards(S, k), L = L0.filter((id) => id !== 'hold').length ? L0.filter((id) => id !== 'hold') : L0; if (!L.length) return { card: 'none' };
  const his = S.log.slice(-3).map((e) => e.plays[0]).filter((id) => id !== 'none' && CARDS[id]).map((id) => CARDS[id].type), cnt = { A: 0, C: 0, F: 0, D: 0 }; his.forEach((t) => cnt[t]++);
  const likely = Object.keys(cnt).sort((x, y) => cnt[y] - cnt[x])[0]; let want = likely === 'D' ? 'F' : ANSWER[likely] || 'A';
  if (S.f[0].rocked) want = 'A'; if (S.f[k].st <= 3) want = 'D'; if (hint) want = hint === 'AC' ? 'D' : r() < 0.5 ? 'A' : 'F';
  const opts = L.filter((id) => CARDS[id].type === want && id !== 'hold'), c = opts.length ? pick(opts) : pick(L);
  const chain = S.init === k && CARDS[c] && CARDS[c].chain ? (() => { const h = [...S.f[k].hand]; h.splice(h.indexOf(c), 1); return h.filter((id) => CARDS[id].type === 'A').slice(0, 2); })() : [];
  return { card: c, then: chain, react: S.f[k].hand.find((id) => ['C', 'D'].includes(CARDS[id].type)) || null, discard: S.f[k].hand.find((id) => id !== c && why(S, k, id)) || null }; }
const colourOf = (id) => (!CARDS[id] ? '' : ['A', 'C'].includes(CARDS[id].type) ? 'AC' : 'FD');
const tellOn = (G, x) => G.S.f[x].tellAt === G.S.n + 1;

export function newGame({ seed = 1, me = 'metronome', him = 'truck' } = {}) {
  let s = (seed * 2654435761) >>> 0 || 1; const r = () => { s ^= s << 13; s >>>= 0; s ^= s >> 17; s ^= s << 5; s >>>= 0; return s / 4294967296; };
  const short = (id) => ((/"([^"]+)"/.exec(POOL[id] ? POOL[id].n : '') || [])[1] || id).replace(/^The /, '');
  const G = { S: newBout(seed, me, him, ['You', 'He']), r, seed, me, him, short: [short(me), short(him)], pre: null, last: [], log: [] }; ready(G); return G; }
function ready(G) { G.pre = !G.S.over && tellOn(G, 0) ? bot(G) : null; }   // your tell: he seals first, you see his colour

/* what the page shows this exchange */
/* S575 (owner: "why is speed so much important to put the number for it so big and damage not so important and i can barely see the damage numbers?"):
   the damage a card does NOW, with this fighter's power - the same sum as engine.mjs attackDmg before the exchange's own extras (combo, after-a-jab, the Lead) */
const dmgNow = (S, k, c) => { if (!c || !c.dmg) return 0; const F = S.f[k], Pk = PROFILES[F.prof] || {}; let d = c.dmg + (F.buff ? 1 : 0); if (c.hook && F.prof === 'press') d += TUNE.hook;
  d += Pk.attr && TUNE.jabNoPower && c.straight && c.dmg <= 2 ? (Pk.punch || 0) : TUNE.powHalf ? Math.ceil((Pk.dmgBonus || 0) / 2) : Pk.dmgBonus || 0; if (Pk.attr && Pk.attr.reach >= 7 && c.pre && c.straight) d += 1; if (S.f[1 - k].cage <= 0) d += 1; return Math.max(0, d); };
export function table(G) { const S = G.S, F = S.f[0], O = S.f[1], txt = view(S, 0), now = {};
  for (const m of txt.matchAll(/^ {2}(?:\d+x )?(\w+) = .*?speed (\d+)(?: \(NOW (\d+)\))?/gm)) now[m[1]] = +(m[3] || m[2]);
  const st = /STATUS - YOU: (.*?)\. HIM: (.*?)(?: - HIS CUT SHOWS YOU: \w+)?\.$/m.exec(txt);
  const ids = [...new Set([...F.hand, ...legalCards(S, 0).filter((id) => CARDS[id] && CARDS[id].virtual), ...(CARDS.stance && TUNE.stance ? ['stance'] : [])])];
  const hand = ids.filter((id) => CARDS[id]).map((id) => ({ ...CARDS[id], code: CARDS[id].id, id, count: F.hand.filter((x) => x === id).length, always: !!CARDS[id].virtual, now: now[id] ?? CARDS[id].spd, dmgNow: dmgNow(S, 0, CARDS[id]), cost: cost(S, 0, id), why: why(S, 0, id) || '' }));
  const side = (X) => ({ name: PROFILES[X.prof].n, style: STYLES[POOL[X.prof] ? POOL[X.prof].style : 'out'] ? STYLES[POOL[X.prof].style].n : '', trait: PROFILES[X.prof].trait || '', head: X.head, headMax: X.headMax, body: X.body, bodyMax: X.bodyMax, st: X.st, stMax: X.stMax, cage: X.cage, rocked: !!X.rocked, cards: X.hand.length });
  return { round: S.round, ex: S.ex, rounds: ROUNDS, exchanges: EXCHANGES, range: S.range, lead: S.init < 0 ? 'none' : S.init === 0 ? 'you' : 'him',
    judges: [S.score[0], S.score[1]], thisRound: [S.roundDmg[0] + S.roundCtr[0], S.roundDmg[1] + S.roundCtr[1]], you: side(F), him: side(O),
    statusYou: st && st[1] !== 'none' ? st[1] : '', statusHim: st && st[2] !== 'none' ? st[2] : '',
    cutShows: TUNE.status && O.cut && O.hand.length && (!TUNE.cutOnce || S.ex === 1) ? O.hand[S.n % O.hand.length] : '',
    readHand: F.sees ? (F.seen || O.hand) : null, hisLast: S.log.slice(-3).reverse().map((e) => e.plays[1]).filter((id) => CARDS[id]),
    tellYou: G.pre ? colourOf(G.pre.card) : '', tellHim: !G.pre && tellOn(G, 1), hand, last: G.last, over: G.over || null, comboOk: S.init === 0 }; }

/* your plan: card + up to 2 combo cards (with the Lead) + the card kept for his combo + one dead card swapped */
export function autoKeep(G, card) { return G.S.f[0].hand.find((id) => id !== card && ['C', 'D'].includes(CARDS[id].type)) || null; }
export function autoSwap(G, card) { return G.S.f[0].hand.find((id) => id !== card && why(G.S, 0, id)) || null; }
export function throwCard(G, plan) { const S = G.S; if (G.over) return { error: 'the bout is over' };
  const card = plan.card || 'none'; if (card !== 'none') { const w = why(S, 0, card); if (w) return { error: w }; }
  const me = { card, then: (plan.then || []).slice(0, 2), react: plan.react === undefined ? autoKeep(G, card) : plan.react, discard: plan.discard === undefined ? autoSwap(G, card) : plan.discard };
  const him = G.pre || bot(G, tellOn(G, 1) ? colourOf(card) || 'FD' : null), round = S.round, ex = S.ex;
  const ev = play(S, [me, him]); G.last = ev.filter((e) => !/^plays /.test(e.t)).map((e) => ({ k: e.k, who: e.k < 0 ? '' : G.short[e.k], t: e.t }));
  G.log.push({ round, ex, you: card, him: him.card, lines: G.last });
  if (S.over) G.over = { winner: S.over.winner < 0 ? 'draw' : S.over.winner === 0 ? 'you' : 'him', how: S.over.how || '', score: S.over.score || null, round: S.over.round || round };
  ready(G); return { you: card, him: him.card, lines: G.last }; }
