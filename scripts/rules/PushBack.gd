extends RefCounted
## S361 she pushes back (Q-S294-86 "Yes, build them", Miro top-5 card 2; verdict Game/Godot/research/MIRO_TOP5_S357.md):
## some weeks the twist card is HER ask (WeekTwist.ASKS), rooted in who she is - a fighter low on discipline wants the
## Hard mornings eased, a confident or hot-headed one wants to spar, one who fades late wants to run, a pressure fighter
## wants the bag, and anyone the last week overreached wants a day off. One card a week stays one choice a week (Kalli's
## warning in CORE3: no pile of picks): her ask takes the drawn card's place. Pure static.
## Real coaching: athletes who get a say stick to the plan and trust the coach more (autonomy-supportive coaching, Mageau &
## Vallerand 2003); one who is always overruled stops listening - here, a lower morale = less of the corner's word taken in
## (FighterProfile.trust).
##   reasons(f, days, evs, peak) -> [ask ids she has a reason for this week]   pick(f, week, days, evs, peak, prev) -> id | ""

const WeekTwist := preload("res://scripts/rules/WeekTwist.gd")

## How often she asks when she has a reason: 60 % of those weeks at coachability 0, 20 % at 100 (a fighter who takes
## orders well asks less).
const ASK_MOST := 0.6
const ASK_LEAST := 0.2
## The last week's fatigue peak that makes her ask: a day off at 75 (WeekPlan.OVERREACHED is 80), easier mornings at 68.
const PEAK_REST := 75.0
const PEAK_EASY := 68.0
const LOW_DISCIPLINE := 50.0
const HIGH_TRAIT := 65.0
const SPAR_HABITS := ["chases_stoppage", "talks_when_ahead"]
const ROAD_HABITS := ["fades_late", "clinches_when_tired"]
const BAG_HABITS := ["loads_up_when_hurt", "one_and_done"]
const BAG_STYLES := ["Pressure fighter", "Slugger"]


## The asks she has a reason for, given next week's mornings (days, [[session, intensity] x 7]), evenings and the last
## week's fatigue peak; each one only when her way would change that week.
static func reasons(f: Dictionary, days: Array, evs: Array, peak: float) -> Array:
	var p: Dictionary = f.get("personality", {})
	var habits: Array = f.get("habits", [])
	var hard := days.any(func(d): return str(d[1]) == "hard")
	var want: Array = []
	if peak >= PEAK_REST:
		want.append("ask_rest")
	if hard and (float(p.get("discipline", 55.0)) < LOW_DISCIPLINE or peak >= PEAK_EASY):
		want.append("ask_easy")
	if float(p.get("confidence", 55.0)) >= HIGH_TRAIT or float(p.get("temper", 55.0)) >= HIGH_TRAIT or _any(habits, SPAR_HABITS):
		want.append("ask_spar")
	if _any(habits, ROAD_HABITS):
		want.append("ask_road")
	if BAG_STYLES.has(str(f.get("style", ""))) or _any(habits, BAG_HABITS):
		want.append("ask_bag")
	return want.filter(func(id): return WeekTwist.touches(_her_way(id), days, evs))


## This week's ask, or "" (no reason, her coachability kept her quiet this week, or it was last week's card too).
static func pick(f: Dictionary, week: int, days: Array, evs: Array, peak: float, prev: String = "") -> String:
	var want := reasons(f, days, evs, peak).filter(func(id): return id != prev)
	if want.is_empty():
		return ""
	var rng := RandomNumberGenerator.new()
	rng.seed = week * 6151 + hash(str(f.get("id", ""))) % 100003
	var coach := clampf(float((f.get("personality", {}) as Dictionary).get("coachability", 55.0)), 0.0, 100.0)
	if rng.randf() >= lerpf(ASK_MOST, ASK_LEAST, coach / 100.0):
		return ""
	if want.has("ask_rest"):
		return "ask_rest"   # worn out comes first
	return str(want[rng.randi_range(0, want.size() - 1)])


## One plain clause saying why this ask came up; "" for an unknown id. Reads the same conditions as reasons(),
## first match wins. No rng, no pronouns.
static func why(id: String, f: Dictionary, peak: float) -> String:
	var p: Dictionary = f.get("personality", {})
	var habits: Array = f.get("habits", [])
	match id:
		"ask_rest":
			return "last week's fatigue peaked at %d" % roundi(peak)
		"ask_easy":
			if peak >= PEAK_EASY:
				return "last week's fatigue peaked at %d" % roundi(peak)
			if float(p.get("discipline", 55.0)) < LOW_DISCIPLINE:
				return "not one for hard mornings"
			return ""
		"ask_spar":
			if float(p.get("confidence", 55.0)) >= HIGH_TRAIT:
				return "confident and wants rounds"
			if float(p.get("temper", 55.0)) >= HIGH_TRAIT:
				return "hot-headed and wants rounds"
			if _any(habits, SPAR_HABITS):
				return "likes a scrap"
			return ""
		"ask_road":
			if _any(habits, ROAD_HABITS):
				return "fades late in fights"
			return ""
		"ask_bag":
			var st := str(f.get("style", ""))
			if BAG_STYLES.has(st):
				return "a %s wants the bag" % st.to_lower()
			if _any(habits, BAG_HABITS):
				return "wants more power work"
			return ""
	return ""


## The ask card with her answer's effects in it.
static func _her_way(id: String) -> Dictionary:
	var t := WeekTwist.card(id)
	return t.merged(t["a"] as Dictionary, true)


static func _any(have: Array, of: Array) -> bool:
	return of.any(func(h): return have.has(h))
