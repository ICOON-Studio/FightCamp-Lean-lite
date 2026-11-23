extends RefCounted
## HOSTPROBE1 (S539): a FLAGGED LOCAL COPY of what club show map v4 adds (ops/research/DESIGN_HOSTSHOW1_V4_REVISE_KALLI_KALLI.md
## s4). Never loaded by the game. Every number here is the map's (its ESTIMATE / NEW), except where a line says PROBE: an
## assumption this probe had to make because the map leaves it open. The game's own modules are used for everything that
## exists (ClubShow draw parts, BoutRead, WorldBout, LadderPoints, Region.rankings, Roster.pro_ready, FighterProfile, WeighGap).

const ClubShow := preload("res://scripts/rules/ClubShow.gd")

## map 4.2 halls
const HALLS := {
	"gym": {"seats_per_place": 4, "rent": 300, "card": 6, "mult": 0.8, "yes": 3, "full": 3, "half": -3},
	"community": {"seats": 250, "rent": 1000, "card": 9, "mult": 1.0, "yes": 5, "full": 4, "half": -3},
	"town": {"seats": 400, "rent": 2000, "card": 12, "mult": 1.25, "yes": 7, "full": 6, "half": -4},
}
const HALL_ORDER := ["gym", "community", "town"]
const GYM_MIN_PLACES := 16
const FIXED := 1500            ## officials, doctor, ambulance $1,200 + medals $300
const DEPOSIT := 0.3           ## of the hall's rent, paid at booking
const TICKET := 25
const RAFFLE_PER_SEAT := 5
const DOOR_PRICE := 15
const DOOR_WALKUP := 1.3       ## the final third's walk-up at the door price
const SOLD_AT_READ := 0.69     ## sold 12 days out, of the night
const SELL_SEATS := 10         ## a boxer who sells: +10 seats, one pad evening (2.6 mastery)
const SELL_MASTERY := 2.6
const TRAVEL := 40             ## a visitor's travel, paid by the host
const SUPPORTERS := 3          ## supporters a visiting boxer brings
const STANDBY := 40
const PULL_OUT := 0.25         ## each invited bout, the final week (map 4.10; the game's own is FightWeekEvents 0.35)
const SHORT_REP := -2
const MOVE_DOWN_REP := -2
const CANCEL_REP := -3
const FOLLOW_BASE := 10
const FOLLOW_PER_WIN := 3
const POSTERS := 24            ## map s6: the main event settled before the posters (+50% of the boxer's following, rounded as s6)
const MAIN_REP := 3
const BELOW_WIN_REP := 3       ## a home win over a name below (map 4.3), BoutRules.WIN_REPUTATION 5 over a name above
const YES_PER_2PTS := 1        ## +1 in 10 a 2 rating points the name above leads ours
const YES_CAP := 9
const FAVOUR_YES := 3
const BELOW_YES := 9
const PROMISE_YES := 9
const SWAP_YES := 0.8          ## each club
const FAV_CAP := 2
const FAV_LAPSE_DAYS := 182
const BROKEN_PROMISE := -2
const CORNER_YES := 0.7
const CORNER_MAX_KG := 0.5
const HARDER_KG := 0.17
const HARDER_WIN := -0.05      ## map s6: wins 38 -> 33
const STAND_SEATS := 25
const NOVICE_FEE := 80
const NOVICE_SEATS := 22
const BOOKED_MORALE := "booked"
const PROBE_DAY_SD := 0.2      ## PROBE: the scale on the day around the forecast, kg (the map's WeighOdds is not specified)
const PROBE_STOP_SHARE := 0.2  ## PROBE: share of our losses that are stoppages (BoutRead.chance gives the win only)


static func seats(hall: String, places: int) -> int:
	var h: Dictionary = HALLS[hall]
	return int(h["seats_per_place"]) * places if h.has("seats_per_place") else int(h["seats"])


static func open(hall: String, places: int) -> bool:
	return hall != "gym" or places >= GYM_MIN_PLACES


static func following(w: int) -> int:
	return FOLLOW_BASE + FOLLOW_PER_WIN * w


## Tickets the night would sell before the luck roll: ClubShow's club part (no juniors, no PER_HOME_BOXER: v4 replaces it with
## followings) + followings + posters + supporters of the visitors boxing.
static func draw(members: int, rep: int, followings: int, posters: int, visitors: int) -> float:
	return ClubShow.BASE + ClubShow.PER_MEMBER * members + ClubShow.PER_REPUTATION * rep + followings + posters + SUPPORTERS * visitors


## One night of v4's show. club {members, rep, places}; ours = wins of our boxers on the card; reserves 0-2;
## read = keep|door|sell|down|cancel; rng = the night's dice. Returns {cash, rep, fav, sold, seats, full, half, short, mastery}.
static func night(club: Dictionary, hall: String, ours: Array, reserves: int, read: String, rng: RandomNumberGenerator) -> Dictionary:
	var places := int(club["places"])
	var luck := rng.randf_range(ClubShow.LUCK.x, ClubShow.LUCK.y)
	var falls: Array = []
	var card := int(HALLS[hall]["card"])
	for i in card:
		falls.append(rng.randf() < PULL_OUT)
	var rent_paid := int(DEPOSIT * int(HALLS[hall]["rent"]))
	var out := {"cash": 0, "rep": 0, "fav": 0, "sold": 0, "seats": seats(hall, places), "full": false, "half": false, "short": false, "mastery": 0.0}
	if read == "cancel":
		out["cash"] = -rent_paid
		out["rep"] = CANCEL_REP
		out["fav"] = -card   # PROBE: one favour with each club on the card (one club a bout)
		return out
	var at := hall
	var rep := 0
	if read == "down":
		var hi := HALL_ORDER.find(hall)
		if hi <= 0 or not open(HALL_ORDER[hi - 1], places):
			read = "keep"   # nothing smaller to move to
		else:
			at = HALL_ORDER[hi - 1]
			rep += MOVE_DOWN_REP
			card = int(HALLS[at]["card"])
			falls = falls.slice(0, card)
	var rent := int(HALLS[at]["rent"]) + (rent_paid if at != hall else 0)   # moved down: the first hall's deposit is lost
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
	var extra := 0
	if read == "sell":
		extra = SELL_SEATS * n_ours
		out["mastery"] = SELL_MASTERY * n_ours
	var cap := seats(at, places)
	var demand := (draw(int(club["members"]), int(club["rep"]), follow, POSTERS, visitors) + extra) * float(HALLS[at]["mult"]) * luck
	var sold := mini(cap, roundi(demand))
	var takings := sold * TICKET
	if read == "door":
		var early := roundi(demand * SOLD_AT_READ)
		var late := roundi((demand - early) * DOOR_WALKUP)
		sold = mini(cap, early + late)
		takings = mini(cap, early) * TICKET + maxi(0, sold - mini(cap, early)) * DOOR_PRICE
	out["cash"] = takings + sold * RAFFLE_PER_SEAT - rent - FIXED - travel - STANDBY * reserves
	out["sold"] = sold
	out["seats"] = cap
	out["full"] = sold >= 0.85 * cap
	out["half"] = sold < 0.5 * cap
	out["short"] = boxed * 3 < card * 2
	if out["full"]:
		rep += int(HALLS[at]["full"])
	elif out["half"]:
		rep += int(HALLS[at]["half"])
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
