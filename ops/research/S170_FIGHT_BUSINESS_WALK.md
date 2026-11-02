# S170 - THE FIGHT BUSINESS: Boxing Manager demo, walked by computer-use (2026-10-06)

Source read: the live demo (Steam 5299070, E:\SteamLibrary), New Demo Career, Mode "Trainer + Promoter", demo ends 30 June 2026.
Screens opened by me: Command Center, Fight Offers, Finance, Scouting, Recruitment, Stable, Training (+ fighter panel), Facilities.
Not walked yet: Shows creation, Fight Night, Contracts, Medical, Staff, Inbox, an Advance Day cycle.

## What it is
A pure menu/spreadsheet manager: dark navy + gold panels over stock arena art, NO 3D gym, no fighter bodies, no floor. Start
= 3 signed fighters (Okafor #7, Price #9, Boone #14), GBP 400k promoter cash + GBP 20k gym cash, reputation 32.

## Patterns worth copying (ours = what we already have)
- COMMAND CENTER: one page, 5 KPI tiles, NEXT EVENT, PRIORITY DESK ("DESK CLEAR" when nothing needs a decision), finance snapshot,
  timeline, news pulse, 5 quick-action buttons. Ours: MY GYM NEXT UP + inbox. Idea: an explicit empty state "DESK CLEAR".
- Two cash pools named and explained (Gym cash vs Promoter cash, working capital = derived, "not a separate wallet"). Ours: one bank.
- SCOUTING text states the rule: confidence != quality; Ability Estimate = current view, Potential = uncertain ceiling; scouting
  narrows uncertainty without changing the fighter. Our candidate card (1-20 + band word) matches the intent.
- RECRUITMENT table: name, age, division, record, rank, gym, previous promoter, ability est "-", potential "-", scouting "UNKNOWN",
  est. purse, VIEW / APPROACH. Unscouted = dashes. This is the shape for our M42 offer_row.
- TRAINING: stable list -> one panel: readiness/fatigue/morale, background focus (Balanced/Power/Speed/Technique/Conditioning/
  Boxing IQ), five attribute bars with "progress to next", staff impact lines, "no daily session is required - weekly tick".
  Training is a focus pick + weekly tick, nothing to watch. Our floor (watch it happen) is already a step beyond.
- FACILITIES: 6 buildings with level, "NEXT:" benefit, cost, days, weekly upkeep, gate "requires premises L2".
- Loading says "First-time setup may take a little longer" (honest ~15 s career build).

## Where ours is ahead / behind
- Ahead: 3D gym rooms, live fight, a boxer you watch, story cards, name field, tutorial guide.
- Behind: information density on one page (Command Center), a named desk-clear state, facility ladder with upgrade costs, recruitment filters
  (division / age range / sort) in one row.

## Traps hit driving it
- open_application on a steam:// URI fails; start the exe directly. Its window opens MINIMISED at (-32000,-32000): restore via ShowWindow.
- Grant by display name "THE FIGHT BUSINESS BOXING MANAGER Demo" AND the exe basename, or its window stays masked.
- Layout shifts after the first click (side menu expands) - screenshot between clicks, never batch coordinates from an old frame.
