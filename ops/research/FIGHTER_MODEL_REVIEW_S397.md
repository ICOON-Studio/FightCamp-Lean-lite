# Fighter model v1 - three critics and the verdicts (S398, 2026-11-07)

Operator S397: "have these mechanisms reviewed by critics and ask for ideas to proper design". Three fresh critics read
`FIGHTER_MODEL_S397.md` v1 (plus J33, K66, the S259 verdict and the fight code) and reviewed it hard. Their reviews are
summarised here in our words; the verdict on each idea is Claude's (the design owner): YES (in v2, built now), LATER
(right, but not this build - with the reason), NO (with the reason).

## Scores on v1
| critic | score | headline |
|---|---|---|
| A. Boxing coach / fight analyst | 5.5/10 | "The fight is mostly a fight over WHERE it happens; today that is a dice roll on the opponent's style." |
| B. Game systems designer | 5/10 | "A weighted sum of gaps with fixed situation shares is one linear average per opponent style." |
| C. Football Manager / sports-sim veteran | 6/10 | "Right principles; missing the layer that makes sims about people: growth, ageing, getting to know him." |

All three put the same idea first: **contest the situation** - the out-boxer's feet and jab trying to keep it long against
the presser cutting the ring. Without it no style triangle can come out of the maths. v2 is built around that.

## A. Boxing coach / analyst
Main points: the table mixes places (range, inside, ropes), tactics (pressing, countering, loading up) and states (tired,
hurt); the pocket (mid-range trading) is missing and is the most important place; cutting the ring is footwork, not foot
speed; a presser loses to the counter on the step-in (the check hook); "countering" was framed backwards (the counter
puncher waits, the leader feints); accuracy / shot selection is the single biggest missing attribute; timing is not hand
speed; strength is not power; recovery from being hurt is not chin; aggression mixes work rate with going forward;
"body punching" is a target, not a punch; guard should cut clean punches landed, not absorb damage after they land; the
knockdown fade by round and the reach and age numbers in J33 are MMA numbers (boxing: reach real but smaller, damage
builds up and stops fights late). Archetypes and triangle: out-boxer beats slugger, swarmer beats out-boxer, slugger beats
swarmer, counter-puncher beats a predictable leader, volume beats the counter-puncher on the cards; each exception is one
attribute past a line (an out-boxer with a check hook beats swarmers). Numbers (marked by the critic as roughly sure):
50-60 thrown and 15-18 landed per fighter per round, ~30% connect (jab 22-25%, power 35-38%), about half of pro fights
inside the distance, southpaws 15-20% of boxers with a small edge (52-55%) that shrinks with familiarity, favourites ~75%,
~90% at heavy odds, draws a few %.

| idea | verdict | why |
|---|---|---|
| A1 contest the situation each exchange (range battle decides the place) | YES | v2 section 4: a distance ladder long / pocket / inside with a steering contest. |
| A2 tired, hurt (and cut) are states that bend every exchange, not situations | YES (cuts LATER) | Tired and hurt now lower the attributes in every exchange, legs and defence first. The corner's eight games stay as the words the corner reads and answers (calls, clues, reads, habits and plans are built on them and were playtested), so "tiring" and "hurt" remain as what the corner SEES. Cuts need a cut mechanic and a cutman hire: the traits/injury session. |
| A3 add the pocket, the ropes, the clinch, the feeling-out; drop "loading up" as a place | YES pocket, ropes, clinch; LATER feeling-out | Pocket = the mid rung; ropes = being pinned inside after wanting it long; the clinch already exists (ClinchRest) and sits on the inside rung. Loading up stays as an opponent game word (the corner answers it) but is fought in the pocket with a risk dial. Feeling-out: the read (TheRead) and "slow to start" cover part; a round-1 rule waits. |
| A4 split abilities from tendencies (pace, going forward) | YES | Two dials, pace and forward, not in the overall, not good or bad. |
| A5 accuracy, timing, strength, recovery from hurt; pressing reads footwork; guard cuts clean punches | YES | All in v2. Recovery covers both the breath between rounds and clearing the head (one number, two uses). |
| A5b cut and swelling risk | LATER | Needs cuts in the fight first (with the traits session). |
| A6 stance matchups beyond familiarity | LATER | Familiarity is already in (never faced a southpaw, the lefty week). The jab/rear-hand shift needs a source; none in J33. |
| A7 damage builds up; counters hit harder; body damage slows feet | YES build-up and body; LATER counters | Knockdowns already build on damage; v2 feeds power vs chin per side and the body attribute scales the energy a body shot costs. |
| A8 a round report a coach can read (who controlled the range, the duel that decided it) | YES | v2 section 7. |
| drop "body punching" as an attribute | YES | It is a target: hooks and uppercuts thrown downstairs, the aim dial already sends them. |
| split fight IQ into reads and killer instinct | PARTLY | Ring IQ = reads and adjusting. No killer-instinct number: finishing reads power, accuracy and composure, which is the critic's own reason ("they punch themselves out swinging wild"). Fewer numbers, nothing dead. |
| output comes from engine and work rate, not hand speed | YES | Output = pace dial x energy left; hand speed acts in duels. |
| treat MMA numbers as ceilings | YES | Reach bar set to ~58-64% at range-heavy fights (J33's 2/3 is the MMA ceiling), ~50% inside; knockdowns come from damage build-up, not a forced per-round fade. |

## B. Game systems designer
Main points: with situation shares fixed by the opponent's style the expected margin is one linear combination of gaps,
an average in disguise; spikes matter only if the share of situations depends on both fighters (steering), the gap curve
is convex, or a fighter leans on his best tool (max-of). Dead: straight (in no row), height, recovery in a 3-round bout;
always-best: guard, hand speed, composure, aggression (plus everywhere, minus nowhere); the counter-puncher had no duel
against the presser; "attacker" was undefined; mastery and punch attributes would double count; variance across 18
independent exchange rolls averages out, so favourites get too safe; players hold 5-7 chunks; bars need a measured
overall, a nonlinearity bar, a triangle bar, a sensitivity bar, a steering bar, and a counterfactual check that the named
deciding duel really decided it.

| idea | verdict | why |
|---|---|---|
| B1 distance ladder + steering contest, clamp 0.2-0.8, ropes, energy cost | YES | v2 section 4, as proposed (game values). |
| B2 two-sided duels, convex gap curve, 0.6 best tool + 0.4 mean | YES | v2 section 5. A spike is a weapon and a hole a target; the linear version scored the spiky boxer 0, this scores 15.7 in the critic's worked case. |
| B3 fix the table: counter vs presser, straight at range, height inside, heart vs composure triggers | YES | Step-in counter (check hook) when the ladder closes; straight is range's power shot; taller boxer pays inside; composure = under fire and hurt, heart = late and tired. Recovery kept: pro bouts now run 4-10 rounds (ProLadder), so it lives. |
| B4 aggression with costs | YES | The pace dial: more output and close rounds, but energy, guard and the opponent's counter pay for it. |
| B5 variance: form on the night, knockdown tail, judges' noise | YES form, YES tail; LATER judges | One form roll per boxer per bout (game value sd 3) - the shown odds integrate over it, so they stay honest. The tail is the existing power-vs-chin count. Judges' noise needs scorecards per judge (today two judges score round for round): with the scoring session. |
| B6 the overall = measured win rate against a reference field | PARTLY | Tables keep a level number (ranks, offers, S397 work); it is the mean of the abilities and is never fought on. The bars use a MEASURED equal strength (win rate against a fixed field) so "equal overall" is not circular. |
| B7 six keys + signature line + steering bar | YES | Fighter page: three groups, the keys (long, pocket, inside, power, durability, engine), "two spikes and a hole" in words, where the fighter wants the fight. |
| B8 mastery feeds duels OR the plan, not both | YES | Punch attributes feed the duels; mastery stays the drilled-move layer (weapons, plan arrows, combinations). Training mastery also raises the punch attribute a little (the coach drilling the hook improves the hook). |
| B8b per-attribute talent ceilings | LATER | One potential today; a ceiling per group comes with training trade-offs. |
| remap the calls' "needs" to the new attributes | YES | A call is done with the attributes it uses (Jab and move = jab + footwork). |
| min-max optimizer bar, training-specialist bar | LATER | Need a hill-climbing probe and the training trade-offs; queued as bars for the next pass. |

## C. Football Manager / sports-sim veteran
Main points: 21 is a good size for a deep sim; accuracy, cut resistance and hand fragility are missing; the five
masteries are too fine to read; heart and composure need different triggers; show aggression as a slider; show 1-20 not
0-100; a hidden people layer (professionalism, ambition, loyalty, temperament, consistency, big-night nerves, injury,
cuts, weight-cut ease) is where boxing management drama lives; WorldGen draws style independent of everything, KOs are
random, height is the same in every division, peak age flat; generate from correlated base traits, a tilt, one signature
and one flaw each, a background, body by weight class, hidden potential, and records from a simulated history; per
attribute age curves (speed first, power last, skill peaks 30-33); no overall on screen; win chance from the real engine
as a range; the coach's report in words; training with real costs.

| idea | verdict | why |
|---|---|---|
| C1 accuracy | YES | Added (same as A5). |
| C1b cut resistance, hand fragility | LATER | With cuts and the injury/traits session. |
| C2 punches too fine to read | YES | Four punch rows (jab, straight, hooks, uppercuts) shown together as the arsenal; body punching dropped. |
| C3 heart and composure, separate triggers | YES | Same as B3. |
| C4 dials shown as sliders | YES | Pace "patient - relentless", forward "backs off - walks down". |
| C5 show 1-20 instead of 0-100 | NO (for now) | Every screen and the operator's habit read 0-100; ranges from scouting do the critic's job (a 2-point noise gap is inside a range). A UI critic can reopen it. |
| C6 hidden people layer | PARTLY | Personality is already there (heart, discipline, confidence, coachability, loyalty, temper). Nerves, consistency, injury and cut proneness, weight-cut ease: with traits next. |
| C7 generation: base traits, tilt, signature + flaw, body by class | YES | v2 section 6. |
| C7b background, simulated history | LATER | Backgrounds are words on top of the tilt; a pre-history run costs world-creation time. KO counts now come from power (cheap) - YES. |
| C8 age curves per attribute in a decline order | YES | Generated boxers' shape moves with age every year end: speed first, then legs and recovery, then chin; ring IQ rises to 33; power last. |
| C9 scouting by tape per situation, scout quality, stale knowledge, own coach misjudges own boxers | PARTLY | Ranges per attribute that narrow as the file opens (existing stages). Tape-per-situation, staleness and the coach's own-boxer error: LATER. |
| C10 no overall on screen | PARTLY | The fighter page leads with attributes, keys and words; tables keep the number for now (ranks just got fixed to mean levels). |
| C11 win chance from the real engine, as a range | YES | BoutRead already walks the fight's own maths exactly; v2 extends it to the duels, the ladder and form. |
| C12 coach's report in words | YES | Signature line + "how they win / how to beat them" from the duels. |
| C13 training costs (sparring wears the chin, strength costs engine and the weight) | LATER | Training session after this build. |

## What v2 changes (summary; the full design is FIGHTER_MODEL_S397.md v2)
1. A distance ladder (long / pocket / inside) contested every exchange: wants + control + clamp + ropes.
2. Two-sided duels per distance, convex gap curve, best tool + mean; the deciding duel named and checked by counterfactual.
3. Attributes: 20 abilities + heart + two dials + body facts; accuracy, timing, strength added; body punching dropped;
   counter -> timing; fight IQ -> ring IQ (reads).
4. Tired and hurt bend every exchange (legs and defence first); heart resists the late fade, composure holds the defence
   when hurt.
5. Form on the night per boxer per bout; the shown odds integrate over it.
6. Generation from base traits + archetype tilt + signature + flaw + body by division + age shape; one model for player
   fighters, opponents and the world.
7. Display: three groups, keys, signature line, wants slider; scouting ranges per attribute; the round report names the
   place and the deciding duel.
8. Bars added from B: nonlinearity, triangle, sensitivity, steering share, migration, counterfactual duel.

## Round 2 (same three critics on v2, not blind): 7 / 7 / 7.5
| idea (round 2) | verdict | why |
|---|---|---|
| A: knockdowns from either fighter (the puncher's chance) | YES | Knockdowns.puncher_chance: the round's winner can be dropped by the loser's punch (0.4 of a clear round's count chance, GV). In the watched bout and the world. |
| A: "lean and tie" must not score; it dampens and drains | YES | Removed from the place score; a won tie-up shrinks the exchange (up to 40%). Energy drain and the ladder reset to the pocket: LATER (small). |
| A: inside answers need head movement; uppercut beats the crouch | YES | Short work answered by 0.4 inside + 0.3 strength + 0.3 head movement; the uppercut tool gains 0.2 per point of the answerer's head movement over 60. |
| A + B: steering nearly symmetric / a footwork race | YES | Long: 0.35 footwork + 0.25 foot speed + 0.2 jab + 0.2 timing. Close: 0.35 footwork + 0.25 foot speed + 0.2 head movement + 0.1 guard + 0.1 chin + the forward dial. Strength 0.3 of control while inside. Composure cuts the ropes penalty. |
| A: stance does nothing | YES (GV) | Opposite stances: jab -3, right hand +3. |
| A: age from 29 for everyone, ±2 by division | LATER | Our divisions span 55-75 kg; no source for the shift. |
| A: chin in pocket trades | YES | The power shot's answer is 0.3 head movement + 0.4 timing + 0.3 chin. |
| B: guard/head movement in too many answers | YES | Answers re-keyed (right hand: guard + timing; power: head movement + timing + chin; body: body + guard; step-in: head movement + composure). Measured by bar 8. |
| B: knee at 10 leaves spikes linear | YES | Knee 6. |
| B: the opponent still rolls its game | YES | RingDuel.mode_bias: the opponent's games of its best place are weighted up by ring IQ (Exchanges.next_mode bias). |
| B: bars 7-10 cannot fail | YES | Bar 9 -> out-boxer long share >= 0.65 vs a slow swarmer, <= 0.45 vs a fast stalker; bar 10 -> migrated fighter's chance vs the field unchanged (on the profile, not the seven numbers); bar 8 paired; bar 7 a 300-build optimizer (best build <= +0.08 over the best archetype, top-10 builds not one top-3 set). |
| B: heart from round 2 in 3-round bouts | YES | "late" = round 3+ of 3 rounds; pros the same (GV). |
| B: pace's benefit was missing (cost only) | YES | Found while wiring: the busier side takes close exchanges, 8 x pace gap / 100 (judges reward work, boxing critic round 1). |
| C: world boxers need a career arc (ceiling, growth rate) | PARTLY | WorldAge already raises young boxers toward the peak and declines after; a hidden ceiling per boxer: LATER. |
| C: simulated pre-history, opponents' temper/confidence | LATER | With traits. |
| C: scouting by place (tape against an out-boxer shows the long tools) | LATER | v2 shows the six keys as ranges on the found words; per-source reveal is the next scouting pass. |
| C: one fighter card, old seven off player screens | PARTLY | The fighter board and the tale of the tape now show the model (groups, keys, signature, wants). The old seven still show on camp cards and goals; they move with the next UI pass. |

## Designer seat round (operator S397 method): Dola wrote "the version that would score 8/10" of v2.1
Raw answer: `DOLA_FIGHTER_MODEL_8_S398.md`. Verdicts (Claude owns the design):
| Dola's change | verdict | why |
|---|---|---|
| 1. redistribute defence so every ability defends somewhere unique | PARTLY | Guard is already off the step-in counter and the power shot; the rest waits for bar 8 (sensitivity) and bar 11 (optimizer) - measured dominance decides, not the table's look. Its claim that "bar 8 showed three pairs everywhere" was not measured by anyone. |
| 1b. recovery shortens hurt; chin softens the ropes | NO / LATER | Hurt lasts one exchange in the live round already; composure already softens the ropes. |
| 2. style shifts with age (forward dial rises after 33) | YES | Cheap: AttrGen.attrs_of adds +1 forward a year past 32 (an old fighter walks down instead of boxing off the back foot). |
| 2b. "at his best 28-32, slowing now" words | LATER | With the career-arc pass (ceiling + growth). |
| 3. a three-line scout summary: where they win, where they break, the trend | YES (two lines) | The tale of the tape gets "Wins: <place>. Breaks: <place>." from the duels against your fighter; the trend line waits for the career arc. |
| 4. identity sentence leading the fighter page | YES (done) | The signature line + wants line lead the at-a-glance note. Trend arrows LATER. |
| 5. round report: control share, deciding duel, one takeaway | YES control + duel (done); NO duel numbers ("hooks 84 beat 71" would be dead numbers on screen); the takeaway is the corner's read, which exists. |
| 6. record tied to profile | YES (done: KOs from power) |
| 7. a consistency dial from the form spread; familiarity in rematches | LATER | Needs a per-boxer form spread in the shown odds; rematch familiarity with the scouting pass. |
| 8. dial words with context | YES | wants_words reads "relentless - throws more, tires faster" style. |


## The BUILT model, two fresh blind critics (no old score, no author): boxing analyst 6/10, systems designer 5.5/10
Under the operator's 8/10 bar. What they agree on, and the verdicts:
| fault (built) | who | verdict | next step |
|---|---|---|---|
| Defence answers are the same at every place (guard and head movement each answer 5 of 9 tools), so moving the fight changes little: bar 1 OPEN | both | YES - the main cause of bar 1 | v3 duel table: each place its own answers (long: footwork, foot speed, jab; pocket: guard, head movement; inside: inside, strength) |
| Chin and body answer whether a punch LANDS (power shot 0.4 chin, body shot 0.6 body) | boxing | YES | chin and body act only after the punch lands: damage, counts, drain |
| The fight is near-additive; tuning pass 1 flattened the curve to fix bar 11, which killed matchups | systems | YES - the tuning treated a level problem with the curve | define strength by measurement (the level that goes even against a reference field; a value-weighted mean first), centre shapes on it, then restore best tool ~0.6 and the knee ~6 |
| The place is muted: every round restarts long, one step a time, clamp 0.2-0.8 | systems | YES | rounds 2+ open where the last ended (or at the better steerer's place); a two-step close on a big control gap |
| A weakness is never a target: random flaw on any of 20; the opponent picks its own best place, not the other's worst | boxing | YES | flaws drawn mostly from chin, body, engine, guard, footwork; high ring IQ picks the place that exposes the hole |
| Conditioning barely matters on the world path (recovery 0.006, heart 0.013) | both | YES | world path gets a cheap hurt term; fade starts earlier (TIRED_AT 65); heart holds the pace when behind |
| Southpaw maths cancels; "right hand" wording ignores stance | boxing | YES | an asymmetric southpaw edge (+1.5 on the straight) and rear-hand words by stance |
| The tale of the tape shows attack keys only; the Gap chip ignores the opponent's shape; "X kept it long" credits the winner, not the steerer | systems | YES | a Defence key; the chip on the public profile; credit the side that wanted the place |
| style_word returns the archetype, not the profile | both | YES | derive the word from dials and spikes |
| Form sd 3 watched vs 4.5 world | systems | PARTLY | kept on purpose (the world lacks hurt states); goes to one value once the world path plays hurt |
| Doc section 5 had drifted from Duels.TOOLS | systems | YES, fixed | section 5 rewritten from the constants (S398) |
Root cause, corrected: the plain-mean level explains bar 11 fully and bar 6 mostly; bar 1 is the near-additive duel with
uniform defence (both critics). The v3 pass changes the duel table and the strength definition together, re-measures
bars 1, 6 and 11 together, and goes back to two fresh critics; build bar 8/10.
