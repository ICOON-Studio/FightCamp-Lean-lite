extends Control
## S387 (operator: "when a bout is agreed ... the poster of the fight comes together like puzzle and assembles in the middle of the
## screen"): the moment after Accept. The bout's own poster (FightPoster) is drawn once off screen, cut into jigsaw pieces with real
## tabs, and the pieces fly in from all sides and lock together; then the finished poster lands with a thump and the camp button
## shows. A click skips to the end. Only with a picture: headless tests never open it (Main.show_poster).

const UI := preload("res://scripts/ui/UI.gd")
const FightPoster := preload("res://scripts/ui/FightPoster.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")

const COLS := 4
const ROWS := 6
const W := 420.0
const STAGGER := 0.04
const FLY := 0.62
const ARC_STEPS := 12

var ended := false
var _main: Node
var _fid := ""
var _size := Vector2.ZERO
var _tex: Texture2D
var _pieces: Array = []
var _board: Control
var _foot: Control


func build(main: Node, m: Dictionary) -> void:
	_main = main
	_fid = str(m["fid"])
	var c: Career = main.career
	var f := c.fighter_by_id(_fid)
	_size = Vector2(W, roundf(W * FightPoster.TALL))
	custom_minimum_size = _size + Vector2(0, 70)
	_board = Control.new()
	_board.name = "Board"
	_board.size = _size
	_board.pivot_offset = _size * 0.5
	add_child(_board)
	var sv := SubViewport.new()
	sv.size = Vector2i(_size)
	sv.render_target_update_mode = SubViewport.UPDATE_ONCE
	sv.add_child(FightPoster.build(c, f, W))
	add_child(sv)
	await RenderingServer.frame_post_draw
	await RenderingServer.frame_post_draw
	if not is_inside_tree():
		return
	_tex = ImageTexture.create_from_image(sv.get_texture().get_image())
	sv.queue_free()
	_cut(hash(_fid))


## The cut: every inner edge gets a tab pointing one way at random; both neighbours share that edge's path.
func _cut(seed_in: int) -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_in
	var pw := _size.x / COLS
	var ph := _size.y / ROWS
	var across: Array = []   # across[r][c]: the edge under row r
	var down: Array = []     # down[r][c]: the edge right of column c
	for r in ROWS:
		across.append([])
		down.append([])
		for k in COLS:
			(across[r] as Array).append(1.0 if rng.randf() < 0.5 else -1.0)
			(down[r] as Array).append(1.0 if rng.randf() < 0.5 else -1.0)
	var order: Array = range(COLS * ROWS)
	for i in range(order.size() - 1, 0, -1):
		var j := rng.randi_range(0, i)
		var t = order[i]
		order[i] = order[j]
		order[j] = t
	for n in order.size():
		var r: int = order[n] / COLS
		var k: int = order[n] % COLS
		var a := Vector2(k * pw, r * ph)
		var b := a + Vector2(pw, 0)
		var d := a + Vector2(pw, ph)
		var e := a + Vector2(0, ph)
		var pts := PackedVector2Array()
		pts.append_array(edge(a, b, Vector2(0, across[r - 1][k]) if r > 0 else Vector2.ZERO, minf(pw, ph)))
		pts.append_array(edge(b, d, Vector2(down[r][k], 0) if k < COLS - 1 else Vector2.ZERO, minf(pw, ph)))
		pts.append_array(edge(d, e, Vector2(0, across[r][k]) if r < ROWS - 1 else Vector2.ZERO, minf(pw, ph)))
		pts.append_array(edge(e, a, Vector2(down[r][k - 1], 0) if k > 0 else Vector2.ZERO, minf(pw, ph)))
		_fly(_piece(pts, (a + d) * 0.5), n, rng)
	var left := get_tree().create_timer(STAGGER * order.size() + FLY + 0.05)
	left.timeout.connect(finish)


## One edge from a to b, ending just before b. n is the side the tab points to (zero: a straight outer edge); the tab is a neck and a
## round head, as on a jigsaw. The path depends only on the edge, so two neighbours fit exactly.
static func edge(a: Vector2, b: Vector2, n: Vector2, cell: float) -> PackedVector2Array:
	var out := PackedVector2Array([a])
	if n == Vector2.ZERO:
		return out
	var along := (b - a).normalized()
	var mid := (a + b) * 0.5
	var rad := cell * 0.15
	var neck := rad * 0.62
	var rise := rad * 1.15
	out.append(mid - along * neck)
	for i in ARC_STEPS + 1:
		var ang := deg_to_rad(235.0 - 290.0 * float(i) / ARC_STEPS)
		out.append(mid + along * rad * cos(ang) + n * (rise + rad * sin(ang)))
	out.append(mid + along * neck)
	return out


func _piece(pts: PackedVector2Array, centre: Vector2) -> Node2D:
	var p := Polygon2D.new()
	var local := PackedVector2Array()
	for q in pts:
		local.append(q - centre)
	p.polygon = local
	p.uv = pts
	p.texture = _tex
	p.antialiased = true
	p.position = centre
	var line := Line2D.new()
	line.points = local
	line.closed = true
	line.width = 1.5
	line.default_color = Color(FightPoster.INK, 0.45)
	line.antialiased = true
	p.add_child(line)
	_board.add_child(p)
	_pieces.append(p)
	return p


func _fly(p: Node2D, n: int, rng: RandomNumberGenerator) -> void:
	var home := p.position
	var ang := rng.randf() * TAU
	p.position = home + Vector2.from_angle(ang) * rng.randf_range(620.0, 980.0)
	p.rotation = rng.randf_range(-1.6, 1.6)
	p.modulate.a = 0.0
	var t := p.create_tween().set_parallel()
	t.tween_property(p, "position", home, FLY).set_delay(STAGGER * n).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	t.tween_property(p, "rotation", 0.0, FLY).set_delay(STAGGER * n).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	t.tween_property(p, "modulate:a", 1.0, 0.12).set_delay(STAGGER * n)


## The pieces become the finished poster, it lands, and the buttons show.
func finish() -> void:
	if ended or _tex == null:
		return
	ended = true
	for p in _pieces:
		p.queue_free()
	_pieces.clear()
	var done := TextureRect.new()
	done.name = "Poster"
	done.texture = _tex
	done.size = _size
	done.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_board.add_child(done)
	var flash := ColorRect.new()
	flash.color = Color(1, 1, 1, 0.75)
	flash.size = _size
	flash.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_board.add_child(flash)
	_board.scale = Vector2(1.06, 1.06)
	var t := create_tween().set_parallel()
	t.tween_property(_board, "scale", Vector2.ONE, 0.28).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	t.tween_property(flash, "color:a", 0.0, 0.32)
	_add_foot()


func _add_foot() -> void:
	var c: Career = _main.career
	var f := c.fighter_by_id(_fid)
	_foot = PanelContainer.new()
	_foot.name = "PosterFoot"
	_foot.theme_type_variation = "Card"
	_foot.position = Vector2(0, _size.y + 12)
	_foot.custom_minimum_size = Vector2(_size.x, 0)
	var row := UI.hbox(10)
	_foot.add_child(row)
	var due := Bouts.camp_due(c, f)
	var go := UI.button("Set the camp" if due else "Continue", "BtnSolid", _leave.bind(due))
	go.name = "PosterDone"
	go.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(go)
	if due:
		var later := UI.button("Later", "Btn", _leave.bind(false))
		later.name = "PosterLater"
		row.add_child(later)
	add_child(_foot)


func _leave(to_camp: bool) -> void:
	_main.close_modal()
	if to_camp:
		_main.act("camp", _fid)


func _unhandled_input(event: InputEvent) -> void:
	if not ended and event is InputEventMouseButton and (event as InputEventMouseButton).pressed:
		finish()
		get_viewport().set_input_as_handled()
