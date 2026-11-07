# FIGHTERLOOK1 - fighters that look like different, living people; stylized vs realistic, blind (2026-11-07)

Operator (2026-11-07): "they do look dumb tbh, the poses the glare they all look the same they have the same look etc";
earlier the same day: "i dont mind changign to stylized art if this helps with the reviews".

## 1. What makes them look alike - measured on main (f006eddd)

| What | Measured | Where |
|---|---|---|
| Faces | 19 boxer bodies (5 men, 14 women). Portrait correlation (64x64 grey, normalised) between women: mean 0.87; 15/18 0.99, 17/18 0.98, 10/19 0.98, 15/17 0.98, 15/22 0.97, 21/23 0.97 - six pairs are near copies (the S333 "make them all hotter" blends pulled toward the same faces). | assets/ui/face/*.jpg |
| Build | 10 of 14 women 58-62 kg, 165-171 cm, the same Creator body rule; men 61-81 kg. Uniform scale only (FightCast.body_scales). | mh_boxer_NN.json |
| Kit | every woman: the same corner singlet + trunks painted on the skin, white trim, the same boots; every man the same trunks. | FightStage VESTS/TRUNKS, FighterKit |
| Eyes | 345 joints, no eye or lid joints, 0 morph targets in every GLB: the eyes never move, never blink; the lid sits high = a wide white-ringed stare in every close-up (film_x 0:37, 0:58, 1:23). | GLB scan |
| Poses | both boxers play the same guard (pro_idle/idle), the same 10 fidgets, the same stool clips (af_sit_idle / af_sit_talk); no breathing at rest (TiredSag breathes only when tired). | GuardLife, CornerMinute |
| Glare | skin specular 0.5 (Godot F0 0.04 vs real skin 0.028), roughness 0.48, pore normal 0.45, under five 3.0-3.6 spots with light_specular 0.7 + AgX + glow; MetaHumanLook's skin presets exist but DEFAULT_LOOK is "A" (= none). Shoulders and chest read oily in every close-up. | mh_skin.gdshader, RingSet |

## 2. Variety and life (on the existing MetaHuman rigs; no new bodies, no generators)

- `scripts/rules/FighterLook.gd` (pure, tested): her look from her OWN data (name hash, style, stats, record, age, club):
  skin shade (+-7% value, +-3.5% warmth), skin shine (specular 0.30-0.36, roughness 0.54-0.64, pores 0.12-0.28),
  hair colour (5 natural multipliers), club trim (5), boots (5), scars from bouts boxed (0 / 1 from 6 bouts / 2 from 12),
  posture by style (forward = pressure/slugger, upright = out-boxer/counter, loose = volume, guarded = boxer-puncher)
  with her own numbers +-35%, eyes (resting lid 0.16-0.34, 10-24 blinks a minute, look-hold 0.8-2.8 s, glance-away share).
- `scripts/fight3d/FighterFace.gd`: puts it on the body; eye surface swapped for `assets/shaders/mh_eye.gdshader`
  (iris slides in UV for gaze - the cap is mapped front-on, front vertex at UV 0.5/0.5; lid drawn in her skin colour from
  the top; lash line); scars = decals on the head bone in rest space.
- `scripts/fight3d/FighterLife.gd` (SkeletonModifier3D after TiredSag, before the guard): breath (chest + shoulders),
  four rest poses she drifts between every 3.5-8 s (weight foot, head tilt, chin, shoulders, lean), hips over one foot
  (FootPlant keeps the feet), head turns part-way to the nearest face in front within 2.6 m (the kneeling coach, else the
  opponent) and the eyes the rest, glances away, blinks (70 ms close, 110 ms open, 12% doubles). Fades to 20% while a
  punch/hit clip plays.
- `-- nolook` = none of it (the control arm, main's look).

## 3. Stylized look behind a switch

`scripts/fight3d/ArtStyle.gd`: `art=toon` (command line) or `art` in user://settings.cfg [settings]; DEFAULT "real".
Toon = `assets/shaders/toon.gdshader` (three hard light bands 0.55/0.8/1.0, no specular, soft rim, a little more
saturation; two-sided twin for hair cards) + `toon_outline.gdshader` (inverted hull, fixed 2.2 px on screen) on people and
kit; ring pieces keep StandardMaterial3D (the camera fades them) with built-in toon diffuse; ambient lifted to 0.75, SSIL
off. Every rig, clip and scene is the same.

## 4. Blind test

Films: tools/corner_film.gd `film short` (round 1 skipped, the corner minute, round 2 opens), real speed, 1:36, Lucy Jackson v
Erin Doyle, E:/FightCamp/tmp/fighterlook. Arm a = `nolook` (main's look), b = varied realistic, c = varied + `art=toon`.
Critics: fresh general-purpose agents, `eyes` skill only, neutral names, key outside their reach, a repeated film as control.

### Round 1 (r1 = cbf29caf..2724ffb3)
| Arm | Critic 1 | Critic 2 | Mean |
|---|---|---|---|
| a main | 4 (+ control copy 4) | 5 (+ control 5) | 4.5 |
| b varied realistic | 3 | 4 | 3.5 |
| c toon | 3 | 3 | 3.0 |
Control held (both critics saw the copy as identical and scored it equal). b lost on MY bugs: eyes rolled into the whites
(0:38, 1:13 - gaze range 28/18 deg on a 0.30-UV iris under a lid that barely moved), pale grey lids on blinks (lid colour
passed as a Vector3 to a source_color uniform: no sRGB conversion), black hair tint on the grey-haired coach. c: photo faces
on cel bodies, dark skin pushed orange, ink lines through eyelids.
Faults on EVERY arm (other owners): singlets read as body paint with torn strap edges; a hole at the coach's neck/collar;
the same coach and second in both corners; Erin's head-back roof stare (stool clip); faces hidden by gloves in the intro.
Fixes r3 (f18e544d): lid rides with the iris, eyes 20/9 deg and the head the rest, per-body eye height (probe:
tools/eye_frame_probe.gd - mesh space = skeleton space, bind = rest^-1; staff eyes 7 cm higher), lid colour as Color,
crew keep their hair, FaceFill (soft no-specular fill a metre behind the live lens); toon skin painted 60% in its mean
tone, texture blurred, light at the real arm's exposure, 1.6 px line. Round 2 films use `seed=7` (corner_film), so every
arm meets the same opponent (round 1 met Erin by chance; an unseeded run met Priya).


### Round 2 (r3 = f18e544d, seed=7, Lucy v Erin in every arm)
| Arm | Critic A | Critic B | Mean |
|---|---|---|---|
| a main | 4 | 4 | 4.0 |
| b varied realistic | 4 (+ control 4) | 4 (+ control 4, ranked 1st) | 4.0 |
| c toon | 3 | 3 | 3.0 |
Eye bug gone; b ties main. Asks: visible breathing, eyes on the one talking (Lucy ignored the second beside her - the
target pick was front-only), more light on corner faces, a little sheen back ("matte and waxy" v main's "oily vinyl").
Built r4 (ad170f09): heavy recovery breathing on the stool (x1.9 rate, x2.3 depth, the head riding it), the talking face
and faces at her side count, skin spec 0.37-0.42 / rough 0.47-0.55, face fill 0.95; staff shirt two-sided (b3220c3e).

### Round 3 (r4)
| Arm | Critic A | Critic B | Mean |
|---|---|---|---|
| b varied realistic | 4.5 (+ control 4.5) | 4 (+ control 4) | 4.25 - both ranked it FIRST |
| a main | 4 | 4 | 4.0 |
| c toon | 3 | 3 | 3.0 |
New fault of mine: the head turn pulled her mouth off the water bottle (CornerMinute aims it at the clip's mouth) -> r6
(8b333b20) holds the head to the clip while a corner prop is within 0.35 m of it. Designer pass r5 (9f60aacd): 17-28
blinks a minute + a blink on every new look, a warm key and cool rim riding the live lens (FaceFill).

### What still caps every arm (the critics' 8/10 recipe), and the designer's plan (fresh agent, ranked by score per day)
1. A different team per corner (both corners show the same coach and second, recoloured) - code, 1 day, ~+0.5 (CornerCrew).
2. Key + rim on corner faces, one grade, sweat only where sweat sits (forehead, nose, cheekbones, chest) - 1.5 days, ~+0.8
   (key/rim done r5; a sweat mask needs the head UV map).
3. Liveness guarantee + clip repairs: no hold over 1.2 s, the opponent's head-back roof stare capped, the second's floating
   hand given a prop, intro faces not behind gloves - code + clip team, 1.5 days, ~+0.6.
4. Per-fighter bone scales under the kit (shoulders, ribcage, waist, hips 3-8%) - 1.5 days, ~+0.4.
5. Mouths that move: re-export the MetaHumans WITH the face joint set, bake ~12 shapes (jaw open, funnel, wide, lip press,
   blinks, brows) to morph targets in Blender, drive the jaw from the coach's line (~4.5 syllables/s) - asset + code, 4 days, ~+1.0.
   The bodies have NO face joints and 0 morph targets today: no mouth can move.
6. Real cloth kit: singlet and trunks as their own meshes 5-8 mm off the body with a sewn hem, Ludo fabric maps - asset,
   4 days, ~+1.0. (Both critics, every round: "body paint on a sculpted nude torso, torn strap edges".)
Designer's estimate: ~5.5 after 1-3, ~7.5 after all six; 8 hinges on the mouth reading as speech (a voice line helps).

### Round 4 (r6 = 8b333b20, the last round: the operator's plan budget)
| Arm | Critic A | Critic B | Mean |
|---|---|---|---|
| b varied realistic | 5 (+ control 5) | 4 (+ control 4) | 4.5 - both ranked it FIRST |
| a main | 4 | 3 | 3.5 |
| c toon | 3 | 2 | 2.5 |
Every round from 2 on ranked varied >= main > toon; controls always scored equal to their twins (8 of 8).

## 5. Verdict
- Keep the realistic MetaHuman look; the variety + life layer is ON (beats main by +0.25 to +1.0 a round, never below it
  after the r3 eye fix). The toon switch stays OFF (ArtStyle.DEFAULT "real"): 3.0 / 3.0 / 3.0 / 2.5 - cel shading on
  photo-scanned MetaHuman faces reads as "a photo pasted on a cartoon"; a stylized look needs stylized heads, not a shader.
- Nothing reached 7: the cap is in the assets, not the look layer - painted-on kit (every critic, every round), no face
  joints (no mouth can move, blinks are painted), the same corner team in both corners, the collar seam on the staff mesh.
  Next, by the designer's ranking: a team per corner (CornerCrew), mouths (MetaHuman re-export with face joints -> morph
  targets), cloth kit (Ludo/Tripo fabric on a fitted shell), per-fighter bone scales. Known: blinks of 0.18 s are rarely
  caught by sampled frames - a 0.3 s blink would read better.
