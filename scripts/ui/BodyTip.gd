extends Control
## S348 (operator C199 on the fight's body view: "the holo need to link to tooltips when mouse over head or liver to show
## stats like damage taken etc"): what one place on her body has taken this bout - the punches landed there by kind, the
## big ones, the last one and its round, how hurt it is and whether it is cut - shown as a HUD-styled tooltip, and the place
## under the mouse ringed on her body so the player sees what he is reading.
##   log_hit(log, place, move, big, round_n)   text(place, value, entry, head_value, cut, closed) -> String
##   panel(text) -> Control (the tooltip)   attach(figure) -> BodyTip (the hover ring)

const BM := preload("res://scripts/rules/BodyMap.gd")
const UI := preload("res://scripts/ui/TV.gd")   # fight graphics keep the dark TV look

## Her right side holds the liver (a lead hook to the body from an orthodox boxer lands there).
const NAMES := {"head": "Head", "left_eye": "Left eye", "right_eye": "Right eye", "nose": "Nose",
	"left_ribs": "Left ribs", "right_ribs": "Liver (right ribs)"}
const BAND_WORDS := {"fine": "fine", "hurt": "hurt", "critical": "badly hurt", "doctor": "the doctor may stop it"}
const BAND_COLOURS := {"fine": Color("#6cc27a"), "hurt": Color("#f0a020"), "critical": Color("#e0503c"),
	"doctor": Color("#a050e0")}
const MOVE_WORDS := {"jab": ["jab", "jabs"], "cross": ["cross", "crosses"], "lead_hook": ["lead hook", "lead hooks"],
	"body_hook": ["body hook", "body hooks"], "rear_uppercut": ["uppercut", "uppercuts"]}

var fig: Control
var hover := ""


## One landed punch on `place` into the bout's log {place: {n, kinds: {move: n}, big, last, round}}.
static func log_hit(log: Dictionary, place: String, move: String, big: bool, round_n: int) -> void:
	var e: Dictionary = log.get(place, {"n": 0, "kinds": {}, "big": 0, "last": "", "round": 0})
	e["n"] = int(e["n"]) + 1
	e["kinds"][move] = int((e["kinds"] as Dictionary).get(move, 0)) + 1
	if big:
		e["big"] = int(e["big"]) + 1
	e["last"] = move
	e["round"] = round_n
	log[place] = e


## The tooltip's words. Line 1 "<Place>: <band> (<value>/100)"; then what landed there; a face place adds the head.
static func text(place: String, value: float, entry: Dictionary, head_value: float = -1.0, cut: bool = false,
		closed: bool = false) -> String:
	var b: String = BM.band(value)
	var lines: PackedStringArray = ["%s: %s (%d/100)" % [NAMES.get(place, place), BAND_WORDS[b], int(round(value))]]
	var n := int(entry.get("n", 0))
	if n == 0:
		lines.append("Nothing landed here yet")
	else:
		var kinds: Dictionary = entry.get("kinds", {})
		var parts: PackedStringArray = []
		for m in BM.PUNCHES:
			var k := int(kinds.get(m, 0))
			if k > 0:
				parts.append("%d %s" % [k, MOVE_WORDS[m][0 if k == 1 else 1]])
		lines.append("Took %d: %s" % [n, ", ".join(parts)])
		var big := int(entry.get("big", 0))
		var last := "Last: %s, round %d" % [MOVE_WORDS.get(str(entry.get("last", "")), [str(entry.get("last", ""))])[0],
			int(entry.get("round", 0))]
		lines.append(("%d big shot%s - " % [big, "" if big == 1 else "s"] if big > 0 else "") + last)
	if cut:
		lines.append("Cut - closed by the cutman" if closed else "Cut open - punches here do more damage")
	if head_value >= 0.0 and place in BM.FACE_PLACES:
		lines.append("Head: %s (%d/100)" % [BAND_WORDS[BM.band(head_value)], int(round(head_value))])
	return "\n".join(lines)


## The tooltip in the HUD's look: faint dark glass, the first line as a title (its band word in the band colour).
static func panel(t: String) -> Control:
	var p := PanelContainer.new()
	p.add_theme_stylebox_override("panel", UI.box(Color(0.06, 0.05, 0.05, 0.86), Color(1, 1, 1, 0.10), 8, 1, 12, 8))
	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 2)
	p.add_child(col)
	var lines := t.split("\n")
	for i in lines.size():
		var line := str(lines[i])
		if i == 0 and line.contains(": "):
			var row := HBoxContainer.new()
			row.add_theme_constant_override("separation", 6)
			var head := line.split(": ", true, 1)
			row.add_child(UI.label(str(head[0]).to_upper(), UI.SMALL, UI.FG, "bold"))
			row.add_child(UI.label(str(head[1]), UI.SMALL, _band_colour(str(head[1]))))
			col.add_child(row)
		elif i == 0:
			col.add_child(UI.label(line, UI.SMALL, UI.FG, "bold"))
		else:
			col.add_child(UI.label(line, UI.TINY, UI.MUTED if line == "" else UI.FG, "mono" if line.begins_with("LANDED")
				or line.begins_with("JABS") or line.begins_with("POWER") or line.begins_with("BODY") else "body"))
	return p


static func _band_colour(words: String) -> Color:
	for b in ["doctor", "critical", "hurt", "fine"]:
		if words.begins_with(BAND_WORDS[b]):
			return BAND_COLOURS[b]
	return UI.FG


## The hover ring: a child drawn over her body; follows the place under the mouse, clears when the mouse leaves.
static func attach(f: Control) -> Control:
	var t := new()
	t.name = "BodyTip"
	t.fig = f
	t.mouse_filter = MOUSE_FILTER_IGNORE
	t.set_anchors_and_offsets_preset(PRESET_FULL_RECT)
	f.add_child(t)
	f.gui_input.connect(t._on_input)
	f.mouse_exited.connect(t.set_hover.bind(""))
	return t


func _on_input(e: InputEvent) -> void:
	if e is InputEventMouseMotion:
		set_hover(str(fig.call("place_at", (e as InputEventMouseMotion).position)))


func set_hover(place: String) -> void:
	if place != hover:
		hover = place
		queue_redraw()


func _draw() -> void:
	if hover == "":
		return
	var g: Dictionary = fig.call("_geom_px", hover)
	var pts: PackedVector2Array = fig.call("_ellipse_pts", g["c"], float(g["rx"]) * 1.15, float(g["ry"]) * 1.15)
	draw_polyline(pts, Color(0, 0, 0, 0.55), 4.0, true)
	draw_polyline(pts, Color(1, 1, 1, 0.95), 2.0, true)
