# TASK K86 - THE GAP AUDIT: what the settled design says vs what every shipped screen does (Kalli, design only)

Model: any. Owner: Kalli (gbot, NEW chat). Study + pictures only, never code. Output: `research/K86_SCREEN_GAP_AUDIT.md`
(+ optional sketches under `research/previews/k86/`).

## Why (operator, 2026-10-05, playing the exported .exe)
- HOME, empty gym: "nowhere says Scouting in the screen" (the FIRST JOB card said Open Scouting; the rail hid the Fighters pages).
- THE CANDIDATE (a coach): "nothing is explained - no tooltips, what the fuck is weeks?" and "does that look like a AAA-management
  game panel?" Then: "you are a AAA class lead game designer, shouldn't you go through the right menu structure?"
Two hotfixes shipped today (Fighters area open on an empty gym; tooltips on the tiles). The structural pass is this task.

## Prior research (read first - these are the rules the screens were supposed to follow)
`J54_MENU_ARCHITECTURE_SURVEY.md` (five areas, HOME answers "what needs me"), `K78_S79_WORDS.md` (one word per job),
`J52_TOOLTIPS_AND_TUTORIAL.md`, `PROFILE_IA_THREE_VERSIONS.md` (the seven shared AAA rules: identity strip, decide-first,
progressive disclosure, honest empties, entity links, one primary CTA), `M32_MENU_ART_DIRECTION.md`, `M33_ICONS_AND_TYPE.md`,
`G109_HUB_LIVE_COUNTS.md`, `S74_READINESS_AUDIT.md`. Your own K85 scene-tree review and `SCENETREE2` v4.

## The evidence (the shipped screens)
Stills, all from the exported build today: `previews/s165_exe_walk/` (01 boot ... 59 next_week: title, creation, HOME
empty and booked, scouting, candidate, offer table, fights hub, offers, camp setup, week review, fight week, weigh-in, fight night,
result, HOME after the bout), `previews/s165_story_beside/` (gym step with the three questions, schedule MY GYM, THE INBOX),
and the operator's own frame of the coach candidate (teaching/tactics/rating/weeks tiles, the gap block, the guide card over the
panel's buttons).

## What would a human do?
A lead designer makes ONE table: every screen x every settled rule, PASS / FAIL with the pixel evidence, then ranks the FAILs by what a
first-hour player hits first. They do not redesign everything; they fix the rule breaks and redesign the one or two screens that
cannot be fixed by a rule (the candidate card).

## The job
1. **The IA map as it IS**: every screen reachable by click, its rail area, how it is reached (which button, from where), which words
   lead there. Mark every button whose words name something NOT on the screen it sits on (the Scouting case), every sub-page hidden
   behind a closed group, every term shown without a tooltip or scale.
2. **Rule x screen table** (the seven PROFILE_IA rules + J54's HOME rule + K78's one-word rule + J52's explain rule): PASS/FAIL per
   screen with the still's filename as evidence.
3. **Ranked defect list** (first-hour first), each with the smallest fix in one line.
4. **THE CANDIDATE card, redesigned on paper** for a coach AND a fighter, copying the Football Manager staff/player profile logic (John
   is transcribing the references in J62; if his file is not there yet, use what you know of FM24 and say PROXY): identity strip
   (portrait slot, name, flag, age, role), attributes on a stated scale with band words, ONE verdict sentence, the ask in plain words
   ("$890 a week for 29 weeks; $1,780 to sign"), what signing changes in OUR gym (one line from the gap data), ONE primary button, the
   guide card never covering it. Wireframe as ASCII or a picture; every label's exact words; every tooltip's text.

## Prefab check
None to buy: this is a design audit of our own screens against our own settled studies and the FM24 pattern.

## Acceptance
`K86_SCREEN_GAP_AUDIT.md`: the IA map, the rule x screen table, the ranked list (<= 25 rows), the candidate card spec (both kinds)
with every word written. Answer first, no restated ask, no process narrative. Under 700 lines.

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
