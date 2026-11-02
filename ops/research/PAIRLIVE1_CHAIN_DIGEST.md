# PAIRLIVE1 chain digest — blocked WIP

Branch: `codex/pairlive1`, seeded from shipped master `d87a99e5`.
Status: OPEN. No production animation changes; no green claim or visual acceptance.

## Baseline and instrumentation

- Read the entire TASK_PAIRLIVE1.md. Created the dedicated worktree and seeded its Godot cache from the main checkout.
- Initial parse of `fight_pair_live_test.gd` and the first census revision: `CHECK total=2 fails=0 autoload_refs=0 autoload_warnings=0 time=0s`.
- The required original live-pair gate did not run. The task's `TOTAL=39 fails=5` and 19/8 clip counts are prior Claude observations, not results reproduced in this worktree.
- `tools/pairlive_census.gd` compares simulation action events with observed punch-clip starts over the same first 60 fight seconds. Populations: seed 930093 Leo Vance/Ray Miller; seed 94301 Malik Adebayo/Tommy Perez. It requires `as_game`, distinct identities/stats and reports the loaded meshes. `bench1=1` explicitly selects the fatigued/scripted control; default is ordinary game behavior. Clip starts are the measured unit, not a reconstruction of individual punches inside combination clips.
- `tools/pairlive_trace.gd` runs the existing OFF-control live-pair assertions without changing their thresholds. It records the existing player/room writer hooks, exact clocks, fresh composed bone positions and lock/push/aim counters. It also logs actual seed, mesh identities and authored gap range. Latest instrumentation edits still require parse/run.

## Findings to verify with the baseline

- The recorder's `bench=1` arm enables engine `bench1`. `FightRealtime.begin` then installs the scripted timeline and gives the blue fighter stamina 28 versus red 95. The previously recorded 19/8 split is therefore not yet evidence that ordinary game strikes are lost. Census separates these populations before changing simulation output.
- At pair time zero, `advance` seeks `max(0, pair_time - delta)` and then advances delta. This expression predicts the reported first-frame clock lead; the trace must confirm it in the live room.
- `_solve_contacts` already skips authored pairs, but the later `_correct_refused_overlap` path can call `push_hand` without that guard. The trace must identify whether this is the first wrong writer. Grounding and subsequent root/limb passes also need observation, not speculative clamps.
- The authored f01/f09 pair must never be forced onto a MetaHuman skeleton.

## Shared PC scheduling

The existing TECHSTAGE1 37-test batch occupies the sole Godot slot (17/37 at handoff). Its wrapper does not check for another Godot process before its next test. An initially queued between-tests attempt was therefore cancelled before launching Godot; the replacement waited for that runner to exit. It too was cancelled before this handoff. Only the owned waiting wrappers were stopped. No competing work was interrupted. Permission to pause the other runner remains unanswered.

The chain's stop-and-move exception is being used for this persistent scheduling block. The work comprised baseline scheduling, the ordinary-versus-benchmark census, and the per-writer trace; these were diagnostic attempts, **not three production repairs**. No red-to-green transition was obtained. This branch is instrumentation WIP, not ready for integration as an animation fix.

## Still open

Original gate red lines; ordinary/control census numbers; first-writer trace; cause repair; unchanged focused and affected-system gates; framed game-camera guard/contact/between stills with numerical gap/noses/wrists/feet; 20-second clip; Claude/operator review. No new still or clip exists for this item yet.

## Final slot retry after the other two WIP handoffs

After TECHSTAGE1's 37-test batch ended, fetched and merged current master as `9d4da7fa` and retried the original gate. Consecutive `merged_solo_warp` and `merged_solo_face` runs claimed Godot before it could start. The owned waiting wrapper was cancelled; **PAIRLIVE1 never launched a Godot test on this retry**. No queued job is left behind. The branch remains diagnostic WIP: latest census/trace revisions still need parse, and no primary red-to-green result, production repair, new still or clip is claimed. An exclusive Godot slot is needed to continue.
