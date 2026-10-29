extends RefCounted
## FighterProfile: footwork, style dials, personality traits, habits and stored morale for a fighter.
## Pure static functions; the only preload is FighterGoal for its morale constants.

const FighterGoal := preload("res://scripts/rules/FighterGoal.gd")

const TRAITS: Array = ["heart", "temper", "confidence", "discipline", "coachability", "loyalty"]
const HABITS: Array = [
	"drops_right_after_jab", "slow_starter", "digs_body_when_hurt", "freezes_on_ropes",
	"switches_stance_under_pressure", "talks_when_ahead", "loads_up_when_hurt", "covers_up_when_hurt",
	# S300 Kalli K-HABITS1 (assets/data/fight_habits.json has each one's trigger, ring beat, punish and coach's notes).
	"wide_hook_tell", "retreats_straight_back", "admires_her_work", "fades_late", "lunges_with_jab", "head_down_inside",
	"clinches_when_tired", "bites_on_feints", "low_lead_hand", "one_and_done", "chases_stoppage", "waits_too_long",
]

const MORALE_START := 60

const MORALE_EVENTS := {
	"win": 8,
	"loss": -12,
	"draw": 0,
	"goal_met": FighterGoal.SUCCESS_MORALE_DELTA,
	"goal_missed": FighterGoal.FAILURE_MORALE_DELTA,
	"rest_week": 4,
	"month_no_fight": -6,
	"booked": 5,
}


## Mood word by morale 0..100.
static func mood(morale: float) -> String:
	if morale >= 75.0:
		return "Fired up"
	if morale >= 50.0:
		return "Steady"
	if morale >= 30.0:
		return "Flat"
	return "Low"


## A new profile for fighter f, deterministic in seed_value.
static func make(f: Dictionary, seed_value: int) -> Dictionary:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_value

	var stats: Dictionary = f.get("stats", {})
	var speed_val: float = float(stats.get("speed", FighterGoal.STAT_DEFAULT))
	var defense_val: float = float(stats.get("defense", FighterGoal.STAT_DEFAULT))
	var footwork_base: float = (speed_val + defense_val) * 0.5
	var footwork_spread: float = (float(rng.randi_range(0, 80)) - 40.0) * 0.1
	var footwork: float = snappedf(footwork_base + footwork_spread, 0.1)

	var style: String = String(f.get("style", ""))
	var pressure_base: float = 50.0
	match style:
		"Out-boxer":
			pressure_base = 25.0
		"Pressure fighter":
			pressure_base = 75.0
		"Slugger":
			pressure_base = 85.0
	var pressure_spread: float = (float(rng.randi_range(0, 160)) - 80.0) * 0.1
	var pressure: float = clampf(pressure_base + pressure_spread, 0.0, 100.0)

	var work_rate: float = clampf(float(rng.randi_range(40, 80)), 0.0, 100.0)
	var body_share: float = clampf(float(rng.randi_range(20, 50)), 0.0, 100.0)
	if style == "Pressure fighter" or style == "Slugger":
		body_share = clampf(body_share + 10.0, 0.0, 100.0)
	var counter_spread: float = (float(rng.randi_range(0, 160)) - 80.0) * 0.1
	var counter: float = clampf(100.0 - pressure + counter_spread, 0.0, 100.0)

	var personality: Dictionary = {}
	for t in TRAITS:
		personality[t] = float(rng.randi_range(30, 85))

	var habits: Array = []
	var pool: Array = HABITS.duplicate()
	for i in range(pool.size() - 1, 0, -1):
		var j: int = rng.randi_range(0, i)
		var tmp = pool[i]
		pool[i] = pool[j]
		pool[j] = tmp
	habits.append(pool[0])
	habits.append(pool[1])

	return {
		"footwork": footwork,
		"style_dials": {
			"pressure": pressure,
			"work_rate": work_rate,
			"body_share": body_share,
			"counter": counter,
		},
		"personality": personality,
		"habits": habits,
		"morale": float(MORALE_START),
		"mood_reason": "",
	}


## Old saves and new signings: add every missing profile key to f IN PLACE, never overwrite.
static func ensure(f: Dictionary) -> Dictionary:
	if not f.has("id"):
		return f
	var seed_value: int = hash(f["id"])
	var built: Dictionary = make(f, seed_value)
	for key in built.keys():
		if not f.has(key):
			f[key] = built[key]
		else:
			var existing = f[key]
			if existing is Dictionary:
				var built_inner: Dictionary = built[key]
				for inner_key in built_inner.keys():
					if not (existing as Dictionary).has(inner_key):
						(existing as Dictionary)[inner_key] = built_inner[inner_key]
			elif existing is Array:
				if (existing as Array).is_empty():
					f[key] = built[key]
	return f


## Apply one morale event to f in place. Personality scales the delta.
static func apply_morale(f: Dictionary, kind: String, reason: String) -> Dictionary:
	if not MORALE_EVENTS.has(kind):
		return {"morale": float(f.get("morale", MORALE_START)), "mood": mood(float(f.get("morale", MORALE_START))),
			"delta": 0.0, "reason": ""}
	var base_delta: float = float(MORALE_EVENTS[kind])
	var personality: Dictionary = f.get("personality", {})
	var heart: float = clampf(float(personality.get("heart", 50.0)), 0.0, 100.0)
	var confidence: float = clampf(float(personality.get("confidence", 50.0)), 0.0, 100.0)

	var scaled: float = base_delta
	if scaled < 0.0:
		scaled = scaled * lerpf(1.3, 0.7, heart / 100.0)
		if kind == "goal_missed":
			scaled = scaled * lerpf(0.9, 1.25, confidence / 100.0)
	elif scaled > 0.0:
		scaled = scaled * lerpf(0.9, 1.1, confidence / 100.0)

	var old_morale: float = float(f.get("morale", MORALE_START))
	var new_morale: float = snappedf(clampf(old_morale + scaled, 0.0, 100.0), 0.1)
	f["morale"] = new_morale
	f["mood_reason"] = reason
	return {"morale": new_morale, "mood": mood(new_morale), "delta": scaled, "reason": reason}
