extends RefCounted
## HOSTPROBE3 (S540): a FLAGGED LOCAL COPY of what club show map v6 adds (ops/research/DESIGN_HOSTSHOW1_V6.md). Never loaded
## by the game. v6 = v5 with HOSTPROBE2 s7 done: the pro call on LADDER POINTS (top 3 and a 7-0 record's points, or a 9-0
## record's points at any rank), the hall as a read of the club (Community or Town; the gym floor gone), boxers-sell and
## Leave off cut, 2 standby reserves as the coach's default, favours at the game's own rate (owner Q-308 "Yes, keep it").
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
const POSTERS := 24
const MAIN_REP := 3
const BELOW_WIN_REP := 3
const YES_PER_2PTS := 1
const YES_CAP := 9
const FAVOUR_YES := 3
const BELOW_YES := 9
const PROMISE_YES := 9
const FAVOURS_START := 1       ## CODE FightWeekPlan.gd:31
const FAVOURS_MAX := FightWeekEvents.FAVOURS_MAX   ## CODE 3
const FAVOUR_PRICE := PartnerMatch.OUTSIDE_FEE      ## CODE PartnerMatch.gd:43: $160 cash or 1 favour
const PROBE_STOP_SHARE := 0.2  ## PROBE: share of our losses that are stoppages (BoutRead.chance gives the win only)
const READ_LUCK := 0.925       ## the hall read's middle night: the middle of ClubShow.LUCK (0.70-1.15)

## NEW v6 (HOSTPROBE2 s7 item 2): the pro call reads LADDER POINTS. The lines are the built rule's own records turned into
## points by the game's seed (LadderPoints.seed_of): top 3 and the points of a 7-0 record (Roster.PRO_WINS), or the points of
## a 9-0 record (Roster.PRO_WINS_ANY_RANK) at any rank. Wins over a name above pay more points (LadderRep.change), so the
## harder win moves the call. Declines and the national finalist rule stay as built (the probe's boxers have 0 declines).
static func pro_points() -> int:
	return LadderPoints.seed_of(Roster.PRO_WINS, 0)


static func pro_points_any() -> int:
	return LadderPoints.seed_of(Roster.PRO_WINS_ANY_RANK, 0)


static func pro_ready(f: Dictionary) -> bool:
	if bool(f.get("pro", false)) or int(f.get("pro_declines", 0)) > 0:
		return Roster.pro_ready(f)
	var pts := LadderPoints.rep_of(f)
	var rk := int(f.get("rank", 0))
	return (rk > 0 and rk <= Roster.PRO_RANK and pts >= pro_points()) or pts >= pro_points_any()


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


## NEW v6 4.2 THE HALL READ (shown, not chosen): each hall's likely night - a middle luck, no pull-outs, every card bout boxed,
## two reserves - as net cash plus its full / half-empty reputation at $333 a point; the read names the higher. Returns
## {hall, likely: {hall: {sold, net, rep, V}}}.
static func hall_read(club: Dictionary, ours: Array) -> Dictionary:
	var likely := {}
	var best := ""
	for hall in HALL_ORDER:
		var card := int(HALLS[hall]["card"])
		var n_ours := mini(ours.size(), card)
		var follow := 0
		for i in n_ours:
			follow += following(int(ours[i]))
		var visitors := n_ours + 2 * (card - n_ours)
		var d := draw(hall, int(club["members"]), int(club["rep"]), follow, POSTERS, visitors) * READ_LUCK
		var sold := mini(seats(hall), roundi(d))
		var net := sold * (TICKET + RAFFLE_PER_SEAT) - int(HALLS[hall]["rent"]) - FIXED - TRAVEL * visitors - STANDBY * RESERVES_DEFAULT
		var rep := int(HALLS[hall]["full"]) if sold >= 0.85 * seats(hall) else (int(HALLS[hall]["half"]) if sold < 0.5 * seats(hall) else 0)
		likely[hall] = {"sold": sold, "net": net, "rep": rep, "V": net + rep * 333.0}
		if best == "" or float(likely[hall]["V"]) > float(likely[best]["V"]):
			best = hall
	return {"hall": best, "likely": likely}


## One night. club {members, rep}; ours = wins of our boxers on the card; reserves 0-2 (the default is 2; the probe checks it).
## Returns {cash, rep, sold, seats, full, half, short}.
static func night(club: Dictionary, hall: String, ours: Array, reserves: int, rng: RandomNumberGenerator) -> Dictionary:
	var luck := rng.randf_range(ClubShow.LUCK.x, ClubShow.LUCK.y)
	var card := int(HALLS[hall]["card"])
	var falls: Array = []
	for i in card:
		falls.append(rng.randf() < PULL_OUT)
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
	var demand := draw(hall, int(club["members"]), int(club["rep"]), follow, POSTERS, visitors) * luck
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
