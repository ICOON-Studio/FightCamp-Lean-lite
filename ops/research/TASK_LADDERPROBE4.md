# TASK LADDERPROBE4 - how often rival gyms ring, and what each answer does to the table (probe only)

Status: OPEN (S518, Claude main line). Discipline: boxing. Model: qwen3-coder (or any seat that runs Godot).
Source: map ops/research/DESIGN_LADDER1_V6_DOLA.md R9 (offers from rival gyms). Built S517b:
scripts/rules/RivalOffer.gd (who_offers / answer / season_reset), scripts/state/RivalOfferWire.gd (monday, answer,
lapse, season_reset; a ranked boxer of ours - Region.RANK_MIN_WINS wins - gets at most one offer every 4 weeks; a rival
rings again only after its own 8 weeks), scripts/ui/RivalOfferCard.gd. tools/ladder_probe.gd (ON MAIN, LADDERPROBE3)
leaves every rival offer unanswered, so each one lapses as a pass (-2 points). We do not know how often offers come.

## The job
1. Keep everything tools/ladder_probe.gd reports today (same tables) and add the rival offers. The file is at 494 lines
   (500 max): put the new code in a NEW file tools/ladder_probe_offers.gd (a RefCounted helper with static funcs: answer
   the open offers, count them, write the table rows) and call it from ladder_probe.gd's `_answer` and `_lines`.
2. Answer policy, by seed so the three answers are all measured: seed % 3 == 0 -> "accept", 1 -> "not_this_show" (when
   RivalOfferWire.view(c, f)["nts_left"] is false it falls to "pass"), 2 -> "pass". Call RivalOfferWire.answer(c, fid,
   choice) the day the offer is open (the same loop pass that answers LateAskWire). Count a refused answer (non-empty
   return) as its own column.
3. Per club, per answer policy, per boxer-season (a boxer-season = one of our amateurs in one calendar year): offers
   received (median / max), share of weeks a ranked boxer had one open, bouts booked from an offer (f["bout"]
   ["rival_offer"] set), wins/losses in those bouts, ladder points of our boxer at day 365 and 730 against the
   LADDERPROBE3 numbers (docs/LADDERPROBE3_RESULT.md), and how many different rivals rang.
4. One line each at the end: offers a season (target the map's R9 reading: "a few a season, never weekly"); does Pass
   drain a boxer (points at 730 under the pass policy vs accept); does Accept crowd out the sheet (sheet bouts a season,
   accept vs pass).
5. docs/LADDERPROBE4_RESULT.md (change the DOC constant), header line LADDERPROBE4, last printed line `LADDERPROBE4 done`.
   Never change a rule or constant; report only.

## Contract
OWNS: tools/ladder_probe.gd, tools/ladder_probe_offers.gd, docs/LADDERPROBE4_RESULT.md
RED_TEST: tools/ladder_probe.gd -> LADDERPROBE4 done
REGRESSION: rival_offer_test, rival_offer_wire_test, ladder_season_test
VISUAL: no

## Prior research
`python ops/Tools/prior_research.py rival offer ladder`. Read RivalOfferWire.gd (148 lines), RivalOffer.gd,
tests/rival_offer_wire_test.gd (how a ranked boxer is seeded), docs/LADDERPROBE3_RESULT.md, ops/research/GDSCRIPT_TRAPS.md.

## What would a human do?
Play two seasons with a ranked boxer, answer every phone call the same way, and count: how many calls, how many bouts
came from them, and whether the boxer ends higher or lower on the table.

## Prefab check
None: our own rule; only our own sim can say how often it fires.

## Rules for this seat
Godot only through godot_slot, headless, `--audio-driver Dummy`, `--fixed-fps 60`, `--log-file E:/FightCamp/tmp/<run>.log`.
No screens opened. Nothing outside OWNS; never touch scripts/fight3d/. No file over 500 lines.

## The one trap
Only ranked boxers get offers (4+ wins): in the quick-start club Lucy starts 0-0, so many seasons have no offer at all.
Report seasons with zero offers separately ("not yet ranked" vs "ranked, nobody rang"), never fold them into a median.
