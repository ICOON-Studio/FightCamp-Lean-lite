extends RefCounted
## PUSHPROBE2 (S443, operator Q-S294-203 "Measure now"): the probe-only rules of PUSHTANK map v2
## (ops/research/PUSHTANK_MAP_V2_S442.md sections 3 and 5) that arms B-D lay on top of the game's REAL bout. Nothing here is
## game code and nothing here rolls a punch, a round or a result: tools/pushprobe2.gd plays every exchange through
## Bouts.fight_step + LiveRound and this file only says what the corner calls and keeps the new bars' sums (LEGS, the head
## per exchange, the opponent's HANDS). Every number the map marks NEW / ESTIMATE is a named constant below. Pure static.

const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const Knockdowns := preload("res://scripts/rules/Knockdowns.gd")
const PaceAim := preload("res://scripts/rules/PaceAim.gd")
const Duels := preload("res://scripts/rules/Duels.gd")

## 3.1 HANDS. Coast is the game's "save" pace (edge -4, drain x0.6, landed x0.75, CODE) WITHOUT the flat refill.
const PACE_OF := {"push": "push", "steady": "steady", "coast": "save"}
const COAST_REFILL := 0.0        # NEW: today PaceAim.SAVE_RECOVER 6 an exchange (the "Push five, Save one" cause)
const SHOUT_CHANGES := 2         # NEW: a mid-round change of HANDS or FEET is one of the round's two full shouts
## 3.2 FEET and LEGS.
const PRESS_DIAL := 75.0         # NEW: Press = the forward dial at 75 (Duels.FORWARD_CLOSE's close bonus, the dial's own place)
const MOVE_DIAL := 25.0          # NEW (probe reading of "wants long"): dial 25, Duels.dial_place goes long under 35
const LEGS_BASE := 2.0           # NEW ESTIMATE: legs spent an exchange before the factors
const LEGS_MULT := {"press": 1.5, "hold": 0.7, "move": 1.0}   # NEW
const LEGS_PRESSED := 1.3        # CODE size (BodyLoad.SIT_LEGS press): the side being pressed
const LEGS_WIND_LINK := 0.5      # CODE (BodyLoad.TANK_MULT): x (1 + 0.5 x (1 - wind / 100))
const LEGS_FIT_TOP := 1.2        # NEW: fitness x (1.2 - 0.4 x mean(Stamina, Footwork) / 100)
const LEGS_FIT_SPAN := 0.4
const LEGS_INSIDE := 0.5         # CODE (BodyLoad.INSIDE_LEGS): inside the feet half stop
const LEGS_PER_BODY := 0.6       # NEW: a body shot taken costs 0.6 legs over the next round
const LEGS_REST := 0.2           # NEW: the minute gives back 20 % of the round's legs spend
const LEGS_CUT_SHARE := 0.5      # NEW: half the weight cut's first-bell drain comes off the legs
const LEGS_FADE_FROM := 50.0     # NEW: the legs fade is a cliff, t = clamp((50 - legs) / 30, 0, 1)
const LEGS_FADE_SPAN := 30.0
const LEGS_NO_PRESS := 30.0      # NEW: under 30 legs Press acts as Hold
const LEGS_KEYS := ["guard", "head_movement", "footwork", "foot_speed"]   # CODE: Duels.effective's TIRED_LEGS side
## 3.3 HEAD per exchange: the exchange's loser takes its band's round damage / 6, the winner WINNER_DAMAGE / 6.
const HEAD_SPLIT := 6.0          # NEW
const HEAD_WIND_AT := 35.0       # NEW: hands drop
const HEAD_WIND_MULT := 1.2
const HEAD_LEGS_AT := 30.0       # NEW: planted, can't roll
const HEAD_LEGS_MULT := 1.3
const HEAD_HURT_PUSH := 1.3      # NEW (boxing critic's must): hurt, told to Push, open while trading
## 3.5 the opponent's HANDS (NEW): pushers push rounds 1-2, a counter-puncher coasts ahead, a fader coasts round 2, anyone
## behind in the last round pushes.
const OPP_PUSHERS := ["Swarmer", "Volume puncher"]
## The coach's reads (map section 5).
const PUSH_WORTH := 40.0         # CODE: Push is worth 0 at 40 (PaceAim.PUSH_GAS_FROM 55 .. 12 a 30 span)
const PUSH_45 := 45.0
const PUSH_55 := 55.0
const OPP_LOW_GAP := 15.0        # NEW: "their wind lower" = 15 under ours (film read)
const CUT_DRAINED := 15.0        # NEW: drained by the cut = 15 or more off at the first bell
const HEAD_LOW := 40.0           # case 15


## ---- LEGS ----
static func legs_spend(feet: String, pressed: bool, wind: float, stamina: float, footwork: float, inside: bool) -> float:
	var s := LEGS_BASE * float(LEGS_MULT.get(feet, 0.7))
	if pressed:
		s *= LEGS_PRESSED
	s *= 1.0 + LEGS_WIND_LINK * (1.0 - clampf(wind, 0.0, 100.0) / 100.0)
	s *= LEGS_FIT_TOP - LEGS_FIT_SPAN * (stamina + footwork) * 0.5 / 100.0
	if inside:
		s *= LEGS_INSIDE
	return s


static func legs_t(legs: float) -> float:
	return clampf((LEGS_FADE_FROM - legs) / LEGS_FADE_SPAN, 0.0, 1.0)


## The wind fade Duels.effective applies (CODE, copied so the legs side can be handed to LEGS): t from energy, heart late.
static func wind_t(energy: float, late: bool, heart: float) -> float:
	var t := clampf((Duels.TIRED_AT - energy) / Duels.TIRED_AT, 0.0, 1.0)
	if late and t > 0.0:
		t = maxf(t * 0.5, t * (1.3 - heart / 100.0))
	return t


## What to add to each legs-side attribute so Duels.effective's wind fade there becomes the LEGS fade (map 3.2 rule 5).
static func legs_shift(energy: float, late: bool, heart: float, legs: float) -> float:
	return Duels.TIRED_LEGS * (wind_t(energy, late, heart) - legs_t(legs))


## The opponent's FEET from the game it plays (its place, RingDuel.MODE_PLACE): press walks in, range moves, the rest holds.
static func opp_feet(mode: String) -> String:
	if mode == "press":
		return "press"
	if mode == "range" or mode == "tiring":
		return "move"
	return "hold"


## ---- HEAD ----
## [ours, theirs] head damage of one exchange. links_a / links_b = the multipliers on what each side takes.
static func head_ex(margin: float, won: bool, links_a: float, links_b: float) -> Array:
	var big := float(Knockdowns.DAMAGE_PER_ROUND[Exchanges.band(margin)]) / HEAD_SPLIT
	var small := Knockdowns.WINNER_DAMAGE / HEAD_SPLIT
	return [(small if won else big) * links_a, (big if won else small) * links_b]


static func head_links(wind: float, legs: float, hurt_push_lost: bool) -> float:
	var k := 1.0
	if wind < HEAD_WIND_AT:
		k *= HEAD_WIND_MULT
	if legs < HEAD_LEGS_AT:
		k *= HEAD_LEGS_MULT
	if hurt_push_lost:
		k *= HEAD_HURT_PUSH
	return k


## ---- the opponent's HANDS ----
static func opp_hands(style: String, weak: String, n: int, total: int, opp_won: int, opp_lost: int) -> String:
	if n == total and opp_won < opp_lost:
		return "push"
	if OPP_PUSHERS.has(style) and n <= 2:
		return "push"
	if style == "Counter-puncher" and opp_won > opp_lost:
		return "coast"
	if weak.begins_with("Fades") and n == 2:
		return "coast"
	return "steady"


## Our edge in power points from the opponent's HANDS (their PaceAim edge, with their own push fade, turned round).
static func opp_edge(hands: String, opp_energy: float) -> float:
	var pace := str(PACE_OF.get(hands, "steady"))
	return -(PaceAim.edge(pace, "", {}, {}) - PaceAim.push_gassed(pace, opp_energy))


## ---- the cells and the policies ----
## The opponents (fictional, probe-only): [style, threat, weak]. Two per cell (A orthodox, B southpaw +1.5 rating).
const OPPS := {"even": ["Boxer-puncher", "Straight right", "Stands still after combinations"],
	"body": ["Pressure fighter", "Left hook to the body", "Leaves the chin open"],
	"mover": ["Out-boxer", "Long jab, keeps you on the end of it", "Backs straight onto the ropes"],
	"slow": ["Counter-puncher", "Right hand counter over the jab", "Slow to start"],
	"fader": ["Boxer-puncher", "Straight right", "Fades after round 2"],
	"swarmer": ["Swarmer", "Never stops throwing", "Leaves the chin open"],
	"volume": ["Volume puncher", "Never stops throwing", "Leaves the chin open"]}
## The cells: the map's 17 cases as starting states plus the critics' missing ones. s3/s6 = the round the policy takes over
## (rounds before are played Steady + Hold on the auto corner), sc3/sc6 = the rounds [won, lost] set at that bell.
const CELLS := [
	{"id": "c1_ahead", "s3": 3, "sc3": [2, 0], "s6": 5, "sc6": [3, 1]},
	{"id": "c2_behind", "s3": 3, "sc3": [0, 2], "s6": 5, "sc6": [1, 3]},
	{"id": "c3_level", "s3": 3, "sc3": [1, 1], "s6": 5, "sc6": [2, 2]},
	{"id": "c4_opp_hurt", "s3": 2, "s6": 2, "ohurt": true},
	{"id": "c5_hurt", "s3": 2, "s6": 2, "hurt": true},
	{"id": "c6_body", "opp": "body"},
	{"id": "c7_mover", "opp": "mover"},
	{"id": "c8_opp_low", "s3": 2, "s6": 2, "odrop": 20.0},
	{"id": "c9_slow", "opp": "slow"},
	{"id": "c10_fader", "opp": "fader"},
	{"id": "c11_fuse", "s3": 2, "sc3": [0, 1], "s6": 2, "sc6": [0, 1], "temper": 85.0, "dmg": 18.0},
	{"id": "c12_cut", "stale": 20.0},
	{"id": "c13_close"},
	{"id": "c14_pinned", "opp": "swarmer"},
	{"id": "c15_underdog", "off": 5.0},
	{"id": "c16_war", "opp": "volume"},
	{"id": "c17_r4", "only6": true, "s6": 4, "sc6": [2, 1]},
	{"id": "x_count", "s3": 2, "sc3": [0, 1], "s6": 2, "sc6": [0, 1], "count": true, "dmg": 20.0},
	{"id": "x_stance", "switch": 2},
	{"id": "x_favourite", "off": -5.0},
]
const POLS := {"A": ["hold", "push", "push45", "push55", "p5c1", "coach"], "B": ["hold", "push", "push45", "push55", "p5c1", "coach"],
	"C": ["hold", "push", "push45", "push55", "p5c1", "coach", "coach_cm"],
	"D": ["hold", "push45", "push55", "press", "move", "pushpress", "p5c1", "coach", "coach_cm", "coach_nocall"],
	"E": ["ice_never", "ice_all", "ice_30", "coach"]}
const HABITS := {"A": ["hold", "push", "push45", "push55", "p5c1"], "B": ["hold", "push", "push45", "push55", "p5c1"],
	"C": ["hold", "push", "push45", "push55", "p5c1"], "D": ["hold", "push45", "push55", "press", "move", "pushpress", "p5c1"],
	"E": ["ice_never", "ice_all", "ice_30"]}


## ---- Arm E (operator S443 "yes add it to the measurement"): the corner minute in SECONDS, with neck ice ----
## Arm E = arm D + this minute. Every E policy fights on the COACH's HANDS and FEET and gets the same hands jobs (water,
## rib ice when 3+ body shots were taken, the coach's talk); the policies differ only in the neck ice (and the coach's rub).
const MINUTE_S := 60.0           # ESTIMATE: the corner minute
const SECONDS_OUT := 50.0        # ESTIMATE: "seconds out" at 0:10 left; hands still busy past it = a late exit (a warning)
const JOB_S := {"water": 10.0, "ribs": 15.0, "talk": 7.0, "rub": 8.0}   # ESTIMATE seconds a job (talk 5-10)
const WATER_POINTS := 2          # ESTIMATE: two water points every minute (the game's CornerJobs water, +3 / +6 each)
const RIBS_AT := 3               # rib ice (one CornerJobs ice point) when this many body shots were taken
const ICE_MAX := 0.15            # ESTIMATE: neck ice takes at most 15 % off the next round's wind drain
const ICE_TAU := 20.0            # ESTIMATE: diminishing return, cut = ICE_MAX x (1 - exp(-seconds / 20))
const ICE_COLD_AT := 30.0        # ESTIMATE: past this dose, or iced the minute before too, the shoulders go cold
const COLD_SNAP := 4.0           # ESTIMATE: cold shoulders: hand speed and power -4 in the next round's first 30 s
const ICE_ALL := 50.0            # "always neck ice the whole minute" = on until seconds out
const ICE_30 := 30.0
const ICE_COACH := 20.0          # the coach's dose: under the cold line
const ICE_COACH_WIND := 60.0     # the coach ices when the wind at the minute is under this, or the next round is the last


static func ice_cut(sec: float) -> float:
	return ICE_MAX * (1.0 - exp(-maxf(0.0, sec) / ICE_TAU))


## The minute's plan in seconds: {water, ribs, rub, ice, late, cold}. Hands jobs run one after another; one still running at
## 0:00 is cut and does nothing; neck ice runs on its own (no hands). cold = the next round opens with cold shoulders.
static func minute_plan(pol: String, s: Dictionary, talk: bool, iced_last: bool, body_taken: int) -> Dictionary:
	var ice := 0.0
	match pol:
		"ice_all": ice = ICE_ALL
		"ice_30": ice = ICE_30
		"coach": ice = ICE_COACH if float(s["wind"]) < ICE_COACH_WIND or int(s["n"]) == int(s["total"]) else 0.0
	var cold := ice > ICE_COLD_AT or (ice > 0.0 and iced_last)
	var jobs: Array = []
	for w in WATER_POINTS:
		jobs.append("water")
	if body_taken >= RIBS_AT:
		jobs.append("ribs")
	if talk:
		jobs.append("talk")
	if pol == "coach" and cold:
		jobs.append("rub")
	var t := 0.0
	var out := {"water": 0, "ribs": 0, "rub": false, "ice": ice, "late": false, "cold": cold}
	for j in jobs:
		t += float(JOB_S[j])
		if t > MINUTE_S:
			break
		if j == "water":
			out["water"] = int(out["water"]) + 1
		elif j == "ribs":
			out["ribs"] = 1
		elif j == "rub":
			out["rub"] = true
			out["cold"] = false
	out["late"] = t > SECONDS_OUT
	return out


## ---- the policies ----
## s = what the corner sees: n, total, i (exchange 0-5; 0 = the minute), won_r, lost_r (rounds), ex_w, ex_l (this round),
## wind, owind, legs, hurt, ohurt, pinned, style, threat, weak (the opponent's file), head, stale, count_fresh, temper,
## stamina, chin, ostamina, ochin. Returns {hands, feet, call, plan, talk}.
const NAMES := {"hold": "Steady + Hold always (today)", "push45": "Push while wind > 45", "push55": "Push while wind > 55",
	"press": "always Press", "move": "always Move", "pushpress": "Push + Press always", "p5c1": "Push five, Coast one",
	"push": "always Push", "coach": "COACH (case table)", "coach_cm": "COACH, hurt = Coast + Move (critic)",
	"coach_nocall": "COACH without its calls", "holdcheck": "D layers off, Hold (= A today?)"}


static func act(h: String, ft: String, call: String = "", plan: String = "", talk: String = "") -> Dictionary:
	return {"hands": h, "feet": ft, "call": call, "plan": plan, "talk": talk}


static func decide(pol: String, s: Dictionary) -> Dictionary:
	var wind := float(s["wind"])
	match pol:
		"hold", "holdcheck":
			return act("steady", "hold")
		"push":
			return act("push", "hold")
		"push45":
			return act("push" if wind > PUSH_45 else "steady", "hold")
		"push55":
			return act("push" if wind > PUSH_55 else "steady", "hold")
		"press":
			return act("steady", "press")
		"move":
			return act("steady", "move")
		"pushpress":
			return act("push", "press")
		"p5c1":
			return act("coast" if int(s["i"]) == 5 else "push", "hold")
		"coach", "coach_cm":
			return coach(s, pol == "coach_cm")
		"coach_nocall":
			var a := coach(s, false)
			a["call"] = ""
			a["talk"] = ""
			return a
	return act("steady", "hold")


## The case table (map v2 section 5), read from what the corner sees, never the cards.
static func coach(s: Dictionary, critic: bool) -> Dictionary:
	var n := int(s["n"])
	var total := int(s["total"])
	var i := int(s["i"])
	var wind := float(s["wind"])
	var legs := float(s["legs"])
	var gas := wind > PUSH_WORTH
	var style := str(s["style"])
	var weak := str(s["weak"])
	# 5 our fighter hurt (map: Push above 40 + Move, Tie up; the boxing critic: Coast + Move, Tie up)
	if bool(s["hurt"]):
		if critic:
			return act("coast", "move", "tie")
		return act("push" if gas else "steady", "move", "tie")
	# (critic) just took a count: the standing eight - hold and move for 30 s
	if bool(s["count_fresh"]) and i <= 1:
		return act("coast" if critic else "steady", "move")
	# 4 opponent hurt
	if bool(s["ohurt"]) and gas:
		return act("push", "press", "finish")
	# 14 pinned on the ropes
	if bool(s["pinned"]):
		return act("steady", "move") if legs > LEGS_NO_PRESS else act("steady", "hold", "tie")
	var ex_w := int(s["ex_w"])
	var ex_l := int(s["ex_l"])
	# 13 steal the last 30 seconds: 2-3 down before the last exchange
	if i == 5 and ex_w == 2 and ex_l == 3:
		return act("push" if gas else "steady", "press" if legs > LEGS_NO_PRESS else "hold")
	# 15 a round already lost (4 down, two left)
	if i >= 4 and ex_l >= 4:
		return act("coast", "move") if float(s["head"]) < HEAD_LOW else act("steady", "hold")
	# 1-3 the deciding rounds: the score from the rounds the corner has seen
	var left := total - n + 1
	if n == total or (total >= 6 and n >= total - 1):
		var diff := int(s["won_r"]) - int(s["lost_r"])
		if diff >= left:
			return act("steady", "move")
		if -diff >= left:
			return act("push", "press", "finish" if bool(s["ohurt"]) else "")
		if diff == 0:
			return act("push", "press") if gas else act("steady", "hold")
		if diff > 0:
			return act("steady", "move")
		return act("push", "press") if gas else act("steady", "hold")
	# 17 a long bout, round 4 on: Steady + Hold, Push only in a close round
	if total >= 6 and n >= 4:
		return act("push" if gas and i >= 3 and absi(ex_w - ex_l) <= 1 else "steady", "hold")
	# 11 short fuse after a lost round: the talk at the minute
	var talk := "calm" if i == 0 and float(s["temper"]) >= 65.0 and bool(s["lost_last"]) else ""
	# 12 drained by the weight cut
	if float(s["stale"]) >= CUT_DRAINED:
		return act("steady", "move", "", "", talk)
	# 9 slow starter: push round 1
	if n == 1 and weak.to_lower().contains("slow to start"):
		return act("push", "press", "", "", talk)
	# 10 fader: Steady + Hold with the body plan for two rounds, then spend
	if weak.begins_with("Fades"):
		if n <= 2:
			return act("steady", "hold", "", "body", talk)
		return act("push" if gas else "steady", "press", "", "", talk)
	# 8 their wind lower (film)
	if float(s["owind"]) < wind - OPP_LOW_GAP:
		return act("steady", "press", "", "", talk)
	# 6 body puncher
	if str(s["threat"]).to_lower().contains("body"):
		return act("steady", "move", "", "", talk)
	# 7 a mover
	if style == "Out-boxer":
		return act("push" if gas else "steady", "hold", "", "", talk)
	# 16 two pushers
	if OPP_PUSHERS.has(style):
		var ours := float(s["stamina"]) + float(s["chin"])
		var theirs := float(s["ostamina"]) + float(s["ochin"])
		return act("push" if gas else "steady", "hold", "", "", talk) if ours >= theirs else act("steady", "move", "", "", talk)
	return act("steady", "hold", "", "", talk)


## ---- the report (what tools/pushprobe2.gd prints; agg = arm|L|cell|pol -> sums and the per-bout outcomes) ----
static func pts(o: int) -> float:
	return 1.0 if o == 2 else (0.5 if o == 1 else 0.0)


static func rate(g: Dictionary) -> float:
	return 100.0 * (float(g["w"]) + 0.5 * float(g["d"])) / maxf(1.0, float(g["n"]))


## Paired difference (points a bout, x100) of policy a over b across the cells: [mean, 95 % half-width, bouts].
static func paired(agg: Dictionary, arm: String, L: int, ids: Array, a: String, b: String) -> Array:
	var s := 0.0
	var s2 := 0.0
	var k := 0
	for cid in ids:
		var ka := "%s|%d|%s|%s" % [arm, L, cid, a]
		var kb := "%s|%d|%s|%s" % [arm, L, cid, b]
		if not agg.has(ka) or not agg.has(kb):
			continue
		var oa: PackedByteArray = agg[ka]["out"]
		var ob: PackedByteArray = agg[kb]["out"]
		for j in mini(oa.size(), ob.size()):
			var d := 100.0 * (pts(oa[j]) - pts(ob[j]))
			s += d
			s2 += d * d
			k += 1
	if k < 2:
		return [0.0, 0.0, k]
	var mean := s / k
	var sd := sqrt(maxf(0.0, (s2 - k * mean * mean) / (k - 1)))
	return [mean, 1.96 * sd / sqrt(float(k)), k]


static func bells(g: Dictionary, key: String) -> String:
	var out := PackedStringArray()
	for b in g[key]:
		out.append("%.0f" % (float(b[0]) / maxf(1.0, float(b[1]))))
	return "/".join(out)


static func report(agg: Dictionary, arms: Array, lens: Array, cells: Array, pilot: bool) -> void:
	var all_arms: Array = arms.duplicate()
	if pilot:
		all_arms.append("H")
	for arm in all_arms:
		for L in lens:
			var ids: Array = []
			for cl in cells:
				if not (bool(cl.get("only6", false)) and int(L) != 6):
					ids.append(str(cl["id"]))
			var pols: Array = ["holdcheck"] if arm == "H" else POLS[arm]
			for cid in ids:
				for pol in pols:
					var key := "%s|%d|%s|%s" % [arm, L, cid, pol]
					if not agg.has(key):
						continue
					var g: Dictionary = agg[key]
					print("P2 ROW %s L%d %-12s %-12s n=%d win=%.1f stopL=%.1f stopW=%.1f rest=%.2f head=%.1f ohead=%.1f wind=%s legs=%s legs3u50=%.0f late=%d" % [arm, L, cid, pol,
						int(g["n"]), rate(g), 100.0 * g["sl"] / g["n"], 100.0 * g["sw"] / g["n"], g["rest"] / g["n"], g["head"] / g["n"],
						g["ohead"] / g["n"], bells(g, "wind"), bells(g, "legs"), 100.0 * g["low"] / g["n"], int(g["late"])])
			if arm == "H":
				var same := 0
				var tot := 0
				for cid in ids:
					var kh := "H|%d|%s|holdcheck" % [L, cid]
					var ka := "A|%d|%s|hold" % [L, cid]
					if agg.has(kh) and agg.has(ka):
						var oh: PackedByteArray = agg[kh]["out"]
						var oa: PackedByteArray = agg[ka]["out"]
						for j in mini(oh.size(), oa.size()):
							tot += 1
							same += 1 if oh[j] == oa[j] else 0
						print("P2 HOLDCHECK L%d %s: identical results %d of %d; head %.3f vs %.3f" % [L, cid, same, tot,
							agg[kh]["head"] / agg[kh]["n"], agg[ka]["head"] / agg[ka]["n"]])
				continue
			var habits: Array = HABITS[arm]
			var best_n := {}
			var mean := {}
			for pol in pols:
				mean[pol] = 0.0
			for cid in ids:
				var top := ""
				var topv := -1.0
				for pol in pols:
					var key := "%s|%d|%s|%s" % [arm, L, cid, pol]
					if agg.has(key):
						mean[pol] = float(mean[pol]) + rate(agg[key]) / ids.size()
						if habits.has(pol) and rate(agg[key]) > topv:
							topv = rate(agg[key])
							top = pol
				best_n[top] = int(best_n.get(top, 0)) + 1
			var line := PackedStringArray()
			for pol in pols:
				line.append("%s %.1f" % [pol, float(mean[pol])])
			print("P2 MEAN %s L%d over %d cells: %s" % [arm, L, ids.size(), ", ".join(line)])
			var worst := ["", 0]
			for h in best_n:
				if int(best_n[h]) > int(worst[1]):
					worst = [h, int(best_n[h])]
			print("P2 BEST %s L%d habit best per cell: %s | most: %s %d of %d (%.0f%%, line <= 60%%: %s)" % [arm, L, str(best_n), worst[0],
				worst[1], ids.size(), 100.0 * int(worst[1]) / ids.size(), "PASS" if int(worst[1]) * 10 <= ids.size() * 6 else "FAIL"])
			for co in ["coach", "coach_cm", "coach_nocall"]:
				if not pols.has(co):
					continue
				var beats := true
				var parts := PackedStringArray()
				for h in habits:
					var p := paired(agg, arm, L, ids, co, h)
					parts.append("%s %+.1f+-%.1f" % [h, float(p[0]), float(p[1])])
					beats = beats and float(p[0]) >= 3.0
				print("P2 COACH %s L%d %s minus each habit (points x100, 95%%): %s | beats every habit by 3: %s" % [arm, L, co, ", ".join(parts), "PASS" if beats else "FAIL"])
			if arm == "E":
				ice_report(agg, L, ids)
				continue
			var p5 := paired(agg, arm, L, ids, "p5c1", "push45")
			var p5h := paired(agg, arm, L, ids, "p5c1", "hold")
			print("P2 P5 %s L%d Push five, %s one: minus Push>45 %+.1f+-%.1f, minus Steady %+.1f+-%.1f, best in %d cells" % [arm, L,
				"Breathe" if arm == "B" else ("Save" if arm == "A" else "Coast"), float(p5[0]), float(p5[1]), float(p5h[0]), float(p5h[1]), int(best_n.get("p5c1", 0))])
			if pols.has("coach_cm"):
				var hc := paired(agg, arm, L, ids, "coach_cm", "coach")
				var h5 := paired(agg, arm, L, ["c5_hurt"], "coach_cm", "coach")
				print("P2 HURT %s L%d Coast+Move when hurt minus the map's Push+Move: all cells %+.1f+-%.1f, cell c5 %+.1f+-%.1f" % [arm, L,
					float(hc[0]), float(hc[1]), float(h5[0]), float(h5[1])])


## Does the neck ice change anything? Each ice policy against "never ice", per cell and overall (paired, 95 %).
static func ice_report(agg: Dictionary, L: int, ids: Array) -> void:
	for pol in ["ice_all", "ice_30", "coach"]:
		var p := paired(agg, "E", L, ids, pol, "ice_never")
		var moved := PackedStringArray()
		for cid in ids:
			var q := paired(agg, "E", L, [cid], pol, "ice_never")
			if absf(float(q[0])) > float(q[1]) and float(q[0]) != 0.0:
				moved.append("%s %+.1f" % [cid, float(q[0])])
		var dh := 0.0
		for cid in ids:
			var ka := "E|%d|%s|%s" % [L, cid, pol]
			var kn := "E|%d|%s|ice_never" % [L, cid]
			if agg.has(ka) and agg.has(kn):
				dh += (float(agg[ka]["head"]) / agg[ka]["n"] - float(agg[kn]["head"]) / agg[kn]["n"]) / ids.size()
		print("P2 ICE L%d %s minus never ice: wins %+.1f+-%.1f over all cells, head at the last bell %+.2f; cells where it moves the result beyond noise: %s" % [L, pol,
			float(p[0]), float(p[1]), dh, ", ".join(moved) if not moved.is_empty() else "none"])
