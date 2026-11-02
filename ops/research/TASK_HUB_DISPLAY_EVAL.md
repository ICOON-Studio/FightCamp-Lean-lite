# TASK HUB_DISPLAY_EVAL - EVERY AGENT - HOW SHOULD THE HUBS BE SHOWN? (evaluation + proposal)
Owner: ALL NINE (claude, codex, cursor, qwen, grok, dola, john, kalli, maria). Assigned S80 end, 2026-09-25.
Sent at the START of S81. Blind: no agent reads another agent's answer before sending its own.

## The operator's words (2026-09-25, verbatim)
"i want everyone on the next session to do an evaluation of the current state and propose ways to diplay the hubs,
should it be still images, 2.5d animated like mad games tycoon or 2point hospital, should we use more our 3d engine to
show the fighters actually doing the exercises in the gym animated"

## The current state (S80) - LOOK AT IT BEFORE YOU WRITE A WORD
**Everything is in `research/s80_look/`**: `current_look_sheet.jpg` (all screens on one sheet),
`01_title.jpg` ... `10_fight_tape.jpg` (full size, one per screen), `11_fight_night_sequence.mp4` (14 s, sound on) and
`00_M34_A_mock_hub.png` (Maria's mock the build follows). **Browser agents (grok, dola, john, kalli, maria): Claude
UPLOADS `current_look_sheet.jpg` and `02_home.jpg` into your chat with this brief** - you cannot open the repo, so say
so if an image did not arrive rather than guessing. Digest: `research/S80_DIGEST.md`.
HOME and three area hubs are AI-generated stills of our gym with pins on real objects (office, staff door, ring,
weights; locker room; office wall; desk), M34 direction A (brass & leather) chrome over them. The pictures do not
change with the game state: an empty gym at 3 fighters and at 30, the same floor after an upgrade (M34's own
self-attack: "the pins sit on a picture that doesn't change when you upgrade the gym, so it could feel like a lie").

## What would a human do?
A management-game UI lead (Two Point, Mad Games, Motorsport Manager, Hollywood Animal, Football Manager) decides how
the hub is SHOWN from three things: what the player must read at a glance, what must visibly change as the business
grows, and what the team can afford to keep in sync. Answer that first, for FightCamp, before choosing.

## The three options to judge (and any fourth you can defend)
A. **Stills** (today): generated/painted pictures per hub, pins on objects, tier variants as the gym grows.
B. **2.5D animated rooms** (Mad Games Tycoon 2, Two Point Hospital/Campus, Game Dev Tycoon): an isometric/2.5D gym
   drawn from tiles and sprites, little fighters and staff working the stations, rooms added as you build.
C. **Our own 3D engine**: the real gym floor (`GymHubPanel` floor data already places equipment on a grid) rendered in
   Godot 3D with our real fighters training on the stations they are programmed on (we own fighter rigs, the RamsterZ
   and Cascadeur animation pipeline, the Marpa arena, a camera director).

## Everyone answers (one markdown memo, <= 1,500 words)
1. Your honest evaluation of the current state - what works, what does not, what a player would notice first.
2. For A, B, C: what it gives the player, what it costs us (art, code, animation, performance on the operator's PC -
   it runs at ~87% CPU and overheats under stacked loads), how it scales with the gym, and the risk.
3. Your recommendation, with a first slice small enough for one session, and what would prove it right or wrong.

## Your lens (what only you can add)
- **codex** (3D lane): cost of C - which exercise animations we have vs need (bag, pads, skipping, weights, sparring),
  fighters per frame the PC can hold, camera. Measure, do not guess: run one test scene with 3 fighters idling on
  stations and report the frame time. Tier: no script edited in shipped code; a new tool under `Godot/tools/` only.
- **cursor**: cost of B in Godot - tilemap/sprite pipeline, where sprites would come from (licence!), sync with
  `GymHubPanel` floor data. Tier: research, no gate.
- **qwen**: census - list every animation clip on disk that shows TRAINING (not fighting) and every gym station in the
  equipment catalogue; the gap between them is C's real cost. Tier: research, a census script under `Godot/tools/` only.
- **grok**: what players praise and hate in how Two Point, Mad Games, MM, HA, FM, Punch Club, Undisputed show their
  hubs - reviews, dated, sourced.
- **john**: sourced survey - which management/sports sims use which approach, and whether it changed their reception.
- **dola**: a fresh-eyes review of the four screenshots as a player seeing them for the first time.
- **kalli**: what the hub must SAY at a glance (words, counts, alerts) under each option - does B or C lose or gain it?
- **maria** (art director): art-direction cost and consistency of A vs B vs C in direction A; how each keeps one look;
  what a vertical slice would need; licence of every source.
- **claude**: synthesise all nine, recommend ONE with a fallback, bring it to the operator with the costs side by side.

## Deliverable
`research/<ID>_HUB_DISPLAY_EVAL.md` (IDs: C208, U177, Q179, G106, J56, D24, K80, M36; claude writes the
synthesis `S81_HUB_DISPLAY_SYNTHESIS.md`). Shell agents commit on their own branch and send one line with
`agent_comms.py send`. Browser agents paste inline. Research only, no shipped-code change.
