extends SceneTree
## S399: a booked boxer who gets injured keeps her bout on the Home row with what it means (home leftovers: "Lucy can be Out
## injured while the card counts down to her bout"). Pure: HomeRows.next_text on hand-made dictionaries. Prints
## HOME_ROW_INJURED failures=<n>.
const HomeRows := preload("res://scripts/ui/HomeRows.gd")
const Career := preload("res://scripts/state/Career.gd")
var failures := 0


func _check(ok: bool, what: String) -> void:
	print(("  ok   " if ok else "  FAIL ") + what)
	if not ok:
		failures += 1


func _initialize() -> void:
	var c = Career.new()
	c.day = 100
	var opp := {"name": "Erin Shaw"}
	var free := {"bout": {}, "injury": {}, "offers": []}
	_check(HomeRows.next_text(c, free) == "No fight booked", "no bout, fit: No fight booked (%s)" % HomeRows.next_text(c, free))
	var hurt := {"bout": {}, "injury": {"type": "hand", "until_day": 110, "days_out": 14}}
	_check(HomeRows.next_text(c, hurt) == "Out injured", "no bout, hurt: Out injured")
	var heals := {"bout": {"opp": opp, "day": 120}, "injury": {"type": "hand", "until_day": 105, "days_out": 14}}
	var t1: String = HomeRows.next_text(c, heals)
	_check(t1.begins_with("Erin Shaw, 20 days") and t1.ends_with("fit in 5 days"), "booked, heals first: bout + fit in 5 (%s)" % t1)
	var pend := {"bout": {"opp": opp, "day": 108}, "injury": {"type": "hand", "until_day": 115, "days_out": 21, "choice": "pending"}}
	_check(HomeRows.next_text(c, pend) == "Hurt before the bout - decide", "booked, runs past, undecided: decide")
	var fight := {"bout": {"opp": opp, "day": 108}, "injury": {"type": "hand", "until_day": 115, "days_out": 21, "choice": "fight"}}
	_check(HomeRows.next_text(c, fight) == "Erin Shaw, 8 days - fighting hurt", "booked, fights hurt (%s)" % HomeRows.next_text(c, fight))
	var ok := {"bout": {"opp": opp, "day": 101}, "injury": {}}
	_check(HomeRows.next_text(c, ok) == "Erin Shaw, tomorrow", "booked, fit: unchanged")
	print("HOME_ROW_INJURED failures=%d" % failures)
	quit(1 if failures else 0)
