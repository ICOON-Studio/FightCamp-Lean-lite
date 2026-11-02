# TASK U100 — CURSOR — "JERKY MOVES": EASE THE CONTACT PUSH IN AND OUT, SWEPT AND MEASURED

Model: `composer-2.5`, medium, `-p --force --trust`. Owner: cursor. Worktree
`C:/Users/user/AppData/Local/Temp/FightCamp-U80`, branch `cursor/u100-push-ease` - Claude creates it from `master`
before launch. Push the BRANCH. Stage: S4a (operator, 2026-09-14, on the gloves-stop-at-contact build side by side:
"Right is better"; asked what looks MOST wrong now: "Jerky moves").

**Test tier: A PRODUCTION SCRIPT EDITED BEHIND A SWITCH WHOSE DEFAULT IS OFF.** Parse gate on every touched `.gd`; the
sweep runs below; then `python Godot/tools/run_tests.py --only contact_solve,fight_world,live_schedule --jobs 2` must
end `fails=0`. No full suite. `python research/U100_check.py` must exit 0 before you commit - if it cannot, do not
commit: send `--topic "U100 BLOCKED"` with its FAIL lines. ONE Godot at a time in your worktree.

## Owned files

- `Godot/scripts/FightWorldLiveScreen.gd` - EDIT (923 lines: never open it whole; `sed -n` windows at `:223-240`
  configure's options, `:385-398` the frame loop that calls `_solve_contacts()`, `:646-655` `_solve_contacts`).
- `Godot/tools/measure_jerk.gd` - EDIT (272 lines, read it whole).
- `Godot/tests/fight_stage_realism_test.gd` - EDIT (1,769 lines: never open it whole; the switch parsing is `:111-140`).
- `research/U100_push_ease.json`, `research/U100_PUSH_EASE.md` (20 lines at most) - NEW.

## Why this exists

Since `934d15d` each glove and forearm inside the other man is pushed out through the arm IK every frame
(`FightContactSolve.hand_pushes` -> `FightStagePlayer.push_hand`), and the push is recomputed from zero every frame: it
switches on, flips direction and switches off in a single frame. Claude re-ran U99's jerk census on `3fedec4`
(`research/S4A_SMOOTH/jerk_3fedec4.json`): `contact_push` is now on **80%** of the worst 1% of jerk frames, all 40
of the worst moments are hands, and hand jerk ROSE (LeftHand p95 3,990 -> 5,299 m/s^3, RightHand 2,675 -> 3,325) while
the head, chest, hips and feet all got calmer.

## The change (a contract - exact names)

`FightWorldLiveScreen.configure(options)` reads two new floats, `options["push_attack_s"]` and
`options["push_release_s"]`, into `var _push_attack_s: float = 0.0` and `var _push_release_s: float = 0.0`. **Both
default 0.0, and at 0.0 the room must behave exactly as today.** `_solve_contacts` takes the frame's `delta` (pass the
`_process` delta - never assume 1/30) and keeps, per body and per arm, an eased push `s` (a `Vector3` in world metres,
starting at zero). Each frame, with `t` the solve's push for that arm:
- the half-life is `_push_attack_s` when `t.length() >= s.length()`, else `_push_release_s`;
- a half-life <= 0 sets `s = t`; otherwise `s = s.lerp(t, 1.0 - exp(-0.693147 * delta / half_life))`;
- when `t.length() < 1e-5` and `s.length() < 1e-4`, set `s = Vector3.ZERO`;
- then `push_hand(arm, s)`.

`tests/fight_stage_realism_test.gd` accepts `-- push_attack=<s>` and `-- push_release=<s>` (beside `contact=off`,
`inertia_<kind>=`) and passes them as those two options. `tools/measure_jerk.gd` accepts the same two plus
`out=<path>`, passes the knobs through `configure`, and writes to `out` when given (default path unchanged).

## The sweep

Six variants, each run through BOTH instruments on the realism seeds (the census and the realism test already drive
94301, 51227, 77003, 3 rounds, f01_m_box_welter v f09_m_bare_welter):

| name | push_attack_s | push_release_s |
|---|---|---|
| V0 | 0.0 | 0.0 |
| V1 | 0.0 | 0.05 |
| V2 | 0.0 | 0.10 |
| V3 | 0.0 | 0.20 |
| V4 | 0.03 | 0.10 |
| V5 | 0.06 | 0.10 |

Census: `python C:/Users/user/AppData/Local/Temp/FightCamp-tools/godot_run.py C:/Users/user/AppData/Local/Temp/FightCamp-U80 tools/measure_jerk.gd --timeout 900 -- push_attack=0.0 push_release=0.10 out=user://u100_V2.json`
(~40 s). **Always pass `out=`** - the default path is U99's committed record and must not change. Realism:
`python C:/Users/user/AppData/Local/Temp/FightCamp-tools/godot_run.py C:/Users/user/AppData/Local/Temp/FightCamp-U80 tests/fight_stage_realism_test.gd --timeout 1500 -- push_attack=0.0 push_release=0.10`
(a few minutes; it exits red by design - read its `RULE`, `R7-SEED` and `measured:` lines, not its exit code).

`U100_push_ease.json`: `{"population": {"seeds": [94301, 51227, 77003], "rounds": 3, "fighters": "f01_m_box_welter v f09_m_bare_welter", "defaults": "production except push_attack_s / push_release_s"},
"variants": [{"name": "V0", "push_attack_s": 0.0, "push_release_s": 0.0,
"census": {"frames": {"94301": n, ...}, "by_point": {point: {"p50", "p95", "p99", "max"}} for all 7 points, "contact_push_share_of_top1pct": x},
"realism": {"R7_violating_frames": {"94301": n, "51227": n, "77003": n}, "R8_reached": n, "R8_landed": n, "R4_pass": n, "R4_exits": n, "R3_mean_mps": x, "verdicts": {"R1": "PASS|FAIL", ... every RULE line}}}, ... V5],
"recommended": "<name>"}` - every number copied from the instruments' own output.

**The recommendation rule:** the variant with the lowest `LeftHand p95 + RightHand p95` among those whose R7 total
violating frames (three seeds) is at most 1.10 x V0's, whose R4 verdict is PASS, and whose R3 mean is at most V0's +
0.005 m/s. `U100_PUSH_EASE.md` opens with `## DECISIONS`: one table row per variant (hands p95 and p99, contact_push
share, R7 total, R4 pass/exits, R3 mean), then the recommended variant and the one number that decided it.

## Commit and send

`git status -s` first. Commit ONLY the five owned files with the paths on the commit line; `git show --stat HEAD` (exactly
those files); `git push -u origin cursor/u100-push-ease`; `python Tools/agent_comms.py send --from cursor --to claude
--topic U100-ready --body <hash>`. Do not edit HANDOFF.md, AgentComms/roadmap.json or any other file. Never `git stash`,
`reset`, `checkout .`, `clean`, `rebase` or `merge`.

## The trap

An eased push that is never carried from one frame to the next changes nothing: if the state is a local, or is rebuilt
inside `_solve_contacts`, V1-V5 print V0's numbers. The check fails any variant whose hand p95 equals V0's, and pins V0
to Claude's own run on `3fedec4` (census hands; R7 per seed 1700 / 1704 / 1357; R4 1008 of 1070; R8 122 of 551) - so a
V0 that is not today's room fails too.
