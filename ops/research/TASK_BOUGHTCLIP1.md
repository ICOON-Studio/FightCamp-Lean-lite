# TASK BOUGHTCLIP1 - show the owner the bought cross as bought, and answer "does the cross only reach the shoulder?" (S537)

Model: claude-fable-5-2 (Agent SDK, API credit). Discipline: boxing (demo). Standing approval for animation fixes (S510).
METHOD: fight player v2 only; no new correction layer; fixed side camera for every comparison (memory
feedback_before_after_films_s537); open every frame yourself and say plainly what shows.

## The owner's notes (review board, 2026-11-22, after KNEEROOT1)
- C467 on 12_red_idle.mp4 (red guard idle, gloves fixed): "Fine" -> the glove fix is accepted.
- C468 on ops/previews/s537_kneeroot1/pairs/3_blue_cross_side.jpg: "They both look weird show me the bought clip". The LEFT
  half was the bought take on OUR MetaHuman body; he has not seen the clip as the vendor sells it.
- C469 on ops/previews/s537_legs_off/recorded_blue_cross.png: "Cross can only reach shoulder?"
- C470 on an older before/after cross loop: "They both look shit".
- C471 (ops/Feedback/2026-11-22-05/marked.png, on the blue cross legs): "That's too much twisting or bending. Maybe the foot
  needs to move a bit".

## Do
1. **The clip as bought.** Find the source of our cross (assets/anim/baked/mc_Box1_M3_Right_Cross*.res -> the MoCap Online
   Box1 pack FBX under assets/ or E:\FightCamp; grep the bake tools for the path). Render it on its OWN skeleton and the
   pack's own mannequin mesh if the pack has one (else a plain capsule-bone figure), same fixed side camera, film + contact
   still. Find the vendor's own preview video/page for that pack and clip (web) and give the URL. Put three side by side:
   vendor-as-bought | our MetaHuman body with the take only (every v2 layer off) | the game now.
2. **Where the difference comes from**, in numbers at the contact frame, per leg and arm: as-bought vs our body. If our
   body/retarget changes the take (bone lengths, rest pose, hips height, foot roll), name the stage and file:line.
3. **The reach (C469).** At contact: glove height vs the target's chin / nose / shoulder, the arm's extension (% of full),
   and the distance between the two men. Does our cross stop at shoulder height because of the take, the spacing, the aim
   layer, or the other man's height? Same for the bought clip on its own (where does its fist end, in m above the floor?).
4. **The feet (C471).** In the bought take does the rear foot pivot/turn on the ball through the cross? Does ours? If the
   take pivots and ours does not, find why (a pin, a step wire, a stance hold) and remove it; if the take does not pivot,
   say so - that is a take problem (a better clip: end-of-November pack), not code.
5. Fix only at a cause that is OURS, by removing or correcting our stage, never by adding a layer; tests in
   tests/player2_test.gd for any fix, red first; player2, choreographer, arm_build, file_limits, golden_path green.
6. `docs/BOUGHTCLIP1_RESULT.md`: plain words first - "the bought clip looks like X; ours differs because Y"; the vendor
   URL; the numbers; what was fixed. Stills/films in ops/previews/s537_boughtclip1/.

## Prior research
docs/KNEEROOT1_RESULT.md (FootTake + Gloves off), FP2POSE2-4 results, ops/research/CROSS_POWER_S439.md,
K46_BOXER_FEET_DURING_PUNCHES.md, memory reference_asset_ai_clauses_s495 (MoCap Online licence: no AI training use - only
viewing/rendering in our game).

## What would a human do?
Open the clip in the vendor's viewer first, then put it beside the game.

## Prefab check
None.

## Rules
Godot only through `python ops/Tools/godot_slot.py run --who boughtclip1 -- <command>`, one run at a time; windowed only via
tools/hidden_desktop.py; nothing opens on the owner's monitors. Do not edit LineGrade.gd, LiveRound.gd, StepWire.gd,
MHRig.gd (report a cause there instead). No script over 500 lines. `git add -- <new>` then `git commit -m ... -- <your
paths>` with `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`, pull --no-rebase --no-edit, push, report in two
lines, stop.
