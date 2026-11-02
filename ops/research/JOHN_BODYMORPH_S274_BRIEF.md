# JOHN BODYMORPH S274 - a boxer's MetaHuman body that changes as he trains (research only)

Operator S274: wire the attributes into "the training, fighter body/profile and the fight"; asked "should a boxer look different
as he trains, more muscular with power and leaner with conditioning?" -> "yes".

## Where we are (facts, checked S274)
- Our boxers are MetaHumans built in Unreal 5.8 (project MHPilot) and exported to Godot 4.7 as GLB (mh_boxer_01..09; body
  mesh MH_Body, 6 surfaces, ZERO blend shapes). S262/S263 already pull body DNA + RigLogic correctives out of UE 5.8.
- The game drives everything else from 11 attributes (power, conditioning, technique, ...). We want the BODY to follow
  power/strength (muscle mass) and conditioning (leaner, more defined), gradually, everywhere the man is shown.

## The ask (answer as long and complete as you can; every claim with a URL; mark UNVERIFIED what you could not open)
1. MetaHuman in UE 5.6 / 5.7 / 5.8: what body controls exist (parametric body, body measurements, "muscularity" / "fat" /
   body types, Body Conform)? Can the SAME MetaHuman be produced at two or three body settings with IDENTICAL vertex count and
   order (a requirement for blend shapes / morph targets)? Exact UI steps AND the Python / Blueprint API (MetaHumanCharacter,
   MetaHuman Creator plugin) to do it headless.
2. Export: can those variants export as FBX/GLB with the same topology, or as morph targets on one mesh (USD / FBX blend
   shapes)? What breaks (skin weights, the body DNA, correctives, clothing)?
3. Licence: the current MetaHuman licence (2025 changes) for shipping MetaHuman bodies AND their shape variants in a game made
   in another engine (Godot), sold on Steam. Quote the clauses.
4. Alternatives if (1) fails: (a) bone scaling (limb/chest girth) - known artefacts; (b) normal / detail map blending for
   muscle definition; (c) how shipped sports games do it (EA UFC, Fight Night Champion, NBA 2K "body type" progression,
   WWE 2K) - the technique each uses, with sources.
5. A recommended pipeline for 9 boxers x 2 extra shapes, with time estimate per boxer.
Research only - no downloads, no code.
