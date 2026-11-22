"""CASCTEST1 probe: which frames carry keys after the quick rig, and what is selected."""
import traceback
try:
    ds = app.current_scene().domain_scene(); lv = ds.layers_viewer(); mv = ds.model_viewer()
    sf = lv.significant_frames()
    print('significant_frames:', [m for m in dir(sf) if not m.startswith('_')])
    try: print('list:', list(sf)[:40])
    except Exception as e: print('not iterable', e)
    for lid in lv.all_layer_ids():
        L = lv.layer(lid)
        attrs = [m for m in dir(L) if not m.startswith('_')]
        try:
            name = L.header.name
        except Exception:
            name = '?'
        info = ''
        for a in ('sections', 'key_frames', 'keys', 'frames'):
            if hasattr(L, a):
                try:
                    v = getattr(L, a); v = v() if callable(v) else v
                    info += ' %s=%s' % (a, str(v)[:120])
                except Exception as e:
                    info += ' %s ERR' % a
        print('layer', name, info, '| attrs' , attrs if name == '?' or not info else '')
    sel = ds.selector().selected()
    print('selected ids', len(sel.ids))
    ls = ds.get_layers_selector()
    print('layers selector:', [m for m in dir(ls) if not m.startswith('_')])
except Exception:
    print('TRACEBACK', traceback.format_exc())
