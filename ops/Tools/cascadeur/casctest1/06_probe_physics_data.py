"""CASCTEST1 probe: where AutoPhysics keeps its solved result (behaviours and data names per object type)."""
import traceback
try:
    ds = app.current_scene().domain_scene()
    mv = ds.model_viewer(); bv = mv.behaviour_viewer(); dv = mv.data_viewer()
    print('bv:', [m for m in dir(bv) if not m.startswith('_')])
    print('dv:', [m for m in dir(dv) if not m.startswith('_')])
    seen = {}
    names = []
    for o in mv.get_objects():
        t = mv.get_object_type_name(o)
        if t == 'Point': names.append(mv.get_object_name(o))
        if t in seen: continue
        seen[t] = 1
        print('==', t, mv.get_object_name(o))
        for b in bv.get_behaviours(o) if hasattr(bv, 'get_behaviours') else []:
            try:
                bn = bv.get_behaviour_name(b)
                print('   beh', bn)
            except Exception as e:
                print('   beh ?', e)
    print('points:', names)
except Exception:
    print('TRACEBACK', traceback.format_exc())
