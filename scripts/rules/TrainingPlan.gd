extends RefCounted
## S351 her week as a plan the player builds (operator on the S349 training board, Q-S294-73: "not that good for training"):
## the board showed her week but the only choice was which session is "main". A coach writes the week as time per session;
## so does the player now: every session has a weight (0-6 blocks) and the week's hours (TrainingLoad) split by weight.
## Real units on the card: boxing work in 3-minute rounds with a minute's rest (4 min a round), roadwork in km at a jog
## (6 min a km), neck work in minutes (S323 research: amateurs train 8-15 h a week; 2-3 sparring days of 4-6 rounds;
## roadwork 20-40 km a week).
## THE GAIN CURVE keeps the old plan's numbers exactly: her default week (main 5 blocks, its partner 3, the pads 3, the
## other five 1 each = 16) gives main 1.0, partner 0.4, the rest 0.06 of a focused week - TrainingPreview's FOCUS /
## PARTNER / OTHER shares. Between those points time pays more the more it is concentrated (a focus works); past a third
## of the week it pays less (one thing all week stops adding). A week never builds more than the default week in total
## (TOTAL_CAP): moving time reshapes her gains, it does not create them.
## The pads' share sets how fast the new move and the combo come (pads_factor; 0 blocks = no new move this week).
## Pure static module - ZERO preloads.

const IDS := ["sparring", "neck", "shadow", "heavy_bag", "speed_bag", "pads", "slip_rope", "roadwork"]
const STAT_OF := {
	"sparring": "fight_iq", "neck": "chin", "shadow": "technique", "heavy_bag": "power", "speed_bag": "speed",
	"slip_rope": "defense", "roadwork": "conditioning",
}
const MAX_BLOCKS := 6
const MAIN_BLOCKS := 5
const SUPPORT_BLOCKS := 3
const PADS_BLOCKS := 3
const OTHER_BLOCKS := 1
const DEFAULT_TOTAL := 16
## share of the week -> fraction of a focused week's gain (piecewise linear through these points).
const CURVE := [[0.0, 0.0], [0.0625, 0.06], [0.1875, 0.4], [0.3125, 1.0], [0.5, 1.3], [1.0, 1.5]]
## The default week's sum of fractions (1.0 + 0.4 + 5 x 0.06): no plan builds more in total.
const TOTAL_CAP := 1.7
const ROUND_MIN := 4.0
const KM_MIN := 6.0
const UNIT := {
	"sparring": "rounds", "neck": "min", "shadow": "rounds", "heavy_bag": "rounds", "speed_bag": "rounds",
	"pads": "rounds", "slip_rope": "rounds", "roadwork": "km",
}


## The week a coach writes for this focus: main 5, its partner 3, the pads 3, the rest 1.
static func default_plan(focus: String, partner: String) -> Dictionary:
	var out := {}
	for id in IDS:
		var stat := str(STAT_OF.get(id, ""))
		if id == "pads":
			out[id] = PADS_BLOCKS
		elif stat == focus:
			out[id] = MAIN_BLOCKS
		elif stat == partner and partner != "":
			out[id] = SUPPORT_BLOCKS
		else:
			out[id] = OTHER_BLOCKS
	return out


## Her saved plan when it is whole and not empty, else the default for her focus.
static func plan_of(saved: Variant, focus: String, partner: String) -> Dictionary:
	if saved is Dictionary and valid(saved):
		var out := {}
		for id in IDS:
			out[id] = clampi(int(saved[id]), 0, MAX_BLOCKS)
		return out
	return default_plan(focus, partner)


static func valid(plan: Dictionary) -> bool:
	for id in IDS:
		if not plan.has(id):
			return false
	return total(plan) > 0


static func total(plan: Dictionary) -> int:
	var n := 0
	for id in IDS:
		n += clampi(int(plan.get(id, 0)), 0, MAX_BLOCKS)
	return n


## One block more (+1) or less (-1) on a session; never below 0, above MAX_BLOCKS, or an empty week.
static func step(plan: Dictionary, id: String, delta: int) -> Dictionary:
	var out := plan.duplicate()
	if not out.has(id):
		return out
	var v := clampi(int(out[id]) + delta, 0, MAX_BLOCKS)
	var was := int(out[id])
	out[id] = v
	if total(out) <= 0:
		out[id] = was
	return out


static func can_step(plan: Dictionary, id: String, delta: int) -> bool:
	var after := step(plan, id, delta)
	return int(after.get(id, 0)) != int(plan.get(id, 0))


## {id: share of the week}; shares sum to 1.
static func shares(plan: Dictionary) -> Dictionary:
	var out := {}
	var t := float(maxi(1, total(plan)))
	for id in IDS:
		out[id] = float(clampi(int(plan.get(id, 0)), 0, MAX_BLOCKS)) / t
	return out


## {id: hours} of a week of load_hours.
static func hours(plan: Dictionary, load_hours: float) -> Dictionary:
	var out := {}
	var sh := shares(plan)
	for id in IDS:
		out[id] = load_hours * float(sh[id])
	return out


static func curve(share: float) -> float:
	var s := clampf(share, 0.0, 1.0)
	for i in range(1, CURVE.size()):
		var a: Array = CURVE[i - 1]
		var b: Array = CURVE[i]
		if s <= float(b[0]):
			var t := (s - float(a[0])) / (float(b[0]) - float(a[0]))
			return lerpf(float(a[1]), float(b[1]), t)
	return float(CURVE[CURVE.size() - 1][1])


## {stat: fraction of a focused week} for every stat a session builds; their sum never passes TOTAL_CAP.
static func fractions(plan: Dictionary) -> Dictionary:
	var out := {}
	var sh := shares(plan)
	var sum := 0.0
	for id in IDS:
		if not STAT_OF.has(id):
			continue
		var f := curve(float(sh[id]))
		out[STAT_OF[id]] = f
		sum += f
	if sum > TOTAL_CAP + 0.000001:
		for k in out.keys():
			out[k] = float(out[k]) * TOTAL_CAP / sum
	return out


## The session with the most blocks (the pads never count; ties go to the earlier session): her main.
static func main_of(plan: Dictionary) -> String:
	var best := ""
	for id in IDS:
		if id == "pads":
			continue
		if best == "" or int(plan.get(id, 0)) > int(plan.get(best, 0)):
			best = id
	return best


static func main_stat(plan: Dictionary) -> String:
	return str(STAT_OF.get(main_of(plan), ""))


## Pad time against the default week's: 1.0 = the usual pace for the new move and the combo, 0 = none, at most 2.
static func pads_factor(plan: Dictionary) -> float:
	var usual := float(PADS_BLOCKS) / float(DEFAULT_TOTAL)
	return clampf(float(shares(plan)["pads"]) / usual, 0.0, 2.0)


## The amount on the card: "12 rounds", "31 km", "40 min" (0 = "off").
static func amount_text(id: String, h: float) -> String:
	var minutes := h * 60.0
	if minutes < 0.5:
		return "off"
	match str(UNIT.get(id, "min")):
		"rounds":
			var r := maxi(1, int(roundf(minutes / ROUND_MIN)))
			return "%d round%s" % [r, "" if r == 1 else "s"]
		"km":
			return "%d km" % maxi(1, int(roundf(minutes / KM_MIN)))
	return "%d min" % int(roundf(minutes))
