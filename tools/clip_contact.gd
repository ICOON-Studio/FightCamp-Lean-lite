extends SceneTree
## When each punch clip lands: the time its punching glove comes closest to the other boxer's head (body for body shots)
## at the fight's jab gap, sampled at 60 Hz on the game's own body and clip library. Writes res://assets/data/clip_contact.json
## {clip: {"contact_s", "hand", "reach_m" (glove-to-target miss), "length_s"}} that BeatClips reads for hit timing. Headless:
##   <godot.exe> --headless --path . --script res://tools/clip_contact.gd -- [prefix=pro_]

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const OUT := "res://assets/data/clip_contact.json"
## Clip names that throw a punch.
const PUNCH_WORDS := ["jab", "cross", "hook", "uppercut", "body_shot", "kidney_shot", "combo_punch", "combo_lh"]
const HZ := 60.0


func _initialize() -> void:
	var prefix := "pro_"
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with("prefix="):
			prefix = str(a).substr(7)
	var stage: Node3D = Stage.new()
	root.add_child(stage)
	await process_frame
	stage.setup({"glb": "res://assets/models/metahuman/mh_boxer_10.glb", "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_11.glb", "corner": "blue"})
	stage.set_process(false)
	var bx: Dictionary = stage.boxers[0]
	var ap: AnimationPlayer = bx["ap"]
	var out := {}
	for n in ap.get_animation_list():
		var name := str(n)
		if not name.begins_with(prefix) or name.contains("hit_by") or not PUNCH_WORDS.any(func(w): return name.contains(w)):
			continue
		var length: float = ap.get_animation(name).length
		# The punching hand from the clip's name (left_ = lead); the target is where the other boxer's head (body for a
		# body or kidney shot) stands at the fight's jab gap. Contact = the glove's closest moment to it in the clip's first
		# 75% (the rest is the recovery).
		var hands: Array = ["LeftHand"] if name.contains("left_") or name.contains("kidney") else (["RightHand"] if name.contains("right_") else ["LeftHand", "RightHand"])
		var head_y: float = stage._pose_point(bx, name, 0.0, "Head").y
		var body := name.contains("body") or name.contains("kidney")
		var target := Vector3(0.0, head_y - (0.5 if body else 0.0), stage.gap_m)
		var best := {"t": 0.0, "hand": "", "reach": 99.0}
		var t := 0.0
		while t <= length * 0.75:
			for hand in hands:
				var miss: float = stage._pose_point(bx, name, t, hand).distance_to(target)
				if miss < float(best["reach"]):
					best = {"t": t, "hand": hand, "reach": miss}
			t += 1.0 / HZ
		out[name] = {"contact_s": snappedf(float(best["t"]), 0.001), "hand": best["hand"], "reach_m": snappedf(float(best["reach"]), 0.001),
			"length_s": snappedf(length, 0.001)}
		print("CONTACT %s %.3fs %s %.2f m from the target (len %.2fs)" % [name, best["t"], best["hand"], best["reach"], length])
	var f := FileAccess.open(OUT, FileAccess.WRITE)
	f.store_string(JSON.stringify(out, "\t", true))
	f.close()
	print("CONTACT DONE %d clips -> %s" % [out.size(), OUT])
	quit(0)
