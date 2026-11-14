# DESIGN_PLANFLOW1_V2_CRITIC_MARIA_MARIA - Maria answer (seat queue SQ134)

Brief: research/DESIGN_PLANFLOW1_V2_CRITIC_MARIA.md
Sent: 2026-11-14 20:45 | collected: 2026-11-14 21:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I give PLANFLOW1 v2 **DEPTH 7, GENERAL DESIGN 6, PLAY 6**. It reaches the owner's bar, but GENERAL DESIGN only just makes it.

v2 fixes v1's big faults:
- The ten invented IFs are now the fight's six real modes.
- Step answers are paid for through the single study slot and pad time.
- PlanRead and ProRead are tagged as built.
- Plan B is one arrow back to the bell box, not a second system.
- Every state is printed as a word.

It stays at 6 because eight Claude CHECKs still decide whole rows, the main screens have no agreed mockup, and no probe has run.

## Scores

**1. DEPTH: 7/10**

What works:
- **Film is now the only route to BEST against a mode the style word doesn't give away.** A guessed answer caps at OK, and a film evening costs a pad evening. That one rule makes film, pad time and the plan trade against each other every week.
- **How often a habit showed on film is a real bet.** "Showed in 3 of 4 films, often" against "1 of 4, rare" lets you weigh a BEST answer on a rare mode against an OK answer on a common one. Real corners do exactly this from tape: you plan for what the opponent does most, not what they did once.
- **Five built rules stop any one plan from winning.** PlanRead pays a line in full only twice a round. ProRead waits for a pro's most-thrown punch. Wrong answers shrink your energy ceiling. Pad time is limited. A step waits on the study slot. The best plan has to be built for this opponent, drilled, and spread over two or three answers.
- **The corner swap gives the player something to steer in stage 1.** Diamonds that never fired are listed first, and the swap list comes from what your boxer has actually drilled.
- **The failure example in section 10 teaches without a rigged roll:** "two IFs on pressing, never fired".

What holds it back:
- **Measured gains are small.** In the brief's sample bouts, the best single change took the plan from 9 wins in 40 to 11. Pass line 1 asks GOOD to beat PRESET by 8+, but nothing yet shows the gap is that wide. If it isn't, the editor is a lot of screen for 3 or 4 bouts in 100.
- **Two of the four habit rows rest on CHECKs.** Whether a habit can be an IF, and whether a diamond can be limited to certain rounds, are both unconfirmed. Without them, the habits only add a share label, and the "slow starter" and "fades late" depth disappears.
- **The timing rules for slow starter and fades late may be free picks.** If a "round 1 only" diamond takes no extra line, it's always worth setting. Say it costs one line like any diamond.

**2. GENERAL DESIGN: 6/10**

What works:
- Every critic point has a row: done, done in part, or not done with a reason.
- Book answers only, with no new content.
- Lines share the coach's 4–6 cap, as in the code.
- No percents, no score, no timer, no judges' cards.
- The held-back list obeys the owner's rulings (Q-212 no percent buffs, S439 buttons that follow the game).
- No names in the body and no fixed pronouns.
- Section 11 wires 16 menus, each marked CODE or NEW.

What fails:
- **The main screen isn't agreed.** The editor replaces the Game plan tab's move map, and the opponent's tree replaces "What your plan should answer". Pack section 7 says screens come only from agreed mockups. The map's own owner question 1 asks this, so stage 1 can't start until he answers it and approves a drawing.
- **It weakens something players can do today.** Today a diamond on any mode is rated by the code. GUESS caps an unfound mode at OK, which is right for depth but changes current results. That shifts the 59 / 45 / 41 balance, and no probe yet re-measures it.
- **Eight CHECKs change the sums.** Film with no camp decides row 2 of the decisions table. Habit-as-IF and the round filter decide three habit rows. Whether FireLevel applies to steps decides how step answers are priced. Whether two modes can hold at once decides diamond order. Stage 1 depends on all of them.
- **Amateur reuse is invented.** "Met before: your most-used line starts SEEN" has no source in real amateur boxing or in the code. It's reasonable, since amateur coaches do remember opponents from club shows. Tag it GAME VALUE and give the player a way to see it coming (the Rival file prints "SEEN: met before", which is good).
- **Test it changes a built feature.** Today Test it has limited tries. The map makes each test cost a sparring night instead. That's a fair price, but it changes the Week, because PEAK already has two sparring nights. Say whether a test can use one of the coach's planned sparring nights or must add a new one.
- **Locking the plan at the first bell** is a NEW rule. Today edits after the weigh-in are possible. That's fine, but it's a change, so give it its own probe.
- **Six presets are content** that nobody has costed. Each needs writing and tuning so PRESET lands 3 to 7 points above no plan.

**3. PLAY: 6/10**

There's a weekly rhythm:
- Film fills in a blank branch of the opponent's tree.
- Validate gives a short to-do list.
- Test it costs an evening and returns a band.
- On the night, FIRED lands on the strip.
- The corner minute shows what's dead.
- "The plan, lit up" shows the whole chart afterwards.

Filling in the opponent's tree is the best anticipation the plan has had. But the payoff is a 3 to 8 point swing in close bouts, and most of the time spent happens before the bout, in an editor. Stage 1 has no live choice beyond today's shouts and one swap a round.

## Options: missing, useless, and what each changes

**Missing**
- **"Use the coach's plan and edit one line":** the fastest way into the editor for a player who doesn't want to draw from scratch.
- **Mark one diamond as the main bet.** Its share band and fire count lead the corner read, so the swap decision is about that bet.
- **A study-slot queue of one:** "next step after this one". The pack says only one step can be learned at a time, so without a queue the plan's second step need waits on the player remembering it.
- **A line on the bout offer:** "Plan from your last bout against this style: +n". Use the band, not a percent.

**Useless or near-dominant**
- **"Copy a team-mate's plan" for the same style:** the drill cards almost never match another boxer's mastery, so it fills the board with red stamps. Keep it for the same opponent only.
- **Diamond order "1",** if the code can't let two modes hold at once. Then it's a label with no effect. Cut it unless the CHECK says yes.
- **The tired IF on every box:** it's free for everyone and the opponent is always there by round 3. Expect one on every plan. Fine, but then make it part of the preset and stop counting it as a choice.
- **The coverage count "answers 3 of 4 known modes"** risks becoming a score the player fills for its own sake. Show it only when a common mode is left unanswered.

**What each option changes**
- **Film evening:** opens one tell, filling a branch, and turns a GUESS into its real rating. Costs about 240 pad units.
- **Scout ($250, pros only):** opens the weapon and the weakness at once and narrows the chance range.
- **Study slot:** about +6 a week on one step, until Usable 30.
- **Step pad card (NEW):** takes a step from 30 toward Sharp 60, sharing pad time with punches.
- **Box:** your boxer's main answer in a place after a won exchange. Worth is shown as the edge.
- **Diamond:** taken first when its mode holds. BEST, OK, WRONG or GUESS changes the edge, and WRONG shrinks the energy ceiling.
- **Timing rule:** limits a diamond to round 1, or to round 3 and later.
- **× (clear one):** frees a line.
- **Test it:** spends that evening on sparring, spreads 180 units over the plan's moves, and returns a band.
- **Validate:** shows warnings only.
- **Save, Load the saved plan, Copy a team-mate's plan:** save the plan, reuse it for a rematch, or start from another boxer's plan.
- **Start again (preset):** the coach's plan for the style word, using free modes.
- **Corner swap:** replaces or removes one piece. The new piece's PRESSURE starts at zero.
- **Say nothing:** holds the plan.
- **"Go for the finish":** beats a hurt diamond and spends one of the two instructions that get through each minute.

## To reach 10/10

1. **Get the owner's yes, and his OK on a drawing, before P10.** Ask "the chart replaces the move map as the Game plan tab's first view?", then show him M1, M10 and M11 at 1920×1080 in Look B. Nothing in stage 1 builds before that.
2. **Settle the four CHECKs that decide stage 1:** Film with no camp, habit as an IF, the round filter, and FireLevel on steps. Cut any habit row whose CHECK says no rather than inventing a stand-in.
3. **Run probes 1, 2, 4 and 10 first.** If GOOD beats PRESET by under 8, make GUESS cap at "OK minus 1" before building the editor, so film is worth its evenings.
4. **Re-measure 59 / 45 / 41 with GUESS on.** Print the new figures beside the old ones in the pack.
5. **Price the free picks.** A timing rule takes one line. Copying a team-mate's plan works only for the same opponent. The tired IF goes into every preset.
6. **Say where a test's sparring night comes from.** It replaces one of the coach's planned sparring nights in BUILD or PEAK, never a TAPER night, and the Week shows "Thu: sparring (plan test)".
7. **Tag amateur reuse GAME VALUE,** and add AMREUSE to the first probe batch, since it changes rematch odds.
8. **Add a "main bet" mark** on one diamond. The corner read leads with it, and the Why grades it first ("Main bet: presses, fired 4, won 3").
9. **Add a one-step queue to the study slot.** "Next: pivot out (the plan needs it)" moves in by itself when the slot frees.
10. **Give stage 1 one live decision.** At the first exchange in which a found mode shows, the strip offers "Lean on it". Your next shout is aimed at that diamond's answer and counts as one of the two instructions that get through each minute. Today that's stage 2. Move it to stage 1 if the shout code allows it.

**My 10/10: Fighter > Playbook > Game plan, 1920×1080, Look B whiteboard**
- **Dark top bar:** the date, cash, and CONTINUE reading "to Sat 28, fight night".
- **Header (0–120):** your boxer's polaroid on the left and the opponent's on the right, each name once. Class in kg, style word, stance. The fight date circled, "18 days".
- **Left (40–440), THE OPPONENT:**
  - A marker tree, with the bell place at the top and six mode branches.
  - Found branches read "presses · 3 of 4 films · often" with the habit's answer. Blank outlines read "not seen yet: 1 Film evening".
  - The biggest hole as one red box, labelled in words.
  - Buttons: Film evening (Tue, −1 pad night), Load the saved plan, Start again.
- **Centre (480–1440), YOUR PLAN:**
  - The bell box at the top, then boxes by place, joined by arrows labelled with places, and grey "lost: back here" arrows.
  - Each box shows the move, "SHARP 64", "fires 3 in 4", "+2.1", a red "UNDER 30: SKIPPED" stamp when it applies, and an ×.
  - Diamonds to the right show the mode word, the answer, BEST / OK / WRONG / GUESS, the share band, and a timing tag ("round 1 only").
  - One diamond carries a gold "MAIN BET" magnet.
- **Right (1480–1880), WHAT IT COSTS:**
  - "Lines 5 of 6".
  - "Drill cards 7, pad nights 5".
  - "Study slot: pivot out, 2 weeks; next: step back".
  - The Validate list, one plain line each.
  - The last test's band, "+6 to +10 over no plan".
- **Bottom strip (980–1060):** Validate, Test it (Thu sparring), Save, Clear. A line in words: "Ready for fight night: 1 warning".
