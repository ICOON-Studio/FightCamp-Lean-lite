# Muscle/skeleton figure: make or buy (S321)

Can Claude make a film-quality realistic muscle+skeleton human? No. That is weeks of a specialist anatomy sculptor's work.
AI 3D generators (Hunyuan/Tripo/Meshy) produce mushy, wrong anatomy - nowhere near your Female Ecorche reference.

Free: Z-Anatomy (Blender, accurate skeleton/muscles/vessels) is CC BY-SA 4.0 share-alike and some parts are non-commercial.
Risky for a paid Steam game - not recommended.

Buy (royalty-free, checked 2026-10-31, prices change):
- CGTrader "Female Ecorche - Skin Musculature Skeleton" $90, royalty-free, says realtime-ready (Unity/Unreal), not rigged.
  https://cgtrader.com/3d-models/character/anatomy/female-ecorche-2e90b04c-ad90-4a34-a4da-b2045ae36bbe
- CGTrader "Highly Detailed Female Sculpted Anatomy" $35, ZBrush + decimated OBJ/FBX skeleton and muscle groups.
- Rigged muscle ecorche $499 (8K textures, IK/FK) - only if the figure must MOVE; the side panel does not need that.
- 3D Scan Store male + female ecorche (scan-based, premium) - check price.

Recommendation: buy ONE female + ONE male royalty-free ecorche (about $35-90 each). Claude renders them into the side-panel
portraits (each boxer's build), and draws the running blood, swelling and ice on top in the game. No rig needed.
Before buying: the licence must allow use inside a sold game (CGTrader royalty-free does; raw model never redistributed).

S321 update (operator's colour reference, previews/s321/ref_muscle_colours_operator.jpg): MUST-HAVE = every muscle
a SEPARATE mesh/group, so the game colours each one by its state (BODY_TRACK_PLAN_S321.md). The $35 "Highly Detailed Female
Sculpted Anatomy" lists individual decimated muscle groups as FBX; check the $90 one has separate pieces before buying it.

## Game-ready spec (S321, operator: "what do you need to make an anatomy model good enough for the game?")
Claude cannot sculpt the muscle shapes; everything after the shapes Claude does (Blender 5.2 is installed, scripted).
Need from the bought model: female + male, every muscle a separate mesh or material group (30-60 pieces, front and back),
clean quads or decimated FBX/OBJ, royalty-free licence that allows a sold game.
Claude then: fits each muscle layer onto every MetaHuman boxer (Blender shrinkwrap/surface deform so it has HER build), binds it to
the MetaHuman skeleton (weight transfer, so it can stand in guard or move), maps the pieces to our game parts (shoulders, arms,
chest, core/ribs, legs, head), one material slot per part for live colour, 20-40k triangles + 2K textures (the panel is ~500 px
tall), and muscle-definition shape keys so training shows on the body (operator's Day 1 -> Day 21 video, S321).
Gate: a 1080p still of the side panel in the game, both boxers, and his OK. About one session after the files arrive.
