extends RefCounted
## FIGHTPLAYER2 (S537 FP2POSE3, the owner on the guard still, C458: "legs are weird and looks like a weak 12 year old
## kid"): A BOXER'S STANCE LENGTH. The Punch PRO actor stands short: as drawn in v2 the guard is 38-47 cm long along
## the line to the other man and a cross lands with the feet 33-41 cm apart under a chest 8-14 cm ahead of the hips -
## two boots close together under a body leaning past them. A boxing stance is 1 to 1.5 shoulder widths long (45-65 cm
## on our bodies; Dempsey: the rear heel ~46 cm behind the lead heel at 5'10", K46 section 6) and a coach's first
## correction is "widen your base". The guard's trunk is NOT the fault (chest 1-4 cm ahead of the hips in the guard; the
## lean at a cross's contact is the punch's own weight going onto the lead leg, K46: 61 % lead), so the trunk, the arms
## and the head are not touched: every glove lands where the census measured it.
## What changes, OFFLINE at the bake (tools/stance_bake.gd; no runtime layer), the SAME on every standing take v2
## plays - guard loops, punches, reactions, blocks, dodges, steps - so every join meets the stance it left:
##   - the lead foot stands LEAD_M further forward and the rear foot REAR_M further back along the line (a constant
##     move in the take's own space: a foot the take keeps planted stays planted, a foot it swings lands as far on);
##   - the hips ride DROP_M lower (a longer base sits lower; without it the lead knee locks), and lower still, eased
##     over the take, wherever a leg would otherwise be at its full reach;
##   - both legs are solved again onto their feet (two-bone IK, the knee in the plane it bends in); the feet keep their
##     own turn, pitch and height - the cross's raised rear heel (CrossLegs) is baked first and kept.
## Kept beside the takes, one small file a take (DIR/<take>.res: the six leg joints' rotations and how much lower the
## hips ride) and laid over the take as the v2 library is built (StepClips.load_into, which only v2 and its census
## run): the shipped player keeps the takes as bought. `-- fp2nostance` = the takes without it (the control arm).
## Knockdowns and wins are not re-done (a man who falls or walks off is not in his stance).
##   load_into(lib, skel, prefix) -> how many takes got the longer stance

const DIR := "res://assets/anim/baked/v2/stance/"
## The guard as baked is 37-38 cm long with the hips midway (0.48-0.50 of the way from the rear ankle to the lead).
## 12 + 4 = 53-54 cm, the hips at 0.42 (a shade on the back foot). Measured in v2 (tests/player2_test.gd, 60 s):
## 7 + 7 (the hips kept midway) added 0.5 m of foot slide, 14 back on the rear foot alone 0.9 m; with the lead foot
## doing most of it the slide is where it was (6.70 / 6.88 m against 6.66 / 6.97). 10 + 4 left one guard at 44 cm.
const LEAD_M := 0.12
const REAR_M := 0.04
const DROP_M := 0.05
const LEGS := ["LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "RightUpperLeg", "RightLowerLeg", "RightFoot"]
## The kinds of take (clip_db.json) a man stands in his stance through.
const KINDS := ["punch", "reaction", "block", "defence", "idle", "other"]
const REST_META := "rest_y"   # the bake body's hip height: the drop is scaled to the body that plays it

static var off := true   # S537 owner "ok switch off": legs play as recorded (C461 "terrible knee twist"); false = the S536-S537 leg bakes


## The takes the bake re-does: every standing take the census keeps (not dropped) and the step takes that stand on the
## guard's stance (`steps`: StepClips.REFIT - the steps as bought stand on their own actor's 47 cm and are not played).
static func takes(rows: Dictionary, have: Array, steps: Array) -> Array:
	var out: Array = []
	for name in have:
		var r: Dictionary = rows.get(str(name), {})
		var plays := (r.get("drop", []) as Array).is_empty() and str(r.get("kind", "")) in KINDS   # (v2 plays takes the census does not mark played: pro_idle_to_block)
		if plays or str(name) in steps:
			out.append(str(name))
	out.sort()
	return out


static func load_into(lib: AnimationLibrary, skel: Skeleton3D, prefix: String) -> int:
	if off or OS.get_cmdline_user_args().has("fp2nostance"):
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
				# the hips: the take's own keys, each lowered by what the bake found for its time
				var ht := anim.find_track(path, Animation.TYPE_POSITION_3D)
				for k in (anim.track_get_key_count(ht) if ht >= 0 else 0):
					var d: Vector3 = legs.position_track_interpolate(lt, minf(anim.track_get_key_time(ht, k), legs.length))
					anim.track_set_key_value(ht, k, (anim.track_get_key_value(ht, k) as Vector3) + d * scale)
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
