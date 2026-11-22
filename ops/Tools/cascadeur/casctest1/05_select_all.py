"""CASCTEST1: select every rig controller on every frame of every layer (Snap to Auto Physics works on the selection)."""
import traceback
try:
    ds = app.current_scene().domain_scene()
    mv = ds.model_viewer(); lv = ds.layers_viewer(); n = lv.frames_count()
    ids = [o for o in mv.get_objects() if mv.get_object_type_name(o) in ('Point', 'Limb Direction', 'Box', 'Center of Mass')]
    layers = list(lv.all_layer_ids())
    def mod(*args):
        session = args[-1]
        session.take_layers_selector().set_full_selection_by_parts(layers, 0, n - 1)
        session.take_selector().select(set(ids), ids[0])
    print('ds modify fns:', [m for m in dir(ds) if 'modif' in m or 'select' in m.lower()])
    print('select ok:', ds.modify_with_session('CASCTEST1 select all', mod), 'objects', len(ids), 'layers', len(layers), 'frames', n)
    print('selected now:', len(ds.selector().selected().ids) if hasattr(ds, 'selector') else '?')
except Exception:
    print('TRACEBACK', traceback.format_exc())
