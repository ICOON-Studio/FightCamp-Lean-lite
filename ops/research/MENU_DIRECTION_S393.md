# Menu direction, S393: Claude's proposal (operator: "i want serious proposals, do new mockup previews of what you think is the right")

**Status: direction approved by the operator, 2026-11-06 ("Yes, this direction"), on the Home mockup.** Fighter and Fights were not shown.

**S394 update:** built in the game, the dark look clashed with the light pages (operator: "the black background doesnt fit the rest of the game"). He chose "Match the light game". Home keeps this layout in the game's light cards (commit 06a5c755), blind reviews 5 to 6.5 over ten rounds, his word on the stills: "its ok for now". Dark is only for a later pass over every page at once.

Mockups, not game screens. HTML with real game art, in E:/FightCamp/tmp/s393/menu/.

## The direction
Real fighters on the arena dark. No room, no desk, no cartoon, no whiteboard.
- Home opens with the next fight as a matchup poster: the two real faces, red corner and blue corner, days to fight night, then weigh-in, date and limit.
- Under it, one row per fighter (the Camp Board structure the operator liked): next fight, weight, condition, this week.
- Right column: Needs you, Since last Monday (each line says why), Coming up.
- One Continue, top right. Five rail buttons, as in PLAYER_PATH.

## Why
- The owner rejected cartoon art as not serious; the 3D portraits are our best asset and were on no menu screen as the hero. They are rendered on black, so a dark screen takes them with no cut-out.
- FM26's lesson (MENUDIR_RESEARCH_S388): speed beats looks. Everything weekly is on Home at 0 or 1 clicks. A room would have been a decoration, and no review praises one.
- Red and blue mean the two corners only, so the colour has a boxing reason.
- Fonts are already in the game: Bebas Neue for names, Barlow for everything else. This also ends the misread brush digits the S391 critic found.

## What it replaces
The whiteboard look and marker fonts. The bible says the skin comes last, after plain screens and strangers: this page is the direction to aim at, not a request to reskin now. Layout and rail can be built into the plain screens first.

## Known limits
Portraits show a red top on every fighter, so every face is cropped above the straps. Numbers in the mockups are invented.

## Blind review, 8 rounds, a fresh reviewer each (bar 7)
Round: Home, Fighter, Fights. 1: 6, 5, 6. 2: 5.5, 6, 6.5. 3: 6.5, 7, 6.5. 4: 7, 7, 6. 5: 6.5, 6, 6.5. 6: 6.5, 7, 6. 7: 7, 6.5, 6. 8: 7, 6.5, 6.
Reviewers differ by about a point on near-identical screens. Every round from 3 on: it looks serious, Home reads in 5 seconds, the set is one game.
What moved the score: studio portraits (assets/ui/face/studio) keyed onto a dark backdrop (the raw 3D ones looked uncanny large), Needs you first, real data, a club badge.
What is left, in every round: the portraits are bare heads with no kit. That needs a new render pass in hard gym light, shoulders and fight kit, not more layout. Also: the anatomy figure reads medical; "closer to a dashboard than boxing"; Fights has too many buttons.
Files: E:/FightCamp/tmp/s393/menu/ home3, fighter3, fights3 (.html, .png), darkbg.py. Home passed and was shown; Fighter and Fights are under 7 and were not.
