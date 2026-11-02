# TASK K45 — KALLI — A PUNCH WHILE STEPPING: UPPER/LOWER-BODY LAYERING IN GODOT 4.7, WITHOUT LOSING OUR JOINS

Model: Grok Bot (Kalli), research. Owner: kalli. Stage: S4a (every action a clip; transitions) - forecast research.

**Research only.** No code, no downloads, no sign-ups. Links and dates. One pass. Reply in this chat.

## Why this exists

Our fighters (Godot **4.7.2**, GDScript) each play ONE clip at a time on an `AnimationPlayer` that we `advance()`
manually every frame, with our own inertialized joins between clips and (soon) a TwoBoneIK3D foot lock after it. So a
man can either step or punch, never both: when the fight needs him to close 10 cm and throw a jab, one of the two is
lost. UFC's GDC 2015 animation talk (our J19) layered an additive locomotion machine under strikes so "a punch and a
step coexist". We need to know how to layer in Godot before we design it.

## What we already hold - do NOT re-research

J19 (UFC 2015: additive locomotion + foot planting), K43 (frame pacing), K44 (foot-lock IK on TwoBoneIK3D).

## What to find - one row each, labelled DOCUMENTED (docs / engine source / PR) / SECONDARY / NOT FOUND

1. **AnimationTree layering in 4.7:** `AnimationNodeBlend2` / `AnimationNodeAdd2` bone FILTERS (upper body from a
   strike, legs from a walk) - how filters are set, whether the filtered blend is per-bone weight or on/off, and how
   `AnimationNodeOneShot` fires a strike over a looping base with fade-in/out.
2. **Additive animation:** how Godot makes an additive (`Add2` / `Add3`, "additive" import option or subtracting a
   reference pose) - what the reference pose is, and the documented pitfalls (double-counted hips, drifting feet).
3. **Manual stepping:** can an `AnimationTree` be advanced manually each frame like our `AnimationPlayer.advance()`
   (`callback_mode_process` MANUAL + `advance()`)? Can it drive its OWN animations without an `AnimationPlayer`
   (4.2+ `AnimationMixer` base)?
4. **Root motion with a tree:** `root_motion_track` and `get_root_motion_position()` on `AnimationTree` / `AnimationMixer`
   - does a filtered blend still produce correct root motion, and can the root track be a Hips bone position track?
5. **Custom poses without a tree:** is a custom `SkeletonModifier3D` (`_process_modification`, 4.4+) a documented way to
   blend a second pose onto chosen bones after the mixer - its cost and ordering against IK modifiers.
6. **Spine blending in practice:** where games split upper from lower body for strikes (spine1? pelvis?), and how they
   stop the hips twisting wrong when the legs step one way and the torso punches another (with sources: GDC talks,
   Unreal "Layered blend per bone" docs for comparison).

## Your answer's first section: `## DECISIONS`

At most six lines:
- AnimationTree filters, additive layers, or a custom SkeletonModifier3D - which to build a punch-while-stepping layer
  on in our manually advanced setup, and why;
- the bone to split at, with its source;
- how our inertialized joins and a TwoBoneIK3D foot lock fit into that order;
- whether root motion survives the layering;
- the one pitfall to test first.

Claude collects as: `research/K45_LAYERED_STRIKES.md`
