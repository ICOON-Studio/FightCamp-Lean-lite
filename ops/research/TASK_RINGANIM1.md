# TASK RINGANIM1 - standing 2D animations for Ring Switches: every action seen, frame by frame (S551)

Kind: build (picture tools under `tools/`, pictures and the toy page under `proto/twohands/`; nothing under scripts/).
Model: claude-fable-5-2 (animation work: owner S512 "use fable for animations"). Discipline: boxing (demo path).
Seat: the next session itself, or a Claude worker in a console tab. Estimate: 4-6 hours, about 1 hour of it GPU renders.

## Why
Owner S551, on the fight toy he called "a beautiful game" (`proto/twohands/switch.html`, `order.html`): "we need to work
on the visuals of the fight so the player can understand the actions by seeing every card being executed by the
fighters , 2d animations and when the fight goes to the ground we will use the grapplemap animations from any angle we
want." Then: "prepare handoff to start with the standing animations". The ground (GrappleMap) is NOT this task.
Today each action shows one still (the end of the punch) from `proto/twohands/img/` - 58 pictures made by
`tools/pics2d_set.gd` (docs/PICS2D1_RESULT.md, docs/PICSFIX1_RESULT.md). The punch does not travel.

## METHOD (quote in your first message)
- FIGHT ANIMATION: v2 only, NO new correction layer in scripts/fight3d (FIGHTPLAYER2). This task changes no game file:
  it records what the v2 player already plays. THE OWNER'S EYE IS THE RULER.
- ANIMATIONS FROM OUR RESEARCH AND CLIPS (owner S537): name the study and the reference take for every action
  (`python ops/Tools/prior_research.py punch wind-up travel recovery frames`); numbers beside ours.
- BEFORE / AFTER ON A FIXED SIDE CAMERA, never a claim from numbers (owner S537). Bars are read on the pictures he sees
  (owner S546: a bend of 0.04 s is invisible).
- A PICTURE NEVER SHOWS A BODY THROUGH A BODY: every contact frame passes `tools/pics2d_gate.gd` (PICSFIX1) or is not kept.
- HIS GAME FIRST: check `Get-Process ArcheAgeChronicles` before any render; one Godot at a time while it is open.

## The actions the page needs (a frame run for each, both corners, men's set first)
| Action in the toy | Runs needed | Source today |
|---|---|---|
| Jab, Cross, Lead hook, Body hook, Lead uppercut, Rear uppercut, Body cross | landed / blocked / missed | `pics2d_set.gd` FAMILIES |
| Overhand | landed / blocked / missed | borrows rear_hook: find an overhand take; if none, say so and keep the hook |
| Step in, Back off | one run each | NO picture: find the v2 step takes |
| Hold it high, Hold it low (each hand) | a 2-3 frame settle into the guard / the body cover | guard.webp; the shell take `mc_block` |
| Feint | the jab's first third, then back | NO picture |
| Push off | one run | NO picture: find a take or say there is none |
| Clinch, Knockdown | clinch: tie-up in 3-4 frames; knockdown: the 3 frames that exist | clinch.webp, *_knockdown_1..3 |

## Steps
0. RED FIRST: `proto/twohands/tools/anim_check.mjs` lists every action above and fails for each one with no frame run
   on disk (all red today). Commit it.
1. `tools/pics2d_anim.gd` (pics2d_set.gd is at 499 lines: a new file that preloads it, never grows it). For each
   family x result x corner: place the pair exactly as the still tool does (the range FOUND at contact, the gate),
   then replay the take from its start with the camera fixed and save frames at fixed offsets from the contact time -
   start with -0.30, -0.22, -0.15, -0.09, -0.04, 0, +0.05, +0.12 s (8 frames) and change the offsets only after looking
   at a strip. The other man plays his own answer in step (hit reaction, block, pull or duck), as in the still.
   Write `frames.json`: for every run the file names and the offsets.
2. The new actions of the table (steps, holds, feint, push, overhand), same camera, same look.
3. Web copies: 480 px webp into `proto/twohands/img/anim/` (PIL, default method - `method=6` took minutes in S551),
   mirrored use stays in the page (the player is blue, on the left).
4. The page (`switch.html`; `order.html` is generated from it by `proto/twohands/tools/make_order.py` - edit the base and
   rerun the generator): play a run at its recorded offsets, hold the contact frame about 0.25 s with the flash that
   exists, slow the last three frames of a big punch, preload a beat's runs before it plays, fall back to the still
   when a run is missing. The caption, the lit switch and the sounds stay as they are.
5. For his eye: one strip per action (all frames side by side) and a before / after film of three beats (before: the
   still pop of today; after: the frame runs), on the review board.

## VISUAL GATE
Red first (step 0). Fixed-side-camera strips through the framing check (both boxers head to feet in every frame, never
a feet-only picture); per contact frame: the gap between the boxers, noses not inside the other body, wrists, feet on
the floor (`tools/pics2d_gate.gd`). Before / after film (twice at real speed, once at quarter speed) and the strips on
the review board with `python ops/Tools/review_add.py --stage S552 --rating "not scored: your eye" --title "<what it
shows>" <files>`. The owner closes it on the films and by playing the page.

## Not allowed
No change under scripts/ or to any bout rule. No layer over a take: a take that reads wrong is REPORTED with its strip,
not patched. Windowed Godot only through `python tools/hidden_desktop.py run ...` and the queue
(`python ops/Tools/godot_slot.py run --who RINGANIM1 -- <command>`), `--audio-driver Dummy`, never `_console.exe`;
watchdog before each job. Do not touch the rules of the toy (`resolve`, `ai`) - pictures and playback only. Commit ONLY
your own paths.

## Feedback loops
None: pictures and playback only; no rule, number or bout result is read or written.

## Prior research
`docs/PICS2D1_RESULT.md`, `docs/PICSFIX1_RESULT.md`, `ops/research/TASK_PICS2D2.md`, `docs/BODYCROSS3_RESULT.md` and
`docs/BODYCROSS4_RESULT.md` (the body cross take, elbow and reach), `docs/BODYREACT2_RESULT.md` (the body-punch fold),
K48 / K51 / K52 (hit response, elbow at impact), `ops/research/TWOHANDS_SCOPE_S551.md` (the toy and his words).

## What would a human do?
He would lay the eight frames of one jab side by side before rendering four hundred, and only go on when the strip reads
as a jab to someone who was not told what it is.

## Prefab check
`tools/pics2d_set.gd` (the stage, the pair placer, the gate), `tools/pics2d_render.gd`, `tools/hidden_desktop.py`,
`proto/twohands/tools/make_order.py`. Budget: about 8 families x 3 results x 2 corners x 8 frames = 384 frames, plus
about 60 for the new actions; at ~15 KB a frame that is under 8 MB.

## Contract
OWNS: tools/pics2d_anim.gd, proto/twohands/tools/anim_check.mjs, proto/twohands/img/anim/, proto/twohands/switch.html, proto/twohands/order.html, proto/twohands/tools/make_order.py, docs/RINGANIM1_RESULT.md
RED_TEST: proto/twohands/tools/anim_check.mjs
REGRESSION: tools/pics2d_gate.gd on every contact frame; `node --check` of both pages' scripts; the still set unchanged
VISUAL: strips and the before / after film on the review board

## Result
`docs/RINGANIM1_RESULT.md`: a NOT GREEN list first (every action with no usable take, every strip that reads wrong);
what now plays; the strips and films named; how to reproduce. Do not push; do not ask questions: decide, and write what
you decided.
