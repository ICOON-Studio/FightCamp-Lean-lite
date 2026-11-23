# one-off: turns the copied round 4 files into round 5 (kept as the record of what changed in the rules)
import io, os, sys
D = os.path.dirname(os.path.abspath(__file__))
def patch(name, pairs):
    p = os.path.join(D, name); s = io.open(p, encoding='utf-8').read()
    for a, b in pairs:
        if a not in s: sys.exit('MISSING in %s: %s' % (name, a[:70]))
        s = s.replace(a, b, 1)
    io.open(p, 'w', encoding='utf-8', newline='\n').write(s)

patch('engine.mjs', [
("""  if (id === '@room') return [N.roomW, 'h'];
""", """  if (id === '@pull') return [N.pullW, 'h'];
  if (id === '@break') return [S.hold.brk, ''];
"""),
("""  const c = CARDS[id], M = S.f[m];
  if (c.k === 'hold' && ((M.chain && M.style === 'bjj') || (M.free && c.leg))) return [0, ''];
  return [c.w, c.L];
}""", """  const c = CARDS[id], M = S.f[m], Q = S.pj;
  if (Q && M.mech && c.k === 'strike' && c.w > 1) { // the two strikers' own mechanics are prices: what a line costs
    const last = S.inc[S.inc.length - 1], lc = last && CARDS[last.id];
    if (M.style === 'boxing' && !c.kick && Q.pos === 'P' && lc && lc.k === 'strike' && !lc.kick) return [c.w - 1, c.L];
    if (M.style === 'karate' && ((c.kick && Q.pos === 'P') || (c.blitz && Q.pos === 'K'))) return [c.w - 1, c.L];
  }
  return [c.w, c.L];
}
const SR = ['K', 'P', 'C'];
// where a card is playable for this fighter: the printed ranges, widened or narrowed by his art's own mechanic
export function atFor(F, c) {
  let at = c.at; if (!at) return at;
  if (F.mech) {
    if (c.enter || c.blitz || (c.kick && F.style === 'karate')) at = KPs;
    if (F.style === 'wrestling' && c.k === 'shot') at = SR;
  }
  if (!(F.mech && F.style === 'bjj') && at.some((a) => a[0] === 'B')) at = at.filter((a) => a[0] !== 'B'); // the guard is BJJ's
  return at;
}"""),
("""  if (S.hold) return false;
  const c = CARDS[id];""", """  if (id === '@pull') return !S.hold && M.mech && M.style === 'bjj' && (S.pos === 'P' || S.pos === 'C');
  if (S.hold || id === '@break') return false;
  const c = CARDS[id];"""),
("""  if (c.needGrip && M.mech && !(S.grip && S.grip.by === m && S.grip.pass < S.pass)) return false;
  let at = c.at;
  if (M.mech && (c.blitz || c.enter)) at = KPs;
  if (M.mech && M.style === 'bjj' && c.k === 'hold' && M.chain) at = GG;
  return fits(at, posKey(S, m));""", """  if (c.needGrip && M.mech && !(S.grip && S.grip.by === m)) return false;
  // a hold needs a settled position: not in the volley of the takedown (sambo's own mechanic is the exception; so is BJJ's own pull)
  if (c.k === 'hold' && S.gpass === S.pass && !(S.gby === m && (S.gpull || (M.mech && M.style === 'sambo')))) return false;
  return fits(atFor(M, c), posKey(S, m));"""),
("""  if (c.needGrip) return true;
  if (c.cleanIf === 'grip') return !!S.grip && S.grip.by === a && S.grip.pass < pass;
  if (c.cleanIf === 'struck' || c.cleanIf === 'quiet') return !!S.tie && S.tie.by === a && S.tie.pass < pass && S.tie.struck === (c.cleanIf === 'struck');
  return false;""", """  if (c.needGrip) return !!S.grip && S.grip.by === a && S.grip.pass < pass;
  if (c.cleanIf === 'tie') return !!S.tie && S.tie.by === a && S.tie.pass < pass;
  return false;"""),
("""function ground(S, top, rung) { S.pos = 'G'; S.top = top; S.rung = rung; S.stall = 0; S.grip = S.tie = null; }""",
 """function ground(S, top, rung, by, pull) { S.pos = 'G'; S.top = top; S.rung = rung; S.stall = 0; S.grip = S.tie = null; S.gpass = S.pass; S.gby = by; S.gpull = !!pull; }"""),
("""  if (id === '@up') { if (S.rung <= 1) stand(S, 'P'); else S.rung -= 2; return; }
  const c = CARDS[id], fx""", """  if (id === '@up') { if (S.rung <= 1) stand(S, 'P'); else S.rung -= 2; return; }
  if (id === '@pull') { ground(S, d, 0, a, true); return; }
  const c = CARDS[id], fx"""),
("""    if (S.pos === 'K' && A.mech && (c.enter || c.blitz)) S.pos = 'P';
    let dmg = c.dmg + (x.prev && A.mech && A.style === 'boxing' ? N.chain : 0) + (p.b || 0), clean = true;""",
 """    if (A.mech) { if (S.pos === 'K' && (c.enter || c.blitz)) S.pos = 'P'; else if (S.pos === 'P' && c.kick && A.style === 'karate') S.pos = 'K'; }
    let dmg = c.dmg + (p.b || 0), clean = true;"""),
("""      else if (fx === 'catch') { ground(S, d, 0); D.pts += N.catchPts; if (D.mech && D.style === 'sambo') D.free = 1; }""",
 """      else if (fx === 'catch') { ground(S, d, 0, d); D.pts += N.catchPts; }"""),
("""    D.hp -= dmg; A.dealt += dmg; x.prev = clean; if (S.pos === 'G') S.stall = 0;""",
 """    D.hp -= dmg; A.dealt += dmg; x.prev = clean; if (S.pos === 'G') S.stall = 0;
    if (c.close && S.pos === 'P') S.pos = 'C';"""),
("""    if (fx && !clean) { if (fx === 'headlock') D.pts += N.headlockPts; if (S.st) S.st.stuffed++; return; }
    ground(S, a, c.to); A.pts += c.pts + ((clean && c.gripPts) || 0); D.hp -= c.dmg || 0; A.dealt += c.dmg || 0;
    if (A.mech && A.style === 'sambo' && !c.sweep) A.free = 1;""",
 """    if (fx && !clean) {
      if (fx === 'headlock') D.pts += N.headlockPts;
      if (A.mech && A.style === 'wrestling') { S.tie = { by: a, pass: S.pass }; S.pos = 'C'; } // chain wrestling: stuffed, he stays on the legs
      if (S.st) S.st.stuffed++; return;
    }
    ground(S, a, c.to, a); A.pts += c.pts; D.hp -= c.dmg || 0; A.dealt += c.dmg || 0;"""),
("""    if (fx) { if (A.mech && A.style === 'bjj') A.chain = 1; if (S.top === a) S.rung = Math.max(0, S.rung - 1); return; }""",
 """    if (fx) { if (S.top === a) S.rung = Math.max(0, S.rung - 1); return; }"""),
("""    S.hold = { by: a, kind: c.hk, count: c.count, price: N.sq0, room: false, pts: c.hpts || 0 };""",
 """    S.hold = { by: a, kind: c.hk, count: c.count, brk: c.brk, tick: c.tick || 0, pts: c.hpts || 0 };"""),
("""  } else if (c.k === 'move') ground(S, d, 0);""", """  }"""),
("""    if (ans && ans.id === 'escape') { S.hold = null; if (A.mech && A.style === 'bjj') A.chain = 1; if (S.top === a) S.rung = Math.max(0, S.rung - 1); if (S.st) S.st.escaped++; }
    else if (ans && ans.id === '@room') S.hold.room = true;
    else if (--S.hold.count <= 0) finishHold(S);""",
 """    const h = S.hold; // out by the Escape card or by paying the hold's printed price: both men are back on their feet in the CLINCH
    if (ans && (ans.id === 'escape' || ans.id === '@break')) { stand(S, 'C'); if (S.st) S.st.escaped++; }
    else {
      if (h.tick) { A.pts += h.tick; checkOver(S); if (S.over && S.over.how === 'lead') S.over.how = 'pin'; } // a pin scores every turn it stays on
      if (!S.over && --h.count <= 0) finishHold(S);
    }"""),
("""    if (!S.hold.room && canPay(M, cost(S, m, '@room'))) out.push({ id: '@room', i: -1 });""",
 """    if (M.wind >= S.hold.brk) out.push({ id: '@break', i: -1 });"""),
("""  if (!bell) { M.wind = Math.min(N.cap, M.wind + Math.max(0, N.back - M.drain));""",
 """  if (!bell) { M.wind = Math.min(N.cap, M.wind + Math.max(0, (S.hold && S.hold.by !== m ? N.heldBack : N.back) - M.drain)); // held: 1 wind back, not 3"""),
("""    if (ans.id === '@room' && S.st) { for (let n = 0; n < N.roomDraw; n++) { const i = M.hand.findIndex((x) => x !== 'escape'); if (i >= 0) discard(S, M, M.hand[i]); } draw(M, S.r); }
""", ""),
("""  const h = S.hold; // the holder squeezes: a rising price, or he lets go
  if (h && h.by === m && !S.over) { const c = [h.price, 'aA']; if (canPay(M, c)) { pay(M, c); h.price++; } else { S.hold = null; if (S.st) S.st.letGo++; } }
""", ""),
("""  if (S.pos === 'G' && S.top === m && !S.hold) {""", """  if (S.pos === 'G' && S.top !== m && S.inc.some((p) => p.id[0] !== '@')) S.stall = 0; // work from underneath keeps it on the ground
  if (S.pos === 'G' && S.top === m && !S.hold) {"""),
("""stall: 0, pass: 0, ctx:""", """stall: 0, pass: 0, gpass: -1, gby: -1, gpull: false, ctx:"""),
("""  const turn = (k, bell) => {""", """  const turn = (k, bell, noAct) => {"""),
("""    if (bell || !canAct(S)) return;""", """    if (bell || noAct || !canAct(S)) return;"""),
("""    for (const id of seq) { declare(S, k, id); if (id[0] !== '@') st.played[k][id] = 1; }""",
 """    const at = [];
    for (const id of seq) { at.push(posKey(S.pj, k)[0]); declare(S, k, id); if (id[0] !== '@') st.played[k][id] = 1; }"""),
("""kinds: seq.map((id) => (id[0] === '@' ? 'step' : CARDS[id].k)), ans: ans ? 1 : 0 });""",
 """kinds: seq.map((id) => (id === '@pull' ? 'move' : id[0] === '@' ? 'step' : CARDS[id].k)), at, ans: ans ? 1 : 0 });"""),
("""    if (!S.over && (S.inc.length || (S.hold && S.hold.by !== first))) turn(first, true);""",
 """    if (!S.over && S.inc.length) turn(first, true);
    for (let g = 0; g < 9 && S.hold && !S.over; g++) turn(1 - S.hold.by, false, true); // the bell waits for a hold: it runs to its end"""),
])

patch('plan.mjs', [
("import { clone, declare, resolveIncoming, legalNow, canPay, cost, ansFits, posKey, fits, answerOptions } from './engine.mjs';",
 "import { clone, declare, resolveIncoming, legalNow, canPay, cost, ansFits, posKey, fits, answerOptions, atFor } from './engine.mjs';"),
("wind: 0.5, lead: 1.5, sub: 30, pin: 14, setup: 4, drain: 2 };", "wind: 0.5, lead: 1.5, sub: 30, pin: 6, held: 3, setup: 4, drain: 2 };"),
("const at = c.at && (F.mech && (c.blitz || c.enter) ? ['K', 'P'] : c.at); if (at && fits(at, k))", "const at = atFor(F, c); if (at && fits(at, k))"),
("""  if (S.hold) v += (S.hold.by === m ? 1 : -1) * (S.hold.kind === 'sub' ? W.sub : W.pin) * (0.15 + 0.85 * (1 - escapeOdds(S, m)));""",
 """  if (S.hold) { const h = S.hold, o = outlook(S); v += (h.by === m ? 1 : -1) * ((o.fin ? (h.kind === 'sub' ? W.sub : W.pin) : W.wind * h.brk) + W.pts * o.pts + W.held * o.turns); }"""),
("  for (const id of [...new Set(M.hand), '@in', '@out', '@stand', '@up'])", "  for (const id of [...new Set(M.hand), '@in', '@out', '@stand', '@up', '@pull'])"),
("opts.find((o) => o && o.id === '@room') || null;\n  let best", "opts.find((o) => o && o.id === '@break') || null;\n  let best"),
("""  karate: [() => ['headkick', 'roundhouse', 'revpunch', 'frontkick', 'legkick'], 'K'],
  judo: [(C, m) => (C.pos === 'G' ? ['pin', 'armlock'] : gripOn(C, m) ? ['shoulderthrow', 'hipthrow', 'footsweep'] : ['grip', 'footsweep']), 'C'],
  wrestling: [(C, m) => (C.pos === 'G' ? ['gnp', 'ride'] : tieOn(C, m) ? (C.tie.struck ? ['double', 'slam', 'single'] : ['single', 'slam', 'double']) : ['tieup', 'slam', 'double', 'single']), 'P'],
  bjj: [() => ['choke', 'armbar', 'triangle', 'kimura', 'pass', 'sweep', 'pull'], 'P'],
  sambo: [(C) => (C.pos === 'G' ? ['kneebar', 'anklelock', 'casualpin'] : ['sthrow', 'trip', 'overhand']), 'C'],""",
 """  karate: [(C) => (C.pos === 'K' ? ['revpunch', 'headkick', 'roundhouse', 'frontkick', 'legkick'] : ['headkick', 'roundhouse', 'frontkick', 'legkick', 'revpunch']), 'K'],
  judo: [(C, m) => (C.pos === 'G' ? ['pin', 'armlock'] : gripOn(C, m) ? ['shoulderthrow', 'hipthrow', 'footsweep'] : ['grip']), 'P'],
  wrestling: [(C) => (C.pos === 'G' ? ['fall', 'gnp', 'ride'] : ['slam', 'double', 'single']), 'P'],
  bjj: [() => ['choke', 'armbar', 'triangle', 'kimura', 'pass', 'sweep', '@pull'], 'P'],
  sambo: [(C) => (C.pos === 'G' ? ['kneebar', 'anklelock', 'casualpin'] : ['sthrow', 'trip', 'overhand']), 'C'],"""),
("const gripOn = (C, m) => C.grip && C.grip.by === m, tieOn = (C, m) => C.tie && C.tie.by === m;", "const gripOn = (C, m) => C.grip && C.grip.by === m;"),
])
s = io.open(os.path.join(D, 'plan.mjs'), encoding='utf-8').read()
a = s.index('// the chance the held fighter still finds his Escape'); b = s.index('const dz =')
s = s[:a] + """// the hold as both men can read it: the held fighter gets 1 wind back a turn and breaks free the first turn he can pay
// the printed price; if the countdown ends first it is the tap (or the full pin). No card is drawn while held.
export function outlook(S) {
  const h = S.hold, V = S.f[1 - h.by]; let w = V.wind;
  for (let j = 1; j <= h.count; j++) {
    w = Math.min(N.cap, w + Math.max(0, N.heldBack - (j === 1 ? V.drain : 0)));
    if (w >= h.brk) return { fin: 0, turns: j, pts: h.tick * (j - 1) };
  }
  return { fin: 1, turns: h.count, pts: h.tick * h.count + h.pts };
}
""" + s[b:]
io.open(os.path.join(D, 'plan.mjs'), 'w', encoding='utf-8', newline='\n').write(s)

patch('probe.mjs', [
("opts.find((o) => o && o.id === '@room') || null; same +=", "opts.find((o) => o && o.id === '@break') || null; same +="),
("""    const feat = (log) => { const f = {}; let n = 0; for (const t of log.slice(0, 10)) { f['at' + t.pos[0]] = (f['at' + t.pos[0]] || 0) + 1; for (const k of t.kinds) { f[k + t.pos[0]] = (f[k + t.pos[0]] || 0) + 1; } f.ans = (f.ans || 0) + t.ans; n++; } for (const k in f) f[k] /= Math.max(1, n); return f; };
    const logs = {}; for (const s of STYLES) { logs[s] = []; for (const t of STYLES) if (t !== s) logs[s].push(...play(fighter(s), fighter(t), AI, AI, per, { keepLogs: 1 }).logs.map((l) => feat(l[0]))); }
""", """    // fine = 0: round 4's judge, every action filed under the range the turn began at (the bar). fine = 1: each action under the range it is laid at (reported beside it)
    const feat = (log, fine) => { const f = {}; let n = 0; for (const t of log.slice(0, 10)) { f['at' + t.pos[0]] = (f['at' + t.pos[0]] || 0) + 1; t.kinds.forEach((k, i) => { const r = fine ? t.at[i] : t.pos[0]; f[k + r] = (f[k + r] || 0) + 1; }); f.ans = (f.ans || 0) + t.ans; n++; } for (const k in f) f[k] /= Math.max(1, n); return f; };
    const raw = {}; for (const s of STYLES) { raw[s] = []; for (const t of STYLES) if (t !== s) raw[s].push(...play(fighter(s), fighter(t), AI, AI, per, { keepLogs: 1 }).logs.map((l) => l[0])); }
    for (const fine of [1, 0]) {
    const logs = {}; for (const s of STYLES) logs[s] = raw[s].map((l) => feat(l, fine));
"""),
("""    out.p6.judgeAll = ok / n; say(`P6 blind judge names the style from 10 turns: ${pct(ok / n)} (${STYLES.map((s) => s + ' ' + pct(out.p6.judge[s])).join(', ')})`);""",
 """    out.p6[fine ? 'judgeFine' : 'judgeAll'] = ok / n; say(`P6 blind judge${fine ? ' (range of each action; reported)' : ' (round 4 judge; the bar)'} names the style from 10 turns: ${pct(ok / n)} (${STYLES.map((s) => s + ' ' + pct(out.p6.judge[s])).join(', ')})`);
    }"""),
])

patch('tune.mjs', [
("['roomW', 1, 3], ['sq0', 1, 3], ['upW', 1, 3]", "['pullW', 1, 3], ['heldBack', 0, 2], ['upW', 1, 3]"),
("['hp', 24, 40], ['lead', 6, 10], ['stepW', 0, 1], ", "['hp', 24, 40], ['lead', 6, 10], "),
("['dmgPer', 3, 8], ['chain', 0, 2], ['stallMax', 1, 3]", "['dmgPer', 3, 8], ['stallMax', 1, 3]"),
("if (c.k === 'hold') { D.push([id + '.count', 1, 3]);", "if (c.k === 'hold') { D.push([id + '.count', 1, 3]); D.push([id + '.brk', 3, 8]); if (c.tick) D.push([id + '.tick', 1, 2]);"),
("fs.writeFileSync(new URL('tuned.json', OUT), JSON.stringify(cur));", "fs.writeFileSync(new URL(kv.out || 'tuned.json', OUT), JSON.stringify(cur));"),
])
patch('report.mjs', [
("`${c.hk === 'sub' ? 'submission' : `pin (+${c.hpts} pt)`}, countdown ${c.count}`", "`${c.hk === 'sub' ? 'submission' : `pin (${c.tick} pt a turn, +${c.hpts} at the end)`}, countdown ${c.count}, break free ${c.brk} wind`"),
("c.k === 'setup' ? 'set-up: next turn\\'s throw or shot is clean'", "c.k === 'setup' ? 'pulls him into the CLINCH, he cannot step out; throws need it; stood a turn = the throw cannot be stopped'"),
("${c.needGrip ? ', needs the grip' : ''}${c.cleanIf ? `, clean if ${c.cleanIf}` : ''}", "${c.needGrip ? ', needs the grip' : ''}${c.cleanIf ? ', cannot be stopped behind a stuffed shot' : ''}"),
("${c.blitz ? ', blitz from KICK' : ''}", "${c.blitz ? ', blitz from KICK' : ''}${c.close ? ', ends in the CLINCH' : ''}"),
])
print('patched')
