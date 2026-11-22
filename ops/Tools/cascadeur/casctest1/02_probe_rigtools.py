"""CASCTEST1 probe: what the rigging tools expose to Python (quick rig from a template, rig mode on/off)."""
import traceback
try:
    tm = app.get_tools_manager(); sc = app.current_scene()
    for name in ['RiggingModeTool', 'RiggingToolWindowTool', 'AutoPhysicsTool']:
        try:
            ed = tm.get_tool(name).editor(sc)
            print(name, [m for m in dir(ed) if not m.startswith('_')])
        except Exception as e:
            print(name, 'ERR', e)
    am = app.get_action_manager()
    print('am', [m for m in dir(am) if not m.startswith('_')])
except Exception:
    print('TRACEBACK', traceback.format_exc())
