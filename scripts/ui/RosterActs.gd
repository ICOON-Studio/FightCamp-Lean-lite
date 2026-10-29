extends RefCounted
## The player's moves on the roster: scouting (invite a prospect, watch her trial, sign her or pass) and turning a
## fighter pro (hear the promoter's offer, sign or stay amateur). Main.act hands names it does not know here.

const Roster := preload("res://scripts/state/Roster.gd")
const UI := preload("res://scripts/ui/UI.gd")


static func act(main: Node, name: String, arg: String) -> bool:
	var c: Career = main.career
	match name:
		"invite":
			if Roster.invite(c, arg):
				var p := Roster.prospect(c, arg)
				main.toast("%s comes in for a trial on %s." % [p["first"], Clock.fmt(int(p["trial_day"]))])
			main.render()
		"trial":
			main.open_modal({"type": "trial", "pid": arg, "picks": []})
		"trialcard":
			var picks: Array = main.modal["picks"]
			if picks.has(arg):
				picks.erase(arg)
			elif picks.size() < 3:
				picks.append(arg)
			main.redraw_modal()
		"signprospect":
			var f := Roster.sign_prospect(c, str(main.modal["pid"]), main.modal["picks"])
			main.close_modal()
			if not f.is_empty():
				main.toast("%s signed on the club stipend. Her goal: %s." % [f["first"], str(f["goal"]["title"]).to_lower()])
		"passprospect":
			Roster.pass_on(c, str(main.modal["pid"]))
			main.close_modal()
			main.toast("You pass. Scouting has others.")
		"prooffer":
			if not c.pro_offer.is_empty():
				main.open_modal({"type": "prooffer", "fid": c.pro_offer["fid"]})
		"turnpro":
			var f := Roster.turn_pro(c)
			main.close_modal()
			main.toast("%s is a pro. Her debut is on %s." % [f["first"], Clock.fmt(int(f["bout"]["day"]))])
		"declinepro":
			Roster.decline_pro(c)
			main.close_modal()
			main.toast("She stays amateur for now.")
		_:
			return false
	return true
