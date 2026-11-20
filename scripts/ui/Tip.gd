extends RefCounted
## S532 GUIDETIPS1 (owner: "your tooltips do not explain things"): the one way a screen writes a tooltip, and the checks the
## standard puts on it (ops/research/GUIDETIPS1_STANDARD.md section 2). Four kinds, all drawn by Tips as one wrapped card:
##   Tip.explain(c, d)        FULL card. d (a Dictionary, or a Callable that returns one, read at hover) =
##                            {title, what, now | rows: [[label, value, delta, tone]], moves, do, keys: [Glossary id]}
##                            what = what it is or what the money buys; now / rows = why it has this value; moves = what
##                            makes it go up and down; do = what the player can do here, starting with a verb.
##   Tip.short(c, title, what, do)   SHORT card: a plain value nothing this week moves. Two lines, 20 words.
##   Tip.button(c, text)      BUTTON line: one sentence saying what the click does (and what it costs).
##   MoveTip.attach           MOVE card (its own file: plays the move).
##   Tip.of(c) -> the spec a control shows today ({} = none; kind "plain" = an old tooltip_text line)
##   Tip.faults(spec, label, names) -> the rules it breaks: repeat, short, long, line, piled, rows, keys, key_unknown,
##       key_title, name, jargon, no_what. tests/tooltip_standard_test.gd walks the screens with it.

const Tips := preload("res://scripts/ui/Tips.gd")
const Glossary := preload("res://scripts/rules/Glossary.gd")

const MIN_WORDS := 6       # a tooltip under six words only says the label again
const LINE_WORDS := 14     # WHAT and MOVES IT: one sentence each
const SHORT_WORDS := 20    # a SHORT card, and a BUTTON line
const FULL_WORDS := 45     # a FULL card's sentences, rows not counted: a ceiling, not a target
const MAX_ROWS := 4
const MAX_KEYS := 2


static func explain(c: Control, d: Variant) -> void:
	Tips.card(c, func(): return spec(d.call() if d is Callable else d))
	_only_voice(c)


static func short(c: Control, title: String, what: String, todo: String = "") -> void:
	Tips.card(c, func(): return {"title": title, "what": what, "do": todo, "kind": "short"})
	_only_voice(c)


static func button(c: Control, text: String) -> void:
	Tips.card(c, func(): return {"lines": [text], "kind": "button"})


## The card speaks for the whole control: an icon or label inside it keeps no tooltip of its own (an icon's was its name).
static func _only_voice(c: Control) -> void:
	for n in c.find_children("*", "Control", true, false):
		(n as Control).tooltip_text = ""


## The card's kind, when the screen did not say: rows, a NOW line or a MOVES IT line make it FULL.
static func spec(d: Variant) -> Dictionary:
	if not (d is Dictionary) or (d as Dictionary).is_empty():
		return {}
	var s: Dictionary = (d as Dictionary).duplicate()
	if not s.has("kind"):
		s["kind"] = "full" if s.has("rows") or s.has("now") or s.has("moves") else "short"
	return s


## What `c` says on hover today: its card, or its plain tooltip line. {} = nothing.
static func of(c: Control) -> Dictionary:
	if c.has_meta(Tips.META_SPEC):
		var s: Variant = (c.get_meta(Tips.META_SPEC) as Callable).call()
		if not (s is Dictionary) or (s as Dictionary).is_empty():
			return {}
		var out: Dictionary = (s as Dictionary).duplicate()
		if not out.has("kind"):
			out["kind"] = "card"   # a card from before the standard: title, rows, Means
		return out
	return Tips.plain_spec(c)


## Every sentence on the card, in reading order (rows are not prose).
static func prose(s: Dictionary) -> Array:
	var out: Array = []
	for k in ["what", "now", "means", "moves", "do"]:
		if str(s.get(k, "")) != "":
			out.append(str(s[k]))
	for l in s.get("lines", []):
		out.append(str(l))
	return out


static func faults(s: Dictionary, label: String = "", names: Array = []) -> Array:
	var out: Array = []
	if s.is_empty():
		return out
	var kind := str(s.get("kind", "card"))
	var lines := prose(s)
	var all := " ".join(lines)
	var n := _count(all)
	var said := _norm(str(s.get("title", "")) + " " + all)
	var lab := _norm(label)
	if lab != "" and (said == lab or (said.length() > 3 and lab.contains(said))
			or (lab.length() > 8 and said.begins_with(lab) and said.length() < lab.length() + 12)):
		out.append("repeat")
	if kind in ["plain", "button"]:
		if n < MIN_WORDS:
			out.append("short")
		if n > SHORT_WORDS:
			out.append("long")   # more than one sentence to say: it is a card, not a line
	else:
		if str(s.get("what", "")) == "" and str(s.get("means", "")) == "":
			out.append("no_what")
		if n > (SHORT_WORDS if kind == "short" else FULL_WORDS):
			out.append("long")
		for k in ["what", "moves"]:
			for sentence in _sentences(str(s.get(k, ""))):
				if _count(sentence) > LINE_WORDS and not out.has("line"):
					out.append("line")
		if (s.get("rows", []) as Array).size() > MAX_ROWS:
			out.append("rows")
	var num := RegEx.create_from_string("\\d[\\d,.]*")
	for sentence in _sentences(all):
		if num.search_all(sentence).size() >= 3:
			out.append("piled")
			break
	if RegEx.create_from_string("(^|\\s)x\\d").search(all) != null:
		out.append("jargon")
	var keys: Array = s.get("keys", [])
	if keys.size() > MAX_KEYS:
		out.append("keys")
	for k in keys:
		var t := Glossary.term(str(k))
		if t.is_empty():
			out.append("key_unknown")
		elif _norm(str(s.get("title", ""))).begins_with(_norm(str(t["name"]))):
			out.append("key_title")   # the card's own word is never its own link
	var body := all
	for row in s.get("rows", []):
		body += " " + str(row[0])
	for nm in names:
		if str(nm).length() > 2 and body.contains(str(nm)):
			out.append("name")
			break
	return out


static func _sentences(text: String) -> Array:
	var out: Array = []
	for line in text.split("\n", false):
		for part in line.replace("? ", ". ").replace("! ", ". ").split(". ", false):
			out.append(part)
	return out


static func _count(text: String) -> int:
	return text.split(" ", false).size()


static func _norm(text: String) -> String:
	return " ".join(RegEx.create_from_string("[^a-z ]").sub(text.to_lower(), "", true).split(" ", false))
