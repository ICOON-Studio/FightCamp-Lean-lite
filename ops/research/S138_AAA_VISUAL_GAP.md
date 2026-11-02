# S138 - the AAA visual gap: where we are, the bar, and the route (2026-10-01)

Operator, verbatim: "none of what i saw so far is even close to AAA , i thought i asked for AAA quality overhaul ,
shaders/vfx etc and use assets i still see a grey ring. let meknow if we need to buy anything , i expect way better
textures and not fake pictures that were drafted for previews only , replace with real protraits of fighters and the
tail of the tape needs to be changed accordingto our art direction always compare titles from our reseraches and try to
surpass them visually"

## Audit (Explore agent + Claude, primary sources)
- Live bout: NO anti-aliasing (SubViewport sets none); venue lights: 19, all shadow_enabled=false, shell key dimmed to
  0.02 -> no shadows at all; environment = flat colour (no tonemap/glow/SSAO/fog); crowd = boxes/silhouettes
  (VenueRig _crowd_row/_crowd_mass_block); ring = flat StandardMaterial3D colours, ropes = boxes; venues ON in career
  bouts since S137 (FightNightScreen.gd:930) but every test/capture tool without a booked bout shows the grey void.
- Skin: fighter_skin_kit.gdshader albedo only, sss_strength 0 in the ring, no normal map; MPFB skins 2048 albedo only.
- Portraits: 24 AI images (Higgsfield gpt_image_2_5, S92, assets/images/athletes/generated) picked by sex + id hash
  (TaleOfTape.gd:13-38, :427) - NOT the man in the ring. FighterPortrait.gd (studio render of the same seeded fighter)
  exists but no screen uses it; rendered S138: white mannequins (skin not applied in that path), no hair, near-identical
  faces -> the MPFB head cannot carry an AAA portrait.
- Owned tools: Character Creator 5 + iClone 8 (D:\Reallusion); FightWorldLiveScreen has a `skin=cc` path and
  CCFighterMaterials.gd (SSS 0.35) - an earlier CC route.

## Done S138 (look pass 1, 278dd213): AgX tonemap, bloom, SSAO, volumetric haze, grade; a shadowed white ring key per
venue; skin SSS 0.3 + sweat sheen; MSAA 4x + FXAA. Venue/arena/fight_night/smoke 9/0. Before/after:
docs/previews/s138_look/before_after_venues.jpg - better, NOT AAA: the remaining gap is ASSETS.

## The bar (research agent, sourced)
- Undisputed (UE4): scanned boxers; progressive sweat + facial deformation; "ultra-bright white light center ring";
  sweat flies on impact; blurred crowd (DOF); CompuBox stats, real announcer/referee.
- UFC 5 (Frostbite): 8 regions x 5 damage levels (cuts/bruises/swelling, gameplay effect); GPU blood/sweat particles
  that build up on the mat; cinematic KO replays framed by finish type; walkout light across skin. Criticised: muted
  atmosphere inside the octagon.
- Fight Night Champion: lasers/smoke/lens flare walkouts; bruise -> swelling -> cut; multi-angle KO replay; HUD-light.
  Criticised: arenas too dark, weak audience, plastic sweat.
- Godot 4 Forward+: volumetric fog + per-light fog energy; SSS (skin) + clearcoat (sweat); VoxelGI for interiors; decals
  do NOT follow skinned meshes -> damage as UV masks in the skin shader + blendshapes; crowds via vertex-animation
  textures + MultiMesh (~50k low-poly at 100 FPS, github.com/antzGames/Godot_Vertex_Animation_Textures_Plugin);
  realistic humans proven: MatMADNESS HumanShaders (MIT/CC BY 4.0) and MetaHumans in stock Godot 4.6.
- Licences: MetaHuman may ship in Godot since June 2025 (free under $1M revenue/yr); Character Creator: shipping
  characters needs the Extended licence per content item (~3x Standard); Fab Standard licence allows other engines
  (check each listing); Poly Haven / ambientCG CC0; Texturing.xyz faces $19.90-39.90 (Business licence for games).
- Tale of the tape (DAZN/Sky style): cut-out fighters at the edges, centre stat column, each row's bar fills toward the
  winner, rows wipe in on the announcer's lines; ours can surpass with camp rows (weigh-in fitness, plan, last-5 form).

## The route (Claude, as lead)
V1 ring: textured canvas (CC0 canvas + our ring logo decal), padded turnbuckles, rope wraps, branded apron skirt.
V2 crowd: vertex-animated low-poly people via MultiMesh instead of boxes; DOF on the house.
V3 fighters: the head/skin decision below; skin shader with normal + roughness detail, damage masks, sweat clearcoat.
V4 portraits: render the fighter's own model (FighterPortrait) into a cached texture on every screen; never photos.
V5 tale of the tape: rebuilt to the DAZN/Sky layout with rendered portraits + camp rows.
V6 presentation: broadcast camera, KO replay + slow-mo, walkout in the venue (C232), sweat/blood GPU particles.
DECISION (operator, money + direction): the fighter head/body source - MetaHuman (free, best, heavy pipeline),
Character Creator 5 (owned; Extended licences per item), or MPFB + bought skin/hair (cheapest, mid).
