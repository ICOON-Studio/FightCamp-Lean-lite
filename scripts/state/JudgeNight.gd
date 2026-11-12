extends RefCounted
## S443 R29 THE JUDGES at fight night (FIGHT_LINK_MAP_S432.md M2): three judges (scripts/rules/Judges.gd) read the bout's
## exchanges, each with a lean, a standing count 10-8 on every card. Every judged bout keeps them on m["judges"] (for the
## result page's JudgeCards). They DECIDE the cards and the verdict only when DECIDES is on: S443 HOLD (coordinator, from
## the probe tools/judges_agree_probe.gd): until JUDGES1 sets the weights and gives BoutRead the judges' model
## (ops/research/TASK_JUDGES1.md), BoutRules.cards_of decides, so the shown win chance stays true. `judgesdecide` on the
## command line turns it on for a probe or a still. Nothing here rolls the fight: the panel is seeded by the bout.

const Judges := preload("res://scripts/rules/Judges.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const Attrs := preload("res://scripts/rules/Attrs.gd")
const AttrGen := preload("res://scripts/rules/AttrGen.gd")
const PaceAim := preload("res://scripts/rules/PaceAim.gd")

## The switch JUDGES1 flips in one step once the weights and BoutRead's model pass their bands.
const DECIDES := false

## The lean in game words, for the cards ("Ring judge": scores who kept the fight where they boxed best).
const LEAN_WORD := {"clean": "Clean punches", "ring": "Ring control", "initiative": "Coming forward", "work": "Work rate"}
const LEAN_TIP := {
	"clean": "Counts the punches that land; a landed punch counts double on this card.",
	"ring": "Counts the exchanges won at the distance the boxer wanted; double on this card.",
	"initiative": "Counts the exchanges won by stepping in to the closer distance; double on this card.",
	"work": "Counts the busier pace; double on this card.",
}


## The bout's three judges, drawn once a bout from its own seed (the day, the fighter, the opponent).
static func panel(f: Dictionary) -> Array:
	var fb: Dictionary = f.get("bout", {})
	if not fb.has("judges"):
		var opp: Dictionary = fb.get("opp", {})
		fb["judges"] = Judges.panel(hash([int(fb.get("day", 0)), str(f.get("id", "")), str(opp.get("name", ""))]), bool(fb.get("pro", false)))
	return fb["judges"]


## One played round as the judges read it: {exs, counts [a, b], pace [a, b], start}.
static func round_of(r: Dictionary, own_pace: float, opp_pace: float) -> Dictionary:
	var exs: Array = r.get("exchanges", [])
	var counts := [0, 0]
	if str(r.get("down", "")) != "":
		counts[0 if str(r["down"]) == "a" else 1] = int(r.get("counts", 0))
	# Our side's work rate this round: the boxer's pace attribute times the corner's pace call (PaceAim.output).
	var out := 0.0
	for x in exs:
		out += PaceAim.output(str((x as Dictionary).get("pace", "steady")))
	var mult := out / float(exs.size()) if not exs.is_empty() else 1.0
	return {"exs": exs, "counts": counts, "pace": [roundi(clampf(own_pace * mult, 0.0, 100.0)), roundi(clampf(opp_pace, 0.0, 100.0))],
		"start": r.get("start", {})}


## The judges over the bout so far: Judges.cards + {leans, reasons}; {} when a round has no exchanges to read.
static func score(f: Dictionary, m: Dictionary) -> Dictionary:
	var played: Array = m.get("rounds", [])
	if played.is_empty() or played.any(func(r): return not (r as Dictionary).has("exchanges")):
		return {}
	var fb: Dictionary = f.get("bout", {})
	var opp: Dictionary = fb.get("opp", {})
	var own_pace := float(Attrs.of(f).get("pace", 55.0))
	var opp_pace := float(AttrGen.attrs_of(opp).get("pace", 55.0)) if not opp.is_empty() else 55.0
	var rounds: Array = played.map(func(r): return round_of(r, own_pace, opp_pace))
	var leans := panel(f)
	var names := [str(f.get("first", "Red")), str(opp.get("first", opp.get("name", "Blue")))]
	var j := Judges.cards(rounds, leans, bool(fb.get("pro", false)), names)
	j["leans"] = leans.duplicate()
	j["reasons"] = [Judges.card_reason(j, 0), Judges.card_reason(j, 1), Judges.card_reason(j, 2)]
	return j


static func decides() -> bool:
	return DECIDES or OS.get_cmdline_user_args().has("judgesdecide")


## The three cards as "29-28" text (ours first). Keeps the judges on m["judges"] (with "decides") whenever the rounds carry
## exchanges; the cards come from them only when decides(), else (and for rounds with no exchanges) BoutRules.cards_of.
## Deciding, each round also carries its three scores (r["judges"]) for the round chips (Broadcast.judge_rounds).
static func cards(f: Dictionary, m: Dictionary) -> Array:
	var j := score(f, m)
	if j.is_empty():
		m.erase("judges")
		return BoutRules.cards_of(m.get("rounds", []))
	j["decides"] = decides()
	m["judges"] = j
	if not bool(j["decides"]):
		return BoutRules.cards_of(m["rounds"])
	var played: Array = m["rounds"]
	for i in played.size():
		(played[i] as Dictionary)["judges"] = (j["by_round"] as Array)[i]
	return (j["cards"] as Array).map(func(c): return "%d-%d" % [int(c[0]), int(c[1])])


## The result's headline words from the judges: "Split decision", "Majority decision", "Unanimous decision", "Draw".
static func verdict_words(m: Dictionary) -> String:
	var j: Dictionary = m.get("judges", {})
	match str(j.get("verdict", "")):
		"unanimous":
			return "Unanimous decision"
		"split":
			return "Split decision"
		"majority":
			return "Majority decision"
		"draw":
			return "Draw"
	return ""
