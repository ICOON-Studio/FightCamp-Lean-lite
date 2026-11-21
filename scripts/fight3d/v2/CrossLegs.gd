extends RefCounted
## FIGHTPLAYER2 (S536 FP2POSE2, the owner on the blue cross still, C454: "wtf is that legs doing"): THE CROSS'S REAR
## LEG. The Punch PRO actor throws every cross flat-footed (docs/FP2POSE2_RESULT.md: at the contact his rear ankle rides
## 0-3 cm higher over the ball of the foot than in his stance, the rear foot turns 0-20 deg while the hips turn 31-51,
## the rear knee stays at 144-163 deg) - a boxer drives a cross off the ball of the rear foot: the heel comes up, the
## foot turns in with the hips ("squash the bug"), the knee bends and turns in. That is put into the takes OFFLINE, at
## the bake (tools/cross_legs_bake.gd, the same kind of work as the S529 step refit; no runtime layer): the rear foot
## turned about its ball with the take's own hip turn and its heel lifted, the leg solved again under the take's own
## hips. Only the rear leg's four joints change; the hips, the trunk, the arms and the lead leg are the take's own.
## The re-baked legs are kept beside the takes (DIR, one small file a take: four rotation tracks) and laid over the
## take as the v2 player's library is built (StepClips.load_into, which only v2 and its census run): the shipped player
## keeps the takes as bought. `-- fp2nocrosslegs` = the takes as bought (the control arm; the bake sets `off`).
##   load_into(lib, prefix) -> how many takes got their re-baked leg

const DIR := "res://assets/anim/baked/v2/"
const STEM := "mc_Box1_M3_"
## The cross takes the bake re-does (every one v2 plays, and the hard one).
const TAKES := ["pro_right_cross", "pro_right_cross_a", "pro_right_cross_b", "pro_right_cross_c", "pro_right_cross_ft",
	"pro_right_cross_hard", "pro_right_cross_hard_ft", "pro_right_cross_hurt", "pro_right_cross_hurt_ft"]

static var off := false


static func load_into(lib: AnimationLibrary, prefix: String) -> int:
	if off or OS.get_cmdline_user_args().has("fp2nocrosslegs"):
		return 0
	var done := 0
	for f in DirAccess.get_files_at(DIR):
		var file := str(f).trim_suffix(".remap")
		var name := "pro_" + file.trim_suffix(".res").trim_prefix(STEM).to_lower()
		if not file.ends_with(".res") or not lib.has_animation(name):
			continue
		var anim := lib.get_animation(name)
		var legs := load(DIR + file) as Animation
		for lt in legs.get_track_count():
			var path := NodePath("%s:%s" % [prefix, str(legs.track_get_path(lt))])
			var t := anim.find_track(path, Animation.TYPE_ROTATION_3D)
			if t >= 0:
				anim.remove_track(t)
			t = anim.add_track(Animation.TYPE_ROTATION_3D)
			anim.track_set_path(t, path)
			for k in legs.track_get_key_count(lt):
				anim.rotation_track_insert_key(t, legs.track_get_key_time(lt, k), legs.track_get_key_value(lt, k))
		done += 1
	return done
