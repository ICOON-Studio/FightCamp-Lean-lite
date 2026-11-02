# PLAYTEST S144 PASS 1 - cold first hour, exported .exe, EMPTY gym (protocol: PLAYTEST_PROTOCOL.md)

Build: Builds/FightCamp_Godot pck 2026-10-02 17:48 (HEAD 2ecbf74b + empty-gym switch), driven live with
tools/s144_live_walk.gd `-- as_game` (the player's game). Tester: Claude, cold walkthrough, one screen at a time.
Stills + raw notes: E:/FightCamp/playtest/s144_p1/ (notes.md, NNN_*.png, live.log). Run 0 (without as_game - kept the test
starters) archived in run0_without_as_game/.

## Verdict
The first 15 minutes are good - title, creation, scouting, negotiation and training read like a finished management game.
Then the loop does not start: after signing a boxer the player has NOTHING to book for 6 weeks, and payroll bills him toward
bankruptcy at ~week 8. Tasks T6-T9 (fight week, the fight, the result, the next decision) were never reached.

## Funnel (commands from the title screen)
| Task | Reached | Commands | Note |
|---|---|---|---|
| T1 start a career | yes | 6 | 3 creation steps, choices feel identical |
| T2 first boxer | yes | +10 | Scouting found by guessing (home CTA points at offers) |
| T3 a coach | yes | +8 | staff room names Scouting but has no hire button |
| T4 train + see gain | yes | +2 (+1 week) | gain shown only in the home Monday report |
| T5 book a fight | **NO** | 6 weeks | 0 offers, 0 bookable world cards, every week |
| T6-T9 | not reached | - | blocked by T5 |

## Loop / economy (weeks 1-6)
| wk | Monday cash | week review IN / OUT / NET | offers on the desk | Monday report |
|---|---|---|---|---|
| 1 | 25,000 -> 17,274 after two signings | 1,008 / 3,473 / -2,465 | 0 | - |
| 2 | 18,282 | 1,080 / 3,473 / -2,393 | 0 | DEF +13% IQ +13% |
| 3 | 19,362 | 1,152 / 3,473 / -2,321 | 0 | same text |
| 4 | 20,514 | 1,224 / 17,365 / -16,141 | 0 | same text |
| 5 | 7,846 | 1,296 / 3,473 / -2,177 | 0 | same text |
| 6 | 9,142 | - | 0 | DEF +12% IQ +12% |
Payroll is billed MONTHLY while the weekly review shows it weekly; the next bill (~14k) lands ~week 8 against 9.1k.

## Issues ranked (severity per PLAYTEST_PROTOCOL: +1 needed to progress, +1 needed knowledge not on screen, +1 still stuck next time)
CRITICAL
- P32 Nothing to book. Female middleweight amateur: amateur calendar never has her division in 6 weeks; the generated pro offers
  (GameState.get_fight_offers) are always MEN ("a generated man", S65 comment) and are hidden from amateurs anyway, so a female
  fighter can never get a bout; the world list shows 161 cards, 0 bookable. Women are 9 of the 12 UK prospects on day 1.
- P9 Home's main call to action ("3 fight offers waiting... put a fighter on a card / Open offers") with NO fighters; nothing
  says "sign your first boxer" or where.
HIGH
- P10 Every in-game ICON renders as an empty square in the exported .exe (date, Continue, hotspots, review bars, top right).
- P28/P39 "3 offers waiting" on Home, the Fights badge and the Office, but the desk says 0 (the 3 are hidden pro offers).
- P29 Developer counter line on the Offers desk ("175 COUNTRIES · 423 ATHLETES · 128 SCHEDULED ... CASH 0 ...").
- P36 Week review layout: title overlaps three empty icon bars, large blank area.
- P37/P44 Training progress: the week review shows none; the Monday report repeats "+13% / +13%" every week.
- P40 Money story: weekly review bills wages every week, cash only drops monthly (-16k in week 4) - reads as a lie.
- P6 Creation step 3 lists a 3-fighter STARTER ROSTER that the empty-gym start does not give.
MEDIUM
- P3/P5 Country and city choices show identical numbers (46/50/54; 2 rival gyms / 1 promotion / 0 events in every city).
- P13 A boxing gym's scouting mixes judo/kickboxing/wrestling, no discipline filter. P14/P18 novices ask ~$1,300-1,650 a
  WEEK + fee against $25k, with no word on income. P17 no face for the person you sign. P21/P23 nothing says a fighter needs a
  coach; the staff room has no hire button. P25 top cash bar lags after a signing. P31/P34 an empty desk gives no next step;
  the world list is a wall of shows you can never enter. P33 DISC column "HYBRID" on every event. P35 "8 THE GAME IS GUESSING".
  P41 "1 need a coach" with a coach hired. P42 +13% in a week. P43 "Open offers" opens the month calendar.
LOW: P1 empty flag boxes, P2 no country search, P4 market stats unexplained, P7 unlabeled floor slots, P8 MMA mat in a boxing
  gym, P12 doubled SCOUTING title, P15 "WEEKS 66" unexplained, P16 "wage exceeds payroll" at $0, P19 summary keeps the ask after
  agreeing, P20 coach quote with no coach, P22 "0 of 0 fighters have a coach", P26 "EMPTY BOOK" unexplained, P27 coach not on
  the training screen, P30 Cyprus MMA sponsor for a London boxing gym.

## PLAY heuristics (0-3)
- Game play 1 - the core loop (fight -> consequence -> next decision) never closes in 6 weeks.
- Mechanics 2 - negotiation, training presets, scouting, slot fit are clear and responsive.
- Usability 1 - missing icons, debug text, counts that contradict screens, wrong-tab button.
- Approachability 1 - no first-goal signposting from an empty gym; first choices carry no meaning.

## Top 5 fixes (RITE: fix, then pass 2)
1. Bookable first fights for EVERY fighter the scouting list offers - women's amateur cards + sex-aware generated offers
   (CRITICAL, code: GameState.get_fight_offers / amateur calendar). Acceptance: a new empty-gym career, sign a female and a
   male 0-0 boxer, each has >= 1 bookable bout within 2 weeks.
2. Empty-gym first goal: Home CTA "Sign your first boxer -> Scouting" when 0 fighters; staff room "Hire a coach" button;
   honest offer counts (exclude hidden pro offers); hide the dev counter line and "the game is guessing".
3. Icons in the exported build.
4. Week review: real layout, the week's stat gains per fighter, wages shown as "accrued, due <date>" when billed monthly.
5. Creation step 3 tells the truth about the empty roster.
