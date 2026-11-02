# TASK J62 - THE EXACT SCREEN LOGIC OF THE PROS, HUB BY HUB (John, research only)

Model: any. Owner: John (gbot). Research only - no code, no repo edits. Output: `research/J62_HUB_REFERENCE_LOGIC.md`.

## Why (operator, 2026-10-05, on the exported .exe)
He opened a coach candidate and said: "nothing is explained - no tooltips, what the fuck is weeks?" and "does that look like a
AAA-management game panel?" Then: "ask for others to design each menu and hub if necessary so that the game makes sense; copy
another similar game's exact logic and build from there." This task is the copy source.

## Prior research (read first, do not redo)
- `J54_MENU_ARCHITECTURE_SURVEY.md` (yours): 11 games, the five-area rail, the job map. Settled; this task goes one level DOWN: the
  screens inside each area.
- `S81_FIGHT_BUSINESS_SURVEY.md` (The Fight Business: Boxing Manager, Steam 5249680), `PROFILE_IA_THREE_VERSIONS.md` (profile IA),
  `J52_TOOLTIPS_AND_TUTORIAL.md` (how management games explain themselves), `K78_S79_WORDS.md` (our words).
- The shipped screens to compare against: stills in `previews/s165_exe_walk/` (HOME, scouting, candidate, offers, camp,
  fight night, result) and `previews/s165_story_beside/` (schedule MY GYM, inbox).

## What would a human do?
A UX lead copying the leaders does not describe them in prose. They open the reference screen and transcribe it FIELD BY FIELD, in
reading order, with the scale of every number, the words of every button and every tooltip they can find, then diff that against
their own screen. That transcript is what the designer and the artist build from.

## The job
For each of our hubs, transcribe the matching screen of the closest shipped games, field by field:
1. **Staff candidate / staff profile** (our THE CANDIDATE drawer for a coach): Football Manager 24 staff profile + staff search
   (attributes 1-20, coloured bands, role suitability stars, contract ask: wage, length, release clause; the "Overview" verdict line),
   Motorsport Manager HQ staff hiring (stats, salary, contract length in races, "sign" flow), The Fight Business staff screen.
2. **Fighter candidate / scouting list** (our SCOUTING table + THE CANDIDATE for a boxer): FM24 player search + scouting report
   (ability/potential stars with uncertainty, the recommendation line, the asking price, what the scout says in words), The Fight
   Business recruit screen, Boxing Manager-type games (World Championship Boxing Manager 2).
3. **Fighter profile** (our athlete profile tabs): FM24 player profile overview (identity strip, attributes, form, contract, happiness).
4. **Schedule / offers** (our FIGHTS: SCHEDULE, OFFERS, LADDER): FM24 schedule + the match-offer equivalent in WCBM2 / The Fight
   Business (an offer row: opponent, purse, date, venue, accept/decline, what the game says about the match-up).
5. **Finance** (our FINANCE): FM24 finances overview (balance, wage budget, projections, the sentences it writes about your situation),
   Motorsport Manager finances.
6. **HOME** (our day feed): FM24 home/inbox, MM home (what is pinned, what counts, how "next up" is phrased, how many calls to action).

For EACH reference screen give: the fields in reading order; the scale and band words of each number (e.g. "1-20, green at 15+");
the primary button's exact words; how each term is explained (tooltip, hover card, side text); the one sentence the game writes for the
player. Mark SOURCED (a page/manual/screenshot you read today, cite it) vs PROXY (community source / memory). Then, per hub, a short
"copy this" table: our field -> the reference field it should become, and the fields we show that no leader shows (candidates to cut).

## Prefab check
Published screenshots and manuals: FM24 manual (sigames.com), the FM wiki, Steam store pages and community guides for The Fight
Business and WCBM2, Motorsport Manager wiki. No paid tools.

## Acceptance
`J62_HUB_REFERENCE_LOGIC.md` with the six transcripts (field tables), source list with IDs, and the six "copy this" tables. Under
900 lines. Answer first; no process narrative.

## OPTION B - "the gym is the menu" (operator, 2026-10-05, 18:40, verbatim: "remove the menus and use the 3d engine maybe for everything ? put a timeline bar on top to progress continuously and pose in menus or something like that")
Answer this alongside the hub work, as a second direction: no rail; the 3D gym (we have it, with room pins and the ring) IS the home;
you click a room, a person or the ring and a panel opens OVER the 3D view; a TIMELINE BAR across the top runs time continuously
(day ticks, with pause / 1x / 3x) and PAUSES whenever a panel is open; dated things (weigh-in, fight night, bills, offers expiring)
sit on the bar ahead of the playhead. References to transcribe for this option: Two Point Hospital (clock + speed + the building as the
menu), Planet Coaster / Prison Architect (click an object, panel over the world, time controls), Motorsport Manager (the race-day
timeline), Football Manager's continue-until-the-next-event vs a real-time clock. Say what each one does when a decision is due
(does time stop? a card? a flashing pin?) and what a boxing-gym manager loses or gains by going continuous: the one-decision-a-day
rhythm, the week review, the fight camp count-down. Give one page per option: A (rail + hubs, repaired) and B (gym-as-menu +
timeline), with the same first hour walked through both, so the operator can choose on paper (DESIGN_ON_PAPER_S159 rule).
