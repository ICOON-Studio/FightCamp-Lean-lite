extends RefCounted
## S459 FIGHTSEAM1 (operator on Q-S294-218, "Hide the seams: no slow-down, calls any time, rules kept", note: "hide the seam
## it gives away who is winning"). The rules still settle a round as six 30-second exchanges (LiveRound); the screen stops
## showing the joins:
##   - the ring never slows at 30 s and no bar waits: a call clicked on the corner bar at any moment is ARMED and the next
##     exchange is fought on it (then it is spent, as a picked shout was); pace and aim stay in force as before.
##   - nothing on screen changes at a join that tells who took those 30 seconds: LANDED counts the punches as the 3D lands
##     them (the fired beats), the call ticks wait for the bell (the corner card), the exchange dots and the live round's
##     leader colour are gone.
##   arm(view, call)   armed(view) -> String   take(view) -> "call|pace=..|aim=.."   landed_ex(view) -> [record]

const LiveRound := preload("res://scripts/state/LiveRound.gd")


static func arm(view: Node, call: String) -> void:
	view.set_meta("armed", call)


static func armed(view: Node) -> String:
	return str(view.get_meta("armed", "")) if view != null else ""


## The shout line the next exchange is fought on, and the armed call spent.
static func take(view: Node) -> String:
	var lv: Dictionary = {}
	var main: Node = view.get("main")
	if main != null:
		lv = LiveRound.live(main.get("modal"))
	var line := "%s|pace=%s|aim=%s" % [armed(view), str(lv.get("pace", "steady")), str(lv.get("aim", ""))]
	view.set_meta("armed", "")
	return line


## One record in the exchange shape RoundBoard reads ({landed: [ours, theirs], body: [ours, theirs]}) from the punches the
## 3D has landed so far this round. "a" is our boxer (BodyMap: the defender of "b"'s punches is "a").
static func landed_ex(view: Node) -> Array:
	var landed := [0, 0]
	var body := [0, 0]
	var t := float(view.get("t")) if view.get("t") != null else 0.0
	for b in view.get("_round_beats"):
		var beat := b as Dictionary
		if float(beat.get("t", 0.0)) > t or str(beat.get("result", "")) != "lands":
			continue
		var k := 0 if str(beat.get("who", "")) == "a" else 1
		landed[k] += 1
		if str(beat.get("move", "")) == "body_hook":
			body[k] += 1
	return [{"landed": landed, "body": body}]
