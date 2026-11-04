extends SceneTree
## S381 HOLOOFF (operator after a playtest: "i liked how i told it do the 1-1, step in go body and the fighter actually did
## it (i think you should remove the holos from those if you agree)"): no holo figures or hit-pop close-ups while a round
## plays; the body map still counts every landed shot; the corner card's holo shows where it landed. 4 tests.
## 1. Not built live (S382): BodyLive builds no panel, figure or close-up - nothing of the holo is in the fight's tree.
## 2. Still counting: a landed body hook on blue and a cross on red take their points on the map and the punch stats, and
##    the round's hits per spot (RoundHits.count: a punch counts once per spot).
## 3. No pops on screen: after the punches still no BodyFigure / BodyCallouts anywhere under the fight view.
## 4. Corner card (S382, skeptic: a round-1 card drew a clean figure - every place still 'fine'): the figure the card DRAWS
##    is her muscle holo, and the shader colour it hands the struck spot (her head took the cross) is a visible tint that
##    differs from an unstruck spot (her ribs: clear); the words layer drew "head 1" and nothing for the ribs; below
##    BodyMap.HURT the band colour is on top (not the round tint).

const BodyLive := preload("res://scripts/fight3d/BodyLive.gd")
const BodyMap := preload("res://scripts/rules/BodyMap.gd")
const CornerOverlay := preload("res://scripts/fight3d/CornerOverlay.gd")
const BodyFigure := preload("res://scripts/ui/BodyFigure.gd")
const BodyCallouts := preload("res://scripts/ui/BodyCallouts.gd")
const RoundHits := preload("res://scripts/ui/RoundHits.gd")
const Faces := preload("res://scripts/rules/Faces.gd")

var failures := 0
var bl: Node
var view: Control


class FakeStage extends Node:
	var boxers := [{"south": false}, {"south": false}]


class FakeView extends Control:
	var bodies := ["", ""]
	var stage: Node
	var round_n := 1
	var _names := ["Red", "Blue"]
	var _bug_box: Control


func _initialize() -> void:
	Engine.max_fps = 60   # a headless loop otherwise spins one core flat out (PC heat)
	root.size = Vector2i(1920, 1080)
	view = FakeView.new()
	view.bodies = [Faces.glb("mh_boxer_11"), Faces.glb("mh_boxer_13")]
	view.stage = FakeStage.new()
	view.add_child(view.stage)
	view._bug_box = Control.new()
	view._bug_box.visible = true   # the scorebug is up: a round is playing
	view.add_child(view._bug_box)
	root.add_child(view)
	view.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bl = BodyLive.attach(view)
	await _secs(0.3)
	_check("1 nothing of the holo is built for the live round", _holo_nodes() == 0 and bl.get("figures") == null
		and bl.get("panels") == null, "%d holo nodes" % _holo_nodes())
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
	_check("3 still no holo or close-up under the fight view after the punches", _holo_nodes() == 0, "%d" % _holo_nodes())
	# 4. The corner minute: the card as FightCast hands it over (the map, what her places took, this round's hits).
	view._bug_box.visible = false
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
	_check("4 one word for the hot spot: \"head 1\", none for the ribs", drawn == ["head 1"], str(drawn))
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
	print("HOLO_OFF failures=%d" % failures)
	quit(1 if failures > 0 else 0)


## BodyFigure / BodyCallouts nodes under the fight view (the live round's tree).
func _holo_nodes() -> int:
	return view.find_children("*", "Control", true, false).filter(func(n):
		return n.get_script() == BodyFigure or n.get_script() == BodyCallouts).size()


func _secs(s: float) -> void:
	var end := Time.get_ticks_msec() + int(s * 1000.0)
	while Time.get_ticks_msec() < end:
		await process_frame


func _check(label: String, ok: bool, detail: String) -> void:
	print("  %s %s%s" % ["PASS" if ok else "FAIL", label, "" if ok or detail == "" else "  (" + detail + ")"])
	if not ok:
		failures += 1
