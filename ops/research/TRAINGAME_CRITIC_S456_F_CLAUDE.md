# Training screen F - fresh critic (Claude), S456

**AS A GAME: 7/10. DEPTH: 6/10.**

## 1. Logic check
No hard contradiction in the arithmetic. Checked and found consistent: 12 days Mon 16 to Sat 28; Stamina 60.1 + 0.09 (Mon) + 0.09 (Wed) = 60.3, and
Roadwork Sat adds the missing 0.1; the WIN tags +2.5 (film) and +1.5 (Wed pads) add to the "+4"; sparring +1.5 gives 55 to 56.5%; Sat 63 to 68 under 72;
the peak week reads "peak 70" in the week goal and on fight night; Light speed bag is 0.6 of Normal (0.05 of 0.09). The week is a PEAK week 12 days out (the
code gives PEAK at 2 weeks), and a no-camp amateur bout is allowed. Names: only in the header and breadcrumb. Good.
Problems:
- **Two different numbers under one card.** Wed pads says "+1.5" (WIN points, green) and "Body hook 29 to 32" (mastery). Same colour, same size, two units.
  The player reads +1.5 as mastery and 29 to 32 as +3.
- **Check hook trail is unreadable.** Mon "12 to 21", Fri "24 to 31", Wed "31 by Fri, not 34". The hook is 21 after Monday, 24 on Friday morning, and the
  Wed split is said to cost 3. Whether 24 already contains the Wed loss is not visible. One running line per move (12, 21, 23.5, 24, 31, 33) is missing.
- **Hold / Cut switch has no clear state.** The row says "Makes weight 69.6 kg" with a green tick, while the line under it says Hold gives 70.5 and the bout is
  off. A green tick on a state the current switch (Hold) fails is a contradiction on the same row.
- **Coach's plan peak 74 is above "Tired 72" and yet the button is just "51% peak 74"** with no warning that the coach's own week ends Tired.
  Fine as data, but the red/green logic is missing: a player cannot tell it is the worse week without comparing.
- **Weight cut vs weekly plan.** Cutting is a diet (500 kcal a day) and changes the week's tiredness and Stamina; the screen shows no tiredness change
  for Cut. The switch looks free.
- Sparring Thu says "live rounds for Usable" but gives no number; Sat's drag strip says "check hook 31 to 33". Thu's own contribution is unquantified.
- Sunday morning shows Rest with "Tiredness 63 to 55" and Sunday evening is also a rest: eight points from two rests, nothing says which gave what.

## 2. As a game
What works: the week is a board you can read in five seconds as a Monday to Sunday grid with a picture per session; the Light / Normal / Hard switch sits
on every morning; the coloured ring ties each icon to its stat; the win dial and the goal bar sit where the eye lands first; the drag strip (what the drop buys
and costs, before you let go) is the best idea on the screen, and the single tiredness curve with the coach's dashed line is exactly the right size.
Why it is not an 8:
- **The numbers are too small to feel.** "+0.09" is the true figure but the player cannot feel it. Football Manager and Motorsport Manager show a bar that moves;
  here nothing moves except one decimal. There is no "what the week buys" view: five stats, now, by the bout, against the cap. The player has to add
  twelve tiny numbers in his head to see whether Stamina reaches goal. (The header bar helps for one stat only.)
- **Text is still the main thing.** The cards carry 4 lines each; the right column is paragraphs (film note, pad rule, coach note). The art is a dark photo
  with a small ring; the picture does not tell the session apart from a distance. Icons are the right style (ink figures, coloured ring) but 60 px.
- **The three goals (Peak / Build / Recover)** are the best idea for fast choice but they show three numbers each that mean three different things (WIN, tired peak) without
  labels. Reaches the player as noise.
- **Evening cards say what they do in words** ("found: drops the right", "Fight IQ live rounds") where a picture of the move and a bar would do.
- The Hold / Cut switch and the Usable threshold at 30 are hidden in small print.
Compared: Football Manager's training calendar is more cluttered but its green/amber workload bar is read at a glance; Punch Club is a plain list with
bigger art; Motorsport Manager's setup sliders show the result changing live (this has that only on a drag); Two Point shows one clear outcome per room.
This screen is closer to MM than FM, which is right for FightCamp.

## 3. Depth (6/10)
Real decisions exist: Stamina goal vs Technique (Sat Roadwork vs Shadow); sparring Sat for +1.5 win at +5 tiredness and a 3x injury chance; splitting one pad
night between two moves; Hold vs Cut; Peak vs Build vs Recover. But the screen resolves them: the coach's pick is told to the player ("Roadwork Sat, not
Shadow", "no sparring Sat"), and the strip shows sparring costs more than it buys. There is nearly one right plan, because every trade-off is priced in the
same place and the numbers are all small. What would make it a decision: costs that do not net out in one number (an injury that stays, a morale or trust cost,
a partner who is available only on some nights), and a payoff that is not visible until Tuesday (the film, the opponent's habit confirmed).
Not changed by this week: the opponent's habit (drops the right) is one line; there is no choice about how to prepare for it except pads on one move.

## 4. Options missing, useless
Missing:
- Sparring partner (club mate free vs outside mate $160 of the opponent's style): in the game for camps and absent here; changes what sparring buys.
- A "swap two days" gesture, and a way to copy a day to the next one.
- Stat ledger (what the week buys, per stat, with the cap) and a Cut diet row on the week's tiredness.
- Seeing the effect of a hard / light switch before pressing it (the number on the card should change live and flash).
- The weigh-in day and the bout date marked on the day columns (Fri weigh-in, Sat bout are next week, but the week after is a taper: a small ghost of
  next week would show where today's choices end).
- A "what the coach would change" button per card (the coach's line exists as a note, but it is not tied to a card).
Useless or doubling: the third week goal (Recover 49%) is a trap nobody will pick 12 days out: show it only when tiredness is high; "Undo" and "Coach's plan"
are two buttons and USE COACH'S PICK is a third copy of the same reset.

## To reach 10/10 (most important first)
1. Add a "WHAT THE WEEK BUYS" ledger: five stats as bars from now to the bout against the fighter's cap, with the goal stat marked; it moves while you drag.
2. Make every card's picture do the work: bigger icon (90 px), the stat colour as a wide bar under the card, no sentence on a card; the move on an evening card shown as the Playbook ink figure.
3. One unit per colour: green WIN points only, white for stat and mastery changes; never a +1.5 and a 29 to 32 side by side.
4. Fix the Hold / Cut state: the tick follows the active switch, Cut shows its tiredness price, and a failed weigh-in is red and blocks RUN THE WEEK.
5. Show the move mastery track across the week (one little ladder per move, Raw / Usable 30 / Sharp 60) so the check hook reads 12 to 21 to 24 to 31 in one glance.
6. Give costs that persist: injury chance as a bar with the week it hits, a partner choice (free or $160) and a morale or trust cost for overruling the coach.
7. Show the coach's pick as a ghost on the board (grey dashed cards) so the player sees where his week differs, instead of a note plus a second button.
8. Label the three week goals (WIN / tired peak / stamina) and hide Recover unless fatigue is high.
9. Put the next week's taper as a pale eighth column so the bout and weigh-in sit on the board.
10. Live numbers: Light / Normal / Hard changes the card at once with a short flash; the drag strip stays.

## 10/10 drawing
`docs/mockups/s456/training_f/critic_claude_f_10.html` and `.png` (1920x1080).
Panels: top bar and header kept (win dial, goal, days) but the dial and the number sit larger. THIS WEEK IS FOR: three week goals with their three numbers named.
Seven day columns: a morning card (photo from the camp-plan set, the ink icon in its stat ring, L / N / H on top, stat and number, tiredness squares) and an
evening card with the drill named. One tiredness curve with the coach's dashed line and an amber dashed "if sparring Sat". Sessions tray of ink icons.
Right column: WHAT THE WEEK BUYS (five stat bars, cap tick, hatched gain, goal marked); ON FIGHT NIGHT (Hold / Cut with the state, tiredness peak, injury);
the coach's handwritten note with how sure; the clicked card (Wed pads split bar, gains and gives up); the drop strip for sparring. The drawing shows the
ledger and the Hold state but is a sketch: the evening cards need the Playbook ink move pictures, which are not reused here.
