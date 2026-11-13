extends SceneTree
## S442 BUBBLES (LOOP_DRAWINGS_S442 s2, the operator's "All three"): the reaction bubbles' rules without a picture.
## Two at most (a third replaces the oldest), each expires after its life, the slot picker keeps off every head / glove /
## foot rect and says "none" when all are blocked, the heard word follows the game's shout rule, and no bubble text
## built from a sample exchange carries a pronoun. Prints REACTION_BUBBLES failures=N.

const RB := preload("res://scripts/fight3d/ReactionBubbles.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const ShoutBar := preload("res://scripts/fight3d/ShoutBar.gd")

var failures := 0


func _initialize() -> void:
	_queue()
	_slots()
	_heard()
	_words()
	print("REACTION_BUBBLES failures=%d" % failures)
	quit(0 if failures == 0 else 1)


func _ctx() -> Dictionary:
	return {"names": ["Lucy", "Priya"], "f": {"bout": {"arrows": [{"move": "1-1"}, {"move": "step_back"}, {"move": "1-2-3"}]}}}


func _x(won: bool) -> Dictionary:
	return {"call": "hands", "shout": true, "shouts_before": 0, "said": "", "won": won, "planned": true, "arrow": "1-2-3",
		"plan_tally": [1, 2], "verdict": Exchanges.verdict("hands", "counter", won, ["Lucy", "Priya"])}


func _beats(x: Dictionary) -> Array:
	var out: Array = []
	for kind in ["shout", "coach", "plan", "plan_end"]:
		out.append(RB.mark({"t": 0.0, "who": "a", "move": "say", "result": "none", "caption": "c"}, kind, x, _ctx()))
	return out


func _queue() -> void:
	var rb: Control = RB.new()
	root.add_child(rb)
	var bs := _beats(_x(false))
	for i in 3:
		rb.add(bs[i], Rect2(Vector2(40, 200 + i * 120), Vector2(300, 80)), Vector2(470, 270))
		_check(rb.live.size() <= RB.MAX_ON, "never more than %d on screen (after %d)" % [RB.MAX_ON, i + 1])
	_check(rb.live.size() == 2, "two on screen after three")
	_check(str(rb.live[0]["kind"]) == "coach" and str(rb.live[1]["kind"]) == "plan", "the third replaced the oldest (the shout)")
	rb.tick(RB.LIFE_S * 0.5)
	_check(rb.live.size() == 2, "both still up halfway through their life")
	rb.tick(RB.LIFE_S * 0.5 + 0.05)
	_check(rb.live.is_empty(), "each expires after its life (%.1f s)" % RB.LIFE_S)
	rb.queue_free()


func _slots() -> void:
	var anchor := Vector2(470, 270)
	var safe := Rect2(16, 180, 1888, 700)
	var sz := Vector2(400, 90)
	var rng := RandomNumberGenerator.new()
	rng.seed = 442
	var got := 0
	for trial in 300:
		var keep: Array = []
		for k in rng.randi_range(1, 6):
			keep.append(RB.keep_rect(Vector2(rng.randf_range(0, 1920), rng.randf_range(150, 950)), rng.randf_range(20, 90)))
		var r: Rect2 = RB.pick_slot(anchor, sz, keep, safe, [])
		if r.size == Vector2.ZERO:
			continue
		got += 1
		for kr in keep:
			_check(not r.intersects(kr), "trial %d: the slot %s covers a keep-out %s" % [trial, r, kr])
		_check(safe.encloses(r), "trial %d: the slot stays inside the safe area" % trial)
	_check(got > 100, "most random layouts leave a free slot (%d of 300)" % got)
	var all := RB.pick_slot(anchor, sz, [Rect2(0, 0, 1920, 1080)], safe, [])
	_check(all.size == Vector2.ZERO, "every slot blocked -> none")
	var first := RB.pick_slot(anchor, sz, [], safe, [])
	var second := RB.pick_slot(anchor, sz, [], safe, [first])
	_check(first.size != Vector2.ZERO and second.size != Vector2.ZERO and not first.intersects(second), "a second bubble takes another slot")


func _heard() -> void:
	# The game's rule: Exchanges.uptake takes in full while shouts_before < FULL_SHOUTS; ShoutBar.shout_note says so.
	for n in 3:
		var full := Exchanges.uptake(55.0, n) >= Exchanges.uptake(55.0, 0)
		var word := RB.heard_word(n, true)
		_check(word == ("Heard" if full else "Half heard"), "shout %d of the round: %s" % [n + 1, word])
		_check(ShoutBar.shout_note(n, "Lucy").contains("only half") == (word == "Half heard"), "shout %d agrees with the shout bar's note" % (n + 1))
	_check(RB.heard_word(0, false) == "Not heard", "a fighter who stopped listening: Not heard")
	var x := _x(true)
	x["shout"] = false
	x["said"] = "hands"
	var b := RB.mark({"t": 0.0, "who": "a", "move": "say", "result": "none", "caption": ""}, "shout", x, _ctx())
	_check(str(b["bub"]["tag"]) == "Not heard", "a shout said but not taken in is marked Not heard")


func _words() -> void:
	var re := RegEx.new()
	re.compile("(?i)\\b(he|she|her|hers|him|his)\\b")
	for won in [true, false]:
		for b in _beats(_x(won)):
			var txt := RB.text_of(b)
			_check(txt.length() > 3, "%s bubble has words" % b["bubble"])
			_check(re.search(txt) == null, "no pronoun in the %s bubble: %s" % [b["bubble"], txt])
	var bs := _beats(_x(false))
	_check(RB.text_of(bs[0]).contains("Hands up! Move your head!") and str(bs[0]["bub"]["tag"]) == "Heard", "shout: the call and Heard")
	_check(RB.text_of(bs[2]).contains("Plan C") and RB.text_of(bs[2]).contains("One-two-hook"), "plan fires: Plan C - One-two-hook")
	_check(RB.text_of(bs[3]).contains("lost it") and RB.text_of(bs[3]).contains("1 of 2"), "plan ends: lost it, 1 of 2")
	_check(RB.text_of(bs[1]).contains("exchange to the opponent"), "coach: the exchange went to the opponent (S448: the role)")


func _check(cond: bool, label: String) -> void:
	if not cond:
		failures += 1
		print("FAIL ", label)
