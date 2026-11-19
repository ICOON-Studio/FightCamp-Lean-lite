extends RefCounted
## FIGHTPLAYER2 (S528; both critics of film 5, item 1: "the two men never move round the ring", "blue's back is on the
## same corner post from ex2 to ex5"; the owner, C434: "why the fighter do not walk ?"): RING STEPS. Pure. The distance
## plan only ever set how far apart the two men are, so the pair fought the whole round on one spot. Between exchanges,
## while both wait at rest, the pair now moves: one RING STEP at a time (both men step together, one leads and the other
## answers a few frames later, the distance held), a breath, another. WHERE a ring step goes is not decided here - the
## plan does not know where in the ring the pair stands; the player does (StepPlay._ring: back to the middle, off the
## ropes, else by `roll`).
##   plan(tracks, gap, db, t0, t1, rng) -> ring steps planned; each is a `step` event on both tracks:
##       {t, end_t, kind: "step", drift: id, roll, lead: bool}

const R := preload("res://scripts/fight3d/v2/ChoreoRules.gd")

const STEP_S := 0.70                   # one ring step, start to the feet down
## Between two ring steps (never a march). S529: was 0.15-0.60 - a step take was on screen 40-44 % of the round and both
## critics of film 6 counted 120 steps a minute that "lead nowhere"; a boxer steps, looks, steps.
const PAUSE_S := Vector2(1.4, 2.4)   # FROZEN S531 with REST_M: 30-45 steps a minute, a reading wait of 0.6-1.5 s. Before:  # S531: was 0.35-0.7 (film 9: "they never stop", no reading beat)
## ... every other breath is a long one: room for the hands (ChoreoWait puts a paw or a feint in it)
const PAUSE_LONG_S := Vector2(1.3, 2.0)
const FIRST_S := Vector2(0.05, 0.30)   # into a quiet stretch before the first
const ANSWER_S := Vector2(0.06, 0.14)  # the other man starts this long after the leader
const HOLD_FROM_M := 1.05              # only while the pair holds at rest or at the pocket
const SETTLE_S := 0.20                 # after a take of either man ends
const BEFORE_S := 0.25                 # a ring step is down this long before either man's next take
const BUSY := ["punch", "reaction", "block", "defence", "pass"]
## S531 IN AND OUT (film 7, both critics' first item: "the feet do not move the man", "the distance never crosses the
## jab edge"; the coach: in range 0.9-1.1 m, out 1.4-1.7, crossed 3-5 times between exchanges). In a hold at rest one
## man steps IN to the jab's edge (a captured step forward: ChoreoGap.steps makes it his step event), stays a breath -
## the hands work there (ChoreoWait) - and the distance opens again: he steps back out, or the other man gives the ground.
const IN_M := Vector2(0.15, 0.22)   # S531 after film 9: a HALF step (from 1.45 the gloves never meet); was 0.24-0.33
const IN_S := 0.45
## Film 9 (both critics' first item): with a hold of 0.75-1.2 s here the two stood "gloves on gloves at punching range,
## nobody throwing". In range a man punches or leaves: the step in is a half step, straight back out.
const IN_HOLD_S := Vector2(0.10, 0.25)
const IN_FIRST_S := Vector2(0.25, 0.8)
const IN_EVERY_S := Vector2(4.0, 7.0)   # film 9: 90 steps a minute read as nervous (the animator: 25-45)
const IN_SAME_OUT := 0.6               # how often the man who stepped in is the one who steps out


static func inout(gap: Array, t0: float, t1: float, rng: RandomNumberGenerator) -> Array:
	var out: Array = [gap[0]]
	var who := "a" if rng.randf() < 0.5 else "b"
	for i in range(1, gap.size()):
		var ta := maxf(float(gap[i - 1][0]), t0 + 0.3)
		var tb := minf(float(gap[i][0]), t1)
		var g := float(gap[i][1])
		if absf(g - float(gap[i - 1][1])) < 0.001 and g >= R.REST_M - 0.05:
			var at := ta + _r(rng, IN_FIRST_S)
			while true:
				var d := _r(rng, IN_M)
				var hold := _r(rng, IN_HOLD_S)
				var end := at + IN_S * 2.0 + hold
				if end > tb - 0.35:
					break
				var other := "b" if who == "a" else "a"
				out.append([at, g, ""])
				out.append([at + IN_S, g - d, who])
				out.append([at + IN_S + hold, g - d, ""])
				out.append([end, g, who if rng.randf() < IN_SAME_OUT else other])
				if rng.randf() < 0.6:
					who = other
				at = end + _r(rng, IN_EVERY_S)
		out.append(gap[i])
	return out


static func plan(tracks: Dictionary, gap: Array, db: Dictionary, t0: float, t1: float, rng: RandomNumberGenerator) -> int:
	var rows: Dictionary = db.get("rows", {})
	var busy: Array = []   # [from, to] of either man's takes
	for w in ["a", "b"]:
		for e in tracks[w]:
			if not (str(e["kind"]) in BUSY):
				continue
			var row: Dictionary = rows.get(str(e.get("clip", "")), {})
			var left: float = float(e.get("until_s", row.get("length_s", 1.2))) - float(e.get("from_s", 0.0))
			busy.append([float(e["t"]) - BEFORE_S, maxf(float(e["control_t"]), float(e["t"]) + (left if str(e["kind"]) != "pass" else 2.0)) + SETTLE_S])
	var n := 0
	var id := int(t0 * 10.0) * 100
	var lead := "a" if rng.randf() < 0.5 else "b"
	for i in range(1, gap.size()):
		var ta := float(gap[i - 1][0])
		var tb := float(gap[i][0])
		var g := float(gap[i][1])
		if absf(g - float(gap[i - 1][1])) > 0.001 or g < HOLD_FROM_M or tb - ta < STEP_S + 0.2:
			continue
		var at := maxf(ta, t0 + 0.3) + _r(rng, FIRST_S)
		while at + STEP_S <= minf(tb, t1) - 0.08:
			var clash := false
			for b in busy:
				if at < float(b[1]) and at + STEP_S > float(b[0]):
					clash = true
					at = float(b[1])
					break
			if clash:
				continue
			var roll := rng.randf()
			var answer := _r(rng, ANSWER_S)
			for w in ["a", "b"]:
				var st := at + (0.0 if w == lead else answer)
				(tracks[w] as Array).append({"t": st, "clip": "", "kind": "step", "part": "legs", "from_s": 0.0, "join_s": 0.0,
					"control_t": st, "end_t": at + STEP_S, "drift": id + n, "roll": roll, "lead": w == lead, "m": 0.0})
			n += 1
			if rng.randf() < 0.5:
				lead = "b" if lead == "a" else "a"
			at += STEP_S + _r(rng, PAUSE_LONG_S if n % 2 == 1 else PAUSE_S)
	return n


static func _r(rng: RandomNumberGenerator, v: Vector2) -> float:
	return v.x + (v.y - v.x) * rng.randf()
