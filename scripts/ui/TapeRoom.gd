extends Control
## S343 THE TAPE ROOM (operator Q-S294-68: "the player watches the films and it unflods like in grappleflows , player has
## appropriate counters for each clip to make his plan . put grappleflows in the game as core mechanic"). Her camp's film
## study: 3-4 films of her past bouts (TapeClips) on our own ring (TapeFilm), and beside the film HER FLOW builds as it
## plays - GrappleFlows' layout (S342 takeaway): a node = a still cut from the film at that moment, a short title, one
## line; the arrow into it a short label; the tell's node marked. At the end of a film its tell opens in her file
## (OppFile) and YOUR ANSWER offers three moves from the place that situation puts the fight; the pick is a WHEN arrow in
## her plan (f["arrows"], PlanFight in the bout): "if she presses: Step back". Over the whole game until Close.
## S343 SPOT (operator: "wanna try also your idea ?"): a tell her file does not hold yet is a "?" node; SPOT while she does
## it and name it from three (TapeClips.spot_choices) - a right call opens it in her file now and the tape suggests the
## answer; a wrong or late call costs only that viewing (Replay), tape study still finds it. A top rival's moment is shorter.
## Headless (the tests) there is no film: the clock still runs and the flow still builds, without stills.
##   var r := TapeRoom.new(); r.for_fighter(main, f); main.add_child(r)

const UI := preload("res://scripts/ui/UI.gd")
const Icons := preload("res://scripts/ui/Icons.gd")
const TapeClips := preload("res://scripts/rules/TapeClips.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")
const PlanBoard := preload("res://scripts/rules/PlanBoard.gd")
const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")
const FightFlow := preload("res://scripts/rules/FightFlow.gd")
const TapeFilm := preload("res://scripts/fight3d/TapeFilm.gd")
const FightView := preload("res://scripts/fight3d/FightView.gd")
const FLOW_W := 600
const THUMB := Vector2(176, 99)
const SLOW := 0.5
## What a node's title says the clip is about, for the tab.
const TAB_WORDS := {"style": "Her game", "weapon": "Her weapon", "habit": "A habit", "weakness": "Her weakness"}

var main: Node = null
var f: Dictionary = {}
var opp: Dictionary = {}
var past: Array = []        # her past bouts (RivalPast), newest first
var clips: Array = []
var idx := 0
var t := 0.0
var playing := false
var slow := false
var shown := 0              # nodes of this film on her flow so far
var watched := {}           # film index -> true once played to its end
var film: Control = null    # TapeFilm (null headless)
var spot_used := false      # this viewing's one SPOT call is spent
var spotting := false       # the film is paused on the three choices
var spot_t := 0.0
var _tell_card: PanelContainer = null
var _spot_btn: Button
var _tabs: HBoxContainer
var _title: Label
var _sub: Label
var _clock: Label
var _flow: VBoxContainer
var _answer: VBoxContainer
var _slow_btn: Button


## Opens on one fighter's camp (call before adding it to the tree). m = Main.
func for_fighter(m: Node, fighter: Dictionary) -> void:
	main = m
	f = fighter
	opp = (f.get("bout", {}) as Dictionary).get("opp", {})
	# Her bouts are kept on the career's record of her (RivalPast); the booked copy may not carry them.
	if (opp.get("bouts", []) as Array).is_empty() and m != null and m.get("career") != null:
		past = ((m.career as Career).rival(str(opp.get("name", ""))) as Dictionary).get("bouts", [])
	clips = TapeClips.clips(opp, past)


func _ready() -> void:
	name = "TapeRoom"
	theme = UI.theme()
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	var bg := ColorRect.new()
	bg.color = UI.BG
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(bg)
	var rows := UI.vbox(0)
	rows.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(rows)
	rows.add_child(_top_bar())
	var body := UI.hbox(18)
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	var pad := MarginContainer.new()
	pad.size_flags_vertical = Control.SIZE_EXPAND_FILL
	for side in ["left", "right", "top", "bottom"]:
		pad.add_theme_constant_override("margin_" + side, 18)
	pad.add_child(body)
	rows.add_child(pad)
	body.add_child(_film_column())
	body.add_child(_flow_column())
	play(0)


func _top_bar() -> Control:
	var bar := PanelContainer.new()
	bar.add_theme_stylebox_override("panel", UI.box(UI.PANEL, UI.LINE, 0, 1, 18, 10))
	var h := UI.hbox(8)
	bar.add_child(h)
	h.add_child(Icons.icon("tv", 24, UI.FG, "The tape room"))
	h.add_child(UI.label("THE TAPE ROOM: %s" % str(opp.get("name", "her")).to_upper(), 22, UI.FG, "bold"))
	h.add_child(UI.muted("  her past bouts on film - watch her, read her, answer her  "))
	h.add_child(UI.spacer())
	_tabs = UI.hbox(6)
	h.add_child(_tabs)
	var close := UI.button("Close", "BtnSolid", close_room)
	close.name = "CloseTape"
	h.add_child(close)
	return bar


func _film_column() -> Control:
	var v := UI.vbox(10)
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var screen := AspectRatioContainer.new()
	screen.ratio = 16.0 / 9.0
	screen.size_flags_vertical = Control.SIZE_EXPAND_FILL
	var frame := PanelContainer.new()
	frame.add_theme_stylebox_override("panel", UI.box(Color(0.06, 0.07, 0.09), UI.FRAME, 6, 3, 0, 0))
	screen.add_child(frame)
	if FightView.enabled():
		film = TapeFilm.new()
		film.setup(opp, _vs_name())
		frame.add_child(film)
	else:
		var words := UI.label("FILM (no picture in a headless run)", UI.BODY, UI.MUTED, "bold")
		words.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		words.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		frame.add_child(words)
	# The TAPE tag and the clock over the film's top-left (a plain Control: the panel would stretch the row over the film).
	var over := Control.new()
	over.mouse_filter = Control.MOUSE_FILTER_IGNORE
	frame.add_child(over)
	var tag := UI.hbox(6)
	tag.position = Vector2(14, 12)
	tag.add_child(UI.chip("TAPE", "red"))
	_clock = UI.label("", UI.SMALL, Color(1, 1, 1, 0.9), "bold")
	tag.add_child(_clock)
	over.add_child(tag)
	v.add_child(screen)
	var info := UI.hbox(10)
	var words_box := UI.vbox(2)
	words_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_title = UI.label("", UI.BODY + 3, UI.FG, "bold")
	_sub = UI.muted("", UI.SMALL)
	words_box.add_child(_title)
	words_box.add_child(_sub)
	info.add_child(words_box)
	_spot_btn = UI.button("SPOT", "BtnSolid", spot)
	_spot_btn.name = "Spot"
	_spot_btn.custom_minimum_size.x = 120
	info.add_child(_spot_btn)
	var replay := UI.button("Replay", "Btn", func(): play(idx))
	replay.name = "Replay"
	info.add_child(replay)
	_slow_btn = UI.button("Slow motion", "Btn", _toggle_slow)
	info.add_child(_slow_btn)
	v.add_child(info)
	var card := PanelContainer.new()
	card.theme_type_variation = "Card"
	_answer = UI.vbox(8)
	card.add_child(_answer)
	v.add_child(card)
	return v


func _flow_column() -> Control:
	var p := PanelContainer.new()
	p.add_theme_stylebox_override("panel", UI.box(UI.PANEL, UI.LINE, 10, 1, 16, 14))
	p.custom_minimum_size.x = FLOW_W
	var v := UI.vbox(8)
	p.add_child(v)
	var head := UI.hbox(8)
	head.add_child(UI.caps("HER FLOW"))
	head.add_child(UI.muted("builds as you watch", UI.TINY))
	v.add_child(head)
	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	v.add_child(scroll)
	_flow = UI.vbox(0)
	_flow.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(_flow)
	return p


## The woman she fought in this film's bout (her record, RivalPast), else a club-show sparring partner.
func _vs_name() -> String:
	var bouts: Array = opp.get("bouts", past)
	return str(bouts[0]["vs"]) if not bouts.is_empty() else "Jess Hardy"


## Starts film i from its first frame: her flow empty again, the answer waiting for the end.
func play(i: int) -> void:
	if clips.is_empty():
		_title.text = "No film on her yet."
		return
	idx = clampi(i, 0, clips.size() - 1)
	var c: Dictionary = clips[idx]
	t = 0.0
	shown = 0
	playing = true
	spot_used = false
	spotting = false
	_tell_card = null
	Engine.time_scale = SLOW if slow else 1.0
	UI.clear(_flow)
	_title.text = str(c["title"])
	_sub.text = "%s  -  film %d of %d" % [c["sub"], idx + 1, clips.size()]
	if film != null:
		film.load_clip(c)
	_draw_tabs()
	_draw_answer()


func _process(delta: float) -> void:
	if not playing:
		return
	advance(delta)


## The tape's clock: beats fire on the film, nodes join her flow as the film passes them, the end opens her tell.
func advance(dt: float) -> void:
	var c: Dictionary = clips[idx]
	t = minf(t + dt, float(c["seconds"]))
	if film != null:
		film.tick(t)
	var nodes: Array = c["nodes"]
	while shown < nodes.size() and float(nodes[shown]["t"]) + TapeClips.STILL_AFTER_S <= t:
		_add_node(nodes[shown], shown)
		shown += 1
	_clock.text = "%d:%02d / %d:%02d" % [int(t) / 60, int(t) % 60, int(c["seconds"]) / 60, int(c["seconds"]) % 60]
	if t >= float(c["seconds"]):
		_ended()
	_spot_state()


## SPOT: the film pauses on three things she might have done.
func spot() -> void:
	if not playing or spot_used or TapeClips.known(opp, clips[idx]):
		return
	spotting = true
	playing = false
	spot_t = t
	Engine.time_scale = 0.0
	UI.clear(_answer)
	var head := UI.hbox(8)
	head.add_child(UI.caps("WHAT DID SHE DO?"))
	head.add_child(UI.muted("at %d:%02d" % [int(t) / 60, int(t) % 60], UI.SMALL))
	_answer.add_child(head)
	var row := UI.hbox(10)
	var i := 0
	for words in TapeClips.spot_choices(clips[idx]):
		var b := UI.button(str(words), "Choice", spot_pick.bind(str(words)))
		b.custom_minimum_size.y = 56
		b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		b.name = "SpotPick%d" % i
		row.add_child(b)
		i += 1
	_answer.add_child(row)
	_answer.add_child(UI.button("Back to the film", "BtnQuiet", spot_pick.bind("")))
	_spot_state()


## The call: right inside the moment opens the tell now; anything else costs this viewing only. "" = back to the film.
func spot_pick(words: String) -> void:
	var c: Dictionary = clips[idx]
	spotting = false
	playing = t < float(c["seconds"])
	Engine.time_scale = SLOW if slow else 1.0
	if words != "":
		spot_used = true
		if TapeClips.spot_ok(c, opp, spot_t, words):
			var opened := TapeClips.watched(opp, c)
			var fb: Dictionary = f.get("bout", {})
			if not fb.is_empty():
				fb["film"] = OppFile.film_depth(opp)
			_toast("Spotted: %s. In her file now%s." % [words.to_lower(), "" if opened.size() < 2 else " (and %d more)" % (opened.size() - 1)])
			if _tell_card != null:
				_fill_node(_tell_card, (c["nodes"] as Array)[int(c["tell_node"])])
		else:
			_toast("Not that - Replay to look again. Tape study in her camp still finds it.")
	if playing:
		_draw_answer()
	else:
		_ended()
	_spot_state()


func _spot_state() -> void:
	if _spot_btn == null or clips.is_empty():
		return
	var known := TapeClips.known(opp, clips[idx])
	_spot_btn.disabled = known or spot_used or not playing
	_spot_btn.tooltip_text = "Her file holds this already" if known else ("One call a viewing: Replay to look again" if spot_used
		else "Press when she shows it")


## Runs the film to its end at once (tests; a player uses Replay and watches).
func finish() -> void:
	while playing:
		advance(0.25)


func _ended() -> void:
	playing = false
	if spotting:
		return
	watched[idx] = true
	_draw_tabs()
	_draw_answer()


func _toast(text: String) -> void:
	if main != null:
		main.toast(text)


## One node on her flow: the arrow into it with its label, then the still, the title and the line. The tell is blue-edged;
## a tell her file does not hold yet is a "?" until SPOT names it.
func _add_node(n: Dictionary, i: int) -> void:
	if i > 0:
		_flow.add_child(_edge(str(n["edge"])))
	var card := PanelContainer.new()
	card.name = "Node%d" % i
	var h := UI.hbox(12)
	h.name = "Row"
	card.add_child(h)
	var still: Texture2D = film.still() if film != null else null
	if still != null:
		var pic := TextureRect.new()
		pic.custom_minimum_size = THUMB
		pic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		pic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		pic.texture = still
		h.add_child(pic)
	else:
		var blank := ColorRect.new()
		blank.color = Color(0.06, 0.07, 0.09)
		blank.custom_minimum_size = THUMB
		h.add_child(blank)
	var words := UI.vbox(2)
	words.name = "Words"
	words.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	h.add_child(words)
	if bool(n["tell"]):
		_tell_card = card
	_fill_node(card, n)
	card.modulate.a = 0.0
	_flow.add_child(card)
	card.create_tween().tween_property(card, "modulate:a", 1.0, 0.35)


## A node's words and edge: the title, the line and the moment; the tell blue-edged, or a "?" while it is hidden.
func _fill_node(card: PanelContainer, n: Dictionary) -> void:
	var tell := bool(n["tell"])
	var hidden := tell and not TapeClips.known(opp, clips[idx])
	card.add_theme_stylebox_override("panel", UI.box(UI.PANEL, UI.GOLD if tell else UI.LINE, 10, 3 if tell else 1, 10, 8))
	var words: VBoxContainer = card.get_node("Row/Words")
	UI.clear(words)
	var top := UI.hbox(6)
	top.add_child(UI.label("?" if hidden else str(n["title"]), UI.BODY, UI.GOLD if hidden else UI.FG, "bold"))
	if tell and not hidden:
		top.add_child(UI.chip("THE TELL", "gold"))
	words.add_child(top)
	words.add_child(UI.muted("Something she does here - SPOT it" if hidden else str(n["line"]), UI.SMALL, true))
	var who := "the other woman" if str(n["who"]) == "a" else str(opp.get("first", "she"))
	words.add_child(UI.label("%d:%02d  %s" % [int(n["t"]) / 60, int(n["t"]) % 60, who], UI.TINY, UI.MUTED, "mono"))


## The arrow between two nodes: a short line down with its label as a pill (GrappleFlows' edge).
func _edge(text: String) -> Control:
	var h := UI.hbox(8)
	h.custom_minimum_size.y = 40
	var line := Control.new()
	line.custom_minimum_size = Vector2(THUMB.x * 0.5 + 10, 40)
	line.draw.connect(func():
		var x := THUMB.x * 0.5 + 10
		line.draw_line(Vector2(x, 2), Vector2(x, 34), UI.GOLD, 3.0, true)
		line.draw_colored_polygon(PackedVector2Array([Vector2(x, 40), Vector2(x - 7, 30), Vector2(x + 7, 30)]), UI.GOLD))
	h.add_child(line)
	if text != "":
		var pill := PanelContainer.new()
		pill.add_theme_stylebox_override("panel", UI.box(UI.PANEL, UI.GOLD, 12, 2, 10, 2))
		pill.add_child(UI.label(text, UI.TINY, UI.FG, "bold"))
		pill.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		h.add_child(pill)
	return h


func _draw_tabs() -> void:
	UI.clear(_tabs)
	for i in clips.size():
		var c: Dictionary = clips[i]
		var done := TapeClips.answer(_plan(), str(c["when"])) != ""
		var b := UI.button("%d  %s" % [i + 1, TAB_WORDS.get(str(c["kind"]), "Film")], "ChoiceOn" if i == idx else "Choice", play.bind(i))
		b.name = "Film%d" % (i + 1)
		if done:
			b.tooltip_text = "Answered in her plan"
			b.add_theme_color_override("font_color", UI.GREEN)
		_tabs.add_child(b)


## YOUR ANSWER: before the end, what to look for; after it, three moves from the place she takes the fight, the one in
## her plan lit.
func _draw_answer() -> void:
	UI.clear(_answer)
	if clips.is_empty():
		return
	var c: Dictionary = clips[idx]
	var when := str(c["when"])
	var card_name := str(StrikeMap.card(str(PlanFight.GAME_CARD.get(when, "long"))).get("name", ""))
	var head := UI.hbox(8)
	head.add_child(UI.caps("YOUR ANSWER"))
	head.add_child(UI.muted("if %s - at %s" % [FightFlow.WHEN_WORDS.get(when, when), card_name.to_lower()], UI.SMALL))
	_answer.add_child(head)
	var known := TapeClips.known(opp, c)
	if not watched.has(idx):
		_answer.add_child(UI.muted(("Watch to the end, then pick what %s does about it." if known else
			"Press SPOT the moment she shows it. At the end, pick what %s does about it.") % str(f.get("first", "your boxer")), UI.BODY, true))
		return
	var now := TapeClips.answer(_plan(), when)
	var row := UI.hbox(10)
	for k in TapeClips.counters(when, TapeClips.habits_of(opp), f.get("moves", {})):
		var id := str(k["move"])
		var grey := str(k["grey"])
		# A tell her file holds (spotted, found by tape study, or free) lets the tape suggest the answer.
		# One short line under the move: the suggestion, then what it does - or, not drilled yet, what she must learn first.
		var small := ("Suggested by the tape. " if known and str(k["fit"]) == "best" else "") + (str(k["why"]) if grey == "" else grey)
		var b := UI.button2(str(k["name"]), small,
			"ChoiceOn" if id == now else "Choice", _pick.bind(id), Vector2(0, 70), UI.FG, UI.GOLD if small.begins_with("Suggested") else UI.MUTED)
		b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		b.name = counter_name(id)
		row.add_child(b)
	_answer.add_child(row)
	var limit := PlanBoard.arrow_limit(_coach())
	var line := "In %s's plan: if %s - %s.  " % [f.get("first", "her"), FightFlow.WHEN_WORDS.get(when, when), StrikeMap.move(now).get("name", now)] if now != "" \
		else "Not in her plan yet: pick one.  "
	_answer.add_child(UI.muted(line + "%d of %d arrows (her coach can hold %d)." % [_plan().size(), limit, limit], UI.SMALL))


## The pick: a WHEN arrow in her plan, replacing her arrow for that situation; refused (with why) past her coach's limit.
func _pick(move_id: String) -> void:
	var c: Dictionary = clips[idx]
	var when := str(c["when"])
	var plan := TapeClips.pick(_plan(), when, move_id)
	var v := PlanBoard.validate(plan, StrikeMap.MOVES, PlanBoard.arrow_limit(_coach()), FightFlow.WHEN_WORDS)
	if not v["ok"]:
		if main != null:
			main.toast("%s - drop an arrow on her plan board first." % str(v["problems"][0]))
		return
	f["arrows"] = plan
	if main != null:
		main.toast("In %s's plan: if %s - %s." % [f.get("first", "her"), FightFlow.WHEN_WORDS.get(when, when), StrikeMap.move(move_id).get("name", move_id)])
	_draw_tabs()
	_draw_answer()


## A counter button's node name ("3b-3@opp_ropes": '@' is not allowed in a node name).
static func counter_name(move_id: String) -> String:
	return "Counter_" + move_id.replace(" ", "_").replace("@", "_at_")


func _plan() -> Array:
	var saved: Array = f.get("arrows", [])
	return (saved if not saved.is_empty() else PlanFight.starter()).duplicate(true)


func _coach() -> float:
	if main == null or main.get("career") == null:
		return 58.0
	return float((main.career as Career).coach.get("rating", 58.0))


func _toggle_slow() -> void:
	slow = not slow
	Engine.time_scale = SLOW if slow else 1.0
	_slow_btn.text = "Normal speed" if slow else "Slow motion"


func close_room() -> void:
	Engine.time_scale = 1.0
	queue_free()
	if main != null:
		main.render()
