# K78 - S79 WORDS: TUTORIAL, CAMP GATE, HOME, RAIL, FIGHT HUD

Owner: Kalli. Words only. Voice = K77 sheet (Handbook neutral; coach senior, warm, blunt; five bans). Claude applies.
Every coach line is script-checked: at most 170 characters, at most 2 sentences, no banned word or construction. Counts are in the budget column.

## Rulings

- **No he, his or him anywhere.** All 24 coach lines and the gate tooltip are rewritten to "the fighter" / "your fighter". No line needs to keep "he", because every string is static and the roster includes women.
- **Building vs preparation.** "gym" is only the building. "fight camp" or "camp" is only the preparation. Chip `CAMP` and buttons `SET CAMP` are the preparation meaning, so they stay.
- **One word per job.** "bout" is one booked fight in coach sentences. `FIGHTS` is the rail area (plural). "instruction" is the between-rounds call everywhere (coach lines and HUD). "order" is dropped.
- **Hover lesson** stays off the name step (K77) and now lives on `home`, which replaced `the_day`.
- **Controls in capitals** only where the task names the on-screen label (HOME, FIGHTERS, TRAINING, SCHEDULE, ROSTER & FLOOR, SET CAMP, GO COLD, CONTINUE). "the offers", "fight night" and the accept button stay lower case, because I have not seen their labels.

### Argued against my strongest ruling: keep GO COLD?
Against: "GO COLD" is fight-trade slang, and a new player may not know it. "SKIP CAMP" says exactly what happens.
Kept GO COLD. "SKIP" reads like skipping a tutorial screen, and the refusal plus tooltip both explain it in plain words. The pair SET CAMP / GO COLD also reads as a real choice, not as a do-it or dismiss pair.

## 1. Coach lines (`CoachMarks.gd` STEPS[].say)

| id | current | proposed | budget |
|---|---|---|---|
| `new_career` | I'm your head coach. Let's open a gym and get a fighter to his first bout. | Open a gym and get one fighter to a first bout. I'm your head coach, and I'll walk you through each step. | 105/170 ch, 2/2 sent |
| `country` | Pick the country your gym works in. It sets the money, the talent and the shows. | Pick the country your gym works in. It sets the money, the talent and the shows you can book. | 93/170 ch, 2/2 sent |
| `city` | Pick a city. The gyms already there are the ones you will fight. | Pick a city. The gyms already there are your rivals. | 52/170 ch, 2/2 sent |
| `gym` | Name your gym - the name also draws your floor and first fighters. Rest the mouse on any word to see what it means. | Name your gym. The name also draws your floor and your first fighters. | 70/170 ch, 2/2 sent |
| `home` | This is Home. What needs you today, your next bout and your fighters are all here. | This is HOME, with what needs you today, your next bout and your fighters. Rest the mouse on any word to see what it means. | 123/170 ch, 2/2 sent |
| `gym_floor` | Open your fighters: each one's record, condition and weight, and the gym floor. | Open FIGHTERS to see each fighter's record, condition and weight. The gym floor is there too, under ROSTER & FLOOR. | 115/170 ch, 2/2 sent |
| `training` | Nobody improves resting. Open training. | Open TRAINING. Nobody gets better resting. | 42/170 ch, 2/2 sent |
| `set_plan` | Pick a day on his row, then click a session twice to set it. Hard work builds skill but tires him. | Pick a day on a fighter's row, then click a session twice to set it. Hard sessions build skill but tire the fighter. | 116/170 ch, 2/2 sent |
| `schedule` | Fights are booked here. Promoters send offers for dated cards. | Open SCHEDULE to book fights. Promoters send offers here for dated cards. | 73/170 ch, 2/2 sent |
| `offers` | Open the offers. | Open the offers. Each one is a bout on a dated card. | 52/170 ch, 2/2 sent |
| `fair_match` | For a first bout pick an even match: similar weight, age and experience. | Pick an even match for a first bout. Look for similar weight, age and experience. | 81/170 ch, 2/2 sent |
| `enter_card` | Accept to book it. He has to make the weight limit on weigh-in day. | Accept the offer to book the bout. Your fighter has to make the weight limit on weigh-in day. | 93/170 ch, 2/2 sent |
| `back_home` | He is booked. Back home - and no coach sends a man in without a camp. | The bout is booked, so go back to HOME. No coach sends a fighter in without a fight camp. | 89/170 ch, 2/2 sent |
| `set_camp` | Continue waits until you answer: set his camp, or send him in cold. | Answer the camp row with SET CAMP or GO COLD. CONTINUE stays locked until you do. | 81/170 ch, 2/2 sent |
| `open_camp` | The camp is the weeks before the fight: sparring, the game plan and the weight. | Press SET CAMP to open the fight camp. It covers the weeks before the bout, with sparring, the game plan and the weight. | 120/170 ch, 2/2 sent |
| `start_camp` | Choose what the camp builds and how hard it trains, then start it. Every week adds readiness for this opponent. | Choose what the camp builds and how hard it trains, then start it. Each week adds readiness against this opponent. | 114/170 ch, 2/2 sent |
| `leave_camp` | He is in camp. Close this - Continue now moves the days. | Close this screen now that the fighter is in camp. From here CONTINUE moves the days forward. | 93/170 ch, 2/2 sent |
| `to_fight_week` | Press Continue, day by day. Camp, costs and news run each day. | Press CONTINUE one day at a time. Camp work, costs and news all run each day. | 77/170 ch, 2/2 sent |
| `fight_week` | Fight week: the camp is done. Keep it light so he arrives fresh. | Keep the work light so your fighter arrives fresh. The camp is done and this is Fight Week. | 91/170 ch, 2/2 sent |
| `weigh_in` | The weigh-in. Over the limit means a fine, or no fight at all. | This is the weigh-in. Over the limit means a fine, or no fight at all. | 70/170 ch, 2/2 sent |
| `fight_night` | He made weight. On to fight night. | Your fighter made weight, so go on to fight night. | 50/170 ch, 1/2 sent |
| `begin_fight` | The clock is top left. Between rounds his corner asks you for one instruction. | Watch the clock at top left. Between rounds the corner asks you for one instruction. | 84/170 ch, 2/2 sent |
| `corner` | The round is over and you are in his corner. Pick one instruction; it holds next round. | Pick one instruction for the next round. You are in the corner now, and your call holds for that round. | 103/170 ch, 2/2 sent |
| `result` | That is the loop: train, book, camp, make weight, fight. The result and any medical suspension are on his card. | Train, book, camp, make weight and fight, then do it again. The result and any medical suspension are on the fighter's card. | 124/170 ch, 2/2 sent |

## 2. Camp gate row on HOME

| id | current | proposed | budget |
|---|---|---|---|
| `chip` | CAMP | CAMP | chip (4 ch, 1 w) |
| `detail` | No camp - N weeks to the fight · readiness N% | No fight camp · N weeks out · readiness N% | row line (see plural note) (42 ch, 10 w) |
| `btn_set` | SET CAMP | SET CAMP | <= 10 chars (8 ch, 2 w) |
| `btn_cold` | GO COLD | GO COLD | <= 10 chars (7 ch, 2 w) |
| `tip_cold` | Send him in without a camp. His readiness stays where it is. | Send the fighter in with no fight camp. Readiness stays where it is. | <= 15 words (68 ch, 13 w) |
| `refusal` | SET HIS CAMP - OR SEND HIM IN COLD | SET A CAMP OR GO COLD FIRST | <= 40 chars (27 ch, 7 w) |

Plural note: `detail` needs "1 week out" when N is 1. If the code cannot branch, use "N wk out" for every N.

## 3. The rail

| id | current | proposed | budget |
|---|---|---|---|
| `area_home` | HOME | HOME | area (4 ch, 1 w) |
| `area_fighters` | FIGHTERS | FIGHTERS | area (8 ch, 1 w) |
| `area_fights` | FIGHTS | FIGHTS | area (6 ch, 1 w) |
| `area_money` | MONEY | MONEY | area (5 ch, 1 w) |
| `page_roster` | ROSTER & FLOOR | ROSTER & FLOOR | page (14 ch, 3 w) |
| `page_training` | TRAINING | TRAINING | page (8 ch, 1 w) |
| `page_scouting` | SCOUTING | SCOUTING | page (8 ch, 1 w) |
| `page_schedule` | SCHEDULE | SCHEDULE | page (8 ch, 1 w) |
| `page_rankings` | RANKINGS | RANKINGS | page (8 ch, 1 w) |
| `page_office` | OFFICE | OFFICE | page (see clash 6) (6 ch, 1 w) |
| `page_staff` | STAFF | STAFF | page (5 ch, 1 w) |
| `tip_home` | (none) | See what needs you today, your next bout and your fighters. | <= 12 words, verb first (59 ch, 11 w) |
| `tip_fighters` | (none) | Check your roster and gym floor, set training and scout fighters. | <= 12 words, verb first (65 ch, 11 w) |
| `tip_fights` | (none) | Book bouts from offers and see where your fighters rank. | <= 12 words, verb first (56 ch, 10 w) |
| `tip_money` | (none) | Check your cash, your office and your staff. | <= 12 words, verb first (44 ch, 8 w) |

Tooltips assume this page mapping, which I **have not seen** (INFERENCE): FIGHTERS holds ROSTER & FLOOR, TRAINING, SCOUTING. FIGHTS holds SCHEDULE, RANKINGS. MONEY holds OFFICE, STAFF. If the mapping differs, the FIGHTERS, FIGHTS and MONEY tooltips must change to list their real pages.

## 4. Fight HUD

| id | current | proposed | budget |
|---|---|---|---|
| `clock` | R2 1:34 | R2 1:34 | live clock (7 ch, 2 w) |
| `break` | BREAK 0:45 | BREAK 0:45 | between rounds (10 ch, 2 w) |
| `corner_set` | CORNER: HOLD THE CENTRE | CORNER · HOLD THE CENTRE | HUD label (24 ch, 5 w) |
| `corner_none` | CORNER: NO ORDER YET | CORNER · NO INSTRUCTION | HUD label (23 ch, 4 w) |

The middle dot replaces the colon so the HUD matches the gate row separator. The colon ban is for sentences, so this is a consistency call, not a ban fix.

## Clashes and flags

1. **condition (open since K77).** `gym_floor` says a fighter's "condition". The Handbook `condition` entry is equipment wear (alias `COND`). Hovering that word on the FIGHTERS page will show the equipment meaning. Settle by renaming the Handbook term to "Equipment condition" and giving body condition its own entry.
2. **BREAK vs the Pass 3 phase words.** Pass 3 named the between-rounds phase `CORNER`. The HUD now shows `BREAK 0:45` on the clock and `CORNER ·` on the instruction line. My ruling is that `BREAK` stays on the clock and `CORNER` only labels the instruction, so the phase word CORNER is not used twice.
3. **"camp" alone.** The chip, the buttons and "in camp" use camp without "fight". That is allowed because none of them sits near the building. Any string that says "camp" and "gym" in one line must say "fight camp".
4. **CENTRE spelling.** The HUD uses British "CENTRE". Every other string must use British spelling too, or all must switch.
5. **CONTINUE lock.** `set_camp` says CONTINUE stays locked. If the real button stays clickable and shows the refusal instead, change the second sentence to "CONTINUE will not move the days until you do."
6. **OFFICE under MONEY.** The word "OFFICE" does not say money, and it echoes the old `CONTINUE TO OFFICE` that Pass 2 killed. I kept it because I have not seen what the page holds. If it is the accounts, rename it `BOOKS`, matching the Pass 3 gold `OPEN THE BOOKS`.

## NOT COMPUTED (claims kept from the placeholders, not checked in code)

- `gym`: the name draws the floor and first fighters. Settle by reading the career-start generator.
- `fair_match`: what counts as an even match.
- `corner`: "your call holds for that round". K72 found CornerAdvice is speech only and only `FightPlans.PACES` is wired. If that is still true, use "Pick one instruction for the next round. You are in the corner now." (65 ch).
- `fight_night`: assumes the fighter made weight. There is still no coach line for a missed weigh-in.
- `start_camp`: that readiness is built against this specific opponent.
- `tip_cold`: that readiness stays exactly where it is.

## WHAT IS STILL WRONG

- None of these lines have been rendered in the 380px coach card or on the HOME row.
- The rail page mapping is inferred, not read.
- The missed-weight branch has no coach line.
- The condition clash is still open.
