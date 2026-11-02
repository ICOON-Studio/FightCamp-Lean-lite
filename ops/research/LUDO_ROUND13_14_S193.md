# LUDO ROUNDS 13 + 14 (S193, 2026-10-10) - the three offers after round 12, then GRAPPLING animation

Operator S193 (verbatim): "continue with ludo ask it also to solve the grappling animation (how to make a realistic humanlike bjj
fight , takedowns and everything that is related to animations needs to be solved by ludo nad passed on to codex if it is possible"
(with a screenshot of Ludo's three follow-up offers after round 12).

Asked as TEXT only (no images sent), in Ludo's project chat (Ask Ludo, project FightCamp).

## Round 13 - question (sent verbatim)

Follow-up on your FightCamp animation overhaul spec (the 9 steps, the 30 s Vance-vs-Miller benchmark, the F3 debug overlay). Please give
all three things you offered, in one answer:
1) Godot 4 pseudocode (GDScript 4.x style, typed) for each of the 9 steps, plus a file-by-file Codex task list: for every file
(FightStagePlayer.gd, FightAliveStance.gd, record_room.gd, Tools/smooth_metrics.py, a NEW FightDebugOverlay.gd mounted by one line from
FightWorldLiveScreen.gd, and a NEW forced-action hook that feeds a scripted action queue to the 20 Hz sim) list the functions to add,
their signatures, and the order Codex should build them so each step lands behind its own on/off switch and can be tested alone.
2) The exact CSV schema record_room.gd writes per frame (column name, unit, type) and the exact Python metric functions
smooth_metrics.py runs to grade the 30 s benchmark automatically: one function per pass/fail threshold from your checklist, how it
segments the timeline windows (00.0-02.5 s etc.), and the final report format (per-step PASS/FAIL + the measured number beside the
threshold).
3) The visual debug-overlay mockup showing COM, foot locks, reaction weights, punch phases and transition states. Constraint: the
top-left/top-right corners belong to the game's fighter HUD cards, so the overlay text panels sit below them.

## Round 14 - question (sent verbatim)

New problem, same standard as the boxing overhaul: GRAPPLING. FightCamp's MMA update needs realistic, humanlike BJJ and wrestling on
screen: clinch entries, takedowns (double leg, single leg, body lock, trips, judo throws), the sprawl and stuffed shot, the landing,
guard / half guard / side control / mount / back control, sweeps, passes, scrambles, stand-ups, ground-and-pound and submissions
(armbar, triangle, rear-naked choke, guillotine, kimura) with the tap. Tell me how a small studio solves this in Godot 4, given what we
have and what we proved does NOT work:
- What we have: two skinned humanoid fighters (MPFB rig, different body sizes); a sim that already decides grappling as events +
  ground seats + durations (a position graph with guard/half/side/mount/back, transition edges, hold decay, submission attempts);
  16 paired attacker/victim clips (_Att/_Vic, mostly clinch/throws); a contact solver that solves capsule SURFACE gaps for both bodies
  together; typed grip anchors (3-4 named anchors per body region); 38 minutes of two-person 3D pose tracking from real fight footage
  (33 joints in metres, good for standing, too noisy on the ground); free CMU paired motion capture; Blender + Codex as the builders.
- What failed: AI text/video-to-motion gives ONE body (8 of 8) and composed two-body takedowns scored 0 of 36; no store sells paired
  ground grappling; authoring holds by script in Cascadeur did not hold a pose; retargeted paired clips lose contact (worst contact
  error 15-19% after fixes); the arms of an authored clinch did not arrive at the grip.
Please answer as a prioritized Codex implementation plan, same format as before:
1) The architecture: how two bodies stay in contact (leader/follower paired clips, shared root, contact IK, physics/active ragdoll,
motion matching, procedural) - which to use for which phase (standing clinch, shot, lift, fall, landing, ground holds, transitions,
submissions), and why.
2) Per step: touch points, the exact maths (springs, IK targets, contact constraints, weight/balance rules), numbers, and a hard
pass/fail threshold a script can measure (contact gap cm, penetration cm, foot slide, timing ms), plus non-regression guards.
3) What content we need per position and the cheapest way to get it (how many key poses per hold, what can be procedural, what must be
captured or hand-keyed in Blender, and how to use our 38 minutes of tracked footage and the 16 paired clips).
4) A 60-second grappling benchmark scene (two DIFFERENT fighters: a wrestler and a BJJ specialist) as a forced timeline that exercises
every system, like the boxing benchmark.
5) What makes grappling read as HUMAN to a viewer (weight, effort, grip fighting, breathing, the tap) and the debug overlay additions.
6) What Codex can build alone, and what needs a human animator or a capture session.

## Round 13 - first answer: an IMAGE only
Ludo answered the first send with one generated image (no text): `previews/ludo_s193/r13_overlay_mock.jpg` - Vance (red)
and Miller (blue) with portrait cards in the top corners, the telemetry panels BELOW them on both sides, a green support polygon under
Vance's feet, a magenta CoM sphere, cyan (planted) and orange (free) foot rings and a yellow flinch marker. Its panel text is image-model
gibberish ("Stite JIS", "Boot Lor") - the LAYOUT is the content, not the words. Re-asked parts 1 and 2 as TEXT ONLY (second send below).

## Round 13 - second send (verbatim)
Thanks for the overlay mockup image. Now please answer the other two parts in TEXT ONLY (no image): 1) [as above] 2) [as above].

## Round 13 - Ludo's text answer (verbatim; cut off by Ludo's own length limit inside test_step_2_locomotion)

