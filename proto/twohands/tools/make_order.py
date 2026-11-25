"""Builds proto/twohands/order.html from switch.html: the same game, but the player chooses the ORDER of his actions."""
import os, sys
root = sys.argv[1]
s = open(os.path.join(root, 'proto/twohands/switch.html'), encoding='utf-8').read()


def R(a, b):
    global s
    assert a in s, a[:80]
    s = s.replace(a, b, 1)


def cut(a, b, new):
    global s
    i, j = s.index(a), s.index(b)
    assert i < j
    s = s[:i] + new + s[j:]


R("<title>Ring Switches</title>", "<title>Ring Switches - order</title>")
R("While his ${sl} hand is out, your", "In that same moment his ${sl} hand is out, so your")
R("const momentOf = (p, sl) => '';", "const momentOf = (p, sl) => ` in moment ${ordOf(p).indexOf(sl) + 1}`;")
R("A punch of his that you block or that misses makes your next punch a <b>counter</b> (+1 health).", "Then throw your own punch in a LATER moment: after his is blocked or misses, yours is a <b>counter</b> (+1 health). A moment later his hand is back and blocks again.")
R('<span class="brand">Ring Switches</span>', '<span class="brand">Ring Switches - your order</span>')
R("every action is a switch - a hand left off defends", "the order you click is the order you throw - <a href=\"switch.html\" style=\"color:inherit\">the version without order</a>")
R(".sw .why{color:#ff9d95;font-weight:600}", ".sw .why{color:#ff9d95;font-weight:600}.sw{position:relative}.sw .n{position:absolute;left:-.5rem;top:-.5rem;width:1.5rem;height:1.5rem;border-radius:50%;background:var(--gold);color:#231a12;font-weight:800;display:grid;place-items:center;font-size:.9rem}\n.seq{display:flex;gap:.4rem;align-items:center;flex-wrap:wrap}.seq button{padding:.25rem .7rem;border-radius:.7rem;border:1px solid var(--gold);background:#3a2c18;font-weight:600}.seq button b{color:var(--gold);margin-right:.3rem}")
# ---- the plan carries an order
R("const plan0 = () => ({ lead: null, rear: null, hl: 'high', hr: 'high', feet: 'hold', clinch: false });",
  "const plan0 = () => ({ lead: null, rear: null, hl: 'high', hr: 'high', feet: 'hold', clinch: false, ord: [] });")
old = s[s.index("const planWords = (p) =>"):s.index("\n", s.index("const planWords = (p) =>"))]
R(old, """// the order a plan is thrown in: the slots that DO something (a hand that punches, feet that move), as the player set them
const active = (p, sl) => (sl === 'feet' ? p.feet !== 'hold' : !!p[sl]);
const ordOf = (p) => p.clinch ? [] : [...(p.ord || []).filter((sl) => active(p, sl)), ...['feet', 'lead', 'rear'].filter((sl) => active(p, sl) && !(p.ord || []).includes(sl))];
const actName = (p, sl) => (sl === 'feet' ? FEET[p.feet].n : ACT[p[sl]].n);
const planWords = (p) => !p ? 'nothing yet' : p.clinch ? 'clinch' : [ordOf(p).map((sl, i) => `${i + 1} ${actName(p, sl)}`).join(', ') || 'no action', [!p.lead && 'lead hand ' + p.hl, !p.rear && 'rear hand ' + p.hr].filter(Boolean).join(', ')].filter(Boolean).join(' - ');""")
# ---- one beat is three moments
cut("// ---- one beat: both plans at once.", "function endBeat(S)", r"""// ---- one beat = THREE MOMENTS. In moment i each man does the i-th thing of his order (or nothing). A hand is out of
// its guard only in the moment it acts; the rest of the beat it is held where he holds it.
function resolve(S, P) { const ev = [], f = S.f, say = (k, o) => ev.push({ k, ...o });
  for (const k of [0, 1]) { if (f[k].kept && P[k].feet === 'in') P[k] = { ...P[k], feet: 'hold' }; f[k].kept = 0; }   // S554: a landed jab keeps him out (as switch.html)
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
        const dmg = a.d + (openNow[sh.k] ? N.counter : 0); D.hp -= dmg; A.pts += a.d >= 3 ? 2 : 1; if (a.body) { D.cap = Math.max(4, D.cap - 1); D.st = Math.min(D.st, D.cap); } if (a.d >= 3) stun[v] = 1; if (a.keep && N.keep) D.kept = 1;
        const why = D.g <= 0 ? 'guard broken' : wasDrawn ? 'the feint drew his hand' : act[v] === sl ? `the ${sl} hand was out in that moment` : `the ${sl} hand was held ${heightOf(P[v], sl)}`;
        say(sh.k, { m: i, t: 'hit', id: sh.id, a: a.n, dmg, o: `lands${openNow[sh.k] ? ' as a counter' : ''} (${why}): -${dmg} health${a.body ? ', stamina bar shorter' : ''}${a.keep && N.keep ? (v ? ' - he cannot step in next beat' : ' - you cannot step in next beat') : ''}`, down: D.hp <= 0 }); }
      x = y; }
    for (const k of [0, 1]) if (drawn[k]) drawn[k]--; }
  if (!ev.length) ev.push({ k: -1, t: 'flat', a: 'Nothing thrown', o: 'both men wait' });
  return ev; }
""")
# ---- the machine: its own order, and the reader tries every order
R("const hist = you.hist || [], key = (x) => [x.lead, x.rear, x.feet].join('|'),", "const hist = you.hist || [], key = (x) => [x.lead, x.rear, x.feet, ordOf(x).join('>')].join('|'),")
R("      const c = { ...lo, ...ro, feet, clinch: false }, lead = c.lead, rear = c.rear; if (cost(c) > me.st || (feet === 'back' && me.ropes >= 2) || (feet === 'in' && !stepOk)) continue;\n      const T = { range: S.range, f: S.f.map((m) => ({ ...m, hist: [] })) }; resolve(T, [{ ...guess }, c]);\n      const v = (you.hp - T.f[0].hp) - (me.hp - T.f[1].hp) + 0.25 * T.f[1].st + 0.6 * [lead, rear, feet].filter((x) => like.includes(x)).length + rnd() * 0.5;\n      if (v > bv) { bv = v; best = c; } }",
  "      const c0 = { ...lo, ...ro, feet, clinch: false, ord: [] }, lead = c0.lead, rear = c0.rear; if (cost(c0) > me.st || (feet === 'back' && me.ropes >= 2)) continue;\n      for (const ord of perms(ordOf(c0))) { const c = { ...c0, ord }, T = { range: S.range, f: S.f.map((m) => ({ ...m, hist: [] })) }; resolve(T, [{ ...guess }, { ...c }]);\n        const v = (you.hp - T.f[0].hp) - (me.hp - T.f[1].hp) + 0.25 * T.f[1].st + 0.6 * [lead, rear, feet].filter((x) => like.includes(x)).length + rnd() * 0.5;\n        if (v > bv) { bv = v; best = c; } } }")
R("// ---- the machine:", "const perms = (a) => a.length < 2 ? [a] : a.flatMap((x, i) => perms([...a.slice(0, i), ...a.slice(i + 1)]).map((r) => [x, ...r]));\n// ---- the machine:")
# his own style orders: the Jabber hits and THEN moves off (so he picks his punches for the range he stands at)
R("    const rr = clamp(r + (p.feet === 'back' ? 1 : 0), 1, 3); if (rr >= 2) take('lead', 'jab');", "    const rr = r; p.ord = ['lead', 'rear', 'feet']; if (rr >= 2) take('lead', 'jab');")
R("  if (me.st <= 2 && r <= 2 && !me.held && rnd() < 0.5) return { ...plan0(), clinch: true };\n  return p; }",
  "  if (me.st <= 2 && r <= 2 && !me.held && rnd() < 0.5) return { ...plan0(), clinch: true };\n  if (!p.ord.length) p.ord = oppI === 1 ? ['feet', 'rear', 'lead'] : ['feet', 'lead', 'rear'];\n  return p; }")
# ---- the board: numbered switches, an order strip, reach previewed at the moment the punch is thrown
R("function board() { const me = F[0], left = me.st - cost(P), after = clamp(range + (P.feet === 'in' ? -1 : P.feet === 'back' ? 1 : 0), 1, 3);",
  "function board() { const me = F[0], left = me.st - cost(P); P.ord = ordOf(P); const stepAt = P.ord.indexOf('feet'), dr = P.feet === 'in' ? -1 : P.feet === 'back' ? 1 : 0;\n  const rangeAt = (sl) => { const at = P.ord.indexOf(sl) < 0 ? P.ord.length : P.ord.indexOf(sl); return clamp(range + (stepAt >= 0 && stepAt < at ? dr : 0), 1, 3); }, num = (sl) => (P.ord.indexOf(sl) >= 0 ? `<span class=\"n\">${P.ord.indexOf(sl) + 1}</span>` : '');")
R("const sw = (grp, id, name, c, sub, on, dis, why, home) => `<button class=\"sw ${on ? 'on' : ''} ${home ? 'home' : ''}\" data-g=\"${grp}\" data-id=\"${id}\" ${dis ? 'disabled' : ''}><b>${name}</b>",
  "const sw = (grp, id, name, c, sub, on, dis, why, home) => `<button class=\"sw ${on ? 'on' : ''} ${home ? 'home' : ''}\" data-g=\"${grp}\" data-id=\"${id}\" ${dis ? 'disabled' : ''}>${on && !home && grp !== 'clinch' && !(grp === 'feet' && id === 'hold') ? num(grp) : ''}<b>${name}</b>")
R("const a = ACT[id], on = cur === id, room = left + (cur ? ACT[cur].st : 0), short = a.st > room, reach = a.d ? a.reach.includes(after) : true;",
  "const a = ACT[id], on = cur === id, room = left + (cur ? ACT[cur].st : 0), short = a.st > room, after = rangeAt(slot), reach = a.d ? a.reach.includes(after) : true;")
R("else if (g === 'lead' || g === 'rear') { if (id === 'high' || id === 'low') { P[g] = null; P[g === 'lead' ? 'hl' : 'hr'] = id; } else P[g] = P[g] === id ? null : id; } else P[g] = id; plan(); };",
  "else if (g === 'lead' || g === 'rear') { if (id === 'high' || id === 'low') { P[g] = null; P[g === 'lead' ? 'hl' : 'hr'] = id; } else P[g] = P[g] === id ? null : id; } else P[g] = id;\n    if (active(P, g) && !P.ord.includes(g)) P.ord = [...P.ord, g]; P.ord = P.ord.filter((sl) => active(P, sl)); plan(); };")
old = s[s.index("  const c = covers(me, P); $('lines').innerHTML ="):s.index("function plan() {")]
R(old, """  // the order strip (click an action to move it one place earlier) and what each moment leaves open
  const all = Object.keys(LINE), heldCov = { [COVER[P.hl][0]]: 1, [COVER[P.hr][1]]: 1 };
  $('lines').innerHTML = (P.clinch ? '<span class="lab">Clinch: nothing is thrown either way</span>' : `<span class="lab">Your order</span><span class="seq">${P.ord.length ? P.ord.map((sl, i) => `<button data-sl="${sl}" title="Click to throw this one place earlier"><b>${i + 1}</b>${actName(P, sl)}</button>`).join('<span>then</span>') : '<span class="ln cov">no action: both hands held</span>'}</span>`) +
    `<span class="lab" style="margin-left:.8rem">What you leave open</span>` + (me.g <= 0 ? '<span class="ln open">your guard is broken: nothing is covered</span>' : all.map((l) => { const sl = slotOf(l), at = P.ord.indexOf(sl);
      return !heldCov[l] ? `<span class="ln open">${THREAT[l]}: OPEN</span>` : at >= 0 ? `<span class="ln open" title="That hand is busy in moment ${at + 1}; before and after it is back and blocks.">${THREAT[l]}: open in moment ${at + 1} only</span>` : `<span class="ln cov">${THREAT[l]}: covered</span>`; }).join(''));
  for (const b of $('lines').querySelectorAll('.seq button')) b.onclick = () => { const i = P.ord.indexOf(b.dataset.sl); if (i > 0) { const o = [...P.ord]; [o[i - 1], o[i]] = [o[i], o[i - 1]]; P.ord = o; plan(); } }; }
""")
# the story names the moment
R("$('story').insertAdjacentHTML('beforeend', `<div class=\"srow ${cls}\"><b>${label}</b>", "$('story').insertAdjacentHTML('beforeend', `<div class=\"srow ${cls}\"><b>${e.m != null ? `<span style=\"color:var(--gold)\">${e.m + 1}</span> ` : ''}${label}</b>")
R("    beat++; P = { ...P, clinch: false, lead: affordable(P.lead), rear: affordable(P.rear) }; if (cost(P) > F[0].st) P = { ...plan0(), hl: P.hl, hr: P.hr };",
  "    beat++; P = { ...P, clinch: false, lead: affordable(P.lead), rear: affordable(P.rear) }; if (cost(P) > F[0].st) P = { ...plan0(), hl: P.hl, hr: P.hr }; P.ord = ordOf(P);")
R("<b>The fast punch lands first.</b> A big punch that lands stops his slower one. A punch of his that misses or is blocked makes yours a counter (+1).",
  "<b>A beat is three moments.</b> The order you click your switches is the order you throw them: your first action meets his first, your second his second. <b>A hand is out of its guard only in the moment it acts.</b> Catch him in the moment his hand is out and it lands; a moment later it is back. Feet take a moment too: step in and then hook, or jab and then back off. A punch of his that misses or is blocked makes your later punches counters (+1).")
R("if (/peek=/.test(location.search)) { mute = true; document.getElementById('go').click(); P.lead = 'jab'; P.feet = 'in'; plan(); }",
  "if (/peek=/.test(location.search)) { mute = true; document.getElementById('go').click(); P.feet = 'in'; P.lead = 'jab'; P.rear = 'cross'; P.ord = ['feet', 'lead', 'rear']; plan(); }")
R("Draws his hands: your rear-hand punch this beat cannot be covered.", "Draws his hands: the punch you throw in the next moment cannot be covered.")
open(os.path.join(root, 'proto/twohands/order.html'), 'w', encoding='utf-8', newline='\n').write(s)
js = s[s.index('<script>') + 8:s.index('</script>')]
open(os.path.join(os.environ['TEMP'], 'so.js'), 'w', encoding='utf-8').write(js)
# the measuring bots, for this version: a sensible player tries every order too
c = open(os.path.join(os.environ['TEMP'], 'sw_human.js'), encoding='utf-8').read()
tail = c[c.index("\n// A SENSIBLE PLAYER"):]
tail = tail.replace("    const c = { ...lo, ...ro, feet, clinch: false }; if (cost(c) > me.st || (feet === 'back' && me.ropes >= 2)) continue; all.push(c);\n    const T = { range: S.range, f: S.f.map((m) => ({ ...m, hist: [] })) }; resolve(T, [c, { ...guess, clinch: false }]);\n    const v = (he.hp - T.f[1].hp) - (me.hp - T.f[0].hp) + 0.25 * T.f[0].st + rnd() * 0.5; if (v > bv) { bv = v; best = c; } }",
                    "    const c0 = { ...lo, ...ro, feet, clinch: false, ord: [] }; if (cost(c0) > me.st || (feet === 'back' && me.ropes >= 2)) continue;\n    for (const ord of (NOORDER ? [ordOf(c0)] : perms(ordOf(c0)))) { const c = { ...c0, ord }; all.push(c); const T = { range: S.range, f: S.f.map((m) => ({ ...m, hist: [] })) }; resolve(T, [{ ...c }, { ...guess, clinch: false }]);\n      const v = (he.hp - T.f[1].hp) - (me.hp - T.f[0].hp) + 0.25 * T.f[0].st + rnd() * 0.5; if (v > bv) { bv = v; best = c; } } }")
assert 'NOORDER' in tail
tail = tail.replace("const out = []; for (const lo of LO) for (const ro of RO) for (const feet of ['in', 'hold', 'back']) { const pl = { ...lo, ...ro, feet, clinch: false }, r = [];",
                    "const out = []; for (const lo of LO) for (const ro of RO) for (const feet of ['in', 'hold', 'back']) for (const ord of perms(ordOf({ ...lo, ...ro, feet }))) { const pl = { ...lo, ...ro, feet, clinch: false, ord }, r = [];")
tail = tail.replace("r.push(boutFixed(pl, 60))", "r.push(boutFixed(pl, 30))")
tail = "\nlet NOORDER = false;" + tail + r"""
// does the ORDER matter? the same sensible player, but he never chooses an order (feet, lead, rear every time)
NOORDER = true; { const r = []; for (oppI = 0; oppI < 3; oppI++) { OPP = OPPS[oppI]; r.push(boutHuman(0, 150)); } console.log('sensible, NO order chosen  wins', r.map((x) => pc(x[0])).join(' ')); }
"""
open(os.path.join(os.environ['TEMP'], 'so_human.js'), 'w', encoding='utf-8').write("const document={getElementById:()=>({})};\n" + js[:js.index('// ---- the page')] + tail)
print('built order.html')
