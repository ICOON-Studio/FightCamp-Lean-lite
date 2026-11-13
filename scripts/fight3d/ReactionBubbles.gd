extends Control
## S442 BUBBLES (operator "All three", ops/research/LOOP_DRAWINGS_S442.md s2): reaction bubbles off OUR (red) corner post
## in a watched round - the shout and whether it went in, the coach's line after an exchange, the plan mark when a line fires
## and ends. Two at most (a third replaces the oldest), ~2 s each with a strip that runs down, faded in and out. Never over a
## head, glove or feet (a fixed set of slots by the post, checked against both boxers' projected bones); no free slot = not
## shown, the caption line keeps the words. ON by default, `nobubbles` = the control arm. FightView._fire -> take().
const UI := preload("res://scripts/ui/TV.gd")
const Icons := preload("res://scripts/ui/Icons.gd")
const ScoreBug := preload("res://scripts/fight3d/ScoreBug.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")

static var enabled := not OS.get_cmdline_user_args().has("nobubbles")
const MAX_ON := 2
const LIFE_S := 2.0     # real seconds on screen at full strength (2x and the shout bar's slow ring do not change it)
const FADE_S := 0.25
const EDGE := Color(1, 1, 1, 0.0)   # S443 his C327 "remove the wooden panel , make it transparent": no gold-brown frame (was #cdb68a)
const BG := Color(0.0, 0.0, 0.0, 0.42)   # S443 C327: see-through dark glass, not a wooden panel (was brown 0.94)
const TEXT_PX := 22
const GAP := 26.0       # bubble edge to the post
const POST_TOP := Vector3(-2.75, 1.45, -2.75)   # RingSet post 0 (red corner): (-RING_M / 2, 0, -RING_M / 2), 1.45 m tall
## Head, gloves and feet (MHRig names) and how far round each a bubble keeps off (metres, on the unscaled body).
const KEEP := {"Head": 0.2, "LeftHand": 0.17, "RightHand": 0.17, "LeftFoot": 0.16, "RightFoot": 0.16}
const SAFE_TOP := 215.0      # under the name plates (their guard row ends ~200) and the scoreboard
const SAFE_BOTTOM := 200.0   # over the bottom bar and the caption line
const ICON := {   # Lucide (ISC, assets/ui/icons/CREDITS.md): message-square, megaphone
"talk": '<path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/>',
	"mega": '<path d="m3 11 18-5v12L3 14v-3z"/><path d="M11.6 16.8a3 3 0 1 1-5.8-1.6"/>'}

var view: Control
var live: Array = []   # [{kind, node: Control, strip: ColorRect, w, left, rect}]
var keep: Array = []   # the last keep-out rects, one a boxer (tools/bubbles_play.gd prints them)

## FightView._fire: true when the beat became a bubble (its caption then stays off the line under the ring).
static func take(v: Control, b: Dictionary) -> bool:
	if not enabled or str(b.get("bubble", "")) == "" or v.get("stage") == null: return false
	var rb: Node = v.get_node_or_null("ReactionBubbles")
	if rb == null:
		rb = new()
		rb.name = "ReactionBubbles"
		rb.view = v
		v.add_child(rb)
	return rb.show_beat(b)

## The game's shout rule (Exchanges.uptake / ShoutBar.shout_note): the round's first FULL_SHOUTS go in whole, the rest at
## half; a fighter who stopped listening (CornerTrust.lands false) takes none.
static func heard_word(shouts_before: int, lands: bool) -> String:
	if not lands: return "Not heard"
	return "Heard" if shouts_before < Exchanges.FULL_SHOUTS else "Half heard"

## Tags one ExchangeBeats beat as a bubble of `kind` (shout / coach / plan / plan_end) with the words it shows.
static func mark(b: Dictionary, kind: String, x: Dictionary, ctx: Dictionary) -> Dictionary:
	var bub := {"icon": "", "pin": "", "pin_col": UI.FG, "tag": "", "tag_col": UI.FG, "text": "", "sub": "", "dot": Color(0, 0, 0, 0)}
	match kind:
		"shout":
			var call := str(x["call"]) if bool(x.get("shout", false)) else str(x.get("said", ""))
			bub["icon"] = "mega"
			bub["text"] = "\"%s\"" % str(Exchanges.CALLS.get(call, {}).get("shout", call))
			bub["tag"] = heard_word(int(x.get("shouts_before", 0)), bool(x.get("shout", false)))
			bub["tag_col"] = {"Heard": UI.GREEN, "Half heard": UI.AMBER}.get(bub["tag"], UI.MUTED)
		"coach":
			var won := bool(x.get("won", false))
			bub["icon"] = "talk"
			bub["text"] = str(x.get("verdict", ""))
			bub["sub"] = "Coach · exchange to %s" % ("your boxer" if won else "the opponent")   # S448: roles, never names
			bub["dot"] = ScoreBug.RED if won else ScoreBug.BLUE
		"plan", "plan_end":
			var pin := letter(((ctx.get("f", {}) as Dictionary).get("bout", {}) as Dictionary).get("arrows", []), str(x.get("arrow", "")))
			bub["pin"] = pin
			bub["tag"] = "Plan %s" % pin if pin != "" else "Plan"
			if kind == "plan":
				bub["text"] = "· " + str(StrikeMap.move(str(x["arrow"])).get("name", x["arrow"]))
			else:
				var tl: Array = x.get("plan_tally", [0, 0])
				bub["text"] = "· %s · %d of %d" % ["won it" if bool(x.get("won", false)) else "lost it", int(tl[0]), int(tl[1])]
				bub["pin_col"] = UI.GREEN if bool(x.get("won", false)) else Color("#e06060")
	b["bubble"] = "plan" if kind == "plan_end" else kind
	b["bub"] = bub
	return b

## The plan line's letter: its place on the coach's plan (A first).
static func letter(arrows: Array, id: String) -> String:
	for i in arrows.size():
		if str((arrows[i] as Dictionary).get("move", "")) == id: return "ABCDEFGH"[i] if i < 8 else ""
	return ""

static func text_of(b: Dictionary) -> String:
	var bub: Dictionary = b.get("bub", {})
	return " ".join([bub.get("tag", ""), bub.get("text", ""), bub.get("sub", "")]).strip_edges()

static func keep_rect(p: Vector2, r: float) -> Rect2:
	return Rect2(p - Vector2(r, r), Vector2(r, r) * 2.0)

## The first free slot beside the post (anchor) for a bubble of `bsz`, kept inside `safe`, off every `keeps` rect and
## every `taken` one. Rect2() = none.
static func pick_slot(anchor: Vector2, bsz: Vector2, keeps: Array, safe: Rect2, taken: Array) -> Rect2:
	var cands := [anchor + Vector2(-GAP - bsz.x, -bsz.y * 0.5),   # left of the post, level with its top
		anchor + Vector2(GAP, 150.0),                                # right of the post, low on it
		anchor + Vector2(-GAP - bsz.x, 150.0),                      # left, low
		anchor + Vector2(GAP, -GAP - bsz.y),                        # right, above
		anchor + Vector2(-bsz.x * 0.5, -GAP - bsz.y),              # straight above
		Vector2(anchor.x - GAP - bsz.x, safe.position.y), Vector2(anchor.x - GAP - bsz.x, safe.position.y + 120.0)]   # post off the left edge: stack down the top-left
	for p in cands:
		var at := Vector2(clampf(p.x, safe.position.x, safe.end.x - bsz.x), clampf(p.y, safe.position.y, safe.end.y - bsz.y))
		var r := Rect2(at, bsz)
		if not safe.encloses(r): continue
		if keeps.any(func(k): return r.intersects(k)) or taken.any(func(k): return r.grow(8.0).intersects(k)): continue
		return r
	return Rect2()

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func show_beat(b: Dictionary) -> bool:
	var cam: Camera3D = view.stage.get("camera")
	if cam == null or not view.is_visible_in_tree() or cam.is_position_behind(POST_TOP): return false
	var sc := view.size / Vector2(cam.get_viewport().get_visible_rect().size)
	var anchor := cam.unproject_position(POST_TOP) * sc
	keep = []
	for bx in view.stage.boxers:
		var skel: Skeleton3D = bx["skel"]
		var box := Rect2()
		for bone in KEEP:
			var i := skel.find_bone(str(bone))
			if i < 0: continue
			var p := skel.global_transform * skel.get_bone_global_pose(i).origin
			var c := cam.unproject_position(p) * sc
			var rad := maxf(24.0, (cam.unproject_position(p + cam.global_transform.basis.x * float(KEEP[bone])) * sc - c).length())
			box = keep_rect(c, rad) if box.size == Vector2.ZERO else box.merge(keep_rect(c, rad))
		keep.append(box)   # the whole span of the boxer's head, gloves and feet
	for n in ["BodyPanel0", "BodyPanel1"]:   # and the side holos (their numbers are read during the round)
		var holo: Control = view.find_child(n, true, false)
		if holo != null and holo.is_visible_in_tree():
			keep.append(holo.get_global_rect())
	var node := _build(b)
	add_child(node)
	var sz: Vector2 = (node.get_child(0) as Control).get_combined_minimum_size()
	var taken: Array = live.slice(1 if live.size() >= MAX_ON else 0).map(func(e): return e["rect"])
	var r := pick_slot(anchor, sz, keep, Rect2(16, SAFE_TOP, view.size.x - 32, view.size.y - SAFE_TOP - SAFE_BOTTOM), taken)
	node.queue_free()
	if r.size == Vector2.ZERO: return false
	add(b, r, anchor)
	return true

## Puts the bubble up at `r` with its tail toward `anchor`; the oldest goes when two are already up.
func add(b: Dictionary, r: Rect2, anchor: Vector2) -> Control:
	while live.size() >= MAX_ON:
		_drop(live.pop_front())
	var node := _build(b)
	node.position = r.position
	add_child(node)
	(node.get_child(0) as Control).size = r.size
	var strip := ColorRect.new()   # the life strip along the bottom edge
	strip.color = EDGE
	strip.set_position(Vector2(2, r.size.y - 6)); strip.set_size(Vector2(r.size.x - 4, 4))
	node.add_child(strip)
	var tail := Polygon2D.new()
	tail.color = EDGE
	var ty := clampf(anchor.y - r.position.y, 14.0, r.size.y - 14.0)
	var side := 1.0 if anchor.x >= r.end.x else (-1.0 if anchor.x <= r.position.x else 0.0)   # 0: the post is above or under
	var sx := r.size.x if side > 0.0 else 0.0
	tail.polygon = PackedVector2Array([Vector2(sx, ty - 12), Vector2(sx + 16.0 * side, ty), Vector2(sx, ty + 12)])
	node.add_child(tail)
	node.modulate.a = 0.0
	node.create_tween().set_ignore_time_scale(true).tween_property(node, "modulate:a", 1.0, FADE_S)
	live.append({"kind": str(b.get("bubble", "")), "node": node, "strip": strip, "w": r.size.x - 4, "left": LIFE_S, "rect": r})
	return node

func _process(delta: float) -> void:
	tick(delta / maxf(0.05, Engine.time_scale))

## Real seconds: each bubble's strip runs down; at its end it fades out.
func tick(dt: float) -> void:
	for e in live.duplicate():
		e["left"] = float(e["left"]) - dt
		(e["strip"] as ColorRect).size.x = float(e["w"]) * clampf(float(e["left"]) / LIFE_S, 0.0, 1.0)
		if float(e["left"]) <= 0.0:
			live.erase(e)
			_drop(e)

func _drop(e: Dictionary) -> void:
	var node: Control = e["node"]
	if is_instance_valid(node):
		node.create_tween().set_ignore_time_scale(true).tween_property(node, "modulate:a", 0.0, FADE_S).finished.connect(node.queue_free)

## The bubble: a dark panel with the gold-brown edge; icon or plan pin, the tag, the words, the coach's sub line.
func _build(b: Dictionary) -> Control:
	var bub: Dictionary = b["bub"]
	var holder := Control.new()
	var panel := PanelContainer.new()
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE   # the holder is 0 x 0; the panel is what covers the ring
	panel.add_theme_stylebox_override("panel", UI.box(BG, EDGE, 8, 2, 14, 10))
	holder.add_child(panel)
	var row := UI.hbox(10)
	panel.add_child(row)
	if str(bub["pin"]) != "":
		var pin := PanelContainer.new()
		pin.add_theme_stylebox_override("panel", UI.box(Color(0.07, 0.055, 0.047), bub["pin_col"], 5, 2, 8, 0))
		pin.add_child(UI.label(str(bub["pin"]), 26, UI.FG, "display"))
		pin.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		row.add_child(pin)
	elif str(bub["icon"]) != "":
		var ic := TextureRect.new()
		ic.texture = _icon(str(bub["icon"]))
		ic.modulate = Color("#cdb68a")   # the icon keeps the gold (the frame is gone, S443 C327)
		ic.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
		row.add_child(ic)
	var col := UI.vbox(4)
	row.add_child(col)
	var line := UI.hbox(8)
	col.add_child(line)
	if str(bub["pin"]) != "":
		line.add_child(UI.label(str(bub["tag"]), TEXT_PX, UI.FG, "bold"))
	line.add_child(UI.label(_wrap(str(bub["text"]), 340.0 if str(bub["sub"]) != "" else 420.0), TEXT_PX, UI.FG, "semi"))
	if str(bub["pin"]) == "" and str(bub["tag"]) != "":
		if bub["tag"] == "Heard":
			line.add_child(Icons.icon("check", 20, bub["tag_col"]))
		line.add_child(UI.label(str(bub["tag"]), TEXT_PX, bub["tag_col"], "bold"))
	if str(bub["sub"]) != "":
		var sub := UI.hbox(8)
		var dot := PanelContainer.new()   # a round dot in the corner's colour (UI.dot is square)
		dot.add_theme_stylebox_override("panel", UI.box(bub["dot"], Color(0, 0, 0, 0), 8, 0, 8, 8))
		dot.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		sub.add_child(dot)
		sub.add_child(UI.label(str(bub["sub"]), TEXT_PX, Color("#b8a88f"), "semi"))
		col.add_child(sub)
	_outline(holder)
	return holder

## See-through bubble (S443 C327): a dark outline keeps every word readable over the ring.
static func _outline(n: Node) -> void:
	for c in n.get_children():
		if c is Label:
			c.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.85))
			c.add_theme_constant_override("outline_size", 6)
		_outline(c)

## Line breaks at `width` px (a Label's own autowrap only knows its height after a layout pass; the slot needs it now).
static func _wrap(text: String, width: float) -> String:
	var f := UI.font("semi")
	var lines: Array = [""]
	for w in text.split(" "):
		var tryl := (str(lines[-1]) + " " + w).strip_edges()
		if str(lines[-1]) != "" and f.get_string_size(tryl, HORIZONTAL_ALIGNMENT_LEFT, -1, TEXT_PX).x > width: lines.append(w)
		else: lines[-1] = tryl
	return "\n".join(lines)

static func _icon(name: String) -> Texture2D:
	var img := Image.new()
	img.load_svg_from_string('<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#ffffff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">%s</svg>' % ICON[name], 28.0 / 24.0)
	return ImageTexture.create_from_image(img)
