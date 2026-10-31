extends RefCounted
## Which clip a RoundScript beat plays (fight model step 4): the MoCap Online Punch Pro clips (pro_*) first, then the
## Starter (mc_*) and the old baked / native clips, so a body without the Pro library still fights. Contact times come
## from assets/data/clip_contact.json (tools/clip_contact.gd measures the glove's furthest reach on the game's body).
## Lead = left: our boxers fight orthodox in the ring view.

const CONTACT_PATH := "res://assets/data/clip_contact.json"
## S302 (operator: "still too slow"): a follow-up by the same boxer starts part-way through its wind-up so it lands this
## long after her last punch, never with less than MIN_WIND_S of visible throw. Piorkowski, Lees & Barton 2011 (the paper
## itself, p. 11; John's "125 ms" is not in it): contact of the 1st to contact of the 4th punch 1.06 +- 0.46 s with
## alternating hands (~0.35 s a punch), 1.35 +- 0.27 s with the same hand (~0.45 s). (Moved from FightView S312.)
const COMBO_LAND_S := 0.35
const COMBO_SAME_HAND_S := 0.45
const MIN_WIND_S := 0.12


## Seconds into a punch clip to start it: 0, or for a follow-up (her last punch lands at view time `last`, now = `now`)
## far enough into the wind-up that it lands COMBO_LAND_S after the last, keeping at least MIN_WIND_S of throw.
static func combo_skip(contact: float, speed: float, last: float, now: float, same_hand: bool = false, gap: float = -1.0) -> float:
	if last < now - 0.30:
		return 0.0
	if gap <= 0.0:
		gap = COMBO_SAME_HAND_S if same_hand else COMBO_LAND_S
	var want := maxf(MIN_WIND_S, last + gap - now)
	return clampf(contact - want * speed, 0.0, maxf(0.0, contact - MIN_WIND_S * speed))


## A thrown punch (S300, 60 Punch Pro punch clips): the beat's Pro stem, its plain takes, and the old clip it falls back on.
## Every stem comes in variants the beat picks by context (punch()): _special / _hard (the round's big shot), _miss (a wide
## miss), _hurt (thrown hurt or tired), _ft (stepping in), _hard_ft / _hurt_ft.
const PUNCH := {
	"jab": ["left_jab", ["", "_a", "_b", "_c"], "jab"],
	"cross": ["right_cross", ["", "_a", "_b", "_c"], "cross"],
	"lead_hook": ["left_hook", ["", "_v2"], "lead_hook"],
	"rear_hook": ["right_hook", [""], "lead_hook"],
	"lead_uppercut": ["left_uppercut", [""], "rear_uppercut"],
	"rear_uppercut": ["right_uppercut", [""], "rear_uppercut"],
	"body_hook": ["body_shot", [""], "body_hook"],
}
## S301 tools/take_check.gd (S300 film: "_ft takes kick the back leg up", "_miss takes fling the rear arm back"): these six
## lift a foot or fling the rear glove well past their plain take (right_cross_miss flings it 0.60 m behind her hips); the
## other 18 stepping / wide-miss takes measured clean and play.
const OFF_TAKES := ["pro_left_hook_hurt_ft", "pro_left_hook_miss", "pro_right_cross_miss", "pro_right_hook_hard_ft",
	"pro_right_hook_miss", "pro_right_uppercut_hurt_ft"]
## A landed punch on the other boxer: by the punch that hit her, then "hurt" for the round's knockback.
## S310 (operator: "why don't you map all 165 clips we purchased?"): every Punch Pro hit reaction that comes back to guard
## within ~1 s (clip_recovery.json back_s) is in its punch's pool and the beat's roll picks one (react() took the first
## until S310: every jab to the head played jab_v1_short). The big head snaps (hook v6/v7/v8, peak 0.65-0.79 m) are the
## big shot's (BIG_REACT); the whole-combination reactions are the hurt boxer's.
const REACT := {
	"jab": ["pro_hit_by_jab_v1_short", "pro_hit_by_jab_v2_short", "pro_hit_by_jab_v3", "pro_hit_by_jab_v4_short",
		"pro_hit_by_jab_v5_short", "mc_hit_jab", "react_head"],
	"cross": ["pro_hit_by_cross_v1_short", "pro_hit_by_cross_v2_short", "pro_hit_by_cross_v3", "mc_hit_jab", "react_head"],
	"lead_hook": ["pro_hit_by_hook_v1_short", "pro_hit_by_hook_v2_short", "pro_hit_by_hook_v3_short", "pro_hit_by_hook_v5",
		"mc_hit_hook", "react_head"],
	"rear_uppercut": ["pro_hit_by_uppercut_v1", "pro_hit_by_hook_v1_short", "mc_hit_hook", "react_head"],
	"lead_uppercut": ["pro_hit_by_uppercut_v1", "pro_hit_by_hook_v2_short", "mc_hit_hook", "react_head"],
	"rear_hook": ["pro_hit_by_hook_v3_short", "pro_hit_by_hook_v1_short", "pro_hit_by_hook_v5", "mc_hit_hook", "react_head"],
	# S305 operator: "body shots do not seem to have any impact" - the _short gut shots barely move her (tools/fight3d_bodyshot.gd
	# sheets); v3 folds her at the waist, knees give, hands drop to the stomach, then back to guard. S310: + the kidney shot's.
	"body_hook": ["pro_hit_by_gutshot_v3", "pro_hit_by_gutshot_v2_short", "pro_hit_by_kidneyshot_v1", "pro_hit_by_gutshot_v2",
		"react_body"],
	"hurt": ["pro_hit_by_hook_v1", "pro_hit_by_cross_v1", "pro_hit_by_combo_v1_short", "pro_hit_by_combo_v2_short",
		"pro_hit_by_hook_v7_short", "mc_hit_combo", "react_hurt"],
}
## The big shot's head reactions (a hook or straight that wins the round): the biggest snaps in the library.
const BIG_REACT := ["pro_hit_by_hook_v8_short", "pro_hit_by_hook_v7_short", "pro_hit_by_hook_v6_short", "pro_hit_by_hook_v3"]
## S305 (the move reel: every slip was pro_left_dodge, every weave pro_left_weave, whatever the punch). A straight punch is
## slipped to the OUTSIDE - toward the shoulder it comes from (jab: her right; cross: her left); a hook is rolled under in the
## direction it travels (away from its shoulder). pro_left_* moves her head to HER left (tools/dodge_side.gd); a southpaw
## plays her clips mirrored, so the name flips.
const HOOKS := ["lead_hook", "rear_hook"]


## The defence clip for `kind` against `move`, thrown by the attacker's left hand when `from_left`; `south` = the
## defender plays mirrored clips.
static func defence(kind: String, move: String, from_left: bool, south: bool, has: Callable) -> String:
	if not kind in ["slip", "weave"]:
		return first(DEFENCE.get(kind, DEFENCE["block"]), has)
	var shoulder := "right" if from_left else "left"
	var side := shoulder if not move in HOOKS else ("left" if shoulder == "right" else "right")
	if south:
		side = "left" if side == "right" else "right"
	return first(["pro_%s_%s" % [side, "dodge" if kind == "slip" else "weave"]] + Array(DEFENCE[kind]), has)


## RoundStyle defences and tired beats. S304 (three-round film: Blue held her rear glove straight up over her head after a
## jab landed on her guard; the in-game joins log named the block clip, hand 0.14 m over her own guard for 0.7 s). Real
## boxers catch a jab with the rear glove at the cheek/temple. tools/glove_height_check.gd over=0.03 (hand at most 0.03 m
## above the head bone): every Pro block and mc_block_hit hold it above for 1-4.6 s; mc_to_block (cover-up, then back to
## guard) and the mc_block hold stay under. mc_block loops (she would freeze in the shell), so the cover-up plays.
const DEFENCE := {
	"block": ["mc_to_block"],
	"slip": ["pro_left_dodge", "pro_right_dodge", "mc_dodge_left", "slip"],
	"weave": ["pro_left_weave", "pro_quick_weave", "pro_right_weave", "mc_dodge_right", "slip"],
	"pull": ["pro_back_dodge", "pro_back_weave", "pull"],
}
## S310: every take the library has, picked by the beat's roll (pick()).
const TIRED := ["pro_idle_tired", "pro_idle_slighty_tired", "pro_idle_really_tired_v1", "pro_idle_really_tired_v2", "mc_fidget"]
const WIN := ["pro_win_v1", "pro_win_v2", "pro_win_v3", "pro_win_v4", "pro_win_v5", "pro_win_v6", "pro_win_v7", "mc_win"]
## A standing count she beats, and a count she does not (KO). knockout_v6 gets back up (back_s 4.75): a count, not a KO.
const DOWN := ["pro_knockout_countdown_v1", "pro_knockout_countdown_v2", "pro_knockout_countdown_v3", "mc_knockout_count", "react_hurt"]
const OUT := ["pro_knockout_v1", "pro_knockout_v2", "pro_knockout_v3", "pro_knockout_v4", "pro_knockout_v5", "pro_knockout_v7",
	"pro_knockout_v8", "mc_knockout", "react_hurt"]

## S300 operator: "most moves seem in slow motion". Shipped timing (old repo UNDISPUTED_STUDY_S254.md, median clip-start ->
## impact over 3,152 Undisputed clips): jab 0.365 s, cross 0.501, hook 0.534, uppercut 0.489, body hook 0.450. A Pro punch
## plays fast enough to land on that beat (never slower than authored, at most 2x).
const IMPACT_S := {"jab": 0.365, "cross": 0.501, "lead_hook": 0.534, "rear_hook": 0.534, "lead_uppercut": 0.489,
	"rear_uppercut": 0.489, "body_hook": 0.450}
## Everything else from the Pro library (hit reactions, blocks, dodges) plays this much faster than authored.
const OTHER_SPEED := 1.25
## The guard every Pro clip starts and ends in: playing it between moves makes the joins seamless.
const GUARD := ["pro_idle", "idle"]

## S301 (operator after the second S300 film: "these still feel off"). tools/clip_recovery.gd measured every Pro clip on the
## game's body: at the S300 speeds the punching hand was back in guard 0.26-0.60 s after impact (Undisputed hands control
## back 0.11-0.17 s after impact) and each clip then stood on in guard to 1.0-1.6 s. Now the recovery (contact -> back in
## guard) plays fast enough to take the measured retraction of real boxers (old repo J28_HOW_FIGHT_MOVES_FLOW, Menzel et al.
## bag-punch phases: jab ~262 ms, cross / hook / uppercut ~168-171 ms), at most RECOVER_MAX x, and the clip hands over to
## the guard at back_s.
const RECOVERY_PATH := "res://assets/data/clip_recovery.json"
const RECOVER_JAB_S := 0.26
const RECOVER_S := 0.17
const RECOVER_MAX := 2.5

static var _contact: Dictionary = {}
static var _recovery: Dictionary = {}


## Vector2(contact_s, back_s) of a clip at 1x (clip_recovery.json); a negative value = not measured / never back in guard.
static func recovery(clip: String) -> Vector2:
	if _recovery.is_empty() and FileAccess.file_exists(RECOVERY_PATH):
		var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(RECOVERY_PATH))
		_recovery = parsed if parsed is Dictionary else {"_": {}}
	var row: Variant = _recovery.get(clip, null)
	if not row is Dictionary:
		return Vector2(-1.0, -1.0)
	return Vector2(float((row as Dictionary).get("contact_s", -1.0)), float((row as Dictionary).get("back_s", -1.0)))


## S305 (operator: "reaction is way too slow"): a hit reaction reaches its furthest point REACT_PEAK_S after the blow (K51:
## the head and body move in the first quarter-second; research G147: reactions on the blow, <=150 ms in), then recovers at
## the clip's own pace. The clip's peak comes from clip_recovery.json "peak_s" (1x).
const REACT_PEAK_S := 0.22
const REACT_FAST_MAX := 2.5


## Seconds into `clip` (1x) of its furthest point from the guard; -1 when not measured.
static func peak(clip: String) -> float:
	recovery(clip)
	var row: Variant = _recovery.get(clip, null)
	return float((row as Dictionary).get("peak_s", -1.0)) if row is Dictionary else -1.0


## The speed a reaction plays at until its peak: its peak lands REACT_PEAK_S after the blow, never slower than `speed`.
static func react_fast(clip: String, speed: float) -> float:
	var pk := peak(clip)
	if pk <= 0.0:
		return speed
	return clampf(pk / REACT_PEAK_S, speed, REACT_FAST_MAX)


## How much faster than `speed` the recovery of `clip` plays (1.0 when there is no measured contact and back).
static func recover_scale(clip: String, speed: float) -> float:
	var r := recovery(clip)
	if r.x < 0.15 or r.y <= r.x or speed <= 0.0:
		return 1.0
	return clampf((r.y - r.x) / speed / (RECOVER_JAB_S if clip.contains("jab") else RECOVER_S), 1.0, RECOVER_MAX)


## Playback speed for `clip` thrown as beat `move`.
static func speed(clip: String, move: String) -> float:
	if not clip.begins_with("pro_"):
		return 1.0
	if not IMPACT_S.has(move):
		return OTHER_SPEED
	return clampf(contact(clip, float(IMPACT_S[move])) / float(IMPACT_S[move]), 1.0, 2.0)


## The first name in `names` that `has` (a Callable(name) -> bool, e.g. stage.has_move) says exists, or "".
static func first(names: Array, has: Callable) -> String:
	for n in names:
		if has.call(str(n)):
			return str(n)
	return ""


## The clip for a punch beat. ctx: {"big", "miss", "tired", "step": bool, "roll": 0..1}. The body shot's big version is
## the kidney shot; the others take their _special / _hard take.
static func punch(move: String, ctx: Dictionary, has: Callable) -> String:
	if not PUNCH.has(move):
		return move
	var stem := "pro_" + str(PUNCH[move][0])
	var plain: Array = PUNCH[move][1]
	var take := stem + str(plain[mini(plain.size() - 1, int(float(ctx.get("roll", 0.0)) * plain.size()))])
	var names: Array = []
	var step := bool(ctx.get("step", false))
	if bool(ctx.get("big", false)):
		names = ["pro_kidney_shot"] if move == "body_hook" else ([stem + "_hard_ft"] if step else []) + [stem + "_special", stem + "_hard"]
	elif bool(ctx.get("miss", false)):
		names = [stem + "_miss"]
	elif bool(ctx.get("tired", false)):
		names = [stem + ("_hurt_ft" if step else "_hurt")]
	elif step:
		names = [stem + "_ft"]
	names.append_array([take, stem, str(PUNCH[move][2])])
	names = names.filter(func(n): return not OFF_TAKES.has(n))
	var got := first(names, has)
	return got if got != "" else move


## S310: one of `names` that exists, chosen by roll 0..1 (the Punch Pro takes first; the fallbacks only when none exists).
static func pick(names: Array, has: Callable, roll: float) -> String:
	var got: Array = names.filter(func(n): return str(n).begins_with("pro_") and has.call(str(n)))
	if got.is_empty():
		return first(names, has)
	return str(got[clampi(int(roll * got.size()), 0, got.size() - 1)])


## The hit reaction: by the punch, the knockback ("hurt") or the big shot to the head; roll picks the take.
static func react(move: String, hurt: bool, has: Callable, roll: float = 0.0, big: bool = false) -> String:
	if big and not hurt and move != "body_hook":
		return pick(BIG_REACT, has, roll)
	return pick(REACT["hurt" if hurt else (move if REACT.has(move) else "jab")], has, roll)


## The measured row of a clip (clip_contact.json): contact_s, hand, reach_m, length_s; {} when not measured.
static func contact_row(clip: String) -> Dictionary:
	contact(clip, 0.0)
	var row: Variant = _contact.get(clip, null)
	return row if row is Dictionary else {}


## Seconds into `clip` when the glove lands: the measured value, else `fallback`.
static func contact(clip: String, fallback: float) -> float:
	if _contact.is_empty() and FileAccess.file_exists(CONTACT_PATH):
		var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(CONTACT_PATH))
		_contact = parsed if parsed is Dictionary else {"_": {}}
	var row: Variant = _contact.get(clip, null)
	var t: float = float((row as Dictionary).get("contact_s", fallback)) if row is Dictionary else fallback
	# A measured contact in the first 0.15 s is the guard, not the punch (pro_left_uppercut reads 0.0): keep the fallback.
	return t if t >= 0.15 else fallback


## S319 SHOVEL1: the glove's path to contact, [[t_s, cum_m], ..] relative to the hips (clip_travel.json); [] when not measured.
const TRAVEL_PATH := "res://assets/data/clip_travel.json"
static var _travel: Dictionary = {}
static func travel_path(clip: String) -> Array:
	if _travel.is_empty() and FileAccess.file_exists(TRAVEL_PATH):
		var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(TRAVEL_PATH))
		_travel = parsed if parsed is Dictionary else {"_": {}}
	var row: Variant = _travel.get(clip, null)
	return (row as Dictionary).get("path", []) if row is Dictionary else []
