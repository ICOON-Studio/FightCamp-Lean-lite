# TASK C214 - CODEX - A LEG-KICK REACTION THAT DOES NOT FLOOR HIM (S97)
Owner: codex. Assigned 2026-09-27 (S97). Model: `gpt-6-astra` MEDIUM (3D animation: clip choice, retarget, binding),
`CODEX_WEB=live` not needed. Meter at assignment: 11% used, resets 2026-10-03.
Branch `codex/c214-leg-reaction` from `origin/master`. Claude merges; never merge master in.

## Why
S97 (live limb damage) rendered the production room: every landed leg kick plays `react_leg`, bound to
`H2H_StaggerLarge04_LowHit.FBX` (start 8.83 s, 2.7 s long - `FightClipBinding.gd:155`). It takes the man to his hands
and knees for ~2 s (contact sheet in `docs/previews/s97/`, `stung.mp4`). A clean low kick in kickboxing makes a man
hitch, shift weight off the leg and keep fighting; the big stagger is a leg that has GONE. So every leg kick currently
reads as a near-knockdown.

## What would a human do?
A fight animator keeps a ladder of hit reactions by severity: a small hitch for an ordinary landed kick, a buckle when
the leg is compromised, the collapse only when it gives out. They pick from the library by watching each take, and
they judge it at game camera distance, not in the clip viewer.

## Do
1. Audition the RamsterZ takes that could be a leg hit: `H2H_StaggerSmall01`, `H2H_StaggerMedium01..04` (+ `_v1`),
   `H2H_HitReaction01..04` in `Godot/assets/anim/audition/ramsterz_h2h/`. For each: does the weight come OFF one
   leg, does he stay up, how long until he is back in stance. Contact sheets into `previews/c214/`.
2. Bind a ladder for `react_leg`: an ordinary landed leg kick -> the small hitch (<= ~1 s, stays upright); keep
   StaggerLarge04 only for a leg at CRITICAL or worse (S97's bands: `CornerPitStop.band(condition)` < 40), which the
   room can read from the fight state it already samples (`FightWorldLiveScreen._chips_shown`). Use the existing
   variant mechanism (`_variants`, `FightReactionSide.choose`) if it fits; do not add a second binding system.
2b. S98 addendum - `J57_WHAT_A_LANDED_LEG_KICK_LOOKS_LIKE.md` section 4 gives a THREE-tier ladder with odds:
   light hitch (<=0.6 s) / medium stumble-buckle (StaggerMedium, <=1.5 s, upright) / heavy collapse (StaggerLarge04).
   Fresh leg 90/10/0, HURT 65/32/3, CRITICAL 35/50/15. Bind the medium tier too if a take fits; if the variant
   mechanism cannot weight by band, ship light + heavy (the brief above) and name the medium take in the digest.
3. Retarget exactly as the current `react_leg` entry does (same reference `T_pose.fbx`, `retarget: true`).

## Gate (a CEILING)
- Render the same S97 fight (`tools/s97_render_corner.gd`, seed 97102 - or your own tool built from it) and a leg-kick
  contact sheet: an ordinary landed leg kick keeps him on his feet; a CRITICAL leg may buckle. `docs/previews/c214/`
  holds both, plus a 5 s mp4 of the small reaction at game camera distance.
- Parse gate on touched files; `python Godot/tools/run_tests.py --jobs 2 --only fight_clip,fight_stage,fight_reaction,corner_`
  no worse than master (fight_world_live_test is already red on master - leave it).
- Windowed renders only via `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 <godot args>`.

## Owned files
`Godot/scripts/FightClipBinding.gd` (the `react_leg` entry and its variants; grep, never open whole),
`Godot/scripts/FightStagePlayer.gd` only if the variant pick needs the band (4,500 lines - sed -n windows around
`play_role` and `_variants`), `Godot/tools/c214_*.gd`, `previews/c214/`, `research/C214_DIGEST.md`.

## Deliver
Commit explicit paths, push the branch, write `research/C214_DIGEST.md`, then
`python Tools/agent_comms.py send --from codex --to claude --topic C214 --body "<clip chosen, hitch length, render paths>"`.
Do NOT edit HANDOFF.md. Research is open: RESEARCH_INDEX.md.
**Trap:** a clip that looks small in the viewer can still travel - check the root does not slide the man across the ring
(`RECEIVER_SWAY_ROLES` carry rules, `FightStagePlayer.gd:82`).
