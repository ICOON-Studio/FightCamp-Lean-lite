extends SceneTree
## S528 GUARDPROBE4 - guard posture with an opponent whose aim PERSISTS (GUARDPROBE3 re-modelled).
## GUARDPROBE3 (Goose #398) reset her aim to the baseline the moment our boxer changed posture, so a switch never
## met the shift it answers - SWITCH could not win. Here her aim is a state: once our boxer has held HIGH for N full
## rounds she moves S of her punches to the body, and it stays there until he holds LOW for N rounds (then S to the
## head). NEUTRAL moves nothing. Bouts are played once per cell (guard_probe3._play, the real BoutNight path); the
## posture is applied per round to the through-guard leak, as guard_probe2/3 do.
## Bots: HIGH, LOW, NEUTRAL (fixed); SWITCH (HIGH, LOW once she digs the body, HIGH once she goes back upstairs);
## READ (each round the posture with the least expected damage for where she aims now - a corner reading the card).
## PASS: no FIXED posture is best in more than 60% of cells (a switch must pay somewhere) - printed per arm.
##   godot --headless --audio-driver Dummy --path . --script res://tools/guard_probe4.gd [-- bouts=50]

const P3 := preload("res://tools/guard_probe3.gd")
const GuardWear := preload("res://scripts/rules/GuardWear.gd")

const SEED0 := 7000
const ARMS := [
	{"N": 1, "S": 0.15}, {"N": 1, "S": 0.25}, {"N": 1, "S": 0.35},
	{"N": 2, "S": 0.15}, {"N": 2, "S": 0.25}, {"N": 2, "S": 0.35},
	{"N": 3, "S": 0.15}, {"N": 3, "S": 0.25}, {"N": 3, "S": 0.35},
]
const BOTS := ["HIGH", "LOW", "NEUTRAL", "SWITCH", "READ"]
const FIXED := ["HIGH", "LOW", "NEUTRAL"]

var L := []

func _initialize() -> void:
	var t0 := Time.get_ticks_msec()
	var bouts := 50
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with("bouts="):
			bouts = int(str(a).substr(6))
	_say(["# GUARDPROBE4 - guard posture against an opponent whose aim persists", "",
		"Run: `godot --headless --audio-driver Dummy --path . --script res://tools/guard_probe4.gd`.",
		"Seeds %d-%d, %d bouts a cell, 12 cells (guard_probe3's: 6 styles x am3 + pro6)." % [SEED0, SEED0 + bouts - 1, bouts],
		"Her aim: held HIGH N full rounds -> +S to the body (stays); held LOW N rounds -> -S (stays); NEUTRAL moves nothing.",
		"Damage = through-guard leak split head/body by her current body share x GuardWear.posture_damage.", ""])
	var cells := {}
	for cell in P3.CELLS:
		var rounds := []
		var body := 0
		var landed := 0
		for i in bouts:
			var r: Dictionary = P3._play(cell, SEED0 + i)
			body += int(r["body_a"])
			landed += int(r["landed_a"])
			rounds.append(r["rounds"])
		cells[cell["id"]] = {"share": float(body) / maxf(1.0, float(landed)), "bouts": rounds, "rounds": int(cell["rounds"])}
		_say("Cell %s: body share %.3f" % [cell["id"], cells[cell["id"]]["share"]])
	_say("(bouts played in %.1f s)" % ((Time.get_ticks_msec() - t0) / 1000.0))
	var passing := []
	for arm in ARMS:
		var key := "N=%d S=%.2f" % [arm["N"], arm["S"]]
		var best_count := {}
		for b in BOTS:
			best_count[b] = 0
		var rows := []
		for id in cells:
			var cd: Dictionary = cells[id]
			var dmg := {}
			for b in BOTS:
				var tot := 0.0
				for br in cd["bouts"]:
					tot += sim(b, int(arm["N"]), float(arm["S"]), float(cd["share"]), br, int(cd["rounds"]))
				dmg[b] = tot
			var best := ""
			for b in BOTS:
				if best == "" or float(dmg[b]) < float(dmg[best]) - 0.0001:
					best = b
			best_count[best] += 1
			var neu := maxf(0.0001, float(dmg["NEUTRAL"]))
			var parts := []
			for b in BOTS:
				parts.append("%s %+.1f%%" % [b, (float(dmg[b]) / neu - 1.0) * 100.0])
			rows.append("  %-14s best %-7s | %s" % [id, best, ", ".join(parts)])
		var fixed_max := 0
		for b in FIXED:
			fixed_max = maxi(fixed_max, int(best_count[b]))
		var ok := fixed_max <= 7
		if ok:
			passing.append(key)
		_say(["", "## %s  best counts %s  fixed max %d/12 -> %s" % [key, str(best_count), fixed_max, "PASS" if ok else "fail"]])
		_say(rows)
	_say("")
	var line := "NONE" if passing.is_empty() else "PASS at %s (all: %s)" % [passing[0], ", ".join(passing)]
	_say("RESULT: tools/guard_probe4.gd -> %s" % line)
	var fa := FileAccess.open("res://docs/GUARDPROBE4_RESULT.md", FileAccess.WRITE)
	if fa != null:
		fa.store_string("\n".join(L) + "\n")
		fa.close()
	print("GUARDPROBE4 done (%.1f s)" % ((Time.get_ticks_msec() - t0) / 1000.0))
	quit(0)

## One bout's damage for one bot. aim = her shift of body share (+ = more to the body), persistent.
static func sim(bot: String, n: int, s: float, base: float, bout_rounds: Array, total: int) -> float:
	var aim := 0.0
	var held := ""
	var count := 0
	var dmg := 0.0
	var sw_low := false
	for r in mini(total, bout_rounds.size()):
		var share := clampf(base + aim, 0.02, 0.98)
		var p := "neutral"
		match bot:
			"HIGH": p = "high"
			"LOW": p = "low"
			"SWITCH":
				if aim > 0.0:
					sw_low = true
				elif aim < 0.0:
					sw_low = false
				p = "low" if sw_low else "high"
			"READ": p = cheapest(share)
		var through := float((bout_rounds[r] as Dictionary).get("through", 0.0))
		dmg += through * ((1.0 - share) * GuardWear.posture_damage(p, "head") + share * GuardWear.posture_damage(p, "body"))
		count = count + 1 if p == held else 1
		held = p
		if count >= n:
			if p == "high":
				aim = s
			elif p == "low":
				aim = -s
	return dmg

static func cheapest(share: float) -> String:
	var best := "neutral"
	var low_cost := 999.0
	for p in ["high", "neutral", "low"]:
		var c := (1.0 - share) * GuardWear.posture_damage(p, "head") + share * GuardWear.posture_damage(p, "body")
		if c < low_cost - 0.0001:
			low_cost = c
			best = p
	return best

func _say(v: Variant) -> void:
	var lines: Array = v if v is Array else [v]
	for s in lines:
		print(s)
		L.append(s)
