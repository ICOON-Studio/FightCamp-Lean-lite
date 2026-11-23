extends RefCounted
## S523 TURNPRO1 (the promoter's lean on the first six pro offer sets), CUT by S543 TURNPROBUILD17 (turning pro v17, map
## DESIGN_TURNPRO1_V17.md section 6: one promoter, no houses, no softer-opponent ask). Pro fights 1-6 are now the SAFE /
## RISKY pair (ProPair); from fight 7 ProLadder._make_offers books as before. extra() stays as a pass-through so ProLadder
## is untouched (its call site is in the normal booking, which v17 keeps as it was).

const LEAN_FIGHTS := 6   ## the two-bout fights (mirrors ProStart.FIGHTS; tools/turnprobe17.gd reads it)


static func extra(_f: Dictionary, out: Array, _tunes: Array, _steps: Array, _no_step: bool, _until: int, _tape: Array,
		_tune_aim: float, _step_aim: float) -> Array:
	return out


static func pro_fights(f: Dictionary) -> int:
	return int(f.get("pro_w", 0)) + int(f.get("pro_l", 0)) + int(f.get("pro_d", 0))
