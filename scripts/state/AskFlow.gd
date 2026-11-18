extends RefCounted
## S512 ASKFIGHT1 build (owner "Yes, build it"; map v4 in ops/research/ASKFIGHT_CRITIC_S511_BRIEF.md, round-4 critics Dola 7/7 +
## Goose 7/7): the career side of ASK FOR A FIGHT. The rules are pure (AskBout, AskDates, FightLearn); this reads the career
## into them, books an ask through the sheet's own accept path (Bouts.accept: poster, fight week, morale, the head coach's
## read), and applies what an amateur fight teaches (FightLearn, every fight ability, as ASKPROBE2 measured it).
## Game text never says he, she, her or him.

const AskLadder := preload("res://scripts/state/AskLadder.gd")   # S516 LADDERWIRE stage 2
const AskBout := preload("res://scripts/rules/AskBout.gd")
const AskDates := preload("res://scripts/rules/AskDates.gd")
const FightLearn := preload("res://scripts/rules/FightLearn.gd")
const StopWord := preload("res://scripts/rules/StopWord.gd")
const WeighGap := preload("res://scripts/rules/WeighGap.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const AmateurBooking := preload("res://scripts/rules/AmateurBooking.gd")
const BoutRead := preload("res://scripts/rules/BoutRead.gd")
const Region := preload("res://scripts/state/Region.gd")
const Data := preload("res://scripts/state/Data.gd")
const Champs := preload("res://scripts/state/Champs.gd")

## The abilities a fight teaches (ASKPROBE2's STATS: the growth is added to each, as measured).
const TAUGHT := ["power", "speed", "technique", "defense", "conditioning", "fight_iq"]
## The next club shows the panel offers side by side (round-4 critics: the soonest and the one after).
const SHOWS := 2


## The fighter in AskBout's words (its header lists the keys).
static func input(c: Career, f: Dictionary) -> Dictionary:
	var b: Dictionary = f.get("bout", {})
	var waiting := false
	var expires := -1
	for o in f.get("offers", []):
		if not bool(o["answered"]) and not bool(o.get("mismatch", false)):
			waiting = true
			expires = int(o["expires"])
	var inj: Dictionary = f.get("injury", {})
	var out := {"name": str(f["name"]), "w": int(f["w"]), "l": int(f["l"]), "d": int(f.get("d", 0)), "pro": bool(f.get("pro", false)),
		"discipline": str(f.get("discipline", "boxing")), "booked": b.has("day"), "bout_day": int(b.get("day", -1)),
		"offer_waiting": waiting, "offer_expires": expires, "fit": inj.is_empty(), "healed_day": int(inj.get("until_day", -1)),
		"in_nationals": Champs.active(f), "weight": float(f["weight"]), "limit": float(f["limit"])}
	if f.has("last_bout_day"):   # day numbers can be negative: only a missing key means "never fought here"
		out["last_bout_day"] = int(f["last_bout_day"])
	return out


## Open or closed, with the reason and the day it opens (AskBout.open).
static func open(c: Career, f: Dictionary) -> Dictionary:
	var a := input(c, f)
	var bouts: GDScript = load("res://scripts/state/Bouts.gd")   # Bouts preloads this module's callers: a runtime load
	return AskBout.open(a, c.day, int(bouts.AFTER_FIGHT))


## Our other fighters' nights: [{name, day}] (one slot a show).
static func taken(c: Career, f: Dictionary) -> Array:
	var out: Array = []
	for g in c.fighters:
		if str(g["id"]) != str(f["id"]) and (g["bout"] as Dictionary).has("day"):
			out.append({"name": str(g["first"]), "day": int(g["bout"]["day"])})
	return out


## The panel's two dates, each with its scale forecast: AskDates.shows + Sim.weigh_forecast.
static func shows(c: Career, f: Dictionary) -> Array:
	var sim: GDScript = load("res://scripts/state/Sim.gd")
	var out: Array = AskDates.shows(c.day, Region.next_shows(c.day, 8), taken(c, f), Callable(Clock, "fmt"), SHOWS)
	for s in out:
		var fc: Dictionary = sim.weigh_forecast(c, f, int(s["day"]))
		s["forecast"] = fc
		# S514: a club show matches walking weights within a gap (Bouts.weigh, WeighGap): over the class limit but inside the
		# gap with the boxer the sheet would send still boxes - the date was greyed "Weight at risk" before.
		s["in_gap"] = not bool(fc.get("ok", true)) and in_gap(c, f, float(fc.get("day", f["weight"])))
		s["weight_ok"] = bool(fc.get("ok", true)) or bool(s["in_gap"])
		s["can_ask"] = bool(s["weight_ok"]) and str(s.get("holder", "")) == ""
	return out


## A club show's scale: `own_kg` inside the walking-weight gap (WeighGap) with the boxer the sheet would send.
static func in_gap(c: Career, f: Dictionary, own_kg: float) -> bool:
	var opp := c.rival(sheet_name(c, f))
	var lim := float(f["limit"])
	return not opp.is_empty() and WeighGap.in_gap(own_kg, float(opp.get("weight", lim)), lim)


## The name the sheet would send next (the matchmaker's own rule, Bouts.legal_index).
static func sheet_name(c: Career, f: Dictionary) -> String:
	var bouts: GDScript = load("res://scripts/state/Bouts.gd")
	var names: Array = Data.DIVISIONS[f["div"]]["opponents"]
	var own := AmateurBooking.bouts_of(int(f["w"]), int(f["l"]))
	return str(names[bouts.legal_index(c, names, int(f["opp_index"]), own)])


## The answers as cards: [{kind, label, opp (the rival), card (AskBout.card), teaches}] and the missing ones with reasons.
static func answers(c: Career, f: Dictionary) -> Dictionary:
	var rows := Region.rankings(c, str(f["div"]))
	var sheet := sheet_name(c, f)
	var me := input(c, f)
	var ranked := int(f["w"]) >= Region.RANK_MIN_WINS
	var out: Array = []
	for a in AskBout.answers(me, rows, sheet, Region.RANK_MIN_WINS):
		for nm in a["names"]:
			var opp := c.rival(str(nm))
			if opp.is_empty():
				continue
			var teach := teach_word(c, f, opp, str(a["kind"]))
			var stop := StopWord.word(gap_of(f, opp))
			out.append({"kind": str(a["kind"]), "opp": opp, "teaches": teach, "stoppage": stop, "ladder": AskLadder.lines(c, f, opp),
				"card": AskBout.card(opp, str(a["kind"]), rows, Region.RANK_MIN_WINS, teach, stop, ranked)})
	return {"cards": out, "absent": AskDates.absent(me, rows, sheet, Region.RANK_MIN_WINS)}


## The rating gap the card's words read (STOPWORD1, docs/STOPWORD1_RESULT.md): the opponent's rating minus our fight power.
static func gap_of(f: Dictionary, opp: Dictionary) -> float:
	return float(opp["rating"]) - BoutRules.fight_power(f["stats"], {}, 0, "")


## The card's teaching word: the expected growth at the middle of the win band (FightLearn's own arithmetic).
static func teach_word(c: Career, f: Dictionary, opp: Dictionary, kind: String) -> String:
	var gap := gap_of(f, opp)
	var band := BoutRead.band(f, opp, BoutRead.camp_for(f, 14), c.seed, float(c.coach.get("rating", 0.0)))
	var p := clampf((float(band["lo"]) + float(band["hi"])) * 0.5, 0.0, 1.0)
	var e := p * FightLearn.teach_for(kind, gap, true, false) + (1.0 - p) * FightLearn.teach_for(kind, gap, false, false)
	return FightLearn.word(e)


## Book the ask through the sheet's own accept path. kind "name" = the host keeps the gate (no ticket cut for the club).
static func book(c: Career, f: Dictionary, kind: String, opp_name: String, day: int) -> bool:
	if not bool(open(c, f)["open"]):
		return false
	var opp := c.rival(opp_name)
	if opp.is_empty():
		return false
	# S516 LADDERWIRE stage 2: an ask for a name (a step up, a name you pick) can be out of reach or refused, with the reason;
	# the sheet's name is the host's own offer - already agreed.
	var lad := AskLadder.lines(c, f, opp)
	f.erase("ask_no")
	if kind != "sheet" and (not bool(lad["askable"]) or not bool(lad["yes"])):
		f["ask_no"] = {"name": opp_name, "words": str(lad["reach"]) if not bool(lad["askable"]) else
			"Their corner said No - %s." % str(lad["reason"])}   # names only in headers (S448)
		return false
	var bouts: GDScript = load("res://scripts/state/Bouts.gd")
	var own := AmateurBooking.bouts_of(int(f["w"]), int(f["l"]))
	var o: Dictionary = bouts._offer("%s:a%d" % [f["id"], c.day], opp.duplicate(true), day, c.day, own)
	if bool(o["mismatch"]):
		return false
	f["offers"] = [o]
	if not bouts.accept(c, str(o["id"])):
		return false
	f["bout"]["ask_kind"] = kind
	f["bout"]["host_gate"] = kind == "name"
	if kind == "sheet":
		f["opp_index"] = int(f["opp_index"]) + 1   # the sheet's name in turn was used: the next sheet sends the one after
	return true


## After an amateur bout: the growth the fight taught, added to every fight ability (ASKPROBE2's model); a step up x1.25.
## Returns {grow, kind} for the result page ("What it taught"); grow 0 = nothing (a stoppage loss can teach nothing).
static func teach_after(f: Dictionary, opp: Dictionary, won: bool, stopped: bool) -> Dictionary:
	var kind := str((f.get("bout", {}) as Dictionary).get("ask_kind", "sheet"))
	var gap := float(opp.get("rating", 0.0)) - BoutRules.fight_power(f["stats"], {}, 0, "")
	var grow := maxf(0.0, FightLearn.teach_for(kind, gap, won, stopped))
	for k in TAUGHT:
		if (f["stats"] as Dictionary).has(k):
			f["stats"][k] = float(f["stats"][k]) + grow
	return {"grow": grow, "kind": kind}


## The result page's line.
static func taught_words(t: Dictionary) -> String:
	var g := float(t.get("grow", 0.0))
	if g <= 0.0:
		return "What it taught: nothing - a stoppage teaches nothing."
	var step := " (a step up teaches a quarter more)" if str(t.get("kind", "")) == "step_up" else ""
	return "What it taught: %s - every fight ability +%.1f%s." % [FightLearn.word(g), g, step]
