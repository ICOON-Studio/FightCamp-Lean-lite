# S557: the look-ahead learns the ground rule (S556 NOT GREEN). Since S556 a round level on points goes to the man who
# backed off less, but the opponents' beat solver values a back off only as rope behind the man (W.ropes), which a
# step in wins back. Tried, each as a tweak file measured on tools/balance.mjs and tools/probe_ground.mjs:
#   gave_NN : every back off costs the man NN/100 health in the solver's eyes for the rest of the round (a new W.gave)
#   ropes50 : the rope behind a man is worth twice as much (W.ropes 0.25 -> 0.5), nothing else
#   python ops/research/s557_balance/mk_ground_tweaks.py
import io, json, os

here = os.path.dirname(os.path.abspath(__file__))
RET = "return (y0.hp - y.hp) - (x0.hp - x.hp) + W.cap *"
GAVE = "return (W.gave || 0) * (((y.gave || 0) - (y0.gave || 0)) - ((x.gave || 0) - (x0.gave || 0))) + (y0.hp - y.hp) - (x0.hp - x.hp) + W.cap *"
tw = {'ropes50': {'_note': "The rope behind a man is worth 0.5 health a step (0.25 on the page).", 'W': {'ropes': 0.5}}}
for v in (15, 30, 50):
    tw['gave_%d' % v] = {'_note': "A back off costs the man %.2f health in the solver's eyes (the round may go to the other man on ground)." % (v / 100.0),
                         'W': {'gave': v / 100.0}, 'src': [[RET, GAVE]]}
for k, v in tw.items():
    io.open(os.path.join(here, k + '.json'), 'w', encoding='utf-8', newline='\n').write(json.dumps(v, indent=1) + '\n')
print(' '.join(tw))
