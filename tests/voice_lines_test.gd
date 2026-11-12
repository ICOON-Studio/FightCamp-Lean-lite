extends SceneTree
## VOICEWIRE1: the voice lines table. Every corner call, every announcer line, every guide tip has its entry;
## no text is too long, no text holds a digit or a name from the game's name lists (whole words), every event id is in
## sounds.json on the Voice bus, and ids are unique. The words are tied to what the screen shows: between-round lines =
## CornerMinute.LINES, corner shouts = Exchanges.CALLS[k].shout. FightVoice's literal ids and VoiceLines agree, and the
## wiring sites exist (deleting a wiring call turns this red). Pure data check - no audio plays (Dummy driver).

const VoiceLines := preload("res://scripts/audio/VoiceLines.gd")
const SoundBank := preload("res://scripts/audio/SoundBank.gd")
const CornerMinute := preload("res://scripts/fight3d/CornerMinute.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const NationalField := preload("res://scripts/state/NationalField.gd")
const NoGi := preload("res://scripts/rules/NoGi.gd")

var failures := 0
var checks := 0


func _check(ok: bool, what: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		print("  FAIL: %s" % what)


func _initialize() -> void:
	print("--- voice_lines_test ---")
	_test_between_rounds()
	_test_corner_shouts()
	_test_announcer()
	_test_guide()
	_test_text_rules()
	_test_events_in_manifest()
	_test_unique_ids()
	_test_fight_voice_ids()
	_test_wiring_sites()
	print("VOICE_LINES checks=%d failures=%d" % [checks, failures])
	if failures == 0:
		print("PASS voice_lines_test")
		quit(0)
	else:
		print("FAIL voice_lines_test (%d failures)" % failures)
		quit(1)


## The text of one row by id ("" when missing).
func _text(id: String) -> String:
	for row in VoiceLines.all_lines():
		if str(row["id"]) == id:
			return str(row["text"])
	return ""


## Every CornerMinute.LINES key has its between-rounds voice line, saying the words the screen shows.
func _test_between_rounds() -> void:
	for k in CornerMinute.LINES:
		var event_id := VoiceLines.between(k)
		_check(event_id != "", "between('%s') returns an event id" % k)
		_check(event_id.begins_with("voice_"), "between('%s') event id starts with 'voice_' (got '%s')" % [k, event_id])
		var said := _text("between_" + str(k))
		_check(said == str(CornerMinute.LINES[k]), "between_%s says the screen's words: '%s' vs LINES '%s'" % [k, said, CornerMinute.LINES[k]])


## Every Exchanges.CALLS key has its corner shout (male and female), saying the round caption's shout.
func _test_corner_shouts() -> void:
	for k in Exchanges.CALLS:
		var male_id := VoiceLines.for_call(k, false)
		var female_id := VoiceLines.for_call(k, true)
		_check(male_id != "", "for_call('%s', false) returns an event id" % k)
		_check(female_id != "", "for_call('%s', true) returns an event id" % k)
		_check(male_id.begins_with("voice_"), "for_call('%s', false) starts with 'voice_' (got '%s')" % [k, male_id])
		_check(female_id.begins_with("voice_"), "for_call('%s', true) starts with 'voice_' (got '%s')" % [k, female_id])
		_check(male_id != female_id, "for_call('%s'): male and female ids differ" % k)
		var want := str(Exchanges.CALLS[k]["shout"])
		for g in ["m", "f"]:
			var said := _text("shout_%s_%s" % [g, k])
			_check(said == want, "shout_%s_%s says the caption's shout: '%s' vs CALLS '%s'" % [g, k, said, want])


## The announcer has its lines: opening, red corner (3 takes), blue corner (3 takes), seconds out, results.
func _test_announcer() -> void:
	var opening := VoiceLines.announce("opening", "")
	_check(opening != "", "announce('opening') returns an event id")
	for corner in ["red", "blue"]:
		for take in 3:
			var id := VoiceLines.announce(corner, take)
			_check(id != "", "announce('%s', %d) returns an event id" % [corner, take])
			_check(id.begins_with("voice_"), "announce('%s', %d) starts with 'voice_'" % [corner, take])
	var seconds := VoiceLines.announce("seconds_out", "")
	_check(seconds != "", "announce('seconds_out') returns an event id")
	# Results: decision, stoppage, ko for each corner, plus draw.
	for kind in ["decision", "stoppage", "ko"]:
		for corner in ["red", "blue"]:
			var res_id := VoiceLines.announce("result_%s" % kind, corner)
			_check(res_id != "", "announce('result_%s', '%s') returns an event id" % [kind, corner])
	var draw := VoiceLines.announce("result_draw", "")
	_check(draw != "", "announce('result_draw') returns an event id")


## The guide has lines for the first-week steps (at most 12).
func _test_guide() -> void:
	var guide_ids := VoiceLines.guide_ids()
	_check(guide_ids.size() >= 1, "guide_ids() returns at least 1 id (got %d)" % guide_ids.size())
	_check(guide_ids.size() <= 12, "guide_ids() returns at most 12 ids (got %d)" % guide_ids.size())
	for id in guide_ids:
		_check(id.begins_with("voice_"), "guide id starts with 'voice_' (got '%s')" % id)


## No text over 250 characters; no digit; no name from the game's name lists (whole words).
func _test_text_rules() -> void:
	var names := _game_names()
	_check(names.size() >= 40, "the game's name lists were read (%d names)" % names.size())
	for row in VoiceLines.all_lines():
		var text := str(row.get("text", ""))
		var rid := str(row.get("id", ""))
		_check(text.length() <= 250, "'%s' text is <= 250 chars (got %d)" % [rid, text.length()])
		_check(not _has_digit(text), "'%s' text has no digit" % rid)
		for w in _words(text):
			_check(not names.has(w), "'%s' text has no name from the game (found '%s')" % [rid, w])


## Every event id in VoiceLines exists in sounds.json on bus "Voice".
func _test_events_in_manifest() -> void:
	for id in VoiceLines.all_event_ids():
		_check(SoundBank.has(id), "'%s' is in sounds.json events" % id)
		_check(SoundBank.bus(id) == "Voice", "'%s' is on bus 'Voice' (got '%s')" % [id, SoundBank.bus(id)])


## All event ids are unique.
func _test_unique_ids() -> void:
	var seen := {}
	var dupes := 0
	for id in VoiceLines.all_event_ids():
		if seen.has(id):
			dupes += 1
		seen[id] = true
	_check(dupes == 0, "all event ids are unique (%d dupes found)" % dupes)


## Every "voice_..." literal in FightVoice.gd is a VoiceLines event, and every wired (non-guide) event has its literal.
## The guide is not wired yet (lead's decision, VOICEWIRE1 collect): its ids are left out of the reverse check.
func _test_fight_voice_ids() -> void:
	var src := FileAccess.get_file_as_string("res://scripts/audio/FightVoice.gd")
	var re := RegEx.new()
	re.compile("\"(voice_\\w+)\"")
	var literals := {}
	for mt in re.search_all(src):
		literals[mt.get_string(1)] = true
	_check(literals.size() >= 30, "FightVoice.gd holds its literal voice ids (%d)" % literals.size())
	var all_ids := VoiceLines.all_event_ids()
	for lit in literals:
		_check(all_ids.has(lit), "FightVoice literal '%s' is a VoiceLines event" % lit)
	var guide := VoiceLines.guide_ids()
	for ev in all_ids:
		if not guide.has(ev):
			_check(literals.has(ev), "VoiceLines event '%s' is played somewhere in FightVoice.gd" % ev)


## The wiring sites: each screen calls its FightVoice line (deleting a call turns this red).
func _test_wiring_sites() -> void:
	var sites := {
		"res://scripts/fight3d/FightIntro.gd": ["FightVoice.intro_opening()", "FightVoice.intro_corner(\"red\"",
			"FightVoice.intro_corner(\"blue\"", "FightVoice.intro_seconds_out()"],
		"res://scripts/ui/modals/FightNight.gd": ["FightVoice.intro_result(", "\"_announced\""],
		"res://scripts/fight3d/BeatFire.gd": ["FightVoice.shout("],
		"res://scripts/fight3d/ExchangeBeats.gd": ["\"shout_call\": str(x[\"call\"])"],
	}
	var corner_calls: Array = []
	for k in CornerMinute.LINES:
		corner_calls.append("FightVoice.between_%s()" % k)
	sites["res://scripts/fight3d/CornerMinute.gd"] = corner_calls
	for path in sites:
		var src := FileAccess.get_file_as_string(path)
		_check(src != "", "%s reads" % path)
		for needle in sites[path]:
			_check(src.contains(needle), "%s calls %s" % [path.get_file(), needle])


## The game's names: NationalField.FIRST + LAST, NoGi.OPP_FIRST, Data.gd's "first" fields and its people's "name"
## fields. Lower case.
func _game_names() -> Dictionary:
	var out := {}
	for list in [NationalField.FIRST, NationalField.LAST, NoGi.OPP_FIRST]:
		for n in list:
			for w in _words(str(n)):
				out[w] = true
	var data := FileAccess.get_file_as_string("res://scripts/state/Data.gd")
	# "first" fields, and "name" fields that are a person's name (two or three capitalised words: not a tab, room or division).
	var re := RegEx.new()
	re.compile("\"first\":\\s*\"([^\"]+)\"|\"name\":\\s*\"([A-Z][a-z]+(?: [A-Z][A-Za-z]+){1,2})\"")
	for mt in re.search_all(data):
		for w in _words(mt.get_string(1) + " " + mt.get_string(2)):
			out[w] = true
	return out


## The whole words of a text, lower case (split on anything that is not a letter).
func _words(text: String) -> Array:
	var out: Array = []
	var cur := ""
	for ch in text.to_lower():
		if ch >= "a" and ch <= "z":
			cur += ch
		elif cur != "":
			out.append(cur)
			cur = ""
	if cur != "":
		out.append(cur)
	return out


## A digit in text (the name placeholder {her} is filled later, so digits are forbidden now).
func _has_digit(text: String) -> bool:
	for ch in text:
		if ch >= "0" and ch <= "9":
			return true
	return false
