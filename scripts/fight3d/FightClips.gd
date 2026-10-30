extends RefCounted
## The boxer's move library: native MetaHuman punches, the old game's baked clips and the MoCap Online clips (S299,
## operator bought Punch Starter; baked by the old repo's tools/lean_bake.gd with roles mc_<file stem>), all added to the
## body's own AnimationPlayer under one name each. Split out of FightStage (S299: it had passed the 500-line rule).

const NativeClip := preload("res://scripts/fight3d/NativeClip.gd")

## Native MetaHuman punches (20 frames at 30 fps, contact at frame 8).
const CLIPS := {
	"jab": "res://assets/anim/metahuman/mh_jab.glb",
	"cross": "res://assets/anim/metahuman/mh_cross.glb",
	"lead_hook": "res://assets/anim/metahuman/mh_lead_hook.glb",
}
## Baked from the old game's full pipeline (tools/old_repo/lean_bake.gd): role -> our name.
const BAKED := {
	"idle": "idle", "react_head": "react_head", "react_body": "react_body", "react_leg": "react_hurt",
	"loc_advance": "advance", "loc_retreat": "retreat", "loc_strafe_left": "strafe_left", "loc_strafe_right": "strafe_right",
	"boxing_slip": "slip", "boxing_pull": "pull", "boxing_body_hook": "body_hook", "boxing_rear_uppercut": "rear_uppercut",
}
const BAKED_DIR := "res://assets/anim/baked/"
## MoCap Online Punch Starter, baked as mc_Punch_M3_<Name>.res: our name -> file stem.
const MOCAP_ONLINE := {
	"mc_idle": "Punch_M3_Idle", "mc_fidget": "Punch_M3_Idle_Fidget_V1", "mc_jab": "Punch_M3_Left_Jab",
	"mc_lead_hook": "Punch_M3_Left_Hook", "mc_lead_uppercut": "Punch_M3_Left_Uppercut", "mc_cross": "Punch_M3_Right_Cross",
	"mc_rear_hook": "Punch_M3_Right_Hook", "mc_rear_uppercut": "Punch_M3_Right_Uppercut", "mc_dodge_left": "Punch_M3_Left_Dodge",
	"mc_dodge_right": "Punch_M3_Right_Dodge", "mc_block": "Punch_M3_Block_Loop", "mc_block_hit": "Punch_M3_Block_Straight_Hit_V1",
	"mc_to_block": "Punch_M3_Idle_To_Block", "mc_from_block": "Punch_M3_Block_To_Idle", "mc_hit_jab": "Punch_M3_Hit_By_Jab_V1_Short",
	"mc_hit_hook": "Punch_M3_Hit_By_Hook_V1_Short", "mc_hit_combo": "Punch_M3_Hit_By_Combo_V1_Short",
	"mc_knockout": "Punch_M3_Knockout_V1", "mc_knockout_count": "Punch_M3_Knockout_Countdown_V1", "mc_win": "Punch_M3_Win_V1",
}
const PRO_PREFIX := "mc_Box1_M3_"
## Clips that travel (their hips keep the X/Z they author); every other clip is thrown in place. Pro clips travel when
## their name says the body goes somewhere (knockouts, falls, wins, steps).
const TRAVELS := ["idle", "advance", "retreat", "strafe_left", "strafe_right", "mc_knockout", "mc_knockout_count", "mc_win"]
const SEAT_MOVES := ["af_sit_enter", "af_sit_exit"]
const TRAVEL_WORDS := ["knock", "ko_", "fall", "win", "walk", "step", "count"]


## Adds every clip to `ap` (tracks re-pathed onto `skel`). Returns the names added. `corner_only` (S307, the corner
## teams): only the ActionForge af_ clips.
static func load_into(ap: AnimationPlayer, skel: Skeleton3D, corner_only: bool = false) -> Array:
	var lib: AnimationLibrary = ap.get_animation_library("")
	var prefix := str(ap.get_node(ap.root_node).get_path_to(skel))
	var added: Array = []
	for move in ({} if corner_only else CLIPS):
		var got: Dictionary = NativeClip.load_animation(CLIPS[move], skel)
		if str(got.get("error", "")) != "":
			push_error(got["error"])
			continue
		var anim: Animation = got["animation"]
		for t in anim.get_track_count():
			anim.track_set_path(t, NodePath("%s:%s" % [prefix, str(anim.track_get_path(t))]))
		hold_root_xz(anim)
		anim.loop_mode = Animation.LOOP_NONE
		lib.add_animation(move, anim)
		added.append(move)
	var baked := {}
	for role in ({} if corner_only else BAKED):
		baked[BAKED[role]] = BAKED_DIR + role + ".res"
	for name in ({} if corner_only else MOCAP_ONLINE):
		baked[name] = BAKED_DIR + "mc_" + str(MOCAP_ONLINE[name]) + ".res"
	for stem in ([] if corner_only else pro_stems()):
		baked[pro_name(stem)] = BAKED_DIR + stem + ".res"
	# S306: the corner minute's ActionForge clips (Quaternius, CC0; the old repo's tools/af_lean_bake.gd): af_<role>.
	for f in DirAccess.get_files_at(BAKED_DIR):
		var file := str(f).trim_suffix(".remap")
		if file.begins_with("af_") and file.ends_with(".res"):
			baked[file.trim_suffix(".res")] = BAKED_DIR + file
	for name in baked:
		if _add_baked(lib, skel, prefix, str(name), str(baked[name])):
			added.append(name)
	return added


## MoCap Online Punch PRO (S299, 145 clips baked as mc_Box1_M3_<Name>.res): every one is loaded as pro_<name>, lower case.
static func pro_stems() -> Array:
	var out: Array = []
	for f in DirAccess.get_files_at(BAKED_DIR):
		var file := str(f).trim_suffix(".remap")
		if file.begins_with(PRO_PREFIX) and file.ends_with(".res"):
			out.append(file.trim_suffix(".res"))
	out.sort()
	return out


static func pro_name(stem: String) -> String:
	return "pro_" + stem.trim_prefix(PRO_PREFIX).to_lower()


static func _add_baked(lib: AnimationLibrary, skel: Skeleton3D, prefix: String, name: String, path: String) -> bool:
	if not ResourceLoader.exists(path):
		return false
	var anim := (load(path) as Animation).duplicate(true) as Animation
	var hips := skel.find_bone("Hips")
	for t in anim.get_track_count():
		anim.track_set_path(t, NodePath("%s:%s" % [prefix, str(anim.track_get_path(t))]))
		if anim.track_get_type(t) == Animation.TYPE_POSITION_3D:
			# Hips keys are deltas from the source body's rest: this body keeps its own hip height.
			var rest: Vector3 = skel.get_bone_rest(hips).origin
			for k in anim.track_get_key_count(t):
				anim.track_set_key_value(t, k, rest + (anim.track_get_key_value(t, k) as Vector3))
	# S307: sitting down / standing up keep their own hip travel (held, the feet slid 0.2-0.3 m/s forward under the stool).
	if not (name in TRAVELS or name in SEAT_MOVES or (name.begins_with("pro_") and TRAVEL_WORDS.any(func(w): return name.contains(w)))):
		hold_root_xz(anim)
	if name == "pro_idle":
		# S300: the Pro guard plays between every move: it loops in place (no restart hitch, no drift).
		hold_root_xz(anim)
		anim.loop_mode = Animation.LOOP_LINEAR
	lib.add_animation(name, anim)
	return true


## A move thrown in place: the hips keep their first X/Z, so the boxer stays on her mark.
static func hold_root_xz(anim: Animation) -> void:
	for t in anim.get_track_count():
		if anim.track_get_type(t) != Animation.TYPE_POSITION_3D or str(anim.track_get_path(t)).get_slice(":", 1) != "Hips":
			continue
		var first: Vector3 = anim.track_get_key_value(t, 0)
		for k in anim.track_get_key_count(t):
			var v: Vector3 = anim.track_get_key_value(t, k)
			anim.track_set_key_value(t, k, Vector3(first.x, v.y, first.z))
