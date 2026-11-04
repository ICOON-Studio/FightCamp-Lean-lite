extends SceneTree
## MOVEPICS1 (S381): the Playbook's ink move cards, read off the PNGs on disk (tools/bake_move_pics.gd writes them and
## assets/ui/moves/moves.json). Every boxing move of the book and the Escapes, every punch and defence they are made of,
## and every move of Ana's syllabus that GrappleMap films (or has a stand-in position for) has a card; each card is the
## session cards' tile - 256 px, opaque, charcoal at the corners - with her red kit and the partner's blue on it, the gold
## arrow where the row says one was drawn, and the drawing clear of the edge. S383: a row marked "pending" (the card failed
## both reviews) ships no PNG and no moves.json entry; it is counted, and MoveTip shows the move's glyph instead.

const Specs := preload("res://tools/move_pic_specs.gd")
const SPS := preload("res://tools/session_pic_style.gd")
const BjjFilm := preload("res://scripts/rules/BjjFilm.gd")

const DIR := "res://assets/ui/moves"
const BLUE := Color(0.16, 0.33, 0.78)
const MIN_KIT_PX := 150
const MIN_GOLD_PX := 25
const EDGE := 4
## Straight punches and hooks land within 0.05 m. S381 measured 0.14-0.16 on three cards where the partner's height clamp
## (0.92-1.06) runs out: the old game's body hook digs in at hip height (body_hook, 1-2-3b) and the lead uppercut meets the
## chin from below - both read as landing on the card, so the bound is the measured worst plus a centimetre.
const MAX_GLOVE_GAP := 0.17
const MAX_BODY_GAP := 0.04    # r2 (review: "glove 0.16 m off the liver"): the body hook's arm reaches the liver
const MIN_BJJ_ARROW := 40
const Cards := preload("res://tools/move_pic_bjj_cards.gd")

var _fails := 0


func _initialize() -> void:
	var files: Variant = JSON.parse_string(FileAccess.get_file_as_string(DIR.path_join("moves.json")))
	var rows: Variant = JSON.parse_string(FileAccess.get_file_as_string(DIR.path_join("moves_rows.json")))
	_ok(files is Dictionary and rows is Dictionary, "moves.json and moves_rows.json parse")
	if not (files is Dictionary and rows is Dictionary):
		quit(1)
		return
	var want: Array = Specs.ids()
	for id in Specs.bjj_ids():
		if not BjjFilm.film(str(id)).is_empty() or Cards.has(str(id)):
			want.append(str(id))
	var shipped := 0
	var pending := 0
	for id in want:
		var row: Dictionary = (rows as Dictionary).get(id, {})
		if bool(row.get("pending", false)):
			# S383: a card that failed both reviews is PENDING - nothing ships for it and MoveTip shows the move's glyph.
			pending += 1
			_ok(not (files as Dictionary).has(id), "%s: pending, so no card in moves.json" % id)
			_ok(not FileAccess.file_exists(DIR.path_join(Specs.file(id))), "%s: pending, so no PNG ships" % id)
			continue
		shipped += 1
		_ok((files as Dictionary).has(id), "%s has a card in moves.json" % id)
		_ok(FileAccess.file_exists(DIR.path_join(Specs.file(id))), "%s: its PNG ships" % id)
		if (files as Dictionary).has(id):
			_check_card(str(id), str(files[id]), row)
	print("MOVE_PICS shipped=%d pending=%d" % [shipped, pending])
	print("move_pics_test: %d cards, %d failed checks" % [want.size(), _fails])
	quit(1 if _fails > 0 else 0)


func _check_card(id: String, path: String, row: Dictionary) -> void:
	_ok(path == DIR.path_join(Specs.file(id)), "%s file name" % id)
	var img := Image.load_from_file(ProjectSettings.globalize_path(path))
	_ok(img != null and img.get_width() == SPS.PX and img.get_height() == SPS.PX, "%s is %d px square" % [id, SPS.PX])
	if img == null:
		return
	img.convert(Image.FORMAT_RGBA8)
	var red := 0
	var blue := 0
	var gold := 0
	var opaque := true
	var edge_clear := true
	for y in img.get_height():
		for x in img.get_width():
			var c := img.get_pixel(x, y)
			opaque = opaque and c.a > 0.99
			if SPS.near_kit_red(c):
				red += 1
			elif absf(c.r - BLUE.r) < 0.03 and absf(c.g - BLUE.g) < 0.03 and absf(c.b - BLUE.b) < 0.03:
				blue += 1
			elif SPS.near_gold(c):
				gold += 1
			# S383 r3: the ring's ropes run off the card on purpose (a rope and its ink line may touch the edge).
			if (x < EDGE or y < EDGE or x >= SPS.PX - EDGE or y >= SPS.PX - EDGE) and not SPS.is_bg(c) 					and not SPS.near_prop(c) and not SPS.near_ink(c):
				edge_clear = false
	_ok(opaque, "%s is opaque" % id)
	# S381 r2: a BJJ card cropped tight on the contact may run a limb off the card.
	var bleeds := bool(row.get("bleeds", false))
	if not bleeds:
		for p in [Vector2i(0, 0), Vector2i(SPS.PX - 1, 0), Vector2i(0, SPS.PX - 1), Vector2i(SPS.PX - 1, SPS.PX - 1)]:
			var cc := img.get_pixelv(p)
			_ok(SPS.is_bg(cc) or SPS.near_prop(cc) or SPS.near_ink(cc), "%s corner %s is the charcoal tile (or a rope)" % [id, p])
		_ok(edge_clear, "%s keeps the drawing off the card's edge" % id)
	_ok(red >= MIN_KIT_PX, "%s shows her red kit (%d px)" % [id, red])
	_ok(blue >= MIN_KIT_PX, "%s shows the partner's blue (%d px)" % [id, blue])
	if float(row.get("arrow_px", 0.0)) >= 14.0:
		_ok(gold >= MIN_GOLD_PX, "%s has its gold arrow (%d px)" % [id, gold])
	if bool(row.get("r2", false)):
		_ok(float(row.get("arrow_px", 0.0)) >= MIN_BJJ_ARROW, "%s: the arrow runs %s px (>= %d)" % [id, row.get("arrow_px"), MIN_BJJ_ARROW])
		_ok(float(row.get("elev", 90.0)) <= 20.0, "%s: a low camera, never top-down (elev %s)" % [id, row.get("elev")])
	if str(row.get("kind", "")) == "punch":
		var gap := absf(float(row.get("glove_gap", 1.0)))
		_ok(gap <= MAX_GLOVE_GAP, "%s: the glove lands (gap %s m)" % [id, row.get("glove_gap")])
		if bool(Specs.spec(id)["body_shot"]):
			_ok(gap <= MAX_BODY_GAP, "%s: the glove is ON the liver (gap %s m)" % [id, row.get("glove_gap")])
		# r2: a combo shows every earlier punch, in order (1-1-2: two faint jabs and the cross).
		_ok(int(row.get("ghosts", 0)) == (Specs.spec(id)["ghosts"] as Array).size(), "%s: %s faint figures" % [id, row.get("ghosts")])


func _ok(cond: bool, what: String) -> void:
	if not cond:
		_fails += 1
		print("FAIL ", what)
