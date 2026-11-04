extends RefCounted
## S359 one day of the coach's whiteboard (split out of WeekBoard, past the 500-line rule): the day's name and 'undo',
## the MORNING magnet (every card on a click, its index card on hover - Tips), the EVENING magnet, TIRED BY NIGHT (bar
## and word, its card on hover).
## S382 G5 (gym idea 2, hover ghosts): a card under the cursor in the morning's picker, or 'undo' (the coach's card), calls
## ghost(dow, card) - THIS CAMP ghosts that week's dry run on its gauge row; ghost(dow, []) when the cursor leaves.
##   WeekDay.make(main, fid, i, m, planned, evening, r, red, mine, items, twist, coach_card, ghost) -> Control   WeekDay.kind(m)

const UI := preload("res://scripts/ui/UI.gd")
const WB := preload("res://scripts/ui/WhiteboardKit.gd")
const Tips := preload("res://scripts/ui/Tips.gd")
const Data := preload("res://scripts/state/Data.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")
const WeekPhase := preload("res://scripts/rules/WeekPhase.gd")

const DAY_W := 140.0
const DAYS := ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"]
const SHORT := {"power": "power", "speed": "speed", "technique": "tech", "defense": "def", "conditioning": "cond",
	"fight_iq": "ring IQ", "chin": "chin"}

static func make(main: Node, fid: String, i: int, m: Array, planned: Array, evening: String, r: Dictionary, red: bool, mine: bool,
		items: Array, twist := "", coach_card: Array = [], ghost := Callable()) -> Control:
	var pad := MarginContainer.new()
	pad.name = "Day_%d" % i
	for side in ["left", "right"]:
		pad.add_theme_constant_override("margin_" + side, 8)
	pad.custom_minimum_size = Vector2(DAY_W, 0)
	pad.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var v := UI.vbox(6)
	pad.add_child(v)
	var head := UI.hbox(6)
	head.add_child(WB.ink(DAYS[i], 26, "marker"))
	if mine and coach_card.size() == 2:
		# S359 (Kalli SQ25 "a small undo arrow on each changed magnet"): back to the coach's card for this day.
		var undo := Button.new()
		undo.name = "Undo_%d" % i
		undo.text = "undo"
		undo.flat = true
		undo.focus_mode = Control.FOCUS_NONE
		undo.add_theme_font_override("font", UI.font("handbold"))
		undo.add_theme_font_size_override("font_size", UI.SMALL)
		undo.add_theme_color_override("font_color", UI.GOLD)
		undo.add_theme_color_override("font_hover_color", WB.RED)
		for k in ["normal", "hover", "pressed", "focus"]:
			undo.add_theme_stylebox_override(k, StyleBoxEmpty.new())
		undo.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		undo.tooltip_text = "Your change. Back to the coach's card: %s" % WeekPhase.card(coach_card)
		undo.pressed.connect(func(): main.act("wday", "%s|%d|%s|%s" % [fid, i, coach_card[0], coach_card[1]]))
		if ghost.is_valid():
			undo.mouse_entered.connect(func(): ghost.call(i, coach_card))
			undo.mouse_exited.connect(func(): ghost.call(i, []))
		head.add_child(undo)
	if m != planned:
		head.add_child(WB.ink("twist", UI.SMALL, "handbold", UI.AMBER))
	v.add_child(head)
	# S359 (operator: "whats the top row, what is the second row?"): each magnet row says what it is; the coach's
	# shorthand for the day (engine / skill / hard) moved to the morning's hover.
	var am := WB.ink("MORNING", UI.SMALL - 3, "caps", WB.PENCIL)
	am.name = "Am_%d" % i
	v.add_child(am)
	var rest := str(m[0]) == "rest"
	var name := "off" if rest else str(WeekPhase.NAMES.get(str(m[0]), str(m[0])))
	var tip := "Morning: %s (a %s day)\n%s\nfatigue %d by the night%s" % [WeekPhase.card(m), _kind(m), _numbers(r), int(round(float(r["fatigue"]))),
		"\nYour change - 'undo' above puts the coach's card back" if mine else ""]
	# S357 (S356 stills): a day the twist changed names the card it replaced.
	if m != planned:
		tip += "\nTwist (%s): replaces %s" % [twist, WeekPhase.card(planned)]
	var cur := items.map(func(it): return it[1]).find([str(m[0]), "normal" if rest else str(m[1])])
	var mag := WB.pick_magnet(name, "" if rest else WB.level(str(m[1])), str(m[1]) == "hard", tip, items, cur,
		func(d): main.act("wday", "%s|%d|%s|%s" % [fid, i, d[0], d[1]]))
	mag.name = "Session_%d" % i
	if ghost.is_valid():
		hover_items(mag, func(k: int):
			if ghost.is_valid():   # a pick may have redrawn the board before the list closes
				ghost.call(i, (items[k][1] as Array) if k >= 0 else []))
	# S359 (operator on the old hover: "unreadable"; J90): an index card beside the magnet, the numbers with their meaning.
	Tips.card(mag, func(): return _magnet_card(m, planned, r, red, mine, twist))
	v.add_child(mag)
	var pm := WB.ink("EVENING", UI.SMALL - 3, "caps", WB.PENCIL)
	pm.name = "Pm_%d" % i
	pm.tooltip_text = "Evenings are pads, or sparring on the nights set by \"Sparring nights\" below."
	pm.mouse_filter = Control.MOUSE_FILTER_PASS
	v.add_child(pm)
	# S360 (Q-S294-90 "Both", Kalli: "cut the evening magnet ... show the evening on the day as text only"): the camp's phase
	# and the weekly Sparring nights set the evenings, so the day only says what it is.
	var ev := WB.ink("~ off" if evening == "rest" else (evening if evening in ["sparring", "film"] else "pads"), UI.SMALL + 2,
		"handbold" if evening == "sparring" else "hand", WB.INK if evening == "sparring" else WB.PENCIL)
	ev.name = "Evening_%d" % i
	ev.tooltip_text = str((WeekPlan.EVENINGS.get(evening, WeekPlan.EVENINGS["rest"]) as Dictionary)["name"])
	ev.mouse_filter = Control.MOUSE_FILTER_PASS
	v.add_child(ev)
	var fat := float(r["fatigue"])
	var tl := WB.ink("TIRED BY NIGHT", UI.SMALL - 3, "caps", WB.PENCIL)
	tl.name = "TiredLabel_%d" % i
	v.add_child(tl)
	var bar := WB.Fatigue.new()
	bar.value = fat
	v.add_child(bar)
	# S359 the fatigue as a word; the number and its cost are on the hover (Kalli SQ25).
	var fw := WB.fatigue_word(fat, red)
	var word := WB.ink(str(fw[0]), UI.SMALL + 2, "handbold", fw[2])
	word.name = "Fatigue_%d" % i
	word.tooltip_text = str(fw[1])
	word.mouse_filter = Control.MOUSE_FILTER_PASS
	var tone := "bad" if fat >= WB.RED_AT or red else ("watch" if fat >= WB.AMBER_AT else "")
	Tips.card(word, func(): return {"title": "Tired by night: %s" % str(fw[0]),
		"rows": [["Fatigue", "%d / 100" % int(round(fat)), str(fw[0]), tone], ["The line", "80", "", ""]],
		"means": str(fw[1]).get_slice(": ", 1) if str(fw[1]).contains(": ") else str(fw[1]), "keys": ["fatigue"]})
	v.add_child(word)
	return pad


## S382 G5: the picker's item under the cursor -> on_item(index), -1 when the cursor is off the list or the list closes.
## PopupMenu only signals keyboard moves (id_focused), so while it is open each frame reads its focused item - the item
## under the mouse (a click opens it with none; the keyboard's item counts too).
static func hover_items(mag: MenuButton, on_item: Callable) -> void:
	var pop := mag.get_popup()
	var last := [-1]
	var tree: Array = [null]
	var tick := func() -> void:
		if not is_instance_valid(pop):
			return
		var k := maxi(-1, pop.get_focused_item())
		if k != int(last[0]):
			last[0] = k
			on_item.call(k)
	var stop := func() -> void:   # also when a pick redraws the board under the open list
		var t: SceneTree = tree[0]
		if t != null and t.process_frame.is_connected(tick):
			t.process_frame.disconnect(tick)
	pop.about_to_popup.connect(func() -> void:
		last[0] = -1
		tree[0] = mag.get_tree()
		if not (tree[0] as SceneTree).process_frame.is_connected(tick):
			(tree[0] as SceneTree).process_frame.connect(tick))
	pop.popup_hide.connect(func() -> void:
		stop.call()
		if int(last[0]) >= 0:
			last[0] = -1
			on_item.call(-1))
	mag.tree_exiting.connect(stop)


## The morning magnet's card: the session, what it builds, where she ends the day, and what that means.
static func _magnet_card(m: Array, planned: Array, r: Dictionary, red: bool, mine: bool, twist: String) -> Dictionary:
	var rows: Array = []
	for k in [["stat", "gain"], ["stat2", "gain2"]]:
		var st := str(r.get(k[0], ""))
		if st != "":
			var g := float(r[k[1]])
			rows.append([str(Data.LABEL.get(st, st)), "%+.2f" % g, "▲" if g > 0.0 else "", "good" if g > 0.0 else ""])
	rows.append(["Weight", "%+.2f kg" % float(r["kg"]), "", ""])
	var fat := float(r["fatigue"])
	var fw := WB.fatigue_word(fat, red)
	rows.append(["Tired by night", "%d / 100" % int(round(fat)), str(fw[0]),
		"bad" if fat >= WB.RED_AT or red else ("watch" if fat >= WB.AMBER_AT else "")])
	var means := "a %s day; %s" % [_kind(m), str(fw[1]).get_slice(": ", 1).to_lower() if str(fw[1]).contains(": ") else ""]
	if m != planned:
		means = "the twist (%s) replaced %s. %s" % [twist, WeekPhase.card(planned), _cap(means)]
	elif mine:
		means = "your change - 'undo' on the day puts the coach's card back. " + _cap(means)
	return {"title": "%s - morning" % WeekPhase.card(m), "rows": rows, "means": _cap(means.strip_edges()),
		"keys": ["fatigue", "phase"] + (["twist"] if m != planned else []), "hint": [["click", "change the day"], ["shift", "pin"]]}


## The day's kind in the coach's shorthand: rest, hard, engine (conditioning), skill.
static func _kind(m: Array) -> String:
	if str(m[0]) == "rest":
		return "rest"
	if str(m[1]) == "hard":
		return "hard"
	return "engine" if str(WeekPlan.session(str(m[0]))["stat"]) == "conditioning" else "skill"


static func _numbers(r: Dictionary) -> String:
	var nums := PackedStringArray()
	if str(r["stat"]) != "":
		nums.append("%s %+.2f" % [SHORT.get(str(r["stat"]), str(r["stat"])), float(r["gain"])])
	if str(r.get("stat2", "")) != "":
		nums.append("%s %+.2f" % [SHORT.get(str(r["stat2"]), str(r["stat2"])), float(r["gain2"])])
	nums.append("%+.2f kg" % float(r["kg"]))
	return ", ".join(nums)


static func _cap(s: String) -> String:
	return s.left(1).to_upper() + s.substr(1)
