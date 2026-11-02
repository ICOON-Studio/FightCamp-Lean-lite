# S334 digest (2026-11-01) - update 36: ring photo, turning body view, 18-year-old prospects; BJJ sources

## His answers acted on
- Q-S294-55 "these are ok but make some younger too 16-18 yo": Kira Mensah (mh_boxer_19, Zuri base) and Samira Khan
  (was Okafor; mh_boxer_20, Asha base, braids), both 18, faces pulled toward Celeste. Two passes. They do NOT read clearly
  younger: every MetaHuman preset is an adult face and a blend stays adult. Board Q-S294-60 (shape by hand / keep).
  Decided 18, not 16-17: under-18s box youth bouts the game does not have (a youth division = his scope call); at 18
  SeasonPath keeps them out of the Elite Nationals (19 min) - a girl to bring up. The "hotter" direction stays with adults.
- Q-S294-56 / C152 (HOME polaroid "looks kind silly"): the A-pose bust is gone; tools/bake_headshots.gd shoots each boxer
  in the ring (FightStage, opponent hidden, mc_win clip at 0.8 s: glove up, face open; 21 deg lens, three-quarter from the
  rear-hand side, far DOF) -> assets/ui/face/<stem>.jpg 600x750. HomeBoard.portrait prefers it.
- Q-S294-57 / C153 (body view "still needs to be bigger maybe slightly autorotating"): panel 340x420 (was 210x294),
  TOP 150. tools/bake_body_turn.gd: 13 views -30..+30 deg (camera + key orbit), strips per corner + mask strip + places per
  view (480 px tall; 20.9 MB for 9 boxers). BodyTurn.gd cross-fades two skins over a 12 s swing; spots per view.
  Part colours averaged over a 5x5 mask patch (soft edges, was hard blocks). Shader moved to body_skin.gdshader
  (BodyFigure 479 lines). tests/body_turn_test.gd.

## Commits
- Lean c9a1e0d (ring photo), 0aee1d6 (turning body view), 8ddc745 (young prospects). Game 9bad8f06 (board), e1ecd4b2
  (configs + stills). Update 36 exported (see Lean docs/WHAT_TO_TRY.txt).

## Side sessions
- [BJJ animations] local_6e653999: research/BJJ_SOURCES_S334.md (01ca875e, 658ff1d0). GrappleMap = public domain,
  601 positions / 1,485 transitions, 23 joints a man - the missing transitions between ground holds; Sekai Blender zip
  (E:/FightCamp/downloads/bjj_blender) has no licence = reference only; bjj-link Dojo Legacy = a game, all rights
  reserved. Board Q-S294-58 (GrappleMap ground prototype now / park for MMA).
- Same session: DOJO_LEGACY_IDEAS_S334.md (53f2a177), 11 ideas in boxing terms. Board Q-S294-59 (next-step card + reasons
  on greyed buttons first).
- [Cloud agents on fight animations] local_c7e7549f (started by another S334 start): Lean .github/workflows/fight-stills.yml
  (Xvfb + Mesa, stills + motion probes on agent PRs). Its first runs were in flight at 03:08 UTC - check them.

## Found
- MetaHuman blends cannot make a face younger (adult presets only); a second pass with more Celeste changed little.
- mh4_audit.py requires boxers aged 19-34 and garment fields bare boxers lack: write a young boxer's sidecar from her base
  preset's boxer (same skin) instead of running the audit.
- The fight's high guard hides the face: a headshot needs a non-guard moment (a win clip). Raised arms past ~0.9 s tear
  the vest at the armpit (kit mesh) - visible in mc_win@1.0; open defect, not fixed.
- bake_headshots prints 'tick' on Nil SCRIPT ERRORs while a stage is freed between shots (tool only; images fine).

## Not verified
- The turn seen in stills + a GIF made from the strip (not a game recording). Polaroid seen on HOME only, not on other pages.

## Next (S335)
Board answers Q-S294-58/59/60; the fight-stills CI runs (other session); Q-S294-53 after his marks; look B polish on
GYM/MONEY/FIGHTS/WORLD; the vest tear under a raised arm.
