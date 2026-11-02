# TASK_U197 - footwork beats reach the room (Cursor, S123)

Model: Cursor Composer, medium. Milestone B (PLAYABLE WITH A BOXER): advances "boxing is watchable" - the feet must visibly work between punches.

## Why
S122 made movement-only techniques (boxing_step_in_out, circle_lead/rear, angle_step, pivot_footwork, switch_stance, rhythm_change,
drawing) engine events of type `footwork` (FightRealtime.gd:5125, behind switch `footwork_no_contact`, ON in the game). The room's beat
loop drops every type it does not name: `FightWorldLiveScreen.gd:1741` keeps only `"action"` (and `grapple` above it). So IN THE GAME
CONFIG no footwork beat has ever reached `FightStagePlayer._is_footwork` / `_footwork_clip` (FightStagePlayer.gd:2115-2135) - the path
that existed for them while they were still typed "action". The engine moves the bodies; the room shows nothing of the step.

## What would a human do?
A fight-game animator drives footwork from the same event stream as punches: a step event plays the step on the legs (lower body, or the
whole body when the arms are free) timed to the engine's travel, and never plays a hit. UFC/Fight Night do this with locomotion layers fed
by the move system, not by a separate walk guesser.

## Prior research
- research/S122_DIGEST.md, section "FOOTWORK WAS LANDING AS PUNCHES" (the switch, the type, the census).
- research/U196_DIGEST.md Part 2 (the C215 shuffle latch and `walk_at` busy rule - do not regress S4-3-4 slide 0).
- research/S15_PRESENTATION_SPLIT.md (exact / substitute / degrade - footwork is exact-or-nothing, never a punch clip).
- searched: footwork step_in_out room beat (python Tools/prior_research.py); topic page research/topics/footwork.md.

## Prefab check
None: this routes our own engine's event type into our own room. No asset or plugin involved.

## Build
1. In the room's beat loop (FightWorldLiveScreen.gd ~:1731-1745), route `type == "footwork"` beats to the SAME footwork presentation the
   stage player already has (`_is_footwork` / `_footwork_clip` / the C215 shuffle), as the action path did for movement beats before S122.
   A footwork beat must NEVER be scheduled as a landing, a contact, a reaction or a hit-stop (footwork_not_a_blow_test guards the engine;
   add the room-side assert).
2. Switch discipline: `footwork_no_contact` OFF must stay byte-identical (those beats are still "action" there).
3. Do not touch FightRealtime.gd, FightClipBinding.gd or any clip - binding one gated clip per footwork move is Claude's C223 work; with
   today's bindings (`"pair": "idle"`) the visible effect is the C215 shuffle under engine travel, and that is the acceptance.

## Gate
- New test `tests/footwork_beats_reach_room_test.gd`: game config (footwork_no_contact ON), boxing, one seed: count footwork beats the
  engine emitted vs footwork beats the room presented (must be > 0 and equal, or name the ones refused and why); zero of them landed,
  reacted or hit-stopped. Prove it with a MUTANT: re-drop the type in the filter -> the test fails. Name the population (both fighters'
  style/stats) in the test output - never two identical fighters.
- fight_body_layers_live S4-3-4 layered slide stays 0 (master 7453f017 once merged; 124 before Part 2).

## Tests (tier: script edited)
Parse gate on touched files; the new test; then
`python Godot/tools/run_tests.py --only footwork,fight_body_layers_live,fight_body_overlap,fight_contact_stop,fight_strike_whole,smoke,boxing_output`.
Each no worse than master (fight_body_overlap has a known 1.3 mm head>arm residual). Never the full suite.

## Owned files
- Godot/scripts/FightWorldLiveScreen.gd (5,333 lines - never open whole; grep -n then sed -n windows around :1725-1760)
- Godot/scripts/FightStagePlayer.gd (4,910 lines - only the footwork path near :2115-2135 and walk_at near :1370)
- Godot/tests/footwork_beats_reach_room_test.gd (new)
- research/U197_DIGEST.md (new)

## Deliver
Branch cursor/u197-footwork-beats (never master), commit per fix, push, write U197_DIGEST.md (before/after counts, the mutant),
`python Tools/agent_comms.py send --from cursor --to claude --topic U197 "<one line>"`.
Trap: the room test harness runs with demo switches unless told otherwise - set footwork_no_contact ON explicitly and print it.
