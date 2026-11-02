# TASK C240C - re-measure the clinch's own overlap gate windowed on hold state, before touching the geometry again (Codex)

Model: gpt-6-luna, medium. Owner: Codex (next free seat after C241). Worktree: resume `codex/c240-boxing-clinch`
(branch already has Q233's real events wired in - `cf984127`, `822400bf`).

## Why (route_decisions.json "C240", PARKED 2026-10-02 S141, verbatim condition to resume)
"Resume when a seat is free AND either (a) someone proposes a different geometric approach to the paired hold
(not more parameter tuning), or (b) the operator reviews c240b_live_room.mp4 and gives a taste verdict that
changes the bar." This task is (a) - not a new geometric algorithm, but evidence that the GATE, not the geometry,
is what failed.

## The evidence that points away from the geometry (primary sources, read before building anything)
1. `research/C240_DIGEST.md` s"Measured before/after", own words: "During the settled hold (5.5-10 s), max
   head penetration was 0.001999 m and torso penetration was zero." The paired-capsule solver
   (`FightStagePlayer.fit_boxing_hold_pair`) WORKS during the window it actually controls.
2. `research/S141_DIGEST.md` s9: the C240b full 10-bout census (both arms, Q233 on/off, ~195k frames) found
   head-overlap frames went 1,897 (off) -> 1,923 (on) - UP, failing the halving gate.
3. `git show codex/c240-boxing-clinch:Godot/tools/c240_overlap_census.gd`, function `run_bout`: `head_bad` /
   `torso_bad` accumulate over the ENTIRE bout (every frame from kickoff to verdict), with no reference anywhere
   to `FightStagePlayer.boxing_hold_active()` or any other hold-state flag. The counted population is not "overlap
   during a clinch" - it is "overlap anywhere in the fight", and the overwhelming majority of a bout's frames have
   no hold active at all.
4. `run_bout` passes `engine_options := {"boxing_clinch": not before}` - a single engine-option flip. Once a
   `hold_engage` event fires in the "after" arm, the engine's subsequent action selection necessarily diverges
   from the "before" arm's trajectory for the REST of the bout (different events logged, different RNG draws
   consumed in a different order) - the two arms are NOT the same fight with one clinch added, they are two
   different fights from the moment of first divergence. Counting whole-bout overlap after that point mixes real
   clinch-pose geometry (which the s"5.5-10s" number shows is fine) with unrelated ordinary-exchange crowding that
   the clinch feature never touches - exactly a [[feedback_control_arm_must_not_share_the_bug]] situation, and
   exactly what capped K38/G147's ordinary-exchange overlap at a nonzero baseline already (this fixture's own
   "before" arm already read 1,897 head-overlap frames with NO clinch at all).

## What to build
1. Read `c240_overlap_census.gd` in full (it is short, ~160 lines) and `FightStagePlayer.boxing_hold_active()`.
2. In `run_bout`'s per-frame loop, read `live._player_a.boxing_hold_active() or live._player_b.boxing_hold_active()`
   each frame and bucket `head_bad`/`torso_bad` into TWO counters: `*_during_hold` and `*_outside_hold`, both as
   a share of their own frame population (frames-with-hold-active vs frames-without), not of the whole bout.
   Keep the existing whole-bout numbers too (do not delete a measurement, add the windowed one beside it).
3. Re-run the SAME 10-bout booked population (`booked_population.json` already exists on the branch; reuse it,
   do not regenerate - a fresh population is a different control arm) for both arms, same seeds.
4. Report four numbers, not two: head-overlap share during-hold (on) vs during-hold (off - there are no hold
   frames in this arm by construction, so this should read "no hold frames, N/A"), and outside-hold (on) vs
   outside-hold (off). The hypothesis under test: during-hold overlap is low (near the single-bout s"5.5-10s"
   result) and outside-hold overlap is statistically indistinguishable between arms (the RNG-divergence noise
   floor) - if BOTH hold, the geometric solver was never the problem and C240 can be judged on taste (route
   condition (b)) instead of a whole-bout number it was never positioned to pass.
5. If during-hold overlap is NOT low on the full population (unlike the single bout's 5.5-10s excerpt), that is
   a real finding and the task stops there to report it - do not start tuning `fit_boxing_hold_pair` against a
   single guess; come back with the windowed numbers first.

## What NOT to build
Do not touch `fit_boxing_hold_pair`, the authored hold clips, or any geometry/tuning constant. This task is a
measurement change only. If the windowed numbers come back bad, that is the NEXT task's brief, written from
real numbers instead of a guess.

## Acceptance
- Windowed census numbers for all 10 bouts, both arms, same population as C240b.
- A plain verdict: "the geometry is fine, the whole-bout gate was wrong" (if during-hold overlap is low and
  outside-hold is noise-level between arms) OR "the geometry is also wrong" (if during-hold overlap is high on
  the full population, not just the single excerpt) - stated in those terms, not just numbers.
- `research/C240C_DIGEST.md` with the four numbers, the verdict, and whether route_decisions.json "C240"
  should move from PARKED to RESUMED-and-merge-ready (geometry fine) or stay PARKED with a real geometry defect
  now described (geometry also wrong).
- Parse gate on `c240_overlap_census.gd`. No new test needed - this is a research tool, not shipped code.

## Owned files
`Godot/tools/c240_overlap_census.gd` (the per-frame bucket + report only), `research/C240C_DIGEST.md`,
`AgentComms/route_decisions.json` (update the "C240" entry's status/why with the verdict - do not invent a new key).

## Prior research
`python Tools/prior_research.py clinch overlap gate windowed hold`: C240_DIGEST.md, S141_DIGEST.md s9,
S139_CLINCH_DESIGN.md, K38 (Davis et al. 2015 clinch-rate reference), [[feedback_control_arm_must_not_share_the_bug]],
[[feedback_gates_must_derive_not_copy]].

## What would a human do?
A reviewer handed "the feature made things worse" would ask what, specifically, got worse, before touching the
feature - not re-tune a solver that already measured near-zero penetration in the one window it owns.

## Prefab check
N/A - measurement-only task, no new asset or technique.

## Test (tier: script edited, research tool)
`python Godot/tools/check_scripts.py Godot/tools/c240_overlap_census.gd` before any run.
`python Tools/c223_parallel.py` is unrelated; do not run the big suite for this - it is a standalone census tool,
run directly: `godot --headless --path Godot --script tools/c240_overlap_census.gd -- <its existing args>` (read
the tool's `option()` calls for the exact flags it already accepts; do not invent new ones beyond the windowed
counters).

## The one trap
The "before" arm never has an active hold by construction (boxing_clinch option off) - its during-hold bucket
will be empty. Report that as "N/A, no hold frames" rather than a 0% share, which would misleadingly look like a
perfect score instead of an undefined measurement.
