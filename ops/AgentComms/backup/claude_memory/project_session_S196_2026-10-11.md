---
name: project-session-s196-2026-10-11
description: "S196: zoned floor, 95-item catalogue, capacity packer + view, garage removed (D46), Ludo round 30 half collected; Chrome safety-check trap for Ludo"
metadata:
  type: project
---

S196 (2026-10-10 evening -> 10-11): merged SHOUT1A/REFEREE1B, bpm effort spike, GYMLOOK1A zoned floor, EQUIP2 (95 items), GYMCAP1/1B/2 (capacity packer, report, packed-gym view `club_capacity`), GARAGEOUT1 (tiers T1 club 30x18 / T2 commercial / T3 elite). Digest `research/S196_DIGEST.md`; Ludo round 30 in `research/LUDO_ROUND30_S196.txt` (A full, B first ~50 rows, C part 1; D-H owed).

**Why:** operator S196: "why cant make a gym like that" (two reference pictures), "gyms have a lot more equipment", "remove the garge concept from everywhere", "ask ludo about the attrition per training area ... deliver it in full", "9 stats not enough" (we have far more underneath; the readout is the gap).

**How to apply:** operator order = decide the gym floor and UI FIRST, then reconsider UI design; Ludo designs, Claude writes verdicts, operator approves on the board. Traps: (1) agent worktrees lack imported assets so `check_workflow branch` reports NOT MERGEABLE - apply the diff to master and run the test there; (2) a path-limited `git add` with one missing pathspec aborts the whole add (a commit carried only live_runs.json); (3) Claude in Chrome: `navigate` often fails with "could not verify this site's safety category" - retry later; the `location.href='http://127.0.0.1:8799/?name=..&d=..'` save to Tools/arena_rx.py works even when the tool prints that error, then navigate back and click Ask Ludo (or click the button via JS) and send with `button.send-message`; (4) an agent's still can be a blank panel - open every still before taking it; (5) GYMCAP2 first aligned the packed ring to the club ring and pushed stations 10 m outside the hall - always assert inside-hall from the nodes. See [[feedback_ludo_not_mobile_deep_manager_sim]], [[reference_ludo_ai]], [[feedback_benchmark_real_world_before_design]].
