extends SceneTree
## S319 SHOVEL1: how far each punch clip's glove travels before contact. For every clip in clip_contact.json, the punching
## hand relative to the hips (a stepping take does not count as fist travel), sampled at 60 Hz on the game's own body from
## the clip's start to its contact. Writes res://assets/data/clip_travel.json {clip: {"travel_m", "path": [[t_s, cum_m], ..]}}
## that ShortPunch reads to start a clip part-way through up close (15-30 cm of fist travel, J_INSIDE2). Headless:
##   <godot.exe> --headless --path . --script res://tools/clip_travel.gd

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const OUT := "res://assets/data/clip_travel.json"
const HZ := 60.0


func _initialize() -> void:
	var stage: Node3D = Stage.new()
	root.add_child(stage)
	await process_frame
	stage.setup({"glb": "res://assets/models/metahuman/mh_boxer_10.glb", "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_11.glb", "corner": "blue"})
	stage.set_process(false)
	var bx: Dictionary = stage.boxers[0]
	var ap: AnimationPlayer = bx["ap"]
	var contact: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(BeatClips.CONTACT_PATH))
	var out := {}
	for name in contact:
		var row: Dictionary = contact[name]
		var hand := str(row.get("hand", ""))
		if hand == "" or not ap.has_animation(name):
			continue
		var c := float(row["contact_s"])
		var path := [[0.0, 0.0]]
		var cum := 0.0
		var prev: Vector3 = _rel(bx, name, 0.0, hand)
		var t := 1.0 / HZ
		while t <= c + 0.0001:
			var p: Vector3 = _rel(bx, name, t, hand)
			cum += p.distance_to(prev)
			prev = p
			path.append([snappedf(t, 0.001), snappedf(cum, 0.001)])
			t += 1.0 / HZ
		out[name] = {"travel_m": snappedf(cum, 0.001), "path": path}
		print("TRAVEL %s %s %.2f m in %.2fs" % [name, hand, cum, c])
	var f := FileAccess.open(OUT, FileAccess.WRITE)
	f.store_string(JSON.stringify(out, "", true))
	f.close()
	print("TRAVEL DONE %d clips -> %s" % [out.size(), OUT])
	quit(0)


func _rel(bx: Dictionary, clip: String, t: float, hand: String) -> Vector3:
	return Stage.IdleMatch.pose_point(bx, clip, t, hand) - Stage.IdleMatch.pose_point(bx, clip, t, "Hips")
