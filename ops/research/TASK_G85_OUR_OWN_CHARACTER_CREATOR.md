# TASK_G85 - can we SHIP our own character creator? The licences of the open body bases (Grok)

Model: Grok, Research mode, Expert. NEVER Build. Owner: grok. Assigned S63, 2026-09-24.

## Why
The operator asked: "can we replicate the parts we need from Reallusion and ship our own creator?"
Reallusion's Character Creator EULA section 5 lets us ship baked fighters but bans a live in-game
generator, and copying its morphs is the same thing. The lead's plan is an in-game creator built from
an OPEN base body + shape targets (muscle, body fat, shoulder width, face) loaded as blend shapes in
Godot and driven by our own slider formulas. Before any build, we need the licence facts.

## The questions (label every answer VERIFIED-FROM-LICENCE-TEXT / SECONDARY / UNKNOWN, quote the clause)
1. **MakeHuman 1.x / MakeHuman Community assets** (base mesh, targets/morphs, skeleton, skins,
   clothes): exact licence of the ASSETS vs the CODE. May a commercial closed-source game ship the base
   mesh and the targets inside its build, modified? Is attribution required?
2. **MPFB2** (the Blender add-on): licence of the add-on vs of the assets and of anything it EXPORTS.
   Is a mesh exported from MPFB2 ours to ship?
3. Other open parametric human bases fit for a game (e.g. SMPL / SMPL-X - licence usually forbids
   commercial use: confirm; Blender Studio's human base meshes; Quaternius or Kenney humanoids; anything
   CC0 with shape keys). One row each: licence, commercial OK?, has shape keys?, rigged?
4. What an in-game body creator needs that a base alone lacks (per-target normal maps, corrective
   shapes at joints, clothing that follows morphs) and which of those the open bases already provide.

## Deliverable
One table for Q1-Q3, short answers for Q4, pasted as Markdown in the chat (not a docx). Claude
transcribes it to `research/G85_OUR_OWN_CHARACTER_CREATOR.md`. No code.
