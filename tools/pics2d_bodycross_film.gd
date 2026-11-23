extends "res://tools/pics2d_set.gd"
## BODYCROSS1 (S542, ops/research/TASK_BODYCROSS1.md step 6): THE BODY CROSS LANDING, OLD TAKE v NEW TAKE, on the
## pictures' own fixed side camera (orthographic, level, red on the left; never a corner frame - owner S537). The same
## pair, the same camera, the game's own finish (Player2._arm -> PunchAim on the ribs): first the take the pictures used
## until S542 (pro_right_cross_c, the head cross sent at the body), then the authored body cross (pro_body_cross).
## Each is played whole at 60 pictures a second from the guard; the other man's gut-shot reaction starts on the contact.
## Writes <out>/<old|new>_NNN.png, <out>/<old|new>_contact.png (through the set tool's framing check: both boxers head
## to toes in frame, else STILL_FRAMING FAIL) and prints the glove's distance to the rib point on the contact picture.
##   python tools/hidden_desktop.py run --timeout=600 --log=<f> <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --fixed-fps 60 --script res://tools/pics2d_bodycross_film.gd -- <out_dir> art=toon set=w|m [who=0|1]

const TAKES := [["old", "pro_right_cross_c", "OLD  the head cross sent at the body"], ["new", "pro_body_cross", "NEW  the body cross take"]]
const LEAD_FRAMES := 18
const TAIL_FRAMES := 24

var label: Label


func _initialize() -> void:
	if not await _setup():
		return
	sv.transparent_bg = false
	RenderingServer.set_default_clear_color(Color(0.20, 0.22, 0.26))
	var layer := CanvasLayer.new()
	sv.add_child(layer)
	label = Label.new()
	label.position = Vector2(20, 16)
	label.add_theme_font_size_override("font_size", 26)
	layer.add_child(label)
	var who := int(_arg("who", "0"))
	for t in TAKES:
		await _film(who, str(t[0]), str(t[1]), str(t[2]))
	print("BODYCROSS_FILM wrote=%d refused=%d" % [wrote, refused])
	quit(0 if refused == 0 else 1)


func _film(who: int, tag: String, clip: String, words: String) -> void:
	var ap: AnimationPlayer = stage.boxers[who]["ap"]
	if not ap.has_animation(clip):
		print("BODYCROSS_FILM no take %s" % clip)
		refused += 1
		return
	var row: Dictionary = stage.v2.db["rows"][clip]
	var cs := float(row.get("contact_s", 0.3))
	var hand: String = stage.hand_of(who, str(row.get("hand", "RightHand")))
	var dirv := axis * (1.0 if who == 0 else -1.0)
	# the range, the set tool's way: the take alone, then the pair moved by what the armed glove still leaves
	await _home_guard()
	stage.v2._play(who, clip, 0.0, "punch", false)
	await _to_contact(who, clip, cs)
	var short: float = (stage.v2.target(1 - who, true) - stage.glove_front(who, hand)).dot(dirv)
	var room: float = (_node(1 - who).global_position - _node(who).global_position).dot(dirv) - MIN_APART_M
	var step := minf(short, room)
	var extra := Vector3.ZERO
	for attempt in 3:
		await _home_guard(step, who)
		_node(who).global_position += extra
		stage.v2._arm(who, clip, true)
		stage.v2._play(who, clip, 0.0, "punch", false)
		await _to_contact(who, clip, cs)
		for f in 8:
			await process_frame
		var r: Vector3 = stage.v2.target(1 - who, true) - stage.glove_front(who, hand)
		if r.length() <= 0.04:
			break
		extra += Vector3(r.x, 0.0, r.z) + dirv * maxf(0.0, -r.y) * 0.6
		extra -= dirv * maxf(0.0, (step + extra.dot(dirv)) - room)
	# the film: from the guard, the whole take, the reaction on the contact
	await _home_guard(step, who)
	_node(who).global_position += extra
	_aim([0, 1])
	label.text = "%s   (%s)" % [words, clip]
	var n := 0
	for f in LEAD_FRAMES:
		await process_frame
		n = await _frame(tag, n)
	stage.v2._arm(who, clip, true)
	stage.v2._play(who, clip, 0.0, "punch", false)
	var hit := false
	var tail := 0
	for f in 400:
		await process_frame
		var live := str(ap.current_animation) == clip and ap.is_playing()
		if not hit and (not live or ap.current_animation_position >= cs - 0.008):
			hit = true
			var tgt: Vector3 = stage.v2.target(1 - who, true)
			var gl: Vector3 = stage.glove_front(who, hand)
			print("BODYCROSS_FILM %s %s contact: glove to the rib point %.3f m (glove %.3f m up, ribs %.3f m up), step %.2f m (+%.2f)" % [
				tag, clip, gl.distance_to(tgt), gl.y, tgt.y, step, extra.length()])
			var bad := _framed([0, 1])
			if bad.is_empty():
				await RenderingServer.frame_post_draw
				sv.get_texture().get_image().save_png(out_dir.path_join(tag + "_contact.png"))
				print("STILL_FRAMING ok %s_contact" % tag)
				wrote += 1
			else:
				print("STILL_FRAMING FAIL %s_contact: %s" % [tag, "; ".join(PackedStringArray(bad))])
				refused += 1
			stage.v2._play(1 - who, str(REACT["body_cross"]), 0.0, "reaction", false)
		n = await _frame(tag, n)
		if not live:
			tail += 1
			if tail >= TAIL_FRAMES:
				break
	var aim: Node = stage.v2._aim[who]
	if aim != null:
		aim.disarm()


func _frame(tag: String, n: int) -> int:
	await RenderingServer.frame_post_draw
	sv.get_texture().get_image().save_png(out_dir.path_join("%s_%03d.png" % [tag, n]))
	return n + 1
