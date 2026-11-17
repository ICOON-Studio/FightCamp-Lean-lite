extends RefCounted
## FIGHTPLAYER2 phase 2 (FP2CHOREO1): constants table and small pure helpers for the choreographer.
## No class_name, no scene preload. Pure module.

const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const ClipCensus := preload("res://scripts/fight3d/v2/ClipCensus.gd")

# --- Distance (REFERENCE_DISTANCES_S439, scope 8) ---
const REST_M := 1.7           # rest out of reach (1.6-1.8)
const CREEP_M := 1.4          # close range, inside punching distance
const MIN_GAP_M := 0.45       # never closer than this
const GAP_SPEED_MPS := 1.6    # max gap change rate (a step pair is 0.55-0.60 s)
const BURST_GAP_S := 2.2      # contacts closer than this are one burst: the pair stays in range between them
const OWN_GAP_S := 0.12        # one boxer's own contacts are at least this far apart (two hands, one body)
const KNOCK_FREE_S := 1.0      # a reaction travels only when no other punch is due within this (the last of a combination)
const LEAVE_S := 1.5          # back at rest within this after a burst's last contact

# --- Fit (scope 3c, ClipCensus) ---
const FIT_M := ClipCensus.FIT_M  # 0.15 (half of Undisputed's 0.30 m arm IK budget)
const IK_MAX_M := 0.30        # arm IK budget (Undisputed)
const HOOK_FIT_M := 0.05      # hooks, uppercuts, body shots get no IK

# --- Timing (UNDISPUTED_STUDY_S254) ---
const SLIDE_MAX_S := 0.25     # max contact slide for stun avoidance
const CONTROL_S := 0.13       # control back after contact (Undisputed 0.11-0.17)
const WIND_MIN_S := 0.12      # a take never starts later than this before its contact

# --- Stun durations by reaction size (scope 3d) ---
const STUN_S := {"light": 0.40, "medium": 0.60, "heavy": 0.80}

# --- Head clearance (scope 3d) ---
const HEADS_APART_M := 0.25   # min gap - head_fwd_m - head_from_hips at every contact

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
const REACT_PEAK_S := 0.13
const REACT_VARY_SCORE := 0.30


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
