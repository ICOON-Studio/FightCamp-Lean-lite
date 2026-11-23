extends RefCounted
## S539 REPEATBITE2 greybox rule (probe copy; the game is untouched). Builds on tools/repeatbite1_rules.gd (P2: the read
## follows the PLAN's own lines, the count carries across rounds and fades 1 at each bell, night k's opponent filmed night
## k-1 and starts with that bout's top line half-read, read at 2 throws, one sooner v a ring-smart opponent).
## Two refinements named by docs/REPEATBITE1_RESULT.md, probed separately and together:
##   R1 SAME SITUATION: a line counts toward the read per situation - the read key is move + situation ("every time I press,
##      she throws the one-two"). A spread plan's lines that share a move across situations no longer pile on one count.
##   R2 WON USES: only a use that WON the exchange counts toward the read (an opponent studies what hurts him).
## Pure static, zero game preloads. Counter numbers are repeatbite1_rules.gd's, unchanged.

## The read key of one planned throw.
static func key(move: String, sit: String, r1: bool) -> String:
	if move == "":
		return ""
	return "%s@%s" % [move, sit] if r1 else move


## True when this use adds to the read's count.
static func counts_toward(won: bool, r2: bool) -> bool:
	return won or not r2
