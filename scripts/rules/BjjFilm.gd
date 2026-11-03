extends RefCounted
## S375 (operator: "i expect to see the bjj moves not a female fighter doing box", "use this https://eel.is/GrappleMap"):
## each no-gi syllabus move (BeltRoad.SYLLABUS ids) as a GrappleMap sequence the mat player can play - by its GrappleMap
## tags, else by a phrase in its title (checked against assets/grapplemap/GrappleMap.txt S375: every entry below finds a
## transition). Moves GrappleMap has no sequence for (americana, clock choke, waiter sweep, K-guard, over-under pass,
## scissor sweep) are left out: the Playbook says so instead of playing a wrong move.
## S376 BJJCOACH1 (the coach's steps run on the film, so the film must BE the move): the leg locks played a judo trip
## ("o-soto-gari": tag ashi_waza is judo's foot throws) - now the ashi entry (straight ankle lock), ashi to double outside
## ashi (outside heel hook), ashi to the 50/50 heel hook (inside heel hook), side control to the honey hole (saddle entry);
## the scissor sweep played a flying scissor (kani basami), so it is unfilmed; berimbolo and crucifix found. "keys" picks
## one of several sequences with the same title by its keyframe count.
##   film(id) -> {tags} | {title[, keys]} | {}   find(db, id) -> GrappleMap sequence index, -1 when none
## Pure static; preloads the GrappleMap reader.

const DB := preload("res://scripts/grapple/GrappleMapDB.gd")

const FILM := {
	"shrimp_bridge": {"title": "shrimp escape"}, "frame_recover_guard": {"title": "bottom recovers full guard"},
	"seatbelt_escape": {"title": "top releases seatbelt"}, "posture_closed_guard": {"title": "posture up"},
	"bullfighter_pass": {"tags": ["pass_around"]}, "knee_cut_pass": {"tags": ["knee_slice"]},
	"hip_bump_sweep": {"tags": ["hip_bump"]}, "double_leg": {"tags": ["double_leg_takedown"]}, "armbar_guard": {"tags": ["armbar"]},
	"kimura": {"tags": ["kimura"]}, "rear_naked_choke": {"tags": ["rear_naked_choke"]}, "guillotine": {"tags": ["guillotine"]},
	"triangle": {"tags": ["triangle"]}, "mounted_triangle": {"tags": ["triangle"]}, "back_triangle": {"tags": ["triangle"]},
	"butterfly_sweep": {"tags": ["butterfly_sweep"]}, "arm_drag_back": {"tags": ["arm_drag"]}, "body_lock_pass": {"tags": ["body_lock"]},
	"deep_half": {"tags": ["deep_half"]}, "darce": {"tags": ["darce"]}, "anaconda": {"tags": ["arm_triangle"]},
	"omoplata": {"tags": ["omoplata"]}, "kneebar": {"tags": ["knee_bar"]}, "leg_drag": {"tags": ["leg_drag"]},
	"wrestle_up": {"tags": ["stand_up"]}, "counter_pass": {"tags": ["frame"]}, "north_south_choke": {"title": "to north/south"},
	"toe_hold": {"tags": ["toehold"]}, "straight_ankle_lock": {"title": "top goes for ankle"},
	"outside_heel_hook": {"title": "bring inside leg out"}, "inside_heel_hook": {"title": "to 50/50", "keys": 9},
	"saddle_entry": {"title": "top attacks leg"}, "berimbolo": {"title": "berimbolo", "keys": 8},
	"crucifix": {"title": "pick up and crucify"}, "single_leg_x": {"title": "to slx"}, "de_la_riva": {"title": "dlr sweep"},
	"calf_slicer": {"title": "calf crank"},
}


static func film(id: String) -> Dictionary:
	return FILM.get(id, {})


## The GrappleMap transition (two keyframes or more) that films this move; -1 when GrappleMap has none. Among tag matches
## the one whose title names the move wins (S375 still: the first "kimura"-tagged move was a "step over", no kimura seen).
static func find(db: Array, id: String) -> int:
	var f := film(id)
	if f.is_empty():
		return -1
	var first := -1
	var word := str((f.get("tags", [""]) as Array)[0]).replace("_", " ")
	for i in db.size():
		var s: Dictionary = db[i]
		if not DB.is_transition(s):
			continue
		if f.has("keys") and (s["frames"] as Array).size() != int(f["keys"]):
			continue
		var title := str(s["title"]).to_lower().replace("\n", " ")
		if f.has("title") and title.contains(str(f["title"])):
			return i
		if f.has("tags") and (f["tags"] as Array).all(func(t): return (s["tags"] as PackedStringArray).has(str(t))):
			if word != "" and title.contains(word):
				return i
			if first < 0:
				first = i
	return first
