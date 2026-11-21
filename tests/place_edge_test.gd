extends SceneTree
## S533 STEPPAY2 phase 2: the place pays (scripts/rules/PlaceEdge.gd, read by RingDuel.step / step_bias / settle).
## Control arm: PlaceEdge.on false = the game before the rule (no edge, the range game kept).

const PlaceEdge := preload("res://scripts/rules/PlaceEdge.gd")
const RingDuel := preload("res://scripts/state/RingDuel.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const Data := preload("res://scripts/state/Data.gd")

var failures := 0


func _check(ok: bool, what: String) -> void:
	print("%s %s" % ["ok  " if ok else "FAIL", what])
	if not ok:
		failures += 1


## The duel edge of one exchange started on this card (same fighters, same dice).
func _edge(f: Dictionary, o: Dictionary, at: String, call: String, mode: String) -> Dictionary:
	var lv := {"at": at, "n": 1}
	RingDuel.open(lv)
	var rng := RandomNumberGenerator.new()
	rng.seed = 41
	var d := RingDuel.step(f, o, lv, call, mode, 90.0, 90.0, rng)
	d["lv"] = lv
	return d


func _initialize() -> void:
	# The rule itself.
	_check(PlaceEdge.edge("opp_ropes") > 0.0, "the opponent on the ropes is an edge (%+.1f)" % PlaceEdge.edge("opp_ropes"))
	_check(PlaceEdge.edge("corner") > PlaceEdge.edge("opp_ropes"), "the corner pays a bit more (%+.1f)" % PlaceEdge.edge("corner"))
	_check(PlaceEdge.edge("own_ropes") == -PlaceEdge.edge("opp_ropes"), "your own ropes are the mirror (%+.1f)" % PlaceEdge.edge("own_ropes"))
	_check(PlaceEdge.edge("corner") <= float(Exchanges.EDGE["best"]) * 0.5, "bounded: under half a best call (%.1f of %.1f)" % [PlaceEdge.edge("corner"), float(Exchanges.EDGE["best"])])
	for at in ["outside", "long", "mid", "inside", "clinch", ""]:
		_check(PlaceEdge.edge(str(at)) == 0.0, "no edge at '%s'" % str(at))
	_check(float(PlaceEdge.bias({"range": 1.6}, "opp_ropes")["range"]) == 0.0 and float(PlaceEdge.bias({}, "corner")["range"]) == 0.0,
		"a trapped opponent's range game has no weight")
	var b0 := {"range": 1.6}
	PlaceEdge.bias(b0, "corner")
	_check(float(b0["range"]) == 1.6 and PlaceEdge.bias(b0, "own_ropes") == b0, "the bias is a copy; your own ropes leave the opponent's games alone")
	_check(PlaceEdge.mode_at("opp_ropes", "range") == "counter" and PlaceEdge.mode_at("corner", "press") == "press"
		and PlaceEdge.mode_at("long", "range") == "range", "trapped at range -> she covers and counters; other games stay")
	_check(PlaceEdge.call_place("own_ropes", 0) == -1 and PlaceEdge.call_place("own_ropes", 2) == 2 and PlaceEdge.call_place("long", 0) == 0,
		"no asking for long range with her back on the ropes")
	_check(PlaceEdge.mode_place("corner", 0) == -1 and PlaceEdge.mode_place("corner", 2) == 2, "the trapped opponent cannot ask for long range")
	# Exchanges.next_mode never picks range for a trapped Out-boxer (60% of her game), and does with the rule off.
	var rng := RandomNumberGenerator.new()
	rng.seed = 5
	var ranged := 0
	var ranged_off := 0
	for k in 400:
		if Exchanges.next_mode("Out-boxer", "", 1, 2, "range", 90.0, false, rng, 0, PlaceEdge.bias({}, "opp_ropes")) == "range":
			ranged += 1
	PlaceEdge.on = false
	for k in 400:
		if Exchanges.next_mode("Out-boxer", "", 1, 2, "range", 90.0, false, rng, 0, PlaceEdge.bias({}, "opp_ropes")) == "range":
			ranged_off += 1
	PlaceEdge.on = true
	_check(ranged == 0 and ranged_off > 200, "a trapped Out-boxer never goes back to her range game (0 of 400; rule off %d)" % ranged_off)
	# Wired: RingDuel.step adds exactly the place's points to the duel (two different fighters, same dice).
	var c := Career.quick_start()
	var f: Dictionary = c.fighter()
	f["bout"] = {"form": [0.0, 0.0]}
	var o: Dictionary = (Data.OPPONENTS[0] as Dictionary).duplicate(true)
	var base := _edge(f, o, "mid", "", "press")
	for at in ["opp_ropes", "corner", "own_ropes"]:
		var d := _edge(f, o, str(at), "", "press")
		_check(absf(float(d["edge"]) - float(base["edge"]) - PlaceEdge.edge(str(at))) < 0.001 and float(d["lv"]["place_edge"]) == PlaceEdge.edge(str(at)),
			"RingDuel.step at %s = the same duel %+.1f" % [str(at), PlaceEdge.edge(str(at))])
	_check(not RingDuel.step_bias(f, o, {"at": "long"}).has("range") or float(RingDuel.step_bias(f, o, {"at": "long"})["range"]) > 0.0,
		"at long range her range game is hers")
	_check(float(RingDuel.step_bias(f, o, {"at": "corner"})["range"]) == 0.0, "RingDuel.step_bias takes the range game away in the corner")
	# Control arm: the rule off is the game before it.
	PlaceEdge.on = false
	var off := _edge(f, o, "corner", "", "press")
	_check(absf(float(off["edge"]) - float(base["edge"])) < 0.001 and PlaceEdge.edge("corner") == 0.0
		and PlaceEdge.mode_at("corner", "range") == "range" and RingDuel.step_bias(f, o, {"at": "corner"}).get("range", 1.0) != 0.0,
		"control arm (rule off): the corner plays as any other place")
	PlaceEdge.on = true
	print("place_edge_test: %s (%d failures)" % ["PASS" if failures == 0 else "FAIL", failures])
	quit(1 if failures > 0 else 0)
