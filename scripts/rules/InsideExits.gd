extends RefCounted
## S315: how an inside spell ends (John J_INSIDE2, coaching sources: Dempsey 1950, BoxingWiki rope/corner escape,
## Honour & Glory lesson plans). Before, every spell ended with a straight step back. The coaching exits:
##   "tie"   - she ties up the arms and waits for "Break": a clinch (ClinchBeats) starts as the spell ends. Only the
##             exchange's own clinches are used (moved to the spell's end), so the clinch count stays the real one.
##   "pivot" - the pressed boxer pivots ~90 deg on her lead foot behind a check hook and is gone off the line.
##   "step"  - a straight step back (the old way).
## Marks each "inside" beat with "exit" and "exit_who" ("a"/"b": the one who leaves); a pivot also gets "pivot_t" (the
## pivot's end, absolute exchange time like end_t). Who lands what is unchanged: a check hook is the leaver's own last
## free single punch of the spell turned into a lead hook. Call after InsideBeats and ClinchBeats.

## Of the spells no clinch ends, this share pivots out (no source counts exits; the coaching books teach the pivot
## first - S315 estimate, John J-INSIDE3 asked for real shares).
const PIVOT := 0.5
## A spell whose clinch could move to its end ties up this often (the rest of the clinches stay where ClinchBeats put them).
const TIE := 0.5
## A clinch starting this close to a spell's end already ends it.
const TIE_NEAR_S := 0.6
## The pivot's window: the step itself takes ~0.4 s (Footwork.PIVOT_SCALE), starting once her check hook is back in guard.
const PIVOT_S := 0.9
## The check hook: her last free single punch this close to the spell's end; the pivot starts right after its contact.
const HOOK_LOOK_S := 1.2
const HOOK_CONTACT_S := 0.3
const BREAK_S := 0.8
const PUNCHES := ["jab", "cross", "lead_hook", "body_hook", "rear_uppercut"]


static func apply(beats: Array, rng: RandomNumberGenerator) -> Array:
	var spells: Array = beats.filter(func(b): return str(b["move"]) == "inside")
	for sp in spells:
		var leaver := "a" if str(sp["who"]) == "b" else "b"
		var held := _clinch_near(beats, float(sp["t"]), float(sp["end_t"]))
		if held.is_empty() and rng.randf() < TIE:
			held = _move_clinch(beats, float(sp["end_t"]))
		if not held.is_empty():
			held["tie"] = true
			sp["exit"] = "tie"
			sp["exit_who"] = str(held["who"])
			sp["end_t"] = minf(float(sp["end_t"]), float(held["t"]))
			continue
		if rng.randf() < PIVOT:
			sp["exit"] = "pivot"
			sp["exit_who"] = leaver
			var hook := _check_hook(beats, leaver, float(sp["t"]), float(sp["end_t"]))
			if not hook.is_empty():
				hook["move"] = "lead_hook"
				sp["end_t"] = float(hook["t"]) + HOOK_CONTACT_S
			sp["pivot_t"] = float(sp["end_t"]) + PIVOT_S
		else:
			sp["exit"] = "step"
			sp["exit_who"] = leaver
	beats.sort_custom(func(x, y): return float(x["t"]) < float(y["t"]))
	return spells


## A clinch that starts inside the spell or within TIE_NEAR_S after it.
static func _clinch_near(beats: Array, start: float, end_t: float) -> Dictionary:
	for b in beats:
		if str(b["move"]) == "clinch" and float(b["t"]) >= start and float(b["t"]) <= end_t + TIE_NEAR_S:
			return b
	return {}


## Moves a clinch that is not already ending a spell to start at `at`, with its referee break, if no punch falls in the
## hold and the break; {} if none fits.
static func _move_clinch(beats: Array, at: float) -> Dictionary:
	for b in beats:
		if str(b["move"]) != "clinch" or bool(b.get("tie", false)):
			continue
		var dur := float(b["dur"])
		if at + dur + BREAK_S > 29.5 or _punch_in(beats, at, at + dur + BREAK_S):
			continue
		var old_break := float(b["break_t"])
		for r in beats:
			if bool(r.get("ref", false)) and str(r["move"]) == "step_out" and is_equal_approx(float(r["t"]), old_break):
				r["t"] = at + dur
		b["t"] = at
		b["break_t"] = at + dur
		b["tie"] = true
		return b
	return {}


static func _punch_in(beats: Array, from: float, to: float) -> bool:
	for b in beats:
		if str(b["move"]) in PUNCHES and float(b["t"]) >= from and float(b["t"]) <= to:
			return true
	return false


## The spell's last punch when it is the leaver's single punch (no combination, no big shot, not a body hook - the body
## count is the exchange's); or her last such punch with only HOOK_LOOK_S of the other's punching after it.
static func _check_hook(beats: Array, who: String, start: float, end_t: float) -> Dictionary:
	var best := {}
	var last_other := -1.0
	for b in beats:
		var t := float(b["t"])
		if t < start or t > end_t or not str(b["move"]) in PUNCHES:
			continue
		if str(b["who"]) != who:
			last_other = t
			continue
		if str(b["move"]) == "body_hook" or bool(b.get("combo", false)) or str(b.get("combo_id", "")) != "" or bool(b.get("big", false)):
			continue
		best = b
	if best.is_empty() or last_other > float(best["t"]) + HOOK_LOOK_S:
		return {}
	return best
