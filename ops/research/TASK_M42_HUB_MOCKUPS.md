# TASK M42 - THE CANDIDATE CARD AND THE FOUR HUBS, MOCKED THE WAY THE PROS SHIP THEM (Maria, art direction)

Model: any. Owner: Maria (gbot, NEW chat). Pictures + a short spec, never code. Output: `research/M42_HUB_MOCKUPS.md` + images
under `research/previews/m42/` (PNG, 1920x1080, our M32 palette and M33 type).

## Why (operator, 2026-10-05, on the exported .exe)
On the coach candidate panel: "does that look like a AAA-management game panel?" - it does not: four raw-number boxes in meaningless
colours, no portrait, no scale, no verdict, a "gap" block that repeats itself in jargon, the guide card covering the panel's buttons.
He asked that each menu and hub be designed by copying a similar game's exact logic.

## Prior research (read first)
Your `M32_MENU_ART_DIRECTION.md`, `M33_ICONS_AND_TYPE.md`, `M34_PITCH_PRESENTATION.md`, `M40_THE_WEEK_REVIEW_LOOK.md` (the one screen
the operator liked - keep that quality bar), `M41` (your scene-tree pictures). `PROFILE_IA_THREE_VERSIONS.md` (seven shared rules).
John transcribes the reference screens field by field in `J62_HUB_REFERENCE_LOGIC.md`; Kalli audits the gaps in
`K86_SCREEN_GAP_AUDIT.md`. Use them when they land; until then mock from Football Manager 24 and Motorsport Manager as you know them
and say so.

## The shipped screens you are replacing
`previews/s165_exe_walk/14_candidate.png` (fighter candidate), the operator's coach candidate frame (teaching 59 / tactics
50 / rating 55 / weeks 29 tiles), `21_home_signed.png` and `31_home_booked.png` (HOME), `25_offers.png` (FIGHTS offers),
`s165_story_beside/20_my_gym_next_up.png` (SCHEDULE), the FINANCE screen (`Godot/scripts/MoneyHubPanel.gd` if you need the fields).

## What would a human do?
A AAA UI artist takes the reference's LOGIC (what is shown, in what order, how a number is explained) and dresses it in the house
style, never the reverse. One mock per screen at game size, then a redline: every text's exact words, size, colour token, every
tooltip's words, where the primary button sits, what the empty state says.

## The job (in this order; ship each as it is done)
1. THE CANDIDATE - coach, and THE CANDIDATE - fighter: identity strip (portrait, name, flag, age, role/division), attributes on a stated
   scale with band colours AND band words, one verdict sentence, the ask in plain words, "what changes in your gym" (one line), one
   primary button, one quiet button. The guide card must have a home that never covers it.
2. HOME with one booked fighter (keep the 3D gym and the pins; fix the right column's hierarchy and the fighter row).
3. FIGHTS - OFFERS (an offer row the way a boxing manager shows it: opponent card, purse, date, venue, the match-up sentence, accept).
4. FINANCE overview (balance, weekly net, next bill, the sentence about your situation).

## Prefab check
Our own UIKit components (`Godot/scripts/UIKit.gd`: pair, plate, button, filter_strip, tip) - design with what exists where it fits;
name any new component once.

## Acceptance
Mocks at 1920x1080 for the five screens + `M42_HUB_MOCKUPS.md` with the redlines (every label's words, tooltip texts, colour tokens).
Answer first, no process narrative.

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
