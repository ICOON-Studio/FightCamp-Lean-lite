extends RefCounted
## S319: the beat switch, moved out of FightView (its 500-line cap). One beat of the round script -> the clips on the
## FightStage: steps, clinch, slip, tired, the count, and a punch with its hit reaction or defence. Holds the per-round
## state the punches need (stepping in, tired takes, the combo rhythm); FightView.play_round calls reset().

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const RoundScript := preload("res://scripts/rules/RoundScript.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const Combos := preload("res://scripts/rules/Combos.gd")
const ShortPunch := preload("res://scripts/rules/ShortPunch.gd")
## A short punch's join: half-life, length (s). Between the strike's (0.06, 0.3) and the guard return's (0.1, 0.45).
const SHORT_JOIN := Vector2(0.09, 0.35)

var stepped := [false, false]   # her next punch steps in (a Pro _ft take)
var tired := [false, false]     # she has tired this round: her punches are the _hurt takes
var last_contact := [-9.0, -9.0]  # view time her last punch lands (S302 combos)
var last_hand := ["", ""]


func reset() -> void:
	stepped = [false, false]
	tired = [false, false]
	last_contact = [-9.0, -9.0]
	last_hand = ["", ""]


## v is the FightView: its stage, body map, profiles, round stop, rng, clock and close-up timer.
func fire(v: Node, b: Dictionary) -> void:
	var stage: Node3D = v.stage
	var rng: RandomNumberGenerator = v._amb_rng
	var who := 0 if str(b["who"]) == "a" else 1
	var other := 1 - who
	var move := str(b["move"])
	match move:
		"say", "inside":
			pass   # S314: an inside spell only moves the range (RangeBreath)
		"step_in", "step_out":
			# S311: one boxer lunges into the pocket or steps out of range; the other holds (RangeBreath).
			if b.has("ref"):
				stage.clinch.release()   # S313: the referee's break - he parts them, both step out
			stage.step(who, 1 if move == "step_in" else -1)
			stepped[who] = move == "step_in"
		"clinch":
			stage.clinch.start(who, float(b.get("dur", 3.0)))
		"slip":
			stage.play(who, "slip")
		"tired":
			stage.play(who, BeatClips.pick(BeatClips.TIRED, stage.has_move, rng.randf()))
			tired[who] = true
		"count":
			# The sim's standing count (Knockdowns); a KO stays down and the winner celebrates.
			stage.play(who, BeatClips.pick(BeatClips.OUT if v._stop == "KO" else BeatClips.DOWN, stage.has_move, rng.randf()))
			if v._stop != "":
				v.get_tree().create_timer(1.2).timeout.connect(stage.play.bind(other, BeatClips.pick(BeatClips.WIN, stage.has_move, rng.randf())))
		_:
			_punch(v, b, who, other, move)


func _punch(v: Node, b: Dictionary, who: int, other: int, move: String) -> void:
	var stage: Node3D = v.stage
	var rng: RandomNumberGenerator = v._amb_rng
	var t: float = v.t
	# Fight model step 4: the beat's punch, its hit reaction and its defence come from BeatClips (Punch Pro first).
	var land := str(b["result"])
	# S301: stepping (_ft) and wide-miss takes back on; the ones tools/take_check.gd measured off stay out (BeatClips.OFF_TAKES).
	var ctx := {"big": bool(b.get("big", false)), "miss": land == "misses" and str(b.get("def", "")) == "",
		"tired": tired[who], "step": stepped[who], "roll": rng.randf()}
	stepped[who] = false
	var clip := BeatClips.punch(move, ctx, stage.has_move)
	var sp := BeatClips.speed(clip, move)
	var contact := BeatClips.contact(clip, float(Stage.CONTACT.get(move, Stage.CONTACT_S)))
	var hand := str(BeatClips.contact_row(clip).get("hand", ""))
	var same_hand := hand != "" and hand == str(last_hand[who])
	var gap := -1.0
	if str(b.get("combo_id", "")) != "":
		# Her drilled combo lands at its own rhythm: quicker the better she has it, slower when she is tired.
		var p: Dictionary = v._profiles.get(str(b["who"]), {})
		gap = Combos.interval(float((p.get("combos", {}) as Dictionary).get(str(b["combo_id"]), 0.0)), same_hand,
			RoundScript.energy_at(p, fmod(float(b["t"]), Exchanges.EX_SECONDS) / Exchanges.EX_SECONDS))
	var skip := BeatClips.combo_skip(contact, sp, float(last_contact[who]), t, same_hand, gap)
	var short: bool = stage.feet.phase() == "inside" and not OS.get_cmdline_user_args().has("noshort")
	if short:
		# S319 SHOVEL1 (J_INSIDE2: inside punches travel 15-30 cm): chest to chest the clip starts late in its swing, so
		# the glove covers only the last stretch of its measured path (clip_travel.json) - a short hook, not a wide one.
		skip = ShortPunch.merge(skip, ShortPunch.skip(BeatClips.travel_path(clip), contact, ShortPunch.want(move, float(ctx["roll"])), sp))
	last_hand[who] = hand
	stage.play(who, clip, sp, skip)
	if short and skip > 0.0 and stage.boxers[who].get("js") != null:
		# Started mid-swing, the clip's glove is up to a metre from the guard's: a slower join (S319 smooth_probe: the
		# strike join's 0.06 s half-life added ~50 kinks/min up close) eases the glove onto the swing.
		(stage.boxers[who]["js"] as Node).join(SHORT_JOIN.x, SHORT_JOIN.y)
	last_contact[who] = t + (contact - skip) / sp
	var at := (contact - skip) / sp
	v.body.land(b, at)
	var tree: SceneTree = v.get_tree()
	if land == "lands":
		# S302: the glove is carried onto her face past the guard, and the contact holds, snaps and nudges.
		stage.land(who, clip, move == "body_hook" or clip.contains("kidney"), at)
		var hit := BeatClips.react(move, bool(b.get("knockback", false)), stage.has_move, rng.randf(), bool(b.get("big", false)))
		tree.create_timer(at).timeout.connect(stage.hit.bind(other, hit, BeatClips.speed(hit, ""), who, move, bool(b.get("big", false))))
		if bool(b.get("big", false)):
			# The round's big shot: cut close as it is thrown and run it at half speed through the contact.
			stage.close_up(other)
			Engine.time_scale = 0.5 * v.pace()
			v._close_left = at + 0.7
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
				tree.create_timer(at).timeout.connect(snap.brace.bind(not from_left))
		else:
			var dclip := BeatClips.defence(d, move, from_left, bool(stage.boxers[other].get("south", false)), stage.has_move)
			tree.create_timer(when).timeout.connect(stage.play.bind(other, dclip, BeatClips.speed(dclip, "")))
	elif land == "misses" and not b.has("def"):
		tree.create_timer(at * 0.35).timeout.connect(stage.play.bind(other, "slip" if randf() < 0.6 else "pull"))
