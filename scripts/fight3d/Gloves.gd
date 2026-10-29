extends Node
## Boxing gloves on a MetaHuman boxer: the hand mesh is cut away (its fingers would poke through) and one glove per hand
## follows the palm frame every time the skeleton updates. A lean version of the old repo's CCFighterSkin procedural
## gloves (rigid, no skinned cuff). The mesh is assets/models/gloves/boxing_glove.glb (CC BY 4.0, CREDITS.md): one
## closed LEFT glove in metres, palm on +Z, its vertex red channel marks the cuff band.

const MeshCut := preload("res://scripts/fight3d/MeshCut.gd")
const GLOVE_PATH := "res://assets/models/gloves/boxing_glove.glb"
## Wrist, middle knuckle, index knuckle, little knuckle.
const HANDS := {
	"l": ["LeftHand", "LeftMiddleProximal", "LeftIndexProximal", "LeftLittleProximal"],
	"r": ["RightHand", "RightMiddleProximal", "RightIndexProximal", "RightLittleProximal"],
}
## Palms in, thumbs on top (the old repo's S162e measure on the certified clips), about the glove's long axis.
const TWIST_DEG := {"l": -75.0, "r": 71.0}
const CUT_FINGERS := ["Thumb", "Index", "Middle", "Ring", "Little"]
const SHADER_CODE := """
shader_type spatial;
uniform vec4 colour : source_color = vec4(0.55, 0.05, 0.05, 1.0);
uniform vec4 cuff_colour : source_color = vec4(0.92, 0.92, 0.9, 1.0);
void fragment() {
	float band = smoothstep(0.35, 0.65, COLOR.r);
	ALBEDO = mix(colour.rgb, cuff_colour.rgb, band);
	ROUGHNESS = mix(0.45, 0.53, band);
	CLEARCOAT = mix(0.24, 0.12, band);
	CLEARCOAT_ROUGHNESS = 0.3;
}
"""
static var _shader: Shader = null

var skel: Skeleton3D
var gloves := {}
var idx := {}


## Puts gloves of `colour` (cuff band `cuff`) on the body. Returns how many hands got one.
func mount(body: Node3D, colour: Color, cuff: Color) -> int:
	var skels := body.find_children("*", "Skeleton3D", true, false)
	if skels.is_empty():
		return 0
	skel = skels[0] as Skeleton3D
	var packed := load(GLOVE_PATH) as PackedScene
	if packed == null:
		return 0
	if _shader == null:
		_shader = Shader.new()
		_shader.code = SHADER_CODE
	for side in HANDS:
		var bones: Array = []
		for b in HANDS[side]:
			bones.append(skel.find_bone(str(b)))
		if bones.has(-1):
			continue
		idx[side] = bones
		var g := Node3D.new()
		g.name = "Glove_" + side
		var model := packed.instantiate() as Node3D
		model.name = "Geometry"
		# The mesh is a LEFT glove (thumb lobe on -X, palm +Z). The right hand's frame mirrors X; the left takes it turned
		# half a turn about Y. Then the twist about the long axis.
		model.scale = Vector3(-1.0, 1.0, 1.0) if side == "r" else Vector3(-1.0, 1.0, -1.0)
		model.transform = Transform3D(Basis(Vector3.UP, deg_to_rad(float(TWIST_DEG[side]))), Vector3.ZERO) * model.transform
		var mat := ShaderMaterial.new()
		mat.shader = _shader
		mat.set_shader_parameter("colour", colour)
		mat.set_shader_parameter("cuff_colour", cuff)
		for mi in model.find_children("*", "MeshInstance3D", true, false):
			(mi as MeshInstance3D).material_override = mat
		g.add_child(model)
		skel.add_child(g)
		gloves[side] = g
	_cut_hands(body)
	skel.skeleton_updated.connect(_follow)
	_follow()
	return gloves.size()


## Wrist to the striking face of the glove, metres along the glove's long axis (from the mounted mesh).
func front_m() -> float:
	var g: Node3D = gloves.get("l") if gloves.has("l") else null
	if g == null:
		return 0.15
	var top := 0.0
	for m in g.find_children("*", "MeshInstance3D", true, false):
		var mi := m as MeshInstance3D
		var xf := g.global_transform.affine_inverse() * mi.global_transform
		var box: AABB = xf * mi.get_aabb()
		top = maxf(top, box.end.y)
	return top if top > 0.05 else 0.15


func _follow() -> void:
	for side in gloves:
		var bones: Array = idx[side]
		var p: Array = []
		for i in bones:
			p.append(skel.get_bone_global_pose(int(i)).origin)
		var wrist: Vector3 = p[0]
		var along: Vector3 = (p[1] as Vector3) - wrist
		if along.length() < 1e-5:
			continue
		along = along.normalized()
		var across: Vector3 = (p[2] as Vector3) - (p[3] as Vector3)
		across = across - along * across.dot(along)
		across = across.normalized() if across.length() > 1e-5 else along.cross(Vector3.UP).normalized()
		(gloves[side] as Node3D).transform = Transform3D(Basis(across, along, across.cross(along).normalized()), wrist)


## Drops every triangle that the hand or finger bones carry (weight >= 0.25), so no finger shows through a glove.
func _cut_hands(body: Node3D) -> void:
	var names := MeshCut.bones_named(skel, CUT_FINGERS)
	for n in names.keys():
		if not (str(n).begins_with("Left") or str(n).begins_with("Right")):
			names.erase(n)
	names["LeftHand"] = true
	names["RightHand"] = true
	for found in body.find_children("*", "MeshInstance3D", true, false):
		MeshCut.cut(found as MeshInstance3D, skel, names)
