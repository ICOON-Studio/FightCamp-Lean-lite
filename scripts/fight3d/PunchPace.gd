extends RefCounted
## POWER1 step 3 (owner S439: "the punches do not feellike the y have power"; CROSS_POWER_S439.md fix 2: the glove's
## striking face topped out at 4.4-5.8 m/s on screen, below the slowest real cross, 6 m/s; CLIP_CRITICS_S439.md: 0.3-0.7 s
## of near-stillness before the hand moves on several clips). How a punch clip is paced on screen:
##   1. its START: a clip with dead wind-up starts later (BeatClips.start_s, measured by tools/punch_pace.gd: the hand moves
##      KEEP_S after the start, never where the trunk already loads). The take itself is never edited.
##   2. its DRIVE (review round 2: the punching ARM only, ReachDrive.gd): the body plays at its pace (BeatClips.speed);
##      the landing reach holds the glove a little off the target, then drives it on over the last DRIVE_S, arriving at
##      the contact at BeatClips.drive_v (screen m/s). The contact stays the clip's, so the drive moves no timer.
##   3. the beat's TIMING: what the later start saves, the boxer stands that much longer in her guard first (BeatFire), so
##      the hit, the sound, the reaction and the combo rhythm the round script hands the 3D side land when they did.
##      3D only: no rule is read or changed.
## `-- nofastdrive` = the control arm (start 0, no arm drive, the hit's timer on the contact as before).
##   plan(clip, move) -> {clip, start, sp, c, v}   real(p, from, to)   lead()   arm(stage, who, p)

const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const CONTACT_FALLBACK := {"jab": 0.27, "cross": 0.35, "lead_hook": 0.45, "rear_hook": 0.45, "lead_uppercut": 0.45,
	"rear_uppercut": 0.45, "body_hook": 0.70}

static var on: bool = not OS.get_cmdline_user_args().has("nofastdrive")
## The hit's timer fires LEAD_S (one frame at 60 fps) before the clip reaches its contact: the timer fires before that
## frame's step and the hit-stop then holds the clip, so a clip already on its contact froze on the frame before it
## (hit_carry_test: the glove arrived at 8-27 % of its speed). One frame short, HitImpact.hit puts it on its contact and
## the hit frame draws the last of the drive.
const LEAD_S := 1.0 / 60.0
## The drive's time on screen (ReachDrive): from the hold onto the target, speeding up all the way (a real cross covers its
## last ~0.35 m in 80-100 ms, CROSS_POWER_S439.md; 0.08 s = about five frames).
const DRIVE_S := 0.08


static func lead() -> float:
	return LEAD_S if on else 0.0


static func is_on() -> bool:
	return on


static func set_on(v: bool) -> void:
	on = v


## The punch's pace: where it starts (clip s), its pace (BeatClips.speed), its contact (clip s), its drive's end speed (v).
static func plan(clip: String, move: String, contact: float = -1.0) -> Dictionary:
	var c := contact if contact >= 0.0 else BeatClips.contact(clip, float(CONTACT_FALLBACK.get(move, 0.35)))
	var p := {"clip": clip, "start": 0.0, "sp": BeatClips.speed(clip, move), "c": c, "v": 0.0}
	if on and clip.begins_with("pro_"):
		p["start"] = clampf(BeatClips.start_s(clip), 0.0, maxf(0.0, c - 0.15))
		p["v"] = BeatClips.drive_v(clip)
	return p


## Screen seconds from clip time `from` to `to` under plan p (the body plays at its pace; the drive moves no time).
static func real(p: Dictionary, from: float, to: float) -> float:
	return maxf(0.0, to - from) / maxf(0.01, float(p["sp"]))


## `who` has just started p's clip (FightStage.play): pose its first frame; the reach she lands or blocks it with drives
## the glove at p's end speed (PunchReach takes it when FightStage.land / arm_block arms that clip).
static func arm(st: Node, who: int, p: Dictionary) -> void:
	# A clip started at 0 (FightStage.play seeks only a later start) stood still on its first drawn frame, a frame behind a
	# clip started part-way. Posed now, every punch steps from its first frame, and the hit's timer leads it by LEAD_S.
	var ap: AnimationPlayer = st.boxers[who]["ap"]
	if on and str(ap.current_animation) == str(p.get("clip", "")) and ap.current_animation_position <= 1e-6:
		ap.seek(0.0, true)
	var pr: Node = st.boxers[who].get("reach")
	if pr != null:
		var sp := maxf(0.01, float(p["sp"]))
		pr.set("drive_for", [str(p.get("clip", "")), float(p.get("v", 0.0)) / sp if on else 0.0, DRIVE_S * sp])
