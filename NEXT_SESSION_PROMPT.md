# S503 handover (written 2026-11-16 at the end of S502)

Start: `git pull && python ops/Tools/agent_comms.py start`, then this page. Roadmap `now.next_action` has the full detail.
Digest: `ops/research/S502_DIGEST.md`.

## Where the fight stands
- Fight motion week (deal: 5+ from BOTH blind critics or 3D leaves the first release). r9 (S502, the new low camera,
  today's changes): coach 4.5, animator 5. r8 was 5 / 4.5. Not there yet.
- S502 built (commit 2bf82d3a0): idle inside spells step out to the jab's edge (RangeBreath `edge`, `-- noinsideedge`),
  exit after a burst 0.4 s; hit snaps sized per punch (`-- oldsnap`), hooks turn the head, a cross drives the trunk
  further and steps back 0.15 m, the snap rises over 2 frames. Rulers r7 -> r9c: idle close spells 5 -> 0, reaction
  peak 5 -> 4 frames, head travel 9.7 -> 12 cm.
- r9 critics (E:/FightCamp/tmp/fightweek/r9blind): BOTH put the feet first. Planted feet slide 10.6 / 11.7 m a round;
  `pro_idle` alone 5.5-5.8 m per boxer (rulers_raw.txt "slide by clip"). Second: the waiting (longest still guard 5.8 s).
  Then punches that finish above the head, hands home in 3-4 frames, the hurt man followed up, the body-shot fold rising
  in ~2 frames (want 8-12). Coach still wants crosses 15-20 cm and the range wider at rest.

## NEXT (in order)
1. LOCK THE PLANTED FEET IN THE IDLE. Read FootPlant.gd (STEP_M 0.10 lets the clip carry a planted foot 10 cm before it
   steps) and the rig's weight during pro_idle (shown.csv `rig_w` ~0.17) first. Measure with a log-only run:
   `python ops/Tools/godot_slot.py run --who S503 -- python tools/hidden_desktop.py run --timeout=600 <godot.exe> --path .
   --windowed --resolution 1280x720 --fixed-fps 30 --audio-driver Dummy --script res://tools/human_fight_film.gd --
   <out_dir> secs=75 seed=7`, then `python tools/human_fight_report.py <out_dir>/shown.csv` (target: under 1 m a round).
2. The waiting alive (bounce, pawing lead hand, feints, circling; by style), then punches ending on the target.
3. Film r10 with `--write-movie`, sheets with `tools/film_sheets.py ... --crop 1120:720:400:190` at ex1 13.6 (3 s),
   ex2 18.9 (2), ex3 33.5 (2), ex4 37.5 (2.5), ex5 59.9 (2.5), wait 44.0 (1), wait2 50.0 (1); rulers_motion + rulers_raw;
   copy the r9blind briefs to r10blind (sed the folder name); two NEW critics.

## Seats
- Qwen FILMBAR2 (round 2 of PR 333, conditional binomial test): launched 18:19, ETA ~20:10, wt LEAN_FILMBAR2. Collect by
  its contract (film_count_test green, film_pattern_test green, admires_her_work find kept).
- Ziva COACHNECK2: no branch yet (chat "Fight Film Analysis", 127.0.0.1:7012).
- Guard damage: Dola SQ205 depth 6 / general 7 (smooth leak curve, a parry, judges count blocked punches, recovery
  between exchanges). John SQ204 still out. Write v2 from both, then two fresh critics at 7+.

## Debt
block_absorb, hit_carry, join_return, punch_speed, punch_weight are red on main since the S496-S501 fight work (S502
checked a clean worktree). Green them or re-baseline them on the critics' numbers. file_limits: GamePlan.gd and
MatTree.gd at 501 lines (split or trim one line each).

## PC
The owner plays ArcheAge (5-10 GB): the PC went RED on memory twice; godot_slot holds Godot until it clears. Build
exported 19:05 with WHAT_TO_TRY current.
TRAP: every Bash call starts with `cd /e/FightCamp/Lean` (a `cd` elsewhere moves the session folder - it happened again).
