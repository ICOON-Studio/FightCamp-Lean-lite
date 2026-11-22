"""CASCTEST1 step 1: import the bought cross take (its own skeleton + keys) into the empty scene.
Run: python ops/Tools/cascadeur/csend.py ops/Tools/cascadeur/casctest1/01_import.py
The FBX stays in the pack folder outside the repo; nothing is copied."""
import traceback, json, os
FBX = r'E:/FightCamp/packs/mocaponline_punch_pro/Boxing_01_v2/FBX/Box1_M3_Right_Cross.fbx'
try:
    sc = app.current_scene()
    tool = app.get_tools_manager().get_tool('FbxSceneLoader')
    print('loader tool methods:', [m for m in dir(tool) if not m.startswith('_')])
    loader = tool.get_fbx_loader(sc)
    print('loader methods:', [m for m in dir(loader) if not m.startswith('_')])
    loader.import_scene(FBX)
    ds = sc.domain_scene()
    mv = ds.model_viewer()
    types = {}
    names = []
    for o in mv.get_objects():
        t = mv.get_object_type_name(o)
        types[t] = types.get(t, 0) + 1
        if t == 'Joint':
            names.append(mv.get_object_name(o))
    print('types:', types)
    print('joints:', names)
    lv = ds.layers_viewer()
    print('layers_viewer:', [m for m in dir(lv) if not m.startswith('_')])
except Exception:
    print('TRACEBACK', traceback.format_exc())
