# Reviewer 5 — Visual & Animation

## Evidence summary: what the game is today

FightCamp is a combat-sports gym management sim whose current milestone is **"Playable with a Boxer"** (`AgentComms/roadmap.json` now.id S122). The player runs a gym, trains a boxer through the week planner and training floor, books an amateur bout, walks through fight week/weigh-in, and watches the bout in a 3D arena. The visual identity is **Direction A — brass & leather, dim warm gym** (DECISION_LEDGER D4, operator pick). Fighters are now the **MPFB-generated male bodies** (DECISION_LEDGER D5) with procedural trunks/gloves; women remain the twelve Tripo bodies. The 3D fight room uses a real 1.27 m boxing canvas, a camera rig, and retargeted animation clips certified through the C223 gate.

The animation milestone is gated by **C223**: every boxing move (36) must play its own clip that passes mechanical and visual rows on four generated legal bodies, with provenance exact and mid-band timing/speed. As of S122, **boxing is 16/36 certified** and **kickboxing is 0/20**. The active session fixed a hip-drop foot-drag defect (`FightClipFootPlant`) and added five single punches via additive pose layers (`FightClipPoseLayer`). No `.exe` or preview video is allowed until 36/36 boxing pass (DECISION_LEDGER D3).

## Missing or not verified

- No live career walk was re-run for this review; evidence comes from digests, stills, and code.
- `previews/c223/` stills were not all opened individually; conclusions rest on digest descriptions.
- Kickboxing clips have no certified rows.
- Ground/grappling clips are not part of the current milestone; the real-time grappling engine exists but has no shippable 3D clip coverage (`C223_DIGEST.md` S120: "97 combat clips and exactly ONE is grappling").
- Audio is Dummy driver; crowd/referee/walkout are not present.

## Strengths to protect

1. **Forward+ renderer** (`CURRENT_STATUS.md` R111) gives the gym rooms real lighting, glow, DoF, fog capability.
2. **Boot screen** is now a live 3D room with three fighters, offset idles, and a non-repeating camera drift instead of the old grey placeholder.
3. **MPFB generated pipeline** (D5) produces consistent, legally clean male bodies and four legal weight-class pairs.
4. **C223 gate** is a falsifiable, measured standard: speed bands, timing bands, slip, skin, join, non-overlap, guard return, and seam mutants.
5. **Additive pose layers** (`FightClipPoseLayer`) are a working, non-destructive way to derive body-shot variants from certified head punches.
6. **Foot-plant bake** (`FightClipFootPlant`) correctly keeps feet where the source put them while allowing knee bend (S122 hip-drop fix).

## Findings

### F1 — Boxing animation coverage is 16/36, blocking the milestone and .exe

- **What:** Only 16 of 36 catalogue boxing moves have passed the C223 gate on all four generated legal bodies.
- **Where:** `research/C223_DIGEST.md`; `research/S122_DIGEST.md`; `research/SHOT_LIST_STRIKING.md`.
- **Evidence:** S122 lists certified moves: jab, cross, jab body, one-two, double jab, lead hook, rear hook, lead uppercut, rear uppercut, body hook, shovel hook, up jab, overhand, inside uppercut, cross body. S121 adds rear hook body. The remaining 20 are: 4 defensive pieces + 7 counters (Q215 in flight), 7 footwork moves, feint, drawing, remaining combos.
- **Player impact:** The player will see repeated, borrowed, or missing clips for more than half of boxing techniques; the fight will not read as authentic boxing.
- **Severity:** Critical
- **Confidence:** High
- **Fix:** Continue the C223 pipeline: certify defensive pieces and counters via `c223_sequence_gate.gd`, then footwork as one gated clip per move, then feint/drawing/combos. Do not lower thresholds.
- **Effort:** Large
- **Status:** CONFIRMED

### F2 — Kickboxing has 0/20 certified clips

- **What:** No kickboxing move has passed the C223 gate.
- **Where:** `research/C223_DIGEST.md` passim; `research/SHOT_LIST_STRIKING.md` batch 5.
- **Evidence:** C223_DIGEST repeatedly states "Kickboxing EXACT-that-PASSED: 0/20 -> 0/20". Run 10 starts from the merged branch head with no kickboxing certifications.
- **Player impact:** Kickboxing bouts will reuse boxing animations or fall back to generic moves, breaking ruleset identity even after boxing is done.
- **Severity:** High
- **Confidence:** High
- **Fix:** Source owned/free kickboxing clips (Roundhouse kick, low kick, teep, switch kick, clinch knee) and run them through the same C223 gate. The RamsterZ H2H set is mostly empty-hand, not kickboxing.
- **Effort:** Large
- **Status:** CONFIRMED

### F3 — The RamsterZ jab/cross variants fail the unbound audition join gate

- **What:** Even with no layer, RamsterZ jab/cross variants fail `join_discontinuity` on the unbound path because the audition does not phase-match the guard.
- **Where:** `research/S121_DIGEST.md` "Findings to carry".
- **Evidence:** S121: "The UNBOUND audition fails `join_discontinuity` on every RamsterZ jab/cross variant even with NO layer (control uj21_0): the audition path does not phase-match the guard. Certify RamsterZ variants on the BOUND path."
- **Player impact:** If the bound path is bypassed or a new source is added, seams between clips will pop visibly.
- **Severity:** Medium
- **Confidence:** High
- **Fix:** Keep C223 certification bound-path only; update the audition harness so unbound failures are not used to reject sources that look fine bound.
- **Effort:** Small
- **Status:** CONFIRMED

### F4 — Heavy body C shows a 0.001175 m/s margin on rear hook speed ceiling

- **What:** The rear hook certificate for heavy body C sits 0.001175 m/s below the 14 m/s SHOT_LIST ceiling.
- **Where:** `research/C223_DIGEST.md` Run 9 rear-hook section; `research/SHOT_LIST_STRIKING.md`.
- **Evidence:** C223_DIGEST: "Heavy C has only 0.001175 m/s below the 14 m/s ceiling; this is a narrow four-fixture, 60 Hz certificate, not evidence of margin on other bodies or clocks."
- **Player impact:** A speed that is technically inside the band but on the edge may look wrong on other generated bodies or at different sample rates; it also invites future regressions.
- **Severity:** Medium
- **Confidence:** High
- **Fix:** Re-source or re-time the rear hook so all four bodies clear the band with margin; avoid edge-tuning.
- **Effort:** Medium
- **Status:** CONFIRMED

### F5 — The live 3D room drops ~92.6% of impacts

- **What:** `FightBeatAdapter` produces 896 impacts and shows 66 beats; the wide frame and HUD carry the fight.
- **Where:** `CURRENT_STATUS.md` R97; `research/S117_DIGEST.md`; `Godot/scripts/FightBeatAdapter.gd`.
- **Evidence:** R97 measured rate: "896 impacts, 66 shown, 830 dropped (92.6%)". M13/G45 agreed the wide frame and HUD must carry the fight.
- **Player impact:** The 3D fight reads as sparse unless the camera/HUD explain what the engine scored; without strong broadcast graphics it looks like nothing is happening.
- **Severity:** High
- **Confidence:** High
- **Fix:** Build the broadcast HUD (tale of the tape, live counters, round card, scorecard) and camera shot selection before asking the operator to judge watchability.
- **Effort:** Large
- **Status:** CONFIRMED

### F6 — Feints are invisible in the 3D room

- **What:** The engine emits ~5-6 feints per minute but the room presents none.
- **Where:** `research/S119_DIGEST.md`; `research/S117_DIGEST.md`; `Godot/scripts/FightStagePlayer.gd`.
- **Evidence:** S119: "FEINTS are invisible in the room (engine ~7/min, room presents none)." S117 probe shows 6.0 feints/min.
- **Player impact:** A key tactical layer disappears visually; the player cannot read fighter intent or game plan execution.
- **Severity:** High
- **Confidence:** High
- **Fix:** Add a feint animation clip or a subtle body/shoulder twitch to the presentation queue; keep it readable at broadcast camera distance.
- **Effort:** Medium
- **Status:** CONFIRMED

### F7 — Generated fighters are bald in the ring while portraits show hair

- **What:** The 3D bout shows bald men; the tale-of-the-tape portraits show hair.
- **Where:** `research/S117_DIGEST.md` "Remaining"; stills `docs/previews/s117_walk_game/74_begin_fight.png` vs `75_bout_live.png`.
- **Evidence:** S117: "Generated fighters: hair (the ring shows bald men while the tale-of-the-tape portraits have hair)."
- **Player impact:** The same athlete looks different in profile and in the fight, breaking identity.
- **Severity:** Medium
- **Confidence:** High
- **Fix:** Generate/port hair geometry for the MPFB bodies or use a consistent hair card; match portrait and 3D.
- **Effort:** Medium
- **Status:** CONFIRMED

### F8 — No same-class female generated pair exists

- **What:** The female roster is still the twelve Tripo bodies; there is no generated legal pair for women.
- **Where:** `research/S117_DIGEST.md`; `research/DECISION_LEDGER.md` D5.
- **Evidence:** S117: "KNOWN GAP: no same-class female pair exists (printed by the test)." Women are the twelve Tripo bodies; men are the MPFB-generated bodies.
- **Player impact:** Women's bouts cannot be certified with the same pipeline; the demo is implicitly male-only.
- **Severity:** High
- **Confidence:** High
- **Fix:** Generate female MPFB bodies and a legal weight-class pair; re-run C223 gate on them before advertising women's boxing.
- **Effort:** Large
- **Status:** CONFIRMED

### F9 — The Tripo free-plan fighters cannot ship

- **What:** The twelve Tripo bodies were made on Tripo's free plan, which carries "Public Models · Non-Commercial Use".
- **Where:** `research/S75_PHASE0.html` legal inventory; `research/DECISION_LEDGER.md` D5/D22.
- **Evidence:** S75_PHASE0: "Twelve fighters f01-f12 ... Tripo AI free plan: 'Public Models · Non-Commercial Use' ... Cannot ship." D22 confirms CC export rejected, MPFB route is default.
- **Player impact:** Until regenerated on Tripo Pro or replaced, any build containing these bodies is not releasable.
- **Severity:** Critical
- **Confidence:** High
- **Fix:** Regenerate the Tripo bodies on Tripo Pro ($20/mo) for commercial use, or finish transitioning all fighters to MPFB.
- **Effort:** Medium
- **Status:** CONFIRMED

### F10 — The shovel hook still reads as a lunging body punch, not a true shovel

- **What:** `boxing_shovel_hook` passes mechanical rows but the stills show a wide lunge with a straight arm, not the elbow-tucked rising shovel.
- **Where:** `research/C223_DIGEST.md` S120 section; `research/SHOT_LIST_STRIKING.md`.
- **Evidence:** C223_DIGEST: "boxing_shovel_hook stays NEAR: solved layer ... lands at liver height and passes every mechanical row ... but the side stills show a wide lunge with the arm straight at 0.18 s - a lunging body punch, not the elbow-tucked rising shovel."
- **Player impact:** A move that passes numbers but fails identity will confuse players who know boxing.
- **Severity:** Medium
- **Confidence:** High
- **Fix:** Add an elbow-in, rising-forearm pose layer to the certified hook base and re-certify.
- **Effort:** Medium
- **Status:** CONFIRMED

### F11 — Visual direction has four competing directions and only one is picked

- **What:** M34 produced four visual directions; the operator picked Direction A (brass & leather) but not all screens are rebuilt in it.
- **Where:** `_maria_delivery/CLAUDE_LAND_NOTE_M34.md`; `DECISION_LEDGER.md` D4.
- **Evidence:** D4: "Visual direction: M34 Direction A, brass & leather, dim warm gym (operator's pick)". RESEARCH_INDEX lists M34 as "pitch look" and FLOW passes as NOT FINISHED.
- **Player impact:** Mixed art direction across screens makes the game look like a prototype, not a coherent product.
- **Severity:** Medium
- **Confidence:** Medium
- **Fix:** Audit every screen against Direction A and rebuild legacy screens (skills, development, day feed, fight night) with the kit.
- **Effort:** Large
- **Status:** CONFIRMED

### F12 — The 3D gym rooms have no people at work

- **What:** Dola's fresh-eyes review of the six rooms found them atmospheric but questioned whether the people look at ease and whether the rooms show real gym activity.
- **Where:** `research/D59_DIGEST.md`, `D60_DIGEST.md`, `D62_DIGEST.md`.
- **Evidence:** D62: "do the people in the rooms look at ease?" D59/D60 room-by-room reviews note good props but sparse life.
- **Player impact:** A management game about a living gym needs visible activity; empty rooms feel abandoned.
- **Severity:** Medium
- **Confidence:** Medium
- **Fix:** Add animated background characters, equipment use, and staff movement in the hub rooms; keep performance budget in mind.
- **Effort:** Large
- **Status:** ASSUMPTION (based on digest summaries, not live observation)

### F13 — Defence outcomes (block/slip) are almost never shown

- **What:** Blocks and slips are computed by the engine but selected out of the broadcast because the presenter drops low-wear events.
- **Where:** `CURRENT_STATUS.md` R103; `research/S117_DIGEST.md`; `Godot/scripts/FightBeatAdapter.gd`.
- **Evidence:** R103: "block+slip pooled are 0.3%" of shown beats. The engine can promote them via `promote_in_remainder_4` but no script has changed.
- **Player impact:** The fight looks like a mutual slugfest with no visible defence; boxing reads as unrealistic.
- **Severity:** High
- **Confidence:** High
- **Fix:** Implement the operator-ruled defence-promotion rule (`promote_in_remainder_4`) with the zero-knockdown-loss guarantee, and add block/slip reaction clips.
- **Effort:** Medium
- **Status:** CONFIRMED

### F14 — The boot/intro screen lacks the final four requested figures

- **What:** The operator asked for boxer, MMA, karate (white gi + black belt), and kickboxer. Only boxer and MMA signifiers are present; karate has no gi and kickboxer is represented only by action.
- **Where:** `CURRENT_STATUS.md` R111; `research/SHOT_LIST_STRIKING.md`.
- **Evidence:** R111: "A gi is geometry, not a texture, and we own no gi model. For the kickboxer the only signifier left was the action, and every kick in the H2H pack is a FLYING kick."
- **Player impact:** The boot screen does not communicate the full stand-up v1 scope.
- **Severity:** Low
- **Confidence:** High
- **Fix:** Add gi geometry and a grounded kickboxing stance/clip to the boot stage once certified assets exist.
- **Effort:** Medium
- **Status:** CONFIRMED

### F15 — Clip provenance and asset manifest gaps remain

- **What:** Some shipped asset folders were unclaimed in the manifest until S122; new sources (Mixamo boxing pipeline, Higgsfield boxing boot, Kenney furniture kit) were added but the broader Ludo/Tripo terms are unconfirmed.
- **Where:** `research/S122_DIGEST.md` nightly reds; `research/S75_PHASE0.html` legal inventory.
- **Evidence:** S122: "asset_manifest: 3 shipped folders unclaimed -> entries added". S75_PHASE0: Ludo terms unknown, Tripo free plan cannot ship.
- **Player impact:** Unclear ownership risks shipping unlicensed assets.
- **Severity:** High
- **Confidence:** High
- **Fix:** Complete the asset manifest audit and confirm or drop every source before any public build.
- **Effort:** Small
- **Status:** CONFIRMED
