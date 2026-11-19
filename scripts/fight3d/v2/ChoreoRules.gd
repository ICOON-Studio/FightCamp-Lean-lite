extends RefCounted
## FIGHTPLAYER2 phase 2 (FP2CHOREO1): constants table and small pure helpers for the choreographer.
## No class_name, no scene preload. Pure module.

const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const ClipCensus := preload("res://scripts/fight3d/v2/ClipCensus.gd")

# --- Distance (REFERENCE_DISTANCES_S439, scope 8) ---
## S525 (both blind critics on both v2 films put RANGE first): rest was 1.7 m, heads 1.61 m apart. Their bar: heads
## 1.3-1.6 m, 40-60 cm of air between the lead gloves, lead feet about 1.1 m apart = 1.55 m between the hips here.
## S529 (film 6, both critics' first or fifth item again: "they wait at a distance nobody fights from", lead gloves
## "a full body apart"; the stance ruler: nearest wrists 0.82 m, front feet 1.09 m at 1.55): the edge of range is
## lead gloves 30-50 cm apart, front feet 0.9-1.1 m = 1.32 m here, one 25 cm step from the longest jab.
const REST_M := 1.32          # rest: just out of reach
const CREEP_M := 1.2          # the round script's own step in (pressure): still out of reach, a jab and half a step from landing
const MIN_GAP_M := 0.45       # never closer than this
const GAP_SPEED_MPS := 1.6    # max gap change rate (a step pair is 0.55-0.60 s)
const BURST_GAP_S := 2.2      # contacts closer than this are one burst: the pair stays in range between them
const OWN_GAP_S := 0.12        # one boxer's own contacts are at least this far apart (two hands, one body)
const KNOCK_FREE_S := 0.5      # a reaction travels unless another punch is due within this (S525: was 1.0 - with the step out and the pocket planned, a follow-up half a second later steps back in)
const LEAVE_S := 1.5          # back at rest within this after a burst's last contact

# --- Fit (scope 3c, ClipCensus) ---
const FIT_M := ClipCensus.FIT_M  # 0.15 (half of Undisputed's 0.30 m arm IK budget)
const IK_MAX_M := 0.30        # arm IK budget (Undisputed)
const HOOK_FIT_M := 0.05      # hooks, uppercuts, body shots get no IK

# --- Timing (UNDISPUTED_STUDY_S254) ---
const SLIDE_MAX_S := 0.25     # max contact slide for stun avoidance
const CONTROL_S := 0.13       # control back after contact (Undisputed 0.11-0.17)
const SAME_HAND_S := 0.04      # the same hand again starts this long after control is back (S531)
const PULL_ALONE_S := 0.9       # a plain miss is pulled from only when no punch follows inside this (S531)
const WIND_MIN_S := 0.12      # a take never starts later than this before its contact
## ... a hook, an uppercut or a body shot not later than this (S525, film 3 and 4: a hook thrown second in a
## combination started 0.12 s before its contact, so the take's whole hip turn - 80-110 deg - was joined in three
## frames: "blue spins and shows his back"). It cuts the first punch's way home a little sooner instead.
const WIND_TURN_S := 0.26
## S526 a defence starts this long before the punch it answers lands, part-way into its take (its head still off the
## line on the blow). The dodge and weave takes take 0.43-0.93 s to their furthest point: started from their first
## frame the man ducked before the punch was thrown at all, which reads as bobbing, not as a read (both critics on
## film 4: "each starts 4-6 frames before the punch lands"; 10 frames here - the owned takes travel 30-70 cm).
const DEF_LEAD_S := 0.33
## S526 THE ARM COMES HOME (both critics on films 3 and 4: "the glove leaves the target in 1-2 frames and is back at
## the chin by frame 6"; it stayed out 8-15 frames). The bought takes bring the hand back 0.3-0.5 s after the contact
## (a hook 0.6-1.4 s: clip_db home_s). A punch take is handed back to the guard this long after its contact - a
## straight at once, a hook, an uppercut or a body shot after its follow-through - and the join brings the hand home.
const ARM_HOME_S := 0.07
const ARM_HOME_TURN_S := 0.14


static func arm_home_s(move: String) -> float:
	return ARM_HOME_S if is_straight(move) else ARM_HOME_TURN_S


# --- Stun durations by reaction size (scope 3d) ---
const STUN_S := {"light": 0.40, "medium": 0.60, "heavy": 0.80}

# --- Head clearance (scope 3d) ---
const HEADS_APART_M := 0.25   # min gap - head_fwd_m - head_from_hips at every contact

# --- Range in HEAD distance (S525, cause a of both v2 films' first fault: "they fight at hugging distance") ---
## The plan's gap is hips to hips from where the puncher STARTS; the heads are closer by the lean of his take
## (clip_db head_fwd_m: 0-0.26 m) and by the other man's own head, which sits this far in front of his hips in the guard.
const VICTIM_HEAD_FWD_M := 0.02
## How far apart the HEADS are at the contact, at least, by the kind of punch (the critics' bars, first film: straights
## 0.8-1.1 m, hooks 0.5-0.85, uppercuts and body hooks 0.55-0.65; under 0.45 = a tie-up, which we own no take for).
const HEAD_FLOOR_M := {"straight": 0.80, "hook": 0.58, "upper": 0.60, "body": 0.58}
## A landed punch may be planned this much further out than its take's own distance to keep that floor: the one arm
## finish (PunchAim, 0.30 m at most) carries the glove the rest of the way. A take that would need more is SHORT: it
## plays only when its family owns nothing longer.
## The body shot reaches furthest: the one fresh take owned dives the puncher's head to the other man's belt (heads
## 0.34-0.47 m apart on the second film); a straighter arm to the ribs from further out is a real punch.
const REACH_M := {"straight": 0.10, "hook": 0.06, "upper": 0.08, "body": 0.14}

# --- Join times (scope 3d) ---
const JOIN_S := {"punch": 0.15, "reaction": 0.05, "defence": 0.15, "block": 0.05, "guard": 0.30}

# --- Pivot and quiet (scope 3d) ---
const PIVOT_EVERY_S := 25.0   # at least one pivot event every this long
const QUIET_MIN_S := 1.2      # minimum quiet spell for a pivot

# --- Body movement (scope 3d) ---
const WHOLE_BODY_HIPS_M := 0.15  # reaction whose hips_max_m >= this is whole-body

# --- Move categories ---
const PUNCH_MOVES := ["jab", "cross", "lead_hook", "rear_hook", "lead_uppercut", "rear_uppercut", "body_hook"]
const STRAIGHTS := ["jab", "cross"]
const LEFT_HAND_MOVES := ["jab", "lead_hook", "lead_uppercut", "body_hook"]
const PASS_MOVES := ["clinch", "count", "tired", "inside"]


static func is_punch(move: String) -> bool:
	return move in PUNCH_MOVES


static func is_straight(move: String) -> bool:
	return move in STRAIGHTS


static func is_left_hand(move: String) -> bool:
	return move in LEFT_HAND_MOVES


static func range_kind(move: String) -> String:
	if move in STRAIGHTS:
		return "straight"
	if move == "body_hook":
		return "body"
	return "upper" if move.ends_with("uppercut") else "hook"


## How much further out than the take's own distance `own_gap` (hips to hips, its miss or block offset in) a punch is
## planned so the heads keep their floor. `lands`: capped by the arm's reach; a miss or a block is not.
static func head_extra(move: String, own_gap: float, head_fwd: float, lands: bool) -> float:
	var k := range_kind(move)
	var short := float(HEAD_FLOOR_M[k]) - (own_gap - head_fwd - VICTIM_HEAD_FWD_M)
	return clampf(short, 0.0, float(REACH_M[k]) if lands else 0.6)


## A take is SHORT for a landed punch when even the full reach leaves the heads under the floor.
static func is_short(move: String, own_gap: float, head_fwd: float) -> bool:
	var k := range_kind(move)
	return own_gap - head_fwd - VICTIM_HEAD_FWD_M + float(REACH_M[k]) < float(HEAD_FLOOR_M[k]) - 0.02


static func gap_fit_for(move: String) -> float:
	return FIT_M if is_straight(move) else HOOK_FIT_M


static func impact_s_for(move: String) -> float:
	if BeatClips.IMPACT_S.has(move):
		return float(BeatClips.IMPACT_S[move])
	return 0.45


## Reaction size by the punch: jab light; cross/hooks/uppercuts medium; big head shots heavy; body_hook medium (gutshot).
## S513 (the first v2 film, both blind critics: "the man who is hit barely moves"; the rulers: the head's furthest
## point 15+ frames after the contact): a bought reaction takes 0.2-1.3 s to reach its furthest point. It starts
## part-way in, so the head is furthest REACT_PEAK_S after the glove lands (the join smoother makes the snap).
## S529: 0.13 -> 0.10 - the reaction now starts one picture after the contact (Player2._late) and joins a little slower:
## the head is still furthest 3 pictures after the glove lands (0.10 read 4 on the 30-a-second film).
const REACT_PEAK_S := 0.08
## S530: a body shot FOLDS a man over 5-6 pictures (30-50 cm: at the head's 3 pictures that is 20 cm in one).
const REACT_FOLD_S := 0.17
## S530 NO HEAD OVER THE BAR IN ONE PICTURE (ChoreoReact.start_s): the most a hit head may go over the hips in one film
## picture (the critics' bar is 10 cm with the body's own step back in it), and how much of the way the join has
## gone after 1, 2, 3 ... pictures, 30 pictures a second: "quick" = Player2.JOIN "reaction" 0.04 / 0.12, "snap" = JOIN_SOFT
## 0.025 / 0.20, "fold" = JOIN_FOLD 0.05 / 0.22, "defence" = JOIN "defence" 0.05 / 0.15 (change a join and its way together).
const HEAD_STEP_MAX_M := 0.085
const FILM_HZ := 30.0
const JOIN_WAY := {"quick": [0.26, 0.76, 1.0], "snap": [0.26, 0.65, 0.88, 0.98], "fold": [0.10, 0.36, 0.65, 0.86, 0.97],
	"defence": [0.15, 0.54, 0.875, 1.0], "punch": [0.15, 0.54, 0.875, 1.0]}
const CUT_STEP_MAX_M := 0.06      # a punch started part-way in (a combination's next): its head's step a picture, at most
const CUT_SLIDE_S := 0.10         # ... it lands this much later at most to start earlier in its take
const WEAVE_STRAIGHT := "pro_quick_weave"   # the weave under a jab or a cross (ChoreoReact.defence)
## S530: a weave or a slip that does not step is a U of 8-12 pictures (the coach's bar; the bought takes come up over
## 12-14 more): he is handed back to the guard this long after his head's lowest point and the guard's join brings him up.
const DEF_UP_S := 0.20
const DEF_EARLY_S := 0.15         # a defence may start this much sooner than DEF_LEAD_S to play more of its take
const REACT_VARY_SCORE := 0.30
## S526 SIZED TO THE PUNCH (four films, both critics, item 1 every time): how far the hit head should travel against
## his own body, by the punch (their asks: jab 10-12 cm, cross 20-25, hook 25-30, uppercut 15-20, a body shot a fold
## of 30-50). The reaction take whose own head travel (clip_db head_rel_m) is nearest plays; a big shot asks more.
## (The film's ruler reads about 0.8 of a take's head_rel_m, so the asks sit a little over the critics' numbers.)
const REACT_HEAD_M := {"jab": 0.15, "cross": 0.24, "lead_hook": 0.24, "rear_hook": 0.24, "lead_uppercut": 0.18,
	"rear_uppercut": 0.18, "body_hook": 0.30}
const REACT_BIG := 1.4
const REACT_VARY_M := 0.045       # takes this near the best fit share the punch (variety)
## The census drops a reaction whose face tips up over 15 deg ("face to the lights", r14). A head snapped back by a
## cross, a hook or an uppercut tips up by its nature: for those punches a take dropped ONLY for that, up to this, plays.
const REACT_FACE_UP_OK_DEG := 30.0
## Takes that build too slowly to read as a hit: the head is furthest 9 frames after the blow wherever the take is
## started from (measured on the bout, s525/h; the critics' bar is 2-3). They play only when nothing else fits.
const REACT_SLOW := ["pro_hit_by_jab_v1"]
## S529: 0.45 -> 0.32 (film 6, both critics: after the hit both gloves "drop and splay to his chest and hip for 6
## frames" - the reaction takes' own tails; their bar: the guard back up in 6-10 pictures).
const REACT_TAIL_S := 0.32        # a reaction hands back to the guard this long after its head's furthest point
const REACT_STAGGER_S := 1.0      # ... a body shot's after its stagger, this long at most


static func react_peak_s(move: String) -> float:
	return REACT_FOLD_S if move == "body_hook" else REACT_PEAK_S


static func react_head_m(move: String, big: bool) -> float:
	return float(REACT_HEAD_M.get(move, 0.15)) * (REACT_BIG if big else 1.0)


static func react_size_for(move: String, big: bool) -> String:
	if big and move != "body_hook":
		return "heavy"
	if move == "jab":
		return "light"
	return "medium"


static func stun_for(size: String) -> float:
	return float(STUN_S.get(size, 0.40))


static func join_for(kind: String) -> float:
	return float(JOIN_S.get(kind, 0.15))
