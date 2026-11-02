# TASK K79 - KALLI - WORDS FOR THE S80 SCREENS (house voice)
Owner: kalli. Assigned S80, 2026-09-25. Words only - Claude applies them.

## Why
S80 rebuilt the front end in the operator's pick (M34 direction A): a new title, HOME as a picture of the gym with
pins, three area hubs (FIGHTERS locker room, FIGHTS office wall, FINANCE desk - the operator renamed MONEY to FINANCE),
and a fight-night sequence (tale of the tape -> bell). All their strings were written by Claude in a hurry and are
marked EXAMPLE in spirit. They need the K77 voice (Handbook neutral; coach senior, warm, blunt; the five bans; no
he/his/him - the roster includes women).

## What would a human do?
A game writer takes the screen inventory, reads each string in place (the screenshots), and rewrites to budget: same
job, fewer words, one word per job across screens.

## The strings (current text - rewrite each, keep the budget)
Title: eyebrow "EST. 2026 · A BOXING & MMA MANAGEMENT GAME" (<=48 ch) · tagline "Run the gym. Build the fighter.
Make the walk." (<=50 ch) · caption under Continue "<gym> · Week N · $cash" (keep format) · "LAST SAVE" card.
HOME pins (title <=14 ch, fact <=28 ch): Office "N offers waiting" / "No offers yet" · Staff room "Coach <name> · in" /
"N staff" · The ring "N of M on a plan" · Gym floor "<kit> · NN%".
HOME cards: NEXT FIGHT "Nobody is booked" + "N fight offers waiting in the office. Read them and put a fighter on a
card." (<=110 ch) + gold "Open offers" / "Set training" / "Plan this week" / "Enter fight week" · "Needs you" ·
"On the wire" · "Your fighters" + "N fighters · N of M floor spaces used" · card status lines "Ready to book",
"Training · ready to book", "Booked · N wk", "Fight camp · <focus>", "<injury> · rest N wk".
Hubs: FIGHTERS pins Roster "N fighters · N need you", Training "N of M on a plan", Scouting "Find and sign new talent";
FIGHTS pins Schedule "<name> · in N wk" / "Nobody booked yet", Rankings "Where your fighters stand", Offers "N waiting";
FINANCE pins The books "Net ±$N a week", Office "Cash $N", Staff "N on the books", Contracts "N fighters signed";
caption lines (<=80 ch) for each hub.
Fight night: "IN THE RED CORNER" / "IN THE BLUE CORNER", "TALE OF THE TAPE", the bell line "N weeks of fight camp.
N kg on the scale. Now it's three minutes." (and its cold variant "No fight camp. In cold."), "Space to skip",
"ON THE LINE TONIGHT".

## Deliverable
`research/K79_S80_WORDS.md`: a table per screen (id | current | proposed | budget), a rulings section, and
clashes. Also `research/CLAUDE_LAND_NOTE_K79.md` (5 lines). Screenshots to read them in place: `research/s80_look/` (Claude uploads
`current_look_sheet.jpg` into your chat; the full-size screens and the fight-night MP4 are in the same folder). Research only, no code, no HANDOFF edit.
