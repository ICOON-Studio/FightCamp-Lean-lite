extends RefCounted
## One amateur bout from camp to scorecards: the camp's cost and edge, the weigh-in, three rounds told in words with a corner
## call between them, the cards and what decided it. Pure static functions: no class_name, no preload, no argument mutation.
## Numbers are the approved prototype's (docs/menu_prototype.html, fightPower / fightAdvance / finishFight); they are
## game-design values, not sport-science measurements. Stat keys: power speed technique defense conditioning fight_iq chin.

## Protocols by index (0 = no camp). cost in $, focus = multiplier on the camp focus's daily gain, edge = fight-night edge.
## S380 (S379: Hard vs Standard moved the camp stat 60.12 vs 59.98 and changed no fatigue - the multiplier only touched
## ~1 point of focus mornings): the protocol also sets the camp's EVENINGS. drill = the pads night's share of a session
## on the camp's stat (a morning is WeekPlan.SESSION_SHARE 0.2); load = how hard those evenings go (fatigue, hours and so
## injury risk); level = the TrainingLoad setting it mirrors into f["load_setting"]. S381 C229 nights = club nights a week
## the card states (design value, a label only - an amateur with a day job: 3 / 4 / 5). S381 C229 stage 2: cost 0 / 0 / 0 -
## the club's own nights cost coach evenings and risk, not cash (a club coach does not bill his own boxer). S381 C229
## stage 4: the flat edges halved (0.5 / 1.2 / 2.0 -> 0.25 / 0.6 / 1.0; NO_CAMP_EDGE stays -1.5) - the value moved into the
## matchup (film answers, the southpaw mate, the stat thresholds the focus card crosses); tools/camp_film_balance.gd.
## S382 EVENINGS1: the camp runs only the strip's pad nights (PadWeek: 2 / 2 / 3 a week, the taper's at half), not 5, so
## drill is per NIGHT: Standard 0.05 -> 0.115, Hard 0.09 -> 0.14 (a 25-day power camp: +2.06 / +2.98 vs +2.06 / +3.03
## before), and Hard's load 1.2 -> 1.0 - its extra volume is now a real third pad night (at 1.2 it peaked 84, overreached;
## at 1.0 76.1 vs 74.6 before). tools/evenings_balance.gd.
## S413: the new model parks about five of conditioning on recovery, and that clears fatigue faster, so those peaks fell
## to 60.8 and 55.7 - both under the injury line of 72. Hard was then only 3.2% against Standard's 2.7% (the extra pad
## night, nothing from fatigue). Load stays 1.0 (the third night is the volume). WeekPlan.HARD_HEAT is the harder
## evenings on top of that, so the camp still gets tired enough to clear the line and stay under overreached.
## Drill shares stay put. Raising them would move every camp's gains, not just a technique camp.
const PROTOCOLS := [
	{"name": "None", "cost": 0, "focus": 1.0, "edge": 0.0, "drill": 0.0, "load": 1.0, "level": "normal", "nights": 0, "blurb": ""},
	{"name": "Light", "cost": 0, "focus": 1.1, "edge": 0.25, "drill": 0.0, "load": 0.75, "level": "light", "nights": 3, "blurb": "3 nights, spar 1 a week"},
	{"name": "Standard", "cost": 0, "focus": 1.2, "edge": 0.6, "drill": 0.115, "load": 1.0, "level": "normal", "nights": 4, "blurb": "4 nights, spar 2 a week"},
	{"name": "Hard", "cost": 0, "focus": 1.35, "edge": 1.0, "drill": 0.14, "load": 1.0, "level": "hard", "nights": 5, "blurb": "5 nights a week"},
]
## S380 fight night: camp fatigue still carried into the ring empties the tank at the first bell (Halperin, Hughes &
## Chapman 2016: punch impact -4 to -7 % when camp fatigue had not cleared). Under FRESH_FATIGUE reads FRESH
## (WhiteboardKit.fatigue_word); STALE_PER_POINT energy a point over it, at most STALE_MAX (= Injuries.HURT_ENERGY serious).
const FRESH_FATIGUE := 50.0
const STALE_PER_POINT := 2.0
const STALE_MAX := 20.0
## S433 NOCAMP1 + TANK1 (CORE_LOOP_MAP_S432 C4): THE TANK at the first bell is one rule on every bout, camp or not - the
## tiredness part above, plus the weight left to the day (CLUBWEEK 4's scale: weighed the same day 1 a 0.1 kg, 2 past
## 0.5 kg; the day before 1 a 0.2 kg) and the boxer's own last bout (7 days ago -8, 14 days ago -4); all added, at most
## TANK_MAX off. The freshness slope under 50 waits for training v6 (FITLEGS1).
const TANK_MAX := 25.0
const EAT_SAME_DAY := 10.0
const EAT_PAST_KG := 0.5
const EAT_DAY_BEFORE := 5.0
const LAST_BOUT := [[7, 8.0], [14, 4.0]]
const CAMP_FOCUSES: Array[String] = ["conditioning", "power", "technique", "defense", "speed"]
## S381 C229 stage 2: film is a phone video of her at a club show - free; it takes one Build-week pad night (WeekPhase.film_night).
## The only camp cash is the outside sparring partner from another club: travel and a favour, $40 a visit, 4 visits (design
## values: the Peak week's 2 sparring nights plus one in each Build week).
const PARTNER_FEE := 40
const PARTNER_VISITS := 4
## S381 C229 stage 3: an orthodox boxer who never sparred a southpaw in camp is lost for the first round against one (design
## value, power points, round 1 only): "never faced a southpaw". The southpaw mate (or a WeekTwist lefty week) takes it
## away; there is no plus edge for having one. The mirror never bites: a southpaw spars orthodox club mates every night.
const NEVER_FACED := 0.6
## The film depth (OppFile.film_depth: 1 nothing found, 3 her whole file) still drives what the corner reads in the ring
## (THE READ, the coach's pick); it no longer adds power.
const FILM_DEPTH_WITH_STUDY := 3
const FILM_DEPTH_DEFAULT := 1
## S381 C229 stage 4: film is earned - tape is only worth what the coach turns into a plan. Each found tell a Playbook plan
## line or a drilled combination answers (FilmEdge.answered, PlanLines.answers) is worth FILM_PER_ANSWER on the night, up
## to FILM_EDGE_MAX (design values; the old flat film edge was the same +1.2 for anyone).
const FILM_PER_ANSWER := 0.4
const FILM_EDGE_MAX := 1.2
## S433 NOCAMP1: a professional with no camp only (night_edge); an amateur fight week has no camp and pays nothing.
const NO_CAMP_EDGE := -1.5
## A camp is worth setting with at least a week to go.
const CAMP_MIN_DAYS := 7
## Each round both sides roll +/- half of this. S305 J-UPSETS1: pro favourites win 86% of decided fights; target ~60% at
## slight edge, ~75% clear, ~88% big, ~95% at +13 (tools/balance_targets.gd measured spread 27).
const ROUND_SPREAD := 27.0
const ROUNDS := 3
## Round 3: she fades below this Stamina (S433 CARDIO1: Stamina, never the mean with Recovery), on a slope (TRAINING_MAP F3):
## OWN_FADE x clamp(FADE_PER_POINT x (FADE_STAMINA - Stamina), 0, FADE_MAX); an opponent who "fades" loses OPP_FADE.
## S434 FADESHARE (tools/fade_share.gd; Data.PROSPECTS + Lucy + 200 AttrGen recruits, signed through Attrs.from_stats, whose
## Stamina starts 5 under the old mean). The bar (TRAINING_MAP F3): the share of FADING AMATEUR BOUTS within 5 points of
## main's (the mean under 64, a flat 1.0). Measured AT FIGHT TIME: each signing through Sim.step_day's own week (no camp),
## a bout on days 28, 35, 42, 49 and 56 (1,030 bouts). Main fades 64.6% of them. Line 59 fades 58.5% (-6.0, outside the
## bar: Stamina trains 0.086 a day on the own week, the mean 0.050, so the split rule pulls away after signing); 60 fades
## 63.6% (-1.0); 61 66.9% (+2.3); 64 74.4% (+9.8). On signing day 60 is +1.9 (70.9% vs 68.9%). THE LINE IS 60.
## A player who answers a Stamina goal (the Stamina week: Tue intervals, Thu roadwork) fades 52.8% of bouts at 60, main's
## rule 59.9%: the split pays the Stamina work more, as F3 wants. SIZE (the design slope kept, the developer decision):
## a fading bout loses 1.49 on average at 60 (main: a flat 1.0), every bout 0.95 (main 0.65); holding main's size would
## need OWN_FADE 0.68, which breaks F3's own points (62: 0.5, 60: 1.0, 56: 2 on the old 64). The deep end costs more,
## the near miss less (TRAINING_MAP risks: "Stamina under 60 cost more than today"); LINES1 prices it in exchanges.
const FADE_STAMINA := 60.0
const FADE_PER_POINT := 0.25
const FADE_MAX := 2.0
const OWN_FADE := 1.0
const OPP_FADE := 1.5

## S308: the eight corner calls (Exchanges.CALLS has what each does); the labels the corner card and the result show.
const CORNER := {"long": "Jab and move", "body": "Go to the body", "lead": "Draw the lead", "hands": "Hands up, move your head",
	"let_go": "Let your hands go", "calm": "Breathe, pick your shots", "tie": "Tie up", "finish": "Go for the finish"}
## The corner edge: a strong call when she has the tool for it, a small one when she has not.
const CORNER_STRONG := 1.0
const CORNER_WEAK := 0.3
const CORNER_BODY_POWER := 60.0
const CORNER_LONG_TECHNIQUE := 61.0
const CORNER_CALM := 0.6
## S381 G1 (gym idea 5, the threshold bar on each camp card): the stat number that changes the night, one per stat that has
## one - the body call goes strong past CORNER_BODY_POWER, "Jab and move" past CORNER_LONG_TECHNIQUE, no round-3 fade from
## FADE_STAMINA. above = strictly past it (fight_power's >), else at it or past (play_round's fade is < it). word = the
## card's caption. Defence and hand speed have no line. fight_power and play_round read clears_night_line, so they never drift.
const NIGHT_LINES := {
	"power": {"at": CORNER_BODY_POWER, "word": "body call", "above": true},
	"technique": {"at": CORNER_LONG_TECHNIQUE, "word": "jab and move", "above": true},
	"stamina": {"at": FADE_STAMINA, "word": "no fade from round 3", "above": false, "name": "Stamina"},
}

const WEIGH_TOLERANCE := 0.05
const MISSED_WEIGHT_COST := 300
const TICKET_CUT := 450
const WIN_MEMBERS := 8
const WIN_REPUTATION := 5
## S324 update 27 "losses cost" (make-it-a-game plan decision 4): a loss loses members after the news and some reputation
## (the natural member count follows reputation, so a loss also lowers where the gym settles); a stoppage loss costs more.
## S327 (operator "Money too harsh"): 1 and 2 members, was 3 and 5 - club members train for themselves; one bout lost
## does not empty a gym (the reputation loss still lowers where the member count settles).
const LOSS_MEMBERS := 1
const LOSS_REPUTATION := 2
const STOPPED_LOSS_MEMBERS := 2
const STOPPED_LOSS_REPUTATION := 4

## Move mastery on the night: a move at USABLE (mastery 30) or better is a weapon. The first BASE_WEAPONS are what any
## amateur brings; each weapon beyond them is worth WEAPON_EDGE, up to WEAPON_EDGE_CAP (a new weapon every 2-3 weeks).
const WEAPON_MASTERY := 30.0
const BASE_WEAPONS := 4
const WEAPON_EDGE := 0.3
const WEAPON_EDGE_CAP := 0.9


## The camp's cash: the protocol (the club's own nights, $0) + the outside sparring partner's visits when one is booked.
static func camp_cost(protocol: int, partner: bool) -> int:
	return int(PROTOCOLS[clampi(protocol, 0, 3)]["cost"]) + (partner_fee() if partner else 0)


static func partner_fee() -> int:
	return PARTNER_FEE * PARTNER_VISITS


## Who the outside partner copies: "southpaw mate" for a southpaw, "pressure mate" for a pressure fighter, else "sparring mate".
static func partner_word(opp: Dictionary) -> String:
	if str(opp.get("stance", "")).to_lower() == "southpaw":
		return "southpaw mate"
	return "pressure mate" if str(opp.get("style", "")).to_lower().begins_with("pressure") else "sparring mate"


## True when the outside partner copies the opponent's free stance or style (the card's "MATCHES <HER>").
static func partner_matches(opp: Dictionary) -> bool:
	return partner_word(opp) != "sparring mate"


## S381 C229 stage 3: an orthodox boxer facing a southpaw with no southpaw in her camp (no partner, no lefty week).
## stance = hers ("" reads orthodox, the club default); a southpaw herself is never caught out (her club mates are orthodox).
static func never_faced(stance: String, opp: Dictionary, camp: Dictionary, lefty: bool = false) -> bool:
	if stance.to_lower() == "southpaw" or str(opp.get("stance", "")).to_lower() != "southpaw":
		return false
	return not (bool(camp.get("partner", false)) or lefty)


## The stance's cost in round n: -NEVER_FACED in round 1 when she never faced a southpaw, else 0.
static func stance_edge(n: int, stance: String, opp: Dictionary, camp: Dictionary, lefty: bool = false) -> float:
	return -NEVER_FACED if n == 1 and never_faced(stance, opp, camp, lefty) else 0.0


## The daily-gain multiplier the camp puts on one stat (1.0 off the focus or without a camp).
static func camp_gain_mult(camp: Dictionary, stat: String) -> float:
	if camp.is_empty() or str(camp.get("focus", "")) != stat:
		return 1.0
	return float(PROTOCOLS[clampi(int(camp.get("protocol", 0)), 0, 3)]["focus"])


## S380 the camp's evenings: {stat (the camp focus the pads drill), drill (the pads share), load (evening fatigue x)}.
static func camp_evening(camp: Dictionary) -> Dictionary:
	if camp.is_empty():
		return {"stat": "", "drill": 0.0, "load": 1.0}
	var p: Dictionary = PROTOCOLS[clampi(int(camp.get("protocol", 0)), 0, 3)]
	return {"stat": str(camp.get("focus", "")), "drill": float(p["drill"]), "load": float(p["load"])}


## The TrainingLoad setting a protocol stands for (Bouts.start_camp mirrors it into f["load_setting"]).
static func camp_level(protocol: int) -> String:
	return str(PROTOCOLS[clampi(protocol, 0, 3)]["level"])


## S433 the Tank's parts at the first bell: {tired, weight, bout, off (their sum, at most TANK_MAX)}. eat_kg = the kilos
## left to eat off on the weigh-in day; days = since the boxer's own last bout (-1 none).
static func tank_parts(fatigue: float, eat_kg: float = 0.0, days: int = -1, same_day: bool = true) -> Dictionary:
	var tired := clampf((fatigue - FRESH_FATIGUE) * STALE_PER_POINT, 0.0, STALE_MAX)
	var kg := maxf(0.0, eat_kg)
	var weight := (kg + maxf(0.0, kg - EAT_PAST_KG)) * EAT_SAME_DAY if same_day else kg * EAT_DAY_BEFORE
	var bout := 0.0
	for row in LAST_BOUT:
		if days >= 0 and days <= int(row[0]):
			bout = float(row[1])
			break
	return {"tired": tired, "weight": weight, "bout": bout, "off": minf(TANK_MAX, tired + weight + bout)}


## The energy off at the first bell (tank_parts' off).
static func tank(fatigue: float, eat_kg: float = 0.0, days: int = -1, same_day: bool = true) -> float:
	return float(tank_parts(fatigue, eat_kg, days, same_day)["off"])


## The Tank off at the first bell of f's booked bout on `day` at this tiredness (BoutNight._peak and CampForecast, so the
## Training tab and the bout read one number): the kilos the scale left to the day (bout "eat_kg"; an amateur weighs in on
## the day, CLUBWEEK 4) and the boxer's own last bout (results = Career.results).
static func tank_for(results: Array, f: Dictionary, fatigue: float, day: int) -> float:
	return float(tank_parts_for(results, f, fatigue, day)["off"])


## tank_for's parts (tank_parts). Her last bout is the newer of results and her own "last_bout_day" (BoutNight writes both;
## a scratch career with no results - PlanTest, the bout page's read - still knows it).
static func tank_parts_for(results: Array, f: Dictionary, fatigue: float, day: int) -> Dictionary:
	var b: Dictionary = f.get("bout", {})
	var days := days_since_bout(results, str(f.get("id", "")), day)
	var own := int(f.get("last_bout_day", -1))
	if own >= 0 and own <= day:
		days = day - own if days < 0 else mini(days, day - own)
	return tank_parts(fatigue, float(b.get("eat_kg", 0.0)), days, not (bool(f.get("pro", false)) or bool(b.get("pro", false))))


## S434 the Tank off the bout page's read assumes (BoutRead): once fight night has set it, the played number; before, the
## fight-night forecast the bout page put on its copy (bout "tank_ahead", CampForecast.for_read: the Training tab's number);
## without one, the same rule on today's tiredness and her last bout. All with the hurt she fights with (Injuries.fight_hurt).
static func tank_read(f: Dictionary) -> float:
	var b: Dictionary = f.get("bout", {})
	var off := float(b["stale"]) if b.has("stale") else (float(b["tank_ahead"]) if b.has("tank_ahead") else
		tank_for([], f, float(f.get("week_fatigue", 20.0)), int(b.get("day", -1))))
	return float(b.get("hurt", 0.0)) + off


## The parts that cost something, in words: "tiredness 20, the last bout 8" ("" when nothing).
static func tank_words(parts: Dictionary) -> String:
	var out: Array = []
	for k in [["tired", "tiredness"], ["weight", "the scale"], ["bout", "the last bout"]]:
		if float(parts.get(k[0], 0.0)) >= 0.5:
			out.append("%s %d" % [k[1], int(round(float(parts[k[0]])))])
	return ", ".join(out)


## Days from the boxer's newest bout in `results` (Career.results: {d, fid}) to `day`; -1 when none.
static func days_since_bout(results: Array, fid: String, day: int) -> int:
	var last := -1
	for r in results:
		if str((r as Dictionary).get("fid", "")) == fid:
			last = maxi(last, int(r.get("d", -1)))
	return day - last if last >= 0 else -1


static func made_weight(weight: float, limit: float) -> bool:
	return weight <= limit + WEIGH_TOLERANCE


## Power points the film is worth: FILM_PER_ANSWER a found tell her plan answers, at most FILM_EDGE_MAX.
static func film_edge(answered: int) -> float:
	return clampf(float(answered) * FILM_PER_ANSWER, 0.0, FILM_EDGE_MAX)


## Her strength on the night: the six fighting stats (chin aside), the camp, the film (answered = found tells her plan or
## drilled combos answer, FilmEdge.answered) and the corner call.
static func fight_power(stats: Dictionary, camp: Dictionary, answered: int, corner: String, pro: bool = false) -> float:
	var p := 0.0
	for k in ["power", "speed", "technique", "defense", "conditioning", "fight_iq"]:
		p += float(stats.get(k, 55.0))
	p /= 6.0
	p += night_edge(camp, answered, pro)
	match corner:
		"body":
			p += CORNER_STRONG if clears_night_line("power", float(stats.get("power", 0.0))) else CORNER_WEAK
		"long":
			p += CORNER_STRONG if clears_night_line("technique", float(stats.get("technique", 0.0))) else CORNER_WEAK
		"calm":
			p += CORNER_CALM
	return p


## S398 the night's edges without the stats (the watched bout fights the stats as duels, RingDuel): the camp and the film.
## S433 NOCAMP1: NO_CAMP_EDGE only for a professional with no camp; an amateur fight week needs none.
static func night_edge(camp: Dictionary, answered: int, pro: bool = false) -> float:
	var p := float(PROTOCOLS[clampi(int(camp.get("protocol", 0)), 0, 3)]["edge"]) if not camp.is_empty() else (NO_CAMP_EDGE if pro else 0.0)
	return p + film_edge(answered)


## One round. roll_a / roll_b are in [0, 1); stats carries "stamina" (the fade's one number). Returns {n, won, mine, theirs, corner}.
static func play_round(n: int, stats: Dictionary, camp: Dictionary, answered: int, corner: String, opp: Dictionary,
		roll_a: float, roll_b: float, weapons_bonus: float = 0.0) -> Dictionary:
	var mine := fight_power(stats, camp, answered, corner) + weapons_bonus + (roll_a - 0.5) * ROUND_SPREAD
	if n >= ROUNDS:   # S434: no default; a caller without her Stamina is a script error, never a silent fade
		mine -= own_fade(float(stats["stamina"]))
	var theirs := float(opp.get("rating", 60.0)) + (roll_b - 0.5) * ROUND_SPREAD
	if n >= ROUNDS and str(opp.get("weak", "")).begins_with("Fades"):
		theirs -= OPP_FADE
	return {"n": n, "won": mine >= theirs, "mine": mine, "theirs": theirs, "corner": corner}


## Her own fade from round 3 at this Stamina: 0 at the line, 0.25 a point under it, at most 2 (OWN_FADE x the slope).
static func own_fade(stamina: float) -> float:
	return OWN_FADE * clampf(FADE_PER_POINT * (FADE_STAMINA - stamina), 0.0, FADE_MAX)


## The Stamina row's fade line in words a player reads (fight_power is the plain average of the stats, so a fade is that
## many points off every stat): "tires from round 3, every stat 0.50 lower; no fade from Stamina 60" or "no fade from
## round 3 (Stamina 60 or more)".
## S439 T17 ("Printed on the row"): the same line short enough for the Stamina row itself, in game words (no bare "fade",
## S422): "From round 3: fights 0.61 weaker; Stamina 60 stops it" or "From round 3: fights no weaker (Stamina 60 or more)" (the
## number is own_fade, points off her fight strength from round 3 on, play_round's n >= ROUNDS; S439: not "every stat", which
## the live fight only approximates); fade_words stays the hover's sentence.
static func fade_row(stamina: float) -> String:
	var fd := own_fade(stamina)
	if fd > 0.0:
		return "From round %d: fights %.2f weaker; Stamina %d stops it" % [ROUNDS, fd, int(FADE_STAMINA)]
	return "From round %d: fights no weaker (Stamina %d or more)" % [ROUNDS, int(FADE_STAMINA)]


static func fade_words(stamina: float) -> String:
	var fd := own_fade(stamina)
	if fd > 0.0:
		return "tires from round 3, every stat %.2f lower; no fade from Stamina %d" % [fd, int(FADE_STAMINA)]
	return "no fade from round 3 (Stamina %d or more)" % int(FADE_STAMINA)


## S381 G1 the stat's night line ({at, word, above}, NIGHT_LINES) or {} when the stat has none.
static func night_line(stat: String) -> Dictionary:
	return NIGHT_LINES.get(stat, {})


## True when `value` is over the stat's night line (false for a stat with no line).
static func clears_night_line(stat: String, value: float) -> bool:
	var l := night_line(stat)
	if l.is_empty():
		return false
	return value > float(l["at"]) if bool(l["above"]) else value >= float(l["at"])


## The card's caption: "past 60: body call", "Stamina 60: no fade from round 3" (a line that names its row) ("" for none).
static func night_line_words(stat: String) -> String:
	var l := night_line(stat)
	if l.is_empty():
		return ""
	return "%s %d: %s" % [str(l.get("name", "past" if bool(l["above"]) else "at")), int(l["at"]), str(l["word"])]


## The call the corner makes when the player sims to the result: her better tool.
static func auto_corner(stats: Dictionary) -> String:
	return "long" if float(stats.get("technique", 0.0)) > float(stats.get("power", 0.0)) else "body"


## Three judges' cards for `total` rounds, her score first: two score it round for round, the third gives one round to
## the other side (to her opponent when she won at least half, else to her) - so 3-0 reads 30-27 30-27 29-28.
static func scorecards(rounds_won: int, total: int = ROUNDS) -> Array:
	var won := clampi(rounds_won, 0, total)
	var hers := 10 * won + 9 * (total - won)
	var theirs := 9 * won + 10 * (total - won)
	var exact := "%d-%d" % [hers, theirs]
	var swing := -1 if won * 2 >= total else 1
	if (swing < 0 and won == 0) or (swing > 0 and won == total):
		swing = 0
	return [exact, exact, "%d-%d" % [hers + swing, theirs - swing]]


## S440 (the result page's audit: every 2-1 fight read as a split decision, since the third judge above always swings a
## round): the cards from the played rounds. Two judges score it round for round; the third sees the CLOSEST round the
## other way, and only when it was close: 3-3 on exchanges (a live round's won_n), or a margin under CLOSE_MARGIN (a
## harness round's mine - theirs). A fight with no close round reads three same cards. The two exact cards always
## agree, so the verdict is the one scorecards() gives; only split versus unanimous changes.
const CLOSE_MARGIN := 3.0
const EXCHANGES_A_ROUND := 6   # Exchanges.EXCHANGES (this file preloads nothing)

static func cards_of(rounds: Array) -> Array:
	var won := rounds.filter(func(r): return bool((r as Dictionary).get("won", false))).size()
	var total := rounds.size()
	var hers := 10 * won + 9 * (total - won)
	var theirs := 9 * won + 10 * (total - won)
	var exact := "%d-%d" % [hers, theirs]
	var pick := flip_round(rounds)
	if pick < 0:
		return [exact, exact, exact]
	var swing := -1 if bool((rounds[pick] as Dictionary).get("won", false)) else 1
	return [exact, exact, "%d-%d" % [hers + swing, theirs - swing]]


## The round the third judge scores the other way (-1 = none): the closest CLOSE round. The cards, the result page's
## round chips (Broadcast.judge_rounds) and the fight's judge tiles (RoundGraphics.judges) all read this one choice.
static func flip_round(rounds: Array) -> int:
	var pick := -1
	var best := INF
	for i in rounds.size():
		var r: Dictionary = rounds[i]
		var how_close := INF
		if r.has("won_n"):
			if int(r["won_n"]) * 2 == EXCHANGES_A_ROUND:
				how_close = absf(float(r.get("mine", 0.0)))
		else:
			var gap := absf(float(r.get("mine", 0.0)) - float(r.get("theirs", 0.0)))
			if gap < CLOSE_MARGIN:
				how_close = gap
		if how_close < best:
			best = how_close
			pick = i
	return pick


## "win", "loss" or "draw" from the cards: a majority of judges decides; anything else is a draw.
static func verdict(cards: Array) -> String:
	var her := 0
	var them := 0
	for card in cards:
		var parts := str(card).split("-")
		if int(parts[0]) > int(parts[1]):
			her += 1
		elif int(parts[0]) < int(parts[1]):
			them += 1
	if her >= 2:
		return "win"
	if them >= 2:
		return "loss"
	return "draw"


## Up to three one-line reasons. rounds: the played rounds; camp_focus_label e.g. "Conditioning"; threat in lower case.
## answered: the found tells her plan answered (S381 C229 stage 4: the film counts only when the plan used it).
## S433 NOCAMP1: the canned lines are gone ("The camp: ... held up", "No camp: ... a step slow", "Your corner call ...
## won that round" - said whatever happened); the camp, the Tank and the calls speak through their own sized lines.
static func why(_rounds: Array, _has_camp: bool, _protocol: int, _camp_focus_label: String, answered: int, threat: String,
		first: String) -> Array:
	var out: Array = []
	if answered >= 1:
		out.append("The film study: %s knew the %s was coming." % [first, threat])
	return out.slice(0, 3)


## Her weapons: the moves at USABLE or better, in the order given. moves = {name: mastery}.
static func weapons(moves: Dictionary) -> Array:
	var out: Array = []
	for k in moves.keys():
		if float(moves[k]) >= WEAPON_MASTERY:
			out.append(k)
	return out


static func weapons_edge(weapon_list: Array) -> float:
	return minf(WEAPON_EDGE_CAP, maxf(0.0, float(weapon_list.size() - BASE_WEAPONS) * WEAPON_EDGE))
