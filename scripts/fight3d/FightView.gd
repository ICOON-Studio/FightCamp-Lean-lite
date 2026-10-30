extends Control
## Fight night in 3D: plays each round the words already settled (RoundScript beats on the FightStage), with a scorebug,
## the round's lines as captions, Highlights / Full, 1x / 2x, SKIP ROUND and SKIP BOUT (Kalli K-FIGHT3D1). Skipping never
## changes a thing: the result is decided before anyone watches. Between rounds the 2D corner picker draws over the
## frozen ring. Main keeps one FightView on its fight layer while a fight modal is open (FightView.sync).
## Headless (the tests) has no picture: the view is off there and fight night stays in words.

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const RoundScript := preload("res://scripts/rules/RoundScript.gd")
const RoundStyle := preload("res://scripts/rules/RoundStyle.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const HabitBeats := preload("res://scripts/rules/HabitBeats.gd")
const Combos := preload("res://scripts/rules/Combos.gd")
const ComboWords := preload("res://scripts/rules/ComboWords.gd")
const CornerCard := preload("res://scripts/rules/CornerCard.gd")
const HABITS_PATH := "res://assets/data/fight_habits.json"
const UI := preload("res://scripts/ui/UI.gd")
const FightCast := preload("res://scripts/fight3d/FightCast.gd")

## The player's choices last the session.
static var highlights := true
static var fast := false

const REAL_ROUND_S := 180.0
## S302 (operator: "still too slow"): a follow-up by the same boxer starts part-way through its wind-up so it lands this
## long after her last punch, never with less than MIN_WIND_S of visible throw. Piorkowski, Lees & Barton 2011 (the paper
## itself, p. 11; John's "125 ms" is not in it): contact of the 1st to contact of the 4th punch 1.06 +- 0.46 s with
## alternating hands (~0.35 s a punch), 1.35 +- 0.27 s with the same hand (~0.45 s).
const COMBO_LAND_S := 0.35
const COMBO_SAME_HAND_S := 0.45
const MIN_WIND_S := 0.12
const CLOSE_UP_S := 1.5
const BELL_S := 2.6

var main: Node
var stage: Node3D
var crew: Node3D
var fid := ""
var plan: Dictionary = {}
var beats: Array = []
var round_n := 0
var _stop := ""   # "KO" / "RSC" when this round ends the bout
var _stepped := [false, false]   # her next punch steps in (a Pro _ft take)
var _tired := [false, false]     # she has tired this round: her punches are the _hurt takes
var _last_contact := [-9.0, -9.0]  # view time her last punch lands (S302 combos)
var _last_hand := ["", ""]
var _profiles: Dictionary = {}
var total := 3
var t := 0.0
var length := 40.0
var next := 0
var playing := false
var _close_left := 0.0
var _quiet := 0.0
var _amb_rng := RandomNumberGenerator.new()
var _bell_left := -1.0
var _bug: Label
var _bug_box: PanelContainer
var _clock: Label
var _caption: Label
var _cap_box: PanelContainer
var _caption_left := 0.0
var _banner: Label
var _buttons: HBoxContainer
var _names := ["", ""]


## Called on every modal draw. True while a round is playing (the modal stays hidden then).
static func sync(m_main: Node, layer: Control) -> bool:
	var m: Dictionary = m_main.modal
	var view: Node = layer.get_child(0) if layer.get_child_count() > 0 else null
	var fight := not m.is_empty() and str(m.get("type", "")) == "fight" and str(m.get("step", "")) != "tape"
	if not fight or not enabled():
		if view != null:
			view.queue_free()
			layer.remove_child(view)
		return false
	if view == null or str(view.fid) != str(m["fid"]):
		if view != null:
			view.queue_free()
			layer.remove_child(view)
		view = new()
		layer.add_child(view)
		view.setup(m_main, m)
	if str(m["step"]) == "round" and int(m.get("watched", 0)) < int(m["round"]):
		if int(view.round_n) != int(m["round"]):
			view.play_round(m, int(m["round"]))
		return true
	view.freeze()
	return false


## The 3D view plays wherever there is a picture to draw; `no3d` on the command line turns it off.
static func enabled() -> bool:
	return DisplayServer.get_name() != "headless" and not OS.get_cmdline_user_args().has("no3d")


func setup(m_main: Node, m: Dictionary) -> void:
	main = m_main
	fid = str(m["fid"])
	total = int(m.get("total", 3))
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	var c: Career = main.career
	var f: Dictionary = c.fighter_by_id(fid)
	var opp: Dictionary = f["bout"]["opp"]
	_names = [str(f["name"]), str(opp["name"])]
	var holder := SubViewportContainer.new()
	holder.stretch = true
	holder.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	holder.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(holder)
	var vp := SubViewport.new()
	vp.own_world_3d = true
	vp.msaa_3d = Viewport.MSAA_4X
	holder.add_child(vp)
	stage = Stage.new()
	vp.add_child(stage)
	var picks := FightCast.bodies_for(float(f.get("limit", 61.2)))
	var sc := FightCast.body_scales(float(f.get("limit", 61.2)), float(f.get("height", 0.0)), float(opp.get("height", 0.0)))
	stage.setup({"glb": picks[0], "corner": "red", "scale": sc[0], "stance": str(f.get("stance", "orthodox"))},
		{"glb": picks[1], "corner": "blue", "scale": sc[1], "stance": str(opp.get("stance", "orthodox"))})
	crew = FightCast.crew(stage, bool(m.get("pro", false)) or total > 3)
	_build_hud()


func _build_hud() -> void:
	var bug := PanelContainer.new()
	bug.add_theme_stylebox_override("panel", UI.box(Color(0.06, 0.05, 0.05, 0.86), UI.LINE, 6, 1, 14, 10))
	bug.position = Vector2(28, 24)
	add_child(bug)
	_bug_box = bug
	var bv := UI.vbox(2)
	bug.add_child(bv)
	_bug = UI.label("", UI.BODY, UI.FG, "bold")
	bv.add_child(_bug)
	_clock = UI.mono("", UI.SMALL, UI.MUTED)
	bv.add_child(_clock)
	_buttons = UI.hbox(8)
	_buttons.alignment = BoxContainer.ALIGNMENT_END
	add_child(_buttons)
	_pin(_buttons, Vector4(1, 0, 1, 0), Vector4(-640, 24, -28, 68))
	_cap_box = PanelContainer.new()
	_cap_box.add_theme_stylebox_override("panel", UI.box(Color(0.04, 0.03, 0.03, 0.78), Color(0, 0, 0, 0), 6, 0, 22, 10))
	_cap_box.visible = false
	add_child(_cap_box)
	_pin(_cap_box, Vector4(0.5, 1, 0.5, 1), Vector4(-620, -78, 620, -22))
	_caption = UI.label("", 26, UI.FG, "body", true)
	_caption.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_caption.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_cap_box.add_child(_caption)
	_banner = UI.display("", 64)
	_banner.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_banner.add_theme_constant_override("outline_size", 10)
	_banner.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.9))
	add_child(_banner)
	_pin(_banner, Vector4(0.5, 0, 0.5, 0), Vector4(-640, 150, 640, 250))
	_draw_buttons()


## Anchors (left, top, right, bottom) and offsets in pixels from them.
func _pin(c: Control, anchors: Vector4, offsets: Vector4) -> void:
	c.anchor_left = anchors.x
	c.anchor_top = anchors.y
	c.anchor_right = anchors.z
	c.anchor_bottom = anchors.w
	c.offset_left = offsets.x
	c.offset_top = offsets.y
	c.offset_right = offsets.z
	c.offset_bottom = offsets.w


func _draw_buttons() -> void:
	UI.clear(_buttons)
	var mode := UI.button("Highlights" if highlights else "Full round", "BtnQuiet", _toggle_mode)
	mode.tooltip_text = "Highlights: only the punches that land. Full: every exchange, 40 seconds a round."
	_buttons.add_child(mode)
	var speed := UI.button("2x" if fast else "1x", "BtnQuiet", _toggle_speed)
	speed.tooltip_text = "Speed (Space)"
	_buttons.add_child(speed)
	var skip := UI.button("Skip round", "Btn", skip_round)
	skip.name = "SkipRound"
	_buttons.add_child(skip)
	var bout := UI.button("Skip bout", "Btn", skip_bout)
	bout.name = "SkipBout"
	_buttons.add_child(bout)
	_buttons.visible = playing


func _toggle_mode() -> void:
	highlights = not highlights
	_draw_buttons()


func _toggle_speed() -> void:
	fast = not fast
	if playing and _close_left <= 0.0:
		Engine.time_scale = pace()
	_draw_buttons()


func _unhandled_key_input(event: InputEvent) -> void:
	if playing and event is InputEventKey and event.pressed and (event as InputEventKey).keycode == KEY_SPACE:
		_toggle_speed()
		get_viewport().set_input_as_handled()


## S302: 2x runs the whole ring at double speed (Engine.time_scale), so moves, timers and hits stay together (it ran only
## the beat clock before: at 2x the hit reaction played before the glove arrived).
static func pace() -> float:
	return 2.0 if fast else 1.0


## Builds the round's beats from the round the words settled, and starts it.
func play_round(m: Dictionary, n: int) -> void:
	var c: Career = main.career
	var f: Dictionary = c.fighter_by_id(fid)
	var opp: Dictionary = f["bout"]["opp"]
	var r: Dictionary = (m["rounds"] as Array)[n - 1]
	round_n = n
	var profiles := {"a": RoundStyle.of_fighter(f), "b": RoundStyle.from_opponent(opp)}
	# S302: each starts the round on the energy the sim left her (Bouts._energy): tired = shorter runs, tired beats.
	var en: Dictionary = r.get("energy", {})
	for side in ["a", "b"]:
		profiles[side]["energy"] = float(en.get(side, Combos.TANK))
		profiles[side]["energy_end"] = float(en.get(side + "_end", profiles[side]["energy"]))
	_profiles = profiles
	plan = RoundScript.build(r, str(f.get("style", "")), str(opp.get("style", "")), RoundScript.SECONDS, c.day * 97 + n, profiles)
	_play_habits(m, n, f, opp)
	# S303 Kalli K-COMBOWORDS1: a SIGNATURE combination landing whole, or one she is too tired to finish, gets its line.
	ComboWords.caption(plan["beats"], {"a": f.get("combos", {}), "b": profiles["b"].get("combos", {})}, _names, c.day + n * 17)
	# S303 corner card: read off the beats this round plays, so the corner screen agrees with what was watched.
	r["card"] = CornerCard.summarize(plan["beats"])
	_stop = str(r.get("stopped", ""))
	_stepped = [false, false]
	_tired = [false, false]
	_last_contact = [-9.0, -9.0]
	_last_hand = ["", ""]
	beats = RoundScript.highlights(plan) if highlights else (plan["beats"] as Array).duplicate(true)
	length = float(beats[-1]["t"]) + 2.0 if highlights and not beats.is_empty() else float(plan["seconds"])
	t = 0.0
	next = 0
	_amb_rng.seed = c.day * 131 + n
	_bell_left = -1.0
	_close_left = 0.0
	playing = true
	Engine.time_scale = pace()
	mouse_filter = Control.MOUSE_FILTER_STOP
	_bug_box.visible = true
	_banner.text = "ROUND %d" % n
	_banner.add_theme_color_override("font_color", UI.FG)
	_say("")
	stage.broadcast(true)
	for i in 2:
		stage.guard(i)
	_draw_buttons()
	_hud()


## Fight model step 5 (S301): both boxers' habits show in the round (HabitBeats rewrites the beats; who lands how many is
## unchanged). Ours are her profile's two; the opponent's come from the scout's words. Kalli's ring line for a habit
## (fight_habits.json ring_lines "<id> fires") captions its first fire.
func _play_habits(m: Dictionary, n: int, f: Dictionary, opp: Dictionary) -> void:
	var rounds: Array = m["rounds"]
	var won_last := n >= 2 and bool((rounds[n - 2] as Dictionary).get("won", false))
	var rng := RandomNumberGenerator.new()
	rng.seed = main.career.day * 53 + n
	var fires := HabitBeats.apply(plan, {"a": f.get("habits", []), "b": RoundStyle.opponent_habits(opp)},
		{"won_last": {"a": won_last, "b": n >= 2 and not won_last}}, rng)
	var lines := {}
	if FileAccess.file_exists(HABITS_PATH):
		var data: Variant = JSON.parse_string(FileAccess.get_file_as_string(HABITS_PATH))
		for row in (data as Dictionary).get("ring_lines", []) if data is Dictionary else []:
			var when := str(row.get("when", ""))
			if when.contains(" fires"):
				lines[when.get_slice(" fires", 0)] = str(row.get("line", ""))
	var said := {}
	for fire in fires:
		var id := str(fire["habit"])
		if said.has(id) or not lines.has(id):
			continue
		for b in plan["beats"]:
			if str(b.get("habit", "")) == id and str(b["caption"]) == "":
				b["caption"] = str(lines[id]).replace("{name}", _names[0 if str(fire["who"]) == "a" else 1])
				said[id] = true
				break


## Between rounds and at the result: the ring stays, frozen and dimmed, under the 2D modal.
func freeze() -> void:
	playing = false
	Engine.time_scale = 1.0
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_bug_box.visible = false
	_banner.text = ""
	_say("")
	_draw_buttons()


func _process(delta: float) -> void:
	if not playing:
		return
	var dt := delta
	if _bell_left >= 0.0:
		_bell_left -= dt
		if _bell_left < 0.0:
			_done()
		return
	t += dt
	if t > 1.2 and _banner.text.begins_with("ROUND"):
		_banner.text = ""
	while next < beats.size() and float(beats[next]["t"]) <= t:
		_fire(beats[next])
		next += 1
	if _caption_left > 0.0:
		_caption_left -= dt
		if _caption_left <= 0.0:
			_say("")
	if _close_left > 0.0:
		_close_left -= delta
		if _close_left <= 0.0:
			Engine.time_scale = pace()
			stage.broadcast(true)
	_ambient(dt)
	if t >= length:
		_bell()
	_hud()


func _fire(b: Dictionary) -> void:
	var who := 0 if str(b["who"]) == "a" else 1
	var other := 1 - who
	var move := str(b["move"])
	if str(b["caption"]) != "":
		_say(str(b["caption"]))
	_quiet = 0.0
	match move:
		"step_in":
			stage.step(who, 1, 0.32)
			stage.step(other, -1, 0.32, true)
			_stepped[who] = true
		"step_out":
			stage.step(who, -1, 0.32)
			stage.step(other, 1, 0.32, true)
		"slip", "clinch":
			stage.play(who, "slip")
		"tired":
			stage.play(who, BeatClips.first(BeatClips.TIRED, stage.has_move))
			_tired[who] = true
		"count":
			# The sim's standing count (Knockdowns); a KO stays down and the winner celebrates.
			stage.play(who, BeatClips.first(BeatClips.OUT if _stop == "KO" else BeatClips.DOWN, stage.has_move))
			if _stop != "":
				get_tree().create_timer(1.2).timeout.connect(stage.play.bind(other, BeatClips.first(BeatClips.WIN, stage.has_move)))
		_:
			# Fight model step 4: the beat's punch, its hit reaction and its defence come from BeatClips (Punch Pro first).
			var land := str(b["result"])
			# S301: stepping (_ft) and wide-miss takes back on; the ones tools/take_check.gd measured off stay out (BeatClips.OFF_TAKES).
			var ctx := {"big": bool(b.get("big", false)), "miss": land == "misses" and str(b.get("def", "")) == "",
				"tired": _tired[who], "step": _stepped[who], "roll": _amb_rng.randf()}
			_stepped[who] = false
			var clip := BeatClips.punch(move, ctx, stage.has_move)
			var sp := BeatClips.speed(clip, move)
			var contact := BeatClips.contact(clip, float(Stage.CONTACT.get(move, Stage.CONTACT_S)))
			var hand := str(BeatClips.contact_row(clip).get("hand", ""))
			var same_hand := hand != "" and hand == str(_last_hand[who])
			var gap := -1.0
			if str(b.get("combo_id", "")) != "":
				# Her drilled combo lands at its own rhythm: quicker the better she has it, slower when she is tired.
				var p: Dictionary = _profiles.get(str(b["who"]), {})
				gap = Combos.interval(float((p.get("combos", {}) as Dictionary).get(str(b["combo_id"]), 0.0)), same_hand,
					RoundScript.energy_at(p, float(b["t"]) / maxf(1.0, float(plan["seconds"]))))
			var skip := combo_skip(contact, sp, float(_last_contact[who]), t, same_hand, gap)
			_last_hand[who] = hand
			stage.play(who, clip, sp, skip)
			_last_contact[who] = t + (contact - skip) / sp
			var at := (contact - skip) / sp
			if land == "lands":
				# S302: the glove is carried onto her face past the guard, and the contact holds, snaps and nudges.
				stage.land(who, clip, move == "body_hook" or clip.contains("kidney"))
				var hit := BeatClips.react(move, bool(b.get("knockback", false)), stage.has_move)
				get_tree().create_timer(at).timeout.connect(stage.hit.bind(other, hit, BeatClips.speed(hit, ""), who, move, bool(b.get("big", false))))
				if bool(b.get("big", false)):
					# The round's big shot: cut close as it is thrown and run it at half speed through the contact.
					stage.close_up(other)
					Engine.time_scale = 0.5 * pace()
					_close_left = at + 0.7
			elif str(b.get("def", "")) != "":
				# Her defence (RoundStyle): a block meets the glove at contact; a slip, weave or step back starts early.
				var d := str(b["def"])
				var when := at * (0.8 if d == "block" else 0.35)
				# S305: the side comes from the hand that throws it (her left arrives on the other's right).
				var lead := move in ["jab", "lead_hook", "lead_uppercut"]
				var from_left: bool = stage.hand_of(who, hand if hand != "" else ("LeftHand" if lead else "RightHand")) == "LeftHand"
				if d == "block" and move == "body_hook":
					# S305: a body shot is blocked with the elbow - gloves stay up, the elbow drops onto the ribs (HitSnap.brace).
					var snap: Node = stage.boxers[other].get("snap")
					if snap != null:
						get_tree().create_timer(at).timeout.connect(snap.brace.bind(not from_left))
				else:
					var dclip := BeatClips.defence(d, move, from_left, bool(stage.boxers[other].get("south", false)), stage.has_move)
					get_tree().create_timer(when).timeout.connect(stage.play.bind(other, dclip, BeatClips.speed(dclip, "")))
			elif land == "misses" and not b.has("def"):
				get_tree().create_timer(at * 0.35).timeout.connect(stage.play.bind(other, "slip" if randf() < 0.6 else "pull"))


## Seconds into a punch clip to start it: 0, or for a follow-up (her last punch lands at view time `last`, now = `now`)
## far enough into the wind-up that it lands COMBO_LAND_S after the last, keeping at least MIN_WIND_S of throw.
static func combo_skip(contact: float, speed: float, last: float, now: float, same_hand: bool = false, gap: float = -1.0) -> float:
	if last < now - 0.30:
		return 0.0
	if gap <= 0.0:
		gap = COMBO_SAME_HAND_S if same_hand else COMBO_LAND_S
	var want := maxf(MIN_WIND_S, last + gap - now)
	return clampf(contact - want * speed, 0.0, maxf(0.0, contact - MIN_WIND_S * speed))


## Between beats the two keep working: a short circle or a feel-out step when the next beat is more than a second away.
func _ambient(dt: float) -> void:
	_quiet += dt
	var gap := 99.0
	if next < beats.size():
		gap = float(beats[next]["t"]) - t
	if _quiet > 1.1 and gap > 1.2:
		_quiet = 0.0
		if _amb_rng.randf() < 0.65:
			stage.circle(-1 if _amb_rng.randf() < 0.5 else 1, _amb_rng.randf_range(0.3, 0.55))


func _say(text: String) -> void:
	_caption.text = text
	_cap_box.visible = text != ""
	_caption_left = 3.2 if text != "" else 0.0


func _bell() -> void:
	var red := str(plan.get("winner", "a")) == "a"
	_banner.text = "BELL. %s'S ROUND" % ("RED" if red else "BLUE") if _stop == "" else "STOPPED. %s WINS" % ("RED" if red else "BLUE")
	_banner.add_theme_color_override("font_color", Color(0.95, 0.35, 0.3) if red else Color(0.45, 0.6, 1.0))
	_say("")
	_bell_left = BELL_S
	Engine.time_scale = pace()
	stage.broadcast(true)


func _hud() -> void:
	_bug.text = "%s  vs  %s" % [_names[0], _names[1]]
	var left := maxf(0.0, REAL_ROUND_S * (1.0 - t / maxf(1.0, length)))
	_clock.text = "ROUND %d OF %d   %d:%02d" % [round_n, total, int(left) / 60, int(left) % 60]


func _done() -> void:
	playing = false
	Engine.time_scale = 1.0
	# S307: between rounds the corner minute plays in the ring (FightCast.corner); its pick starts the next round.
	if FightCast.corner(self):
		return
	main.act("fightwatched", str(round_n))


func hide_hud() -> void:
	_bug_box.visible = false
	_banner.text = ""
	_say("")
	_draw_buttons()


func corner_done(pick: String) -> void:
	Engine.time_scale = 1.0
	main.modal["watched"] = round_n
	main.act("fightstep", "corner:" + pick)


func skip_round() -> void:
	Engine.time_scale = 1.0
	if playing:
		_bell_left = -1.0
		_done()


## Skips the rest of the bout: the corner takes the calls (the same as "Sim to result").
func skip_bout() -> void:
	Engine.time_scale = 1.0
	playing = false
	main.act("fightskip", "")
