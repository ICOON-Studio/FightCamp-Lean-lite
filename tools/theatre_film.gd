extends SceneTree
## S379 the Grappling theatre on film for the ops board: one chain (TheatreChains) in documentary mode - the director's
## cuts, the lower thirds, the timeline with its join ticks - rendered frame by frame at 30 fps into a fixed 1280x720
## SubViewport (the UI laid out at 1920x1080 and scaled, so the film looks like the game's screen), JPG frames under
## user:// (C:, off the full E: drive), encoded to <out>/<chain>.mp4 with ffmpeg, frames deleted.
## While it films it MEASURES the women AS DRAWN (bones read on Skeleton3D.skeleton_updated, after GrapplePose - the S307
## trap; tools/grapple_orbit.gd's definitions): per JOIN the worst one-frame step of a tracked bone in the 0.6 s after
## the tick and its jerk p95 there (a pop at a join reads as a step far over the chain's own), per MOVE the deepest drawn
## overlap (a limb or head inside the other's pelvis/trunk, metres; frames deeper than 6 cm = bodies inside bodies).
##   python tools/hidden_desktop.py run --timeout=900 <godot.exe> --path . --windowed --resolution 1280x720 \
##       --audio-driver Dummy --fixed-fps 30 --script res://tools/theatre_film.gd -- chain=<id> out=<dir> [ffmpeg=<exe>]
## `cards=1 out=res://assets/ui/theatre` instead: each chain's card still (its key move's landing, a 3/4 wide view) as
## <id>.png (416x234) - run `--headless --import` after so the game loads them.
## Prints THEATRE_FILM lines and one THEATRE_JSON line; THEATRE_FILM done <mp4> at the end.

const Chains := preload("res://scripts/grapple/TheatreChains.gd")
const Director := preload("res://scripts/grapple/TheatreDirector.gd")
const W := 1280
const H := 720
const CARD := Vector2i(416, 234)
const FPS := 30.0
const V_MIN := 0.0005
const DEEP_M := 0.06
const JOIN_WINDOW_S := 0.6
const TRACK := ["LeftHand", "RightHand", "LeftLowerArm", "RightLowerArm", "LeftFoot", "RightFoot", "LeftLowerLeg",
	"RightLowerLeg", "Head", "Hips"]
const BONES := ["Hips", "Spine", "Neck", "Head", "LeftUpperArm", "RightUpperArm", "LeftLowerArm", "RightLowerArm",
	"LeftHand", "RightHand", "LeftUpperLeg", "RightUpperLeg", "LeftLowerLeg", "RightLowerLeg", "LeftFoot", "RightFoot",
	"LeftToes", "RightToes"]
const PARTS := [["Head", "Head", 0.11], ["Neck", "Head", 0.07], ["LeftUpperArm", "LeftLowerArm", 0.06],
	["RightUpperArm", "RightLowerArm", 0.06], ["LeftLowerArm", "LeftHand", 0.045], ["RightLowerArm", "RightHand", 0.045],
	["LeftUpperLeg", "LeftLowerLeg", 0.10], ["RightUpperLeg", "RightLowerLeg", 0.10], ["LeftLowerLeg", "LeftFoot", 0.065],
	["RightLowerLeg", "RightFoot", 0.065], ["LeftFoot", "LeftToes", 0.068], ["RightFoot", "RightToes", 0.068]]
const TORSO := [["LeftUpperLeg", "RightUpperLeg", 0.118], ["Spine", "Neck", 0.12]]
const WHO := ["red", "blue"]

var _cache: Array = [{}, {}]
var th: Control
var vp: SubViewport


func _initialize() -> void:
	var chain := "fifty_fifty"
	var out := "user://theatre_film"
	var cards := false
	var ffmpeg := "ffmpeg"
	for a in OS.get_cmdline_user_args():
		var s := str(a)
		if s.begins_with("chain="):
			chain = s.substr(6)
		elif s.begins_with("out="):
			out = s.substr(4)
		elif s == "cards=1":
			cards = true
		elif s.begins_with("ffmpeg="):
			ffmpeg = s.substr(7)
	root.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_KEEP
	vp = SubViewport.new()
	vp.size = CARD if cards else Vector2i(W, H)
	vp.size_2d_override = vp.size if cards else Vector2i(1920, 1080)
	vp.size_2d_override_stretch = true
	vp.msaa_3d = Viewport.MSAA_4X
	vp.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	root.add_child(vp)
	th = load("res://scenes/dev/GrappleTheatre.tscn").instantiate()
	th.set("film", true)
	vp.add_child(th)
	for k in 3:
		await process_frame
	if cards:
		await _cards(ProjectSettings.globalize_path(out))
	elif Chains.chain(chain).is_empty():
		print("THEATRE_FILM FAIL no chain ", chain)
	else:
		await _film(chain, ProjectSettings.globalize_path(out), ffmpeg)
	quit(0)


func _cards(dir: String) -> void:
	DirAccess.make_dir_recursive_absolute(dir)
	(th.get("_caption")["box"] as Control).visible = false
	(th.get("_strip") as Control).visible = false
	for c in Chains.chains():
		th.call("load_chain", str(c["id"]))
		th.call("set_playing", false)
		var steps: Array = th.get("steps")
		var t := float(steps[int(c["key"])]["t1"]) - 0.05
		th.call("seek", t)
		var d: RefCounted = th.get("director")
		var js: Array = th.call("sample", t)
		var reach := 0.0
		var top := 0.0
		var ctr: Vector3 = d.call("centre", t)
		for w in 2:
			for p in (js[w] as PackedVector3Array):
				reach = maxf(reach, Vector2(p.x - ctr.x, p.z - ctr.z).length())
				top = maxf(top, p.y)
		th.call("set_orbit", true)
		th.set("_orbit_yaw", float(d.call("side_yaw", js)) + 25.0)
		th.set("_orbit_pitch", 26.0)
		th.set("_orbit_dist", Director.fit(reach, top, 40.0) * 0.85)
		th.call("apply")
		for k in 4:
			await RenderingServer.frame_post_draw
		var path := dir.path_join(str(c["id"]) + ".png")
		vp.get_texture().get_image().save_png(path)
		print("THEATRE_FILM card %s -> %s (key move %d: %s)" % [c["id"], path, int(c["key"]), steps[int(c["key"])]["name"]])
		th.call("set_orbit", false)


func _film(chain: String, out_dir: String, ffmpeg: String) -> void:
	th.call("load_chain", chain)
	th.call("set_playing", false)
	var poses: Array = th.get("poses")
	for w in 2:
		_watch((poses[w] as Node).get_parent() as Skeleton3D, w)
	var total: float = th.get("total")
	var steps: Array = th.get("steps")
	var joins: Array = th.get("joins")
	var reel: Dictionary = th.get("reel")
	var frames_dir := OS.get_user_data_dir().path_join("theatre_frames").path_join(chain)
	DirAccess.make_dir_recursive_absolute(frames_dir)
	DirAccess.make_dir_recursive_absolute(out_dir)
	var n := int(ceil(total * FPS))
	var tracks: Array = []
	for w in 2:
		var per: Array = []
		for _b in TRACK:
			per.append([])
		tracks.append(per)
	var ov := PackedFloat32Array()
	th.call("seek", 0.0)
	await RenderingServer.frame_post_draw
	for f in n:
		th.call("seek", float(f) / FPS)
		await RenderingServer.frame_post_draw
		vp.get_texture().get_image().save_jpg(frames_dir.path_join("f%05d.jpg" % f), 0.9)
		for w in 2:
			for k in TRACK.size():
				(tracks[w][k] as Array).append(_cache[w].get(TRACK[k], Vector3.ZERO))
		ov.append(_overlap())
	var d: RefCounted = th.get("director")
	var row := {"chain": chain, "length_s": snappedf(total, 0.01), "frames": n, "shots": [], "joins": [], "moves": []}
	for s in d.get("shots"):
		row["shots"].append("%s %.1f-%.1f" % [s["kind"], float(s["t0"]), float(s["t1"])])
	print("THEATRE_FILM %s %.1f s, %d frames, %d shots: %s" % [chain, total, n, row["shots"].size(), ", ".join(row["shots"])])
	var all_steps := _steps(tracks, 0, n)
	for i in joins.size():
		var tj := float(joins[i])
		var f0 := int(tj * FPS)
		var win := _steps(tracks, f0, mini(n, f0 + int(JOIN_WINDOW_S * FPS) + 1))
		var j: Dictionary = reel["joins"][i]
		var line := "join %d at %.2f s: %s -> %s | align err %.3f m%s | worst step %.3f m (%s) vs chain p95 step %.3f | jerk p95 %.0f vs chain %.0f m/s^3" % [
			i + 1, tj, steps[i]["name"], steps[i + 1]["name"], float(j["err"]), ", same keyframe (dropped)" if bool(j["dropped"]) else "",
			float(win["worst"]), win["worst_at"], float(all_steps["p95"]), float(win["jerk_p95"]), float(all_steps["jerk_p95"])]
		print("THEATRE_FILM " + line)
		row["joins"].append({"t": snappedf(tj, 0.01), "from": steps[i]["name"], "to": steps[i + 1]["name"], "err": snappedf(float(j["err"]), 0.001),
			"worst_step": snappedf(float(win["worst"]), 0.001), "where": win["worst_at"], "jerk_p95": snappedf(float(win["jerk_p95"]), 1.0)})
	for s in steps:
		var a := int(float(s["t0"]) * FPS)
		var b := mini(n, int(float(s["t1"]) * FPS) + 1)
		var peak := 0.0
		var deep := 0
		var at := 0.0
		for f in range(a, b):
			if ov[f] > peak:
				peak = ov[f]
				at = f / FPS
			if ov[f] > DEEP_M:
				deep += 1
		print("THEATRE_FILM move %-24s %5.2f-%5.2f s | drawn overlap peak %.3f m at %.2f s, %d frames deeper than 6 cm" % [
			s["name"], float(s["t0"]), float(s["t1"]), peak, at, deep])
		row["moves"].append({"name": s["name"], "t0": snappedf(float(s["t0"]), 0.01), "t1": snappedf(float(s["t1"]), 0.01),
			"overlap_peak": snappedf(peak, 0.001), "overlap_at": snappedf(at, 0.01), "deep_frames": deep})
	row["jerk_p95"] = snappedf(float(all_steps["jerk_p95"]), 0.1)
	row["flips_s"] = snappedf(float(all_steps["flips_s"]), 0.01)
	print("THEATRE_FILM drawn bones over the chain: jerk p95 %.1f m/s^3, flips %.2f /s a bone" % [row["jerk_p95"], row["flips_s"]])
	print("THEATRE_JSON " + JSON.stringify(row))
	var mp4 := out_dir.path_join(chain + ".mp4")
	var outlog: Array = []
	var rc := OS.execute(ffmpeg, ["-y", "-loglevel", "error", "-framerate", "30", "-i", frames_dir.path_join("f%05d.jpg"),
		"-c:v", "libx264", "-pix_fmt", "yuv420p", "-crf", "20", "-movflags", "+faststart", mp4], outlog, true)
	if rc != 0 or not FileAccess.file_exists(mp4):
		print("THEATRE_FILM FAIL ffmpeg rc=%d %s (frames kept in %s)" % [rc, " ".join(outlog), frames_dir])
		return
	for f in n:
		DirAccess.remove_absolute(frames_dir.path_join("f%05d.jpg" % f))
	DirAccess.remove_absolute(frames_dir)
	print("THEATRE_FILM done " + mp4)


## Every bone of the women as drawn this frame (after GrapplePose ran), world space.
func _watch(skel: Skeleton3D, who: int) -> void:
	var ids := {}
	for b in BONES:
		ids[b] = skel.find_bone(b)
	skel.skeleton_updated.connect(func() -> void:
		var d := {}
		var gt := skel.global_transform
		for b in BONES:
			if int(ids[b]) >= 0:
				d[b] = gt * skel.get_bone_global_pose(int(ids[b])).origin
		_cache[who] = d)


## One-frame steps, jerk and flips of the tracked bones over frames [a, b): p95 step, the worst step and where.
func _steps(tracks: Array, a: int, b: int) -> Dictionary:
	var st := PackedFloat32Array()
	var jerks := PackedFloat32Array()
	var worst := 0.0
	var worst_at := ""
	var flips := 0
	for w in 2:
		for k in TRACK.size():
			var p: Array = tracks[w][k]
			for i in range(maxi(a, 1), mini(b, p.size())):
				var s: float = (p[i] as Vector3).distance_to(p[i - 1])
				st.append(s)
				if s > worst:
					worst = s
					worst_at = "%s %s %.2f s" % [WHO[w], TRACK[k], i / FPS]
				if i >= 3:
					var j3: Vector3 = (p[i] as Vector3) - 3.0 * (p[i - 1] as Vector3) + 3.0 * (p[i - 2] as Vector3) - (p[i - 3] as Vector3)
					jerks.append(j3.length() * FPS * FPS * FPS)
				if i >= 2:
					var v0: Vector3 = (p[i - 1] as Vector3) - (p[i - 2] as Vector3)
					var v1: Vector3 = (p[i] as Vector3) - (p[i - 1] as Vector3)
					if v0.length() > V_MIN and v1.length() > V_MIN and v0.dot(v1) < 0.0:
						flips += 1
	st.sort()
	jerks.sort()
	var secs := maxf(1.0 / FPS, (b - a) / FPS)
	return {"p95": st[int(st.size() * 0.95)] if st.size() > 0 else 0.0, "worst": worst, "worst_at": worst_at,
		"jerk_p95": jerks[int(jerks.size() * 0.95)] if jerks.size() > 0 else 0.0, "flips_s": flips / (2.0 * TRACK.size()) / secs}


## The deepest part of one woman inside the other's pelvis or trunk this frame (both ways), metres.
func _overlap() -> float:
	var worst := 0.0
	for w in 2:
		var me: Dictionary = _cache[w]
		var other: Dictionary = _cache[1 - w]
		if me.is_empty() or other.is_empty():
			continue
		for tc in TORSO:
			for p in PARTS:
				var cp := Geometry3D.get_closest_points_between_segments(me[p[0]], me[p[1]], other[tc[0]], other[tc[1]])
				worst = maxf(worst, float(p[2]) + float(tc[2]) - cp[0].distance_to(cp[1]))
	return worst
