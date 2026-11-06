extends "res://tools/body_react_probe.gd"
## S393 FOLD probe (both blind judges: "her face stays sunk in the other's torso"): three live rounds on the bones as shown.
## Per frame, one boxer's head against the other's trunk, as capsules: gap < 0 is a head sunk in a body. Reports frames,
## spells, the longest spell, and which clips the owner of the head and the other boxer were playing, so the cause has a name.
##   <godot.exe> --headless --audio-driver Dummy --path . --fixed-fps 30 --script res://tools/fold_probe.gd -- show3d

const HEAD_RADIUS := 0.11
const TRUNK_RADIUS := 0.15
const HEAD_ABOVE_M := 0.08
const PITCHED_DEG := 35.0
const SPELL_MIN_F := 6   # 0.2 s: long enough for a judge to see

var _frames := 0
var _sunk := 0
var _heads := 0
var _pitched := 0
var _run := [0, 0]
var _spells := 0
var _long_spells := 0
var _longest := 0
var _by_own := {}
var _by_other := {}
var _by_pitch := {}
var _worst := 0.0


func _sample() -> void:
	super._sample()
	for i in 2:
		var me: Array = history[i]
		var them: Array = history[1 - i]
		if me.is_empty() or them.is_empty():
			continue
		var a: Dictionary = me[me.size() - 1]
		var b: Dictionary = them[them.size() - 1]
		if not (a.has("Head") and a.has("Chest") and a.has("Hips") and b.has("Neck") and b.has("Hips") and b.has("Head")):
			continue
		_frames += 1
		var head: Vector3 = a["Head"] + Vector3.UP * HEAD_ABOVE_M
		var on := Geometry3D.get_closest_point_to_segment(head, b["Hips"], b["Neck"])
		var gap := head.distance_to(on) - HEAD_RADIUS - TRUNK_RADIUS
		var head_b: Vector3 = b["Head"] + Vector3.UP * HEAD_ABOVE_M
		if i == 0 and head.distance_to(head_b) < 2.0 * HEAD_RADIUS:
			_heads += 1
		var pitch := rad_to_deg(((a["Chest"] as Vector3) - (a["Hips"] as Vector3)).angle_to(Vector3.UP))
		if pitch >= PITCHED_DEG:
			_pitched += 1
			_by_pitch[str(a["clip"])] = int(_by_pitch.get(str(a["clip"]), 0)) + 1
		if gap < 0.0:
			_sunk += 1
			_worst = minf(_worst, gap)
			_run[i] = int(_run[i]) + 1
			_by_own[str(a["clip"])] = int(_by_own.get(str(a["clip"]), 0)) + 1
			_by_other[str(b["clip"])] = int(_by_other.get(str(b["clip"]), 0)) + 1
		elif int(_run[i]) > 0:
			_close_spell(i)


func _close_spell(i: int) -> void:
	_spells += 1
	_longest = maxi(_longest, int(_run[i]))
	if int(_run[i]) >= SPELL_MIN_F:
		_long_spells += 1
	_run[i] = 0


func _top(by: Dictionary, n: int) -> String:
	var rows: Array = []
	for k in by:
		rows.append([int(by[k]), str(k)])
	rows.sort_custom(func(x, y): return int(x[0]) > int(y[0]))
	var out: Array = []
	for r in rows.slice(0, n):
		out.append("%s %d" % [r[1], r[0]])
	return ", ".join(out)


func _report() -> void:
	print("FOLD frames %d, head sunk in a trunk %d (%.2f%%), deepest %.2f m" % [_frames, _sunk, 100.0 * _sunk / maxf(_frames, 1.0), _worst])
	print("FOLD heads inside each other: %d frames" % _heads)
	print("FOLD spells %d, of 0.2 s or more %d, longest %.2f s" % [_spells, _long_spells, _longest / 30.0])
	print("FOLD trunk past %d deg: %d frames (%.2f%%)" % [int(PITCHED_DEG), _pitched, 100.0 * _pitched / maxf(_frames, 1.0)])
	print("FOLD head's owner plays: ", _top(_by_own, 8))
	print("FOLD the other plays: ", _top(_by_other, 8))
	print("FOLD pitched on: ", _top(_by_pitch, 8))
	var fh := FileAccess.open("E:/FightCamp/tmp/s393/fold_last.txt", FileAccess.WRITE)
	if fh != null:
		fh.store_line("frames %d sunk %d (%.2f%%) deepest %.2f | spells %d long %d longest %.2f s | pitched %d (%.2f%%)" % [_frames, _sunk, 100.0 * _sunk / maxf(_frames, 1.0), _worst, _spells, _long_spells, _longest / 30.0, _pitched, 100.0 * _pitched / maxf(_frames, 1.0)])
		fh.store_line("heads in heads %d" % _heads)
		fh.store_line("own: " + _top(_by_own, 10))
		fh.store_line("other: " + _top(_by_other, 10))
		fh.store_line("pitch: " + _top(_by_pitch, 10))
	super._report()
