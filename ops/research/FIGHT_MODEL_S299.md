# The fight model: who a fighter is, and how the ring shows it (S299, 2026-10-29)

## Approved by the operator (S299 chat, verbatim)
- Asked "how many parameters do you think we need to simulate properly a fight ?" -> about 25 in four layers: "25 sounds ok"
- "i want to have the fighters as unique personalities so some things should be embedded to each fighter so everyone will
  react a bit different" -> 6 traits + 2 habits, learned not shown: "ok with that"
- "what about morale do we have than in the game and in the fight ?" -> one stored morale: "fine"
- Rule for every number (Claude's, agreed with it): it gets at least ONE behaviour you can see in the ring or the gym, and a
  test that proves it changes something. A number that changes nothing visible does not go in.

## Why (what the code does today, read 2026-10-29)
- BoutRules.fight_power adds six ratings + camp + film + corner + weapons -> each round's winner and margin. Training works.
- RoundScript.build gets only won / margin / style / corner and picks punches at random (45% jab) for everyone: a fighter
  who drilled hooks throws the same mix as one who never did; a weak chin looks like an iron one. The ring cannot show training.
- FighterGoal reports "morale +10 / -20" but nothing stores or reads morale (defect: fixed in step 1).
- No knockdowns: a bout ends only on the cards.

## The fighter (~34 numbers; the player sees words, never these numbers)
| Layer | Numbers | What they are |
|---|---|---|
| Ratings (trained) | 8 | power, speed, technique, defense, conditioning, fight_iq, chin + NEW footwork (distance, ring cutting, not trapped; recovery between rounds folds into conditioning) |
| Body (fixed) | 5 | height, reach, weight, stance, age |
| Fight state (live, reset each bout) | 5 | stamina, head damage, body damage, composure, cuts |
| Style (dials) | 4 | pressure <-> out-boxer, work rate, head/body targeting, counter tendency |
| Move mastery | 8-10 | per punch / defence (MoveMastery, exists) |
| Personality (fixed, drifts slowly) | 6 | heart, temper, confidence, discipline, coachability, loyalty |
| Habits | 2 | from a bank of ~20 (Kalli writes it): drops the right after the jab, slow starter, digs to the body when hurt, freezes on the ropes, switches stance under pressure, talks when ahead ... |
| Morale (stored, moves weekly) | 1 | Fired up / Steady / Flat / Low |

## What each one shows
| Number | In the ring | Outside |
|---|---|---|
| move mastery | she throws what she has mastered, cleaner; unlearned moves never appear | - |
| speed | quicker hands (clip speed), 2-3 punch combinations | - |
| technique | more of her punches land, fewer wild misses | - |
| defense | more blocks, slips, weaves (Pro clips) | - |
| footwork | holds her range, steps out instead of blocking, rarely on the ropes | - |
| power | heavy reactions on the other boxer (head snap, stumble) | - |
| conditioning | fresh guard early; low: tired idle, dropped guard, slower hands by round 3 | - |
| chin | how hard she reacts; weak chin + big shot = knockdown + count | - |
| fight_iq | follows the corner call, counters misses | - |
| heart | hurt: fires back or covers up; down: up at 6 or stays down | bounces back from a loss or sulks |
| temper | caught clean: keeps shape or brawls (wide, open, tiring) | rows, weigh-in trouble |
| confidence | winning: presses, showboats; losing: hesitates, throws less | asks for bigger fights, more money |
| discipline | keeps the game plan when it gets hard | trains or skips; makes weight easily or not |
| coachability | the corner minute: listens to your call or not (the call's edge scales) | learns new moves faster |
| loyalty | - | stays, or leaves when a bigger gym calls |
| habits | recurring beats fans and scouts recognise; an opponent's habit is what film study finds and your fighter punishes | scouting notes |
| morale | composure starts from it: fast or flat round 1; how she copes when a round goes badly | training gains, skipped sessions, requests, lines; low + low loyalty = talks to other gyms |

Morale moves up with wins, goals met, a good camp, pay, a booked fight, praise, a rest week; down with losses, missed goals,
hard weeks with no rest, months without a fight, a bad purse, a teammate getting the better fights. Personality scales the
moves (heart shrugs off a loss; confidence takes a missed goal personally).

## How the player learns it
- A mood word on the fighter card + the reason ("Hasn't fought in 3 months").
- A COACH'S NOTES card per fighter that fills in with words from sparring, trials and fights ("Gets up angry. Stops listening
  when she's winning."). Opponents: the same card from scouting and film study.
- In the ring: one short line when something is because of training ("Her hook keeps landing: six weeks on the pads"), and a
  corner card after each round: what worked, what hurt, the call.

## Who decides what
The simulation decides everything (Bouts / BoutRules, pure, headless-tested). RoundScript turns the settled round into beats
using BOTH fighters' profiles; FightStage only plays the clip each beat names. Knockdowns are decided in the simulation (power
and damage vs chin, heart for the count), never in the view. Target rates come from real amateur data (John researches:
women's amateur knockdown and stoppage rates; until then the test bounds them, never an exact count).

## Build order (each step: a red test first on main, then green)
1. Fighter profile + morale stored (defect fix): Career/Roster carry footwork, style, personality, habits, morale; FighterGoal's
   morale delta is applied; save/load round trip. Pure rules + tests (Qwen / Arena).
2. Knockdowns in BoutRules: per-round knockdown chance from power vs chin + damage, the count from heart; a stoppage path;
   bounded rates over 1,000 bouts (Arena, after John's numbers).
3. RoundScript from profiles: punch mix from mastery, land/miss/block from technique vs defense, combos from speed, footwork
   steps, tired beats from conditioning, habit beats, personality reactions, knockdown beats. Tests over 200 seeds: high defense
   blocks more; no mastered hook = no hook; low conditioning = tired beats in round 3 (Qwen / Arena).
4. FightStage plays the Pro clips by beat tag (light/heavy hit, dodge, weave, tired idle, knockdown + count, celebration) - Claude.
5. Words: Kalli writes the habit bank, mood lines, coach's notes and in-ring lines; the corner card (Cursor: one screen).
6. A film watched with eyes, frame by frame, two differently trained fighters in the same bout; then the .exe.
