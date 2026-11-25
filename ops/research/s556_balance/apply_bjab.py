# S556 BODYJAB1: the body jab on proto/twohands/order.html, with its own pictures (run names <corner>_body_jab_<result>).
# Run once from the repo root, with no balance.mjs run going:  python ops/research/s556_balance/apply_bjab.py
# Then: node proto/twohands/tools/balance.mjs table ; ... play who=mix opp=mirror n=84 ; node proto/twohands/tools/rules_test.mjs
import io
import sys

p = 'proto/twohands/order.html'
s = io.open(p, encoding='utf-8', newline='').read()


def rep(a, b):
    global s
    if s.count(a) != 1:
        sys.exit('expected 1 of %r, found %d' % (a[:80], s.count(a)))
    s = s.replace(a, b)


rep("  hook: { n: 'Lead hook', h: 0,",
    "  bjab: { n: 'Body jab', h: 0, st: 1, d: 1, sp: 1, reach: [2, 3], line: 'body', pic: 'body_jab' },   // S556: the second line at Long - one lead hand cannot stop both jabs (Kalli, John and the S554 probe all put it first). A light punch: it does not shorten his stamina bar (with that the head jab fell to 3% of beats, S555)\n"
    "  hook: { n: 'Lead hook', h: 0,")
rep("body: 'his body hook and body cross' };", "body: 'his body jab, body hook and body cross' };")
rep("...['jab', 'hook', 'lup', 'lbody', 'feint', 'push'].map((id) => ({ lead: id, hl: 'high' }))];",
    "...['jab', 'bjab', 'hook', 'lup', 'lbody', 'feint', 'push'].map((id) => ({ lead: id, hl: 'high' }))];")
rep("the jab hand (jab, lead hook, lead uppercut, body hook, feint, push)", "the jab hand (jab, body jab, lead hook, lead uppercut, body hook, feint, push)")
rep("snd(ACT[e.id].body ? 'punch_body_1'", "snd(ACT[e.id].line === 'body' ? 'punch_body_1'")
io.open(p, 'w', encoding='utf-8', newline='').write(s)
print('applied: the body jab is on the page')
