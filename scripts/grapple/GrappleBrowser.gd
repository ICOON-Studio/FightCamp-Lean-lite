extends Control
## S335 the ground-move browser (operator: "a nice menu with in&outs like in the website for each position"): GrappleMap
## played on two of our women. A position shows its moves IN and moves OUT; a move plays and lands on its position, the
## next move laid on the pose on screen (GrappleGraph.align), so a player can walk the graph move by move. Tabs are the
## families (guard, mount, back ...), a search box finds a position by name. A prototype outside the boxing game (MMA
## update, operator Q-S294-58 "Build the prototype now"); open with `FightCamp.exe -- jump=grapple`.

const UI := preload("res://scripts/ui/UI.gd")
const DB := preload("res://scripts/grapple/GrappleMapDB.gd")
const Graph := preload("res://scripts/grapple/GrappleGraph.gd")
const Pose := preload("res://scripts/grapple/GrapplePose.gd")
const Player := preload("res://scripts/grapple/GrapplePlayer.gd")
const Grip := preload("res://scripts/grapple/GrappleGrip.gd")
const MH := preload("res://scripts/fight3d/MHRig.gd")
const Kit := preload("res://scripts/fight3d/FighterKit.gd")
## S335 operator: "use different colours on the clothes for each" - one colour head to toe per woman (top a shade lighter).
const TOPS := [Color("#ff6a5c"), Color("#5b93ff")]
const BODIES := ["res://assets/models/metahuman/mh_boxer_11.glb", "res://assets/models/metahuman/mh_boxer_10.glb"]
const TRUNKS := [Color("#e2483d"), Color("#2f6fdb")]
## S336 MMA kit: the boxing trunks' white waistband and piping (MH_Trim) showed as a white tear between top and shorts on
## the ground; MMA shorts and a sports top are one corner colour, the trim a dark shade of it.
const TRIM_DARKEN := 0.45
const START := "mount"
const ORBIT_DEG_S := 6.0
const PANEL_W := 470

var db: Array = []
var graph: RefCounted
var player: Node
var cam: Camera3D
var current := -1          # the position on screen (a GrappleMap sequence index)
var moving: Dictionary = {}  # the move playing ({} = holding a position)
var _yaw := 35.0
var _look := Vector3(0, 0.4, 0)
var _side: VBoxContainer
var _list: VBoxContainer
var _search: LineEdit
## `-- walk=N`: the browser walks the graph by itself (N moves, a pause on each position, then quits) - the film tool.
var _walk := 0
var _hold := 0.0
var _rng := RandomNumberGenerator.new()
var _walking := false
var _seen := {}


func _ready() -> void:
	theme = UI.theme()
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	db = DB.load_db()
	graph = Graph.new()
	var bg := ColorRect.new()
	bg.color = UI.BG
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(bg)
	var rows := UI.vbox(0)
	rows.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(rows)
	rows.add_child(_top_bar())
	var body := UI.hbox(0)
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	rows.add_child(body)
	var view := _viewport()
	body.add_child(view)
	body.add_child(_panel())
	_cast(view.get_child(0).get_child(0))
	_family("mount")
	go_position(db.find(DB.find(db, START)))
	for a in OS.get_cmdline_user_args():
		if a.begins_with("walk="):
			_walk = int(a.substr(5))
			_walking = true
			_rng.seed = 335


## The walk's next move: one out of here that lands on a position with moves of its own, a new place first; at a dead
## end it jumps to a well-linked position of the current family.
func _walk_step(delta: float) -> void:
	if not moving.is_empty():
		return
	_hold += delta
	if _hold < 1.2:
		return
	_hold = 0.0
	if _walk <= 0:
		get_tree().quit()
		return
	_seen[current] = true
	var outs: Array = graph.outs(current).filter(func(m): return Graph.lands(m) != null and not graph.outs(int(Graph.lands(m))).is_empty())
	var fresh := outs.filter(func(m): return not _seen.has(int(Graph.lands(m))))
	if not fresh.is_empty():
		outs = fresh
	_walk -= 1
	if outs.is_empty():
		var hubs: Array = graph.family(str(Graph.FAMILIES[_rng.randi() % Graph.FAMILIES.size()][1])).slice(0, 5)
		go_position(int(hubs[_rng.randi() % hubs.size()]["id"]))
		return
	play_out(outs[_rng.randi() % outs.size()])


## ---------- the 3D view ----------

func _viewport() -> Control:
	var box := SubViewportContainer.new()
	box.stretch = true
	box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	box.size_flags_vertical = Control.SIZE_EXPAND_FILL
	var vp := SubViewport.new()
	vp.msaa_3d = Viewport.MSAA_4X
	box.add_child(vp)
	var world := Node3D.new()
	vp.add_child(world)
	_room(world)
	return box


## The two women and the player, once the view is in the tree (the leg lengths read world transforms).
func _cast(world: Node3D) -> void:
	var poses: Array = []
	var legs: Array = []
	var skels: Array = []
	for i in 2:
		var b := MH.load_fighter(BODIES[i])
		world.add_child(b)
		MH.colour_trunks(b, TRUNKS[i])
		Kit.colour_vest(b, TOPS[i], 0.8)
		_mma_trim(b, TRUNKS[i].darkened(TRIM_DARKEN))
		var skel := b.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
		skels.append(skel)
		poses.append(Pose.attach(skel))
		var sw := skel.global_transform
		legs.append((sw * skel.get_bone_global_rest(skel.find_bone("LeftUpperLeg")).origin).distance_to(
			sw * skel.get_bone_global_rest(skel.find_bone("LeftFoot")).origin))
	player = Player.new()
	world.add_child(player)
	player.men = poses
	player.scale = Player.pair_scale(legs)
	for i in 2:
		Grip.attach(skels[i], poses[i], poses[1 - i])


## The MMA kit's trim (waistband, piping) in the corner's dark shade instead of the boxing white.
static func _mma_trim(body: Node3D, colour: Color) -> void:
	for m in body.find_children("*", "MeshInstance3D", true, false):
		var mi := m as MeshInstance3D
		for s in mi.mesh.get_surface_count():
			var src := mi.mesh.surface_get_material(s)
			if src != null and src.resource_name.begins_with("MH_Trim"):
				var trim := StandardMaterial3D.new()
				trim.albedo_color = colour
				trim.roughness = 0.8
				mi.set_surface_override_material(s, trim)


func _room(world: Node3D) -> void:
	var env := WorldEnvironment.new()
	var e := Environment.new()
	e.background_mode = Environment.BG_COLOR
	e.background_color = Color("#dfe7ec")
	e.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	e.ambient_light_color = Color(0.9, 0.9, 0.92)
	e.ambient_light_energy = 0.6
	e.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	env.environment = e
	world.add_child(env)
	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-55, 35, 0)
	sun.light_energy = 1.3
	sun.shadow_enabled = true
	world.add_child(sun)
	var mat := MeshInstance3D.new()
	var plane := PlaneMesh.new()
	plane.size = Vector2(10, 10)
	mat.mesh = plane
	var m := StandardMaterial3D.new()
	m.albedo_color = Color("#9da3a8")  # neutral grey: red, blue and skin all read on it (operator S335: blue fighter on a blue mat)
	m.roughness = 0.9
	mat.material_override = m
	world.add_child(mat)
	cam = Camera3D.new()
	cam.fov = 38.0
	world.add_child(cam)
	cam.current = true


func _process(delta: float) -> void:
	if player == null or player.seq.is_empty():
		return
	if _walking:
		_walk_step(delta)
	_yaw += ORBIT_DEG_S * delta
	var js: Array = player.joints_at(player.t())
	var lo := Vector3.INF
	var hi := -Vector3.INF
	for p in js:
		for v in (p as PackedVector3Array):
			lo = lo.min(v)
			hi = hi.max(v)
	_look = _look.lerp((lo + hi) * 0.5, minf(1.0, delta * 3.0))
	var r := maxf((hi - lo).length() * 0.5, 0.9)
	var dist := r / tan(deg_to_rad(cam.fov * 0.5)) * 1.1
	cam.position = _look + Basis(Vector3.UP, deg_to_rad(_yaw)) * Vector3(0, 0.42, 0.9).normalized() * dist
	cam.look_at(_look, Vector3.UP)
	if not moving.is_empty() and player.done():
		var to: Variant = Graph.lands(moving)
		moving = {}
		if to != null:
			current = int(to)
		_refresh()


## ---------- moving through the graph ----------

## Show a position, laid on the pose on screen when there is one (same position = no jump).
func go_position(id: int) -> void:
	if id < 0:
		return
	var frames: Array = db[id]["frames"]
	if player.seq.is_empty():
		player.play(db[id], player.men, player.scale, Transform3D.IDENTITY)
	else:
		player.play_frames(Graph.placed(frames, Graph.align(player.shown_frame(), frames[0])))
	current = id
	moving = {}
	_refresh()


## Play a move OUT of the position on screen (laid on it), then hold where it lands.
func play_out(move: Dictionary) -> void:
	var frames: Array = db[int(move["t"]["id"])]["frames"]
	var rev := bool(move["reverse"])
	var first: Array = frames.back() if rev else frames[0]
	player.play_frames(Graph.placed(frames, Graph.align(player.shown_frame(), first), rev))
	moving = move
	_refresh()


## Play a move IN: it starts at its own position and ends on the one on screen.
func play_in(move: Dictionary) -> void:
	var frames: Array = db[int(move["t"]["id"])]["frames"]
	var rev := bool(move["reverse"])
	var last: Array = frames[0] if rev else frames.back()
	player.play_frames(Graph.placed(frames, Graph.align(player.shown_frame(), last), rev))
	moving = {"t": move["t"], "reverse": rev, "into": current}
	_refresh()


## ---------- the panels ----------

func _top_bar() -> Control:
	var bar := PanelContainer.new()
	bar.add_theme_stylebox_override("panel", UI.box(UI.PANEL, UI.LINE, 0, 1, 18, 10))
	var h := UI.hbox(6)
	bar.add_child(h)
	h.add_child(UI.label("GROUND MOVES", 22, UI.FG, "bold"))
	h.add_child(UI.muted("  prototype  "))
	for f in Graph.FAMILIES:
		var tag := str(f[1])
		h.add_child(UI.button(str(f[0]), "Tab", func(): _family(tag)))
	h.add_child(UI.spacer())
	_search = LineEdit.new()
	_search.placeholder_text = "find a position"
	_search.custom_minimum_size = Vector2(220, 0)
	_search.text_changed.connect(_find)
	h.add_child(_search)
	return bar


func _panel() -> Control:
	var p := PanelContainer.new()
	p.custom_minimum_size = Vector2(PANEL_W, 0)
	p.add_theme_stylebox_override("panel", UI.box(UI.PANEL, UI.LINE, 0, 1, 18, 14))
	var scroll := ScrollContainer.new()
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	p.add_child(scroll)
	var v := UI.vbox(10)
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(v)
	_side = UI.vbox(8)
	_side.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	v.add_child(_side)
	v.add_child(UI.sep())
	v.add_child(UI.caps("POSITIONS"))
	_list = UI.vbox(4)
	_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	v.add_child(_list)
	return p


func _refresh() -> void:
	UI.clear(_side)
	if not moving.is_empty():
		_side.add_child(UI.caps("NOW PLAYING"))
		_side.add_child(UI.label(Graph.clean(str(moving["t"]["title"])), 26, UI.GOLD, "bold", true))
		_side.add_child(UI.button("Skip to the end", "BtnQuiet", func(): player.seek(player.length_s())))
		return
	var pos: Dictionary = db[current]
	_side.add_child(UI.caps("POSITION"))
	_side.add_child(UI.label(Graph.clean(str(pos["title"])), 28, UI.FG, "bold", true))
	_side.add_child(UI.muted(", ".join(Array(pos["tags"]).map(func(t): return str(t).replace("_", " "))), UI.TINY, true))
	_moves("MOVES OUT", graph.outs(current), true)
	_moves("MOVES IN", graph.ins(current), false)


func _moves(title: String, moves: Array, out: bool) -> void:
	_side.add_child(UI.sep())
	_side.add_child(UI.caps("%s  (%d)" % [title, moves.size()]))
	if moves.is_empty():
		_side.add_child(UI.muted("none recorded", UI.TINY))
	for mv in moves:
		var other: Variant = Graph.lands(mv) if out else (mv["t"]["to"] if bool(mv["reverse"]) else mv["t"]["from"])
		var where := Graph.clean(str(db[int(other)]["title"])) if other != null else "?"
		var m: Dictionary = mv
		var b := UI.button2(Graph.clean(str(mv["t"]["title"])), ("to " if out else "from ") + where, "Choice",
			(func(): play_out(m)) if out else (func(): play_in(m)), Vector2(PANEL_W - 50, 58), UI.FG, UI.MUTED, false, UI.SMALL, UI.TINY)
		_side.add_child(b)


func _family(tag: String) -> void:
	_fill(graph.family(tag).slice(0, 40))


func _find(words: String) -> void:
	if words.strip_edges().length() >= 2:
		_fill(graph.search(words).slice(0, 40))


func _fill(list: Array) -> void:
	UI.clear(_list)
	for p in list:
		var id := int(p["id"])
		var n: int = graph.outs(id).size() + graph.ins(id).size()
		_list.add_child(UI.button2(Graph.clean(str(p["title"])), "%d moves" % n, "Choice", func(): go_position(id),
			Vector2(PANEL_W - 50, 50), UI.FG, UI.MUTED, false, UI.SMALL, UI.TINY))
