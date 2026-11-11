extends Node
## S369 BJJMATCH1 - a no-gi belt match on the GrappleBrowser's 3D pair (the Miro frame "BJJ belt match - you call the
## next move", operator "ok go-ahead"; the rules are BjjMatch). Ana (red, woman 0) against an open's opponent (blue):
## whoever has the initiative makes a move out of the position on screen; on a heavy settle with calls left the panel
## offers her 2-3 moves with odds and what a miss costs - the player calls one within CALL_WINDOW_S, else her game plan
## (the first offer) goes. Scrambles flow on (SCRAMBLE_S); settles breathe SETTLE_S before the next move.
## Opens with `FightCamp.exe -- jump=grapple match=1` (the sticky: "Playtest one belt match first"); `auto=1` lets her
## plan take every call (the film / probe run) and prints MATCH lines.

const UI := preload("res://scripts/ui/UI.gd")
const Halo := preload("res://scripts/ui/Halo.gd")
const Graph := preload("res://scripts/grapple/GrappleGraph.gd")
const DB := preload("res://scripts/grapple/GrappleMapDB.gd")
const GrappleFinish := preload("res://scripts/grapple/GrappleFinish.gd")
const FinishLens := preload("res://scripts/grapple/FinishLens.gd")
const Curated := preload("res://scripts/grapple/GrappleCurated.gd")
const Player := preload("res://scripts/grapple/GrapplePlayer.gd")
const BjjMatch := preload("res://scripts/rules/BjjMatch.gd")
const NoGi := preload("res://scripts/rules/NoGi.gd")
const Bar := preload("res://scripts/ui/Bar.gd")
const BjjClash := preload("res://scripts/rules/BjjClash.gd")
const MatHud := preload("res://scripts/grapple/MatHud.gd")

const CALL_WINDOW_S := 5.0
const SCRAMBLE_S := 0.25
## S371 BJJ9 round 5: the finished hold reads this long before the verdict banner (the bodies reach the sub first).
const VERDICT_HOLD_S := 0.7
const OPP := {"name": "Kim Patel", "skill": 30.0, "stats": {"strength": 55.0, "cardio": 50.0}}

var browser: Control
var f: Dictionary
## S389 BJJWIRE: the bracket's opponent and the career's hand-back; a bare `match=1` run keeps OPP.
var opp: Dictionary = OPP
var names: Array = ["ANA", "KIM"]
var on_end := Callable()
var st: Dictionary
var auto := false
var _rng := RandomNumberGenerator.new()
var _wait := 0.0                 # seconds until the next move
var _call: Array = []            # the offers on the panel while a call is open
var _call_left := 0.0
var hud: Control
var _score: Label
var _clock: Label
var _where: Label
var _calls: Label
var _gas: Array = []
var _offers: VBoxContainer
## S371 round 7: the pre-match stance (the standing family's first position) is the match's OPENING only - entering it
## mid-match reads as a reset and a handshake (Argon priced "stand up, back away, shake hands, reset" at 01:04 twice),
## and the same move replayed twice in a row (three "Hold And Breathe" ticks over 00:03-00:07) is a statue loop.
var _start_pos := -1
var _prev_title := ""
var _window: Control
var _last := ""
var _ended := false
var _hold_left := 0.0
## S377 round 10: a won lock submission's finish (GrappleFinish) - where the sub's move landed and which way it ran.
var _finish_land := -1
var _finish_rev := false
var _finish_done := false
## S425 ANIMFIX1 (the live bout on film: "+4" and the new score stood on screen 2 s before the bodies reached the mount, and
## "LANDS" over a move that had not started): the screen says who is TRYING what when a move starts; its result and the
## score land when the bodies do (RESULT_LEAD_S before the move ends; a miss after its feint's reach, RESULT_MISS_S).
## `-- earlyresult` = the result at once (the control arm).
const RESULT_LEAD_S := 0.3
const RESULT_MISS_S := 0.7
var _late: bool = not OS.get_cmdline_user_args().has("earlyresult")
var _result: Dictionary = {}     # the attempt whose result is not on screen yet
var _pts_shown: Array = [0, 0]


func setup(b: Control, athlete: Dictionary, seed_n: int = 369, rival: Dictionary = {}, done: Callable = Callable()) -> void:
	browser = b
	f = athlete
	if not rival.is_empty():
		opp = rival
	on_end = done
	names = [str(f["first"]).to_upper(), str(opp["name"]).get_slice(" ", 0).to_upper()]
	st = BjjMatch.start(f, opp)
	_rng.seed = seed_n
	auto = OS.get_cmdline_user_args().has("auto=1")
	_build_panel()
	# A belt match starts on the feet - from scratch: the browser's own first position (mount) is dropped, or every
	# match opened on a one-frame mount that then teleported to standing (the probe's 1.80 m pop at 0.1 s).
	var pl: Node = browser.get("player")
	if pl != null:
		pl.set("seq", {})
	var stand: Array = browser.graph.family("standing")
	if not stand.is_empty():
		_start_pos = int(stand[0]["id"])
		browser.go_position(_start_pos)
	_wait = 1.0
	_draw()
	print("MATCH start %s vs %s, %s" % [f["name"], opp["name"], BjjMatch.clock(float(st["limit_s"]))])


func _process(delta: float) -> void:
	if browser == null or st.is_empty():
		return
	_result_tick(delta)
	if bool(st["over"]):
		# S371 BJJ9: a submission's winning move plays out BEFORE the verdict shows, then the finished hold reads for
		# VERDICT_HOLD_S before the banner (a tap's worth of stillness in the choke, not a verdict over a tangle).
		# S377 round 10: a LOCK submission plays its finish (the winner takes the arm, the loser taps) before the hold.
		if not _ended and (browser.moving as Dictionary).is_empty():
			if _finish_land >= 0 and not _finish_done:
				_finish_done = true
				_play_finish()
				return
			if _hold_left <= 0.0:
				_hold_left = VERDICT_HOLD_S
			_hold_left -= delta
			if _hold_left <= 0.0:
				_end()
		return
	var pos_c := BjjMatch.classify(_tags(browser.current))
	var settled: bool = browser.moving.is_empty() and BjjMatch.SETTLES.has(pos_c)
	BjjMatch.tick(st, delta, settled)
	if bool(st["over"]):
		return
	_draw()
	if not browser.moving.is_empty():
		return
	if not _call.is_empty():
		_call_left -= delta
		(_window.get_child(0) as Control).set("frac", clampf(_call_left / CALL_WINDOW_S, 0.0, 1.0))
		if _call_left <= 0.0:
			_act(0, _call[0], false)   # her plan goes
		return
	_wait -= delta
	if _wait > 0.0:
		return
	var me := int(st["init"])
	var top := _top(pos_c)
	var offers := BjjMatch.offers(st, f if me == 0 else opp, me, pos_c, top, _cands(pos_c))
	if offers.is_empty():
		_drift(pos_c)
		return
	if me == 0 and BjjMatch.can_call(st, pos_c) and not auto:
		_open_call(BjjMatch.call_offers(offers))
		return
	_act(me, offers[0] if me == 0 else offers[_rng.randi() % mini(2, offers.size())], false)


## One move by woman `me`: rolled; a hit plays it (the points are in), a miss stays and hands the initiative over.
func _act(me: int, o: Dictionary, called: bool) -> void:
	_close_call()
	var roll := _rng.randf()
	var firsts := [str(names[0]).capitalize(), str(names[1]).capitalize()]
	var before: Dictionary = st.duplicate(true)   # the clash reads the odds as they were rolled
	var hit := BjjMatch.resolve(st, me, o, roll, called)
	var who: String = firsts[me]
	if str(o["kind"]) == "hold":
		hud.note(me, str(o["title"]))
	else:
		var r := BjjClash.read(before, me, o, hit, firsts)
		var shown := BjjClash.title(o, NoGi.move_name(str(o["syllabus"])) if str(o["syllabus"]) != "" else "")
		_show_result(before["pts"])   # one still waiting (the next move took over mid-feint) goes on screen first, on its own score
		_result = {"me": me, "title": shown, "hit": hit, "odds": float(o["odds"]), "roll": roll, "r": r,
			"left": RESULT_MISS_S if (not hit or int(o["i"]) < 0) else -1.0}
		if _late and not bool(st["over"]):   # a won submission says LOCKED IN at once: its finish plays next
			hud.trying(me, shown, r)
		else:
			_show_result()
	_prev_title = Graph.clean(str(o["title"])).to_lower()
	_last = "%s%s: %s - %s" % ["CALL " if called else "", who, Graph.clean(str(o["title"])),
		("+%d" % int(o["pts"]) if int(o["pts"]) > 0 else "in") if hit else "missed"]
	print("MATCH %s %s %s %s odds %.2f %s | %d-%d" % [BjjMatch.clock(float(st["t"])), who, str(o["kind"]),
		Graph.clean(str(o["title"])), float(o["odds"]), "HIT" if hit else "MISS", int(st["pts"][0]), int(st["pts"][1])])
	if hit and int(o["i"]) >= 0:
		# The kind paces the move: a takedown lands fast with an impact (S371 BJJ9), a positional move keeps its time.
		# A won submission is NOT skipped: its move plays and _end() waits for it (the verdict must match the bodies).
		# Its last frame holds (freeze_handover): the verdict pose is not re-aligned under the banner.
		var mv: Dictionary = browser.graph.outs(browser.current)[int(o["i"])]
		if bool(st["over"]):
			browser.set("freeze_handover", true)
			# S377 round 10: the finish (the lock, the extension, the tap) is built from the move's landing pose when
			# its move has played out.
			_finish_land = int(Graph.lands(mv))
			_finish_rev = bool(mv["reverse"])
		browser.play_out(mv, str(o["kind"]))
	elif int(o["i"]) >= 0:
		# S371 round 9: a MISS plays the attempt as a FEINT - out and back over ~1.1 s. Round 8's film had eight
		# alternating misses with no animation at all (01:03-01:09, "completely frozen like statues"): the fighter
		# now visibly tries and recovers, and the next move may take over mid-feint (Argon: "overlap the blend
		# windows so transitions flow continuously without full stops").
		browser.play_feint(browser.graph.outs(browser.current)[int(o["i"])])
	# Round 9: the settle is short - the blend windows of the next move cover the hand-over (was 1.0/0.6).
	_wait = 0.5 if hit else 0.3


## S425: the waiting result goes on screen when the bodies arrive (or its miss has shown), and the score with it.
func _result_tick(delta: float) -> void:
	if _result.is_empty():
		return
	var pl: Node = browser.get("player")
	if float(_result["left"]) >= 0.0:
		_result["left"] = float(_result["left"]) - delta
		if float(_result["left"]) <= 0.0:
			_show_result()
	elif (browser.moving as Dictionary).is_empty() or pl == null or float(pl.length_s()) - float(pl.t()) <= RESULT_LEAD_S:
		_show_result()


func _show_result(pts: Array = []) -> void:
	if not _result.is_empty():
		var x: Dictionary = _result
		_result = {}
		hud.attempt(int(x["me"]), str(x["title"]), bool(x["hit"]), float(x["odds"]), float(x["roll"]), x["r"])
	var now: Array = st["pts"] if pts.is_empty() else pts
	_pts_shown = [int(now[0]), int(now[1])]
	if _score != null:
		_draw()


## No scoring move for the one with the initiative: a plain move out (a grip, a step) keeps the match flowing.
func _drift(pos_c: String) -> void:
	var outs: Array = browser.graph.outs(browser.current)
	var ok: Array = []
	for i in outs.size():
		if Graph.lands(outs[i]) != null and not Curated.blocked(int(outs[i]["t"]["id"])) and not browser.graph.outs(int(Graph.lands(outs[i]))).is_empty() \
				and int(Graph.lands(outs[i])) != _start_pos:
			ok.append(i)
	st["init"] = 1 - int(st["init"])
	if ok.is_empty():
		# S371 round 8: the family's first standing hub IS the pre-match shake stance - a drift into it read as the fighters
# stopping to shake hands (Argon, twice: 01:04 in round 6, 03:32 in round 7, the clasped hands on film).
		var hubs: Array = browser.graph.family("standing" if pos_c == "standing" else "full_guard")
		var hub := int(hubs[0]["id"])
		for hb in hubs:
			if int(hb["id"]) != _start_pos:
				hub = int(hb["id"])
				break
		browser.go_position(hub)
	else:
		browser.play_out(outs[ok[_rng.randi() % ok.size()]])
	_wait = SCRAMBLE_S


## S377 round 10: a won lock submission's finish - GrappleFinish builds it from the landing pose (the winner takes the
## armbar); a choke's hold reads as-is. Only a lock family (armbar/spiderweb) takes the arm.
func _play_finish() -> void:
	if not Player.on("finish"):   # S379 audit control arm: `-- nofinish`, the landing pose is the verdict pose
		return
	var tags: Array = browser.db[_finish_land].get("tags", [])
	# S390: the frame on screen, not the raw data: a move is laid on the pair swapped or mirrored, and on the raw frame the winner
	# took the tap (film: Ana, the winner, slapping the mat).
	var landing: Array = browser.player.shown_frame()
	var winner := int(st["winner"])
	var fin: Dictionary = GrappleFinish.squeeze(landing, winner, tags)
	_draw()
	hud.clear_for_finish(0.0)
	browser.play_finish(fin["frames"], fin["times"])
	# S390: the shot of the match: close and low, from the side the tap is on (every judge: "no tap"; the hand was behind the bodies).
	var end: Array = browser.player.joints_at(browser.player.length_s())
	var lose: PackedVector3Array = end[1 - winner]
	var hand: Vector3 = lose[DB.joint(str(fin["free"]) + "Hand")]
	var mid: Vector3 = ((end[0] as PackedVector3Array)[DB.joint("Core")] + (end[1] as PackedVector3Array)[DB.joint("Core")]) * 0.5
	var look := mid.lerp(hand, 0.3)
	browser.finish_lens(look, FinishLens.toward(end, look, 1 - winner, str(fin["free"])))


## Every move out of the position on screen, laid on the pair as the browser would play it: its tags, where it lands,
## who is on top there.
func _cands(_pos_c: String) -> Array:
	var out: Array = []
	var outs: Array = browser.graph.outs(browser.current)
	var shown: Array = browser.player.shown_frame()
	for i in outs.size():
		var m: Dictionary = outs[i]
		var land: Variant = Graph.lands(m)
		if land == null or Curated.blocked(int(m["t"]["id"])):
			continue
		if int(land) == _start_pos:
			continue
		var frames: Array = browser.db[int(m["t"]["id"])]["frames"]
		var rev := bool(m["reverse"])
		var align := Graph.align(shown, frames.back() if rev else frames[0])
		var placed := Graph.placed(frames, align, rev)
		# S371 round 5: a link that would RELOCATE the pair to start (the probe caught a 1.9 m one-frame jump on a
		# submission finish's entry) is a wrong move for this spot. The MEAN error hides one flying joint, so the
		# test is the worst joint between the move's placed first frame and the pose on screen.
		var p0: Array = placed[0]
		var jump := 0.0
		for mm in 2:
			var pm: PackedVector3Array = p0[mm]
			var sm: PackedVector3Array = shown[mm]
			for j in pm.size():
				jump = maxf(jump, pm[j].distance_to(sm[j]))
		if jump > 0.25:
			continue
		var to_c := BjjMatch.classify(_tags(int(land)))
		var last: Array = placed.back()
		# The move's own tags only: a position's grip tags (a kimura grip on side control) are not a submission.
		var title := Graph.clean(str(m["t"]["title"]))
		if title.strip_edges().trim_suffix(".").is_empty() or title.begins_with("..."):
			title = "to %s" % Graph.clean(str(browser.db[int(land)]["title"])).to_lower()
		# S371 round 6: the pre-match move ("begin" walks the pair into the greeting stance) never fires again mid-match
		# (Argon's 4/10: "after standing up in the middle of the match both fighters stop to shake hands").
		var tlc := title.to_lower()
		if tlc.contains("begin"):
			continue
		# Round 7: one hold in a row is a breather; the same hold twice is a statue (three "Hold And Breathe" ticks ran
		# 00:03-00:07 in round 6's film).
		if tlc.contains("hold") and _prev_title.contains("hold"):
			continue
		out.append({"i": i, "title": title, "tags": BjjMatch.scoring_tags(m["t"]["tags"] as Array, _tags(int(land))),
			"to_c": to_c, "top_after": BjjMatch.top_of([_core_y(last, 0), _core_y(last, 1)], to_c),
			"sub_by": GrappleFinish.attacker(m["t"]["tags"] as Array, last)})
	return out


func _tags(pos_id: int) -> Array:
	return browser.db[pos_id].get("tags", []) if pos_id >= 0 and pos_id < browser.db.size() else []


func _top(pos_c: String) -> int:
	var fr: Array = browser.player.shown_frame()
	return BjjMatch.top_of([_core_y(fr, 0), _core_y(fr, 1)], pos_c)


static func _core_y(frame: Array, man: int) -> float:
	return (frame[man] as PackedVector3Array)[DB.joint("Core")].y


## ---------- the panel ----------

func _build_panel() -> void:
	# S389 CLASH: the browser's side panel gives way to a panel each side of the mat.
	var side: Control = browser.get("_side")
	(side.get_parent().get_parent().get_parent() as Control).visible = false
	hud = MatHud.new()
	hud.name = "MatHud"
	browser.add_child(hud)
	hud.build(names, str(f.get("belt", "white")), [_numbers(0), _numbers(1)])
	_score = hud.score
	_clock = hud.clock
	_where = hud.where
	_calls = hud.calls
	_gas = hud.gas
	_offers = hud.offers


func _numbers(i: int) -> Dictionary:
	return {"skill": float(st["skill"][i]), "strength": float(st["strength"][i]), "cardio": float(st["cardio"][i])}


func _draw() -> void:
	_score.text = "%s %d - %d %s" % [names[0], int(_pts_shown[0]), int(_pts_shown[1]), names[1]]
	_clock.text = "%s of %s" % [BjjMatch.clock(minf(float(st["t"]), float(st["limit_s"]))), BjjMatch.clock(float(st["limit_s"]))]
	var pos_c := BjjMatch.classify(_tags(browser.current))
	var top := _top(pos_c)
	var on := "" if top < 0 else (" - %s on top" % str(names[top]).capitalize())
	_where.text = "%s%s" % ["Scramble" if pos_c == "other" else pos_c.replace("_", " ").capitalize(), on]
	# S390: two judges could not say who was who: the line wears her corner's colour, and the finish says which corner applies it.
	var who := int(st["winner"]) if bool(st["over"]) and _finish_land >= 0 else _top(pos_c)
	_where.add_theme_color_override("font_color", MatHud.SIDE_COLOR[who] if who >= 0 else UI.FG)
	if bool(st["over"]) and _finish_land >= 0:   # the label read "Guard - Nadia on top" through Ana's armbar
		_where.text = "%s - %s (%s)" % [BjjMatch.sub_name(browser.db[_finish_land].get("tags", [])), names[who] if who == 1 else str(f["first"]), "RED" if who == 0 else "BLUE"]
	for i in 2:
		_gas[i].frac = float(st["gas"][i])
	_calls.text = "CALLS %d of %d%s" % [int(st["calls"]), BjjMatch.CALLS_PER_MATCH,
		"" if float(st["gas"][0]) >= BjjMatch.TIRED_GAS else " - gassed: no calls"]


func _open_call(offers: Array) -> void:
	_call = offers
	_call_left = CALL_WINDOW_S
	UI.clear(_offers)
	_offers.add_child(UI.caps("YOUR CALL - %s'S PLAN GOES IN %d s" % [str(f["first"]).to_upper(), int(CALL_WINDOW_S)]))
	_window = UI.hbox(0)
	var bar := Bar.new()
	bar.custom_minimum_size = Vector2(300, 8)
	bar.fill = UI.GOLD
	bar.frac = 1.0
	_window.add_child(bar)
	_offers.add_child(_window)
	for k in offers.size():
		_offers.add_child(_offer_card(k, offers[k]))


## S376 BJJMENU1 (BJJ DOJO's move menu): one call as a card - the move (her plan first), then CHANCE / POINTS / GAS / RISK
## (BjjMatch.gas_cost, BjjMatch.risk) and what a miss costs. The whole card is the button.
func _offer_card(k: int, o: Dictionary) -> PanelContainer:
	var b := PanelContainer.new()
	b.name = "Call_%d" % k
	b.add_theme_stylebox_override("panel", UI.box(UI.PANEL, UI.LINE, 10, 1, 12, 8))
	if k == 0:
		Halo.ring(b, UI.GOLD, 10.0)
	else:
		Halo.hover(b, Halo.CHALK, 10.0)
	b.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	b.tooltip_text = "Call it"
	b.gui_input.connect(func(e: InputEvent):
		if e is InputEventMouseButton and e.pressed and e.button_index == MOUSE_BUTTON_LEFT:
			_act(0, o, true))
	var v := UI.vbox(4)
	var top := UI.hbox(8)
	if k == 0:
		top.add_child(UI.chip("%s'S PLAN" % str(f["first"]).to_upper(), "gold"))
	var hold := str(o["kind"]) == "hold"
	# S425: what the call DOES first ("Take mount"), the technique's own name after it, small
	var does := str(o["title"]) if hold else BjjClash.title(o, NoGi.move_name(str(o["syllabus"])) if str(o["syllabus"]) != "" else "")
	top.add_child(UI.label(does, UI.BODY, UI.FG, "bold"))
	if not hold and Graph.clean(str(o["title"])).to_lower() != does.to_lower():
		top.add_child(UI.muted(Graph.clean(str(o["title"])), UI.SMALL))
	v.add_child(top)
	var cells := UI.hbox(18)
	var gas := BjjMatch.gas_cost(st, 0, o)
	var rk := BjjMatch.risk(o)
	cells.add_child(_cell("CHANCE", "%d%%" % roundi(float(o["odds"]) * 100.0)))
	cells.add_child(_cell("POINTS", ("+%d" % int(o["pts"])) if int(o["pts"]) > 0 else ("WIN" if str(o["kind"]) == "sub" else
		("0, paid before" if BjjMatch.paid(st, 0, str(o["kind"])) else "0"))))
	cells.add_child(_cell("GAS", ("+%d" % roundi(-gas.x)) if hold else ("-%d, miss -%d" % [roundi(gas.x), roundi(gas.y)])))
	var rc := UI.vbox(2)
	rc.add_child(UI.caps("RISK"))
	rc.add_child(UI.chip(str(rk["word"]), str(rk["chip"])))
	cells.add_child(rc)
	v.add_child(cells)
	v.add_child(UI.muted("Miss: %s" % str(o["miss"]), UI.TINY, true))
	b.add_child(v)
	for c in v.find_children("*", "Control", true, false):
		(c as Control).mouse_filter = Control.MOUSE_FILTER_IGNORE
	v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return b


func _cell(cap: String, value: String) -> VBoxContainer:
	var c := UI.vbox(2)
	c.add_child(UI.caps(cap))
	c.add_child(UI.mono(value, UI.BODY, UI.FG))
	return c


func _close_call() -> void:
	_call = []
	UI.clear(_offers)


func _end() -> void:
	_ended = true
	_close_call()
	_show_result()
	_draw()
	var w := int(st["winner"])
	var line := ("%s (RED) WINS - %s" % [str(f["first"]).to_upper(), st["how"]]) if w == 0 else \
		(("%s (BLUE) WINS - %s" % [str(names[1]), st["how"]]) if w == 1 else str(st["how"]).to_upper())
	hud.banner(line, UI.GREEN if w == 0 else (UI.RED if w == 1 else UI.FG))
	var called := (st["log"] as Array).filter(func(e): return bool(e["called"])).size()
	print("MATCH_END %s | %d-%d | calls used %d | moves %d" % [line, int(st["pts"][0]), int(st["pts"][1]), called,
		(st["log"] as Array).size()])
	if on_end.is_valid():
		var go := UI.button("Continue", "BtnSolid", func(): on_end.call(result()))
		go.name = "MatchContinue"
		_offers.add_child(go)
	elif auto:
		browser.get_tree().create_timer(1.5).timeout.connect(browser.get_tree().quit)


## S389 what the bracket needs: a bracket has no draw. S397: level at the bell goes to the referee - the more offensive
## grappler (BjjMatch.decide), no longer the fuller tank.
func result() -> Dictionary:
	var w := int(st["winner"])
	var how := str(st["how"])
	if w < 0:
		var d := BjjMatch.decide(st, _rng)
		w = int(d["winner"])
		var sh := float(d.get("share", 0.5))
		how = "referee decision after %d-%d, %d%% of the attacks" % [int(st["pts"][0]), int(st["pts"][1]),
			int(round(100.0 * (sh if w == 0 else 1.0 - sh)))]
	var landed: Array = []
	for e in st["log"]:
		var title := BjjClash.title({"kind": str(e["kind"]), "title": str(e["title"])}).to_lower()
		if int(e["who"]) == 0 and bool(e["hit"]) and str(e["kind"]) != "hold" and not landed.has(title):
			landed.append(title)
	return {"win": w == 0, "how": how, "landed": landed}
