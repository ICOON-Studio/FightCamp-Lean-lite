# TASK U89 — CURSOR — A STAGGER TRAVELS: CARRY IT, AND LET THE ROOM TAKE THE DISTANCE

Model: Composer (`composer-2.5`), **medium**, `-p --force --trust`. Owner: cursor. Worktree
`C:/Users/user/AppData/Local/Temp/FightCamp-U80` (imported), branch `cursor/u89-travel` - already created from
`origin/master` for you. Push the BRANCH. Stage: S4a (d) part 3, item (1) - R3, part 2 of 2.

**Test tier: SCRIPTS EDITED.** Parse gate on every touched `.gd`, your new test, the realism test (below), the subset
at `--jobs 2` (never 4 - the PC overheats). No full suite - Claude's at integration.

## Owned files

- `Godot/scripts/FightStagePlayer.gd` - ~1,390 lines, NEVER read it whole. Read `sed -n '1,30p'`, the U88 carry in
  `_graft_retargeted` (`grep -n "func _graft_retargeted"`, read 90 lines), `advance` and `_ground`
  (`grep -n "func advance\|func _ground\|func take_animation_clock"`), `_mark_busy` (`grep -n "func _mark_busy"`).
  You add: a travel list, the extraction inside `advance`, `consume_travel`, `busy_at`. Do not change inertialization.
- `Godot/scripts/FightWorldLiveScreen.gd` - read `sed -n '85,135p'` (the gap constants and vars), `grep -n "func
  _process\|func _step_gap\|func _advance_bodies\|func configure"` and 40 lines at each.
- `Godot/tests/fight_stage_realism_test.gd` - the user-arg block only (`grep -n "cmdline_user_args"`): ONE new arg.
- `Godot/tests/fight_stage_travel_test.gd` - NEW, yours.
- `research/U89_TRAVEL.md` - NEW, yours, 25 lines at most.
- `Godot/scripts/FightClipBinding.gd` and `Godot/tests/fight_stage_walk_test.gd` - send-back 3 only: the five-line fix and
  the test, identical to master's `c781ab1`.

## Why this exists

U88 carried the hips sway of hit reactions that sway and RETURN, and R3 (a planted foot does not slide, bound
0.10 m/s) fell from 0.186 to **0.130 m/s**. What skates now, by the realism test's own by-take list: **react_body
0.89 m/s over 6,547 frames - 39% of all the skate left.** Those takes TRAVEL: StaggerSmall01-03 and
StaggerMedium01-04 end 0.35-1.38 m straight back (Q89; lateral 0.000), and react_leg's StaggerLarge04_LowHit 0.84 m.
U88 left them height-only on purpose, because a carried travel in the Hips would snap back at the next take.

**Claude's decision (R3, part 2):** carry the travel, and hand it to the ROOM every frame, so the body really ends
where the stagger took it and the pair re-closes by walking. This is ordinary root-motion extraction: moving the
body node by the hips' horizontal offset and putting the hips back at rest gives the SAME world pose (the feet hang
from the hips), so the feet stay planted while the stagger plays, and there is no offset left to snap back later.

## The change

1. **Which takes travel.** In `FightStagePlayer`: `const TRAVEL_CARRY_ROLES := ["react_body", "react_leg", "block"]`
   and `var _travel_roles: Array` initialised from it, with `set_travel_carry_roles(roles: Array)` (before `bind`,
   like U88's `set_sway_carry_roles`). In `_graft_retargeted`, a take CARRIES when
   `role in _sway_roles and sway["returns"]` (U88, unchanged) OR `role in _travel_roles and not sway["returns"]`
   (new). Keep a Dictionary `_travel_takes` of the animation names that carry as travel. A mirrored travel take uses
   U88's `_carry_about_rest_x`, exactly as a carried sway take does.
2. **The extraction, every frame, in `advance`** - right after `_ap.advance(...)` and BEFORE `_inertialize_joins`:
   if the current animation is in `_travel_takes`, read the Hips pose position, take its horizontal offset from the
   Hips REST origin along the Hips-parent-frame X and Z axes (built as `hip_carry` builds them - `Vector3(1, 0, 0)`
   and `Vector3(0, 0, 1)` through the parent's global REST basis inverse; NEVER Godot's named direction constants),
   set the Hips pose position back to rest in X and Z (height kept), and convert the removed offset to WORLD space
   (`_skel.global_transform.basis * parent_global_rest_basis * offset`). The travel this frame is that world offset
   minus the previous frame's world offset for the same take; add it to `var _travel: Vector3`.
   **On a new take (the name changed, or its position went backwards), the previous offset is the CURRENT offset** -
   so a take entered part-way never jumps the body.
3. `func consume_travel() -> Vector3` returns `_travel` and zeroes it. `func busy_at(now_s: float) -> bool` returns
   whether `now_s` is before `_queue_state["busy_until_s"]`.
4. **The room takes the distance.** In `FightWorldLiveScreen._process`, right after `_advance_bodies(delta)`: read
   `consume_travel()` from both players; project each onto `_axis` (`pa`, `pb`); then `_gap += pb - pa`,
   `_mid += _axis * (pa + pb) * 0.5`, and write both node positions from `_mid`/`_gap` exactly as `_step_gap` does
   (Y kept). The lateral part is dropped: add it up per body and print the total when the bout finishes.
5. **A body mid-take is not slid by the room.** In `_step_gap`, a player that is `busy_at(_show_s)` does not move:
   if both are busy the gap holds; if one is, the free body covers the whole change (same exponential and the same
   `STEP_MPS` cap on the gap); if neither, both move as today.
6. **Switches, for measuring only:** `configure` reads `options["travel_roles"]` (Array, handed to both players
   before `bind`) and `options["legacy_gap"]` (bool: `_step_gap` as it was). The realism test reads the user args
   `travel=off` (travel roles `[]` AND legacy gap) and `gap=legacy` (legacy gap only), and prints them on its
   POPULATION line the way it prints `sway=`.

## Your test: `Godot/tests/fight_stage_travel_test.gd`

Bind a `FightStagePlayer` to f01 the way `fight_stage_inertia_test.gd` does (read its setup, `sed -n '1,80p'`).
Play `react_body` (StaggerSmall01, take 0) on the caller's clock (`take_animation_clock`), advance at 1/30 s, and
consume the travel every frame. Assert:
- the summed travel's length is within 0.03 m of Q89's 0.698 m x the carry scale (`hip_carry`'s `scale`), and points
  BACKWARDS in the fighter's own frame (negative along the node's forward, +Z of the skeleton);
- at every frame, the Hips WORLD position with extraction on (node moved by the summed travel + the posed skeleton)
  equals the Hips world position of the same take with extraction OFF (carried in the Hips, node still) within
  0.002 m - the extraction moves nothing on screen;
- a take entered part-way (seek to half its length) adds no travel on its first frame (under 0.002 m);
- `react_head` (a sway take) produces no travel at all (U88's carry stays in the Hips).
Print `fight_stage_travel_test: N checks, M failures` and quit.

## Gate - in this order, from the worktree root

0. The realism test on the UNCHANGED tree first:
   `python C:/Users/user/AppData/Local/Temp/FightCamp-tools/godot_run.py . tests/fight_stage_realism_test.gd --timeout 2400`
   - keep R1-R6 lines (BASELINE: Claude's merge reads R3 0.130).
1. Make the change. Parse gate on every touched `.gd`.
2. Your test through `godot_run.py` - 0 failures.
3. The realism test: no arg (PRODUCTION), `-- travel=off`, `-- gap=legacy`.
   - `travel=off` must print R1-R5b byte-identical to the BASELINE.
   - PRODUCTION: **R3 mean BELOW the baseline's**; react_body's by-take skate lower; **R2b, R3b and R4 still PASS**;
     study lines unchanged. Report R1, R3 (mean, p95, frames, by-take), R4, R5, R5b and R6 for all four runs.
   - If R3 does not fall, STOP and report - do not tune.
4. Subset: `python Godot/tools/run_tests.py --only clip,retarget,stage,anim,fight_world,paired,live_schedule,engine_input,inertia,sway,travel --jobs 2`.
   The realism test fails by design; any OTHER failure must fail identically on `origin/master` (copy your file aside,
   `git checkout origin/master -- <file>`, re-run that one test, copy yours back - never `git stash`).

## The digest `research/U89_TRAVEL.md`

Opens with `## DECISIONS`: the four-run table (R1, R3 mean/p95/frames, R3b, R4, R5, R5b, R6), the by-take skate for
react_body, react_head, hook_lead and cross in each, the lateral total dropped per body, the subset's SUITE line.

## Commit

`git status -s` first. Commit ONLY the owned files, paths on the commit line; `git show --stat HEAD`;
`git push -u origin cursor/u89-travel`; `python Tools/agent_comms.py send --from cursor --to claude --topic "U89 ready" --body "<hash>"`.
Do not edit `HANDOFF.md`.

## The trap

**Axes and signs.** U88's first delivery used `Vector3.FORWARD`, which in Godot is (0, 0, -1), and made the skate
worse. Build every axis from explicit components, and let your world-pose check (above) prove the sign. And a
GDScript runtime error HANGS a headless run until its timeout: read the log after the first minute.

## SEND-BACK 1 - Claude, 2026-09-13 late night. READ THIS BEFORE TOUCHING ANYTHING.

Your STOP was right. Your implementation stays: build on the UNCOMMITTED WIP in your worktree. Do NOT rebase, reset,
stash or check out master over it.

**What Claude found in your own logs.**
1. **`_apply_travel` does not move both bodies.** With A = mid - axis*gap/2 and B = mid + axis*gap/2, your update
   (`_gap += pb - pa`, `_mid += _axis * (pa + pb) * 0.5`) moves A by exactly `axis*pa` and B by exactly `axis*pb`.
   So "move only the staggering node" would change nothing. Keep `_apply_travel` as it is.
2. **The idle skate rises whenever TRAVEL IS ON, in BOTH gap modes:** idle 0.09 m/s under `gap=legacy`
   (`godot_FightCamp-U80_fight_stage_realism_test.gd_231848.log`), 0.11 in production (`_231801.log`), 0.02 at
   baseline. The likely cause is the RE-CLOSING. Each stagger now really opens the gap 0.35-1.38 m, and `_step_gap`
   closes it on an exponential whose tail is slower than the walk clip can play. Below
   `FightStagePlayer.WALK_MIN_RATE` (0.17 of native, `FightStagePlayer.gd:379`), `walk_at` puts the body back in
   stance while the room keeps sliding its node. A stance body that slides IS idle skate. This is roadmap S4a (3),
   "step or stay put, never glide", and it is U89's job now, because U89 is what makes the gap move.
3. **Your table's `travel=off` row (R3 0.167, p95 0.638) matches the `gap=legacy` row exactly, and no travel=off log
   exists.** Treat it as NOT MEASURED. The original task requires travel=off to reproduce BASELINE exactly.

**Do these in order.**
- **A. A log for every run.** Run every realism run through `godot_run.py`. The digest names each run's log file next
  to its table row.
- **B. Measure BASELINE and travel=off.** BASELINE runs on the unchanged files: copy your three edited `.gd` files
  aside, `git checkout -- <those three>`, run, then copy yours back (never `git stash`). travel=off runs on your
  WIP. Compare every `RULE` and `measured:` line of R1-R5b with a small script; they must be byte-identical. If they
  differ, find the take whose by-take number moved and fix the switch until they match. This comes before
  everything else.
- **C. Trace the glide before you fix it.** In `FightWorldLiveScreen`, for each body on every frame, add up the node's
  horizontal displacement on frames where that body is NOT walking. Add `func is_walking() -> bool` to
  `FightStagePlayer` returning `_walking()`. Print `GLIDE A <m> m over <n> frames; B <m> m over <n> frames` in
  `_finish`, and add a getter the realism test prints on its POPULATION line. Run production and travel=off.
  Expected: glide metres are higher with travel on. **If they are not, STOP and report the numbers.** The hypothesis
  would then be wrong, and Claude re-plans.
- **D. The fix: step or stay put, never glide.** In `_step_gap` (not under `legacy_gap`), a body the room moves this
  frame moves at a speed its walk clip can show. The minimum is `WALK_MIN_RATE * native_speed_mps` of `loc_advance`
  when the gap closes and of `loc_retreat` when it opens (`FightClipBinding.metadata_for(role)`; today 1.736 and
  1.781 m/s, so about 0.30 m/s a body).
  - When the exponential's per-body speed is below that minimum, raise the step to the minimum, but never past `diff`.
  - When `absf(diff) <= GAP_EPSILON_M`, move nothing.
  - When both bodies move, each covers half, so the minimum applies to each body. The gap's speed is then twice the
    minimum (about 0.60-0.61 m/s), which can exceed `STEP_MPS` (0.6). So the cap becomes
    `maxf(STEP_MPS, sum of the moving bodies' minimums) * delta`. The cap exists to stop a large band change being
    crossed in one frame, never to force a glide.
  - `_walk_at_body_speed` then only ever receives a playable speed or nothing. Derive every number from the
    constants named here; invent none.
- **E. Re-run** production, travel=off and gap=legacy, each printing GLIDE.

**The gate. It REPLACES step 3 of the original gate; steps 0-2 and 4 stand.**
- travel=off: R1-R5b byte-identical to BASELINE, proven by the script.
- PRODUCTION:
  - R3 mean BELOW BASELINE's.
  - idle by-take skate at most BASELINE's idle + 0.01 m/s.
  - GLIDE metres for each body at most travel=off's.
  - R2b, R3b and R4 still PASS, and no study line changes.
- `fight_stage_travel_test`: 0 failures.
  - Your one failing check (0.695 m against the scaled 0.730 m) is decided by the PHYSICAL pin you already have: the
    Hips world position with extraction ON equals extraction OFF within 0.002 m.
  - Derive the expected length from the extraction-OFF run of the same take: the Hips' world horizontal displacement
    from its first frame to its last. Assert the summed travel is within 0.01 m of that.
  - Print Q89's 0.698 m and the carry scale on a REFERENCE line only. The digest says which figure the travel matched
    and why; check the skeleton's world scale.
- Then the subset exactly as the original gate says, at `--jobs 2`. Claude runs a subset in the main checkout at
  the same time, so never go above 2 (the PC overheats).
- **If R3 does not fall after D, STOP and report with the GLIDE numbers. Do not tune constants.**

Then the digest (add the GLIDE columns and the log names), the commit (ONLY the owned files, paths on the commit
line), the push of the branch and the mail, exactly as the original task says.

## SEND-BACK 2 - Claude, 2026-09-14. A TRACE, NOT A FIX. READ BEFORE TOUCHING ANYTHING.

Send-back 1 did its job on two counts: `travel=off` now reproduces BASELINE, and the travel test passes 37/0. But
**production is byte-for-byte the same as before the min-walk change** (R3 0.179, idle 0.11). So the change never
touched what skates, and nobody knows yet what does. Keep all your WIP. Do NOT change behaviour in this pass.

**Why GLIDE cannot answer it.** `_track_glide` runs after `_apply_travel`, so it counts the stagger's own travel as
glide. That travel is legitimate root motion: the feet stay planted because extraction keeps the world pose. So
212 m against 38 m mostly measures travel. Fix the instrument first.

**Do, in order.**
- **A. Per-frame motion record, room side.** In `FightWorldLiveScreen`, for each body on every frame, record the
  node's horizontal displacement from each source separately:
  - `gap_m`: position after `_step_gap` minus position before it;
  - `travel_m`: the same around `_apply_travel`;
  - `walking`: `is_walking()` read right after `_walk_at_body_speed`;
  - `anim`: the AnimationPlayer's `current_animation`.
  Expose them through `func frame_motion(side: String) -> Dictionary`, overwritten each frame. Replace GLIDE with
  `GLIDE <side>: gap-not-walking <m> m, gap-walking <m> m, travel <m> m`.
- **B. Attribute R3's skate, test side.** In `fight_stage_realism_test.gd`, on every frame R3 already scores as
  planted-foot skate, read `frame_motion()` for that body and add the frame's skate to one of four buckets:
  - `gap_not_walking`: gap_m > 0.0005 and not walking;
  - `gap_walking`: gap_m > 0.0005 and walking;
  - `travel`: travel_m > 0.0005;
  - `unmoved`: the node did not move, so the skate is IN THE POSE.
  Print, for the `idle` take and for all takes:
  `R3-TRACE <take>: <bucket> frames=<n> mean=<m/s>` for each bucket. Also print the top five `anim` names inside
  `gap_not_walking` and inside `unmoved`.
- **C. Run it:** PRODUCTION and `travel=off`, through `godot_run.py`, with logs kept.
- **D. Report and STOP.** The digest gets a `## TRACE` table: bucket x run, for the idle take and for all takes.
  Commit NOTHING, push nothing. Send the mail with `--topic "U89 trace"` and the two log file names as the body.

**What each outcome would mean.** Claude decides the fix from this; you do not.
- idle skate mostly `gap_not_walking`: `walk_at` refuses. Look at `anim` - a body that is not in idle or a walk
  (for example a stance take named `idle#...`, a block or a recovery) is slid while it plays.
- idle skate mostly `unmoved`: the skate is in the pose, not the room. Likely the Hips after an extracted stagger,
  or an inertialized join out of one.
- mostly `gap_walking`: the walk plays at the wrong speed for the node.

The trap is the same: build no axis from Godot's named directions, and read the log after the first minute.

## SEND-BACK 3 - Claude, 2026-09-14. YOUR TRACE FOUND IT; THE ROOT CAUSE IS FIXED ON MASTER. NOW MEASURE WITH IT.

Your trace was exactly right: the idle skate is `gap_not_walking`, and `gap_walking` never fired. Claude probed
`walk_at` and found why no walk EVER played: `FightClipBinding.metadata_for` copies a fixed list of keys and dropped
`native_speed_mps`, so `walk_at` computed a rate of 0 on every call. That makes send-back 1's min-walk change
unmeasurable, not wrong. The fix is on master in `c781ab1`, with `tests/fight_stage_walk_test.gd`, which fails 5/13
without it and passes 13/13 with it.

**Do, in order.** Keep your WIP; do not rebase, merge, stash or reset.
- **A. Apply the fix by hand.** Read master's version with
  `git show c781ab1 -- Godot/scripts/FightClipBinding.gd`: five added lines in `metadata_for`. Add the same five lines
  to your `FightClipBinding.gd` (`git fetch origin master` first). Copy `tests/fight_stage_walk_test.gd` with
  `git show c781ab1:Godot/tests/fight_stage_walk_test.gd > Godot/tests/fight_stage_walk_test.gd`. Parse gate both,
  then run the walk test: 13/13.
- **B. Re-run with your trace in place:** PRODUCTION, `travel=off` and `gap=legacy`, each through `godot_run.py` with
  its log kept.
- **C. The gate (send-back 1's, with the trace added):**
  - travel=off: R1-R5b byte-identical to a BASELINE you re-run on the unchanged files PLUS the five-line fix.
    Name that run BASELINE+FIX. Copy aside and restore as before, never `git stash`.
  - PRODUCTION:
    - R3 mean BELOW BASELINE+FIX's;
    - idle by-take skate at most BASELINE+FIX's idle + 0.01 m/s;
    - `gap_not_walking` metres for each body at most travel=off's;
    - `gap_walking` above zero (walks now happen);
    - R2b, R3b and R4 PASS.
  - `fight_stage_travel_test` 37/0, walk test 13/13. Then the subset at `--jobs 2`, adding `walk` to the `--only`
    list.
  - If R3 does not fall, STOP and report the trace table for all three runs. Do not tune.
- **D. On a pass:** the digest gets the three-run table and the trace table. Commit ONLY your owned files, now
  including `Godot/scripts/FightClipBinding.gd` and `Godot/tests/fight_stage_walk_test.gd` (identical to master's -
  say so in the message), with paths on the commit line. Then `git show --stat HEAD`, push the branch, and mail
  `--topic "U89 ready"`.

## SEND-BACK 4 - Claude, 2026-09-14. A SECOND TRACE: WHY A WALK AT BODY SPEED STILL SKATES.

Send-back 3 did what it had to. Walks play now (`gap_walking` 8,412 frames), and travel=off matches BASELINE+FIX.
But PRODUCTION R3 rose 0.130 -> 0.209 (idle 0.09), and the walk frames skate. One hypothesis, UNPROVEN - trace it,
do not act on it: `native_speed_mps` (1.736 / 1.781) was measured by U84 on the SOURCE skeleton. On f01 the retarget
scales the hips' height and the stride with the fighter's legs, so the stride speed ON f01 may differ. A walk played
at body speed / the source's stride speed would then slide by exactly that ratio.

**Do, in order. No behaviour change, no commit, no push.**
- **A. f01's own stride speed.** Bind a `FightStagePlayer` to f01 as `tests/fight_stage_walk_test.gd` does. Play
  `loc_advance` at rate 1.0 on the caller's clock for one full loop at 1/30 s, with the NODE STILL. For each frame,
  record both toe bones' world X/Z. A planted foot moves backwards under a walking body at the stride speed, so the
  stride speed is the mean backward speed of whichever toe is lowest, over the frames where that toe is within
  0.02 m of its lowest height. Do the same for `loc_retreat`. Print `STRIDE f01 loc_advance <m/s> (bound 1.736)` and
  the same for loc_retreat.
- **B. Where the walk frames skate.** In your realism trace, for frames whose take is `loc_advance` or `loc_retreat`,
  also bucket R3's skate by the ratio playing rate / (node speed / f01 stride speed from A). Buckets:
  `<0.8`, `0.8-1.2`, `>1.2`. Print frames and mean skate for each.
- **C. Report and STOP.** Add a `## TRACE 2` table to the digest: A's two stride speeds against the bound values, and
  B's buckets for PRODUCTION. Mail `--topic "U89 trace 2"` with the log names as the body.

**What it would mean.** If f01's stride differs from the bound speed by more than 10% and the skate sits in the
off-ratio buckets, the fix is to measure the stride on the fighter being played. If the stride matches, the skate is
in the rate changes (`WALK_RATE_STEP`) or the blends, and Claude re-plans.

## SEND-BACK 5 - Claude, 2026-09-14. MERGE MASTER, THEN TRACE WHY A BODY SLIDES WITH NO WALK UNDER IT.

Trace 2 was clean and settled it: f01's stride matches the bound speed, so the walk's RATE is not the skate. Claude
now takes the walk's own skate (the hip sway the retarget drops, measured in isolation with the bake-off tool) on a
Claude branch - do not touch walk playback. Yours is the other half of PRODUCTION's R3: the `gap_not_walking` bucket,
8,882 frames at 0.631 m/s (idle x4089, hook_lead x621, react_body#4 x492). The room moves a body and no walk plays.
On master, `_step_gap` (`FightWorldLiveScreen.gd:429`) approaches the target exponentially, capped at `STEP_MPS` over
both bodies, and `walk_at` (`FightStagePlayer.gd:385`) refuses below `WALK_MIN_RATE` (0.17 x 1.736 = 0.295 m/s) - so
most of that approach is slower than the slowest readable walk. That is a hypothesis about master; your branch changed
the gap and walk logic in send-back 1. TRACE IT ON YOUR BRANCH, do not act on it.

**Do, in order.**
- **A. Commit your WIP, then merge master.** `git status -s` first.
  1. Move the trace out of the test folder (every file in `Godot/tests/` is run by the suite):
     `git mv` is not possible for an untracked file - just move `Godot/tests/fight_stage_stride_trace.gd` to
     `Godot/tools/fight_stage_stride_trace.gd` and fix any `res://tests/` path inside it.
  2. Master already has `Godot/tests/fight_stage_walk_test.gd`. Compare yours with
     `git show origin/master:Godot/tests/fight_stage_walk_test.gd`; if identical, delete your untracked copy, else STOP
     and report the difference.
  3. Commit on `cursor/u89-travel`, paths on the commit line, ONLY: `Godot/scripts/FightClipBinding.gd`,
     `Godot/scripts/FightStagePlayer.gd`, `Godot/scripts/FightWorldLiveScreen.gd`,
     `Godot/tests/fight_stage_realism_test.gd`, `Godot/tests/fight_stage_travel_test.gd`,
     `Godot/tools/fight_stage_stride_trace.gd`, `research/U89_TRAVEL.md`. Never the stray root copies
     (`FightStagePlayer.gd`, `FightWorldLiveScreen.gd` at the worktree root), `.u89_backup/`, `.u89_logs/`,
     `research/u86_log_*`, `Godot/tools/probe_u88_toe_skate.gd` or any AgentComms mail. `git show --stat HEAD`.
  4. `git fetch origin && git merge origin/master`. Master moved your files only a little since your base `722125a`:
     `FightClipBinding.gd` +5 (the SAME five lines you applied by hand - keep one copy), `FightStagePlayer.gd` +25
     (`NEAREST_CLIP`), `FightWorldLiveScreen.gd` +9 (`fighter_b_mesh`). Keep both sides of every conflict.
  5. Parse gate on the four `.gd` files. Then, one at a time: `fight_stage_walk_test` 13/13,
     `fight_stage_travel_test` 37/0, `fight_stage_technique_fidelity_test` and `fight_stage_presenter_contract_test`
     (both must pass as they do on master). `git push origin cursor/u89-travel` - the branch, never master.
- **B. The trace. No behaviour change.** In PRODUCTION (no arg), for every frame your R3-TRACE puts in
  `gap_not_walking`, record WHY that body is not walking. Exactly one reason per frame, checked in this order:
  - `not_called` - the room did not call `walk_at` for this body this frame;
  - `not_playing` - `_ap` is null or not playing;
  - `busy_take` - the current take is neither a walk nor stance (record its role);
  - `below_min_rate` - the rate came out under `WALK_MIN_RATE` (record the body speed);
  - `not_grafted` - the walk role is not bound;
  - `other` - anything else (say what).
  Print two tables for PRODUCTION, and the first one for `travel=off` too:
  1. reason x take role: frames, mean R3 skate (m/s), metres moved;
  2. `gap_not_walking` frames by the body's own speed: `<0.05`, `0.05-0.15`, `0.15-0.30`, `>=0.30` m/s - frames and
     mean skate - and, for `busy_take` only, whether the frame is in the take's first 0.25 s, last 0.25 s, or between.
- **C. Report and STOP.** Add `## TRACE 3` to the digest with those tables and the merge commit hash. Mail
  `--topic "U89 trace 3"` with the log names as the body. No further change.

**What it would mean.** `below_min_rate` dominating: the room crawls bodies slower than any walk can show, and the fix
is to move in steps at a readable speed and then stand - not to slide. `busy_take` dominating: the room drags a man
under his own punch or flinch, and the fix is to hold his half of the gap until the take ends. `not_called`: the
trigger misses frames. Claude re-plans from the table.

**SEND-BACK 5 ADDENDUM - Claude, 2026-09-14 ~02:00. Your stop was correct, and the trap was Claude's wording.** The post-merge `travel=off` numbers (R3 0.218 / p95 1.214, R1 1.92 s, R4 95%, R5 RightUpperArm 3.42x, R5b 2.09x) are EXACTLY master's since `762fa44` (the watchable-room merge: NEAREST_CLIP plays more clips; the roadmap records R3 0.130 -> 0.218, led by hook_rear 2.00 m/s x2179). They are the NEW BASELINE, not a merge defect. Continue from part A step 5 (the four tests, then push the branch), then parts B and C, with the post-merge `travel=off` run as the baseline. Leave hook_rear's skate alone - it is Claude's (strikes).

## SEND-BACK 6 - Claude, 2026-09-14 ~02:45. A BODY MOVES ONLY WHEN YOU CAN SEE IT WALK.

TRACE 3 was exactly what was needed. Two findings drive this send-back, plus one probe of Claude's:
- `below_min_rate` on stance: the room crawls a body at 0.15-0.30 m/s, slower than any readable walk
  (`WALK_MIN_RATE` 0.17 x 1.736 = 0.295 m/s), so it slides. The bands are only 0.15 m apart (LONG 1.10, MID 0.95,
  POCKET 0.80), so most band changes move each body 7.5 cm through the exponential tail.
- `busy_take`: the room drags a man under his own reaction or punch (react_body 1,721 frames, react_head 659).
- Claude's `tools/probe_walk_direction.gd` (on master): loc_advance played at a matched rate on a body moving along
  its own +Z skates only 0.025-0.038 m/s at 0.3-0.5 m/s. So a STEADY walk is clean; short walks that are mostly
  crossfade are not.
- MASTER MOVED: `087a3c9` - every striking role now carries its hip sway (R3 0.218 -> 0.172 on master's production).

**Do, in order.**
- **A. Merge master.** `git fetch origin && git merge origin/master` (your branch touches none of the strike carry's
  lines except `fight_stage_realism_test.gd`: master replaced `sway=strikes` with `sway=receivers` - keep master's).
  Parse gate your four scripts. **BASELINE** = master's behaviour on your merged branch: `-- travel=off gap=legacy`.
  Its R3 mean must be 0.172 +/- 0.003 (master's); if not, STOP and report - the merge is wrong.
- **B. The behaviour contract** (implement it in `FightWorldLiveScreen.gd` / `FightStagePlayer.gd`; your design):
  1. A body is FREE when its AnimationPlayer holds stance (`idle` takes) or a walk (`loc_*`); otherwise BUSY.
  2. A BUSY body's node is never moved by the gap. (Your travel still moves a body by its own clip's travel.)
  3. A FREE body's node moves at exactly `WALK_MPS`, or not at all - no speed in between except the last frame's
     remainder - and while it moves its AnimationPlayer holds `loc_advance` / `loc_retreat` at `WALK_MPS` / native.
  4. Each body closes at most its OWN half of the gap error (`target_gap - gap`, measured from the two positions),
     and stands when its remaining half is at most `GAP_DEADBAND_M`.
  Keep `-- gap=legacy` reproducing master's gap logic, so BASELINE stays measurable.
- **C. Sweep the two new constants, four runs, nothing else:** `WALK_MPS` in {0.35, 0.50} x `GAP_DEADBAND_M` in
  {0.04, 0.08}, each as PRODUCTION (travel on). Add ONE report line to the realism test: mean |gap error| in metres
  over all frames (so we see whether range fidelity pays for the feet). For BASELINE and each variant print: R3 mean
  and p95, `gap_not_walking` frames and metres, mean |gap error|, R6 mean body speed, R2b / R3b / R4.
- **D. The gate, on the variant with the lowest R3 mean:**
  - R3 mean below BASELINE's;
  - `gap_not_walking` frames at most 10% of BASELINE's;
  - R2b, R3b, R4 PASS;
  - `fight_stage_walk_test` 13/13, `fight_stage_travel_test` 37/0, `fight_stage_technique_fidelity_test` and
    `fight_stage_presenter_contract_test` pass; then
    `python Godot/tools/run_tests.py --only clip,retarget,stage,anim,fight_world,paired,live_schedule,engine_input,inertia,sway,travel,knockdown_count,walk --jobs 2`
    ends with only `fight_stage_realism_test` failing (red by design).
  - Set the chosen constants in code, commit your owned files with paths on the commit line, `git show --stat HEAD`,
    push `cursor/u89-travel` (never master), digest `## SEND-BACK 6` with the five-row table, mail `--topic "U89 ready"`.
  - **If no variant beats BASELINE's R3: STOP.** Commit nothing new; put the five-row table and TRACE 3's two tables
    for the best variant in the digest; mail `--topic "U89 sweep"`. Do not tune beyond the four.
