# How fighters look: generator, Character Creator, physique, portraits, kit

**Canonical page.** Read this before assigning or building anything on this topic. New findings UPDATE the sections
below (with the study that settled them); they do not become an orphan file. Last hand update: S114, 2026-09-27.

## Settled
- **WHICH BODIES THE GAME USES (S120, from git + DECISION_LEDGER D5/D22 - read this line first):** MALE fighters are the
  MPFB generator (CC0, `assets/models/generator/`) - D5 decided S92-S93, pilot 8e6606b1 (09-26), C213 wired it 09-27,
  game default since S117 (662e969b / d960d3fd, 09-28). FEMALE fighters: MPFB female base since S120
  (`mpfb_female_pilot.glb`, same 31 seeded keys + Godot bones, CC0 female skins, painted trunks + sports top;
  sheet `docs/previews/s120/female_seeds.png`) - the Tripo twelve are no longer used for anyone. The Tripo twelve (09-08, Higgsfield tripo_3d + Ludo) were
  the default until S116. **Tripo Pro** was bought 09-26 (S91) to regenerate the twelve on a wrong free-plan premise
  (S90); S92 chose MPFB instead and the operator ruled "keep tripo pro, use it for the gym props" - it made the gym
  props S94-S96 (heavy/speed/double-end bags, locker, dummy, racks, bike, rower, physio table, recovery props, worn tiers).
  C223 clips are certified on the four MPFB generated bodies (runs 7+); runs 4-5 measured on Tripo f01/f10 (then default).
- **The twelve Tripo fighters are ours and shippable:** made with Higgsfield tripo_3d (paid) + Ludo, not the Tripo free plan (memory
  `project_tripo_free_plan_terms`); reviewed - `R76_FIGHTER_REVIEW.md`, `R95_THE_TWELVE_REVIEWED.md`, `C58_THE_TWELVE_SEEN.md`
  (kit reads right); regenerated/retextured - `R77_REGENERATION.md`, `R78_RETEXTURE.md`; all twelve share one skeleton -
  `Q63_THE_THIRTEENTH_FIGHTER.md`; skinning measured - `C98_FIGHTER_SKINNING.md`. Tripo Pro regeneration - `G125_REGENERATING_THE_FIGHTERS.md`.
- **A fighter generator without Reallusion:** Reallusion's EULA bans a live in-game generator - `J45_OUR_OWN_CHARACTER_CREATOR.md`;
  ship one from MakeHuman / MPFB2 CC0 assets - `G85_OUR_OWN_CHARACTER_CREATOR.md`, `G126_A_FIGHTER_GENERATOR_WITHOUT_REALLUSION.md`
  (S93 pilot); the game never exposes sliders - `G81_PHYSIQUE_FROM_NUMBERS.md`; the shapes that make one fighter look unlike
  another - `G127_THE_SHAPES_THAT_MAKE_A_FIGHTER.md`; CC physique generator - `C179_DIGEST.md`; stature - `U156_DIGEST.md`.
- **Portraits** that are the same man as the 3D fighter - `G128_A_PORTRAIT_THAT_IS_THE_SAME_MAN.md`, `D38_FRESH_EYES_THE_ROSTER_PORTRAITS.md`,
  `D40_FRESH_EYES_THE_GENERATED_CARDS.md`.
- **Kit:** gloves are ruleset data (every ruleset legal) - `Q154_DIGEST.md`; both corners wear ruleset gloves - `U176_DIGEST.md`;
  glove dimensions - `G80_GLOVE_DIMENSIONS.md`; dressing the generated fighter per ruleset (CC0 MPFB clothes; waistband nickname,
  gym crest) - `G129_DRESSING_THE_GENERATED_FIGHTER.md`, `M37_DRESSING_THE_GENERATED_FIGHTER.md`; gi and shin guards - `Q50_GI_AND_KIT.md`.
- **Names:** fighters fictional with a swap file; organization names real, no logos (operator 2026-09-25).

## Open
- Reallusion licence (blocks shipping any Character Creator fighter), CC fighter verdict, SMPL-X licence - all the operator's.
- Dressed fighters in the fight (status deck gap: "generator bodies, undressed").

## Engine
`FighterRig.gd` / `Rig.rig_profile`, `FighterPhysique.gd`, `CaptureFighterRoster`, `assets/models/fighters/`, `Tools/cc_bridge/`.

<!-- GENERATED BELOW - python Tools/topic_pages.py; edit only above this line -->

## Studies on this topic (37, newest first, generated)

- `M37_DRESSING_THE_GENERATED_FIGHTER.md` (2026-09-27) - M37 DRESSING THE GENERATED FIGHTER, PER RULESET
- `G129_DRESSING_THE_GENERATED_FIGHTER.md` (2026-09-27) - G129 - Dressing the generated fighter (Grok, Expert mode, collected S94 2026-09-27)
- `U176_DIGEST.md` (2026-09-26) - U176 — both corners wear ruleset gloves
- `G128_A_PORTRAIT_THAT_IS_THE_SAME_MAN.md` (2026-09-26) - G128 - A CARD PORTRAIT THAT IS THE SAME MAN AS THE 3D FIGHTER
- `G126_A_FIGHTER_GENERATOR_WITHOUT_REALLUSION.md` (2026-09-26) - G126 - A FIGHTER GENERATOR IN THE GAME WITHOUT PAYING REALLUSION
- `G125_REGENERATING_THE_FIGHTERS.md` (2026-09-26) - G125 - REGENERATING THE FIGHTERS ON TRIPO PRO, AND HOW PROMOTIONS SHOOT ROSTER PORTRAITS
- `G105_CLUB_SHOW_WALKOUT.md` (2026-09-26) - G105_CLUB_SHOW_WALKOUT
- `D38_FRESH_EYES_THE_ROSTER_PORTRAITS.md` (2026-09-26) - D38 - FRESH EYES ON THE ROSTER PORTRAITS (Dola)
- `G95_BRIEF.md` (2026-09-25) - G95 - CAN A COMMERCIAL GAME USE A HUMAN BODY MODEL TO MAKE ITS ANIMATION? (Grok research brief)
- `G95_BODY_MODEL_LICENCES.md` (2026-09-25) - G95 - body-model licences and legal two-person mocap routes (Grok, 2026-09-25)
- `U156_DIGEST.md` (2026-09-24) - U156 — stature: engine, mount target, tape measure
- `J45_OUR_OWN_CHARACTER_CREATOR.md` (2026-09-24) - J45 — Can we SHIP our own character creator? Licences of the open body bases
- `G85_OUR_OWN_CHARACTER_CREATOR.md` (2026-09-24) - G85 - can we ship our own character creator? Licences of the open body bases (Grok, delivered)
- `G81_PHYSIQUE_FROM_NUMBERS.md` (2026-09-24) - G81 - the fighter's NUMBERS become a Character Creator BODY: sliders, values, licence (Grok)
- `C179_DIGEST.md` (2026-09-24) - C179 Character Creator physique generator
- `Q154_DIGEST.md` (2026-09-23) - Q154 digest - gloves are ruleset data, not a copy in the skin module
- `G78_CC5_BY_SCRIPT.md` (2026-09-23) - G78 - Character Creator 5 by script, and into Godot (Grok, Expert), verbatim
- `U129_DIGEST.md` (2026-09-22) - U129 digest
- `U128_DIGEST.md` (2026-09-22) - U128 digest — region panel in UIKit
- `C157_DIGEST.md` (2026-09-22) - C157 digest
- `C156_DIGEST.md` (2026-09-22) - C156 digest
- `C153_CAPSULE_SET.md` (2026-09-21) - C153 — stature-scaled capsules for a standing clinch
- `J29_STANCE_AND_FOOTWORK_DEMOS.md` (2026-09-13) - J29 — Amateur Stance and Footwork Demos We Are Allowed to Use
- `C98_FIGHTER_SKINNING.md` (2026-09-13) - C98 fighter skinning measurements
- `Q63_THE_THIRTEENTH_FIGHTER.md` (2026-09-11) - Q63 — The Thirteenth Fighter: What Made the Twelve, and What a Gi Costs
- `Q50_GI_AND_KIT.md` (2026-09-11) - Q50 — THE GI AND THE SHIN GUARDS: WHAT TO BUY ON 2026-09-14
- `R95_THE_TWELVE_REVIEWED.md` (2026-09-10) - R95 — THE TWELVE, LOOKED AT
- `R78_RETEXTURE.md` (2026-09-09) - R78 — f10: fix the face by retexturing, keep the body
- `R77_REGENERATION.md` (2026-09-09) - R77 — Regeneration log: f06 and f08
- `R76_FIGHTER_REVIEW.md` (2026-09-09) - R76 — the twelve fighters, seen
- `C58_THE_TWELVE_SEEN.md` (2026-09-09) - C58 — The Twelve, Seen
- `C49_THE_REGULATOR_AND_THE_KIT.md` (2026-09-08) - C49 — The Regulator and the Kit
- `C41_UIKIT_DEAD_FACTORY_AUDIT.md` (2026-09-08) - C41 — UIKit dead-factory audit
- `R34_DIGEST.md` (2026-09-06) - R34 — THE FIGHT CAMP (Claude, 2026-09-06)
- `G6_STATUS.md` (2026-09-04) - 
- `G6_DIGEST.md` (2026-09-04) - G6 COMPLETE (bodies on origin)
- `SHOT_LIST_GROUND.md` (untracked) - SHOT LIST - GROUND (generated S114 from `GroundGraph.EDGES`; regenerate when the graph changes)
