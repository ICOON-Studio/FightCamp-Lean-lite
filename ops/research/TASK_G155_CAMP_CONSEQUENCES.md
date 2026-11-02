# TASK G155 - every camp choice shows what it does before you commit (UI, Grok CLI)
Owner: Grok (Grok Build CLI). Worktree D:/FightCamp/wt/G155, branch grok/g155-camp-consequences (from master).
Operator 2026-10-01: "everything needs to have a meaning", AAA, icons over text with tooltips. D66_STRICT_REVIEW.md #3:
"Camp choices lack consequence preview - 'The Striking Shark', 'The Marathon Man' etc. are flavour phrases with no visible
stat or style impact. 'Projection: nothing to choose yet' is empty space. Choices feel like gambling, not planning."
D66's fix: "Every camp focus shows: +Power +8, -Defence -3 / Opponent style: Southpaw -> your adjustment ... Show before committing."

## Census first (write it into the digest)
Godot/scripts/FightCampPanel.gd (1,271 lines): its PROJECTION (header ~11, ~41, `last_projection` ~59, ~143) re-computes
on every pick - find why the screen reads "nothing to choose yet" (no pick made? projection keys empty for the default?).
Godot/scripts/FightCamp.gd (the camp math) - what each focus/archetype actually changes.

## Deliver
- Each camp focus/archetype card shows its effect BEFORE selection: icon + signed value per stat it moves (biceps-flexed
  power, shield defence, heart-pulse cardio, zap speed, target accuracy...), tooltip with the source line from FightCamp
  math; the opponent's style line (from the scouting read) with the recommended adjustment.
- The PROJECTION is never empty: the default (balanced) projection shows from the first frame.
- Icons over text (DesignLibrary/GLOSSARY.md "Icon with tooltip"; `UIKit.icon_plate`, `UIKit.tip`; Lucide icons in
  Godot/assets/icons/lucide).
- Owned: FightCampPanel.gd (+ a thin read in FightCamp.gd only if a number is not exposed). NEW
  `Godot/tests/camp_consequences_test.gd` (every focus card carries >= 1 effect tile with a tooltip; the projection is
  non-empty with no pick; picking a focus changes the projection by exactly its card's numbers). Stills ->
  `previews/g155/` (OPEN THEM). `research/G155_DIGEST.md`. Never edit HANDOFF.md.

## Owned files
- `Godot/scripts/FightCampPanel.gd` (1,271 lines - sed -n windows)
- `Godot/scripts/FightCamp.gd` (a thin read only, if a number is not exposed)
- `Godot/tests/camp_consequences_test.gd`
- `Godot/tools/g155_camp_stills.gd`
- `previews/g155/*`
- `research/G155_DIGEST.md`

## Tests
Parse gate; the new test; `python Godot/tools/run_tests.py --jobs 2 --only camp,fight_camp,gf1,smoke,ui_kit`. Watchdog first.
Do not change any camp RULE - this task explains, it does not rebalance.

## Finish
git add by explicit path, commit, git push -u origin grok/g155-camp-consequences. Do not stop at "written".
