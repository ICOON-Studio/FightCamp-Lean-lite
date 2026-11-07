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
const WeekPhase := preload("res://scripts/rules/WeekPhase.gd")
const WeekTwist := preload("res://scripts/rules/WeekTwist.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const PadWeek := preload("res://scripts/rules/PadWeek.gd")
const PadEdit := preload("res://scripts/rules/PadEdit.gd")
const PlanCards := preload("res://scripts/rules/PlanCards.gd")
const DrillTray := preload("res://scripts/ui/DrillTray.gd")


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
			elif name == "combo":
				PlanCards.drill_it(f, parts[1] if parts.size() > 1 else "")   # S382 in camp the slot alone drills nothing
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
			# S356 one card a day; the coach's own card for that day removes the exception (WeekPhase).
			# S397: on the weekend the board is next week's (WeekPhase.ahead_view); the change waits for that Monday.
			var g := WeekPhase.ahead_view(f, c.day) if WeekPhase.weekend(c.day) else f
			WeekPhase.edit(g, clampi(int(parts[1]), 0, 6), [parts[2], parts[3] if parts.size() > 3 else "normal"], WeekPlan.coach_of(g))
			if WeekPhase.weekend(c.day):
				WeekPhase.keep_ahead(f, g)
			main.render()
		"twistpick":
			# S356 the week's twist card answered: "fid|a" (until Monday runs; WeekTwist.pick).
			var parts := arg.split("|")
			WeekTwist.pick(who(main, parts[0]), parts[1])
			who(main, parts[0])["board_taught"] = true   # S359 the whiteboard's first-open dim is over (WeekBoard.teaching)
			if not (main.modal as Dictionary).is_empty():
				main.open_modal(main.modal)
			else:
				main.render()
		"spar":
			var parts := arg.split("|")
			var f := who(main, parts[0])
			var g := WeekPhase.ahead_view(f, c.day) if WeekPhase.weekend(c.day) else f
			WeekPhase.edit_spar(g, clampi(int(parts[1]), 0, 2))
			if WeekPhase.weekend(c.day):
				WeekPhase.keep_ahead(f, g)
			main.render()
		"weekreset":
			var f := who(main, arg)
			if WeekPhase.weekend(c.day):
				var g := WeekPhase.ahead_view(f, c.day)
				g.erase("week_edits")
				WeekPhase.keep_ahead(f, g)
			else:
				WeekPhase.clear(f)
			main.render()
		"drill", "undrill", "padsplit", "drillit":
			# S382 DRILLCARD1 the Training tab's pad nights (PadEdit): "fid|dow|card" a card onto a night, "fid|dow[|card]"
			# a night cleared (or one card off it), "fid|dow" a split night's shares cycled, "fid|card" + drill it.
			var parts := arg.split("|")
			var f := who(main, parts[0])
			var nights := PadWeek.nights_of(f)
			match name:
				"drill":
					PadEdit.place(f, nights, int(parts[1]), parts[2])
				"undrill":
					if parts.size() > 2:
						PadEdit.remove(f, nights, int(parts[1]), parts[2])
					else:
						PadEdit.clear(f, nights, int(parts[1]))
				"padsplit":
					PadEdit.cycle(f, nights, int(parts[1]))
				"drillit":
					PadEdit.drill_it(f, nights, parts[1])
			DrillTray.picked = ""
			main.render()
		"nights":
			# S382 DRILLCARD1 Light / Standard / Hard on the Training tab: "fid|0..2" - in camp the camp's protocol (1..3), else
			# her training load; PadWeek.nights_for turns it into pad and sparring nights.
			var parts := arg.split("|")
			var f := who(main, parts[0])
			var step := clampi(int(parts[1]), 0, 2)
			if PadWeek.in_camp(f):
				f["camp"]["protocol"] = step + 1
				f["load_setting"] = BoutRules.camp_level(step + 1)
			else:
				f["load_setting"] = PadWeek.STEPS[step]
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
				main.toast("%s is entered for the nationals: the draw is on World > Championships." % ef["first"])
			main.render()
		"openBout":
			main.nav({"area": "fights", "tab": 0, "bout": arg})
		"accept":
			var fid := str(Bouts.find_offer(c, arg)[0].get("id", ""))
			if Bouts.accept(c, arg):
				main.nav({"area": "home", "tab": 0})
				main.toast("Bout booked. Next: set the camp.")
				main.show_poster(fid)
		"declineOffer":
			Bouts.decline(c, arg)
			main.nav({"area": "fights", "tab": 0})
			main.toast("Declined. Another offer will come.")
		"camp":
			var f := who(main, arg)
			# S381 C229 stage 4: film on when there is tape of her (a debutant has none: no film, no pad night spent).
			main.open_modal({"type": "camp", "fid": f["id"], "focus": Sim.focus_of(c, f), "protocol": 2,
				"film": OppFile.has_tape(f["bout"]["opp"]), "partner": false})
		"cfocus", "cproto", "cfilm", "cpartner":
			if name == "cfilm" and not OppFile.has_tape(who(main, "")["bout"]["opp"]):
				return true
			var k := {"cfocus": "focus", "cproto": "protocol", "cfilm": "film", "cpartner": "partner"}[name] as String
			main.modal[k] = arg if k == "focus" else (int(arg) if k == "protocol" else not bool(main.modal.get(k, false)))
			main.redraw_modal()
		"startcamp":
			var m: Dictionary = main.modal
			var f := who(main, "")
			var paid := Bouts.start_camp(c, f, str(m["focus"]), int(m["protocol"]), bool(m["film"]),
				bool(m.get("partner", false)))
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
			main.toast("%s is in your office: pick the next goal." % f["first"])
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
