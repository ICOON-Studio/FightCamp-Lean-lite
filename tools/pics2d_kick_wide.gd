extends "res://tools/pics2d_kick.gd"
## RENDERFIT1 (S559, ops/research/TASK_RENDERFIT1.md): the kick runs whose man leaves the ring camera's square frame.
## On the owner's fixed ring camera, red's teep and low kick MISSED were refused (blue's back foot pulls out past the
## frame's right edge: STILL_FRAMING FAIL blue LeftToes at x 767 / 807 of 768). Widening the camera (Gate.fit) would leave
## the ring spot and change the scale; instead the picture is made WIDE= times as wide at the same height, the same
## camera size (KEEP_HEIGHT) and the same aim: its middle 768 px are exactly the square frame, the page draws it centred
## on the same middle, so the men, the slide and the ring line up with every other picture. The frame check is the
## gate's own (head, toes, hands 4 px inside), on the wider width.
##   python tools/hidden_desktop.py run ... --script res://tools/pics2d_kick_wide.gd -- <out_dir> art=toon set=m south=blue \
##       only=red_teep_missed,red_low_kick_missed [wide=1.5]

var wide := 1.5


func _setup() -> bool:
	var ok: bool = await super._setup()
	wide = float(_arg("wide", "1.5"))
	cam.keep_aspect = Camera3D.KEEP_HEIGHT   # the height stays cam.size: the same px a metre as the square pictures
	sv.size = Vector2i(int(round(SIZE * wide)), SIZE)
	return ok


func _frame(name: String, who: Array = [0, 1]) -> bool:
	var w := sv.size.x
	var bad: Array = []
	for i in who:
		for p in [["Head", 0.14], ["LeftToes", -0.06], ["RightToes", -0.06], ["LeftHand", 0.0], ["RightHand", 0.0]]:
			var s := cam.unproject_position(Gate.world(stage, i, str(p[0])) + Vector3.UP * float(p[1]))
			if s.x < 4.0 or s.x > w - 4.0 or s.y < 4.0 or s.y > SIZE - 4.0:
				bad.append("%s %s at %s" % [["red", "blue"][i], str(p[0]), str(s.round())])
	if not bad.is_empty():
		print("STILL_FRAMING FAIL %s: %s" % [name, "; ".join(PackedStringArray(bad))])
		return false
	await RenderingServer.frame_post_draw
	sv.get_texture().get_image().save_png(out_dir.path_join(name + ".png"))
	wrote += 1
	return true
