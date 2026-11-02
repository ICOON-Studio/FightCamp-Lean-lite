## StripeCall - the professor's stripe as a choice (S363, Kalli K-BELTROAD1 "my one first change", SQ26
## Game/Godot/research/K_BELTROAD1_KALLI.md). Before it a due stripe was a notification with a button: free, riskless,
## always pressed. Now three calls, each with a cost:
## - NOW (a stripe is due): morale +NOW_MORALE, loyalty +NOW_LOYAL.
## - HOLD (a stripe is due): no stripe; she trains hungry (NoGi.HUNGRY on the drilled move until it is given), morale
##   -HOLD_MORALE, loyalty -HOLD_LOYAL (Claude: Kalli's spec dropped nothing from loyalty, so the "another club" line could
##   never fire); under ASKS_UNDER loyalty she asks about another club (a news line). One hold per stripe.
## - EARLY (none due, at least half way to the next): morale +EARLY_MORALE; the gym's grading standard slips - from the
##   second early stripe on, members -EARLY_MEMBERS each time and her next open seeds her tough (NoGi.TOUGH).
## Morale is read by NoGi.win_chance (the opens) and moved by her results there (Grapplers._open).
## Pure static; preloads NoGi and BeltRoad.
##   StripeCall.options(f, today) -> {now, hold, early: "" or why not, pick, why}   StripeCall.apply(f, choice, today) -> {...}

const NoGi := preload("res://scripts/rules/NoGi.gd")
const BeltRoad := preload("res://scripts/rules/BeltRoad.gd")

const NOW_MORALE := 6
const NOW_LOYAL := 3
const HOLD_MORALE := 8
const HOLD_LOYAL := 5
const ASKS_UNDER := 50
const EARLY_MORALE := 10
const EARLY_FROM := 2
const EARLY_MEMBERS := 2
## Morale at or over HUNGRY_AT reads as hungry (the coach would hold); under LOW_AT he would give it now.
const HUNGRY_AT := 70
const LOW_AT := 50

const TIPS := {
	"now": "Stripe now: morale +%d, loyalty +%d." % [NOW_MORALE, NOW_LOYAL],
	"hold": "No stripe yet: she drills %d%% harder until it comes, morale -%d, loyalty -%d. Under %d loyalty she looks at other clubs." % [
		int(round((NoGi.HUNGRY - 1.0) * 100)), HOLD_MORALE, HOLD_LOYAL, ASKS_UNDER],
	"early": "Stripe before it is due: morale +%d. From the %dnd early stripe the BJJ members see it (-%d) and her next open is a tougher bracket." % [
		EARLY_MORALE, EARLY_FROM, EARLY_MEMBERS],
}


## What the professor can do today. Each of now / hold / early is "" when open, else the reason it is not; pick is the
## coach's advice ("now", "hold" or "early"... only ever now or hold) with why in his words.
static func options(f: Dictionary, today: int) -> Dictionary:
	var belt := str(f.get("belt", "white"))
	var given := int(f.get("stripes", 0))
	var out := {"now": "", "hold": "", "early": "", "pick": "", "why": ""}
	if BeltRoad.next_belt(belt) == "" or given >= BeltRoad.STRIPES:
		var why := "No stripes left on this belt."
		return {"now": why, "hold": why, "early": why, "pick": "", "why": ""}
	var due := NoGi.stripes_due(f, today)
	if due <= 0:
		out["now"] = "No stripe due yet: one comes each quarter of the way to the next belt."
		out["hold"] = "Nothing to hold back."
		var share := float(BeltRoad.readiness(f, f.get("bjj", {}), today)["share"])
		if share * BeltRoad.STRIPES - given < 0.5:
			out["early"] = "Not half way to stripe %d yet." % (given + 1)
		return out
	out["early"] = "A stripe is due: give it or hold it."
	if int(f.get("held", 0)) == given + 1:
		out["hold"] = "Already held back - she knows it."
	var morale := int(f.get("morale", NoGi.MORALE_START))
	var loyal := int(f.get("loyalty", NoGi.MORALE_START))
	if loyal < ASKS_UNDER:
		out["pick"] = "now"
		out["why"] = "Give it now: %s's loyalty is thin." % f.get("first", "she")
	elif morale < LOW_AT:
		out["pick"] = "now"
		out["why"] = "Give it now: %s needs a lift." % f.get("first", "she")
	elif morale >= HUNGRY_AT and out["hold"] == "":
		out["pick"] = "hold"
		out["why"] = "%s's hungry: holding it back would fire her up." % f.get("first", "She")
	else:
		out["pick"] = "now"
		out["why"] = "She has earned it: give it now."
	return out


## Applies the call to `f` (changed in place). Returns {"ok", "why" (refused), "line" (what happened, for the review),
## "news" (a line for Mail or ""), "members" (the gym's member change)}.
static func apply(f: Dictionary, choice: String, today: int) -> Dictionary:
	var opt := options(f, today)
	if not opt.has(choice) or str(opt[choice]) != "":
		return {"ok": false, "why": str(opt.get(choice, "No such call.")), "line": "", "news": "", "members": 0}
	var first := str(f.get("first", "She"))
	var n := int(f.get("stripes", 0)) + 1
	var log: Array = f.get_or_add("belt_log", [])
	var out := {"ok": true, "why": "", "line": "", "news": "", "members": 0}
	match choice:
		"now":
			f["stripes"] = n
			f.erase("held")
			_add(f, NOW_MORALE, NOW_LOYAL)
			log.append({"d": today, "t": "Stripe %d" % n, "note": ""})
			out["line"] = "Stripe %d given. %s's morale %d, loyalty %d." % [n, first, f["morale"], f["loyalty"]]
		"hold":
			f["held"] = n
			_add(f, -HOLD_MORALE, -HOLD_LOYAL)
			log.append({"d": today, "t": "Stripe %d held back" % n, "note": ""})
			out["line"] = "Stripe %d held back: %s drills hungry until it comes. Morale %d, loyalty %d." % [n, first, f["morale"], f["loyalty"]]
			if int(f["loyalty"]) < ASKS_UNDER:
				out["news"] = "%s asked about another club." % first
		"early":
			f["stripes"] = n
			_add(f, EARLY_MORALE, 0)
			f["early"] = int(f.get("early", 0)) + 1
			log.append({"d": today, "t": "Stripe %d" % n, "note": "given early"})
			out["line"] = "Stripe %d given early. Morale %d." % [n, f["morale"]]
			if int(f["early"]) >= EARLY_FROM:
				f["tough_next"] = true
				out["members"] = -EARLY_MEMBERS
				out["news"] = "Members talk: %s's stripes come easy at this gym (%d members left, her next open is tougher)." % [first, EARLY_MEMBERS]
	return out


static func _add(f: Dictionary, morale: int, loyalty: int) -> void:
	f["morale"] = clampi(int(f.get("morale", NoGi.MORALE_START)) + morale, 0, 100)
	f["loyalty"] = clampi(int(f.get("loyalty", NoGi.MORALE_START)) + loyalty, 0, 100)
