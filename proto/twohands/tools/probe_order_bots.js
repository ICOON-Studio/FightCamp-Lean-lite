const document={getElementById:()=>({})};

// RING SWITCHES (S551 toy). Owner: "what if put everything that the fighter can do in the fight as action toggable
// buttons like the jab,uppercut push,backoff,step in , guard low, guard up etc"; "holding a card can turn to a defence is
// reasonable , i like the idea". No decks, no timing: you set switches, both men act at once, the beat plays out.
// A feel test: every number is in N / ACT and is a first guess.
const N = { hp: 22, st: 8, rec: 1, hold: 1, guard: 6, grec: 1, rounds: 3, beats: 6, kd: [9, 7], counter: 1 };   // rec: stamina back a beat, + hold for each hand kept home
const RNG = { 1: 'Inside', 2: 'Mid', 3: 'Long' };
// a punch: which hand, stamina, health it takes, speed (1 first), the ranges it reaches, the line it travels on
const ACT = {
  jab: { n: 'Jab', h: 0, st: 1, d: 1, sp: 1, reach: [2, 3], line: 'straight', pic: 'jab' },
  hook: { n: 'Lead hook', h: 0, st: 2, d: 3, sp: 2, reach: [1, 2], line: 'side', pic: 'lead_hook' },
  lup: { n: 'Lead uppercut', h: 0, st: 3, d: 4, sp: 3, reach: [1], line: 'under', pic: 'lead_uppercut' },
  lbody: { n: 'Body hook', h: 0, st: 2, d: 2, sp: 2, reach: [1, 2], line: 'body', body: 1, pic: 'body_hook' },
  feint: { n: 'Feint', h: 0, st: 1, feint: 1, t: 'Draws his hands: your rear-hand punch this beat cannot be covered.' },
  push: { n: 'Push off', h: 0, st: 1, push: 1, t: 'Inside only: shoves him back to Mid before the punches. Breaks a clinch.' },
  cross: { n: 'Cross', h: 1, st: 2, d: 3, sp: 2, reach: [2], line: 'straight', pic: 'cross' },
  over: { n: 'Overhand', h: 1, st: 3, d: 4, sp: 3, reach: [1, 2], line: 'side', pic: 'rear_hook' },
  rup: { n: 'Rear uppercut', h: 1, st: 3, d: 4, sp: 3, reach: [1], line: 'under', pic: 'rear_uppercut' },
  rbody: { n: 'Body cross', h: 1, st: 2, d: 2, sp: 2, reach: [2], line: 'body', body: 1, pic: 'body_cross' },
};
const LINE = { straight: 'Head, straight', side: 'Head, from the side', under: 'Chin, from below', body: 'Body' };
const FEET = { in: { n: 'Step in', st: 1, t: 'One place closer.' }, hold: { n: 'Hold your ground', st: 0, t: 'Stay where you are.' }, back: { n: 'Back off', st: 1, t: 'One place further. At Long you are giving ground toward the ropes.' } };
// what a hand LEFT OFF covers: it depends on where the guard is held
const COVER = { high: ['straight', 'side'], low: ['body', 'under'] };   // [lead hand home, rear hand home]
const OPPS = [
  { n: 'The Jabber', t: 'Stays at Long behind the jab and backs off when you come in. Crosses when you stand at Mid.', hp: 20, read: 0.75 },
  { n: 'The Slugger', t: 'Walks in. Overhands and hooks at Mid, uppercuts Inside. Throws with both hands, so he leaves lines open.', hp: 26, read: 0.45 },
  { n: 'The Body Snatcher', t: 'Gets to Mid or Inside and digs to the body to shorten your stamina. Keeps a hand home.', hp: 22, read: 0.6 },
];
const $ = (id) => document.getElementById(id), rnd = Math.random, pickOne = (a) => a[Math.floor(rnd() * a.length)], clamp = (v, a, b) => Math.max(a, Math.min(b, v));
let F, P, oppI = 0, OPP = OPPS[0], round, beat, range, cards, phase = 'setup', mute = false, busy = false, popN = 0;
const plan0 = () => ({ lead: null, rear: null, hl: 'high', hr: 'high', feet: 'hold', clinch: false, ord: [] });   // lead / rear: a punch, or null = held where hl / hr says
const slotOf = (line) => (line === 'straight' || line === 'body' ? 'lead' : 'rear'), heightOf = (p, slot) => (slot === 'lead' ? p.hl : p.hr);
const LO = [{ lead: null, hl: 'high' }, { lead: null, hl: 'low' }, ...['jab', 'hook', 'lup', 'lbody', 'feint', 'push'].map((id) => ({ lead: id, hl: 'high' }))];
const RO = [{ rear: null, hr: 'high' }, { rear: null, hr: 'low' }, ...['cross', 'over', 'rup', 'rbody'].map((id) => ({ rear: id, hr: 'high' }))];
const man = (hp) => ({ hp, max: hp, st: N.st, cap: N.st, g: N.guard, pts: 0, kd: 0, ropes: 0, held: 0, last: null });
const snd = (n, v = 0.7) => { if (mute) return; try { const au = new Audio('snd/' + n + '.ogg'); au.volume = v; au.play().catch(() => {}); } catch (e) {} };
const pic = (n) => { $('pic').src = 'img/' + n + '.webp'; };
function pop(who, text, cls) { const el = $('pop' + who); el.textContent = text; el.className = 'pop p' + who + ' ' + cls; void el.offsetWidth; el.classList.add('go'); }
function jolt() { const st = $('stage'); st.classList.remove('shake'); void st.offsetWidth; st.classList.add('shake'); }
const cost = (p) => (p.lead ? ACT[p.lead].st : 0) + (p.rear ? ACT[p.rear].st : 0) + FEET[p.feet].st + (p.clinch ? 1 : 0);
// the lines a man's plan covers, and why a line is open
function covers(m, p) { const c = {}; if (m.g <= 0 || p.clinch) return c; if (!p.lead) c[COVER[p.hl][0]] = 1; if (!p.rear) c[COVER[p.hr][1]] = 1; return c; }
// the order a plan is thrown in: the slots that DO something (a hand that punches, feet that move), as the player set them
const active = (p, sl) => (sl === 'feet' ? p.feet !== 'hold' : !!p[sl]);
const ordOf = (p) => p.clinch ? [] : [...(p.ord || []).filter((sl) => active(p, sl)), ...['feet', 'lead', 'rear'].filter((sl) => active(p, sl) && !(p.ord || []).includes(sl))];
const actName = (p, sl) => (sl === 'feet' ? FEET[p.feet].n : ACT[p[sl]].n);
const planWords = (p) => !p ? 'nothing yet' : p.clinch ? 'clinch' : [ordOf(p).map((sl, i) => `${i + 1} ${actName(p, sl)}`).join(', ') || 'no action', [!p.lead && 'lead hand ' + p.hl, !p.rear && 'rear hand ' + p.hr].filter(Boolean).join(', ')].filter(Boolean).join(' - ');

// ---- one beat = THREE MOMENTS. In moment i each man does the i-th thing of his order (or nothing). A hand is out of
// its guard only in the moment it acts; the rest of the beat it is held where he holds it.
function resolve(S, P) { const ev = [], f = S.f, say = (k, o) => ev.push({ k, ...o });
  for (const k of [0, 1]) { P[k] = { ...P[k], ord: ordOf(P[k]) }; f[k].st -= cost(P[k]); f[k].last = { ...P[k] }; if (P[k].lead || P[k].rear) f[k].hist = [...(f[k].hist || []), { ...P[k] }].slice(-3); }
  const pusher = [0, 1].find((k) => P[k].lead === 'push' && !P[k].clinch), clincher = [0, 1].find((k) => P[k].clinch);
  if (clincher != null && (S.range > 2 || f[clincher].held)) { say(clincher, { t: 'flat', a: 'reaches to clinch', o: S.range > 2 ? 'too far away' : 'the referee will not allow two running' }); P[clincher] = { ...plan0(), hl: P[clincher].hl, hr: P[clincher].hr }; }
  else if (clincher != null && pusher === 1 - clincher) { say(clincher, { t: 'flat', a: 'tries to clinch', o: 'shoved off' }); P[clincher] = { ...plan0(), hl: P[clincher].hl, hr: P[clincher].hr }; }
  else if (clincher != null) { f[clincher].st = Math.min(f[clincher].cap, f[clincher].st + 3); f[clincher].held = 2; S.range = 2; say(clincher, { t: 'clinch', a: 'ties him up', o: 'no punch lands - the referee breaks them at Mid, +2 stamina' }); return ev; }
  const opening = [0, 0], drawn = [0, 0];
  for (let i = 0; i < 3; i++) { const act = [P[0].ord[i], P[1].ord[i]]; if (!act[0] && !act[1]) continue;
    let d = 0; for (const k of [0, 1]) if (act[k] === 'feet') { if (P[k].feet === 'in') { d--; f[k].ropes = 0; } else { d++; if (S.range === 3) f[k].ropes++; } }
    const r0 = S.range; S.range = clamp(S.range + d, 1, 3); const movers = [0, 1].filter((k) => act[k] === 'feet').map((k) => (k ? 'he ' : 'you ') + (P[k].feet === 'in' ? 'step' + (k ? 's' : '') + ' in' : 'back' + (k ? 's' : '') + ' off')).join(', ');
    if (movers) ev.push({ k: -1, m: i, t: 'range', a: S.range !== r0 ? `${RNG[r0]} to ${RNG[S.range]}` : `stays ${RNG[r0]}`, o: movers });
    for (const k of [0, 1]) if (act[k] === 'lead' && P[k].lead === 'push') { if (S.range === 1) { S.range = 2; say(k, { m: i, t: 'flat', a: 'pushes off', o: 'back to Mid' }); } else say(k, { m: i, t: 'flat', a: 'pushes', o: 'at nothing - he is not Inside' }); }
    for (const k of [0, 1]) if (act[k] === 'lead' && P[k].lead === 'feint') { drawn[k] = 2; say(k, { m: i, t: 'flat', a: 'feints', o: 'the next punch cannot be covered' }); }
    const shots = []; for (const k of [0, 1]) { const sl = act[k]; if ((sl === 'lead' || sl === 'rear') && ACT[P[k][sl]].d) shots.push({ k, id: P[k][sl], a: ACT[P[k][sl]] }); }
    shots.sort((x, y) => x.a.sp - y.a.sp);
    const cov = [0, 1].map((k) => { const c = {}; if (f[k].g <= 0) return c; if (act[k] !== 'lead') c[COVER[P[k].hl][0]] = 1; if (act[k] !== 'rear') c[COVER[P[k].hr][1]] = 1; return c; }), stun = [0, 0];
    for (let x = 0; x < shots.length;) { let y = x; while (y < shots.length && shots[y].a.sp === shots[x].a.sp) y++;
      const stunNow = [...stun], openNow = [...opening];
      for (const sh of shots.slice(x, y)) { const A = f[sh.k], D = f[1 - sh.k], a = sh.a, v = 1 - sh.k, sl = slotOf(a.line), wasDrawn = drawn[sh.k] === 1;
        if (stunNow[sh.k]) { say(sh.k, { m: i, t: 'flat', id: sh.id, a: a.n, o: 'beaten to the punch - never thrown' }); continue; }
        if (D.hp <= 0) continue;
        if (!a.reach.includes(S.range)) { say(sh.k, { m: i, t: 'miss', id: sh.id, a: a.n, o: S.range > Math.max(...a.reach) ? 'falls short at ' + RNG[S.range] : 'smothered - too close at ' + RNG[S.range] }); opening[v] = 1; continue; }
        if (cov[v][a.line] && !wasDrawn) { D.g = Math.max(0, D.g - (a.d >= 3 ? 1 : 0)); say(sh.k, { m: i, t: 'block', id: sh.id, a: a.n, o: `blocked by the ${sl} hand held ${heightOf(P[v], sl)}` + (D.g <= 0 ? ' - GUARD BROKEN' : '') }); opening[v] = 1; continue; }
        const dmg = a.d + (openNow[sh.k] ? N.counter : 0); D.hp -= dmg; A.pts += a.d >= 3 ? 2 : 1; if (a.body) { D.cap = Math.max(4, D.cap - 1); D.st = Math.min(D.st, D.cap); } if (a.d >= 3) stun[v] = 1;
        const why = D.g <= 0 ? 'guard broken' : wasDrawn ? 'the feint drew his hand' : act[v] === sl ? `the ${sl} hand was out in that moment` : `the ${sl} hand was held ${heightOf(P[v], sl)}`;
        say(sh.k, { m: i, t: 'hit', id: sh.id, a: a.n, dmg, o: `lands${openNow[sh.k] ? ' as a counter' : ''} (${why}): -${dmg} health${a.body ? ', stamina bar shorter' : ''}`, down: D.hp <= 0 }); }
      x = y; }
    for (const k of [0, 1]) if (drawn[k]) drawn[k]--; }
  if (!ev.length) ev.push({ k: -1, t: 'flat', a: 'Nothing thrown', o: 'both men wait' });
  return ev; }
function endBeat(S) { for (const m of S.f) { const l = m.last || {}, home = l.clinch ? 0 : (l.lead ? 0 : 1) + (l.rear ? 0 : 1); m.st = Math.min(m.cap, m.st + N.rec + N.hold * home); m.g = Math.min(N.guard, m.g + N.grec); if (m.held) m.held--; } }

const perms = (a) => a.length < 2 ? [a] : a.flatMap((x, i) => perms([...a.slice(0, i), ...a.slice(i + 1)]).map((r) => [x, ...r]));
// ---- the machine: reads the range, your guard as he sees it, and what you did LAST beat
function ai(S) { const me = S.f[1], you = S.f[0], last = you.last || plan0(), p = plan0(), r = S.range; let st = me.st; const can = (id) => ACT[id].st <= st;
  const take = (slot, id) => { if (id && can(id) && !p[slot]) { p[slot] = id; st -= ACT[id].st; } };
  const openYou = (line) => !covers(you, last)[line];
  p.hl = last.lead === 'lbody' || last.rear === 'rbody' ? (rnd() < 0.6 ? 'low' : 'high') : 'high'; p.hr = r === 1 && rnd() < 0.4 ? 'low' : p.hl;
  if (oppI === 0) { if (r < 3 && !(me.ropes >= 2) && st > 1 && rnd() < 0.75) { p.feet = 'back'; st--; }
    const rr = r; p.ord = ['lead', 'rear', 'feet']; if (rr >= 2) take('lead', 'jab'); if (rr === 2 && rnd() < (openYou('straight') ? 0.8 : 0.35)) take('rear', 'cross'); if (rr === 1) take('lead', rnd() < 0.5 ? 'push' : 'hook'); }
  else if (oppI === 1) { if (r === 3 && st > 2) { p.feet = 'in'; st--; }
    const rr = clamp(r - (p.feet === 'in' ? 1 : 0), 1, 3); if (rr === 2) { take('rear', 'over'); if (rnd() < 0.6) take('lead', openYou('side') ? 'hook' : 'jab'); } else if (rr === 1) { take('rear', 'rup'); if (rnd() < 0.5) take('lead', 'hook'); } else take('lead', 'jab'); }
  else { if (r === 3 && st > 2) { p.feet = 'in'; st--; }
    const rr = clamp(r - (p.feet === 'in' ? 1 : 0), 1, 3); if (rr === 2) { take(rnd() < 0.5 ? 'rear' : 'lead', rnd() < 0.5 ? 'rbody' : 'lbody'); if (!p.rear && rnd() < 0.4 && openYou('straight')) take('rear', 'cross'); } else if (rr === 1) { take('lead', 'lbody'); if (rnd() < 0.3) take('rear', 'rup'); } else take('lead', 'jab'); }
  // HE READS A HABIT: the same punches in two of your last three punching beats and he answers THAT - he tries every
  // plan he can pay for against it on a copy of the ring and takes the best for him (with a lean to his own style)
  const hist = you.hist || [], key = (x) => [x.lead, x.rear, x.feet, ordOf(x).join('>')].join('|'), cnt = {}; for (const h of hist) cnt[key(h)] = (cnt[key(h)] || 0) + 1;
  const habit = hist.find((h) => cnt[key(h)] >= 2);
  if (habit && rnd() < OPP.read) { let best = p, bv = -1e9; const like = [['jab', 'cross', 'back'], ['over', 'hook', 'rup', 'lup', 'in'], ['lbody', 'rbody', 'in']][oppI];
    const yours = { ...habit, feet: habit.feet === 'back' && you.ropes >= 2 ? 'hold' : habit.feet }, guess = cost(yours) <= you.st ? yours : { ...plan0(), hl: habit.hl, hr: habit.hr };
    for (const lo of LO) for (const ro of RO) for (const feet of ['in', 'hold', 'back']) {
      const c0 = { ...lo, ...ro, feet, clinch: false, ord: [] }, lead = c0.lead, rear = c0.rear; if (cost(c0) > me.st || (feet === 'back' && me.ropes >= 2)) continue;
      for (const ord of perms(ordOf(c0))) { const c = { ...c0, ord }, T = { range: S.range, f: S.f.map((m) => ({ ...m, hist: [] })) }; resolve(T, [{ ...guess }, { ...c }]);
        const v = (you.hp - T.f[0].hp) - (me.hp - T.f[1].hp) + 0.25 * T.f[1].st + 0.6 * [lead, rear, feet].filter((x) => like.includes(x)).length + rnd() * 0.5;
        if (v > bv) { bv = v; best = c; } } }
    return best; }
  if (me.st <= 2 && r <= 2 && !me.held && rnd() < 0.5) return { ...plan0(), clinch: true };
  if (!p.ord.length) p.ord = oppI === 1 ? ['feet', 'rear', 'lead'] : ['feet', 'lead', 'rear'];
  return p; }


let NOORDER = false;
// A SENSIBLE PLAYER: he answers what the man did LAST beat (the page shows it), trying every plan he can pay for;
// eps = how often he does something else he can afford instead (a human is not a machine)
function human(S, eps) { const me = S.f[0], he = S.f[1], guess0 = he.last || plan0(), guess = cost(guess0) <= he.st ? guess0 : { ...plan0(), hl: guess0.hl, hr: guess0.hr }; let best = plan0(), bv = -1e9; const all = [];
  for (const lo of LO) for (const ro of RO) for (const feet of ['in', 'hold', 'back']) {
    const c0 = { ...lo, ...ro, feet, clinch: false, ord: [] }; if (cost(c0) > me.st || (feet === 'back' && me.ropes >= 2)) continue;
    for (const ord of (NOORDER ? [ordOf(c0)] : perms(ordOf(c0)))) { const c = { ...c0, ord }; all.push(c); const T = { range: S.range, f: S.f.map((m) => ({ ...m, hist: [] })) }; resolve(T, [{ ...c }, { ...guess, clinch: false }]);
      const v = (he.hp - T.f[1].hp) - (me.hp - T.f[0].hp) + 0.25 * T.f[0].st + rnd() * 0.5; if (v > bv) { bv = v; best = c; } } }
  return rnd() < eps ? pickOne(all) : best; }
function boutHuman(eps, n) { let w = 0, ko = 0, beats = 0; for (let b = 0; b < n; b++) { const S = { f: [man(N.hp), man(OPP.hp)], range: 3 }; let done = false, t = [0, 0];
    for (let r = 0; r < N.rounds && !done; r++) { S.range = 3; for (const m of S.f) { m.pts = 0; m.st = m.cap; m.g = N.guard; m.ropes = 0; m.held = 0; }
      for (let i = 0; i < N.beats && !done; i++) { resolve(S, [human(S, eps), ai(S)]); endBeat(S); beats++;
        for (const k of [0, 1]) if (S.f[k].hp <= 0) { S.f[k].kd++; S.f[1 - k].pts += 3; if (S.f[k].kd > N.kd.length) { if (k === 1) w++; ko++; done = true; break; } S.f[k].hp = N.kd[S.f[k].kd - 1]; } }
      if (!done) { const [x, y] = S.f; t[0] += x.pts >= y.pts ? 10 : 9; t[1] += y.pts >= x.pts ? 10 : 9; } }
    if (!done && t[0] > t[1]) w++; } return [w / n, ko / n, beats / n]; }
const pc = (x) => (100 * x).toFixed(0).padStart(3) + '%';
for (const eps of [0, 0.25, 1]) { const r = []; for (oppI = 0; oppI < 3; oppI++) { OPP = OPPS[oppI]; r.push(boutHuman(eps, 150)); }
  console.log(eps === 1 ? 'RANDOM switches   ' : eps ? 'sensible, 1 in 4 off' : 'sensible player   ', 'wins', r.map((x) => pc(x[0])).join(' '), '| stoppages', r.map((x) => pc(x[1])).join(' '), '| beats', r.map((x) => x[2].toFixed(1)).join(' ')); }

// every fixed plan, thrown whenever it can be paid for
function boutFixed(pl, n) { let w = 0; for (let b = 0; b < n; b++) { const S = { f: [man(N.hp), man(OPP.hp)], range: 3 }; let done = false, t = [0, 0];
    for (let r = 0; r < N.rounds && !done; r++) { S.range = 3; for (const m of S.f) { m.pts = 0; m.st = m.cap; m.g = N.guard; m.ropes = 0; m.held = 0; }
      for (let i = 0; i < N.beats && !done; i++) { let mine = { ...pl }; if (mine.feet === 'back' && S.f[0].ropes >= 2) mine.feet = 'hold'; if (cost(mine) > S.f[0].st) mine = { ...plan0(), hl: pl.hl, hr: pl.hr };
        resolve(S, [mine, ai(S)]); endBeat(S);
        for (const k of [0, 1]) if (S.f[k].hp <= 0) { S.f[k].kd++; S.f[1 - k].pts += 3; if (S.f[k].kd > N.kd.length) { if (k === 1) w++; done = true; break; } S.f[k].hp = N.kd[S.f[k].kd - 1]; } }
      if (!done) { const [x, y] = S.f; t[0] += x.pts >= y.pts ? 10 : 9; t[1] += y.pts >= x.pts ? 10 : 9; } }
    if (!done && t[0] > t[1]) w++; } return w / n; }
const out = []; for (const lo of LO) for (const ro of RO) for (const feet of ['in', 'hold', 'back']) for (const ord of perms(ordOf({ ...lo, ...ro, feet }))) { const pl = { ...lo, ...ro, feet, clinch: false, ord }, r = []; for (oppI = 0; oppI < 3; oppI++) { OPP = OPPS[oppI]; r.push(boutFixed(pl, 30)); } out.push({ w: planWords(pl), r }); }
console.log('best FIXED plan against each man:', [0, 1, 2].map((i) => { const o = out.slice().sort((a, b) => b.r[i] - a.r[i])[0]; return pc(o.r[i]) + ' ' + o.w; }).join(' | '));
console.log('fixed plans that beat all three over 50%:', out.filter((o) => Math.min(...o.r) > 0.5).length, 'of', out.length);

// does the ORDER matter? the same sensible player, but he never chooses an order (feet, lead, rear every time)
NOORDER = true; { const r = []; for (oppI = 0; oppI < 3; oppI++) { OPP = OPPS[oppI]; r.push(boutHuman(0, 150)); } console.log('sensible, NO order chosen  wins', r.map((x) => pc(x[0])).join(' ')); }
