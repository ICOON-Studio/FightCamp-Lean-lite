extends RefCounted
## HOSTPROBE5 (S541): a FLAGGED LOCAL COPY of what club show map v8 adds (ops/research/DESIGN_HOSTSHOW1_V8.md). Never loaded
## by the game. v8 = v7 (tools/hostprobe4_rules.gd) with HOSTPROBE4 s7 done: the pro call keeps the BUILT count (7 wins + top 3,
## or 9) but WEIGHS each win (a win over a name above on ladder points 1, below W_BELOW, calibrated on the road's calibration
## seeds), the name below's yes 8 in 10, and the main event's posters tied to the hall (Community +24, Town +48).
## Every number is the map's (ESTIMATE / NEW) unless a line says CODE (read from the game) or PROBE (an assumption here).

const ClubShow := preload("res://scripts/rules/ClubShow.gd")
const FightWeekEvents := preload("res://scripts/rules/FightWeekEvents.gd")
const PartnerMatch := preload("res://scripts/rules/PartnerMatch.gd")
const LadderPoints := preload("res://scripts/state/LadderPoints.gd")
const Roster := preload("res://scripts/state/Roster.gd")

## map v6 4.2 halls (the gym floor is cut: HOSTPROBE2 B7, never within $1,546 of the next hall).
const HALLS := {
	"community": {"seats": 250, "rent": 1000, "card": 9, "reach": 1.0, "yes": 5, "full": 4, "half": -3},
	"town": {"seats": 400, "rent": 2000, "card": 12, "reach": -1.0, "yes": 7, "full": 6, "half": -4},
}
const HALL_ORDER := ["community", "town"]
const TOWN_REACH_BASE := 0.6
const TOWN_REACH_PER_REP := 0.01
const TOWN_REACH_MAX := 1.25
const FIXED := 1500            ## officials, doctor, ambulance $1,200 + medals $300 (ClubShow.gd:3-5 anchors)
const TICKET := 25
const RAFFLE_PER_SEAT := 5
const TRAVEL := 40
const SUPPORTERS := 3
const STANDBY := 40
const RESERVES_DEFAULT := 2    ## NEW v6: the coach books two standby reserves (a line on the sheet, not a choice)
const PULL_OUT := FightWeekEvents.PULL_OUT_CHANCE   ## CODE FightWeekEvents.gd:5 (0.35), each invited bout, fight week
const SHORT_REP := -2
const FOLLOW_BASE := 10
const FOLLOW_PER_WIN := 3
## v8 4.3 (HOSTPROBE4 s7 item 3): the main event's posters scale with the hall (ESTIMATE); the night has no posters without it.
const MAIN_POSTERS := {"community": 24, "town": 48}
const MAIN_REP := 3
const BELOW_WIN_REP := 3
const YES_PER_2PTS := 1
const YES_CAP := 9
const FAVOUR_YES := 2          ## v7 (HOSTPROBE3 s7 item 3): +2 in 10, was +3
const BELOW_YES := 8          ## v8 (HOSTPROBE4 s7 item 2): 8 in 10, was 9 (ESTIMATE)
const PROMISE_YES := 9
const FAVOURS_START := 1       ## CODE FightWeekPlan.gd:31
const FAVOURS_MAX := FightWeekEvents.FAVOURS_MAX   ## CODE 3
const FAVOUR_PRICE := PartnerMatch.OUTSIDE_FEE      ## CODE PartnerMatch.gd:43: $160 cash or 1 favour
const PROBE_STOP_SHARE := 0.2  ## PROBE: share of our losses that are stoppages (BoutRead.chance gives the win only)
const READ_LUCKS := [0.70, 0.8125, 0.925, 1.0375, 1.15]   ## v7: the read averages five lucks across ClubShow.LUCK
const READ_CLOSE := 300        ## v7: halls within this = "close - your call", both shown
## v7 4.3 (HOSTPROBE3 s7 item 4): a "no" costs the slot's week. The next ask goes out after the 3-day answer, so a no from
## the name above lands after the posters LATE_NO of the time: the posters go up with no bout of ours, and the late ask to
## the name below is answered yes LATE_BELOW_YES in 10 (names below fill their dates). A home boxer v the name below on the
## posters (booked in time) brings POSTERS_BELOW seats (the main event, the name above, keeps MAIN_POSTERS[hall] and +-MAIN_REP).
const LATE_NO := 0.5           ## ESTIMATE
const LATE_BELOW_YES := 7      ## ESTIMATE
const POSTERS_BELOW := 12      ## ESTIMATE

## v8 4.4 (HOSTPROBE4 s7 item 1): the BUILT count, each win WEIGHED: a win over a name above on ladder points (theirs higher
## than ours before the bout) counts 1, any other win W_BELOW. The lines stay Roster.PRO_WINS (7) with top 3, or
## Roster.PRO_WINS_ANY_RANK (9) at any rank. W_BELOW = the lowest of {0.5, 0.6, 0.7, 0.8} that keeps the built call's timing
## on the road's calibration seeds (docs/HOSTPROBE5_RESULT.md s2 fixes the procedure before the run; set after stage=road).
const W_BELOW := 0.5           ## CALIBRATED (stage=road, seeds 0-7; result s4)


static func weight(opp_pts: int, our_pts: int) -> float:
	return 1.0 if opp_pts > our_pts else W_BELOW


## f.wwins = the weighed wins (the probe keeps it on its boxers). Declines and the national finalist stay as built.
static func pro_ready(f: Dictionary) -> bool:
	if bool(f.get("pro", false)) or int(f.get("pro_declines", 0)) > 0 or bool(f.get("nat_final", false)):
		return Roster.pro_ready(f)
	var ww := float(f.get("wwins", float(f.get("w", 0))))
	var rk := int(f.get("rank", 0))
	return (rk > 0 and rk <= Roster.PRO_RANK and ww >= Roster.PRO_WINS - 0.001) or ww >= Roster.PRO_WINS_ANY_RANK - 0.001


static func reach(hall: String, rep: int) -> float:
	if hall == "town":
		return clampf(TOWN_REACH_BASE + TOWN_REACH_PER_REP * rep, TOWN_REACH_BASE, TOWN_REACH_MAX)
	return float(HALLS[hall]["reach"])


static func seats(hall: String) -> int:
	return int(HALLS[hall]["seats"])


static func following(w: int) -> int:
	return FOLLOW_BASE + FOLLOW_PER_WIN * w


## the hall's reach scales the club part only; followings, posters and visitors' supporters come whatever the hall.
static func draw(hall: String, members: int, rep: int, followings: int, posters: int, visitors: int) -> float:
	var club := ClubShow.BASE + ClubShow.PER_MEMBER * members + ClubShow.PER_REPUTATION * rep
	return club * reach(hall, rep) + followings + posters + SUPPORTERS * visitors


## v7 4.2 THE HALL READ (shown, not chosen): each hall's EXPECTED night - five lucks across ClubShow.LUCK, every pull-out
## pattern weighted by its chance (35 in 100 a bout), two reserves - as net cash plus full / half-empty / short reputation at
## $333 a point; the read names the higher, and "close - your call" when they are within READ_CLOSE. (The build can use the
## binomial count of pull-outs: the night depends only on how many of ours and of the visitors' fall.)
## Returns {hall, close, likely: {hall: {sold, net, rep, V}}}.
static func hall_read(club: Dictionary, ours: Array) -> Dictionary:
	var likely := {}
	var best := ""
	for hall in HALL_ORDER:
		var card := int(HALLS[hall]["card"])
		var acc := {"sold": 0.0, "net": 0.0, "rep": 0.0}
		for mask in 1 << card:
			var falls: Array = []
			var pr := 1.0
			for b in card:
				var fell := ((mask >> b) & 1) == 1
				falls.append(fell)
				pr *= PULL_OUT if fell else 1.0 - PULL_OUT
			for luck in READ_LUCKS:
				var n := night_of(club, hall, ours, RESERVES_DEFAULT, float(luck), falls, int(MAIN_POSTERS[hall]))
				var w := pr / READ_LUCKS.size()
				acc["sold"] += w * float(n["sold"])
				acc["net"] += w * float(n["cash"])
				acc["rep"] += w * float(n["rep"])
		acc["V"] = float(acc["net"]) + float(acc["rep"]) * 333.0
		likely[hall] = acc
		if best == "" or float(acc["V"]) > float(likely[best]["V"]):
			best = hall
	var vs: Array = HALL_ORDER.map(func(h): return float(likely[h]["V"]))
	return {"hall": best, "close": absf(float(vs[0]) - float(vs[1])) < READ_CLOSE, "likely": likely}


## One night. club {members, rep}; ours = wins of our boxers on the card; reserves 0-2 (the default is 2; the probe checks it).
## Returns {cash, rep, sold, seats, full, half, short}.
## v8: posters = the card's posters (the hall's main event when it is booked; the read and the hall stage assume it is).
static func night(club: Dictionary, hall: String, ours: Array, reserves: int, rng: RandomNumberGenerator, posters: int) -> Dictionary:
	var luck := rng.randf_range(ClubShow.LUCK.x, ClubShow.LUCK.y)
	var falls: Array = []
	for i in int(HALLS[hall]["card"]):
		falls.append(rng.randf() < PULL_OUT)
	return night_of(club, hall, ours, reserves, luck, falls, posters)


## The night for a given luck and pull-out pattern (the read walks these; night() rolls them).
static func night_of(club: Dictionary, hall: String, ours: Array, reserves: int, luck: float, falls: Array, posters: int) -> Dictionary:
	var card := int(HALLS[hall]["card"])
	var n_ours := mini(ours.size(), card)
	var follow := 0
	var visitors := 0
	var boxed := 0
	var used := 0
	var travel := 0
	for b in card:
		var fell: bool = falls[b]
		if fell and used < reserves:
			used += 1
			fell = false
		if fell:
			if b < n_ours:
				follow += int(following(int(ours[b])) / 2)   # PROBE: half our boxer's following still comes
			continue
		boxed += 1
		var vis := 1 if b < n_ours else 2
		visitors += vis
		travel += TRAVEL * vis
		if b < n_ours:
			follow += following(int(ours[b]))
	var cap := seats(hall)
	var demand := draw(hall, int(club["members"]), int(club["rep"]), follow, posters, visitors) * luck
	var sold := mini(cap, roundi(demand))
	var out := {"cash": sold * (TICKET + RAFFLE_PER_SEAT) - int(HALLS[hall]["rent"]) - FIXED - travel - STANDBY * reserves,
		"sold": sold, "seats": cap, "full": sold >= 0.85 * cap, "half": sold < 0.5 * cap, "short": boxed * 3 < card * 2}
	var rep := 0
	if out["full"]:
		rep += int(HALLS[hall]["full"])
	elif out["half"]:
		rep += int(HALLS[hall]["half"])
	if out["short"]:
		rep += SHORT_REP
	out["rep"] = rep
	return out


## map 4.3 the yes chance (in 10) of an ask.
static func yes10(kind: String, hall: String, lead_pts: float, how: String) -> int:
	if kind == "below":
		return BELOW_YES
	var y := int(HALLS[hall]["yes"]) + maxi(0, int(floor(lead_pts / 2.0))) * YES_PER_2PTS
	if how == "favour":
		y += FAVOUR_YES
	elif how == "promise":
		y = PROMISE_YES
	return mini(y, YES_CAP)
