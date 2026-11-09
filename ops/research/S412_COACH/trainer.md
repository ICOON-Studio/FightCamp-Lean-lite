# Coach round S412: the trainer's answer

Role: veteran amateur and pro trainer. Picture: docs/mockups/s412/coach/trainer.png (source trainer.html). I used no web search. The cases below are from memory and are the ones I am sure of; everything marked JUDGEMENT is the trainer's opinion, not a record.

## The moment this starts from
Week 31. Mia has been with Luke for 31 weeks and 6 bouts. Her technique has stopped moving: +0.05 a week where it was +0.20. Her habit (drops the right after the jab) has been called out in the corner four times and she nods and does it again. A bout is booked in 5 weeks. The player has to choose: keep Luke, add a second voice, or hand her to a pads coach. What the player feels: loyalty and fear. Luke is the only one who knows how she breathes on the mitts, and a new man will cost a month. Staying also feels like waiting for a door to close. That mix is the decision.

## 1. What real trainers know that others do not (real patterns)
- A school, not a number. Detroit's Kronk under Emanuel Steward is remembered for the left hook and forward power; the Cuban amateur system for footwork and defence; Mexican gyms for body work. A fighter who changes trainer changes school, and the old habits come back under pressure. JUDGEMENT: a change fixes one thing in a camp, not five.
- The corner voice. Steward is remembered as a man who could change a fight between rounds, and also for Tommy Hearns standing and trading in 1985 against Hagler when told to box: the bond is trust, not obedience.
- The mitt rhythm. A trainer holds mitts to one fighter's timing. A new holder breaks it for a few weeks. JUDGEMENT.
- The amateur to pro switch is where most boxers change trainer, because a points game and a damage game want different things. JUDGEMENT.

Real cases for both paths, so neither is the answer:
- Stayers: Lomachenko with his father Anatoly, Canelo with the Reynoso family from his teens. Long arcs, one voice.
- Movers: Oscar De La Hoya used many trainers over his career, Mayweather Sr. then Roach in 2007-08; Tyson Fury went from Ben Davison to SugarHill Steward in 2019 and boxed a different, more aggressive fight against Wilder in 2020.
- A bond failing at the worst moment: Mike Tyson after D'Amato died and Kevin Rooney was dropped (1988); he lost to Douglas in 1990. Wilder's corner threw in the towel against Fury in 2020 and Wilder blamed the corner afterwards.
What a boxer loses on a change: the shorthand (one word means a whole move), the trainer knowing when he is really hurt, the mitt rhythm, the camp routine. What he gains: a fresh eye on a habit, a different school, a voice he has not learned to ignore.

## The mechanics (smallest first)

### M1. Rounds together: the bond (smallest)
- Moment: round 6, she is hurt, and the corner man is new.
- Rule: each coach-boxer pair has a bond in four words: Stranger, Working, Trusted, Family-level (call it Trusted+ in the UI only if needed; four pips). It grows with weeks of pad nights together and bouts in his corner (range to test: a bout is worth 3-6 times a pad week). It does not grow while he is not in the boxer's week. Overruling her asks, a goal missed on his watch and a change of coach inside a camp cut it.
- Fight night effect: it sits on top of the existing trust (Fired up 1.05 ... Low 0.7). Stranger caps the corner's word at about 0.85; Trusted can add up to about +0.10; the third call in a minute gets through only from a Trusted voice. A Trusted corner makes the RECOVER points work better when she is hurt.
- Week effect: a habit fix (the "gone in 4 weeks" focus) needs Working or better; at Stranger it takes twice as long.
- Cost: bond goes to zero when a coach leaves, apart from a "left well" memory (about a quarter) kept if he is let go at a natural end (ceiling hit, goal met), not mid-camp.
- Breaks if overdone: a flat +10% for a long bond makes loyalty a free best answer. Cap it small, and let the ceiling (M2) end the benefit.
- Pack mechanics touched: corner minute trust and morale multipliers, the two-instructions-per-minute limit, Ring general perk, habits and Coachability (a low-coachability boxer builds bond slower), goal talk "her asks", Loyalty trait (exists, not shown), the unbuilt "kept goal builds loyalty".

### M2. His ceiling: the notch on the bar
- Moment: week 31, the weekly gain shrinks and a red notch sits on her Technique bar.
- Rule: each of the five areas (pads, bag, sparring, conditioning, strength, from COACH1) has a rating, and a coach can lift a stat in that area only up to a ceiling tied to that rating (range: rating minus 10 to rating plus 5 in stat points, to test). Past the notch, his gains fall to about a quarter, the same shape as the existing headroom clamp. The notch is drawn on the stat bar beside the potential tick. The coach card shows "weeks to his ceiling" for the boxer next in line.
- How it is seen coming: three signs, in order. The weekly delta shrinks; the card says "about N weeks to his ceiling"; the Monday review writes one line ("Luke has taken her as far as he can on pads").
- Real source: boxers outgrow the man who got them started, usually at a level step (amateur to pro, regional to national). JUDGEMENT on the numbers, the pattern is common.
- Cost: none to keep him; the cost is the lost growth. A second coach can lift the area, which is the point of M3.
- Breaks if overdone: low-ceiling coaches become cheap traps. Every coach must have one area high (the COACH1 balance: averages equal today's overall rating) so the player is never forced to fire a good man.
- Touches: the five area ratings, the 0.5 + rating x 0.7 coach factor, headroom clamp, potential tick, perks (Stiff jab needs Technique 65, so a ceiling of 60 blocks it until a better pads coach), weekly review.

### M3. His book: depth from one voice, breadth from many
- Moment: Mia needs the body hook, which Luke does not teach.
- Rule: every coach carries a short book, five to seven lessons: two to four moves or combinations, two corner calls, one plan-line family. Any coach can bring a move to Usable (30), so it becomes a weapon. Only a coach with it in his book can take it to Sharp (60) and Signature (85). What she learned stays hers. A move outside every book of her current coaches stops at 30.
- Fight night effect: a corner call in his book gets through fully; outside it, about half (range 0.4-0.6). Plan lines: his book decides which line families he can teach beyond the base four lines.
- Week effect: a lesson in his book teaches faster in his hands (1.0 to 1.3x), and a lesson outside is at 0.7.
- Breadth costs depth: two coaches at once split her pad nights (the AGREED pad-night sharing), a switch means 2 weeks of "strangers" (lessons at about 60%), a $1,000 signing fee and a week's notice pay (already the staff-job rule). Staying with one man buys bond and Signatures in his school but leaves the moves outside his book at 30.
- Breaks if overdone: a book that is too narrow forces rotation for every career. Every boxer style should have a coach in the pool who covers its core three moves.
- Shown on the coach card as chips (picture first, as in the mockup).
- Touches: MoveMastery.gain, the Playbook tiers New/Raw/Usable/Sharp/Signature, combos, the two-fighter pad nights, PlanLines.skill_for, the eight corner calls, the staff hire fee, Luke and Marcus.

### M4. What a coach learns
- Moment: a boxer reaches Signature in a move his own coach did not carry, and the coach is changed by it.
- Rule: when a boxer under him reaches Signature in a move outside the book, it goes into the book (the boxer taught the teacher). This is what keeps a loyal coach worth keeping. Optional, cut first: once a season a coach can be sent to a clinic (about $150 and a week without his pad nights) for one lesson. Real source: coaches take licence courses and learn from fighters and visiting trainers.
- Cost: only the weeks it took to get there.
- Breaks if overdone: a boxer farming Signature on a rotation for his coaches. The rule fires only once per coach per boxer and only after the boxer has stayed 12+ weeks.
- Touches: coach book, Signature tier, the existing "old coach visits" and "visiting pro" twist cards.

### M5. Going on the left: the parting
- Moment: she has outgrown him and he is also the man who got her to the nationals.
- Rule: you can hand over, keep him on the other boxers, or keep him as the corner man on fight night only. A coach handed over well returns as the "old coach visits" card with a one-bout bond echo. Fired mid-camp, the bond is gone and a rival gym may take him.
- Cut this mechanic: the poaching half needs the rival gym, which is not built. Keep only "let go at a natural end keeps a quarter of the bond" inside M1.

## What I would cut
Cut M5 now (rival gym not built) and the clinic in M4 (a second way to the same result as M4's main rule). Keep M1, M2, M3 and M4's main rule: four rules, each with a number to test.

## How the bots prove it false
Four strategies over 200 careers each, on a split population: fast starters with low potential, high-potential high-coachability boxers, and a slugger and an out-boxer (different schools):
1. Loyal: one coach throughout.
2. Rotate every camp.
3. Rotate at the ceiling notch only.
4. Match the opponent's style with the book.
Each is scored on bouts won at year 3, stat sum, Signature count, and reaching the nationals and the pro debut.
- Rule fails if rotate-every-camp beats the best other strategy by more than 3 points of win rate in any population, or if loyal beats it by more than 3 in every population (rotation must win somewhere: low potential and short careers, mismatched school).
- Rule fails if a hire-for-a-week cycle (hire, take the lesson, fire) reaches Sharp in a book move faster than a normal hire.
- Rule fails if the bond effect is the difference of more than 3 points of win chance on its own, or less than 0.5 (invisible).
- Rule fails if in more than 20% of careers the player is forced to fire a coach with no exit (a ceiling reached and nobody in the pool covers the area).
- Expected shape: loyal wins with high-potential, high-coachability boxers over long careers (Signatures and trusted corner); rotating wins with short careers, low potential, or when the boxer's style is outside the first coach's book. JUDGEMENT.

## To reach 10/10
1. Prove with bots that both a loyal and a rotating career win, in different boxer populations, before the numbers are fixed (the whole design hangs on this).
2. Draw the notch on every stat bar and put "about N weeks to his ceiling" on the coach card, because a ceiling the player cannot see is only a penalty.
3. Make the corner minute show the bond: a stranger's calls greyed or dimmed for what is outside his book, as in the mockup, with the percentage on hover.
4. Make sure every boxer style has a coach in the pool whose book covers its core three moves, so rotation is a choice, not a trap.
5. Write the hire pool so each coach has one high area and one clear school (a Kronk-style hook man, a Cuban-style footwork man, a conditioning man like Marcus) and say so on the card in one line.
6. Show the book on the card as chips and nothing else; no list screen, no new screen count.
7. Show the leaving moment as a Monday line, not a modal, with the "left well" memory.
8. Add a four-bout check: a Trusted corner changes a hurt round in the Why ("her corner man was a stranger: his third call did not get through").

Strongest idea in three lines: the ceiling notch on her own stat bar, so the player watches the gains shrink and sees the coach's limit coming.
Second: the book is about what a coach can take to Signature, while anyone can take a move to Usable, so rotating buys breadth and costs depth.
Third: the bond lives on fight night, in how much of a stranger's third call she takes in when she is hurt.
