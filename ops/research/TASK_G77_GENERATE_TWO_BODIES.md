# TASK_G77 — GROK — GENERATE TWO-PERSON GRAPPLING MOTION WITHOUT FILMING ANYONE

**Research. No code.** Expert mode. Owner: grok. Assigned S59, 2026-09-23.

## Owned files

- `research/G77_GENERATE_TWO_BODIES.md` - Claude saves your answer here.

## THE RULING THAT FRAMES THIS

The operator has ruled OUT filming people ("this is not an option, find a way, there are so many AI generators and
tools, innovate"). Your G76 recommended filming; that route is closed. Find the generation route.

## WHAT WE HAVE AND WHAT WORKS

- Cascadeur Pro (owned): our agent Codex authors paired static HOLDS in it by script, and poses them to a CHECKED
  REFERENCE IMAGE (a generated still that a human verified) - that matched closed guard today.
- Image generation gets a SINGLE two-person pose right when checked (north-south, knee-on-belly failed in video but
  were correct as stills).
- Text-to-video (Seedance) gives believable two-body footage; tracking it fails on wrapped poses (your G76).
- Text-to-motion (Higgsfield ARDY kimodo) gives clean skeletons, ONE body only.
- RamsterZ Full Mount paired pack (owned, 16 moves). Godot 4 engine; our contact probe declares contacts as
  joint-pair distances (e.g. attacker left hand -> victim neck).

## WHAT I WANT

1. **Two-person motion GENERATION models** (skeleton out, not video): InterGen, InterControl, in2IN, InterMask,
   TIMotion, ReMoS, Duolando, FreeMotion, and anything newer. For each: output format, joint-level CONTACT control
   (InterControl claims per-joint distance control - does it?), local Windows + one NVIDIA GPU, **licence of the
   CODE and of the TRAINED WEIGHTS and of the DATASET they trained on (InterHuman, Inter-X, Hi4D...) for a
   COMMERCIAL game**, and whether any close-contact or combat motion is in the data.
2. **Cascadeur's own AI tools** in 2026: AI inbetweening / "fill the gap between keyframes", AutoPhysics, AutoPosing -
   what each does, whether it works on TWO characters in contact, and whether it is scriptable from Cascadeur's Python.
   The plan it would serve: a takedown = 4-5 checked key stills, Codex poses each, Cascadeur fills the motion.
3. **Physics-based character controllers** that can take two reference poses/keyframes and simulate the contact
   between them (e.g. MaskedMimic, PHC, InterPhys-style work): usable offline to BAKE clips? Licence?
4. **Video tricks** that make generated video trackable: dressing each generated fighter in a distinct solid-colour
   full-body suit for segmentation-first tracking (SAM2 / colour masks), prompting mocap-style marker suits, any
   published use of this. Would a generated video keep the colours consistent enough?
5. **Rank** the routes by expected yield per hour for our 376 missing clips (takedowns, throws, escapes, transitions,
   strikes), and say what you would pilot FIRST with one takedown (a double-leg).

## RULES

Every number measured (source) or judgement. **WHAT I COULD NOT FIND.** **ARGUE AGAINST YOURSELF** - but not with
"film it": that is ruled out; attack the ranking instead.
