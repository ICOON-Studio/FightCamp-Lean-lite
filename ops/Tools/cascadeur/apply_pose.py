"""Apply a table of controller world positions, then report the resulting joints.

Reads S30_POSE.json:  {"targets": {"<controller name>": [x, y, z], ...}}
Controller names are Cascadeur object names; fighter B is prefixed 'character1:'.
"""
import csc
import json
import numpy as np

import os
PATH = os.path.join(WORKDIR, "POSE.json")

with open(PATH, "r", encoding="utf-8") as fh:
    spec = json.load(fh)

sc = app.current_scene().domain_scene()
mv = sc.model_viewer()
dv = mv.data_viewer()
bv = mv.behaviour_viewer()

N = {}
for o in mv.get_objects():
    N[mv.get_object_name(o)] = o


def pos_data(nm):
    tr = bv.get_behaviour_by_name(N[nm], 'Transform')
    return bv.get_behaviour_data(tr, 'global_position')


def gp(nm):
    return np.array(dv.get_data_value(pos_data(nm), 0), dtype=float)


plan = []
missing = []
for nm, xyz in spec["targets"].items():
    if nm not in N:
        missing.append(nm)
        continue
    plan.append((nm, pos_data(nm), np.array(xyz, dtype=np.float32)))

if missing:
    print("MISSING CONTROLLERS:", missing)

touched = set()


def mod(me, ue, su):
    de = me.data_editor()
    for nm, did, tgt in plan:
        de.set_data_value(did, 0, tgt)
        touched.add(did)
    su.run_update(touched, 0)


print("controllers set:", len(plan), "| modify_update ->",
      sc.modify_update(spec.get("label", "S30 pose"), mod))

# report: where the controllers actually ended up vs where they were asked to go
print()
print("%-30s %-24s %-24s %s" % ("controller", "asked", "got", "err cm"))
for nm, did, tgt in plan:
    got = gp(nm)
    print("%-30s %-24s %-24s %6.2f" % (nm, np.round(tgt, 1), np.round(got, 1),
                                       float(np.linalg.norm(got - tgt))))
