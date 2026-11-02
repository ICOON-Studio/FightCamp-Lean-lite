# S200 DIGEST (2026-10-11) - Ludo saw the floor; the floor audit; three merges

## What now works / landed
- GYMART1A merged 54d633b1 (Cursor): gym_look2 building shell - thick walls + cap beams, floor materials, cove, trusses + lamps,
  street outside. Owned-file diff only (its HANDOFF.md edit dropped). gym_look2 stays OFF; shell 112/0, look2_props, hall_3d,
  club_3d, ludo_camera green on master. Game-camera stills with gym_look2 ON still owed (the render attempt hit AMBER, not run).
- FILMIDLE1A + BAGSWING1A merged b9718fef (Arena PRs #111/#112 closed): pure FilmIdle (80/0) and BagSwing pendulum (45/0).
- Ops board: "Running now" cards carry ON THIS PC / CLOUD (operator: "i want to see which runs are local"); working_now cards show
  their real agent (they always said "claude"); the chat link reads live_runs `url`.
- Arena RUNNING: FACILITYDIR1A (chat 01a12ade-0e36, branch arena/674dae5c-fightcamp) and CAMPSLOTS1A (chat 01a12ade-ecec, branch
  arena/3a337085-fightcamp) - pure modules, briefs TASK_FACILITYDIR1A.md / TASK_CAMPSLOTS1A.md.

## Ludo round 35 (LUDOFLOOR1 done)
- LUDO_ROUND35_S200.txt: part 1 27,889 chars (Ludo stopped mid-table), part 2 28,876 after "continue" + the operator's ask to place
  every UI item. Verdict LUDO_ROUND35_VERDICT_S200.md: V1 hall zones (adopt for the hall, keep our rooms at z 18-22.5), V2 camera
  option (b) offset, V3 UI placement (14 items adopted, HVAC/heatmaps/sparring overlay parked), V4 look (minus grime/chipped paint),
  V5 generation order. Ludo's overview is camera-only; it claimed the ring is mid-floor - it is already back-centre in our data.
- Preview images (operator asks): 1 = Ludo's own gym, no UI (good art reference); 2 = drawer only (weak); 3 = OUR gym with zones
  moved + UI (operator: "base it on the current design") - loose (bags on the west wall, small drawer box). Operator: "if you give
  such trash reference it will generate trash" - the in-game still full of filler was a bad reference.
- Code ask (operator: "produce the whole code for it"): LUDO_ROUND35_S200_code.txt, 18,112 chars - places JSON does not parse,
  FILE 4/5 truncated, zones repeat the packing junk because I passed it our quota rules. Reference only.

## The floor audit (operator: "scan all zones ... what items have no place in the gym")
GYM_ZONE_AUDIT_S200.md (+ .txt): ROOT CAUSE = the capacity packer fills zones to pass quotas (>= 45% fill, >= 6 bags, east = west),
so it dumped 6 first-aid cabinets (stretch strip is 1.4 m deep under the ring clearance), 7 speed bags (3 behind heavy bags), a
heavy bag in strength_east, freestanding bags mid-floor on top of the pads/mirror stations, plyo step boxes as a "water bench"
and as weights dressing, a mitts locker as a "glove rack", and 7 phantom bikes (cardio_floor = "jump ropes + floor markings" drawn
as a bike). Recommendation on the board (Q-S199-2): author the layout by hand from real-gym rules (G121), turn the quota tests into
rule checks, Ludo reviews, operator approves.
Tried and reverted: removing the stretch floor zone (club_zones_test needs a stretch patch under the station); swapping the
cabinets for recovery items (2-3 m footprints do not fit the 1.4 m strip) - both belong to the authored layout.

## Board questions waiting
- Q-S199-1: overview camera with the drawer open - (b) shift the hall left (Ludo) vs (a) full width. Stills s200_drawer/*.
- Q-S199-2: author the floor by hand from real-gym rules (Claude's recommendation) vs Ludo designs it all.
Operator asked: "i want the assets to be animated when used" -> EQUIPANIM1 queued (bags first via BAGHIT1; machines after models).

## Held
- Codex BAGRIG1 (35203f62): gate MERGEABLE but club_fill RED on the branch (3 floor bags deleted). Send-back started and STOPPED
  (operator: "wait on codex first read ludos review"). It now waits for Q-S199-2: the authored layout decides where every bag hangs.

## Mistakes recorded
- check_workflow on a no-worktree Arena branch ran a full Godot editor import on E: and took the PC to 88 C (RED): for a pure
  new-files PR use diff + parse + the one test on master; killed it, cleaned the temp extracts (8 GB).
- agent_window -ArgumentString needs `|` between paths (a space = "prompt file not found", the run dies silently).
- Overwrote TASK_CAMPFOCUS1A.md without checking it existed (CampFocus already merged) - restored from git.
- First Ludo preview asks used our filler-laden still as the reference; ask Ludo from data/rules, not from a junk picture.
- Rewrote roadmap.json with indent 1 (file is indent 2) - caught by the diff size, fixed.

## Evidence
master after merges: gym_look2_shell 112/0, gym_look2_props 677, gym_hall_3d 41, gym_club_3d 173, ludo_camera 26/0,
film_idle 80/0, bag_swing 45/0. Ops board /api/roadmap serves the new working_now; pills render (checked in the pane).
