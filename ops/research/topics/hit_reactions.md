# Hit reactions, ragdoll, the man who gets hit

**Canonical page.** Read this before assigning or building anything on this topic. New findings UPDATE the sections
below (with the study that settled them); they do not become an orphan file. Last hand update: S114, 2026-09-27.

## Settled
- **What a hit head and body do** in the first half-second: a hook ~71 g / ~9306 rad/s2 (Viano 2005), an uppercut ~24 g -
  `K51_THE_HIT_RESPONSE.md`; how far a hit boxer's feet move - `K48_HIT_BOXER_FEET.md`; reaction direction vs strike -
  `Q104_REACTION_DIRECTION.md`; no head take is lateral-dominant - `C177_DIGEST.md` (sided reactions).
- **Reactions play whole on the blow** (the queue used to cut 75% before recovery) - `U159_DIGEST.md`; sway carry -
  `U88_SWAY_CARRY.md`, `Q89_REACTION_SWAY.md`; spend presentation slots on reactions - `M17_THE_REACTION.md`.
- **An ordinary leg kick keeps the man upright** (react_leg = StaggerSmall01, 0.60 s) - `C214_DIGEST.md`.
- **Physics hit reactions:** the design and cost - `G86_PHYSICS_HIT_REACTIONS.md`; the struck-segment experiment -> keep
  `hit_physics` OFF - `C188_DIGEST.md`. **Active ragdoll from Kickback (MIT, pinned upstream)** - prototype
  `C217_DIGEST.md`, live motion `C218_DIGEST.md`; `active_ragdoll` defaults OFF.

## Open
- Whether the active ragdoll goes ON: needs the operator's eye on a recording and a no-worsening contact gate.

## Engine
`FightStagePlayer.gd` (reaction queue), `addons/kickback/`, the room's `active_ragdoll` option. Tests: `fight_hit*`.

<!-- GENERATED BELOW - python Tools/topic_pages.py; edit only above this line -->

## Studies on this topic (18, newest first, generated)

- `C218_DIGEST.md` (2026-09-27) - C218 - live active-ragdoll motion
- `C217_DIGEST.md` (2026-09-27) - C217 - active-ragdoll nervous system prototype
- `C214_DIGEST.md` (2026-09-27) - C214 - an ordinary leg kick stays upright
- `J50_HOW_A_DEFENDER_DEFENDS.md` (2026-09-25) - J50 — How a Defender Defends (block, evade, and everything in between)
- `U159_DIGEST.md` (2026-09-24) - U159 — reactions play whole on the blow
- `G86_PHYSICS_HIT_REACTIONS.md` (2026-09-24) - G86 - physics-driven hit reactions over animation, in Godot 4 (Grok, delivered S65 2026-09-24)
- `G86_BRIEF.md` (2026-09-24) - G86 - FEINTS: how often real fighters feint, what the other man does, and what it opens (Grok, research) - S68
- `C188_DIGEST.md` (2026-09-24) - C188 — struck-segment physics experiment, NOT ACCEPTED
- `C177_DIGEST.md` (2026-09-23) - C177 - sided reactions
- `Q104_REACTION_DIRECTION.md` (2026-09-14) - DECISIONS
- `K60_WATCH_LIST_5.md` (2026-09-14) - K60 - Watch list 5: the man who gets hit
- `K57_WATCH_LIST_3.md` (2026-09-14) - K57 — Watch list 3: punches landing in super slow motion (the hit and the reaction)
- `K51_THE_HIT_RESPONSE.md` (2026-09-14) - K51 — WHAT A HIT MAN'S HEAD AND BODY DO IN THE FIRST HALF-SECOND
- `U88_SWAY_CARRY.md` (2026-09-13) - DECISIONS
- `Q89_REACTION_SWAY.md` (2026-09-13) - DECISIONS
- `G56_THE_BEAT_AND_THE_CLIP.md` (2026-09-11) - G56 — A Three-Second Reaction on a One-Second Beat
- `M19_THE_MISSING_CLIP.md` (2026-09-10) - M19 — THE MISSING CLIP (presenter when R101 names a technique we have no clip for)
- `M17_THE_REACTION.md` (2026-09-10) - M17 — THE REACTION (spend M16 freed slots)
