extends RefCounted
## S303 corner card (docs/FIGHT_MODEL.md "a corner card after each round: what worked, what hurt, the call"). Read off the
## beats the ring played (FightView sets it on the round when it builds the plan, so the card never disagrees with what the
## player watched). The call follows what a real corner does: a tired boxer is calmed; one hurt by short punches is kept
## long, one outworked at range is sent inside; otherwise more of what worked. Pure static; zero preloads.

## Energy under which the corner calms her (Combos.WEARY_AT).
const WEARY_AT := 40.0
## Every punch beat RoundStyle.MOVE_BEAT can play (S305 WORDSCONTRACT1: the card missed rear_hook / lead_uppercut).
const SHORT := ["lead_hook", "rear_hook", "body_hook", "rear_uppercut", "lead_uppercut"]
const LONG := ["jab", "cross"]
const WORD := {"jab": "jab", "cross": "straight right", "lead_hook": "left hook", "rear_hook": "right hook",
	"body_hook": "hook to the body", "rear_uppercut": "uppercut", "lead_uppercut": "lead uppercut"}


## {"a"/"b": {"landed": {move: n}, "whole": [combo ids that landed whole]}}
static func summarize(beats: Array) -> Dictionary:
	var out := {"a": {"landed": {}, "whole": []}, "b": {"landed": {}, "whole": []}}
	var i := 0
	while i < beats.size():
		var b: Dictionary = beats[i]
		var who := str(b.get("who", ""))
		if not out.has(who):
			i += 1
			continue
		if str(b.get("result", "")) == "lands" and WORD.has(str(b.get("move", ""))):
			var landed: Dictionary = out[who]["landed"]
			landed[str(b["move"])] = int(landed.get(str(b["move"]), 0)) + 1
		var cid := str(b.get("combo_id", ""))
		if cid != "":
			var j := i
			var all_land := str(b.get("result", "")) == "lands"
			while j + 1 < beats.size() and str(beats[j + 1].get("combo_id", "")) == cid and str(beats[j + 1]["who"]) == who:
				j += 1
				all_land = all_land and str(beats[j]["result"]) == "lands"
				if str(beats[j]["result"]) == "lands" and WORD.has(str(beats[j]["move"])):
					var l2: Dictionary = out[who]["landed"]
					l2[str(beats[j]["move"])] = int(l2.get(str(beats[j]["move"]), 0)) + 1
			if all_land and j > i and not bool(beats[j].get("combo_cut", false)) and not (out[who]["whole"] as Array).has(cid):
				(out[who]["whole"] as Array).append(cid)
			i = j + 1
			continue
		i += 1
	return out


## The move that landed most (ties: the order of WORD); "" when nothing landed.
static func top(landed: Dictionary) -> String:
	var best := ""
	var n := 0
	for mv in WORD.keys():
		if int(landed.get(mv, 0)) > n:
			best = mv
			n = int(landed[mv])
	return best


## {worked, hurt, call (BoutRules.CORNER key), why}. names = [hers, the opponent's]; energy = hers at the bell.
static func card(summary: Dictionary, energy: float, names: Array) -> Dictionary:
	var mine: Dictionary = summary.get("a", {}).get("landed", {})
	var theirs: Dictionary = summary.get("b", {}).get("landed", {})
	var whole: Array = summary.get("a", {}).get("whole", [])
	var good := top(mine)
	var bad := top(theirs)
	# S309 "fix the wording": two women in the ring, so the card names who landed what; "why" is the coach talking to
	# her fighter ("you" = ours, the opponent by name).
	var worked := "%s landed nothing clean." % names[0] if good == "" else "%s landed %s." % [names[0], landed(int(mine[good]), good)]
	if not whole.is_empty():
		worked += " %s's %s landed whole." % [names[0], str(whole[0])]
	var hurt := "%s landed nothing clean." % names[1] if bad == "" else "%s landed %s." % [names[1], landed(int(theirs[bad]), bad)]
	var call := "long"
	var why := "Keep %s behind your jab." % names[1]
	if energy < WEARY_AT:
		call = "calm"
		why = "You're tired. Breathe and pick your shots."
	elif bad in SHORT and int(theirs[bad]) >= 2:
		call = "long"
		why = "%s's %s needs you close: keep her on the end of your jab." % [names[1], WORD[bad]]
	elif bad in LONG and int(theirs[bad]) >= 2:
		call = "body"
		why = "%s is winning at range: get inside and go to the body." % names[1]
	elif good == "body_hook":
		call = "body"
		why = "Your body shots are working: keep digging."
	elif good in LONG:
		call = "long"
		why = "Your %s is working: stay long." % WORD[good]
	return {"worked": worked, "hurt": hurt, "call": call, "why": why}


## "3 clean jabs" / "1 clean left hook".
static func landed(n: int, move: String) -> String:
	var w := str(WORD[move])
	if n != 1:
		w = "hooks to the body" if move == "body_hook" else w + "s"
	return "%d clean %s" % [n, w]
