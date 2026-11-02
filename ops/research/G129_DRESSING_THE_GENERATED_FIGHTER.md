# G129 - Dressing the generated fighter (Grok, Expert mode, collected S94 2026-09-27)
Source: grok.com/c/3fa9082a-ae39-412e-9487-dc4cf6a3b1f6 (69 sources). Tags: SOURCED / PROXY / JUDGEMENT as Grok gave them.

## 1. Licences
- MH/MPFB core mesh, targets, skins, SYSTEM clothes/hair/eyes and outputs: CC0; closed-source Steam OK, no attribution. Community packs: check each row. SOURCED (GitHub, static.makehumancommunity)
- CC0 usable now: system hair short01-04, afro01, bob01/02, ponytail01; Hair 01 pack (cortu_short_messy_hair, Toigo bobs, Culturalibre shorts); Gloves 01 (learning_mma_fighting_gloves + Toigo/Culturalibre gloves); Pants 01 cortu_jeans_shorts (closest free short); Bodyparts 05 beards (scruffy, viking, faun, Sigmund). SOURCED
- TRAPS (CC-BY = credits page): hair02 (Elvaerwyn, whole pack), hair03 (Culturalibre/Punkduck/Grinsegold), pants03 swim shorts/trunks (the only fight-ish shorts), system eye materials 03 (01/02 are CC0). Stale .mhclo headers say AGPL3 - ignore header, use the pack table. SOURCED/PROXY
- No dedicated CC0 boxing-trunk or hand-wrap pack exists. PROXY

## 2. MPFB fit -> glTF
- MHCLO = per garment vertex: 3 basemesh verts + barycentric weights + offset; fit_clothes_to_human builds a temp "from mix" shape key and repositions. SOURCED
- glTF does NOT carry MHCLO. Runtime morphs in Godot work only if (a) body+garment baked per snapshot, or (b) the same 31 keys transferred onto the garment (our eye method). Export Copy may interpolate keys onto children but only "significant deformation" - trunks may get waist/leg keys and skip face keys.
- JUDGEMENT: keep MHCLO in Blender; copy the 31 keys per garment at export.

## 3. Gloves
- Boxing glove (closed fist): RIGID mesh parented to hand/wrist bone + scale/cuff key. MMA 4 oz: SKINNED to hand+fingers. PROXY. Cost negligible either way (one mesh, no extra bones).

## 4. Own trunks via MakeClothes
- Unmodified basemesh -> model on helper groups -> matching vertex groups -> Check Clothes -> MHCLO + delete-group -> pose-test squat/kick/clinch -> export.
- 8-16 h first pair, 2-4 h after; three cuts (boxing high-waist, MMA split, Muay Thai mid) from one blockout.
- Pitfalls: crotch/inner-thigh, waistband gaps on fat/muscle keys, helper vs body groups, delete-group holes.

## 5. Hair at fight camera
- Opaque sculpted caps (short01-04 class) over alpha cards: no overdraw, no z-sort; Godot alpha hair z-fights. JUDGEMENT: caps first.

## 6. First wardrobe (no spend), ~40-60 h
| Item | Source | Licence | Hours |
|---|---|---|---|
| 3 shorts (box/MMA/MT) | MakeClothes; cortu_jeans_shorts as fit ref | ours + CC0 | 16-24 |
| MMA gloves | learning_mma_fighting_gloves | CC0 | 2 |
| Boxing gloves | own rigid mesh | ours | 6-10 |
| Wraps | strips or hand albedo | ours | 4 |
| Hair x5 | short01-04, afro01; hair01 messy/bobs | CC0 | 4 |
| Beards x3 | bodyparts05 | CC0 | 2 |
| Colour/logos | material params | - | 4 |
Vary dye, waist height, glove oz, wrap dirt by the fighter seed, not new meshes.

## Claude's read (S94)
Actionable as-is. Decision for the generator follow-up: CC0 system caps + bodyparts05 beards first (cheapest, visible at fight distance); boxing glove = rigid on the hand bone (C213 lane can take it); trunks via MakeClothes carrying the 31 keys (the eye method). Never pull hair02/hair03/pants03.
