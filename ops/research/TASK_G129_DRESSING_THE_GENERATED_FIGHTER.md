# TASK G129 - GROK - DRESSING THE GENERATED FIGHTER (shorts, gloves, wraps, hair) WITHOUT PAYING
Owner: grok (Expert, grok.com in the in-app browser; sent grok.com/c/3fa9082a-ae39-412e-9487-dc4cf6a3b1f6). Assigned 2026-09-27 (S93). Research only. Reply inline,
<= 700 words, titled G129_DRESSING_THE_GENERATED_FIGHTER. Tag SOURCED (link) / PROXY / JUDGEMENT.

## Why
Our fighters are generated with MakeHuman/MPFB (CC0) in Blender and exported to Godot 4.7 as one skinned mesh on a
52-bone humanoid rig with 31 blend shapes (face, build, muscle, age, ancestry), plus eye and eyebrow proxies that
carry the same 31 keys. They are naked and bald. They need fight shorts (boxing trunks, MMA shorts, Muay Thai
shorts), gloves (boxing 10-16 oz, 4 oz MMA), hand wraps, a few hair styles and facial hair - varied per fighter by
the same seed - and all of it must ship commercially on Steam.

## What would a human do?
A character artist at a sports-game studio builds a small wardrobe of modular garments fitted to ONE base body,
skinned to the same skeleton, uses proxy/shape-key fitting so every body variant wears them, and varies colour and
logos through material parameters rather than new meshes.

## Questions
1. CC0 or commercially safe sources for fight shorts/trunks, boxing + MMA gloves, hand wraps, short hair, beards -
   especially MakeHuman/MPFB community assets (.mhclo) with their exact licence (CC0 vs CC-BY). hair02 is CC-BY -
   name any other trap.
2. How MPFB fits clothes to a morphed body (mhclo proxy fitting) and whether it survives glTF export with blend
   shapes - or must each garment carry the same 31 shape keys (we already do this for eyes: one refit per key)?
3. Gloves: a rigid mesh on the hand bone vs a skinned mesh - what fight games do, and the VRAM/draw-call cost.
4. Making our OWN trunks with MPFB's MakeClothes from the base mesh: steps, hours, pitfalls.
5. Hair in Godot 4.7 at our budget: hair cards vs a sculpted cap - which reads better at fight-camera distance.
6. Your recommended first wardrobe: exact items, sources, licences, and hours.
