extends SceneTree
## S383 OWNED MOCAP: the kept takes (ops/research/OWNED_MOCAP_S381.md, its OWNED_KEPT lines) as baked by
## tools/owned_mocap_bake.gd. Each kept .res loads, carries the template's tracks (the 25 bones of mc_Box1_M3_Idle: 25
## rotation tracks + the Hips offset), is as long as the doc says, holds no NaN, and no plant of either foot slides past
## the doc's bar (tools/owned_mocap_measure.gd: plant = ball within 2.5 cm of its floor and < 0.25 m/s, slide = how far
## the ball gets from where the plant began) - on the body the takes are fitted to (mh_boxer_08, a man).
## S383 eyes check: every OWNED_DROPPED take in the doc is gone from the baked folder (no dropped clip ships), and no
## take is both kept and dropped.

const Measure := preload("res://tools/owned_mocap_measure.gd")
const DOC := "res://ops/research/OWNED_MOCAP_S381.md"
const TEMPLATE := "res://assets/anim/baked/mc_Box1_M3_Idle.res"
const DIR := "res://assets/anim/baked/owned/"

var checks := 0
var failures := 0


func _initialize() -> void:
	var kept := _rows("OWNED_KEPT ")
	_check(kept.size() >= 1, "the doc lists at least one kept take (%d)" % kept.size())
	var kept_names := kept.map(func(r): return str(r["take"]))
	var dropped := _rows("OWNED_DROPPED ")
	_check(dropped.size() >= 1, "the doc lists the dropped takes (%d)" % dropped.size())
	for row in dropped:
		var stem := str(row["take"])
		_check(not FileAccess.file_exists(DIR + stem + ".res"), "dropped %s has no .res in %s" % [stem, DIR])
		_check(not kept_names.has(stem), "%s is not both kept and dropped" % stem)
	var tmpl := load(TEMPLATE) as Animation
	var want := {}
	for t in tmpl.get_track_count():
		want["%s|%d" % [tmpl.track_get_path(t), tmpl.track_get_type(t)]] = true
	var bones := {}
	for k in want:
		bones[str(k).get_slice("|", 0)] = true
	_check(bones.size() == 25, "the template drives 25 bones (%d)" % bones.size())
	var rig := Measure.rig_for("mh_boxer_08")
	root.add_child(rig["body"])
	for row in kept:
		var stem := str(row["take"])
		var anim := load(DIR + stem + ".res") as Animation
		_check(anim != null, "%s.res loads" % stem)
		if anim == null:
			continue
		var have := {}
		for t in anim.get_track_count():
			have["%s|%d" % [anim.track_get_path(t), anim.track_get_type(t)]] = true
		_check(have.size() == want.size() and have.keys().all(func(x): return want.has(x)),
			"%s carries the template's %d tracks (%d)" % [stem, want.size(), have.size()])
		_check(absf(anim.length - float(row["secs"])) < 0.02, "%s is %.2f s as the doc says (%.2f)" % [stem, float(row["secs"]), anim.length])
		var d := Measure.sample(anim, rig)
		_check(not d["nan"], "%s holds no NaN key" % stem)
		var st := Measure.stats(d, 0, -1, {})
		_check(st["slide_max"] <= float(row["slide_bar_cm"]),
			"%s: no plant slides past %.1f cm (max %.1f over %d plants)" % [stem, float(row["slide_bar_cm"]), st["slide_max"], st["plants"]])
	print("OWNED_MOCAP checks=%d failures=%d" % [checks, failures])
	quit(1 if failures > 0 else 0)


## OWNED_KEPT <take> secs=<s> slide_bar_cm=<cm>  /  OWNED_DROPPED <take> why=<word>
func _rows(prefix: String) -> Array:
	var out: Array = []
	var f := FileAccess.open(DOC, FileAccess.READ)
	if f == null:
		return out
	for line in f.get_as_text().split("\n"):
		var s := line.strip_edges()
		if not s.begins_with(prefix):
			continue
		var row := {"take": s.get_slice(" ", 1)}
		for part in s.split(" ", false):
			if part.contains("="):
				row[part.get_slice("=", 0)] = part.get_slice("=", 1)
		out.append(row)
	return out


func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failures += 1
		print("  FAIL: %s" % label)
