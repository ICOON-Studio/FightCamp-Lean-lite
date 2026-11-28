// S575 STATUS WARNINGS (owner: "Make sure there are clear warnings when status effects happen , more will be added with each
// style"). ONE table: each status effect the rules can put on a fighter, how the page spots it, and the warning it shows in
// that fighter's panel (never near the fighters). A new style adds its effects HERE - nothing else on the page changes.
//   line:  a log line of the rules (proto/octagon/engine.mjs say(...)); the line's k is the man it happens to
//   state: (now, before) => true when a state starts (for effects the rules keep but do not log)
//   sev:   red = he loses something big now, amber = a lasting cost, blue = position
//   title / says: short words (owner S545: little text); says may use the line's match
export const STATUS_FX = [
  { id: 'rocked', sev: 'red', title: 'ROCKED', says: () => 'next exchange: only a Counter or a Defend', line: /^ROCKED/ },
  { id: 'stag', sev: 'amber', title: 'STAGGERED', says: () => 'legs gone: -1 speed, no step in next exchange', line: /is STAGGERED/ },
  { id: 'cut', sev: 'red', title: 'CUT OVER THE EYE', says: () => 'one card of the hand is shown each round', line: /is CUT over the eye/ },
  { id: 'cutw', sev: 'red', title: (m) => `CUT WIDER ${m[1]} / ${m[2]}`, says: (m) => (+m[2] - +m[1] <= 1 ? 'one more and the doctor stops it' : `the doctor stops it at ${m[2]}`), line: /cut opens wider \(cut (\d+) of (\d+)/ },
  { id: 'liver', sev: 'amber', title: 'LIVER SHOT', says: () => 'maximum stamina -2', line: /liver shot: maximum stamina/ },
  { id: 'body', sev: 'amber', title: 'BODY DAMAGE', says: () => 'maximum stamina -2', line: /body damage: maximum stamina/ },
  { id: 'worn', sev: 'amber', title: 'WORN DOWN', says: (m) => `maximum stamina -${m[1]}`, line: /his maximum stamina -(\d+)/ },
  { id: 'drain', sev: 'amber', title: 'DRAINED', says: (m) => `-${m[1]} stamina from the body shot`, line: /drains him: -(\d+) stamina/ },
  { id: 'winded', sev: 'amber', title: 'WINDED', says: () => 'body at half: guards give 1 less back', state: (P, Q) => P.body <= P.bodyMax / 2 && !(Q.body <= Q.bodyMax / 2) },
  { id: 'ropes', sev: 'blue', title: 'ON THE ROPES', says: () => 'no stepping out; punches land +1', state: (P, Q) => P.cage <= 0 && Q.cage > 0 },
  { id: 'spent', sev: 'amber', title: 'SPENT', says: () => 'under 3 stamina', state: (P, Q) => P.st < 3 && Q.st >= 3 },
];

/* the warnings one exchange raised: lines = the exchange's log ({k, t}), now / before = each man's {head, body, bodyMax, st, cage} */
export function warningsOf(lines, now, before) { const out = [[], []];
  for (const e of lines) { if (e.k !== 0 && e.k !== 1) continue;
    for (const fx of STATUS_FX) { if (!fx.line) continue; const m = fx.line.exec(e.t); if (m) out[e.k].push(make(fx, m)); } }
  for (const k of [0, 1]) for (const fx of STATUS_FX) if (fx.state && before && fx.state(now[k], before[k])) out[k].push(make(fx, []));
  return out; }
const make = (fx, m) => ({ id: fx.id, sev: fx.sev, title: typeof fx.title === 'function' ? fx.title(m) : fx.title, says: fx.says(m) });
