# TASK C204 - CODEX - A FIGHTER STANDING HIS GROUND STILL LOOKS ALIVE (stance layer)
Model: gpt-6-astra, medium (`CODEX_MODEL=gpt-6-astra`), CODEX_WEB=live. Owner: codex. Assigned S77, 2026-09-25.
3D-animation lane. QUEUED behind C203: it starts when C203 lands (two-agent cap).

## Why
Operator, 2026-09-25, verbatim: "they need side stepping faking and all this things while their body doesnt move
much the posture is changing thinking about their next burst/move etc". Qwen's Q176 cuts the travel; when a man
holds his ground he must not freeze - the POSTURE carries the life.

## What would a human do?
An animator on a fight game (EA UFC, Undisputed) builds an idle/guard SET, not one loop: weight shifts from foot to
foot, head movement off the centre line, shoulder and hand feints, a level change, a small pivot, breathing that
deepens with fatigue - layered and chosen by the fighter's state, never a metronome. Read `G86_FEINTS.md`,
`J29_STANCE_AND_FOOTWORK_DEMOS.md`, `M18_THE_FOOTWORK.md` and `G100_TIME_MOTION.md` (when landed) via root
RESEARCH_INDEX.md.

## Do
1. Census what the stance currently plays per discipline (clip names, loop length, any variation) - print it.
2. An upper-body additive layer over the stance, behind option `alive_stance` (default OFF; OFF byte-identical):
   weight shift, head movement, shoulder/hand feint, level change, breathing scaled by stamina. SELECTED, not looped:
   a new variation no sooner than ~1.5-3 s (PROXY until G100), never the same one twice running. Feet planted (the
   existing foot lock) - the hips may sway, the roots do not travel.
3. Two MP4s, same seed, OFF vs ON, recorded with `Godot/tools/s77_camera_probe.gd -- shot=broadcast opt.alive_stance=true`
   through `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 <godot args>`; md5 both.

## Owned files
`Godot/scripts/FightStagePlayer.gd` (~4,500 lines - NEVER open whole; grep `stance\|_layer_lower\|foot_lock` and
read windows), new `Godot/scripts/FightAliveStance.gd`, new test `Godot/tests/fight_alive_stance_test.gd`,
`research/C204_DIGEST.md`. `FightWorldLiveScreen.gd` only to wire the option (windows only).

## Gate (tier: script edited)
Parse gate first, then `python Godot/tools/run_tests.py --only fight_stage,fight_body_layers,fight_room_,contact_`.
Prove the test with a mutant. Commit explicit paths, push `codex/c204-alive-stance`, then
`python Tools/agent_comms.py send --from codex --to claude --topic C204 --body "<census, what ON adds, md5s, tests>"`.
Do NOT read HANDOFF.md, CURRENT_STATUS.md or HANDOFF_ARCHIVE.md.

## The one trap
Sway that moves the HANDS reintroduces the flicker S77 just fixed (`FightStagePlayer.settle_hand_offsets`). Measure
hand reversals with `s77_camera_probe.gd` (`hand_buzz` line) OFF vs ON; ON must not be worse.
