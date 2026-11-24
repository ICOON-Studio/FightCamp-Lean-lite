extends RefCounted
## S545 KNOWBUILD1 (owner S544: "looks like spreadheet you need to use art"; S545: "you do not need to spell everything out
## for the player"): the signing card and the trial evening are SCENES. Beside ProScene (the pro call's office):
##   art(p, caption, size) -> Control        the prospect painted in the gym, the name on a plate at the foot
##   band(lo, hi, level, tone, w) -> Control  a read as a band on a 0-100 track with the level's tick (it tweens in)
##   read_col(id, cap, r, level, tip) -> Control   one group's band with its range in big words ("56-72")
##   strip(c, p) -> Control                   21 days from today: the bout, the rival's window, the safe days before it
##   question(main, pid, q, odds, on) -> Button   tomorrow's question as a picture button (K4)
## Pictures already in the game (assets/ui/art); no new art is generated in this build.

const UI := preload("res://scripts/ui/UI.gd")
const Palette := preload("res://scripts/ui/Palette.gd")
const MenuFx := preload("res://scripts/ui/MenuFx.gd")
const RosterCards := preload("res://scripts/ui/RosterCards.gd")
const ProScene := preload("res://scripts/ui/ProScene.gd")

const GYM := "res://assets/ui/art/gym_backdrop.jpg"
const DAYS := 21
const SPRITE := "res://assets/ui/art/hub_sprites/%s_%s.png"   ## S548: the prospect's own body (was always mh_boxer_01, a man)
const FRAME := 4   ## the hub sheets' frame shown on a question (mid-move)
## The four questions (K4): the picture, the button's name, what it narrows (one plain line), the hover.
const QUESTIONS := {
	"body": {"pic": "stretch", "name": "BODY", "line": "the fitness test", "tip": "Strength, speed and engine. A second ask narrows it again, half as much."},
	"skills": {"pic": "bag_combo", "name": "SKILLS", "line": "pad rounds", "tip": "Accuracy, timing, defence and footwork on the pads. A second ask narrows them half as much."},
	"pads": {"pic": "bag_upper", "name": "PAD TEST", "line": "the ceiling, halved", "tip": "How far the prospect can go: the ceiling's range halves. A second test takes a quarter."},
	"spar": {"pic": "guard_move", "name": "HARD SPAR", "line": "under fire", "tip": "Under fire and how the prospect takes pressure. The risk: injury twice as likely that night, +15 tiredness."},
}


static func art(p: Dictionary, caption: String, size: Vector2) -> Control:
	var box := Control.new()
	box.name = "ProspectArt"
	box.custom_minimum_size = size
	box.size_flags_vertical = Control.SIZE_EXPAND_FILL
	box.clip_contents = true
	box.add_child(MenuFx.art(GYM))
	box.add_child(ProScene._shade(0.30, 0.96))
	var body: Control = RosterCards.stance_body(p)
	if body != null:
		box.add_child(body)
		body.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		body.offset_top = 70.0
		body.offset_bottom = -70.0
		body.offset_left = -60.0
		body.offset_right = 60.0
		body.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.add_child(ProScene._shade(0.72, 0.94))
	var cap := UI.label(caption, UI.SMALL, Palette.TEXT, "caps", true)
	cap.name = "SceneCaption"
	cap.position = Vector2(20, 18)
	cap.custom_minimum_size.x = size.x - 40.0
	box.add_child(cap)
	var plate := UI.vbox(0)
	plate.name = "NamePlate"
	plate.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	plate.offset_left = 20.0
	plate.offset_right = -12.0
	plate.offset_top = -86.0
	plate.offset_bottom = -12.0
	var nm := str(p["name"]).to_upper()
	plate.add_child(UI.display(nm, clampi(int((size.x - 32.0) / (float(nm.length()) * 0.60)), 26, 44), Palette.TEXT))
	plate.add_child(UI.label("%d, %s  ·  amateur %d-%d" % [int(p["age"]), str(p["wc"]), int(p["w"]), int(p["l"])], UI.BODY, Palette.MUTED, "semi"))
	box.add_child(plate)
	return box


## A read drawn as a band: the dark 0-100 track, the band from lo to hi, the level's tick. The band grows in (it tweens).
class Band extends Control:
	var lo := 0.0
	var hi := 0.0
	var level := 60.0
	var tone := Palette.TEXT
	var grow := 0.0

	func _ready() -> void:
		if MenuFx.instant:
			grow = 1.0
			return
		var t := create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		t.tween_property(self, "grow", 1.0, 0.5)

	func _process(_d: float) -> void:
		queue_redraw()

	func _draw() -> void:
		var h := size.y
		var y := h * 0.5 - 7.0
		draw_rect(Rect2(0, y, size.x, 14), Palette.PAGE)
		var mid := (lo + hi) * 0.5
		var a := lerpf(mid, lo, grow) / 100.0 * size.x
		var b := lerpf(mid, hi, grow) / 100.0 * size.x
		draw_rect(Rect2(a, y, maxf(2.0, b - a), 14), Palette.alpha(tone, 0.85))
		var lx := level / 100.0 * size.x
		draw_rect(Rect2(lx - 1.5, y - 6, 3, 26), Palette.TEXT)


static func band(lo: float, hi: float, level: float, tone: Color, w: float = 240.0) -> Control:
	var b := Band.new()
	b.lo = lo
	b.hi = hi
	b.level = level
	b.tone = tone
	b.custom_minimum_size = Vector2(w, 28)
	b.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return b


static func range_text(r: Dictionary) -> String:
	return "%d-%d" % [int(floor(float(r["lo"]))), int(ceil(float(r["hi"])))]


## The band's colour against the level: clear above it green, under it red, across it amber.
static func tone_of(r: Dictionary, level: float) -> Color:
	if float(r["lo"]) > level:
		return Palette.GOOD_FILL
	if float(r["hi"]) < level:
		return Palette.BAD_FILL
	return Palette.WARN


static func read_col(id: String, cap: String, r: Dictionary, level: float, tip: String, w: float = 240.0) -> Control:
	var v := UI.vbox(2)
	v.name = "Read_" + id
	v.mouse_filter = Control.MOUSE_FILTER_STOP
	v.tooltip_text = tip
	v.add_child(UI.label(cap, 15, Palette.MUTED, "caps"))
	var t := UI.label(range_text(r), 30, Palette.TEXT, "bold")
	t.name = "Range_" + id
	v.add_child(t)
	var b := band(float(r["lo"]), float(r["hi"]), level, tone_of(r, level), w)
	v.add_child(b)
	return v


## 21 days from today: each day a cell; the bout's day gold with a glove mark, the rival's window red, the days before the
## window green (safe), today outlined. Empty (no node) for a name with no dates.
static func strip(c: Career, p: Dictionary) -> Control:
	if int(p.get("window_to", -1)) < 0:
		return null
	var v := UI.vbox(4)
	v.name = "DayStrip"
	var cells := UI.hbox(3)
	var win := UI.hbox(0)
	var bout := int(p["bout_day"])
	var from := int(p["window_from"])
	var to := int(p["window_to"])
	v.mouse_filter = Control.MOUSE_FILTER_STOP
	v.tooltip_text = "The next three weeks. Gold: the prospect boxes at the region show (free to watch). Red: %s may sign any of these days. Green: safe, the rival will not decide yet." % str(p["club"])
	for i in DAYS:
		var d := c.day + i
		var cell := PanelContainer.new()
		cell.custom_minimum_size = Vector2(40, 40)
		cell.mouse_filter = Control.MOUSE_FILTER_IGNORE
		var col := Palette.alpha(Palette.GOOD_FILL, 0.55) if d < from else (Palette.alpha(Palette.BAD_FILL, 0.75) if d <= to else Palette.alpha(Palette.TEXT, 0.06))
		if d == bout:
			col = Palette.HEADER
			cell.name = "StripBout"
		cell.add_theme_stylebox_override("panel", UI.box(col, Palette.TEXT if i == 0 else Palette.CLEAR, 4, 2 if i == 0 else 0, 0, 0))
		var l := UI.label(str(int(Clock._date(d)["day"])), 14, Palette.PAGE if d == bout else Palette.TEXT, "bold")
		l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		cell.add_child(l)
		cells.add_child(cell)
		if d == from:
			win.name = "StripWindow"
	v.add_child(cells)
	var keys := UI.hbox(26)
	keys.add_child(_key(Palette.HEADER, "Boxes %s" % Clock.fmt(bout)))
	keys.add_child(_key(Palette.BAD_FILL, "%s decide %s - %s" % [str(p["club"]), Clock.fmt(from), Clock.fmt(to)]))
	keys.add_child(win)
	v.add_child(keys)
	if win.name != "StripWindow":   # the window starts past the 21 days shown: the key still names it
		win.name = "StripWindow"
	return v


static func _key(col: Color, words: String) -> Control:
	var h := UI.hbox(8)
	var d := ColorRect.new()
	d.color = col
	d.custom_minimum_size = Vector2(16, 16)
	d.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	h.add_child(d)
	h.add_child(UI.label(words, UI.SMALL, Palette.TEXT, "semi"))
	return h


## Tomorrow's question as a picture button: the boxer at the bag / in guard / stretching, the question's name, what it narrows.
static func question(main: Node, pid: String, q: String, asked: int, on: bool, stem: String = "mh_boxer_01") -> Button:
	var info: Dictionary = QUESTIONS[q]
	var b := Button.new()
	b.name = "Q_" + q
	b.focus_mode = Control.FOCUS_NONE
	b.custom_minimum_size = Vector2(196, 210)
	b.disabled = not on
	b.tooltip_text = str(info["tip"]) + ("" if asked == 0 else " Asked %d time%s already." % [asked, "" if asked == 1 else "s"])
	b.pressed.connect(main.act.bind("trialq", "%s:%s" % [pid, q]))
	for st in ["normal", "hover", "pressed", "disabled", "focus"]:
		var hot: bool = str(st) == "hover"
		b.add_theme_stylebox_override(str(st), UI.box(Palette.alpha(Palette.TEXT, 0.04), Palette.alpha(Palette.ACCENT if hot else Palette.LINE, 1.0), 8, 2 if hot else 1, 0, 0))
	var v := UI.vbox(2)
	v.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var pic := Control.new()
	pic.custom_minimum_size = Vector2(0, 130)
	pic.clip_contents = true
	pic.mouse_filter = Control.MOUSE_FILTER_IGNORE
	pic.add_child(MenuFx.art(GYM))
	var path := SPRITE % [stem, str(info["pic"])]
	if not ResourceLoader.exists(path):
		path = SPRITE % ["mh_boxer_01", str(info["pic"])]
	if ResourceLoader.exists(path):   # a hub sprite sheet: 16 frames of 96 x 128 px; one frame of the move
		var s := TextureRect.new()
		s.name = "QPic"
		s.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		s.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		var at := AtlasTexture.new()
		at.atlas = load(path)
		at.region = Rect2(96 * FRAME, 0, 96, 128)
		s.texture = at
		s.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		s.mouse_filter = Control.MOUSE_FILTER_IGNORE
		pic.add_child(s)
	v.add_child(pic)
	var pad := MarginContainer.new()
	pad.mouse_filter = Control.MOUSE_FILTER_IGNORE
	for side in ["left", "right"]:
		pad.add_theme_constant_override("margin_" + side, 12)
	var t := UI.vbox(0)
	t.mouse_filter = Control.MOUSE_FILTER_IGNORE
	t.add_child(UI.label(str(info["name"]), 22, Palette.HEADER if on else Palette.MUTED, "bold"))
	t.add_child(UI.label(str(info["line"]) + ("" if asked == 0 else "  ·  again"), UI.SMALL, Palette.MUTED, "semi"))
	pad.add_child(t)
	v.add_child(pad)
	b.add_child(v)
	return b
