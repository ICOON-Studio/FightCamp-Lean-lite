extends RefCounted
## VOICEWIRE1: the voice playback wrapper. Small - each method plays one voice line.
## The words on screen stay as they are; the voice plays on top.
## Uses literal event ids in Sfx.play() calls so the sound test can verify them.

const Sfx := preload("res://scripts/audio/Sfx.gd")
const FightSfx := preload("res://scripts/audio/FightSfx.gd")


## Announcer opening. S440: every announcer line plays over the arena crowd (FightSfx.announcer_line); names and the
## winner get the roar after them.
static func intro_opening() -> bool:
	return _room(Sfx.play("voice_announcer_opening"), "voice_announcer_opening", true)


## Announcer calls a corner (take 0-2).
static func intro_corner(corner: String, take: int) -> bool:
	if corner == "red":
		if take == 0: return _room(Sfx.play("voice_announcer_red_0"), "voice_announcer_red_0", true)
		if take == 1: return _room(Sfx.play("voice_announcer_red_1"), "voice_announcer_red_1", true)
		return _room(Sfx.play("voice_announcer_red_2"), "voice_announcer_red_2", true)
	if corner == "blue":
		if take == 0: return _room(Sfx.play("voice_announcer_blue_0"), "voice_announcer_blue_0", true)
		if take == 1: return _room(Sfx.play("voice_announcer_blue_1"), "voice_announcer_blue_1", true)
		return _room(Sfx.play("voice_announcer_blue_2"), "voice_announcer_blue_2", true)
	return false


## Announcer: seconds out (the bell answers it, not the crowd).
static func intro_seconds_out() -> bool:
	return _room(Sfx.play("voice_announcer_seconds"), "voice_announcer_seconds", false)


## Announcer reads the result (on the menus, after the ring has gone: the bed comes back for it, then fades).
static func intro_result(kind: String, corner: String) -> bool:
	if kind == "draw":
		return _result(Sfx.play("voice_announcer_draw"), "voice_announcer_draw")
	if corner == "red":
		if kind == "decision": return _result(Sfx.play("voice_announcer_red_decision"), "voice_announcer_red_decision")
		if kind == "ko": return _result(Sfx.play("voice_announcer_red_ko"), "voice_announcer_red_ko")
		if kind == "stoppage": return _result(Sfx.play("voice_announcer_red_stoppage"), "voice_announcer_red_stoppage")
	if corner == "blue":
		if kind == "decision": return _result(Sfx.play("voice_announcer_blue_decision"), "voice_announcer_blue_decision")
		if kind == "ko": return _result(Sfx.play("voice_announcer_blue_ko"), "voice_announcer_blue_ko")
		if kind == "stoppage": return _result(Sfx.play("voice_announcer_blue_stoppage"), "voice_announcer_blue_stoppage")
	return false


## The crowd only answers a line that really played (a kept file).
static func _room(ok: bool, id: String, cheer: bool) -> bool:
	if ok:
		FightSfx.announcer_line(id, cheer)
	return ok


static func _result(ok: bool, id: String) -> bool:
	if ok:
		FightSfx.announcer_result(id)
	return ok


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
