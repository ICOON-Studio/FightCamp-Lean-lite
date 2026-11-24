extends Control
## PICS2D2 (S540, owner Q-S294-310 "Keep, build the full set"): the fight in pictures - a second view of a settled round,
## beside the 3D. Each 30-second exchange shows up to three of its punches as paired pictures (tools/pics2d_set.gd renders
## them from our own 3D: assets/ui/fight_pictures/<w|m>/), each PIC_S long with the 0.24 s pop (0.90 -> 1.035 -> 1.0),
## an impact ring on a landed punch and a MISS / BLOCKED streak otherwise; a clinch, a knockdown in three frames and the
## corner stool when the round had them. It reads the round the sim settled (BoutTape: the ring's own beats) and decides
## nothing. Ships ON; `-- nopics2d` is the control arm.
##   button(main, m) -> Button     open(parent, data) -> FightPictures     data(main, m, n) -> {names, set, shows}
##   shows(tape_exs, r) -> Array (pure: what is shown, in order)

const BoutTape := preload("res://scripts/fight3d/BoutTape.gd")
const Faces := preload("res://scripts/rules/Faces.gd")
const UI := preload("res://scripts/ui/UI.gd")
const Palette := preload("res://scripts/ui/Palette.gd")   # PICSFIX1: every colour from the one palette
const DIR := "res://assets/ui/fight_pictures/"
const PIC_S := 1.1
const POP_S := 0.24
const RING_S := 0.48
const PER_EXCHANGE := 3
const FAMILIES := ["jab", "cross", "lead_hook", "rear_hook", "body_hook", "body_cross", "lead_uppercut", "rear_uppercut"]
const RESULT_PIC := {"lands": "landed", "blocked": "blocked", "misses": "missed"}
const VERB := {"lands": "lands the", "blocked": "is blocked: the", "misses": "misses the"}

var names: Array = ["", ""]
var pics: Array = []
var set_id := "w"
var at := 0          # the picture now shown
var u := 0.0         # seconds into it
var playing := true
var _pic: TextureRect
var _fx: Fx
var _flash: ColorRect
var _clock: Label
var _exl: Label
var _what: Label
var _line: Label
var _texs := {}


static func on() -> bool:
	return not OS.get_cmdline_user_args().has("nopics2d")


static func set_for(f: Dictionary) -> String:
	return "m" if Faces.sex(f) == "m" else "w"


## A beat's picture: "<corner>_<family>_<landed|blocked|missed>", or "" for a move we have no picture of.
static func pic_of(b: Dictionary) -> String:
	var mv := str(b.get("move", ""))
	if not mv in FAMILIES or not RESULT_PIC.has(str(b.get("result", ""))):
		return ""
	return "%s_%s_%s" % ["red" if str(b.get("who", "a")) == "a" else "blue", mv, RESULT_PIC[str(b["result"])]]


## What one round shows, in order. tape_exs: this round's BoutTape exchanges ({i, beats (t inside the exchange)});
## r: the closed round (its exchanges' clinch flags and verdicts, counts / down / stopped). Per exchange: the first punch,
## the winner's best landed (a big one first), one that missed or was blocked; a clinch after the first when it had one;
## the knockdown in three frames at the end; then your boxer on her stool when the bout goes on.
static func shows(tape_exs: Array, r: Dictionary) -> Array:
	var out: Array = []
	var recs: Array = r.get("exchanges", [])
	for k in tape_exs.size():
		var tx: Dictionary = tape_exs[k]
		var x: Dictionary = recs[k] if k < recs.size() else {}
		var at0 := float(k) * 30.0
		var mine: Array = []
		for b in tx.get("beats", []):
			if pic_of(b) != "":
				mine.append(b)
		var line := str(x.get("verdict", "")) if str(x.get("verdict", "")) != "" else str(x.get("duel_line", ""))
		if mine.is_empty():
			out.append({"k": k, "t": at0 + 1.0, "pic": "guard", "who": "", "line": line})
			continue
		var chosen: Array = [mine[0]]
		var win := "a" if _yes(tx.get("won", x.get("won", false))) else "b"
		var best: Dictionary = {}
		for b in mine:
			if str(b["who"]) == win and str(b["result"]) == "lands" and (best.is_empty() or _yes(b.get("big", false))):
				best = b
		if not best.is_empty() and not chosen.has(best):
			chosen.append(best)
		for b in mine:
			if chosen.size() < PER_EXCHANGE and str(b["result"]) != "lands" and not chosen.has(b):
				chosen.append(b)
				break
		chosen.sort_custom(func(p, q): return float(p["t"]) < float(q["t"]))
		for j in chosen.size():
			var b: Dictionary = chosen[j]
			out.append({"k": k, "t": at0 + float(b["t"]), "pic": pic_of(b), "who": str(b["who"]), "move": str(b["move"]),
				"result": str(b["result"]), "big": _yes(b.get("big", false)), "line": line})
			if j == 0 and _yes(x.get("clinch", false)):
				out.append({"k": k, "t": at0 + float(b["t"]) + 0.5, "pic": "clinch", "who": "", "line": line, "say": "Clinch - both tie up"})
	var down := str(r.get("down", ""))
	if int(r.get("counts", 0)) > 0 and down in ["a", "b"]:
		var corner := "red" if down == "a" else "blue"
		for n in 3:
			out.append({"k": maxi(tape_exs.size() - 1, 0), "t": 179.0, "pic": "%s_knockdown_%d" % [corner, n + 1], "who": "",
				"line": "", "say": ("Your boxer is down" if down == "a" else "The opponent is down") if n < 2 else "The count"})
	elif str(r.get("stopped", "")) == "" and not out.is_empty():
		out.append({"k": maxi(tape_exs.size() - 1, 0), "t": 180.0, "pic": "red_corner", "who": "", "line": "", "say": "The bell - back to the corner"})
	return out


## Round n's pictures (1-based; 0 = the last closed round) from the moment.
static func data(main: Node, m: Dictionary, n: int = 0) -> Dictionary:
	var f: Dictionary = main.career.fighter_by_id(str(m["fid"]))
	var rounds: Array = m.get("rounds", [])
	var rn := n if n > 0 else rounds.size()
	var tape: Array = BoutTape.build(main.career, f, m).filter(func(x): return int(x["round"]) == rn)
	var opp: Dictionary = (f.get("bout", {}) as Dictionary).get("opp", {})
	return {"names": [str(f.get("name", "")), str(opp.get("name", ""))], "set": set_for(f), "round": rn,
		"shows": shows(tape, rounds[rn - 1] if rn >= 1 and rn <= rounds.size() else {})}


## The fight screen's toggle (the round page, beside the 3D): opens the round just closed in pictures.
static func button(main: Node, m: Dictionary) -> Button:
	var b := UI.button("Watch it in pictures", "Btn", func(): open(main, data(main, m)))
	b.name = "Pictures"
	b.tooltip_text = "The round just fought, exchange by exchange, as paired pictures: who threw what and whether it landed."
	return b


static func open(parent: Node, d: Dictionary) -> Control:
	var old := parent.get_node_or_null("FightPictures")
	if old != null:
		parent.remove_child(old)
		old.queue_free()
	var v: Control = load("res://scripts/ui/FightPictures.gd").new()
	v.name = "FightPictures"
	v.names = d.get("names", ["", ""])
	v.pics = d.get("shows", [])
	v.set_id = str(d.get("set", "w"))
	parent.add_child(v)
	v.build(int(d.get("round", 1)))
	return v


func pic_path(p: String) -> String:
	return DIR + set_id + "/" + p + ".png"


func build(round_n: int) -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	var bg := ColorRect.new()
	bg.color = Palette.PAGE
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(bg)
	var canvas := ColorRect.new()   # a lit canvas behind the pair, as a ring floor under lights
	canvas.color = Palette.TEXT.darkened(0.07)
	canvas.position = Vector2(90, 70)
	canvas.size = Vector2(940, 940)
	add_child(canvas)
	_pic = TextureRect.new()
	_pic.name = "Picture"
	_pic.position = Vector2(100, 80)
	_pic.size = Vector2(920, 920)
	_pic.pivot_offset = _pic.size * 0.5
	_pic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_pic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	add_child(_pic)
	_fx = Fx.new()
	_fx.position = _pic.position
	_fx.size = _pic.size
	_fx.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_fx)
	_flash = ColorRect.new()
	_flash.color = Palette.fade(0.0)
	_flash.position = canvas.position
	_flash.size = canvas.size
	_flash.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_flash)
	var head := _label(Vector2(1090, 90), 40, "%s  v  %s" % [names[0], names[1]])
	head.add_theme_color_override("font_color", Palette.HEADER.lightened(0.3))
	_label(Vector2(1090, 150), 24, "ROUND %d IN PICTURES" % round_n).add_theme_color_override("font_color", Palette.MUTED)
	_clock = _label(Vector2(1090, 190), 60, "")
	_exl = _label(Vector2(1090, 280), 30, "")
	_what = _label(Vector2(1090, 340), 38, "")
	_what.name = "What"
	_line = _label(Vector2(1090, 430), 26, "")
	_line.size = Vector2(760, 300)
	_line.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	var row := HBoxContainer.new()
	row.position = Vector2(1090, 900)
	row.add_theme_constant_override("separation", 16)
	add_child(row)
	var again := UI.button("Play again", "Btn", func(): show_pic(0))
	again.name = "PicsAgain"
	row.add_child(again)
	var close := UI.button("Back to the corner", "BtnSolid", func(): close_view())
	close.name = "PicsClose"
	row.add_child(close)
	show_pic(0)


func close_view() -> void:
	if get_parent() != null:
		get_parent().remove_child(self)
	queue_free()


func _label(p: Vector2, px: int, t: String) -> Label:
	var l := Label.new()
	l.position = p
	l.text = t
	l.add_theme_font_size_override("font_size", px)
	l.add_theme_color_override("font_color", Palette.TEXT)
	add_child(l)
	return l


func _tex(p: String) -> Texture2D:
	if not _texs.has(p):
		_texs[p] = load(pic_path(p)) if ResourceLoader.exists(pic_path(p)) else null
	return _texs[p]


## Shows picture i (its words, its effect) and starts its time.
func show_pic(i: int) -> void:
	if pics.is_empty():
		_what.text = "No exchanges to show"
		playing = false
		return
	at = clampi(i, 0, pics.size() - 1)
	u = 0.0
	playing = true
	var s: Dictionary = pics[at]
	var p := str(s["pic"])
	_pic.texture = _tex(p) if _tex(p) != null else _tex("guard")
	var left := maxf(180.0 - float(s["t"]), 0.0)
	_clock.text = "%d:%02d" % [int(left) / 60, int(left) % 60]
	_exl.text = "Exchange %d of 6" % (int(s["k"]) + 1)
	var who := str(s.get("who", ""))
	if who != "":
		_what.text = "%s %s %s" % ["Your boxer" if who == "a" else "The opponent", VERB.get(str(s["result"]), ""), str(s.get("move", "")).replace("_", " ")]
	else:
		_what.text = str(s.get("say", "Both on guard"))
	_line.text = str(s.get("line", ""))
	var c: Dictionary = _contact(p)
	var sc := _pic.size.x / 768.0
	_fx.start(str(s.get("result", "")) == "lands", Vector2(c["glove"][0], c["glove"][1]) * sc, Vector2(c["target"][0], c["target"][1]) * sc, who != "")
	_fx.word = "BLOCKED" if str(s.get("result", "")) == "blocked" else "MISS"
	_frame()


static var _contacts := {}


func _contact(p: String) -> Dictionary:
	if not _contacts.has(set_id):
		var path := DIR + set_id + "/contacts.json"
		var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(path)) if FileAccess.file_exists(path) else null
		_contacts[set_id] = parsed if parsed is Dictionary else {}
	var c: Dictionary = (_contacts[set_id] as Dictionary).get(p, {})
	if not c.has("glove") or not c.has("target"):
		return {"glove": [384, 300], "target": [430, 290]}
	return c


func _process(delta: float) -> void:
	if not playing or pics.is_empty():
		return
	u += delta
	if u >= PIC_S:
		if at + 1 < pics.size():
			show_pic(at + 1)
		else:
			playing = false
			u = PIC_S
	_frame()


func _frame() -> void:
	_pic.scale = Vector2.ONE * pop(u)
	_fx.at(u)
	_flash.color.a = clampf(0.35 * (1.0 - u / 0.15), 0.0, 0.35) if str((pics[at] as Dictionary).get("result", "")) == "lands" else 0.0


## The pop: 0.90 -> 1.035 over the first half of POP_S, -> 1.0 over the second.
static func pop(t: float) -> float:
	if t >= POP_S:
		return 1.0
	var h := POP_S * 0.5
	if t < h:
		return lerpf(0.90, 1.035, ease(t / h, 0.5))
	return lerpf(1.035, 1.0, ease((t - h) / h, 2.0))


## The impact ring (landed) or the MISS / BLOCKED streak, drawn over the picture.
class Fx extends Control:
	var landed := false
	var glove := Vector2.ZERO
	var face := Vector2.ZERO
	var on := false
	var word := "MISS"
	var u := 0.0

	func start(l: bool, g: Vector2, f: Vector2, show: bool) -> void:
		landed = l
		glove = g
		face = f
		on = show
		u = 0.0
		queue_redraw()

	func at(t: float) -> void:
		u = t
		queue_redraw()

	func _draw() -> void:
		if not on:
			return
		if landed:
			if u > RING_S:
				return
			var k := u / RING_S
			var r := lerpf(20.0, 130.0, ease(k, 0.4))
			var a := 1.0 - k
			draw_arc(glove, r, 0.0, TAU, 48, Palette.alpha(Palette.CLIP_BAND, a), lerpf(12.0, 3.0, k), true)
			draw_arc(glove, r * 0.62, 0.0, TAU, 40, Palette.fade(a), lerpf(7.0, 2.0, k), true)
			for i in 10:
				var d := Vector2.from_angle(TAU * i / 10.0 + 0.3)
				draw_line(glove + d * r * 0.7, glove + d * r * 1.15, Palette.alpha(Palette.WARN.lightened(0.2), a), 5.0, true)
		else:
			if u > 0.7:
				return
			var dir := (face - glove).normalized() if face.distance_to(glove) > 1.0 else Vector2.RIGHT
			var a := clampf(1.0 - (u - 0.35) / 0.35, 0.0, 1.0)
			var shift := dir * lerpf(0.0, 50.0, minf(u / 0.3, 1.0))
			for i in 3:
				var o := Vector2(-dir.y, dir.x) * (i - 1) * 14.0
				draw_line(glove + o - dir * 110.0 + shift, glove + o + dir * 26.0 + shift, Palette.fade(a * 0.8), 4.0, true)
			draw_string(ThemeDB.fallback_font, face + Vector2(-70, -90) + shift, word, HORIZONTAL_ALIGNMENT_LEFT, -1, 56, Palette.alpha(Palette.BAD_FILL, a))


## A field read as yes/no: a bool as it is, a filled Dictionary/Array (the tape's clinch record) as yes.
static func _yes(v: Variant) -> bool:
	if v is bool:
		return v
	if v is Dictionary or v is Array:
		return not v.is_empty()
	return v != null and str(v) not in ["", "0", "false"]
