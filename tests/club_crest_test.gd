extends SceneTree
## S412 each gym's crest behind the boxers on the versus screen.

const ClubCrest := preload("res://scripts/rules/ClubCrest.gd")

var failures := 0


func _initialize() -> void:
	var clubs := ["Lion ABC", "Anvil Street Gym", "Belfast Gloves ABC", "Repton ABC", "Leicester ABC", "Fisher ABC", "St Pancras ABC", "West Ham ABC"]
	print("Population: %d club names, %d crests" % [clubs.size(), ClubCrest.CRESTS.size()])
	_check(ClubCrest.of("Lion ABC") == "lion" and ClubCrest.of("Anvil Street Gym") == "anvil" and ClubCrest.of("Belfast Gloves ABC") == "glove", "a name with a crest's word takes it")
	for crest in ClubCrest.CRESTS:
		_check(ResourceLoader.exists(ClubCrest.path(crest)), "%s has its picture" % crest)
	for a in clubs:
		_check(ClubCrest.of(a) == ClubCrest.of(a) and ClubCrest.CRESTS.has(ClubCrest.of(a)), "%s keeps one crest" % a)
		for b in clubs:
			var p: Array = ClubCrest.pair(a, b)
			_check(p[0] != p[1], "%s v %s: two different crests" % [a, b])
	print("CLUB_CREST failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(ok: bool, label: String) -> void:
	if not ok:
		failures += 1
		print("FAIL: " + label)
