extends RefCounted
## S531 TOPDOWN1 (owner: "Yes, build it", the top-down fight view beside the 3D): where the two boxers stand in the ring,
## seen from above, read only from what the live round already records - each exchange's ring card (rec["at"], the
## StrikeMap card and its range_m), the step she took (rec["arrow"]), who won it and the punches each side landed.
## Pure: no nodes. Ring units are metres, (0, 0) the centre, x to her right as she faces the camera, y down.
##   frame(exs, i) -> {"a": Vector2, "b": Vector2, "gap": float, "at": String, "trail": Array[Vector2], "lines": Array}
##   lines: [{"who": 0|1, "landed": bool}] - 0 her punches, 1 the opponent's; at most LINES_MAX solid a side, plus one
##   dashed miss for a side that lost the exchange and landed nothing.

const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")

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
		deg += float(TURN.get(str(x.get("arrow", "")), 0.0)) + float((k * 37) % 23 - 11)
	return deg_to_rad(deg)


static func _clamp(p: Vector2) -> Vector2:
	var lim := HALF - ROPE_IN
	return Vector2(clampf(p.x, -lim, lim), clampf(p.y, -lim, lim))


## Both boxers for exchange i. Open cards stand around a centre that drifts with who wins (the winner walks the loser
## back); own_ropes puts her back on the rope, opp_ropes the opponent's, corner the opponent in a corner.
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
		var c := Vector2.ZERO
		for k in i + 1:
			var w: Dictionary = exs[k]
			c += dir * (0.18 if bool(w.get("won", false)) else -0.18)
		c = c.limit_length(lim - g)
		a = c - dir * g * 0.5
		b = c + dir * g * 0.5
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
