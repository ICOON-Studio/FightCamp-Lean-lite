extends SceneTree
## S403: every icon from the approved menus turns into a real picture in the game, with a tooltip.

const KitIcon := preload("res://scripts/ui/KitIcon.gd")


func _initialize() -> void:
	var failures := 0
	for id in KitIcon.ICONS:
		var t := KitIcon.tex(id, 32)
		if t == null or t.get_width() != 32:
			failures += 1
			print("FAIL bad picture: ", id)
		if KitIcon.tip(id) == "":
			failures += 1
			print("FAIL no tooltip: ", id)
	for state in ["booked", "camp", "injured", "offer", "contract", "free", "leaving", "retiring"]:
		if not KitIcon.has_icon(state):
			failures += 1
			print("FAIL missing state: ", state)
	var r := KitIcon.icon("camp", 24, Color.RED, "In camp, week 1")
	if r.tooltip_text != "In camp, week 1" or r.modulate != Color.RED:
		failures += 1
		print("FAIL icon() ignores its arguments")
	r.free()
	print("KIT_ICON failures=", failures)
	quit(0 if failures == 0 else 1)
