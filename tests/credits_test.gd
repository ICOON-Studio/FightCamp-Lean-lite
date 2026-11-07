extends SceneTree
## S396 Steam release: the credits carry every line a shipped licence asks for, and the title screen opens them.
## Prints CREDITS checks=<n> failures=<n>.

const CreditsPanel := preload("res://scripts/ui/CreditsPanel.gd")

var checks := 0
var failures := 0


func _initialize() -> void:
	var all := ""
	for s in CreditsPanel.sections():
		all += " ".join(PackedStringArray(s.get("lines", []))) + " "
	_check(CreditsPanel.sections().size() >= 6, "the credits have their sections")
	_check(all.contains("Incg5764") and all.contains("CC BY 4.0") and all.contains("Changed for FightCamp"), "CC BY gloves: author, licence, changes")
	_check(all.contains("NSF EIA-0196217"), "the CMU credit line")
	_check(all.contains("Lucide") and all.contains("ISC"), "Lucide ISC")
	_check(all.contains("Open Font License") and all.contains("Apache"), "the font licences")
	_check(all.contains("MIT"), "the MIT addon")
	_check(Engine.get_license_text().length() > 100, "the Godot licence text ships with the engine")
	var p := CreditsPanel.build(null)
	_check(p.find_child("EngineLicence", true, false) != null, "the panel shows the engine licence")
	p.free()
	for f in ["res://assets/ui/icons/LICENSE-lucide.txt", "res://assets/fonts/Barlow-OFL.txt", "res://assets/fonts/BebasNeue-OFL.txt",
			"res://assets/fonts/PermanentMarker-LICENSE.txt", "res://addons/godot-motion-blur/LICENSE"]:
		_check(FileAccess.file_exists(f), "licence file ships: " + f)
	_check(FileAccess.get_file_as_string("res://scripts/ui/TitleScreen.gd").contains("\"credits\""), "the title screen opens the credits")
	print("CREDITS checks=%d failures=%d" % [checks, failures])
	quit(1 if failures > 0 else 0)


func _check(ok: bool, what: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		print("FAIL ", what)
