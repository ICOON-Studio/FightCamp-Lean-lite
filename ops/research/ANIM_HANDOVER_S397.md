# Animation seats - handover from the S397 anim-chain session (2026-11-07 ~19:30)

The next session owns the animation seats: collect what lands, judge on film (fresh BLIND critic, sub-agent model **sonnet**,
eyes on the video, neutral names, control = main), merge only what is better with nothing worse, keep Cursor and Qwen busy.
Token rule (operator via S398, plan at 49%): seats build, Claude judges; check in on events, never on a timer.

## In flight
| Seat | Task | State | What to do when it lands |
|---|---|---|---|
| Cursor (Composer 2.5; next launch = GPT-5.6 Sol) | SOUTHPAW1 - southpaw knock-kneed in guard (OPERATOR SAW IT, priority) | running since 19:16, branch cursor/southpaw1, wt E:/FightCamp/wt/LEAN_SOUTHPAW1 | Read the test for loosened bars (S397: seats filter samples out of their own bars). Run tests/southpaw_legs_test.gd yourself. Film: fight3d_film short, branch vs main, blind critic on the stance. Before film judged 5/10 "the guard stance undermines it ... blue most clear". |
| Qwen | HITSELL5 - find where a landed punch's head reaction is lost in PLAYED rounds (tools/head_react_probe.gd), fix there | queued; launches when the watchdog leaves RED (memory) | Main must FAIL its probe bars; read the "RESULT: lost at" line; film + critic. |
| me (renders) | Inside-work retest: S393 branch claude/insidework1 rebased onto main in E:/FightCamp/wt/LEAN_INSIDEWORK (uncommitted: InsideWork.gd + ExchangeBeats 3 lines + its test) | both films RENDERED (19:31 / 19:36, rc 0): E:/FightCamp/tmp/iwfilm/arm_w.avi (inside work) and arm_c.avi (`nowork` control) - ready for the blind critic | Blind critic (sonnet) on up-close action. If better by >= 1: commit the 3 files to a branch, run inside_beats/inside_exits/fight_polish + inside_work_test, merge. |

## Decided this session (all closed with reasons on the PRs)
- FIGHTWALK1 #66, FIGHTWALK2 #70, FIGHTWALK3 #73: NOT merged. Critics: main 4.5 vs 4; 4.5 vs 5 (new faults); 5.5 vs 3. STRUCTURAL:
  every rewrite of the corner cue plan broke staging + camera together. Next corner round = ONE change per film (e.g. only the coach's
  hands on her gloves), CornerShots in the same brief. Checklist: ops/research/FIGHTWALK2_FILMS_S397.md. Main's corner is the base.
- HITSELL2 #69, HITSELL3, HITSELL4 #72: NOT merged - HitSnap tuned on a bare body never reaches the screen (films ~95% identical).
- INSIDE2 (Goose) / INSIDE3 #71 (Arena) / INSIDE4 (Qwen): the S393 face-in-torso fault is GONE from live play (7 frames, 0 spells in
  3 rounds). tools/head_torso_probe.gd merged (d0e95c2e); _clear_torso not merged.
- CORNERCAM1 (Goose, branch goose/issue-68): not merged - its test reads hand-placed positions; judge on film on top of whichever corner wins.
- tools/corner_film.gd `short` (1521c7db, 198a6293): round 1 skipped, one corner minute, real speed (~1:36). fight3d_film `short`
  fast-forwards ~0:30-0:44 of round 1 - tell critics it is the tool.
- Cursor's shell: fixed by the main session (hooks hidden in Cursor worktrees, bf1a15a0). Grok: operator "Leave Grok off".
- ring_feet_test red on main CI only: deterministic on the PC (226 frames left even at --fixed-fps 5) - CI environment, not the walk.

## Rules learned
- Every seat brief: a LIVE guard bar that must pass on main (S397: four tests passed on zero samples) + "start every Godot run
  through godot_slot.py" + "do not loosen a bar".
- My own Godot jobs: `python E:/FightCamp/Lean/ops/Tools/godot_slot.py run --who anim -- ...` (rule_guard enforces it).
- seat_dispatch films/judges now run through the queue and judge in the background (f006eddd, 9a0318e7).
