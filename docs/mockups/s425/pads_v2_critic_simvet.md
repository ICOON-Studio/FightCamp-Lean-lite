# R55 pads v2 - sim veteran critic (S425)

Scores: look 6, clarity 7, depth 4, realism 5. I would not defend it to him as a 7 yet.

## 1. Is each decision real?
Core problem: the measured stake is one card, one week, one fight. After the card is usable the decision is gone for that boxer
(sharp pays 1 point today). A career has maybe a handful of overlapping camps. That is an event, not a mechanic.

1. Plan picks the card (Playbook). REAL, the best one: plan round what she owns vs take the stronger answer, priced 2 to 14 in 100.
   Weak spot: the player cannot see the 4 prices (26 to 38%) until he writes the line; show them on the answer picker.
2. Booking. Mostly DEAD. "Pass" is never right when a free split or a $280 coach fixes the overlap. A pass costs the boxer
   morale and the club the ticket cut; a one-week-late card is 2 to 14 wins in 100. It bites only when no fix is affordable.
3. The lays. Read, do not decide: each lay prints its own result, so the player picks the shortest red list.
   - Nearer first: Reid's default. Right only when the near boxer's card is worth more; the screen shows it is not (14 vs 9).
   - Other first: here DOMINANT (9 lost vs 14). A dominated default is a trap, which is fine, but then Reid's line is a chore.
   - Split: free, and the map says single moves land the same week on half nights. So for any single move it is ALWAYS right.
     It is missing from the picture. It only loses for combinations: one case, not a lay.
   - Both whole, no class: $230 a week against $280 forever. Pure arithmetic on overlap length. Chore: auto-pick forever.
   - Move a pad night: not on the screen, yet Friday shows "free". The clash is self-made. Mon + Wed clash with Fri free is
     false drama; the player just drags a night. Either lock the week (rest days, sparring, fatigue) or admit it.
4. Hiring. Second coach is ALWAYS right once two boxers overlap more than a month: he carries +40 members (about $320 a week in
   dues) against $280. He pays for himself. DEAD as a decision. Hale ($1,090) is DEAD: the measure says how good hardly matters.
   Reid 74 vs 45 on the card is a number that changes no choice.
5. Goes without. "Feels second" then a promise: always promise (free), nothing makes the promise cost until the next camp,
   and morale 5/10 are invented. DEAD unless the promise binds a later lay (Reid must lay for her next camp or it breaks).
6. After. Fine, not a decision.

## 2. What is missing
- FIGHT NIGHT. The real sharing problem in a small club is one corner man for two boxers on the same show. The map left it out
  ("player corners both"). Corner trust (Low = ignores shouting, calls count 0.7 to 1.05) is already in the game. Put it on
  Club > People and on Fights > offer: Reid corners one, you the other, the calls count less. This is the strongest link.
- Value of the fight is missing from the stakes. 9 or 14 wins in 100 means nothing without what rides on it: rank, purse,
  the nationals. A late card on a club show is not a late card on an eliminator. Add win chance and what is at stake to each lay.
- Weight cut and weigh-in days: a coach is needed on the scale and the cut walks. Fighters > Fight prep.
- Sparring and rest: sparring nights need no pad hands and are where the second boxer's evening goes. Link to fatigue (overreached x0.6).
- Injury: a hurt boxer gives nights back (stated) but the other gains them; the player should see it ("Danny hurt: Lucy gets Wed").
- Money: class lost per evening is the only price; a hire has no gain side besides members. Put the member gain beside the $280.

## 3. Useless
- Coach rating (74, 45) on the rota: changes no decision by the map's own numbers.
- "26 of 30" and the white tick: needs a manual; say "Usable at 30" once or draw the Usable line named.
- The three "needs Mon + Wed" words in the red chip: it names nights, but Friday is free.
- Left-out "second coach Tue Thu Sat": the real clash only exists on Mon/Wed because the player cannot move nights. Remove that rule.

## 3b. Wired and shown
- Playbook star and "needs N weeks": right place; show the 4 prices there, not only on People.
- Offer card overlap line: right; must also show the show-night corner clash.
- Home Monday need: right. Opens People: fine.
- Club > People: right home for the rota; but a boxer's own nights must also be editable from Fighters > Training (the Coach row
  exists: good). Two homes for one edit; make People read-only and the Training week the only editor, or vice versa.
- Club > Money line "Classes $350, two evenings off: $120": fine, but not actionable there; show it, no button.
- Fighter > Overview "Feels second": right place. Missing menu: Fights > Results and the Why carry only the lesson; also add Home's boxer row chip.

## 4. The screen, element by element
- Rota rows and cells: KEEP (faces are very clear). CHANGE: add "half each" cell and a drag to Friday; label the cells with the card.
- Class money strip: KEEP.
- Second coach ghost row: CHANGE to "Second coach: +40 members" and drop the rating; a locked Hale row is CUT.
- Hire row: CHANGE, merge into the lays (it already is a lay).
- Bells timeline: KEEP, best element. CHANGE: write win chance, not "a week late".
- Warning chip: CHANGE to say what happens, not who needs what.
- Boxer cards and chips: KEEP; CUT the star chip (the card name already says it); CHANGE "Without it" to a chance and what rides on the fight.
- Coach line: CHANGE, Reid states his rule and that it is not the best; a fake coach advice that is wrong teaches the player to ignore him.
- Four lays: CHANGE, each lay shows one number (wins in 100 lost) and one price; add Split and Move night. Type is 26+ px: no hard fail.
Look cap does not apply (no text block, type 24+), but the painted look is flat dark slate, not the wood/whiteboard of the Training tab: 6.

## 5. Scores
Look 6. Clarity 7 (the timeline reads in five seconds; the lays do too, but "Ready by the bell?" is a riddle). Depth 4: one card, one week.
Realism 5: a coach rotates two boxers through one night, so "whole night or class off" is invented; real limits are rounds and arms.

## 6. To reach 10/10
1. Put the show night in: one corner man, trust and calls on the offer card and on People.
2. Make the stakes carry value: every lay shows lost wins in 100 against what is at stake (rank, purse).
3. Remove dominated options: second coach is priced honestly with its member income (a real buy-or-not); cut Hale and ratings.
4. Give Split, Move night and the promise real prices; make the promise bind next camp's lay.
5. Free the nights: let the player move pad nights, and give sparring/rest/weigh-in a claim on them so a clash is real.
6. Step 1 first: sharp and signature pay on fight night, or pad time dies at usable and the mechanic is a one-card event.
7. Show the four plan-answer prices on the Playbook picker so decision 1 feeds decision 3.
8. Let Reid's rule be a visible default that learns: he picks the boxer with the most wins at stake after you overrule him twice.
Drawing: docs/mockups/s425/pads_v2_10_simvet.png
