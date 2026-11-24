extends "res://tools/bodycross2_ruler.gd"
## BODYCROSS3 (S546, ops/research/TASK_BODYCROSS3.md step 3): THE RULER THAT READS WHAT THE OWNER LOOKS AT. His mark on
## BODYCROSS2's own sheet (C502): "there is no elbow bent , the reaction should force the opponent to bend hisposture a
## bit". BODYCROSS2's ruler read the elbow in 3D on ONE key (142.7 deg, gone 0.04 s later) and a fold of 7-8 deg. This one
## reads THE SHEET'S OWN TWELVE PICTURES - the film's pair, distance and fixed side camera, every picture from
## SHEET_BEFORE before the touch to SHEET_AFTER after it - and prints, a picture:
##   elbow   the puncher's shoulder - elbow - wrist angle AS SEEN (projected on the side camera's screen; 3D beside it)
##   glove   the glove front to the hit man's trunk surface as drawn (under 0 = in it)
##   fold    the hit man's hips - neck line against upright AS SEEN (+ = bent toward the puncher) and how far that has
##           changed since the touch picture (the fold the blow makes)
##   hips    his hips' travel away since the touch
## Bars (each beside its study in docs/BODYCROSS3_RESULT.md):
##   BENT WHERE HE LOOKS  elbow as seen <= ELBOW_TOUCH_MAX on the first on-body picture (K52: amateurs 137 +/- 12), never
##     over ELBOW_LATER_MAX on a later picture of the sheet, BENT_PICS pictures on his body with the elbow <= ELBOW_BENT
##   STILL A PUNCH        BODYCROSS2's speed, time and past-the-surface bars (G75, K54), read by its own _measure
##   HE BENDS             the fold is FOLD_MIN..FOLD_MAX deg within FOLD_S of the touch (REACT_FOLD_S: the fold arrives
##     0.17 s after the glove), FOLD_PICS sheet pictures after the touch show FOLD_SHOWN or more, he is not back within
##     UPRIGHT_DEG of his touch posture sooner than UPRIGHT_MIN_S, his hips go back HIPS_BACK_M or more
##   <godot> --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tools/bodycross3_ruler.gd -- <out_dir> set=m|w [who=0|1] [take=pro_body_cross] [react=game|<take>] [from=<s>] [old=<res> row=<json>] [tag=<t>]
## Prints BC3 rows, one line a bar and BODYCROSS3_RULER GREEN|RED; writes <out_dir>/ruler3_<set>_<tag>.json and .md. Exit 0 either way.

const SHEET_BEFORE := 3
const SHEET_AFTER := 8
const ON_BODY_M := 0.01
const ELBOW_TOUCH_MAX := 150.0
const ELBOW_LATER_MAX := 160.0
const ELBOW_BENT := 155.0
const BENT_PICS := 3
const FOLD_MIN := 12.0
const FOLD_MAX := 25.0
const FOLD_S := 0.15
const FOLD_SHOWN := 10.0
const FOLD_PICS := 3
const UPRIGHT_DEG := 5.0
const UPRIGHT_MIN_S := 0.40
const HIPS_BACK_M := 0.05
const SPEED_BARS := 6         # BODYCROSS2's bars 0-5: reach, past, speed x 3, first move


func _initialize() -> void:
	if not await _setup():
		return
	_watch()
	var set_name := _arg("set", "m")
	var who := int(_arg("who", "1" if set_name == "m" else "0"))   # the films: men, blue throws; women, red throws
	var clip := _arg("take", "pro_body_cross")
	var react := _arg("react", "game")
	react_from = float(_arg("from", "-1"))
	if _arg("old", "") != "":
		clip = OLD_NAME if _adopt(_arg("old", ""), _arg("row", ""), OLD_NAME, clip) else clip
	if not (stage.boxers[who]["ap"] as AnimationPlayer).has_animation(clip):
		print("BODYCROSS3_RULER RED no take %s" % clip)
		quit(0)
		return
	var run := await _play_out(who, clip, true, react)
	var m := _measure(who, run)
	m["set"] = set_name
	m["take"] = clip
	m["as"] = "own"
	m["react"] = str((run["react"] as Dictionary).get("clip", react))
	m["react_from_s"] = float((run["react"] as Dictionary).get("from_s", 0.0))
	_say(m)
	var s := _sheet(who, run, m)
	var tag := _arg("tag", "own")
	var fh := FileAccess.open(out_dir.path_join("ruler3_%s_%s.json" % [set_name, tag]), FileAccess.WRITE)
	fh.store_string(JSON.stringify(s, "  "))
	fh.close()
	_md(m, out_dir.path_join("ruler_%s_%s.md" % [set_name, tag]))
	_md3(s, out_dir.path_join("ruler3_%s_%s.md" % [set_name, tag]))
	quit(0)


## An angle at k between a and b as the side camera sees it (the part along the camera's line of sight dropped).
static func _seen(a: Vector3, k: Vector3, b: Vector3, view: Vector3) -> float:
	var u := a - k
	var v := b - k
	u -= view * u.dot(view)
	v -= view * v.dot(view)
	return rad_to_deg(u.angle_to(v))


## The hit man's hips - neck line against upright on the screen, deg (+ = toward the puncher).
func _lean(s: Dictionary, d: int, dirv: Vector3) -> float:
	var t := _at(s, d, "Neck") - _at(s, d, "Hips")
	return rad_to_deg(atan2(t.dot(-dirv), t.y))


func _sheet(who: int, run: Dictionary, m: Dictionary) -> Dictionary:
	var d := 1 - who
	var fr: Array = run["frames"]
	var ci: int = m["ci"]
	var hand: String = run["hand"]
	var side := hand.trim_suffix("Hand")
	var dirv: Vector3 = run["dirv"]
	var view := _view()
	var lean0 := _lean(fr[ci]["def"], d, dirv)
	var h0 := _at(fr[ci]["def"], d, "Hips")
	var rows: Array = []
	var fold_in := 0.0          # the most within FOLD_S
	var fold_most := 0.0
	var fold_most_s := 0.0
	var at_s := {}              # the fold 0.05 / 0.10 / 0.15 s after the touch
	var hips_in := 0.0
	var hips_most := 0.0
	var up_s := -1.0            # when he is back within UPRIGHT_DEG after the fold's most
	var shown := 0
	var bent := 0
	var later_max := 0.0
	var curve: Array = []       # every picture from the touch: [fold deg, hips back m]
	for k in range(maxi(ci - SHEET_BEFORE, 0), fr.size()):
		var a: Dictionary = fr[k]["thr"]
		var b: Dictionary = fr[k]["def"]
		var f := k - ci
		var dt := float(f) / 60.0
		var lean := _lean(b, d, dirv)
		var fold := lean - lean0
		var hb := ((_at(b, d, "Hips") - h0) * Vector3(1, 0, 1)).dot(dirv)
		if f > 0:
			if fold > fold_most:
				fold_most = fold
				fold_most_s = dt
				up_s = -1.0
			elif up_s < 0.0 and fold_most >= FOLD_SHOWN and fold <= UPRIGHT_DEG:
				up_s = dt
			hips_most = maxf(hips_most, hb)
			if dt <= FOLD_S + 1e-6:
				fold_in = maxf(fold_in, fold)
				hips_in = maxf(hips_in, hb)
			for q in [3, 6, 9]:
				if f == q:
					at_s[q] = fold
		if f >= 0:
			curve.append([snappedf(fold, 0.1), _r3(hb)])
		if f > SHEET_AFTER:
			continue
		var sh := _at(a, who, side + "UpperArm")
		var el := _at(a, who, side + "LowerArm")
		var wr := _at(a, who, side + "Hand")
		var seen := _seen(sh, el, wr, view)
		var gap := float(_surf_dist(_surf_pose(b), a["gl"][hand])[0])
		var on := gap <= ON_BODY_M
		if on and seen <= ELBOW_BENT:
			bent += 1
		if f > 0:
			later_max = maxf(later_max, seen)
			if fold >= FOLD_SHOWN:
				shown += 1
		rows.append({"pic": rows.size() + 1, "f": f, "take_s": _r3(float(fr[k]["pos"])), "elbow_seen_deg": snappedf(seen, 0.1),
			"elbow_3d_deg": snappedf(rad_to_deg((sh - el).angle_to(wr - el)), 0.1), "gap_m": _r3(gap), "on_body": on,
			"lean_deg": snappedf(lean, 0.1), "fold_deg": snappedf(fold, 0.1), "hips_back_m": _r3(hb), "heads_m": _r3(_heads(a, b, who))})
	var touch: Dictionary = rows[mini(SHEET_BEFORE, rows.size() - 1)]
	var s := {"set": m["set"], "take": m["take"], "react": m["react"], "react_from_s": m["react_from_s"], "rows": rows, "pair_hips_m": m["pair_hips_m"],
		"touched": bool(m["touched"]), "elbow_touch_deg": touch["elbow_seen_deg"], "elbow_later_max_deg": snappedf(later_max, 0.1), "bent_pics": bent,
		"fold_in_deg": snappedf(fold_in, 0.1), "fold_most_deg": snappedf(fold_most, 0.1), "fold_most_s": _r3(fold_most_s), "fold_shown_pics": shown,
		"fold_005": snappedf(float(at_s.get(3, 0.0)), 0.1), "fold_010": snappedf(float(at_s.get(6, 0.0)), 0.1), "fold_015": snappedf(float(at_s.get(9, 0.0)), 0.1),
		"hips_in_m": _r3(hips_in), "hips_most_m": _r3(hips_most), "upright_s": _r3(up_s), "lean_touch_deg": snappedf(lean0, 0.1), "curve": curve}
	print("BC3 %s set %s; the hit man plays %s from %.3f s; hips %.3f m apart in the guard" % [s["take"], s["set"], s["react"], s["react_from_s"], s["pair_hips_m"]])
	print("BC3 sheet  pic  take_s  elbow as seen (3D)  glove-to-body  on body  his lean  his fold  hips back  head to the other's trunk (the picture gate's %.2f)" % Gate.HEAD_CLEAR_M)
	for r in rows:
		print("BC3 %3d (%+d)  %6.3f  %6.1f deg (%5.1f)  %7.3f m  %-3s  %6.1f deg  %6.1f deg  %6.3f m  %6.3f m" % [r["pic"], r["f"], r["take_s"], r["elbow_seen_deg"], r["elbow_3d_deg"], r["gap_m"], "yes" if r["on_body"] else "no", r["lean_deg"], r["fold_deg"], r["hips_back_m"], r["heads_m"]])
	print("BC3_REACT %s from %.3f s: fold as seen %.1f / %.1f / %.1f deg at +0.05 / +0.10 / +0.15 s, most %.1f deg at +%.3f s; hips back %.3f m in %.2f s, %.3f m most; %s" % [
		s["react"], s["react_from_s"], s["fold_005"], s["fold_010"], s["fold_015"], s["fold_most_deg"], s["fold_most_s"], s["hips_in_m"], FOLD_S, s["hips_most_m"],
		"never folded %.0f deg" % FOLD_SHOWN if fold_most < FOLD_SHOWN else ("not upright again in %.1f s" % (AFTER_F / 60.0) if up_s < 0.0 else "upright again after %.3f s" % up_s)])
	var bars: Array = [
		["BENT: elbow as seen <= %d deg on the first on-body picture" % int(ELBOW_TOUCH_MAX), bool(s["touched"]) and float(s["elbow_touch_deg"]) <= ELBOW_TOUCH_MAX, "%.1f deg" % float(s["elbow_touch_deg"])],
		["BENT: never over %d deg on a later picture of the sheet" % int(ELBOW_LATER_MAX), later_max <= ELBOW_LATER_MAX, "most %.1f deg" % later_max],
		["BENT: %d pictures on his body with the elbow <= %d deg" % [BENT_PICS, int(ELBOW_BENT)], bent >= BENT_PICS, "%d pictures" % bent],
		["HE BENDS: fold %d-%d deg within %.2f s" % [int(FOLD_MIN), int(FOLD_MAX), FOLD_S], fold_in >= FOLD_MIN and fold_in <= FOLD_MAX, "%.1f deg" % fold_in],
		["HE BENDS: %d sheet pictures after the touch show %d deg or more" % [FOLD_PICS, int(FOLD_SHOWN)], shown >= FOLD_PICS, "%d pictures" % shown],
		["HE BENDS: not upright again before %.1f s" % UPRIGHT_MIN_S, fold_most >= FOLD_SHOWN and (up_s < 0.0 or up_s >= UPRIGHT_MIN_S), "never folded" if fold_most < FOLD_SHOWN else ("not in %.1f s" % (AFTER_F / 60.0) if up_s < 0.0 else "after %.3f s" % up_s)],
		["HE BENDS: his hips go back %.2f m or more" % HIPS_BACK_M, hips_most >= HIPS_BACK_M, "%.3f m" % hips_most],
	]
	var old: Array = m["bars"]
	for k in mini(SPEED_BARS, old.size()):
		bars.append(["STILL A PUNCH: " + str(old[k]["bar"]), bool(old[k]["pass"]), str(old[k]["read"])])
	var red := 0
	var out: Array = []
	for b in bars:
		print("BC3_BAR %s  %s: %s" % ["PASS" if b[1] else "FAIL", b[0], b[2]])
		out.append({"bar": b[0], "pass": b[1], "read": b[2]})
		red += 0 if b[1] else 1
	s["bars"] = out
	s["verdict"] = "GREEN" if red == 0 else "RED"
	print("BODYCROSS3_RULER %s %s set %s (%d of %d bars failed)" % [s["verdict"], s["take"], s["set"], red, bars.size()])
	return s


func _md3(s: Dictionary, path: String) -> void:
	var txt := "%s, set %s, the hit man plays %s from %.3f s - %s\n\n| Picture | Elbow as seen (3D) | Glove to his body m | His fold deg (lean) | His hips back m | Head to the other's trunk m |\n|---|---|---|---|---|---|\n" % [s["take"], s["set"], s["react"], s["react_from_s"], s["verdict"]]
	for r in s["rows"]:
		txt += "| %d (%+d) | %.1f (%.1f) | %.3f%s | %.1f (%.1f) | %.3f | %.3f |\n" % [r["pic"], r["f"], r["elbow_seen_deg"], r["elbow_3d_deg"], r["gap_m"], " on" if r["on_body"] else "", r["fold_deg"], r["lean_deg"], r["hips_back_m"], r["heads_m"]]
	txt += "\n| Bar | Read | |\n|---|---|---|\n"
	for b in s["bars"]:
		txt += "| %s | %s | %s |\n" % [b["bar"], b["read"], "pass" if b["pass"] else "FAIL"]
	var fh := FileAccess.open(path, FileAccess.WRITE)
	fh.store_string(txt)
	fh.close()
