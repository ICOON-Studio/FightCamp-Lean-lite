# Training tab, approach B: what is displayed and how (S419)

Operator: "the B approach seems good , what do you think", then "i want the screen reveiewed by critics and you and decide what should be displayed and how".
Screen: docs/mockups/s419/training_b.png (layout), training_b_painted_ludo.png (look). Brief the critics got: ops/research/TRAINING_B_CRITIC_BRIEF_S419.md.

## 1. Claude's own read (written before the critics' reports were opened)

What B gets right: one tiredness picture for the week, drawn once; the choice being made is big (one day open); every option shows its cost before the click (the three intensity steps each carry tiredness and gain); pad minutes are a visible split, not a number field.

Element by element:

| Element | Verdict | Why / how |
|---|---|---|
| Seven day tiles, two icons each | KEEP | The whole week at a glance, and the way to pick a day. |
| Intensity pips under the morning icon | KEEP | Hard and easy days read as a rhythm across the strip. |
| Drill dots under the evening icon | CHANGE | Three anonymous dots say nothing. Show the count only when it is a pad night, or drop them. |
| Tiredness curve, the 80 line, the peak number | KEEP, CHANGE | The curve is the screen's best part. Colour the day tile's edge when its point is over the line, so the eye lands on the day to fix, not on a number in the middle of a graph. |
| Dotted preview line for the coach's change | KEEP | The consequence before the commit. Use the same dotted line for ANY hovered option, not only the coach's. |
| Intensity lever (Light, Normal, Hard) with two chips each | KEEP, CHANGE | Two chips per step are right. The emoji faces go; a flame for tiredness and the stat's own icon for the gain, so "+0.11" says of what. |
| Session row of nine icons | CHANGE | Nine unlabelled icons is a guessing game. Each needs the stat it trains as a colour or a letter, and the coach's best area marked (a session the coach is good at gains more: that is a real decision the screen hides). |
| Goal bar (Stamina 64.2 to 66, +0.44) | KEEP, CHANGE | Keep one goal, with the pace tick. Say whether the week is on pace by colour alone: the tick ahead of the fill = behind. |
| Evening type tiles (Pads, Sparring, Film, Rest) | KEEP, CHANGE | Add approach A's idea: each tile shows the peak tiredness it would cause (74, 82 in red, 62, 56). That is the decision in one number. |
| Minute split bar and minus / plus | KEEP | The split is the pad night's real choice. Drag on the bar; the buttons stay for the mouse-shy. |
| Drill card: name, the numbered punches, the tier chip, the mastery bar with ticks, now to after | KEEP, CUT | Keep the bar with the 30 / 60 / 85 ticks and "24 to 25.2". Cut the second "35 min" line: the split bar already says it. |
| The hand of drills | KEEP | Dealing a card in is the fun part. Show on each what it would gain tonight, and grey the ones held back by a prerequisite with the reason in the tooltip. |
| Coach bar: the change, the peak before and after, Do it, Leave | KEEP | One suggestion, its effect, one button. |
| Diet: Hold / Cut and the weight | KEEP only with a fight booked | Otherwise it is noise. |
| Start week | KEEP | One red button. |
| Top bar repeated inside the mockup (Home, Fighters, ...) | CUT | The game has one Gym button now (Q-160). |

Missing, and where it goes:
1. WHAT THE SESSION TRAINS: on the session icons and the open card (stat icon + colour). On this screen.
2. THE COACH'S AREAS: a small mark on sessions the coach is best at. On this screen. The detail stays on Club People.
3. DAYS TO THE FIGHT AND THE CAMP PHASE: the fight day is on the strip in a fight week; in other weeks a small "19" flag at the strip's right end. On this screen, as a flag, no words.
4. INJURY RISK FROM A LOAD SPIKE: it is the same story as tiredness for the player. Do not add a second meter; the 80 band carries it, and a spike week turns the band's edge red with a tooltip. On this screen, inside the curve.
5. MASTERY THAT FADES: a drill card in the hand that is fading gets a small down arrow. On this screen.
6. TWO BOXERS SHARING PAD NIGHTS: agreed, not built; out of this build, the layout must leave the room (the "75 min" becomes the boxer's share).
7. MONEY: not on this screen. The week costs nothing extra in the rules today.
8. COPY LAST WEEK / the coach's week: "Back to the coach's week" exists in the game today and B lost it. It must come back as one small button by the coach.

Useless today: the drill dots, the duplicated minutes line, the nav bar inside the page, the "Wed" caption under Roadwork (the gold tile already says which day).

My scores: look 6 (emoji, flat panels: the paint fixes most), clarity in five seconds 8, depth 7, fun of planning 7.

## 2. The critics (three, each read the game pack first, scored the look first, drew a 10/10)

Drawings: docs/mockups/s419/training_b_critic_newplayer.png, training_b_critic_simvet.png, training_b_critic_coach.png.

| | Look | Clear in 5 s | Depth | Fun |
|---|---|---|---|---|
| New player | 5 | 3 | 8 | 7 |
| Management-sim veteran | 6 | 7 | 6 | 5 |
| Boxing coach | 5 | 6 | 5 | 6 |
| Claude | 6 | 8 | 7 | 7 |

All three cap the look at 4 if the emoji ship. Claude's 8 for clarity was too kind: the new player's 3 is the honest read of a first hour.

Where all three agree (and Claude):
- KEEP the day strip, the tiredness curve with its line, the peak number, the three-step lever, the minute split, the hand of drills, the coach's one change, Start week.
- Every session must show which stat it trains (a colour).
- Days to the fight and the camp phase must be on the screen.
- A fading drill gets a mark; a drill that answers the opponent's known weakness gets a mark.
- Paint every icon; no emoji.
- Cut: the anonymous drill dots, the duplicated minutes, the "Wed" caption, the decimals nobody acts on.

What only one of them saw, and is right:
- COACH (the biggest miss): the week drawn in B peaks at 82 in FIGHT week and nothing warns. A fight week must look different: the phase lit on a ribbon (Base, Build, Peak, Taper, Fight), sparring greyed in a taper, the curve expected to fall. And a hard/easy bar on each day tile so "never two hard days in a row" is visible without a word.
- NEW PLAYER: the coach's change is the most important thing on the screen for a first-hour player and B hides it in the bottom strip. It goes to the top as the verdict, with one button.
- SIM VETERAN: without "copy last week" (and later saved week templates) planning is a chore by week ten; and the screen shows the cost (tiredness) but not what the plan buys, so two plans cannot be compared. A small "this week buys" block (the stats the week gains, against last week) fixes that.

Where they disagree, and the call:
- Decimals on the lever. New player and coach: replace with 1 to 3 bars. Veteran: the numbers are the trade-off. CALL: bars on the picture, the exact numbers in the tooltip and on the goal bar. The operator's rule is fewer numbers nobody acts on.
- A word under every icon (new player) against icons only. CALL: a word under the session and evening icons on the OPEN day only; the strip stays icons with a stat colour. Painted icons with a colour are readable; twelve captions in the strip is the text he asked to cut.
- An injury-risk gauge (veteran, coach) against one meter (new player, Claude). CALL: no second meter. The band on the curve turns red at the top and a load spike marks the day; the coach's change shows tiredness only. One picture for "too much".
- Money chip (veteran, coach). CALL: only when the week has a cost (an outside sparring partner, $160). Never "$0".
- Weight path on the curve (coach). CALL: yes, but only in a week with a weigh-in: a dotted line that ends on the scale mark. Otherwise absent.

## 3. Decision: what the Training tab shows, and how

Top to bottom:
1. PHASE RIBBON, top left: five arrow pieces (Base, Build, Peak, Taper, Fight), the current one lit, and a bell with the days to the fight. No fight booked: the ribbon is absent.
2. THE COACH'S VERDICT, top, full width: the coach's face, one line of at most six words ("Wednesday is too much"), the before and after on a small tiredness mark (82 to 74), one green button "Do it", one small "Coach's week" (back to the coach's plan) and "Last week" (copy). This replaces B's bottom bar.
3. THE WEEK: seven day tiles with painted icons, each tile edged in the colour of the stat its morning trains, a hard/easy bar under it (green, amber, red), the fight on its real day. Under the strip ONE tiredness curve: a red band named by its colour, the peak tagged only where it crosses, last week as a faint line, a dotted line for whatever option is under the mouse. In a week with a weigh-in, the dotted weight path ending on the scale.
4. THE OPEN DAY, left: the session's painted icon and name, three big buttons Light, Normal, Hard, each with two small bars (gain, tiredness); the sessions as a named picker of nine painted tiles, each with its stat colour and a small star where the coach is strong.
5. THE OPEN EVENING, right: four tiles (Pads, Sparring, Film, Rest) each with the peak it would cause; Sparring red-edged, and greyed with a bell in a taper. A pad night: the minute split bar (drag, with snap points), drill cards with one gain number, the mastery bar with its ticks, a target mark when the drill answers a known weakness; the hand of drills below, fading ones marked.
6. BOTTOM STRIP: the goal bar (one stat, the pace tick, coloured by on pace or behind), "this week buys" as four small stat bars against last week, the diet (Hold, Cut) only with a fight booked, and Start week, red, far right.

Not on this screen: the coach's ratings (Club People), the opponent's file (Fight prep), money unless the week costs some, a second meter for injury.
Not in this build, but the layout leaves the room: two boxers sharing pad nights (the "75 min" becomes this boxer's share), saved week templates beside "Last week".
Rule changes this needs (so it is honest, not only drawn): none for items 1 to 6 except "Last week" (copy the previous week's plan), which is new and small.

Type: nothing under 20 px, acted-on numbers 26 px or more. Words: at most 70.
Next: one consolidated drawing of this decision, Ludo's paint of it, the operator's yes (Q-S294-166 is on the earlier drawing), then the Cursor brief.
