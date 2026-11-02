extends RefCounted
## S343 THE TAPE ROOM's films (operator Q-S294-68: "the player watches the films and it unflods like in grappleflows ,
## player has appropriate counters for each clip to make his plan . put grappleflows in the game as core mechanic";
## proposal Game Godot/research/TAPEROOM_S342.md). Her file (OppFile) cut into 3-4 short films from her past bouts
## (RivalPast), one tell each: her game, her best weapon, a habit, her weakness. A film is a beat list the 3D ring plays
## (BeatFire: "b" is her, in the blue corner she wears against us; "a" the woman she fought), and the flow it unfolds:
## her moves as nodes in the order she makes them (GrappleFlows: a node = a still of that moment, a short title, one line;
## the arrow into it a short label), the tell's node marked. Then THE COUNTERS: three moves from the place she takes the
## fight to in that situation (PlanFight.GAME_CARD) - one that answers her (PlanFight.ANSWERS best), one that half works
## (ok), one that does not (wrong, else nothing) - unlabelled, each with the coach's line on what it does; reading her is
## the player's job. The pick is a WHEN arrow in her plan (f["arrows"]): "if she presses: Step back".
##   clips(opp) -> [{tell, opens, kind, shape, title, sub, when, seconds, beats, nodes, tell_node}]   watched(opp, clip)
##   counters(when, habits, mastery) -> [{move, name, why, fit, grey}]   pick(plan, when, move) -> plan
## S343 SPOT (operator: "wanna try also your idea ?"): the player presses SPOT while she does it and names it from three
## (spot_choices); a right call inside her moment (spot_window - shorter for a top rival) opens it in her file now.
##   spot_choices(clip)   spot_window(clip, opp) -> Vector2   spot_ok(clip, opp, at_s, words)   known(opp, clip)
## Pure static; preloads the file (OppFile), the move map (StrikeMap) and the plan in the bout (PlanFight).

const OppFile := preload("res://scripts/rules/OppFile.gd")
const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")
const RoundStyle := preload("res://scripts/rules/RoundStyle.gd")

const MAX_CLIPS := 4
## A node's still is cut this long after its beat (the glove at contact, Stage.CONTACT_S ~0.27 s).
const STILL_AFTER_S := 0.3

## [t, who, move, result, def, node title, node line, label on the arrow into the node]. A row with a title is a node.
## Real tells: what a coach charts on her tape (Game research TAPEROOM_S342 "What a real coach does").
const SHAPES := {
	"press": {"when": "press", "tell": 2, "seconds": 9.0, "beats": [
		[0.6, "b", "step_in", "", "", "Walks in", "Chin down, straight in", ""],
		[1.3, "b", "jab", "misses", "block", "", "", ""],
		[1.7, "b", "cross", "lands", "", "Jab, cross", "Two straight shots as she arrives", "on arrival"],
		[2.6, "a", "step_out", "", "", "", "", ""],
		[3.3, "b", "step_in", "", "", "Follows", "Every step back, a step in", "the other backs off"],
		[3.8, "b", "lead_hook", "lands", "", "", "", ""],
		[4.4, "b", "body_hook", "lands", "", "Hooks at mid range", "Head, then body, close", "in range"],
		[5.6, "a", "jab", "misses", "block", "", "", ""],
		[6.1, "a", "step_out", "", "", "", "", ""],
		[6.8, "b", "step_in", "", "", "Walks down again", "Never a rest", "the other backs off again"],
		[7.4, "b", "cross", "misses", "slip", "", "", ""],
		[7.8, "b", "lead_hook", "lands", "", "", "", ""]]},
	"press_body": {"when": "press", "tell": 1, "seconds": 8.5, "beats": [
		[0.6, "b", "step_in", "", "", "Steps in", "Head off the centre line", ""],
		[1.2, "b", "body_hook", "lands", "", "Body hook", "The left to the ribs, on arrival", "close"],
		[2.0, "a", "jab", "misses", "block", "", "", ""],
		[2.6, "b", "body_hook", "lands", "", "", "", ""],
		[3.0, "b", "lead_hook", "lands", "", "Body, then head", "The hand comes down, the hook goes up", "the guard drops"],
		[4.4, "a", "step_out", "", "", "", "", ""],
		[5.0, "b", "step_in", "", "", "", "", ""],
		[5.5, "b", "body_hook", "lands", "", "Back to the body", "Every time she gets close", "she follows"],
		[6.6, "a", "cross", "misses", "block", "", "", ""]]},
	"press_flurry": {"when": "press", "tell": 1, "seconds": 8.5, "beats": [
		[0.6, "b", "step_in", "", "", "Steps in", "Straight into range", ""],
		[1.1, "b", "jab", "misses", "block", "", "", ""],
		[1.4, "b", "cross", "misses", "block", "", "", ""],
		[1.7, "b", "lead_hook", "lands", "", "Three, four punches", "Never one shot - always a flurry", "at once"],
		[2.0, "b", "cross", "misses", "block", "", "", ""],
		[3.2, "a", "jab", "lands", "", "", "", ""],
		[3.7, "b", "jab", "lands", "", "", "", ""],
		[4.0, "b", "cross", "misses", "block", "", "", ""],
		[4.3, "b", "body_hook", "lands", "", "Flurries again", "Hit or not, she keeps throwing", "straight back"],
		[5.6, "a", "step_out", "", "", "", "", ""],
		[6.2, "b", "step_in", "", "", "", "", ""],
		[6.6, "b", "jab", "misses", "block", "", "", ""],
		[6.9, "b", "cross", "lands", "", "", "", ""]]},
	"range": {"when": "range", "tell": 1, "seconds": 8.5, "beats": [
		[0.6, "b", "jab", "lands", "", "Jab", "Long, from the end of the reach", ""],
		[1.4, "b", "jab", "misses", "block", "", "", ""],
		[2.2, "a", "step_in", "", "", "", "", ""],
		[2.6, "b", "step_out", "", "", "Steps back out", "The moment the other comes in", "the other closes"],
		[3.4, "b", "jab", "lands", "", "", "", ""],
		[3.9, "b", "cross", "misses", "block", "Jab, cross at range", "Never closer than the jab", "back at range"],
		[5.0, "a", "step_in", "", "", "", "", ""],
		[5.4, "a", "jab", "misses", "slip", "", "", ""],
		[5.9, "b", "step_out", "", "", "", "", ""],
		[6.6, "b", "jab", "lands", "", "On the end of the jab again", "Touch, step back, touch", "out again"]]},
	"range_straight": {"when": "range", "tell": 1, "seconds": 8.0, "beats": [
		[0.6, "b", "jab", "misses", "block", "Jab to set it up", "Long, to find the range", ""],
		[1.0, "b", "cross", "lands", "", "Straight right", "Down the middle, behind the jab", "right behind it"],
		[2.4, "a", "step_in", "", "", "", "", ""],
		[2.8, "b", "step_out", "", "", "", "", ""],
		[3.6, "b", "jab", "lands", "", "", "", ""],
		[3.9, "b", "cross", "lands", "", "Again down the middle", "The same two punches", "at range"],
		[5.4, "a", "jab", "misses", "slip", "", "", ""],
		[6.0, "b", "cross", "lands", "", "", "", ""]]},
	"counter": {"when": "counter", "tell": 1, "seconds": 8.0, "beats": [
		[0.8, "a", "jab", "misses", "slip", "Waits", "Hands up: she lets the other woman lead", ""],
		[1.2, "b", "cross", "lands", "", "Counter over the jab", "Slips it, the right hand comes back over it", "the jab comes"],
		[2.6, "a", "jab", "misses", "block", "", "", ""],
		[3.0, "a", "cross", "misses", "slip", "", "", ""],
		[3.4, "b", "lead_hook", "lands", "", "Counter hook", "Slips the cross, hooks back", "the cross comes"],
		[5.0, "a", "step_in", "", "", "", "", ""],
		[5.6, "a", "jab", "misses", "block", "", "", ""],
		[6.0, "b", "cross", "lands", "", "Never leads", "Every punch she throws is an answer", "she leads again"]]},
	"loadup": {"when": "loadup", "tell": 1, "seconds": 8.0, "beats": [
		[0.8, "b", "step_in", "", "", "Sets the feet", "Plants, the right hand back", ""],
		[1.4, "b", "cross", "misses", "slip", "Loads the right", "One big shot - you see it coming", "she plants"],
		[2.6, "a", "jab", "lands", "", "", "", ""],
		[3.6, "b", "lead_hook", "misses", "weave", "Wide hook", "Swings for the head", "after the miss"],
		[4.4, "a", "cross", "lands", "", "", "", ""],
		[5.4, "b", "cross", "lands", "", "Lands the big one", "She waits, then throws hard", "she sets again"]]},
	"tiring": {"when": "tiring", "tell": 1, "seconds": 8.0, "beats": [
		[0.8, "b", "jab", "misses", "block", "Late in the round", "The jab is slower now", ""],
		[1.6, "b", "tired", "", "", "Hands drop", "Mouth open, gloves at the chest", "slowing"],
		[2.4, "a", "jab", "lands", "", "", "", ""],
		[2.9, "a", "cross", "lands", "", "Gets hit clean", "Guard low, feet slow", "the other lets go"],
		[3.8, "b", "jab", "misses", "block", "", "", ""],
		[4.6, "b", "tired", "", "", "", "", ""],
		[5.2, "a", "lead_hook", "lands", "", "", "", ""],
		[5.6, "a", "cross", "lands", "", "Stands and takes it", "No punches back", "again"]]},
	"hurt_body": {"when": "hurt", "tell": 1, "seconds": 7.5, "beats": [
		[0.8, "a", "cross", "lands", "", "She is hit", "A clean right hand lands", ""],
		[1.4, "b", "body_hook", "lands", "", "Digs to the body", "Hurt, she comes back downstairs", "straight away"],
		[2.0, "b", "body_hook", "misses", "block", "", "", ""],
		[3.2, "a", "jab", "lands", "", "", "", ""],
		[3.6, "a", "cross", "lands", "", "", "", ""],
		[4.2, "b", "body_hook", "lands", "", "Body again", "Every time she is hurt", "hit again"]]},
	"hurt_wild": {"when": "hurt", "tell": 1, "seconds": 7.5, "beats": [
		[0.8, "a", "cross", "lands", "", "She is hit", "A clean right hand lands", ""],
		[1.4, "b", "lead_hook", "misses", "weave", "Swings wild", "Hurt, she loads up a wide hook", "straight away"],
		[2.2, "b", "cross", "misses", "slip", "", "", ""],
		[3.0, "a", "jab", "lands", "", "", "", ""],
		[3.4, "a", "cross", "lands", "", "", "", ""],
		[4.0, "b", "cross", "lands", "", "Still dangerous", "The big right still lands", "hit again"]]},
	"drops_right": {"when": "range", "tell": 1, "seconds": 8.0, "beats": [
		[0.7, "b", "jab", "misses", "block", "Jab", "The lead hand goes out", ""],
		[1.0, "a", "lead_hook", "lands", "", "Hook over it", "The right hand drops as the jab comes back", "as it comes back"],
		[2.6, "b", "jab", "lands", "", "", "", ""],
		[2.9, "a", "lead_hook", "lands", "", "Again", "Jab - then the chin is open", "the same jab"],
		[4.4, "b", "jab", "misses", "block", "", "", ""],
		[4.7, "a", "lead_hook", "lands", "", "", "", ""]]},
	"lunges": {"when": "press", "tell": 0, "seconds": 8.0, "beats": [
		[0.8, "b", "step_in", "", "", "Lunges in with the jab", "The whole body follows the jab, feet square", ""],
		[0.9, "b", "jab", "misses", "slip", "", "", ""],
		[1.3, "a", "cross", "lands", "", "Countered", "The right hand comes back over it", "as she lands"],
		[2.8, "a", "step_out", "", "", "", "", ""],
		[3.6, "b", "step_in", "", "", "", "", ""],
		[3.7, "b", "jab", "misses", "slip", "Lunges again", "Same lunge, same line", "straight line"],
		[4.1, "a", "lead_hook", "lands", "", "", "", ""]]},
	"admires": {"when": "range", "tell": 1, "seconds": 8.0, "beats": [
		[0.6, "b", "jab", "lands", "", "", "", ""],
		[0.9, "b", "cross", "lands", "", "", "", ""],
		[1.3, "b", "lead_hook", "lands", "", "Three-punch combination", "Jab, cross, hook - all land", ""],
		[2.2, "b", "say", "", "", "Stands and admires", "Hands low, feet still, looking", "after it"],
		[2.6, "a", "cross", "lands", "", "", "", ""],
		[3.0, "a", "lead_hook", "lands", "", "Hit while she looks", "Two clean shots back", "she waits"],
		[4.6, "b", "jab", "lands", "", "", "", ""],
		[4.9, "b", "cross", "lands", "", "", "", ""],
		[5.6, "b", "say", "", "", "", "", ""],
		[6.0, "a", "cross", "lands", "", "", "", ""]]},
	"slow_start": {"when": "range", "tell": 0, "seconds": 8.0, "beats": [
		[0.6, "b", "step_out", "", "", "Round 1: feeling it out", "Out of range, barely throws", ""],
		[1.6, "a", "jab", "lands", "", "", "", ""],
		[2.2, "a", "cross", "lands", "", "Gives the round away", "The other woman scores first", "free shots"],
		[3.2, "b", "jab", "misses", "block", "", "", ""],
		[4.2, "a", "jab", "lands", "", "", "", ""],
		[4.6, "a", "cross", "misses", "block", "", "", ""],
		[5.4, "b", "step_out", "", "", "Still waiting", "One jab in ten seconds", "on the end"]]},
	"backs_up": {"when": "range", "tell": 1, "seconds": 8.0, "beats": [
		[0.6, "a", "step_in", "", "", "Pressed", "The other woman walks forward", ""],
		[1.0, "b", "step_out", "", "", "Backs straight up", "No angle - straight back", "she is pressed"],
		[1.8, "a", "step_in", "", "", "", "", ""],
		[2.2, "b", "step_out", "", "", "", "", ""],
		[2.8, "a", "jab", "lands", "", "", "", ""],
		[3.2, "a", "body_hook", "lands", "", "On the ropes", "Out of room, she covers", "two steps back"],
		[4.0, "b", "jab", "misses", "block", "", "", ""],
		[4.6, "a", "cross", "lands", "", "", "", ""]]},
}
## S343 the body shows the tell (the risk test: on the first stills her right hand never dropped, her guard never sank and
## the lunge read as a plain jab): her beats of this move in this film carry `tell`, which the ring poses on her body
## (TellPose, TASK_TELLS1). [move, pose].
const TELL_POSES := {"drops_right": ["jab", "hand_drop"], "lunges": ["jab", "lunge"], "tiring": ["tired", "tired_guard"],
	"admires": ["say", "hands_low"]}
## Her weapon words -> the film that shows it (first match).
const WEAPON_SHAPES := [["over the jab", "counter"], ["counter", "counter"], ["long jab", "range"], ["jab she lives", "range"],
	["body", "press_body"], ["hooks", "press_body"], ["overhand", "loadup"], ["heavy right", "loadup"], ["straight", "range_straight"],
	["down the middle", "range_straight"], ["never stops", "press_flurry"], ["flurries", "press_flurry"]]
## Her game (OppFile.main_game) -> its film.
const GAME_SHAPES := {"press": "press", "range": "range", "counter": "counter", "loadup": "loadup"}
## A habit (RoundStyle.opponent_habits) -> its film.
const HABIT_SHAPES := {"fades_late": "tiring", "slow_starter": "slow_start", "drops_right_after_jab": "drops_right",
	"lunges_with_jab": "lunges", "admires_her_work": "admires", "digs_body_when_hurt": "hurt_body", "loads_up_when_hurt": "hurt_wild"}
## Her weakness words -> its film.
const WEAK_SHAPES := [["fades", "tiring"], ["legs late", "tiring"], ["slow to start", "slow_start"], ["round 1", "slow_start"],
	["chin", "drops_right"], ["drops the right", "drops_right"], ["walks in straight", "lunges"], ["straight lines", "lunges"],
	["backs straight", "backs_up"], ["backed up", "backs_up"], ["stands still", "admires"]]
## What each move does, in the coach's words (the counters say what a move does, never whether it answers her).
const WHY := {"step_in": "Step in behind the jab and take the centre", "1-1-2": "Double jab to close, then the cross",
	"feint": "Feint and draw the lead", "1-1": "Double jab: touch and stay long", "1-2": "The one-two down the middle",
	"2-3": "Cross, then the hook as she comes", "1-2-3": "One-two-hook, all in", "1-2-3-2": "Four punches, all in",
	"1-2-3b": "One-two, then a hook to the ribs", "step_out": "Step out of range and wait", "cut_off": "Cut off the ring, walk to the ropes",
	"1-6-3": "Jab, uppercut, hook in close", "3b-3": "Dig the body, then the head", "slip 2-3": "Slip the punch, cross and hook back",
	"step_back": "One step back: the punches fall short", "tie_up": "Tie the arms up and lean in", "roll_out": "Roll under and out to the side",
	"push_off": "Shove off and reset", "pivot_out": "Pivot off the ropes into open ring", "herd": "Herd into the corner"}
const KIND_WORDS := {"style": "Game", "weapon": "Best weapon", "habit": "Habit", "weakness": "Weakness"}
## S343 SPOT (operator: "wanna try also your idea ?"): what each film shows, in the words the player picks from after SPOT.
const SPOT_WORDS := {"press": "She keeps walking forward", "press_body": "She goes to the body as she arrives",
	"press_flurry": "Throws in flurries", "range": "Keeps you at the end of the jab",
	"range_straight": "A straight right behind the jab", "counter": "Waits, then counters over the jab",
	"loadup": "Loads up one big right", "tiring": "Hands drop when tired", "hurt_body": "Hurt, digs to the body",
	"hurt_wild": "Hurt, swings wild", "drops_right": "The right hand drops after the jab",
	"lunges": "Lunges in behind the jab", "admires": "Stands still after a combination",
	"slow_start": "She barely throws early", "backs_up": "She backs straight up"}
## The moment to SPOT a tell: from just before its node to this long after it, by her rating - a top rival hides it
## better (the moment is shorter).
const SPOT_LEAD_S := 0.3
const SPOT_S := [[62.0, 2.2], [68.0, 1.6], [999.0, 1.0]]


## Her films, in the order a coach watches them: her game, her best weapon, a habit, her weakness (a second habit when the
## weakness has no film); at most MAX_CLIPS, never two of one film.
static func clips(opp: Dictionary, past: Array = []) -> Array:
	if (opp.get("bouts", []) as Array).is_empty() and not past.is_empty():
		opp = opp.duplicate()
		opp["bouts"] = past
	var out: Array = []
	var used := {}
	var habits: Array = []
	for t in OppFile.tells(opp):
		var id := str(t["id"])
		var kind := id.get_slice(":", 0)
		var shape := ""
		match kind:
			"style":
				shape = str(GAME_SHAPES.get(OppFile.main_game(opp), ""))
			"weapon":
				shape = _first(str(t["value"]), WEAPON_SHAPES)
			"habit":
				shape = str(HABIT_SHAPES.get(id.get_slice(":", 1), ""))
				if shape != "":
					habits.append([id, t, shape])
				continue
			"weakness":
				shape = _first(str(t["value"]), WEAK_SHAPES)
		if shape != "" and not used.has(shape):
			used[shape] = true
			out.append(_clip(opp, t, shape))
	# Her habits go before the weakness while there is room; a habit her weakness film already shows opens with it.
	var at := out.size()
	for i in out.size():
		if str(out[i]["kind"]) == "weakness":
			at = i
	for h in habits:
		var shape := str(h[2])
		if used.has(shape):
			for c in out:
				if str(c["shape"]) == shape:
					(c["opens"] as Array).append(str(h[0]))
			continue
		if out.size() >= MAX_CLIPS:
			break
		used[shape] = true
		out.insert(at, _clip(opp, h[1], shape))
		at += 1
	return out


static func _clip(opp: Dictionary, t: Dictionary, shape: String) -> Dictionary:
	var s: Dictionary = SHAPES[shape]
	var kind := str(t["id"]).get_slice(":", 0)
	var beats: Array = []
	var nodes: Array = []
	for r in s["beats"]:
		var b := {"t": float(r[0]), "who": str(r[1]), "move": str(r[2]), "result": str(r[3]), "def": str(r[4]),
			"caption": "", "big": false, "knockback": false}
		var pose: Array = TELL_POSES.get(shape, [])
		if not pose.is_empty() and str(r[1]) == "b" and str(r[2]) == str(pose[0]):
			b["tell"] = str(pose[1])
		if str(r[5]) != "":
			b["node"] = nodes.size()
			nodes.append({"t": float(r[0]), "title": str(r[5]), "line": str(r[6]), "edge": str(r[7]), "who": str(r[1]),
				"tell": nodes.size() == int(s["tell"])})
		beats.append(b)
	var value := str(t["value"])
	if kind == "style":
		value = str(OppFile.GAME_WORDS.get(OppFile.main_game(opp), value))
	return {"tell": str(t["id"]), "opens": [str(t["id"])], "kind": kind, "shape": shape, "title": "%s: %s" % [KIND_WORDS.get(kind, kind), value],
		"sub": _bout_line(opp, kind), "when": str(s["when"]), "seconds": float(s["seconds"]), "beats": beats, "nodes": nodes,
		"tell_node": int(s["tell"])}


## Which of her past bouts (RivalPast, newest first) the film is cut from: a win shows her game and weapon, a loss her
## weakness. "" with no record.
static func _bout_line(opp: Dictionary, kind: String) -> String:
	var want_win := kind != "weakness"
	var bouts: Array = opp.get("bouts", [])
	for b in bouts:
		if bool(b["win"]) == want_win and not bool(b.get("ours", false)):
			return "%s %s (%s), %s" % ["Beat" if want_win else "Lost to", b["vs"], b["vs_club"], b["how"]]
	return "Club show footage" if bouts.is_empty() else "%s vs %s (%s)" % ["Bout", bouts[0]["vs"], bouts[0]["vs_club"]]


## THE COUNTERS for a situation: three moves out of the place it puts the fight (PlanFight.GAME_CARD) - one that answers
## her, one that half works (else a second answer), one that does not (wrong, else one that does nothing) - in a fixed
## shuffled order. `habits` refines the situation the way the bout does (PlanFight.refine: a hurt woman who hits back);
## `mastery` greys a combination she cannot throw yet (StrikeMap.grey_reason).
static func counters(when: String, habits: Array = [], mastery: Dictionary = {}) -> Array:
	var sit := PlanFight.refine(when, habits, 0, 6)
	var card := str(PlanFight.GAME_CARD.get(when, "long"))
	var by := {"best": [], "ok": [], "wrong": [], "none": []}
	for m in StrikeMap.outs(card):
		(by[PlanFight.fit(str(m["id"]), sit)] as Array).append(m)
	var picks: Array = []
	for k in [["best"], ["ok", "none", "best"], ["wrong", "none", "ok", "best"]]:
		for g in k:
			var left: Array = (by[g] as Array).filter(func(m): return not picks.has(m))
			if not left.is_empty():
				picks.append(left[0])
				break
	var out: Array = []
	for m in picks:
		var id := str(m["id"])
		out.append({"move": id, "name": str(m["name"]), "why": str(WHY.get(PlanFight.base_id(id), m["name"])),
			"fit": PlanFight.fit(id, sit), "grey": StrikeMap.grey_reason(m, mastery) if not mastery.is_empty() else ""})
	# The answer is never always first: the order turns with the situation.
	var turn := absi(hash(when)) % maxi(1, out.size())
	return out.slice(turn) + out.slice(0, turn)


## Her plan with the counter as a WHEN arrow; it replaces the arrow already on that place for that situation.
static func pick(plan: Array, when: String, move_id: String) -> Array:
	var row := StrikeMap.move(move_id)
	var out: Array = plan.filter(func(a): return not (str(StrikeMap.move(str(a["move"])).get("from", "")) == str(row.get("from", ""))
		and str(a.get("when", "")) == when))
	out.append({"move": move_id, "when": when})
	return out


## The arrow her plan holds for a film's situation ("" = none yet).
static func answer(plan: Array, when: String) -> String:
	var card := str(PlanFight.GAME_CARD.get(when, "long"))
	for a in plan:
		if str(a.get("when", "")) == when and str(StrikeMap.move(str(a["move"])).get("from", "")) == card:
			return str(a["move"])
	return ""


## A right SPOT finds what the film shows: its tells open in her file (OppFile.open). Returns the ids opened.
static func watched(opp: Dictionary, clip: Dictionary) -> Array:
	return (clip.get("opens", []) as Array).filter(func(id): return OppFile.open(opp, str(id)))


## SPOT's three choices: what this film shows and two things other films show, in a fixed order for the film.
static func spot_choices(clip: Dictionary) -> Array:
	var shape := str(clip["shape"])
	var others: Array = SPOT_WORDS.keys().filter(func(k): return k != shape and str(SPOT_WORDS[k]) != str(SPOT_WORDS[shape]))
	others.sort()
	var h := absi(hash(shape))
	var a := str(SPOT_WORDS[others[h % others.size()]])
	var b := str(SPOT_WORDS[others[(h / 7 + 3) % others.size()]])
	if b == a:
		b = str(SPOT_WORDS[others[(h % others.size() + 1) % others.size()]])
	var out := [str(SPOT_WORDS[shape]), a, b]
	var turn := h % 3
	return out.slice(turn) + out.slice(0, turn)


## [from, to] seconds of the film in which SPOT catches its tell.
static func spot_window(clip: Dictionary, opp: Dictionary) -> Vector2:
	var at := float((clip["nodes"] as Array)[int(clip["tell_node"])]["t"])
	var width := 1.0
	for r in SPOT_S:
		if float(opp.get("rating", 60.0)) < float(r[0]):
			width = float(r[1])
			break
	return Vector2(at - SPOT_LEAD_S, at + width)


## A right call: SPOT inside the moment and the words this film shows.
static func spot_ok(clip: Dictionary, opp: Dictionary, at_s: float, words: String) -> bool:
	var w := spot_window(clip, opp)
	return at_s >= w.x and at_s <= w.y and words == str(SPOT_WORDS.get(str(clip["shape"]), ""))


## True when her file already holds what this film shows (her game is free at booking; tape study may have found it).
static func known(opp: Dictionary, clip: Dictionary) -> bool:
	return OppFile.known(opp, str(clip["tell"]))


static func habits_of(opp: Dictionary) -> Array:
	return RoundStyle.opponent_habits(opp)


static func _first(text: String, rows: Array) -> String:
	var low := text.to_lower()
	for r in rows:
		if low.contains(str(r[0])):
			return str(r[1])
	return ""
