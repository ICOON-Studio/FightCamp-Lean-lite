extends RefCounted
## The player's moves on the roster: scouting (invite a prospect, watch her trial, sign her or pass) and turning a
## fighter pro (hear the promoter's offer, sign or stay amateur). Main.act hands names it does not know here.

const GymSpend := preload("res://scripts/state/GymSpend.gd")
const Recruit := preload("res://scripts/rules/Recruit.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const FirstHour := preload("res://scripts/rules/FirstHour.gd")
const UI := preload("res://scripts/ui/UI.gd")
const STRIKE := preload("res://scenes/dev/StrikeBrowser.tscn")
const TAPE := preload("res://scripts/ui/TapeRoom.gd")


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
			# S343 the tape room (Q-S294-68): her opponent's films, her flow, the answers into her plan.
			for f in c.fighters:
				if str(f["id"]) == arg and not (f.get("bout", {}) as Dictionary).is_empty():
					var room := TAPE.new()
					room.for_fighter(main, f)
					main.add_child(room)
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
		"prooffer":
			if not c.pro_offer.is_empty():
				main.open_modal({"type": "prooffer", "fid": c.pro_offer["fid"]})
		"turnpro":
			var f := Roster.turn_pro(c)
			main.close_modal()
			main.toast("%s is a pro. Debut on %s." % [f["first"], Clock.fmt(int(f["bout"]["day"]))])
		"declinepro":
			Roster.decline_pro(c)
			main.close_modal()
			main.toast("Staying amateur for now.")
		_:
			return false
	return true
