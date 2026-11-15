extends RefCounted
## S489 STEPVALUE1 build piece 3 (map ops/research/DESIGN_STEPVALUE1_V1_KALLI_KALLI.md s2 ROPES, his Q-S294-231: "three in a
## round on your count = the next exchange is on the ropes"): the ROPES COUNT inside the live round. Each planned step that
## fired moves the count by its StepEffect row (step back +1; pivot out / step out clear it; cut off / herd add to the
## opponent's count). At StepEffect.ROPES_AT the next exchange is fought on the ropes card (own_ropes / opp_ropes) and the
## count starts again. Counts live on the round (lv), so they reset at the bell. Only the place changes here: the step's
## DENY / OPEN / DRAIN sizes wait for the map's probes (s9), so no unmeasured edge enters the fight.
##   after(lv, rec, arrow, planned) - updates lv["at"], lv["ropes"], lv["opp_ropes"], lv["ropes_times"], rec["ropes_put"]
##   times(lv) -> int   (how often this round your boxer was put on the ropes by the count)

const StepEffect := preload("res://scripts/rules/StepEffect.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")


static func after(lv: Dictionary, rec: Dictionary, arrow: String, planned: bool) -> void:
	rec["ropes_put"] = ""
	var step := PlanFight.base_id(arrow)
	var row := StepEffect.effect(step)
	if not planned or row.is_empty():
		return
	lv["ropes"] = StepEffect.ropes_after(int(lv.get("ropes", 0)), step)
	lv["opp_ropes"] = int(lv.get("opp_ropes", 0)) + int(row.get("opp_ropes", 0))
	if StepEffect.on_ropes(int(lv["ropes"])):
		lv["at"] = "own_ropes"
		lv["ropes"] = 0
		lv["ropes_times"] = int(lv.get("ropes_times", 0)) + 1
		rec["ropes_put"] = "own"
	elif StepEffect.on_ropes(int(lv["opp_ropes"])):
		lv["at"] = "opp_ropes"
		lv["opp_ropes"] = 0
		rec["ropes_put"] = "opp"


static func times(lv: Dictionary) -> int:
	return int(lv.get("ropes_times", 0))
