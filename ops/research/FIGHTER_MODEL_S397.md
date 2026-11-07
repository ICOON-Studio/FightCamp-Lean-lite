# The fighter model: every fighter different, everything shows (S397 design v1, for critics)

Operator S397: "i want this done properly ... everything needs to reflect on the fighter and make him feel unique";
"Rebuild world bouts on the real fight odds and give every opponent a real stat profile: yes, and have these mechanisms
reviewed by critics and ask for ideas". History: he ruled seven stats inadequate (S31) and approved 11 attributes wired to
training and the fight (S259, "add them all, wire them properly"); the Lean restart (10-28) never carried them over.

## 1. What is wrong today (code, read S397)
- The fight averages six stats (power, speed, technique, defence, conditioning, fight IQ) into one "strength on the night"
  (BoutRules.fight_power) before the first exchange. Every layer since (plan, corner, reads, habits) moves that one edge.
  Two fighters of the same average fight the same fight.
- Every opponent is ONE number (rating); its "stats" are that number with small word tweaks (RoundStyle.from_opponent).
- World bouts: rating plus a flat +-4 roll. 8+ points better wins 100% (measured); no styles, no power or chin.
- Chin, power and conditioning do act (hurt, knockdowns, energy), but nothing about how a fighter boxes does.

## 2. Principles
1. Every number does something you can see in the fight. If an attribute cannot change who wins a situation, how hard a
   punch lands, or how long a fighter lasts, it is not added.
2. Nothing is averaged in the fight. A situation reads only the attributes that matter in it, side against side.
3. One model for everyone: the player's fighters, every opponent, every world boxer. The world fights on the same maths.
4. The overall rating is a summary for tables and offers only, never an input to a fight.
5. A fighter is: attributes + body facts + a style that comes out of them + (later) a few traits that bend rules.
6. Grounded in what the sport measures (ops/research/J33_WHAT_THE_SPORT_MEASURES.md): reach above ~6.5 in wins about two
   thirds standing; the younger fighter (4+ years) wins ~60%, mostly through durability; knockdown rate fades by round
   (5.3% -> 2.4% -> 1.5%); accuracy depends on shot selection; strong favourites win ~86% (J-UPSETS1).

## 3. The attributes (0-100) and body facts
| group | attribute | what it does in the fight |
|---|---|---|
| physical | power | damage per landed punch; knockdown chance against the chin |
| | hand speed | who lands first when both throw; counters; the jab beating a slower jab |
| | foot speed | getting in and out; escaping the ropes; cutting the ring off |
| | engine | the stamina pool and how fast output drains it |
| | recovery | what comes back between rounds and after a hard exchange |
| | chin | head damage before hurt / down; wears with damage and age (cannot be trained up) |
| | body | body damage before the legs and breath go (a liver shot) |
| technical | jab | winning at range; setting up everything else |
| | straight | the cross / one-two down the middle |
| | hooks | inside and mid range damage; the check hook |
| | uppercuts | inside against a crouch or a lunge |
| | body punching | landing downstairs; draining the opponent's engine |
| | guard | blocking: how much of what lands is absorbed |
| | head movement | slips and rolls: making them miss, opening counters |
| | footwork | range control: keeping the fight where you want it, angles, ring generalship |
| | inside | working in close: framing, tying up, short punches, breaking the clinch |
| | counter | timing the counter off a miss |
| mental | fight IQ | reading a habit, adapting, finding the right answer without the corner |
| | composure | staying technical under fire and when hurt; no panic |
| | heart | coming back when behind or hurt; refusing to fold late |
| | aggression | a dial, not good or bad: output and pressure versus patience |
Body facts: height, reach, stance (orthodox/southpaw), age, weight-cut strain.
Lean today keeps per-punch mastery (MoveMastery): jab/straight/hooks/uppercuts/body punching come FROM it, not beside it.

## 4. How the fight reads them (no averaging)
The round stays six 30-second exchanges, each fought in a situation (Exchanges.MODES). Each situation is a contest of
named attributes, side against side, plus the plan/corner/read edges that exist today:
| situation | the attacker uses | the defender uses |
|---|---|---|
| at range | jab, footwork, hand speed, reach edge | head movement, footwork, guard |
| pressing | foot speed (cutting the ring), aggression, chin (walking through), hooks, body punching | footwork, jab, inside (tie up) |
| countering | counter, hand speed, fight IQ, head movement | fight IQ (feints), guard, composure |
| loading up | power, hooks/uppercuts | head movement, guard, counter |
| inside | inside, uppercuts, hooks, body punching | inside, guard, composure |
| tiring (late) | engine, recovery, heart, aggression | engine, recovery, composure |
| hurt | power, fight IQ (finishing), aggression | chin, composure, heart, inside (holding) |
- Margin of an exchange = weighted sum of (attacker attribute - defender attribute) for that situation + today's edges +
  the dice. The weights are per situation and sum to the same total, so no situation is worth more by having more rows.
- A landed punch: damage = power x punch mastery, absorbed by guard; head damage against chin, body damage against body.
- Output (punches thrown) = aggression x engine left x hand speed: decides how many punches score and how fast the tank empties.
- Knockdowns: chance from power against chin per landed power punch, fading by round as measured.
- Reach: an edge at range only (nullified inside), sized so a ~16 cm edge wins about two thirds standing at equal level.
- Age: chin and recovery wear with age past ~30 (the younger fighter's measured edge is durability).
- Style = where a fighter steers the fight: the situation weights (STYLE_MODES) come from the attributes (high footwork +
  jab -> range; high foot speed + aggression -> pressing; high counter + hand speed -> countering), not from a label.

## 5. Opponents and the world
- Every generated boxer is built from an archetype (out-boxer, pressure fighter, counter-puncher, puncher, volume puncher,
  swarmer, boxer-puncher) + a level + an age: a shape of the attributes with noise, so two pressure fighters still differ.
- The overall rating shown on tables = a weighted summary per archetype (for ranking and offers), never fought on.
- World bouts use the same situation maths, fast: both styles pick situations, rounds of exchanges, damage, knockdowns,
  stoppages, cards. No plan or corner. Upsets come from the dice and from matchups, not a flat roll.
- Targets (J-UPSETS1, to check by probe): a slight edge ~60%, clear ~75%, big ~88%, never above ~95%; a bad matchup
  can make a better boxer a 45-55% fight.

## 6. Training and the save
- The Week tab's sessions train named attributes (pads -> jab/straight/hooks via mastery, sparring -> fight IQ/inside/
  composure, roadwork/intervals -> engine/recovery, defence drills -> guard/head movement, ladders/skipping -> footwork/
  foot speed, strength -> power). Chin and body are not trained up; they wear.
- Saves migrate: today's six stats split into the new set so nobody changes identity (speed -> hand speed + foot speed,
  defence -> guard + head movement, technique -> footwork + counter + mastery, fight IQ -> fight IQ + composure).

## 7. Showing it
- Fighter page: the attributes in three groups with words, plus the style that comes out of them ("keeps it long").
- Scouting: an opponent's attributes start as ranges and narrow (as the read does today).
- Fight: the round report names the duel that decided an exchange ("her jab against his head movement").

## 8. Bars before anyone looks at it
1. Equal overall, different profiles: matchups move the chance by 10-15 points (an out-boxer with feet beats a slow presser;
   the same out-boxer loses to a presser who cuts the ring).
2. Each archetype wins its own situations (probe: situations won by style).
3. Reach ~16 cm at equal level: ~60-67% at range-heavy matchups; ~50% inside.
4. World upsets inside the J-UPSETS1 bands; no gap is a certain win.
5. A blind reader tells two boxers apart from their round reports alone.
6. Rule 2 (matchmaking bots) and rule 4 (plan) still pass.

## 9. Out of scope now
Traits (C238) come after, on top of this. BJJ has its own model (mastery, belts) and gets a belt-gap test separately.

## 10. Questions for the critics
Is anything here averaging in disguise? Which attributes are dead weight or missing? Is the situation table right for
real boxing? How should styles come out of attributes? How do we make a player FEEL the difference in the menus and the
fight, not only in the numbers? What would you add that makes a fighter unique beyond numbers?
