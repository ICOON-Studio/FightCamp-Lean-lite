## CAMPICK1 (S559, ops/research/TASK_CAMPICK1.md): the picture tools' side camera, in numbers. The owner turns the camera in
## tools/camera_pick.gd and saves the angle to tools/pics2d_camera.json; tools/pics2d_set.gd (and every tool built on it)
## then takes those numbers as its defaults. No file = today's camera exactly (level, side on, ORTHO_M 2.55, LOOK_Y 1.02).
## pitch= / yaw= on the command line still win over the file.

const PATH := "res://tools/pics2d_camera.json"
const DEFAULTS := {"pitch": 0.0, "yaw": 0.0, "size": 2.55, "look_y": 1.02, "look_shift": 0.0}
const PITCH_MAX := 85.0   # straight down has no "up" for look_at


## The camera numbers: the defaults, the saved file over them, the command line over both. arg: func(key, def) -> String.
static func read(arg: Callable) -> Dictionary:
	var d: Dictionary = DEFAULTS.duplicate()
	if FileAccess.file_exists(PATH):
		var j = JSON.parse_string(FileAccess.get_file_as_string(PATH))
		if j is Dictionary:
			for k in DEFAULTS:
				if (j as Dictionary).has(k):
					d[k] = float(j[k])
	for k in ["pitch", "yaw"]:
		var v := str(arg.call(k, ""))
		if v != "":
			d[k] = float(v)
	d["pitch"] = clampf(float(d["pitch"]), -PITCH_MAX, PITCH_MAX)
	return d


## Places the orthographic camera 8 m off the pair on -X, raised by pitch (looking down), turned by yaw about the pair,
## aimed at look_y over the pair's middle, the aim moved look_shift m to the camera's right.
static func place(cam: Camera3D, mid: Vector3, c: Dictionary) -> void:
	cam.size = float(c["size"])
	var off := Vector3(-8.0, 0.0, 0.0).rotated(Vector3.BACK, -deg_to_rad(float(c["pitch"]))).rotated(Vector3.UP, deg_to_rad(float(c["yaw"])))
	var right := Vector3(-off.x, 0.0, -off.z).normalized().cross(Vector3.UP)
	var look := Vector3(mid.x, float(c["look_y"]), mid.z) + right * float(c["look_shift"])
	cam.global_position = look + off
	cam.look_at(look, Vector3.UP)
