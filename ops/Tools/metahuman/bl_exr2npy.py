import bpy, numpy as np
for n in ("face_normal", "face_cavity"):
    img = bpy.data.images.load(f"E:/FightCamp/metahuman_pilot/export02/tex/{n}.exr")
    w, h = img.size
    a = np.array(img.pixels[:], np.float32).reshape(h, w, 4)[::-1]
    np.save(f"E:/FightCamp/metahuman_pilot/work02/{n}.npy", a)
    print("EXR", n, w, h, [(float(a[..., i].min()), float(a[..., i].max()), float(a[..., i].mean())) for i in range(4)])
