"""MH1: MetaHuman Creator FBX exports (Body.fbx + Face.fbx, all LODs) -> ONE game GLB.
blender --background --python bl_build_glb.py -- <export_dir> <texture_dir> <out.glb> [body_lod] [face_lod]
- keeps body LOD1 + face LOD1 (~48k tris), drops the hidden face sections (saliva, eye shell, eye edge, cartilage)
- one skeleton: the body's UE5 MetaHuman skeleton (names kept); face-only joints (FACIAL_*, ~550) are folded into
  `head` (no facial animation in the game; the head stays rigid with the head bone)
- metres, Y-up glTF, A-pose bind kept (Godot's retarget derives its own rest corrections)"""
import bpy, sys, os
argv = sys.argv[sys.argv.index("--") + 1:]
EXP, TEX, OUT = argv[0], argv[1], argv[2]
BODY_LOD = int(argv[3]) if len(argv) > 3 else 1
FACE_LOD = int(argv[4]) if len(argv) > 4 else 1
bpy.ops.wm.read_factory_settings(use_empty=True)
bpy.ops.import_scene.fbx(filepath=os.path.join(EXP, "Body.fbx"), use_anim=False)
body_objs = set(bpy.data.objects)
bpy.ops.import_scene.fbx(filepath=os.path.join(EXP, "Face.fbx"), use_anim=False)
arm = next(o for o in body_objs if o.type == 'ARMATURE')
face_arm = next(o for o in bpy.data.objects if o.type == 'ARMATURE' and o is not arm)
body = next(o for o in body_objs if o.type == 'MESH' and o.name.endswith(f"_LOD{BODY_LOD}"))
face = next(o for o in bpy.data.objects if o.type == 'MESH' and o not in body_objs and o.name.endswith(f"_LOD{FACE_LOD}"))
keep = {arm, body, face}
# unparent the keepers (keep world transform), delete everything else
for o in list(keep):
    mw = o.matrix_world.copy(); o.parent = None; o.matrix_world = mw
for o in list(bpy.data.objects):
    if o not in keep:
        bpy.data.objects.remove(o, do_unlink=True)
# face: drop hidden sections by UE slot index (head, teeth, saliva, eyeLeft, eyeRight, eyeshell, eyelashes, eyeEdge, cartilage)
DROP = {2, 5, 7, 8}
import bmesh
bm = bmesh.new(); bm.from_mesh(face.data)
bmesh.ops.delete(bm, geom=[f for f in bm.faces if f.material_index in DROP], context='FACES')
bm.to_mesh(face.data); bm.free()
# fold face-only joints into head
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
for o in (body, face):
    for m in list(o.modifiers):
        o.modifiers.remove(m)
    o.parent = arm
    o.matrix_parent_inverse = arm.matrix_world.inverted()
    mod = o.modifiers.new("Armature", 'ARMATURE'); mod.object = arm
# apply rotation/scale so the skeleton is in metres with unit node scale
bpy.ops.object.select_all(action='DESELECT')
for o in (arm, body, face):
    o.select_set(True)
bpy.context.view_layer.objects.active = arm
bpy.ops.object.transform_apply(location=False, rotation=True, scale=True)
# materials
def mat(name, img=None, rough=0.5, color=(1, 1, 1, 1), alpha=None):
    m = bpy.data.materials.new(name); m.use_nodes = True
    p = m.node_tree.nodes["Principled BSDF"]
    p.inputs["Roughness"].default_value = rough
    p.inputs["Base Color"].default_value = color
    if img:
        t = m.node_tree.nodes.new("ShaderNodeTexImage"); t.image = bpy.data.images.load(os.path.join(TEX, img))
        m.node_tree.links.new(t.outputs["Color"], p.inputs["Base Color"])
    if alpha is not None:
        p.inputs["Alpha"].default_value = alpha
        m.surface_render_method = 'BLENDED'
    return m
skin_h = mat("MH_Skin_Head", "mh_pilot_head_albedo.jpg", 0.5)
skin_b = mat("MH_Skin_Body", "mh_pilot_body_albedo.jpg", 0.5)
teeth = mat("MH_Teeth", None, 0.35, (0.85, 0.82, 0.75, 1))
eye = mat("MH_Eye", "mh_pilot_eye_albedo.jpg", 0.05)
lash = mat("MH_Eyelashes", None, 0.6, (0.03, 0.025, 0.02, 1), alpha=0.75)
body.data.materials.clear(); body.data.materials.append(skin_b)
# Boxing trunks: the body faces between the navel and mid-thigh (bind pose, metres, arms excluded by |x|) get their
# own material slot, so the game can colour them per fighter (FighterTrunks does the same on the MPFB body).
trunks = mat("MH_Trunks", None, 0.4, (0.55, 0.05, 0.06, 1))
body.data.materials.append(trunks)
mw = arm.matrix_world
n_tr = 0
for p in body.data.polygons:
    c = mw @ p.center
    if 0.64 <= c.z <= 1.07 and abs(c.x) < 0.235:
        p.material_index = 1; n_tr += 1
print("MH1BUILD trunks faces", n_tr)
remap = {0: 0, 1: 1, 3: 2, 4: 2, 6: 3}
orig = [p.material_index for p in face.data.polygons]   # read BEFORE clear(): clearing slots zeroes the indices
face.data.materials.clear()
for m in (skin_h, teeth, eye, lash):
    face.data.materials.append(m)
for p, i in zip(face.data.polygons, orig):
    p.material_index = remap.get(i, 0)
import collections
print("MH1BUILD face material counts", dict(collections.Counter(p.material_index for p in face.data.polygons)))
arm.name = "MH_Pilot01"; body.name = "MH_Body"; face.name = "MH_Head"
tris = {o.name: sum(len(p.vertices) - 2 for p in o.data.polygons) for o in (body, face)}
print("MH1BUILD tris", tris, "total", sum(tris.values()), "bones", len(arm.data.bones),
      "face_groups", len(face.vertex_groups), "folded", len(fold), "height_m", round(max((arm.matrix_world @ v.co).z for v in face.data.vertices), 3))
bpy.ops.export_scene.gltf(filepath=OUT, export_format='GLB', use_selection=False, export_yup=True,
    export_skins=True, export_animations=False, export_morph=False, export_image_format='JPEG',
    export_jpeg_quality=90, export_apply=False)
print("MH1BUILD wrote", OUT, os.path.getsize(OUT))
