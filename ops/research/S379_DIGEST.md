# S379 digest (2026-11-04, Claude)

## Shipped to main
- Fight Camp picture cards (482032fe): five camp cards with the boxer's training-station art, the real fight-night forecast
  (scripts/state/CampForecast.gd replays Sim days), protocol row, one summary line. Operator approved the mockup.
- Hit-pop body callouts (d488ab86): HEAD/LIVER/RIBS close-ups hidden until a landed punch pops only the struck one (outline,
  condition line, 2.5 s hold, fade); hover shows the same card.
- Grappling theatre (2d1cd429 + 8cfe2ac6 captions): 8 GrappleMap chains straight from the data, documentary director
  (captions, timeline, shots <= 10 deg/s), free orbit, jump=theatre / Theatre button in the browser.
- 50/50 piggyback fixed (d5173e6e): GrapplePose kept rolls continuous (trunk slerp crossed 180 deg; arms/hands/feet flipped)
  + GrappleGraph.steady() lays back GrappleMap keyframes stored with the pair swapped (8 in the DB). Worst trunk/head step
  0.203 -> 0.026 m; verified by a second agent and Claude's eyes.
- Films keep 16:9 (726da2ef): the hidden desktop's 1920x1009 window cut ~65 px off each side of every fight film.
- Board: Grappling page + verified-only Boxer page (ce446b20; 0 of 153 boxer clips verified), PC live page (8efff752 +
  011b5912: Task-Manager tiles, watchdog verdict, what is using the PC, jobs, page file, biggest folders, heat),
  preview cameras drift <= 10 deg/s and follow the pair (b535f4eb, 3a53151a).
- Seat dispatch: BJJ films judged on a BJJ prompt (--kind bjj), judge score = FIRST N/10 after "score" (2b327aed; FIGHT9R9
  had read 9/10 from "nowhere near a 9/10" - real 4/10), eyes sheets of the scored film in <wt>/_eyes for agy (6e35ab48).
- Cloud-light (S380 commits by the workflow, verified): fight-stills renders off GitHub (probes only, ~12 min/PR), Goose
  dispatches stills only on fight-code changes, ci skips ops/docs pushes, .godot import cache; ~7,100 -> ~2,000 Actions
  min/week (month was heading for the $50 hard stop ~Nov 25). Sparse seat worktrees (0.23 GB), retire after 2 h.
- Disk: 21 finished worktrees retired (E: 23 -> 40 GB free); worktree_retire ignores .import/.uid churn.
- GrappleFlows community moves as facts (GRAPPLEFLOWS_MOVES_S379.md: 438 no-gi moves, 357 chains, 6 plans proposed).

## Branches (not main)
- claude/fight9base = FIGHT9 round 7 (Argon 6/10, knee tremble 12.0 -> 3.46) + main. FIGHT9R9 = 4/10 (dropped).
- claude/bjj9base (967a79bd + dde5a5f8): belt match plays GrappleMap STRAIGHT (Ziva's idle/route/push-out/finish layers
  off unless `-- with<layer>`), GrappleMap player source in ops/research/grapplemap_player. Needs main's d5173e6e merged.
- claude/locowalk3 (3c7e8c76): walk_back_guard only, WALK_SPEED 1.0 - foot holds but 0.40 m/s, 1.8 m short of the corner.
- claude/tvcam: TV broadcast camera workflow (wf tv-broadcast-camera) was RUNNING at hand-over - check its result.

## Operator rules earned (memory)
Eyes on every animation, mine and other seats' (and pressing contact like a leg under the armpit is normal); picture cards
over text menus; BJJ moved Ziva -> Argon; agy may read eel.is / github / docs.godotengine.org; camera never zooms while it
turns, TV angles, <= 10 deg/s; clips start with each boxer in his corner, walk to centre, fight (TODO).

## Open / next
1. agy launches from the scheduled reconcile fail with agy.exe "exists False" for 10 min (FIGHT9R8 20:51, BJJ9R11 05:16)
   while session-shell launches work - fix seat_dispatch (find agy via shutil.which / the shim at call time, and on a
   FileNotFoundError requeue instead of failing the run).
2. claude/tvcam -> verify frames -> fight9base; then films start in the corners (judge_film / knockdown_film: skip the
   ring walk-in, each boxer in his corner, walk to centre, fight); then release FIGHT9R10 (held in dispatch_queue).
3. Merge main (d5173e6e pose fix) into claude/bjj9base, relaunch BJJ as BJJ9R12 on agy (brief TASK_BJJ9R11 -> R12).
4. Camp: Hard vs Standard barely moves the stat; load_setting never read by the sim (no fatigue change) - fix; men need
   station pictures (tools/bake_session_pics.gd); theatre card fifty_fifty.png shows the old swapped ending.
5. LOCOWALK4 (cursor) brief written, BASE claude/locowalk3 pushed - queue it.
6. Export update 75 (camp cards, callouts, theatre) for the operator to play.
7. E: 9% free; C: 3.3% free; the operator considers a 1-2 TB NVMe (MSI PRO B650-S WIFI has a free M.2 slot).
