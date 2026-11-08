# One fighter profile for both sports (S402, 2026-11-08)

Operator: "i want a proper fighter profile that can be adjuster if fighter transitions from bjj to boxing the attributes display should be coherent . Make sure we have
attributes added or changed according to critics and game mechanics because the current number feels very low".
Read here as the number of attributes. History: he ruled seven stats inadequate (S31) and approved 11 attributes; the approval was lost in the 10-28 restart.
Mockups: docs/mockups/s402/05c_profile_boxing and 05d_profile_bjj (the same fighter).

## Today
| | Boxing | BJJ |
|---|---|---|
| On main | 7 stats (power, speed, technique, defense, conditioning, fight IQ, chin) plus a move list | 6 stats (strength, cardio, flexibility, explosiveness, composure, aggression) plus mastery per move |
| PR #85 | 20 attributes, read by situation; not merged | Nothing |
| Shared between the two | Nothing. "Conditioning" and "cardio" are different numbers for the same lungs | |

Corner King for scale, read from its files: five trained stats plus three hidden mental ones, so about eight.

## The rule (changed on his note: "try to interconnect those attributes with all sports example flexibility can play a role also for a boxer ?")
One fighter has one body and one mind, and every sport reads all of it, each in its own way. Only skills belong to a sport.
Every number shown must change something in the sport being shown. Power, Chin and Cuts are about hitting and being hit, so they show only where she can be hit. This shape carries MMA with no new page.

## The attributes (v2, after the MMA critics: see the end of this page)
| Group | Attribute | Boxing and other striking | BJJ | Wiring |
|---|---|---|---|---|
| Body, every sport | Strength | Inside work, moving her on the ropes | Pins, grips, finishing | Both exist |
| | Explosiveness | The first step in, the shot that drops someone; kicks and knees | Shots, bridges, scrambles | NEW in boxing |
| | Engine | Stamina pool (today's conditioning) | Gas for attempts and holds (today's cardio) | Merge the two |
| | Recovery | Between rounds | Between bracket matches | NEW in BJJ |
| | Flexibility | Deeper slips and rolls, fewer shoulder and hip injuries; kick height | Guard retention, escaping submissions | NEW in boxing |
| | Hand speed | Who lands first | Hand fighting, entering a submission | NEW in BJJ |
| | Foot speed | In and out, the ropes, cutting off the ring | Takedown entries, passing | NEW in BJJ |
| | Toughness | Body shots before the legs go | Holding up under pressure | NEW in BJJ |
| | Weight cut | How hard she can cut and still fight | The same | NEW, reads the weight-cut rules |
| Mind, every sport | Fight IQ | Reading habits, adapting | The read of the next position | Both exist |
| | Composure | Calm when hurt | Calm in a bad position | Both exist |
| | Heart | Coming back late | Late scrambles, refusing to tap | NEW in BJJ |
| Style dial, not a bar | Aggression | The forward dial | How often she attacks | Both exist |
| Body, when she can be hit | Power, Chin, Cuts (how easily she marks: the cutman reads it) | Yes | Not shown | Cuts is NEW |
| Boxing skills | Jab, Right hand, Hooks, Uppercuts, Accuracy, Timing, Blocking (was Guard), Head movement, Footwork, Inside work | Yes | Not shown | PR #85 |
| BJJ skills | Takedowns, Guard, Passing, Sweeps, Control, Submissions, Submission defence, Escapes | Not shown | Each from the mastery of its moves | NoGi move groups |

Nine new links are real work in the fight models. Each ships with a test that +10 on that attribute measurably changes a situation, at a small weight, so nothing is decoration and no old balance is thrown off.

## Other sports: kicks, knees, elbows, MMA
Body and Mind stay the same 12 numbers plus the style dial in every sport. Each sport only decides which skill families it shows, and the ruleset decides what is legal.
| Family | Skills | Boxing | BJJ | Kickboxing | Muay Thai | MMA (first update) |
|---|---|---|---|---|---|---|
| Hands | The ten boxing skills | Yes | No | Yes | Yes | Yes |
| Legs | Low kicks, Body kicks, High kicks, Teeps, Checking kicks, Taking kicks | No | No | Yes | Yes | Yes |
| Close range | Knees | No | No | Yes | Yes | Yes |
| | Elbows, Clinch | No | No | No (most rules) | Yes | Yes |
| Wrestling and wall | Takedown defence, Wall work, Scrambles, Get-ups | No | No | No | No | Yes |
| Ground | The eight BJJ skills | No | Yes | No | No | Yes |
| Ground striking | Ground and pound | No | No | No | No | Yes |

Numbers shown: boxer 25, grappler 20, kickboxer 32, Muay Thai 34, MMA 47.
Display: from kickboxing up, skills fold into families. Each family shows one headline number and only the family that matters for this fight is open, so an MMA fighter reads as about seven headlines, with every number one click away.
Scope: the agreed release is boxing and BJJ at Early Access, MMA in the first update. Kickboxing and Muay Thai are not scheduled. Nothing here is built until a sport is.

## The display
Overview, same three columns, same order, in both sports: Body, Skills, Mind. The twelve shared numbers are identical in both views; Power, Chin and Cuts appear only in a sport where she can be hit.
A sport switch appears only once she trains both. With one sport there is no switch.
Beside it: a style line from the numbers ("Keeps it long") and one thing to work on, with where it is trained. Each number's hover says what it does in this sport.
Record, rank or belt, and weight class belong to each sport.

## Crossing over
"Start BJJ" (or "Start boxing") on Overview. It costs training time, the real price: one week, one plan, mornings and pad nights or mat classes share it.
- Body and mind carry over at their value, immediately.
- Skills of the new sport start near zero, with a small read-across from related skills (boxing Inside work to Control, BJJ Control to Inside work).
- Engine is specific: it reads lower in the new sport at first and comes back over some weeks of that training.
- Skills she stops training fade slowly, as pad moves do today.
Numbers for read-across and how fast the engine comes back are NOT set: research C55 found no measured data on crossovers. John's seat is asked; until then they stay blank, never guessed.

## Build, after PR #85 passes its gate (it owns Attrs and AttrBoard)
1. The data: one attribute set, Ana's six stats mapped onto it (cardio to Engine), old saves migrated. Pure module and tests.
2. The seven new links, each with its measuring test, boxing after PR #85 lands.
3. The Overview page, from the approved mockup.
4. The crossing over.

## Critics' round on the profile (two sonnet critics, S402)
Player critic 7/10: 24 numbers is no longer "very low"; the shared columns are the right idea. Art director 6.5/10: tidy, but 24 identical blue bars do not say which numbers matter.
Taken: bars coloured by group; on switching sport only the Skills column moves and Body and Mind visibly stay put; the numbers that matter for the current plan stand out.
Not taken: merging Jab, Right hand, Hooks and Uppercuts into one skill (each is trained and thrown on its own in the combo lab); a neck or core number for chin (Chin already covers it).
Noted: Aggression must stay one number with the style dial, not a second one. A new white belt must read as new, not broken: the note beside it says so.

## MMA critics' round (his note: "have all attributes critqued for mma if we need anything else"; two sonnet critics, S402)
MMA coach 5.5/10 and sim designer 6/10, both on the earlier draft. v2 above is not re-scored.
Taken (both): Power and Chin moved to Body; Takedown defence, Wall work, Get-ups, Ground and pound as their own numbers; a weight-cut number; fold the display.
Taken (one): Scrambles; Submission defence; Taking kicks; Cuts (it gives the cutman something real to read); Aggression as a dial, not a bar; Guard renamed Blocking.
Not taken: merging Hand speed and Foot speed (both critics asked; a slow-handed mover and a fast-handed plodder are different fighters, PR #85 measures them apart, and the fold shows them under one headline in MMA);
merging the four punches (trained and thrown separately); merging Toughness into Chin (a liver shot is not a chin); hiding Flexibility (his call, and it does real work in kicks and guard);
Grip, fight-week nerves, style adaptability and late-fight durability as numbers (Strength, Weight cut, Fight IQ, Engine and Heart already carry them; no separate decision).
