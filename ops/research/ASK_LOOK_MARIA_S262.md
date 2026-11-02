# ASK (Maria, art direction) - make our MetaHuman boxers look real in Godot 4.7 on a broadcast-style fight camera (S262)

Longest complete answer you can. Numbers, not adjectives: every recommendation names the Godot material/light property and a
value or range, and why.

## Context
FightCamp is a boxing manager sim (PC, Steam EA). The fight is WATCHED from a TV-broadcast camera: high, 3/4 view, both boxers
head to feet in frame (they are ~350-450 px tall on a 1920x1080 frame). Bodies are MetaHumans exported from UE 5.8 to Godot
4.7.2 (Forward+): body + head meshes, albedo/normal JPGs (2K), a skin micro-normal, hair and brows as CARDS (no strands),
StandardMaterial3D. Ring lit by four broadcast fills from the truss corners (S261) + a key. The operator (40 years of games):
"the MH models do not look very nice or real to me". Our honest read: Unreal's MetaHuman look comes from its skin shader
(subsurface scattering, dual-lobe specular, cavity/AO), strand/groom hair and Epic lighting - we have none of that in Godot.

## Questions
1. Skin in Godot 4.7 StandardMaterial3D for dark and light skin tones at THIS camera distance: subsurface_scattering_strength,
   subsurf_scatter_skin_mode, transmittance (on/off, depth, color), roughness (value + a roughness map?), specular / metallic_specular,
   clearcoat for sweat (yes/no, value), rim (rim, rim_tint) - and whether a custom ShaderMaterial (dual-lobe specular, cavity
   multiply) is worth it at 400 px tall. Give a recommended starting preset per skin tone.
2. Sweat/oil sheen that builds over rounds (fighters glisten under ring lights) - which property to animate and its range.
3. Hair/brows as cards: alpha mode (alpha scissor vs hash vs depth prepass), anisotropy, how to keep short boxer haircuts from
   looking like a helmet. Should most boxers have shaved/short hair to dodge the problem? (art direction call)
4. Lighting for a believable TV fight look: key/fill/rim ratios, colour temperature, shadow softness, SSAO/SSIL/SDFGI or not,
   tonemap (AgX/ACES/Filmic) and exposure, a touch of bloom on the canvas glare? Name the Environment and Light3D settings.
5. Reference: name 3 shipped games or broadcast stills whose fighter look we should match at this camera height, and what
   each does right (e.g. Undisputed, Fight Night Champion, UFC 5 - what makes their skin read as skin from far away).
6. A "look test" plan: which 4 stills (same pose, same camera) the operator should compare to pick a direction.

Answer as text; we will build the A/B stills from it and the operator picks.
