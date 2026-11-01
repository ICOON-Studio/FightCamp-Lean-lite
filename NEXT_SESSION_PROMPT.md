# S338 - next session (written S337, 2026-11-01)

Start: `git pull && python Tools/agent_comms.py start` in E:\FightCamp\Game, then work in E:\FightCamp\Lean.
S337 shipped update 39 (68/68): NEXT STEP card on her page, a reason on every greyed button, the boxing move map
(`-- jump=strikemap`), the ground push-out; rules for wrestling chains (WrestleChains) and the shared plan board (PlanBoard).
Digest: Game\Godot\research\S337_DIGEST.md.

1. HAIRFIX first. New-format MetaHuman hair grooms (they ship `<hair>_RooUVSeedCoverage.dds`, ColorXYDepthGroupID, TangentCoordU:
   Hair_L_Straight, TwistedBraids, UpdoBraids, UpdoBuns) render 9-11% of their card faces: bald crowns, the "shaved" heads he
   complained about. `Tools/metahuman/mh2_textures.py` cards() reads coverage from the CardsAtlas_Attribute RED channel (right
   for older grooms, 43-50%); green gave 94% solid ribbons. Find the real coverage (UE groom card docs / the MetaHuman hair
   material graph name the channels), fix cards(), then `MH4_TARGET_DIR=E:/FightCamp/Lean/assets/models/metahuman python
   mh4_run.py finish mh_boxer_21`, Godot `--import` in Lean, bake `tools/bake_headshots.gd -- stems=mh_boxer_21` on the hidden
   desktop, open the jpg: the crown must read as hair. Measure first: S337 scratch method (Blender exports each card face's UV
   centre, Python samples the atlas) - visible share of card faces should reach ~40-50% like the pixie.
2. FACES3 (operator: "add more whites", "no keep them all dont rebuild"): build Ellie (mh_boxer_22) and Jade (23) - configs exist -
   lineup of Holly/Ellie/Jade beside the current five, board question with the lineup attached BEFORE adding them to Faces.CM /
   CAST and the 4 bakes. Then a board question: re-texture only the hair of Samira, Megan, Priya, Chloe (faces unchanged)?
3. Q-S294-61 step 3: combo clips on the Training page (coach with pads + boxer) - check ANIMCLOUD1's owner session first.
4. Q-S294-62: the Standing tab in the ground browser (WrestleChains + clip_for on graph.json), then the plan board screen
   (PlanBoard) for boxing and wrestling - a Cursor brief.
