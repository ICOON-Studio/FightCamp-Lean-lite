extends RefCounted
## RIVALOFFER1 - Offers from rival gyms and the DUCKED / OWED flags.
## Source: ops/research/DESIGN_LADDER1_V6_DOLA.md lines 1047-1164 (R6, R9).
## All functions static. No class_name. No scene preloads.

const PASS_COST := 2
const COOLDOWN_WEEKS := 8
const OWED_SCORE := 95
const OWED_PAY := 3
const DUCK_WINDOW := 8
const DUCK_RANK_GAP := 8

## who_offers: the rival gym that rings this week, or {}.
## mine = {"rep": int, "free": bool}. Each rival = {"name", "rep", "last_offer_week", "booked"}.
## A rival may offer when: not booked, her rep < mine, mine is in her reach, cooldown elapsed.
## Of eligible: highest rep; ties by name (deterministic).
static func who_offers(mine: Dictionary, rivals: Array, week: int) -> Dictionary:
	var my_rep: int = int(mine.get("rep", 0))
	var best: Dictionary = {}
	var best_rep: int = -1
	var best_name: String = ""
	for r in rivals:
		var rname: String = str(r.get("name", ""))
		var rrep: int = int(r.get("rep", 0))
		var rbooked: bool = bool(r.get("booked", false))
		var rlast: int = int(r.get("last_offer_week", -1))
		if rbooked:
			continue
		if rrep >= my_rep:
			continue
		var LR := preload("res://scripts/rules/LadderRep.gd")
		if not LR.in_reach(rrep, my_rep):
			continue
		if rlast >= 0 and week - rlast < COOLDOWN_WEEKS:
			continue
		if rrep > best_rep or (rrep == best_rep and rname < best_name):
			best = r
			best_rep = rrep
			best_name = rname
	return best


## answer: process a choice ("accept" | "not_this_show" | "pass").
## state = {"free": bool, "not_this_show_used": bool, "week": int}.
static func answer(choice: String, state: Dictionary) -> Dictionary:
	var free: bool = bool(state.get("free", true))
	var used: bool = bool(state.get("not_this_show_used", false))
	var week: int = int(state.get("week", 0))
	if choice == "accept":
		return {
			"ok": true,
			"booked": true,
			"my_delta": 0,
			"their_delta": 0,
			"not_this_show_used": used,
			"next_offer_week": week + COOLDOWN_WEEKS,
			"why": "Fight booked",
		}
	elif choice == "not_this_show":
		if not used:
			return {
				"ok": true,
				"booked": false,
				"my_delta": 0,
				"their_delta": 0,
				"not_this_show_used": true,
				"next_offer_week": week,
				"why": "Not this show",
			}
		else:
			return {
				"ok": true,
				"booked": false,
				"my_delta": -PASS_COST if free else 0,
				"their_delta": PASS_COST if free else 0,
				"not_this_show_used": used,
				"next_offer_week": week + COOLDOWN_WEEKS,
				"why": "Not this show already used, counts as a pass" if free else "Not this show already used, counts as a pass (no penalty, not free)",
			}
	elif choice == "pass":
		if not free:
			return {
				"ok": true,
				"booked": false,
				"my_delta": 0,
				"their_delta": 0,
				"not_this_show_used": used,
				"next_offer_week": week + COOLDOWN_WEEKS,
				"why": "Passed but free (hurt, resting, too heavy or booked), no penalty",
			}
		return {
			"ok": true,
			"booked": false,
			"my_delta": -PASS_COST,
			"their_delta": PASS_COST,
			"not_this_show_used": used,
			"next_offer_week": week + COOLDOWN_WEEKS,
			"why": "Passed, -%d to challenger" % PASS_COST,
		}
	return {"ok": false, "booked": false, "my_delta": 0, "their_delta": 0,
		"not_this_show_used": used, "next_offer_week": week, "why": "Unknown choice"}


## ducked: true when she is ranked 0..DUCK_RANK_GAP places above, said No, and my boxer is hot.
## rank_gap = my_rank - her_rank (positive = she's above).
static func ducked(rank_gap: int, said_no: bool, my_hot: bool) -> bool:
	if rank_gap < 0 or rank_gap > DUCK_RANK_GAP:
		return false
	if not said_no:
		return false
	if not my_hot:
		return false
	return true


## owed: two or more ducks within the last DUCK_WINDOW weeks.
## duck_weeks = Array of int (week numbers when ducks happened).
static func owed(duck_weeks: Array, week: int) -> bool:
	var count: int = 0
	for dw in duck_weeks:
		var diff: int = week - int(dw)
		if diff >= 0 and diff < DUCK_WINDOW:
			count += 1
	return count >= 2


## owed_answer: on an owed ask the score starts at 95 and a No pays my boxer +3.
static func owed_answer(owed_now: bool, score: int) -> Dictionary:
	if owed_now:
		return {"score": OWED_SCORE, "no_pays": OWED_PAY}
	return {"score": score, "no_pays": 0}


## season_reset: a copy with not_this_show_used false (1 January); ducks and cooldowns carry over.
static func season_reset(rival: Dictionary) -> Dictionary:
	var out: Dictionary = rival.duplicate()
	out["not_this_show_used"] = false
	return out
