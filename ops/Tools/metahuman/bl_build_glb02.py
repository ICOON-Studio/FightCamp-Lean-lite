"""MH1 Core Data pass: MetaHuman Creator exports (export02: preset face + body FBX, groom cards, groom heads) -> ONE GLB.
blender --background --python bl_build_glb02.py -- <export02_dir> <texture_dir> <out.glb> [hair_lod] [brow_lod]
Same body/face handling as bl_build_glb.py (body LOD1 + face LOD1, one 341-joint skeleton, face joints folded into
`head`, trunks slot), plus the groom CARDS (Godot cannot render strands):
- the cards are authored on the groom's own reference head (MH_Groom_Head for hair, SKM_Groom_Head_Legacy02 for brows,
  read from the GroomBindingAssets), NOT on this character's face. The MetaHuman Creator re-binds them with an RBF on
  the head surface; here the same idea: head vertices are paired across the two heads by their UV (same MetaHuman
  head UV layout), and every card vertex moves by the inverse-distance-weighted displacement of its 16 nearest
  reference-head vertices. Card vertices that still end up inside the face are pushed out to 1.5 mm (counted).
- cards are rigid on `head` (weight 1), material MH_Hair / MH_Brows (RGBA coverage atlas)."""
import bpy, bmesh, sys, os, collections
from mathutils import Vector, kdtree, bvhtree
argv = sys.argv[sys.argv.index("--") + 1:]
EXP, TEX, OUT = argv[0], argv[1], argv[2]
HAIR_LOD = int(argv[3]) if len(argv) > 3 else 2
BROW_LOD = int(argv[4]) if len(argv) > 4 else 2
BODY_LOD, FACE_LOD = 1, 1
bpy.ops.wm.read_factory_settings(use_empty=True)


def imp(path):
    before = set(bpy.data.objects)
    bpy.ops.import_scene.fbx(filepath=os.path.join(EXP, path), use_anim=False)
    return set(bpy.data.objects) - before


body_objs = imp("Body.fbx")
face_objs = imp("Face.fbx")
gh_objs = imp("groom/MH_Groom_Head.fbx")
gl_objs = imp("groom/SKM_Groom_Head_Legacy02.fbx")
hair_objs = imp(f"groom/Hair_S_BrushCut_CardsMesh_Group0_LOD{HAIR_LOD}.fbx")
brow_objs = imp(f"groom/Eyebrows_M_Dense_CardMesh_Group0_LOD{BROW_LOD}.fbx")
arm = next(o for o in body_objs if o.type == 'ARMATURE')
body = next(o for o in body_objs if o.type == 'MESH' and o.name.endswith(f"_LOD{BODY_LOD}"))
face = next(o for o in face_objs if o.type == 'MESH' and o.name.endswith(f"_LOD{FACE_LOD}"))
face0 = next(o for o in face_objs if o.type == 'MESH' and o.name.endswith("_LOD0"))
ghead = next(o for o in gh_objs if o.type == 'MESH' and o.name.endswith("_LOD0"))
lhead = next(o for o in gl_objs if o.type == 'MESH')
hair = next(o for o in hair_objs if o.type == 'MESH')
brow = next(o for o in brow_objs if o.type == 'MESH')
print("MH1B02 face materials", [m.name for m in face.data.materials])


def skin_verts(o):
    """world position + head-UV of every vertex used by material slot 0 (the head skin)."""
    mw = o.matrix_world
    uvl = o.data.uv_layers[0].data
    uv = {}
    for p in o.data.polygons:
        if p.material_index != 0:
            continue
        for li, vi in zip(p.loop_indices, p.vertices):
            if vi not in uv:
                uv[vi] = uvl[li].uv.copy()
    return {vi: (mw @ o.data.vertices[vi].co, uv[vi]) for vi in uv}


def surface_bvh(o):
    mw = o.matrix_world
    verts = [mw @ v.co for v in o.data.vertices]
    polys = [list(p.vertices) for p in o.data.polygons if p.material_index == 0]
    return bvhtree.BVHTree.FromPolygons(verts, polys)


T = skin_verts(face0)
kd_uv = kdtree.KDTree(len(T))
for vi, (_, uv) in T.items():
    kd_uv.insert(Vector((uv.x, uv.y, 0.0)), vi)
kd_uv.balance()
tgt_bvh = surface_bvh(face)   # penetration is judged against the mesh the game draws (LOD1)


def fit(cards, ref, label):
    S = skin_verts(ref)
    pairs = []
    for vi, (pos, uv) in S.items():
        co, ti, d = kd_uv.find(Vector((uv.x, uv.y, 0.0)))
        if d < 2e-3:
            pairs.append((pos, T[ti][0] - pos))
    kd = kdtree.KDTree(len(pairs))
    for i, (pos, _) in enumerate(pairs):
        kd.insert(pos, i)
    kd.balance()
    cards.data.transform(cards.matrix_world)
    cards.matrix_world.identity()
    def inside_count():
        n = 0
        for v in cards.data.vertices:
            loc, nrm, _, _ = tgt_bvh.find_nearest(v.co)
            if loc is not None and (v.co - loc).dot(nrm) < -0.001:
                n += 1
        return n
    before = inside_count()               # control: the unfitted cards on this face
    mags = []
    for v in cards.data.vertices:
        acc = Vector((0, 0, 0)); ws = 0.0
        for co, i, d in kd.find_n(v.co, 16):
            w = 1.0 / (d * d + 1e-6)
            acc += pairs[i][1] * w; ws += w
        disp = acc / ws
        mags.append(disp.length)
        v.co += disp
    after = inside_count()
    pushed = 0
    for v in cards.data.vertices:
        loc, nrm, _, _ = tgt_bvh.find_nearest(v.co)
        if loc is None:
            continue
        sd = (v.co - loc).dot(nrm)
        if sd < -0.001:
            pushed += 1
        if sd < 0.0015:
            v.co = loc + nrm * 0.0015
    mags.sort()
    nv = len(cards.data.vertices)
    print(f"MH1B02 FIT {label}: ref={ref.name} paired {len(pairs)}/{len(S)} head verts; displacement median "
          f"{mags[len(mags)//2]*1000:.1f} mm max {mags[-1]*1000:.1f} mm; card verts inside the face >1 mm: "
          f"unfitted {before}/{nv} ({100*before/nv:.1f}%), fitted {after}/{nv} ({100*after/nv:.1f}%), pushed out {pushed}")


fit(hair, ghead, "hair")
fit(brow, lhead, "brows")

# Neck seam samples: the head mesh's lowest open boundary (skin slot) and the body vertex under each point, both as
# UVs, so make_textures02.py can match the body albedo to the head at the seam (run: build, textures, build).
import json
fmw = face.matrix_world; bmw = body.matrix_world
ec = collections.Counter()
for p in face.data.polygons:
    if p.material_index == 0:
        for ek in p.edge_keys:
            ec[ek] += 1
bverts = {v for ek, n in ec.items() if n == 1 for v in ek}
zmin = min((fmw @ face.data.vertices[v].co).z for v in bverts)
low = {v for v in bverts if (fmw @ face.data.vertices[v].co).z < zmin + 0.12}
fuv = {}
for p in face.data.polygons:
    if p.material_index == 0:
        for li, vi in zip(p.loop_indices, p.vertices):
            if vi in low and vi not in fuv:
                fuv[vi] = tuple(face.data.uv_layers[0].data[li].uv)
kb = kdtree.KDTree(len(body.data.vertices))
for v in body.data.vertices:
    kb.insert(bmw @ v.co, v.index)
kb.balance()
buv = {}
for p in body.data.polygons:
    for li, vi in zip(p.loop_indices, p.vertices):
        buv.setdefault(vi, tuple(body.data.uv_layers[0].data[li].uv))
pairs = []
for vi, uv in fuv.items():
    co, bi, d = kb.find(fmw @ face.data.vertices[vi].co)
    if d < 0.01:
        pairs.append([uv, buv[bi]])
json.dump(pairs, open(os.path.join(TEX, "seam_uv.json"), "w"))
print("MH1B02 seam samples", len(pairs), "of", len(fuv), "low boundary verts")
keep = {arm, body, face, hair, brow}
for o in list(keep):
    mw = o.matrix_world.copy(); o.parent = None; o.matrix_world = mw
for o in list(bpy.data.objects):
    if o not in keep:
        bpy.data.objects.remove(o, do_unlink=True)
# face: drop hidden sections by UE slot index (head, teeth, saliva, eyeLeft, eyeRight, eyeshell, eyelashes, eyeEdge, cartilage)
DROP = {2, 5, 7, 8}
bm = bmesh.new(); bm.from_mesh(face.data)
bmesh.ops.delete(bm, geom=[f for f in bm.faces if f.material_index in DROP], context='FACES')
bm.to_mesh(face.data); bm.free()
bones = {b.name for b in arm.data.bones}
head_vg = face.vertex_groups.get("head") or face.vertex_groups.new(name="head")
fold = [vg for vg in face.vertex_groups if vg.name not in bones]
idx = {vg.index: vg for vg in fold}
for v in face.data.vertices:
    w = sum(g.weight for g in v.groups if g.group in idx)
    if w > 0:
        head_vg.add([v.index], w, 'ADD')
for vg in fold:
    face.vertex_groups.remove(vg)
for c in (hair, brow):     # rigid on the head joint; atlas UV first and only
    for vg in list(c.vertex_groups):
        c.vertex_groups.remove(vg)
    g = c.vertex_groups.new(name="head")
    g.add(list(range(len(c.data.vertices))), 1.0, 'REPLACE')
    while len(c.data.uv_layers) > 1:
        c.data.uv_layers.remove(c.data.uv_layers[-1])
for o in (body, face, hair, brow):
    for m in list(o.modifiers):
        o.modifiers.remove(m)
    o.parent = arm
    o.matrix_parent_inverse = arm.matrix_world.inverted()
    mod = o.modifiers.new("Armature", 'ARMATURE'); mod.object = arm
bpy.ops.object.select_all(action='DESELECT')
for o in (arm, body, face, hair, brow):
    o.select_set(True)
bpy.context.view_layer.objects.active = arm
bpy.ops.object.transform_apply(location=False, rotation=True, scale=True)


def img(name, noncolor=False):
    i = bpy.data.images.load(os.path.join(TEX, name))
    if noncolor:
        i.colorspace_settings.name = 'Non-Color'
    return i


def mat(name, albedo=None, normal=None, rough=0.5, color=(1, 1, 1, 1), alpha=None, clip=False):
    m = bpy.data.materials.new(name); m.use_nodes = True
    nt = m.node_tree; p = nt.nodes["Principled BSDF"]
    p.inputs["Roughness"].default_value = rough
    p.inputs["Base Color"].default_value = color
    if albedo:
        t = nt.nodes.new("ShaderNodeTexImage"); t.image = img(albedo)
        nt.links.new(t.outputs["Color"], p.inputs["Base Color"])
        if clip:
            nt.links.new(t.outputs["Alpha"], p.inputs["Alpha"])
            m.surface_render_method = 'DITHERED'
    if normal:
        t = nt.nodes.new("ShaderNodeTexImage"); t.image = img(normal, True)
        nm = nt.nodes.new("ShaderNodeNormalMap")
        nt.links.new(t.outputs["Color"], nm.inputs["Color"]); nt.links.new(nm.outputs["Normal"], p.inputs["Normal"])
    if alpha is not None:
        p.inputs["Alpha"].default_value = alpha
        m.surface_render_method = 'BLENDED'
    return m


skin_h = mat("MH_Skin_Head", "mh02_head_albedo.jpg", "mh02_head_normal.jpg", 0.5)
skin_b = mat("MH_Skin_Body", "mh02_body_albedo.jpg", "mh02_body_normal.jpg", 0.5)
teeth = mat("MH_Teeth", None, None, 0.35, (0.85, 0.82, 0.75, 1))
eye = mat("MH_Eye", "mh_pilot_eye_albedo.jpg", None, 0.05)
lash = mat("MH_Eyelashes", None, None, 0.6, (0.03, 0.025, 0.02, 1), alpha=0.75)
hair_m = mat("MH_Hair", "mh02_hair_cards.png", None, 0.45, clip=True)
brow_m = mat("MH_Brows", "mh02_brow_cards.png", None, 0.5, clip=True)
body.data.materials.clear(); body.data.materials.append(skin_b)
trunks = mat("MH_Trunks", None, None, 0.4, (0.55, 0.05, 0.06, 1))
body.data.materials.append(trunks)
mw = arm.matrix_world
n_tr = 0
for p in body.data.polygons:
    c = mw @ p.center
    if 0.64 <= c.z <= 1.07 and abs(c.x) < 0.235:
        p.material_index = 1; n_tr += 1
print("MH1B02 trunks faces", n_tr)
remap = {0: 0, 1: 1, 3: 2, 4: 2, 6: 3}
orig = [p.material_index for p in face.data.polygons]
face.data.materials.clear()
for m in (skin_h, teeth, eye, lash):
    face.data.materials.append(m)
for p, i in zip(face.data.polygons, orig):
    p.material_index = remap.get(i, 0)
for c, m in ((hair, hair_m), (brow, brow_m)):
    c.data.materials.clear(); c.data.materials.append(m)
print("MH1B02 face material counts", dict(collections.Counter(p.material_index for p in face.data.polygons)))
arm.name = "MH_Pilot02"; body.name = "MH_Body"; face.name = "MH_Head"; hair.name = "MH_HairCards"; brow.name = "MH_BrowCards"
tris = {o.name: sum(len(p.vertices) - 2 for p in o.data.polygons) for o in (body, face, hair, brow)}
print("MH1B02 tris", tris, "total", sum(tris.values()), "bones", len(arm.data.bones), "folded", len(fold),
      "height_m", round(max((arm.matrix_world @ v.co).z for v in face.data.vertices), 3))
bpy.ops.export_scene.gltf(filepath=OUT, export_format='GLB', use_selection=False, export_yup=True,
    export_skins=True, export_animations=False, export_morph=False, export_image_format='AUTO',
    export_jpeg_quality=90, export_apply=False, export_vertex_color='NONE')
print("MH1B02 wrote", OUT, os.path.getsize(OUT))
