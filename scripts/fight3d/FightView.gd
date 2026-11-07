extends Control
## Fight night in 3D. S308 (operator: "rounds should be 3 minutes and callouts from corner every 25-30 seconds"; "Build it,
## full 3:00"): a round runs 3:00 in real time as six 30-second exchanges. LiveRound settles each one; at every 30 seconds
## the ring slows and the shout bar (ShoutBar) shows the clue and the calls, and the pick fights the next exchange
## (ExchangeBeats turns it into beats on the FightStage). Scorebug with the clock and the exchanges, 1x / 2x, SKIP ROUND
## (the rest of the round with no shouts) and SKIP BOUT. Between rounds the corner minute (FightCast.corner).
## Main keeps one FightView on its fight layer while a fight modal is open (FightView.sync).
## Headless (the tests) has no picture: the view is off there and fight night stays in words.

const FightSfx := preload("res://scripts/audio/FightSfx.gd")
const Stage := preload("res://scripts/fight3d/FightStage.gd")
const RoundScript := preload("res://scripts/rules/RoundScript.gd")
const RoundStyle := preload("res://scripts/rules/RoundStyle.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const ExchangeBeats := preload("res://scripts/fight3d/ExchangeBeats.gd")
const ShoutBar := preload("res://scripts/fight3d/ShoutBar.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const Combos := preload("res://scripts/rules/Combos.gd")
const CornerCard := preload("res://scripts/rules/CornerCard.gd")
const UI := preload("res://scripts/ui/TV.gd")  # S333: fight graphics keep the dark TV look
const FightCast := preload("res://scripts/fight3d/FightCast.gd")
const FightHud := preload("res://scripts/fight3d/FightHud.gd")
const RangeBreath := preload("res://scripts/fight3d/RangeBreath.gd")
const BeatFire := preload("res://scripts/fight3d/BeatFire.gd")
const KnockdownReplay := preload("res://scripts/fight3d/KnockdownReplay.gd")
const KnockdownCount := preload("res://scripts/fight3d/KnockdownCount.gd")

## The player's choice lasts the session.
static var fast := false
## The ring's pace under the shout bar.
const SHOUT_PACE := 0.3

const CLOSE_UP_S := 1.5
const BELL_S := 2.6
const BELL_EASE_S := 0.5

var main: Node
var stage: Node3D
var _vp: SubViewport
var crew: Node3D
var fid := ""
var plan: Dictionary = {}
var beats: Array = []
var round_n := 0
var _stop := ""   # "KO" / "RSC" when this round ends the bout
var _beat := BeatFire.new()   # S319: the beat switch (BeatFire.gd) and its per-round state
var _profiles: Dictionary = {}
var _ctx: Dictionary = {}
var _ex_done := 0      # exchanges queued into beats this round
var _shouting: Node = null
var _round_beats: Array = []
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
var bodies := ["", ""]   # S320 each boxer's glb (BodyLive / the corner card draw her own body)
var body: Node   # S318 BodyLive: the bout's body map + the scorebug figures (FightHud.build)
var burn: Node   # S322 BodyBurn: per-part Burn, shown as guard height, steps, punch snap
var bars: Node   # S345 HudBars: six bars a boxer + the round edge (FightHud.build)
var replay: Node   # S376 KnockdownReplay: the slow-motion replay of a knockdown shot
var kd: Node   # S377 KnockdownCount: the neutral corner, the count, the rise or the stoppage


## Called on every modal draw. True while a round is playing (the modal stays hidden then).
static func sync(m_main: Node, layer: Control) -> bool:
	var m: Dictionary = m_main.modal
	var view: Node = layer.get_child(0) if layer.get_child_count() > 0 else null
	var fight := not m.is_empty() and str(m.get("type", "")) == "fight" and enabled()
	var tape := fight and str(m.get("step", "")) == "tape"
	if view != null and (not fight or str(view.fid) != str(m["fid"])):
		view.queue_free()
		layer.remove_child(view)
		view = null
	if not fight:
		return false
	if view == null:
		view = new()
		view.theme = UI.theme()   # S333: the dark TV theme under the fight; the menus around it are the whiteboard
		view.fid = str(m["fid"])
		view.visible = false
		layer.add_child(view)
		# S312 (Ziva: Begin fight froze 3.4-5.5 s; measured 2.4 s build + a 1.0 s first frame): the ring builds hidden while
		# the tale of the tape is read, a moment after the card has drawn.
		if tape:
			m_main.get_tree().create_timer(0.3).timeout.connect(view.prebuild.bind(m_main, m))
	if tape:
		return false
	if view.stage == null:
		view.setup(m_main, m)
	view.reveal()
	if str(m["step"]) == "round" and int(m.get("watched", 0)) < int(m["round"]):
		if int(view.round_n) != int(m["round"]):
			view.play_round(m, int(m["round"]))
		return true
	view.freeze()
	return false


## S312: built hidden behind the tale of the tape and drawn once there, so Begin neither builds nor compiles shaders.
func prebuild(m_main: Node, m: Dictionary) -> void:
	if stage == null and is_inside_tree():
		setup(m_main, m)
		_vp.render_target_update_mode = SubViewport.UPDATE_ONCE


## S390: the crowd leaves with the ring, or its bed runs on under the menus.
func _exit_tree() -> void:
	FightSfx.crowd_off()


func reveal() -> void:
	if not visible:
		visible = true
		_vp.render_target_update_mode = SubViewport.UPDATE_ALWAYS   # what SubViewportContainer sets when shown


## The 3D view plays wherever there is a picture to draw; `no3d` on the command line turns it off. S334: `show3d` plays it
## headless too - the cloud probes (.github/workflows/fight-stills.yml) read bones, not pixels, and a software GPU ran the
## windowed fight at 1 frame a second.
static func enabled() -> bool:
	var args := OS.get_cmdline_user_args()
	return (DisplayServer.get_name() != "headless" or args.has("show3d")) and not args.has("no3d")


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
	_vp = SubViewport.new()
	_vp.own_world_3d = true
	_vp.msaa_3d = Viewport.MSAA_4X
	holder.add_child(_vp)
	stage = Stage.new()
	_vp.add_child(stage)
	var picks := FightCast.bodies_for(f, opp)
	bodies = picks.duplicate()
	var sc := FightCast.body_scales(f, opp)
	stage.setup({"glb": picks[0], "corner": "red", "scale": sc[0], "stance": str(f.get("stance", "orthodox"))},
		{"glb": picks[1], "corner": "blue", "scale": sc[1], "stance": str(opp.get("stance", "orthodox"))})
	crew = FightCast.crew(stage, bool(m.get("pro", false)) or total > 3)
	# S376 KNOCKDOWN1: every knockdown's shot replays in slow motion once the fall has played (KnockdownReplay).
	replay = KnockdownReplay.new()
	replay.name = "KnockdownReplay"
	add_child(replay)
	replay.setup(self)
	_build_hud()
	if kd != null:
		kd.queue_free()
	kd = KnockdownCount.attach(self)


func _build_hud() -> void:
	FightHud.build(self)
	_draw_buttons()


func _draw_buttons() -> void:
	FightHud.draw_buttons(self)


func _toggle_speed() -> void:
	fast = not fast
	if playing and _close_left <= 0.0 and _shouting == null:
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


## Starts round n: its first exchange is already fought on the corner's plan (Bouts opens a round that way).
func play_round(m: Dictionary, n: int) -> void:
	var c: Career = main.career
	var f: Dictionary = c.fighter_by_id(fid)
	var opp: Dictionary = f["bout"]["opp"]
	round_n = n
	if n == 1:
		FightSfx.setup_room(f["bout"])   # S396 the hall or the arena, by attendance, before the walk-in
	if kd != null:
		kd.stop()
	var profiles := {"a": RoundStyle.of_fighter(f), "b": RoundStyle.from_opponent(opp)}
	_profiles = profiles
	var rounds: Array = m["rounds"]
	_ctx = {"n": n, "plan": str(LiveRound.live(m).get("plan", "")), "a_style": str(f.get("style", "")),
		"b_style": str(opp.get("style", "")), "seed": c.day * 97 + n, "profiles": profiles, "f": f, "opp": opp,
		"names": _names, "day": c.day,
		"won_last": n >= 2 and rounds.size() >= n - 1 and bool((rounds[n - 2] as Dictionary).get("won", false))}
	_stop = ""
	_beat.reset()
	beats = []
	_round_beats = []
	_ex_done = 0
	length = Exchanges.EXCHANGES * Exchanges.EX_SECONDS
	plan = {"seconds": length}
	_queue(m, 0)
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
	bars.fresh_round()
	if n > 1:
		FightHud.fade_in(self)
	# S307: before round 1 the intro plays (FightCast.intro); it hands the ring back at the bell.
	playing = not (n == 1 and FightCast.intro(self))
	if playing:
		FightSfx.bell(true)


## Exchange k's beats into the round. Its energy runs from where the round has her at its start to its end.
func _queue(m: Dictionary, k: int) -> void:
	var lv := LiveRound.live(m)
	var closed := lv.is_empty()
	var r: Dictionary = (m["rounds"] as Array)[round_n - 1] if closed else {}
	var exs: Array = r.get("exchanges", []) if closed else lv["ex"]
	if k >= exs.size():
		return
	var e: Dictionary = r.get("energy", {}) if closed else lv["e"]
	for side in ["a", "b"]:
		var e0 := float(e.get(side, Combos.TANK))
		var e1 := float(e.get(side + "_end", e0))
		_profiles[side]["energy"] = lerpf(e0, e1, float(k) / Exchanges.EXCHANGES)
		_profiles[side]["energy_end"] = lerpf(e0, e1, float(k + 1) / Exchanges.EXCHANGES)
	var bs := ExchangeBeats.build(exs[k], k, r, _ctx)
	if burn != null:
		burn.exchange(bs, str((exs[k] as Dictionary).get("sit", "")), (exs[k] as Dictionary).get("after", {}), str((exs[k] as Dictionary).get("pace", "steady")))
	beats.append_array(bs)
	_round_beats.append_array(bs)
	if closed:
		_stop = str(r.get("stopped", ""))
	_ex_done = k + 1


## Every 30 seconds: the ring slows and the shout bar waits for the call.
func _open_shout() -> void:
	var filming := OS.has_feature("movie")
	for a in OS.get_cmdline_user_args():
		filming = filming or str(a).begins_with("film=")
	if filming:
		_shouted("|pace=steady|aim=")
		return
	var f: Dictionary = main.career.fighter_by_id(fid)
	var bar := ShoutBar.new()
	add_child(bar)
	bar.setup(LiveRound.preview(f, main.modal), round_n)
	bar.picked.connect(_shouted)
	_shouting = bar
	_say("")
	Engine.time_scale = SHOUT_PACE * pace()


func _shouted(call: String) -> void:
	if _shouting != null:
		_shouting.queue_free()
		_shouting = null
	var c: Career = main.career
	Bouts.fight_step(c, c.fighter_by_id(fid), main.modal, "shout:" + call)
	_queue(main.modal, _ex_done)
	Engine.time_scale = pace()


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
		if _bell_left < FightHud.FADE_S and _bell_left + dt >= FightHud.FADE_S:
			FightHud.fade_out(self)
		if _bell_left < 0.0:
			_done()
		return
	if _shouting != null:
		_ambient(dt)
		return
	if _ex_done < Exchanges.EXCHANGES and t >= _ex_done * Exchanges.EX_SECONDS and not LiveRound.live(main.modal).is_empty():
		_open_shout()
		return
	var counting: bool = kd != null and kd.holding()   # S377: the round clock holds through a knockdown's count
	if not counting:
		t += dt
	if t > 2.0 and _banner.text.begins_with("ROUND"):
		_banner.text = ""
	while next < beats.size() and float(beats[next]["t"]) <= t:
		_fire(beats[next])
		next += 1
	if not counting:
		stage.aim(RangeBreath.phase(beats, next, t))
	if _caption_left > 0.0:
		_caption_left -= dt
		if _caption_left <= 0.0:
			_say("")
	if _close_left > 0.0:
		_close_left -= delta
		if _close_left <= 0.0:
			Engine.time_scale = pace()
			stage.broadcast(true)
	if not counting:
		_ambient(dt)
	if t >= length:
		_bell()
	_hud()


func _fire(b: Dictionary) -> void:
	if str(b["caption"]) != "":
		_say(str(b["caption"]))
	_quiet = 0.0
	_beat.fire(self, b)


## Between beats the two keep working: a short circle or a feel-out step when the next beat is more than a second away.
func _ambient(dt: float) -> void:
	_quiet += dt
	var gap := 99.0
	if next < beats.size():
		gap = float(beats[next]["t"]) - t
	if _quiet > 1.1 and gap > 1.2 and not stage.feet.phase() in ["clinch", "inside", "pivot"] and not _floored():
		_quiet = 0.0
		if _amb_rng.randf() < 0.65:
			stage.circle(-1 if _amb_rng.randf() < 0.5 else 1, _amb_rng.randf_range(0.3, 0.55))


## S376 KNOCKDOWN1: a boxer on the canvas (a knockdown / knockout clip) - the between-beats circling waits for the count.
func _floored() -> bool:
	for bx in stage.boxers:
		var clip := str((bx["ap"] as AnimationPlayer).current_animation)
		if clip.contains("knockout") or clip.contains("countdown"):
			return true
	return false


func _say(text: String) -> void:
	_caption.text = text
	_cap_box.visible = text != ""
	_caption_left = 3.2 if text != "" else 0.0


func _bell() -> void:
	var r: Dictionary = (main.modal["rounds"] as Array)[round_n - 1]
	# S303 corner card: read off the beats this round played, so the corner screen agrees with what was watched.
	r["card"] = CornerCard.summarize(_round_beats)
	bars.held = true
	_buttons.visible = false   # S395 nothing left to skip in the seconds after the bell
	body.bell()
	if burn != null:
		burn.bell()
	_stop = str(r.get("stopped", ""))
	var red := bool(r.get("won", true))
	var who := str((_ctx["f"] if red else _ctx["opp"])["first"]).to_upper()   # S395 names, as the corner card has them
	_banner.text = "BELL. %s'S ROUND" % who if _stop == "" else "STOPPED. %s WINS" % who
	_banner.add_theme_color_override("font_color", Color(0.95, 0.35, 0.3) if red else Color(0.45, 0.6, 1.0))
	_say("")
	_bell_left = BELL_S
	FightSfx.bell(false)
	if _stop == "":   # S396 (blind review: both stood frozen in guard 2.6 s after the bell): the hands come down, as at a real bell
		get_tree().create_timer(BELL_EASE_S).timeout.connect(func():
			if _bell_left >= 0.0:
				for i in 2:
					stage.act(i, "af_idle"))
	Engine.time_scale = pace()
	stage.broadcast(true)


func _hud() -> void:
	_bug.text = FightHud.round_line(round_n, total, (main.modal.get("rounds", []) as Array).slice(0, round_n - 1), _names)
	var left := ceilf(maxf(0.0, length - t))   # S395 reads 0:00 at the bell, not a second before it
	_clock.text = "%d:%02d" % [int(left) / 60, int(left) % 60]
	FightHud.paint(self, FightHud.shown(_exchanges(), t, FightHud.round_start(self)), FightHud.scored(_exchanges(), t))


## This round's exchanges fought so far (live, or the closed round's).
func _exchanges() -> Array:
	if main == null or round_n < 1:
		return []
	var lv := LiveRound.live(main.modal)
	if not lv.is_empty():
		return lv["ex"]
	var rounds: Array = main.modal.get("rounds", [])
	return (rounds[round_n - 1] as Dictionary).get("exchanges", []) if rounds.size() >= round_n else []


func _done() -> void:
	playing = false
	Engine.time_scale = 1.0
	# S307: between rounds the corner minute plays in the ring (FightCast.corner); its pick starts the next round.
	_bug_box.visible = false   # S394 the corner's letterbox cut the round box and rings in half; the next round brings them back
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
	if kd != null:
		kd.stop()
	if playing:
		_close_shout()
		var c: Career = main.career
		Bouts.fight_step(c, c.fighter_by_id(fid), main.modal, "round_out")
		body.catch_up()   # S318: the skipped exchanges' beats still mark the body (and the corner card reads them)
		var r: Dictionary = (main.modal["rounds"] as Array)[round_n - 1]
		r["card"] = CornerCard.summarize(_round_beats)
		# S322: a skipped round still ends at a bell - the corner's one-round fixes run out, the minute's rest refills.
		body.bell()
		if burn != null:
			burn.bell()
		_stop = str(r.get("stopped", ""))
		_bell_left = -1.0
		_done()


func _close_shout() -> void:
	if _shouting != null:
		_shouting.queue_free()
		_shouting = null


## Skips the rest of the bout: the corner takes the calls (the same as "Sim to result").
func skip_bout() -> void:
	Engine.time_scale = 1.0
	if kd != null:
		kd.stop()
	playing = false
	_close_shout()
	main.act("fightskip", "")
