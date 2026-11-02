# S338 DIGEST - update 40: the hair fix (no more "shaved" heads), three new boxers, chain wrestling tie-ups, the coach's plan board

2026-11-01. Lean main (see the export line at the bottom). Game master abe9dff2..d5c9f329.

## Operator (verbatim)
- Asked mid-session: Sidekick martial-arts mocap packs ("should i buy any of these"), Animium kick mocap, IJF Yoko-guruma.
  Answer given: buy none now - boxing is covered by the owned MoCap Online Punch PRO (145 clips) + Punch Starter; Sidekick
  ships iClone format (needs an iClone 8 licence to export; S131 passed on it), Animium's terms ("you are not buying the models
  only paying for the bandwidth") do not clearly allow a sold game, IJF is "All rights reserved" (reference only). Revisit
  kicks/clinch packs (FBX + clear game licence) when the MMA update starts.
- Board: Q-S294-63 asked (add Holly, Ellie, Jade to the cast? lineup attached).

## HAIRFIX - the real cause (S337's "newer card format" theory was wrong)
- Red IS the coverage channel in every groom's CardsAtlas_Attribute (G/B are dilated root-UV/seed). The newer files
  (Roo(t)UVSeedCoverage / TangentCoordU|StrandU / ColorXYDepthGroupID) are a whole-hair unwrap no card UV indexes:
  R,G = each strand's ROOT in face UV (v from the top), B seed, A coverage (measured: correlation ~0 with the atlas; card UVs
  overlay the atlas cells exactly).
- Holly's bald crown: mh2_glb joined card groups and Blender merges UV layers BY NAME - Group1's atlas UV is called
  "LightMapUV" (Group0 has UVmap_0 + LightMapUV), so it landed in the layer the "first UV only" step deletes: 22,960 of 34,790
  hair triangles sampled 0% coverage. Fix: each group keeps its own first layer, renamed "AtlasUV", before the join.
- Samira/Megan (TwistedBraids), Priya (UpdoBraids), Dana (Updo): built before S337, Group0 only - their Group1 (the braids,
  the fringes) was never in the game. Rebuilt from the SAME Unreal export (faces unchanged); budget 6 MB -> 6.5 MB
  (braids 6.25 MB). Chloe's UpdoBuns is one group and renders full - not affected.
- Erin (PulledBack): buzzed sides are the groom's own (the root map has no strands above the ears); a scalp tint from the root
  map was tried and dropped (painted temple edge). Unchanged.
- Before/after: previews/S338_hairfix_before_after.jpg (sent, review board).

## FACES3
Holly (21), Ellie (22, Hair_M_Layered), Jade (23, Hair_L_StraightBangs) built (Unreal ~4 min each), ring photos baked,
lineup S338_faces3_lineup.jpg on the board (Q-S294-63). Not in Faces.CM / CAST until his answer.

## Wrestling + the plan board (Q-S294-62 steps 1-2)
| Commit (Lean) | What |
|---|---|
| 29af06f + 6998d28 | TIEUPS1 (Cursor): Tie-ups tab in the ground browser - 6 tie-ups, 30 answers (27 play a GrappleMap clip, 3 greyed "No clip of this yet"), link buttons chain tie-ups, `jump=grapple tie=<id>`; mine: picking a tie-up stands the women where its first clip starts (they lay in mount), tools/tieup_still.gd |
| d604a1c + 6709b18 + 3be0691 | PLANSCREEN1 (Cursor): Build plan on the boxing move map - arrows (limit by coach, 6 at 55), coverage, untrained marks, remove, full-plan reasons, `jump=strikemap plan=1`; mine: plan arrows green, stay-on-card moves drawn as loops (8 of 30 never showed), no duplicate arrows, planned moves stay usable, reasons once; tools/plan_still.gd |
| PLANSCREEN2 merge | Cursor: the same panel on the tie-ups - each answer an arrow keyed by the opponent's reaction (two arrows from one tie-up when the reactions differ), limit 6 at coach 55, `jump=grapple tie=<id> plan=1`; tieup_plan_test; still t05 |

## Traps
- A chained `commit; push` after a test command pushes even when the test is red (6709b18 went out with plan_screen_test red;
  fixed in 3be0691). Gate the commit on the test's own result.
- Blender's join merges UV layers by name - rename before joining.
- PowerShell `-replace` is case-insensitive; use `-creplace` for prompt templates.

## Operator S338 (verbatim, late): "keep all agents working on animations and you work onthe mechanics and ui"
From now: every agent seat gets animation work only; Claude writes mechanics and screens. MOVECLIPS1 (Qwen: every StrikeMap
move -> its clips, the table the 3D fight needs to show a planned move) launched under it and merged (30 moves -> clips, move_clips_test).

## Export
Two export attempts stopped on "exit 127" in random tests: Godot started (banner printed) and was killed - Cursor reports
stopping Godot runs after hangs, which kills ours too. Re-run alone passed; the third export (Cursor done) built update 40, 71/71. Lesson: export when no agent runs Godot tests.
