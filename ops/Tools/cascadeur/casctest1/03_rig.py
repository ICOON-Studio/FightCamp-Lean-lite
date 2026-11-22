"""CASCTEST1 step 2: quick-rig the imported take with Cascadeur's own Mixamo (no namespace) template.
STAGE = 'on' | 'qrt' | 'off' - one stage per request so the app reaches an idle boundary between them."""
import traceback
TPL = r'C:/Program Files/Cascadeur/resources/autorig_templates/Mixamo_No_Namespace_Template_New.qrigcasc'
try:
    STAGE
except NameError:
    STAGE = 'on'
try:
    import rig_mode.on as rm_on, rig_mode.off as rm_off
    sc = app.current_scene(); ds = sc.domain_scene()
    tool = app.get_tools_manager().get_tool('RiggingToolWindowTool').editor(sc)
    if STAGE == 'on':
        rm_on.run_raw(ds, [0.0, 0.5, 0.0])
    elif STAGE == 'qrt':
        # The quick rig shows its warnings in a Continue/Cancel dialog; on a hidden desktop nobody can click it.
        # Print the warnings and continue (what the Continue button does).
        import prototypes.rigs._rigs as p_rigs
        if not hasattr(p_rigs.RigDefinition, '_casctest_orig_warn'):
            p_rigs.RigDefinition._casctest_orig_warn = p_rigs.RigDefinition.get_preprocess_warnings
            def _warn(self):
                print('QRT WARNINGS (continued past):', p_rigs.RigDefinition._casctest_orig_warn(self))
                return []
            p_rigs.RigDefinition.get_preprocess_warnings = _warn
        print('create_from_qrt:', tool.create_from_qrt_by_fileName(TPL))
    elif STAGE == 'gen':
        print('generate:', tool.generate_rig_elements())
    elif STAGE == 'off':
        rm_off.run(ds, True)
    mv = ds.model_viewer(); types = {}
    for o in mv.get_objects():
        t = mv.get_object_type_name(o); types[t] = types.get(t, 0) + 1
    print(STAGE, 'types:', types, 'frames', ds.layers_viewer().frames_count())
except Exception:
    print('TRACEBACK', traceback.format_exc())
