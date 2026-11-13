# TRAINGAME critic S455, picture D - Claude (fresh critic)

Judged: `docs/mockups/s455/training_d/training_game_d.png`, against `docs/mockups/s449/camp_v3/camp_plan_v3.png`, CRITIC_PACK, WeekPlan.gd, InjuryRoll.gd.
My 10/10 drawing: `docs/mockups/s455/training_d/critic_claude_10.html` / `.png` (a sketch of the layout; art reused from D).

## Scores
- AS A GAME: **6 / 10**
- DEPTH: **6 / 10**

## 1. Logic check
Checked and fine: Sat 28 Feb is 12 days from Mon 16; weigh-in Fri 27 is the day before; 70.9 kg now, Cut 69.6 = 0.4 kg spare under 70.0, Hold 70.5 is over; injury x2.3 at 77 matches InjuryRoll (x1 to 72, x2 at 76, x3 at 80); the legend numbers match the code; pad progress (Check hook 12, 21, 25, 32; Body hook 29 to 32) agrees between cards, right panel and rings; "Peak" phase 12 days out is right (2 weeks out); header holds the only names (Kwame, Jade).

Problems:
1. **The WIN tags do not add up.** The tags sum to about 7.3 points (mornings 1.0, evenings 6.3) but the dial says "your 2 changes +4". Only two cards are marked YOURS, so tags and the dial use different units or the tags include the coach's cards. A player who adds the green tags will think the screen lies. Say what a tag is: points of win chance, and make the dial equal the sum.
2. **Morning tags double as stat gains.** Roadwork +0.2 and Intervals +0.3 equal the Stamina "+0.5" in THIS WEEK BUILDS, so they read as stat gain, not win points. One meaning per number.
3. **Goal bar "0.9 short: add Intervals"** says add one session while another full week (Feb 23-27) still exists. The header itself says that week is the last for pads. Either the goal row means "by this Sunday" (then say so) or it should say "on course".
4. **Film "$75".** The pack says tape study in an amateur camp is free; pros pay $250 to scout. $75 is not a rule in the pack. A cost on an amateur's film night needs a source or must go.
5. **"x2.3" is jargon** and, for a base training chance of about 1.3% a week, means about 3 in 100. The player cannot tell if that is worth fearing. The legend repeats x2 / x3. Show chance in plain words ("about 3 in 100 a week").
6. **Sparring Sat after sparring Thu**: the code's peak week spars Tue and Thu (SPAR_DAYS [1,3]). The picture's coach week has film Tuesday and sparring Thursday, and a second sparring on Sat is offered with a warning. Fine as a choice, but the card does not say sparring also carries a bout-injury-style risk to the fight itself (a cut or hurt rib 7 days out), which is the real price. Only tiredness is shown.
7. **The hover tooltip covers the Mon and Tue tiredness tanks and the lower half of two evening cards** - in the picture the Mon/Tue values are unreadable, and the Mon pads play-triangle sits over its "+0" tag. A mock that hides its own key number cannot be judged as clear.
8. Mon pads shows "+0" and "12 to 21" side by side (explained only by hover). Honest, but the first thing the player sees is a card that looks useless.
9. No name outside the header: pass.

## 2. AS A GAME (6)
What works: it is a real planning board. Photo cards with a stat-coloured ring, a lever per morning, a pulsing CONTINUE, the sessions tray you drag from, the tiredness tank, the sparring drop warning and the "YOURS vs struck coach card" idea are all genuine game verbs. The look is the same family as the camp plan (dark navy, Oswald, photo cards, green/amber/red tags). Better than Boxing Manager's list screens; closer to Motorsport Manager's setup screens.

What fails the five-second test:
- **Too small and too dense.** Body text is 13-15 px on 1920. The camp plan uses 18-24 px for everything and has about 40 numbers on screen; D has over 150 (14 cards with tag, ring, stat, flames, lever, plus 7 tanks, 6 bars, 4 rings, weigh-in, legend). Football Manager's training screen is dull but it has one control per area; D has five (card, lever, goal row, buttons, tray).
- **The picture does not say the one thing the player is here to do**: reach the bout at best shape. The camp plan has "ON FIGHT NIGHT" as a checklist (makes weight, stat on target, tiredness peak, injury chance) and a handwritten coach's pick. D has the WIN dial but no fight-night checklist and no coach's pick, so the player must read the whole board to learn whether the week is OK.
- **Tiredness is shown seven times as separate tanks**, which hides the shape (rising, peaking, recovering). One curve across the week with the 72 and 80 lines would read in a second and shows the cost of a drop live.
- Flames per card, three lever buttons per card and a tag per card repeat the same information on every one of 14 cards. Show levers only on hover or on the clicked day (the owner's "only actionable info" rule), keep the flames.
- Art is where it matters (photos, rings), but the cards' own text sits on dark gradients at small size and the photo is mostly covered.

## 3. DEPTH (6)
There are real trade-offs: sparring vs tiredness vs injury, film vs pads, Hard vs Light against the 72/80 lines, a weight cut against training, pads splitting a night between two moves, and Peak/Build/Recover changing what the dial counts. That is a decision, not one right plan.
Why only 6:
- The week is the LAST pad week and the bout is mostly decided by stats already (5 points in stats wins 72%). The levers move the dial by single points, and the best plan is findable: Peak goal, pads Wed and Fri, spar Thu, keep under 72. The coach's own plan is already 51 and "yours" adds 4. That is a tuning game, not a dilemma.
- No risk you can take on purpose: nothing says "go Hard and risk overreaching for +X" with a visible chance and payoff. The picture shows the cost (x2.3) but not a payoff large enough to tempt.
- Nothing links this week to the next one: the TAPER week is not previewed, so the player cannot see what saving tiredness now buys.
- Opponent knowledge is a single Film card. It does not say what the opponent is weak at and what the week should answer.

## 4. Missing, useless
Missing:
1. A fight-night checklist (as the camp plan): weight margin, stat goal, tiredness peak, week injury chance, usable moves. Changes: the player can tell "good week" without reading cards.
2. The coach's pick as a note with a one-line reason and "use it". Changes: a new player gets a safe default; an expert sees what to beat.
3. One tiredness curve with a live ghost line for a drop in progress.
4. A "what this answers" line from the opponent's file (a found tell, with the card that answers it). Ties film and sparring to the bout.
5. Preview of the next (taper) week: "next week: 3 light days, no sparring".
6. A drop-time "Hard here: +x, tiredness +y, injury 3 in 100" readout on the lever, not three identical buttons per card.
7. The injury price of a sparring night as a plain chance.
Useless or noisy:
- Five of seven tanks as separate boxes (replace with the curve).
- The lever on every card at once (hover or select only).
- The flame count and the tag and the ring on every card: keep the ring and the tag, put flames in the tooltip.
- The "Weekly card" button in the header (an event) belongs in the top-bar flag set, not beside the goal.
- Both "Weekly card" and the YOURS strike-through coach card: two ways to show "changed".
- "All mornings Light/Normal/Hard" AND per-card levers AND Coach's plan AND Undo AND week-goal row: five global controls. Keep goal row, Undo, Coach's plan.

## To reach 10/10 (most important first)
1. **Add the camp plan's ON FIGHT NIGHT checklist** (makes weight, stat goal, tiredness peak of 80, injury chance this week, usable moves) as the first right-hand panel, live as cards move. This is what the week is for.
2. **Make the WIN dial and the tags one unit.** Tags are points of win chance; the dial equals base plus the sum of changed tags; hover on a tag lists its cause. Fix the +4 vs 7.3 contradiction and the "+0.2 = stamina gain" double meaning.
3. **Raise text to the camp plan's size**: 18 px minimum, 40 numbers on screen at rest. Show levers, flames and costs only on hover or on the selected day; no tooltip may cover another number (place it off the board).
4. **Replace the seven tanks with one tiredness curve** across the week with the 72 and 80 lines and a dashed ghost for the drop in progress; label bands Fresh / Working / Tired / Overreached on it.
5. **Add a coach's pick note** (handwritten, with FAIRLY SURE and Use coach's pick), same as the camp plan, naming the single change that matters.
6. **Give the week a real gamble**: a Hard lever or an extra sparring night that shows its payoff and its price side by side (for example "+0.4 Ring IQ, +3 win points, injury 3 in 100"), and a taper-week preview, so spending tiredness now is a decision against next week.
7. **Tie film and sparring to the opponent's file**: "answers: she loads up -> Tue film opens it, Thu sparring drills the check hook".
8. **Plain words for risk**: "3 in 100 a week", not x2.3; source or remove the Film $75.
9. **Bigger photo cards, fewer per screen**: show the day's two cards large for the selected day and small chips for the rest (Punch Club / Two Point style), so art is the thing you read.
10. One global control set: goal row, Undo, Coach's plan, and a single "all mornings" lever; drop the rest.

## My 10/10 layout, 1920x1080 (drawn in `critic_claude_10.html`)
- Top bar 56 px (shell). Header strip 84 px under it: portrait + name + weight/rank/record; bout + days; WIN dial; stamina goal bar. Weekly card moves to the top-bar flags.
- Left, 1296 wide: **THIS WEEK** board: goal row (Peak / Build / Recover) and a single all-mornings lever above seven day columns. Each column: a morning card, a three-position lever, an evening card, all 150 px photo cards with the stat ring, name at 17-23 px, one green tag. Changed cards say YOURS; a sparring drop shows a red dashed outline and a "?" tag until dropped.
- Under the cards, one **tiredness curve**, full board width, with the 72 and 80 lines, bands labelled, and a ghost line for the drop in progress.
- Bottom left: **SESSIONS** tray, 78 px rings, morning left, evening right, with the band legend on the same strip.
- Right, 584 wide, top to bottom: ON FIGHT NIGHT checklist; the clicked card (photo, what it gives, what it gives up); weigh-in one line with Hold/Cut; the coach's pick as a handwritten note with Use coach's pick. CONTINUE sits in the top bar as the one pulsing button ("Run the week").
