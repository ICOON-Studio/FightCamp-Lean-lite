"""Measure the paired pose: closest joint pairs between the two fighters,
plus the named contacts the pose was authored to make. Distances in metres.
"""
import csc
import json
import math
import numpy as np

import os
OUT = os.path.join(WORKDIR, "MEASURE.json")

sc = app.current_scene().domain_scene()
mv = sc.model_viewer()
dv = mv.data_viewer()
bv = mv.behaviour_viewer()

A, B = {}, {}
for o in mv.get_objects():
    nm = mv.get_object_name(o)
    if mv.get_object_type_name(o) != "Joint":
        continue
    tr = bv.get_behaviour_by_name(o, 'Transform')
    p = np.array(dv.get_data_value(bv.get_behaviour_data(tr, 'global_position'), 0), dtype=float)
    if nm.startswith("character1:"):
        B[nm[len("character1:"):]] = p
    else:
        A[nm] = p

pairs = []
for an, ap in A.items():
    for bn, bp in B.items():
        pairs.append((float(np.linalg.norm(ap - bp)) / 100.0, an, bn))
pairs.sort()

print("TEN CLOSEST JOINT PAIRS BETWEEN THE TWO FIGHTERS (metres)")
for d, an, bn in pairs[:10]:
    print("  %-18s <-> %-18s %6.3f m" % ("A." + an, "B." + bn, d))

NAMED = [
    ("A right hand", "hand_r", "B nape", "neck"),
    ("A left hand", "hand_l", "B nape", "neck"),
    ("B left hand", None, None, None),
]


def d(a_name, b_name):
    return float(np.linalg.norm(A[a_name] - B[b_name])) / 100.0


print()
print("THE AUTHORED CONTACTS (metres)")
rows = [
    ("A right hand -> B neck", d("hand_r", "neck")),
    ("A left hand  -> B neck", d("hand_l", "neck")),
    ("A right hand -> B head", d("hand_r", "head")),
    ("B left hand  -> A right arm", float(np.linalg.norm(B["hand_l"] - A["arm_r"])) / 100.0),
    ("B right hand -> A left arm", float(np.linalg.norm(B["hand_r"] - A["arm_l"])) / 100.0),
    ("head  <-> head", d("head", "head")),
    ("chest <-> chest", d("chest", "chest")),
    ("pelvis<-> pelvis", d("pelvis", "pelvis")),
]
for k, v in rows:
    print("  %-30s %6.3f m" % (k, v))

print()
print("FLOOR CHECK - lowest joint of each fighter (metres above ground)")
for tag, S in (("A", A), ("B", B)):
    lo = min(S.items(), key=lambda kv: kv[1][1])
    print("  %s lowest joint %-10s y = %6.3f m" % (tag, lo[0], lo[1][1] / 100.0))

json.dump({
    "closest_pairs_m": [{"a": an, "b": bn, "d_m": round(dd, 4)} for dd, an, bn in pairs[:20]],
    "named_contacts_m": {k: round(v, 4) for k, v in rows},
    "A_joints_cm": {k: [round(float(x), 2) for x in v] for k, v in A.items()},
    "B_joints_cm": {k: [round(float(x), 2) for x in v] for k, v in B.items()},
}, open(OUT, "w", encoding="utf-8"), indent=1)
print()
print("wrote", OUT)
