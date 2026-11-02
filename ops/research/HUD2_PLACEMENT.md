# HUD2 placement: every item, zone, Lucide icon, tooltip line (EXAMPLE)
- Icons are only from `Godot/assets/icons/lucide/`. Tooltip = the label as the title, plus the line below, which starts with a verb and doesn't repeat the label. Lines marked (game) are adapted from current strings in ShellChrome.gd. Everything else is EXAMPLE (Kalli owns words).
- Zones are **shared by A/B/C** unless the last column says otherwise.
- Zone codes: TL top-left · TC top-centre · TR top-right cluster · RS right objective stack · DK-S dock system column · DK-B dock big buttons · DK-G1/2/3 dock groups (people / fights / business) · BR bottom-right clock cluster · PNL inside a panel · W world-space.

| # | Item | Status | Zone | Lucide | Tooltip line (EXAMPLE) | A / B / C difference |
|---|---|---|---|---|---|---|
| 1 | Gym crest + name | current | TL crest plate | (crest art, no glyph) | Open the gym's profile: tier, rooms and record. | — |
| 2 | Home | current | DK-G1 | house | See what needs you today, your next bout and your fighters. (game) | — |
| 3 | Fighters + roster count badge | current | DK-B #1 | users | Check your roster, form and contracts. | A walnut/brass · B glass · C red kit bag |
| 4 | Training | current | DK-B #2 | dumbbell | Set each fighter's weekly training and follow his skills. (game) | as #3 (C blue bag) |
| 5 | Scouting (+lead badge) | current | DK-G1 | binoculars | Look for prospects to sign and study future opponents. (game) | — |
| 6 | Staff | current | DK-G1 | user-check | Hire and manage coaches and support staff. (game) | — |
| 7 | Fights + bookable-offer badge | current | DK-B #3 | swords | Find fight offers, book bouts and see the calendar. (game) | as #3 (C gold bag) |
| 8 | Rankings | current | DK-G2 | trophy | Check division tables and where your fighters stand. (game) | — |
| 9 | Finance | current | DK-G3 | wallet | Run the business: money, contracts, objectives and weight classes. (game) | — |
| 10 | Back arrow | current | PNL header, left of the title (on every open panel) + Esc | arrow-left | Return to the previous screen. (game, reworded) | — |
| 11 | Handbook (i) | current | DK-S | info | Replay a tutorial chapter. (game, verb-first) | — |
| 12 | Date plate "Mon 5 Jan 2026 Wk 1" | current | BR date plate | calendar | Open the month: bouts, bills and camp weeks. | A/C date in Bebas |
| 13 | CONTINUE "to Tue" | current | BR, between speed and MAIL | arrow-right | Skip to the next day once the must-answers are done. | — |
| 14 | Cash $25,000 (roster line in tooltip) | current | TR cluster, row 1 | banknote + trending-down/up | See bills, wages and who costs what. *Meta: Roster: 1 fighter · wages $1,800/wk* | A brass plate, Bebas 38 · B scorebug · C corner card |
| 15 | Notices bell | current | BR MAIL button | bell | Read results, offers and gym news. (game, verb-first) | — |
| 16 | Settings | current | DK-S | settings | Open the main menu, options, careers and exit. (game, verb-first) | — |
| 17 | Fighter panel: name, "08:00 MORNING · PADS" | club | TL card (A) · lower-third strip above the dock (B) · taped sheet (C) | — | Open his profile. | **differs by direction** |
| 17a | STAMINA bar | club | fighter panel | zap | Watch it fall as he works; below 30 he fades. | B label "STA" |
| 17b | STRAIN bar | club | fighter panel | flame | Keep it low; high strain risks injury. | B label "STR" |
| 17c | Mood word FRESH | club | fighter panel | circle-check | Read how he feels about today's work. | — |
| 17d | Move-card line | club | fighter panel | clock | See when the next move is ready to use. | — |
| 18 | Day goals (2 rows + checks) | club | RS card 2 "DAY GOALS 0/2" + Done bar | target (rows: zap, clock; check) | Tick both before the bell. | A walnut card · B glass card · C chalkboard rows |
| 19 | Day card MONDAY WEEK 1, STEP IN / SKIP THE DAY | club | RS card 3 | sunrise · play | Start the day on the floor, or skip it. | as #18 |
| 20 | GUIDE card: Set his training, OPEN TRAINING / SKIP THIS STEP | club | RS card 1 (teal strip) | map-pin · dumbbell | Follow the next step of your first month. | C: teal chalk title |
| 21 | Action ring (6 buttons) | club | W, on the clicked fighter, station or coach (unchanged) | existing ring glyphs, NOT VERIFIED | (unchanged) | — |
| 22 | Hover labels | club | W (unchanged) | — | (unchanged) | — |
| 23 | 2:00 real-time day, Space = pause | club | BR date plate: timer "1:24" + day bar; speed bar pause; paused frame + TC pause tab | timer · pause | Watch today's clock; the day ends at 0:00. / Stop the clock (Space). | — |
| 24 | Offers / booking / schedule tabs: MY GYM, LADDER, MY MONTH, THE CARDS, OFFERS, THE CORNER | live | PNL opened by DK-B Fights (one door, one name, per J61) | swords | (as #7) | — |
| 25 | Fight week / weigh-in / fight night / result | live | DK-G2, plus an RS card that appears once a bout is booked | calendar-clock | Follow the weigh-in, fight night and the result. | — |
| 26 | Fight camp | live | DK-G2 | biceps-flexed | Plan the weeks of build-up before a bout. | — |
| 27 | Sponsors (3 offers) | live | DK-G3, badge 3 | handshake | Read the deals waiting on your desk. | — |
| 28 | Story inbox (phone) | live | BR MAIL (with notices) | bell | (inside MAIL) Read messages from your phone. | — |
| 29 | The Wall, Chapter 1 "Keys" | live | RS card 4 (collapsed) | flag | See the story so far and what's next. | — |
| 30 | Reputation / fame | live | TR row 2 meter (reputation) + TR row 1 number (fame, 2nd currency) | award · sparkles | See what fans and promoters think of the gym. / Earn it from wins and hype. | — |
| 31 | Hype push | live | TR row 2 meter (click = push) | megaphone | Spend cash to get people talking before a bout. | — |
| 32 | Walk-ins + interviews | live | DK-G1, badge | user-plus | Meet the people waiting at reception. | — |
| 33 | Coach hire | live | PNL tab inside Staff (DK-G1) | user-check | (as #6) | — |
| 34 | Members + dues | live | TR row 2 count "12" | ticket | See who trains here and what they pay. | — |
| 35 | Rooms (office, locker, mat room, staff room, physio, film room, lobby) | live | DK-G3 (flyout lists the rooms) + click the room in W | building | Visit any space and see what it does. | — |
| 36 | Week review | live | BR date plate: a calendar-check button appears at week end (not drawn) | calendar-check | Look back at results, money and form. | — |
| 37 | Rankings | live | (= #8) | trophy | (as #8) | — |
| 38 | Finances / contracts / objectives / weight class | live | PNL tabs inside Finance (DK-G3) | wallet (tabs: receipt, file-pen, target, scale) | (as #9) | — |
| 39 | Equipment dock: place / move / repair / buy | future (coming) | DK-B #4, greyed | wrench | Place, move, repair and buy stations on the floor. | — |
| 40 | Multiple fighters (portrait strip) | future (coming) | TL strip under the fighter (A, C) · inside the lower-third (B) | user-plus slots | Switch who you're looking after. | **differs** |
| 41 | Multiple coaches | future (coming) | same strip, coach slot | whistle | Switch to another and see his sessions. | — |
| 42 | Ruleset filter (boxing / kickboxing / Muay Thai, later MMA / grappling, women's divisions) | future (coming) | TC chip | hand-fist + chevron-down | Choose which styles and divisions show. | — |
| 43 | Gym star tier | future (coming) | TC chip "0/2" | star | Earn these to unlock better rooms and fighters. | — |
| 44 | Gym level | future (coming) | TC chip "1" | shield | Grow this to unlock rooms and kit. | — |
| 45 | Gym expansion | future (coming) | DK-G3, greyed | layers | Add rooms and open new floor space. | — |
| 46 | Per-body-part recovery / injuries | future (coming) | fighter panel chips (A, C) · lower-third slot (B) | heart-pulse · bandage | See each body part's recovery. / Book the physio and track healing. | — |
| 47 | The corner between rounds | future (coming) | DK-G2, greyed (in-fight it lives in the fight HUD) | hand | Give advice between rounds. | — |
| 48 | Chapter objective cards | future (coming) | RS card 4 "goals coming" | flag | Track what this part of the story asks of you. | C: chalk rows |
| 49 | Achievements | future (coming) | RS card 5 (collapsed, greyed) | medal | Look through the milestones you've reached. | — |
| 50 | Game speed pause / 1x / 2x / 3x | future (2x and 3x coming) | BR 4-step speed bar | pause · play · fast-forward (+2 / +3) | Stop the clock (Space). / Run the day at normal speed. / Run it twice as fast. / Run it three times as fast. | — |
| 51 | Mail = notices + story phone | future merge | BR big MAIL button, badge | bell (no mail or phone glyph in the set) | Read news, offers and messages from your phone. | A gold chamfer · B glass with a gold underline · C gold |
| — | Paused state | — | 4px red frame + TC pause tab | pause | — | same in all three |

**Icon gaps (not in the repo set):** mail/envelope, smartphone, menu, towel/stool. Used instead: bell (MAIL) and hand (corner). Adding `mail` and `smartphone` from Lucide would be an art request, not done here.
