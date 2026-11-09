# Coach round S412: designer

Picture: `docs/mockups/s412/coach/designer.png` (source `designer.html`, rendered with tools/render_mockup.py). It replaces the STAFF card on Club > People; no new screen.

## The moments (start here, not at a screen)
1. Week 14. Lucy's jab bar touches a red line on Luke's card. Luke says he has shown her everything he has on it. Her ceiling is higher than his. A fight is 5 weeks away and Marcus Hale is available. The player feels loyalty, ambition and fear of breaking something that works, all at once.
2. Three weeks after swapping. Corner minute, round 2. The player shouts "Draw the lead". She does not take it in full: nobody ever rehearsed that call with her. That is what switching cost, felt on fight night.
3. Week 30. The coach the player kept is now on the Corner turn of the tape. She takes the hard truth between rounds and fights better for it. That is what staying bought.

## Real gyms (patterns, no numbers)
- Schools are real and recognisable: Cuban-style amateur (footwork, distance, the jab), Detroit-style pressure with hard sparring and the left hook, Philly-shell defence and counters, peek-a-boo head movement from the inside, Mexican body-hook pressure, the British amateur jab-and-score habit. A trainer is known for a school, and so for a blind spot.
- Boxers change trainers mostly after a loss, a stall, or a move to the pros. What they gain: a fresh eye on one flaw and a new school's tools. What they lose: the chief second who reads them in the corner, the shared tape and habits, and weeks. The widely told cases (Tyson parting with Rooney, big names moving between trainers after losses) show the same two-sided story: sometimes a boxer is rescued, sometimes something goes quietly missing.
- Amateur coaches build fundamentals; pro trainers manage rounds, pace and the corner. Many fighters carry a separate conditioning person. Cutmen are specialists. Trainers also learn from their fighters: a boxer's habit becomes the gym's lesson.

## The five mechanics, smallest first

### 1. The Book (the school)
- Moment: hiring. The card shows a school and a blind spot as pictures, not an area-rating table.
- Rule: each coach carries a book of about 5-8 entries: moves, combinations, and 2-4 corner calls. He can take a boxer through an entry only. A move outside his book he can hold pads on (stops the fade) but not raise. A boxer alone on shadow or heavy bag can still reach Raw. What the boxer learned stays with the boxer.
- Cost: pad time is already scarce (3 pad nights, 75 minutes each), so a wide book is not free to use. A big-book coach costs more per week than a narrow one.
- Changes: which moves she can grow, which calls she has rehearsed (see 3). Plan lines: a plan answer outside everything she has been taught is "walks into it" more often.
- Breaks if overdone: a coach with a huge book removes the choice. Keep books narrow enough that every coach has a clear gap.

### 2. The Limit line (the ceiling)
- Moment: week 14 above. The player sees it coming.
- Rule: for each entry, a coach has a depth: Usable (30), Sharp (60) or Signature (85), taken from his area rating in COACH1 (below about 45 Usable, about 45-70 Sharp, over 70 Signature). Signature depth also needs the bond at Trusted. A boxer's mastery with that coach stops at his depth. Her own potential is separate: she can be capped by him, not the other way round.
- Seen coming: a red tick on every bar, and the week review says "at this pace stops growing in N weeks". The forecast already exists for stat deltas.
- Cost: a high-depth coach costs real money in a gym with 1-3 months of cash. Passing the limit costs a block of weeks with another coach.
- Changes: the weekly gain on that move goes to zero at the line, so the choice is forced by a number the player can read.
- Breaks if overdone: if every boxer hits the line at week 10 the player rotates by rote. Tune so most boxers hit one line, not all, and the others still have room.

### 3. The Bond (tape)
- Moment: the corner, and the night a hard truth is said.
- Rule: four turns of tape per coach and boxer pair: Stranger, Working, Trusted, Corner. Builds with weeks drilled together (range 4-8 weeks to Working, 12-24 weeks and 1-2 fights together to Trusted), a goal met together, the coach in her corner on a win, and especially a loss survived together. Breaks (drops a turn) when you overrule her asks or ignore the coach's one change repeatedly, when a goal he set is missed, when his corner is taken from him for a fight, or when she is split between too many coaches. Per pair, so one head coach with two boxers builds both bonds slower.
- Changes on fight night: rehearsed calls are taken at full trust (the pack's morale trust factor stays, rehearsal and bond add to it, range +0.05 to +0.15); a Trusted coach's TALK works (the truth steadies, where a Stranger's truth stings); the corner card's "what hurt" reads narrow in ranges at Trusted and wide at Stranger. In the week: Stranger gains x0.7 for the first two weeks together (range 0.6-0.85); Trusted x1.05-1.10; Signature depth opens.
- Cost: time, and the money to keep a coach. Loyalty to one coach also loads the risk of the coach being poached.
- Breaks if overdone: if the bond is a flat bonus, staying always wins. It must gate depth and not stack beyond the Trusted tier.

### 4. The Handover (rotating)
- Moment: the notice, and the first week of a new face.
- Rule: a hire is a block, 4 weeks minimum (range 3-6), signing fee already exists ($1,000), leaving costs a week's pay. A coach leaving at Trusted or above gives one parting lesson: +5 to +10 on one move at his depth, and his notes pass to the next coach (the coach's notes card stays). Leaving on bad terms gives neither. A new coach starts at Stranger. On the coach card, the new coach's book shows what he adds to this boxer in green and the cost of the first two weeks.
- Cost: reading-time (about 2 weeks at x0.7), the notice, the rehearsed calls not carrying over, the fade on what the new coach cannot hold or raise.
- Changes: breadth. A rotated boxer owns more Usable moves and more rehearsed calls, but fewer Sharp and Signature ones.
- Breaks if overdone: hire-for-a-week farming. The block and the x0.7 start stop it; the bot below tests it.

### 5. The coach learns from the corner
- Moment: after a win, the week review says "Luke picked up the Check hook from Lucy".
- Rule: when a boxer wins a bout using a weapon outside her coach's book, and the bond is Working or above, the coach adds it to his book at Usable depth. Also the head coach (the player's edge: Old hand, Ex-pro, Amateur coach, Strength coach) starts with a school and grows it the same way. A coach with a grown book is worth more, and also worth a rival's offer: a trained coach can be poached by the named rival gym (Frank Doyle's Eastside ABC) and takes his book with him.
- Cost: nothing at first; the cost comes later when the coach is poached or wants more money.
- Changes: books grow from your gym's wins, so the gym slowly gets its own style. It gives a reason to keep a coach over years.
- Breaks if overdone: a coach who can learn everything becomes the best coach. Cap at one new entry per season and only at Usable.

## Pack mechanics touched
Coach factor 0.5+rating*0.7 percent and 60% with no coach; MoveMastery gain (up to 1.40x); the tiers New/Raw/Usable/Sharp/Signature and weapon at 30; fade of undrilled moves; pad nights and the pad-night sharing for two boxers (agreed, not built); PlanLines (coach rating teaches line N); plan answers Beats/Works/Walks into; the 8 perks (Ring general, Counter sense, Body snatcher need weapons from specific books); corner minute (calls, TALK, ONE CHANGE, trust factors by morale, "only two instructions get through"); morale and Coachability, Loyalty; goals and "Her asks"; the coach's notes card; staff jobs and the $1,000 signing and a week's pay on letting go; head-coach edges; twist card "old coach visits"; Find a fighter ceilings (Amateur coach edge).

## What I would cut
Mechanic 5's shop talk between coaches (not needed; a coach learns only from the corner), and the pad-hold on out-of-book moves if the bots show it makes rotation free. If the build must be smaller: ship 1+2+3 first, and 4 as soon as there are two coaches to rotate.

## How the bots prove it false
Run careers on the eight stylised opponent mixes with strategies: loyal, rotate every block, rotate when a limit is hit, one-week hire farm, random. Measure win rate to the first pro offer, week of the offer, cash and perks reached.
- Fails if any one strategy beats the others by more than about 5 points of win rate across all boxer types.
- Fails if the one-week farm is above loyal on cash-adjusted results.
- It must pass: boxers with high potential and Coachability favour rotating at the line; boxers with low Coachability or a fight inside 4 weeks favour staying; a pressure-school gym wins vs out-boxers and loses to counter-punchers so books can be countered.

## To reach 10/10 (most important first)
1. Prove with the bots that neither staying nor rotating wins every career, using the table above, before any screen is built.
2. A coach card that shows the book as a picture with the limit line and the boxer's marker, as drawn, and a swap preview that shows what a second coach adds and costs in the same picture.
3. The cost of a swap must be visible before the click: first two weeks, block length, rehearsed calls lost, fade. No hidden penalty.
4. A real change on fight night: rehearsed calls and the bond-gated TALK, with the corner card showing the effect, so the player feels staying and leaving.
5. Coaches must feel like people: a school, a blind spot, a line about this boxer (functional, not flavour), a corner record, one thing picked up from her.
6. Wire opponents to counter schools so a narrow book can lose (needs "opponents adjust by round 2", agreed not built).
7. A season clock for coach changes: handovers are cheapest right after a fight and ruinous in fight week.
8. Poaching by the named rival gym and a coach who stalls his own career (his depth grows only with the gym's wins).
9. Two boxers sharing a coach: the pad-night split costs bond to both (needs the agreed pad-night rule built).

## Strongest idea
(see the three lines in the reply)
