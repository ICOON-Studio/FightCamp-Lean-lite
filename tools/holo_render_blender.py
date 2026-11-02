import bpy, mathutils, math, sys
# S353: the female ecorche (material 1) rendered front-on as the body figure's holo. Run: blender -b ecorche.blend --python this
OUT = sys.argv[sys.argv.index("--") + 1] if "--" in sys.argv else "E:/FightCamp/gen/s353_holo/holo_f.png"
ob = bpy.data.objects[0]
bpy.context.view_layer.objects.active = ob
ob.select_set(True)
bpy.ops.object.mode_set(mode='EDIT')
bpy.ops.mesh.separate(type='MATERIAL')
bpy.ops.object.mode_set(mode='OBJECT')
parts = sorted([o for o in bpy.data.objects if o.type == 'MESH'], key=lambda o: o.name)
fem = parts[1]
for o in parts:
    o.hide_render = (o != fem)
for o in list(bpy.data.objects):
    if o.type in ('LIGHT', 'CAMERA'):
        bpy.data.objects.remove(o)
sc = bpy.context.scene
for eng in ('BLENDER_EEVEE', 'BLENDER_EEVEE_NEXT'):
    try:
        sc.render.engine = eng
        break
    except TypeError:
        pass
sc.render.film_transparent = True
sc.render.resolution_x = 900
sc.render.resolution_y = 1500
sc.view_settings.view_transform = 'Standard'
w = bpy.data.worlds.new("w"); sc.world = w; w.use_nodes = True
w.node_tree.nodes["Background"].inputs[1].default_value = 0.0
# Holo: facing ramp (rim glows) x ambient occlusion (the grooves between muscles go dark) + a soft key for volume.
m = bpy.data.materials.new("holo"); m.use_nodes = True
nt = m.node_tree; N = nt.nodes; L = nt.links
for n in list(N): N.remove(n)
out = N.new("ShaderNodeOutputMaterial")
em = N.new("ShaderNodeEmission")
lw = N.new("ShaderNodeLayerWeight"); lw.inputs["Blend"].default_value = 0.30
ramp = N.new("ShaderNodeValToRGB")
r = ramp.color_ramp
r.elements[0].position = 0.0; r.elements[0].color = (0.005, 0.035, 0.060, 1)
r.elements[1].position = 1.0; r.elements[1].color = (0.85, 1.0, 1.0, 1)
e = r.elements.new(0.62); e.color = (0.06, 0.48, 0.78, 1)
ao = N.new("ShaderNodeAmbientOcclusion"); ao.inputs["Distance"].default_value = 0.035; ao.samples = 16
geo = N.new("ShaderNodeNewGeometry")
key = N.new("ShaderNodeVectorMath"); key.operation = 'DOT_PRODUCT'
key.inputs[1].default_value = (-0.35, 0.75, 0.55)   # world: toward the camera (+Y), up and from her right
keyc = N.new("ShaderNodeMath"); keyc.operation = 'MAXIMUM'; keyc.inputs[1].default_value = 0.0
keyw = N.new("ShaderNodeMath"); keyw.operation = 'MULTIPLY_ADD'; keyw.inputs[1].default_value = 0.45; keyw.inputs[2].default_value = 0.45
facing = N.new("ShaderNodeMath"); facing.operation = 'ADD'
mix_ao = N.new("ShaderNodeMath"); mix_ao.operation = 'MULTIPLY'
aopow = N.new("ShaderNodeMath"); aopow.operation = 'POWER'; aopow.inputs[1].default_value = 1.6
col = N.new("ShaderNodeVectorMath"); col.operation = 'SCALE'
L.new(lw.outputs["Facing"], facing.inputs[0])
L.new(geo.outputs["Normal"], key.inputs[0])
L.new(key.outputs["Value"], keyc.inputs[0])
L.new(keyc.outputs[0], keyw.inputs[0])
fk = N.new("ShaderNodeMath"); fk.operation = 'MULTIPLY'; fk.inputs[1].default_value = 0.25
L.new(keyc.outputs[0], fk.inputs[0])
L.new(fk.outputs[0], facing.inputs[1])
L.new(facing.outputs[0], ramp.inputs["Fac"])
L.new(ao.outputs["AO"], aopow.inputs[0])
L.new(aopow.outputs[0], mix_ao.inputs[0])
L.new(keyw.outputs[0], mix_ao.inputs[1])
L.new(ramp.outputs["Color"], col.inputs[0])
L.new(mix_ao.outputs[0], col.inputs["Scale"])
L.new(col.outputs["Vector"], em.inputs["Color"])
em.inputs["Strength"].default_value = 1.0
# See-through inside, solid at the rim: alpha follows the facing ramp (back faces culled, so only her front skin shows).
tr = N.new("ShaderNodeBsdfTransparent")
mixs = N.new("ShaderNodeMixShader")
alpha = N.new("ShaderNodeMapRange"); alpha.inputs["From Min"].default_value = 0.0; alpha.inputs["From Max"].default_value = 0.75
alpha.inputs["To Min"].default_value = 0.55; alpha.inputs["To Max"].default_value = 1.0
L.new(facing.outputs[0], alpha.inputs["Value"])
L.new(alpha.outputs["Result"], mixs.inputs["Fac"])
L.new(tr.outputs[0], mixs.inputs[1])
L.new(em.outputs["Emission"], mixs.inputs[2])
L.new(mixs.outputs[0], out.inputs["Surface"])
m.use_backface_culling = True
try:
    m.surface_render_method = 'BLENDED'
except Exception:
    m.blend_method = 'BLEND'

fem.data.materials.clear(); fem.data.materials.append(m)
pts = [fem.matrix_world @ mathutils.Vector(c) for c in fem.bound_box]
lo = mathutils.Vector([min(v[k] for v in pts) for k in range(3)]); hi = mathutils.Vector([max(v[k] for v in pts) for k in range(3)])
ctr = (hi + lo) / 2
cd = bpy.data.cameras.new("cam"); cd.type = 'ORTHO'; cd.ortho_scale = (hi.z - lo.z) * 1.04
cam = bpy.data.objects.new("cam", cd); sc.collection.objects.link(cam); sc.camera = cam
cam.location = (ctr.x, 6.0, ctr.z)
cam.rotation_euler = (math.pi / 2, 0, math.pi)
sc.render.filepath = OUT
bpy.ops.render.render(write_still=True)
# Where the picture's pixels sit in metres, for the places/track baked beside it.
print("HOLO_FRAME lo=%s hi=%s ctr=%s scale=%.4f res=%dx%d" % (tuple(round(x, 4) for x in lo), tuple(round(x, 4) for x in hi),
	tuple(round(x, 4) for x in ctr), cd.ortho_scale, sc.render.resolution_x, sc.render.resolution_y))
print("WROTE", OUT, sc.render.engine)
