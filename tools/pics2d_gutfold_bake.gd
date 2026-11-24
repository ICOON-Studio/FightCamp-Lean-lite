extends SceneTree
## BODYCROSS3 (S546, ops/research/TASK_BODYCROSS3.md step 5): THE HIT MAN'S TAKE FOR A BODY PUNCH, AUTHORED OFFLINE.
## Owner C502 on BODYCROSS2's sheet: "the reaction should force the opponent to bend hisposture a bit".
## tools/bodycross3_ruler.gd on every captured gut-shot take, the fold AS SEEN from the side camera: three fold deep
## enough (v2 22 deg, v2_short 19, v3 26) but LATE - each opens with 0.15-0.35 s in which the man stands, even leans
## back 2-4 deg, and the fold is deepest 0.5-0.85 s into the take. The v2 player starts a body reaction near that
## opening (ChoreoReact.start_s walks the start back until the head's step a picture is under its bar), so 0.15 s after
## the glove he has folded 6.5-8.4 deg: nobody sees it. The other four never fold 10 deg on the side camera.
## This bakes ONE new take from the captured v3 (the deepest fold, the least ground given: K48 "bend / brace / hold more
## than a long retreat"): v3 FROM THE KEY ITS FOLD STARTS ON (from=, s). Every key after it is the captured one, moved
## earlier by that much; the feet, the legs, the arms and the step back are as captured. The hips' place on the floor
## starts where v3's starts (the ground v3 gave before that key is not replayed). fold= scales the trunk's own bend
## (Spine, Chest, UpperChest only, against their first captured key; 1.0 = as captured). As captured the fold is
## 26 deg at its deepest and reads doubled over; the owner asked for "a bit": 0.75 gives 21-22 deg, 18.5-19.3 inside
## 0.15 s of the glove on the film's two pairs.
## Saved as mc_Box1_M3_Hit_By_GutShot_V3_Fold.res: FightClips loads it as pro_hit_by_gutshot_v3_fold (a "gutshot"
## reaction: the v2 player's body-punch pool, ChoreoReact.react). Its clip_db row: tools/clip_census.gd.
##   <godot> --headless --audio-driver Dummy --path . --script res://tools/pics2d_gutfold_bake.gd -- [dry] [from=0.25] [fold=0.75]

const SRC := "res://assets/anim/baked/mc_Box1_M3_Hit_By_GutShot_V3.res"
const OUT := "res://assets/anim/baked/mc_Box1_M3_Hit_By_GutShot_V3_Fold.res"
const TRUNK := ["Spine", "Chest", "UpperChest"]


func _arg(key: String, def: float) -> float:
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with(key + "="):
			return float(str(a).substr(key.length() + 1))
	return def


func _initialize() -> void:
	var dry := OS.get_cmdline_user_args().has("dry")
	var from := _arg("from", 0.25)
	var fold := _arg("fold", 0.75)
	var src := load(SRC) as Animation
	var out := src.duplicate(true) as Animation
	var scaled: Array = []
	var names: Array = []
	for t in out.get_track_count():
		var ty := out.track_get_type(t)
		var tp := str(out.track_get_path(t))
		var bone := tp.get_slice(":", tp.get_slice_count(":") - 1)
		names.append(bone)
		while out.track_get_key_count(t) > 0:
			out.track_remove_key(t, 0)
		if ty == Animation.TYPE_POSITION_3D:
			var first: Vector3 = src.track_get_key_value(t, 0)
			var lost: Vector3 = (src.position_track_interpolate(t, from) - first) * Vector3(1, 0, 1)
			out.position_track_insert_key(t, 0.0, src.position_track_interpolate(t, from) - lost)
			for k in src.track_get_key_count(t):
				if src.track_get_key_time(t, k) > from + 1e-4:
					out.position_track_insert_key(t, src.track_get_key_time(t, k) - from, (src.track_get_key_value(t, k) as Vector3) - lost)
			print("GUTFOLD_BAKE the hips: v3 has given %.3f m of ground by %.3f s (not replayed); from there it gives %.3f m more" % [lost.length(), from, _most(src, t, from)])
		elif ty == Animation.TYPE_ROTATION_3D:
			var ref: Quaternion = src.track_get_key_value(t, 0)
			var sc := fold if bone in TRUNK else 1.0
			if sc != 1.0:
				scaled.append(bone)
			out.rotation_track_insert_key(t, 0.0, _bent(ref, src.rotation_track_interpolate(t, from), sc))
			for k in src.track_get_key_count(t):
				if src.track_get_key_time(t, k) > from + 1e-4:
					out.rotation_track_insert_key(t, src.track_get_key_time(t, k) - from, _bent(ref, src.track_get_key_value(t, k), sc))
		elif ty == Animation.TYPE_SCALE_3D:
			out.scale_track_insert_key(t, 0.0, src.scale_track_interpolate(t, from))
			for k in src.track_get_key_count(t):
				if src.track_get_key_time(t, k) > from + 1e-4:
					out.scale_track_insert_key(t, src.track_get_key_time(t, k) - from, src.track_get_key_value(t, k))
	out.length = snappedf(src.length - from, 1.0 / 60.0)
	print("GUTFOLD_BAKE %d tracks; v3 from %.3f s; length %.3f -> %.3f s; trunk bend x %.2f on %s" % [out.get_track_count(), from, src.length, out.length, fold, str(scaled)])
	if fold != 1.0 and scaled.size() != TRUNK.size():
		print("GUTFOLD_BAKE FAIL the take's tracks are %s: not every trunk joint of %s is among them" % [str(names), str(TRUNK)])
		quit(1)
		return
	if not dry:
		out.set_meta("bodycross3", {"from": SRC, "from_s": from, "fold": fold, "trunk": TRUNK if fold != 1.0 else []})
		print("GUTFOLD_BAKE saved %s (err %d)" % [OUT, ResourceSaver.save(out, OUT)])
	print("GUTFOLD_BAKE DONE")
	quit(0)


## A trunk joint's captured turn q, its bend against the take's first key scaled by sc.
static func _bent(ref: Quaternion, q: Quaternion, sc: float) -> Quaternion:
	return q if sc == 1.0 else ref.slerp(q, sc)


## The most the hips travel on the floor after 'from' (m).
static func _most(src: Animation, t: int, from: float) -> float:
	var at: Vector3 = src.position_track_interpolate(t, from)
	var most := 0.0
	for k in src.track_get_key_count(t):
		if src.track_get_key_time(t, k) > from:
			most = maxf(most, (((src.track_get_key_value(t, k) as Vector3) - at) * Vector3(1, 0, 1)).length())
	return most
