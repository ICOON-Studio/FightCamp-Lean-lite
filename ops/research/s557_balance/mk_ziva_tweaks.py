# S557: Ziva's rule ideas from the nine-bout playtest (ops/research/ZIVAPLAY1_REPORT.md, "TO REACH 10/10" 3 and 4),
# each written as a tweak file so it is measured on tools/balance.mjs before anything touches the page.
#   python ops/research/s557_balance/mk_ziva_tweaks.py
import io, json, os

here = os.path.dirname(os.path.abspath(__file__))
WEAR = "D.g = Math.max(0, D.g - (a.d >= 3 ? 1 : 0));"
RES = "function resolve(S, P) { const ev = [], f = S.f, say = (k, o) => ev.push({ k, ...o });"
PAY = "f[k].st -= cost(P[k]); f[k].last = { ...P[k] };"
tw = {
 # 3. "Price the block": today only a big punch wears the blocker's guard, by 1, and 1 comes back a beat - it ticked once in nine bouts
 'block_g1': {'_note': "A block costs the BLOCKER guard: every blocked punch wears it 1, a big one (3 health or more) 2. Guard 6, 1 back a beat.",
              'src': [[WEAR, "D.g = Math.max(0, D.g - (a.d >= 3 ? 2 : 1));"]]},
 'block_g2': {'_note': "A block costs the BLOCKER guard the punch's own health (jab 1 ... overhand 4). Guard 6, 1 back a beat.",
              'src': [[WEAR, "D.g = Math.max(0, D.g - a.d);"]]},
 'block_g2w': {'_note': "As block_g2, and the look-ahead values a point of guard at 0.4 health (0.15 on the page).",
               'W': {'guard': 0.4}, 'src': [[WEAR, "D.g = Math.max(0, D.g - a.d);"]]},
 # 4. "Give Long one honest punch ... or make the step-in cheaper in the moment it answers a back-off" (S555 measured the cross at Long: the jab dies)
 'chase': {'_note': "He backed off last beat: your step in this beat costs no stamina (the chase is free).",
           'src': [[RES, RES + " const was = [f[0].last, f[1].last];"],
                   [PAY, "f[k].st -= cost(P[k]) - (P[k].feet === 'in' && !P[k].clinch && was[1 - k] && was[1 - k].feet === 'back' && !was[1 - k].clinch ? 1 : 0); f[k].last = { ...P[k] };"]]},
}
for k, v in tw.items():
    io.open(os.path.join(here, k + '.json'), 'w', encoding='utf-8', newline='\n').write(json.dumps(v, indent=1) + '\n')
print(' '.join(tw))
