extends RefCounted
## S398 where the fight happens and who wins it there (FIGHTER_MODEL_S397.md v2 sections 4-6, round-2 critics' fixes):
## a distance ladder (0 long, 1 pocket, 2 inside) both sides steer, and at each place two-sided duels of named tools,
## each tool's gap through a convex curve, a fighter leaning on the best tool. No averaging of a profile anywhere.
## a / b = attribute dicts (Attrs / AttrGen, with heart, pace, forward). ctx = {reach (a's cm edge), height (a's cm edge),
## lefty (opposite stances), stepin (-1 none, 0 a resisted the step in, 1 b did)}. Edges are in the fight's power points
## (a level 5 points higher everywhere = 5, as the old average was). Pure static; zero preloads. All numbers GV.

const LONG := 0
const POCKET := 1
const INSIDE := 2
const PLACES := ["long", "pocket", "inside"]
const PLACE_WORD := ["at range", "in the pocket", "inside"]

## Each place's tools: attack (the fighter's attributes) against answer (the opponent's). Weights sum to 1 each side.
const TOOLS := [
	[{"id": "jab", "atk": {"jab": 0.50, "footwork": 0.30, "explosiveness": 0.20}, "ans": {"footwork": 0.35, "foot_speed": 0.25, "jab": 0.15, "ring_iq": 0.25}},
	 {"id": "right", "atk": {"straight": 0.40, "hand_speed": 0.25, "accuracy": 0.35}, "ans": {"footwork": 0.35, "foot_speed": 0.30, "jab": 0.20, "accuracy": 0.15}},
	 {"id": "counter", "atk": {"timing": 0.40, "hand_speed": 0.20, "accuracy": 0.20, "ring_iq": 0.20}, "ans": {"jab": 0.35, "footwork": 0.30, "foot_speed": 0.20, "ring_iq": 0.15}}],
	[{"id": "combos", "atk": {"hand_speed": 0.28, "straight": 0.25, "hooks": 0.27, "explosiveness": 0.20}, "ans": {"guard": 0.48, "head_movement": 0.25, "ring_iq": 0.15, "recovery": 0.12}},
	 {"id": "power", "atk": {"power": 0.45, "hooks": 0.25, "accuracy": 0.30}, "ans": {"head_movement": 0.30, "guard": 0.25, "ring_iq": 0.45}},
	 {"id": "counter", "atk": {"timing": 0.40, "hand_speed": 0.20, "head_movement": 0.15, "ring_iq": 0.25}, "ans": {"guard": 0.25, "head_movement": 0.22, "ring_iq": 0.41, "recovery": 0.12}}],
	[{"id": "short", "atk": {"inside": 0.50, "hooks": 0.18, "uppercuts": 0.17, "explosiveness": 0.15}, "ans": {"inside": 0.65, "strength": 0.35}},
	 {"id": "body", "atk": {"inside": 0.40, "hooks": 0.35, "power": 0.25}, "ans": {"inside": 0.65, "guard": 0.35}},
	 {"id": "uppercut", "atk": {"inside": 0.30, "uppercuts": 0.40, "accuracy": 0.30}, "ans": {"inside": 0.55, "strength": 0.30, "ring_iq": 0.15}}],
]
const STEPIN := {"id": "stepin", "atk": {"timing": 0.5, "hooks": 0.3, "strength": 0.2}, "ans": {"head_movement": 0.6, "composure": 0.4}}
const TIE := {"strength": 0.6, "inside": 0.4}
## What the report calls each tool and the answer it beat.
const TOOL_WORD := {"jab": "jab", "right": "right hand", "counter": "counter", "combos": "combinations", "power": "power shots",
	"short": "short work", "body": "body shots", "uppercut": "uppercut", "stepin": "counter on the way in"}
const ANSWER_WORD := {"jab": "footwork", "right": "footwork", "counter": "defence", "combos": "guard", "power": "head movement",
	"short": "inside work", "body": "inside work", "uppercut": "inside work", "stepin": "head movement"}

const KNEE := 6.0            # v3: the value-weighted level lets signature spikes leave the linear zone again
const CONVEX := 0.5
const BEST_W := 0.6          # a fighter leans on the best tool; the value-weighted level prices that tool honestly
const K := 0.5              # place score -> power points
const REACH_PER_CM := 0.25   # on the long jab (bar 3)
const HEIGHT_PER_CM := 0.2  # the taller fighter pays inside, at most HEIGHT_CAP
const HEIGHT_CAP := 4.0
const SOUTHPAW_STRAIGHT := 1.5   # asymmetric: the lefty's rear straight, unless both are southpaws
const CROUCH := 0.2         # the uppercut beats the crouch: per point of the answerer's head movement over CROUCH_AT
const CROUCH_AT := 60.0
const PACE_GUARD := 6.0     # a busy fighter's own guard and head movement pay (p - 0.5) x this
const PACE_COUNTER := 15.0  # and the opponent's counters gain (p - 0.5) x this
const PACE_WORK := 8.0      # the busier side takes close exchanges: (pace_a - pace_b) / 100 x this (judges reward work)
const PACE_HOT := 72.0      # past a volume puncher's busy, more pace starts missing (a random 86 is not free)
const PACE_HOT_GUARD := 0.30
const TIE_DAMP := 40.0      # a won tie-up shrinks the exchange by tie / TIE_DAMP, at most TIE_MAX
const TIE_MAX := 0.4
## Steering (section 4, round-2 weights).
const OPEN := {"footwork": 0.35, "foot_speed": 0.3, "jab": 0.25, "timing": 0.1}
const CLOSE := {"footwork": 0.4, "foot_speed": 0.3, "head_movement": 0.2, "strength": 0.1}
const FORWARD_CLOSE := 0.55  # per dial point over 50, on the closing side, once the feet can use it
const FWD_CAP := 26.0       # past a stalker's walk-down the dial adds no more: a wild forward is not a free build
const FWD_GUARD := 0.28     # per point of forward over 50, off the guard: a style's level pays it, a loose dial does not
const FWD_PAST := 76.0      # past a stalker's 75, more forward keeps costing the guard and buys no more close
const FWD_PAST_GUARD := 0.45
const CLOSE_FEET_AT := 45.0
const CLOSE_FEET_SPAN := 18.0
const INSIDE_STRENGTH := 0.3
const SAME_WAY := 0.85
const STEER_SPAN := 36.0
const STEER_MIN := 0.2
const STEER_MAX := 0.8
const TWO_STEP_GAP := 6.0   # a stalker who is already winning the walk-down can cross long -> inside in one exchange
const ROPES := 8.0          # the pinned side's control, x (1.3 - composure / 100)
const PINNED_AFTER := 2
## States (section 6).
const TIRED_AT := 65.0
const TIRED_LEGS := 12.0
const TIRED_SNAP := 6.0
const TIRED_CALM := 3.0
const HURT_DEF := 8.0


const ALIAS := {"hand_speed": "speed", "foot_speed": "speed", "engine": "stamina", "chin": "durability",
	"body": "durability", "ring_iq": "fight_iq", "guard": "defence", "head_movement": "defence"}
const PUNCHES := ["jab", "straight", "hooks", "uppercuts"]
## Derived recomputes (inputs already stored) and punch-name scans. The speed test reads these.
static var n_derived := 0
static var n_punch_scan := 0
## Packed fight vector. effective() stores it on the copy it returns; a raw dict is packed on the spot.
const QN := 21
const Q_JAB := 0; const Q_FOOT := 1; const Q_EXP := 2; const Q_FSPD := 3; const Q_IQ := 4
const Q_STRAIGHT := 5; const Q_HAND := 6; const Q_ACC := 7; const Q_TIME := 8; const Q_HOOK := 9
const Q_GUARD := 10; const Q_HEAD := 11; const Q_REC := 12; const Q_POWER := 13; const Q_INSIDE := 14
const Q_UPPER := 15; const Q_STR := 16; const Q_COMP := 17; const Q_PACE := 18; const Q_FWD := 19; const Q_HEART := 20


static func v(a: Dictionary, k: String) -> float:
	# No stored head movement: the defence, kept by flexible joints. A stored value (the tired copy) wins.
	if k == "head_movement" and not a.has("head_movement"):
		n_derived += 1
		var defence := float(a.get("defence", a.get("guard", 55.0)))
		return 0.65 * defence + 0.35 * float(a.get("flexibility", defence))
	if a.has(k):
		return float(a[k])
	if k == "power":
		n_derived += 1
		var s := float(a.get("strength", 55.0))
		return 0.5 * s + 0.5 * float(a.get("explosiveness", s))
	if PUNCHES.has(k):
		n_punch_scan += 1
		return 55.0
	var alt := str(ALIAS.get(k, ""))
	if alt != "" and a.has(alt):
		return float(a[alt])
	return 55.0


static func mix(a: Dictionary, w: Dictionary) -> float:
	var s := 0.0
	for k in w:
		s += v(a, k) * float(w[k])
	return s


## The convex gap curve.
static func h(g: float) -> float:
	return g + CONVEX * signf(g) * maxf(0.0, absf(g) - KNEE)


## The attributes as they stand right now: tired (energy), hurt, the pace dial's cost to the own defence. late = round 3+
## (heart resists the fade).
static func effective(a: Dictionary, energy: float, hurt: bool, late: bool) -> Dictionary:
	var e := a.duplicate()
	var t := clampf((TIRED_AT - energy) / TIRED_AT, 0.0, 1.0)
	if late and t > 0.0:
		t = maxf(t * 0.5, t * (1.3 - v(a, "heart") / 100.0))
	var p := v(a, "pace") / 100.0 - 0.5
	for k in ["guard", "head_movement", "footwork", "foot_speed"]:
		e[k] = v(a, k) - TIRED_LEGS * t
	for k in ["hand_speed", "power", "accuracy"]:
		e[k] = v(a, k) - TIRED_SNAP * t
	e["composure"] = v(a, "composure") - TIRED_CALM * t
	e["guard"] = float(e["guard"]) - PACE_GUARD * p
	e["head_movement"] = float(e["head_movement"]) - PACE_GUARD * p
	var hot := maxf(0.0, v(a, "pace") - PACE_HOT)
	e["guard"] = float(e["guard"]) - PACE_HOT_GUARD * hot
	e["accuracy"] = float(e["accuracy"]) - 0.20 * hot
	var fwd := maxf(0.0, v(a, "forward") - 50.0)
	e["guard"] = float(e["guard"]) - FWD_GUARD * fwd - FWD_PAST_GUARD * maxf(0.0, v(a, "forward") - FWD_PAST)
	if hurt:
		var k_hurt := HURT_DEF * (1.2 - v(a, "composure") / 100.0)
		for k in ["guard", "head_movement", "footwork"]:
			e[k] = float(e[k]) - k_hurt
	e.erase("_vec")
	e["_vec"] = _pack(e)
	return e


static func pack(a: Dictionary) -> PackedFloat32Array:
	var got: Variant = a.get("_vec", null)
	if typeof(got) == TYPE_PACKED_FLOAT32_ARRAY:
		return got
	return _pack(a)


static func _pack(a: Dictionary) -> PackedFloat32Array:
	var u := PackedFloat32Array()
	u.resize(QN)
	u[Q_JAB] = v(a, "jab")
	u[Q_FOOT] = v(a, "footwork")
	u[Q_EXP] = v(a, "explosiveness")
	u[Q_FSPD] = v(a, "foot_speed")
	u[Q_IQ] = v(a, "ring_iq")
	u[Q_STRAIGHT] = v(a, "straight")
	u[Q_HAND] = v(a, "hand_speed")
	u[Q_ACC] = v(a, "accuracy")
	u[Q_TIME] = v(a, "timing")
	u[Q_HOOK] = v(a, "hooks")
	u[Q_GUARD] = v(a, "guard")
	u[Q_HEAD] = v(a, "head_movement")
	u[Q_REC] = v(a, "recovery")
	u[Q_POWER] = v(a, "power")
	u[Q_INSIDE] = v(a, "inside")
	u[Q_UPPER] = v(a, "uppercuts")
	u[Q_STR] = v(a, "strength")
	u[Q_COMP] = v(a, "composure")
	u[Q_PACE] = v(a, "pace")
	u[Q_FWD] = v(a, "forward")
	u[Q_HEART] = v(a, "heart")
	return u


## One side's place score on packed vectors. x = o (0.6 best + 0.4 mean, through h), y = best tool index (3 = the step-in).
static func _ob(atk: PackedFloat32Array, ans: PackedFloat32Array, place: int, reach: float, height: float, southpaw: int, stepin: int, side: int) -> Vector2:
	var sgn := 1.0 if side == 0 else -1.0
	var g0 := 0.0
	var g1 := 0.0
	var g2 := 0.0
	if place == LONG:
		g0 = atk[Q_JAB] * 0.50 + atk[Q_FOOT] * 0.30 + atk[Q_EXP] * 0.20 - (ans[Q_FOOT] * 0.35 + ans[Q_FSPD] * 0.25 + ans[Q_JAB] * 0.15 + ans[Q_IQ] * 0.25)
		g0 += REACH_PER_CM * reach * sgn
		g1 = atk[Q_STRAIGHT] * 0.40 + atk[Q_HAND] * 0.25 + atk[Q_ACC] * 0.35 - (ans[Q_FOOT] * 0.35 + ans[Q_FSPD] * 0.30 + ans[Q_JAB] * 0.20 + ans[Q_ACC] * 0.15)
		if (side == 0 and southpaw > 0) or (side == 1 and southpaw < 0):
			g1 += SOUTHPAW_STRAIGHT
		g2 = atk[Q_TIME] * 0.40 + atk[Q_HAND] * 0.20 + atk[Q_ACC] * 0.20 + atk[Q_IQ] * 0.20 - (ans[Q_JAB] * 0.35 + ans[Q_FOOT] * 0.30 + ans[Q_FSPD] * 0.20 + ans[Q_IQ] * 0.15)
		g2 += PACE_COUNTER * (ans[Q_PACE] / 100.0 - 0.5)
	elif place == POCKET:
		g0 = atk[Q_HAND] * 0.28 + atk[Q_STRAIGHT] * 0.25 + atk[Q_HOOK] * 0.27 + atk[Q_EXP] * 0.20 - (ans[Q_GUARD] * 0.48 + ans[Q_HEAD] * 0.25 + ans[Q_IQ] * 0.15 + ans[Q_REC] * 0.12)
		g1 = atk[Q_POWER] * 0.45 + atk[Q_HOOK] * 0.25 + atk[Q_ACC] * 0.30 - (ans[Q_HEAD] * 0.30 + ans[Q_GUARD] * 0.25 + ans[Q_IQ] * 0.45)
		g2 = atk[Q_TIME] * 0.40 + atk[Q_HAND] * 0.20 + atk[Q_HEAD] * 0.15 + atk[Q_IQ] * 0.25 - (ans[Q_GUARD] * 0.25 + ans[Q_HEAD] * 0.22 + ans[Q_IQ] * 0.41 + ans[Q_REC] * 0.12)
		g2 += PACE_COUNTER * (ans[Q_PACE] / 100.0 - 0.5)
	else:
		g0 = atk[Q_INSIDE] * 0.50 + atk[Q_HOOK] * 0.18 + atk[Q_UPPER] * 0.17 + atk[Q_EXP] * 0.15 - (ans[Q_INSIDE] * 0.65 + ans[Q_STR] * 0.35)
		g1 = atk[Q_INSIDE] * 0.40 + atk[Q_HOOK] * 0.35 + atk[Q_POWER] * 0.25 - (ans[Q_INSIDE] * 0.65 + ans[Q_GUARD] * 0.35)
		g2 = atk[Q_INSIDE] * 0.30 + atk[Q_UPPER] * 0.40 + atk[Q_ACC] * 0.30 - (ans[Q_INSIDE] * 0.55 + ans[Q_STR] * 0.30 + ans[Q_IQ] * 0.15)
		g2 += CROUCH * maxf(0.0, ans[Q_HEAD] - CROUCH_AT)
		var cut := minf(HEIGHT_CAP, maxf(0.0, HEIGHT_PER_CM * height * sgn))
		g0 -= cut
		g1 -= cut
		g2 -= cut
	var h0 := h(g0)
	var h1 := h(g1)
	var h2 := h(g2)
	var top := h0
	var best := 0
	if h1 > top:
		top = h1
		best = 1
	if h2 > top:
		top = h2
		best = 2
	var nf := 3.0
	var hs := 0.0
	if stepin == side:
		var gs := atk[Q_TIME] * 0.5 + atk[Q_HOOK] * 0.3 + atk[Q_STR] * 0.2 - (ans[Q_HEAD] * 0.6 + ans[Q_COMP] * 0.4)
		gs += PACE_COUNTER * (ans[Q_PACE] / 100.0 - 0.5)
		if place == INSIDE:
			gs -= minf(HEIGHT_CAP, maxf(0.0, HEIGHT_PER_CM * height * sgn))
		hs = h(gs)
		nf = 4.0
		if hs > top:
			top = hs
			best = 3
	var mean := h0 / nf + h1 / nf + h2 / nf
	if stepin == side:
		mean += hs / nf
	return Vector2(BEST_W * top + (1.0 - BEST_W) * mean, float(best))


static func _bname(place: int, i: int) -> String:
	if i == 3:
		return "stepin"
	if place == LONG:
		return "jab" if i == 0 else ("right" if i == 1 else "counter")
	if place == POCKET:
		return "combos" if i == 0 else ("power" if i == 1 else "counter")
	return "short" if i == 0 else ("body" if i == 1 else "uppercut")


static func _tie(u: PackedFloat32Array) -> float:
	return u[Q_STR] * 0.6 + u[Q_INSIDE] * 0.4


## a's edge at a place in power points, with both sides' best tools and the tie-up's dampening.
## Returns {edge, a_best, b_best, a_o, b_o, tie}. Same numbers as the tool table, read off a packed vector.
static func at(a: Dictionary, b: Dictionary, place: int, ctx: Dictionary) -> Dictionary:
	var va := pack(a)
	var vb := pack(b)
	var reach := float(ctx.get("reach", 0.0))
	var height := float(ctx.get("height", 0.0))
	var southpaw := int(ctx.get("southpaw", 0))
	var stepin := int(ctx.get("stepin", -1))
	var sa := _ob(va, vb, place, reach, height, southpaw, stepin, 0)
	var sb := _ob(vb, va, place, reach, height, southpaw, stepin, 1)
	var e := K * (sa.x - sb.x) + PACE_WORK * (va[Q_PACE] - vb[Q_PACE]) / 100.0
	var tie := 0.0
	if place == INSIDE:
		tie = _tie(va) - _tie(vb)
		if (e < 0.0 and tie > 0.0) or (e > 0.0 and tie < 0.0):
			e *= 1.0 - minf(TIE_MAX, absf(tie) / TIE_DAMP)
	return {"edge": e, "a_best": _bname(place, int(sa.y)), "b_best": _bname(place, int(sb.y)), "a_o": sa.x, "b_o": sb.x, "tie": tie}


## The edge only. best_place, the world matrix and the expected walk do not need the tool names.
static func edge_of(a: Dictionary, b: Dictionary, place: int, reach: float, height: float, southpaw: int, stepin: int) -> float:
	var va := pack(a)
	var vb := pack(b)
	var sa := _ob(va, vb, place, reach, height, southpaw, stepin, 0)
	var sb := _ob(vb, va, place, reach, height, southpaw, stepin, 1)
	var e := K * (sa.x - sb.x) + PACE_WORK * (va[Q_PACE] - vb[Q_PACE]) / 100.0
	if place == INSIDE:
		var tie := _tie(va) - _tie(vb)
		if (e < 0.0 and tie > 0.0) or (e > 0.0 and tie < 0.0):
			e *= 1.0 - minf(TIE_MAX, absf(tie) / TIE_DAMP)
	return e


## The place where a does best against b (ties go nearer the dial's own default).
static func best_place(a: Dictionary, b: Dictionary, ctx: Dictionary) -> int:
	var reach := float(ctx.get("reach", 0.0))
	var height := float(ctx.get("height", 0.0))
	var southpaw := int(ctx.get("southpaw", 0))
	var stepin := int(ctx.get("stepin", -1))
	var dial := dial_place(a)
	var top := 0
	var val := -INF
	for p in 3:
		var e := edge_of(a, b, p, reach, height, southpaw, stepin) - 0.01 * absf(float(p - dial))
		if e > val:
			val = e
			top = p
	return top


## Where the forward dial takes a fighter left alone: walks down -> inside, backs off -> long.
static func dial_place(a: Dictionary) -> int:
	var fw := v(a, "forward")
	return INSIDE if fw >= 65.0 else (LONG if fw <= 35.0 else POCKET)


## The chance of each place being wanted: the best response found with chance ring IQ / 100, else the dial's place.
## forced >= 0 = a call or a game sets it.
static func wants(a: Dictionary, b: Dictionary, ctx: Dictionary, forced: int = -1) -> Array:
	var out := [0.0, 0.0, 0.0]
	if forced >= 0:
		out[forced] = 1.0
		return out
	var iq := clampf(0.25 + v(a, "ring_iq") / 100.0, 0.0, 1.0)
	out[best_place(a, b, ctx)] += iq
	out[dial_place(a)] += 1.0 - iq
	return out


## How well a fighter takes the fight the way `dir` (+1 closer, -1 longer, 0 hold) from `place`; pinned on the ropes costs.
static func control(a: Dictionary, dir: int, place: int, pinned: bool) -> float:
	var c := _ctrl(pack(a), dir, place, pinned)
	return c * (1.0 + float(a.get("open_add", 0.0))) if dir < 0 else c   # S459 the named Out-boxer steers it open +0.1 (StyleName)


static func _ctrl(u: PackedFloat32Array, dir: int, place: int, pinned: bool) -> float:
	var op := u[Q_FOOT] * 0.35 + u[Q_FSPD] * 0.3 + u[Q_JAB] * 0.25 + u[Q_TIME] * 0.1
	var cl := u[Q_FOOT] * 0.4 + u[Q_FSPD] * 0.3 + u[Q_HEAD] * 0.2 + u[Q_STR] * 0.1
	var feet := 0.5 * (u[Q_FOOT] + u[Q_FSPD])
	var gate := clampf((feet - CLOSE_FEET_AT) / CLOSE_FEET_SPAN, 0.2, 1.15)
	var urge := clampf(u[Q_FWD] - 50.0, -FWD_CAP, FWD_CAP)
	var c := cl + FORWARD_CLOSE * urge * gate if dir > 0 else (op if dir < 0 else (op + cl) * 0.5)
	if place == INSIDE:
		c = c * (1.0 - INSIDE_STRENGTH) + u[Q_STR] * INSIDE_STRENGTH
	if pinned:
		c -= ROPES * (1.3 - u[Q_COMP] / 100.0)
	return c


## The ladder's moves from `place` for wants wa / wb: [[next place, chance, stepin side], ...]. pins = [a pinned, b pinned].
static func moves(a: Dictionary, b: Dictionary, place: int, wa: int, wb: int, pins: Array) -> Array:
	var da := signi(wa - place)
	var db := signi(wb - place)
	if da == db:
		if da == 0:
			return [[place, 1.0, -1]]
		return [[place + da, SAME_WAY, -1], [place, 1.0 - SAME_WAY, -1]]
	var ca := control(a, da, place, bool(pins[0]))
	var cb := control(b, db, place, bool(pins[1]))
	var pa := clampf(0.5 + (ca - cb) / STEER_SPAN, STEER_MIN, STEER_MAX)
	var a_to := place + da
	var b_to := place + db
	if da > 0 and wa - place >= 2 and ca - cb >= TWO_STEP_GAP:
		a_to = mini(wa, place + 2)
	if db > 0 and wb - place >= 2 and cb - ca >= TWO_STEP_GAP:
		b_to = mini(wb, place + 2)
	return [[a_to, pa, (1 if da > 0 else -1) if da != 0 else (0 if db > 0 else -1)],
		[b_to, 1.0 - pa, (0 if db > 0 else -1) if db != 0 else (1 if da > 0 else -1)]]


## Pinned counters after a move: a side that wants it long but is inside, PINNED_AFTER exchanges running, is on the ropes.
static func pin_next(run: int, wanted: int, place: int) -> int:
	return run + 1 if place == INSIDE and wanted < INSIDE else 0


## Rolls one exchange's place: {place, stepin, wa, wb}. roll_* in [0, 1).
static func step(a: Dictionary, b: Dictionary, place: int, ctx: Dictionary, forced_a: int, forced_b: int, pins: Array,
		roll_wa: float, roll_wb: float, roll_move: float) -> Dictionary:
	var wa := _pick(wants(a, b, ctx, forced_a), roll_wa)
	var wb := _pick(wants(b, a, flip(ctx), forced_b), roll_wb)
	var ms := moves(a, b, place, wa, wb, [int(pins[0]) >= PINNED_AFTER, int(pins[1]) >= PINNED_AFTER])
	var r := roll_move
	for m in ms:
		r -= float(m[1])
		if r < 0.0:
			return {"place": int(m[0]), "stepin": int(m[2]) if int(m[0]) > place else -1, "wa": wa, "wb": wb}
	var last: Array = ms[-1]
	return {"place": int(last[0]), "stepin": int(last[2]) if int(last[0]) > place else -1, "wa": wa, "wb": wb}


static func _pick(dist: Array, roll: float) -> int:
	var r := roll
	for i in 3:
		r -= float(dist[i])
		if r < 0.0:
			return i
	return 2 if float(dist[2]) > 0.0 else (1 if float(dist[1]) > 0.0 else 0)


## The same context seen from b's side.
static func flip(ctx: Dictionary) -> Dictionary:
	var c := ctx.duplicate()
	c["reach"] = -float(ctx.get("reach", 0.0))
	c["height"] = -float(ctx.get("height", 0.0))
	c["southpaw"] = -int(ctx.get("southpaw", 0))
	var s := int(ctx.get("stepin", -1))
	c["stepin"] = -1 if s < 0 else 1 - s
	return c


## Body facts between two boxers: {reach, height, southpaw}; southpaw is +1 when a alone is left-handed, -1 when b is.
static func facts(a_body: Dictionary, b_body: Dictionary) -> Dictionary:
	var la := str(a_body.get("stance", "orthodox")).to_lower() == "southpaw"
	var lb := str(b_body.get("stance", "orthodox")).to_lower() == "southpaw"
	var reach := 0.0
	if a_body.has("reach") and b_body.has("reach"):
		reach = float(a_body["reach"]) - float(b_body["reach"])
	var height := 0.0
	if a_body.has("height") and b_body.has("height"):
		height = float(a_body["height"]) - float(b_body["height"])
	return {"reach": reach, "height": height, "lefty": la != lb, "southpaw": int(la) - int(lb)}


## The expected edge of each of n exchanges from the round's opening (long), walking the ladder exactly (ropes included).
## wa / wb = want chances per place (or per exchange: an Array of n such arrays). ea / eb = effective attributes per exchange
## (Arrays of n dicts) or one dict. Returns {edges: [n], share: [long, pocket, inside]}.
static func expect(ea, eb, ctx: Dictionary, wa, wb, n: int, start_states: Dictionary = {}) -> Dictionary:
	var states: Dictionary = start_states.duplicate() if not start_states.is_empty() else {Vector3i(LONG, 0, 0): 1.0}
	var edges: Array = []
	var share := [0.0, 0.0, 0.0]
	for i in n:
		var a: Dictionary = ea[i] if ea is Array else ea
		var b: Dictionary = eb[i] if eb is Array else eb
		var pa: Array = wa[i] if (wa is Array and (wa as Array).size() > 0 and wa[0] is Array) else wa
		var pb: Array = wb[i] if (wb is Array and (wb as Array).size() > 0 and wb[0] is Array) else wb
		var next := {}
		var e := 0.0
		var cache := {}
		for s in states:
			var w := float(states[s])
			for xa in 3:
				if float(pa[xa]) <= 0.0:
					continue
				for xb in 3:
					if float(pb[xb]) <= 0.0:
						continue
					var pw := w * float(pa[xa]) * float(pb[xb])
					for m in moves(a, b, s.x, xa, xb, [s.y >= PINNED_AFTER, s.z >= PINNED_AFTER]):
						var mp := pw * float(m[1])
						if mp <= 0.0:
							continue
						var place := int(m[0])
						var si := int(m[2]) if place > s.x else -1
						var key := Vector2i(place, si)
						if not cache.has(key):
							cache[key] = edge_of(a, b, place, float(ctx.get("reach", 0.0)), float(ctx.get("height", 0.0)), int(ctx.get("southpaw", 0)), si)
						e += mp * float(cache[key])
						share[place] += mp / float(n)
						var ns := Vector3i(place, mini(PINNED_AFTER, pin_next(s.y, xa, place)), mini(PINNED_AFTER, pin_next(s.z, xb, place)))
						next[ns] = float(next.get(ns, 0.0)) + mp
		states = next
		edges.append(e)
	return {"edges": edges, "share": share, "states": states}


## "Lucy's jab against Maria's head movement" for the winner's best tool at the exchange's place.
static func duel_words(winner: String, loser: String, tool: String, stance: String = "orthodox") -> String:
	var attack := str(TOOL_WORD.get(tool, tool))
	if tool == "right":
		attack = "straight left" if stance.to_lower() == "southpaw" else "right hand"
	return "%s's %s against %s's %s" % [winner, attack, loser, str(ANSWER_WORD.get(tool, "defence"))]


## The fighter page's keys: attack at each place, defence across those places, power, durability and engine.
static func keys(a: Dictionary) -> Array:
	var out: Array = []
	for p in 3:
		var s := 0.0
		for t in TOOLS[p]:
			s += mix(a, t["atk"]) / float((TOOLS[p] as Array).size())
		out.append({"name": ["Long game", "Pocket", "Inside"][p], "value": s})
	var defence := 0.0
	for p in 3:
		for t in TOOLS[p]:
			defence += mix(a, t["ans"]) / 9.0
	out.append({"name": "Defence", "value": defence})
	out.append({"name": "Power", "value": v(a, "power")})
	out.append({"name": "Durability", "value": v(a, "durability")})
	out.append({"name": "Stamina", "value": v(a, "stamina")})
	return out
