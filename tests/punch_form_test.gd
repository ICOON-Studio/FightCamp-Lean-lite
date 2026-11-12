extends SceneTree
## S438 CLIPFIX4 (in-house round): the punch form test. Reads punch_form.json (tools/punch_form.gd) and judges every
## clip on the brief's bars: straights elbow >= 150, hang <= 0.17 (LEAD RULING S439 R1, Ruler.HANG_MAX), other glove low <= 0.15 and far <= 0.30,
## reach_frac >= 0.92, cross hip turn >= 20; hooks elbow AT CONTACT 75-125, other glove low <= 0.15, pre-drop <= 0.25;
## uppercuts finish <= 0, pre-drop held <= 0.18 (the brief's kept raise, made for the GOOD uppercut's 0.167 from the
## collarbone; from the UpperArm joint it reads 0.100, so that reason is gone: left_uppercut's 0.267 is caught at 0.15
## or 0.18, the lead may put it back to 0.15); body shots bow_hip_m <= 0.25 (LEAD RULING S439 R5: the head over the
## lead HIP; in a lunge the knee is far forward, so head-past-knee cannot see a folded trunk), back <= 0.45. One added measure (review
## defect 10): straights' forward reach at contact (wrist from the frame-0 pelvis along facing) >= the GOOD jab_a's
## minus 0.05 m (the ruler's own band), the bar derived from the control and printed.
## A value within 2 % of its bar (either side) is ON THE LINE: printed, never a catch. LEAD RULING S439 R9: that band
## applies to the R1 hang bar (0.17: up to about 0.173 is ON THE LINE) and the R5 bow-over-the-hip bar (0.25: up to
## about 0.255) as to every other bar.
## LEAD RULING S439 R8: a clip with a fixed take is judged twice: its eye row on the ORIGINAL take (o_<clip> in the json)
## and a FIXED row on the take the game loads.
## LEAD RULING S439 R12 (replaces R8's "must clear every bar"): the FIXED row must pass the bar(s) of the fault that was
## fixed (the eye's measures) and must not be WORSE than its original take on any other bar. A fault the ORIGINAL take
## already had prints "STILL FAULTY: <clip> <bar> <fixed value> (original <value>)" and does not fail. Reason: the retime
## fixes the eye's fault (the hang) and nothing else; a clip's own other faults (pro_left_jab_c's rear glove, og_far
## 0.319 fixed / 0.321 original, bar 0.30) stay on the faulty list instead of blocking the fix. A bar the original
## passed and the fixed take fails, or a shared fault the fixed take makes further past its bar, fails. No bar changes.
## For each of the 12 faulty clips the test prints SAME / DIFFERENT / NONE: the measures that catch it against the
## measures that should see the fault the eye named (TASK_CLIPFIX2's table, below). No clip is whitelisted.
## KNOWN BLIND (LEAD RULING S439 R4): cross_a and cross_b's "short and bent" has no measure yet (PUNCHSNAP1 is the
## planned one); they print a KNOWN BLIND row and do not fail; the eye's verdict stands (they stay faulty).
## FAILS (each line says FAIL, a FINDING line says why the lead must rule): a GOOD control fails a bar; a faulty clip
## is NONE (the ruler is blind to it); a measure is out of its sane range; the json's hashes do not match the takes the
## game loads now and the clip_contact / clip_recovery rows it read (a stale json).

const DATA_PATH := "res://assets/data/punch_form.json"
const Ruler := preload("res://tools/punch_form.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const LINE_FRAC := 0.02
const FWD_MARGIN := 0.05
const STRAIGHT := {"elbow": ["elbow_deg", "min", 150.0], "hang": ["hang_s", "max", Ruler.HANG_MAX],
	"og_low": ["other_glove_low_m", "max", 0.15], "og_far": ["other_glove_far_m", "max", 0.30],
	"reach_frac": ["reach_frac", "min", 0.92]}
const BARS := {
	"jab": STRAIGHT,
	"cross": {"elbow": ["elbow_deg", "min", 150.0], "hang": ["hang_s", "max", Ruler.HANG_MAX],
		"og_low": ["other_glove_low_m", "max", 0.15], "og_far": ["other_glove_far_m", "max", 0.30],
		"reach_frac": ["reach_frac", "min", 0.92], "hip": ["hip_turn_deg", "min", 20.0]},
	"hook": {"elbow_lo": ["elbow_contact_deg", "min", 75.0], "elbow_hi": ["elbow_contact_deg", "max", 125.0],
		"og_low": ["other_glove_low_m", "max", 0.15], "pre_drop": ["pre_drop_depth_m", "max", 0.25]},
	"uppercut": {"finish": ["finish_over_head", "max", 0.0], "pre_drop_held": ["pre_drop_held_s", "max", 0.18]},
	"body": {"bow": ["bow_hip_m", "max", Ruler.BOW_HIP_MAX], "back": ["back_s", "max", 0.45]},
}
## The eye's table (TASK_CLIPFIX2) and the measures that should see each named fault.
const EYE := {
	"pro_left_jab": ["jab", "hangs at full reach about 0.33 s", ["hang"]],
	"pro_left_jab_b": ["jab", "hangs at full reach", ["hang"]],
	"pro_left_jab_c": ["jab", "hangs about 0.26 s", ["hang"]],
	"pro_right_cross": ["cross", "the lead glove is left out in front, away from the chin", ["og_far"]],
	"pro_right_cross_a": ["cross", "short and bent, never straightens, almost no hip turn", ["elbow", "reach_frac", "fwd", "hip"]],
	"pro_right_cross_b": ["cross", "short and bent, the same", ["elbow", "reach_frac", "fwd"]],
	"pro_right_cross_c": ["cross", "the lead glove drops to chest height while the cross is out", ["og_low"]],
	"pro_left_hook": ["hook", "a straight-arm swing", ["elbow_hi"]],
	"pro_left_hook_v2": ["hook", "the glove drops to the hip about 0.2 s first, then a near-straight arm", ["pre_drop", "elbow_hi"]],
	"pro_left_uppercut": ["uppercut", "waits at the thigh about 0.26 s, finishes above her own head", ["pre_drop_held", "finish"]],
	"pro_body_shot": ["body", "a bowed lunge: head past the lead knee", ["bow"]],
	"pro_kidney_shot": ["body", "a bowed lunge, about 0.7 s to get back", ["bow", "back"]],
}
## LEAD RULING S439 R4: the eye's "short and bent" on these two has no measure yet.
const KNOWN_BLIND := {
	"pro_right_cross_a": true,
	"pro_right_cross_b": true,
}
const KNOWN_BLIND_TEXT := "KNOWN BLIND (lead ruling S439): the eye's fault 'short and bent' has no measure yet; PUNCHSNAP1 (fist speed, straighten time) is the planned measure"
const GOOD := {"pro_left_jab_a": "jab", "pro_right_uppercut": "uppercut"}

var failures := 0
var clips: Dictionary = {}
var fwd_min := 0.0


func _initialize() -> void:
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(DATA_PATH))
	if not (parsed is Dictionary and (parsed as Dictionary).get("clips") is Dictionary):
		print("FAIL %s missing or not {clips, inputs}: run tools/punch_form.gd" % DATA_PATH)
		quit(1)
		return
	clips = parsed["clips"]
	_check_fresh(parsed.get("inputs", {}))
	for clip in clips:
		_check_sane(str(clip), clips[clip])
	var jab_a: Dictionary = clips.get("pro_left_jab_a", {})
	fwd_min = float(jab_a.get("forward_m", 0.0)) - FWD_MARGIN
	print("BAR fwd_min %.3f = GOOD jab_a forward %.3f - %.2f" % [fwd_min, float(jab_a.get("forward_m", 0.0)), FWD_MARGIN])
	for clip in GOOD:
		var res: Dictionary = _judge(clip, GOOD[clip])
		if (res["catches"] as Array).is_empty():
			print("PASS GOOD %s clears every bar%s" % [clip, _line_note(res)])
		else:
			failures += 1
			print("FAIL FINDING GOOD %s fails %s - the bar may be wrong for this measure: the lead decides the bar" % [clip, ", ".join(res["catch_text"])])
	for clip in EYE:
		var row: Array = EYE[clip]
		# LEAD RULING S439 R8: a clip with a fixed take is judged in two rows - the eye's row on its ORIGINAL take
		# (o_<clip>, the ruler must still catch the eye's fault there) and a FIXED row on the take the game loads,
		# judged by R12 (_judge_fixed): the fixed fault's bars pass, no other bar worse than the original.
		var fixed: bool = Ruler.has_fixed(clip)
		var eye_name: String = "o_" + clip if fixed else clip
		if fixed:
			_judge_fixed(clip, row[0], row[2])
		var res: Dictionary = _judge(eye_name, row[0])
		var eye_set: Array = row[2]
		var caught: Array = res["catches"]
		var same: Array = caught.filter(func(c): return eye_set.has(c))
		var verdict := "NONE"
		if same.size() > 0:
			verdict = "SAME"
		elif caught.size() > 0:
			verdict = "DIFFERENT"
		var eye_vals: Array = []
		for mname in eye_set:
			eye_vals.append(str(res["text"].get(mname, mname + " n/a")))
		print("EYE_VS_RULER %s%s | eye: %s | eye's measures: %s | catches: %s | on the line: %s | %s %d/%d" % [clip,
			" (ORIGINAL take %s, lead ruling S439)" % eye_name if fixed else "", row[1],
			"; ".join(eye_vals), ", ".join(res["catch_text"]) if caught.size() > 0 else "none",
			", ".join(res["line_text"]) if (res["line_text"] as Array).size() > 0 else "none", verdict, same.size(), eye_set.size()])
		if row[0] == "body":
			print("INFO %s bow_hip_m %.3f (head over the lead HIP joint, the bar's measure) - bow_m (head over the lead KNEE, no bar) %.3f" % [
				clip, float(clips[clip].get("bow_hip_m", NAN)), float(clips[clip].get("bow_m", NAN))])
		if KNOWN_BLIND.has(clip):
			print("%s | %s | verdict %s" % [KNOWN_BLIND_TEXT, clip, verdict])
		elif verdict == "NONE":
			failures += 1
			print("FAIL FINDING RULER_BLIND %s: no bar catches it%s; the eye named: %s" % [clip,
				" on its original take" if fixed else "", row[1]])
		elif verdict == "DIFFERENT":
			print("FINDING RULER_DIFFERENT %s: caught on %s, not on the eye's fault (%s)" % [clip, ", ".join(caught), row[1]])
	var hk: Dictionary = clips.get("pro_right_hook", {})
	print("UNCLEAR pro_right_hook %s" % JSON.stringify(hk, "", true))
	print("PUNCH_FORM failures=%d" % failures)
	quit(1 if failures > 0 else 0)


## LEAD RULING S439 R12: the fixed take (the one the game loads) is judged against its ORIGINAL take (o_<clip>), bar by
## bar. Reason: the retime fixes the eye's fault and nothing else, so a fault the original already had must not block
## the fix, while the fix must neither leave the eye's fault nor make the clip worse anywhere.
##  - a bar of the fault that was fixed (the eye's measures, EYE[clip][2]) caught on the fixed take: FAIL;
##  - any other bar caught on the fixed take and NOT caught on the original: FAIL (the fix made it worse);
##  - any other bar caught on both, the fixed value further past the bar than the original's: FAIL (worse);
##  - any other bar caught on both, the fixed value no further past: STILL FAULTY line, no failure (the clip stays on
##    the faulty list for it, e.g. pro_left_jab_c's rear glove og_far 0.319 fixed / 0.321 original, bar 0.30).
## ON THE LINE is not a catch, as everywhere. Prints the R10 extension hold, original against fixed (no bar).
func _judge_fixed(clip: String, kind: String, fixed_bars: Array) -> void:
	var o_name: String = "o_" + clip
	if not clips.has(o_name):
		failures += 1
		print("FAIL %s has a fixed take but no %s row (its original): re-run tools/punch_form.gd" % [clip, o_name])
		return
	var res: Dictionary = _judge(clip, kind)
	var orig: Dictionary = _judge(o_name, kind, true)
	var bad: Array = []
	var still: Array = []
	for mname in res["catches"]:
		var v: float = float(res["values"][mname])
		var ov: float = float(orig["values"].get(mname, NAN))
		var b: Array = res["bars"][mname]
		var worse: bool = v > ov if b[1] == "max" else v < ov
		if fixed_bars.has(mname):
			bad.append("%s %.3f (the fault that was fixed; original %.3f)" % [mname, v, ov])
		elif not (orig["catches"] as Array).has(mname):
			bad.append("%s %.3f (original %.3f passed: the fix made it worse)" % [mname, v, ov])
		elif worse:
			bad.append("%s %.3f (original %.3f: further past the bar %.3f, worse)" % [mname, v, ov, float(b[2])])
		else:
			still.append(mname)
			print("STILL FAULTY: %s %s %.3f (original %.3f) - LEAD RULING S439 R12: the original's own fault, not the fix; stays on the faulty list, not counted" % [clip, mname, v, ov])
	if bad.is_empty():
		print("PASS FIXED (lead ruling S439 R12) %s: the fixed take passes the fixed fault's bar%s (%s) and is no worse than its original on any other bar%s%s" % [
			clip, "s" if fixed_bars.size() > 1 else "", ", ".join(fixed_bars),
			"" if still.is_empty() else "; still faulty: " + ", ".join(still), _line_note(res)])
	else:
		failures += 1
		print("FAIL FIXED (lead ruling S439 R12) %s: %s" % [clip, "; ".join(bad)])
	print("INFO EXTENSION_HOLD %s original %.3f s -> fixed %.3f s (3D hand to UpperArm joint within 0.05 m of its peak; R10, a number for the eye and PUNCHSNAP1, no bar)" % [
		clip, float(clips[o_name].get("ext_hold_s", NAN)), float(clips[clip].get("ext_hold_s", NAN))])


## Every bar of the clip's kind (plus fwd for straights): PASS / LINE / FAIL rows and the catches (FAIL only).
func _judge(clip: String, kind: String, quiet := false) -> Dictionary:
	var m: Dictionary = clips.get(clip, {})
	var catches: Array = []
	var catch_text: Array = []
	var line_text: Array = []
	var text := {}
	var values := {}
	if m.is_empty():
		failures += 1
		print("FAIL %s MISSING from the json" % clip)
		return {"catches": catches, "catch_text": catch_text, "line_text": line_text, "text": text, "values": values, "bars": {}}
	var bars: Dictionary = (BARS[kind] as Dictionary).duplicate()
	if kind in ["jab", "cross"]:
		bars["fwd"] = ["forward_m", "min", fwd_min]
	for mname in bars:
		var b: Array = bars[mname]
		var v: float = float(m.get(b[0], NAN))
		var bar: float = float(b[2])
		var over: bool = v > bar if b[1] == "max" else v < bar
		var on_line: bool = absf(v - bar) <= LINE_FRAC * absf(bar)
		var status := "LINE" if on_line else ("FAIL" if over else "PASS")
		var desc := "%s %.3f %s %.3f" % [mname, v, "<=" if b[1] == "max" else ">=", bar]
		text[mname] = desc + (" ON THE LINE" if on_line else (" caught" if over else " passes"))
		values[mname] = v
		if not quiet:
			print("ROW %s %s %s" % [clip, desc, status])
		if on_line:
			line_text.append(desc)
			if not quiet:
				print("ON THE LINE %s %s %.4f vs %.3f (%s, not counted)" % [clip, mname, v, bar, "over" if over else "under"])
		elif over:
			catches.append(mname)
			catch_text.append(desc)
	return {"catches": catches, "catch_text": catch_text, "line_text": line_text, "text": text, "values": values, "bars": bars}


func _line_note(res: Dictionary) -> String:
	return "" if (res["line_text"] as Array).is_empty() else " (on the line: %s)" % ", ".join(res["line_text"])


func _check_sane(clip: String, m: Dictionary) -> void:
	var length: float = float(m.get("length_s", 0.0))
	var ranges := {"elbow_deg": [0.0, 180.0], "elbow_contact_deg": [0.0, 180.0], "hang_s": [0.0, length],
		"other_glove_low_m": [0.0, 1.0], "other_glove_far_m": [0.0, 1.0], "pre_drop_depth_m": [0.0, 1.0],
		"pre_drop_held_s": [0.0, length], "finish_over_head": [-1.0, 1.0], "bow_m": [-1.0, 1.0], "bow_hip_m": [-1.0, 1.0],
		"hip_turn_deg": [0.0, 90.0], "reach_frac": [0.3, 1.05], "forward_m": [-1.0, 2.0], "ext_hold_s": [0.0, length]}
	for k in ranges:
		var v: float = float(m.get(k, NAN))
		var r: Array = ranges[k]
		if not (v >= float(r[0]) and v <= float(r[1])):
			failures += 1
			print("FAIL sane %s %s %.4f not in [%.3f, %.3f]" % [clip, k, v, r[0], r[1]])
	var back: float = float(m.get("back_s", NAN))
	if not (back == -1.0 or (back >= 0.0 and back <= length)):
		failures += 1
		print("FAIL sane %s back_s %.4f not -1 or in [0, %.3f]" % [clip, back, length])


## The json must have been written from the takes the game loads NOW and from the rows it reads now (hashes).
func _check_fresh(inputs: Dictionary) -> void:
	var contact_doc: Dictionary = Ruler.read_json(BeatClips.CONTACT_PATH)
	var recovery_doc: Dictionary = Ruler.read_json(BeatClips.RECOVERY_PATH)
	var stale := 0
	for clip in clips:
		var inp: Dictionary = inputs.get(clip, {})
		var take: String = Ruler.take_path(str(clip))
		var why: Array = []
		if str(inp.get("take", "")) != take:
			why.append("take %s, the game loads %s" % [inp.get("take", "?"), take])
		elif str(inp.get("take_md5", "")) != FileAccess.get_md5(take):
			why.append("take %s changed" % take)
		if str(inp.get("contact_row_md5", "")) != Ruler.row_md5(contact_doc.get(clip, {})):
			why.append("clip_contact row changed")
		if str(inp.get("recovery_row_md5", "")) != Ruler.row_md5(recovery_doc.get(clip, {})):
			why.append("clip_recovery row changed")
		if str(inp.get("row_md5", "")) != Ruler.row_md5(clips[clip]):
			why.append("its own measured row was edited after the ruler wrote it")
		if why.size() > 0:
			stale += 1
			failures += 1
			print("FAIL stale punch_form.json %s: %s - re-run tools/punch_form.gd last" % [clip, "; ".join(why)])
	print("FRESH punch_form.json: %d of %d clips match their takes, input rows and own rows by md5" % [clips.size() - stale, clips.size()])
