extends SceneTree
## S305: the AUTHORED hips path of a baked clip (before FightClips.hold_root_xz pins it): X/Z at 9 points.
## Headless: <godot.exe> --headless --path . --script res://tools/raw_hips.gd -- <stem> [<stem> ...]


func _initialize() -> void:
	for stem in OS.get_cmdline_user_args():
		var anim: Animation = load("res://assets/anim/baked/%s.res" % stem)
		if anim == null:
			print("RAWHIPS %s missing" % stem)
			continue
		for t in anim.get_track_count():
			if t < 3: print("TRACK ", anim.track_get_path(t), " type=", anim.track_get_type(t))
			if anim.track_get_type(t) != Animation.TYPE_POSITION_3D or str(anim.track_get_path(t)).get_slice(":", 1) != "Hips":
				continue
			var line := "RAWHIPS %s len=%.2f" % [stem, anim.length]
			var p0: Vector3 = anim.position_track_interpolate(t, 0.0)
			for k in 9:
				var tt := anim.length * k / 8.0
				var p: Vector3 = anim.position_track_interpolate(t, tt) - p0
				line += " | %.2fs x%+.2f z%+.2f" % [tt, p.x, p.z]
			print(line)
	quit(0)

