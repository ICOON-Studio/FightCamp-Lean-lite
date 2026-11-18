extends RefCounted
## S515 LADDERWIRE1 stage 1 (season ladder v6, owner's yes Q-S294-270; map ops/research/DESIGN_LADDER1_V6_DOLA.md R1-R3,
## R10 seeding): every amateur, ours and the region's rivals, carries LADDER POINTS (0-100, key "rep"). An amateur bout
## moves both sides by LadderRep.change (the map's chess-style table: beating a better boxer pays more). A boxer with no
## points yet is seeded from the record: max(0, 8 + 4 x net wins + bouts), at most 65 (R10). Stage 1 only moves and shows
## the points (result page); the ladder table, the Ask card's reach / will-they-say-yes and the clock come next.
##   rep_of(x) -> int (seeds and stores)   method_of(cards, stop, won) -> "ud" / "split" / "majority" / "stop"
##   settle(a, b, outcome, method) -> {a_delta, b_delta, a_rep, b_rep}   (outcome is a's: "win" / "loss" / "draw")

const LadderRep := preload("res://scripts/rules/LadderRep.gd")
const AmateurBooking := preload("res://scripts/rules/AmateurBooking.gd")

const SEED_BASE := 8
const SEED_PER_NET_WIN := 4
const SEED_MAX := 65


static func seed_of(w: int, l: int) -> int:
	return clampi(SEED_BASE + SEED_PER_NET_WIN * (w - l) + AmateurBooking.bouts_of(w, l), 0, SEED_MAX)


static func rep_of(x: Dictionary) -> int:
	if not x.has("rep"):
		x["rep"] = seed_of(int(x.get("w", 0)), int(x.get("l", 0)))
	return int(x["rep"])


## The decision's kind from the judges' cards ("ours-theirs"): all three for the winner = unanimous, one a draw = majority,
## one against = split. A stoppage is "stop". No readable cards = unanimous.
static func method_of(cards: Array, stop: String, won: bool) -> String:
	if stop != "":
		return "stop"
	var forw := 0
	var even := 0
	var n := 0
	for s in cards:
		var p := str(s).split("-")
		if p.size() != 2 or not p[0].is_valid_int() or not p[1].is_valid_int():
			continue
		n += 1
		var d := int(p[0]) - int(p[1])
		if d == 0:
			even += 1
		elif (d > 0) == won:
			forw += 1
	if n < 3 or forw == n:
		return "ud"
	return "majority" if even > 0 and forw + even == n else "split"


## Both sides move on the same bout: a's change from a's side of the table, b's from b's.
static func settle(a: Dictionary, b: Dictionary, outcome: String, method: String) -> Dictionary:
	var ra := rep_of(a)
	var rb := rep_of(b)
	var b_out := {"win": "loss", "loss": "win"}.get(outcome, "draw") as String
	var da := LadderRep.change(ra, rb, outcome, method)
	var db := LadderRep.change(rb, ra, b_out, method)
	a["rep"] = LadderRep.apply(ra, da)
	b["rep"] = LadderRep.apply(rb, db)
	return {"a_delta": int(a["rep"]) - ra, "b_delta": int(b["rep"]) - rb, "a_rep": int(a["rep"]), "b_rep": int(b["rep"])}
