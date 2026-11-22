"""CASCTEST1: try each snap action id the DLL carries and say whether the rear knee point moved (frame 9)."""
import traceback
try:
    VARIANT
except NameError:
    VARIANT = 'AutoPhysics.Snap to Physics'
try:
    sc = app.current_scene(); ds = sc.domain_scene()
    mv = ds.model_viewer(); bv = mv.behaviour_viewer(); dv = mv.data_viewer(); lv = ds.layers_viewer()
    def knee():
        for o in mv.get_objects():
            if mv.get_object_name(o) == 'RightLeg_MainPoint':
                d = bv.get_behaviour_data(bv.get_behaviour_by_name(o, 'Transform'), 'global_position')
                return [[round(float(x), 3) for x in dv.get_data_value(d, f)] for f in (0, 5, 9, 14)]
    if VARIANT == 'keys':
        for lid in lv.all_layer_ids():
            L = lv.layer(lid)
            print('layer', L.header.name if hasattr(L, 'header') else '?', 'keys', len(lv.significant_frames([lid])) if True else '')
    else:
        print('knee before', knee())
        r = app.get_action_manager().call_action(VARIANT)
        print('call_action', VARIANT, '->', r)
        print('knee right after', knee())
except Exception:
    print('TRACEBACK', traceback.format_exc())
