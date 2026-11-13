# TRAINGAME critic S455, picture E (fresh critic: Claude)

Read: CRITIC_PACK, `training_game_e.png`, `camp_plan_v3.png`, rule constants in WeekPlan.gd / InjuryRoll.gd.

## Scores
- AS A GAME: 6 / 10
- DEPTH: 6 / 10

## 1. Logic check
Holds up (checked): week 7 = Mon 16 Feb (day 42); 12 days to Sat 28; two green tags +2.5 and +1.5 add to the +4 on the dial; the dragged sparring strip says +1.5 and the
dial is not changed before the drop; bands 72 and 80 match the code (injury risk from 72, overreached 80); Thu already has sparring, matching the PEAK pattern (two
nights); a bout one week out makes next week a taper (S451); no he/she in text; the only names are in the header and breadcrumb.

Defects and doubts:
1. Stamina goal 61 "on course": 60.1 by Sunday and "61.0 after next week". A taper week of 3 light mornings cannot add 0.9 (a morning is a fifth of 1.0 x 0.6 for Light, times
   headroom: about 0.1 each). The goal is either off course or the taper figure is wrong. This is the main goal on the screen, so the number must be honest.
2. Mastery numbers do not agree: Monday pads Check hook 12 to 21 (+9 for a whole night) but Wednesday's half night gives Body hook +3 (29 to 32). Half a night should be about +4.5
   at the same rate. Also the pack gives pads 2.1 mastery per hour, so +9 in 75 minutes is far over. Fix the rate or show the units.
3. A third sparring night (Sat) in a phase where the coach sets two (SPAR_DAYS for Peak is two nights). The strip prices it as a free choice; the screen must say whether a third
   is allowed, and what it pushes out. It is shown only as Saturday being empty, which hides that Sat is a 3rd night.
4. Sun "Open night: last pad night that counts" while Fri is also "Check hook to Usable" and the header says "last pad week". Three different "last" claims; pick one: "pads after
   Sun count for nothing" and say why (usable by the taper).
5. Tuesday film is YOURS +2.5, and the coach's week puts sparring on Tue and Thu in Peak. So the player swapped a sparring night for film, yet that card shows no "gives up".
   Every green card must show what it cost, not only the strip for the dragged card.
6. "Welter 70 kg" in the header is ambiguous: class limit or weight now? "Makes weight 0.4 kg spare" needs both numbers beside it.
7. The tray has no Mobility and no evening Rest, but both exist in WeekPlan (ORDER has mobility, EVENINGS has Rest). Sparring in the tray is greyed with no reason.
8. "Weekly card" flag is amber but the card is not on the screen; RUN THE WEEK pulses over an unanswered event. Say what happens (coach's pick) or open it first.
9. Stamina on Mon, Wed and Thu-speed are all the same ring-teal family as Rest green and Strength red = Power red: Strength and Heavy bag share a colour; fine, but there is no
   legend of colours to stats outside the tags.

## 2. As a game
Good: the week is a real board, the picture of each session says what it is, rings and flames are learnable, the tiredness curve with named bands and the live drag strip is
the best idea here (a decision with a price shown before you let go). The look matches the camp plan: same navy panels, same Oswald headings, same ON FIGHT NIGHT
checklist and handwritten pick, so it belongs to the game.

Against the screens I know: Football Manager's training calendar is plainer but one glance shows load and who is unfit; Motorsport Manager shows what each choice does to named
numbers; this screen is closer to MM in spirit but shows the effect of a card only as an arrow and a word ("Stamina", one flame), never a number you can compare. Punch Club
and Two Point read in five seconds because there are 4 or 5 big things; here are 14 cards each with picture, ring, name, stat, flames, letter badge, tag, plus curve, strip,
tray, checklist, note and card: about 60 things to read. Five seconds: I can see "drag a round icon onto a day" and "keep the curve out of the red". I cannot see what a session
improves by how much, nor what Light / Normal / Hard changes (the letter badge is tiny and only the selected day shows the lever). The photo behind each card does the
session's job; the ring icon on top of it repeats it, so the art is spent twice and the text is still small (cards at about 180 px wide with 16 px text).
Dead space: the right column leaves about 140 px empty above USE COACH'S PICK, the tray row has an empty bottom third, while the curve and the cards are cramped.

## 3. Depth
The trade-off is real in one place: the tiredness cap against the WIN dial points, plus injury 1 to 3 in 100, plus the hook becoming Usable by Friday. That is a puzzle with a
clear target: get the green tags up while the peak stays under 72, and the coach's pick is probably near the best answer. There is one right plan with small variations
because (a) the WIN dial is a single number everything is converted into, (b) weight, money, morale and the other fighters never appear as a cost, (c) the week goal chips
(Peak / Build / Recover) show no effect, and (d) nothing is uncertain: every number is shown exactly, so there is no gamble ("fairly sure" is the only doubt and it is the coach's).
Over a season the lever is not visible: does a harder week now cost the next? The curve stops at Sunday. A 7 needs two goods that cannot both be bought in the same week.

## 4. Options
Missing:
- Diet Hold / Cut with its price (the pack has it as a training lever; the screen only says "Cut" in a checklist line).
- The numbers of a session: how much stamina this morning buys (+0.15), and a Light / Normal / Hard control on every morning card, not only the selected one.
- A body strip: what hurts now (training load spike 1.5 is a 3x injury rule in the pack, not shown), so the player knows why a Hard day is dangerous.
- A "what changed vs the coach's plan" count, so one tap shows only the player's edits.
- Next week's taper as a card row (it is a text line only), and the whole camp to the bout.
- Pad night split (50/50, 70/30) is in the game and absent from the picture; the Wed card says "half the night each" but the player cannot change it here.
Useless or weak:
- The Build / Recover chips with no preview (they rewrite the week; show the dial and curve they would give before pressing).
- The sparring greyed tray icon (no reason).
- The tiny L / N / H letter on unselected cards: it is a lever shown as a label.
- The sentence "a green tag = what your change adds to the WIN dial" (the legend should be on the dial hover).

## To reach 10/10 (most important first)
1. Make the numbers honest and consistent: stamina after the taper, mastery per night, a cap of two sparring nights (say if a third is allowed and what it pushes out).
2. Show each session's effect as a number on its card (stamina +0.15) and a visible L / N / H on every morning card, so "what each improves, how much" needs no click.
3. Put a price on every green tag (what the player gave up), not only on the dragged one.
4. Add a second axis to the decision beside the WIN dial: weight (diet lever with its cost), and an injury strip with the body's state, so a week has two goods that clash.
5. Add a "What this week buys" strip: stat bars before and after the week with the goal tick, plus the pad moves climbing the New / Raw / Usable ladder; it replaces the text lines in the header.
6. Cut the card clutter: drop the duplicate ring on photo cards (the ring is in the tray), keep one label and one number per card; use the freed space for bigger text.
7. Preview before commit for the week chips (Peak / Build / Recover), and show the taper week as a faded row after Sunday on the curve.
8. Fill the dead space (right column, tray row); add Mobility and evening Rest to the tray; give greyed items a reason; name colours in a tiny legend.
9. Say what the pulsing RUN THE WEEK does with the open weekly card.
10. Needs the game to do more: a week-after-week memory (this week's load carries into next) and a small uncertainty (injury or form range) so the plan is a bet. Today
    the rules show every number exactly, so this part is not buildable until the game adds it.

## My 10/10 layout (1920x1080) - file `docs/mockups/s455/training_d/critic_claude_e_10.png`
Same shell, header and look as the camp plan.
- Top bar 54 px, header 84 px: fighter, bout, countdown, WIN dial with where each point comes from on hover, the goal with "0.5 short" (honest, amber).
- Left main (1370 wide): row with week chips and one line saying what Peak means; seven day columns, each a morning card on a photo with the stat ring, the name, the stat and the
  number it buys, a visible L N H switch and tiredness dots; an evening card under it with the drill, its move and the ladder step; one tiredness curve (140 px) with named bands,
  the Saturday drop shown as a dashed line.
- Under the curve, three panels: WHAT THIS WEEK BUYS (stat bars pale to bright with the goal tick), MOVES ON THE PADS (New / Raw / Usable ladder, Usable line marked), BODY (diet
  Hold / Cut 500 / Hard cut with its cost, weight spare, hurt now).
- Session tray 96 px at the bottom, all 10 mornings and 4 evenings, ring colours explained once.
- Right column (504 wide): ON FIGHT NIGHT checklist; an amber panel that lives while dragging (win, tiredness, injury, goal, what it replaces); the coach's handwritten pick with how
  sure; the clicked card's gives and gives up; USE COACH'S PICK in green.
Known flaws of my drawing: the lower panels are a little cramped and the "pale = now" caption wraps; fix in a real build.
