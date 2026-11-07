extends RefCounted
## S397 rank 4 (P1, STRUCTURE_DESIGN_S395 5.3a rule 2): the right fight is not simply the one you will win. A pro on a WORLD1
## division table picks a fight every GAP_MONTHS from the promoter's offers or asks for one, and every choice pulls four ways:
##   rank    beat someone above you (or anyone ranked while you are not) and you take their place (WorldRank.apply_result_in);
##           lose to someone above you and you drop one; beat someone below and nothing moves
##   growth  soft fights teach little, hard ones more, losses most (GROW_*), on top of the yearly rise to the peak (WorldAge)
##   time    a mismatch is a quick night (next fight in QUICK_WEEKS), a step up a hard one (HARD_WEEKS), a stopped loss adds a
##           medical rest (STOP_REST_WEEKS) and damage
##   money   the purse follows your own rank; tickets follow your fans and how close the fight looks
##   record  a losing or level record is never ranked in the top TOP_RECORD
##   unknown an unscouted opponent is a RANGE_RAW-wide guess around the truth and an unseen matchup edge (+-EDGE_MAX);
##           scouting (SCOUT_COST) narrows the range to RANGE_SCOUTED and shows the edge
## The promoter's rule: ask at most BAND_UP places above your rank (unranked: from UNRANKED_REACH down); a top-5 ask needs fans,
## two ducked fights in a row stop the asks until you take a hard one, and after a loss you win a rebuild fight before you
## ask above your place again. A refusal always says why.
## Pure rules: the career and screens call these; tests/matchmaking_bots_test.gd is rule 2's bot test.

const WR := preload("res://scripts/world/WorldRank.gd")
const WA := preload("res://scripts/world/WorldAge.gd")
const BoutRead := preload("res://scripts/rules/BoutRead.gd")

const GAP_MONTHS := 2          # a pro camp is 6-8 weeks: 4-6 bouts a year early on (assets/data/world/SOURCES.md)
## S397 (operator "Real loss costs"): a fight's night decides the wait for the next one, in weeks. A mismatch is a quick
## night (a tune-up 4-6 weeks apart is normal for a prospect); a step up is a hard night that needs healing; being stopped
## is a medical rest on top (boards suspend a stopped boxer 28 days or more; game value 8 weeks) and damage.
const NEXT_WEEKS := 8
const QUICK_WEEKS := 6
const HARD_WEEKS := 12
const STOP_REST_WEEKS := 8
const BAND_UP := 5
const UNRANKED_REACH := 15
const TOP_ASK := 5             # asking for a top-5 boxer needs fans >= TOP_ASK_FANS
const TOP_ASK_FANS := 3
const DUCKS_BLOCK := 2
const SCOUT_COST := 250       # a scout's day and the tape: about a third of the gym's take on an unranked night
const RANGE_RAW := 12.0        # full width of the guess (BoutRead.rating_range opens at 12 too)
const RANGE_SCOUTED := 4.0
const SOFT_GAP := 6.0          # an opponent this far below is a mismatch: it teaches little and bores the crowd
const GROW_BASE := 0.3
const GROW_PER_POINT := 0.08   # per rating point the opponent is above you
const GROW_LOSS := 0.4
const GROW_SOFT := 0.1
const LEARN_GAP := 6.0         # past this many points above you a fight teaches no more: you are surviving, not learning
const STOP_COST := 0.8         # rating lost at once to a stoppage loss (the damage shows now, not only after 31)
const PURSE_UNRANKED := 1500
const PURSE_PER_PLACE := 400   # rank 1 pays 1500 + 19 * 400 on a 20-place table
const OPP_DRAW_PER_PLACE := 150  # fighting a ranked name above you: the B side is paid for the name
const TICKET_PER_FAN := 150
const STEP_SELLS := 6.0       # a step up this far above still sells as a close fight
const STEP_BONUS := 0.25      # and a real step up sells a quarter more: the underdog story
const GYM_SHARE := 0.25        # manager 15% + trainer 10% (Roster.GYM_SHARE)
const TOP_RECORD := 10         # the board ranks nobody with a losing (or level) record above #11
## "Styles make fights": how his hidden weapon, habits and weakness (OppFile's tape tells) meet your boxer's game, in rating
## points on the night, + for you. Rolled once per pair, unseen until a scout finds it. A bad one also adds stoppage risk.
const EDGE_MAX := 6.0
const BAD_EDGE := -3.0
const BAD_EDGE_STOP := 0.12
const FANS_MIN := -5
const FANS_MAX := 12


## A new pro on the division table, unranked. `rating` is the BoutRules.fight_power scale the world uses.
static func join(division_boxers: Array, name: String, rating: float, age: int, seed: int = 0) -> Dictionary:
	var p := {"id": -1, "seed": seed, "name": name, "rating": rating, "age": age, "peak_age": WA.PEAK_AGE_PRO, "rank": 0, "belt": "",
		"w": 0, "l": 0, "d": 0, "ko": 0, "retired": false, "player": true, "fans": 0, "ducks": 0, "money": 0,
		"next_weeks": NEXT_WEEKS, "damage_ledger": {"hard_fights": 0, "stoppage_losses": 0, "total_fights": 0}, "log": []}
	division_boxers.append(p)
	return p


## The real chance on the night: the game's own bout odds (BoutRead.chance) with both sides on their ratings, no camp edge.
static func win_chance(own_rating: float, opp_rating: float) -> float:
	var st := {}
	for k in ["power", "speed", "technique", "defense", "conditioning", "fight_iq", "chin"]:
		st[k] = own_rating
	return BoutRead.chance({"name": "you", "stats": st}, {"name": "them", "rating": opp_rating, "style": "", "threat": "", "weak": ""}, {})


## What the player sees of an opponent: a range holding the true rating, placed by a dice roll so the middle is not the truth.
static func guess(opp: Dictionary, rng: RandomNumberGenerator) -> Dictionary:
	var t := float(opp["rating"])
	var lo := t - rng.randf() * RANGE_RAW
	return {"opp": opp, "lo": lo, "hi": lo + RANGE_RAW, "scouted": false, "edge": 0.0}


## The hidden matchup for this pair, fixed for the career (a replay agrees): uniform in +-EDGE_MAX.
static func edge(p: Dictionary, opp: Dictionary) -> float:
	var h := absi(hash("%s|%s|%s" % [str(p.get("seed", 0)), str(opp.get("id", "")), str(opp.get("name", ""))]))
	return snappedf((float(h % 10001) / 10000.0 * 2.0 - 1.0) * EDGE_MAX, 0.5)


## Scouting narrows a guess inside its old range, still holding the truth, and finds the matchup edge.
static func scout(p: Dictionary, g: Dictionary, rng: RandomNumberGenerator) -> bool:
	if g["scouted"] or int(p["money"]) < SCOUT_COST:
		return false
	p["money"] = int(p["money"]) - SCOUT_COST
	var t := float(g["opp"]["rating"])
	var lo := clampf(t - rng.randf() * RANGE_SCOUTED, float(g["lo"]), float(g["hi"]) - RANGE_SCOUTED)
	g["lo"] = lo
	g["hi"] = lo + RANGE_SCOUTED
	g["scouted"] = true
	g["edge"] = edge(p, g["opp"])
	return true


## What the read shows: the rating range, and the matchup once scouted (unscouted it reads as even).
static func shown_chance(p: Dictionary, g: Dictionary) -> Dictionary:
	var own := float(p["rating"]) + float(g.get("edge", 0.0))
	return {"lo": win_chance(own, float(g["hi"])), "mid": win_chance(own, (float(g["lo"]) + float(g["hi"])) / 2.0),
		"hi": win_chance(own, float(g["lo"]))}


## The promoter's three offers: one below you, one about level, one above (none above while you have ducked twice).
static func offers(p: Dictionary, boxers: Array, rng: RandomNumberGenerator) -> Array:
	var pool := _opponents(p, boxers)
	if pool.is_empty():
		return []
	var own := float(p["rating"])
	var below := pool.filter(func(b): return float(b["rating"]) < own - 2.0)
	var level := pool.filter(func(b): return absf(float(b["rating"]) - own) <= 2.0)
	# S397 blind round 3: the promoter's step up is a ranked name in your band when there is one (an unranked step up gave
	# no place and lost to simply asking for #15); else anyone better.
	var above := pool.filter(func(b): return int(b.get("rank", 0)) > 0 and _place(b) < _place(p) and _in_band(p, b) and float(b["rating"]) > own - 2.0)
	var near := above.filter(func(b): return float(b["rating"]) <= own + STEP_SELLS)   # a step, not a cliff
	if not near.is_empty():
		above = near
	if above.is_empty():
		above = pool.filter(func(b): return float(b["rating"]) > own + 2.0 and float(b["rating"]) <= own + STEP_SELLS and _in_band(p, b))
	var groups := [["below", below], ["level", level]]
	if int(p["ducks"]) < DUCKS_BLOCK and not p.get("rebuild", false):
		groups.append(["above", above])
	var out: Array = []
	for kg in groups:
		var group: Array = kg[1]
		if not group.is_empty():
			var g := guess(group[rng.randi_range(0, group.size() - 1)], rng)
			g["kind"] = kg[0]
			out.append(g)
	return out


## Ask for a named opponent. {ok, reason}: the promoter's answer.
static func ask(p: Dictionary, opp: Dictionary) -> Dictionary:
	if opp.get("retired", false) or opp == p:
		return {"ok": false, "reason": "Not available"}
	if not _in_band(p, opp):
		var top := maxi(1, int(p["rank"]) - BAND_UP) if int(p["rank"]) > 0 else UNRANKED_REACH
		return {"ok": false, "reason": "Too high: you can ask down from #%d" % top}
	if int(opp.get("rank", 0)) > 0 and int(opp["rank"]) <= TOP_ASK and int(p["fans"]) < TOP_ASK_FANS:
		return {"ok": false, "reason": "Not selling yet: a top-%d fight needs more fans" % TOP_ASK}
	if p.get("rebuild", false) and _place(opp) < _place(p):
		return {"ok": false, "reason": "Coming off a loss: win a rebuild fight first"}
	if int(p["ducks"]) >= DUCKS_BLOCK and float(opp["rating"]) <= float(p["rating"]):
		return {"ok": false, "reason": "You turned down the last %d hard fights" % int(p["ducks"])}
	return {"ok": true, "reason": ""}


## The player chose `opp` from these offers: taking a softer fight while a harder one was offered counts as a duck.
static func note_choice(p: Dictionary, choice: Dictionary, offered: Array) -> void:
	var harder := offered.any(func(g): return float(g["opp"]["rating"]) > float(choice["rating"]) + 2.0)
	if harder and not p.get("rebuild", false):   # after a loss the softer fight is the rebuild, not a duck
		p["ducks"] = int(p["ducks"]) + 1   # S397 blind: a duck costs the promoter's patience, not fans (two stop the step ups)
	elif float(choice["rating"]) > float(p["rating"]) + 2.0:
		p["ducks"] = 0


## Fight night, simulated (the bot test and bouts the player does not watch): rolls the bout, then apply_result.
static func fight(p: Dictionary, opp: Dictionary, boxers: Array, rng: RandomNumberGenerator) -> Dictionary:
	var own := float(p["rating"])
	var them := float(opp["rating"])
	var e := edge(p, opp)
	var won := rng.randf() < win_chance(own + e, them)
	var stop := rng.randf() < clampf(absf(them - own) * 0.04, 0.05, 0.45) + (BAD_EDGE_STOP if e <= BAD_EDGE and not won else 0.0)
	var line := apply_result(p, opp, boxers, won, stop)
	p["money"] = int(p["money"]) + int(round(float(int(line["purse"]) + int(line["tickets"])) * GYM_SHARE))
	return line


## What a bout pays the fighter before it is fought: the purse on her own rank and the tickets on fans and closeness.
static func pay_of(p: Dictionary, opp: Dictionary) -> Dictionary:
	var p_rank := int(p["rank"])
	var purse := PURSE_UNRANKED + PURSE_PER_PLACE * maxi(0, 21 - p_rank) if p_rank > 0 else PURSE_UNRANKED
	var o_rank := int(opp.get("rank", 0))
	if o_rank > 0 and (p_rank == 0 or o_rank < p_rank):   # S397 blind round 4: risk pays - the name above you is the draw
		purse += OPP_DRAW_PER_PLACE * (21 - o_rank)
	# a close fight sells, and so does a step up to 6 points (the crowd comes to see her try); a mismatch either way does not
	var gap := float(opp["rating"]) - float(p["rating"])
	var closeness := clampf(1.0 + minf(gap, 0.0) / 15.0 - maxf(gap - STEP_SELLS, 0.0) / 15.0, 0.3, 1.0) + (STEP_BONUS if gap > 2.0 and gap <= STEP_SELLS else 0.0)
	return {"purse": purse, "tickets": int(TICKET_PER_FAN * float(maxi(0, int(p["fans"]) + 5)) * closeness)}


## A result, however it was fought (the career's real fight night calls this too): rank, record, belt, growth, fans,
## damage and rest move here. The money is the caller's (the career pays the gym's share itself).
static func apply_result(p: Dictionary, opp: Dictionary, boxers: Array, won: bool, stop: bool) -> Dictionary:
	var own := float(p["rating"])
	var gap := float(opp["rating"]) - own
	var p_rank := int(p["rank"])
	var o_rank := int(opp.get("rank", 0))
	var pay := pay_of(p, opp)
	var grow := GROW_BASE + GROW_PER_POINT * clampf(gap, 0.0, LEARN_GAP) if gap > -SOFT_GAP else GROW_SOFT
	if won:
		p["w"] = int(p["w"]) + 1
		opp["l"] = int(opp.get("l", 0)) + 1
		if stop:
			p["ko"] = int(p["ko"]) + 1
		p["fans"] = clampi(int(p["fans"]) + 1 + int(gap > 2.0) + int(stop) - int(gap <= -SOFT_GAP), FANS_MIN, FANS_MAX)
		WR.apply_result_in(p, opp, boxers)
		_take_belt(p, opp)
		p["rebuild"] = false
	else:
		grow += GROW_LOSS if gap <= LEARN_GAP and not stop else 0.0
		grow -= STOP_COST if stop else 0.0
		p["l"] = int(p["l"]) + 1
		opp["w"] = int(opp.get("w", 0)) + 1
		p["fans"] = clampi(int(p["fans"]) - loss_fans(gap), FANS_MIN, FANS_MAX)
		p["rebuild"] = true
		WR.apply_result_in(opp, p, boxers)
		if o_rank > 0 and p_rank > o_rank:
			WR.drop_one(p, boxers)
		if stop:
			WA.record_stoppage_loss(p)
			pass
	p["next_weeks"] = next_weeks(gap, stop and not won)
	_record_floor(p, boxers)
	WA.record_bout(p, absf(gap))
	WA.record_bout(opp, absf(gap))
	p["rating"] = snappedf(own + grow, 0.1)
	var line := {"opp": opp["name"], "opp_rank": o_rank, "gap": gap, "edge": edge(p, opp), "won": won, "stop": stop,
		"rank_before": p_rank, "rank_after": int(p["rank"]), "grow": grow, "fans": int(p["fans"]), "purse": int(pay["purse"]),
		"tickets": int(pay["tickets"])}
	(p["log"] as Array).append(line)
	return line


## The chance she is stopped in this fight: her chance to lose times how often the opponent stops the boxers beaten
## (the record's KO share, floored at a tenth: anyone can land one).
static func stop_chance(win_chance_now: float, opp: Dictionary) -> float:
	var wins := int(opp.get("w", 0))
	var ko_share := maxf(0.1, float(opp.get("ko", 0)) / float(wins)) if wins > 0 else 0.25
	return clampf((1.0 - win_chance_now) * ko_share, 0.0, 1.0)


## Weeks to the next fight after this one (gap = opponent minus her): a mismatch is quick, a step up is hard, a stopped
## loss adds the medical rest.
static func next_weeks(gap: float, stopped_loss: bool) -> int:
	var w := QUICK_WEEKS if gap <= -SOFT_GAP else (HARD_WEEKS if gap > 2.0 else NEXT_WEEKS)
	return w + (STOP_REST_WEEKS if stopped_loss else 0)


## Fans a loss costs, by how the fight looked (gap = opponent minus her): a favourite who loses costs 2, a close loss 1,
## an underdog who loses costs none (S397 blind round 4: the loss column read the same on every row).
static func loss_fans(gap: float) -> int:
	return 2 if gap < -2.0 else (1 if gap <= 2.0 else 0)


## A losing or level record cannot sit in the top TOP_RECORD: the boxer drops to the first place under it.
static func _record_floor(p: Dictionary, boxers: Array) -> void:
	while int(p["rank"]) > 0 and int(p["rank"]) <= TOP_RECORD and int(p["l"]) >= int(p["w"]):
		var before := int(p["rank"])
		WR.drop_one(p, boxers)
		if int(p["rank"]) == before:
			return


static func _take_belt(p: Dictionary, opp: Dictionary) -> void:
	var lb := str(opp.get("belt", ""))
	if lb == "":
		return
	var pb := str(p.get("belt", ""))
	if pb != "" and WR.level_index(pb) >= WR.level_index(lb):
		return
	opp["belt"] = ""
	p["belt"] = lb


static func _best_rank(a: int, b: int) -> int:
	var x := a if a > 0 else 99
	var y := b if b > 0 else 99
	return mini(x, y)


static func _place(b: Dictionary) -> int:
	return int(b["rank"]) if int(b.get("rank", 0)) > 0 else 99


static func _in_band(p: Dictionary, b: Dictionary) -> bool:
	var r := int(b.get("rank", 0))
	if r <= 0:
		return true
	var own := int(p["rank"])
	if own <= 0:
		return r >= UNRANKED_REACH
	return r >= own - BAND_UP


static func _opponents(p: Dictionary, boxers: Array) -> Array:
	return boxers.filter(func(b): return b != p and not b.get("retired", false) and not b.get("player", false))
