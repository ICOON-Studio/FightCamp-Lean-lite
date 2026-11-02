# TASK G128 - GROK - A CARD PORTRAIT THAT IS THE SAME MAN AS THE 3D FIGHTER (S92, for S93)
Owner: grok (grok.com, Research mode - never Build). Assigned S92, 2026-09-26. Reply inline, <= 800 words, titled
G128_A_PORTRAIT_THAT_IS_THE_SAME_MAN. Tag every claim SOURCED (with URL) / PROXY / JUDGEMENT.
Model: Grok Expert (research). Tier: research only - no repo, no test.

## Why
The operator asked how faithful a fighter's photo will be to his 3D body. S93 makes one seed drive both: a MakeHuman/
MPFB fighter (CC0 skins, blend-shape face) rendered in Godot 4.7 as a studio headshot. A raw real-time render of a
MakeHuman head can look like a game character next to photoreal portraits. We need the card to read like a photo AND
stay recognisably the same face as the man in the ring.

## What would a human do?
Sports games (EA UFC, Undisputed, FIFA/FC) and promotions' digital teams render select-screen portraits from the game
mesh with a dedicated portrait light rig and higher-quality shading than gameplay; some then retouch. Find out how.

## Questions
1. Godot 4.7 settings that make a skin headshot believable: subsurface scattering, specular/roughness for sweat, SSAO/
   SSIL, depth of field, film grain, tonemapper, and hair cards vs meshes - what gains the most per hour.
2. Image-to-image from a render: which models keep IDENTITY (face structure) while adding photo realism (e.g. gpt-image
   edit, Flux Kontext, InstantID/IP-Adapter-style), how strongly to condition, and how to measure that the face is still
   the same (face-embedding similarity threshold).
3. Legal: does an image-to-image pass change who owns the card (Higgsfield paid plan; the render is ours)?
4. How games keep portraits and in-match bodies consistent when the player edits the fighter later (re-render on edit?
   cached per save?).
5. JUDGEMENT for us: raw render or render + edit pass; the settings; the identity check; the ONE trap.

## Owned files
None. Reply inline in the Grok chat; Claude saves it as `research/G128_A_PORTRAIT_THAT_IS_THE_SAME_MAN.md`.
