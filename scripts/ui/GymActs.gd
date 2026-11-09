extends RefCounted
## The player's moves on MONEY, GYM and the gear menu (save / load), kept out of Main.gd so it stays small.
## Main.act hands any name it does not know to act(); returns false when the name is not one of these.

const SaveGame := preload("res://scripts/state/SaveGame.gd")
const Data := preload("res://scripts/state/Data.gd")
const UI := preload("res://scripts/ui/UI.gd")
const GymSpend := preload("res://scripts/state/GymSpend.gd")
const GymUpgrades := preload("res://scripts/rules/GymUpgrades.gd")
const StaffRoles := preload("res://scripts/rules/StaffRoles.gd")
const GymSlots := preload("res://scripts/rules/GymSlots.gd")


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
				main.toast("No saved career yet. Save from the Menu while you play.")
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
		# S397 money bites (GymSpend): Club > Money's upgrades, premises, kit budget, club show, contract talks; People's staff.
		"buyup", "movepremises", "hirerole", "letgorole", "kitbudget", "bookshow", "talks", "stipend", "dues", "eveningcoach", "grantbid", "buyslot":
			_spend(main, c, name, arg)
		"equipgym":   # S415 Home's Equip mode: the pieces not yet bought show as ghosts on the picture
			main.set_meta("gym_equip", arg == "on")
			main.render()
		_:
			return false
	return true


static func _spend(main: Node, c: Career, name: String, arg: String) -> void:
	var why := ""
	var done := ""
	match name:
		"buyup":
			why = GymSpend.buy(c, arg)
			done = "Bought: %s. Ready in a week." % str(GymUpgrades.item(arg).get("name", arg)).to_lower()
		"buyslot":
			why = GymSpend.buy_slot(c, arg)
			done = "Bought: %s. Ready in a week." % str(GymSlots.item(arg).get("name", arg)).to_lower()
		"movepremises":
			why = GymSpend.move(c)
			done = "Moved: %s." % str(GymSpend.premises(c)["name"]).to_lower()
		"hirerole":
			why = GymSpend.hire(c, arg)
			done = "%s hired." % str(StaffRoles.role(arg).get("name", arg)).get_slice(",", 0)
		"letgorole":
			why = GymSpend.let_go(c, arg)
			done = "%s let go." % str(StaffRoles.role(arg).get("name", arg)).get_slice(",", 0)
		"kitbudget":
			GymSpend.set_kit(c, arg)
			done = "Kit budget: %s." % str(GymSpend.kit(c)["name"]).to_lower()
		"bookshow":
			why = GymSpend.book_show(c)
			done = "Club show booked for %s." % Clock.fmt(int(c.show.get("day", c.day)))
		"dues":
			GymSpend.set_dues(c, arg)
			done = "Dues set."
		"eveningcoach":
			why = GymSpend.evening_coach(c, 1 if arg == "add" else -1)
			done = "Evening coaches: %d." % c.extra_coaches
		"grantbid":
			why = GymSpend.grant_bid(c)
			done = "Grant bid sent."
		"stipend":
			var sp := arg.split("|")
			var sf := c.fighter_by_id(sp[0])
			why = "no such fighter" if sf.is_empty() else GymSpend.set_stipend(c, sf, sp.size() > 1 and sp[1] == "on")
			done = "Stipend changed for %s." % str(sf.get("first", ""))
		"talks":
			var parts := arg.split("|")
			var f := c.fighter_by_id(parts[0])
			why = "no such fighter" if f.is_empty() else GymSpend.answer_talks(c, f, parts.size() > 1 and parts[1] == "keep")
			done = "Contract settled."
	main.toast(done if why == "" else "Not now: %s." % why)
	main.render()
