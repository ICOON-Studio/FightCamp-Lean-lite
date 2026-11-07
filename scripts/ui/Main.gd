extends Control
## The root: owns the career, the route and the running clock, and turns every button press (act) into a change
## plus a redraw - the prototype's render loop. Screens and moments are one scene each.

const Recruit := preload("res://scripts/rules/Recruit.gd")
const UI := preload("res://scripts/ui/UI.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const Needs := preload("res://scripts/state/Needs.gd")
const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const GymActs := preload("res://scripts/ui/GymActs.gd")
const BoutActs := preload("res://scripts/ui/BoutActs.gd")
const RosterActs := preload("res://scripts/ui/RosterActs.gd")
const GrapplerPage := preload("res://scripts/ui/areas/GrapplerPage.gd")
const SaveGame := preload("res://scripts/state/SaveGame.gd")
const FightView := preload("res://scripts/fight3d/FightView.gd")
const TestJump := preload("res://scripts/ui/TestJump.gd")

const TITLE := preload("res://scenes/Title.tscn")
const CREATE := preload("res://scenes/Create.tscn")
const SHELL := preload("res://scenes/Shell.tscn")
const INTERVIEW := preload("res://scenes/modals/Interview.tscn")
const REVIEW := preload("res://scenes/modals/WeekReview.tscn")
const POSTER := preload("res://scenes/modals/PosterReveal.tscn")
const FirstWeek := preload("res://scripts/rules/FirstWeek.gd")
const FighterPage := preload("res://scripts/ui/areas/FighterPage.gd")
const Playbook := preload("res://scripts/ui/areas/Playbook.gd")
const INFO := preload("res://scenes/modals/InfoModal.tscn")
const CAMP := preload("res://scenes/modals/Camp.tscn")
const WEIGH := preload("res://scenes/modals/WeighIn.tscn")
const FIGHT := preload("res://scenes/modals/FightNight.tscn")
const GOALTALK := preload("res://scenes/modals/GoalTalk.tscn")
const TRIAL := preload("res://scenes/modals/Trial.tscn")
const PROOFFER := preload("res://scenes/modals/ProOffer.tscn")
const OPEN_NIGHT := preload("res://scenes/modals/OpenNight.tscn")
const MatNight := preload("res://scripts/ui/MatNight.gd")
const Grapplers := preload("res://scripts/state/Grapplers.gd")
const Settings := preload("res://scripts/state/Settings.gd")
const AutoSave := preload("res://scripts/state/AutoSave.gd")
const Routes := preload("res://scripts/ui/Routes.gd")

var career: Career = null
var screen := "title"
var create := {"step": 0, "country": "United Kingdom", "city": "London", "gym": ""}
var route := {"area": "home", "tab": 0, "fighter": "", "bout": ""}
var past: Array = []
var ahead: Array = []
var running := false
var speed := 2
var modal: Dictionary = {}
## The save slot (tests point it elsewhere).
var save_path := SaveGame.PATH
## S311: a scene can start at a test part without command-line args (Ziva's run_scene passes none): scenes/dev/Jump*.tscn.
@export var jump_override := ""

var _screen_holder: Control
var _fight_layer: Control
var _mat_layer: Control   # S389 a bout of an open fought live covers the career
var _modal_layer: Control
var _toast_layer: Control
var _shell: Node = null
var _timer: Timer
var _toast_timer: Timer
var _toast_frame := -1
var _shown_screen := ""


func _ready() -> void:
	theme = UI.theme()
	Settings.apply(Settings.read(), get_tree())   # S396 P15 text size, window, sound, as the player left them
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var bg := ColorRect.new()
	bg.color = UI.BG
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)
	_screen_holder = _layer()
	_fight_layer = _layer()
	_modal_layer = _layer()
	_mat_layer = _layer()
	_toast_layer = _layer()
	Grapplers.live = FightView.enabled()
	_toast_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_timer = Timer.new()
	_timer.one_shot = true
	_timer.timeout.connect(_tick)
	add_child(_timer)
	_toast_timer = Timer.new()
	_toast_timer.one_shot = true
	_toast_timer.timeout.connect(func(): UI.clear(_toast_layer))
	add_child(_toast_timer)
	render()
	# S310: the ops board's Play buttons start the build at the part to test (TestJump: `-- jump=fight`).
	# S335 `-- jump=grapple` (the ground-move browser), S337 `jump=strikemap` (StrikeMap's position cards), S379
	# `jump=theatre` (the Grappling theatre): prototypes outside the boxing game open on their own scene (TestJump.SCENE_JUMPS).
	var jump_scene := TestJump.scene_for(OS.get_cmdline_user_args())
	if jump_scene != "":
		get_tree().change_scene_to_file.call_deferred(jump_scene)
		return
	var jump := jump_override if TestJump.JUMPS.has(jump_override) else TestJump.wanted(OS.get_cmdline_user_args())
	if jump != "":
		(func():
			var ok := TestJump.run(self, jump)
			print("TESTJUMP %s reached fight night: %s" % [jump, ok])
			if ok and jump == "round3":
				TestJump.to_round3(self)).call_deferred()


func _layer() -> Control:
	var c := Control.new()
	c.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	c.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(c)
	return c


## ---------- drawing ----------

func render() -> void:
	if screen != _shown_screen:
		UI.clear(_screen_holder)
		_shell = null
		_shown_screen = screen
		if screen == "career":
			_shell = SHELL.instantiate()
			_screen_holder.add_child(_shell)
		_screen_holder.mouse_filter = Control.MOUSE_FILTER_PASS
	if screen == "title":
		_put_screen(TITLE)
	elif screen == "create":
		_put_screen(CREATE)
	elif _shell != null:
		_shell.refresh(self)


func _put_screen(scene: PackedScene) -> void:
	UI.clear(_screen_holder)
	var node := scene.instantiate()
	_screen_holder.add_child(node)
	node.build(self)


func _render_modal() -> void:
	UI.clear(_modal_layer)
	_modal_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	# Fight night in 3D: while a round plays the ring has the screen; the words modal draws over it between rounds.
	if FightView.sync(self, _fight_layer) or modal.is_empty():
		return
	_modal_layer.mouse_filter = Control.MOUSE_FILTER_STOP
	var scrim := ColorRect.new()
	scrim.color = Color(0.04, 0.027, 0.02, 0.72)
	scrim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_modal_layer.add_child(scrim)
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_modal_layer.add_child(center)
	var scene: PackedScene = {"interview": INTERVIEW, "review": REVIEW, "info": INFO, "camp": CAMP, "weighin": WEIGH,
		"fight": FIGHT, "goaltalk": GOALTALK, "trial": TRIAL, "prooffer": PROOFFER, "poster": POSTER, "open": OPEN_NIGHT}[modal["type"]]
	var node := scene.instantiate()
	center.add_child(node)
	node.build(self, modal)


## Redraws the open moment after its data changed (a pick, a round).
func redraw_modal() -> void:
	_render_modal()


func modal_node() -> Node:
	if _modal_layer.get_child_count() < 2:
		return null
	return _modal_layer.get_child(1).get_child(0)


func toast(text: String) -> void:
	UI.clear(_toast_layer)
	var p := PanelContainer.new()
	p.theme_type_variation = "Toast"
	p.add_child(UI.label(text))
	p.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
	p.grow_horizontal = Control.GROW_DIRECTION_BOTH
	p.grow_vertical = Control.GROW_DIRECTION_BEGIN
	p.offset_bottom = -24
	_toast_layer.add_child(p)
	_toast_timer.start(2.6)
	_toast_frame = Engine.get_process_frames()


func clear_toast() -> void:
	_toast_timer.stop()
	UI.clear(_toast_layer)


## S352 (board review: "toasts stay up across several screens and cover content"): a new screen or moment clears the
## toast of an EARLIER action; one raised by the same action (same frame, e.g. "signed" then the page) stays up.
func _drop_old_toast() -> void:
	if Engine.get_process_frames() != _toast_frame:
		clear_toast()


## ---------- time ----------

func on_go() -> void:
	var b := Needs.blockers(career)
	if not b.is_empty():
		act(str(b[0]["act"]), str(b[0]["arg"]))
		return
	if not Bouts.fighting_today(career).is_empty():
		act("fightnight")
		return
	if running:
		pause()
		return
	running = true
	render()
	_timer.start(0.12)


func _tick() -> void:
	if not running or career == null:
		return
	if Clock.step(career):
		pause()
		AutoSave.on_stop(career, save_path)   # S396 P15: every Monday, the last weeks kept
		if career.closed:
			act("closedgym")
		return
	render()
	_timer.start(Clock.TICK_MS[speed - 1] / 1000.0)


func pause() -> void:
	running = false
	_timer.stop()
	render()


## Steps day by day until the clock stops by itself, without the timer. Returns the days run (tests use it).
func run_to_stop(max_days: int = 60) -> int:
	var days := 0
	while days < max_days:
		days += 1
		if Clock.step(career):
			break
	render()
	return days


## ---------- navigation ----------

func nav(r: Dictionary) -> void:
	past.append(route.duplicate())
	ahead.clear()
	route = Routes.canon({"area": r.get("area", "home"), "tab": int(r.get("tab", 0)), "fighter": str(r.get("fighter", "")),
		"ftab": int(r.get("ftab", 0)), "ptab": int(r.get("ptab", 0)), "bout": str(r.get("bout", ""))})   # S396 screen cut
	_drop_old_toast()
	render()
	if _shell != null:
		_shell.scroll_top()


## S387 the Playbook lives on the fighter page. `who` goes first: the rail passes the fighter on screen, a "playbook:<tab>" link
## passes Playbook.pick (the caller named its fighter there, e.g. "Ana's mat: Playbook" from the roster).
func _nav_area(area: String, tab: int, who: String) -> void:
	if area != "playbook":
		nav({"area": area, "tab": tab})
		return
	var id := Playbook.fighter_id(career, who, str(route.get("fighter", "")))
	if id == "":
		toast("Sign a fighter first: the Playbook is on the fighter's page.")
		return
	nav({"area": "fighters", "tab": 0, "fighter": id, "ftab": FighterPage.PLAYBOOK_TAB, "ptab": tab})


func open_modal(m: Dictionary) -> void:
	if running:
		pause()
	modal = m
	_drop_old_toast()
	_render_modal()


func close_modal() -> void:
	modal = {}
	_render_modal()
	render()


func _unhandled_input(event: InputEvent) -> void:
	if not (event is InputEventKey) or not event.pressed or event.echo:
		return
	var key := (event as InputEventKey).keycode
	if key == KEY_SPACE and screen == "career" and modal.is_empty():
		on_go()
		get_viewport().set_input_as_handled()
	elif key == KEY_ESCAPE and not modal.is_empty() and not ["fight", "weighin", "trial", "open"].has(str(modal["type"])) \
			and not bool(modal.get("locked", false)):
		close_modal()
		get_viewport().set_input_as_handled()


## ---------- actions (every button lands here) ----------

func act(name: String, arg: String = "") -> void:
	match name:
		"quick":
			_start_career("Anvil Street Gym", "London")
		"newcareer":
			modal = {}
			_render_modal()
			create = {"step": 0, "country": "United Kingdom", "city": "London", "gym": ""}
			screen = "create"
			render()
		"cstep":
			create["step"] = int(arg)
			render()
		"cpick":
			var kv := arg.split("|")
			create[kv[0]] = kv[1]
			if kv[0] == "country":
				create["city"] = ""
			render()
		"cstart":
			_start_career(arg, str(create["city"]) if str(create["city"]) != "" else "London")
		"title":
			pause()
			modal = {}
			_render_modal()
			career = null
			screen = "title"
			render()
		"go":
			var parts := arg.split(":")
			_nav_area(parts[0], int(parts[1]) if parts.size() > 1 else 0, Playbook.pick)
		"area":
			_nav_area(arg, 0, str(route.get("fighter", "")))
		"ptab":
			nav({"area": "fighters", "tab": 0, "fighter": route["fighter"], "ftab": FighterPage.PLAYBOOK_TAB, "ptab": int(arg)})
		"guideweek":
			if on_week_tab():
				FirstWeek.set_week(career)
				render()
			else:
				nav({"area": "fighters", "tab": 0, "fighter": str(career.fighter().get("id", "")), "ftab": FighterPage.TRAINING_TAB})
		"guideskip":
			FirstWeek.skip(career)
			render()
		"tab":
			nav({"area": route["area"], "tab": int(arg)})
		"fighter":
			nav({"area": "fighters", "tab": 0, "fighter": arg, "ftab": 0})
		"ftab":
			nav({"area": "fighters", "tab": 0, "fighter": route["fighter"], "ftab": int(arg)})
		"back":
			if not past.is_empty():
				ahead.append(route)
				route = past.pop_back()
				_drop_old_toast()
				render()
		"fwd":
			if not ahead.is_empty():
				past.append(route)
				route = ahead.pop_back()
				_drop_old_toast()
				render()
		"settings":
			open_modal({"type": "info", "title": "Settings", "body": "", "settings": true})
		"handbook":
			open_modal({"type": "info", "title": "Handbook", "body": "", "handbook": true})
		"go_btn":
			on_go()
		"speed":
			speed = int(arg)
			render()
		"pausebtn":
			pause()
		"mail":
			career.unread = 0
			nav({"area": "world", "tab": 0})
		"interview":
			open_modal({"type": "interview", "picks": []})
		"pickcard":
			var picks: Array = modal["picks"]
			if Recruit.FOCUS.has(arg):   # S354 one starting focus replaces the cards
				picks.clear()
				picks.append(arg)
			elif picks.has(arg):
				picks.erase(arg)
			elif picks.size() < 3:
				picks.append(arg)
			_render_modal()
		"sign":
			Sim.sign(career, modal["picks"])
			var f: Dictionary = career.fighters[career.fighters.size() - 1]
			close_modal()
			toast("%s signed. Goal on the card: %s." % [f["first"], str(f["goal"]["title"]).to_lower()])
		"decline":
			close_modal()
			toast("The boxer waits at reception while you think.")
		"hire":
			var c := Sim.hire(career, arg)
			render()
			if not c.is_empty():
				toast("%s hired. $1,000 signing fee paid." % c["name"])
		"review":
			career.review_pending = false
			open_modal({"type": "review", "r": career.last_report})
			render()
		"close":
			close_modal()
		"closedgym":
			open_modal(closed_modal(career))
		"quit":
			get_tree().quit()
		"opennight":
			open_modal({"type": "open", "fid": arg})
		"opensim":
			Grapplers.sim_bout(career, career.grappler_by_id(arg))
			redraw_modal()
		"openlive":
			MatNight.start(self, _mat_layer, career.grappler_by_id(arg))
		"openclose":
			Grapplers.close_open(career, career.grappler_by_id(arg))
			close_modal()
		_:
			if not (GymActs.act(self, name, arg) or BoutActs.act(self, name, arg) or RosterActs.act(self, name, arg) or GrapplerPage.act(self, name, arg)):
				push_warning("unknown action " + name)


## S324 update 27: the close screen - the career in numbers, then load a save or start again. It cannot be dismissed.
static func closed_modal(c: Career) -> Dictionary:
	var w := 0
	var l := 0
	for f in c.fighters:
		w += int(f.get("w", 0)) + int(f.get("pro_w", 0))
		l += int(f.get("l", 0)) + int(f.get("pro_l", 0))
	var body := "%s closed on %s after %d weeks: %d weeks in a row below $0 (%s in the bank).\n\nFighters %d, record %d-%d, members at the end %d, reputation %d." % [
		c.gym_name, Clock.fmt_long(c.day), Clock.week_of(c.day), c.weeks_below, UI.money(c.cash), c.fighters.size(), w, l,
		c.members, c.reputation]
	return {"type": "info", "title": "The gym has closed", "body": body, "locked": true,
		"buttons": [["New career", "newcareer", ""], ["Load career", "load", ""], ["Title", "title", ""]]}


var quiet_moments := false   # S387 TestJump plays through: no poster moment in its way


func _start_career(gym_name: String, city: String) -> void:
	var c := Career.quick_start(gym_name, city)
	FirstWeek.begin(c)
	resume(c)   # S388 lands on the gym; nothing opens by itself (S275): the guide's "Meet the walk-in" opens the boxer


## S387 PosterReveal, the moment after Accept. Only with a picture: headless runs stay in words.
func show_poster(fid: String) -> void:
	if DisplayServer.get_name() != "headless" and not quiet_moments:
		open_modal({"type": "poster", "fid": fid})


## S387 FirstWeek: true on the fighter's Training tab, where the guide's "Lock in week 1" confirms the week.
func on_week_tab() -> bool:
	return route["area"] == "fighters" and str(route.get("fighter", "")) != "" and int(route.get("ftab", 0)) == FighterPage.TRAINING_TAB


## Puts a career on screen at HOME (a new one or a loaded save).
func resume(c: Career) -> void:
	modal = {}
	_render_modal()
	career = c
	route = {"area": "home", "tab": 0, "fighter": "", "ftab": 0, "bout": ""}
	past.clear()
	ahead.clear()
	running = false
	speed = 2
	screen = "career"
	render()
