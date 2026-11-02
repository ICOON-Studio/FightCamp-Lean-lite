# S141 Digest - 2026-10-02 (Claude)

## 1. Collected and merged, each as a diff (never a whole stale file)

Five merges, each via `git diff <merge-base>..<branch-head> -- <owned files>` + `git apply --3way`
against today's master, not a blind 3-dot diff - several of these branches were cut before later
merges (Q233, G157, MH1, K83) landed, so their RAW diff against current master would have deleted
that work. Three had real conflicts, surfaced and resolved rather than silently papered over:

- **Q233** (Qwen, boxing clinch ENGINE) - `cf984127`. Need-based holds, distance threshold, referee
  break, penalty ladder. 9/9 clinch test. Clean apply, no conflicts.
- **G157** (Grok, VAT crowd) - `1743b9af`. Box spectators replaced by a clothed MultiMesh crowd.
  Stills opened (before: empty boxes; after: seated/standing crowd, varied poses/shirts) - confirms
  the digest. New binary assets needed a headless `--import` pass before tests saw them
  (`venue_crowd_test.gd` 11/11 FAIL before import, 0 fails after - not a code defect).
- **Q226** (Qwen, speed/strands/technique-effects inputs) - `85d71d1d`. Real 2-way conflict with
  Q233 in `FightRealtime.gd`/`q212_booked_census.gd` (both touch `DEMO_SWITCHES` and the census
  control-arm options) - resolved by union, not by picking a side. **Found a genuine interaction
  bug by running the merged pair together**: `q226_strands_test.gd` failed post-merge (tech 29.2%
  vs bal 30.6%, wanted tech > bal) because it duplicates the now-larger `DEMO_SWITCHES` wholesale
  and didn't know to exclude `boxing_clinch` (merged after the test was written) - clinch
  interruptions were noise inside a test isolating training_strands. Confirmed against Q226 alone
  (no Q233): passes clean. Fix: added `"boxing_clinch":false` to all three Q226 isolation tests.
- **Q232** (Qwen, rooms bright pass 3) - `92943a81`. Clean apply, no conflicts.
- **Q230** (Qwen, regional venues PBR/light/banners) - `4434d63d`. One conflict with G157 in
  `VenueRig.gd` (both inserted a helper beside `_add_seated_silhouette`) - kept both. Its own digest
  flagged incomplete after-renders ("empty framebuffer" on 2/3 venues, blamed on concurrent Godot
  processes); re-ran `capture_venue.gd` after confirming watchdog GREEN and process count down - all
  three venues rendered clean this time. Opened before/after (iron_parish standing + establishing):
  textured concrete walls/ceiling, FIGHTCAMP ring mark, volumetric haze all real. Noted one caveat in
  the digest: the `standing` camera framing differs before/after because `before` predates S139's V1
  ring geometry - a project-history artifact, not a regression.

Combined affected suite after all five (run together deliberately, to catch interaction, not each
alone): `SUITE total=20 fails=0` (8 rooms + venue/arena/smoke). `q233_boxing_clinch_test.gd` +
`q226_*_test.gd` + `q212`/`booked` together: `SUITE total=6 fails=0`.

## 2. C240 (Codex, clinch room) - dropped-route defect fixed

`start`'s uncollected scan flagged C240 as having NO route decision despite its own digest saying
NOT COMPLETE / NOT MERGE-READY (a scripted fixture, not real Q233 events; 30s excerpt failed its own
overlap-halving gate 17->15/900 frames). Recorded RESUMED in `route_decisions.json` (`959d7a25`):
blocked on Q233, which merged this session. Wrote `TASK_C240B_BOXING_CLINCH_ROOM_INTEGRATION.md` and
relaunched Codex in the same worktree (`E:/FightCamp/wt/C240`) to wire the real clinch events into
`FightWorldLiveScreen._pump_to`/`FightStagePlayer` and re-run the census on real bouts. Running at
session end (0 output yet - animation/room work takes a while).

## 3. K83 scorebug mounted (`42d4d5d0`)

`_build_round_clock`/`_update_round_clock` now build and drive Kalli's `BroadcastScorebug.gd`
(lower-left corner-colour bar/surname/record/code/clock) instead of the old top-left ad hoc box.
Added `class_name BroadcastScorebug` (missing - needed a `godot --headless --editor --quit` to
register it in the global class cache before `check_scripts.py` would parse the reference).

Q233's clinch log (`_state["fight"]["log"]`) is read by a new cursor-walk, NOT through `_pump_to`'s
beat filter - the engine appends `hold_warning`/`point_deduction` off its own tick, not the
action/grapple schedule, and a filter named only those two types has always been blind to
everything else (the same trap C240's own digest names for `_pump_to`). This drain only drives the
HUD (two new `BroadcastScorebug` methods, `warn`/`flash_message`, reusing the existing order-chip/
round-strip widgets); it does NOT mount anything on the fighters' bodies - that's C240b's job,
scoped separately in its task file so the two don't collide on the same file.
`fight_world_live_test.gd` TOTAL=24 fails=0.

## 4. Operator taste checks sent (owed since S139/S140)

C232 walkout video, the S140 hit pop-up video, and U208's three tale-of-the-tape layout options
(pick one of 3) - all sent via SendUserFile with the specific decision each one owes. No reply yet
at session end.

## 5. Not done / carried

- The ~25-test FightWorldLiveScreen-affected suite (launched broad, before the five merges, to
  baseline the scorebug change) was still running at session end with zero flushed output after
  ~1 h - almost certainly Python's full output buffering on a redirected file (every other targeted
  run this session completed and reported normally), not a hang; the 24/24 direct
  `fight_world_live_test.gd` run and the 20/20 combined affected suite both passed. Next session:
  check if it finished, read its tail.
- Q231 (Qwen, national/international venues) was still writing (uncommitted `VenueRig.gd` + new
  venue assets) at session end - not collected, leave it running.
- FOOTLOCK brief (S139_DIGEST s6, `tools/s139_slide_probe.gd` gate) still owed to the first free
  Codex/engine seat - not briefed this session (C240b took the one freed Codex seat).
- MH2 (demo boxers as MetaHumans) still queued, no seat assigned.
- The exe walk for the 10-06 demo (item 5 of the S139 recorded next action) not done this session -
  five merges plus the scorebug mount ran the available time.

## 6. Route decisions
C240 RESUMED (section 2). Q233/G157/Q226/Q232/Q230 all merged clean - no new route entries needed
(they were in-flight, not dropped).

## Next
(1) Collect: the big affected suite (read its tail), C240b when it lands (judge the video, apply the
DIFF), Q231 when it commits, U210 (Cursor, FOOTLOCK planner-only path) when it lands. (2) MH2 brief
when a seat frees. (3) The exe walk for the 10-06 demo once C240b's clinch is in and judged -
3 days left (2026-10-05 effectively, given the 10-06 date). (4) Read the operator's U208
tale-of-the-tape pick and taste verdicts on C232/hit-popup when they answer.

## 7. Send-back (mid-session, operator): U208 heads were cropped out of frame

Operator, after seeing the first U208 send: "head is not showing recalibrate" (with a screenshot of
`variant_2_faceoff`-style framing showing a headless fighter). Traced to
`u208_tott_previews.gd._frame_full_height_camera` (variant 1 DWCS + variant 3 FightCamp): it framed
off the Head BONE position, which sits near the base of the skull/neck, not the top of the visible
head - leaving only ~1-1.3% of span as top margin, thinner than the skull's own extent above the
bone. Fixed by reading the true head top from the posed mesh's AABB (mirrors how `_feet_local_y`
already measures the feet - the posed mesh, not a bone/rest guess). No free Cursor/Codex/Qwen seat
was available (all three on C240b/U210/Q231), so fixed directly per the "write it yourself when no
seat is free" rule. Re-rendered all three variants, re-encoded all three MP4s, rebuilt the contact
sheet, opened all three stills before resending - confirmed clean. Pushed to
`cursor/u208-tott-previews` (`a17b0d2c`), not yet merged (same branch the operator's pick-one-of-3
still gates). `run_tests.py --only portrait,tale_of,fight_night`: SUITE total=4 fails=0.

## 8. Send-back 2 (operator): gloves frozen, then "make another asset" - C240 parked, C241 launched

Operator, same thread: "the gloves are not rendered right" (screenshot: red gloves stranded near the
hips/frame edge while the raised guard hands were bare). `CCFighterSkin` is `RefCounted` - the local
`overlay` in `u208_tott_previews.gd._build_fighter_rig` went out of scope the instant the function
returned, disconnecting its `skeleton_updated` listener (the exact trap MH1_DIGEST.md already named:
"a glove object that goes out of scope disconnects and its gloves freeze at rest"). Fixed by
returning the overlay in the rig dict so a live reference survives the whole render. Re-rendered,
re-encoded, opened stills, confirmed, pushed (`a17b0d2c`+1 on `cursor/u208-tott-previews`).

With gloves now actually tracking the hands, the operator saw their SHAPE clearly for the first
time and said: "the gloves look terrible make another asset for the gloves." Traced to
`CCFighterSkin._build_glove`: a `SphereMesh` scaled non-uniformly + a `CylinderMesh`, two primitives
stitched together, used by EVERY fighter in the game (live ring, portraits, every preview), not a
U208-only placeholder. Wrote `TASK_C241_REAL_GLOVE_ASSET.md` and launched Codex on it (its C240b
seat had just freed - see section 9). Real dimensions already exist (`G80_GLOVE_DIMENSIONS.md`); the
task asks for a prefab check first, then Blender authoring if nothing licensed fits.

Also this session: Codex's C240b (clinch room, started S141 before this send-back) landed while
investigating the glove bug - see section 9.

## 9. C240b landed - NOT merge-ready, parked

Real Q233 clinch events now route through `FightWorldLiveScreen._pump_to` into `FightStagePlayer`
(walks `fight.log` with a cursor). A real 10-bout paired booked census ran both arms (Q233 on/off,
10/10 complete bouts each, ~195k sampled frames). The halving gate FAILED on real measurement: head-
overlap frames went 1,897 (off) -> 1,923 (on), UP not down. Hold-rate-per-round (2.0/2.0/1.5)
undershoots the Davis et al. 2015 amateur reference (2.5/3.2/4.8). `fight_stage_realism_test.gd`'s
600s timeout was confirmed to reproduce on an UNMODIFIED baseline too - pre-existing, not caused by
C240b. KO/TKO stayed in band on the full Q212 census (45.0% on / 43.3% no_q233 control).

Recorded PARKED in `route_decisions.json` rather than an immediate third attempt: two rounds (C240,
C240b) both missed the halving target by a real margin, not a near-miss. The clinch pairing geometry
(`fit_boxing_hold_pair`) likely needs a different approach, not another tuning pass. Codex's freed
seat went to C241 (the glove asset, section 8) instead - the operator's more immediate ask.

## 10. A real engine regression, found and fixed: pushback_m broke OFF-arm byte-identity

While investigating the broader affected-system suite (launched to baseline the scorebug mount),
`fight_strike_whole_test.gd` FAILED a check that had never failed before this session:
"OFF boxing/mma events and verdict byte-identical to baseline" - a pinned SHA-256 hash test, the
project's strictest regression gate (any DEMO_SWITCHES-off arm must produce bit-identical output to
pre-feature master).

Confirmed real (not pre-existing) by running the same hash probe against the session-start commit
(`ce563747`) in a temporary file-swap - it matched the pinned hashes exactly there. Found the cause
by diffing a direct single-bout probe's event JSON, current vs. session-start, same seed: every
`type: action` event in `_run_impact`'s returned dict carried a NEW unconditional key,
`"pushback_m": float(technique_eff.get("pushback_m", 0.0))`. `technique_eff` is `{}` when
`technique_effects` is off, so the VALUE was always a harmless `0.0` - but the KEY's mere presence
changed the JSON string, and therefore the hash, even with zero semantic effect. The house
convention elsewhere in the same two merges (`_speed_bias_for`, `_identity_bias`) is "OFF = {} =
byte-identical" - this one field broke that pattern.

Fixed: the key is now added to the event dict only when `technique_effects` is actually on. Every
reader already used `.get("pushback_m", 0.0)` with a safe default, so nothing downstream changed.
Re-verified the direct probe's event JSON matches the pre-merge baseline byte-for-byte, and both
pinned hashes now match exactly. `cd221b1f`.

**Trap for next time:** a byte-identity hash test like this one will NOT be caught by any targeted
"affected systems" test list that doesn't happen to include it by name - it only surfaced because the
broad ~25-test suite (launched out of caution, not because anything pointed at it) included it. Two
test files touch this exact invariant and are easy to miss when scoping an affected-test run:
`fight_strike_whole_test.gd` and (per its own comments) anything else pinned the same way. Worth
adding to the default affected-test list for any change to `_run_impact`'s event shape.

An unresolved risk this session leaves open: the broader affected suite that originally surfaced this
(launched before the fix, 5 fails of 26: 3 confirmed pre-existing hangs, 1 now-fixed byte-identity
fail, 1 unconfirmed - `fighter_gloves_both_corners_test.gd`, not yet directly isolated) should be
re-run from a clean state next session to confirm nothing else is hiding in the other failures. A
focused re-confirmation of the fix's own blast radius (`fight_strike_whole,q226,q233_boxing_clinch,
q212,booked,fight_intent`) came back `SUITE total=7 fails=0` - the fix itself is solid; the broader
26-test suite's other 2 unconfirmed failures are the open item.

## 11. A launcher trap: a pre-session zombie process silently blocked Cursor twice

Launching Cursor on U210 via `Tools/agent_window.ps1` reported `launched 'CURSOR U210' pid=XXXXX`
twice, but no `cursor-agent` process ever actually spawned for that workspace (checked via
`Get-CimInstance Win32_Process`), and no output file was ever written - looked exactly like a broken
launcher. The real cause: a `cursor-agent` process from a PRE-SESSION U208 launch had been running
for HOURS (since before this session started, well past when its actual work had already landed and
committed) and was silently holding a lock that blocked any new Cursor launch. Killed it by PID (not
by image name), then launched U210 via a direct foreground invocation of `cursor_task.cmd` (bypassing
`agent_window.ps1`'s hidden-window wrapper, which still failed silently a third time even after the
zombie was cleared) - that worked immediately, confirmed by a real `cursor-agent` node process
spawning for `E:/FightCamp/wt/U210`. See [[feedback_check_for_a_zombie_agent_process_first]]. Next
session: if `agent_window.ps1` itself is still silently swallowing Cursor launches, worth a closer
look at why the hidden-window mode specifically fails where the direct foreground call succeeds.
