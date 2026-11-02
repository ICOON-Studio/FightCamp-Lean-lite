# TASK C217 - CODEX - A SIMULATED NERVOUS SYSTEM: ACTIVE-RAGDOLL HIT REACTIONS, PROTOTYPE (S101)
Owner: codex. Assigned 2026-09-27 (S101). Model: `gpt-6-astra` HIGH (`CODEX_MODEL=gpt-6-astra`, `CODEX_EFFORT=high`;
spatial, physics, rigs). Branch `codex/c217-active-ragdoll` from `origin/master`, own worktree. Claude merges.
**Launch after C215 lands (Codex's animation queue; max two shell agents).**

## Why
The operator asked (2026-09-27) for "the simulated nerve system described in the video": Corridor Crew's breakdown of
GTA 6 (notes: `research/S101_GTA6_VFX_BREAKDOWN_NOTES.md`, point 1). Rockstar's Euphoria runs motion capture
together with a physics solver. On a hit, joint MOTORS drive the body toward a target pose inside joint limits, and a
small state machine switches between BALANCE (shot in the right leg -> load the left) and SELF-PRESERVATION (arms up,
brace for the fall). Euphoria itself is proprietary and patented; we build the generic technique, an active ragdoll
with PD-driven joints, which is widely published.

Our hit reactions are canned clips today (C214: an ordinary landed leg kick is a 0.60 s StaggerSmall01; the heavy
collapse plays only at CRITICAL/DOCTOR). The limb-damage model (S97, `CornerPitStop.band`, `FightRealtime`
`body_condition`) already knows which leg is hurt and how badly. That is exactly what a balance controller needs.

## What would a human do?
A games animation programmer (NaturalMotion, the PuppetMaster author, the Uncharted/TLOU hit-reaction talks) keeps the
animation authoritative and lets physics ADD to it. A partial ragdoll is blended over the clip. Each joint gets a PD
motor toward the clip's pose, and a hit lowers the motor strength for a short window, only on the struck chain. A
balance controller keeps the centre of mass over the support polygon, stepping if it must. The animator then blends
back to the clip. Nobody lets physics decide the outcome of the fight. Read how they do it BEFORE choosing a method:
Godot 4.7's `PhysicalBoneSimulator3D` / `PhysicalBone3D` (joint limits, `influence`), Jolt's joint motors, and
published active-ragdoll write-ups.

## Prefab check - START FROM KICKBACK, DO NOT BUILD FROM SCRATCH (S101)
`github.com/blugart-dev/kickback` - **MIT**, **Godot 4.7+** (we run 4.7.2), **Jolt required**. "Euphoria-like hit
reactions" with active-ragdoll springs that track the animation; a stagger that stays upright; centre-of-mass balance;
momentum transfer; directional bracing; fatigue across repeated hits; REGIONAL IMPAIRMENT (persistent per-bone injury -
map it to our limb bands); protected bones (legs stay animated); a directed stumble with arm bracing and foot-IK catch
steps; a threat-anticipation API (pre-hit lean). It auto-detects Mixamo / Rigify / UE5-mannequin / generic Hips-Spine
rigs, with a `RagdollProfile` fallback. Pre-1.0 (the author estimates 20-25% of Euphoria), 22 stars - so VENDOR IT at a
pinned commit under `Godot/addons/kickback/` with its LICENSE, and record the commit hash in the digest.
First checks: (a) the project has no `physics/3d/physics_engine` line in `project.godot`, so confirm what 4.7.2 runs
by default and whether switching to Jolt moves anything (our fight engine is custom, but the room and props may use
physics); (b) does it map onto the Tripo fighters and the MPFB generator rig (S93: MPFB's Root bone broke the
retarget)? Write a `RagdollProfile` if auto-detect fails.
Fallbacks if Kickback does not fit: CBerry22 `Active-Ragdoll---Physics-Animations-in-Godot-4.0` (MIT, 152 stars, a
reference implementation of Unreal-style physical animation) and R3X-G1L6AME5H `Godot-Active-Ragdolls` (RigidBody +
Generic6DOFJoint motors). Our layer on top is what Kickback lacks: the engine event -> reaction mapping, and "physics
never changes the result".

## The hard rule
**Physics PRESENTS what the engine decided; it never changes it.** The fight engine is deterministic, and
watched == settled is a shipped guarantee (S87). The ragdoll reads the engine's event (a landed kick on `left_leg`,
limb band `hurt`) and animates it; it writes nothing back. A reaction that would topple a man the engine says is
standing must recover on its own.

## Do (a prototype, one body, then two)
1. **Feasibility, in one page, before any code:** Godot 4.7 active-ragdoll options on OUR rigs (Tripo/Higgsfield
   fighters, MPFB generator bodies). Our rigs are NOT in metres (memory: Tripo exports scaled; they lift 0.925 m). Name
   the skeleton, the bone chains, and the physics tick against the 60 fps render.
2. **One fighter, one event:** a landed low kick on the lead leg.
   - The struck leg's motors weaken for about 0.4 s.
   - The balance controller shifts the centre of mass onto the other leg.
   - A step recovers if needed, then the body blends back to idle.
   - Two severities: `hurt` recovers in place; `critical` drops to one knee, then rises.
3. **The self-preservation reflex:** a head shot at CRITICAL head condition brings the arms up and braces for the fall.
4. **Two bodies, only if 2-3 are stable:** the reaction plays while the opponent stays animated, with no
   interpenetration pops.
5. **Measure:** frame time on this PC (the live room at its normal size; C112's frame timer); stability (no explosions
   over 200 reactions from a seeded list); and a before/after contact sheet and MP4 for the operator (memory: show
   animation as video). Windowed runs go through `Tools\godot_hidden.ps1`.

## Gate (a ceiling)
Behind a switch, `active_ragdoll`, OFF by default. With the switch OFF the room is byte-identical: the engine log hash
does not change either way. Frame cost is reported. The prototype video and the digest are delivered. No full suite:
parse gate plus the room tests you touch (`--only fight_world_live,fight_room`).

## Owned files
A new `Godot/scripts/FightActiveRagdoll.gd`; the room's hook into it (`FightWorldLiveScreen.gd`, ~4,200 lines - never
open it whole, grep then `sed -n` windows); `Godot/tools/c217_*.gd`; `research/C217_DIGEST.md`; the preview
video under `previews/c217/`.

## Deliver
Commit and push AS YOU GO. Digest, then `python Tools/agent_comms.py send --from codex --to claude --topic C217 --body
"..."`. Do NOT edit HANDOFF.md. All research is open via `RESEARCH_INDEX.md`. **Trap:** a ragdoll that looks great on
one clean rig and explodes on the scaled Tripo rig is the likely failure. Test on the shipped fighters first, never on
a test mannequin.
