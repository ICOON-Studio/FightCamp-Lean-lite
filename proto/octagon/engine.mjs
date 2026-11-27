// OCTAGON TACTICS - boxing first (S570, TASK_OCTAGON1). The owner's design (ops/research/octagon/*.pdf), cut to the boxing
// cards + the Fight IQ cards, with the rule calls in docs/OCTAGON1_RULES.md. One card each an exchange, sealed, then both
// revealed: movement -> the triangle (Attack > Feint > Counter > Attack, Defend covers one zone) -> speed -> damage ->
// Initiative ("the Lead": +2 speed, combo chains). Three rounds of six exchanges. Pure: no DOM, no I/O.
export const RANGES = ['long', 'mid', 'close'];
// type A attack, C counter, F feint, D defend. legal = ranges it can be played from; pre/post = range steps (+1 closer).
export const CARDS = {
  jab:    { n: 'Step-In Jab', type: 'A', spd: 8, st: 2, legal: ['long'], pre: 1, zone: 'head', dmg: 2, chain: 1, straight: 1, t: 'Step in from Long to Mid and jab the head, 2 dmg. [Chain +1].' },
  cross:  { n: 'Cross', type: 'A', spd: 6, st: 3, legal: ['mid'], zone: 'head', dmg: 4, chain: 1, straight: 1, t: 'Straight right to the head, 4 dmg. Chained after a Jab: +1 dmg, +1 speed. [Chain +1].' },
  lhook:  { n: 'Lead Hook', type: 'A', spd: 6, st: 3, legal: ['mid', 'close'], zone: 'head', dmg: 4, hook: 1, t: 'Hook to the head, 4 dmg; +2 dmg if he threw a straight punch (Jab, Cross) this exchange.' },
  liver:  { n: 'Liver Shot', type: 'A', spd: 5, st: 3, legal: ['mid', 'close'], zone: 'body', dmg: 4, hook: 1, t: 'Left hook to the body, 4 dmg; on a hit his maximum stamina drops 2 for the fight.' },
  upper:  { n: 'Uppercut', type: 'A', spd: 5, st: 4, legal: ['close'], zone: 'head', dmg: 5, hook: 1, t: 'Close only: uppercut to the chin, 5 dmg.' },
  cage:   { n: 'Cut the Cage', type: 'A', spd: 7, st: 1, legal: ['long'], pre: 1, zone: null, dmg: 0, t: 'Walk him down from Long to Mid; if it is not countered his cage space drops 1 (toward the fence). No damage.' },
  slip:   { n: 'Slip & Cross', type: 'C', spd: 7, st: 3, legal: ['long', 'mid'], dmg: 5, answers: 'straight', t: 'Long or Mid. Answers a straight punch (Jab, Cross): his punch misses, your cross lands 5 dmg, you take the Lead. Anything else: you whiff (-2 stamina).' },
  checkh: { n: 'Check Hook', type: 'C', spd: 7, st: 2, legal: ['long', 'mid'], dmg: 3, answers: 'advancing', post: -1, t: 'Long or Mid. Answers a man stepping in (Step-In Jab, Cut the Cage): his attack misses, your hook lands 3 dmg, you take the Lead; then you pivot out to Long. Else: whiff.' },
  pullc:  { n: 'Pull Counter', type: 'C', spd: 8, st: 3, legal: ['mid'], dmg: 5, answers: 'hook', t: 'Mid. Answers a hook or uppercut (Lead Hook, Liver Shot, Uppercut): it misses, you land 5 dmg and take the Lead. Else: whiff.' },
  paw:    { n: 'Pawing Jab & Angle', type: 'F', spd: 8, st: 1, legal: ['long', 'mid'], post: -1, t: 'Feint. Beats a Counter: he whiffs and loses 3 stamina, you draw 1. Then you step out one range. Loses to an Attack.' },
  hmf:    { n: 'Head Movement Feint', type: 'F', spd: 7, st: 1, legal: ['mid', 'close'], t: 'Feint. Beats a Counter. If you are not hit, your next Attack this round gets +2 speed and +1 dmg. Loses to an Attack.' },
  read:   { n: 'Fight IQ: Read Tendency', type: 'F', spd: 9, st: 1, legal: ['long', 'mid', 'close'], t: 'Feint. You see his hand next exchange, he cannot repeat the card he just played, you draw 1. Beats a Counter, loses to an Attack.' },
  shell:  { n: 'High Shell Guard', type: 'D', spd: 9, st: 1, legal: ['long', 'mid', 'close'], covers: 'head', chip: 1, rec: 2, t: 'Defend the HEAD: a head attack does 1 chip dmg and you recover 2 stamina; a BODY attack lands in full. Playing Defend gives up the Lead.' },
  philly: { n: 'Philly Shell & Roll', type: 'D', spd: 8, st: 1, legal: ['mid', 'close'], covers: 'head', chip: 0, rec: 1, t: 'Defend the HEAD: head attacks do nothing, you recover 1 stamina; a BODY attack lands in full. Gives up the Lead.' },
  circle: { n: 'Circle Out & Reset', type: 'D', spd: 8, st: 1, legal: ['mid', 'close'], covers: 'half', rec: 2, post: -1, t: 'Defend: an attack does half dmg (rounded down); +2 stamina, +1 cage space, the Lead goes neutral, you step out one range.' },
  cover:  { n: 'Cover Up', type: 'D', spd: 9, st: 0, legal: ['long', 'mid', 'close'], covers: 'head', chip: 0, rec: 0, virtual: 1, t: 'Rocked only (v2): hands up, chin down - head attacks do nothing; no stamina back. Always in reach, never in your deck.' },
  wind:   { n: 'Second Wind', type: 'D', spd: 5, st: 0, legal: ['long'], covers: 'none', rec: 6, t: 'Long only. Recover 6 stamina and draw 2 - but you block nothing this exchange.' },
};
export const PROFILES = {
  out: { n: 'Out-Fighter', head: 14, body: 14, st: 18, reach: 2, reflex: 8, cardio: 5, rocked: 4,
    trait: 'Sniper footwork: cards that step out cost 1 less stamina; +1 speed at Long. Reflexes 8: +1 counter dmg.',
    deck: { jab: 3, cross: 2, lhook: 1, liver: 1, checkh: 2, slip: 2, pullc: 1, paw: 2, hmf: 1, shell: 1, circle: 2, wind: 1, read: 1 } },
  press: { n: 'Pressure Boxer', head: 16, body: 15, st: 16, reach: 1, reflex: 6, cardio: 4, rocked: 5,
    trait: 'Iron chin: rocked only at 5+ head dmg in one exchange. Hooks (Lead Hook, Liver Shot, Uppercut) +1 dmg.',
    deck: { jab: 1, cross: 2, lhook: 3, liver: 2, upper: 2, slip: 1, pullc: 1, hmf: 2, shell: 1, philly: 1, cage: 2, wind: 1, read: 1 } },
};
export const ROUNDS = 3, EXCHANGES = 6, HAND = 5;
export const TUNE = { hp: 1.5, hook: 1, lead: 2, cover: 0, readCards: 0, styleSpeed: 0, stack: 1 };   // v2 switches (S570 cup findings): lead +1, cover=1 a rocked man can always Cover Up, readCards=2, styleSpeed=1 (no reach tie-break; Pressure +1 speed at Close), stack=0 (stepping in together stops at Mid)   // S570 balance knobs: health scale, the Pressure Boxer's hook bonus
function rng(s) { let x = s >>> 0 || 1; return () => { x ^= x << 13; x >>>= 0; x ^= x >> 17; x ^= x << 5; x >>>= 0; return x / 4294967296; }; }
const shuffle = (a, r) => { for (let i = a.length - 1; i > 0; i--) { const j = Math.floor(r() * (i + 1)); [a[i], a[j]] = [a[j], a[i]]; } return a; };
export function newBout(seed = 1, profA = 'out', profB = 'press', names = ['A', 'B']) {
  const S = { seed, n: 0, round: 1, ex: 1, range: 'mid', init: -1, over: null, cards: [[0, 0], [0, 0]], log: [], score: [0, 0], roundDmg: [0, 0], roundCtr: [0, 0], rs: seed * 7919 + 13 };
  S.f = [profA, profB].map((p, k) => { const P = PROFILES[p], deck = Object.entries(P.deck).flatMap(([id, n]) => Array(n).fill(id));
    const H = Math.round(P.head * TUNE.hp), Bd = Math.round(P.body * TUNE.hp);
    return { name: names[k], prof: p, head: H, headMax: H, body: Bd, bodyMax: Bd, st: P.st, stMax: P.st, cage: 2, deck, hand: [], disc: [], rocked: 0, ban: null, sees: 0, buff: 0, bodyTaken: 0 }; });
  const r = rng(S.rs); S.f.forEach((F) => shuffle(F.deck, r)); S.rs = Math.floor(r() * 1e9); S.f.forEach((F) => draw(S, F, HAND)); return S;
}
function draw(S, F, n) { const r = rng(S.rs); for (let i = 0; i < n && F.hand.length < HAND + 2; i++) { if (!F.deck.length) { if (!F.disc.length) break; F.deck = shuffle(F.disc, r); F.disc = []; F.st = Math.max(0, F.st - 2); } F.hand.push(F.deck.pop()); } S.rs = Math.floor(r() * 1e9); }
export const cost = (S, k, id) => { const c = CARDS[id], F = S.f[k]; return Math.max(0, c.st - (F.prof === 'out' && c.post === -1 ? 1 : 0)); };
// why a card cannot be played now ('' = legal)
export function why(S, k, id) { const c = CARDS[id], F = S.f[k];
  if (!c) return 'no such card'; if (id === 'cover') return TUNE.cover && F.rocked ? '' : 'Cover Up is only for a ROCKED man (v2 rules)'; if (!F.hand.includes(id)) return 'not in your hand'; if (!c.legal.includes(S.range)) return `not playable at ${S.range} (only ${c.legal.join(' / ')})`;
  if (cost(S, k, id) > F.st) return `needs ${cost(S, k, id)} stamina, you have ${F.st}`; if (F.ban === id) return 'banned this exchange (he read your tendency)';
  if (F.rocked && !['C', 'D'].includes(c.type)) return 'you are ROCKED: only a Counter or a Defend this exchange'; if (c.post === -1 && F.cage <= 0 && c.type !== 'D') return 'your back is on the fence: you cannot step out'; return ''; }
export const legalCards = (S, k) => [...new Set(S.f[k].hand), ...(TUNE.cover && S.f[k].rocked ? ['cover'] : [])].filter((id) => !why(S, k, id));
// plan: { card, then: [ids] (a combo, only while you hold the Lead), react: id (a Counter or Defend kept for his combo) } or { card: 'none' }
export function play(S, plans) {
  if (S.over) return []; const ev = [], say = (k, t) => ev.push({ k, t }), F = S.f, P = plans.map((p) => ({ card: p.card || 'none', then: (p.then || []).slice(0, 2), react: p.react || null }));
  const initAtStart = S.init; S.n++;
  for (const k of [0, 1]) { const id = P[k].card; if (id !== 'none' && !CARDS[id].virtual) { F[k].st -= cost(S, k, id); F[k].hand.splice(F[k].hand.indexOf(id), 1); F[k].disc.push(id); S.cards[k][0]++; } F[k].ban = null; }
  for (const k of [0, 1]) say(k, P[k].card === 'none' ? 'plays nothing' : `plays ${CARDS[P[k].card].n}`);
  // 1) pre-moves: opposite cancel, the same stack
  let mv = 0; for (const k of [0, 1]) { const c = CARDS[P[k].card]; if (c && c.pre) mv += c.pre; }
  if (!TUNE.stack) mv = Math.max(-1, Math.min(1, mv));
  if (mv) { const i0 = RANGES.indexOf(S.range); S.range = RANGES[Math.max(0, Math.min(2, i0 + mv))]; say(-1, `range: ${RANGES[i0]} -> ${S.range}`); }
  const card = (k) => CARDS[P[k].card] || { type: 'N' }, atk = [0, 1].map((k) => card(k).type === 'A'), inRange = (k) => { const c = card(k); return c.type === 'N' || (c.pre ? true : c.legal.includes(S.range)); };
  const hits = [0, 0], dmgTo = [0, 0], head = [0, 0], lead = [S.init === 0, S.init === 1];
  const speed = (k, c, extra = 0) => c.spd + (lead[k] ? TUNE.lead : 0) + (F[k].prof === 'out' && S.range === 'long' ? 1 : 0) + (TUNE.styleSpeed && F[k].prof === 'press' && S.range === 'close' ? 1 : 0) + (F[k].buff ? 2 : 0) + extra;
  const hurt = (k, zone, d, why) => { if (d <= 0) return 0; const v = 1 - k; if (zone === 'body') { F[v].body -= d; F[v].bodyTaken += d; while (F[v].bodyTaken >= 5) { F[v].bodyTaken -= 5; F[v].stMax = Math.max(4, F[v].stMax - 2); F[v].st = Math.min(F[v].st, F[v].stMax); say(v, 'body damage: maximum stamina -2'); } } else { F[v].head -= d; head[v] += d; }
    dmgTo[v] += d; S.roundDmg[k] += d; say(k, `lands ${d} to the ${zone}${why ? ' (' + why + ')' : ''}`); return d; };
  const answers = (c, a) => (c.answers === 'straight' && a.straight) || (c.answers === 'hook' && a.hook) || (c.answers === 'advancing' && !!a.pre);
  const attackDmg = (k, a, other, chained, prev) => { let d = a.dmg + (F[k].buff ? 1 : 0); if (a.hook && F[k].prof === 'press') d += TUNE.hook; if (P[k].card === 'lhook' && other && other.straight && !chained) d += 2; if (chained && prev === 'jab' && a === CARDS.cross) d += 1; if (F[1 - k].cage <= 0) d += 1; return d; };
  const onHit = (k, id) => { const a = CARDS[id]; if (id === 'liver') { F[1 - k].stMax = Math.max(4, F[1 - k].stMax - 2); F[1 - k].st = Math.min(F[1 - k].st, F[1 - k].stMax); say(1 - k, 'liver shot: maximum stamina -2'); } if (id === 'cage') { F[1 - k].cage = Math.max(0, F[1 - k].cage - 1); say(1 - k, `pushed toward the fence: cage space ${F[1 - k].cage}`); } if (a.zone) F[k].buff = 0; };
  // 2) the triangle
  const t = [card(0).type, card(1).type];
  const strike = (k, why) => { const a = card(k); if (!inRange(k)) { say(k, `${a.n} is out of range at ${S.range}`); return false; } hurt(k, a.zone || 'head', a.zone ? attackDmg(k, a, card(1 - k)) : 0, why); if (!a.zone) say(k, `${a.n}: no damage`); onHit(k, P[k].card); hits[k] = 1; return true; };
  const counterWins = (c, a) => answers(card(c), card(a)) && inRange(c);
  const whiff = (k) => { F[k].st = Math.max(0, F[k].st - 2); say(k, `${card(k).n} whiffs: -2 stamina`); };
  let winner = -1;
  if (t[0] === 'A' && t[1] === 'A') { const s = [speed(0, card(0)), speed(1, card(1))];
    if (s[0] === s[1] && !TUNE.styleSpeed) { const tb = [F[0], F[1]].map((x) => PROFILES[x.prof]); for (const key of ['reach', 'reflex']) if (tb[0][key] !== tb[1][key]) { s[tb[0][key] > tb[1][key] ? 0 : 1] += 0.5; break; } }
    if (s[0] === s[1]) { say(-1, 'same speed: they trade'); strike(0); strike(1); } else { const w = s[0] > s[1] ? 0 : 1; say(-1, `${F[w].name} is faster (${s[w]} v ${s[1 - w]})`); if (strike(w, 'beats him to it')) winner = w; else strike(1 - w); } }
  else for (const [k, v] of [[0, 1], [1, 0]]) {
    if (t[k] === 'A' && t[v] === 'C') { if (counterWins(v, k)) { say(v, `${card(v).n} reads the ${card(k).n}: it misses`); hurt(v, 'head', card(v).dmg + (PROFILES[F[v].prof].reflex >= 8 ? 1 : 0), 'counter'); S.roundCtr[v]++; winner = v; } else { whiff(v); if (strike(k)) winner = k; } }
    if (t[k] === 'A' && t[v] === 'F') { if (strike(k, 'caught him faking')) winner = k; }
    if (t[k] === 'A' && t[v] === 'D') { const d = card(v), a = card(k); if (!inRange(k)) say(k, `${a.n} is out of range at ${S.range}`);
      else if (d.covers === 'head' && a.zone === 'head') { if (d.chip) hurt(k, 'head', d.chip, 'chip through the guard'); else say(v, `${d.n} takes the ${a.n}`); say(v, 'blocked - the Lead is stripped'); S.init = -1; }
      else if (d.covers === 'half' && a.zone) { hurt(k, a.zone, Math.floor(attackDmg(k, a, d) / 2), 'half through the circle-out'); onHit(k, P[k].card); }
      else { strike(k, a.zone === 'body' && d.covers === 'head' ? 'to the body, under the guard' : 'nothing covered it'); winner = k; } }
    if (t[k] === 'A' && t[v] === 'N') { if (strike(k)) winner = k; }
    if (t[k] === 'C' && t[v] === 'F') { whiff(k); const f = card(v); if (P[v].card === 'paw') { F[k].st = Math.max(0, F[k].st - 3); say(k, 'baited: -3 stamina more'); draw(S, F[v], 1); } else if (P[v].card === 'read') draw(S, F[v], 1); winner = v; say(v, `${f.n} baits the counter`); }
    if (t[k] === 'C' && (t[v] === 'D' || t[v] === 'C' || t[v] === 'N')) { if (k === 0 || t[v] !== 'C') say(k, `${card(k).n}: nothing to counter`); }
  }
  if (t[0] === 'F' && t[1] === 'F') { draw(S, F[0], 1); draw(S, F[1], 1); S.init = -1; say(-1, 'feint battle: both draw 1, the Lead is neutral'); }
  if (t[0] === 'D' && t[1] === 'D') { S.init = -1; say(-1, 'both reset: the Lead is neutral'); }
  // 3) Defend recovers; Feint effects; Read Tendency
  for (const k of [0, 1]) { const c = card(k);
    if (c.type === 'D') { if (P[k].card === 'wind') draw(S, F[k], 2); F[k].st = Math.min(F[k].stMax, F[k].st + c.rec); say(k, `recovers ${c.rec} stamina`); if (P[k].card === 'circle') { F[k].cage = Math.min(3, F[k].cage + 1); S.init = -1; } if (S.init === k) S.init = -1; }
    if (c.type === 'F' && !dmgTo[k]) { if (P[k].card === 'hmf') { F[k].buff = 1; say(k, 'next Attack this round: +2 speed, +1 dmg'); } if (P[k].card === 'read') { F[k].sees = 2; F[k].seen = TUNE.readCards ? [...F[1 - k].hand].sort(() => 0.5 - ((S.n * 9301 + 49297) % 233280) / 233280).slice(0, TUNE.readCards) : null; F[1 - k].ban = P[1 - k].card !== 'none' ? P[1 - k].card : null; draw(S, F[k], 1); say(k, `reads him: sees his hand, he cannot repeat ${P[1 - k].card !== 'none' ? CARDS[P[1 - k].card].n : 'it'}`); } } }
  if (winner >= 0) { if (S.init !== winner) say(winner, 'takes the Lead'); S.init = winner; }
  // 4) combo burst: the Lead held at the start, a [Chain] first card that connected
  for (const k of [0, 1]) { if (initAtStart !== k || winner !== k || !card(k).chain || !P[k].then.length) continue; let prev = P[k].card, react = P[1 - k].react && F[1 - k].hand.includes(P[1 - k].react) ? P[1 - k].react : null;
    for (let j = 0; j < P[k].then.length; j++) { const id = P[k].then[j], a = CARDS[id], c = cost(S, k, id) + 1;
      if (!a || a.type !== 'A' || !F[k].hand.includes(id) || !a.legal.includes(S.range) || c > F[k].st || F[1 - k].head <= 0 || F[1 - k].body <= 0) { say(k, `combo stops before ${a ? a.n : id}`); break; }
      F[k].st -= c; F[k].hand.splice(F[k].hand.indexOf(id), 1); F[k].disc.push(id); S.cards[k][1]++; say(k, `COMBO: ${a.n} (+1 speed, +1 stamina)`);
      if (react) { const r = CARDS[react]; F[1 - k].hand.splice(F[1 - k].hand.indexOf(react), 1); F[1 - k].disc.push(react); F[1 - k].st = Math.max(0, F[1 - k].st - cost(S, 1 - k, react)); react = null; say(1 - k, `reacts: ${r.n}`);
        if (r.type === 'C' && answers(r, a) && r.legal.includes(S.range)) { hurt(1 - k, 'head', r.dmg, 'countered the combo'); S.roundCtr[1 - k]++; S.init = 1 - k; break; }
        if (r.type === 'D' && r.covers === 'head' && a.zone === 'head') { if (r.chip) hurt(k, 'head', r.chip, 'chip'); say(1 - k, 'blocks the combo, the Lead is stripped'); S.init = -1; break; }
        if (r.type === 'C') { F[1 - k].st = Math.max(0, F[1 - k].st - 2); say(1 - k, 'reaction whiffs: -2 stamina'); } }
      const d = attackDmg(k, a, null, true, prev) + (j === 1 ? 2 : 0); hurt(k, a.zone || 'head', a.zone ? d : 0, j === 1 ? 'FINISHER +2' : 'combo'); onHit(k, id); prev = id; } }
  // 5) post-moves (cage space), rocked, KO
  let post = 0; for (const k of [0, 1]) { const c = card(k); if (c.post && (c.type !== 'F' || !dmgTo[k]) && (c.type !== 'C' || winner === k)) { if (F[k].cage > 0 || c.type === 'D') { post += c.post; if (c.type !== 'D') F[k].cage = Math.max(0, F[k].cage - 1); } } }
  if (post) { const i0 = RANGES.indexOf(S.range); S.range = RANGES[Math.max(0, Math.min(2, i0 + post))]; if (S.range !== RANGES[i0]) say(-1, `range: ${RANGES[i0]} -> ${S.range}`); }
  for (const k of [0, 1]) { F[k].rocked = 0; if (head[k] >= PROFILES[F[k].prof].rocked && F[k].head > 0) { F[k].rocked = 1; S.init = 1 - k; say(k, `ROCKED (${head[k]} to the head): only Counter or Defend next exchange; he has the Lead`); } }
  for (const k of [0, 1]) if (F[k].head <= 0 || F[k].body <= 0) { S.over = { winner: 1 - k, how: F[k].head <= 0 ? 'KO' : 'TKO (body)', round: S.round, ex: S.ex }; say(-1, `${F[1 - k].name} WINS by ${S.over.how}`); }
  for (const k of [0, 1]) if (F[k].sees) F[k].sees--;
  S.log.push({ round: S.round, ex: S.ex, plays: P.map((p) => p.card), lines: ev });
  if (!S.over) endExchange(S, ev); return ev;
}
function endExchange(S, ev) { const F = S.f;
  if (++S.ex > EXCHANGES) { const d = [0, 1].map((k) => S.roundDmg[k] + S.roundCtr[k]); let p = [10, 10];
    if (d[0] !== d[1]) { const w = d[0] > d[1] ? 0 : 1; p[1 - w] = d[w] - d[1 - w] >= 8 ? 8 : 9; }
    S.score[0] += p[0]; S.score[1] += p[1]; ev.push({ k: -1, t: `END OF ROUND ${S.round}: judges ${p[0]}-${p[1]} (damage + clean counters ${d[0]} v ${d[1]}); total ${S.score[0]}-${S.score[1]}` });
    S.roundDmg = [0, 0]; S.roundCtr = [0, 0];
    if (S.round >= ROUNDS) { const w = S.score[0] === S.score[1] ? -1 : S.score[0] > S.score[1] ? 0 : 1; S.over = { winner: w, how: w < 0 ? 'DRAW' : 'DECISION', score: [...S.score] }; ev.push({ k: -1, t: w < 0 ? `DRAW ${S.score[0]}-${S.score[1]}` : `${F[w].name} WINS on points ${S.score[w]}-${S.score[1 - w]}` }); return; }
    S.round++; S.ex = 1; S.range = 'long'; S.init = -1; for (const f of F) { f.st = Math.min(f.stMax, f.st + PROFILES[f.prof].cardio); f.rocked = 0; f.buff = 0; f.cage = Math.max(f.cage, 2); } ev.push({ k: -1, t: `ROUND ${S.round}: back to Long, the Lead neutral, stamina +${PROFILES[F[0].prof].cardio} / +${PROFILES[F[1].prof].cardio}` }); }
  for (const f of F) draw(S, f, HAND - f.hand.length);
}
// how one fighter sees the bout (never the other's hand unless he read it)
export function view(S, k) { const F = S.f[k], O = S.f[1 - k], card = (id) => `${id} = ${CARDS[id].n} [${CARDS[id].type === 'A' ? 'ATTACK' : CARDS[id].type === 'C' ? 'COUNTER' : CARDS[id].type === 'F' ? 'FEINT' : 'DEFEND'}, speed ${CARDS[id].spd}, cost ${cost(S, k, id)}] ${CARDS[id].t}${why(S, k, id) ? ' -- CANNOT NOW: ' + why(S, k, id) : ''}`;
  const L = [`ROUND ${S.round} of ${ROUNDS}, exchange ${S.ex} of ${EXCHANGES}. Range: ${S.range.toUpperCase()}. The Lead: ${S.init < 0 ? 'neutral' : S.init === k ? `YOU (+${TUNE.lead} speed on attacks; a [Chain] card that connects can combo)` : `HIM (+${TUNE.lead} speed on his attacks)`}. Judges so far: you ${S.score[k]} - him ${S.score[1 - k]}.`,
    `YOU (${PROFILES[F.prof].n}): head ${F.head}/${F.headMax}, body ${F.body}/${F.bodyMax}, stamina ${F.st}/${F.stMax}, cage space ${F.cage}/3${F.rocked ? ', ROCKED' : ''}${F.buff ? ', next attack +2 speed +1 dmg' : ''}. Trait: ${PROFILES[F.prof].trait}`,
    `HIM (${O.name}, ${PROFILES[O.prof].n}): head ${O.head}/${O.headMax}, body ${O.body}/${O.bodyMax}, stamina ${O.st}/${O.stMax}, cage space ${O.cage}/3${O.rocked ? ', ROCKED' : ''}, cards in hand ${O.hand.length}${F.sees ? (F.seen ? ' - YOU READ PART OF HIS HAND: ' + F.seen.join(', ') : ' - YOU READ HIS HAND: ' + O.hand.join(', ')) : ''}. Trait: ${PROFILES[O.prof].trait}`,
    'YOUR HAND:', ...[...new Set(F.hand), ...(TUNE.cover && F.rocked ? ['cover'] : [])].map((id) => `  ${F.hand.filter((x) => x === id).length > 1 ? F.hand.filter((x) => x === id).length + 'x ' : ''}${card(id)}`)];
  const last = S.log[S.log.length - 1]; if (last) L.splice(1, 0, `LAST EXCHANGE (round ${last.round}, exchange ${last.ex}): ` + last.lines.map((e) => (e.k < 0 ? '' : e.k === k ? 'You ' : 'He ') + e.t).join('; '));
  return L.join('\n'); }
