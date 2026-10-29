extends RefCounted
## The player's moves on MONEY, GYM and the gear menu (save / load), kept out of Main.gd so it stays small.
## Main.act hands any name it does not know to act(); returns false when the name is not one of these.

const SaveGame := preload("res://scripts/state/SaveGame.gd")
const Data := preload("res://scripts/state/Data.gd")
const UI := preload("res://scripts/ui/UI.gd")


static func act(main: Node, name: String, arg: String) -> bool:
	var c: Career = main.career
	match name:
		"save":
			if c == null:
				main.toast("Nothing to save: start a career first.")
			elif SaveGame.save(c, main.save_path):
				main.toast("Saved: %s, %s." % [c.gym_name, Clock.fmt_long(c.day)])
			else:
				main.toast("Could not save on this machine.")
		"load":
			var loaded := SaveGame.load_career(main.save_path)
			if loaded == null:
				main.toast("No saved career yet. Save from the Gear menu while you play.")
			else:
				main.resume(loaded)
				main.toast("Loaded: %s, %s." % [loaded.gym_name, Clock.fmt_long(loaded.day)])
		"deal":
			for d in c.deals:
				if str(d["id"]) == arg and str(d["state"]) == "offer":
					d["state"] = "signed"
					c.add_news("%s signs with %s: %s a week." % [c.gym_name, d["name"], UI.money(int(d["per"]))])
					main.toast("%s signed: +%s a week." % [d["name"], UI.money(int(d["per"]))])
			main.render()
		"repair":
			for f in c.facilities:
				if str(f["id"]) == arg and str(f["state"]) == "worn":
					c.pay(-int(f["repair"]), "Repair: %s" % str(f["name"]).to_lower())
					f["state"] = "good"
					c.reputation += Data.REPAIR_REPUTATION
					main.toast("%s repaired. Members notice." % f["name"])
			main.render()
		"scout":
			main.toast("Scouting trials come in week 4.")
		_:
			return false
	return true
