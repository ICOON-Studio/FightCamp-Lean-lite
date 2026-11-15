# DESIGN_PLANFLOW1_V3_CRITIC_JOHN_JOHN - John answer (seat queue SQ151)

Brief: research/DESIGN_PLANFLOW1_V3_CRITIC_JOHN.md
Sent: 2026-11-15 02:10 | collected: 2026-11-15 02:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

On it. I'm reading PLANFLOW1 v3 against the critic pack now. Beast is still offline, so `CRITIC_ACCESS.md`, the board and the mockups aren't open; I'll check the numbers first, then score.

**Logic check.** Some arithmetic holds: the step price (2.1 an hour × 1.25 hours = 2.6 a night; 30 points at 1.3 a night × 3 nights a week is about 8 weeks), the fallback OK − 1 edge (2), and probe 0's line of 56 or more against today's 59. Nine things don't hold or aren't stated:

1. **The corner arrow change has no reset gain.** Section 7.3 says the new answer "starts fresh under PlanRead. That's the gain." But PlanRead resets every line at the bell (CODE), so the old line also starts fresh in the next round. The only gain from the swap is a better match to the opponent's mode. M11's sales line is false.
2. **The uses lines add up to more than a round holds.** A round is 6 exchanges. Five boxes at "about 1 use a round" plus the bell box at "about 3" comes to about 8 uses in 6 exchanges. Either a use isn't an exchange (then say what it is, and whether a misfire under FireLevel counts), or the estimates must sum to 6 or less.
3. **The camp in 6.3 is miscounted.** Standard is 4 evenings a week, but 2 of those are sparring (pack 4.2: 2+2), and TAPER week has no sparring and three rest days. A 4-week Standard camp has about 7–8 pad nights, not 13 left over from 16. The cost comparison is also unequal: a film day costs a whole evening (240 units), but the map prices the alternative as half-nights (3 × 1.3 = about 4). A whole evening is about 7.9 mastery, so film is about twice as expensive as shown.
4. **GUESS when it's wrong isn't stated.** "Pays as OK, even when right" leaves the wrong case open. If a wrong GUESS also pays OK, then filling every unfound mode is free and becomes the dominant pick. If it still pays −7, say so on the hover.
5. **Test it's cost isn't clear.** The map says a test night "spends the sparring night's units on the plan, not on general sparring". But sparring units already go to the moves on the boxer's cards and plan (S448). If the test night still hands out those 180 units, it costs nothing and you'd always test. Say whether it gives mastery.
6. **"Film" means two things.** It names your Film evening and also the opponent's past bouts ("often needs 3+ films", the Tape Room's 3–4 films). That breaks one word per concept. "Shown in at least 3 of 4" also can't be read with exactly 3 films.
7. **Probe 10's pass line works against the plan being the star.** The code makes the assistant's plan "poor to about half of a read plan" (about 52, between 45 and 59). A pass line "within 3 below GOOD" lets your coach match the player, so the editor stops being worth opening.
8. **Things the map doesn't say:**
   - Which camp evening a film day replaces: a pad night or a sparring night.
   - Whether the tires IF uses one of the 4–6 line slots. It does count as a choice if it costs a slot.
   - What a pro's $250 Scout opens in the new tape order (modes or not).
   - Whether a preset is named for your boxer's style or the opponent's.
   - Whether morale trust (1.05 / 1.0 / 0.85 / 0.7) scales Lean on it and the arrow change. It should, because they're corner words.
9. **Small things:**
   - "Bell box" isn't in the section 12 word list.
   - The film rate "one tell per evening (CODE)" disagrees with the pack's "every few camp days" (CHECK).
   - AMREUSE's "first box" has no order, because diamond order is cut.
   - AMREUSE also punishes Start from last bout, which the map adds as a time saver.

No names outside headers, and no fixed he or she. "She presses" in the code text is already flagged.

I score PLANFLOW1 v3 at depth 7, general design 6 and play 7, so it meets the owner's 6+ on depth and design. The 10/10 list and page are at the end. I couldn't open `CRITIC_ACCESS.md`, the board or the mockups because Beast is offline; this is judged from the critic pack and the map.

## Scores

**Depth 7.** The choices are real:
- **Film or pads:** each tape evening means a weaker answer on fight night.
- **Film or guessing:** you can answer an unfound mode now at OK pay, or spend an evening to find it.
- **Steps past Usable:** about 8 weeks of half a pad night, against a punch answer for the same time.
- **Pro fights:** steering away from SEEN by what you throw over a career.
- **The corner:** one arrow change in the minute, plus a shout spent on Lean on it.

It ties into a lot of the game: FireLevel, PlanRead, ProRead, StepMastery, camp evenings, sparring nights, shouts and the Why.

What holds it at 7:
- MAIN BET changes no number, so it's a label, not a choice.
- Lean on it only matters once a box has already had its 2 full uses in a round. At about 1 use a round, that's rare.
- The arrow change has no gain from the reset (logic point 1).
- AMREUSE is a tiny penalty with no real-world basis.

**General design 6.**
- **What's right:** v3 answers the v2 critics carefully. One plan feeds both views. New things are tagged NEW. Every CHECK says what gets cut on a no. Stages run simplest first. Every menu is wired (section 11).
- **What holds it at 6:**
  - the claimed reset gain is false;
  - the uses estimates add up to more than a round holds;
  - the camp in 6.3 is miscounted and film is priced at half its real cost;
  - GUESS doesn't say what a wrong guess pays;
  - Test it may cost nothing;
  - "film" means two things;
  - probe 10's pass line works against the plan being the star;
  - nine CHECKs and four owner questions are open, and no probe has run.

**Play 7.** There's something to do every stage of the week:
- film evenings that fill in the opponent's tree;
- a test night that shows up on the Week;
- pad cards counting down to Sharp;
- the round line, with an arrow change in the minute;
- a Why that grades your main bet.

The anticipation is real. It's held back because the moments of choice inside the bout are thin: one arrow change, and a shout that rarely matters.

## What each option changes, and verdict
| Option | What it changes | Verdict |
|---|---|---|
| Add a box (diamond + answer) | Which mode gets a planned edge (9 / 3 / −7) | Keep |
| GUESS box | An unfound mode pays as OK | Keep, once a wrong guess's pay is stated |
| Film evening | One tell, at the cost of a full evening (about 7.9 mastery) | Keep; reprice 6.3 |
| Put an answer on pads | Its FireLevel tier | Keep |
| Step past Usable on pads | Steps reach Sharp in about 8 weeks | Keep (NEW) |
| Study queue | Saves one click when the slot frees | Keep, minor |
| Use a preset | A whole plan in one click | Keep; say whose style it's named for |
| Your coach rewrites it | A plan from found tells and drilled pieces | Keep, at about half a read plan, not within 3 of GOOD |
| Start from last bout | Keeps the 2–3 lines that fired most | Keep; it clashes with AMREUSE |
| Copy a team-mate's plan | Keeps pieces at 30+ | Keep (stage 2) |
| Test it | A worth band against the known file | Keep, once its unit cost is stated |
| Save / Load | Named plans | Keep |
| MAIN BET | What you see first; no number | **Useless as it stands** |
| Arrow change in the minute | Swaps one answer for a better match | Keep; drop the reset claim |
| Lean on it | A 3rd full use of a box in the round | **Rarely live**; offer it only after the 2nd full use |
| Breathing band | Tells you whether to plan the Tiring box | Keep (stage 2) |
| Offer line (M9) | Gives a band, but no action | **Useless without "Load that plan"** |
| AMREUSE | Halves the first full use of one box | **Cut** |
| Round pace from a found habit | Fills in the existing pace choice | Keep, if pace by round exists |

**Missing options**
- **A replace control for film days in a camp:** which evening does the film take, a pad night or a sparring night?
- **What the pro Scout ($250) opens in the new tape order.** Without it, the pro film lever is undefined.
- **A real MAIN BET trade:** the main bet box gets 3 full uses a round instead of 2. For pros, its answer counts double toward the punch ProRead waits for next fight. That gives an edge now and a risk later.
- **Trust on corner words:** Lean on it and the arrow change should go through the morale multiplier, and a Low boxer should ignore Lean on it, as with any shout.
- **"Load that plan" on the offer line,** so the line becomes something you can act on.

## To reach 10/10
1. **Drop the reset gain from the arrow change.** Sell it only as a better match for the mode count shown in the minute, and have probe 7 measure just that.
2. **Define a use as one exchange where the box's diamond holds,** with misfires counted. Make the uses estimates sum to 6 or fewer a round. Print the uses line as a share of the round ("about 1 of 6").
3. **Redo 6.3** with real camp evenings (Standard: 2 pad + 2 sparring a week, TAPER with no sparring, so about 7–8 pad nights in 4 weeks). Price a film day as the whole evening it replaces, and say which one: a pad night first, never a sparring night in PEAK.
4. **State GUESS in full:** right pays OK (3), wrong pays wrong (−7). Put both on the hover. Then probe 1 tests a real risk.
5. **State Test it's cost:** the test night gives no mastery (its 180 units go to the test only). Show that on the Week line: "Thu: sparring (plan test), no drill gains".
6. **Give MAIN BET a number:** 3 full uses under PlanRead for that box. For pros, its answer counts double toward ProRead's most-thrown punch.
7. **Offer Lean on it only after the box's 2nd full use in the round,** scale it by morale trust, and have a Low boxer ignore it.
8. **Set probe 10's pass line at 5–8 below GOOD,** matching the code's assistant plan, which is about half a read plan.
9. **Split the words:** "tape" for the opponent's past bouts and "film evening" for yours. "Often" then needs 3+ tapes and the mode in at least 75% of them. Add "bell box" to the word list, or call it the go-to combination as the pack does.
10. **Write what the pro Scout opens:** weapon, weakness and the top unfree mode.
11. **Cut AMREUSE.** Amateurs already lose to habits, and it fights Start from last bout.
12. **Add "Load that plan" to the offer line,** or cut M9.
13. **Answer the nine CHECKs and four owner questions,** run the first batch of probes, and get an M1 drawing OK'd before P1.

**CHECK (John), "often" at 3+ tapes:** I didn't check how much real amateur footage corners have this pass. Keep it as GAME VALUE until it's researched. The pack's own rule that an opponent with no bouts has no tape already covers novices.

## The 10/10 page (1920×1080, Fighter page > Playbook > Game plan, Look B in the dark shell)

**Shell (0–64 px):** gym, date, cash, Menu. The big button reads "CONTINUE: to Thu, sparring (plan test)".

**Header (64–150):** the boxer's portrait and name, then "vs" the opponent's name and club, both once. The fight date is circled in red: "Sat · 19 days". On the right: "Line cap 5 · 4 used".

**Left (24–560): the opponent's tree on cream paper.**
- The style word, with the free mode already inked: "Pressing: free".
- The tells run in tape order: weapon, top mode, habits, second mode, weakness. Each has a share band ("often · 3 of 4 tapes").
- Locked rows say what opens them: "1 film evening".
- A hover on any mode prints "fired 7 in your last 3 bouts against Pressure fighters".

**Centre (580–1340): your boxer's chart.** Five boxes, each a diamond leading by an arrow to an answer.
- Each answer has a FireLevel stamp (USABLE / SHARP), a uses line ("about 2 of 6 a round"), and a slate MAIN BET magnet on one box with "3 full uses".
- The GUESS box has a dashed outline and the hover "Not found on tape: pays OK if right, −7 if wrong".
- The go-to combination box sits at the bottom.
- The Validate strip below has at most 3 lines, each with a fix button: "Pressing: often, no box: Add it", "Right hand to the body ×0.8: Put it on pads", and the SEEN line for pros.

**Right (1360–1896): cost and test.**
- Pad cards with countdowns: "Pivot out 34 → Sharp in about 8 weeks on half a night", and "Next: step back".
- The week's evenings as magnets, with one film evening marked "−1 pad night".
- A Test it result card: "Worth +4 to +9 · 2 modes guessed · no drill gains Thu".
- Your coach's plan, shown dimmed for comparison: "about half your plan's edge".

**Bottom (900–1040):** the buttons Preset, Your coach rewrites it, Start from last bout, Save / Load, and How the chart reads. The one pulsing button is "Test it on Thu".

**Hard case on the same page:** a pro bout where the main bet's answer is also the most-thrown punch. The red SEEN line reads "your main bet is the punch they'll wait for: swap or add a feint line".

## Sources
No new outside sources this pass. Every figure is DERIVED from the critic pack (4.2, 4.3, 4.7, 4.8, S448, S451, S463) and the map's own numbers. The scorecard rule (England Boxing 12.10.1, IBA 18.8) comes from my v2 pass and wasn't reread today.
