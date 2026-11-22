extends RefCounted
## FIGHTPLAYER2 (S528, the owner on film 5, C434: "why the fighter do not walk ?"): THE STEP TAKES. The Punch PRO pack has
## no step in it (its only travel is inside punches, dodges and fidgets), so v2 slid the guard pose wherever the plan moved
## a boxer. These are captured boxing steps: Mixamo's boxing footwork set (the owner's own downloads, royalty-free in a
## game, the raw files stay out of the repo in E:/FightCamp/packs/mixamo_steps), put on our body once by
## tools/step_bake.gd through the retarget the side-step walks already used (RkRetarget: a foot the actor keeps planted
## stays planted on our legs) and turned so the feet stand on the guard's own line. One take = one whole step in guard:
## the lead foot goes first going in, the rear foot first going out, the hands stay by the head.
## Each is baked as bare bone tracks, the hips as travel from the bake body's rest (like every baked take).
##   load_into(lib, skel, prefix) -> names added (FightClips pins them like every take and keeps their travel beside them)
## What each take does (travel, the time it travels in, when each foot stands) is in assets/data/foot_db.json
## (tools/step_census.gd db).

const CrossLegs := preload("res://scripts/fight3d/v2/CrossLegs.gd")
const Stance := preload("res://scripts/fight3d/v2/Stance.gd")
const DIR := "res://assets/anim/baked/steps/"
const PREFIX := "st_"
## file stem (E:/FightCamp/packs/mixamo_steps) -> take name
const SOURCES := {
	"Short_Boxing_Step_Forward": "st_fwd_s", "Medium_Boxing_Step_Forward": "st_fwd_m", "Long_Boxing_Step_Forward": "st_fwd_l",
	"Short_Boxing_Step_Backward": "st_back_s", "Medium_Boxing_Step_Backward": "st_back_m", "Long_Boxing_Step_Backward": "st_back_l",
	"Short_Left_Boxing_Side_Step": "st_left_s", "Medium_Left_Boxing_Side_Step": "st_left_m", "Long_Left_Boxing_Side_Step": "st_left_l",
	"Short_Right_Boxing_Side_Step": "st_right_s", "Medium_Right_Boxing_Side_Step": "st_right_m", "Long_Right_Boxing_Side_Step": "st_right_l",
	"High_Left_Boxing_Pivot": "st_pivot_left_hi", "High_Right_Boxing_Pivot": "st_pivot_right_hi",
	"Low_Left_Boxing_Pivot": "st_pivot_left_lo", "Low_Right_Boxing_Pivot": "st_pivot_right_lo",
	"Boxing_Advancing_Forward": "st_advancing", "Bouncing_Boxing_Idle": "st_bounce", "Bouncing_Fight_Idle_With_Guard_Up": "st_bounce_guard",
	"Boxing_Idle": "st_idle", "Male_Boxing_Idle": "st_idle_male", "Boxing_Dodge_Advance": "st_dodge_adv", "Boxing_Dodge_Retreat": "st_dodge_ret",
}
## S529 the WALKING takes, refitted onto the Punch PRO guard's own stance by the bake (tools/step_bake.gd, THE REFIT):
## take -> [source stem, stride]. The stride scales the captured travel to a boxing step (the actor's "short" step
## forward is 0.51 m; the critics' bar is 15-30 cm): in 0.23 / 0.36, out 0.23 / 0.35, left 0.20 / 0.34, right 0.21 / 0.34.
const REFIT := {
	"st_in_s": ["Short_Boxing_Step_Forward", 0.45], "st_in_m": ["Short_Boxing_Step_Forward", 0.70],
	"st_out_s": ["Short_Boxing_Step_Backward", 0.75], "st_out_m": ["Medium_Boxing_Step_Backward", 0.63],
	"st_l_s": ["Short_Left_Boxing_Side_Step", 1.0], "st_l_m": ["Medium_Left_Boxing_Side_Step", 1.0],
	"st_r_s": ["Short_Right_Boxing_Side_Step", 0.85], "st_r_m": ["Medium_Right_Boxing_Side_Step", 0.80],
	# S531 THE LIVING WAIT (films 6 and 7, both critics: "two men standing still"; their bar a 2-4 cm bounce about twice a
	# second): the bouncing boxing idles on the guard's own stance, a standing heel flat (the owner on film 7: "mostly on
	# his toes" - as bought st_bounce holds its lead heel up in 71 % of its pictures). The stride scales the bob too
	# (6.8 cm as bought). These two LOOP (load_into).
	"st_wait": ["Bouncing_Boxing_Idle", 0.55], "st_wait_g": ["Bouncing_Fight_Idle_With_Guard_Up", 1.0],
}
## S531 (the owner: "they look like robots" - both men bounced ONE loop): red waits in st_wait, blue in st_wait_g
## (Player2.WAITS). Boxing_Idle was tried as a third: refitted it stands knock-kneed (the hips come down 7 cm for reach).
const LOOPS := ["st_wait", "st_wait_g"]


static func names() -> Array:
	var out: Array = []
	for f in DirAccess.get_files_at(DIR):
		var file := str(f).trim_suffix(".remap")
		if file.begins_with(PREFIX) and file.ends_with(".res"):
			out.append(file.trim_suffix(".res"))
	out.sort()
	return out


## Adds every baked step take to `lib` on `skel` (tracks prefixed `prefix:`). Returns the names added.
static func load_into(lib: AnimationLibrary, skel: Skeleton3D, prefix: String) -> Array:
	var rest: Vector3 = skel.get_bone_rest(skel.find_bone("Hips")).origin
	var added: Array = []
	CrossLegs.load_into(lib, prefix)   # S536 FP2POSE2: the cross takes' re-baked rear leg (v2 and its census only, like the steps)
	for name in names():
		if lib.has_animation(name):
			continue
		var anim := (load(DIR + str(name) + ".res") as Animation).duplicate(true) as Animation
		for t in anim.get_track_count():
			anim.track_set_path(t, NodePath("%s:%s" % [prefix, str(anim.track_get_path(t))]))
			if anim.track_get_type(t) == Animation.TYPE_POSITION_3D:
				for k in anim.track_get_key_count(t):
					anim.track_set_key_value(t, k, rest + (anim.track_get_key_value(t, k) as Vector3))
		anim.loop_mode = Animation.LOOP_LINEAR if str(name) in LOOPS else Animation.LOOP_NONE
		lib.add_animation(name, anim)
		added.append(name)
	Stance.load_into(lib, skel, prefix)   # S537 FP2POSE3: the longer stance, on every standing take (after the cross's legs)
	return added
