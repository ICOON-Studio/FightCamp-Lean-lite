# PLANREADSHOW1 - "opponents adjust" is now shown (S539)

Owner Q-S294-301 asked for a penalty when combos repeat. The probe (REPEATREAD1) found the game already has the rule, silent:
PlanRead.ADJUST (S396). This task adds NO rule - it records and shows the one that exists.

## What was built
- Record (scripts/state/LiveRound.gd, recording only): an exchange where ADJUST cut a right answer's edge carries
  `read_adj {move, uses, cut, round}`; the first bite of a round also carries `read_line` (one live line a round).
- Live fight: the 3D caption (ExchangeBeats, after the habit line) and the fight-night panel (FightNight) say
  "They have your <move> now: it pays less this round." with a tooltip on the panel line.
- Result Plan tab (ResultTabs): per line "read after 3 uses in round 1: paid 30% less" + tooltip (what the rule is, the fix:
  a second answer for the moment, or drill the line sharper).
- Plan chart: amber chip "Leans on one answer: an opponent adjusts after two uses a round" when one answer is on three or
  more lines and over half of them (PlanReadShow.lean_move); the tooltip explains the 30% and the fix.
- Pure words/helpers: scripts/rules/PlanReadShow.gd.

## Evidence
- tests/plan_read_shown_test.gd: red on main (no bite recorded), green now (11 checks).
- Determinism: the digest of 40 whole bouts (win, margin, landed, plan edge) is 2334540372 before and after.
- Regression green: plan_chart_test, result_tabs_test, plan_test_it_test, plan_read_test, golden_path_test.
- Stills (ops/previews/planreadshow1): the chart with the chip, the Plan tab with the bite line (tools/planreadshow1_still.gd).

## Finding the owner should know
The rule almost never fires in ordinary play: 3 bites in about 600 probe bouts (every template and the starter plan against
three opponents, 20-30 bouts each; none in 40 natural bouts of the test). It needs a fourth right use of one answer in a
round, and a round has six exchanges on moving cards, so an answer rarely stays "best" that often. It is a safety net for a
plan that leans on one answer, not a pressure players feel. The test therefore spends the answers' uses first
(`answer_uses = 3`), the same state the fourth use meets. If he wants repeated combos to matter more, that is a new
rule (free uses lower, or the read counted across rounds) and a scope/taste call for him, not done here.
