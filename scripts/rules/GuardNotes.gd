extends RefCounted
## S526 guard v4 step 6 (DESIGN_GUARDDMG1_V4 s3 "Camp Screen": the amateur guard note + the opponent style warning).
## Only what the settled fight really does (GuardState / GuardWear): a presser or a loader who wins an exchange leaves
## you on your own ropes (PlanFight.LOST_CARD), where every block wears the guard WEAR_ROPES more; an amateur bout wears
## each block WEAR_AMATEUR more and a quiet exchange gives back RECOVER_QUIET_AMATEUR (pro RECOVER_QUIET).
## The habit lines live in OppFile.GUARD_NOTE (her file). Shown under COACH'S PICK on the Training tab (ClubWeek "guard" -> TrainSide;
## S527: THIS CAMP / WeekCamp sits in that tab's hidden Legacy box, so its copy is never seen).
##   style_warning(game) -> "" or one sentence    amateur_note(amateur) -> "" or one sentence    lines(game, amateur) -> Array

const GuardWear := preload("res://scripts/rules/GuardWear.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")


## game = her main game (OppFile.main_game / WeekOpp line "game").
static func style_warning(game: String) -> String:
	if str(PlanFight.LOST_CARD.get(game, "")) != "own_ropes":
		return ""
	return "Guard: lose an exchange to the opponent and you are on the ropes - there every block wears the guard %d%% more. Pivot or tie up." % roundi(GuardWear.WEAR_ROPES * 100.0)


static func amateur_note(amateur: bool) -> String:
	if not amateur:
		return ""
	# S533 GUARDREV5: was "a quiet exchange gives back", which one landed punch already stops.
	return "Amateur guard: each block wears it %d%% more; it comes back only when the opponent lands nothing (+%d, pro +%d)." % [
		roundi(GuardWear.WEAR_AMATEUR * 100.0), roundi(GuardWear.RECOVER_QUIET_AMATEUR), roundi(GuardWear.RECOVER_QUIET)]


static func lines(game: String, amateur: bool) -> Array:
	var out: Array = []
	for s in [style_warning(game), amateur_note(amateur)]:
		if str(s) != "":
			out.append(str(s))
	return out
