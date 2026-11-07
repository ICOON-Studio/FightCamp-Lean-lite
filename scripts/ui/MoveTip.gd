extends PanelContainer
## S382 MOVETIP1 (operator, a skill-tree hover card in a game he plays: "this is a nice presentation for a skill it plays
## the animation"). ONE shared hover card for every move card: hover a move ~0.25 s and the card opens beside it - the
## move's ink icon, its name, her tier with it (raw / usable / sharp / signature, MoveMastery) and its gas as pips; the
## move played LIVE on a loop on her own body in a plain light studio (boxing: MovePlayer; BJJ: MatPlayer, GrappleMap on
## two bodies); the chain as glyphs; what it starts from and leads into (ComboFlow's own joins); at most two functional
## lines. Leave and it hides. One instance on its own CanvasLayer, one 3D viewport in it (rebuilt only when the fighter
## changes), in its OWN World3D; the viewport renders only while the card is shown and its bodies hide with it.
## Round 2, the operator's capture of the reference card (tmp/s382/rec/NOTES.md):
##   - the partner is solid and reacts (MoveStudio: slips / blocks the jab, takes the cross, folds on a body shot); the
##     camera ~35 deg above at 3/4 on an off-white floor with soft shadows;
##   - while a clip loads, the box shows the move's ink card, then cross-fades to the clip (never a black or empty box);
##   - a move with no clip (a defence or a step without one) gets a COMPACT card: no clip box, the height of its content;
##   - no delay beyond the hover intent: the card opens at once with the ink card; the player is warmed while the page
##     is idle (warm), else built the frame after the card shows.
##   MoveTip.attach(control, move_id, fighter)   - the whole wiring. move_id = a StrikeMap move ("1-2", "pivot_out"),
##       a ComboFlow move ("jab", "lead_hook"), a Data move name ("Lead hook"), a book combination ("1-2-3") or a
##       syllabus move ("kimura"). The training drill cards (claude/training1) attach the same way.
##   MoveTip.info(move_id, fighter) -> Dictionary   what the card says (pure, for tests)   MoveTip.inst() -> the card

const UI := preload("res://scripts/ui/UI.gd")
const Icons := preload("res://scripts/ui/Icons.gd")
const MovePlayer := preload("res://scripts/fight3d/MovePlayer.gd")
const MatPlayer := preload("res://scripts/ui/MatPlayer.gd")
const Faces := preload("res://scripts/rules/Faces.gd")
const BjjFilm := preload("res://scripts/rules/BjjFilm.gd")
const Info := preload("res://scripts/ui/MoveTipInfo.gd")
const PICS := "res://assets/ui/moves/%s.png"

const DELAY_S := 0.25
const W := 440.0
const CLIP := Vector2(408, 300)
const GAP := 12.0
const YAW_DEG := 15.0   # turned a little toward her front, his face still in view (MoveStudio adds ~35 deg from above)
const FADE_S := 0.25         # the ink card's cross-fade to the clip
const READY_FRAMES := 3      # frames the clip draws under the ink card before the cross-fade (its first pose settled)
const WARM_IDLE_FRAMES := 20 # the page has been still this long before the card warms its player
const TIER_COLOR := {"unlearned": UI.MUTED, "new": UI.MUTED, "raw": UI.AMBER, "usable": UI.GREEN, "sharp": UI.GOLD, "signature": UI.PURPLE,
	"locked": UI.MUTED, "ready": UI.GREEN, "learning": UI.MUTED, "felt": UI.AMBER, "owned": UI.GREEN}

static var _inst: Control = null

var _target: Control = null
var _want := {}          # {id, f} waiting out DELAY_S
var _wait := -1.0
var shown := ""          # the move on the card now
var player: Control = null   # MovePlayer or MatPlayer - one at a time
var _player_key := ""
var _clip_box: PanelContainer
var _cover: PanelContainer   # the ink card over the clip until it is ready
var _ink: TextureRect
var _pending := {}           # {d, f}: the clip to start the frame after the card shows
var _ready_in := -1          # frames left before the cross-fade
var _fade: Tween
var _warm := {}              # {sport, f}: a player to build while the page is idle
var _idle := 0
var _icon: TextureRect
var _name: Label
var _tier: Label
var _gas: HBoxContainer
var _chain: HFlowContainer
var _links: VBoxContainer
var _lines: VBoxContainer


## Hover `c` and the card opens beside it for `id`, `f`'s own move; leave and it hides.
static func attach(c: Control, id: String, f: Dictionary) -> void:
	if c == null or id == "":
		return
	if c.mouse_filter == Control.MOUSE_FILTER_IGNORE:
		c.mouse_filter = Control.MOUSE_FILTER_PASS
	c.tooltip_text = ""   # the card replaces the plain tooltip
	c.set_meta("move_tip", id)
	inst().warm(id, f)
	c.mouse_entered.connect(func(): inst().hover(c, id, f))
	c.mouse_exited.connect(func():
		if is_instance_valid(_inst):
			_inst.leave(c))


## The one card, made on first use on its own CanvasLayer over everything.
static func inst() -> Control:
	if is_instance_valid(_inst):
		return _inst
	var tree := Engine.get_main_loop() as SceneTree
	var layer := CanvasLayer.new()
	layer.name = "MoveTipLayer"
	layer.layer = 90
	tree.root.add_child(layer)
	_inst = new()
	_inst.name = "MoveTip"
	layer.add_child(_inst)
	return _inst


func _ready() -> void:
	visible = false
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	custom_minimum_size = Vector2(W, 0)
	var sb := UI.box(UI.PANEL, UI.FG, 10, 2, 14, 12)
	sb.shadow_color = Color(0, 0, 0, 0.22)
	sb.shadow_size = 10
	sb.shadow_offset = Vector2(0, 4)
	add_theme_stylebox_override("panel", sb)
	var v := UI.vbox(8)
	add_child(v)
	var top := UI.hbox(10)
	_icon = TextureRect.new()
	_icon.custom_minimum_size = Vector2(56, 56)
	_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	top.add_child(_icon)
	var nv := UI.vbox(0)
	nv.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_name = UI.label("", 26, UI.FG, "display")
	_name.name = "TipName"
	nv.add_child(_name)
	_tier = UI.label("", UI.SMALL, UI.MUTED, "bold")
	_tier.name = "TipTier"
	nv.add_child(_tier)
	top.add_child(nv)
	_gas = UI.hbox(4)
	_gas.name = "TipGas"
	top.add_child(_gas)
	v.add_child(top)
	_clip_box = PanelContainer.new()
	_clip_box.name = "TipClip"
	_clip_box.custom_minimum_size = CLIP
	_clip_box.add_theme_stylebox_override("panel", UI.box(MovePlayer.STUDIO_BG, UI.LINE, 6, 1, 0, 0))
	_cover = PanelContainer.new()
	_cover.name = "TipCover"
	_cover.add_theme_stylebox_override("panel", UI.box(MovePlayer.STUDIO_BG, UI.LINE, 6, 1, 8, 8))
	_ink = TextureRect.new()
	_ink.name = "TipInk"
	_ink.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_ink.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_cover.add_child(_ink)
	_clip_box.add_child(_cover)
	v.add_child(_clip_box)
	_chain = HFlowContainer.new()
	_chain.name = "TipChain"
	_chain.add_theme_constant_override("h_separation", 6)
	_chain.add_theme_constant_override("v_separation", 4)
	v.add_child(_chain)
	v.add_child(UI.sep())
	_links = UI.vbox(4)
	_links.name = "TipLinks"
	v.add_child(_links)
	_lines = UI.vbox(2)
	_lines.name = "TipLines"
	v.add_child(_lines)
	_set_player_on(false)


func hover(c: Control, id: String, f: Dictionary) -> void:
	_target = c
	_want = {"id": id, "f": f}
	# Already open on another card: the new move takes its place at once (the eye is already on the card).
	_wait = 0.0 if visible else DELAY_S


func leave(c: Control) -> void:
	if c != _target:
		return
	_target = null
	_want = {}
	_wait = -1.0
	hide_tip()


func hide_tip() -> void:
	visible = false
	shown = ""
	_pending = {}
	_ready_in = -1
	if _fade != null:
		_fade.kill()
	_cover.modulate.a = 1.0
	_set_player_on(false)


## A page attached a card for `id`: the player that card would need is built while the page is idle, so the first hover
## opens without building two bodies.
func warm(id: String, f: Dictionary) -> void:
	_warm = {"sport": Info.sport(id, f), "f": f}
	_idle = 0


func _process(delta: float) -> void:
	_tick_clip()
	if not visible and _wait < 0.0 and not _warm.is_empty():
		_idle += 1
		if _idle >= WARM_IDLE_FRAMES:
			_ensure_player(str(_warm["sport"]), _warm["f"])
			_warm = {}
			_set_player_on(false)
	if _wait >= 0.0:
		_wait -= delta
		if _wait <= 0.0:
			_wait = -1.0
			if is_instance_valid(_target) and _target.is_visible_in_tree() and not _want.is_empty():
				_show(str(_want["id"]), _want["f"])
	elif visible and not (is_instance_valid(_target) and _target.is_visible_in_tree()):
		hide_tip()   # the card it belongs to was re-rendered away or hidden
	elif visible:
		reset_size()
		_place()   # the flows settle a frame late; the card follows a scrolled list


func _show(id: String, f: Dictionary) -> void:
	var d := info(id, f)
	shown = id
	_name.text = str(d["name"])
	_tier.text = str(d["tier"])
	_tier.add_theme_color_override("font_color", TIER_COLOR.get(str(d["tier"]), UI.MUTED))
	_icon.texture = _pic(d)
	_fill_gas(float(d["gas"]))
	_fill_chain(d["glyphs"])
	_fill_links(d)
	UI.clear(_lines)
	for l in d["lines"]:
		var lab := UI.label(str(l), UI.SMALL, UI.FG, "body", true)
		lab.custom_minimum_size.x = W - 28.0   # a wrapped line needs its width, or it measures one word a line
		_lines.add_child(lab)
	# The clip box shows the move's ink card at once; the clip starts the next frame (a cold player builds then, with the
	# card already up) and cross-fades in once it has drawn (_tick_clip). No clip: the compact card.
	var clip := _has_clip(d)
	_clip_box.visible = clip
	_ink.texture = _pic(d, true)
	if _fade != null:
		_fade.kill()
	_cover.modulate.a = 1.0
	_ready_in = -1
	_pending = {"d": d, "f": f} if clip else {}
	if not clip:
		_set_player_on(false)
	for n in find_children("*", "Control", true, false):
		(n as Control).mouse_filter = Control.MOUSE_FILTER_IGNORE   # the card never takes the hover from the cards under it
	visible = true
	reset_size()
	_place()


static func _has_clip(d: Dictionary) -> bool:
	if str(d["sport"]) == "bjj":   # S384 a tree move with an exact film plays it too (MatPlayer.tree_film)
		return not BjjFilm.film(str(d["id"])).is_empty() or MatPlayer.tree_film(str(d["id"])) >= 0
	return not (d["clips"] as Array).is_empty()


## The frame after the card shows: start its clip; then READY_FRAMES drawn under the ink card; then the cross-fade.
func _tick_clip() -> void:
	if not visible:
		return
	if not _pending.is_empty():
		var d: Dictionary = _pending["d"]
		var f: Dictionary = _pending["f"]
		_pending = {}
		if _play(d, f):
			_ready_in = READY_FRAMES
		else:
			_clip_box.visible = false   # GrappleMap had no film after all: the compact card
	elif _ready_in > 0:
		_ready_in -= 1
		if _ready_in == 0:
			_ready_in = -1
			_fade = create_tween()
			_fade.tween_property(_cover, "modulate:a", 0.0, FADE_S)


## The live clip: true when it plays.
func _play(d: Dictionary, f: Dictionary) -> bool:
	_ensure_player(str(d["sport"]), f)
	_set_player_on(true)
	if str(d["sport"]) == "bjj":
		return bool(player.play_move(str(d["id"])))
	if str(d["sm"]) != "":
		player.show_move(str(d["sm"]))
	else:
		player.show_chain(d["clips"])
	return true


## The one player for this sport and pair of bodies (built once; another fighter or sport replaces it).
func _ensure_player(sport: String, f: Dictionary) -> void:
	var stems: Array = Faces.pair(f, Faces.partner(f))
	var key := "%s|%s|%s" % [sport, stems[0], stems[1]]
	if key == _player_key and is_instance_valid(player):
		return
	if is_instance_valid(player):
		player.queue_free()   # one viewport: the old bodies go before the new ones come
		_clip_box.remove_child(player)
	var bjj := sport == "bjj"
	player = MatPlayer.new() if bjj else MovePlayer.new()
	player.name = "TipPlayer"
	player.bodies = [Faces.glb(str(stems[0])), Faces.glb(str(stems[1]))]
	player.studio = true
	if not bjj:
		player.yaw_deg = YAW_DEG
	player.custom_minimum_size = CLIP
	_clip_box.add_child(player)
	_clip_box.move_child(_cover, -1)   # the ink card stays over the clip
	_player_key = key


## The viewport draws and the player ticks only while the card is shown.
func _set_player_on(on: bool) -> void:
	if not is_instance_valid(player):
		return
	player.visible = on
	player.process_mode = Node.PROCESS_MODE_INHERIT if on else Node.PROCESS_MODE_DISABLED
	if not on and player.has_method("stop"):
		player.stop()
	for vp in player.find_children("*", "SubViewport", true, false):
		(vp as SubViewport).render_target_update_mode = SubViewport.UPDATE_WHEN_VISIBLE if on else SubViewport.UPDATE_DISABLED
		for n in vp.get_children():
			if n is Node3D:
				(n as Node3D).visible = on   # S382 its bodies hide with the card (its own world, but never left showing)


## Beside the card it belongs to (right, else left), kept inside the screen.
func _place() -> void:
	if not is_instance_valid(_target):
		return
	var r := _target.get_global_rect()
	var screen := get_viewport().get_visible_rect().size
	var s := get_combined_minimum_size()
	var x := r.end.x + GAP
	var y := r.position.y
	if x + s.x > screen.x - 8.0:
		x = r.position.x - GAP - s.x
		if x < 8.0:   # S382 a row as wide as its card (a move bar): over its right end, above it (else below)
			x = r.end.x - s.x
			y = r.position.y - GAP - s.y if r.position.y - GAP - s.y >= 8.0 else r.end.y + GAP
	x = clampf(x, 8.0, maxf(8.0, screen.x - s.x - 8.0))
	y = clampf(y, 8.0, maxf(8.0, screen.y - s.y - 8.0))
	position = Vector2(x, y)


func _fill_gas(pct: float) -> void:
	UI.clear(_gas)
	if pct <= 0.0:
		return
	var v := UI.vbox(2)
	var pips := UI.hbox(3)
	var n := clampi(roundi(pct), 1, 5)
	for i in 5:
		pips.add_child(UI.dot(UI.AMBER if i < n else UI.LINE))
	v.add_child(pips)
	v.add_child(UI.label("gas %.1f%%" % pct, UI.TINY, UI.MUTED, "bold"))
	_gas.add_child(v)


## The chain as glyphs: [fist] Jab > [fist] Cross > [feet] Step in.
func _fill_chain(glyphs: Array) -> void:
	UI.clear(_chain)
	for i in glyphs.size():
		if i > 0:
			_chain.add_child(UI.label(">", UI.SMALL, UI.MUTED, "bold"))
		var g := UI.hbox(3)
		g.add_child(Icons.icon(str(glyphs[i][0]), 16, UI.FG))
		g.add_child(UI.label(str(glyphs[i][1]), UI.SMALL, UI.FG, "semi"))
		_chain.add_child(g)


func _fill_links(d: Dictionary) -> void:
	UI.clear(_links)
	for row in [["Starts from", d["starts"]], ["Leads into", d["leads"]]]:
		if (row[1] as Array).is_empty():
			continue
		var h := HFlowContainer.new()
		h.add_theme_constant_override("h_separation", 6)
		h.add_child(UI.label(str(row[0]) + ":", UI.SMALL, UI.MUTED, "semi"))
		var names: Array = row[1]
		for i in names.size():
			h.add_child(UI.label(str(names[i]) + ("," if i < names.size() - 1 else ""), UI.SMALL, UI.GOLD, "bold"))
		_links.add_child(h)


## The move's ink card (assets/ui/moves, MOVEPICS1); without one, its kind's glyph.
static func _pic(d: Dictionary, big := false) -> Texture2D:
	var path := PICS % str(d["pic"]).replace(" ", "_").replace("@", "_at_")
	if ResourceLoader.exists(path):
		return load(path)
	if FileAccess.file_exists(path):   # baked but not imported yet
		var img := Image.load_from_file(ProjectSettings.globalize_path(path))
		if img != null:
			return ImageTexture.create_from_image(img)
	return Icons.texture(str(d["glyph"]), 96 if big else 48)


## What the card says (pure, for tests): MoveTipInfo.
static func info(id: String, f: Dictionary) -> Dictionary:
	return Info.info(id, f)
