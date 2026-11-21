# CARDPROTO1_CRITIC_KALLI_KALLI - Kalli answer (seat queue SQ284)

Brief: research/CARDPROTO1_CRITIC_KALLI.md
Sent: 2026-11-21 23:40 | collected: 2026-11-22 00:10 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I'm scoring the card game prototype now, from the rules, the balance table and the three transcripts.

**Depth 4, Play 4, General 5. It fails the 8/8 bar.**

**Depth 4.** The cards do differ in more than numbers: range, the set-up and the table give each one a job. But every exchange is a blind pick from 12 against an opponent that never reads you back, so it's rock-paper-scissors with a damage spreadsheet. Your own data says knowledge barely matters. Playing the file you're dealt is worth +2.5 points (46.9 against 44.4), and knowing both habits only +3.4. Luck beats skill by a mile. On top of that, defence never pays: Slip wins 32 %, Roll 33 %, Step back 30 % and Block 37 % of the time they're played, while Uppercut and Lead hook win 55 %. The correct play is "throw the uppercut", which is a solved game, not a decision.

**Play 4.** Pace is fine, with 18 reveals and one line each. But there's no combination and no build-up, and the fights don't look different from each other: bout 25 is 15 of 18 exchanges inside, and bouts 3 and 11 are inside for most of them. Surprise comes from the dice, not from the other corner. And the lines undercut the tension: "his block lands", "his step back lands", "his pivot out lands" read as nonsense, and a defence card dealing damage kills the fantasy of slipping a shot and making him pay. I'd play a second bout to check whether the uppercut keeps winning, not because I want to.

**General 5.** It's a clean, testable, data-driven base, and the harness and its honest measure of the read are good engineering. The design on top isn't there yet. It also breaks two house rules, which I've listed in the next message.

## (1) Missing cards and options
- **Feint**: does no damage. It beats Block, Slip and Roll by drawing them early, so your next punch lands as if set up, and it loses to any punch. Feints are what make a read pay.
- **Cross counter**: the real answer to the jab (a straight right over the lazy jab). Today the jab only trades with the cross.
- **Check hook**: a pivot plus a hook against a man walking in. It beats Cut off the ring, Clinch and pressure, the Mayweather–Hatton 2007 knockdown pattern.
- **Pull counter / lean back**: the out-boxer's own counter. It beats the jab and the cross at range and loses to the body hook.
- **Breathe / tie up and rest**: gets wind back and loses to every punch. Without it, wind is only a tax.
- **Combinations**: two or three cards in one exchange, paid in wind (jab-cross, jab-cross-hook, slip-cross). Boxing is combinations, and that's where the depth is.
- **Tells**: one visible chip before each reveal ("loading the right", "head low, walking in", "on the back foot"), true more often the better your boxer's Fight IQ and your scouting.
- **Ropes and corner position**: an inside state where Step back is off the table and Pivot out is the only exit.
- **A round score shown between rounds**: right now the corner card is chosen without knowing whether you're up or down.

## (2) Useless or dominated cards
- **Block**: played in 6.6 % of exchanges and wins 37 % of them. It loses to the uppercut, the clinch and Cut off the ring, and its wins do nothing.
- **Step back**: 30 %, the worst card. Its "w" against the big punches converts to 1.1 damage, so the table says win while the score says nothing.
- **Slip and Roll** (32 to 33 %): their wins don't feed the next shot, so they're stall cards.
- **Pivot out**: the opposite problem. Its table row never loses (w, w, t, w, w, n, n, n, w, n, n, w), so nothing counters it. It's a free reset that does 0.9 damage and wins 46.8 %. It's a hole in the table, not a card.
- **Uppercut**: overloaded. It beats the jab, the cross, the lead hook, Block and Roll, at any range the table allows, with the top damage of 7.9. Both knockdowns in bout 11 come from an uppercut against a jab or a block.
- **Cross**: weaker than the lead hook in every column that matters (44 % against 55 %). The power hand should beat the jab, not trade with it.

## House rules broken (fix before any rescore)
- **Females never fight males.** Bout 25 is Mara Okafor against Kwame Boateng, "his", and bouts 3 and 11 put Ines Duarte against Rio Tanaka, also "his". If Ines is a woman, that's a second break; please confirm.
- **The opponent is "drawn from the rest of the gym".** Opponents are from other clubs, not your own boxers. Bouts 3 and 11 are also the same pairing, despite "never the same man twice".
- **Fixed "he" and names.** The README says "his deck", "his tank" and "the same man twice" (S412), and names boxers in the body text (S448).
- **Draws are not amateur.** Three 3-minute rounds is an amateur bout, which always has a winner. Draws are 6.7 % of bouts here.

## (3) What each change does, and (4) TO REACH 10/10, most important first
All figures are targets for the harness, not measured results.

1. **Make defence pay in its own currency.** Defence cards never deal damage. A winning Slip or Roll gives an *opening*: your next punch this round gets +30 % damage and +15 accuracy. A winning Block refunds 1 wind. A winning Step back moves the range to `out` and costs him 1 wind. A winning Pivot out resets the range to mid, and you see his card first next exchange. A miss he throws into your defence counts for the work-rate judge.
   *What it does:* the lines read true ("You slip the cross: opening for the right hand"), and defence becomes a setup instead of a stall. *Bar:* every defence card wins 45 to 55 % when played, and Block is played in 8 % or more of exchanges.
2. **Add tells, and make the opponent read you back.** Before each reveal he shows one tell chip. Scouting plus Fight IQ sets how often it's true: 55 % blind, 70 % with one habit known, 85 % with both. He tracks your last three cards, and a card you repeat twice makes him twice as likely to pick its counter.
   *What it does:* it turns the blind 12-way guess into reading and mixing up, and makes the coach the skill. *Bar:* perfect reading beats blind play by 15 or more points (today it's 3.4), and an AI that repeats its best card loses to one that mixes.
3. **Fix the holes in the table.** The cell is read as row against column, and each change keeps the table anti-symmetric.
   - Lead hook against Pivot out becomes `w`, because the hook catches the turn.
   - Jab against Uppercut becomes `w` at `out` and mid, because the man dipping eats the jab.
   - Slip against Uppercut becomes `X`, since you slip into it, the way you already roll into it.
   - Cross against Jab becomes `w` at mid, for the cross counter.
   - Uppercut at `out` drops to 50 % accuracy.
   *What it does:* the uppercut stops being the answer, and every card gets a counter. *Bar:* every card beats 2 or more cards and loses to 2 or more, and no card wins more than 55 % when played.
4. **Add combinations.** Play up to 3 cards in an exchange, paying the sum of their costs plus 1 wind per extra card. They resolve one by one against his card. A defence card in the first slot followed by a punch makes a counter combination.
   *What it does:* sequencing, wind planning and real boxing shapes. It's the biggest single gain in Play.
5. **Add the missing cards:** Feint, Cross counter, Check hook, Pull counter and Breathe, as listed above. Each one goes into the table with its counter written first.
6. **Make range move and cost something.** Each exchange spent inside costs the boxer who doesn't want it 1 wind, set by style. Add a "ropes" state after two Cut off the ring wins in a row. Show range as a strip of three.
   *What it does:* out-boxer against pressure becomes a fight about where the fight is. *Bar:* in out-boxer against pressure bouts, no single range holds more than 60 % of exchanges.
7. **Make habits a real read.** Drill each habit card into his deck three times, and have it fire 70 % of the time when its situation is true. The player can *create* the situation: hurt him and he clinches, so the lead hook that beats a clinch is the payoff. *Bar:* each known habit is worth 5 or more points.
8. **Fix knockdowns.** Bout 11 has a knockdown on R1.1, on a fresh boxer, which breaks the README's own rule. Aim for about 0.6 knockdowns a bout (today 1.68) and stoppages at 8 to 10 %.
9. **Judge it as an amateur bout.** Five judges, no draws, and the round scores shown after every round. Bout 3 went 30-27 on all three cards when R1 reads as roughly even, so each judge's line needs a one-line why.
10. **Give camp a cost.** Each week costs fatigue, one of the four weeks is rest or a taper, and the drill choices follow from the scouting file.
11. **Fix the words and the rules.** Same-sex bouts only, opponents from other clubs, and no fixed "he": use "your boxer", her / him and "the opponent", with names only in headers. Defence lines become "takes you out of range", "slips it" or "blocks it", never "lands".

## The single most wrong thing
The exchange is a blind guess against an opponent who never reads you, and defence wins give you nothing. So the coach's skill is worth about 3 points, and the uppercut is the answer. Fix 1 and 2 together and the rest is tuning.

The card game scores Depth 4, Play 4 and General 5, so it fails the 8/8 bar.

The biggest problem is that every exchange is a blind guess against an opponent who never reads you back. Defence wins also give you nothing, so throwing the uppercut is nearly always the right call. Your own numbers back this up: reading the scouting file is worth only about 3 points.

The two fixes that matter most:
- Defence wins open up your next punch instead of doing damage.
- The opponent shows a tell before each pick and punishes you for repeating a card.

It also breaks two house rules you'll want fixed before a rescore. A woman fights a man in bout 25, and opponents come from your own gym instead of other clubs.
