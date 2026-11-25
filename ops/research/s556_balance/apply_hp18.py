# S556: one more point of health for everybody on proto/twohands/order.html (18; the opponents 16 / 21 / 18). With the
# body jab on the page two equal men knocked each other down 2.7 times a bout and 27% of bouts were stopped (168 bouts);
# with 18 it is 2.25 and 16% (docs/RINGSWITCH_S556.md). Run once, with no balance.mjs run going.
import io
import sys

p = 'proto/twohands/order.html'
s = io.open(p, encoding='utf-8', newline='').read()


def rep(a, b):
    global s
    if s.count(a) != 1:
        sys.exit('expected 1 of %r, found %d' % (a[:80], s.count(a)))
    s = s.replace(a, b)


rep("const N = { hp: 17,", "const N = { hp: 18,")
rep("hp: 15, read", "hp: 16, read")
rep("hp: 20, read", "hp: 21, read")
rep("hp: 17, read", "hp: 18, read")
io.open(p, 'w', encoding='utf-8', newline='').write(s)
print('applied: health 18, the opponents 16 / 21 / 18')
