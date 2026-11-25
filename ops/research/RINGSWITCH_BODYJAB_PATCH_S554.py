p='proto/twohands/switch.html'; s=open(p,encoding='utf-8',newline='').read()
def rep(a,b,n=1):
    global s
    assert s.count(a)==n, (s.count(a), a[:80])
    s=s.replace(a,b)
# S554 THE BODY JAB: at Long only the jab reached and one hold stopped it. The body jab reaches Long too and is stopped by
# the lead hand held LOW: one hand cannot stop both, so Long has a guess (probe_body_jab.mjs: the sensible player's wins
# against the Jabber 97% -> 60%, the other two unchanged).
rep("  hook: { n: 'Lead hook', h: 0,",
    "  bjab: { n: 'Body jab', h: 0, st: 1, d: 1, sp: 1, reach: [2, 3], line: 'body', pic: 'body_jab', keep: 1, x: 'If it lands he cannot step in next beat.' },\n  hook: { n: 'Lead hook', h: 0,")
rep("const STOPS = { straight: 'his jab and his cross', side: 'his lead hook and his overhand', under: 'his uppercuts', body: 'his body hook and body cross' };",
    "const STOPS = { straight: 'his jab and his cross', side: 'his lead hook and his overhand', under: 'his uppercuts', body: 'his body jab, body hook and body cross' };")
rep("...['jab', 'hook', 'lup', 'lbody', 'feint', 'push'].map((id) => ({ lead: id, hl: 'high' }))];", "...['jab', 'bjab', 'hook', 'lup', 'lbody', 'feint', 'push'].map((id) => ({ lead: id, hl: 'high' }))];")
# the machine mixes it in: more often at a lead hand it last saw held high
rep("  // HE READS A HABIT: the same punches in two of your last three punching beats",
    "  if (p.lead === 'jab' && rnd() < (last.lead ? 0.35 : last.hl === 'high' ? 0.6 : 0.15)) p.lead = 'bjab';   // S554: the jab goes to the body, mostly at a lead hand he last saw held high\n  // HE READS A HABIT: the same punches in two of your last three punching beats")
rep("At Long you are giving ground toward the ropes.' } };", "At Long you are giving ground toward the ropes.' } };")
rep("Round 1. You start at Long: only a jab reaches.", "Round 1. You start at Long: only the jab and the body jab reach.")
open(p,'w',encoding='utf-8',newline='').write(s)
p='proto/twohands/tools/anim_check.mjs'; s=open(p,encoding='utf-8',newline='').read()
a="const PUNCHES = ['jab', 'cross',"; assert s.count(a)==1
s=s.replace(a,"const PUNCHES = ['jab', 'body_jab', 'cross',"); open(p,'w',encoding='utf-8',newline='').write(s)
p='tools/pics2d_set.gd'; s=open(p,encoding='utf-8',newline='').read()
a='	"cross": [["pro_right_cross", "pro_right_cross_ft", "pro_right_cross_a"], false],\n'; assert s.count(a)==1
s=s.replace(a,'	"body_jab": [["pro_left_jab", "pro_left_jab_a", "pro_left_jab_ft"], true],   # S554: the jab aimed at the body (Ring Switches)\n'+a)
open(p,'w',encoding='utf-8',newline='').write(s)
print('ok')
