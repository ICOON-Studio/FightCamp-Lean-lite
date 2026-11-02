# TASK GYMLOOK3A (S212) - the gym floor gets real surfaces and every lighting effect Godot can afford (the game camera)

Model: Cursor (next free local seat after PROFILE2E). Own worktree E:/FightCamp/wt/GYMLOOK3A (seed it: Tools\seed_godot_cache.ps1),
branch cursor/gymlook3a from master. Never master.

## Operator rulings (verbatim)
- Q-S206-1: "it must be recorded already search you will find it , keep bodies +my free props+textures/effect pass" - keep the MetaHuman
  bodies and his free prop packs (gym_pack); the pass is TEXTURES + EFFECTS. The stylised/no-photo-texture direction was NOT taken.
- 10-11 board comments on the current floor (our_floor_reference.png): C21 "how we get better textures ? for posters and cosmetics do we
  need 2d assets ? cna you show it to me with all you speciall effects that you can use like ambient occlusion dynamic lighting etc";
  C29 "we need textures"; C31 "and the other visual effects". C19 on Ludo's r41 paint-over: "it slooking very nice though".
- S198: "ask it to ship as it came out of the factory" / "it means brand new" - clean, new surfaces: NO grime, rust or dirt maps.

## LUDO GATE (operator S212, verbatim: "visual approvements and UI must pass from ludo first then ask me")
- BEFORE you build: Claude sends Ludo (lead art designer) the before stills + this plan and asks for the surface/material/lighting
  direction; Claude adds Ludo's verdict here as "## Ludo direction" - build to THAT. Do not start step 2 until that section exists
  (step 1 before stills are yours; stop after them and note Claude in AgentComms/messages).
- AFTER: Claude sends Ludo your after stills; you fix what Ludo rejects; only a Ludo-passed set goes to the operator on the board.

## Ludo direction (S212, round 44 - build to THIS; launch only after the operator answers board Q-S211-1 "Build it?")
Read `research/LUDO_ROUND44_VERDICT_S212.md` (TAKEN / CHANGED / REFUSED) and the verbatim reply it cites
(`LUDO_ROUND44_S212_reply.txt`, sections A-E: the 20-surface material table, the light rig + morning/midday/evening keyframes, the post
stack, the posters). Where the verdict CHANGES Ludo (positions mapped to our hall, SDFGI vs lightmaps, tonemap white, clean texture
sets), the verdict wins. Do steps 2-6 in Ludo's order once its section F (first 5 changes) is appended to the verdict; until then
go: textures (floor, zone mats, brick, ring) -> ring + bag-line lights -> post stack -> posters.

## Prior research
GYM_LOOK_DECISION_S206.md (John's step 1 lighting list: AgX, SSAO+SSIL, warm key + cool fill, warm lamps over ring and bags, one grade),
M_STYLE_SHEET_S206.md (Gleason's palette: brick-red walls, grey concrete, black steel, red/black/white leather - keep the PALETTE, ignore its
"no photo textures" line, overruled by Q-S206-1), Ludo r41 paint-over (docs/previews/_sent/2026-10-11_2212_gym_floor_v2_*/ludo_r41_paintover.jpg -
the target mood), S101_GTA6_VFX_BREAKDOWN_NOTES.md s3 (LightmapGI + probes for a static gym), topics/gym_rooms_art.md.
Code: GymLook2.gd (151 lines, the Environment: ACES, SSAO, SSIL already ON), GymLook2Shell.gd (442 lines: walls, floor patches
`_floor_material`, trusses, lamps, exterior - flat `_std_mat` colours today), GymLook2Dress.gd, GymPack.gd, GymClub3D.gd (2,242 lines - never
read whole; `sed -n` windows). Look data in the JSON the shell reads (find it from GymLook2Shell.gd).

## What would a human do?
An environment artist textures the 5 big surfaces first (they fill 80% of the frame: floor concrete, rubber zone mats, brick walls, wood
ring apron/benches, painted plaster), then lights: warm pools over the ring and bags, cool fill, bounce, then post (grade, glow, subtle fog).

## Prefab check
Textures: Poly Haven (CC0) and ambientCG (CC0) PBR sets - albedo + normal + roughness (+AO), 1K for floors/walls (keep files light;
2K only for the ring canvas if needed). Name every set and its URL in the digest; CC0 needs no credit but list them in CREDITS_CC_BY.md's
"CC0 (no credit required)" section anyway. Posters/cosmetics: 2D decals (Decal node or a textured quad) - fight posters as our own flat
art (fictional fighters, real organisations allowed), never ripped images.

## Do
1. Before stills (game camera, the club floor as the player sees it - same framing as docs/previews/s206_gym_pack/our_floor_reference.png)
   with the CURRENT look: 3 stills (overview, ring close, a training zone with a fighter on it).
2. Textures (behind the existing gym_look2 switch, data-driven where the shell already reads JSON): concrete floor, rubber mats per zone
   (keep each zone's colour - colour per station is the readability rule - as a tint over the rubber texture), brick walls, wood (benches,
   ring steps), painted plaster, ring canvas. Triplanar or proper UV scale so tiles never stretch; texel density consistent across walls.
3. Effects: (a) lighting - warm SpotLights/OmniLights over the ring and the bag line with shadows, cool fill; (b) GI - try SDFGI vs
   LightmapGI on the static shell, keep the one that looks better AND stays inside the frame budget; (c) post - glow on the lamps,
   subtle volumetric fog for light shafts under the trusses, one colour grade (AgX if it reads better than ACES - show both), SSR on the
   ring canvas/mat if it helps; (d) contact shadows under props. Each effect on its own key in the look data so it can be turned off.
4. Posters and cosmetics: 4-6 poster decals on the brick (our fictional fight cards, the club name), the floor zone lettering kept.
5. Performance: fps on the game camera before/after (Godot's monitor) on this PC; the pass must stay >= 60 fps at 1920x1080. Report it.
6. After stills: same 3 framings + one per effect turned off (so the operator sees what each adds). Every still through the game's camera,
   head-to-feet framing for any person in it. Open every still with your file tool and describe it in the digest.
7. Tests: gym_look2_shell_test + gym_look2_props_test stay green; add checks that each texture loads and each effect key toggles; then
   `python Godot/tools/run_tests.py --jobs 2 --only gym_look,gym_pack,club,gym_hall` - nothing green goes red.
8. research/GYMLOOK3A_DIGEST.md: texture table (surface, set, licence, size), effect table (on/off, fps cost), stills before/after.
   Commit, push the branch, note to Claude in AgentComms/messages.

## Owned files
- `Godot/scripts/club_look/GymLook2.gd`, `GymLook2Shell.gd`, `GymLook2Dress.gd` and the look JSON they read
- `Godot/assets/` new texture folder for the gym (e.g. `assets/textures/gym/`), keep each set <= 1K unless named above
- `Godot/tests/gym_look2_*` (extend), `previews/gymlook3a/`, `research/GYMLOOK3A_DIGEST.md`, `CREDITS_CC_BY.md`
- NOT GymClub3D.gd layout, NOT the floor plan (approved S206), NOT fighters/MetaHumans.

## Rules
Parse gate before any test: `python Godot/tools/check_scripts.py <touched .gd>`. Watchdog before every Godot run
(`powershell -NoProfile -ExecutionPolicy Bypass -File Tools\pc_watchdog.ps1 -Once`, RED = wait). Windowed Godot ONLY via
`Tools\godot_hidden.ps1`. Never open image viewers or browsers - view images with your file tool. `git add -- <files>`; never commit
.import churn for files you did not add. Never master.

## The one trap
Godot imports new textures on first open - a full re-import of the project heats the PC (87 C, S206). Seed the worktree cache first and
import only your new texture folder; keep textures 1K, compressed (VRAM compressed, mipmaps on).
