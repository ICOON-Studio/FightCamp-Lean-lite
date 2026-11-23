extends RefCounted
## The player's moves on the roster: scouting (invite a prospect, watch her trial, sign her or pass) and turning a
## fighter pro (hear the promoter's offer, sign or stay amateur). Main.act hands names it does not know here.

const GymSpend := preload("res://scripts/state/GymSpend.gd")
const Recruit := preload("res://scripts/rules/Recruit.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const FirstHour := preload("res://scripts/rules/FirstHour.gd")
const UI := preload("res://scripts/ui/UI.gd")
const VisitWire := preload("res://scripts/state/VisitWire.gd")
const STRIKE := preload("res://scenes/dev/StrikeBrowser.tscn")
const TAPE := preload("res://scripts/ui/FightAnalysisTape.gd")   # S511: the Tape Room retired into FIGHT ANALYSIS


static func act(main: Node, name: String, arg: String) -> bool:
	var c: Career = main.career
	match name:
		"plan":
			# S339 the coach's plan board for one fighter, over the whole game until Save plan / Back.
			for f in c.fighters:
				if str(f["id"]) == arg:
					var board := STRIKE.instantiate()
					board.for_fighter(main, f)
					main.add_child(board)
		"taperoom":
			# S343 the tape room (Q-S294-68); S511 FIGHTFILM1 map 6: Watch the tape opens FIGHT ANALYSIS on her films, no filing.
			for f in c.fighters:
				if str(f["id"]) == arg and not (f.get("bout", {}) as Dictionary).is_empty():
					TAPE.watch(main, c, f)
		"invite":
			if Roster.invite(c, arg):
				var p := Roster.prospect(c, arg)
				main.toast("%s comes in for a trial on %s." % [p["first"], Clock.fmt(int(p["trial_day"]))])
			elif GymSpend.place_blocked(c) != "":   # S397 roster places
				main.toast("No trial: %s (Club)." % GymSpend.place_blocked(c))
			main.render()
		"trial":
			main.open_modal({"type": "trial", "pid": arg, "picks": []})
		"trialcard":
			var picks: Array = main.modal["picks"]
			if Recruit.FOCUS.has(arg):   # S354 one starting focus replaces the cards
				picks.clear()
				picks.append(arg)
			elif picks.has(arg):
				picks.erase(arg)
			elif picks.size() < 3:
				picks.append(arg)
			main.redraw_modal()
		"signprospect":
			var f := Roster.sign_prospect(c, str(main.modal["pid"]), main.modal["picks"])
			main.close_modal()
			if not f.is_empty():
				main.toast("%s signed on the club stipend. Goal: %s." % [f["first"], str(f["goal"]["title"]).to_lower()])
		"passprospect":
			Roster.pass_on(c, str(main.modal["pid"]))
			main.close_modal()
			main.toast("You pass. Scouting has others.")
		"decline":   # S405 the first walk-in refused: gone for good, the next one comes in
			var left := FirstHour.refuse(c)
			main.close_modal()
			main.toast(left)
		"passwalkin":   # S397 rank 5: a later walk-in (FirstHour's second) turned away at reception
			var who := str(c.applicant.get("name", "The walk-in"))
			Roster.pass_on(c, str(c.applicant.get("id", "")))
			c.applicant = {}
			main.close_modal()
			main.toast("%s thanks you and leaves." % who)
		"signvisit":   # S533 P4PBUILD1 the visit: capacity and the last day are read again now (VisitWire.sign)
			var res: Dictionary = VisitWire.sign(c, main.modal.get("picks", []))
			if bool(res["ok"]):
				main.close_modal()
				main.toast("%s signed. Goal on the card: %s." % [res["f"]["first"], str(res["f"]["goal"]["title"]).to_lower()])
			else:
				main.toast("Not signed: %s." % str(res["why"]))
				main.redraw_modal()
		"passvisit":
			VisitWire.pass_visit(c)
			main.close_modal()
			main.toast("The boxer goes back to the old club. No new ask for %d days." % VisitWire.CardAsk.COOLDOWN_DAYS)
		"trialvisit":
			if VisitWire.trial(c):
				main.close_modal()
				main.toast("Trial on %s. The answer is due by %s." % [Clock.fmt(int(c.applicant["trial_day"])), Clock.fmt(int(c.applicant["expires"]))])
		"prooffer":
			if not c.pro_offer.is_empty():
				main.open_modal({"type": "prooffer", "fid": c.pro_offer["fid"]})
		"turnpro":
			var f := Roster.turn_pro(c)
			main.close_modal()
			if f.is_empty():
				return true
			main.toast("%s is a pro. Debut on %s: pick the bout on Fights." % [f["first"], Clock.fmt(int(f["pro_due"]))])
		"declinepro":   # S543 v17 "Not yet": a patience mark, the offer back in four weeks
			Roster.decline_pro(c)
			main.close_modal()
			main.toast("Not yet: the promoter calls again in %d weeks." % Roster.ProStart.NOT_YET_WEEKS)
		"rivalgo":   # S543 v17: the rival gym's call refused - the boxer leaves for good
			Roster.refuse_rival(c)
			main.close_modal()
			main.toast("The boxer leaves for the rival gym.")
		"propair":   # S543 TURNPRO17: "<fid>:safe|risky", pro fights 1-6
			var pp := arg.split(":")
			var pf := c.fighter_by_id(pp[0])
			if not pf.is_empty() and Roster.ProPair.book(c, pf, pp[1]):
				main.nav({"area": "home", "tab": 0})
				main.toast("Pro fight booked for %s. Next: set the camp." % pf["first"])
			else:
				main.render()
		_:
			return false
	return true
