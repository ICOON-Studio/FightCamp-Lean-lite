extends RefCounted
## S388 (operator: "Records should show a history of all actions that involved the player and his fighters (not ranodm news) like
## achivements for the fighters or the gym or the coach everything , and also aybe add filters there"): GYM > Records. Reads
## Career.news (never trimmed) and keeps only the gym's own rows: add_news marks the world's stories own = false. Each row gets who
## it is about and what kind it is, plus each fighter's finished goals. rows() -> [{"d", "t", "kind", "who": [ids]}], newest first.

const KINDS := ["Honours", "Fights", "Training", "Health", "People", "Money", "Gym"]
const GYM := "gym"
const COACH := "coach"

## First match wins, top down. "joined the" sits first so a medal's new members read as People, not Honours.
const WORDS := [
	["People", ["joined the", "left the"]],
	["Honours", [" award", " medal", "regional champion", " belt.", "Nationals 2", "Signature:", "met the goal", " rankings"]],
	["Training", ["the goal:", "new goal"]],   # before Fights: a goal's own title can say "bout"
	["Health", ["hurt", "injury", "suspended", "cleared to box", "doctor"]],
	["Money", ["sponsor", "signs with", "bill", "bank balance", "closed its doors"]],
	["People", ["signs for", "joins as", "trial", "asks to train", "new member", "turns pro", "stays amateur"]],
	["Fights", ["bout", "beats", "loses to", " draw", "Booked", "offer", "pulled out", "missed weight", "Tape on", " vs ", "entered for",
		"withdr", "bye through", "national draw", "at the "]],
	["Training", ["weapon", "can throw", "habit", "perk", "goal", "Coach"]],
]


static func rows(c: Career) -> Array:
	var out: Array = []
	for n in c.news:
		var text := str(n["t"])
		var who := who_of(c, text)
		# A save from before S388 has no "own" mark: a row naming nobody of ours is the world's story.
		var own := bool(n["own"]) if (n as Dictionary).has("own") else who != [GYM]
		if own:
			out.append({"d": int(n["d"]), "t": text, "kind": kind_of(text), "who": who})
	for f in c.fighters:
		for h in f.get("history", []):
			var line := "%s %s the goal: %s." % [f["first"], "met" if bool(h["met"]) else "missed", h["title"]]
			out.append({"d": int(h["d"]), "t": line, "kind": kind_of(line), "who": [str(f["id"])]})
	out.sort_custom(func(a, b): return int(a["d"]) > int(b["d"]))
	return out


static func kind_of(text: String) -> String:
	for row in WORDS:
		for w in row[1]:
			if text.contains(w):
				return str(row[0])
	return "Gym"


## Who a line is about: fighter and athlete ids, COACH, or [GYM] when it names nobody.
static func who_of(c: Career, text: String) -> Array:
	var out: Array = []
	for f in c.fighters + c.grapplers:
		if _names(text, str(f["first"])):
			out.append(str(f["id"]))
	if text.begins_with("Coach") or (not c.coach.is_empty() and _names(text, str(c.coach["name"]))):
		out.append(COACH)
	return out if not out.is_empty() else [GYM]


## The rows matching both filters; "" means all.
static func pick(all: Array, who: String, kind: String) -> Array:
	return all.filter(func(r): return (who == "" or (r["who"] as Array).has(who)) and (kind == "" or str(r["kind"]) == kind))


## The whole word: "Ana" is in "Ana's", never in "Banana".
static func _names(text: String, name: String) -> bool:
	var at := text.find(name)
	while at >= 0:
		var before := "" if at == 0 else text[at - 1]
		var end := at + name.length()
		var after := "" if end >= text.length() else text[end]
		if not _letter(before) and not _letter(after):
			return true
		at = text.find(name, at + 1)
	return false


static func _letter(ch: String) -> bool:
	return ch != "" and ch.to_lower() != ch.to_upper()
