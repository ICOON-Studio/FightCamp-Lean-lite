"""CASCTEST1: dump every Rigid Body's centre per frame (cm) -> <TAG>.json. With AutoPhysics on these are compared
against the same dump with it off, to see whether the solved motion is readable there."""
import json, os, traceback
try:
    TAG
except NameError:
    TAG = 'rigid'
try:
    ds = app.current_scene().domain_scene()
    mv = ds.model_viewer(); bv = mv.behaviour_viewer(); dv = mv.data_viewer(); n = ds.layers_viewer().frames_count()
    out = {}
    for o in mv.get_objects():
        t = mv.get_object_type_name(o)
        if t not in ('Rigid Body', 'Center of Mass', 'Point'): continue
        d = bv.get_behaviour_data(bv.get_behaviour_by_name(o, 'Transform'), 'global_position')
        if d.is_null(): continue
        out[mv.get_object_name(o)] = [[round(float(x), 3) for x in dv.get_data_value(d, f)] for f in range(n)]
    json.dump(out, open(os.path.join(WORKDIR, TAG + '.json'), 'w'))
    print('wrote', TAG, len(out))
except Exception:
    print('TRACEBACK', traceback.format_exc())
