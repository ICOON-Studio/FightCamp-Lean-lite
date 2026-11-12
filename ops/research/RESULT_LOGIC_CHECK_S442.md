# Result page round 2 (docs/mockups/s441/result/fight_only.png): logic check, S442

Verdict: the result logic is right (cards, split decision, record, rank threshold, pro-offer count, punch-table sums),
but the SAMPLE FIGHT was written by hand and cannot happen in the game. Round 3 must draw a bout the sim really played.

## Cannot happen / wrong (file:line is the proof)
1. Priya keeps one game longer than 3 exchanges in a round: `Exchanges.gd:61` MAX_RUN 3, `next_mode` 243-253, `RingDuel.gd:352-358`.
2. Line B "Waits to counter -> Feint and draw" can never fire: `feint` starts from the outside card (`StrikeMap.gd:21`), a line
   fires only on its own card (`PlanBoard.gd:79`), the counter game puts the fight at long (`PlanFight.gd:22`).
3. Line C "Presses -> Step in" cannot fire where drawn: `step_in` is from outside (`StrikeMap.gd:19`); pressing puts the fight at
   mid, then the ropes (`PlanFight.gd:25`, `LiveRound.gd:256`). No move from mid "walks into" pressing.
4. The "Rewrite C" hover names moves from three places; a line takes a move only from its own place (`PlanLines.gd:62`).
5. The habit "retreats in straight lines" is punished in EVERY exchange against pressing (`HabitFix.gd:24, 42-51`,
   `LiveRound.gd:222, 232`), not twice; FightWhy counts the punished lost exchanges (`FightWhy.gd:60, 140`).
6. Pinned on the ropes needs pins >= 2 from inside exchanges where our fighter wanted out (`Duels.gd:69, 370-371`).
7. The fight moves back one place at most per exchange (`Duels.gd:350-366`).
8. An orthodox puncher's jab, cross and lead hook reach only the RIGHT eye, a southpaw's the left (`BodyMap.gd:52, 57-71`):
   never both eyes; show the stances.
9. Condition numbers must follow the punches: face 1.18, head 0.59, ribs 2.9 a landed punch (`BodyMap.gd:18-22`); only a body
   hook reaches the ribs (`BodyMap.gd:75-83`).
10. "To the body" (exchange records, `FightStats.gd:24-27`) and "Body hook" (3D beats) are two sources on one table.
11. Landed punches per exchange are fixed pairs, winner first: close 4-3, clear 5-2, dominant 6-1 (`Exchanges.gd:307, 318-323`).
12. STAND-INS the code does not produce: a Counters row; blocked / slipped / missed and per-punch thrown counts for rounds NOT
    watched in 3D (`FightCast.gd:87`); "landed whole" combination counts; "cut over the LEFT EYE" (the roll returns "Cut - out 3
    weeks", `InjuryRoll.gd:96, 204`); the opponent's chance before the bell (only ours is shown: "Win chance about X% (lo to
    hi%)", `FightPrep.gd:135`, and nothing is stored at the first bell); "hurt opponent" as punches (it is a state after an
    exchange, `RingDuel.gd:347-350`).
13. Buttons: "Train cardio next week" (`FightNight.gd:255`, `BoutActs.gd` "bodyfocus") and "Drill it" (`PadEdit.drill_it`) are
    real, but an injured fighter trains at a quarter (`Injuries.gd:6`): say so. "Rewrite C": the Playbook exists
    (`ui/areas/Playbook.gd`). "Replay the plan": no such screen in scripts/ui: build it or drop the button.
14. "Legs went" is the legs' WEAR passing 50 (`BodyReport.gd:6, 16-37`), not an energy number.
15. The middle place is "In the pocket" in the game (`Duels.gd:13`, `RingDuel.gd:264`), not "Mid".
16. The place each fighter wanted is stored on every exchange record (`LiveRound.gd:354-355`): use it, do not assume.
17. Nationals entry also needs 91 days at the club, age 19-40, fit, entry by day 70 (`SeasonPath.gd:9-14, 24`).
18. A corner call stands for the whole round; grading it at the bell only is half true (`LiveRound.gd:211`, `Exchanges.gd:104`).
19. Plan lines read "When the opponent presses" in the Playbook (`FightFlow.gd:33`) and show the line's place.

## Checked and true
Grade words (`PlanLines.gd:23`, `Exchanges.gd:22`); condition bands fine > 55, hurt to 35, critical to 15, doctor under
(`BodyMap.gd:128-135`); judges' cards and the flipped level round (`BoutRules.gd:371-419`); rank from 4 wins; nationals 5
bouts; pro offer 7 wins; a cut is 14-21 days; plan worth and MIXED (`FightWhy.gd:65, 112-116`); 35 is the tired line
(`Exchanges.SHE_TIRED`); move levels Sharp 60 / Usable 30 (`MoveMastery.gd:28-29`); no pronouns in the page text.
