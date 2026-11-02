# TASK KICKREACH1 (S226) - a landed low kick is scored while the kicking foot is 1.14 m from the leg

Seat: Goose (cloud, label `goose`). Own branch goose/issue-<n> + PR; never master. Take only your own small commits (S224 trap: a stale
tree once reverted 439 files - rebase on master first, diff must touch only the files you name in your report).
New features ship ON (CLAUDE.md s10); plain --script tests are the OFF control arm.

## The red (measured S226)
`Godot/tests/fight_contact_stop_test.gd` on master: `FAIL: landed kickboxing_low_kick surface error <=3cm: -1.13670302410396`
(145 checks, 1 failure). Bisect (Claude, S226): green at 20a21082~1, red at 20a21082 ("ANIMFIX2 r2 merged: pose layer authored in
generator rest frame"). That commit only changes BOXING pose layers (no low-kick clip has a pose layer), so it shifted the fight's
timeline and the test now meets a different landed low kick - one that lands with the foot 1.14 m away. The kick defect is latent;
do NOT revert ANIMFIX2.

## Do
1. Reproduce on master; print, for the failing frame: both fighters' root positions and their distance, the kick take, info.contact_s,
   position_s, which foot the test picked as effector (the farthest-moving foot) and the foe leg capsule it measured against.
2. Find the cause - one of: (a) the sim lands a low kick at a range the leg cannot reach (spacing/range gate for kicks), (b) the
   whole-root hold puts the kicker in the wrong place at contact, (c) the test picks the wrong foot (e.g. a mirrored/southpaw take
   where the plant foot moves farther). Prove which with the printed numbers.
3. Fix the CAUSE in the game code (or, only for (c), the instrument - and then show the instrument still reads a real 1 m miss
   red with a mutant). No threshold change, no skip.

## Gate
`godot --headless --path Godot --script tests/fight_contact_stop_test.gd` -> `145 checks, 0 failure(s)` (or more checks), plus
`python Godot/tools/run_tests.py --jobs 2 --only fight_contact,fight_stage,fight_strike,kick` with no new red. Paste the CI log lines.

## Prior research
S121 (landed low kicks meet the thigh), U198 root coordinator, FightStagePlayer `_is_kick_throw_role`, `strike_contact()`.

## What would a human do?
Look at the frame where it happens: are the two men simply too far apart when the kick is called "landed"?

## Prefab check
None - engine logic.

## The one trap
The red appears only because the timeline shifted; a fix that just shifts the timeline back (seed, order) hides it. Fix the reach.
