extends SceneTree
## POWER1 step 4: prints RangeTable's distance for every Pro punch take (pelvis to pelvis, metres) and each move's footwork
## distance, for two pairs of different bodies, beside the jab gap every punch was thrown from before. Headless:
##   <godot> --headless --audio-driver Dummy --path . --script res://tools/range_table_probe.gd
## Prints RANGE_TABLE lines.

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const RangeTable := preload("res://scripts/fight3d/RangeTable.gd")
const PAIRS := [["mh_boxer_08", "mh_boxer_13"], ["mh_boxer_20", "mh_boxer_12"]]


func _initialize() -> void:
	for pair in PAIRS:
		var st: Node3D = Stage.new()
		root.add_child(st)
		await process_frame
		st.setup({"glb": "res://assets/models/metahuman/%s.glb" % pair[0], "corner": "red"},
			{"glb": "res://assets/models/metahuman/%s.glb" % pair[1], "corner": "blue"})
		for i in 5:
			await process_frame
		for who in 2:
			var bx: Dictionary = st.boxers[who]
			print("RANGE_TABLE %s throws at %s: jab gap %.3f m (scale %.3f / %.3f)" % [pair[who], pair[1 - who], float(st.gap_m),
				float(st._scale(who)), float(st._scale(1 - who))])
			var mr: Dictionary = bx.get("move_ranges", {})
			for m in mr:
				print("RANGE_TABLE   move %s: footwork %.3f m" % [m, float(mr[m])])
			var rg: Dictionary = bx.get("ranges", {})
			var names := rg.keys()
			names.sort()
			for c in names:
				print("RANGE_TABLE   %s %s %.3f m" % [RangeTable.kind(str(c)), c, float(rg[c])])
		st.queue_free()
		await process_frame
	quit(0)
