# S187 playtest - UI review (2026-10-09, as_game hud2)

Two walks, stills on the game camera: `docs/previews/s187_play_a` (creation -> fight week, 60 stills) and
`docs/previews/s187_play_b` (creation -> first bout -> result, 60 stills). Operator ask: "during your walk identify possible
improvements on the UI (like a professional playtester)" then "fix issues as you find them".

Status column: FIXED <hash> / AGENT <run> / OPEN.

## A. Defects - the screen tells the player something false

| # | Where (still) | What the player sees | Status |
|---|---|---|---|
| D1 | Week review (a/56) | "Nobody trained this week" - Bastien trained on pads Monday (+10.4 technique). Live club-floor gains never reach the week report (`WeekReviewPanel._fighter_rows` reads only `body_results`). | FIXED b782e155 signing baseline + oldest-snapshot fallback; signing_stat_baseline_test (red without) |
| D2 | Home after signing (a/21) | Cash still $25,000 after paying $3,918 + $1,720 signing; $19,362 only after changing screen. | FIXED a07c1510 (refresh_top after sign/hire) |
| D3 | Camp setup (a/47-52) | The screen behind bleeds through (ghost "BASTIEN TORRES", "START A CAMP"); a cut giant line bottom-left "NE OPPONENT AND FADES IF IT IS ABANDONED"; Continue + guide cut at the right edge; card texts truncated ("ROU...", "D...", "IT WILL COST ON"); two titles (CAMP SETUP + FIGHT CAMP). | PARTLY FIXED d4255c16 (footer word, clock label); rest AGENT Cursor PLAYUI1 |
| D4 | Camp setup, sparring partner (a/50) | The ACTUAL opponent "Alejandro Hassan" is offered as a sparring partner "cast to look like Alejandro Hassan". | FIXED b322910f |
| D5 | Fight week (b/53) | "DAYS 0 TO BELL" and tape "0 weeks / 0 days out" while the week strip still shows Wed..Mon ahead. | NOT A DEFECT - it was fight day; the real defect was the morning card offering a training day on fight night: FIXED b322910f |
| D6 | Tale of the tape (b/55) | 18-year-old, 12 fights, DEBUT 2026 (it is Feb 2026). | FIXED 16735957 |
| D7 | Guide card (a/21 -> a/60) | "Set his training - Open Training" stays up for 4 weeks although he trains every day and a camp is running. | FIXED a07c1510 |
| D8 | Goals top-left (a/21, a/40) | "Stamina above 30 at the bell" ticked before anything happened; "Jab usable by Friday" ticked Monday 10:33 with the move card at 152/600 min; both still shown in week 4. | FIXED a07c1510 (day goal at the bell; week goal moves on) |
| D9 | Result punch table (b/60) | BODY row "- / 13" (thrown missing) and the rows do not add up to TOTAL (22+13+13 != 35) - body is a subset, not a row. | FIXED b322910f |
| D10 | Live bout (b/58) | Clicking SIM TO RESULT asks "SKIP THE CORNER?" - the question does not match the button. | FIXED b322910f |
| D11 | Country pick (a/03) | Czechia, DR Congo, Dominican Rep. show an empty flag box. | FIXED 16735957 (14 countries; N. Cyprus + Somaliland have no flag file) |
| D12 | Week review (a/56) | Header "WEEK 2" over "Week 1 in review" with a "Mon 5 Jan" pill; stray green square in the NET tile; "WEEK" label printed over the $ figure; floating "=" and "-" glyphs. | FIXED b322910f (header, sparkline, Before the bill chip) |
| D13 | Fight week (b/53) | After a 4-week Striking Shark camp: "CAMP BUILT OVR 49 -> 49", "This camp built: nothing yet". | NOT A DEFECT - the walk skipped every camp day and a skipped club day trains nothing; filed as improvement B16 |
| D14 | Weight (a/50, b/53, b/54) | Camp: 55.7 kg, 4.9 kg water cut "past the safe line". Fight week: "Cut 0.0 kg - safe". Weigh-in: "cut 8.8%". Three stories. | FIXED 16735957 (on-weight reads On weight already) |
| D15 | Scorebug (b/57) | TORRES country "-" (HASSAN shows CYP, both born Nicosia). | FIXED 16735957 |
| D16 | Weigh-in (b/54) | Opponent box labelled "The limit" instead of his own weight/status. | FIXED 16735957 (Must make) |

## B. Improvements a pro playtester would file (not false, but costs the player)

1. **(FIXED: runway line on hire/sign cards; week review chip says Before the bill)** **Money runway is invisible.** Signing ($1,306/wk) + coach ($860/wk) + upkeep ($367/wk) = $10,132/month against $19k cash, and the
   week review still says "Profit week +$1,264" because the bill lands monthly. Show weekly burn and "cash lasts N weeks" at the hire
   and sign buttons and in the week review.
2. **Three calls to action at once** on the home screen: morning card (STEP IN / SKIP THE DAY), guide (OPEN TRAINING), Continue. One
   primary action per moment.
3. **Unlabelled numbers:** fighter card bars (green/red), profile region markers "100", offer icons (66%, +4, star 0, OPEN/CLOSED),
   scorebug "0/0", result "+12" star, "OFFICE PUSH $150 - HYPE 12 / POSTER QUOTE PHOTO". Each needs an icon tooltip (UIKit.tip).
4. **Training gain reads absurd:** Technique 56 -> +10.4 in 2.5 hours (+5.0/h) on a 0-100 scale (open question Q-S186-3).
5. **No fight plan prompt:** the result says "ONLY ONE CORNER CAME WITH A PLAN" - the player was never asked for one. Put FIGHT PLAN on
   the fight-week path (weigh-in -> plan -> fight night).
6. **(FIXED: tape + fighter card)** **Boxer screens show grappling:** profile "NOT TRAINED HERE: Grapple / TD def / Top", tape "WINS BY SUBMISSION". Hide off-ruleset rows.
7. **Portraits do not match the body:** an 18-year-old 160 cm 50.8 kg flyweight is shown as a heavy, 30-something heavyweight.
8. **The gym is empty** while members pay $1,264/week dues - members never appear on the floor.
9. **Bastien stands on PADS** in every still for four weeks, whatever the camp says.
10. **Record mismatch** 7-4-1 everywhere, AM 1-0-0 on the result (open question Q-S186-1).
11. **Offers screen:** header says SCHEDULE while the tab is OFFERS; "3 EVEN MATCHES" shows 2; a "SELECT AN OFFER / CANNOT OPEN" bar
    beside ENTER buttons; sponsors mixed into fight offers with no demand shown.
12. **Creation:** BACK + X do the same thing; the right half of country/gym pages is empty; small floor tiles print stacked text; empty
    floor slots are black boxes with no "+ place" hint; "COMBAT" vs "COMBAT POPULARITY".
13. **Hire/sign modals:** no portrait; option lines do not look clickable until picked; "TEACHING 12 (Good)" with no scale.
14. **Wall signs in the club** are unreadable at the game camera; club name printed twice.
16. **Skipping a camp day forfeits it silently** - a whole camp skipped built OVR 49 -> 49 with no warning at SKIP THE DAY.
15. **Fight night** header repeats "ROUND 1 LIVE" before the bell; two skip controls (scorebug fast-forward + SIM TO RESULT).
