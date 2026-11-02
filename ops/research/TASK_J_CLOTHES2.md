TASK J_CLOTHES2_S208 (John, deep research) - FightCamp S208

Thank you for J_CLOTHES_S207 - thorough. One ruling changed under it: the operator (S207, verbatim) "i do not want to see mbfb model anywhere again" - every person in the game is now a METAHUMAN body (Epic MetaHuman, exported to glTF into Godot 4.7.2, MetaHuman skeleton). MPFB/MakeHuman and Tripo bodies are gone, so the MakeHuman clothes route no longer fits.

Re-answer the same question for MetaHuman bodies: how do we dress 5 roles (boxers in training, coaches in club uniform, front-desk staff, gym members, walk-in customers) x 6 looks each so everyone looks different, commercial PC release, tiny budget.

Cover, with sources and dates:
1. LICENCE FIRST: the current MetaHuman licence for using MetaHuman bodies AND MetaHuman Creator clothing outside Unreal (another engine, Godot). Quote the clause. Which clothing assets are covered (Creator outfits, Fab "MetaHuman-ready" clothing).
2. Sources of clothes that fit the MetaHuman body/skeleton: MetaHuman Creator built-in outfits (how to export them with the body), Fab/Sketchfab/CGTrader clothing made for MetaHuman (price, licence, tris), Marvelous Designer/CLO marketplace, Quaternius/Kenney-style free packs, Mixamo-rigged clothing. Note which ones auto-fit across MetaHuman body types (MetaHuman has body presets - does clothing conform?).
3. Boxing-specific gear on MetaHumans: gloves, hand wraps, headgear, trunks, boxing boots, coach mitts.
4. Godot pipeline: export MetaHuman + outfit from UE to glTF (or Blender), keep one shared skeleton, swap outfit meshes at runtime, hide body under clothes, texture/colour variation (tinting, decals) for a club uniform with a logo slot.
5. Top-3 ranking and an hours estimate for 30 looks, USD cost.

## Prior research
Your J_CLOTHES_S207 (sections 3 Godot outfit swapping and 5 pipeline still apply - reuse them, do not redo). Maria's M_WARDROBE_S207 gives the looks per role (mesh codes T1-T6 etc.) - the targets are hers.
## What would a human do?
A technical artist on a small UE-to-other-engine team would check the MetaHuman EULA, then buy/collect MetaHuman-fitted clothing and bake outfit variants in Blender on the shared skeleton.
## Prefab check
That is the whole task - prefabs first, building our own clothes last.

Reply in full, as long as needed, sources with URLs and access dates. Mark SOURCED vs JUDGEMENT.
