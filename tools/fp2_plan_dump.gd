extends SceneTree
## FIGHTPLAYER2: prints the choreographer's plan for one exchange of real RoundScript beats (headless, pure).
##   <godot> --headless --path . --script res://tools/fp2_plan_dump.gd -- seed=9 [from=2.0 to=4.0]
## One line a beat (what was asked, the take, the contact, the gap), the distance plan, each boxer's track, the log.

const Choreo := preload("res://scripts/fight3d/v2/Choreographer.gd")
const Gap := preload("res://scripts/fight3d/v2/ChoreoGap.gd")
const ClipCensus := preload("res://scripts/fight3d/v2/ClipCensus.gd")
const RS := preload("res://scripts/rules/RoundScript.gd")


func _initialize() -> void:
	var sd := 7
	var from := 0.0
	var to := 30.0
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with("seed="):
			sd = int(str(a).substr(5))
		if str(a).begins_with("from="):
			from = float(str(a).substr(5))
		if str(a).begins_with("to="):
			to = float(str(a).substr(3))
	var db: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(ClipCensus.DB_PATH))
	var round := {"n": 1, "won": true, "mine": 60.0, "theirs": 55.0, "corner": "", "lines": []}
	var beats: Array = RS.build(round, "Slugger", "Slugger", 30.0, sd)["beats"]
	var plan := Choreo.plan(beats, db, {"t0": 0.0, "t1": 30.0, "seed": sd})
	print("--- beats")
	for b in plan["beats"]:
		if float(b["t"]) < from - 1.0 or float(b["t"]) > to:
			continue
		print("%6.2f %s %-13s %-8s %-6s -> %-28s from %.2f play %6.2f contact %6.2f gap %.2f ik %.2f %s%s" % [float(b["t"]), b["who"], b["move"], b["result"],
			str(b.get("def", "")), b["take"], float(b["from_s"]), float(b["t_play"]), float(b["contact_t"]), float(b["gap"]), float(b["ik_m"]),
			("react " + str(b["react"]) + "/" + str(b["react_part"])) if str(b["react"]) != "" else str(b["defence"]), " CUT" if bool(b["cut"]) else ""])
	print("--- gap plan")
	for g in plan["gap"]:
		if float(g[0]) >= from and float(g[0]) <= to:
			print("%6.2f %.2f %s" % [float(g[0]), float(g[1]), g[2]])
	for w in ["a", "b"]:
		print("--- track ", w)
		for e in plan["tracks"][w]:
			if float(e["t"]) >= from and float(e["t"]) <= to:
				print("%6.2f %-9s %-28s from %.2f ctrl %6.2f %s" % [float(e["t"]), e["kind"], e["clip"], float(e["from_s"]), float(e["control_t"]), str(e.get("m", ""))])
	print("--- log")
	for l in plan["log"]:
		print(l)
	print("--- counts ", plan["counts"])
	quit(0)
