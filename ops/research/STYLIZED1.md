# STYLIZED1 - a properly stylized fighter (painted skins) v realistic, blind, two fighters (2026-11-08)

Operator S399: "I like it" (the toon look), "i want whatever is on the image to match the fighter", "Yes, test two".
Question: does repainting the MetaHuman skin atlases in the 2D portraits' comic style (instead of the shader-only toon of
FIGHTERLOOK1, "a photo pasted on a cartoon") beat the realistic look?

## What was built
- Ludo `image edit` on the UV atlases (head + body albedo, 1024 px) of mh_boxer_01 (Josh Harper, man) and mh_boxer_13
  (Maria Ortega, woman), style ref assets/ui/style_b/_trial2/editImage-1cfc1019-v1.png. Picks colour-matched to the source
  (mean, std x0.85) + median 5; registration 0-2 px (FFT of edge maps); features checked on a checkerboard overlay.
  Files + Ludo job ids: assets/models/metahuman/toon/ (SOURCES.md).
- Ludo faults met: round 1 painted open irises on the closed-lid UV (double eyes in 3D) and a circular face mask (ring
  seam); round 2 painted the reference's man's buzz cut on the woman's bald scalp atlas (her hair is cards) - fixed by
  dropping the reference image for her. Prompts that held: "closed lids, no irises", "one uniform tone to every edge, no
  mask", "no outlines", "hair is a separate mesh, paint no hair".
- ArtStyle.gd: under `art=toon` a body with toon/<body>_<atlas>_toon.png wears it (no blur, no mean-tone wash) and its hair
  and brow cards go flat colour (toon shader `tex_alpha_only`, colour = the cards' covered mean). Normal and roughness were
  already dropped by the toon shader. Bodies are told apart by MHRig's `mh_body` mesh tag (the GLB's textures are only
  "mh02_head_albedo"). `nopaint` = the shader-only toon (arm B). Realistic default untouched.
  Test: tests/art_toon_paint_test.gd (both painted bodies, an unpainted control body, realistic unchanged) - 0 failures;
  fighter_look_test 0 failures.
- corner_film.gd `cast=mh_boxer_01,mh_boxer_02`: red/blue bodies by Faces.CAST (the two never meet: men box men).

## Films (seed 7, `film short`, 1:36, E:/FightCamp/tmp/stylized)
Two bouts per arm, the painted body in the red corner (corner-minute close-ups 0:58-1:04): bout 1 Maria v Erin, bout 2
Josh v Danny. A = realistic (main), B = `art=toon nopaint`, C = `art=toon` (painted). Blind set: neutral names, C duplicated
as control, key outside the critics' folder, both portraits given.

## Scores (look /10; portrait match /10 in brackets)
| Arm | Critic 1 (Sonnet) | Critic 2 (Sonnet) | Claude (eyes) | Mean of critics |
|---|---|---|---|---|
| A realistic | bout1 6 (4), bout2 5.5 (3) | bout1 6 (5), bout2 7 (6) | 4 | **6.1** (match 4.5) |
| B toon shader-only | 4 (3), 5 (6) | 3.5 (4), 5.5 (6.5) | 3 | **4.5** (match 4.9) |
| C toon + painted | 4.5 (4), 6 (7) | 4.5 (5.5), 4.5 (6) | 3.5 | **4.9** (match 5.6) |
Rankings: bout 1 A > C > B (both); bout 2 critic 1 C > A > B, critic 2 A > B > C.
Coverage: critic 1 ran bursts at ~0:20 and 1:01 only; critic 2 judged faces from single crops at 1:01 + overview sheets
(no dense bursts) - the corner close-up carries most of each score.
Control: both critics found the duplicate by checksum (md5), so it did not test consistency blind - next time re-encode
the copy.

## Verdict: C does not win (rule: beat A by >= 0.5 AND beat B)
- C v A: -1.2. C v B: +0.4 (bout 1 +0.75, bout 2 tie). Painting fixes "photo face on a cartoon" (critic 1 named it on B
  only) and gives the best portrait match (5.6), but no arm reads as the portrait's person.
- Why it still loses (both critics + Claude's crops): skin too pale peach v the portraits' tan (the toon light lifts it);
  no form shadow - three light bands with low contrast make faces and torsos "flat slabs"; washed grey-blue eyes; the ink
  line along the jaw reads as stubble/scribble; singlet straps torn; heavy black lash cards. The portrait style is ink
  contours + 2-3 strong cel shadow shapes + rim - lighting and line, not only albedo.
- Cost seen: 7 Ludo credits for 2 bodies (14 images, 0.5 each, three prompt rounds) = ~3.5 credits/body with retries
  (2 credits/body if the first n=2 round holds). All 23 MetaHumans (19 boxers + 4 staff; 23 head atlases, 21 distinct body
  atlases): ~70-80 credits + ~15 min QA per body.

## Recommendation
Keep realistic (A leads in 3 of 4 critic rows). Do not paint the other 21 bodies now. If stylized is pursued, the next
test is free code, not credits: toon light retuned for darker, warmer skin with a strong 2-band cel shadow (shade 0.35-0.4,
key from one side), a thicker outline without the chin line (outline off the jaw underside), dark eye colour in toon,
then re-film the same two bodies; paint the rest only if that arm beats A by 0.5.

# STYLIZED2 - retuned toon + the brow fix (2026-11-08, commit 32ceb10e)

## The "chin scribble" was the eyebrows
On 10 of the 23 MetaHumans (boxers 11 Lucy, 13 Maria, 14, 15 Erin, 16, 17, 18, 20; staff coach_2, cutman_1) the brow cards
were exported 12-13 cm low - on the jaw, under the mouth (probe: brow lowest y v eye top y; good bodies -0.007..-0.016 m,
these -0.123..-0.132 m). Every critic, every look, saw it ("chin scribble", "chin mark"). MHRig.seat_brows moves the cards
up (lowest card 2 mm under the eye top - the good bodies' -12 mm sat on the lids of these straighter grooms) and onto the
forehead (median of the front skin under them + 1.5 mm). Realistic default changes for those 10 bodies: brows on the
forehead. Test: art_toon_paint_test checks all 23 bodies.

## Toon retune (arm D)
Camera-keyed cel form shadow (view-space key upper left, shade 0.66), light_k 0.17 -> 0.15, line 2.4 px pushed 4 cm behind
the body (silhouette only), toon eye: dark iris + off-white white, lashes x0.5 alpha, painted skins refit at std x1.1.

## Blind round (new build: Rokoko merges + brow fix; seed 7, both bouts; control = D re-encoded, so md5 differs)
| Arm | Critic 3 (Sonnet) | Critic 4 (Sonnet) | Mean | Portrait match | Claude (eyes) |
|---|---|---|---|---|---|
| A2 realistic + brow fix | 6.5 / 7 | 5.5 / 6 | **6.25** | 3.0 | 4.5 |
| D retuned toon + painted | 5 / 5 | 5 / 5 | **5.0** | 5.5 | 4 |
Control held: both critics scored the re-encode equal to its twin (they spotted it by pixel diff, not checksum). Both ran the
dense bursts on all six films. D v A2: -1.25 -> D does not win. D v C (round 1): +0.1.
Critics on D: "coherent but crude", blotchy flat skin patches, dithered brow/lash fringe, flat unshaded bodies, paler than
the portrait, no bold outline. On A2: "polished but dark/murky", rim halo, and "breaks the link to the 2D portraits" (3/10).

## Verdict and recommendation
Stylizing the 3D does not pay: two rounds, -1.2 and -1.25 v realistic, ~7 credits spent. Keep realistic; toon stays OFF.
The real gap the operator named ("whatever is on the image to match the fighter") is the portrait match - realistic 3/10.
Cheaper direction: move the 2D portraits toward the 3D (paint over the studio renders assets/ui/face/studio/<body>.jpg with a
light comic pass that keeps the real face and tan), judged blind on "same person". Second: the realistic fight reads dark and
murky to every critic in both rounds - a grade/exposure pass is a cheap look gain.
