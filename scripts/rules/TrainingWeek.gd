extends RefCounted
## S349 the training board (operator on the S348 mockup, Q-S294-72: "the text has nothing to do with the picture, combo and
## learning like wtf ? everythingis wrong in the boxes"): her week as the eight sessions a boxing gym runs, each pointing at
## the part of her body it builds, as his MMA home-training picture does. Settings (load, weight) are not sessions: they sit
## in the board's header. A stat's session is where her focus goes; the coach's pads carry the new move and the combo.
## Real numbers: an amateur trains 8-15 h a week (S323 research, TrainingLoad); the stat each session builds matches the old
## project's equipment catalogue (heavy bag -> power, speed bag -> hand speed, ring -> sparring / ring craft, cardio ->
## stamina). The hours split is the board's picture of TrainingPreview's shares (main 1.0, support 0.4, the rest a little).
## Pure static module - ZERO preloads.

## id, name, the stat it builds ("" = the pads: moves and combos), the body point its line ends on (lead / rear flip for a
## southpaw; "fist" = the hand of the move she is learning), its icon (Icons.gd), the coach's one line on why.
const SESSIONS: Array[Dictionary] = [
	{"id": "sparring", "name": "Sparring", "stat": "fight_iq", "point": "head", "icon": "brain",
		"why": "reading a live opponent: timing, distance, traps"},
	{"id": "neck", "name": "Neck work", "stat": "chin", "point": "neck", "icon": "user-check",
		"why": "a strong neck stops the head snapping back"},
	{"id": "shadow", "name": "Shadow boxing", "stat": "technique", "point": "lead_shoulder", "icon": "user",
		"why": "form in the mirror, chin behind the lead shoulder"},
	{"id": "heavy_bag", "name": "Heavy bag", "stat": "power", "point": "rear_shoulder", "icon": "hand-fist",
		"why": "power from the back foot, through the hips and shoulder"},
	{"id": "speed_bag", "name": "Speed bag", "stat": "speed", "point": "lead_arm", "icon": "zap",
		"why": "fast hands and rhythm; shoulders that stay up"},
	{"id": "pads", "name": "Pads with the coach", "stat": "", "point": "fist", "icon": "target",
		"why": "the new move and the combination, on the coach's call"},
	{"id": "slip_rope", "name": "Slip rope", "stat": "defense", "point": "core", "icon": "shield",
		"why": "slips and rolls bend at the waist and knees"},
	{"id": "roadwork", "name": "Roadwork", "stat": "conditioning", "point": "legs", "icon": "footprints",
		"why": "the engine: legs and lungs for the last round"},
]

## Her picked week cards (Data.CARDS) belong to a session: they show on its card as her drill.
const CARD_SESSION := {
	"Jab and move": "shadow", "Body work": "heavy_bag", "Pad rounds": "pads", "Hill sprints": "roadwork",
	"Defence drills": "slip_rope", "Film study": "sparring",
}

## The rear hand's moves (Data.MOVES); the rest are thrown with the lead hand.
const REAR_MOVES := ["Cross", "Uppercut"]

## Shares of her week's hours: the pads, her main session, its support session; the other five split what is left.
const PADS_SHARE := 0.20
const MAIN_SHARE := 0.32
const SUPPORT_SHARE := 0.16


static func session(id: String) -> Dictionary:
	for s in SESSIONS:
		if s["id"] == id:
			return s
	return {}


## The session that builds a stat ("" when none does).
static func session_for(stat: String) -> String:
	for s in SESSIONS:
		if s["stat"] == stat:
			return str(s["id"])
	return ""


## "main" for her focus's session, "support" for its partner's, "pads", or "" (a little time).
static func role(id: String, focus: String, partner: String) -> String:
	if id == "pads":
		return "pads"
	var stat := str(session(id).get("stat", ""))
	if stat == focus:
		return "main"
	if stat == partner:
		return "support"
	return ""


## {session id: hours} for a week of `load_hours` with `focus` (and its partner, TrainingPreview.PARTNER); sums to load_hours.
static func hours(load_hours: float, focus: String, partner: String) -> Dictionary:
	var out := {}
	var others := 0
	for s in SESSIONS:
		if role(str(s["id"]), focus, partner) == "":
			others += 1
	var rest := 1.0 - PADS_SHARE - MAIN_SHARE - SUPPORT_SHARE
	for s in SESSIONS:
		var share := 0.0
		match role(str(s["id"]), focus, partner):
			"pads":
				share = PADS_SHARE
			"main":
				share = MAIN_SHARE
			"support":
				share = SUPPORT_SHARE
			_:
				share = rest / float(maxi(1, others))
		out[s["id"]] = load_hours * share
	return out


## e.g. "3.2 h", "40 min".
static func hours_text(h: float) -> String:
	if h < 1.0:
		return "%d min" % int(roundf(h * 60.0))
	return "%.1f h" % h


## Her week cards that belong to this session.
static func drills(id: String, cards: Array) -> Array:
	var out: Array = []
	for c in cards:
		if str(CARD_SESSION.get(str(c), "")) == id:
			out.append(str(c))
	return out


## The body point a session's line ends on, resolved for her: "lead_*" / "rear_*" stay as BodyTrack names; "fist" becomes
## the hand of the move she is learning ("lead_fist" / "rear_fist").
static func point(id: String, learning: String) -> String:
	var p := str(session(id).get("point", ""))
	if p == "fist":
		return "rear_fist" if REAR_MOVES.has(learning) else "lead_fist"
	return p


## The body place on the front picture (her LEFT on the viewer's right): lead = left for an orthodox boxer.
static func body_side(p: String, southpaw: bool) -> String:
	var lead := "right" if southpaw else "left"
	var rear := "left" if southpaw else "right"
	if p.begins_with("lead_"):
		return lead + "_" + p.substr(5)
	if p.begins_with("rear_"):
		return rear + "_" + p.substr(5)
	return p
