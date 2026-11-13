# S452 handover (written 2026-11-13 at the end of S451; S450's handover is in git history)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S452`.

## USAGE RULES (kept)
- Run `get_usage` first. Hand over at 300k context (S451 handed over at ~290k).
- At most TWO helper sessions.

## FIRST: the Miro connector
The Miro connector's connection broke in S451 ("connection invalidated"). He reconnects it from the connector settings. Then redraw P0 once:
- `python ops/Tools/where_we_are.py svg > E:/FightCamp/tmp/wwa.svg`
- then one `canvas_update_from_svg` with that file (recipe: the where_we_are_svg.py docstring).

The S451 cards are already in roadmap.json `plan.map`.

## RUNNING (collect first)
- **Qwen POWER1C** (wt/LEAN_POWER1C, ops/research/TASK_POWER1C.md): the lead uppercut's tail.
  - Qwen committed b315f3a1 ("shorter back time, guard takes over after TAIL_S"); seat_dispatch was still running its gate at the S451 hand-over.
  - Collect by diff, then run tests/uppercut_tail_test.gd plus the beat_clips and punch tests the diff touches.
  - Then film the seed 4242 bout on 3+ seeds (tools/hit_frame_film.gd, the game camera) and open the stills. The bars: the glove never over her own head; the elbow under the shoulder; back to guard by 0.40 s.
  - Then the review board (his C353/C354/C359: "terrible hands").
- **Grok Dev BLOCKLOOK4** (TASK_BLOCKLOOK4.md): the go was sent at 14:55 S451, after OFFICE1 was collected. ETA about 21:00. Collect by diff, then render the reel.
- **Critics**:
  - SQ62 (John on fight week v4): still out at hand-over. Read it for defects only; v5 replaces v4.
  - SQ61/SQ63 (Kalli/John on COACHFIT1 v1): queued.
  - Both 7+ -> fix the named defects -> his board with --attach. Below 7 -> the next version.
- **Fight week v5 critics**: SQ64 (Kalli) and SQ65 (John) are queued with ops/research/AMATEURWEEK_CRITIC_S451_BRIEF.md. It is built from:
  - the brief = CRITIC_PACK + CRITIC_ACCESS + the S450 job text + ops/research/AMATEURWEEK1_MAP_V5_S451.md
  - name: AMATEURWEEK_CRITIC_S451_BRIEF.md

## DONE IN S451
- OFFICE1 collected (d7bf6148):
  - the office pin opens a full-screen computer desktop: needs, the next four weeks, mail, fighters, money ahead, staff
  - gym_hub_test follows the new route
  - layout_snapshot shoots 26b_office
  - the real screen is on the review board
- Kalli SQ60 on fight week v4: Depth 5, Play 6. v5 written: ops/research/AMATEURWEEK1_MAP_V5_S451.md.
  - Code checks: ops/research/AMATEURWEEK1_V5_CHECKS_S451.md. TAPER runs for amateur bouts; there are two stoppage rests; there are no savings.
- FIGHTWEEKPROBE3, a season measure (docs/FIGHTWEEKPROBE3_RESULT.md):
  - tools/career_harness.gd gains `week=rest|tick|through|coach` and `policies=`
  - the model is tools/harness_fightweek.gd; the summary is tools/fightweek_season_sum.py
- PROGPROBE1R2 collected (6af1b609):
  - control + cadence valid. The coach's default week crosses a line in 12-13 % of weeks; rotating the pad cards gives 74 %.
  - steps and the hold sweep are VOID: step_in flat at 37 in its own trace; identical fighters
  - round 3 queued for the next free Goose day
- Critic pack: S451 facts added (FireLevel on, height/reach, two stoppage rests, the office desktop).

## NEXT (after the collects)
1. **STEPMASTERY1** (Claude; PROGRESSION_MAP_S448 M5): steps and defences get mastery.
   - Step in/out start at max(30, 0.55 x Footwork).
   - Shadow mornings drill 0.85 an hour.
   - The fire share follows FireLevel.
   - The FOOTWORK1 bound: a novice with no Step back loses 1.5-5 in 100 to pressure.
   - Build from the PROGPROBE1R2 control rows; the probe's step numbers are void.
2. **PROGPROBE1R3** to Goose: steps that move, four DIFFERENT fighters, one reaching 85.
3. **The coach's default pad cards** train only 2 of 6 punches (12 % of weeks cross a line). Read the default in SLOTS1/PadWeek, then decide whether the default rotates the cards.
4. **SPECIALTY1** (Qwen, the hold rule) after STEPMASTERY1.

## WAITING ON HIM (board)
- His look: the office desktop (new), the block reel round 3, camp v3, the result tabs.
- His ear: the voices, the PA mix.
- Reconnect Miro.

## TRAPS (S451)
- rule_guard sends every Godot job through `python ops/Tools/godot_slot.py run --who <session> -- <cmd>`, hidden_desktop.py included.
- A bare `scripts/state/Training*.gd`-style glob with no match HANGS a grep (twice in S451): use the Grep tool.
- live_runs_archive.json `runs` is a LIST, live_runs.json `runs` a DICT.
- Goose PRs can fail to open: collect from the pushed branch by diff, then close the issue.
- The idle guard counts Qwen idle while seat_dispatch runs Qwen's gate test (no qwen CLI process): Qwen is not idle then.
