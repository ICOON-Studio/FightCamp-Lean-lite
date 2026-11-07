# BJJ fight design v3 (S397): the 8/10 version (Qwen)

Design target: 8/10 from a black-belt coach, a game systems designer, a sports-sim veteran. Builds on v2 (as built),
keeping the logit formula, mat time, body, finish gate, position-aware stalling, form. Each part below states what
changes from v2 and why, the rule with numbers, what the player sees and decides, and one measurable bar.

---

## A. Belt meaning

**Change from v2:** none in mechanism; v2's mat_time already builds class by class. The change is a hard calibration
table the probe must hit, and a split of mat_time into attack-mat and defence-mat so a black belt's defence is worth
more than a black belt's attack against a white belt (the coach's "defence above all").

**Rule:** mat_time stays [G]: white 0, blue 1.0, purple 1.8, brown 2.4, black 2.9 (+0.4 over first 300 classes).
New: defence-mat = mat_time x DEF_SCALE [G 1.3]. A black belt defending a white belt gets the gap x1.3 on the logit;
attacking, x1.0. Per-pair bands the probe must hit [G from R proxy, coach]: white->blue 80-88%, blue->purple 70-80,
purple->brown 65-75, brown->black 60-70; two belts 85-95; three+ 95-99; 4-stripe vs fresh same belt 62-70.

**Player sees:** the scouting card names the gap in words; the result card names whose mat time decided it.

**Bar:** the probe (n >= 2,000 per cell) lands every belt-gap cell inside its band; a black belt loses to a white belt
no more than 1% of the time.

---

## B. The grappler

**Change from v2:** body and mind become trainable in the Week (the coach: "body is dice the player cannot steer").
Ana's body starts at DEFAULT 50 + the first 8 weeks' training effect; each Week's plan can include one body focus
(strength circuit, cardio rounds, flexibility flow, explosiveness drills, composure breathing, aggression sparring).
Each focus raises its attribute by gain_of x BODY_W [G 0.6] a week, decaying as the attribute rises (diminishing returns
above 70). The mind attributes (composure, aggression) train the same way; aggression also moves with the mat call.

**Rule:** six body/mind attributes (strength, cardio, flexibility, explosiveness, composure, aggression), 0-100. Each
move reads attacker vs defender attrs by kind [G, v2 READS kept]; body cap stays +-0.25 on the logit. New: weight
class as a body fact (light / mid / heavy), +3 strength -3 cardio for heavy, reversed for light [G; R: heavier wins
60.5%, nogiratings.com].

**Player sees:** the grappler card shows six bars + weight; the Week screen shows the training focus and projected gain.

**Bar:** after 40 weeks of focused training, Ana's trained attribute rises 15-25 points; an unfocused attribute stays
within +-3 of start. Every attribute shows on the result card at least once per 20 matches.

---

## C. The five-plus games

**Change from v2:** add a sixth game, the Back-taker / Scrambler; define the matchup wheel with explicit edges.

**Rule:** six games [G, v2 shapes kept]: Wrestler (strength +6, explosiveness +12, flexibility -10), Guard player
(flexibility +14, cardio +4, strength -8), Passer (strength +12, cardio +4, composure +4, explosiveness -6),
Half-guard player (composure +10, strength +4, flexibility +4), Leg locker (explosiveness +6, flexibility +8,
aggression +14, composure -6). New: Back-taker (explosiveness +8, composure +8, strength -4, aggression +6; go-to:
scramble -> back take -> RNC). Matchup wheel [G; each edge 8-15 points]: Passer > Guard player and Leg locker;
Half-guard > Passer; Wrestler > Half-guard; Leg locker > Wrestler at brown/black; Guard player > Wrestler; Back-taker
> Passer and Half-guard; Wrestler > Back-taker.

**Player sees:** the scouting card names the style, two tells, and the matchup edge; the result card names the game
that won.

**Bar:** at equal belt, the worst matchup for each style moves the win chance 8-15 points from 50%; each style's cell
in the 6x6 matrix is 0.40-0.60; the Back-taker accounts for ~15% of brown/black opens (R: RNC ~21-22% of no-gi black
finishes, BJJ Heroes).

---

## D. The standing exchange and grips

**Change from v2:** hand fighting becomes a technique line (a set of moves on the tree), not a body-attribute roll.
The standing exchange gains explicit grip phases.

**Rule:** three new technique lines on the tree [G]: wrist_control (white), underhook (white), 2_on_1 (blue). Each is
an early-tree move whose mastery adds to takedown odds as a chain bonus (CHAIN x grip_mastery / 30). The standing
exchange: shot vs sprawl (defender's explosiveness + strength) vs guard pull (BASE, 0.94, lands in closed guard) [R:
Williams 2019]. A failed shot the defender sprawls goes to the scramble node. Grip dominance: higher grip mastery wins
the hand-fighting exchange [G].

**Player sees:** the tree shows the three grip moves as drillable; the result card says "won the grip exchange" when
grip mastery decided the standing phase.

**Bar:** at equal belt and style, the side with +10 grip mastery wins the first standing exchange 58-65% of the time;
guard pulls land 94% (the BASE rate); takedowns land 25-40% depending on style matchup (R: ADCC 2022).

---

## E. Guard vs pass and scrambles

**Change from v2:** the pass becomes a multi-beat contest (2-4 beats of grip fighting, not one roll); frames become a
technique line; scrambles reward explosiveness and composure explicitly.

**Rule:** frames [G]: frame_recover_guard (white, exists), underhook_frame (blue), crossface_frame (purple). Each
raises guard retention odds (defender's flexibility + frame_mastery / 30 in the pass's READS row). The pass as
multi-beat: when a passer attempts a pass, the defender gets one free frame attempt (odds = frame_mastery / 30 x
flexibility / 50); success resets to guard, failure lets the pass through. Scrambles [G]: the scramble node reads
explosiveness + composure; higher explosiveness wins 60% of the time (+5 composure = +8% scramble win). Winner goes to
back_take, takedown, or standing.

**Player sees:** the tree shows frame moves; the result card says "framed the pass" or "scramble won".

**Bar:** at equal belt, a guard player with frame_mastery 60 retains guard 65-75% against a Passer with pass_mastery
40 (R: guard retention is the hallmark of the guard game); scrambles go to the more explosive side 58-65% of the time.

---

## F. Submissions and defence

**Change from v2:** near-submissions become advantages explicitly (v2 has the finish gate but the escaped sub is
already an advantage in the code); leg-lock defence is split into knowledge (the answer's mastery) and body
(flexibility + composure); add the tap-or-injury choice for heel hooks at brown/black.

**Rule:** finish gate [G, v2 kept]: escape_chance = logit+(ESC by tier, ESC_W x (mat_def - mat_att)); an escaped sub is
an advantage. Leg-lock defence [G, coach]: answer's mastery x0.7, flexibility x0.2, composure x0.1 (knowledge
dominates). Heel hooks at brown/black: landed heel hook has 15% injury chance (DQ) when defender's leg_lock_escape < 20
[G]; "tapped to a heel hook" vs "injured - knee gave way". Near-submission: any landed but escaped submission counts as
an advantage (v2 already does this); result card says "nearly finished with a triangle".

**Player sees:** the result card names the submission and whether it was finished or escaped; the scouting card says
"leg-lock specialist" when the opponent's leg_lock moves are owned.

**Bar:** at brown/black, heel hooks finish 60-70% of the time when landed (R: BJJ Heroes 17-23% of all finishes, but
landed heel hooks in the saddle are high-finish); leg-lock defence correlates with leg_lock_escape mastery (r > 0.6 in
the probe); injury rate on heel hooks < 20%.

---

## G. Fatigue and pace

**Change from v2:** beat length stays 33s (the coach: "with position-aware stalling the 33-s beat is fine"); gas costs
rise slightly for explosive moves to make cardio matter more in the last third.

**Rule:** gas system [G, v2 kept]: each non-BASE attempt costs GAS_COST x drain(cardio); drain = 1.5 - cardio/100.
New: explosive moves (takedown, sweep, back_take) cost +0.02 [G] to make a Wrestler's gas drop faster. Tired odds:
when gas < 0.3, odds x lerp(0.7, 1.0, gas). A 10-minute black bout at cardio 50 ends near 0.4-0.5 gas; at cardio 30
near 0.1-0.2.

**Player sees:** the corner card shows "tiring" when gas < 0.4, "gassed" when < 0.2.

**Bar:** a cardio-70 grappler beats a cardio-40 grappler of equal technique 60-68% of the time in a 10-minute match
(R: cardio separates levels less than grip strength, but matters in long matches); a cardio-40 grappler's odds drop
20-30% in the last third vs the first third.

---

## H. The referee

**Change from v2:** none in mechanism (v2 fixed the coin, added position-aware stalling, offence tally). The change is
readability: the result card shows the referee's reasoning step by step.

**Rule:** IBJJF order [R]: points, advantages, fewer penalties, referee decision [v2 kept]. Stalling: a hold off a pin
every 2nd beat (~66s) = one penalty; 2nd penalty = advantage, 3rd = two points [R: IBJJF Rules Book]. Pins exempt:
mount, back, side control, knee on belly, north-south. Offence tally: submission 3, pass/sweep/takedown/back_take 2,
entry 1, top time 0.5 [v2]; miss counts half. Decision: higher share wins; inside 5% a weighted call [v2].

**Player sees:** the result card shows "penalised for stalling" with beat time; "referee decision: more offensive (62%
of attacks)" with the share.

**Bar:** referee decisions account for 2-10% of even-belt matches (R: 7% at black, 19% all-level); stalling penalties
land on the holding side 85%+ of the time; no pin-hold is penalised.

---

## I. The coach's part

**Change from v2:** the mat call (Hunt / Steady / Hold) stays; add a scouting card, a duel line, a counter drill, and
3 live corner calls for the live match.

**Rule:** mat call [G, v2 kept]: Hunt (+25 aggression), Steady (0), Hold (-20 aggression). Scouting card [G]: before
the match, the player sees the opponent's style, two tells (top-2 attributes above 65), the matchup edge, and the
go-to route. Duel line [G]: one line per match naming the key matchup ("their explosiveness against your sprawl").
Counter drill [G]: after a loss, the player can pick "drill the counter" - answers to the opponent's go-to lane get a
one-week +5 bonus. Live corner calls [G]: 3 calls per live match (one every 2 minutes), each is Hunt / Steady / Hold
for the next 2 minutes; the player sees current gas, score, and position. Result card [G]: win/loss, method, score,
advantages, duel line, top-3 rule notes, the body edge that decided it.

**Player sees:** the scouting card before the match; the duel line on the result card; the counter-drill prompt after a
loss; the 3 live calls during a live match.

**Bar:** the counter drill raises the drilled answers' mastery by 5+ points for one week; a player who uses the counter
drill improves their win rate against that style by 8-12% over 4 weeks; the live calls change the outcome in 10-15% of
close matches (score gap <= 2 points at the time of the call).
