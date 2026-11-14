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
const TellPose := preload("res://scripts/fight3d/TellPose.gd")
const PunchRange := preload("res://scripts/fight3d/PunchRange.gd")
const FightSfx := preload("res://scripts/audio/FightSfx.gd")
const FightVoice := preload("res://scripts/audio/FightVoice.gd")
const MoveStudio := preload("res://scripts/fight3d/MoveStudio.gd")
const BeatTally := preload("res://scripts/fight3d/BeatTally.gd")
const PunchPace := preload("res://scripts/fight3d/PunchPace.gd")
## A short punch's join: half-life, length (s). Between the strike's (0.06, 0.3) and the guard return's (0.1, 0.45).
const SHORT_JOIN := Vector2(0.09, 0.35)
## S469 (hit_gap_probe: 5-6 of the 7-8 landed punches shown more than 15 cm off their target were inside punches started
## two frames before the hit; the glove was still coming out of her guard, 0.2-0.7 m short). A short punch keeps at least
## this much screen time for the glove to arrive. `-- shortwind=0.08` = the old floor (the control arm).
static var SHORT_WIND_S: float = _short_wind()
static func _short_wind() -> float:
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with("shortwind="):
			return float(str(a).trim_prefix("shortwind="))
	return 0.16

var stepped := [false, false]   # her next punch steps in (a Pro _ft take)
var tired := [false, false]     # she has tired this round: her punches are the _hurt takes
var last_contact := [-9.0, -9.0]  # view time her last punch lands (S302 combos)
const FALL_AFTER_S := 0.03   # S376: a knockdown's fall starts this long after the shot lands
## S376: the knockdown clips stand ~0.4 s before they drop (head 1.56 m -> the canvas by ~1.3 s, tools S376 measure):
## they start this far in, so the head is down ~0.9 s after the punch (the scan's MMA Career Simulator: 0.8 s).
const FALL_FROM_S := 0.4
const FALL_ON_CANVAS_S := 0.9   # S390: the thud waits for the body: canvas at ~1.3 s of the clip, started FALL_FROM_S in
var last_hand := ["", ""]
var last_def := ["", ""]
var last_def_t := [-9.0, -9.0]


func reset() -> void:
	stepped = [false, false]
	tired = [false, false]
	last_contact = [-9.0, -9.0]
	last_hand = ["", ""]
	last_def = ["", ""]
	last_def_t = [-9.0, -9.0]


## v is the FightView: its stage, body map, profiles, round stop, rng, clock and close-up timer.
func fire(v: Node, b: Dictionary) -> void:
	var stage: Node3D = v.stage
	var rng: RandomNumberGenerator = v._amb_rng
	var who := 0 if str(b["who"]) == "a" else 1
	var other := 1 - who
	var move := str(b["move"])
	if b.has("tell"):
		var contact: float = BeatClips.contact(move, float(Stage.CONTACT.get(move, Stage.CONTACT_S))) if move in Stage.CONTACT else 0.0
		TellPose.apply(stage, who, str(b["tell"]), contact)
	match move:
		"say", "inside":
			# S314: an inside spell only moves the range (RangeBreath). VOICEWIRE1: the corner's shout beat speaks its call
			# (no coach carries a sex field yet, so it is Callum's voice until staff do).
			if b.has("shout_call"):
				FightVoice.shout(str(b["shout_call"]), false)
		"step_in", "step_out":
			# S311: one boxer lunges into the pocket or steps out of range; the other holds (RangeBreath).
			if b.has("ref"):
				stage.clinch.release()   # S369/S371 NOREF1: both push off to range
			else:
				stage.step(who, 1 if move == "step_in" else -1)
				FightSfx.step()
			stepped[who] = move == "step_in"
		"clinch":
			# S354 CLINCH2: the beat's own digs/digger (ClinchBeats) ride along; a beat without them ties up as before.
			stage.clinch.start(who, float(b.get("dur", 3.0)), int(b.get("digs", 0)), (0 if str(b.get("digger", "a")) == "a" else 1) if b.has("digger") else -1)
		"slip":
			stage.play(who, "slip")
		"tired":
			stage.play(who, BeatClips.pick(BeatClips.TIRED, stage.has_move, rng.randf()))
			tired[who] = true
		"count":
			# S377: a frame later - the round script puts the count on the big shot's own t, and the sort that orders the
			# two is not stable; read before the shot fired, last_contact was the punch before it.
			_count.call_deferred(v, who, other)
		_:
			_punch(v, b, who, other, move)


## The sim's standing count (Knockdowns). S376 KNOCKDOWN1 (the itch scan: "punch at 1.8 s, fully down by 2.6 s"): the fall
## starts FALL_AFTER_S after the shot's contact, and the shot replays in slow motion. S377 KNOCKCOUNT1: the count itself
## (neutral corner, the number, the rise or the stoppage, the winner's celebration) is KnockdownCount's.
func _count(v: Node, who: int, other: int) -> void:
	var stage: Node3D = v.stage
	var shot := float(last_contact[other])
	var wait := maxf(0.0, shot - float(v.t)) + FALL_AFTER_S
	var fall := BeatClips.pick(BeatClips.OUT if v._stop == "KO" else BeatClips.DOWN, stage.has_move, v._amb_rng.randf())
	# A skipped round (KnockdownCount.stop) cancels a fall still to come - he would drop in the corner minute; a KO falls.
	v.get_tree().create_timer(wait, false).timeout.connect(func():
		if v.get("kd") == null or str(v.kd.phase) != "":
			stage.play(who, fall, 1.0, FALL_FROM_S)
			FightSfx.knockdown(FALL_ON_CANVAS_S))
	if v.get("replay") != null and shot > -1.0:
		v.replay.knockdown(who, shot)
	if v.get("kd") != null:
		v.kd.start(who, str(v._stop), _up_at(v), wait)


## When the downed boxer gets up (Knockdowns' up_at for the round's last count; 0 = KnockdownCount's default).
static func _up_at(v: Node) -> int:
	var rounds: Array = (v.main.modal as Dictionary).get("rounds", []) if v.main != null else []
	if rounds.size() < int(v.round_n):
		return 0
	var ups: Array = (rounds[int(v.round_n) - 1] as Dictionary).get("up_at", [])
	return int(ups[-1]) if not ups.is_empty() else 0


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
	BeatTally.take(move, ctx, clip)   # S435: what this beat really got (BEAT_TALLY)
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
		skip = ShortPunch.merge(skip, ShortPunch.skip(BeatClips.travel_path(clip), contact, ShortPunch.want(move, float(ctx["roll"])), sp, SHORT_WIND_S))
	last_hand[who] = hand
	# S371 BODYREACT1 (the S370 probe measured it: 14 of 42 landed body shots were cut off before they ever arrived - no
	# hit, no reaction, no fold (PunchRange.cut_off: a new beat replaced the armed punch before its contact; the probe's
	# fliers caught her flip pro_body_shot -> pro_left_hook_v2 on the very contact frame). A body hook flies 0.40 s,
	# while the same boxer's next beat can arrive 0.35 s after hers: the follow-up beats her own landing. A punch that
	# would replace HER OWN still-flying punch now waits for it to land. `base` is the view time it really starts;
	# every timer runs off it, so the contact stays on her glove.
	var at := (contact - skip) / sp
	# POWER1 step 3 (PunchPace): a lone punch starts past its dead wind-up (its glove's drive, ReachDrive, moves no time); what
	# that saves, she stands in her guard first, so the punch lands when it did (the hit, its sound and reaction, the combo
	# rhythm).
	var pp := PunchPace.plan(clip, move, contact)
	skip = maxf(skip, float(pp["start"]))
	var real_s := PunchPace.real(pp, skip, contact)
	var wait := maxf(0.0, at - real_s) + PunchPace.lead()
	at = real_s - PunchPace.lead()
	var base := maxf(t, float(last_contact[who]) + 0.03)
	# S371 BODYREACT1: she does not punch out of a fresh fold either - with the own-punch wait in, a new beat could still
	# fire beside her own body-shot reaction and cut the hold short: the probe read 0.17 s, then 0.27 s against the
	# 0.35 bar before this wait, 0.47 s after it. Only a FOLD waits (gain 1.0 brace / a head reaction: no wait - head
	# shots are untouched).
	var hitsnap: Node = stage.boxers[who].get("snap")
	var bt := float(hitsnap.get("_bt")) if hitsnap != null else -1.0
	if bt >= 0.0 and bt < 0.51 and float(hitsnap.get("_gain")) > 1.5:
		base = maxf(base, t + (0.51 - bt))
	# Review round 2: the guard wait goes on after the fold's (added before it, a fold could swallow it and the punch landed
	# up to `wait` early).
	base += wait
	last_contact[who] = base + at
	b["contact_t"] = base + at   # POWER1 step 4: RangeBreath keeps this punch's own distance until it lands
	b["clip"] = clip
	# Her defence is chosen when the beat fires (the de-duplication reads the beat's own time), shown when it plays.
	var d := ""
	var stopped := bool(b.get("stopped", false))   # S393 CounterCut: the other's punch stops this one; nobody defends it
	if land != "lands" and not stopped and (str(b.get("def", "")) != "" or land == "misses"):
		d = str(b.get("def", ""))
		if d == "":
			d = "slip" if rng.randf() < 0.75 else "pull"
		if d in ["weave", "pull"] and str(last_def[other]) == d and t - float(last_def_t[other]) < 1.4:
			d = "slip" if d == "weave" else "block"
		last_def[other] = d
		last_def_t[other] = t
	# Review round 2 (blind review of beeea8f2: "blocks are now set late"; tests/block_set_test.gd). The cover-up needs
	# BLOCK_SET_S of its clip to get the gloves up. Timed from go() and clamped at 0, a punch whose start-to-contact is
	# shorter (a later start, a short take) met a guard still rising. Now it is timed from the beat - she may raise it while
	# the other still stands in her guard - and when even that is too late it starts part-way in (MoveStudio's preview does
	# the same), so it is set when the glove arrives. A punch refused or cut off before it shows still shows no block.
	# BLOCKLOOK2: there is no block clip any more (every owned one hunches her or holds a glove over her head). She stays
	# in her guard and BlockCatch brings the glove on the punch's side onto its line, set before the glove arrives
	# ((base - t) + at real seconds from now), then back into the guard. The refused / cut-off rule is the same.
	var blk := {"id": -2}   # the punch's play id once go() has run (-1: refused)
	if d == "block" and move != "body_hook":
		var still_b := func() -> bool:
			var pid := int(blk["id"])
			return not (pid == -1 or (pid >= 0 and PunchRange.cut_off(stage, who, pid)))
		preload("res://scripts/fight3d/BlockCatch.gd").block(stage, who, clip, move, contact, sp, (base - t) + at, still_b)
	var go := func() -> void:
		# S321: a punch refused (she is locked in a hit reaction) never shows, so its hit or defence must not either.
		var punch_id: int = int(stage.boxers[who]["play_id"]) if stage.play(who, clip, sp, skip) else -1
		blk["id"] = punch_id
		if punch_id < 0:
			BeatTally.add("refused")
			return
		PunchPace.arm(stage, who, pp)
		BeatTally.add("started")
		if short and skip > 0.0 and stage.boxers[who].get("js") != null:
			# Started mid-swing, the clip's glove is up to a metre from the guard's: a slower join (S319 smooth_probe:
			# the strike join's 0.06 s half-life added ~50 kinks/min up close) eases the glove onto the swing.
			(stage.boxers[who]["js"] as Node).join(SHORT_JOIN.x, SHORT_JOIN.y)
		v.body.land(b, at)
		# HEADAIM2: un-landed head punches aim their height at the target's face (blocked, slipped, missed).
		# Body punches (body_hook, kidney, body) are never aimed here.
		var is_body := move == "body_hook" or clip.contains("kidney") or clip.contains("body")
		# BLOCKMEET2: blocked head punches are carried onto the blocking glove (arm_block), not just aimed at face height.
		var is_block := land == "blocked" or str(b.get("def", "")) == "block"
		if land != "lands" and not stopped and not is_body:
			if is_block:
				stage.arm_block(who, clip, at, contact)
			else:
				stage.aim_height(who, clip, at, contact)
			BeatTally.add("aim_block" if is_block else "aim_height")
		elif land != "lands":
			BeatTally.add("aim_none")
		var tree: SceneTree = v.get_tree()
		if punch_id >= 0 and land != "lands" and not stopped:
			# S390: at the glove's contact, and only for a punch that shows. A slip or weave is a miss, not a block.
			# S395: the punch must still be running (PunchRange.cut_off): 14 % of block/miss sounds fired after
			# the punch clip was replaced by a reaction or another move.
			if is_block:
				tree.create_timer(at).timeout.connect(func():
					if not PunchRange.cut_off(stage, who, punch_id):
						FightSfx.blocked())
			else:
				tree.create_timer(at).timeout.connect(func():
					if not PunchRange.cut_off(stage, who, punch_id):
						FightSfx.missed(0.0, move, str(b.get("def", ""))))
		if land == "lands":
			# S302: the glove is carried onto her face past the guard, and the contact holds, snaps and nudges.
			# (FIGHT9: no half-speed close-up on the big shot - Argon read it as slow motion; S376 replays knockdowns.)
			stage.land(who, clip, move == "body_hook" or clip.contains("kidney"), at, contact)
			BeatTally.add("aim_land")
			if bool(b.get("big", false)):
				FightSfx.big_shot_ahead(at)
			var hit := BeatClips.react(move, bool(b.get("knockback", false)), stage.has_move, rng.randf(), bool(b.get("big", false)))
			tree.create_timer(at).timeout.connect(stage.hit.bind(other, hit, BeatClips.speed(hit, ""), who, move, bool(b.get("big", false)), punch_id))
		elif d != "":
			# Her defence (RoundStyle): a block meets the glove at contact; a slip, weave or step back starts early.
			# BLOCKMEET2: block uses shared constant BLOCK_SET_S (0.25s before contact), same as preview path.
			var when := at * 0.35   # a head block is timed from the beat, above
			# S305: the side comes from the hand that throws it (her left arrives on the other's right).
			var lead := move in ["jab", "lead_hook", "lead_uppercut"]
			var from_left: bool = stage.hand_of(who, hand if hand != "" else ("LeftHand" if lead else "RightHand")) == "LeftHand"
			if d == "block" and move == "body_hook":
				# S305: a body shot is blocked with the elbow - gloves stay up, the elbow drops onto the ribs (HitSnap.brace).
				# S450 (BLOCKLOOK3's unowned bug): the brace's trunk give lives on her BlockCatch, which only a head block made.
				preload("res://scripts/fight3d/BlockCatch.gd").on(stage, other)
				var snap: Node = stage.boxers[other].get("snap")
				if snap != null:
					tree.create_timer(at).timeout.connect(snap.brace.bind(not from_left))
			elif d != "block":
				var dclip := BeatClips.defence(d, move, from_left, bool(stage.boxers[other].get("south", false)), stage.has_move)
				tree.create_timer(when).timeout.connect(func():
					if not PunchRange.cut_off(stage, who, punch_id):
						stage.play(other, dclip, BeatClips.speed(dclip, "")))
	if base <= t + 0.0001:
		go.call()
	else:
		v.get_tree().create_timer(base - t).timeout.connect(go)
