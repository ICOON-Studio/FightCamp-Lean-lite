extends RefCounted
## The player's moves around a fighter's bout and plan: offers, camp, weigh-in, fight night, the office talk, her week
## plan. Each takes the fighter by id (the arg, or the open moment's "fid"). Main.act hands names it does not know here.

const Data := preload("res://scripts/state/Data.gd")
const UI := preload("res://scripts/ui/UI.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const Injuries := preload("res://scripts/state/Injuries.gd")
const Champs := preload("res://scripts/state/Champs.gd")
const TrainingPlan := preload("res://scripts/rules/TrainingPlan.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")


## The fighter an action means: by id, else the open moment's, else the first.
static func who(main: Node, id: String) -> Dictionary:
	var c: Career = main.career
	if id != "":
		var f := c.fighter_by_id(id)
		if not f.is_empty():
			return f
	if not main.modal.is_empty() and main.modal.has("fid"):
		return c.fighter_by_id(str(main.modal["fid"]))
	return c.fighter()


static func act(main: Node, name: String, arg: String) -> bool:
	var c: Career = main.career
	match name:
		"rivalfile":
			# S341 any rival's file, any time (WORLD > Rankings).
			var r := c.rival(arg)
			if r.is_empty():
				return true
			main.open_modal({"type": "info", "title": str(r["name"]), "body": "%s, %s. %s." % [r["club"], str(r.get("stance", "")),
				r["style"]], "rival": arg})
		"focus", "diet", "learn", "combo", "trainload":
			var parts := arg.split("|")
			var f := who(main, parts[0])
			f[{"focus": "focus", "diet": "diet", "learn": "learning", "combo": "combo_learning", "trainload": "load_setting"}[name]] = parts[1] if parts.size() > 1 else parts[0]
			if name == "focus":
				f.erase("week_plan")   # S351 a new main = the coach's week for it
			main.render()
		"weekplan":
			# S351 one block more or less on a session: "fid|session|+1"; her main follows the biggest session.
			var parts := arg.split("|")
			var f := who(main, parts[0])
			var plan := TrainingPlan.step(Sim.plan_of(c, f), parts[1], int(parts[2]))
			f["week_plan"] = plan
			f["focus"] = TrainingPlan.main_stat(plan)
			main.render()
		"wday":
			# S354 CORE3: one morning of the week - "fid|dow|session|intensity" (the Training tab's week row).
			var parts := arg.split("|")
			var f := who(main, parts[0])
			var days: Array = WeekPlan.days_of(f).duplicate(true)
			days[clampi(int(parts[1]), 0, 6)] = [parts[2], parts[3] if parts.size() > 3 else "normal"]
			f["week_days"] = days
			main.render()
		"spar":
			var parts := arg.split("|")
			who(main, parts[0])["spar_nights"] = clampi(int(parts[1]), 0, 2)
			main.render()
		"weekreset":
			var f := who(main, arg)
			f.erase("week_days")
			f["spar_nights"] = 1
			main.render()
		"bodyfocus":
			var parts := arg.split("|")
			who(main, parts[0])["focus"] = parts[1]
			who(main, parts[0]).erase("week_plan")
			main.open_modal(main.modal)   # S327 the result page redraws: the button reads "Training ... next week"
		"injurychoice":
			main.open_modal(Injuries.choice_modal(c, who(main, arg)))
		"pullout", "fighthurt":
			var hf := who(main, arg)
			if name == "pullout":
				Injuries.pull_out(c, hf)
				Champs.day_events(c)   # S328 out of a championship round: her run ends now, not tomorrow
			else:
				Injuries.fight_hurt(c, hf)
			main.close_modal()
		"enterchamp":
			var ef := who(main, arg)
			if Champs.enter(c, ef):
				main.toast("%s is entered for the nationals: the draw is on WORLD > Nationals." % ef["first"])
			main.render()
		"openBout":
			main.nav({"area": "fights", "tab": 0, "bout": arg})
		"accept":
			if Bouts.accept(c, arg):
				main.nav({"area": "home", "tab": 0})
				main.toast("Bout booked. SET CAMP waits on the top bar.")
		"declineOffer":
			Bouts.decline(c, arg)
			main.nav({"area": "fights", "tab": 0})
			main.toast("Declined. Another offer will come.")
		"camp":
			var f := who(main, arg)
			main.open_modal({"type": "camp", "fid": f["id"], "focus": Sim.focus_of(c, f), "protocol": 2, "film": true})
		"cfocus", "cproto", "cfilm":
			var k := {"cfocus": "focus", "cproto": "protocol", "cfilm": "film"}[name] as String
			main.modal[k] = arg if k == "focus" else (int(arg) if k == "protocol" else not bool(main.modal["film"]))
			main.redraw_modal()
		"startcamp":
			var m: Dictionary = main.modal
			var f := who(main, "")
			var paid := Bouts.start_camp(c, f, str(m["focus"]), int(m["protocol"]), bool(m["film"]))
			var focus_word := str(Data.LABEL[m["focus"]]).to_lower()
			main.close_modal()
			main.toast("%s's camp started: %s focus.%s" % [f["first"], focus_word, (" %s paid." % UI.money(paid)) if paid > 0 else ""])
		"weighin":
			var f := who(main, arg)
			main.open_modal({"type": "weighin", "fid": f["id"]})
		"doWeigh":
			var f := who(main, "")
			var made := Bouts.weigh(c, f)
			main.close_modal()
			main.toast("%s made weight. Tomorrow is fight night." % f["first"] if made
				else "%s missed weight. The bout is off and the club pays %s for the empty slot." % [f["first"], UI.money(BoutRules.MISSED_WEIGHT_COST)])
		"fightnight":
			var f := Bouts.fighting_today(c)
			if not f.is_empty():
				# S302: a toast still showing (weigh-in) never draws over the fight's captions.
				main.clear_toast()
				main.open_modal(Bouts.fight_modal(f))
		"fightstep":
			Bouts.fight_step(c, who(main, ""), main.modal, arg)
			main.redraw_modal()
			main.render()
		"fightwatched":
			main.modal["watched"] = int(arg)
			main.redraw_modal()
		"fightskip":
			Bouts.fight_step(c, who(main, ""), main.modal, "rest")
			main.modal["watched"] = int(main.modal["round"])
			main.redraw_modal()
			main.render()
		"afterfight":
			var f := who(main, "")
			Bouts.after_fight(c, f)
			main.close_modal()
			main.toast("NEW GOAL waits on the top bar: %s is in your office." % f["first"])
		"goaltalk":
			var f := who(main, arg)
			main.open_modal({"type": "goaltalk", "fid": f["id"], "pick": ""})
		"pickgoal":
			main.modal["pick"] = arg
			main.redraw_modal()
		"setgoal":
			var f := who(main, "")
			Bouts.set_goal(c, f, str(main.modal["pick"]))
			main.close_modal()
			main.toast("%s's new goal: %s." % [f["first"], f["goal"]["title"]])
		_:
			return false
	return true
