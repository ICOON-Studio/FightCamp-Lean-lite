extends SceneTree
## BODYREACT2 (S547, ops/research/TASK_BODYREACT2.md step 3): THE BODY HOOK AND ITS ANSWER, FILMED AS THE FIGHT PLAYS IT.
## One exchange through the v2 player's own route, as tools/bodyreact2_ruler.gd plays it (Player2.queue ->
## Choreographer.plan -> ChoreoReact.react -> the player's events, joins and layers), on a FIXED SIDE CAMERA
## (orthographic, level, red on the left, set once before the exchange and never moved - owner S537).
##   side=before  the shipped pick: the table's folds are taken out in memory, so ChoreoReact falls back to the
##                head-travel pick, draw for draw what the fight played until S547 (tests/body_react_test.gd DRAWS)
##   side=after   the tree as it is
## The same pair, slot and size in both runs = the same seed, the same punch take, the same contact time: the films
## differ by the answer alone. Every picture from LEAD_S before the planned contact to AFTER_S after the touch is
## saved (<out>/<side>_NNN.png, 60 a second) after the framing check (both boxers head to feet: STILL_FRAMING lines);
## the sheet's twelve (3 before the touch to 8 after) are tiled into <out>/<side>_sheet.png, each captioned with what
## the ruler's reading gives ON THAT PICTURE (his fold since the touch picture, his lean, the heads' crowding measure).
## cam=game: the game's own broadcast camera instead, 1920x1080, the set as the fight shows it; stills GAME_PICS
## pictures after the touch (<out>/game_<side>_pNN.png).
##   python tools/hidden_desktop.py run --timeout=300 --log=<f> <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --fixed-fps 60 --script res://tools/bodyreact2_film.gd -- <out_dir> fightplayer2 set=m|w side=before|after [slot=0] [big] [cam=game]

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const Player2 := preload("res://scripts/fight3d/v2/Player2.gd")
const FightClips := preload("res://scripts/fight3d/FightClips.gd")
const Gate := preload("res://tools/pics2d_gate.gd")
const SETS := {"w": ["11", "14"], "m": ["02", "01"]}
const THROWS := {"w": 0, "m": 1}
const HZ := 60.0
const W := 960
const H := 720
const ORTHO_M := 2.7          # the picture's height in metres (3.6 m wide: the hit man gives up to 0.9 m of ground)
const LOOK_Y := 1.02
const SHIFT_M := 0.30         # the camera stands this far toward the hit man's side
const LEAD_S := 0.75
const AFTER_S := 1.6
const SLOT_S := 6
const HIT_AT_S := 1.5
const SHEET_BEFORE := 3
const SHEET_AFTER := 8
const TILE_W := 640
const TILE_H := 480
const COLS := 6
const GAME_PICS := [0, 6, 9, 14]
const BONES := ["Hips", "Spine", "Chest", "UpperChest", "Neck", "Head", "LeftToes", "RightToes", "LeftHand", "RightHand"]

var st: Node3D
var p2: Node
var sv: SubViewport
var cam: Camera3D
var shown: Array = [{}, {}]
var out_dir := "user://bodyreact2_film"
var bad_frames := 0


func _arg(key: String, def: String) -> String:
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with(key + "="):
			return str(a).substr(key.length() + 1)
	return def


func _w(i: int, bone: String) -> Vector3:
	return (st.boxers[i]["skel"] as Skeleton3D).global_transform * (shown[i].get(bone, Vector3.ZERO) as Vector3)


func _pic() -> Array:
	var out: Array = [{}, {}]
	for i in 2:
		for b in BONES:
			out[i][b] = _w(i, str(b))
	return out


static func _flat(v: Vector3) -> Vector3:
	return Vector3(v.x, 0.0, v.z)


static func _lean(p: Dictionary, dirv: Vector3) -> float:
	var t: Vector3 = (p["Neck"] as Vector3) - (p["Hips"] as Vector3)
	return rad_to_deg(atan2(t.dot(-dirv), t.y))


static func _heads(pic: Array) -> float:
	var best := INF
	for i in 2:
		var h: Vector3 = pic[i]["Head"]
		var line: Array = []
		for bone in Gate.TORSO + ["Head"]:
			line.append(pic[1 - i][bone])
		best = minf(best, Gate.chain_dist([h, h], line))
	return best


## The framing check on the picture being saved: both boxers head to feet (and gloves) inside it (tools/pics2d_gate.gd's points and margins).
func _framed(pic: Array, size: Vector2i) -> Array:
	var bad: Array = []
	for i in 2:
		for p in [["Head", 0.14], ["LeftToes", -0.06], ["RightToes", -0.06], ["LeftHand", 0.0], ["RightHand", 0.0]]:
			var s := cam.unproject_position((pic[i][str(p[0])] as Vector3) + Vector3.UP * float(p[1]))
			if s.x < 4.0 or s.x > size.x - 4.0 or s.y < 4.0 or s.y > size.y - 4.0:
				bad.append("%s %s at %s" % [["red", "blue"][i], str(p[0]), str(s.round())])
	return bad


func _initialize() -> void:
	Engine.max_fps = int(HZ)
	var args := OS.get_cmdline_user_args()
	if not args.is_empty() and not str(args[0]).contains("="):
		out_dir = str(args[0])
	DirAccess.make_dir_recursive_absolute(out_dir)
	var set_name := _arg("set", "m")
	var side := _arg("side", "after")
	var game := _arg("cam", "side") == "game"
	var big := args.has("big")
	var slot := int(_arg("slot", "0"))
	var who: int = int(THROWS[set_name])
	var d := 1 - who
	Player2.force = true
	FightClips.untouched = true
	var size := Vector2i(1920, 1080) if game else Vector2i(W, H)
	sv = SubViewport.new()
	sv.size = size
	sv.msaa_3d = Viewport.MSAA_4X
	sv.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	root.add_child(sv)
	st = Stage.new()
	sv.add_child(st)
	await process_frame
	var pair: Array = SETS[set_name]
	st.setup({"glb": "res://assets/models/metahuman/mh_boxer_%s.glb" % pair[0], "corner": "red", "stance": "orthodox"},
		{"glb": "res://assets/models/metahuman/mh_boxer_%s.glb" % pair[1], "corner": "blue", "stance": "orthodox"})
	if st.v2 == null:
		print("BR2_FILM FAIL the v2 player was not built")
		quit(1)
		return
	p2 = st.v2
	for i in 2:
		var sk: Skeleton3D = st.boxers[i]["skel"]
		var ids: Array = BONES.map(func(b): return sk.find_bone(str(b)))
		var dd: Dictionary = shown[i]
		sk.skeleton_updated.connect(func():
			for k in BONES.size():
				dd[BONES[k]] = sk.get_bone_global_pose(int(ids[k])).origin)
	for f in 90:
		await process_frame
	if side == "before":
		for n in p2.db["rows"]:
			(p2.db["rows"][n] as Dictionary).erase("fold_g")
	var n0: Node3D = st.boxers[0]["node"]
	var n1: Node3D = st.boxers[1]["node"]
	if game:
		cam = st.camera
	else:
		Gate.clean_set(st, [n0, n1])
		sv.transparent_bg = false
		RenderingServer.set_default_clear_color(Color(0.20, 0.22, 0.26))
		cam = Camera3D.new()
		cam.projection = Camera3D.PROJECTION_ORTHOGONAL
		cam.size = ORTHO_M
		cam.near = 0.05
		cam.far = 40.0
		st.add_child(cam)
		var axis := _flat(n1.global_position - n0.global_position).normalized()   # red -> blue: the picture's right
		var look := Vector3.UP.cross(axis)
		var mid := _flat((n0.global_position + n1.global_position) * 0.5) + axis * SHIFT_M * (1.0 if d == 1 else -1.0)
		cam.global_position = Vector3(mid.x, LOOK_Y, mid.z) - look * 8.0
		cam.look_at(Vector3(mid.x, LOOK_Y, mid.z), Vector3.UP)
		cam.make_current()
	var layer := CanvasLayer.new()
	sv.add_child(layer)
	var label := Label.new()
	label.position = Vector2(20, 14)
	label.add_theme_font_size_override("font_size", 24 if not game else 34)
	label.add_theme_color_override("font_outline_color", Color.BLACK)
	label.add_theme_constant_override("outline_size", 6)
	layer.add_child(label)
	# the exchange, as the ruler plays it
	var t0 := float(slot * SLOT_S)
	var ws := "a" if who == 0 else "b"
	var os := "b" if who == 0 else "a"
	p2.queue([{"t": t0 + HIT_AT_S, "who": ws, "move": "body_hook", "result": "lands", "def": "", "big": big}], t0, t0 + float(SLOT_S))
	var ev := {}
	for e in p2.plan["tracks"][os]:
		if str(e.get("kind", "")) == "reaction":
			ev = e
	var punch := ""
	var contact_t := t0 + HIT_AT_S
	for e2 in p2.plan["tracks"][ws]:
		if str(e2.get("kind", "")) == "punch":
			punch = str(e2.get("clip", ""))
			contact_t = float(e2.get("contact_t", contact_t))
	label.text = "%s\na landed body hook (%s)\nhe answers with %s" % ["BEFORE: the shipped pick" if side == "before" else "AFTER: the take that folds on the blow", punch.trim_prefix("pro_"), str(ev.get("clip", "?")).trim_prefix("pro_")]
	print("BR2_FILM set %s %s slot %d%s: punch %s, contact planned at %.3f s, the answer %s from %.3f s" % [set_name, side, slot, " big" if big else "", punch, contact_t, str(ev.get("clip", "")), float(ev.get("from_s", 0.0))])
	var seen: int = (p2.contacts as Array).size()
	var pics: Array = []      # every saved picture's poses
	var names: Array = []
	var ci := -1              # the touch picture among the saved ones
	var t := t0
	for f in int(SLOT_S * HZ):
		p2.clock(t, true)
		await process_frame   # (the picture drawn last frame is this clock's; the poses just read are its)
		t += 1.0 / HZ
		var touched_now: bool = ci < 0 and (p2.contacts as Array).size() > seen
		if t < contact_t - LEAD_S:
			continue
		if not game and sv.get_camera_3d() != cam:
			cam.make_current()
		var pic := _pic()
		if touched_now:
			ci = pics.size()
		pics.append(pic)
		var k := pics.size() - 1
		var bad := _framed(pic, size)
		if not bad.is_empty():
			bad_frames += 1
			if bad_frames <= 3:
				print("STILL_FRAMING FAIL %s picture %d: %s" % [side, k, "; ".join(PackedStringArray(bad))])
		var name := "%s_%03d.png" % [side, k]
		if game:
			name = ""
			if ci >= 0 and (k - ci) in GAME_PICS:
				name = "game_%s_p%02d.png" % [side, k - ci]
		names.append(name)
		if name != "" and (bad.is_empty() or not game):
			sv.get_texture().get_image().save_png(out_dir.path_join(name))
		if ci >= 0 and k - ci >= int(AFTER_S * HZ):
			break
	if ci < 0:
		print("BR2_FILM FAIL the hook never reached its contact")
		quit(1)
		return
	print("STILL_FRAMING %s %s: %d of %d pictures hold both boxers head to feet" % ["ok" if bad_frames == 0 else "FAIL", side, pics.size() - bad_frames, pics.size()])
	# what the ruler's reading gives on every saved picture
	var dirv := _flat((pics[ci][d]["Hips"] as Vector3) - (pics[ci][who]["Hips"] as Vector3)).normalized()
	var lean0 := _lean(pics[ci][d], dirv)
	var rows: Array = []
	for k in pics.size():
		rows.append({"k": k, "f": k - ci, "file": names[k], "lean_deg": snappedf(_lean(pics[k][d], dirv), 0.1), "fold_deg": snappedf(_lean(pics[k][d], dirv) - lean0, 0.1), "heads_m": snappedf(_heads(pics[k]), 0.001)})
	var fh := FileAccess.open(out_dir.path_join("%s%s_frames.json" % ["game_" if game else "", side]), FileAccess.WRITE)
	fh.store_string(JSON.stringify({"set": set_name, "side": side, "slot": slot, "big": big, "punch": punch, "react": str(ev.get("clip", "")), "from_s": float(ev.get("from_s", 0.0)), "touch": ci, "pictures": pics.size(), "framing_bad": bad_frames, "rows": rows}, " "))
	fh.close()
	print("BR2_FILM %s: touch on picture %d of %d; his fold +3 / +6 / +9 pictures after: %.1f / %.1f / %.1f deg" % [side, ci, pics.size(), float(rows[mini(ci + 3, rows.size() - 1)]["fold_deg"]), float(rows[mini(ci + 6, rows.size() - 1)]["fold_deg"]), float(rows[mini(ci + 9, rows.size() - 1)]["fold_deg"])])
	if not game:
		await _sheet(side, rows, ci, str(ev.get("clip", "")))
	quit(0)


## The sheet of twelve: the saved pictures 3 before the touch to 8 after, each with the reading of THAT picture.
func _sheet(side: String, rows: Array, ci: int, react: String) -> void:
	var sheet := SubViewport.new()
	sheet.size = Vector2i(COLS * TILE_W, 2 * TILE_H)
	sheet.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	sheet.disable_3d = true
	root.add_child(sheet)
	var n := 0
	for k in range(ci - SHEET_BEFORE, ci + SHEET_AFTER + 1):
		if k < 0 or k >= rows.size():
			continue
		var r: Dictionary = rows[k]
		var img := Image.load_from_file(out_dir.path_join(str(r["file"])))
		var tr := TextureRect.new()
		tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tr.stretch_mode = TextureRect.STRETCH_SCALE
		tr.texture = ImageTexture.create_from_image(img)
		tr.position = Vector2((n % COLS) * TILE_W, (n / COLS) * TILE_H)
		tr.size = Vector2(TILE_W, TILE_H)
		sheet.add_child(tr)
		var back := ColorRect.new()
		back.color = Color(0, 0, 0, 0.62)
		back.position = tr.position + Vector2(0, TILE_H - 84)
		back.size = Vector2(TILE_W, 84)
		sheet.add_child(back)
		var cap := Label.new()
		cap.position = back.position + Vector2(12, 4)
		cap.add_theme_font_size_override("font_size", 27)
		cap.add_theme_color_override("font_color", Color(1.0, 0.92, 0.55) if int(r["f"]) != 0 else Color(1.0, 0.55, 0.45))
		var when := "THE TOUCH" if int(r["f"]) == 0 else ("%+.3f s" % (float(r["f"]) / HZ))
		cap.text = "%d  (%s)   he has bent %+.1f deg\nhis lean %.1f deg   heads %.2f m apart" % [n + 1, when, float(r["fold_deg"]), float(r["lean_deg"]), float(r["heads_m"])]
		sheet.add_child(cap)
		n += 1
	for f in 4:
		await process_frame
	await RenderingServer.frame_post_draw
	sheet.get_texture().get_image().save_png(out_dir.path_join("%s_sheet.png" % side))
	print("BR2_FILM %s sheet: %d pictures, the hit man plays %s -> %s" % [side, n, react, out_dir.path_join("%s_sheet.png" % side)])
