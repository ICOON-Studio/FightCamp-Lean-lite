---
name: project-session-s141-2026-10-02
description: "S141 - 5 branches merged as diffs, fixed a real OFF-arm byte-identity regression, two U208 send-backs (gloves frozen, gloves ugly), C240b landed+parked, K83 scorebug mounted"
metadata:
  node_type: memory
  type: project
  originSessionId: b8add24e-181e-45ff-b1e9-727b687ee8cf
  modified: 2026-10-02T09:17:54.170Z
---

- Merged 5 in-flight branches, each as `git diff <merge-base>..<head> -- <owned files>` + `git apply --3way`
  against current master, never a blind whole-file diff (several branches were cut before Q233/G157/MH1/K83
  landed): Q233 boxing clinch engine (`cf984127`), G157 VAT crowd people (`1743b9af`), Q226 speed/strands/
  technique-effects inputs (`85d71d1d`), Q232 rooms bright pass 3 (`92943a81`), Q230 regional venue PBR/light/
  banners (`4434d63d`). Three had real conflicts, resolved by union/keeping both sides, not by picking one.
- Found a genuine cross-branch interaction bug by running the merged pair together (not each alone):
  `q226_strands_test.gd` failed post-merge because it duplicates `DEMO_SWITCHES` wholesale and the test predates
  `boxing_clinch` (Q233) - clinch interruptions were noise inside an isolation test. Fixed by excluding
  `boxing_clinch` from all three Q226 isolation tests. See [[feedback_a_port_brings_its_blind_spots]].
- A SECOND, more serious cross-branch bug surfaced later from a broad ~25-test suite run out of caution:
  `fight_strike_whole_test.gd`'s pinned OFF-arm SHA-256 hashes broke. `_run_impact` added a `"pushback_m"` key to
  every event dict unconditionally - value always 0.0 when `technique_effects` was off, but the key's mere
  presence changed the hash even though nothing semantic changed. Confirmed real (not pre-existing) against the
  session-start commit via a direct probe; fixed to only add the key when the switch is on; both pinned hashes
  match exactly now (`cd221b1f`). See [[feedback_a_new_key_breaks_a_hash_even_at_zero]] - a narrow
  "affected systems" test list by subsystem name would never have caught this.
- Mounted K83 BroadcastScorebug (Kalli's spec) in `FightWorldLiveScreen._build_round_clock`/`_update_round_clock`,
  replacing the old top-left clock box. Q233's clinch log is read by a NEW cursor-walk, not through `_pump_to`'s
  beat filter (same trap C240's own digest names). Added missing `class_name BroadcastScorebug` - needed
  `godot --headless --editor --quit` to register it in the global script class cache.
- C240 (Codex clinch room) had NO route decision despite NOT MERGE-READY - recorded RESUMED, wrote
  TASK_C240B, relaunched Codex once Q233 merged. C240b landed: real Q233 events routed into the room, a real
  10-bout paired census ran both arms, but the halving gate FAILED on measurement (head-overlap went UP,
  1897->1923, not down). Parked (route_decisions.json) rather than a third immediate attempt.
- Two U208 (tale-of-the-tape) send-backs from the operator mid-session: (1) heads cropped out of frame - the
  camera framed off the Head BONE (base of skull), not the mesh's true top; fixed by reading the posed mesh's
  AABB instead, same method `_feet_local_y` already used. (2) gloves frozen at bind pose - `CCFighterSkin` is
  RefCounted, a local `overlay` went out of scope and disconnected its sync listener (the exact trap
  MH1_DIGEST.md already named). Fixed by keeping a live reference. Once gloves actually tracked the hands, the
  operator saw their SHAPE and said "make another asset" - `CCFighterSkin._build_glove` is a scaled sphere +
  cylinder, used game-wide, not a U208 bug. Briefed + launched Codex on TASK_C241 (prefab-checked first) on the
  seat C240b had just freed.
- Operator asked directly about MH2 (MetaHuman demo boxers) mid-session - clarified MH1 was only a pilot, MH2
  (the actual swap) is still queued; operator chose to let current agent tasks finish first.
- Sent several operator taste checks via SendUserFile (C232 walkout video, S140 hit pop-up video, U208
  pick-one-of-3, the corrected U208 after each send-back, C240b's live-room clinch) - no pick/verdict received
  by session end; operator also used the session for unrelated help (Steamworks IBAN/KYC troubleshooting).
- Cursor's U210 launch silently failed TWICE via `agent_window.ps1` (reported a pid, no process ever spawned,
  no output file written). Cause: a STALE `cursor-agent` process from a PRE-SESSION U208 launch had been
  running for hours and was holding a lock that blocked new launches. Killed it by PID, then launched U210 via
  a direct foreground invocation (bypassing `agent_window.ps1`'s hidden-window wrapper) which worked
  immediately. See [[feedback_check_for_a_zombie_agent_process_first]].
- Q231 (Qwen venues), U210 (Cursor, FOOTLOCK, now genuinely running) and C241 (Codex, glove asset) were all
  still running at session end, not collected.
