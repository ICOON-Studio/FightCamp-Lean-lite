# TASK G152 - JD1: the three judges must be able to disagree (Grok, S134)

Model: Grok Build CLI default. Worktree `D:/FightCamp/wt/G148`, branch `grok/g152-judges` (fresh from master).

## Why
Boxing seats three judges (`RoundScoring.gd:59` judge_count 3 for ten_point_must), each a noisy copy of the scoring
weights (`JudgePanel.panel`, sigma `judge_sigma` default 0.06 at `RoundScoring.gd:60`). The booked-bout census found
**0 split decisions in 54** (topics/scoring_results.md line 22); the S134 exe walk's result screen shows three identical
cards (28-29, 28-29, 28-29). Real pro boxing has split and majority decisions. A result screen where the judges never
differ makes "THE CARDS" a decoration.

## Prior research
`python Tools/prior_research.py split decision judges scoring disagreement` - read `research/topics/scoring_results.md`,
`J1_ORGANIZATION_RULES_AND_JUDGES.md`, `M5_SCORECARD_THREE_JUDGES.md`. The panel code: `Godot/scripts/JudgePanel.gd`
(175 lines, read whole), `Godot/scripts/RoundScoring.gd` (200 lines, read whole). The test: `Godot/tests/judge_panel_test.gd`.

## What would a human do?
A statistician who has sat ringside: (1) find the real share of pro boxing DECISIONS that are split or majority (not of
all bouts) and how often a single round is scored differently by the three judges (round-level agreement studies of
boxing judging exist - e.g. Lee/Balmer/Nevill-style ringside judging studies, BoxRec/CompuBox scorecard datasets);
(2) find WHY our cards agree - measure it: most likely a round's margin is far larger than 0.06 relative weight noise can
flip, so only close rounds should differ; (3) make disagreement come from where it comes from in life - CLOSE rounds
(small score margin) - not from random noise on clear rounds.

## Prefab check
No prefab; this is a constant/mechanism inside our own scorer. Sources only.

## Owned files
- `Godot/scripts/JudgePanel.gd` (175 lines) and `Godot/scripts/RoundScoring.gd` (200 lines) - edit only the judge
  noise / close-round perception; do NOT touch the 10-8 rules, knockdown handling, or one-judge rulesets (judges <= 1
  must stay byte-identical: the existing test T1 guards it).
- `Godot/tests/judge_panel_test.gd` - add cases, never loosen an existing one.
- NEW `research/G152_JUDGES_DIGEST.md`.
- The measuring tool `Godot/tools/_s119_q212_check.gd` (209 lines): you may add a "split+majority share OF DECISIONS"
  column (today its split/maj% is a share of ALL bouts - say so in the digest).

## Spec
1. Sourced anchor: split+majority share of pro boxing decisions, and round-level three-judge agreement, each labelled
   DOCUMENTED / SECONDARY / NO STUDY with source + year. Give a BAND, never a point.
2. Measure BEFORE (master): run the census, record decisions, split, majority, share of decisions.
3. Change at most TWO constants or one small mechanism (label each AUTHORED / DERIVED). Preferred: judges perceive a
   round's margin with noise scaled so that close rounds split and clear rounds do not.
4. Measure AFTER on the SAME seeds and fighters: split+majority share of decisions inside your sourced band; KO+TKO% and
   draw% must not move outside the census bands already printed (KO+TKO 40-55); a clear round (big margin) must still be
   scored the same by all three (add that test case with a fixture that can fail: a mutant with sigma 1.0 must break it).
5. Digest: the table before/after, the sources, the constants.

## Gates (in this order)
- Parse: `python Godot/tools/check_scripts.py Godot/scripts/JudgePanel.gd Godot/scripts/RoundScoring.gd Godot/tests/judge_panel_test.gd Godot/tools/_s119_q212_check.gd`
- Test: `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64_console.exe" --headless --path Godot --script tests/judge_panel_test.gd`
  (the exit code alone is not a pass: read for FAIL lines and SCRIPT ERROR).
- Then `python Godot/tools/run_tests.py --jobs 2 --only judge` and `--only result`.
- Census: `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64_console.exe" --headless --path Godot --script tools/_s119_q212_check.gd` (read its header for args).

## The one trap
The census tool's split/maj% divides by ALL bouts. 5% of all bouts can be 10% of decisions. Anchor and measure on the
SAME denominator, and print both.

## Deliver
`git add` your files by path, commit, `git push -u origin grok/g152-judges`. Do not stop at "written".
