# PLAYTEST pass 2 - S146, 2026-10-02 (cold AI pass, exported .exe, empty gym, as_game)

Method: PLAYTEST_PROTOCOL.md, the same tasks as pass 1 (PLAYTEST_S144_PASS1.md), driven live one screen at a time with
`tools/s144_live_walk.gd` in `Builds/FightCamp_Godot/FightCamp_console.exe` (pck built 19:23 at 659b260e + U213 work).
Same choices as pass 1 for a like-for-like funnel: United Kingdom, London, sign Isabel Anders (F, 0-0-0 middleweight),
hire coach Adrian Williams (boxing 88). Stills: `E:/FightCamp/playtest/s146_p2/` (001-098). Log: live.log there.

## Funnel (pass 1 -> pass 2)
| Task | Pass 1 (S144) | Pass 2 (S146) |
|---|---|---|
| T1 start a career | 6 screens | 6 screens (same) |
| T2 first boxer | found by guessing (Fighters > Scouting) | HOME FIRST JOB 'Sign your first boxer' -> Scouting, 1 click |
| T3 a coach | dead end via the staff room | FIRST JOB 'Hire a coach' -> Scouting STAFF, 1 click |
| T4 train + see her improve | Monday report only, '+13%' repeated | programme set (Plan this week > SET PROGRAM > BALANCED); week review + Monday report 'DEFENSE 54.0 -> 54.1' |
| T5 book a fight | NEVER (no bout for a woman in 6 weeks) | week 1, vs Valentina Ito (0-0-0), 4 clicks |
| T6 camp + weigh-in | not reached | camp set (1 retry: protocol hint small), made weight 72.6 |
| T7 watch the fight | not reached | live 3D bout, R1 at 1X then 4X, SIM TO RESULT |
| T8 read the result | not reached | Ito UD 29-28 (3 rounds); home: rest 2 wk |
| T9 plan next | not reached | 2 offers waiting on HOME |

The loop now closes in 5 in-game weeks. Pass 1's CRITICAL (no fight for a female debutant) is gone in the exe.

## Issues found live and FIXED this session (each with its gate; exe walk re-check owed on the next build)
| id | sev | what the player met | fix (commit) |
|---|---|---|---|
| P2-1 | HIGH | Week review: OUT subtracted weekly wages AND the monthly bill; NET disagreed with the bank | PAID OUT = bills + camp; NET == bank change (659b260e, 0d2449dd) |
| P2-2 | HIGH | NET +$1,008 while the bank lost $432: fight camp paid weekly, never shown | camp spend in PAID OUT; test: NET == bank change with a $900 camp (0d2449dd) |
| P2-3 | CRITICAL | Broke at the first fight: cash -$666 in week 5 (0-0 novice asked $1,614/wk) | 0-0-0 novice asks the $250 stipend (J5: wage polarity invented); test 8 weeks ON $9,264 vs OFF -$1,748 (28398a4c) |
| P2-4 | MEDIUM | '$-666' in cream, no warning | '-$666' red + OVERDRAWN tooltip (345f92bf) |
| P2-5 | HIGH | After her loss home + profile still read 0-0 (amateur bouts write amateur_record) | UIKit.shown_record on home + profile (28398a4c) |
| P2-6 | MEDIUM | '1 offer waiting' + week review offer hooks after she was booked | booked fighters / amateurs excluded (c32c0078) |
| P2-7 | MEDIUM | Hired a coach, Staff pin still '1 without a coach' (P41/P22 again) | a new coach takes unassigned fighters (9e58b343) |
| P2-8 | MEDIUM | 'Open offers' opened the calendar month | opens the OFFERS tab (0d2449dd) |
| P2-9 | MEDIUM | Fight week: 'No camp before this bout ... he fights' after a 4-week camp; 'he' for Isabel | reads the camp summary, no pronoun (28398a4c) |
| P2-10 | MEDIUM | Fight week '8 x 3:00' for an amateur bout fought over 3 rounds | 3 x 3:00 (345f92bf) |
| P2-11 | LOW | 'Decision Loss After Decision · rest 2 wk' | 'Decision loss · rest 2 wk' (345f92bf) |
| P2-12 | LOW | Gym floor pin 'Set this week's training' opens the floor editor | 'Nobody on the floor yet' (345f92bf) |
| D69 | - | Dola fresh eyes on the week review (8 of 10 applied) | cb10c6c8 |

## Open (not fixed this session), ranked
| id | sev | issue |
|---|---|---|
| P2-13 | HIGH | Economy still bleeds ~$1,400/wk with one coach ($1,844/wk) - solvent ~4 months, amateurs earn no purse. Needs the economy pass J5 asks for (dues line with evidence, coach pay bands) |
| P2-14 | MEDIUM | Scouting for a BOXING gym lists judo/kickboxing/wrestling first (P13 from pass 1) |
| P2-15 | MEDIUM | Scouting/top bar keeps 'No fighters yet' after the first signing until the screen changes (P25) |
| P2-16 | MEDIUM | Live bout: clothes show white blotches (shorts/top texture); both fighters barefoot; some torso overlap in the clinch |
| P2-17 | MEDIUM | One still (091) shows a knee raised to hip height in a boxing bout - no knee is in the palette, so most likely a step pose; check on a video before the demo |
| P2-18 | LOW | Offers desk keeps '1 TO ANSWER' after booking; sponsor 'Cyprus MMA Federation' for a London boxing gym; 'EXPIRY TBC' |
| P2-19 | LOW | Profile 'DEBUT 2020' and '#3 MIDDLEWEIGHT' for a 0-0-0 debutant; opponent from Tijuana on a UK open circuit |
| P2-20 | LOW | Camp sheet: START CAMP stays grey until a protocol is picked - the hint is small, bottom right; the profile bleeds through the sheet |
| P2-21 | LOW | Media line 'We hear the scale is a problem this week' while she is on the limit |

## PLAY heuristic scores (0-3)
- Game play 2 (pass 1: 1): the loop closes and a fight happens in week 5; the result is readable.
- Mechanics 2 (1): camp, cut and weigh-in work; economy still unsustainable past month 4.
- Usability 2 (1): first-job cards lead each step; camp sheet is dense.
- Approachability 2 (1): no outside knowledge needed to reach the fight.

## Top 5 next
1. Rebuild + exe re-walk of P2-1..P2-12 (pass 2b), then the operator's cold session.
2. P2-13 economy pass (dues with evidence, coach pay bands) - lead-dev decision, research J5/J6/G74.
3. P2-16/P2-17: a 20 s live-room video of a boxing bout, opened frame by frame, before the demo.
4. P2-14 scouting discipline default = the gym's discipline.
5. P2-15 top bar refresh after a signing.
