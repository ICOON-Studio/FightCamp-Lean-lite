# TASK G127 - GROK - THE SHAPES THAT MAKE ONE FIGHTER LOOK UNLIKE ANOTHER (S92, for S93)
Owner: grok (grok.com, Research mode - never Build). Assigned S92, 2026-09-26. Reply inline, <= 900 words, titled
G127_THE_SHAPES_THAT_MAKE_A_FIGHTER. Tag every claim SOURCED (with URL) / PROXY / JUDGEMENT.
Model: Grok Expert (research). Tier: research only - no repo, no test.

## Why
G126 chose MakeHuman / MPFB (CC0 assets) for an in-game fighter generator: one base mesh per sex on MPFB's GameEngine
rig, 15-40 body + 20-40 face blend shapes baked per fighter from a seed, CC0 skins. S93 builds the pilot. We need to
know WHICH shapes to export - the MPFB modifier budget is small, so each one must buy visible difference at a fight
camera and on a portrait.

## What would a human do?
A character lead on a sports game picks the handful of sliders that separate real athletes at a glance - jaw, brow,
nose break, ears, neck, shoulder slope, forearm size - from photo lineups of the real roster, and cuts sliders nobody
can see at 3 m. Fighters have specific marks: cauliflower ears, flattened noses, heavy brows, thick necks.

## Questions
1. The MPFB/MakeHuman modifier NAMES (exact, as in the modifier list / .target files) for: face (jaw width, chin,
   cheekbones, brow ridge, nose width/bridge/tip, ear size/shape, eye spacing, lips) and body (neck girth, trapezius,
   shoulder width, chest, arm and forearm muscle, waist, thigh, calf, body fat). Which exist, which do not.
2. Fighter marks: can cauliflower ear or a flattened nose be made from existing targets, or does it need a custom
   target (and is a custom target easy to author in MPFB)?
3. Which 20 face + 20 body shapes buy the most difference per shape for fighters (JUDGEMENT, ranked), and the safe
   weight range for each so nobody looks deformed.
4. CC0 skin and hair for MPFB: name specific packs with their licence page opened (bundled vs community; community
   assets may NOT be CC0), and the MH UV constraint.
5. Ethnicity/age as axes: how MakeHuman's African/Asian/Caucasian and age macro-modifiers work, and how to seed them
   without producing caricatures.

## Owned files
None. Reply inline in the Grok chat; Claude saves it as `research/G127_THE_SHAPES_THAT_MAKE_A_FIGHTER.md`.
