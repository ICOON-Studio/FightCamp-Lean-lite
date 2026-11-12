extends RefCounted
## VOICEWIRE1: the voice playback wrapper. Small - each method plays one voice line.
## The words on screen stay as they are; the voice plays on top.
## Uses literal event ids in Sfx.play() calls so the sound test can verify them.

const Sfx := preload("res://scripts/audio/Sfx.gd")


## Announcer opening.
static func intro_opening() -> bool:
	return Sfx.play("voice_announcer_opening")


## Announcer calls a corner (take 0-2).
static func intro_corner(corner: String, take: int) -> bool:
	if corner == "red":
		if take == 0: return Sfx.play("voice_announcer_red_0")
		if take == 1: return Sfx.play("voice_announcer_red_1")
		return Sfx.play("voice_announcer_red_2")
	if corner == "blue":
		if take == 0: return Sfx.play("voice_announcer_blue_0")
		if take == 1: return Sfx.play("voice_announcer_blue_1")
		return Sfx.play("voice_announcer_blue_2")
	return false


## Announcer: seconds out.
static func intro_seconds_out() -> bool:
	return Sfx.play("voice_announcer_seconds")


## Announcer reads the result.
static func intro_result(kind: String, corner: String) -> bool:
	if kind == "draw":
		return Sfx.play("voice_announcer_draw")
	if corner == "red":
		if kind == "decision": return Sfx.play("voice_announcer_red_decision")
		if kind == "ko": return Sfx.play("voice_announcer_red_ko")
		if kind == "stoppage": return Sfx.play("voice_announcer_red_stoppage")
	if corner == "blue":
		if kind == "decision": return Sfx.play("voice_announcer_blue_decision")
		if kind == "ko": return Sfx.play("voice_announcer_blue_ko")
		if kind == "stoppage": return Sfx.play("voice_announcer_blue_stoppage")
	return false


## Between-rounds coach line.
static func between_long() -> bool:
	return Sfx.play("voice_between_long")


static func between_body() -> bool:
	return Sfx.play("voice_between_body")


static func between_calm() -> bool:
	return Sfx.play("voice_between_calm")


## The corner's in-round shout for an Exchanges.CALLS key (BeatFire plays it on the shout beat). female = Sarah.
static func shout(call_id: String, female: bool) -> bool:
	match call_id:
		"long": return shout_long(female)
		"body": return shout_body(female)
		"lead": return shout_lead(female)
		"hands": return shout_hands(female)
		"let_go": return shout_let_go(female)
		"calm": return shout_calm(female)
		"tie": return shout_tie(female)
		"finish": return shout_finish(female)
	return false


## Corner shout during a round (male = Callum, female = Sarah).
static func shout_long(female: bool) -> bool:
	if female: return Sfx.play("voice_shout_f_long")
	return Sfx.play("voice_shout_m_long")


static func shout_body(female: bool) -> bool:
	if female: return Sfx.play("voice_shout_f_body")
	return Sfx.play("voice_shout_m_body")


static func shout_lead(female: bool) -> bool:
	if female: return Sfx.play("voice_shout_f_lead")
	return Sfx.play("voice_shout_m_lead")


static func shout_hands(female: bool) -> bool:
	if female: return Sfx.play("voice_shout_f_hands")
	return Sfx.play("voice_shout_m_hands")


static func shout_let_go(female: bool) -> bool:
	if female: return Sfx.play("voice_shout_f_let_go")
	return Sfx.play("voice_shout_m_let_go")


static func shout_calm(female: bool) -> bool:
	if female: return Sfx.play("voice_shout_f_calm")
	return Sfx.play("voice_shout_m_calm")


static func shout_tie(female: bool) -> bool:
	if female: return Sfx.play("voice_shout_f_tie")
	return Sfx.play("voice_shout_m_tie")


static func shout_finish(female: bool) -> bool:
	if female: return Sfx.play("voice_shout_f_finish")
	return Sfx.play("voice_shout_m_finish")


## Returns the event id for a corner shout without playing it (for beat dicts).
static func shout_event(call_id: String, female: bool) -> String:
	if female:
		if call_id == "long": return "voice_shout_f_long"
		if call_id == "body": return "voice_shout_f_body"
		if call_id == "lead": return "voice_shout_f_lead"
		if call_id == "hands": return "voice_shout_f_hands"
		if call_id == "let_go": return "voice_shout_f_let_go"
		if call_id == "calm": return "voice_shout_f_calm"
		if call_id == "tie": return "voice_shout_f_tie"
		if call_id == "finish": return "voice_shout_f_finish"
	else:
		if call_id == "long": return "voice_shout_m_long"
		if call_id == "body": return "voice_shout_m_body"
		if call_id == "lead": return "voice_shout_m_lead"
		if call_id == "hands": return "voice_shout_m_hands"
		if call_id == "let_go": return "voice_shout_m_let_go"
		if call_id == "calm": return "voice_shout_m_calm"
		if call_id == "tie": return "voice_shout_m_tie"
		if call_id == "finish": return "voice_shout_m_finish"
	return ""
