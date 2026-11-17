# S505 handover (rewritten 2026-11-17 at the end of S504's after-ship work)

Start: `git pull && python ops/Tools/agent_comms.py start`, then this page. Roadmap `now.next_action` has the full detail.
Digest: `ops/research/S504_DIGEST.md` (its "After ship" section is the latest).

## Where the fight stands
- Fight motion week (deal: 5+ from BOTH blind critics or 3D leaves the first release). r10 (S503): coach 5, animator
  4.5. No new blind round since.
- Base film now: `E:/FightCamp/tmp/fightweek/s504o` (180 s, seed 7). Against s504g: head jumps 90 -> 80, cross step back
  11.5 -> 12.9 cm, reactions peak 4 frames (5 late).
- Built after ship: Scorecard tab (operator's yes, Q-265); body slide cap (RingPlace.travel_cap 1.8 m/s, `nonodecap`),
  PopCapPre before the reach (`noprecap`), PopCap world read (`skelpopcap`); a clean blow stops the hit man's step in
  (`nostopin`), the rock holds until his feet arrive (`rockout`).

## NEXT (in order)
1. Collect Qwen IDLEIN1 (PR 340, landed; tests green). It reads 0 idle spells on every film because MY brief said
   "phase == fight" and the film's `phase` column is the range (in / inside / pocket / clinch) or `rest`: at collect,
   change that filter to "phase != rest" (and its test fixture), then read idle time inside 1.0 m on s504o and make the
   inside phase act (punch, tie up or step out).
2. Cross step back 12.9 -> 15+: s504o frames 815, 3785, 5061 - the place goes back 12-32 cm but the shown hips only
   0-13 cm. Find what holds the hips (the reaction clip's own hips, BODY_KEEP, the travel cap).
3. Head jumps 80: on a jab frame the layers between PopCapPre and PopCap add 4-10 cm of trunk; find which (ArmHome,
   PunchReach, HitSnap's inside sway, GloveClear). Reactions (~30) stay free by design (a 3.6 m/s cap cost timing).
4. Film r11 (`--write-movie`, 1920x1080, sheets as in S503), rulers, two NEW blind critics (briefs in
   E:/FightCamp/tmp/fightweek/r10blind, sed the folder).
5. Re-send Ziva COACHNECK2 (never started).

## Waiting on the operator
- He wrote "goose could not install godot" (S504, end). Checked: every Goose Actions run since 11-14 got Godot 4.7.2
  (cache hit or the download step; the release URL answers 200, the cache is current); the one failed run (STYLE2,
  11-15) timed out on its own probe after 100 min; no Goose is installed on this PC. Ask him where he saw it (which
  issue / run / app) before changing goose.yml.

## Debt
uppercut_tail_test red before and after S504. block_absorb, hit_carry, join_return, punch_speed, punch_weight red
since S496-S501. PunchEnd's hand-from-hips in ring axes reads a turned guard as out (a chest bone in the film log would
fix it).

## PC / tools
- Every Bash call starts with `cd /e/FightCamp/Lean`; never `cd` into a worktree in a plain call.
- hidden_desktop drops Godot's stdout unless `--log=<file>` is given (S504 lost a debug round to it).
