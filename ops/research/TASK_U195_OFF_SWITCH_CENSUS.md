# TASK U195 - CURSOR - THE OFF-SWITCH CENSUS: EVERY FINISHED SYSTEM ENDS ON OR DELETED (S114)
Owner: cursor. Model: Cursor default (Composer). Assigned 2026-09-27 (S114). Branch `cursor/u195-switch-census` from
`origin/master`, own worktree. Claude decides and merges. On the demo road (DAY 2-3, deadline 2026-10-04).

## Why
Ten finished systems sit behind switches that default OFF, and the census that decides each was never run - the player sees
none of them (S114 damage-control report). The demo ships with each one ON or deleted, never "built and forgotten".

## What would a human do?
A studio's feature-flag review before a milestone: for every flag, run the build both ways on the same content, compare the
numbers that matter against the targets, look at a recording, then flip it on or delete the code. No flag survives a milestone
undecided.

## Prior research
`research/topics/pace_calibration.md` (J20 D1-D6 anchors, CompuBox bands), `topics/ground.md` (GroundGraph, traps),
`topics/defence.md`, `topics/feints.md`, `topics/contact_collision.md` (contact_stop), `topics/hit_reactions.md`
(active_ragdoll, hit_physics), `topics/playback_blend.md`, `topics/footwork.md` (planted-foot gate, U185-U188),
`AgentComms/route_decisions.json` (C202, C217, U187 are carried by THIS task). Source studies: `C191_DIGEST.md`
(contact_stop), `C217_DIGEST.md` / `C218_DIGEST.md` (active_ragdoll), `U172_DIGEST.md` / `U173_DIGEST.md` (defence_model),
`C196_DIGEST.md` (feints), `Q169_DIGEST.md` (trap_arm), `S58_THE_GROUND_GRAPH_WIRED.md` (ground_arm), `C204_DIGEST.md` (alive_stance).

## Prefab check
None: this measures our own switches. Reuse the existing census tools (`q205_mma_state_time_census.gd`,
`q184_kb_finish_funnel.gd`, `c191_clip_census.gd`, Q198's audited planted-foot instrument) - do not write new instruments.

## The switches (names verified in code, S114)
Engine (`FightRealtime.gd` options): `ground_arm` (current|graph|decay|both), `trap_arm`, `defence_model`, `feint`.
Room (`FightWorldLiveScreen.gd`): `contact_stop`, `active_ragdoll`, `alive_stance`, `strikes_play_whole`, `camera_keep_pair`,
`reactions_play_whole`. (`hit_physics` is already decided OFF - C188; do not re-run it.)

## S115 UPDATE - READ FIRST: THE OPERATOR TURNED ALL TEN ON FOR THE DEMO (80ddd79a)
Operator 2026-09-27: *"turn them all on for the demo build"*. The game now runs every switch ON
(`FightRealtime.DEMO_SWITCHES`, `FightWorldLiveScreen.demo_switches_on()`); a `--script` run keeps them OFF, so your
tools still get OFF by default and must pass ON explicitly. Your census now answers a sharper question: **which switch
costs the finishes.** `tools/s115_demo_switches_probe.gd` (read it; reuse its populations) measured all four engine
switches together: boxing stoppages 4/30 -> 0/30, kickboxing KO+TKO 8 -> 3, MMA decisions 9 -> 14. So step 1 runs
ONE-SWITCH-ON arms as well as ALL-ON-MINUS-ONE arms, and the verdict names the switch (or pair) behind the drop, with the
finish rate beside the real-world anchor (J20 for MMA; the boxing/KB stoppage rates in `RESEARCH_INDEX.md`).
Verdict column is now ON-KEEP / ON-NEEDS-TUNE (name the constant) / OFF (only if it alone kills finishes).

## Build
1. Engine switches: for each, OFF vs ON over THREE DIFFERENT populations (never identical fighters; both legal for the
   ruleset), 40+ seeds each, boxing / kickboxing / MMA where the switch applies. Print achieved beside wanted for J20 D1-D5
   (MMA), CompuBox bands (boxing), leg share (KB), and name the population in the output.
2. Room switches: OFF vs ON on the same seeds - overlap >3 cm share, body jumps, planted-foot skate p95 (Q198 instrument) -
   and a 20-s recording pair per switch (`Tools\godot_hidden.ps1`, `tools/record_room.gd`) into `previews/u195/`.
3. A verdict table: switch | numbers OFF | numbers ON | recommendation (ON / DELETE / needs the operator's eye) | why.
   Do NOT flip defaults yourself - Claude decides from the table and the operator's eye on the recordings.

## Gate
PC watchdog first; max two agents - run at idle priority, `--jobs 1`. New tools only (`Godot/tools/u195_*.gd`): parse gate
+ running them. No production script edited.

## Owned files
`Godot/tools/u195_*.gd`, `previews/u195/`, `research/U195_DIGEST.md`. Read-only: everything else
(`FightRealtime.gd` is ~7,300 lines - never open it whole).

## Deliver
Commit and push as you go; U195_DIGEST.md with the verdict table first; one `agent_comms.py send --from cursor` line.
**Trap:** a switch that changes nothing on your population may just never fire there - print how often each switch's code
path ran (non-vacuity) before you call it harmless.
