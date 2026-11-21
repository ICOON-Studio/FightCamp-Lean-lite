extends RefCounted
## S531 TOPDOWN1 (owner: "Yes, build it", the top-down fight view beside the 3D): where the two boxers stand in the ring,
## seen from above, read only from what the live round already records - each exchange's ring card (rec["at"], the
## StrikeMap card and its range_m), the step she took (rec["arrow"]), who won it and the punches each side landed.
## Pure: no nodes. Ring units are metres, (0, 0) the centre, x to her right as she faces the camera, y down.
##   frame(exs, i) -> {"a": Vector2, "b": Vector2, "gap": float, "at": String, "trail": Array[Vector2], "lines": Array}
##   lines: [{"who": 0|1, "landed": bool}] - 0 her punches, 1 the opponent's; at most LINES_MAX solid a side, plus one
##   dashed miss for a side that lost the exchange and landed nothing.

const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")
const PlanRecord := preload("res://scripts/rules/PlanRecord.gd")

const HALF := 2.75          # half the ring inside the ropes (a 5.5 m amateur ring)
const ROPE_IN := 0.35       # a trapped boxer's back is this far inside the rope line
const LINES_MAX := 3
const TRAIL := 3            # her last steps drawn behind her
const TURN := {"pivot_out": 50.0, "roll_out": 40.0, "cut_off": -25.0, "herd": -30.0, "step_out": 15.0, "feint": 10.0}
const GAP_OF := {"clinch": 0.3, "own_ropes": 0.75, "opp_ropes": 0.75, "corner": 0.7}


## The gap for a card: the middle of its range, or GAP_OF for the cards with no range.
static func gap(at: String) -> float:
	if GAP_OF.has(at):
		return float(GAP_OF[at])
	var r: Array = StrikeMap.card(at).get("range_m", [])
	return (float(r[0]) + float(r[1])) * 0.5 if r.size() == 2 else 1.2


## The line between them turns a little every exchange (the fight circles) and more on a step that turns.
static func angle_at(exs: Array, i: int) -> float:
	var deg := 200.0
	for k in mini(i + 1, exs.size()):
		var x: Dictionary = exs[k]
		deg += (float(TURN.get(str(x.get("arrow", "")), 0.0)) if fired(x) else 0.0) + float((k * 37) % 23 - 11)   # S533: only a step that was taken turns the map
	return deg_to_rad(deg)


static func _clamp(p: Vector2) -> Vector2:
	var lim := HALF - ROPE_IN
	return Vector2(clampf(p.x, -lim, lim), clampf(p.y, -lim, lim))


## Both boxers for exchange i. own_ropes puts her back on the rope, opp_ropes the opponent's, corner the opponent in a
## corner. An open card stands round the middle: the record holds no direction of travel there, so none is drawn (S533:
## the drift with who won the last exchanges is gone - it claimed a walk-down nothing had recorded).
static func place(exs: Array, i: int) -> Dictionary:
	var x: Dictionary = exs[i]
	var at := str(x.get("at", "long"))
	var g := gap(at)
	var th := angle_at(exs, i)
	var dir := Vector2(cos(th), sin(th))   # from her to the opponent
	var lim := HALF - ROPE_IN
	var a := Vector2.ZERO
	var b := Vector2.ZERO
	if at == "own_ropes":
		a = _to_rope(-dir, lim)
		b = a + _toward_centre(a) * g
	elif at == "opp_ropes":
		b = _to_rope(dir, lim)
		a = b + _toward_centre(b) * g
	elif at == "corner":
		b = Vector2(signf(dir.x if dir.x != 0.0 else 1.0), signf(dir.y if dir.y != 0.0 else 1.0)) * lim
		a = b + _toward_centre(b) * g
	else:
		a = -dir * g * 0.5
		b = dir * g * 0.5
	return {"a": _clamp(a), "b": _clamp(b), "gap": g, "at": at}


static func _to_rope(d: Vector2, lim: float) -> Vector2:
	var m := maxf(absf(d.x), absf(d.y))
	return d / m * lim if m > 0.0 else Vector2(0, lim)


static func _toward_centre(p: Vector2) -> Vector2:
	return (-p).normalized() if p.length() > 0.001 else Vector2(0, -1)


static func frame(exs: Array, i: int) -> Dictionary:
	if exs.is_empty() or i < 0 or i >= exs.size():
		return {}
	var out := place(exs, i)
	var trail: Array = []
	for k in range(maxi(0, i - TRAIL), i):
		trail.append(place(exs, k)["a"])
	out["trail"] = trail
	var x: Dictionary = exs[i]
	var landed: Array = x.get("landed", [0, 0])
	var lines: Array = []
	for side in 2:
		var n := mini(int(landed[side]), LINES_MAX)
		for j in n:
			lines.append({"who": side, "landed": true})
		var won_side := bool(x.get("won", false)) == (side == 0)
		if n == 0 and not won_side:
			lines.append({"who": side, "landed": false})
	out["lines"] = lines
	return out


## One tick per exchange for the strip under the ring: {"n", "won", "landed", "word"} (the step's name, else the card).
static func ticks(exs: Array) -> Array:
	var out: Array = []
	for x in exs:
		var arrow := str(x.get("arrow", ""))
		var mv: Dictionary = StrikeMap.move(arrow) if arrow != "" else {}
		var word := str(mv.get("name", "")) if bool(x.get("planned", false)) else ""
		if word == "":
			word = str(StrikeMap.card(str(x.get("at", ""))).get("name", ""))
		out.append({"n": int(x.get("i", out.size())) + 1, "won": bool(x.get("won", false)), "landed": x.get("landed", [0, 0]), "word": word})
	return out


## THE CORNER'S EYE (S531; S533 P4PBUILD1 stage 2, DESIGN_THREEP4P_V2 section 4): the plan drawn on the ring, from what
## the exchange recorded - the line the plan had for this place (rec["want"]) and what became of it (rec["line"],
## PlanRecord.line_state). An exchange from before S533 has no "line": a thrown line reads worked / lost from the
## exchange, a held one held, and nothing is said about a line that was not thrown (no intent is invented).
const STEP_DIR := {"step_back": "back", "step_out": "back", "push_off": "back", "step_in": "in", "cut_off": "in", "herd": "in",
	"tie_up": "in", "feint": "in", "pivot_out": "side", "roll_out": "side"}
## How each state is drawn and said. "faint" = the plan's line for the next opening, not attempted yet.
const LEGEND := [["worked", "solid", "thrown and won"], ["lost", "cross", "thrown and lost"], ["held", "hollow", "held: wrong for the moment"],
	["not_ready", "dotted", "not ready: did not get off"], ["faint", "faint", "next: the plan's line here"]]
const STATE_WORDS := {"worked": "worked", "lost": "lost", "held": "held", "not_ready": "not ready", "faint": "next"}
const GHOST_ROUNDS := 2


## Whether the plan's line was thrown this exchange (the only thing that may move or turn the map).
static func fired(x: Dictionary) -> bool:
	if x.has("line"):
		return str(x["line"]) in ["worked", "lost"]
	return bool(x.get("planned", false)) and not bool(x.get("held", false))


static func _state(x: Dictionary) -> String:
	if x.has("line"):
		return str(x["line"])
	if bool(x.get("held", false)):
		return "held"
	if bool(x.get("planned", false)):
		return "worked" if bool(x.get("won", false)) else "lost"
	return "none"


## {dir, state, name}: dir "back" | "in" | "side" for a step, "" for a punch line (said, not drawn as an arrow).
## {} = the plan had no line here (or an old exchange that recorded none).
static func plan_mark(x: Dictionary) -> Dictionary:
	var st := _state(x)
	var id := str(x.get("want", x.get("arrow", "")))
	if st == "none" or id == "":
		return {}
	var base := id.split("@")[0]
	return {"dir": str(STEP_DIR.get(base, "")), "state": st, "name": str(StrikeMap.move(base).get("name", base)),
		"why": str(PlanRecord.WHY_WORDS.get(str(x.get("line_why", "")), "")) if st == "lost" else ""}   # the cause, in words (lost lines only)


## The plan's line for the next opening ({at, want}), not attempted yet: drawn faint. {} = none, or the bell.
static func next_mark(next: Dictionary) -> Dictionary:
	var id := str(next.get("want", ""))
	if id == "":
		return {}
	var base := id.split("@")[0]
	return {"dir": str(STEP_DIR.get(base, "")), "state": "faint", "name": str(StrikeMap.move(base).get("name", base))}


## Who is pinned, from the record alone: 0 your boxer (on the own ropes, or held there by the duel), 1 the opponent (on
## the ropes or in a corner), -1 open ring - nobody is said to be walked anywhere.
static func pinned(exs: Array) -> int:
	if exs.is_empty():
		return -1
	var x: Dictionary = exs[-1]
	var at := str(x.get("at", ""))
	if at == "own_ropes" or bool(x.get("pinned", false)):
		return 0
	return 1 if at in ["opp_ropes", "corner"] else -1


## The last GHOST_ROUNDS settled rounds' ATTEMPTED lines, dim beside the ring: [{n, rows: [{name, worked, lost}]}].
## A round with no recorded lines (an old save) gives no row: no past intent is made up.
static func ghosts(rounds: Array) -> Array:
	var out: Array = []
	for r in rounds.slice(maxi(0, rounds.size() - GHOST_ROUNDS)):
		var by := {}
		var order: Array = []
		for x in (r as Dictionary).get("exchanges", []):
			if not (x as Dictionary).has("line") or not fired(x):
				continue
			var id := str(x.get("want", "")).split("@")[0]
			if not by.has(id):
				by[id] = {"name": str(StrikeMap.move(id).get("name", id)), "worked": 0, "lost": 0}
				order.append(id)
			by[id][str(x["line"])] = int(by[id][str(x["line"])]) + 1
		if not order.is_empty():
			out.append({"n": int((r as Dictionary).get("n", 0)), "rows": order.map(func(k): return by[k])})
	return out


## What the corner can do at the next opening, as a kind the view puts into words - only controls that already exist,
## at their own timing; the map itself does nothing. "bell" = the round is settled: the corner minute's one swap, or
## keep the plan. "tie" = your boxer is on the ropes and the plan's exit there is missing or did not get off: the Tie
## up call, or say nothing. "" = nothing to point at.
static func hint(exs: Array, next: Dictionary, total: int) -> String:
	if exs.is_empty():
		return ""
	if exs.size() >= total:
		return "bell"
	if pinned(exs) != 0:
		return ""
	var last := _state(exs[-1])
	if str(next.get("want", "")) == "" or last == "not_ready":
		return "tie"
	return ""
