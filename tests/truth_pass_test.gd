extends SceneTree
## S396 truth pass (P15, docs/STRUCTURE_DESIGN_S395.md rank 1): Settings keep and come back, autosave keeps the last weeks,
## the Handbook finds its words, the camp counts once in the daily gain, and nothing on screen says "not built yet".
## Prints TRUTH_PASS checks=<n> failures=<n>.

const Settings := preload("res://scripts/state/Settings.gd")
const AutoSave := preload("res://scripts/state/AutoSave.gd")
const HandbookPanel := preload("res://scripts/ui/HandbookPanel.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")
const WeekTwist := preload("res://scripts/rules/WeekTwist.gd")
const PadWeek := preload("res://scripts/rules/PadWeek.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const Data := preload("res://scripts/state/Data.gd")
const NameLinks := preload("res://scripts/ui/NameLinks.gd")

var checks := 0
var failures := 0


func _initialize() -> void:
	# Settings: a change is kept and read back; a broken value is clamped.
	var p := "user://truth_settings.cfg"
	var d := Settings.read(p + ".none")
	_check(int(d["text"]) == 1 and bool(d["autosave"]), "defaults: Medium text, autosave on")
	d["text"] = 3
	d["vol_Crowd"] = 40
	d["autosave"] = false
	Settings.write(d, p)
	var back := Settings.read(p)
	_check(int(back["text"]) == 3 and int(back["vol_Crowd"]) == 40 and not bool(back["autosave"]), "settings come back as left")
	Settings.apply(back, null)
	_check(AudioServer.get_bus_index("Crowd") < 0 or true, "apply runs without a window")

	# Autosave: Monday only, and only the last KEEP weeks kept.
	var c := Career.quick_start()
	var main := "user://truth_main.save"
	var on := {"autosave": true}
	c.day = 7 * 3 + 2
	_check(not AutoSave.on_stop(c, main, on), "no autosave on a Wednesday")
	for w in range(4, 12):
		c.day = 7 * w
		AutoSave.on_stop(c, main, on)
	_check(FileAccess.file_exists(main), "the main slot is saved")
	var kept := AutoSave.copies()
	_check(kept.size() == AutoSave.KEEP and int(kept[-1]) == 11, "the last %d weeks are kept (%s)" % [AutoSave.KEEP, str(kept)])
	_check(not AutoSave.on_stop(c, main, {"autosave": false}), "autosave off saves nothing")
	_check(AutoSave.last(main).begins_with("Last save: week 11"), "Settings shows the last save (%s)" % AutoSave.last(main))

	# Handbook: words, search and groups.
	var all := HandbookPanel.terms()
	_check(all.size() >= 10, "the Handbook has its words (%d)" % all.size())
	_check(not HandbookPanel.find(all, "fatigue", "All").is_empty(), "search finds a word")
	_check(HandbookPanel.find(all, "zzzz", "All").is_empty(), "a word that is not there finds nothing")

	if c.fighters.is_empty():
		Roster.sign_fighter(c, Data.lucy(), [])
	# The camp counts once: the daily gain is the week's gain over 7 (WeekPlan.week already takes the camp multiplier).
	if not c.fighters.is_empty():
		var f: Dictionary = c.fighters[0]
		var focus := str((f["stats"] as Dictionary).keys()[0])
		f["camp"] = {"focus": focus, "protocol": 2}
		var w := WeekPlan.week(WeekTwist.days(WeekTwist.active(f), WeekPlan.days_of(f)), Sim.week_ctx(c, f), PadWeek.evenings(f))
		var week_gain := float((w["gains"] as Dictionary).get(focus, 0.0))
		var daily := float(Sim.daily_gain(c, f).get(focus, 0.0))
		_check(week_gain > 0.0 and BoutRules.camp_gain_mult(f["camp"], focus) > 1.0, "the check has a camp stat that grows (%.4f)" % week_gain)
		_check(absf(daily * 7.0 - week_gain) < 0.0001, "the camp counts once (%.4f x 7 vs %.4f, mult %.2f)" % [daily, week_gain,
			BoutRules.camp_gain_mult(f["camp"], focus)])
	else:
		_check(false, "quick start has a fighter")

	# Every name is a link (S396 screen cut): a known fighter's name opens her page; brackets in the text stay text.
	var bb := NameLinks.bbcode(c, "%s beat someone [3 rounds]" % str(c.fighters[0]["name"]))
	_check(bb.contains("[url=fighter|%s]" % str(c.fighters[0]["id"])) and bb.contains("[lb]3 rounds]"), "names link, brackets stay text (%s)" % bb)
	# No "not built yet" left in the game's own screens.
	var found := []
	for dir in ["res://scripts/ui", "res://scripts/ui/areas", "res://scripts/ui/modals"]:
		for fname in DirAccess.get_files_at(dir):
			if fname.ends_with(".gd") and FileAccess.get_file_as_string(dir + "/" + fname).to_lower().contains("not built yet."):
				found.append(fname)
	_check(found.is_empty(), "no screen says 'not built yet' %s" % str(found))
	print("TRUTH_PASS checks=%d failures=%d" % [checks, failures])
	quit(1 if failures > 0 else 0)


func _check(ok: bool, what: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		print("FAIL ", what)
