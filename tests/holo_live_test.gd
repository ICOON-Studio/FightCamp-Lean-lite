extends SceneTree
## S405 the holo on each side of the live round (operator: "i told you to put the holo on each side and blink the area that
## gets hit, on critical hits pop up the right organ flashing, and the wholo changes colors on the damaged or tired areas").
## 1. Built live: one figure a side, up with the scorebug, at the screen's own edge.
## 2. Counting: landed punches take their points on the map, the punch stats and the round's hits.
## 3. Live behaviour: a struck place blinks, a big punch pops its organ, a small one does not, the tired parts reach the figure.
## 4. Corner card: its holo still shows where this round landed.

const BodyLive := preload("res://scripts/fight3d/BodyLive.gd")
const BodyMap := preload("res://scripts/rules/BodyMap.gd")
const CornerOverlay := preload("res://scripts/fight3d/CornerOverlay.gd")
const BodyFigure := preload("res://scripts/ui/BodyFigure.gd")
const BodyCallouts := preload("res://scripts/ui/BodyCallouts.gd")
const BodyPanels := preload("res://scripts/fight3d/BodyPanels.gd")
const RoundHits := preload("res://scripts/ui/RoundHits.gd")
const Faces := preload("res://scripts/rules/Faces.gd")
const FightSeam := preload("res://scripts/fight3d/FightSeam.gd")

var failures := 0
var bl: Node
var view: Control


class FakeStage extends Node:
	var boxers := [{"south": false}, {"south": false}]


class FakeBurn extends Node:
	func track(_i: int) -> Dictionary:
		return {"core": 80.0}


class FakeView extends Control:
	var burn: Node
	var bodies := ["", ""]
	var stage: Node
	var round_n := 1
	var body: Node   # S460: BodyLive, as FightView keeps it
	var _round_beats := []   # empty, as after a call re-planned the round
	var t := 30.0
	var _names := ["Red", "Blue"]
	var _bug_box: Control


func _initialize() -> void:
	Engine.max_fps = 60   # a headless loop otherwise spins one core flat out (PC heat)
	root.size = Vector2i(1920, 1080)
	view = FakeView.new()
	view.bodies = [Faces.glb("mh_boxer_11"), Faces.glb("mh_boxer_13")]
	view.stage = FakeStage.new()
	view.add_child(view.stage)
	view.burn = FakeBurn.new()
	view.add_child(view.burn)
	view._bug_box = Control.new()
	view._bug_box.visible = true   # the scorebug is up: a round is playing
	view.add_child(view._bug_box)
	root.add_child(view)
	view.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bl = BodyLive.attach(view)
	view.body = bl
	await _secs(0.3)
	var holo: Node = bl.get("holo")
	_check("1 two figures, one a side", holo != null and holo.figures.size() == 2, "")
	_check("1 up with the scorebug", holo.panels.all(func(p): return (p as Control).visible), "")
	var left: Rect2 = (holo.panels[0] as Control).get_global_rect()
	var right: Rect2 = (holo.panels[1] as Control).get_global_rect()
	_check("1 each at its own edge, on screen", left.position.x < 100.0 and right.end.x > 1820.0 and right.end.x <= 1920.0
		and left.end.y <= 1080.0, "%s %s" % [left, right])
	_check("1 the critical rule: a big punch, the place that lost most", BodyPanels.critical_place({"head": 90.0, "nose": 90.0},
		{"head": 85.0, "nose": 88.0}, {"head": 5.0, "nose": 2.0}, true) == "head", "")
	_check("1 the critical rule: a place dropping a band", BodyPanels.critical_place({"head": 56.0}, {"head": 54.0}, {"head": 2.0}, false) == "head", "")
	_check("1 the critical rule: an ordinary punch pops nothing", BodyPanels.critical_place({"head": 90.0}, {"head": 88.0}, {"head": 2.0}, false) == "", "")
	bl.land({"t": 12.0, "who": "a", "move": "body_hook", "result": "lands", "big": false, "caption": "", "def": ""}, 0.0)
	bl.land({"t": 13.0, "who": "b", "move": "cross", "result": "lands", "big": true, "caption": "", "def": ""}, 0.0)
	bl.land({"t": 14.0, "who": "b", "move": "jab", "result": "missed", "caption": "", "def": ""}, 0.0)
	await _secs(0.4)
	_check("2 blue's ribs took the body hook", BodyMap.value(bl.map, "b", "right_ribs") < 100.0, str(BodyMap.value(bl.map, "b", "right_ribs")))
	_check("2 red's head took the cross", BodyMap.value(bl.map, "a", "head") < 100.0, str(BodyMap.value(bl.map, "a", "head")))
	_check("2 the punch stats count (red 1/1, blue 1/2)", int(bl.stats[0]["landed"]) == 1 and int(bl.stats[1]["landed"]) == 1
		and int(bl.stats[1]["thrown"]) == 2, str(bl.stats))
	var rh: Dictionary = bl.round_hits(0, 1)
	_check("2 red's round 1: one punch to the head (the cross marks face + head once), nothing on the ribs",
		rh == {"head": 1}, str(rh))
	_check("2 blue's round 1: one to the liver side", bl.round_hits(1, 1) == {"right_ribs": 1}, str(bl.round_hits(1, 1)))
	_check("2 nothing in round 2 yet", bl.round_hits(0, 2).is_empty(), "")
	var lx: Dictionary = FightSeam.landed_ex(view)[0]
	_check("2 S460 C385: LANDED is the holo's own count (red 1 with 1 to the body, blue 1 to the head), whatever the beat list",
		lx["landed"] == [1, 1] and lx["body"] == [1, 0], str(lx))
	var red_co: Node = holo.figures[0].get_node("BodyCallouts")
	var blue_co: Node = holo.figures[1].get_node("BodyCallouts")
	_check("3 the struck place is still blinking", float(holo.figures[0]._flash.get("head", 0.0)) > 0.0, "")
	_check("3 the big cross popped the head card, as the brain", red_co.shown(0) and bool(red_co.get("live_pop")), "")
	_check("3 the ordinary body hook popped nothing", not blue_co.shown(1), "")
	await _secs(0.7)
	_check("3 the tired parts reach the figure", is_equal_approx(float(holo.figures[0]._track.get("core", 0.0)), 80.0), "")
	_check("3 this round's hits reach the figure", holo.figures[0].round_hits == {"head": 1}, str(holo.figures[0].round_hits))
	await process_frame
	await process_frame
	var nums: Array = (holo.words[0].get("drawn") as Array).map(func(d): return str(d[0]))
	_check("3 the holo writes the count on the area (a number, no words)", nums == ["1"], str(nums))
	# 4. The corner minute: the card as FightCast hands it over (the map, what her places took, this round's hits).
	view._bug_box.visible = false
	await _secs(0.1)
	_check("3 the panels go with the scorebug", holo.panels.all(func(p): return not (p as Control).visible), "")
	var co := CornerOverlay.new()
	root.add_child(co)
	co.build({"worked": "", "hurt": "", "why": "", "call": "", "body_map": bl.map, "body_taken": bl.taken[0],
		"body_round_hits": bl.round_hits(0, 1), "body_glb": view.bodies[0]}, ["Red", "Blue"])
	co.show_card(true)
	await _secs(0.3)
	var figs := co.find_children("*", "Control", true, false).filter(func(n): return n.get_script() == BodyFigure)
	var fig: Control = figs[0] if figs.size() == 1 else null
	_check("4 the corner card draws one figure, on screen", fig != null and fig.is_visible_in_tree(), "%d figures" % figs.size())
	if fig == null:
		_end()
		return
	var skin: TextureRect = fig.get_node_or_null("Skin")
	var mat: ShaderMaterial = skin.material as ShaderMaterial if skin != null else null
	_check("4 it is her holo: the drawn skin is the muscle holo picture in holo mode", mat != null and bool(fig.get("holo"))
		and skin.texture != null and skin.texture.resource_path.contains("holo_") and float(mat.get_shader_parameter("holo")) == 1.0,
		skin.texture.resource_path if skin != null and skin.texture != null else "no skin")
	var spot: Array = mat.get_shader_parameter("spot_col") if mat != null else []
	var box: Array = mat.get_shader_parameter("spot_box") if mat != null else []
	_check("4 the drawn spots: three colours, three boxes", spot.size() == 3 and box.size() == 3, "%d %d" % [spot.size(), box.size()])
	if spot.size() == 3:
		var head: Color = spot[0]
		_check("4 her struck head (fine, %d) is drawn tinted (alpha %.2f, the round's amber)" % [int(BodyMap.value(bl.map, "a", "head")),
			head.a], BodyMap.band(BodyMap.value(bl.map, "a", "head")) == "fine" and head.a >= RoundHits.ALPHA_FEW - 0.01
			and head.is_equal_approx(RoundHits.tint(1)), str(head))
		_check("4 the unstruck ribs are drawn clear, so the struck place differs", (spot[1] as Color).a <= 0.0
			and (spot[2] as Color).a <= 0.0 and not head.is_equal_approx(spot[1]), "%s %s" % [spot[1], spot[2]])
		_check("4 the head's tint has a box on her head", (box[0] as Vector4).z > 0.0, str(box[0]))
	var words: Control = co.round_words
	var drawn: Array = (words.get("drawn") as Array).map(func(d): return str(d[0])) if words != null else []
	_check("4 one number on the hot spot (the head: 1), none for the ribs", drawn == ["1"], str(drawn))
	_check("4 the word sits inside the corner card", words != null and drawn.size() == 1
		and co._card.get_global_rect().has_point(words.get_global_transform() * Vector2((words.drawn[0] as Array)[1])), "")
	# The grading and the band on top: many punches turn it orange; a hurt place keeps its band colour.
	_check("4 many punches tint orange, a few amber", RoundHits.tint(RoundHits.MANY_AT).is_equal_approx(Color(RoundHits.MANY,
		RoundHits.ALPHA_MANY)) and RoundHits.tint(1).is_equal_approx(Color(RoundHits.FEW, RoundHits.ALPHA_FEW)) and RoundHits.tint(0).a == 0.0, "")
	fig.set_values({"head": 50.0})
	var hurt: Color = (mat.get_shader_parameter("spot_col") as Array)[0]
	var band := Color(BodyFigure.BAND_COLOURS["hurt"], float(BodyFigure.SPOT_ALPHA["hurt"]))
	_check("4 below HURT the band colour is drawn on top", hurt.is_equal_approx(band), str(hurt))
	_end()


func _end() -> void:
	print("HOLO_LIVE failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _secs(s: float) -> void:
	var end := Time.get_ticks_msec() + int(s * 1000.0)
	while Time.get_ticks_msec() < end:
		await process_frame


func _check(label: String, ok: bool, detail: String) -> void:
	print("  %s %s%s" % ["PASS" if ok else "FAIL", label, "" if ok or detail == "" else "  (" + detail + ")"])
	if not ok:
		failures += 1
