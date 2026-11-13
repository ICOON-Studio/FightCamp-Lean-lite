extends RefCounted
## S427 the live round board on the corner bar (operator's marks on the bar, Feedback/2026-11-10-20: "make them smaller .
## and use the space to add some live stats ?"). Three things a corner can act on, as pictures:
##   LANDED     punches this round, hers against the opponent's, one two-way bar, head and body under it
##   HER GAME   what the opponent is doing NOW (lit), and the games she has shown this round with how often
##   YOUR CALLS each call used this round with a tick or a cross per use (stop shouting what loses)
## Pure builder: build(ex, sit, names, w, h) from the round's exchange records (LiveRound) - it holds no state.

const TV := preload("res://scripts/ui/TV.gd")
const WoodKit := preload("res://scripts/ui/WoodKit.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const CornerIcons := preload("res://scripts/fight3d/CornerIcons.gd")
const SharedHolo := preload("res://scripts/fight3d/SharedHolo.gd")

const RED := Color("#e2483d")
const BLUE := Color("#5b9bff")
const GREEN := Color("#2fae6e")
const SLATE := Color("#1a1512")
const EDGE := Color("#5a4a3a")


## S459 FIGHTSEAM1: `live` = FightSeam.landed_ex (the punches the 3D has landed); when given, LANDED counts those and the
## calls show no tick or cross until the bell (a tick at each join told who took those 30 seconds).
static func build(ex: Array, sit: String, names: Array, w: float, h: float, live: Array = [], holo: String = "", hurt: Array = []) -> Control:
	var board := Panel.new()
	board.name = "RoundBoard"
	board.mouse_filter = Control.MOUSE_FILTER_IGNORE
	board.custom_minimum_size = Vector2(w, h)
	board.add_theme_stylebox_override("panel", _box(SLATE, EDGE, 10, 2))
	var me := str(names[0]) if names.size() > 0 else "You"
	var her := str(names[1]) if names.size() > 1 else "Opponent"
	# The "<name> NOW" column moved onto the head chip and the side panel. Its width goes to these two.
	var col := (w - 24.0) * (0.62 if holo != "" else 0.5)   # S459 C384: the shared holo takes the larger share
	_landed(board, live if not live.is_empty() else ex, me, her, 12.0, col - 8.0, h, holo, hurt)
	_calls(board, ex, 12.0 + col + 4.0, w - 24.0 - col - 8.0, h, live.is_empty())
	board.set_meta("sit", sit)
	return board


## [mine, hers] landed, and [mine, hers] of those to the body.
static func tally(ex: Array) -> Dictionary:
	var landed := [0, 0]
	var body := [0, 0]
	for e in ex:
		var l: Array = (e as Dictionary).get("landed", [0, 0])
		var b: Array = (e as Dictionary).get("body", [0, 0])
		for k in 2:
			landed[k] = int(landed[k]) + (int(l[k]) if l.size() > k else 0)
			body[k] = int(body[k]) + (int(b[k]) if b.size() > k else 0)
	return {"landed": landed, "body": body}


## The games she has shown this round, most often first: [{sit, n}].
static func games(ex: Array) -> Array:
	var count := {}
	for e in ex:
		var s := str((e as Dictionary).get("sit", ""))
		if s != "":
			count[s] = int(count.get(s, 0)) + 1
	var rows: Array = []
	for s in count:
		rows.append({"sit": str(s), "n": int(count[s])})
	rows.sort_custom(func(a: Dictionary, b: Dictionary) -> bool: return int(a["n"]) > int(b["n"]))
	return rows


## Each call used this round, the latest first: [{call, wins: [bool, ...]}].
static func calls(ex: Array) -> Array:
	var rows: Array = []
	for i in range(ex.size() - 1, -1, -1):
		var id := str((ex[i] as Dictionary).get("call", ""))
		if id == "":
			continue
		var found := false
		for r in rows:
			if str((r as Dictionary)["call"]) == id:
				((r as Dictionary)["wins"] as Array).push_front(bool((ex[i] as Dictionary).get("won", false)))
				found = true
		if not found:
			rows.append({"call": id, "wins": [bool((ex[i] as Dictionary).get("won", false))]})
	return rows


## S459 C384: with `holo` (BodyHolo.holo_for's prefix) the head and body counts hang off one shared holo (SharedHolo); the
## two totals sit low at each side, in each corner's colour.
static func _landed(board: Control, ex: Array, _me: String, _her: String, x: float, w: float, h: float, holo: String = "", hurt: Array = []) -> void:
	var t := tally(ex)
	var mine := int(t["landed"][0])
	var hers := int(t["landed"][1])
	_put(board, _tag("LANDED"), x, 6, w, 22)
	if holo != "":
		var fig := SharedHolo.new()
		fig.name = "SharedHolo"
		fig.setup(holo, [mine - int(t["body"][0]), int(t["body"][0])], [hers - int(t["body"][1]), int(t["body"][1])], RED, BLUE, hurt)
		_put(board, fig, x, 26, w, h - 30.0)
		for k in 2:
			var big := TV.label(str([mine, hers][k]), 40, [RED, BLUE][k], "bold")
			big.name = ["LandedMine", "LandedHers"][k]
			big.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT if k == 0 else HORIZONTAL_ALIGNMENT_RIGHT
			_put(board, big, x if k == 0 else x + w - 70.0, h - 56.0, 70, 48)
		board.set_meta("landed", [mine, hers])
		return
	var a := TV.label(str(mine), 44, RED, "bold")
	a.name = "LandedMine"
	_put(board, a, x, 28, 70, 52)
	var b := TV.label(str(hers), 44, BLUE, "bold")
	b.name = "LandedHers"
	b.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_put(board, b, x + w - 70.0, 28, 70, 52)
	var bar := Split.new()
	bar.mine = mine
	bar.hers = hers
	bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_put(board, bar, x + 74.0, 44, w - 148.0, 20)
	# S448 operator: names only in the header. S459 C383 on the YOURS / THEIRS words: "remove that make it distinctive
	# properly" - each row opens with a glove in its corner's colour (the same colour as its big number); who it is, on hover.
	var rows := [["FootMine", RED, mine - int(t["body"][0]), int(t["body"][0]), "Your boxer's punches landed this round"],
		["FootHers", BLUE, hers - int(t["body"][1]), int(t["body"][1]), "The opponent's punches landed this round"]]
	for i in rows.size():
		var r: Array = rows[i]
		var y := 84.0 + 24.0 * float(i)
		var glove := CornerIcons.Glove.new()
		glove.name = str(r[0]) + "Glove"
		glove.col = r[1]
		glove.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_put(board, glove, x, y - 1.0, 24, 24)
		var foot := TV.label("head %d  body %d" % [int(r[2]), int(r[3])], 20, r[1], "bold")
		foot.name = str(r[0])
		foot.tooltip_text = str(r[4])
		foot.mouse_filter = Control.MOUSE_FILTER_PASS
		_put(board, foot, x + 30.0, y, w - 30.0, 22)
	board.set_meta("landed", [mine, hers])


static func _calls(board: Control, ex: Array, x: float, w: float, _h: float, ticks_on: bool = true) -> void:
	# S444 operator C333 on this box: "what is this for?" - the heading now says it: each call, did it win its exchanges.
	_put(board, _tag("CALLS WORKED?" if ticks_on else "CALLS THIS ROUND"), x, 6, w, 22)
	var rows := calls(ex)
	if rows.is_empty():
		var none := TV.label("No call yet", 22, WoodKit.SOFT, "bold")
		none.name = "NoCalls"
		_put(board, none, x, 34, w, 30)
		return
	var y := 30.0
	for r in rows.slice(0, 3):
		var id := str(r["call"])
		var lab := TV.label(str((Exchanges.CALLS.get(id, {}) as Dictionary).get("label", id)), 20, WoodKit.INK, "bold")
		lab.name = "Used_" + id
		lab.clip_text = true
		var wins := (r["wins"] as Array).slice(-3) if ticks_on else []
		var tick_w := 28.0 * float(wins.size()) + 4.0   # S444: the name takes the room the ticks leave ("Draw the" was cut)
		_put(board, lab, x, y, w - tick_w, 30)
		var ticks := Ticks.new()
		ticks.wins = wins
		ticks.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_put(board, ticks, x + w - tick_w, y + 2.0, tick_w, 26)
		y += 36.0


static func _tag(text: String) -> Label:
	return TV.label(text, 20, WoodKit.SOFT, "bold")


static func _box(bg: Color, edge: Color, radius: int, width: int) -> StyleBoxFlat:
	var sb := StyleBoxFlat.new()
	sb.bg_color = bg
	sb.border_color = edge
	sb.set_border_width_all(width)
	sb.set_corner_radius_all(radius)
	return sb


static func _put(parent: Control, c: Control, x: float, y: float, w: float, h: float) -> void:
	parent.add_child(c)
	c.position = Vector2(x, y)
	c.size = Vector2(w, h)
	if c.mouse_filter == Control.MOUSE_FILTER_STOP:
		c.mouse_filter = Control.MOUSE_FILTER_IGNORE


## Punches landed, hers against the opponent's, as one bar split at their share.
class Split extends Control:
	var mine := 0
	var hers := 0

	func _draw() -> void:
		var total := mine + hers
		var share := 0.5 if total == 0 else float(mine) / float(total)
		draw_rect(Rect2(0, 0, size.x, size.y), Color("#3a3028"))
		if total > 0:
			draw_rect(Rect2(0, 0, size.x * share, size.y), RED)
			draw_rect(Rect2(size.x * share, 0, size.x * (1.0 - share), size.y), BLUE)
		draw_rect(Rect2(size.x * share - 2.0, -3.0, 4.0, size.y + 6.0), Color("#efe6d8"))


## One tick or cross per use of a call, oldest first.
class Ticks extends Control:
	var wins: Array = []

	func _draw() -> void:
		var x := size.x - 28.0 * float(wins.size())
		for won in wins:
			if bool(won):
				draw_polyline(PackedVector2Array([Vector2(x + 3, 13), Vector2(x + 10, 21), Vector2(x + 23, 4)]), GREEN, 4.0, true)
			else:
				draw_line(Vector2(x + 5, 5), Vector2(x + 21, 21), RED, 4.0)
				draw_line(Vector2(x + 21, 5), Vector2(x + 5, 21), RED, 4.0)
			x += 28.0
