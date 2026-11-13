extends SceneTree
## S442 LOOP drawing 3: the headline card's words (Headline.headline(facts)), built only from what the bout booked.
## The facts are the shape AfterFight.night_facts writes into the result modal (m["night"]).
##   1. the S442 bout as drawn: a split loss, the FightWhy cause, records and ranks before -> after, no milestone.
##   2. the measured replay as a win: the split's flip round decides it; entering the rankings is the milestone.
##   3. a first win, a unanimous win, a stoppage, a draw, a majority; a pro night has no rank lines.
##   4. no he/she/her/him in any word it builds.

const Headline := preload("res://scripts/rules/Headline.gd")

var failures := 0


func _initialize() -> void:
	var loss := _lucy({})
	var h := Headline.headline(loss)
	_check(str(h.get("title", "")) == "Lucy loses on a split, 2-1", "split loss title (%s)" % str(h.get("title", "")))
	_check(str(h.get("tone", "")) == "loss", "a loss reads as a loss")
	_check(str(h.get("cause", "")) == "One-two-hook was the wrong answer to a counter-puncher, 3 times.",
		"a loss's cause is FightWhy's against line, first sentence (%s)" % str(h.get("cause", "")))
	_check((h.get("milestone", {}) as Dictionary).is_empty(), "a loss is no milestone")
	_check(str(h.get("night", "")) == "Fight night · Sat 7 Mar · Lightweight · 3 rounds", "the night line (%s)" % str(h.get("night", "")))
	_check(h.get("rec", []) == ["3-1 → 3-2", "5-1 → 6-1"], "records before -> after (%s)" % str(h.get("rec", [])))
	_check(h.get("rank", []) == ["Unranked", "No. 4 → No. 3"], "ranks before -> after (%s)" % str(h.get("rank", [])))

	# 2. The replay without line C: a split win; round 2 flipped by judge 3 and it enters the rankings.
	var win := _lucy({"outcome": "win", "cards": ["29-28", "29-28", "28-29"], "won": [false, true, true], "won_n": [2, 4, 4], "flip": 1,
		"rec_after": [4, 1, 0], "opp_rec_after": [5, 2, 0], "rank_after": 7, "opp_rank_after": 4})
	var hw := Headline.headline(win)
	_check(str(hw["title"]) == "Lucy wins on a split, 2-1", "split win title (%s)" % str(hw["title"]))
	_check(str(hw["cause"]) == "Round 2 decided it: your boxer won 4 of 6 exchanges; judge 3 gave it to the opponent.",
		"a split win names the flip round (%s)" % str(hw["cause"]))
	_check(str((hw["milestone"] as Dictionary).get("kind", "")) == "ranked" and str(hw["milestone"]["words"]) == "Enters the rankings",
		"unranked -> ranked is the milestone (%s)" % str(hw["milestone"]))
	_check(hw["rank"] == ["Unranked → No. 7", "No. 4"], "rank lines on entering (%s)" % str(hw["rank"]))

	# 3a. A first win (0 wins before), unanimous: the clearest round names it.
	var first := _lucy({"outcome": "win", "cards": ["30-27", "30-27", "30-27"], "won": [true, true, true], "won_n": [4, 5, 4], "flip": -1,
		"rec_before": [0, 1, 0], "rec_after": [1, 1, 0], "rank_before": 0, "rank_after": 0})
	var hf := Headline.headline(first)
	_check(str(hf["title"]) == "Lucy wins on points, 3-0", "unanimous title (%s)" % str(hf["title"]))
	_check(str((hf["milestone"] as Dictionary).get("kind", "")) == "first_win" and str(hf["milestone"]["words"]) == "First win",
		"a first win is the milestone (%s)" % str(hf["milestone"]))
	_check(str(hf["cause"]) == "Round 2 was the clearest: your boxer won 5 of 6 exchanges.", "unanimous cause (%s)" % str(hf["cause"]))
	# 3b. A second win is no milestone; a pro's first win says pro.
	var second := _lucy({"outcome": "win", "cards": ["30-27", "30-27", "30-27"], "won": [true, true, true], "won_n": [4, 4, 4], "flip": -1,
		"rec_before": [1, 1, 0], "rec_after": [2, 1, 0]})
	_check((Headline.headline(second)["milestone"] as Dictionary).is_empty(), "a second win is no milestone")
	_check(str(Headline.headline(second)["cause"]) == "Round 3 was the clearest: your boxer won 4 of 6 exchanges.", "ties go to the later round")
	var pro := _lucy({"outcome": "win", "pro": true, "rounds": 4, "cards": ["40-36", "40-36", "40-36"], "won": [true, true, true, true],
		"won_n": [4, 4, 4, 4], "flip": -1, "rec_before": [0, 0, 0], "rec_after": [1, 0, 0]})
	var hp := Headline.headline(pro)
	_check(str(hp["milestone"].get("words", "")) == "First pro win" and hp["rank"] == ["", ""], "a pro night: first pro win, no amateur ranks (%s)" % str(hp))
	_check(str(hp["night"]).begins_with("Pro night"), "a pro night says so (%s)" % str(hp["night"]))
	# 3c. Stoppages.
	var ko := _lucy({"outcome": "win", "stopped": "KO", "won": [true, true], "won_n": [4, 5], "flip": -1, "cards": ["20-18", "20-18", "20-18"]})
	var hk := Headline.headline(ko)
	_check(str(hk["title"]) == "Lucy wins by knockout in round 2", "KO win title (%s)" % str(hk["title"]))
	_check(str(hk["cause"]) == "Round 2 decided it: the opponent did not beat the count.", "KO cause (%s)" % str(hk["cause"]))
	var rsc := _lucy({"outcome": "loss", "stopped": "RSC", "won": [false, false, false], "won_n": [2, 1, 1]})
	_check(str(Headline.headline(rsc)["title"]) == "Lucy loses by stoppage in round 3", "RSC loss title (%s)" % str(Headline.headline(rsc)["title"]))
	# 3d. A draw and a majority.
	var draw := _lucy({"outcome": "draw", "cards": ["38-38", "39-37", "37-39"], "rounds": 4})
	var hd := Headline.headline(draw)
	_check(str(hd["title"]) == "Lucy and Priya draw" and str(hd["tone"]) == "draw", "a draw (%s)" % str(hd["title"]))
	var maj := _lucy({"outcome": "win", "cards": ["39-37", "38-38", "39-37"], "rounds": 4, "won": [true, true, false, true], "won_n": [4, 4, 2, 3]})
	_check(str(Headline.headline(maj)["title"]) == "Lucy wins on a majority, 2-0", "a majority (%s)" % str(Headline.headline(maj)["title"]))
	# An empty against line leaves no cause, never a made-up one.
	_check(str(Headline.headline(_lucy({"against": ""}))["cause"]) == "", "no FightWhy line: no cause")

	# 4. No pronouns in anything it says.
	var pron := RegEx.create_from_string("(?i)\\b(he|she|her|him|his|hers)\\b")
	var said := PackedStringArray()
	for x in [h, hw, hf, hp, hk, hd]:
		said.append(str(x["title"]) + " " + str(x["cause"]) + " " + str(x["night"]) + " " + str((x["milestone"] as Dictionary).get("words", "")))
	_check(pron.search(" ".join(said)) == null, "no he/she/her/him in the headline words")
	print("HEADLINE failures=%d" % failures)
	quit(1 if failures > 0 else 0)


## The S442 bout (docs/mockups/s442/result/bout.json): Lucy Jackson v Priya Nair, a split loss, with `over` laid on top.
func _lucy(over: Dictionary) -> Dictionary:
	var f := {"first": "Lucy", "opp_first": "Priya", "outcome": "loss", "stopped": "", "pro": false, "rounds": 3,
		"cards": ["28-29", "28-29", "29-28"], "won": [true, false, false], "won_n": [4, 3, 2], "flip": 0, "per_round": 6,
		"against": "One-two-hook was the wrong answer to a counter-puncher, 3 times. Wrong answers punished cost Lucy 4 of the tank.",
		"date": "Sat 7 Mar", "weight": "Lightweight",
		"rec_before": [3, 1, 0], "rec_after": [3, 2, 0], "opp_rec_before": [5, 1, 0], "opp_rec_after": [6, 1, 0],
		"rank_before": 0, "rank_after": 0, "opp_rank_before": 4, "opp_rank_after": 3}
	f.merge(over, true)
	return f


func _check(ok: bool, label: String) -> void:
	if not ok:
		failures += 1
		print("  FAIL: " + label)
	else:
		print("  ok: " + label)
