"""CASCTEST1 step 3: AutoPhysics on the rigged take, by the app's own toolbar actions (ANIMSOURCE1A).
STAGE = 'save_before' | 'on' | 'snap' | 'save_after' | 'off'. One stage per request (the solve runs at idle)."""
import os, traceback
try:
    STAGE
except NameError:
    STAGE = 'on'
try:
    sc = app.current_scene()
    ed = app.get_tools_manager().get_tool('AutoPhysicsTool').editor(sc)
    am = app.get_action_manager()
    if STAGE.startswith('save_'):
        p = os.path.join(WORKDIR, 'cross_' + STAGE[5:] + '.casc')
        sc.save(p); print('saved', p)
    elif STAGE == 'on':
        ed.turn_off()
        am.call_action('AutoPhysicsTool.Switch Auto Physics')
        print('AutoPhysics switched on from a known off state')
    elif STAGE == 'snap':
        am.call_action('AutoPhysicsTool.Snap to Auto Physics')
        print('Snap to Auto Physics called')
    elif STAGE == 'off':
        ed.turn_off(); print('AutoPhysics off')
except Exception:
    print('TRACEBACK', traceback.format_exc())
