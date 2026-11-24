extends SceneTree
## S547 PLANREAD2 (ops/research/TASK_PLANREAD2.md, docs/PLANREAD2_RESULT.md): the card must not promise a plan the bout does
## not pay. PLANWORTH1 (docs/PLANWORTH1_RESULT.md) measured the read 4-7 times the bout on a written plan. This reads its arms
## the cheap way: three of TURNPROBE18's types at week 4 (Kira Mensah, Josh Harper, Kai Turner - all three HELD OUT of the
## fit: PlanReadFit is fitted on the other five types' bouts in tools/planread2_probe.gd) x two opponent styles (Pressure
## fighter, Out-boxer), arms A (no plan, no coach), D (one line: the style plan's first) and C (the style plan: PLANWORTH1's
## arm C chooser, greedy on the read as it was before this fix, frozen here so the plan does not move with the read), 300
## paired bouts an arm (3 files x 100, bout k = career day 50000 + 7k in every arm). The fighters are TURNPROBE18's
## (tools/tellplay1_rules.gd build_types(4)) frozen as data below, so no tool is preloaded.
## Bars, pooled over the six cells (a cell alone has 2 SE of ~5.5 points at 300 bouts):
##   1. |read - bout| <= 4 points of wins in 100 for every arm;
##   2. (read C - read A) <= 2 x (bout C - bout A) + 3 points.
## The bout is PLANWORTH1's bout() copied (BoutNight.play_out, the game's own mode_bias, a 4-round pro debut card).
const BoutRead := preload("res://scripts/rules/BoutRead.gd")
const BoutNight := preload("res://scripts/state/BoutNight.gd")
const DebutOpp := preload("res://scripts/rules/DebutOpp.gd")
const RingDuel := preload("res://scripts/state/RingDuel.gd")
const Sim := preload("res://scripts/state/Sim.gd")

const CAMP := {"protocol": 2}
const GYM := 58.0
const N := 100
## TURNPROBE18's types 1, 5, 9 at week 4 with their style plans (tools/planread2_probe.gd stage=dump; plans from stage=plans,
## greedy on the read before S547). The greedy stopped at four lines for each (the limit is six).
const TYPES_JSON := '''[
{"name":"Kira Mensah","night0":57.1666666666667,"f":{"age":18,"arrows":[],"attrs":{"accuracy":58.027254486084,"body":52,"chin":52,"composure":59.4028129577637,"defence":57.5,"durability":52,"engine":54.0243093967438,"explosiveness":52.6979202032089,"fight_iq":54.5971870422363,"flexibility":55,"foot_speed":66.5,"footwork":58.9,"forward":22.1,"guard":57.5,"hand_speed":66.5,"head_movement":56.625,"heart":36,"hooks":33.05,"inside":52.6518248175182,"jab":50.1,"pace":77,"power":54,"recovery":61.9756906032562,"ring_iq":54.5971870422363,"speed":66.5,"stamina":54.0243093967438,"straight":44.3,"strength":55.3020797967911,"timing":59.972745513916,"uppercuts":23.6},"booked_fight":false,"bout":{},"camp":{},"cards":["Jab and move","Pad rounds","Hill sprints"],"combos":{"1-1":55.2,"1-1-2":41.4,"1-2":57,"2-3":32.2},"diet":"hold","div":"wfw","fatigue":8,"first":"Kira","focus":"conditioning","footwork":58.9,"goal":{"deadline_day":28,"id":"next_bout_inside_a_month","persona_line":"Get me back in the ring and get my stamina up.","start_day":0,"start_stats":{"accuracy":58.027254486084,"composure":59.4028129577637,"defence":57.5,"durability":52,"explosiveness":52.6979202032089,"fight_iq":54.5971870422363,"flexibility":55,"footwork":58.9,"inside":52.6518248175182,"recovery":61.9756906032562,"speed":66.5,"stamina":54.0243093967438,"strength":55.3020797967911,"timing":59.972745513916},"targets":{"booked_fight":true,"stamina":57.5243093967438},"title":"Next bout inside a month"},"goal_talk":false,"habits":["freezes_on_ropes","bites_on_feints"],"height":163,"history":[],"id":"kira","joined":0,"know":{"body":0,"bout_count":0,"fire_bout":0,"fire_spar":0,"hyped":false,"last_bout_week":-1,"seed":2090437068,"seen_all":false,"skills":0,"stale_body":0,"stale_causes":[],"stale_fire":0,"under_fire_opened":false},"l":1,"learning":"Uppercut","limit":57,"mood_reason":"","morale":60,"moves":{"Body hook":29.4,"Check hook":13.8,"Cross":53.4,"Jab":64.4,"Lead hook":41.4,"Uppercut":18.4},"name":"Kira Mensah","next_offer_day":8,"note":"fast hands, thin chin","offers":[],"opp_index":0,"perks":{},"personality":{"coachability":84,"confidence":58,"discipline":64,"heart":36,"loyalty":60,"temper":30},"pot":86,"pro":false,"rank":0,"reach":168,"registered":-28,"sex":"f","stance":"orthodox","stats":{"chin":53.0419,"conditioning":60.1056442758475,"defense":57.7470742807244,"fight_iq":57.2514089172283,"power":54.2718,"speed":67.9664308349652,"technique":59.8910245017157},"stats_seen":{"_footwork":58.9,"chin":52,"conditioning":58,"defense":57.5,"fight_iq":57,"power":54,"speed":66.5,"technique":59},"steps":{"cut_off":20,"feint":36.8,"herd":20,"pivot_out":41.4,"push_off":20,"roll_out":20,"step_back":50.6,"step_in":46,"step_out":55.2,"tie_up":20},"style":"Out-boxer","style_dials":{"body_share":23,"counter":71.1,"pressure":22.1,"work_rate":77},"w":9,"wc":"Featherweight","week_start":{"chin":52,"conditioning":58,"defense":57.5,"fight_iq":57,"power":54,"speed":66.5,"technique":59},"weekly_salary":250,"weight":58.3},"plans":{"Pressure fighter":[{"move":"1-1"},{"move":"tie_up"},{"move":"pivot_out"},{"move":"1-1-2"}],"Out-boxer":[{"move":"1-2"},{"move":"tie_up"},{"move":"1-1-2"},{"move":"pivot_out"}]}},
{"name":"Josh Harper","night0":56.9166666666667,"f":{"age":23,"arrows":[],"attrs":{"accuracy":56.5999682426453,"body":64,"chin":64,"composure":57.9518207907677,"defence":55,"durability":64,"engine":59.8133918762207,"explosiveness":63.2689772844315,"fight_iq":54.0481792092323,"flexibility":55,"foot_speed":56,"footwork":56.2,"forward":73.2,"guard":55,"hand_speed":56,"head_movement":55,"heart":66,"hooks":31.1,"inside":58.6076642335766,"jab":47.2,"pace":45,"power":63,"recovery":70.1866081237793,"ring_iq":54.0481792092323,"speed":56,"stamina":59.8133918762207,"straight":41.6,"strength":62.7310227155685,"timing":54.4000317573547,"uppercuts":22.2},"booked_fight":false,"bout":{},"camp":{},"cards":["Jab and move","Pad rounds","Hill sprints"],"combos":{"1-2":36,"1-2-3-2":31.5,"1-2-3b":45,"1-6-3":31.5,"3b-3":54},"diet":"hold","div":"mww","fatigue":8,"first":"Josh","focus":"conditioning","footwork":56.2,"goal":{"deadline_day":28,"id":"next_bout_inside_a_month","persona_line":"Get me back in the ring and get my stamina up.","start_day":0,"start_stats":{"accuracy":56.5999682426453,"composure":57.9518207907677,"defence":55,"durability":64,"explosiveness":63.2689772844315,"fight_iq":54.0481792092323,"flexibility":55,"footwork":56.2,"inside":58.6076642335766,"recovery":70.1866081237793,"speed":56,"stamina":59.8133918762207,"strength":62.7310227155685,"timing":54.4000317573547},"targets":{"booked_fight":true,"stamina":63.3133918762207},"title":"Next bout inside a month"},"goal_talk":false,"habits":["loads_up_when_hurt","admires_her_work"],"height":178,"history":[],"id":"josh","joined":0,"know":{"body":0,"bout_count":0,"fire_bout":0,"fire_spar":0,"hyped":false,"last_bout_week":-1,"seed":2090407705,"seen_all":false,"skills":0,"stale_body":0,"stale_causes":[],"stale_fire":0,"under_fire_opened":false},"l":2,"learning":"Uppercut","limit":70,"mood_reason":"","morale":60,"moves":{"Body hook":59.4,"Check hook":9,"Cross":52.2,"Jab":46.8,"Lead hook":57.6,"Uppercut":36},"name":"Josh Harper","next_offer_day":8,"note":"never tires, wide hooks","offers":[],"opp_index":0,"perks":{},"personality":{"coachability":64,"confidence":38,"discipline":80,"heart":66,"loyalty":70,"temper":35},"pot":79,"pro":false,"rank":0,"reach":182,"registered":-168,"sex":"m","stance":"southpaw","stats":{"chin":64.4950136120643,"conditioning":66.0528221379237,"defense":55.2080625521889,"fight_iq":56.1993932791811,"power":64.2032253004843,"speed":56.1993932791811,"technique":56.2755213255674},"stats_seen":{"_footwork":56.2,"chin":64,"conditioning":65,"defense":55,"fight_iq":56,"power":63,"speed":56,"technique":55.5},"steps":{"cut_off":49.5,"feint":20,"herd":45,"pivot_out":20,"push_off":36,"roll_out":20,"step_back":20,"step_in":49.5,"step_out":20,"tie_up":36},"style":"Pressure fighter","style_dials":{"body_share":55,"counter":21.7,"pressure":73.2,"work_rate":45},"w":7,"wc":"Welterweight","week_start":{"chin":64,"conditioning":65,"defense":55,"fight_iq":56,"power":63,"speed":56,"technique":55.5},"weekly_salary":250,"weight":71.4},"plans":{"Pressure fighter":[{"move":"tie_up"},{"move":"1-2"},{"move":"pivot_out"},{"move":"step_back"}],"Out-boxer":[{"move":"tie_up"},{"move":"1-2"},{"move":"step_back"},{"move":"pivot_out"}]}},
{"name":"Kai Turner","night0":58.6666666666667,"f":{"age":22,"arrows":[],"attrs":{"accuracy":61.0708847522736,"body":55,"chin":55,"composure":61.8394029140472,"defence":58,"durability":55,"engine":61.5151890039444,"explosiveness":56.1220205068588,"fight_iq":54.1605970859528,"flexibility":55,"foot_speed":62,"footwork":55,"forward":57.4,"guard":58,"hand_speed":62,"head_movement":56.95,"heart":36,"hooks":33.6,"inside":58.3773722627737,"jab":51,"pace":54,"power":57,"recovery":70.4848109960556,"ring_iq":54.1605970859528,"speed":62,"stamina":61.5151890039444,"straight":45,"strength":57.8779794931412,"timing":58.9291152477264,"uppercuts":24},"booked_fight":false,"bout":{},"camp":{},"cards":["Jab and move","Pad rounds","Hill sprints"],"combos":{"1-1":42.8,"1-2":55.1,"1-2-3":47.5,"1-2-3-2":52.3,"3b-3":38},"diet":"hold","div":"mlm","fatigue":8,"first":"Kai","focus":"conditioning","footwork":55,"goal":{"deadline_day":28,"id":"next_bout_inside_a_month","persona_line":"Get me back in the ring and get my stamina up.","start_day":0,"start_stats":{"accuracy":61.0708847522736,"composure":61.8394029140472,"defence":58,"durability":55,"explosiveness":56.1220205068588,"fight_iq":54.1605970859528,"flexibility":55,"footwork":55,"inside":58.3773722627737,"recovery":70.4848109960556,"speed":62,"stamina":61.5151890039444,"strength":57.8779794931412,"timing":58.9291152477264},"targets":{"booked_fight":true,"stamina":65.0151890039444},"title":"Next bout inside a month"},"goal_talk":false,"habits":["slow_starter","clinches_when_tired"],"height":175,"history":[],"id":"kai","joined":0,"know":{"body":0,"bout_count":0,"fire_bout":0,"fire_spar":0,"hyped":false,"last_bout_week":-1,"seed":193496826,"seen_all":false,"skills":0,"stale_body":0,"stale_causes":[],"stale_fire":0,"under_fire_opened":false},"l":3,"learning":"Uppercut","limit":65,"mood_reason":"","morale":60,"moves":{"Body hook":47.5,"Check hook":9.5,"Cross":55.1,"Jab":58.9,"Lead hook":53.2,"Uppercut":30.4},"name":"Kai Turner","next_offer_day":8,"note":"busy, thin chin","offers":[],"opp_index":0,"perks":{"body_snatcher":0},"personality":{"coachability":84,"confidence":33,"discipline":64,"heart":36,"loyalty":60,"temper":30},"pot":80,"pro":false,"rank":0,"reach":175,"registered":-28,"sex":"m","stance":"orthodox","stats":{"chin":55.8250226867738,"conditioning":67.0528221379237,"defense":58.1907240061732,"fight_iq":58.1907240061732,"power":57.1993932791811,"speed":63.3536284630448,"technique":60.6600181494191},"stats_seen":{"_footwork":55,"chin":55,"conditioning":66,"defense":58,"fight_iq":58,"power":57,"speed":62,"technique":60},"steps":{"cut_off":38,"feint":20,"herd":33.3,"pivot_out":20,"push_off":20,"roll_out":20,"step_back":20,"step_in":47.5,"step_out":20,"tie_up":28.5},"style":"Volume puncher","style_dials":{"body_share":26,"counter":49.1,"pressure":57.4,"work_rate":54},"w":8,"wc":"Light welterweight","week_start":{"chin":55,"conditioning":66,"defense":58,"fight_iq":58,"power":57,"speed":62,"technique":60},"weekly_salary":250,"weight":65.8},"plans":{"Pressure fighter":[{"move":"tie_up"},{"move":"1-1"},{"move":"step_back"},{"move":"pivot_out"}],"Out-boxer":[{"move":"1-2"},{"move":"tie_up"},{"move":"step_back"},{"move":"pivot_out"}]}}
]'''
const FILES := {"Pressure fighter": [["Body hooks", "Walks in straight"], ["Right hand over the jab", "Leaves the chin open"], ["Never stops throwing", "Slow to start"]],
	"Out-boxer": [["Stops people", "Backs straight up"], ["Long jab", "Fades after round 2"], ["Heavy right hand", "Walks in straight"]]}
var fails := 0


func check(ok: bool, msg: String) -> void:
	if not ok:
		fails += 1
		print("FAIL ", msg)
	else:
		print("ok   ", msg)


func opp_of(f: Dictionary, style: String, threat: String, weak: String, rating: float) -> Dictionary:
	var opp := DebutOpp.make(f, 0.0, 0, "probe18")
	var name := "M %s|%s|%s" % [style, threat, weak]
	opp.merge({"name": name, "first": "M", "style": style, "threat": threat, "weak": weak, "rating": snappedf(rating, 0.01)}, true)
	return opp


func read(f0: Dictionary, opp: Dictionary, arr: Array, k: float) -> float:
	var f := f0.duplicate()
	f["pro"] = true
	f["bout"] = {"tank_ahead": 0.0, "pro": true, "rounds": 4}
	f["arrows"] = arr.duplicate(true)
	return float(BoutRead.CardOdds.result(BoutRead.round_edges(f, opp, CAMP, k), RingDuel.FORM_SD)["win"])


## PLANWORTH1's bout(): one real bout on paired dice k; arrows empty and ck = no coach = no plan.
func bout(f0: Dictionary, opp: Dictionary, arr: Array, k: int, ck: float) -> bool:
	var sc := Career.new()
	sc.day = 50000 + k * 7
	sc.seed = 387
	sc.coach = {"rating": ck}
	var sf: Dictionary = f0.duplicate(true)
	sf["pro"] = true
	sf["camp"] = CAMP.duplicate(true)
	sf["arrows"] = arr.duplicate(true)
	sf["bout"] = {"opp": opp, "day": sc.day, "weighed": true, "made": true, "done": false, "film": 1, "rounds": 4, "pro": true, "stale": 0.0}
	var fx := sf.duplicate()
	fx["bout"] = {}
	sf["bout"]["mode_bias"] = RingDuel.mode_bias(fx, opp).duplicate()
	sc.fighters = [sf]
	var md := BoutNight.fight_modal(sf)
	BoutNight.play_out(sc, sf, md)
	return BoutNight.outcome_of(sf, md) == "win"


func _initialize() -> void:
	var t0 := Time.get_ticks_msec()
	var arms := ["A", "D", "C"]
	var tot := {"A": [0.0, 0.0], "D": [0.0, 0.0], "C": [0.0, 0.0]}   # [read %, bout %] summed over cells
	var cells := 0
	var types: Array = JSON.parse_string(TYPES_JSON)
	for ty in types:
		var f: Dictionary = ty["f"]
		for style in FILES:
			var plan: Array = ty["plans"][style]
			var plans := {"A": [[], Sim.NO_COACH_RATING], "D": [plan.slice(0, 1), GYM], "C": [plan, GYM]}
			var row := {}
			for a in arms:
				var rd := 0.0
				var wins := 0
				for fl in FILES[style]:
					var opp := opp_of(f, style, str(fl[0]), str(fl[1]), float(ty["night0"]))
					rd += 100.0 * read(f, opp, plans[a][0], plans[a][1]) / float(FILES[style].size())
					for k in N:
						wins += int(bout(f, opp, plans[a][0], k, plans[a][1]))
				var bt := 100.0 * float(wins) / float(N * FILES[style].size())
				row[a] = [snappedf(rd, 0.1), snappedf(bt, 0.1)]
				tot[a][0] += rd
				tot[a][1] += bt
			cells += 1
			print("CELL %s vs %s: %s" % [ty["name"], style, str(row)])
	for a in arms:
		tot[a] = [float(tot[a][0]) / cells, float(tot[a][1]) / cells]
		var gap := float(tot[a][0]) - float(tot[a][1])
		check(absf(gap) <= 4.0, "arm %s: read %.1f, bout %.1f, read - bout %+.1f (bar |.| <= 4)" % [a, tot[a][0], tot[a][1], gap])
	var read_gain := float(tot["C"][0]) - float(tot["A"][0])
	var bout_gain := float(tot["C"][1]) - float(tot["A"][1])
	check(read_gain <= 2.0 * bout_gain + 3.0, "the plan's gain: read C-A %+.1f <= 2 x bout C-A %+.1f + 3" % [read_gain, bout_gain])
	print("PLAN_READ_FIT %s: %d cells, %d bouts an arm, %.1f s" % ["PASS" if fails == 0 else "FAIL", cells, cells * N * 3, (Time.get_ticks_msec() - t0) / 1000.0])
	quit(1 if fails > 0 else 0)
