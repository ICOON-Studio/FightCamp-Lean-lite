# S424 handover: MECHANICS FIRST, maps on the board (written 2026-11-10 at the end of S423)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S424` and redraw the map (recipe: ops/Tools/where_we_are_svg.py docstring; the frame refuses to shrink - harmless; after a redraw run `learn` / `trim` as the svg command prints).
Older handovers are in git (this file's history); S396 to S417 in ops/research/HANDOVERS_S349_S417.md.

## What S423 did
- Main CI was red since LOOKSLATE7 (menus_round4 wanted BtnSolid; the Overview's primary is now the wood Go piece): fixed.
- FIGHTDISPLAY1 (corner bar, NOW!, scorebug from the veteran's drawing, his Q-174 pick, GRADED calls) LAUNCHED on Cursor;
  FIGHTDISPLAY2 (side panels + EnergyForecast) queued after it, then TRAININGB1.
- R28 Cutman: design map v2 on the board (Q-175) after two critics (ops/research/R28_CUTMAN_DESIGN_MAP.md,
  docs/mockups/s423/cutman_10_coach.png = the design, critics' reviews beside it).
- R25: measured first (tools/adapt_probe.gd, tools/cover_probe.gd, hook `bout.covered` in LiveRound, empty = the game today).
  Only "she WAITS for your best plan line" bites (-6.5 points), and NO counterplay won it back (swap to another answer,
  drilled or not: 34.5%). Map: ops/research/R25_ADAPTS_DESIGN_MAP.md, NOT asked: find the way back first (brief a Qwen
  probe on tools/cover_probe.gd: why a fresh right answer is worth less than the waited line; feint first, film study).
- Dues: design map on the board (Q-176), ops/research/DUES_DESIGN_MAP_S423.md + docs/mockups/s423/dues_choice.png.
- LEGTREMBLE3 HELD, not collected: its 149 smoothed clips pass leg_tremble/beat_clips/move_tip on main, but head_aim_test
  goes red with them (1-2 failures a run, 0 twice on main's clips). Branch cursor/legtremble3 (5af23d18) pushed. Find
  which head_aim check breaks (diff its AIM/JOIN lines with and without the clips), fix, then collect + film.
- FIGHTSLIDE3 landed in Qwen's worktree (runner was still checking at S423's end): no single slide cause, SideStep 13% the
  biggest, Footwork and PushOff negative; collect tools/fight_slide_probe.gd + the result doc.
- His four board marks (Q-171/172 pictures): no explaining words, tooltips with coloured numbers, both designs look AI-made;
  hiring moves to its own page and the staff wall's space goes to club info; staff cards a bit more info. Answered in chat;
  they apply when those menus come back (At a glance, staff screen with R55).

## Order for S424
1. Read the board: Q-175 (R28), Q-176 (dues). On a yes, brief the pure module first (Qwen/Goose), then the screen (Cursor).
2. Collect what lands: FIGHTDISPLAY1 (Cursor: render the live round, LOOK at it, his drawing is the bar), KDFIX3 (Qwen,
   brings PR 162's ruler; close PR 162 when it merges), then FIGHTDISPLAY2.
3. LEGTREMBLE3: the head_aim break first (above), then `python ops/Tools/seat_dispatch.py films LEGTREMBLE3 --branch
   cursor/legtremble3`, LOOK at the legs in round 2 before telling him it is fixed.
4. Next mechanic maps: R37 ask for a fight (a refusal says why, reshapes Fights), R55 two fighters one coach (brings the
   staff screen, his Q-172 notes), R58 a fighter leaves. Each: measure if it touches the fight, map + picture, two critics, board.

## Traps
- A design map a critic breaks in one read wastes his approval: run the critics BEFORE the board question.
- seat_dispatch reads OWNS as one line of paths; notes go in parentheses on the next line.
- The idle guard reads a seat idle when its CLI exited while the runner still checks: look for the runner pid first.
- questions.json is 2-space JSON, roadmap.json 1-space: keep the indent or the diff is the whole file.

SETTINGS: S423 ran on Opus 5.5. Weekly plan use was 88% at S423's end (resets 11-12): propose Sonnet, high effort, Fast off, until the reset.
