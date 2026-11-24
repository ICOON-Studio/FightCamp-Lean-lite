extends SceneTree
## BODYREACT2 (S547, owner C502: "the reaction should force the opponent to bend hisposture a bit"): a landed body punch
## draws a take that folds on the blow. Pure: no scene, no body - assets/data/clip_db.json (fold_g, baked by
## tools/bodyreact2_bake.gd from each gut-shot take's own keys) through ChoreoReact.react, the v2 player's own pick.
## The pictures are tools/bodyreact2_ruler.gd's (the v2 player, as drawn, a fixed side camera); this holds the rule:
##   BAKED    every gut-shot reaction carries its fold (a tools/clip_census.gd re-run without the bake goes red here)
##   FOLDS    60 seeds a size (normal, big), five body sizes: the take drawn shows BODY_FOLD_MIN_DEG or more over the
##            fight's guard BODY_FOLD_S after the key the player starts it on, and 0.15 s after it (ChoreoReact.fold_shown:
##            the take's fold through the fold join - within 2 deg of the ruler's pictures on the films' pairs)
##   DEEPEST  a big body punch takes the deepest of the takes that fold on the blow
##   HEADS    a head punch picks what it picked without the rule (the same table with the folds taken out), 400 seeds
##   DRAWS    the body pick leaves the exchange's dice where the old pick left them (every later draw is unchanged)
##   WORSE    the rule can read worse: with the folds taken out a body punch falls back to the head-travel pick (a take
##            that does NOT fold on the blow) and the plan's log says so
## Run: <godot> --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tests/body_react_test.gd

const Census := preload("res://scripts/fight3d/v2/ClipCensus.gd")
const React := preload("res://scripts/fight3d/v2/ChoreoReact.gd")
const R := preload("res://scripts/fight3d/v2/ChoreoRules.gd")
const SIZES := [0.9, 1.0, 1.05, 1.104, 1.164]   # the census body, the films' men (02 / 01), a smaller and a mid one
const HEAD_MOVES := ["jab", "cross", "lead_hook", "rear_hook", "lead_uppercut", "rear_uppercut"]

var failures := 0


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
	print(("PASS " if ok else "FAIL ") + what)


func _initialize() -> void:
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(Census.DB_PATH))
	if not (parsed is Dictionary):
		print("FAIL the table reads")
		print("BODY_REACT failures=1")
		quit(1)
		return
	var db: Dictionary = parsed
	var rows: Dictionary = db["rows"]
	var hz: float = float((db.get("meta", {}) as Dictionary).get("curve_hz", 30.0))
	var bare: Dictionary = db.duplicate(true)   # the same table without the folds: the old pick
	var gut := 0
	var baked := 0
	for n in rows:
		if str(rows[n].get("kind", "")) == "reaction" and str(n).contains("gutshot"):
			gut += 1
			baked += 1 if (rows[n].get("fold_g", []) as Array).size() >= 10 and rows[n].has("fold_blow_deg") and rows[n].has("fold_015_deg") else 0
			(bare["rows"][n] as Dictionary).erase("fold_g")
	_check(gut >= 4 and baked == gut, "BAKED every gut-shot reaction carries its fold (%d of %d; run tools/bodyreact2_bake.gd after a census)" % [baked, gut])
	var least := INF
	var least_015 := INF
	var drawn := {}
	var n_body := 0
	var deepest_ok := true
	var same_dice := 0
	for sc in SIZES:
		for big in [false, true]:
			for sd in 60:
				var rng := RandomNumberGenerator.new()
				rng.seed = sd
				var ri: Array = React.react(db, rows, "body_hook", bool(big), true, rng, 0.023, [], float(sc), [])
				var row: Dictionary = ri[1]
				var from: float = float(React.start_s(row, "body_hook", hz, float(sc))[0])
				var curve: Array = row.get("fold_g", [])
				least = minf(least, React.fold_shown(curve, from, React.BODY_FOLD_S, hz) if not curve.is_empty() else -99.0)
				least_015 = minf(least_015, React.fold_shown(curve, from, 0.15, hz) if not curve.is_empty() else -99.0)
				drawn[str(ri[0])] = int(drawn.get(str(ri[0]), 0)) + 1
				n_body += 1
				if bool(big):
					for other in rows:
						var oc: Array = rows[other].get("fold_g", [])
						if oc.is_empty() or not React.may_play(rows[other], true):
							continue
						var o_from: float = float(React.start_s(rows[other], "body_hook", hz, float(sc))[0])
						if React.fold_shown(oc, o_from, React.BODY_FOLD_S, hz) > React.fold_shown(curve, from, React.BODY_FOLD_S, hz) + 1e-6:
							deepest_ok = false
				var rng2 := RandomNumberGenerator.new()
				rng2.seed = sd
				React.react(bare, bare["rows"], "body_hook", bool(big), true, rng2, 0.023, [], float(sc), [])
				same_dice += 1 if rng.state == rng2.state else 0
	_check(least >= React.BODY_FOLD_MIN_DEG, "FOLDS a landed body punch draws a take whose picture shows %.0f deg or more %.3f s after its start (least %.1f deg over %d picks: %s)" % [React.BODY_FOLD_MIN_DEG, React.BODY_FOLD_S, least, n_body, str(drawn)])
	_check(least_015 >= React.BODY_FOLD_MIN_DEG, "FOLDS ... and inside 0.15 s (least %.1f deg at 0.15 s)" % least_015)
	_check(deepest_ok, "DEEPEST a big body punch takes the deepest take that folds on the blow")
	_check(same_dice == n_body, "DRAWS the body pick leaves the exchange's dice where the old pick left them (%d of %d)" % [same_dice, n_body])
	var head_same := 0
	var head_n := 0
	for move in HEAD_MOVES:
		for big in [false, true]:
			var used_a: Array = []
			var used_b: Array = []
			for sd in 400:
				if sd % 5 == 0:
					used_a.clear()
					used_b.clear()
				var ra := RandomNumberGenerator.new()
				ra.seed = sd
				var rb := RandomNumberGenerator.new()
				rb.seed = sd
				var a: Array = React.react(db, rows, str(move), bool(big), R.is_left_hand(str(move)), ra, 0.023, [], 1.104, used_a)
				var b: Array = React.react(bare, bare["rows"], str(move), bool(big), R.is_left_hand(str(move)), rb, 0.023, [], 1.104, used_b)
				head_n += 1
				head_same += 1 if str(a[0]) == str(b[0]) and not str(a[0]).contains("gutshot") else 0
	_check(head_same == head_n, "HEADS a head punch picks what it picked without the rule, never a gut-shot take (%d of %d)" % [head_same, head_n])
	var log: Array = []
	var rw := RandomNumberGenerator.new()
	rw.seed = 7
	var old: Array = React.react(bare, bare["rows"], "body_hook", false, true, rw, 0.023, log, 1.0, [])
	var old_row: Dictionary = rows.get(str(old[0]), {})
	var old_from: float = float(React.start_s(old_row, "body_hook", hz, 1.0)[0])
	var old_fold: float = React.fold_shown(old_row.get("fold_g", [0.0]), old_from, React.BODY_FOLD_S, hz)
	_check(old_fold < React.BODY_FOLD_MIN_DEG and log.any(func(l): return str(l).contains("no take folds on the blow")),
		"WORSE without the folds a body punch falls back to the head-travel pick (%s: %.1f deg on the blow) and the log says so" % [old[0], old_fold])
	print("BODY_REACT failures=%d" % failures)
	quit(0 if failures == 0 else 1)
