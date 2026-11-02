"""Dump every controller and joint world position of the current scene to RIG.json.

Run through csend.py, which injects WORKDIR. Positions are in CENTIMETRES,
which is what Cascadeur reports.
"""
import os

import csc
import numpy as np
import json

OUT = os.path.join(WORKDIR, "RIG.json")

sc = app.current_scene().domain_scene()
mv = sc.model_viewer()
dv = mv.data_viewer()
bv = mv.behaviour_viewer()

out = {"controllers": {}, "joints": {}}
for o in mv.get_objects():
    nm = mv.get_object_name(o)
    t = mv.get_object_type_name(o)
    tr = bv.get_behaviour_by_name(o, 'Transform')
    if tr.is_null():
        continue
    d = bv.get_behaviour_data(tr, 'global_position')
    if d.is_null():
        continue
    p = [round(float(x), 4) for x in dv.get_data_value(d, 0)]
    if t in ("Point", "Limb Direction"):
        out["controllers"][nm] = p
    elif t == "Joint":
        out["joints"][nm] = p

with open(OUT, "w", encoding="utf-8") as fh:
    json.dump(out, fh, indent=1)
print("wrote", OUT, "controllers:", len(out["controllers"]), "joints:", len(out["joints"]))
