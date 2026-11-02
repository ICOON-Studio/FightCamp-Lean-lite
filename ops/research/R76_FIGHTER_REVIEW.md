# R76 — the twelve fighters, seen

Claude, 2026-09-09. Renders: `previews/fighters/` (94 PNGs, commit
`a10805c`, pushed before this document existed so C58 could judge them cold).
Tool: `Godot/tools/CaptureFighterRoster.gd`.

**Headline: nine keep, two regenerate, one needs a face reroll. `apply_girth`
ships. The bodies and the rig are better than the numbers promised; the hair is
the roster-wide weak point, and the bare-hand group is the weakest as a group —
not because the hands failed, but because nothing marks them as fighters.**

## How they were rendered

Neutral three-point studio light, mid-grey ground, vertical FOV 26°, each
fighter loaded with `GLTFDocument`, scaled by `FighterPhysique.describe` and
stood on y=0 — the same chain as `tests/fight_world_mount_test.gd`. Four T-pose
views (front / 3-4 / side / back), one frame held off `walk_relaxed`, plus head
and hand close-ups. Every capture prints its mean luma, so the black-frame trap
cannot pass silently; the range came out 0.26–0.51.

Two honesty notes on the method. **The key light is bright (1.5 + 0.55 ambient
+ a 0.9 rim), so pale albedos blow out** — some of the "waxy" verdict below is
my lighting. But the same lights flatter f01, f04 and f09, so where I call a
fighter pale the difference is in the asset. And **the 320 px contact-sheet
cells exaggerate face defects**: several mouths that read as smears in
`contact_faces.png` are ordinary mouths at full resolution. Every verdict below
was made against the full-res file, not the sheet.

## The verdicts

| # | file | verdict | why, in one line |
|---|---|---|---|
| f01 | m box welter | **keep** | Best male in the roster: clean face, correct welterweight build, gloves and trunks read boxing instantly. |
| f02 | m box heavy | **keep** | Genuinely heavy frame with the mass in the right places; bald-and-bearded gives him a silhouette nobody else has. |
| f03 | f box fly | **keep** | Small, lean and correctly tiny at 1.578 m; kit and proportions right for a flyweight. |
| f04 | f box middle | **keep** | Characterful face with a slightly crooked nose that suits a boxer; the faceted hair shell is her only real defect. |
| f05 | m mma light | **keep** | Good lean lightweight, MMA gloves read clearly; hair is chunky and faceted at close range. |
| f06 | m mma lhw | **regenerate** | Built like a lean lightweight at light-heavyweight stature — 93 kg on paper, thin arms, soft undefined torso; also the waxiest face and a dark bake gradient on the shorts hem. |
| f07 | f mma straw | **keep** | Best of the MMA women; athletic, correctly small, kit consistent with f05/f06. |
| f08 | f mma bantam | **regenerate** | Chalk-white plastic skin with no subsurface warmth, a doll-like face under a hard helmet of hair, and red gloves that break the MMA group's black kit. |
| f09 | m bare welter | **keep** | Best of the bare group; bearded, athletic, hands are properly modelled. |
| f10 | m bare heavy | **needs work (face only)** | The best back in the roster on a genuinely heavy body, but the roughest face of the twelve — heavy folds and a mushy mouth. Reroll the head, keep the body. |
| f11 | f bare feather | **keep** | Clean, athletic, reads as a fighter's build rather than a body type. |
| f12 | f bare welter | **keep** | Good face and proportions; blonde ponytail is one of the better hair pieces. |

## The four questions the task asked

**Would this stand up in a roster screen next to a competitor's product?**
Yes, with the hair caveat below. `lineup.png` is the proof: twelve fighters at
their own statures, and the height spread reads immediately — f02 and f10 tower,
f03 and f07 are visibly small, everyone graduates in between. Bodies, skinning
and kit are commercial-grade. Faces are a step behind the bodies but hold at
roster distance.

**Do the boxing four read as boxers and the MMA four as MMA?** Yes,
unmistakably, and the gloves do the work — see `contact_hands.png`. Boxing gets
full closed gloves with wrist wraps in red and blue; MMA gets black open-finger
gloves with the fingers actually protruding. The kit is not generic. Two misses:
**f08's gloves are red/white where the other three MMA are black**, and **all
four boxers are barefoot** — boxers box in boots, and this is the one clear
authenticity error in the set.

**Do the bare-hand four have acceptable hands?** **Yes — the group most likely
to have failed did not.** The fingers are modelled and held together with real
separation lines and knuckle definition, exactly as prompted. My first read off
a T-pose close-up said "flat mittens" and was wrong: seen edge-on with the arm
extended, a relaxed hand looks like a paddle. Re-shot with the arm down in the
walk pose, all four are fine. The forward-looking problem is not the mesh: **with
no finger bones the hand can never close, so a bare-knuckle fighter will throw
punches with an open hand.** That is an animation-stage decision, flagged below.

**Do the six women read as athletes rather than as a body type?** Yes, five of
six. f03, f04, f07, f11 and f12 have visible shoulder, back and leg musculature
and read as fighters at different weights. f08 is the exception and it is a
material problem, not a shape problem — the chalk-white skin flattens whatever
definition she has.

## `apply_girth` — it ships

`girth_range_f01.png` is the decision image and the answer is clean. Left to
right at 0.94 / 1.00 / 1.18 the trunk visibly widens through chest, ribcage and
waist; the head, gloves and feet stay identical, so the counter-scaling that was
verified numerically is verified visually too. There is no pinching at the neck,
no candy-wrapper at the waist, no seam at the elbow or knee. **1.18 reads as a
thicker, stronger version of the same man — not as a barrel.**

`girth_heavy_f02.png` answers the doubling-up worry: an already-heavy mesh at
its shipping 1.184 broadens through the chest and shoulders and still does not
distort. No cap or clamp change is needed.

One limitation to record, because it changes what girth is for: **the effect is
subtle, and it is a fine-tuning tool, not a body-type system.** 0.94 → 1.18 is a
25% relative trunk change and at roster distance 0.94 against 1.00 is nearly
invisible. It cannot turn a slim mesh into a light-heavyweight — which is
exactly why f06 fails. Build variety has to come from the mesh.

## Roster-wide findings

1. **Hair is the weakest asset class.** Every tied-back and short style is a
   faceted low-poly shell with hard triangle edges and a jagged silhouette —
   clearest on f04's crown and f05's curls. It holds at roster scale and falls
   apart in a close-up. This is the single highest-value thing to improve, and
   it affects nine of twelve.
2. **Three fighters are conspicuously pale** (f06, f08, f10) against warm
   mid-tones on f01, f04 and f09. Read as a set they look like two different art
   directions rather than ethnic variety, because the pallor arrives with a
   washed-out low-contrast material.
3. **Male build variety is thin.** f01, f05 and f09 are near-identical builds at
   three different heights. Stature separates the roster; mass does not.
4. **The bare four carry no fight signal.** No gloves, no wraps, no tape, gym
   shorts and sports bras — in `contact_posed.png` they read as people at the
   gym, not as bare-knuckle fighters.
5. **The twelve original prompts were never written down.** They are not in
   `HANDOFF.md` and not in `research/`. The regenerate list below is
   therefore self-contained prompt text rather than a diff against an original.
   Record the prompt with the file from now on.
6. **Skinning is sound.** Across twelve fighters in the walk pose, no collapsing
   shoulders, no hip pinching, no twist artifacts. Backs are clean —
   `contact_back.png` shows no seams, no missing geometry, no texture failures.

## The regenerate list

Two full regenerations and one head. At 6 credits each (5 Tripo + 1 Ludo) that
is **18 credits**. Ludo's two traps still apply: clear the staged Reference
Model slot before dropping, and reload `/3d-generator` before pulling a result.

**f06 — m mma lhw.** The physique is the reason; fix it in the prompt, do not
try to fix it with girth.
> Athletic male mixed martial artist, light heavyweight, 1.90 m, 93 kg, heavily
> muscled with broad shoulders and a thick chest and back, visible abdominal
> definition, powerful thighs. Tanned mediterranean skin with warm mid-tone
> colour, not pale. Short dark hair. Black open-finger MMA gloves, plain dark
> fight shorts with a solid colour and no gradient. T-pose, arms horizontal,
> fingers held together, barefoot.

**f08 — f mma bantam.** The skin and hair are the reason; the shape is close.
> Athletic female mixed martial artist, bantamweight, 1.65 m, 61 kg, lean and
> muscular with defined shoulders, arms and abdominals. Warm olive or light-brown
> skin with natural colour variation, NOT pale or chalk-white. Dark hair pulled
> back into a tight ponytail, not a solid helmet shape. **Black** open-finger MMA
> gloves to match the rest of the MMA group, dark fight shorts and a fitted top.
> T-pose, arms horizontal, fingers held together, barefoot.

**f10 — m bare heavy, head only.** Keep the body; it is the best back in the
roster. If Tripo cannot reroll a head in isolation, regenerate whole with the
body description held and this added:
> …clean-shaven heavyweight face with defined cheekbones and jaw, a straight
> modelled mouth, smooth skin without heavy folds around the nose and mouth.

## Follow-up tasks (not done here — this was a research session)

- **Boxing boots for f01–f04.** Barefoot boxers are the set's one authenticity
  error. Either a re-prompt with boots or a separate footwear mesh; decide which
  before more fighters are generated.
- **A fight-kit signal for the bare four.** Hand wraps or tape would cost one
  prompt line and would make the group read as bare-knuckle rather than gym.
- **The fist problem.** No finger bones means the bare four cannot close a hand.
  Decide before strike animations: bake a fist-ready hand into the bare meshes,
  add finger bones for that group only, or accept an open-hand punch.
- **A hair pass.** Whether to accept faceted hair shells at roster scale or
  re-prompt for hair with a cleaner silhouette. Affects nine of twelve, so it is
  worth deciding once rather than per fighter.
- **Male build variety.** Three near-identical male builds at three heights. A
  future roster wants at least one squat, thick-set body and one rangy one.
