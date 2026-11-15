# TASK PARTNERMATCH1 - how well a sparring partner matches the opponent: points, word, lines readied, round-1 edge (pure module + test)

Status: OPEN (S479, Claude main). Discipline: boxing. Model: Arena (cloud, lite mirror), default.

## Why now
Fight week v9 (map ops/research/DESIGN_AMATEURWEEK1_V9_REVISE_KALLI_KALLI.md section 4.1 "CHOOSE A SPARRING PARTNER") passed
two critics and is on the owner's board (Q-S294-238, drawing docs/mockups/s479/sparring_partner_v1.png). Every sparring night
in a fight week needs a partner; the partner's match with the opponent decides how many plan lines the night readies and the
round-1 edge. This module is the rule; Claude wires it to the screen.

## What to build: scripts/rules/PartnerMatch.gd (new, under 200 lines)
`extends RefCounted`, pure static functions, no class_name, no preload, no game state.

A person (partner or opponent) is a Dictionary: {"sex": "f"|"m", "div_kg": float, "style": String ("" = unknown),
"stance": "orthodox"|"southpaw"|"" (unknown), "reach_cm": float (0 = unknown), "level": int (a rating, 0 = unknown),
"tells": Array of String (tell ids)}.
The opponent's dictionary holds only what is KNOWN: unknown style is "", unknown reach is 0; "tells" holds only FILMED tells.

Constants (ESTIMATES from the map, keep the names):
- PT_STYLE := 2, PT_STANCE := 1, PT_REACH := 1, PT_TELL := 1, REACH_CLOSE_CM := 5.0
- CLOSE_MIN := 5, PART_MIN := 3   (CLOSE 5+, PART 3-4, LOOSE 0-2)
- LINES := {"CLOSE": 3, "PART": 2, "LOOSE": 1}   (lines the night readies; never more than the lines the player picked)
- EDGE := {"CLOSE": 1.0, "PART": 0.5, "LOOSE": 0.0}   (round-1 edge)
- LEVEL_GAP := 5   (a partner's level more than 5 above the boxer's = "above", more than 5 below = "below", else "level")
- INJURY_ABOVE := 1.15
- OUTSIDE_FEE := 160   (dollars; a partner at another club; or 1 favour)

Functions:
1. `points(partner: Dictionary, opp: Dictionary) -> Dictionary` - {"total": int, "style": 0|2, "stance": 0|1, "reach": 0|1,
   "tells": int}. A fact scores only when it is known on BOTH sides (opp style "" never scores; reach 0 on either side never
   scores). Tells: one point per tell id in both partner.tells and opp.tells.
2. `word(total: int) -> String` - "CLOSE" / "PART" / "LOOSE".
3. `best_possible(opp: Dictionary) -> int` - the most points any partner could score against what is known (2 if style known
   + 1 if stance known + 1 if reach known + number of filmed tells). With no filmed tell and everything else known this is 4,
   so the best match is PART (the screen then says "film a tell to find a closer partner").
4. `needs_film(opp: Dictionary) -> bool` - true when best_possible(opp) < CLOSE_MIN.
5. `level_word(partner_level: int, boxer_level: int) -> String` - "above" / "level" / "below" (unknown 0 on either side = "level").
6. `night(partner: Dictionary, opp: Dictionary, boxer_level: int, picked_lines: int) -> Dictionary` - everything the screen
   and the fight week need: {"points": total, "word", "lines": mini(LINES[word], picked_lines), "edge": EDGE[word],
   "injury_mult": INJURY_ABOVE if above else 1.0, "flatters": level == "below", "beats_it_known": word != "LOOSE",
   "test_likely": word == "PART"}.
7. `listable(partner: Dictionary, boxer: Dictionary) -> bool` - same sex only (females never spar males in this list) and
   partner.div_kg within one class of the boxer: absf(partner.div_kg - boxer.div_kg) <= 7.5.
8. `cost(partner_club_is_ours: bool, favours_with_club: int, cash: int) -> Dictionary` - {"cash": 0 or OUTSIDE_FEE,
   "favour_ok": favours_with_club > 0, "payable": ours or favours > 0 or cash >= OUTSIDE_FEE, "reason": "" or
   "no favours with this host" / "cash under $160" (the reason only when not payable; cash reason when favours are 0)}.
9. `rank(partners: Array, opp: Dictionary) -> Array` - the partners' indices sorted by points, highest first; ties keep input
   order (stable).

## The test: tests/partner_match_test.gd (new)
Same shape as tests/amateur_booking_test.gd (extends SceneTree, `_check(cond, label)`, prints `PARTNER_MATCH checks=<n>
failures=<n>`, quit(1) on any failure). At least 30 checks, including the drawing's six rows against the opponent
{style "Counter", stance "orthodox", reach 174, tells ["drops_right_after_jab"]}:
- club boxer 57 kg {Counter, orthodox, 172, tells ["drops_right_after_jab"]} -> 5 points, CLOSE, 3 lines of 3, edge 1.0
- other club {Counter, orthodox, 175} -> 4, PART, 2 lines; level above -> injury 1.15
- other club {Counter, southpaw, 170} -> 3, PART
- club boxer 63 kg {Pressure, southpaw, 180} -> 0, LOOSE, 1 line, beats_it_known false
- club member {style "", orthodox, reach 0, level below} -> 1, LOOSE, flatters true
- unknown facts never score: an opponent with style "" gives no style point to anyone
- best_possible: 5 with one tell, 4 with none (needs_film true), 2 with only style known
- lines never exceed picked_lines (CLOSE with 2 picked -> 2)
- listable: female/male false; 60 vs 75 kg false; 60 vs 65 true
- cost: our club free and payable; outside with 0 favours and $100 -> not payable, "cash under $160"; with 1 favour payable
- rank: stable on ties.

## Pass lines
RESULT: tests/partner_match_test.gd -> PARTNER_MATCH checks=<n> failures=0

## Contract
OWNS: scripts/rules/PartnerMatch.gd, tests/partner_match_test.gd
RED_TEST: tests/partner_match_test.gd -> PARTNER_MATCH failures=0 (red on main: the file does not exist)
REGRESSION: none - nothing else is edited
VISUAL: no
NOT YOURS: every other file; never delete or weaken a test. Do not wire it (Claude does that).
Godot 4.7.2 headless: `godot --headless --audio-driver Dummy --path . --script res://tests/partner_match_test.gd`. If your
sandbox cannot download Godot, say so in the PR body and let the repo's CI run the test; never guess a pass line.
GDScript traps: never `:=` on a Variant from a Dictionary/Array get (type it); tabs for indent; `%` in format strings.

## Prior research
Map section 4.1 (the match table) and 9.3 (Frame B); scripts/rules/BoutSheet.gd and scripts/rules/RegionShows.gd (shapes);
scripts/rules/FilmTruth.gd (filmed tells). John's critic (DESIGN_AMATEURWEEK1_V9_CRITIC_JOHN_JOHN.md, 10/10 item 2): the
partner decides how many lines are readied.
## What would a human do?
A coach picks the club sparring partner who moves most like the coming opponent, and pays for an outside one only when nobody
in the gym does.
## Prefab check
None: our own rule.
