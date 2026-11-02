# TASK G150 - GF1 part D: the Body Lab and the fatigue maths explain themselves (Grok, S133)

Model: Grok Build CLI default. Worktree `D:/FightCamp/wt/G148` re-branched `grok/g150-body-fatigue` from master.

## Why
Dola's D66 weaknesses 9 and 10 (`research/D66_STRICT_REVIEW.md`): "Fatigue +6/week, -6 injury risk but no cap,
no recovery speed" (62_technical_flow) and "Body regions are decorative - all 100/100 sound; no explanation of how
damage carries between fights" (17_body_lab). Your G149 (merged 3ccf0e36) did the training week; this is the clarity
pass on two more screens.

## Prior research
`topics/ui_screens.md`, `J52_TOOLTIPS_AND_TUTORIAL.md`, `S78_DIGEST.md`, `U201_DIGEST.md` (the hover pattern);
`python Tools/prior_research.py body region readiness recovery`.

## What would a human do?
Hover a body part: its number, what hurts it, what heals it and how fast, and what it blocks (training / competition
threshold). Hover a fatigue number: the cap, the recovery per rest day, and the injury-risk line it crosses.

## Prefab check
Reuse `UIKit.tip` / TipLayer. The numbers exist in `assets/data/body_readiness_rules.json` (training 80, amber 60,
competition head 90 / torso 85 / limbs 80, `competition_fatigue_max` 85, recovery rest_base / recovery_base /
targeted_region_bonus); read them through `BodyReadiness.gd`'s accessors - never re-parse the JSON, never hardcode.

## The work
1. Body Lab (`ProfileRevampPanel.gd`: `_build_body_lab` :2767, `_fill_regions` :2840, `_fill_recovery` :3087; never read
   the 3724-line file whole): every region gets a hover with its value, its training and competition threshold, what
   raises it (rest / recovery station, amounts from the rules) and whether it blocks a bout now.
2. Fatigue on the camp's technical-flow card (`FightCampPanel.gd`; Qwen's Q219 hover code is merged - add, do not
   rewrite): the fatigue and injury-risk numbers get a hover with the cap and the recovery per rest day.

## Owned files
`Godot/scripts/ProfileRevampPanel.gd` ONLY `_fill_regions` / `_fill_recovery` and helpers at the end of the file;
`Godot/scripts/FightCampPanel.gd` (add hovers only); NEW `Godot/tests/gf1_body_fatigue_tips_test.gd`,
`previews/g150/` (ONLY the Body Lab and technical-flow stills), `research/G150_DIGEST.md`.
NOT GameState.gd, UIKit.gd, BodyReadiness.gd, Glossary.gd (Cursor may add terms there - use plain-text tips).

## Tests
Parse gate on every touched .gd. Your test: every region and the fatigue number resolve a NON-EMPTY
`TipLayer.body_for` and quote at least one threshold equal to BodyReadiness's accessor. Then
`python Godot/tools/run_tests.py --jobs 2 --only profile_revamp,fighter_card,body_readiness,fight_camp_panel,gf1_`.

## Deliver
Commit, `git push -u origin grok/g150-body-fatigue`, 10-line digest. Say only what the rules and code compute.
