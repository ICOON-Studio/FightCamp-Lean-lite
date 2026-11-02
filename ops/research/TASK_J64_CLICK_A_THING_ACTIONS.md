# TASK J64 - Research: "click a thing on screen, see what it can do" - how famous sims link actions to objects and people (research only, no code)

You are John, a research agent. No shell, no repo needed. Everything is on this page. Reply in this chat with ONE document.

## Context
FightCamp is a boxing gym management game (Godot 4, 3D). The main screen is ONE 3D boxing gym seen from above at an angle: a ring,
a bag line, speed bags, a mirror wall, a cardio corner, a weights corner, a stretch corner, an office with a window onto the floor.
One fighter trains through a day while a clock runs; the player clicks a station and the fighter walks there and trains.
The operator (studio CEO, 40 years of games) wants this, verbatim (2026-10-08):
"if you click on the fighter you can call any available coach . is that a good idea ? can you make an interface like that to link
actions available by assets in the screen, but check first what games are famous for this and how they achived it"

## Prior research (do not repeat it)
J61 (2026-10-03) found Two Point Hospital's training room = click the lectern (the object) -> one course screen. J62 listed continuous-time
references (Two Point Hospital, Prison Architect, Planet Coaster, Motorsport Manager, Football Manager) but did NOT study how selection and
object actions work. That is the gap.

## What would a human do?
A designer would open the games that are famous for it, click a person, click an object, and write down exactly what appears, how many
choices, what is greyed out and why, and what the cursor/hover shows before the click.

## The questions
1. For each game: The Sims 4 (pie menu), RimWorld (select pawn, right-click a target = float menu; the gizmo bar), Prison Architect,
   Two Point Hospital / Two Point Campus (click staff / patient / room / object), Planet Coaster or Planet Zoo, Jurassic World Evolution 2,
   Chef: A Restaurant Tycoon Game, Big Ambitions, one Kairosoft game, Football Manager's touchline shouts (as the non-3D contrast):
   a. Selection model: do you select the ACTOR first then the TARGET, the TARGET first, or both work?
   b. What appears on click: radial/pie menu, a list at the cursor, a side panel, a bottom bar of buttons? How many actions at most?
   c. Unavailable actions: hidden, or shown greyed with a reason? (e.g. "coach busy until 14:00")
   d. Hover before the click: what does the cursor or a tooltip show?
   e. Does time stop while the menu is open?
   f. Keyboard/mouse: left vs right click, shortcuts, how you cancel.
2. Which game is most praised for this (reviews, player quotes with dates) and which is criticised (too many clicks, hidden actions)?
3. For OUR case, recommend ONE model and draw it in words: click the fighter -> what appears (e.g. "CALL A COACH" listing every
   available coach with what he is good at and how much of his week is left); click a coach; click a station; click the office window;
   click a person walking in from the street. Max 6 actions per thing.

## Prefab check
Name any Godot 4 addon or open-source project that ships a radial / context-action menu (Asset Library, GitHub), with licence.

## Deliverable
ONE document, answer first, a table per question, every claim tagged SOURCED (url + date) or JUDGEMENT. Max 250 lines.
Title it "J64 - Click a thing, see its actions".
