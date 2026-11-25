import sys
BJAB = 'bjab' in sys.argv
p='proto/twohands/order.html'; s=open(p,encoding='utf-8',newline='').read()
def rep(a,b,n=1):
    global s
    assert s.count(a)==n,(s.count(a),a[:90]); s=s.replace(a,b)
# ---- numbers
rep("const N = { hp: 22, st: 8, rec: 1, hold: 1, guard: 6, grec: 1, rounds: 3, beats: 6, kd: [9, 7], counter: 1, keep: 1 };",
    "const N = { hp: 17, st: 8, rec: 1, hold: 1, guard: 6, grec: 1, rounds: 3, beats: 6, kd: [6, 4], counter: 1, keep: 0 };")
rep("// A feel test: every number is in N / ACT and is a first guess.",
    "// S555 THE BALANCED SLICE (the owner: \"need better balance , i want this slice to be perfectly balance to move on\"): the numbers in\n// N / ACT and five rules below were chosen on tools/balance.mjs - two equal men who both play each beat's solved mix box at all\n// three ranges, every punch gets thrown, bouts end both ways (docs/RINGSWITCH_BALANCE_S555.md has the table). keep: 0 = the S554\n// trial \"a landed jab keeps him out\" is off: it made 75% of beats Long.")
rep("  jab: { n: 'Jab', h: 0, st: 1, d: 1, sp: 1, reach: [2, 3], line: 'straight', pic: 'jab', keep: 1, x: 'If it lands he cannot step in next beat.' },",
    "  jab: { n: 'Jab', h: 0, st: 1, d: 1, sp: 1, reach: [2, 3], line: 'straight', pic: 'jab' },")
rep("  hook: { n: 'Lead hook', h: 0, st: 2, d: 3, sp: 2, reach: [1, 2], line: 'side', pic: 'lead_hook' },",
    "  hook: { n: 'Lead hook', h: 0, st: 2, d: 3, sp: 1, reach: [1, 2], line: 'side', pic: 'lead_hook' },   // S555: as fast as the jab (the check hook); at the hooks' speed it was in 3% of beats")
rep("  lup: { n: 'Lead uppercut', h: 0, st: 3, d: 4, sp: 3, reach: [1], line: 'under', pic: 'lead_uppercut' },",
    "  lup: { n: 'Lead uppercut', h: 0, st: 2, d: 3, sp: 2, reach: [1], line: 'under', pic: 'lead_uppercut' },   // S555: the short one (was 3 stamina, 4 health, slow: never worth choosing beside the rear uppercut)")
rep("  cross: { n: 'Cross', h: 1, st: 2, d: 3, sp: 2, reach: [2], line: 'straight', pic: 'cross' },",
    "  cross: { n: 'Cross', h: 1, st: 2, d: 3, sp: 2, reach: [1, 2], line: 'straight', pic: 'cross' },   // S555: Mid AND Inside (Mid only, it fell short two times in three)")
rep("  rbody: { n: 'Body cross', h: 1, st: 2, d: 2, sp: 2, reach: [2], line: 'body', body: 1, pic: 'body_cross' },",
    "  rbody: { n: 'Body cross', h: 1, st: 2, d: 2, sp: 2, reach: [1, 2], line: 'body', body: 1, pic: 'body_cross' },")
rep("back: { n: 'Back off', st: 1, t: 'One place further. At Long you are giving ground toward the ropes.' } };",
    "back: { n: 'Back off', st: 1, t: 'One place further, and you give ground: two and you are on the ropes.' } };")
rep("in: { n: 'Step in', st: 1, t: 'One place closer.' }", "in: { n: 'Step in', st: 1, t: 'One place closer, even if he backs off in that moment. Wins your ground back.' }")
rep("hp: 20, read: 0.75,", "hp: 15, read: 0.75,"); rep("hp: 26, read: 0.45,", "hp: 20, read: 0.45,"); rep("hp: 22, read: 0.6,", "hp: 17, read: 0.6,")
# ---- rules
rep("else { d++; if (S.range === 3) f[k].ropes++; } }", "else { d++; f[k].ropes++; } }   // S555: EVERY back off gives ground (it did at Long only, and backing off was in 45% of beats)")
rep("    const r0 = S.range; S.range = clamp(S.range + d, 1, 3);",
    "    if ([0, 1].some((k) => act[k] === 'feet' && P[k].feet === 'in') && [0, 1].some((k) => act[k] === 'feet' && P[k].feet === 'back')) d = -1;   // S555: A STEP IN BEATS A BACK OFF in the same moment (cutting off the ring): he closes anyway\n    const r0 = S.range; S.range = clamp(S.range + d, 1, 3);")
rep("if (clincher != null && (S.range > 2 || f[clincher].held))", "if (clincher != null && (S.range > 1 || f[clincher].held))")   # S555: the clinch is Inside only
rep("o: S.range > 2 ? 'too far away'", "o: S.range > 1 ? 'too far away - a clinch is Inside only'")
rep("f[clincher].st = Math.min(f[clincher].cap, f[clincher].st + 3);", "f[clincher].st = Math.min(f[clincher].cap, f[clincher].st + 2);")
rep("if (S.range <= 2 && !me.held && me.st >= 1) out.push({ ...plan0(), clinch: true });", "if (S.range <= 1 && !me.held && me.st >= 1) out.push({ ...plan0(), clinch: true });")
# ---- the page's words
rep("'Mid or Inside: no punch lands for either man, you get 2 stamina. Not twice running.', P.clinch, (range > 2 ||", "'Inside only: no punch lands for either man, you get 2 stamina. Not twice running.', P.clinch, (range > 1 ||")
rep("range > 2 ? 'Too far away.'", "range > 1 ? 'Inside only.'")
rep("Backing off at Long gives one up;", "Every back off gives one up;")
rep("<b>A jab that lands keeps him out</b>: he cannot step in on the next beat.", "<b>A step in beats a back off</b> in the same moment: you close anyway. <b>Every back off gives ground</b>: two and you are on the ropes, until you step in. The clinch works Inside only.")
if BJAB:
    rep("  hook: { n: 'Lead hook', h: 0,", "  bjab: { n: 'Body jab', h: 0, st: 1, d: 1, sp: 1, reach: [2, 3], line: 'body', pic: 'jab' },   // S555: the second line at Long (Kalli, John and the S554 probe all put it first); it BORROWS the head jab's pictures until its own take is authored\n  hook: { n: 'Lead hook', h: 0,")
    rep("body: 'his body hook and body cross' };", "body: 'his body jab, body hook and body cross' };")
    rep("...['jab', 'hook', 'lup', 'lbody', 'feint', 'push'].map((id) => ({ lead: id, hl: 'high' }))];", "...['jab', 'bjab', 'hook', 'lup', 'lbody', 'feint', 'push'].map((id) => ({ lead: id, hl: 'high' }))];")
open(p,'w',encoding='utf-8',newline='').write(s)
print('applied', 'with the body jab' if BJAB else 'without the body jab')
