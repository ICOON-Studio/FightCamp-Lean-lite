# C58 — The Twelve, Seen

## Section 1 — The bar

A fighter is shippable only if all of the following hold when judged in the roster render at its intended viewing size, with a closer view used to confirm rather than excuse defects:

1. **Face integrity and identity — PASS:** both eyes, nose, mouth, ears, jaw and hairline are anatomically coherent; nothing is melted, doubled, detached or visibly asymmetric by accident; the face reads as a particular adult rather than a blank mannequin or a near-copy of another fighter.
2. **Athletic silhouette — PASS:** head, neck, shoulders, torso, pelvis and limbs form a plausible trained-fighter silhouette; mass is distributed through recognizable anatomy rather than uniform inflation, and no fighter reads as a stretched, pinched or barrel-shaped base mesh.
3. **Joint and limb construction — PASS:** shoulders, elbows, wrists, hips, knees and ankles meet cleanly and bend-ready limb shapes remain plausible; there are no collapsed shoulders, twisted forearms, bowed joints, disconnected-looking limbs or visible mesh intersections.
4. **Kit read — PASS:** without consulting the filename, boxing gloves unmistakably read as closed boxing gloves, MMA gloves as open-finger fight gloves, and bare hands as ungloved; clothing and equipment fit the sport, sit on the body without clipping, and do not make all three groups look like one generic kit with handwear swapped.
5. **Hands — PASS:** wrists align with forearms and each hand has a deliberate, human outline at roster-screen size. Boxing gloves have believable volume and thumb placement; MMA and bare-hand silhouettes do not show extra, missing, splayed, fused or spike-like digits. Fingers held together may simplify into a clean grouped shape, but may not read as a mitten, paddle or damaged hand.
6. **Per-division distinction — PASS:** the two fighters of the same sex and glove group still look like different people side by side through at least two structural traits—face, head shape, shoulder-to-waist ratio, limb proportion or mass distribution—not merely hair, skin tone, kit colour or overall scale.
7. **Women as varied athletes — PASS:** every woman reads as a trained combat-sport athlete with plausible musculature and proportions, while the six women show meaningful variation in build and identity rather than one female body duplicated, recoloured or uniformly scaled.
8. **Physique and stature credibility — PASS:** girth changes preserve head size, joint scale, limb attachment and human body contours, while the division-level height spread reads through proportion and presence rather than making one apparent person look uniformly enlarged or reduced.
9. **Production finish — PASS:** exposed surfaces have no holes, floating pieces, severe clipping, broken normals, texture seams, accidental transparency or distracting material mismatch; minor lighting, background and camera shortcomings are not mesh failures, but the fighter must remain visible enough to judge.

**Outright rejection:** regenerate any fighter with malformed or unreadable hands, a broken or duplicated face, impossible anatomy, severe clipping or surface corruption, the wrong glove/kit identity, an obviously distorted silhouette, or such close structural duplication that a same-division pair reads as one person reskinned. If the render is too dark, small or occluded to establish these points, the fighter is not cleared; the required outcome is a new usable render rather than a guessed verdict.

## Section 2 — The verdict

- `f01_m_box_welter` — **BORDERLINE:** the body and boxing silhouette work, but the upward-rolled, bright eye whites make the face look vacant even in the full-resolution posed view.
- `f02_m_box_heavy` — **KEEP:** broad shoulders, thicker trunk and heavier legs read as a powerful heavyweight without becoming barrel-shaped.
- `f03_f_box_fly` — **BORDERLINE:** she is a distinct, compact flyweight boxer, but the bright, high-set gaze weakens an otherwise coherent face at roster size.
- `f04_f_box_middle` — **KEEP:** her broader athletic frame, braided hair and clean glove silhouette make her distinct from f03 in both identity and division.
- `f05_m_mma_light` — **BORDERLINE:** the fighter reads well overall, but the exposed MMA fingertips become angular and slightly spike-like in the dedicated hand view.
- `f06_m_mma_lhw` — **KEEP:** stature, shoulder width, blond identity and open-finger gloves produce a clear light-heavyweight silhouette distinct from f05.
- `f07_f_mma_straw` — **KEEP:** the compact, powerful lower body and clear open-finger glove shape read as a specific strawweight athlete.
- `f08_f_mma_bantam` — **KEEP:** the short-haired face and straighter, leaner torso distinguish her from f07, while the red MMA gloves remain legible at roster size.
- `f09_m_bare_welter` — **KEEP:** the bearded identity and lean welterweight frame are coherent, and the grouped bare fingers still form a readable human hand silhouette.
- `f10_m_bare_heavy` — **KEEP:** the thick neck, trunk and legs sell heavyweight mass, while the ungloved hand remains readable in the posed roster view.
- `f11_f_bare_feather` — **KEEP:** her lean waist, longer athletic lines and restrained bare-hand outline make a clean, distinct featherweight.
- `f12_f_bare_welter` — **KEEP:** her blond identity, fuller hip line and blue fitted kit separate her from f11 without losing the trained-athlete read.

1. **Boxing versus MMA:** the boxing four unmistakably read as boxers because of the large closed gloves, and the MMA four read as MMA because their fingers are exposed. The clothing itself is generic across the roster—mostly the same loose shorts, with sports bras for women—so the sport distinction depends almost entirely on handwear rather than a genuinely different kit language.
2. **Bare hands:** yes, all four are acceptable at roster-screen size. The fingers are visibly simplified and held as one close group, especially on f10–f12, but each posed silhouette still has a thumb, a palm and a deliberate finger edge; none reads as an extra-digit mutation or an unreadable mitten at the intended size.
3. **Women:** the six read as athletes rather than one reused body. f03 is compact and lean, f04 broader through shoulder and leg, f07 short and powerful, f08 straighter and lighter, f11 long-waisted and lean, and f12 fuller through the hips; faces, hair and stature reinforce rather than substitute for those structural differences.
4. **Girth:** `apply_girth` is a shippable effect in `girth_range_f01.png`. From 0.94 through 1.18 the chest, waist, shoulders and limbs gain believable breadth while the head, joints and attachments stay stable; 1.18 reads as a thicker athlete, not a barrel. The f02 comparison also shows that 1.184 does not double-inflate an already-heavy mesh.
5. **Stature:** the spread reads clearly in `lineup.png`: the fly/straw fighters sit visibly below the heavyweights, with useful intermediate steps across the roster. Because head, trunk and limb proportions plus identity vary with the height, the result does not look like one man uniformly scaled.

**Regenerate list:** none.

**Follow-up:** diversify the boxing/MMA/bare clothing language and check the shared eye/gaze presentation before final roster-screen art lock; neither issue justifies spending regeneration credits on an individual mesh from this set.
