extends RefCounted
## VOICEWIRE1: the table of every spoken line in the game. Pure data, no preloads.
## Each row: id (unique), role (announcer/shout_m/shout_f/between/guide), text (<=250 chars, no digits, no names),
## and the event id it plays as ("voice_<id>"). The event is registered in sounds.json on bus "Voice".
##   for_call(call_id, coach_female) -> event id or ""
##   between(call_id) -> event id or ""
##   announce(what, corner_or_take) -> event id or ""
##   guide_ids() -> Array of guide event ids
##   all_lines() -> Array of all row dicts
##   all_event_ids() -> Array of all event id strings

## The cast (docs/audio/VOICE_CAST_S434.md):
##   Roger - ring announcer (booming, building up)
##   Brian - between rounds (gruff veteran, calm)
##   Callum - corner shout male (coach shouting over crowd)
##   Sarah - corner shout female (fierce coach shouting over crowd)
##   Bill - guide (old ex-boxer, gravelly, warm)

## CornerMinute.LINES keys: long, body, calm.
## Exchanges.CALLS keys: long, body, lead, hands, let_go, calm, tie, finish.

const _LINES := {
	## --- ANNOUNCER (Roger) ---
	"announcer_opening": {"role": "announcer", "text": "Ladies and gentlemen, welcome to tonight's bout!"},
	"announcer_red_0": {"role": "announcer", "text": "In the red corner!"},
	"announcer_red_1": {"role": "announcer", "text": "Introducing the fighter in red!"},
	"announcer_red_2": {"role": "announcer", "text": "From the red corner!"},
	"announcer_blue_0": {"role": "announcer", "text": "In the blue corner!"},
	"announcer_blue_1": {"role": "announcer", "text": "Introducing the fighter in blue!"},
	"announcer_blue_2": {"role": "announcer", "text": "From the blue corner!"},
	"announcer_seconds": {"role": "announcer", "text": "Seconds out!"},
	"announcer_red_decision": {"role": "announcer", "text": "The winner by decision, from the red corner!"},
	"announcer_blue_decision": {"role": "announcer", "text": "The winner by decision, from the blue corner!"},
	"announcer_red_stoppage": {"role": "announcer", "text": "The winner by stoppage, from the red corner!"},
	"announcer_blue_stoppage": {"role": "announcer", "text": "The winner by stoppage, from the blue corner!"},
	"announcer_red_ko": {"role": "announcer", "text": "The winner by knockout, from the red corner!"},
	"announcer_blue_ko": {"role": "announcer", "text": "The winner by knockout, from the blue corner!"},
	"announcer_draw": {"role": "announcer", "text": "This bout is a draw!"},
	## --- BETWEEN ROUNDS (Brian) - one per CornerMinute.LINES key, the words = LINES[k] ---
	"between_long": {"role": "between", "text": "Stay long. Jab and move, make every punch reach."},
	"between_body": {"role": "between", "text": "Go downstairs. Dig to the body, the head comes later."},
	"between_calm": {"role": "between", "text": "Breathe. Slow it down and pick your shots."},
	## --- CORNER SHOUTS MALE (Callum) - one per Exchanges.CALLS key, the words = CALLS[k].shout ---
	"shout_m_long": {"role": "shout_m", "text": "Turn! Jab and move!"},
	"shout_m_body": {"role": "shout_m", "text": "Downstairs! Go to the body!"},
	"shout_m_lead": {"role": "shout_m", "text": "Feint! Draw the lead!"},
	"shout_m_hands": {"role": "shout_m", "text": "Hands up! Move your head!"},
	"shout_m_let_go": {"role": "shout_m", "text": "Let your hands go!"},
	"shout_m_calm": {"role": "shout_m", "text": "Breathe! Pick your shots!"},
	"shout_m_tie": {"role": "shout_m", "text": "Hold! Tie up!"},
	"shout_m_finish": {"role": "shout_m", "text": "Finish it! Go now!"},
	## --- CORNER SHOUTS FEMALE (Sarah) - one per Exchanges.CALLS key, the words = CALLS[k].shout ---
	"shout_f_long": {"role": "shout_f", "text": "Turn! Jab and move!"},
	"shout_f_body": {"role": "shout_f", "text": "Downstairs! Go to the body!"},
	"shout_f_lead": {"role": "shout_f", "text": "Feint! Draw the lead!"},
	"shout_f_hands": {"role": "shout_f", "text": "Hands up! Move your head!"},
	"shout_f_let_go": {"role": "shout_f", "text": "Let your hands go!"},
	"shout_f_calm": {"role": "shout_f", "text": "Breathe! Pick your shots!"},
	"shout_f_tie": {"role": "shout_f", "text": "Hold! Tie up!"},
	"shout_f_finish": {"role": "shout_f", "text": "Finish it! Go now!"},
	## --- GUIDE (Bill) - first-week tips. NOT WIRED YET: tools/voice_make.py skips them unless --with-guide ---
	"guide_sign": {"role": "guide", "text": "Nobody at the desk. Go find a fighter."},
	"guide_coach": {"role": "guide", "text": "Get yourself an assistant coach."},
	"guide_week": {"role": "guide", "text": "Plan the week, then lock it in."},
	"guide_go": {"role": "guide", "text": "Week is set. Press Continue."},
	"guide_offer": {"role": "guide", "text": "The show has asked for your fighter."},
	"guide_prep": {"role": "guide", "text": "Your fighter needs a camp first."},
	"guide_fight": {"role": "guide", "text": "Makes weight Friday, fights Saturday."},
	"guide_club": {"role": "guide", "text": "Next job for the club. Get it done."},
}


## Corner shout for a call id. coach_female selects Sarah over Callum. Returns event id or "".
static func for_call(call_id: String, coach_female: bool) -> String:
	var prefix := "shout_f_" if coach_female else "shout_m_"
	var key := prefix + call_id
	if _LINES.has(key):
		return "voice_" + key
	return ""


## Between-rounds line for a CornerMinute.LINES key. Returns event id or "".
static func between(call_id: String) -> String:
	var key := "between_" + call_id
	if _LINES.has(key):
		return "voice_" + key
	return ""


## Announcer line. what = "opening", "red", "blue", "seconds_out", "result_decision", "result_stoppage", "result_ko", "result_draw".
## corner = "red"/"blue" for corner calls and results, or take index (0-2) for red/blue, or "" for others.
static func announce(what: String, corner) -> String:
	var key := ""
	match what:
		"opening":
			key = "announcer_opening"
		"seconds_out":
			key = "announcer_seconds"
		"result_decision", "result_stoppage", "result_ko":
			key = "announcer_" + str(corner) + "_" + what.trim_prefix("result_")
		"result_draw":
			key = "announcer_draw"
		"red", "blue":
			var take := int(corner) if corner is int else 0
			key = "announcer_" + what + "_" + str(take)
	if key != "" and _LINES.has(key):
		return "voice_" + key
	return ""


## All guide event ids (at most 12).
static func guide_ids() -> Array:
	var out: Array = []
	for k in _LINES:
		if str(_LINES[k]["role"]) == "guide":
			out.append("voice_" + k)
	return out


## Every row as a dict {id, role, text, event}.
static func all_lines() -> Array:
	var out: Array = []
	for k in _LINES:
		var row: Dictionary = _LINES[k]
		out.append({"id": k, "role": row["role"], "text": row["text"], "event": "voice_" + k})
	return out


## Every event id string.
static func all_event_ids() -> Array:
	var out: Array = []
	for k in _LINES:
		out.append("voice_" + k)
	return out
