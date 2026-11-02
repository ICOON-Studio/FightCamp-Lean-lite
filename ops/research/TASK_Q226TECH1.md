# TASK Q226TECH1 (S211) - technique training must show in the fight (Goose, cloud, long)

Model: Goose (GitHub Actions, label `goose`), branch goose/issue-<n>. Pure engine work: NO 3D models, NO LFS, headless tests only.

## The finding (S187 NIGHTLY1E census, still true)
A technique specialist (strands technique 90 / footwork 10 / conditioning 0) connects 28.2% of thrown strikes vs a balanced boxer
(34/33/33) 28.0%: paired diff +0.24 pp, 95% CI [-0.84, +1.31]. Training technique does nothing a player can see. `q226_strands_test.gd`
was weakened to "not worse" (TECHNIQUE_SHARE_DIFF_FLOOR = -0.01). The milestone is "train him ... watch the fight": training must matter.

## Prior research
research/Q226_DIGEST.md (E3 strand edges, E4 TechniqueEffects), TASK_Q226_TRAINING_SPEED_TECHNIQUE_IN_THE_FIGHT.md,
G75_STRIKE_SPEEDS.md, K52_WHERE_A_PUNCH_LANDS.md, J21_THE_MOVE_PALETTE.md (connect rates).
## What would a human do?
A coach would expect a fighter who spent his camp on technique to land a bit more often (and maybe gas or get caught moving more):
visible over a fight, not huge. First find WHERE the gain is lost before turning any dial.
## Prefab check
None - our engine.

## Code anchors (FightRealtime.gd is 9,488 lines - never read it whole; use grep and sed -n windows)
- `_strand_edge` ~line 2295: edge = 1 + STRAND_EDGE_MAX(0.06) * (share - 1/3) -> technique 90% gives 1.034.
- `_build_fighter` ~2165: strand_edge_footwork / _conditioning / _technique stored on the fighter.
- footwork edge ~1708: preferred_range *= strand_edge_footwork (the specialist's footwork share FALLS 33 -> 10).
- contact ~5544-5618: clean_at = (0.20 + 0.30*technique)*range_fit, ... `clean_at *= tech_edge` (~5578), `if contact_roll < clean_at`.
- conditioning edge ~5054.

## Do
1. DECOMPOSE (write `Godot/tools/q226tech_decompose.gd`, headless): over 40 paired seeds, same two DIFFERENT fighters (never identical -
   CLAUDE.md s5), measure connect share for: balanced; technique-only edge (footwork edge forced 1.0); footwork-loss only (technique edge
   forced 1.0); full specialist. Print each arm with a paired 95% CI. Say in the digest which term eats the gain (or whether the edge is
   simply too small, or applied to a threshold that is later overwritten - e.g. the counter_lift cap 0.92 / ladder).
2. FIX the cause you found, behind the existing `training_strands` switch (OFF must stay byte-identical: the q226 OFF replay check).
   Target: full specialist vs balanced connect share +1.5 to +4 pp with the 95% CI excluding 0, over >= 40 paired seeds; a footwork
   specialist must still out-range a technique specialist (the trade-off stays real). Bound values, never an exact count.
3. Restore the test: `q226_strands_test.gd` TECHNIQUE_SHARE_DIFF_FLOOR back to a real floor (CI lower bound > 0) and keep the 0.08 cap.
   The new check must FAIL on today's master (prove it: paste the FAIL line) and pass after.
4. Run `python Godot/tools/check_scripts.py <touched .gd>` then the tests: q226_strands_test, q226_speed_test, q226_technique_effects
   (if present), fight_determinism (any *determinism* test) - list exact names you ran. Digest `research/Q226TECH1_DIGEST.md`
   with the decomposition table, the fix, before/after numbers. Open the PR; never master.

## Owned files
`Godot/scripts/FightRealtime.gd` (only the strand-edge lines named above), `Godot/scripts/TrainingStrands*.gd` / `Strands` (if the share
math is the cause), `Godot/tests/q226_strands_test.gd`, new `Godot/tools/q226tech_decompose.gd`, `research/Q226TECH1_DIGEST.md`.

## The one trap
Do NOT delete or loosen tests to go green, and do not "fix" it by inflating STRAND_EDGE_MAX until a 4-seed sample passes - the whole
point is a paired, bounded effect over many seeds that a player would actually feel.
