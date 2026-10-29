extends SceneTree
## S301 (operator on the S300 film: "these still feel off" - joins and punch speed). For every Pro clip, on the game's own
## body at 60 Hz: how far its first and last frames sit from the guard (pro_idle frame 0) - a gap there is a snap at the
## join - and when it is back in guard after the action ("back_s": the first moment after the punch's contact, or after
## the clip's furthest point from guard, that hands, head and pelvis are all within BACK_M of the guard). Undisputed hands
## control back 0.11-0.17 s after impact; this says where each Pro clip could hand back. Writes
## res://assets/data/clip_recovery.json. Headless:
##   <godot.exe> --headless --path . --script res://tools/clip_recovery.gd -- [prefix=pro_]

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const OUT := "res://assets/data/clip_recovery.json"
const HZ := 60.0
const BONES := ["LeftHand", "RightHand", "Head", "Hips"]
const BACK_M := 0.08


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
	var guard := _pose(stage, bx, "pro_idle", 0.0)
	var out := {}
	for n in ap.get_animation_list():
		var name := str(n)
		if not name.begins_with(prefix):
			continue
		var length: float = ap.get_animation(name).length
		var samples: Array = []
		var t := 0.0
		while t <= length + 0.0001:
			samples.append(_dev(_pose(stage, bx, name, minf(t, length)), guard))
			t += 1.0 / HZ
		var peak_i := 0
		for i in samples.size():
			if float(samples[i]) > float(samples[peak_i]):
				peak_i = i
		var contact := BeatClips.contact(name, -1.0)
		var from_i := peak_i if contact < 0.0 else mini(samples.size() - 1, int(round(contact * HZ)))
		var back := -1.0
		for i in range(from_i, samples.size()):
			if float(samples[i]) <= BACK_M:
				back = i / HZ
				break
		out[name] = {"length_s": snappedf(length, 0.001), "start_m": snappedf(float(samples[0]), 0.001),
			"end_m": snappedf(float(samples[-1]), 0.001), "peak_s": snappedf(peak_i / HZ, 0.001),
			"peak_m": snappedf(float(samples[peak_i]), 0.001), "contact_s": snappedf(contact, 0.001), "back_s": snappedf(back, 0.001)}
		print("RECOVERY %s len %.2f start %.3f end %.3f peak %.2f@%.2f contact %.2f back %.2f" % [name, length, samples[0],
			samples[-1], samples[peak_i], peak_i / HZ, contact, back])
	var f := FileAccess.open(OUT, FileAccess.WRITE)
	f.store_string(JSON.stringify(out, "\t", true))
	f.close()
	print("RECOVERY DONE %d clips -> %s" % [out.size(), OUT])
	quit(0)


func _pose(stage: Node3D, bx: Dictionary, clip: String, t: float) -> Dictionary:
	var p := {}
	for b in BONES:
		p[b] = stage._pose_point(bx, clip, t, b)
	return p


## The largest distance any tracked bone sits from its guard position.
func _dev(p: Dictionary, guard: Dictionary) -> float:
	var worst := 0.0
	for b in BONES:
		worst = maxf(worst, (p[b] as Vector3).distance_to(guard[b] as Vector3))
	return worst
