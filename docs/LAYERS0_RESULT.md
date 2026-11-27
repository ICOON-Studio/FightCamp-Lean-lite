# LAYERS0 - one man per picture, phase 0: the guard holds + the jab (S570, Claude in session)

Owner S569: "the fighter get displaced without moving"; "sohow fighting games cope with distance ? what are we doing
differently ?". Plan: ops/research/LAYERS_SCOPE_S569.md, approved S570 with his purchase of Cascadeur Indie + the Animo
pack. Brief: ops/research/TASK_LAYERS0.md.

## How (no new render for frames that have a part mask)
- `proto/twohands/tools/layers_cut.py`: every frame with a MASK1 part mask (each pixel = the body part IN FRONT there)
  is split into two layers - the blue man's pixels and the red man's - so the man behind is cut exactly where the near
  man covers him; each layer frame records the man's feet point (metres from the picture's centre).
- `tools/pics2d_anim.gd layers=1` saves a part mask beside every frame: the jab at Long and Mid re-rendered with masks
  (12 runs, 132 frames, 0 refused).
- `proto/twohands/layers_ui.js` (only with `?layers=1`): two pictures, each man on the page's OWN spot (his guard spot +
  the metres ring_ui keeps for him, redM / blueM) plus his run's movement since its first frame; between two runs the
  gap is carried and eased out over three pictures (a clip blend, as fighting games do). A run not cut yet plays the old
  two-man picture.
- `jump_rec.mjs` / `jump_ana.py` read the layers (each man's feet from img/layers/frames.json).

## The gate (6 random bouts, a jump = a man's feet moving > 4 screen px across a run boundary)
| | boundaries | jumps | between two jab / hold runs |
|---|---|---|---|
| today's page (no layers) | 78 | 54 | 33 touching the family |
| ?layers=1, no blend | 72 | 69 (feet) | 6 |
| ?layers=1 with the blend | 65 | 77 | **0** |
The family passes: 0 jumps where both runs are layered. Jumps where a layered run meets an old two-man run went UP
(a layered man on his spot next to a picture that bakes him elsewhere) - they go away family by family in phase 1.

## Phase 1 (next, a worker: one render at a time, no game open)
Re-render with `layers=1` (masks): every punch run (pics2d_anim.gd, both sides, Long / Mid / Inside, landed / blocked /
missed / short), the steps + push + clinch (pics2d_anim_more.gd), head moves (pics2d_head.gd), kicks (pics2d_kick.gd);
`anim_web.py` each, `layers_cut.py`; the same gate on each family; then ?layers=1 becomes the default and GLIDE / step
code in ring_ui.js retires. The Animo pack (assets/anim/animo_boxing, ANIMO_PACK_S570.md) brings the hit reactions,
staggers and knockdowns as the hit man's own runs.

## For the owner
Open http://127.0.0.1:8797/order.html?layers=1 and play: holds and jabs are two separate men who stay where they stand;
other moves still show the old picture. Your look decides phase 1.

LAYERS0 DONE
