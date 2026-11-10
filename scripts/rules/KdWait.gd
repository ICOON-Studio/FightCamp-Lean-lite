extends RefCounted
## S422 (seen S421: "the knockdown count waits on the replay with no time limit"). When KnockdownCount may start the count:
## down_s after the fall, after the slow-motion replay, or REPLAY_LATE_S past that when a due replay never began (its recorder
## stopped). A replay begins within KnockdownReplay.LIVE_AFTER_S (2.3 s) of the shot, and the count pauses with the tree while
## one plays, so `wait` grows only while none does: the limit never cuts a playing replay. Pure static; zero preloads.

const REPLAY_LATE_S := 4.0


static func count_ready(wait: float, fall_in: float, down_s: float, replay_due: bool, replay_active: bool) -> bool:
	if wait < fall_in + down_s or replay_active:
		return false
	return not replay_due or wait >= fall_in + down_s + REPLAY_LATE_S
