# Skills layer review, S404, systems designer

Read: CRITIC_PACK, CRITIC_ACCESS, profile.png, the top of Exchanges / RoundStyle / BoutRules (boxing) and the weight tables
and header of BjjBody / BjjBeat (BJJ). I did not read BjjWalk.gd whole or Exchanges past its first 60 lines, so code costs
below are estimates and say so where unsure.

## 1. Score: 4 / 10
- It is two lists glued together. 7 striking skills are one grain (how you hit and avoid); the 10 grappling skills are another
  (one per move family plus its mirror). Grappling gets 10 of 17 while boxing, shipping first, gets 4-5.
- Six of the seventeen are move families or the mirror of one (Takedowns, Submissions, Passing, Escapes, Takedown defence,
  Submission defence). Submissions 16 plus an armbar at Sharp is two numbers saying one thing, unless the skill does
  something the moves do not.
- The profile mockup proves it: striking gets bars, and the whole ground game falls into a grey text blob of 11 numbers.
  If it cannot be shown as bars a player cannot read it at a glance.

What a skill must DO that moves do not: be the family-wide level. Drilling any move in the family raises the skill a little;
a new move in that family starts with a head start from it; it is added to every move in the family. That is the only
reason to have the layer, and it is what makes crossover real.

## 2. One row per skill
| Skill | Verdict | Sports | What it changes in a fight | Trained by | Decision it gives |
|---|---|---|---|---|---|
| Accuracy | KEEP (it is today's Technique) | all striking | fewer wide misses, landed share (RoundStyle.active reads thrower technique) | pads, shadow, bag | volume/precision vs power |
| Timing | KEEP, weakest of the keepers | all striking | counters, punishing the entry (Draw the lead, Waiting to counter) | sparring, counter drills | build a counter-puncher |
| Blocking | MERGE into Defence | striking | one number: how much of what is thrown lands | sparring, slip rope | |
| Head movement | MERGE into Defence | striking | same | | |
| Kick defence | MERGE into Defence (checks and catches are MOVES) | kick, MT, MMA | same | | |
| Defence | KEEP (today's Defence) | striking | hit rate against you, "hands up" call works | sparring, slip rope | tank vs slick |
| Footwork | KEEP, make it stored, not derived | striking | range holding, Jab and move call, pull-back | footwork drills, shadow | out-boxer vs pressure |
| Inside fighting | KEEP, rename Inside (absorbs Clinch) | box, MT, MMA | ropes, tie-up, short-range exchanges | clinch drills, sparring | take it to the ropes |
| Clinch | MERGE into Inside | | one number; the sport swaps the moves | | |
| Takedowns | KEEP as Wrestling, with its defence | BJJ, MMA | standing and entry groups, both sides | live wrestling | wrestler vs guard puller |
| Takedown defence | MERGE into Wrestling | | BjjBody already has an attacker and a defender weight per group, so one number serves both | | |
| Scrambling | KEEP | BJJ, MMA | transitions after a failed move, who lands on top | rolling | the chaos fighter |
| Guard | KEEP (bottom game: retention and sweeps) | BJJ, MMA | bottom odds, sweeps | positional sparring | guard puller |
| Passing | KEEP as Top game (absorbs Control) | BJJ, MMA | passes and holding a position | positional sparring | pressure passer |
| Control | MERGE into Top game | | holding a position is the other half of passing | | |
| Submissions | KEEP, both sides (absorbs Sub defence) | BJJ, MMA | finishes and defending finishes | drills, rolling | the finisher |
| Submission defence | MERGE into Submissions, or into Survival | | | | |
| Escapes | MOVE DOWN to the Playbook (they are moves, already folded into Moves), the bar is Survival | BJJ, MMA | | | |

## 3. Missing
- Survival (ground defence): escapes plus staying alive underneath, as one bar. Optional, a taste call.
- Ground striking, MMA only: ground and pound is a fight-ending path with no home in the list.
- NOT missing, do not add: Power (Strength + Explosiveness), Pace (Stamina), Pressure / ring generalship (Fight IQ + the
  Aggression slider), Adaptability (Fight IQ), body-shot skill (a move and an aim setting already).
- Kickboxing and Muay Thai need no new skill. Knees, elbows, teeps, checks and low kicks are moves; the Muay clinch is Inside.

## 4. Recommended final list and counts
| Sport | Skills | Count |
|---|---|---|
| Boxing | Accuracy, Timing, Defence, Footwork, Inside | 5 |
| Kickboxing | the same five (a kick is a move, kick defence is Defence) | 5 |
| Muay Thai | the same five, Inside weighted much more | 5 |
| No-gi BJJ | Wrestling, Scrambling, Guard, Top game, Submissions, Survival | 6 |
| MMA | the five striking + the six grappling + Ground striking | 12 |

Too many: 5-6 bars per sport is right, 7 is the edge, and never more than ~12 skill numbers anywhere. MMA's 12 is readable
only as three labelled groups (Striking 5, Grappling 6, Ground striking 1), with the last hidden until the fighter owns a
ground-strike move. At 17 plus 10 attributes plus moves, nobody can say what a fighter is in one look. A boxer is already at
15 numbers with 10 attributes and 5 skills.

## 5. Crossover (all guesses, no data; the pack leaves it blank on purpose)
- Striking sports: Accuracy, Timing, Footwork carry about 80-90%. Defence about 70% (new weapons and leg checks show up as
  a MOVE gap, not a skill gap). Inside about 50% into Muay Thai (a different clinch), about 70% into MMA.
- BJJ and MMA grappling: Guard, Top game, Submissions, Scrambling carry 90-100% (no-gi is the same game); take ~10% off for the
  cage and ground strikes.
- Wrestling: BJJ to MMA about 70% (BJJ takedowns are pull-heavy and cooperative).
- Striking to grappling: 0 on skills. The bridge is the primaries (Stamina, Composure, Fight IQ, Heart), which carry by design.
- Rule I recommend: a crossing fighter keeps his skill number, but every new MOVE starts at New. The family head start is why a
  boxer learns a kick faster than a stranger does. That is the layer earning its place.

## 6. Overlaps (double counting)
- Timing vs Fight IQ (reading) vs Speed (reacting): define Timing as counter-hitting only, or fold it into Accuracy.
- Footwork is DERIVED in RoundStyle.gd as (speed + defence) / 2 today. Store it and drop the formula, or Speed and Defence
  count twice.
- Blocking, Head movement, Kick defence vs Durability: a block is a move, taking the hit is Durability. Defence is about not
  being hit, never about surviving it.
- Control vs Strength; Scrambling vs Explosiveness + Flexibility; Guard vs Flexibility; Submissions vs Flexibility and
  Composure. BjjBody already weights each move group by those attributes, so a skill must be an ADDED term, never a
  replacement, or the same ability is counted twice.
- Takedowns, Submissions, Passing, Escapes are named like moves (single leg, armbar, a pass). The skill is the family number;
  the level of the move is the Playbook's. Never list move names inside a skill.
- Inside is the short-range skill, not toughness (that is Durability).

## 7. What the fight code needs, in order of cost
1. Boxing Accuracy and Defence: free. They exist as Technique and Defence (RoundStyle.active, BoutRules.fight_power read
   them). Rename the label. Do this first.
2. Footwork stored, not derived: low. RoundStyle.footwork() already prefers a stored p["footwork"]; new is the career data, a
   training source, and removing the derived formula.
3. BJJ family skills: low to medium (estimate from the weight tables, not the whole walk). BjjBody has per-group weights for
   attacker and defender (standing, pass, sweep, escape, back_take, entry, transition, choke, arm, leg), so a skill is one more
   key per group and the two-sided merges cost nothing extra. Wrestling = standing + entry, Top game = pass, Guard = sweep +
   bottom entries, Submissions = choke + arm + leg, Survival = escape. Unsure whether guard retention and holding a position
   are resolved in BjjWalk at all, or only through attempts; check before promising Guard and Top game.
4. Timing and Inside in the boxing exchanges: medium. Exchanges calls carry a "needs" list (footwork, technique) and modes
   (Waiting to counter, Tie up); add timing to the counter calls and inside to the tie-up/ropes ones. The plan places inside,
   clinch and ropes exist for the plan; the dice weights do not.
5. Family head start on new moves: medium. A move starting at New takes a fraction of its family skill, and a drilled move
   feeds a little back. Touches Playbook mastery data and the save. This is what makes crossover real.
6. Skill training routes: medium. Each skill needs a morning or evening source (today a morning raises one stat and a pad
   night raises moves). A skill with no way to raise it is only a label.
7. Kickboxing, Muay Thai, MMA: HIGH. There is no kick, check or cage engine; Exchanges is boxing-only. The cost is the engine,
   not the list. Do not build skill numbers for a sport that has no fight to use them.

## Unsure
- How many bars the owner wants on a boxer page: I say 5, but he said real stats stay, so he may want more.
- Whether Timing earns a bar or folds into Accuracy (4 boxing skills).
- Whether Survival is its own bar (my preference) or merged into Submissions.
- Every crossover percentage (no data). BJJ code costs rest on the weight tables, not on BjjWalk as a whole.
- The Playbook move count is not established in the pack; I did not count it.
