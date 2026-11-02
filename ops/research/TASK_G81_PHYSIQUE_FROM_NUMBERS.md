# TASK_G81 - the fighter's NUMBERS become a Character Creator BODY: which sliders, what values, per weight class (Grok)

Model: Grok, Research mode, Expert. NEVER Build. Owner: grok. Assigned S62, 2026-09-24, on the
operator's ask: "the creator studio character is fine, can we add more models like that or a
generator, i want height, muscles etc being visible according to the numbers".

## What exists (so you research the gap, not the whole)
- Character Creator 5 (trial, D:\Reallusion) is driven by Python (`import RLPy`; your own G78).
  S60 already shaped HD Aaron by script: `SetShapingMorphWeight` on eight body sliders, then a
  height refit by bounding box with **Character Scale A** (measured slope 93 cm per unit).
- The game holds per athlete: `height_cm`, `reach_cm`, `leg_reach_cm`, `weight_kg`,
  `competition_weight_kg`, `sex`, and derives a `girth` 0.85-1.30 from BMI against a lean
  reference of BMI 23 (`FighterPhysique.gd`). Weight classes run 52 kg (straw) to 120 kg (open).
- CC5 body sliders we have listed by display name (all -1..1 or 0..1): Character Scale A,
  Shoulder Width A, Shoulder Top Height A/B, Deltoid Outer Curve, Deltoid Depth, Neck Scale,
  Pectoral Scale, Abdomen Scale, Upper Arm Scale, Upperarm Inner Scale, Forearm Scale,
  Forearm Inner Upper Scale, Hip Width A, Quad Lower Inner Scale, Hamstring Scale, Lower Leg
  Scale, plus the packs **Male Muscular** (Shoulder, ...) and **Male Skinny** (Arm, Shoulder,
  Thigh). Ranges are recorded; what NOBODY has is the VALUE each slider should take for a
  57 kg flyweight against a 120 kg heavyweight, or for a 1.65 m man against a 1.98 m one.

## Deliver ONE file: `G81_PHYSIQUE_FROM_NUMBERS.md`, three sections, every row labelled
MEASURED (study, N given) / DERIVED (from a formula you show) / JUDGEMENT / NOT FOUND.

1. **Anthropometry by weight class, men and women.** For each of the 17 unified classes plus
   boxing's extra ones: mean stature, mean competition BMI, body-fat % at weigh-in and on fight
   night, fat-free mass index, biacromial (shoulder) width, chest/waist/thigh/upper-arm girths
   where a study has them. Sources you already know the shape of: Reale et al. on MMA weight
   cutting, Kirk et al., the boxing anthropometry series (Chaabène; Bruzas), judo/wrestling
   somatotype studies. Give the number and the N; a range is fine, a mean without N is
   JUDGEMENT.
2. **The mapping to sliders.** A table with one column per slider above and one row per
   class (and a row for "lean" vs "stocky" at the same weight, since a 77 kg man can be
   1.72 m or 1.88 m): the VALUE to set, and the anthropometric quantity it stands for (e.g.
   Shoulder Width A <- biacromial width relative to stature; Abdomen Scale <- waist girth
   relative to the BMI-23 lean reference; Male Muscular pack <- FFMI above 22). Show the
   formula per column so a script can compute it from `height_cm`, `weight_kg`, `sex` and
   `reach_cm` alone. Where a slider's physical meaning is unknown, say NOT FOUND and propose
   the two-value calibration (set 0 and 1, measure the mesh) that would find it.
3. **Licence and export limits, verbatim where you can.** (a) What the CC5 trial's 30-export cap
   is, whether it resets, and what a bought CC5 licence changes. (b) Reallusion's EULA on
   shipping EXPORTED characters (HD Aaron and any CC base body, with shaping applied) inside a
   commercial game: the export licence, the per-character Content licence, and the
   "Character Creator base" clause. Quote the clause and its URL. This is the operator's open
   ruling on the board and a wrong reading costs real money.

Judgement labels on every row. Argue against yourself at the end: which slider will the
generator get wrong first, and why. No code, no Build mode.
