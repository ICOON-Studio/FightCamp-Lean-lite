# K-BELTROAD1 - game design review of the BJJ belt road (update 64) - Kalli

You are Kalli, FightCamp's game designer. FightCamp is a boxing gym management game for PC; the player is the gym owner and
head coach. Since 2026-11-02 the gym also has a no-gi BJJ side (no gi, ever). Review the design below as a player and a
designer, and answer in plain words: what makes it fun, what is flat, and the ONE change you would make first.
Discipline: bjj (no-gi).

## What was built (update 64)
- One no-gi athlete, Ana Ribeiro (featherweight, 22, white belt, 2 stripes, 4 wins 2 losses in opens). She has her own page,
  a single tab, Record:
  1. THE ROAD TO BLACK BELT: five belt bars, white to black, hers outlined, her stripes drawn white on the black tip. Under each:
     the IBJJF minimum (blue: age 16; purple: 2 years at blue; brown: 1.5 years at purple, 18+; black: 1 year at brown, 19+).
  2. TO BLUE BELT - THE FOUNDATIONS: mat time (130 of 200 classes) and moves owned (9 of 14), then the 14 syllabus moves in
     three groups (Escapes and survival; Passes and sweeps; Takedowns and submissions), each with a bar, a tick at 30
     (owned), and "owned" or "22/30". The move being drilled this week is marked "(drilling)".
  3. COACH'S CALL: "Ready for a 3rd stripe: Ana's escapes are solid." / "Blue belt in about 6 months at this week's plan
     (3 classes a week)." Buttons: Give stripe 3 (off until one is due), Promote to blue (not ready). The rule: one stripe
     is due each quarter of the way to ready; promotion is refused under the IBJJF minimums, allowed earlier than ready
     but she then owes a quarter of the new belt's classes.
     NEXT OPENS: an open every 5 weeks on a Saturday, $95-$110 entry, 8 in the bracket, single elimination; Enter pays.
     THE RULES (adult no-gi): match minutes per belt, points (mount/back 4, pass 3, takedown/sweep/knee on belly 2).
  4. RECORD: her open matches (Won - Kim Patel, submission (armbar from guard) 3:12), then belts and stripes so far.
- The week: 3 classes; the class drills the syllabus move she is closest to owning (+3.2 a week) until it is owned.
- An open: her chance per match = 0.35 + 0.30 x (how far she is to the next belt, 0..1), so about 54 % now; about one win
  per open on average; a third of matches end by submission.
- The player's choices today: give a stripe, promote (early or ready), enter an open. Nothing else.

## Questions
1. Is giving a stripe a real decision, or a button the player always presses? What would make it a choice?
2. Which ONE player choice should the week on the mat have (what she drills, how many classes, privates with the head
   coach, competing vs training), and what does it cost?
3. Opens: what should the player read before pressing Enter (bracket, opponents, weight cut), and what should a result
   change (confidence, a stripe, members joining the BJJ side)?
4. What does a BJJ athlete give the gym (members, money, reputation) so the player cares, in numbers a small UK club would see?
5. Your ONE first change, written as a short spec a developer can build in a day.

Answer as long and complete as you can: numbered, with numbers where you give any.
