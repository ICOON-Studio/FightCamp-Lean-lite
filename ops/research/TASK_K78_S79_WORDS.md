# TASK K78 - KALLI - THE WORDS FOR S79: THE NEW TUTORIAL, THE CAMP GATE, HOME AND THE RAIL (words only)
Model: Kalli. Owner: kalli. Assigned S79, 2026-09-25. Words only - no code, no commits.

## Why
Your K77 voice is live in the Handbook (65 lines applied). S79 then changed the game under the tutorial: THE DAY is
now HOME (J54), the rail is HOME / FIGHTERS / FIGHTS / MONEY with pages under each, a booked fighter with no camp now
blocks CONTINUE until the manager answers "SET CAMP" or "GO COLD", and the tutorial grew to 24 steps (a real
training plan, the camp, the corner). Claude wrote those lines as placeholders; they need your house voice.

## What would a human do?
A UX writer on a shipped management game rewrites every new string in one pass against the voice sheet, checks each
fits its container, and flags any word that means two things (you already found `condition`).

## The strings (current placeholder -> yours; keep each within the budget shown)
1. The 24 coach lines (`CoachMarks.gd` STEPS[].say, <= 2 sentences, <= 170 characters each). Current text, in order:
   new_career "I'm your head coach. Let's open a gym and get a fighter to his first bout." / country "Pick the country
   your gym works in. It sets the money, the talent and the shows." / city "Pick a city. The gyms already there are the
   ones you will fight." / gym "Name your gym - the name also draws your floor and first fighters. Rest the mouse on any
   word to see what it means." / home "This is Home. What needs you today, your next bout and your fighters are all
   here." / gym_floor "Open your fighters: each one's record, condition and weight, and the gym floor." / training
   "Nobody improves resting. Open training." / set_plan "Pick a day on his row, then click a session twice to set it.
   Hard work builds skill but tires him." / schedule "Fights are booked here. Promoters send offers for dated cards." /
   offers "Open the offers." / fair_match "For a first bout pick an even match: similar weight, age and experience." /
   enter_card "Accept to book it. He has to make the weight limit on weigh-in day." / back_home "He is booked. Back
   home - and no coach sends a man in without a camp." / set_camp "Continue waits until you answer: set his camp, or
   send him in cold." / open_camp "The camp is the weeks before the fight: sparring, the game plan and the weight." /
   start_camp "Choose what the camp builds and how hard it trains, then start it. Every week adds readiness for this
   opponent." / leave_camp "He is in camp. Close this - Continue now moves the days." / to_fight_week "Press Continue,
   day by day. Camp, costs and news run each day." / fight_week "Fight week: the camp is done. Keep it light so he
   arrives fresh." / weigh_in "The weigh-in. Over the limit means a fine, or no fight at all." / fight_night "He made
   weight. On to fight night." / begin_fight "The clock is top left. Between rounds his corner asks you for one
   instruction." / corner "The round is over and you are in his corner. Pick one instruction; it holds next round." /
   result "That is the loop: train, book, camp, make weight, fight. The result and any medical suspension are on his card."
2. The camp gate row on HOME: kind chip "CAMP", detail "No camp - N weeks to the fight · readiness N%", buttons
   "SET CAMP" and "GO COLD" (<= 10 characters each), the GO COLD tooltip "Send him in without a camp. His readiness
   stays where it is." (<= 15 words), and the refusal "SET HIS CAMP - OR SEND HIM IN COLD" (<= 40 characters).
3. The rail: area names HOME, FIGHTERS, FIGHTS, MONEY; pages ROSTER & FLOOR, TRAINING, SCOUTING, SCHEDULE, RANKINGS,
   OFFICE, STAFF; and one tooltip per area (<= 12 words, starts with a verb).
4. The fight HUD: "R2 1:34", "BREAK 0:45", "CORNER: HOLD THE CENTRE", "CORNER: NO ORDER YET".
Keep "the gym" (never "camp") for the building; "fight camp" is only the preparation. Avoid "he" where your K77 ban 1
applies, or say why a line keeps it.

## Deliverable
`K78_S79_WORDS.md`: a table per section - id | current | proposed | budget - plus anything that clashes.
