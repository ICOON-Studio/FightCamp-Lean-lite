# TASK_J49 - HOW THE INDUSTRY JOINS MECHANICS, ANIMATION AND UI (John, research only)

Model: John's Grok Bot, deep research. Owner: john. Assigned S73, 2026-09-25. No code, no repo test.

## Why
The operator asked (2026-09-25): *"i want to see the professional workflow that is done during the mechanics and the
ui ? how industry mix those to achieve what their audience expects"*. FightCamp is a management sim with a watched 3D
fight: a match engine decides, the 3D room shows it, and screens carry the career. We want the real production
workflow of games that sit on either side of that, sourced from the people who built them - not a genre essay.

## Questions - every claim SOURCED (link + date read: GDC Vault talk, studio blog, postmortem, interview) or NOT FOUND
1. **Fight games** - EA UFC (1-5), Fight Night Champion, Undisputed, and one of Tekken/Street Fighter if a production
   talk exists. For each: where the motion came from (mocap stage, fighters used, cleanup), the runtime animation system
   (state machine, blend trees, motion matching, physics hit reactions), how hits are resolved vs shown, and the in-fight
   HUD / broadcast presentation choices. Name the talk or article for each.
2. **Management sims with a watched match** - Football Manager (2D/3D match engine), Out of the Park Baseball, Motorsport
   Manager, and any MMA/boxing manager (e.g. Punch Club, World Championship Boxing Manager). How does the SIM decide and
   the VISUALS illustrate? What is shown live vs summarised? What did they cut to keep it readable?
3. **The pipeline order.** Across both groups: in what ORDER do studios lock mechanics, animation and UI (greybox first?
   vertical slice?), who signs off, and what is prototyped with placeholder art. Any published team structure or milestone
   plan counts.
4. **What the audience expects.** Any counted player-research, review-score analysis or studio statement on what players
   of these games judge first (readability of the fight, authenticity of motion, depth of menus).
5. **Motion matching specifically** - Ubisoft's GDC 2016 talk (Simon Clavet) and any fight-game use: what it needs
   (hours of mocap), and whether a small team without a stage uses it.

## What would a human do?
This whole study IS that question for game production: how do the real designers, animators and UI teams order and
join the work? (Collected S73: J49 answers it - logic first, playable ugly, sign-off, content, presentation, UI tuned
by players.)

## Rules
Every number and every "studio X did Y" SOURCED or NOT FOUND - never inferred from marketing. Say which claims come from a
developer talk and which from press. Tables first.

## Deliver
ONE markdown file, `J49_MECHANICS_MEET_PRESENTATION.md`, plus `CLAUDE_LAND_NOTE_J49.md` (5 lines: what finished, the
headline, what FightCamp should take). Nothing else.
