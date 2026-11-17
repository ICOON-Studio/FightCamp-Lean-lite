extends RefCounted
## HEADSPLIT1: a ruler that splits every head jump into the part of the body that moved it, and compares two
## films only over the part where both men do the same thing.
## Pure static analyser over shown.csv rows (every value a String). ZERO preloads.
## S507: "head jumps 77 -> 91" between two films was mostly a DIFFERENT BOUT - the films play the same clips
## frame for frame only until ~48 s, then drift. So jumps are counted per clip kind (a rate per punch clip and
## per reaction clip, never per film), and shared_until() finds the frame where the two films part company.
## A JUMP is the head's world travel between two CONSECUTIVE frames of ONE boxer over JUMP_CM. It is split
## into four offsets, each read against its own parent, so a root slide is not blamed on the neck:
##   root_cm  = node                 (the whole man sliding)
##   hips_cm  = Hips - node          (the hips on the root)
##   trunk_cm = UpperChest - Hips    (the back bending)
##   neck_cm  = Head - UpperChest    (the head on the chest)
## Each is the length of the CHANGE in that offset vector, in cm. They are not a partition of head_cm and need
## not sum to it: a segment turning about its parent swings the head sideways while its own length barely moves.
## Kind words and the 12 cm gate mirror tools/fight_motion_rulers.py (JUMP_M, PUNCH_WORDS, REACT_PREFIX).
## A CLIP START is a row whose clip differs from that boxer's previous row. The first row of a boxer has no
## previous row, so it is not a start. Starts do not need consecutive frames; jumps do.
## Medians are true medians - the mean of the two middle values on an even count, as statistics.median.
## S508: every jump also says WHEN in the punch it falls. since_contact counts the frames from that boxer's
## most recent CONTACT START (hold 0 -> 1, as contacts() in tools/fight_motion_rulers.py) to row b, and only
## while her clip has not changed since it: -1 when the current clip holds no contact. phase is pre / contact /
## post / late on a punch clip, none on any other kind - the hold runs from the punch's start to ~10 frames
## after contact, so a post jump is one the held-glove trunk cap can still be blamed for.
## S509: a punch clip cuts soon after contact, so the next punch of a COMBO used to read pre. since_prev_hit
## dates a jump from her most recent contact start on a PUNCH clip, counted across clip changes (-1 when she
## has not landed one); a contact start on a reaction clip - her own hold rows while she is hit - never counts.
## A pre jump 1..POST_FRAMES after that hit is phase combo: the second punch coming off the first hit.

const JUMP_CM := 12.0
const REACT_PREFIXES := ["pro_hit", "react_", "mc_hit"]
const PUNCH_WORDS := ["jab", "cross", "hook", "uppercut", "body_shot", "kidney"]
const WORST_N := 5
const NO_LIMIT := -1
## Frames after contact still counted as post - mirrors STEP_WINDOW in tools/fight_motion_rulers.py.
const POST_FRAMES := 12
const PHASES := ["pre", "combo", "contact", "post", "late", "none"]


## "jumps" is the count, "jump_list" holds one dictionary per jump. until_frame (NO_LIMIT = the whole film)
## counts only jumps and starts whose row b frame is < until_frame - the shared part of two films.
static func analyse(rows: Array, until_frame: int = NO_LIMIT) -> Dictionary:
	var out := {"jumps": 0, "jump_list": [], "by_kind": {}, "starts": {}, "per_punch": 0.0,
		"per_react": 0.0, "root_p50": 0.0, "hips_p50": 0.0, "trunk_p50": 0.0, "neck_p50": 0.0, "worst": [],
		"by_phase": _zero_phases(), "post_p50_frames": 0.0}
	if rows.is_empty():
		return out
	var grouped := _group_by_who(rows)
	var jumps := _jumps(grouped, until_frame)
	var starts := {}
	for s in _clip_starts(grouped):
		if until_frame != NO_LIMIT and int(s["frame"]) >= until_frame:
			continue
		_bump(starts, _kind(str(s["clip"])))
	var by_kind := {}
	var by_phase := _zero_phases()
	var root_vals: Array = []
	var hips_vals: Array = []
	var trunk_vals: Array = []
	var neck_vals: Array = []
	var post_vals: Array = []
	for j in jumps:
		_bump(by_kind, str(j["kind"]))
		_bump(by_phase, str(j["phase"]))
		if str(j["phase"]) == "post":
			post_vals.append(j["since_contact"])
		root_vals.append(j["root_cm"])
		hips_vals.append(j["hips_cm"])
		trunk_vals.append(j["trunk_cm"])
		neck_vals.append(j["neck_cm"])
	var punch_starts: int = int(starts.get("punch", 0))
	var react_starts: int = int(starts.get("react", 0))
	out["jumps"] = jumps.size()
	out["jump_list"] = jumps
	out["by_kind"] = by_kind
	out["starts"] = starts
	out["per_punch"] = float(int(by_kind.get("punch", 0))) / float(punch_starts) if punch_starts > 0 else 0.0
	out["per_react"] = float(int(by_kind.get("react", 0))) / float(react_starts) if react_starts > 0 else 0.0
	out["root_p50"] = _median(root_vals)
	out["hips_p50"] = _median(hips_vals)
	out["trunk_p50"] = _median(trunk_vals)
	out["neck_p50"] = _median(neck_vals)
	out["worst"] = _worst(jumps)
	out["by_phase"] = by_phase
	out["post_p50_frames"] = _median(post_vals)
	return out


## The frame where two films stop doing the same thing: their clip-start sequences (both boxers merged, in
## frame order then who) compared element by element. The first start that differs gives the EARLIER of the
## two frames. When one sequence is a prefix of the other, the last frame of the shorter film (an empty film
## has last frame 0). Equal sequences give the earlier last frame of the two.
static func shared_until(rows_a: Array, rows_b: Array) -> int:
	var sa := _clip_starts(_group_by_who(rows_a))
	var sb := _clip_starts(_group_by_who(rows_b))
	var n := mini(sa.size(), sb.size())
	for i in range(n):
		var a: Dictionary = sa[i]
		var b: Dictionary = sb[i]
		if int(a["frame"]) != int(b["frame"]) or int(a["who"]) != int(b["who"]) or str(a["clip"]) != str(b["clip"]):
			return mini(int(a["frame"]), int(b["frame"]))
	var last_a := _last_frame(rows_a)
	var last_b := _last_frame(rows_b)
	if sa.size() < sb.size():
		return last_a
	if sb.size() < sa.size():
		return last_b
	return mini(last_a, last_b)


static func _kind(clip: String) -> String:
	for p in REACT_PREFIXES:
		if clip.begins_with(p):
			return "react"
	for w in PUNCH_WORDS:
		if clip.contains(w):
			return "punch"
	return "other"


static func _group_by_who(rows: Array) -> Dictionary:
	var by_who := {}
	for r in rows:
		var w: int = int(r["who"])
		if not by_who.has(w):
			by_who[w] = []
		by_who[w].append(r)
	for w in by_who:
		by_who[w].sort_custom(func(x, y): return int(x["frame"]) < int(y["frame"]))
	return by_who


## One dictionary per jump: row b's frame, film_s, who, clip, kind and cause, the five cm numbers, and
## since_contact / since_prev_hit / phase. Rows are paired per who and only when frame b = frame a + 1 - a
## dropped frame is never a jump. Both contact counts run over the boxer's WHOLE film, so a contact before
## until_frame still dates a jump inside the shared part.
static func _jumps(grouped: Dictionary, until_frame: int) -> Array:
	var jumps: Array = []
	for who in grouped:
		var rows: Array = grouped[who]
		var since := _contact_offsets(rows)
		var prev := _prev_hit_offsets(rows)
		for i in range(1, rows.size()):
			var b: Dictionary = rows[i]
			var frame_b: int = int(b["frame"])
			if until_frame != NO_LIMIT and frame_b >= until_frame:
				continue
			var a: Dictionary = rows[i - 1]
			if int(a["frame"]) + 1 != frame_b:
				continue
			var j := _jump(a, b, who, since[i], prev[i])
			if not j.is_empty():
				jumps.append(j)
	return jumps


## Per row of ONE boxer in frame order: the frames since her most recent contact start (hold 0 -> 1) while her
## clip has not changed since it, -1 when the current clip holds none. A clip change clears the count first, so
## a contact ON the change frame belongs to the new clip. The first row has no previous row and is never a
## contact start, as contacts() in tools/fight_motion_rulers.py. A row with no hold column reads "0".
static func _contact_offsets(rows: Array) -> Array:
	var out: Array = []
	var contact := -1
	for i in range(rows.size()):
		var r: Dictionary = rows[i]
		var frame: int = int(r["frame"])
		if i > 0:
			if str(r["clip"]) != str(rows[i - 1]["clip"]):
				contact = -1
			if _contact_start(rows, i):
				contact = frame
		out.append(frame - contact if contact >= 0 else -1)
	return out


## Per row of ONE boxer in frame order: the frames since her most recent contact start on a PUNCH clip,
## counted ACROSS clip changes - the next punch of a combo is still dated by the first one's hit. -1 until
## she lands one. A contact start on any other kind never counts: a reaction clip's hold rows are her being
## hit, not her landing. The count is never cleared, so it also reaches past an idle or a reaction clip.
static func _prev_hit_offsets(rows: Array) -> Array:
	var out: Array = []
	var hit := -1
	for i in range(rows.size()):
		var r: Dictionary = rows[i]
		var frame: int = int(r["frame"])
		if _contact_start(rows, i) and _kind(str(r["clip"])) == "punch":
			hit = frame
		out.append(frame - hit if hit >= 0 else -1)
	return out


## A contact start: this row's hold is "1" and the previous row's "0". The first row has no previous row.
static func _contact_start(rows: Array, i: int) -> bool:
	return i > 0 and _hold(rows[i]) == "1" and _hold(rows[i - 1]) == "0"


static func _hold(row: Dictionary) -> String:
	return str(row["hold"]) if row.has("hold") else "0"


## WHEN in the punch: pre before her contact, contact on it, post within POST_FRAMES after, late beyond.
## A pre jump 1..POST_FRAMES after her last landed hit is combo instead - the next punch of a combo, whose
## own clip holds no contact. Only a punch clip has a phase - a reaction or an idle jump is none whatever
## its since_contact.
static func _phase(kind: String, since_contact: int, since_prev_hit: int) -> String:
	if kind != "punch":
		return "none"
	if since_contact < 0:
		if since_prev_hit >= 1 and since_prev_hit <= POST_FRAMES:
			return "combo"
		return "pre"
	if since_contact == 0:
		return "contact"
	return "post" if since_contact <= POST_FRAMES else "late"


## by_phase always carries all six words, so a film with no jumps still reports six zeroes.
static func _zero_phases() -> Dictionary:
	var out := {}
	for p in PHASES:
		out[p] = 0
	return out


static func _jump(a: Dictionary, b: Dictionary, who: int, since_contact: int, since_prev_hit: int) -> Dictionary:
	var head_cm := _pos(b, "Head").distance_to(_pos(a, "Head")) * 100.0
	if head_cm <= JUMP_CM:
		return {}
	var clip_b := str(b["clip"])
	var kind := _kind(clip_b)
	return {
		"frame": int(b["frame"]),
		"film_s": float(b["film_s"]),
		"who": who,
		"clip": clip_b,
		"kind": kind,
		"cause": "change" if str(a["clip"]) != clip_b else "inside",
		"since_contact": since_contact,
		"since_prev_hit": since_prev_hit,
		"phase": _phase(kind, since_contact, since_prev_hit),
		"head_cm": head_cm,
		"root_cm": _pos(b, "node").distance_to(_pos(a, "node")) * 100.0,
		"hips_cm": _seg(b, "Hips", "node").distance_to(_seg(a, "Hips", "node")) * 100.0,
		"trunk_cm": _seg(b, "UpperChest", "Hips").distance_to(_seg(a, "UpperChest", "Hips")) * 100.0,
		"neck_cm": _seg(b, "Head", "UpperChest").distance_to(_seg(a, "Head", "UpperChest")) * 100.0,
	}


## Every clip start of both boxers, merged and ordered by frame then who: (frame, who, clip).
static func _clip_starts(grouped: Dictionary) -> Array:
	var starts: Array = []
	for who in grouped:
		var rows: Array = grouped[who]
		for i in range(1, rows.size()):
			var b: Dictionary = rows[i]
			var clip_b := str(b["clip"])
			if clip_b != str(rows[i - 1]["clip"]):
				starts.append({"frame": int(b["frame"]), "who": who, "clip": clip_b})
	starts.sort_custom(func(x, y):
		if int(x["frame"]) != int(y["frame"]):
			return int(x["frame"]) < int(y["frame"])
		return int(x["who"]) < int(y["who"]))
	return starts


static func _worst(jumps: Array) -> Array:
	var ranked := jumps.duplicate()
	ranked.sort_custom(func(x, y):
		if x["head_cm"] != y["head_cm"]:
			return x["head_cm"] > y["head_cm"]
		if int(x["frame"]) != int(y["frame"]):
			return int(x["frame"]) < int(y["frame"])
		return int(x["who"]) < int(y["who"]))
	var out: Array = []
	for i in range(mini(WORST_N, ranked.size())):
		var j: Dictionary = ranked[i]
		out.append({"film_s": j["film_s"], "who": j["who"], "clip": j["clip"], "head_cm": j["head_cm"],
			"root_cm": j["root_cm"], "hips_cm": j["hips_cm"], "trunk_cm": j["trunk_cm"], "neck_cm": j["neck_cm"]})
	return out


static func _last_frame(rows: Array) -> int:
	var last := 0
	for r in rows:
		last = maxi(last, int(r["frame"]))
	return last


static func _pos(row: Dictionary, bone: String) -> Vector3:
	return Vector3(float(row[bone + "_x"]), float(row[bone + "_y"]), float(row[bone + "_z"]))


static func _seg(row: Dictionary, bone: String, parent: String) -> Vector3:
	return _pos(row, bone) - _pos(row, parent)


static func _bump(counts: Dictionary, key: String) -> void:
	counts[key] = int(counts.get(key, 0)) + 1


static func _median(vals: Array) -> float:
	if vals.is_empty():
		return 0.0
	var s := vals.duplicate()
	s.sort()
	var mid: int = int(float(s.size()) / 2.0)
	if s.size() % 2 == 1:
		return float(s[mid])
	return (float(s[mid - 1]) + float(s[mid])) * 0.5
