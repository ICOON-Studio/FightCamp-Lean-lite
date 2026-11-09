# The fighter model: every fighter different, everything shows (design v2.1, S398)

Operator S397: "i want this done properly ... everything needs to reflect on the fighter and make him feel unique";
"give every opponent a real stat profile ... have these mechanisms reviewed by critics and ask for ideas". History: seven
stats ruled inadequate (S31); 11 attributes approved and wired (S259, "add them all, wire them properly"); the Lean restart
(10-28) never carried them over. v1 (git history, f5e704fd) was reviewed by three critics (5.5, 5, 6 out of 10;
`FIGHTER_MODEL_REVIEW_S397.md` holds their reviews and every verdict). v2 answers them.

Numbers marked GV are game values (tuned by the bars in section 9); every other number cites its source.

## 1. What was wrong (code, read S397)
- The fight averaged six stats into one "strength on the night" (BoutRules.fight_power); two fighters with the same
  average fought the same fight. Opponents were one number with word tweaks (RoundStyle.from_opponent). World bouts were
  rating +-4: 8 points better won 100% (measured). The situation of an exchange was a roll on the opponent's style alone.

## 2. Principles
1. Every number changes something you can see: where the fight is fought, who wins a duel, how hard a punch lands, how
   long a fighter lasts. A number that cannot is not added.
2. Nothing is averaged in the fight: each place is two-sided duels of named tools; a fighter leans on the best tool.
3. One model for everyone: the player's fighters, every opponent, every world boxer, on the same maths.
4. The overall (the level number tables use) is a summary for ranks and offers; it is never fought on.
5. A fighter = abilities + two dials (how they like to fight) + body facts + personality; style comes out of them.
6. Grounded where the sport measures (J33, the boxing critic's CompuBox numbers); MMA numbers are treated as ceilings.

## 3. The fighter
| group | attribute | what it does |
|---|---|---|
| physical | power | damage of a landed power shot; knockdowns against the chin |
| | hand speed | combinations, getting the counter off first |
| | foot speed | the steering contest, both ways |
| | strength | leaning, framing and tying up inside |
| | engine | the tank and how fast work drains it |
| | recovery | breath back between rounds; clearing the head when hurt |
| | chin | head damage before a count; wears with age and stoppages |
| | body | body shots before the legs and breath go (scales the energy a body shot costs) |
| skill | jab | winning long; a jab that will not overcommit is the answer to the counter |
| | straight | the right hand down the middle: long's power shot, the pocket's combinations |
| | hooks | the pocket and inside; the check hook on the step-in |
| | uppercuts | inside, against the crouch |
| | accuracy | shot choice: landing what is thrown, not punching yourself out |
| | timing | counters, the step-in counter; landing on a faster man |
| | guard | fewer clean punches land |
| | head movement | slips and rolls; getting in under the jab |
| | footwork | range control and cutting the ring (both are footwork) |
| | inside | short work, framing, breaking the clinch |
| mind | ring IQ | reading habits, choosing the right place (best response) |
| | composure | the defence holds under fire and when hurt |
| | heart | (personality) the late fade: work rate holds when tired and behind |
Dials (0-100, neither good nor bad, not in the overall): pace (patient - relentless), forward (backs off - walks down).
Body facts: height, reach, stance, age. Personality as today (heart, discipline, confidence, coachability, loyalty, temper).
Mastery stays the drilled-move layer (weapons, plan arrows, combinations); drilling a move also raises its punch attribute
a little. Legacy view: the old seven stats stay as a summary of their children for the screens and rules that read them
(power; speed = hand + foot speed; technique = jab, straight, hooks, uppercuts, accuracy, timing; defense = guard + head
movement; conditioning = engine + recovery; fight_iq = ring IQ + composure; chin). A training gain to an old stat is shared
among its children; the fight reads only the attributes.

## 4. Where the fight happens: the distance ladder
Three places: LONG, POCKET (mid-range trading), INSIDE. Each round opens long. Before each exchange both sides want a place:
- the player's fighter: the corner's call or plan (Jab and move -> long; Go to the body, Tie up -> inside; Let your hands
  go, Draw the lead, Go for the finish -> pocket); with no call, the best response: the place where the duels favour the
  fighter most, found with chance ring IQ/100, else the forward dial's default (walks down -> inside, backs off -> long).
- the opponent: the game the opponent is playing (pressing -> inside, boxing at range -> long, waiting to counter and
  loading up -> pocket, tiring -> long, hurt -> inside to hold); world boxers both pick by best response / dial.
Control (v2.1, round-2 critics): wanting it longer = 0.35 footwork + 0.25 foot speed + 0.2 jab + 0.2 timing; wanting it
shorter = 0.35 footwork + 0.25 foot speed + 0.2 head movement + 0.1 guard + 0.1 chin + 0.1 per forward-dial point over 50;
while inside, strength is 0.3 of either. Same want: the ladder moves one step toward it (0.85, GV). Different wants: one step toward A with
chance clamp(0.5 + (C_A - C_B) / 40, 0.2, 0.8) (GV; nobody can lock a fight). Pinned: a fighter who wanted it long and is
inside two exchanges running is on the ropes: control -8 x (1.3 - composure / 100) (GV). Winning a steer costs 0.5 energy (GV).
The ladder carries through the round; the corner's eight games (pressing, at range, countering, loading up, tiring, hurt,
your fighter tired / hurt) stay the words the corner reads and answers.

## 5. The duels (no averaging)
At each place each fighter has 2-3 tools; a tool's gap g = attack (fighter's attributes) - answer (opponent's):
| place | tool | attack | answer |
|---|---|---|---|
| long | jab | 0.6 jab + 0.4 footwork + reach | 0.4 head movement + 0.4 footwork + 0.2 guard |
| | right hand | 0.5 straight + 0.3 hand speed + 0.2 accuracy | 0.5 guard + 0.2 head movement + 0.3 timing |
| | counter | 0.5 timing + 0.3 hand speed + 0.2 accuracy | 0.6 ring IQ + 0.4 jab |
| pocket | combinations | 0.4 hand speed + 0.3 straight + 0.3 hooks | 0.5 guard + 0.5 head movement |
| | power shot | 0.5 power + 0.3 hooks + 0.2 accuracy | 0.3 head movement + 0.3 composure + 0.4 chin |
| | counter | 0.5 timing + 0.3 hand speed + 0.2 head movement | 0.6 ring IQ + 0.4 accuracy |
| inside | short work | 0.4 inside + 0.3 hooks + 0.3 uppercuts | 0.4 inside + 0.3 strength + 0.3 head movement |
| | body | 0.5 hooks + 0.3 power + 0.2 inside | 0.6 body + 0.4 guard |
| | uppercut | 0.6 uppercuts + 0.4 accuracy (+0.2 per point of the answerer's head movement over 60: the crouch) | 0.6 inside + 0.4 guard |
| any closing step | step-in counter (resisting side only) | 0.5 timing + 0.3 hooks + 0.2 strength | 0.6 head movement + 0.4 composure |
(Table = Duels.TOOLS as built, S398 tuning pass 1. Steering: OPEN 0.35 footwork + 0.3 foot speed + 0.25 jab + 0.1 timing;
CLOSE as section 4. h(g): 0.3 extra slope past 8; best tool 0.45. The built critics' v3 changes are in the review file.)
Holding inside (0.6 strength + 0.4 inside, each side) does not score: the side losing the place but winning the tie-up cuts
the exchange by tie / 40, at most 40%. Counters (and the step-in counter) gain 15 x (the other's pace - 0.5); the busier
side takes close exchanges, + 8 x the pace gap / 100. Opposite stances: jab -3, right hand +3 (GV).
Reach: +0.4 per cm of reach edge on the long jab (GV, sized by bar 3). Height: the taller fighter's inside tools -0.2 per cm
(GV, capped at 4).
Score of a place: h(g) = g + 0.5 sign(g) max(0, |g| - 6) (convex past 6, GV; round 2: 10 left spikes linear); O(place) = 0.6 max h + 0.4 mean h.
Duel edge (power points, the fight's existing scale) = 0.5 (O_A - O_B) (GV: equal profiles 5 points apart = 5 points, as
the old average did). The deciding duel of an exchange = the winner's best tool; it is reported only when removing that
tool's gap flips or halves the exchange (counterfactual, as the plan's S388 swing).

## 6. States, dials, form
- Tired (energy under 50, t = (50 - energy) / 50): guard, head movement, footwork, foot speed -12 t; hand speed, power,
  accuracy -6 t; composure -3 t (GV; the fade order the boxing critic gave: legs and defence, then snap, composure last).
  Heart resists it after round 2: t x (1.3 - heart / 100), never below 0.5 t.
- Hurt: guard, head movement, footwork -8 x (1.2 - composure / 100) (GV).
- Pace dial p = pace / 100: output x (0.7 + 0.6 p) (landed punches, close rounds lean to the busier man); the fighter's own
  guard and head movement -10 (p - 0.5); the opponent's counters +15 (p - 0.5); energy spent x (0.8 + 0.4 p) (GV).
- Form on the night: one roll per boxer per bout, normal, sd 3 power points (GV). BoutRead integrates over it, so the
  shown chance stays the real chance.
- Knockdowns: the round's winner's punch (0.7 power + 0.3 accuracy) against the loser's chin and heart, on the built-up
  damage (Knockdowns); and the puncher's chance (round 2): the round's winner can be dropped by the loser, 0.4 of a clear
  round's count chance on the loser's punch against the winner's chin.
- The opponent chooses its game toward the place its profile does best at, weighted by ring IQ (no plain style roll).

## 7. Opponents, the world, generation
Every boxer that is not the player's is a level (the table rating) + a shape (offsets per attribute, mean 0) + dials +
body facts + age. Attributes = level + shape (+ age wear). The level moves with results and age as before (WorldAge,
Region), so ranks keep meaning ability (S397) and the shape is the person.
Generation (a world of a few hundred): three base traits (athletic, skill, mind; correlated 0.2) give each attribute its
base, plus noise (sd 4); an archetype tilt on 4-6 attributes (+8 to +12, about 15% get a second tilt); one signature
(+12) and one flaw (-12) each; height by division and reach = height + 3 cm +- 4; KOs on the record from power. Archetypes:
out-boxer, swarmer, stalker, slugger, counter-puncher, volume puncher, boxer-puncher, spoiler. The style word on a table
comes OUT of the generated profile (the archetype is a tilt, the dials and spikes decide the word).
Age (generated boxers, each year end): hand speed and foot speed -1 a year from 29, recovery -0.8 from 31, chin -0.8 from
31 (and -2 per stoppage loss), power -0.5 from 34, ring IQ +0.5 a year to 33 (GV order from the critics; J33: the younger
boxer's edge is mostly durability).
World bouts: the same ladder, duels, states, form, dice and knockdowns as the player's bout (no corner, no plan), so an
upset comes from matchups, form and punches, never a flat roll.
Amateur rivals (Region) and the fixed opponents (Data) get their shape from their style and scouting words + a seeded spread.

## 8. Training and display
Training: each session trains named attributes (roadwork -> engine; intervals -> engine, recovery; heavy bag -> power,
hooks; strength -> strength, power; speed bag -> hand speed, timing; slip rope -> head movement, guard; shadow -> footwork,
jab, straight; neck -> chin; sparring -> ring IQ, inside, composure; pads -> the move drilled and the camp's line).
Display: the fighter page shows the three groups, six keys (long, pocket, inside, power, durability, engine), the signature
line (two spikes and a hole in words) and where the fighter wants the fight. Scouting: an opponent's attributes are ranges
that narrow as the file opens. The round report: where it was fought ("kept it long 4 of 6") and the duel that decided it.

## 9. Bars (measured; results in section 10)
1. Equal measured strength, different profiles: matchups move the chance 10-15 points either way.
2. Each archetype wins its own place (place share and duel wins by archetype).
3. Reach 16 cm at equal level: 58-64% in long fights, ~50% inside.
4. World upsets in the J-UPSETS1 bands (slight ~60, clear ~75, big ~88, max ~95); no gap a certain win.
5. A blind reader tells two boxers apart from round reports alone.
6. Nonlinearity: a flat and a spiky profile of equal strength differ by 10+ points against two archetypes, opposite ways.
7. Triangle: no profile beats every archetype; each corner of out-boxer / swarmer / slugger beats one other.
8. Sensitivity: +10 on any ability moves the chance 2+ points against some archetype; none moves it 3x the median.
9. Steering tells styles apart: an out-boxer is long >= 65% of exchanges against a slow swarmer, <= 45% against a fast
   stalker (round 2: the 20-80% clamp passed by construction).
10. Migration: a migrated fighter's chance against the field moves under 3 points from the old model's; suites green
   (plan rule 1, matchmaking rule 2). (Round 2: "same seven numbers" passed by construction.)
11. Optimizer: 300 random builds at one level - the best is at most +0.08 over the best archetype and the top 10 do not
   share one top-3 set of attributes.

## 10. Measured (S398 build; `tools/fighter_bars.gd -- quick`, held by `tests/fighter_model_bars_test.gd`)
Tuning pass 1 after the first measurement (all GV, reasons in the code): timing taken out of two answers (it moved the
field 3x the median), convexity 0.5 past 6 -> 0.3 past 8 and the best tool 0.6 -> 0.45 (random spiky builds beat every
archetype by 0.18), reach 0.4 -> 0.25 a cm (0.70 in long fights), form on the night sd 3 -> 4.5 (10-round fights at +18
were certain), the engine scales the world's tank spend, recovery carries the refill between rounds.
| bar | measured | verdict |
|---|---|---|
| 4 world upsets, 3 rounds (n 300-500) | +2 0.56-0.61, +5 0.74-0.76, +9 0.85-0.89, +13 0.92, +18 0.98 | PASS (targets 0.60 / 0.75 / 0.88 / max ~0.95) |
| 4 longer pro fights | 6 rounds +5 0.83, +9 0.95; 10 rounds +5 0.75, +9 0.93, +18 0.99 | PASS-ish: never certain; favourites win more over more rounds, as pro favourites do (86%, J-UPSETS1) |
| 3 reach 16 cm | long fight (two out-boxers) 0.58; inside (two swarmers) 0.51; two boxer-punchers 0.54 | PASS |
| 9 steering tells styles apart | out-boxer long 0.67 vs a slow swarmer, 0.40 vs a fast stalker | PASS |
| 2 places by archetype (vs a boxer-puncher) | out-boxer long 0.61; stalker inside 0.37 / long 0.11; counter-puncher pocket 0.60; swarmer inside 0.30 | PASS: each style fights where it wants |
| 7 no archetype beats every other | none does | PASS |
| 8 sensitivity, +10 on one attribute | top timing +0.065, median +0.027 (top <= 3x median); recovery +0.006, heart +0.013 still weak | PASS on dominance; recovery and heart weak on the world's path (they act in the watched bout: refill, hurt, counts) |
| 1 matchups at equal measured strength | largest 0.054, median 0.014 | OPEN: the styles differ in WHERE they fight more than in WHO wins |
| 6 spiky vs flat, same mean | spiky +0.06 to +0.19 against every archetype | OPEN: a spike is a weapon but a hole is not yet a target often enough |
| 11 optimizer, best of 60 random builds | 0.632 vs the best archetype 0.500 | OPEN: points in high-value attributes beat a balanced profile at the same plain-mean level |
| 10 migration | old saves keep their seven numbers (fighter_model_test); save_load_test green | PASS |
| 5 blind reader | see section 12 | |
Root cause of the three OPEN bars (one fault, structural): the level is the PLAIN mean of 20 attributes, but the duels
value them unequally (bar 8: timing is worth 20 times recovery on the world's path). A boxer with points in timing, head
movement and guard is stronger than the level says, so equal "overall" is not equal strength, random builds win, and
archetype matchups drown in that noise. Next design change (not a re-tune): a VALUE-WEIGHTED overall (each attribute
weighted by its measured field move, recomputed by the probe), shapes centred on it, archetype tilts measured for equal
strength; then bars 1, 6 and 11 again. The shown odds already use the real duels, so nothing the player sees lies; the
table rating is the part that is off.
Watched-bout checks (tests): the shown chance against real bouts within 0.06 in all eight cases (bout_read_test: worst
0.053, Lucy -6 vs Maria 0.325 vs 0.272; the band holds the chance at every stage, 0 misses in 1584); the
corner game kept: silence 0.47 < the coach's pick 0.52 < reading the clue 0.67 (exchanges_test); the everyday world path
within 0.011 of the exact walk (fighter_model_test).


## 11. Out of scope now
Traits (C238) next, on top of this profile; cuts, hand injuries, judges' noise, feeling-out round, stance jab shift,
training costs, tape per situation, 1-20 display: LATER with reasons in the review. BJJ keeps its own model.

## 12. Bar 5, the blind reader (S398)
`tools/round_reports.gd`: Kira (fast hands, thin chin) and Samira (raw power, no defence), three bouts each against Maria
Ortega, round reports only. A fresh reader: "Mostly yes, about 70% sure"; named Kira an out-boxer (the jab at range, a
thin chin, pinned on the ropes) and Samira a body puncher who stays inside too long (her guard). PARTIAL PASS. What read
the same: the old flavour lines (FightWords.round_lines, keyed on the OPPONENT's style and the round's result) gave both
boxers word-for-word the same round 1 in bout 3, and "Maria kept it long" was credited to a pressure fighter (the place
line credited the winner - fixed: it now credits the side that asked for the place). Next: the flavour lines read the
fighter's own place, duel and signature (v3 list).
