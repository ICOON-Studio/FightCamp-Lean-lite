"""Blender helper: exported transient face maps to numpy for MH2 texturing."""
import bpy, numpy as np, pathlib, sys, json

cfg = json.load(open(sys.argv[sys.argv.index('--') + 1]))
work = pathlib.Path(cfg['work'])
work.mkdir(parents=True, exist_ok=True)
for name in ('face_normal', 'face_cavity'):
    img = bpy.data.images.load(cfg['export'] + '/tex/' + name + '.exr')
    w, h = img.size
    a = np.array(img.pixels[:], np.float32).reshape(h, w, 4)[::-1]
    np.save(work / (name + '.npy'), a)
    print('STAFF1 EXR', name, w, h)
