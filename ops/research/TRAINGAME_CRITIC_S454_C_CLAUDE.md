# TRAINGAME critic S454, version C (Claude, fresh critic)

Read: brief C, CRITIC_PACK, CRITIC_ACCESS (skimmed), training_game_c.png. Checked WeekPlan.gd and the pack for numbers.

## 1. Logic check

Contradictions on the screen or against the pack:
1. Injury line. The dashed line says "injury risk x2 (76)". The pack (4.1) and WeekPlan say overreached from 80 fatigue: gains x0.6 and injury risk x3. Either the line is at 80 and says x3, or the rule changed and the pack is stale. As drawn, the Saturday warning ("61 -> 77, injury risk x2") fires on a rule the game does not have.
2. Check hook runs backwards. Mon pads: 12 -> 21. Wed pads: 21 -> 32 (Usable). Fri pads: Check hook 25 -> 32. After Wednesday it is already 32, so Friday cannot start at 25. Friday is tagged "In Wed" with +0, which says "nothing to add" while the card still shows a gain. Either the sequence is wrong or Fri is a dead card that should be greyed.
3. "5 weapons - the slip 2-3 line is thrown" on Sat 28, but the move rings show only 4 moves, and the 1-2-3 is at 18 of 30 (not usable). "Slip 2-3 line" is not on the screen anywhere else. The "Gives up" line says "the 1-2-3 waits one more night", which contradicts a thrown 2-3 line.
4. Sunday evening: "Pad work lands" is a dead slot, while the header says pad work lands Sunday night. The player cannot tell if Sunday pads count, are locked, or are the delivery moment. A locked slot looks like a card. It should read "locked, last night that counts is Sat" or be draggable.
5. Builds panel lists Stamina, Power, Hand speed, Defence, Ring IQ. Saturday's Shadow card grows Footwork (+0.1) and there is no Footwork bar. The week's total does not add up to what the cards say.
6. WIN dial: 48% coach + 7 = 55%. Tags add to about 7.3 (mornings 1.0, evenings 6.3), fine. But Monday pads gain 9 points of Check hook and show +0, while Wednesday 3.5 for similar work. The tag is not explained (why does the same drill give 0 in one place and 3.5 in another?). Reads as a hidden formula.
7. Weight: 70.9 -> 69.98 against limit 70.0 on Cut. Margin 0.02 kg. This is a coin flip shown in green, and it is unclear whether it is the Sunday weight or the weigh-in weight on Fri 27 (the pack puts weigh-in the day before the bout). One number needs a date.
8. The tank on Saturday reads 61 after Friday's 63 with a Shadow morning and a pad night, yet a sparring night alone adds 16. Check the recovery rule is stated somewhere; a viewer cannot reproduce it.
9. Header goal "met" at 60.1 by Sunday while the bar fill sits at the marker; fine, but "mood +10 after the bout" is a reward line tied to a goal that is already met by the default plan. The goal is no challenge.
10. Names outside headers: none seen. "Jade Okoro" and "Kwame Asante" sit in headers only. Good.
11. Game could not do: the pack says Wednesday-style "Pads: two hooks" is a split of a 75 minute night (50/50); consistent. Film $75 "opens 1 tell" fine. Amateur bout 12 days out: pack says fight week is 1-2 weeks out; the screen treats this week as a normal camp ("Peak") with a Peak/Build/Recover goal. The pack's phase names are BASE/BUILD/PEAK/TAPER and these are for camps that amateurs do not need. Small mismatch; say so.

## 2. AS A GAME: 6 / 10

Would I enjoy planning a week? Partly. The seven-day grid with picture cards, a drag strip, a fatigue tank and a WIN dial is a real game toy, closer to Motorsport Manager's setup screen than to Football Manager's grid. The pulsing CONTINUE is clear.

Five-second test, honestly:
- "I drag a card from the bottom onto a day" is clear. "Light/Normal/Hard" levers are clear.
- What each card improves is readable only through tiny text and small arrows under the card title (7-8 px height of text). The picture carries mood, not meaning. A viewer cannot tell from the pictures which card trains what.
- The fatigue tank is the best idea on the screen. But it is a label-free bar with a number, and the injury line is a thin dashed red.
- The right column is a dense sheet again: four stat bars, four rings, a weekly card, a load dial, a diet switch, and the clicked card's numbers. This is still the information sheet the owner complained about, with art on the left.
- Text volume: about 40 distinct text items on the board alone at 9-12 px. Too text-heavy at 1920 wide.
Compared with: Football Manager (clear grid, no art, but one-line effect per slot): this is more fun to look at, less clear. Punch Club: stronger art and instant stat read. Two Point: items glow when something is wrong; here the only alert is the sparring warning.

Art where it matters: the picture sits on the card, but the thing that matters (what it trains) is the arrow text. A round icon plus a comic illustration say the same thing twice.

## 3. DEPTH: 6 / 10

Real trade-offs exist: fatigue against gain (Light x0.6 / Hard x1.3), pads vs sparring vs film (opponent tell, $75), the weight cut, the week goal (Peak/Build/Recover), the pad split, risk pips on heavy bag and sparring.
Weaknesses:
- Few plans are bad. The coach's default is at 48% and the player adds 7 points; the optimum is a short list of obvious moves (pads on 2 nights, film, sparring early, keep the tank under the line). Once the player learns that tags equal WIN points, the screen is a score-maximising puzzle with one visible answer.
- The injury and fatigue lines are the only cost. There is no price in money, mood, or relationships except Film $75.
- Mornings are almost a solved choice: stat arrows and gain are small (+0.1 to +0.3), the dial barely moves. A player will see that mornings do not matter and set all to Normal or use the quick-set. Evenings hold the whole decision (2.5, 3.5).
- Nothing changes the plan during the week (twist card exists only as the weekly card here); there is no hidden info, no forecast risk, no reaction to the opponent beyond film.
- Single fighter only. The pack has four fighters and shared coach pad nights (agreed, not built); the competition for the coach is the best trade-off in the game and it is missing here.

## 4. Options missing / useless

Missing:
- A "why this plan" line that names the one change that would add most to the WIN dial (the pack has "coach's one change with Do it"; it is gone from this screen). Big gain for new players.
- Opponent profile beside the week: what they are strong at, which of my sessions answers it. Film gives "1 tell" but the player has no idea what to train against.
- Sparring partner choice (club mate / hired, with their style and hit risk). Pack 4.3 has partners.
- Coach availability: how many pad nights are left in the week for this fighter, across all four.
- Recovery tools: physio/massage/sleep/ice bath as an evening or the strength-and-conditioning staff effect (pack: injury risk -15%).
- A weigh-in preview with a date and a safe/danger band, and a cut penalty on fatigue (cutting hurts gains).
- A forecast of risk: injury chance in % for the week, so the dashed line means something.
- Mood: a Rest morning with a social/other option, and what the fighter wants (a want card).
- Week-to-week carry: Monday's load from last week is shown only as the tank start (38); show acute vs usual load (pack: ratio 1.5+ raises injury risk 2-4x).
Useless or weak:
- Quick-set text "Mornings: All L, All N, All H | gains L x0.6 N x1.0 H x1.3" - tiny, should be three buttons with a tooltip.
- "Last week" and "Coach's week" and "Clear" and "Undo": four buttons; "Clear" and "Last week" are rarely needed. Keep Undo and Coach's week.
- The round icon plus the comic picture plus the card title triple-state each session.
- Strength, Neck, Slip rope in the strip but no explanation of what Strength/Neck do (Chin shows only in the strip).
- Header goal bar for Stamina is already met by the default; no decision.
- Good Mood and Weekly card text in the header duplicate the right column.

## To reach 10/10 (most important first)
1. Make the picture carry the meaning. Each session gets one big icon colour-coded by the stat it trains (the same colour as that stat's bar on the right), and the card text shrinks to the name plus the gain number. A player should read "red = power, blue = speed" with no text.
2. Fix the logic: injury line = the real rule (80, x3, or change the rule and the pack), the check-hook sequence, the slip 2-3 line / 5 weapons text, Footwork bar, one dated weight number with a margin band.
3. Replace the WIN-tag arithmetic with one rule that is visible: hover any card to see "this card +X because...". Zero and "In Wed" tags need a reason text or a greyed card.
4. Make the fatigue tank the hero of the board: larger, named bands (Fresh / Working / Tired / Overreached), the real threshold line, the effect printed on it ("gains x0.6, injury x3 above 80"), and a risk % for the week.
5. Strip the right column to three things: the clicked card, the week builds, and the one danger (weight or fatigue). Move weekly card, diet and week load to a drawer or the header.
6. Give the week a real second axis: one decision with a price (hire a sparring partner for $, physio for a night, a harder cut for a gain). Add the coach's "one change" button.
7. Show the opponent: a small panel of their three traits and which of my sessions counters each. Film then has a visible payoff.
8. For four fighters: show coach pad nights left and a fighter switcher at the top; the contest for the coach is the best decision in the game.
9. Cut text: no 9 px text anywhere; the minimum is 14 px at 1920x1080. Remove the hint line, the quick-set formula and the double icon.
10. Light/Normal/Hard as a three-notch slider on the card with the colour of the tank changing live when moved.

## My 10/10 layout, 1920x1080, panel by panel
- Top bar (0-60 px): gym, date, money, big pulsing CONTINUE. Nothing else.
- Fighter strip (60-160 px): portrait, name (header only), weight with date, next bout and days, one WIN dial (big, with the coach's number struck out), mood face. Goal as one bar with the coach's suggestion.
- Left rail (0-300 px wide, 160-1020): the opponent card: face, three traits, what to train against, and film tells found. Under it the coach: pad nights left this week across the four fighters.
- Centre board (300-1500 px wide, 160-780): seven columns. Each column: a day name, a big morning picture card (square, 170 px) with stat colour and a three-notch Light/Normal/Hard slider; an evening card the same size; under them one fatigue column (a thermometer) with the named bands and the danger line. Gain number only on each card (+0.3). Sunday evening drawn as a locked padlock card.
- Under the board (780-920 px): the fatigue forecast strip: week risk % for injury, weight forecast at weigh-in with a band, WIN dial change when a card is dragged. One live sentence: "Dragging sparring here: injury risk 9% -> 17%."
- Sessions tray (920-1060 px): large round icons in two groups (Mornings | Evenings), name under each, stat colour ring, flame count. Hover shows the numbers.
- Right column (1500-1920 px): top, the clicked card with a picture, "what it does on fight night" in one line and "what it gives up" in one line. Middle, builds: four stat bars with the gain hatched, moves as rings. Bottom, the coach's one change with a Do it button. Weekly card, diet and week load sit in a drawer opened from the header.
- Every number appears once; every card hover gives the reason for its WIN points.
