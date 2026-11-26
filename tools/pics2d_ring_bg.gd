extends "res://tools/pics2d_set.gd"
## RENDERFIT1 (S559, ops/research/TASK_RENDERFIT1.md): the empty ring from the SAME camera as the Ring Switches pictures
## (the owner's saved angle, tools/pics2d_camera.json, aimed at the ring spot ring_at as cam=ring), so the page can draw
## it behind the men instead of its flat side-on gradient and two CSS rope lines. The stage is the game's own FightStage
## ring (RingSet: canvas, apron, posts, three ropes); the boxers are hidden, and so are the posts and rope pieces on the
## camera's side of the ring (in the runs they would stand in front of the men; drawn behind them they would cut through),
## and the crowd and its camera flashes (a flash quad sat on the ring's middle).
## The picture is WIDE= times as wide as a run picture at the same height and the same aim, so its middle SIZE px are
## exactly a run picture's frame and the rest fills the page's stage left and right.
##   python tools/hidden_desktop.py run --timeout=600 --log=<f> <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --fixed-fps 60 --script res://tools/pics2d_ring_bg.gd -- <out_dir> art=toon set=m south=blue [wide=4]
## Writes <out_dir>/ring_bg.png (SIZE*wide x SIZE) and ring_bg.json; prints RING_BG wrote <path> hidden_near=<n>.

func _run() -> void:
	var wide := int(_arg("wide", "4"))
	await _home_guard()
	_aim([0, 1])
	var ring: Node = stage.find_child("RingSet", true, false)
	if ring == null:
		print("RING_BG FAIL the stage has no RingSet")
		quit(1)
		return
	var high := 0
	for n in ring.find_children("*", "VisualInstance3D", true, false):
		var v := n as VisualInstance3D
		v.visible = not (n is MultiMeshInstance3D) and not str(v.get_path()).contains("CrowdFlashes")   # the seated crowd and its camera flashes stay out (a flash quad sat on the ring's middle)
		if v.visible and not (n is Light3D) and v.get_aabb().size.length() < 20.0 and (v.global_transform * v.get_aabb().get_center()).y > 1.6:
			v.visible = false   # the light rig over the ring: from his raised camera a lamp sat in the middle of the picture
			high += 1
			print("RING_BG hid %s (%s) at %s" % [v.name, v.get_class(), v.global_transform * v.get_aabb().get_center()])
	for b in [_node(0), _node(1)]:
		(b as Node3D).visible = false
	var back := -_view()
	back.y = 0.0
	back = back.normalized()
	var at: Vector3 = camv["ring_at"]
	var near := 0
	for n in ring.ring_side:
		var p: Vector3 = (n as Node3D).global_position
		if (p - at).dot(back) > 2.5:   # the near rope line and its posts only (the ring is 5.5 m: its edge is 2.75 m off the middle)
			(n as VisualInstance3D).visible = false
			near += 1
	if _arg("list", "") != "":
		for n in stage.find_children("*", "VisualInstance3D", true, false):
			var v := n as VisualInstance3D
			if v.is_visible_in_tree() and not (n is Light3D):
				print("RING_BG shows %s %s %s size %s" % [v.get_path(), v.get_class(), v.global_transform * v.get_aabb().get_center(), v.get_aabb().size])
	cam.keep_aspect = Camera3D.KEEP_HEIGHT   # the height stays the runs' cam.size; the width grows about the same aim
	sv.size = Vector2i(SIZE * wide, SIZE)
	for f in 8:
		await process_frame
	await RenderingServer.frame_post_draw
	var path := out_dir.path_join("ring_bg.png")
	sv.get_texture().get_image().save_png(path)
	var fh := FileAccess.open(out_dir.path_join("ring_bg.json"), FileAccess.WRITE)
	fh.store_string(JSON.stringify({"wide": wide, "size_px": [SIZE * wide, SIZE], "run_px": SIZE, "cam": camv.duplicate().merged({"ring_at": [at.x, at.y, at.z]}, true)}, "  "))
	fh.close()
	print("RING_BG wrote %s hidden_near=%d hidden_high=%d" % [path, near, high])
	quit(0)
