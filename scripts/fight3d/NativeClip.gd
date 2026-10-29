extends RefCounted
## A native MetaHuman clip (assets/anim/metahuman/*.glb, authored on the MetaHuman skeleton at game speed: 20 frames at
## 30 fps) as an Animation on one of our boxers (copied from the old repo's FightClipNativeMH.load_animation). Rotation
## keys are native; position keys keep the body's own rest offsets plus the authored displacement.
const Raw := preload("res://scripts/fight3d/RawAsset.gd")
const MH := preload("res://scripts/fight3d/MHRig.gd")

static func load_animation(path: String, skel: Skeleton3D) -> Dictionary:
	var doc := GLTFDocument.new()
	var state := GLTFState.new()
	if doc.append_from_buffer(Raw.read(path),path.get_base_dir(),state) != OK:
		return {"error":"Cannot load native clip " + path}
	var source := doc.generate_scene(state,30.0)
	if source == null:
		return {"error":"Cannot generate native clip " + path}
	var players := source.find_children("*","AnimationPlayer",true,false)
	if players.is_empty():
		source.free()
		return {"error":"Native clip has no animation"}
	var ap := players[0] as AnimationPlayer
	var animation: Animation
	for name in ap.get_animation_list():
		if name != "RESET":
			animation = ap.get_animation(name).duplicate(true)
	if animation == null:
		source.free()
		return {"error":"Native clip has no take"}
	# Cascadeur's FBX carrier is Z-up; its static parent is already normalized
	# for metres. Fold this packaging transform into the top joint only.
	var nodes: Array[GLTFNode] = state.get_nodes()
	var carrier := Transform3D.IDENTITY
	var native_rest := {}
	for node in nodes:
		native_rest[node.resource_name] = node.position
		if node.resource_name == "MH_Boxer_01":
			carrier = Transform3D(Basis(node.rotation).scaled(node.scale),node.position)
	var mapped := 0
	for track in range(animation.get_track_count()-1,-1,-1):
		var source_path := animation.track_get_path(track)
		var native := str(source_path.get_subname(0)) if source_path.get_subname_count() else str(source_path.get_name(source_path.get_name_count()-1))
		var bone := str(MH.UE5_TO_OURS.get(native,MH.UE5_FINGERS.get(native,native)))
		var index := skel.find_bone(bone)
		if index < 0:
			if native != "MH_Boxer_01":
				source.free()
				return {"error":"Unknown native joint " + native}
			animation.remove_track(track)
			continue
		animation.track_set_path(track,NodePath(bone))
		mapped += 1
		# Bodies share joint axes/hierarchy, but not hip width or height. Keep
		# their own rest offsets plus the authored translation displacement.
		# Rotation keys are native; there is no silhouette or wrist correction.
		if animation.track_get_type(track) == Animation.TYPE_POSITION_3D:
			for key in animation.track_get_key_count(track):
				var delta: Vector3 = animation.track_get_key_value(track,key) - native_rest[native]
				if skel.get_bone_parent(index) < 0:
					delta = carrier.basis * delta
				animation.track_set_key_value(track,key,skel.get_bone_rest(index).origin + delta)
		if skel.get_bone_parent(index) < 0:
			for key in animation.track_get_key_count(track):
				if animation.track_get_type(track) == Animation.TYPE_ROTATION_3D:
					var q: Quaternion = animation.track_get_key_value(track,key)
					animation.track_set_key_value(track,key,(carrier.basis.get_rotation_quaternion()*q).normalized())
	source.free()
	if mapped == 0:
		return {"error":"Native clip mapped no tracks"}
	# These are already local-to-actual-parent keys, including intermediate bones.
	animation.set_meta("mh_rest_folded",true)
	animation.set_meta("native_mh_clip",true)
	animation.set_meta("resolved_clip_path",path)
	return {"error":"","animation":animation}
