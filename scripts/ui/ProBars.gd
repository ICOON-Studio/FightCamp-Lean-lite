extends RefCounted
## S544 (owner on the S544 build: "wtf is this why half the screen isout of bounds ?" - turning pro v17 had put a page-wide
## TURNING PRO card above everything on the boxer's Overview and pushed the goal and body row off a 1080 screen): from the
## first pro offer to pro fight 6 the boxer's CONFIDENCE and HUNGER are two more bars under FATIGUE and LOYALTY, in the
## same form (DarkOverview.condition / loyalty); before signing, the patience marks; at hunger 0, the warning. No card of
## their own: the rows take their height from the boxer's picture, never from the page.
##   rows(f, width) -> Array of Control ([] when the boxer has no pro start, or is past pro fight 6 with no warning)
##   NEW: a row named in `fresh` ("conf", "hunger", "patience") carries a gold NEW chip (the reveal after a decision).

const UI := preload("res://scripts/ui/UI.gd")
const Palette := preload("res://scripts/ui/Palette.gd")
const DarkOverview := preload("res://scripts/ui/DarkOverview.gd")
const ProStart := preload("res://scripts/rules/ProStart.gd")

const BARS := [["conf", "CONFIDENCE", "green", 50, "Confidence %d of 100. It moves the win chance of pro fights 1 to 6 by up to 5 points either way: 50 is level. Wins raise it, a stoppage costs most."],
	["hunger", "HUNGER", "amber", 0, "Hunger %d of 100: how much the boxer wants it. Safe wins and each Not yet lower it, a risky bout raises it. At 0 the boxer asks to leave."]]


## The rows that carry a NEW chip in the build now running (set by the page around DarkOverview.make, then cleared).
static var mark: Array = []


static func shown(f: Dictionary) -> bool:
	var s: Dictionary = f.get("pro_start", {})
	return not s.is_empty() and not (bool(f.get("pro", false)) and not ProStart.on(s) and int(s.get("warn", 0)) == 0)


static func rows(f: Dictionary, width: int, fresh: Array = []) -> Array:
	if not shown(f):
		return []
	if fresh.is_empty():
		fresh = mark
	var s: Dictionary = f["pro_start"]
	var out: Array = []
	for k in BARS:
		var v := int(s.get(k[0], 50))
		var low := (str(k[0]) == "hunger" and v <= 20) or (str(k[0]) == "conf" and v < 30)
		var tone: Color = DarkOverview.TONE["red"] if low else DarkOverview.TONE[str(k[2])]
		var row := UI.hbox(10)
		row.name = "Bar_" + str(k[0])
		row.mouse_filter = Control.MOUSE_FILTER_PASS
		row.tooltip_text = str(k[4]) % v
		row.add_child(UI.label(str(k[1]), UI.BODY, DarkOverview.SOFT, "bold"))
		var bar := DarkOverview.Bar.new()
		bar.frac = float(v) / 100.0
		bar.tick = float(k[3]) / 100.0
		bar.colour = tone
		bar.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
		bar.custom_minimum_size = Vector2(120, 22)
		row.add_child(bar)
		row.add_child(UI.label(str(v), 26, tone, "bold"))
		if fresh.has(str(k[0])):
			row.add_child(new_chip())
		out.append(row)
	if not bool(f.get("pro", false)):
		var pr: Control = load("res://scripts/ui/modals/ProOffer.gd").patience_row(s)
		if fresh.has("patience"):
			pr.add_child(new_chip())
		out.append(pr)
	var warn: String = load("res://scripts/state/ProPair.gd").warning_line(f)
	if warn != "":
		var wl := UI.label("Asks to leave: warning %d of %d. A risky bout brings the hunger back." % [int(s.get("warn", 0)), int(ProStart.WARNINGS)],
			UI.SMALL, DarkOverview.TONE["red"], "bold", true)
		wl.name = "HungerWarning"
		wl.custom_minimum_size.x = width
		wl.mouse_filter = Control.MOUSE_FILTER_PASS
		wl.tooltip_text = warn
		out.append(wl)
	return out


## The gold NEW mark on something a decision just changed.
static func new_chip() -> Control:
	var p := UI.chip("NEW", "gold")
	p.name = "NewChip"
	p.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	return p
