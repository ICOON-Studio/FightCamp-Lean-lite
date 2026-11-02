# TASK C119 — CODEX — UNREAL 5.8'S OWN CODE: HOW A JOIN BETWEEN TWO ANIMATIONS IS BUILT (INERTIALIZATION AND DEAD BLENDING)

Model: `gpt-5.6-luna`, MEDIUM (the only setting - `Tools/codex_task.cmd`). Owner: codex. Main checkout, branch
`master`. Stage: S4a (the joins between clips).

**Test tier: RESEARCH, NO `.gd` TOUCHED.** No Godot, no test, no commit (your sandbox cannot write `.git`; Claude
collects). `python research/C119_check.py` must exit 0 before you send the mail.

## Owned files

- `research/C119_UE_JOINS.md` - NEW, 70 lines at most.
- `research/C119_ue_citations.json` - NEW.

## Why this exists

Our fighters change animation dozens of times a minute, and the joins fail our realism gate: in the 0.35 s after a
change of take, leg joints turn at 2.05x the speed the incoming performance itself uses (rule R5b), arms at up to 3.4x.
Our join is an inertialization (Bollo 2018, a quintic decay of the pose offset, initial velocity from the last two
frames). Unreal Engine 5.8 ships two join nodes - Inertialization and the newer Dead Blending (which extrapolates the
outgoing pose with decaying velocity and CLAMPS that velocity) - and both are installed on this PC with their source.
Read them and write down exactly what the code does, cited line by line. DOCUMENTED means "the installed code says
so", never a forum or a guess.

## What to read - ONLY these (read-only; paths under `C:/Program Files/Epic Games/UE_5.8/`)

- `Engine/Source/Runtime/Engine/Classes/Animation/AnimNode_DeadBlending.h` (332 lines, read whole)
- `Engine/Source/Runtime/Engine/Private/Animation/AnimNode_DeadBlending.cpp` (1,140 lines: `grep -n` for
  `HalfLife`, `Maximum`, `Extrapolat`, `Velocity`, `Alpha`, `Duration`, `Request`, then read windows)
- `Engine/Source/Runtime/Engine/Classes/Animation/AnimNode_Inertialization.h` (505 lines: the node struct from `:296`)
- `Engine/Source/Runtime/Engine/Private/Animation/AnimNode_Inertialization.cpp` (1,521 lines: `grep -n` for
  `CalcInertialFloat`, `Deficit`, `Duration`, `Velocity`, `Quintic`, then read windows)
- `Engine/Source/Runtime/Engine/Classes/Animation/AnimInertializationRequest.h` (94 lines, read whole)

If any path cannot be read, stop: send `--topic "C119 BLOCKED"` with the exact error text. Do not substitute other files.

## Questions - each answered in the digest, each backed by citations

- **D1** Dead Blending: what is extrapolated from the outgoing pose (which channels), how the per-bone velocity is
  measured, and the extrapolation formula over time - as code.
- **D2** How the extrapolation half-life is chosen per bone (`ExtrapolationHalfLife`, `...Min`, `...Max`: what
  quantity picks a value between min and max) and where `MaximumTranslationVelocity` / `MaximumRotationVelocity` /
  `MaximumScaleVelocity` clamp - the formula and the units (degrees or radians per second, cm per second).
- **D3** How the extrapolated pose and the incoming pose are combined: the alpha, its curve (`EAlphaBlendOption`),
  `DefaultBlendDuration`, `BlendTimeMultiplier`, and per-bone durations from a blend profile.
- **D4** A new request while a dead blend is still running: what becomes the new "outgoing" pose.
- **I1** Inertialization: the offset decay as the code computes it (the polynomial and how its coefficients come from
  the initial offset, its velocity and the duration), including what it does when the initial velocity points AWAY
  from the target.
- **I2** Inertialization: an interrupted blend - `InertializationDeficit`, `InertializationMaxDuration` - and how a
  request's `Duration` is resolved when several arrive in one frame.
- **I3** For both nodes: what happens to the root bone / root motion, and to a bone present in one pose and not the
  other.

## Output

`C119_ue_citations.json`:
`{"defaults": {"FAnimNode_DeadBlending.DefaultBlendDuration": 0.25, ...},
  "citations": [{"id": "D1", "claim": "one sentence", "file": "Engine/Source/Runtime/Engine/Private/Animation/AnimNode_DeadBlending.cpp", "line": 123, "quote": "the exact text of that line, trimmed"}, ...]}`
- `defaults`: EVERY field declared with a default value (`Type Name = value;`) DIRECTLY after a `UPROPERTY(...)` line
  in the three structs `FAnimNode_DeadBlending`, `FAnimNode_Inertialization` and `FInertializationRequest`, keyed
  `Struct.Field`: numbers as numbers (drop the `f`), `true`/`false` as JSON booleans, anything else as the text after
  the `=` (e.g. `"nullptr"`, `"NAME_None"`, `"UE::Anim::DefaultBlendOption"`).
- `citations`: at least TWO for each of D1, D2, D3, I1 and I2, and one for D4 and I3. `line` is 1-based; `quote` is at
  least 15 non-space characters copied from that line (the check looks within two lines either side). `file` is
  relative to `C:/Program Files/Epic Games/UE_5.8/`.

`C119_UE_JOINS.md` opens with `## DECISIONS` (at most 8 lines: for our joins - the velocity clamp and half-life rule
with their numbers, the blend duration and curve, what an interrupted join does). Then one `### D1` ... `### I3`
section per question: the answer, the formula in plain code, and the citation ids it rests on.

## Send

`python research/C119_check.py`, then
`python Tools/agent_comms.py send --from codex --to claude --topic "C119 ready" --body "check PASS"`.
Do not edit any other file. Do not run Godot.

## The trap

A header comment describes what a field is FOR; the `.cpp` decides what it DOES, and they can disagree (C118 found
`PelvisHeightMode` exposed in the header and never read by the code). Every answer to D1-D3 and I1-I2 must cite at
least one `.cpp` line; where a comment and the code differ, say so and follow the code. And units: Unreal mixes
degrees in its settings and radians in its math - name the unit at every number.
