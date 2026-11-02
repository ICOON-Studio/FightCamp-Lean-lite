extends RefCounted
## Real-world numbers (research S323): amateur boxers train ~8-15 h a week; acute:chronic load 0.8-1.3 = safe, >= 1.5 =
## 2-4x injury risk (Gabbett 2016). The same ratio thresholds as InjuryRoll.SAFE_RATIO / SPIKE_RATIO.
## S327 "her usual" (the chronic load) is an exponentially weighted average (EWMA - Williams et al. 2017, BJSM: weights
## recent weeks more and has no 4-week cliff) whose span is the fitness time constant of the Banister model (~42 days):
## the chronic load stands for her fitness, and one deload week keeps it (taper studies, Mujika & Padilla 2003: fitness
## holds through 1-2 weeks of reduced training; detraining shows after 2-4 weeks). The old 4-week rolling average let a
## single rest week (3 h) drag her usual to 8.25 h, so the Normal week after read 1.21x and two read 1.38x - resting RAISED
## the risk. Now a rest week takes her usual 10 -> 8.9 h (back at Normal = 1.12x, safe); weeks of Hard still spike first.

const SETTINGS := {
	"rest": {"hours": 3.0, "gain": 0.25, "label": "Rest"},
	"light": {"hours": 6.0, "gain": 0.6, "label": "Light"},
	"normal": {"hours": 10.0, "gain": 1.0, "label": "Normal"},
	"hard": {"hours": 15.0, "gain": 1.3, "label": "Hard"},
}
const ORDER := ["rest", "light", "normal", "hard"]
const DEFAULT := "normal"
const CAMP_DEFAULT := "hard"
const CHRONIC_DAYS := 42.0
## The weekly EWMA weight: 1 - e^(-7/42) = 0.1535 of the gap between this week and her usual.
const CHRONIC_DECAY := 0.15351827510938593
const SAFE_RATIO := 1.3
const SPIKE_RATIO := 1.5
const START_HOURS := 10.0


static func hours(setting: String) -> float:
	var s: String = setting if SETTINGS.has(setting) else DEFAULT
	var h: float = float(SETTINGS[s]["hours"])
	return h


static func gain(setting: String) -> float:
	var s: String = setting if SETTINGS.has(setting) else DEFAULT
	var g: float = float(SETTINGS[s]["gain"])
	return g


## Her usual on day one: a normal week.
static func fresh_chronic() -> float:
	return START_HOURS


## Her usual after a week of week_hours.
static func next_chronic(chronic: float, week_hours: float) -> float:
	return chronic + CHRONIC_DECAY * (week_hours - chronic)


## Her usual from an old save's last four weeks (before S327): their plain average.
static func chronic_from_history(history: Array) -> float:
	if history.is_empty():
		return START_HOURS
	var total: float = 0.0
	for w in history:
		total += float(w)
	return total / float(history.size())


## This week's setting against her usual: 1.0 = her usual.
static func ratio(setting: String, chronic: float) -> float:
	if chronic <= 0.0:
		return 1.0
	return hours(setting) / chronic


static func band(r: float) -> String:
	if r <= SAFE_RATIO:
		return "safe"
	if r < SPIKE_RATIO:
		return "high"
	return "spike"


static func gauge_line(r: float) -> String:
	var b: String = band(r)
	var msg: String = ""
	if b == "safe":
		msg = "safe"
	elif b == "high":
		msg = "injury risk up"
	else:
		msg = "injury risk 3x"
	return "Load %.1fx the usual - %s" % [r, msg]


static func default_for(in_camp: bool) -> String:
	if in_camp:
		return CAMP_DEFAULT
	return DEFAULT


## S327 a camp's first setting: the hardest that stays safe against her usual (<= SAFE_RATIO), never below Normal. Coaches
## build camp volume step by step; a straight jump to Hard from a normal month is a 1.5x spike (3x the injury risk).
static func camp_default(chronic: float) -> String:
	for s in ["hard", "normal"]:
		if ratio(s, chronic) <= SAFE_RATIO:
			return s
	return DEFAULT


static func cycle(setting: String) -> String:
	if not setting in ORDER:
		return DEFAULT
	var idx: int = ORDER.find(setting)
	return ORDER[(idx + 1) % ORDER.size()]
