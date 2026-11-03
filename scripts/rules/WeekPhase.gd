extends RefCounted
## S356 (operator Q-S294-82 "Yes, build it"; Miro AI + Kalli: "too many picks for 2 minutes a week", "phase sets the
## default week; edit exceptions", "merge day types with Light/Normal/Hard"): the camp's phase writes the coach's week and
## the player changes only the days he wants. Each day is one card that carries its intensity ("Hard intervals").
## Phases, counted back from fight night (John S354: taper volume down 40-60 %, stop sparring 7-10 days out; sparring 1-2
## days a week): BASE no bout booked; BUILD 3+ weeks out (the camp's stat Hard once); PEAK two weeks out (the hardest week,
## sparring twice); TAPER fight week (light, three rest days, no sparring).
##   phase(bout, day) -> id   sync(f, day) (f["phase"]; edits from another phase are dropped)   week(phase, focus) -> 7 days
##   spar(phase) / pads(phase) -> sparring / pad nights   card(day) -> "Hard intervals"   cards() -> [[id, intensity] x every card]
##   edit(f, dow, day_pick) / edit_spar(f, n) / edits(f) -> {days: {dow: [id, int]}, spar}   clear(f)
## Pure static; f keys: phase, week_edits {phase, days {"0".."6": [id, intensity]}, spar}.

const PHASES := {
	"base": {"name": "Base week", "line": "No bout booked: the coach keeps things ticking over.", "spar": 1},
	"build": {"name": "Build week", "line": "Volume up; the camp's stat gets a Hard morning.", "spar": 1},
	"peak": {"name": "Peak week", "line": "The hardest week of the camp; sparring twice.", "spar": 2},
	"taper": {"name": "Fight week taper", "line": "Volume down by half, no sparring: fresh legs on the night.", "spar": 0, "pads": 3},
}
## "F" = the session that builds the camp's stat (FOCUS).
const WEEKS := {
	"base": [["roadwork", "normal"], ["heavy_bag", "normal"], ["intervals", "normal"], ["speed_bag", "light"],
		["roadwork", "normal"], ["strength", "normal"], ["rest", "normal"]],
	"build": [["roadwork", "normal"], ["F", "hard"], ["intervals", "normal"], ["speed_bag", "light"],
		["roadwork", "normal"], ["strength", "normal"], ["rest", "normal"]],
	"peak": [["intervals", "hard"], ["F", "normal"], ["roadwork", "normal"], ["slip_rope", "light"],
		["intervals", "normal"], ["shadow", "light"], ["rest", "normal"]],
	"taper": [["roadwork", "light"], ["shadow", "light"], ["rest", "normal"], ["speed_bag", "light"],
		["roadwork", "light"], ["rest", "normal"], ["rest", "normal"]],
}
const FOCUS := {"conditioning": "intervals", "power": "heavy_bag", "speed": "speed_bag", "defense": "slip_rope",
	"technique": "shadow", "chin": "neck", "fight_iq": "shadow"}
const SESSIONS := ["roadwork", "intervals", "heavy_bag", "strength", "speed_bag", "slip_rope", "shadow", "neck"]
const NAMES := {"roadwork": "roadwork", "intervals": "intervals", "heavy_bag": "heavy bag", "strength": "weights",
	"speed_bag": "speed bag", "slip_rope": "slip rope", "shadow": "shadow", "neck": "neck work"}
const LEVELS := {"light": "Light", "normal": "Normal", "hard": "Hard"}


static func phase(bout: Dictionary, day: int) -> String:
	if bout.is_empty() or bool(bout.get("done", false)):
		return "base"
	var weeks := int(ceil((int(bout.get("day", day)) - day) / 7.0))
	return "taper" if weeks <= 1 else ("peak" if weeks == 2 else "build")


## The phase as of `day` on the fighter; a change of phase drops the last phase's exceptions (a new week is written).
static func sync(f: Dictionary, day: int) -> String:
	var p := phase(f.get("bout", {}), day)
	f["phase"] = p
	f.erase("week_days")   # the S354 whole-week save: the phase writes the week now
	var e: Dictionary = f.get("week_edits", {})
	if not e.is_empty() and str(e.get("phase", "")) != p:
		f.erase("week_edits")
	return p


static func week(p: String, focus: String) -> Array:
	var out: Array = []
	for d in WEEKS.get(p, WEEKS["base"]):
		out.append([str(FOCUS.get(focus, "heavy_bag")) if str(d[0]) == "F" else str(d[0]), str(d[1])])
	return out


static func spar(p: String) -> int:
	return int((PHASES.get(p, PHASES["base"]) as Dictionary)["spar"])


## Pad nights in the phase (6 = every night but Sunday; the taper keeps 3).
static func pads(p: String) -> int:
	return int((PHASES.get(p, PHASES["base"]) as Dictionary).get("pads", 6))


static func card(d: Array) -> String:
	return "Rest" if str(d[0]) == "rest" else "%s %s" % [LEVELS.get(str(d[1]), "Normal"), NAMES.get(str(d[0]), str(d[0]))]


## Every card a day can hold, in the picker's order: each session Light / Normal / Hard, then Rest.
static func cards() -> Array:
	var out: Array = []
	for s in SESSIONS:
		for k in ["light", "normal", "hard"]:
			out.append([s, k])
	out.append(["rest", "normal"])
	return out


static func edits(f: Dictionary) -> Dictionary:
	var e: Dictionary = f.get("week_edits", {})
	return e if str(e.get("phase", "")) == str(f.get("phase", "base")) else {}


## One day changed; picking the coach's own card for that day removes the exception.
static func edit(f: Dictionary, dow: int, pick: Array, coach: Array) -> void:
	var e := _own(f)
	if pick == coach[dow]:
		(e["days"] as Dictionary).erase(str(dow))
	else:
		e["days"][str(dow)] = [str(pick[0]), str(pick[1])]


static func edit_spar(f: Dictionary, n: int) -> void:
	var e := _own(f)
	if n == spar(str(f.get("phase", "base"))):
		e.erase("spar")
	else:
		e["spar"] = clampi(n, 0, 2)


static func clear(f: Dictionary) -> void:
	f.erase("week_edits")


static func _own(f: Dictionary) -> Dictionary:
	if edits(f).is_empty():
		f["week_edits"] = {"phase": str(f.get("phase", "base")), "days": {}}
	return f["week_edits"]
