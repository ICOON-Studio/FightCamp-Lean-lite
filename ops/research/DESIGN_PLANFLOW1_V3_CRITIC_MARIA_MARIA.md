# DESIGN_PLANFLOW1_V3_CRITIC_MARIA_MARIA - Maria answer (seat queue SQ152)

Brief: research/DESIGN_PLANFLOW1_V3_CRITIC_MARIA.md
Sent: 2026-11-15 01:10 | collected: 2026-11-15 01:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I give PLANFLOW1 v3 **DEPTH 7, GENERAL DESIGN 6, PLAY 6**, so it clears the owner's bar again. v3 cleans up v2's faults:
- Film has one price.
- Steps to Sharp are priced at the punch rate (about 8 weeks, not 4).
- Test it plays only against what film found.
- The corner swap is the built "change one plan arrow".
- The round filter is cut.

It's held at 6 on general design for three reasons:
- **It leans on new pieces that change results:** modes as a tell type, the GUESS pay rule, the lock at the first bell, Test it on a sparring night, and the amateur reuse rule. All of them are unmeasured.
- **Nine CHECKs decide which rows survive.**
- **The pad maths in 6.3 doesn't match its own section 5 pricing.**

## Scores

**1. DEPTH: 7/10**

What works:
- **Film against pads is now a real trade on one budget.** A tape evening is an evening off pads, in a camp too (owner question 4). Three tape days are worth about 4 mastery on one line, and the probe asks film to win against an unknown style and pads against a known one. That's the right shape.
- **GUESS pays as OK even when it's right,** so film always has a reason. The fallback to OK − 1 if GOOD barely beats a preset is a good guard.
- **Steps priced at the punch rate** stop a step plan from being a cheap answer, and STEPS-ONLY checks it.
- **SEEN gives the pro game a career-long decision:** what your boxer throws most becomes what the next opponent waits for. Real corners plan against exactly this. Camps study the last fights on tape and build around the favourite punch.
- **Start from last bout** keeps only lines still at 30+, so carrying a plan forward is a time saver, not a buff.

What holds it back:
- **The mechanic's choices are mostly made before the fight.** The only live levers are one arrow change and "Lean on it", and Lean on it may slip to stage 2.
- **MAIN BET changes no number.** It's a reading aid, not a choice with a cost.
- **Presets with "Your coach rewrites it" may be the dominant first click.** If probe 10 lands within 3 of GOOD, most players will press it and edit nothing. The map lists that as a pass line, but a pass means the player's own plan barely beats the coach's.
- **Amateur reuse punishes a plan used twice against the same club, not the same opponent.** Amateur clubs don't share tape like that. It's a game value with a weak real basis, and it's a soft nudge at best.

**2. GENERAL DESIGN: 6/10**

What works:
- Every critic point has a row, and every refused point says why: no tutorial overlay because nothing opens by itself, no round filter because films don't record when a habit shows.
- One plan store, two views.
- The word list is clean (box, diamond, answer, mode, tell).
- Gold is kept for the worth band, with MAIN BET on slate.
- No scores in the corner, with the England Boxing and IBA rules quoted.
- No names in the body.
- The menu table wires every line.

What fails:
- **The pad maths in 6.3 contradicts section 5.** Section 5 says a full pad night is about 2.6 mastery. Section 6.3 says 3 evenings spent on pads instead of film buy "about 4 mastery (3 × 1.3, at half a night each)". But a camp evening spent on pads is a whole pad night, so it's about 7.8. The film price is understated by half, and that's the number the film-against-pads choice rests on.
- **Several new pieces change results:**
  - modes as a tell (a new tape order);
  - GUESS;
  - the lock at the first bell;
  - Test it using a coach's sparring night;
  - amateur reuse.

  Each is stated honestly, but together they move 59/45/41. Probe 0 re-measures, and none has run.
- **"Lock at the first bell" is new and unexplained as a choice.** Today the plan can change in the corner minute through the arrow (CODE). Locking from the weigh-in removes nothing, since there's no new information. Then it's a rule that changes no result, so it's not worth a build task (P7) or an M13 line.
- **Nine CHECKs each cut a row on a no.** Habit as a trigger, two modes at once, FireLevel on steps, pace by round, an aimed shout, the opponent's Energy band and film with no camp could each remove a feature from stage 1. The stage 1 list isn't settled until Claude answers.
- **"Often" needs 3+ films,** but an amateur opponent has 3–4 films at most, and Film opens one tell an evening. Reaching "often" on two modes takes most of a camp's evenings. That may be the point, but it's GAME VALUE and should be marked.
- **The breathing band (M11)** gives the player a read but no action beyond the arrow change. It's borderline under the owner's rule of actionable information only.

**3. PLAY: 6/10**

There's a weekly rhythm: film or pads, a plan test night, the Validate strip naming one fix at a time. Fight night has the round line ("Main bet met 3, paid 2"), the arrow change and the mode count. The Why grades the main bet first, which gives a clear payoff for a read that came right. But most of the reward lands after the fight. During it, the player watches boxes fire and gets one arrow change a round.

## Options: missing, useless, and what each changes

**Missing**
- **A cost on MAIN BET.** For example, the main bet's box pays full for a third use in a round (past PlanRead's 2), and the other boxes for only one. Then it's a choice, not a label.
- **A choice of where Test it's night comes from** (a pad night or a sparring night), with the cost of each printed. Today the map picks for the player.
- **A way to see the share bands' film count before choosing film or pads:** "Pressing: 2 films seen, 1 more for often".
- **A live switch between two saved plans at the corner minute,** if one arrow isn't enough. Real corners do switch plans between rounds ("box him now, stop trading").

**Useless or near-useless**
- **Lock at the first bell:** changes no result.
- **MAIN BET as it stands:** no number moves.
- **The breathing band:** a read with no action of its own.
- **Amateur reuse by club:** weakly real, small, and likely cut by AMREUSE.

**What each option changes**
- **Use a preset:** 4–6 lines for a style in one click, including the tires line.
- **Your coach rewrites it:** a plan from found tells and drilled pieces, within the line cap.
- **Start from last bout:** keeps the 2–3 lines that fired most and are still at 30+.
- **Copy a team-mate's plan:** only the pieces your boxer has at 30+, with the rest left empty.
- **Test it:** spends a sparring night (180 units) for a worth band against the known file. It finds no tells.
- **Save or Load:** keep and reuse named plans.
- **A box on a found mode:** pays at its rating (best 9, ok 3, wrong −7) times FireLevel.
- **A GUESS box:** pays as OK whatever the answer.
- **MAIN BET:** what the corner read and the Why show first.
- **A Film evening:** one tell, and one pad evening lost.
- **A step on pads:** about 2.6 a full night, about 8 weeks from 30 to 60 on half a night.
- **The study queue:** the next step moves into the slot automatically.
- **Arrow change in the corner:** a new answer that starts fresh under PlanRead.
- **ONE CHANGE:** a habit fix, Elbows in or Gloves high.
- **Lean on it:** one more full use of a box this round, for one of two shouts.
- **"Push round 1: Use it":** sets round 1's pace.
- **The SEEN swap:** a different most-thrown punch, or a feint line that blunts the read.

## To reach 10/10

1. **Fix the 6.3 maths.** A camp evening on pads is a full pad night (about 2.6 mastery), so 3 evenings are about 7.8 on one line. Re-run probe 3 against that number.
2. **Give MAIN BET a cost and a payoff,** such as a third full use a round for the main bet's box and a cap of one full use on any other. Then add a probe that each mode is the best main bet in 20–60 of 100 bouts.
3. **Cut the lock at the first bell (P7) and the M13 line,** or name the result it changes.
4. **Get the CHECK answers before you write stage 1.** First: habit as a trigger, aimed shouts, pace by round, film with no camp. Then publish the stage 1 list as it actually stands.
5. **Run the first batch (probes 0, 1, 2, 4, 10, AMREUSE).** If probe 10 lands within 3 of GOOD, make the coach's plan weaker (only found tells, no GUESS boxes), so the player's own plan earns its time.
6. **Mark "often" at 3+ films GAME VALUE,** and show the film count on each mode: "2 seen, 1 more for often".
7. **Let the player choose where Test it's night comes from,** a pad night or a sparring night, with both costs printed.
8. **Make Lean on it a stage 1 must.** If the shout code can't aim at a box, add the smallest change that lets it, because it's the mechanic's only live decision.
9. **Cut amateur reuse by club,** or change it to the same opponent, with a real example of a rematch read.
10. **Drop the breathing band** unless probe 7 shows the arrow change pays more when the player can see it.

**My 10/10: Fighter page > Playbook > Game plan, 1920×1080, Look B whiteboard**
- **Dark top bar** with CONTINUE.
- **Portrait header** with the name once and "VS" with the opponent's style word.
- **Left (40–620), THE OPPONENT:**
  - The tree as marker diamonds for the six modes, each with its band word (often, some, rare) and its film count ("2 seen, 1 more for often").
  - The weapon and habits as stickies, with locked ones saying "1 more Film evening".
- **Centre (660–1380), YOUR PLAN:**
  - Boxes drawn as diamond-to-answer arrows. Each answer has its tier stamp (USABLE, SHARP, SIGNATURE) and its uses line.
  - GUESS boxes in pencil with "pays as OK".
  - One slate MAIN BET magnet with its effect printed: "third full use a round".
  - The bell box at the bottom.
- **Right (1420–1880):**
  - VALIDATE, at most three lines each with a fix button.
  - THE TRADE: "Film evening, one tell" against "Pad night, +2.6 on the right hand", with the evenings left before fight night.
  - Test it, with "use a pad night" or "use a sparring night".
- **Bottom (980–1060):** Your coach rewrites it, Start from last bout, Save, and Test it in gold.
