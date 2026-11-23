extends RefCounted
## HOSTPROBE2 (S539): a FLAGGED LOCAL COPY of what club show map v5 adds (ops/research/DESIGN_HOSTSHOW1_V5.md s4). Never loaded
## by the game. v5 = v4 with HOSTPROBE1 s7 done: one favour (the built Career.favours), the promise priced by the delayed pro
## call, hall reach on the club part only (Town's reach grows with reputation), weight section / skills bout / door price /
## move down / ladder swap cut, boxers-sell priced from PadWeek (in the runner), the game's own pull-out rate.
## Every number is the map's (ESTIMATE / NEW) unless a line says CODE (read from the game) or PROBE (an assumption here).

const ClubShow := preload("res://scripts/rules/ClubShow.gd")
const FightWeekEvents := preload("res://scripts/rules/FightWeekEvents.gd")
const PartnerMatch := preload("res://scripts/rules/PartnerMatch.gd")

## map v5 4.2 halls. reach = the multiplier on the CLUB PART of the draw only (base + members + reputation); Town's reach is
## TOWN_REACH_BASE + TOWN_REACH_PER_REP x reputation, clamped (NEW v5: a town hall fills from the club's name).
const HALLS := {
	"gym": {"seats_per_place": 4, "rent": 300, "card": 6, "reach": 0.8, "yes": 3, "full": 3, "half": -3},
	"community": {"seats": 250, "rent": 1000, "card": 9, "reach": 1.0, "yes": 5, "full": 4, "half": -3},
	"town": {"seats": 400, "rent": 2000, "card": 12, "reach": -1.0, "yes": 7, "full": 6, "half": -4},
}
const HALL_ORDER := ["gym", "community", "town"]
const TOWN_REACH_BASE := 0.6
const TOWN_REACH_PER_REP := 0.01
const TOWN_REACH_MAX := 1.25
const GYM_MIN_PLACES := 16
const FIXED := 1500            ## officials, doctor, ambulance $1,200 + medals $300 (ClubShow.gd:3-5 anchors)
const DEPOSIT := 0.3
const TICKET := 25
const RAFFLE_PER_SEAT := 5
const SELL_SEATS := 10         ## a boxer who sells: +10 seats for one fight-week pad night (its price: PadWeek, in the runner)
const TRAVEL := 40
const SUPPORTERS := 3
const STANDBY := 40
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
const FAVOUR_PRICE := PartnerMatch.OUTSIDE_FEE      ## CODE PartnerMatch.gd:43: the game's own price, $160 cash or 1 favour
const RETURN_MIN_DAYS := 28    ## the promised return bout, 4-12 weeks after our night, away on their show (map v4 4.3)
const RETURN_MAX_DAYS := 84
const NOVICE_FEE := 80
const NOVICE_SEATS := 22
const PROBE_STOP_SHARE := 0.2  ## PROBE: share of our losses that are stoppages (BoutRead.chance gives the win only)


static func reach(hall: String, rep: int) -> float:
	if hall == "town":
		return clampf(TOWN_REACH_BASE + TOWN_REACH_PER_REP * rep, TOWN_REACH_BASE, TOWN_REACH_MAX)
	return float(HALLS[hall]["reach"])


static func seats(hall: String, places: int) -> int:
	var h: Dictionary = HALLS[hall]
	return int(h["seats_per_place"]) * places if h.has("seats_per_place") else int(h["seats"])


static func open(hall: String, places: int) -> bool:
	return hall != "gym" or places >= GYM_MIN_PLACES


static func following(w: int) -> int:
	return FOLLOW_BASE + FOLLOW_PER_WIN * w


## v5: the hall's reach scales the club part only; followings, posters and visitors' supporters come whatever the hall.
static func draw(hall: String, members: int, rep: int, followings: int, posters: int, visitors: int) -> float:
	var club := ClubShow.BASE + ClubShow.PER_MEMBER * members + ClubShow.PER_REPUTATION * rep
	return club * reach(hall, rep) + followings + posters + SUPPORTERS * visitors


## One night. club {members, rep, places}; ours = wins of our boxers on the card; reserves 0-2; read = keep|sell.
## Returns {cash, rep, sold, seats, full, half, short, sold_pads}. The sell's pad-night price is added by the runner.
static func night(club: Dictionary, hall: String, ours: Array, reserves: int, read: String, rng: RandomNumberGenerator) -> Dictionary:
	var places := int(club["places"])
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
	var extra := SELL_SEATS * n_ours if read == "sell" else 0
	var cap := seats(hall, places)
	var demand := draw(hall, int(club["members"]), int(club["rep"]), follow, POSTERS, visitors) * luck + extra
	var sold := mini(cap, roundi(demand))
	var out := {"cash": sold * (TICKET + RAFFLE_PER_SEAT) - int(HALLS[hall]["rent"]) - FIXED - travel - STANDBY * reserves,
		"sold": sold, "seats": cap, "full": sold >= 0.85 * cap, "half": sold < 0.5 * cap, "short": boxed * 3 < card * 2,
		"sold_pads": n_ours if read == "sell" else 0}
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
