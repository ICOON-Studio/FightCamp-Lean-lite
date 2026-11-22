"""CASCTEST1: dump per-frame world positions (cm) of the leg/trunk/arm joints to <TAG>.json.
Run through csend with TAG set by a prefix line (see run notes in docs/CASCTEST1_RESULT.md)."""
import json, os, traceback
try:
    TAG
except NameError:
    TAG = 'before'
WANT = ['Hips','Spine','Spine1','Spine2','Neck','Head','LeftUpLeg','LeftLeg','LeftFoot','LeftToeBase','LeftToeEnd',
        'RightUpLeg','RightLeg','RightFoot','RightToeBase','RightToeEnd','LeftArm','LeftForeArm','LeftHand',
        'RightArm','RightForeArm','RightHand','LeftShoulder','RightShoulder']
try:
    ds = app.current_scene().domain_scene()
    mv = ds.model_viewer(); dv = mv.data_viewer(); bv = mv.behaviour_viewer(); lv = ds.layers_viewer()
    n = lv.frames_count()
    out = {'frames': n, 'joints': {}}
    for o in mv.get_objects():
        if mv.get_object_type_name(o) != 'Joint':
            continue
        nm = mv.get_object_name(o)
        if nm not in WANT:
            continue
        tr = bv.get_behaviour_by_name(o, 'Transform')
        d = bv.get_behaviour_data(tr, 'global_position')
        out['joints'][nm] = [[round(float(x), 3) for x in dv.get_data_value(d, f)] for f in range(n)]
    for o in mv.get_objects():
        if mv.get_object_type_name(o) == 'Center of Mass':
            tr = bv.get_behaviour_by_name(o, 'Transform')
            if not tr.is_null():
                d = bv.get_behaviour_data(tr, 'global_position')
                if not d.is_null():
                    out['com'] = [[round(float(x), 3) for x in dv.get_data_value(d, f)] for f in range(n)]
    p = os.path.join(WORKDIR, TAG + '.json')
    json.dump(out, open(p, 'w'))
    print('wrote', p, 'frames', n, 'joints', len(out['joints']))
    h = out['joints']['Hips']
    print('Hips f0', h[0], 'last', h[-1])
except Exception:
    print('TRACEBACK', traceback.format_exc())
