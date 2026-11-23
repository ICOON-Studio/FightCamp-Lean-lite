extends RefCounted
## DEBUTPICK1 (S533, owner Q-286 "Pick to each boxer"), SHRUNK by S543 TURNPROBUILD17 (turning pro v17): the two houses'
## aims, the matchmaker's misjudgement and the offer's words went with the houses (map section 6). What stays is the
## search: find the opponent's rating gap whose read sits nearest a wanted chance, through the read the booking shows (the
## caller passes it: ProPair reads the bout as it will be fought, confidence and all). The read rises with the gap (a weaker
## opponent), so the search halves the range and takes the nearer of the two neighbours. Pure static, no preloads.
##   search(read_of: Callable(gap) -> float, want, lo, hi) -> {gap, read}

const STEP := 0.1         ## DebutOpp snaps the rating to 0.1
const GAP_MIN := -10.0    ## a matchmaker finds an opponent from 10 rating points over the boxer...
const GAP_MAX := 25.0     ## ...to 25 under


static func search(read_of: Callable, want: float, gap_lo := GAP_MIN, gap_hi := GAP_MAX) -> Dictionary:
	var lo := roundi(gap_lo / STEP)
	var hi := roundi(gap_hi / STEP)
	while hi - lo > 1:
		var mid := (lo + hi) >> 1
		if float(read_of.call(float(mid) * STEP)) < want:
			lo = mid
		else:
			hi = mid
	var r_lo := float(read_of.call(float(lo) * STEP))
	var r_hi := float(read_of.call(float(hi) * STEP))
	var take_hi := absf(r_hi - want) <= absf(r_lo - want)
	return {"gap": snappedf(float(hi if take_hi else lo) * STEP, STEP), "read": r_hi if take_hi else r_lo}
