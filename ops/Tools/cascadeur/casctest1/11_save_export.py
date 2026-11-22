"""CASCTEST1: what the FREE tier lets out. Saves the scene as .casc (kept local, git-ignored) and TRIES an FBX and a
GLB export into WORKDIR/_export_test/ - only to record whether the free licence allows it; the files are deleted by
the caller straight after (nothing made on the free tier enters the game)."""
import os, traceback
try:
    STAGE
except NameError:
    STAGE = 'save'
sc = app.current_scene(); ds = sc.domain_scene()
if STAGE == 'save':
    try:
        p = os.path.join(WORKDIR, 'cross_autophysics.casc'); sc.save(p); print('saved .casc', os.path.exists(p), os.path.getsize(p))
    except Exception: print('SAVE TRACEBACK', traceback.format_exc())
if STAGE == 'fbx':
    try:
        d = os.path.join(WORKDIR, '_export_test'); os.makedirs(d, exist_ok=True)
        loader = app.get_tools_manager().get_tool('FbxSceneLoader').get_fbx_loader(sc)
        p = os.path.join(d, 'x.fbx').replace('\\', '/'); loader.export_all_objects(p)
        print('fbx export returned; file exists:', os.path.exists(p), os.path.getsize(p) if os.path.exists(p) else 0)
    except Exception: print('FBX TRACEBACK', traceback.format_exc())
if STAGE == 'glb':
    try:
        d = os.path.join(WORKDIR, '_export_test'); os.makedirs(d, exist_ok=True)
        o = csc.glb.ExportOptions(); o.include_animation = True; o.fps = 30
        p = os.path.join(d, 'x.glb').replace('\\', '/'); csc.glb.process_export(ds, p, o)
        print('glb export returned; file exists:', os.path.exists(p), os.path.getsize(p) if os.path.exists(p) else 0)
    except Exception: print('GLB TRACEBACK', traceback.format_exc())
if STAGE == 'tools':
    tm = app.get_tools_manager()
    for name in ['InbetweeningTool', 'Inbetweening', 'AutoInterpolationTool', 'RetargetingTool', 'MocapTool', 'FixFootTool']:
        try:
            ed = tm.get_tool(name).editor(sc); print(name, [m for m in dir(ed) if not m.startswith('_')])
        except Exception as e: print(name, 'ERR', str(e)[:80])
