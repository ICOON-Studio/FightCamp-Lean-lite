extends RefCounted
## FIGHTPLAYER2 (S537 FP2POSE4, the owner: "the power does not come from twisting the knee use our research/clips when
## you make animations"): THE HIP DRIVE ON POWER PUNCHES. The Punch PRO actor throws his rear-hand punches standing
## where he is: as drawn the hips go 0-3 cm toward the other man by the contact and the rear knee BENDS 1-16 deg into
## it (docs/FP2POSE3_RESULT.md). A real cross is pushed off the rear foot: the hips travel 27.8 +- 6 cm by the impact
## (Cheraghi 2014; ops/research/CROSS_POWER_S439.md, whose fix 3 asks for 10-18 cm on power punches; the captured
## stepping cross Mixamo Cross_Punch__A: 11.6), the rear knee EXTENDS about 25 deg through the drive, the rear ankle
## about 12, and at the impact 61 % of the ground force is on the lead foot, which brakes (K46: "rear drive -> front
## brace"). Cascadeur's AutoPhysics does not add it (docs/CASCTEST1_RESULT.md): it is not in the take, it is authored.
## What changes, OFFLINE at the bake (tools/drive_bake.gd, run after cross_legs_bake and stance_bake; no runtime
## layer), on every cross, rear hook and rear uppercut v2 plays:
##   - the hips sit a little onto the rear leg (the load), then go FORWARD along the line to the other man, eased, so
##     that by the contact they are FWD_M further on than in the guard (less what the take travels itself), still
##     moving as the glove lands, and come back on the recoil;
##   - the rear foot stays on its BALL (the heel comes up more where the leg would run out of length) and the rear leg
##     is solved again under the moved hips: the knee straightens through the drive. Nothing turns at the knee: it
##     keeps the plane it bends in under the take's own pelvis (FP2POSE3's rule holds, tests/player2_test.gd KNEE);
##   - the lead foot stays where it stands and its leg BRACES: its knee gives BRACE_DEG at most, the hips rise for the rest.
## The trunk, the arms and the head ride the hips: the gloves land 10-13 cm further out (the census rows of these
## takes are measured again: contact_gap_m, hips_at_contact_m).
## Kept beside the takes, one small file a take (DIR/<take>.res: how far the hips move, the two legs' rotations) and
## laid over the take as the v2 library is built (StepClips.load_into, after the stance). In v2 the forward part goes
## where every take's travel goes - onto the BODY (the take's root path; the feet stay by the re-solved legs and the
## foot pins) - so a punch cut at its contact leaves the man where the drive took him and the plan walks it off; held
## as a pose it came back 15 cm inside the join to the guard and the feet skated. `-- fp2nodrive` = without.
##   load_into(lib, skel, prefix) -> how many takes got the drive

const CrossLegs := preload("res://scripts/fight3d/v2/CrossLegs.gd")
const DIR := "res://assets/anim/baked/v2/drive/"
const ROOT_PATH_META := "root_path"   # FightClips.ROOT_PATH_META (not preloaded: FightClips loads this file)
## How far the hips are toward the other man at the contact (m), by family. CROSS_POWER_S439 fix 3: 10-18 cm.
const FWD_M := {"cross": 0.14, "rear_hook": 0.12, "rear_uppercut": 0.10}
## A hard take drives more, a hurt man less (kept inside the study's 10-18 cm).
const FORM_X := {"hard": 1.2, "hard_ft": 1.2, "hurt": 0.85, "hurt_ft": 0.85}
const LEAST_M := 0.10
const MOST_M := 0.18
const BRACE_DEG := 8.0        # the lead knee gives this much under the weight coming onto it, no more
const REST_META := "rest_y"   # the bake body's hip height: the move is scaled to the body that plays it

static var off := true   # S537 owner "ok switch off": legs play as recorded (C461 "terrible knee twist"); false = the S536-S537 leg bakes


## How far this take's hips are driven by the contact (m); 0 = not a driven take.
static func amp(row: Dictionary) -> float:
	var fam := str(row.get("family", ""))
	if not FWD_M.has(fam):
		return 0.0
	return clampf(float(FWD_M[fam]) * float(FORM_X.get(str(row.get("form", "")), 1.0)), LEAST_M, MOST_M)


## The takes the bake re-does: every rear-hand power punch v2 plays (and the cross takes CrossLegs re-does).
static func takes(rows: Dictionary, have: Array) -> Array:
	var out: Array = []
	for name in have:
		var r: Dictionary = rows.get(str(name), {})
		var plays := bool(r.get("played", false)) and (r.get("drop", []) as Array).is_empty()
		if amp(r) > 0.0 and (plays or str(name) in CrossLegs.TAKES):
			out.append(str(name))
	out.sort()
	return out


## The pinned take's own travel (x, z) at `t` (RootPath.at; that file loads FightClips, which loads this one).
static func _at(path: PackedVector3Array, t: float) -> Vector2:
	var n := path.size()
	if t <= path[0].y:
		return Vector2(path[0].x, path[0].z)
	for k in range(1, n):
		if t <= path[k].y:
			var w := (t - path[k - 1].y) / maxf(path[k].y - path[k - 1].y, 0.00001)
			return Vector2(lerpf(path[k - 1].x, path[k].x, w), lerpf(path[k - 1].z, path[k].z, w))
	return Vector2(path[n - 1].x, path[n - 1].z)


static func load_into(lib: AnimationLibrary, skel: Skeleton3D, prefix: String) -> int:
	if off or OS.get_cmdline_user_args().has("fp2nodrive"):
		return 0
	var done := 0
	var rest_y: float = skel.get_bone_rest(skel.find_bone("Hips")).origin.y
	for f in DirAccess.get_files_at(DIR):
		var file := str(f).trim_suffix(".remap")
		var name := file.trim_suffix(".res")
		if not file.ends_with(".res") or not lib.has_animation(name):
			continue
		var anim := lib.get_animation(name)
		var legs := load(DIR + file) as Animation
		var scale := rest_y / maxf(float(legs.get_meta(REST_META, rest_y)), 0.01)
		for lt in legs.get_track_count():
			var path := NodePath("%s:%s" % [prefix, str(legs.track_get_path(lt))])
			if legs.track_get_type(lt) == Animation.TYPE_POSITION_3D:
				# the hips: the take's own keys, each moved by what the bake found for its time (keys added where the
				# take has too few to carry a 0.2 s drive)
				var ht := anim.find_track(path, Animation.TYPE_POSITION_3D)
				if ht < 0:
					continue
				for k in legs.track_get_key_count(lt):
					var kt := legs.track_get_key_time(lt, k)
					if anim.track_find_key(ht, kt, Animation.FIND_MODE_APPROX) < 0:
						anim.position_track_insert_key(ht, kt, anim.position_track_interpolate(ht, kt))
				# v2 pins every punch on the spot and plays the take's travel on the BODY (FightClips.hold_root_xz, RootPath):
				# the drive goes the same way, so a punch cut at its contact leaves the man where the drive took him (as
				# a pose it came back 15 cm inside the join and the feet skated). Unpinned (the census, the bakes): the keys.
				var trail: PackedVector3Array = anim.get_meta(ROOT_PATH_META, PackedVector3Array())
				var moved := PackedVector3Array()
				for k in anim.track_get_key_count(ht):
					var kt := anim.track_get_key_time(ht, k)
					var d: Vector3 = legs.position_track_interpolate(lt, minf(kt, legs.length)) * scale
					var v: Vector3 = anim.track_get_key_value(ht, k)
					if trail.is_empty():
						anim.track_set_key_value(ht, k, v + d)
						continue
					anim.track_set_key_value(ht, k, v + Vector3(0.0, d.y, 0.0))
					var own := _at(trail, kt)
					moved.append(Vector3(own.x + d.x, kt, own.y + d.z))
				if not trail.is_empty():
					anim.set_meta(ROOT_PATH_META, moved)
				continue
			var t := anim.find_track(path, Animation.TYPE_ROTATION_3D)
			if t >= 0:
				anim.remove_track(t)
			t = anim.add_track(Animation.TYPE_ROTATION_3D)
			anim.track_set_path(t, path)
			for k in legs.track_get_key_count(lt):
				anim.rotation_track_insert_key(t, legs.track_get_key_time(lt, k), legs.track_get_key_value(lt, k))
		done += 1
	return done
