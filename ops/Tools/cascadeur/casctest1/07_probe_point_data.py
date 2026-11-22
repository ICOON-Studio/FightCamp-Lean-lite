"""CASCTEST1 probe: every data channel on the rear-knee rig point, with its value at frame 0 and 9."""
import traceback
try:
    ds = app.current_scene().domain_scene()
    mv = ds.model_viewer(); bv = mv.behaviour_viewer(); dv = mv.data_viewer()
    for o in mv.get_objects():
        nm = mv.get_object_name(o)
        if nm not in ('RightLeg_MainPoint', 'Center of mass', 'Hips_Rigid'):
            continue
        print('#####', nm)
        for b in bv.get_behaviours(o):
            bn = bv.get_behaviour_name(b)
            try:
                props = list(bv.get_behaviour_property_names(b))
            except Exception as e:
                props = ['ERR %s' % e]
            line = []
            for p in props:
                try:
                    d = bv.get_behaviour_data(b, p)
                    if d.is_null(): continue
                    v0 = dv.get_data_value(d, 0); v9 = dv.get_data_value(d, 9)
                    line.append('%s[%s]: f0=%s f9=%s' % (p, dv.get_data_name(d) if hasattr(dv, 'get_data_name') else '', str(v0)[:60].replace('\n', ' '), str(v9)[:60].replace('\n', ' ')))
                except Exception as e:
                    pass
            print('  ', bn, props if not line else '')
            for l in line: print('       ', l)
except Exception:
    print('TRACEBACK', traceback.format_exc())
