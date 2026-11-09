extends SceneTree
## S411: a coach's areas average to the overall rating, every session reads its area, and the People
## card shows the five bars, Best at, and the boxer's week from WeekPlan.

const Data := preload("res://scripts/state/Data.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const CoachAreas := preload("res://scripts/rules/CoachAreas.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")
const PadWeek := preload("res://scripts/rules/PadWeek.gd")
const DrillWeek := preload("res://scripts/state/DrillWeek.gd")
const TrainingPreview := preload("res://scripts/rules/TrainingPreview.gd")
const PageInk := preload("res://tools/page_ink.gd")
const MenuFx := preload("res://scripts/ui/MenuFx.gd")
const MAIN := preload("res://scenes/Main.tscn")

var failures := 0
var main: Node


func _initialize() -> void:
	_rules()
	await _screen()
	print("COACH_AREAS failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _rules() -> void:
	for coach in Data.COACHES:
		var areas: Dictionary = coach["areas"]
		var sum := 0.0
		var ok := true
		for id in CoachAreas.AREAS:
			if not areas.has(id):
				ok = false
			else:
				sum += float(areas[id])
		var avg := sum / float(CoachAreas.AREAS.size())
		_check(ok and is_equal_approx(avg, float(coach["rating"])),
			"%s areas average %.3f, rating %s" % [coach["name"], avg, str(coach["rating"])])
	for id in WeekPlan.SESSIONS.keys():
		var area := CoachAreas.area_of(str(id))
		if str(id) == "rest":
			_check(area == "", "rest has no area")
		else:
			_check(CoachAreas.AREAS.has(area), "session %s is %s" % [id, area])
	for id in WeekPlan.EVENINGS.keys():
		var area := CoachAreas.area_of(str(id))
		if str(id) == "rest" or str(id) == "film":
			_check(area == "", "%s has no area" % id)
		else:
			_check(CoachAreas.AREAS.has(area), "evening %s is %s" % [id, area])
	_check(CoachAreas.area_of("mobility") == "conditioning", "mobility is conditioning")
	_check(CoachAreas.best(Data.coach("reid")) == "pads", "Reid is best at pads")
	_check(CoachAreas.best(Data.coach("hale")) == "conditioning", "Hale is best at conditioning")
	var stats := {"power": 60.0, "speed": 60.0, "technique": 60.0, "defense": 60.0, "conditioning": 60.0, "fight_iq": 60.0, "chin": 60.0}
	var reid := Data.coach("reid")
	_check(is_equal_approx(CoachAreas.rating_for({}, "pads"), Sim.NO_COACH_RATING), "no coach is the alone rating")
	_check(is_equal_approx(TrainingPreview.coach_factor(CoachAreas.rating_for({}, "roadwork")), 0.6), "alone factor is 60%")
	var bare := {"stats": stats, "pot": 80, "weight": 60.0, "coach": {}}
	var old := {"stats": stats, "pot": 80, "weight": 60.0, "coach": Sim.NO_COACH_RATING}
	_check(is_equal_approx(float(WeekPlan.day("roadwork", "normal", bare, 20.0)["gain"]),
		float(WeekPlan.day("roadwork", "normal", old, 20.0)["gain"])),
		"a session with no coach matches the old alone value")
	var rated := {"stats": stats, "pot": 80, "weight": 60.0, "coach": {"rating": 60.0}}
	var flat := {"stats": stats, "pot": 80, "weight": 60.0, "coach": 60.0}
	_check(is_equal_approx(float(WeekPlan.day("roadwork", "normal", rated, 20.0)["gain"]),
		float(WeekPlan.day("roadwork", "normal", flat, 20.0)["gain"])),
		"a rating with no areas still uses that rating")
	var ctx := {"stats": stats, "pot": 80, "weight": 60.0, "diet": "hold", "coach": reid,
		"camp_on": true, "camp_stat": "technique", "eve_drill": 0.2, "phase": "build"}
	var pad: Dictionary = WeekPlan.full_day("rest", "normal", "pads", ctx, 20.0)
	var ctx_c: Dictionary = ctx.duplicate()
	ctx_c["camp_stat"] = "conditioning"
	var cond: Dictionary = WeekPlan.day("roadwork", "normal", ctx_c, 20.0)
	_check(float(pad["gain2"]) > float(cond["gain"]) and float(cond["gain"]) > 0.0,
		"a pad session gains more with Reid than a conditioning one (%.4f > %.4f)" % [pad["gain2"], cond["gain"]])
	var as_float := {"stats": stats, "pot": 80, "weight": 60.0, "coach": CoachAreas.rating_for(reid, "roadwork")}
	_check(is_equal_approx(float(WeekPlan.day("roadwork", "normal", {"stats": stats, "pot": 80, "weight": 60.0, "coach": reid}, 20.0)["gain"]),
		float(WeekPlan.day("roadwork", "normal", as_float, 20.0)["gain"])),
		"roadwork reads Reid's conditioning rating")
	_check(absf(CoachAreas.lift(Sim.NO_COACH_RATING)) < 1e-6, "training alone lifts nothing")
	for r in [46.0, 48.0, 58.0, 64.0, 74.0, 90.0]:
		var want: float = (0.5 + r * 0.7 / 100.0) / 0.6 - 1.0
		_check(is_equal_approx(CoachAreas.lift(r), want), "lift(%.0f) = %+.1f%%" % [r, want * 100.0])


func _screen() -> void:
	MenuFx.instant = true
	main = MAIN.instantiate()
	root.add_child(main)
	await _settle(2)
	_size()
	await _settle(2)
	main.act("quick")
	var c: Career = main.career
	Sim.sign(c, ["Jab and move", "Pad rounds", "Hill sprints"])
	main.act("go", "gym:1")
	await _settle()
	_check(main.find_child("CoachCompare", true, false) != null, "two coaches side by side")
	_check(main.find_child("Assistant_reid", true, false) != null and main.find_child("Assistant_hale", true, false) != null,
		"both cards exist by name")
	_check(main.find_child("Hire_reid", true, false) != null and main.find_child("Hire_hale", true, false) != null,
		"Hire_reid and Hire_hale")
	_check(_fits(), "two offers fit on the page")
	main.act("hire", "reid")
	c.staff_roles = ["assistant", "strength", "physio", "cutman"]
	main.act("go", "gym:1")
	await _settle()
	_check(_fits(), "one coach, four jobs and the guide fit")
	c.guide = ""
	main.act("go", "gym:1")
	await _settle()
	var card: Node = main.find_child("Assistant_reid", true, false)
	_check(card != null, "the hired card is Assistant_reid")
	var bars: Node = card.find_child("AreaBars", true, false) if card != null else null
	_check(bars != null and bars.get_child_count() == 5, "five bars")
	if bars != null:
		var prev := 101.0
		for i in bars.get_child_count():
			var b := bars.get_child(i) as Control
			var rating := float(b.get_meta("rating"))
			_check(rating <= prev + 0.001, "bar %d %s at %.0f" % [i, str(b.get_meta("area")), rating])
			prev = rating
			var marked := _text(b).contains("Best at")
			_check(marked == (i == 0), "Best at on bar %d" % i)
		_check(str(bars.get_child(0).get_meta("area")) == "pads", "Reid's top bar is pads")
	var f: Dictionary = c.fighter()
	var area := CoachAreas.best(c.coach)
	var ctx: Dictionary = Sim.week_ctx(c, f)
	ctx["coach"] = {}
	var alone := WeekPlan.area_week(WeekPlan.days_of(f), PadWeek.evenings(f), ctx, area)
	ctx["coach"] = c.coach
	var coached := WeekPlan.area_week(WeekPlan.days_of(f), PadWeek.evenings(f), ctx, area)
	var want := CoachAreas.line(str(f["first"]), area, alone, coached)
	if area == "pads":   # S413 pad nights teach moves: the rating reaches the learning and the line counts it
		var r := float(c.coach["areas"]["pads"])
		_check(is_equal_approx(float(DrillWeek.inputs(c, f)["skill"]), r), "move learning reads the coach's pad rating")
		alone = DrillWeek.week_moves(c, f, 0.0)
		coached = DrillWeek.week_moves(c, f, r)
		_check(alone > 0.0 and coached > alone, "a coach's pad nights teach more than none (%.2f, %.2f)" % [alone, coached])
		_check(coached / alone <= 1.0 + 0.40 * r / 100.0 + 0.01, "and no more than the page's percent says (%.3f)" % (coached / alone))
		want = CoachAreas.move_line(str(f["first"]), area, alone, coached)
	var shown: Node = main.find_child("BoxerLine", true, false)
	_check(shown != null and str((shown as Label).text) == want, "boxer line equals WeekPlan: %s" % want)
	_check(main.find_child("Hire_reid", true, false) == null, "a hired coach has no Hire button")
	for id in ["assistant", "strength", "physio", "cutman"]:
		_check(main.find_child("LetGo_" + id, true, false) != null, "LetGo_%s" % id)
	_check(main.find_child("HeadCoachRow", true, false) != null, "the head coach stays on top")
	var wall := main.get_node_or_null("PaintedWall") as TextureRect
	_check(wall != null and wall.texture != null and str(wall.texture.resource_path).ends_with("gym_backdrop.jpg"),
		"painted gym behind People")
	_check(_fits(), "one coach and four jobs fit, no scroll")
	var ink: Dictionary = PageInk.read(root)
	print("STAFF_INK words=%d" % int(ink["words"]))
	_check(int(ink["words"]) <= 110, "People words %d <= 110 (pictures %.1f%%, tallest %.0f)" % [ink["words"], ink["pic_pct"], ink["tallest"]])
	if int(ink["words"]) > 110:
		_dump(root)


func _size() -> void:
	root.size = Vector2i(1920, 1080)
	if DisplayServer.get_name() == "headless":
		main.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
		main.size = Vector2(1920, 1080)


func _fits() -> bool:
	var sc: ScrollContainer = null
	for n in main.find_children("*", "ScrollContainer", true, false):
		sc = n as ScrollContainer
		break
	if sc == null or sc.get_child_count() == 0:
		print("  FAIL layout: no scroll")
		return false
	var bar := sc.get_v_scroll_bar()
	var bottom := (sc.get_child(0) as Control).get_global_rect().end.y
	var page: Control = main.find_child("PeoplePage", true, false)
	var people := page.get_global_rect().end.y if page != null else bottom
	print("  layout people=%.0f content=%.0f scroll=%.0f/%.0f" % [people, bottom, bar.max_value, bar.page])
	return people <= 1080.0 and bottom <= 1080.0 and bar.max_value <= bar.page + 1.0


func _text(n: Node) -> String:
	var s := ""
	if n is Label:
		s = (n as Label).text
	for c in n.get_children():
		s += " " + _text(c)
	return s


func _dump(n: Node) -> void:
	if n is Label and (n as Label).text.strip_edges() != "":
		print("   L ", (n as Label).text.replace("\n", " | "))
	if n is Button and (n as Button).text.strip_edges() != "":
		print("   B ", (n as Button).text.replace("\n", " | "))
	for c in n.get_children():
		_dump(c)


func _settle(n: int = 8) -> void:
	for i in n:
		await process_frame


func _check(ok: bool, what: String) -> void:
	if ok:
		print("  ok: ", what)
	else:
		failures += 1
		print("  FAIL: ", what)
