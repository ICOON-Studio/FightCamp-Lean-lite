# TASK GLOVEFACE1 - the guard glove: sinks into the cheek, tall and narrow side-on, the cuff a tube (owner C447)

Model: claude-fable-5-2 (Code Mode console in E:\FightCamp\Lean). Discipline: boxing (demo).
Owner C447 (review board, a WRONG mark on the red boxer's guard glove, ops/Feedback/2026-11-21-06/marked.png): "is the glove
normal looking ?". Claude's read of his mark: side-on the glove reads tall and narrow, its back pressed INTO the cheek, and the
white cuff is a straight tube the width of the glove. MHCORR2 (body correctives) has landed, so judge on today's bodies.

## Do
1. Measure first, on the game's own camera (fight player v2, `tools/fight3d_still.gd` on the hidden desktop through
   `python tools/hidden_desktop.py run ...`, stills via still_framing `save_if_framed`): guard AND mid-punch, side-on and the
   broadcast angle. Print per glove: length (cuff end to knuckle), width, depth (palm to back), cuff length and flare, and the
   glove-to-cheek gap (negative = inside the face). Compare with a real 10-12 oz glove (find a maker's size sheet; tag
   SOURCED or ESTIMATE). Write the numbers in `docs/GLOVEFACE1_RESULT.md` before changing anything.
2. Fix what the numbers say: the glove's proportions (per-axis scale in `scripts/fight3d/Gloves.gd`, not one SIZE), the cuff
   (shorter and flared toward the forearm, still the vertex-red band), and the guard gap (the glove rests ON the cheekbone,
   never inside it - reuse GloveClear/guard placement; the guard must still protect the head, owner S531).
   Keep reach and punch targets honest: front_m() follows the mesh, so check `tests/glove_cut_test.gd`, `tests/own_gloves_test.gd`,
   `tests/player2_test.gd`, `tests/choreographer_test.gd` stay green.
2b. Owner C456 (S536, on the body stills): "this black fighters do not look good on dark background it is so dark i cant tell
   the difference in the pictures". Measure the boxers' mean luminance against the crowd behind them on the broadcast camera;
   lift them with the ring's own lights (a key over the ring and a cool rim from behind, as TV boxing lights a ring), never
   by lightening skin. Pass: every body (dark and light skin) separates from the crowd by a luminance gap you print.
3. Before/after stills of the SAME frames (guard, jab contact, close guard) side-on and broadcast; open them yourself; post with
   `python ops/Tools/review_add.py --stage S536 --rating "<your read>" --title "Glove: before / after (your C447)" <files>`
   and reply on the map note if one exists. The owner closes it, not a test.

## Prior research
memory: guard protects the head (S531), no feet-only stills, MetaHuman only; Gloves.gd S316 / S391 / S400 notes (wrist straight,
palm helpers cut, SIZE 1.2 after "they look like mma gloves"); map card "Glove clipping: audit first".

## What would a human do?
Hold a real 10 oz glove beside the face: a fat rounded fist, wider than it is tall from the side, the cuff a short padded
bell, the glove resting against the cheekbone with the forearm tucked.

## Prefab check
The glove mesh is assets/models/gloves/boxing_glove.glb (CC BY 4.0). If its shape cannot be reached by per-axis scale, say so
and name a CC0 / CC BY glove (Fab, Sketchfab, Poly Haven) with its licence - do not download a paid one.

## Contract
OWNS: scripts/fight3d/Gloves.gd, the ring lights (find their file; name it in the result), docs/GLOVEFACE1_RESULT.md,
ops/previews/s536_gloveface/ (stills)
RED_TEST: a glove-to-cheek gap check added to tests/own_gloves_test.gd (red on today's guard if the gap is negative)
REGRESSION: tests/glove_cut_test.gd tests/own_gloves_test.gd tests/player2_test.gd tests/choreographer_test.gd
VISUAL: yes - game camera stills, before / after, opened by you

## Rules
Godot only through `python ops/Tools/godot_slot.py run --who gloveface1 -- <command>`; windowed renders on the hidden desktop
only, never on his monitors. Never stage LineGrade.gd, LiveRound.gd, StepWire.gd, MHRig.gd, tools/export.sh. Stage explicit
paths, commit to main with the Co-Authored-By line, push, report in two lines, stop.
