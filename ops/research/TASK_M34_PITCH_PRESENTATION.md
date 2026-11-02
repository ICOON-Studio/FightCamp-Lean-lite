# TASK M34 - MARIA - THE PITCH LOOK: MAIN MENU, HUB AND FIGHT-NIGHT HYPE (art direction; after M33)
Model: Maria (Grok bot, art direction). Owner: maria. Assigned S78 end, 2026-09-25. Art only. Start after M33.

## Why
Operator, 2026-09-25, verbatim: "like you're presenting this to someone who wants to buy the game ... I don't want to
see placeholders ... I don't want to see this fucking stupid gray empty just illustrate it"; "I'm open to 2D live
animation in there, only still pictures, high resolution menus ... What kind of transition ... fit into this kind of
game?"; "from the first fucking scene I see up to ... the hype of the fight. I want to see how difficult it is to reach
the fight."

## Operator references (2026-09-25, binding)
"i want a new exe when the game matches visually Motorsport manager and Hollywood animal background menus and animated
video fadeouts". His sheet: `research/refs/operator_hollywood_animal_2026-09-25.png` (Hollywood Animal: main
screen background effect, shiny button effect, scene transitioning, cell design and colours, how items show up, studio
landscape scene with tutorial, filler item cards, the date/time bar). "Preset 3-4 different previews before deciding":
deliver THREE OR FOUR distinct front-end directions, each a title + hub mock, all within the MM / Hollywood Animal
family, so the operator picks one.

## What would a human do?
An AD preparing a vertical slice for a publisher pitch builds a key-art-led front end: one hero illustration per
major screen, a motion language (how screens enter/leave), and a fight-night sequence that escalates (card
announced -> camp -> weigh-in faceoff -> walkout -> ring intro -> bell). References first, then mocks.

## Do
1. Reference board: 8-12 fight/sports games' front ends (UFC 5, Undisputed, Fight Night Champion, EA FC/FM, WWE 2K,
   Punch Club 2, Creed: Rise to Glory) - title screens, hubs, transitions; for each: still vs animated background,
   what the transition is, why it fits. Name the frames (game, screen) so Claude can look them up.
2. Decide: still high-res illustrations vs 2D-animated (parallax/loops) per screen, within a tiny budget (AI-assisted
   stills + subtle parallax is the likely answer - say if not).
3. Mocks at 1920x1080: TITLE screen, HOME hub (use J54's IA if it has landed; else keep today's rail items), and a
   5-beat FIGHT-NIGHT HYPE storyboard (announcement, faceoff at weigh-in, walkout, ring intro, bell) with the
   "how hard it was to get here" beat (camp weeks, weight made, record) shown on screen.
4. A transition spec: per screen change, type + duration + easing (M32 7.6 timings).

5. BUYABLE ASSETS (operator 2026-09-25: "there are many assets we can use for interface ... tell me there is anything we
   could buy from there that will bring the game closer looking to a fine illustrated AAA title"). Survey GameDev Market,
   ArtStation Marketplace, itch.io, GraphicRiver/Envato, Unity Asset Store (ART packs only - Unity "Extension Assets"
   such as Michsky Heat / Modern UI Pack are licensed for Unity only and cannot ship in Godot), Humble bundles, font
   foundries. For each candidate: link, price, licence (commercial, engine-agnostic?), what it contains (layered PSD,
   9-slice PNG, 4K?), and how close it gets to the MM / Hollywood Animal look. Rank the top 5 and say which gap each
   closes (frames/buttons, illustrated backgrounds, portraits, icons, display font). Claude's first pass (S78):
   ArtStation "MMA/Boxing Gym Asset Pack Vol.1" $24.99 (56 PBR 3D props - for the gym/arena scenes), GameDev Market GUI
   category, itch.io GUI tag, GraphicRiver fight/boxing game assets.
   UNITY ASSET STORE, operator's explicit ask ("check our assets in unity hub and what is being sold there about
   GUI/UIX"): (a) OWNED, checked S78 in %APPDATA%/Unity/Asset Store-5.x: SlimUI "3D Modern Menu UI" (rejected in
   ASSET_REPORT_2026-09-20: Unity-EULA code asset, cannot ship in Godot), Marpa "MMA Arena" 452.9 MB (the real venue -
   see ASSET_REPORT), Poly Ronin gym props, RamsterZ + Magicpot animations. (b) FOR SALE in 2D > GUI: survey the
   top-rated and newest art packs (Layer Lab "GUI Pro" series incl. Minimal Game Dark/Blue, and every dark/premium/
   sports/management-styled kit), and for each read its licence type on the product page: ONLY non-"Extension Asset"
   art (sprites/PSD/fonts) may ship in Godot. Most GUI kits there are mobile/casual/fantasy - say plainly if none fits
   the MM / Hollywood Animal look.

## Deliverable
`research/M34_PITCH_PRESENTATION.md`, the mocks, `CLAUDE_LAND_NOTE_M34.md`, via your usual delivery.
