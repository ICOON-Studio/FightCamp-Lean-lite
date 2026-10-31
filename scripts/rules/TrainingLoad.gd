extends RefCounted
## Real-world numbers (research S323): amateur boxers train ~8-15 h a week; acute:chronic load 0.8-1.3 = safe, >= 1.5 =
## 2-4x injury risk (Gabbett 2016). The same ratio thresholds as InjuryRoll.SAFE_RATIO / SPIKE_RATIO.

const SETTINGS := {
	"rest": {"hours": 3.0, "gain": 0.25, "label": "Rest"},
	"light": {"hours": 6.0, "gain": 0.6, "label": "Light"},
	"normal": {"hours": 10.0, "gain": 1.0, "label": "Normal"},
	"hard": {"hours": 15.0, "gain": 1.3, "label": "Hard"},
}
const ORDER := ["rest", "light", "normal", "hard"]
const DEFAULT := "normal"
const CAMP_DEFAULT := "hard"
const HISTORY_WEEKS := 4
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


static func fresh_history() -> Array:
	return [START_HOURS, START_HOURS, START_HOURS, START_HOURS]


static func push(history: Array, week_hours: float) -> Array:
	var h: Array = history.duplicate()
	h.append(week_hours)
	if h.size() > HISTORY_WEEKS:
		h = h.slice(h.size() - HISTORY_WEEKS)
	return h


static func ratio(setting: String, history: Array) -> float:
	if history.is_empty():
		return 1.0
	var total: float = 0.0
	for w in history:
		total += float(w)
	var avg: float = total / float(history.size())
	if avg <= 0.0:
		return 1.0
	return hours(setting) / avg


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
	return "Load %.1fx her usual - %s" % [r, msg]


static func default_for(in_camp: bool) -> String:
	if in_camp:
		return CAMP_DEFAULT
	return DEFAULT


static func cycle(setting: String) -> String:
	if not setting in ORDER:
		return DEFAULT
	var idx: int = ORDER.find(setting)
	return ORDER[(idx + 1) % ORDER.size()]
