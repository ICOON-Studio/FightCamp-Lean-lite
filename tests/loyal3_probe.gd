extends SceneTree
## LOYAL3 (S486): a rival club (Eastside ABC) approaches; a bot club answers. Does any one of
## the five answers always win, or is each best for some clubs? A probe: it prints shares.
##
## Model: R58 "a fighter leaves", ops/research/R58_MAP_S439.md section 4 M4 "THE HAND MODEL", priced
## with the game's own rules: Approach.answers(v) gives the five columns and Approach.talk_chance()
## the talk. Every number below is the task's bot model (ESTIMATE), none is re-implemented from
## Approach: loyalty_end, holder_end, cash, train and holder_train all come out of answers().
##
## Per club (seeded, 6,000 clubs per cash band):
##   cash in the band; weekly net -$450..+$150; the approached fighter loyalty 25-34,
##   coachability 0-100, worth to the club $2,000-8,000; a team-mate holds the stipend 7 in 10
##   (loyalty 50-80); that team-mate's two-win chance 0.15-0.70 and their pro share $1,500;
##   a show bookable 6 in 10, its night's net -$800..+$2,500; ticks 3, ticks_after_show 2,
##   holder_ticks 3, group "keep" (the map's week).
## The weekly net is drawn because the map drew it; the value model below prices cash by the
## weight w only, so the net never enters an answer's value.
##
## Value of an answer to a bot (negative = the club pays):
##   w = clamp(8000 / cash, 0.2, 1.5)                       a dollar matters more to a short club
##   value = w * column cash                                the column's cash, negative = paid
##   - leave_chance(loyalty_end) * worth                    the fighter walks in the next half year
##   - leave_chance(holder_end) * $1,000                    the team-mate walks (when there is one)
##   - (1 - train) * $1,200, (1 - holder_train) * $1,200    a training multiplier under 1.0
##   - (1 - holder_train) * two_win * $1,500                MOVE only: the holder's pro road
##   + show night's net                                     PROMISE only
##   PROMISE only: unfit on the night 1 in 20 and then the leaving chance is 100%, so the fighter's
##   expected loss is worth * (0.95 * leave_chance(loyalty_end) + 0.05).
##   LET THEM GO: leaving chance 100% (the answer is the leaving).
## leave_chance is the map's ladder on the loyalty read 12 weeks on: 50+ 2%, 45-49 10%, 40-44 20%,
## 35-39 35%, 30-34 55%, under 30 70%.
##
## The talk: a bot talks first when chance * best(landed view) + (1 - chance) * best(failed view,
## loyalty - 4) beats best(no talk); chance is Approach.talk_chance(coachability). Then it takes the
## best AVAILABLE answer.
##
## BY CONSTRUCTION (arithmetic, not tuning):
##   MATCH IT and MOVE THE STIPEND read +12 loyalty for the fighter, so they differ only in cash and
##   in the holder. Match costs w * $3,000; move costs the holder at most
##   (0.55 - 0.02) * $1,000 + (1 - 0.85) * $1,200 + 0.15 * 0.70 * $1,500
##   = $530 + $180 + $157.50 = $867.50 (holder 50-51 falls from the 2% rung to the 55% rung: the
##   worst case). In tight (w >= 1.333, match >= $4,000) and in drawn (w >= 0.533, match >= $1,600)
##   match can never beat move; only above about $27,700 of cash (w < 0.289) can it. So MATCH IT is
##   expected to win only in the rich band's top half. That is the design's question: reported,
##   not tuned.
##
## Run: godot --headless --audio-driver Dummy --fixed-fps 60 --path .
##      --script res://tests/loyal3_probe.gd
## Prints one line per band and over all, then the two gates. quit(0): a probe reports, it does
## not fail.

const Approach := preload("res://scripts/rules/Approach.gd")

const SEED := 4861
const DAY := 91
const CLUBS := 6000
const IDS := ["match", "half", "move", "promise", "let_go"]
const BANDS := ["tight", "drawn", "rich"]
const BAND_LO := [1500, 6000, 15000]
const BAND_HI := [6000, 15000, 40000]

## Gate 1: every answer best in at least one band at this share (%) or more.
const FLOOR := 5.0
## Gate 2: no answer over this share (%) in any band.
const CEILING := 60.0

const HOLDER_WORTH := 1000.0
const PRO_SHARE := 1500.0
const TRAIN_COST := 1200.0
const UNFIT := 0.05


func _initialize() -> void:
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	rng.seed = SEED
	var all_counts: Dictionary = _zero_counts()
	var all_talked: int = 0
	var band_counts: Array = []
	for b in range(BANDS.size()):
		var name: String = str(BANDS[b])
		var rows: Dictionary = _run_band(rng, int(BAND_LO[b]), int(BAND_HI[b]))
		var counts: Dictionary = rows["counts"]
		var talked: int = int(rows["talked"])
		band_counts.append(counts)
		_line(name, counts, CLUBS, talked)
		for id_item in IDS:
			var id: String = str(id_item)
			all_counts[id] = int(all_counts[id]) + int(counts[id])
		all_talked += talked
	_line("all", all_counts, CLUBS * BANDS.size(), all_talked)

	var gate1: bool = _gate1(band_counts)
	var gate2: bool = _gate2(band_counts)
	var ok: bool = gate1 and gate2
	print("LOYAL3 pass=%d gate1=%d gate2=%d" % [1 if ok else 0, 1 if gate1 else 0, 1 if gate2 else 0])
	quit(0)


## 6,000 bot clubs in one cash band: every club answers, counted by the answer it picked.
func _run_band(rng: RandomNumberGenerator, lo: int, hi: int) -> Dictionary:
	var counts: Dictionary = _zero_counts()
	var talked: int = 0
	for i in range(CLUBS):
		var club: Dictionary = _draw(rng, lo, hi)
		var loyalty: int = int(club["loyalty"])
		var chance: float = Approach.talk_chance(int(club["coachability"]))
		var plain: Dictionary = _view(club, loyalty, "")
		var no_talk: float = float(_best(plain, club)["value"])
		var landed: Dictionary = _view(club, loyalty, "landed")
		var failed: Dictionary = _view(club, loyalty - 4, "failed")
		var best_landed: float = float(_best(landed, club)["value"])
		var best_failed: float = float(_best(failed, club)["value"])
		var after: float = chance * best_landed + (1.0 - chance) * best_failed
		var view: Dictionary = plain
		if after > no_talk:
			talked += 1
			# Approach.talk rolls the same way: landed when the roll is under the chance.
			view = landed if rng.randf() < chance else failed
		var pick: String = str(_best(view, club)["id"])
		counts[pick] = int(counts[pick]) + 1
	return {"counts": counts, "talked": talked}


## One bot club's state, drawn in a fixed order so the seed reproduces the run.
func _draw(rng: RandomNumberGenerator, lo: int, hi: int) -> Dictionary:
	var cash: int = int(rng.randf_range(float(lo), float(hi)))
	var weekly_net: int = int(rng.randf_range(-450.0, 150.0))
	var loyalty: int = rng.randi_range(25, 34)
	var coachability: int = rng.randi_range(0, 100)
	var worth: int = int(rng.randf_range(2000.0, 8000.0))
	var has_holder: bool = rng.randf() < 0.7
	var holder_loyalty: int = 0
	if has_holder:
		holder_loyalty = rng.randi_range(50, 80)
	var two_win: float = rng.randf_range(0.15, 0.70)
	var can_book: bool = rng.randf() < 0.6
	var show_net: int = int(rng.randf_range(-800.0, 2500.0))
	return {
		"cash": cash,
		"weekly_net": weekly_net,
		"loyalty": loyalty,
		"coachability": coachability,
		"worth": worth,
		"has_holder": has_holder,
		"holder_loyalty": holder_loyalty,
		"two_win": two_win,
		"can_book": can_book,
		"show_net": show_net,
	}


## The view Approach.answers reads, built from the club (the map's week: 3 / 2 / 3 ticks).
func _view(club: Dictionary, loyalty: int, talk: String) -> Dictionary:
	var holder: Dictionary = {}
	if bool(club["has_holder"]):
		holder = {"loyalty": int(club["holder_loyalty"])}
	return {
		"loyalty": loyalty,
		"talk": talk,
		"group": "keep",
		"holder": holder,
		"can_book": bool(club["can_book"]),
		"ticks": 3,
		"ticks_after_show": 2,
		"holder_ticks": 3,
		"day": DAY,
	}


## Leaving chance in the next half year by the loyalty read at the window's end (the map's ladder).
func leave_chance(loyalty_end: int) -> float:
	if loyalty_end >= 50:
		return 0.02
	if loyalty_end >= 45:
		return 0.10
	if loyalty_end >= 40:
		return 0.20
	if loyalty_end >= 35:
		return 0.35
	if loyalty_end >= 30:
		return 0.55
	return 0.70


## What one Approach answer column is worth to this bot: cash it spends, losses it takes.
func _value(col: Dictionary, club: Dictionary) -> float:
	var id: String = str(col["id"])
	var cash: int = int(club["cash"])
	var w: float = clampf(8000.0 / float(cash), 0.2, 1.5)
	var value: float = w * float(int(col["cash"]))
	if id == "promise":
		value += float(int(club["show_net"]))
	var worth: float = float(int(club["worth"]))
	var leave: float = 1.0 if id == "let_go" else leave_chance(int(col["loyalty_end"]))
	if id == "promise":
		leave = (1.0 - UNFIT) * leave + UNFIT
	value -= leave * worth
	if bool(club["has_holder"]):
		value -= leave_chance(int(col["holder_end"])) * HOLDER_WORTH
	var train: float = float(col["train"])
	if train < 1.0:
		value -= (1.0 - train) * TRAIN_COST
	var holder_train: float = float(col["holder_train"])
	if holder_train < 1.0:
		value -= (1.0 - holder_train) * TRAIN_COST
	if id == "move" and bool(club["has_holder"]):
		var two_win: float = float(club["two_win"])
		value -= (1.0 - holder_train) * two_win * PRO_SHARE
	return value


## The best answer for one view: the highest value among the columns the card offers.
## Column order breaks a tie (match, half, move, promise, let_go): the first one holds.
func _best(view: Dictionary, club: Dictionary) -> Dictionary:
	var best_id: String = ""
	var best_value: float = 0.0
	for item in Approach.answers(view):
		var col: Dictionary = item
		if not bool(col["available"]):
			continue
		var v: float = _value(col, club)
		if best_id == "" or v > best_value:
			best_id = str(col["id"])
			best_value = v
	return {"id": best_id, "value": best_value}


func _zero_counts() -> Dictionary:
	var counts: Dictionary = {}
	for id_item in IDS:
		counts[str(id_item)] = 0
	return counts


## `LOYAL3 band=<name> match=<x> half=<x> move=<x> promise=<x> let_go=<x> talked=<x>` (percent).
func _line(name: String, counts: Dictionary, n: int, talked: int) -> void:
	var parts: Array = []
	var total: float = float(n)
	for id_item in IDS:
		var id: String = str(id_item)
		var share: float = 100.0 * float(int(counts[id])) / total
		parts.append("%s=%.1f" % [id, share])
	parts.append("talked=%.1f" % (100.0 * float(talked) / total))
	print("LOYAL3 band=%s %s" % [name, " ".join(parts)])


## Gate 1: every answer is the best in at least one band at FLOOR or more.
func _gate1(band_counts: Array) -> bool:
	for id_item in IDS:
		var id: String = str(id_item)
		var found: bool = false
		for item in band_counts:
			var counts: Dictionary = item
			if _share(counts, id) >= FLOOR:
				found = true
		if not found:
			return false
	return true


## Gate 2: no answer is over CEILING in any band.
func _gate2(band_counts: Array) -> bool:
	for id_item in IDS:
		var id: String = str(id_item)
		for item in band_counts:
			var counts: Dictionary = item
			if _share(counts, id) > CEILING:
				return false
	return true


func _share(counts: Dictionary, id: String) -> float:
	return 100.0 * float(int(counts[id])) / float(CLUBS)
