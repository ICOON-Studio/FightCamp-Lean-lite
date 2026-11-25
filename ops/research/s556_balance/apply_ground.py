# S556: AN EVEN ROUND GOES TO THE MAN WHO GAVE LESS GROUND, on proto/twohands/order.html (Kalli 6, John 4; measured on
# tools/balance.mjs: draws 12% -> 6%, nothing else moves - docs/RINGSWITCH_S556.md). Run once from the repo root, with
# no balance.mjs run going:  python ops/research/s556_balance/apply_ground.py
import io
import sys

p = 'proto/twohands/order.html'
s = io.open(p, encoding='utf-8', newline='').read()


def rep(a, b):
    global s
    if s.count(a) != 1:
        sys.exit('expected 1 of %r, found %d' % (a[:80], s.count(a)))
    s = s.replace(a, b)


# the setting the measuring tool reads when it scores a round
rep("counter: 1, keep: 0 };", "counter: 1, keep: 0, even: 1 };")
# every back off is counted for the round
rep("else { d++; f[k].ropes++; }", "else { d++; f[k].ropes++; f[k].gave = (f[k].gave || 0) + 1; }")
# the bell: a round level on points goes to the man who backed off less (still level: 10-10)
rep("function bell() { const [x, y] = F, w = x.pts === y.pts ? -1 : x.pts > y.pts ? 0 : 1, sc = [w === 1 ? 9 : 10, w === 0 ? 9 : 10];",
    "function bell() { const [x, y] = F, lvl = x.pts === y.pts, gx = x.gave || 0, gy = y.gave || 0, onGround = lvl && N.even && gx !== gy, w = lvl ? (onGround ? (gx < gy ? 0 : 1) : -1) : x.pts > y.pts ? 0 : 1, sc = [w === 1 ? 9 : 10, w === 0 ? 9 : 10];   // S556: an even round goes to the man who gave less ground")
rep("m.ropes = 0; m.held = 0; m.kept = 0; }\n  $('said').textContent = `BELL. The judges give the round ${sc[0]}-${sc[1]}. Round ${round}: back at Long.`;",
    "m.ropes = 0; m.held = 0; m.kept = 0; m.gave = 0; }\n  $('said').textContent = `BELL. The judges give the round ${sc[0]}-${sc[1]}${onGround ? ` (level on points: it goes to ${w ? 'him, you' : 'you, he'} backed off more)` : ''}. Round ${round}: back at Long.`;")
# the score line says it on hover
rep("$('score').innerHTML = `Points this round: you <b>${F[0].pts}</b> - him <b>${F[1].pts}</b>`",
    "$('score').innerHTML = `<span title=\"A round level on points goes to the man who backed off less. Backed off this round: you ${F[0].gave || 0}, him ${F[1].gave || 0}.\">Points this round: you <b>${F[0].pts}</b> - him <b>${F[1].pts}</b></span>`")
io.open(p, 'w', encoding='utf-8', newline='').write(s)
print('applied: an even round goes to the man who gave less ground')
