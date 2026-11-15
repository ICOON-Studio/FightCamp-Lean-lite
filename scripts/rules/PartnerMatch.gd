extends RefCounted
## PARTNERMATCH1 (map DESIGN_AMATEURWEEK1_V9_REVISE_KALLI_KALLI section 4.1 "CHOOSE A SPARRING PARTNER"):
## how well a sparring partner matches the coming opponent. The partner's match decides how many plan
## lines the night readies and the round-1 edge. Pure static functions, no class_name, no preload,
## no game state.
##
## A person (partner or opponent) is a Dictionary:
##   {"sex": "f"|"m", "div_kg": float, "style": String ("" = unknown),
##    "stance": "orthodox"|"southpaw"|"" (unknown), "reach_cm": float (0 = unknown),
##    "level": int (a rating, 0 = unknown), "tells": Array of String (tell ids)}
## The opponent holds only what is KNOWN: unknown style is "", unknown reach is 0, and "tells"
## holds only the FILMED tells.
##
##   points(partner, opp)                            -> {"total", "style", "stance", "reach", "tells"}
##   word(total)                                     -> "CLOSE" / "PART" / "LOOSE"
##   best_possible(opp)                              -> the most points any partner could score
##   needs_film(opp)                                 -> true when the best match possible is under CLOSE
##   level_word(partner_level, boxer_level)          -> "above" / "level" / "below"
##   night(partner, opp, boxer_level, picked_lines)   -> what the screen and the fight week need
##   listable(partner, boxer)                        -> same sex and within one class
##   cost(partner_club_is_ours, favours, cash)       -> {"cash", "favour_ok", "payable", "reason"}
##   rank(partners, opp)                             -> partner indices, best match first (stable)

## Points for each known fact a partner shares with the opponent (ESTIMATE, from the map).
const PT_STYLE := 2
const PT_STANCE := 1
const PT_REACH := 1
const PT_TELL := 1
## A reach this close (cm) counts as the same size.
const REACH_CLOSE_CM := 5.0
## CLOSE 5+, PART 3-4, LOOSE 0-2.
const CLOSE_MIN := 5
const PART_MIN := 3
## Plan lines the night readies (never more than the lines the player picked).
const LINES := {"CLOSE": 3, "PART": 2, "LOOSE": 1}
## The edge against this opponent in rounds 1-2 (S482: bout.spar_edge; PARTNERPROBE1 sized it - docs/PARTNERPROBE1_RESULT.md).
const EDGE := {"CLOSE": 2.5, "PART": 1.25, "LOOSE": 0.0}   # S482 PARTNERPROBE1 paired, rounds 1-2: close vs loose +3.7 / +5.3 in 100 (seeds 4801/4802)
## A partner more than 5 levels above the boxer is "above", more than 5 below is "below".
const LEVEL_GAP := 5
## "Above": the night's injury risk.
const INJURY_ABOVE := 1.15
## A partner at another club: the camp's outside partner fee in dollars, or 1 favour.
const OUTSIDE_FEE := 160
## A partner one class away is within this many kg of the boxer.
const CLASS_GAP_KG := 7.5


## The partner's match points against only what is known: a fact scores only when both sides know it.
## {"total", "style" (0 or 2), "stance" (0 or 1), "reach" (0 or 1), "tells" (0..n)}.
static func points(partner: Dictionary, opp: Dictionary) -> Dictionary:
	var p_style: String = str(partner.get("style", ""))
	var o_style: String = str(opp.get("style", ""))
	var style_pt := 0
	if p_style != "" and o_style != "" and p_style == o_style:
		style_pt = PT_STYLE
	var p_stance: String = str(partner.get("stance", ""))
	var o_stance: String = str(opp.get("stance", ""))
	var stance_pt := 0
	if p_stance != "" and o_stance != "" and p_stance == o_stance:
		stance_pt = PT_STANCE
	var p_reach: float = float(partner.get("reach_cm", 0.0))
	var o_reach: float = float(opp.get("reach_cm", 0.0))
	var reach_pt := 0
	if p_reach > 0.0 and o_reach > 0.0 and absf(p_reach - o_reach) <= REACH_CLOSE_CM:
		reach_pt = PT_REACH
	var p_tells: Array = partner.get("tells", [])
	var o_tells: Array = opp.get("tells", [])
	var counted: Array = []
	var tell_pt := 0
	for raw in o_tells:
		var tell_id := str(raw)
		if tell_id == "" or counted.has(tell_id):
			continue
		if p_tells.has(tell_id):
			counted.append(tell_id)
			tell_pt += PT_TELL
	return {
		"total": style_pt + stance_pt + reach_pt + tell_pt,
		"style": style_pt,
		"stance": stance_pt,
		"reach": reach_pt,
		"tells": tell_pt,
	}


## The match word: "CLOSE" at CLOSE_MIN and up, "PART" at PART_MIN and up, else "LOOSE".
static func word(total: int) -> String:
	if total >= CLOSE_MIN:
		return "CLOSE"
	if total >= PART_MIN:
		return "PART"
	return "LOOSE"


## The most points any partner could score against what is known about the opponent
## (2 for a known style + 1 for a known stance + 1 for a known reach + the filmed tells).
## With no filmed tell and everything else known this is 4, so the best match is PART.
static func best_possible(opp: Dictionary) -> int:
	var total := 0
	if str(opp.get("style", "")) != "":
		total += PT_STYLE
	if str(opp.get("stance", "")) != "":
		total += PT_STANCE
	if float(opp.get("reach_cm", 0.0)) > 0.0:
		total += PT_REACH
	var counted: Array = []
	for raw in opp.get("tells", []):
		var tell_id := str(raw)
		if tell_id == "" or counted.has(tell_id):
			continue
		counted.append(tell_id)
		total += PT_TELL
	return total


## True when the best match possible is still under CLOSE: the screen says "film a tell to find a
## closer partner".
static func needs_film(opp: Dictionary) -> bool:
	return best_possible(opp) < CLOSE_MIN


## "above" when the partner is more than LEVEL_GAP above the boxer, "below" when more than LEVEL_GAP
## below, else "level". An unknown level (0) on either side is "level".
static func level_word(partner_level: int, boxer_level: int) -> String:
	if partner_level <= 0 or boxer_level <= 0:
		return "level"
	if partner_level > boxer_level + LEVEL_GAP:
		return "above"
	if partner_level < boxer_level - LEVEL_GAP:
		return "below"
	return "level"


## Everything the partner screen and the fight week need from one partner against one opponent:
## {"points", "word", "lines", "edge", "injury_mult", "flatters", "beats_it_known", "test_likely"}.
## Lines readied are the match word's lines, never more than the lines the player picked.
static func night(partner: Dictionary, opp: Dictionary, boxer_level: int, picked_lines: int) -> Dictionary:
	var scored := points(partner, opp)
	var total: int = int(scored.get("total", 0))
	var match_word := word(total)
	var level := level_word(int(partner.get("level", 0)), boxer_level)
	var ready_lines := mini(int(LINES.get(match_word, 1)), picked_lines)
	return {
		"points": total,
		"word": match_word,
		"lines": ready_lines,
		"edge": float(EDGE.get(match_word, 0.0)),
		"injury_mult": INJURY_ABOVE if level == "above" else 1.0,
		"flatters": level == "below",
		"beats_it_known": match_word != "LOOSE",
		"test_likely": match_word == "PART",
	}


## The partner list holds the same sex only (females never spar males here) and partners within one
## class of the boxer: absf(partner.div_kg - boxer.div_kg) <= CLASS_GAP_KG.
static func listable(partner: Dictionary, boxer: Dictionary) -> bool:
	var p_sex: String = str(partner.get("sex", ""))
	var b_sex: String = str(boxer.get("sex", ""))
	if p_sex == "" or b_sex == "" or p_sex != b_sex:
		return false
	var p_div: float = float(partner.get("div_kg", 0.0))
	var b_div: float = float(boxer.get("div_kg", 0.0))
	return absf(p_div - b_div) <= CLASS_GAP_KG


## What the partner costs: our own club is free; another club is OUTSIDE_FEE cash or 1 favour with
## that host. {"cash", "favour_ok", "payable", "reason"}; reason is "" when payable.
static func cost(partner_club_is_ours: bool, favours_with_club: int, cash: int) -> Dictionary:
	var favour_ok := favours_with_club > 0
	if partner_club_is_ours:
		return {"cash": 0, "favour_ok": favour_ok, "payable": true, "reason": ""}
	var payable := favour_ok or cash >= OUTSIDE_FEE
	var reason := ""
	if not payable:
		# No favour to spend and not enough cash: the cash is what stops it.
		reason = "cash under $160" if not favour_ok else "no favours with this host"
	return {"cash": OUTSIDE_FEE, "favour_ok": favour_ok, "payable": payable, "reason": reason}


## The partners' indices sorted by their match points, highest first; ties keep the input order.
static func rank(partners: Array, opp: Dictionary) -> Array:
	var totals: Array = []
	for partner in partners:
		totals.append(int(points(partner, opp).get("total", 0)))
	var order: Array = []
	for _row in partners.size():
		var best := -1
		for j in partners.size():
			if order.has(j):
				continue
			if best == -1 or int(totals[j]) > int(totals[best]):
				best = j
		if best == -1:
			break
		order.append(best)
	return order
