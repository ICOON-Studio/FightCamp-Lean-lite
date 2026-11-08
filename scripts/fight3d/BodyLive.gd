extends Node
## S318 the body map live (operator S316: "a body visual ... real time interactive on where the hits are being taken and
## changing colour on that area"; plan Q-S294-29 "Yes, build it", Game Godot/research/S316_BODY_MAP_PLAN.md step 2).
## Keeps the bout's BodyMap (six places a boxer, over all its rounds): a landed punch takes its points at the glove's contact.
##   attach(view) -> BodyLive   land(beat, at_s)   bell()   catch_up()   map / taken / stats / round_hits(side, n)
## S405 the holo panels on each side of the live round are BodyPanels (they were off from S381 to S405).

const BodyMap := preload("res://scripts/rules/BodyMap.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const BodyTip := preload("res://scripts/ui/BodyTip.gd")
const CalloutLine := preload("res://scripts/ui/CalloutLine.gd")
const RoundHits := preload("res://scripts/ui/RoundHits.gd")
const BodyPanels := preload("res://scripts/fight3d/BodyPanels.gd")

var view: Control
var map: Dictionary = BodyMap.fresh()
## S320 TV punch stats (CompuBox style), the fight so far: thrown/landed, jabs, power, to the body.
var stats := [{"thrown": 0, "landed": 0, "jab_t": 0, "jab_l": 0, "pow_t": 0, "pow_l": 0, "body": 0},
	{"thrown": 0, "landed": 0, "jab_t": 0, "jab_l": 0, "pow_t": 0, "pow_l": 0, "body": 0}]
## S348 (C199): what each place took, per boxer ({place: BodyTip.log_hit entry}); the corner card's tooltips read it.
var taken := [{}, {}]
## S382 per boxer {round_n: {spot: punches landed}} (RoundHits.count) - the corner card tints this round's hot spots.
var _by_round := [{}, {}]
var holo: Node   # BodyPanels: the two side figures
var _catching := false   # SKIP ROUND lands the rest at once: nothing blinks or pops for those


static func attach(v: Control) -> Node:
	var bl := new()
	bl.name = "BodyLive"
	bl.view = v
	v.add_child(bl)
	# S320 the round and result pages draw the bout's body map too (RoundGraphics.body): the modal shares the map.
	if v.get("main") != null:
		v.main.modal["body_map"] = bl.map
		v.main.modal["bodies"] = v.get("bodies")
	bl.holo = BodyPanels.attach(v, bl)
	return bl


## A beat FightView fires; a landed punch reaches the other boxer `at_s` from now (its contact).
func land(b: Dictionary, at_s: float) -> void:
	if not str(b.get("move", "")) in BodyMap.PUNCHES:
		return
	var st: Dictionary = stats[0 if str(b["who"]) == "a" else 1]
	st["thrown"] += 1
	st["jab_t" if str(b["move"]) == "jab" else "pow_t"] += 1
	if str(b.get("result", "")) != "lands":
		return
	get_tree().create_timer(maxf(0.0, at_s)).timeout.connect(_apply.bind(b))
	var calls: Node = view.get_node_or_null("FightCalls")
	if calls != null and bool(b.get("big", false)):
		get_tree().create_timer(maxf(0.0, at_s - calls.LEAD_S)).timeout.connect(calls.big_coming.bind(b))


func _apply(b: Dictionary) -> void:
	var calls: Node = view.get_node_or_null("FightCalls")
	if calls != null:
		calls.landed(b)
	var def := "b" if str(b["who"]) == "a" else "a"
	var side := 0 if def == "a" else 1
	var st: Dictionary = stats[1 - side]
	st["landed"] += 1
	st["jab_l" if str(b["move"]) == "jab" else "pow_l"] += 1
	if str(b["move"]).contains("body"):
		st["body"] += 1
	var before := {}
	for p in BodyMap.PLACES:
		before[p] = BodyMap.value(map, def, p)
	var stage: Node = view.stage
	BodyMap.add_beats(map, [b], {"a": bool(stage.boxers[0].get("south", false)), "b": bool(stage.boxers[1].get("south", false))})
	var struck := []
	var lost := {}
	var round_n := int(view.get("round_n"))
	for p in BodyMap.PLACES:
		if BodyMap.value(map, def, p) < float(before[p]):
			struck.append(p)
			lost[p] = float(before[p]) - BodyMap.value(map, def, p)
			BodyTip.log_hit(taken[side], p, str(b["move"]), bool(b.get("big", false)), round_n)
	RoundHits.count(_by_round[side], round_n, struck)
	var bars: Node = view.get("bars")   # S392: the HUD answers at the contact
	if bars != null and not lost.is_empty():
		bars.hit(side, lost, bool(b.get("big", false)))
	if holo != null and not lost.is_empty() and not _catching:
		holo.struck(side, before, lost, str(b["move"]), bool(b.get("big", false)))


## S382 {spot: punches landed} on boxer `side` (0 = hers) in round `n` (the corner card's tint and words).
func round_hits(side: int, n: int) -> Dictionary:
	return (_by_round[side] as Dictionary).get(n, {}).duplicate()


## The place tooltip from a bout map, one boxer `who` and what her places took (S381: the corner card's holo).
static func place_tip(bmap: Dictionary, who: String, took: Dictionary, place: String) -> String:
	var m: Dictionary = bmap.get(who, {})
	return BodyTip.text(place, BodyMap.value(bmap, who, place), took.get(place, {}),
		BodyMap.value(bmap, who, "head"), bool((m.get("cuts", {}) as Dictionary).get(place, false)),
		bool((m.get("closed", {}) as Dictionary).get(place, false)))


## S379 the line under a close-up: its worst place's value, what landed on its place, an open cut on her face.
static func spot_line(bmap: Dictionary, who: String, took: Dictionary, s: Dictionary) -> String:
	var m: Dictionary = bmap.get(who, {})
	var worst := 100.0
	var cut := false
	for p in s["places"]:
		worst = minf(worst, BodyMap.value(bmap, who, str(p)))
		cut = cut or (bool((m.get("cuts", {}) as Dictionary).get(p, false))
			and not bool((m.get("closed", {}) as Dictionary).get(p, false)))
	return CalloutLine.line(str(s["name"]), worst, took.get(str(s["at"]), {}), str(s["at"]) != "head", cut)


## SKIP ROUND: the round is settled (Bouts "round_out"); its unwatched exchanges are built into the view's beats and
## every punch not yet played lands on the map now, so a skipped round still leaves its marks.
func catch_up() -> void:
	_catching = true
	for k in range(int(view._ex_done), Exchanges.EXCHANGES):
		view._queue(view.main.modal, k)
	var rest: Array = (view.beats as Array).slice(int(view.next))
	for b in rest:
		if str(b.get("move", "")) in BodyMap.PUNCHES:
			var st: Dictionary = stats[0 if str(b["who"]) == "a" else 1]
			st["thrown"] += 1
			st["jab_t" if str(b["move"]) == "jab" else "pow_t"] += 1
		if str(b.get("result", "")) == "lands" and str(b.get("move", "")) in BodyMap.PUNCHES:
			_apply(b)
	view.next = (view.beats as Array).size()
	_catching = false


## The round's bell: the corner's one-round fixes run out (BodyMap.end_round).
func bell() -> void:
	BodyMap.end_round(map)
