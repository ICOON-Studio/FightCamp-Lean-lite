# TRAINGAME critic S454 - Claude (fresh critic) - Training screen, training_game_a.png

Read: the brief, CRITIC_PACK (whole), CRITIC_ACCESS (skimmed), the picture, Attrs.gd SESSION_ATTRS.

## Scores
- AS A GAME: **6 / 10**
- DEPTH: **6 / 10**

## 1. Logic check (things that contradict or the game could not do)
1. **Weight class contradiction.** Header says "Welter 69 kg". The weight panel says "limit 65.0 kg". One fighter cannot have two limits.
   (Pack: men's classes are 57.5 / 60 / 70 / 75; neither number is a class.) Fix one of them.
2. **Stamina gain does not add up.** Morning cards: Roadwork +0.22 (Mon), Intervals +0.27 (Wed), Roadwork +0.22 (Fri), Intervals +0.27 (Sat) = +0.98.
   The right panel says Stamina +2.2 and the goal bar says 57.9 -> 60.1. The goal line (the thing the player cares about) is more than twice
   what the cards promise. Either the cards or the panel is wrong. Same check on the others: Power +0.10 and Hand speed +0.09 -> +0.1 are fine.
3. **Injury risk is two different numbers.** Fatigue chart label: "INJURY RISK x3" (matches the pack: overreached from 80, risk x3). The intensity
   text says Hard "injury x2 a week before the bout". Also Hard peaks at 79, which is under the 80 line where risk x3 starts, so why any
   injury penalty at all. The chart also draws "gains slow down" at about 72 while the pack says gains x0.6 start at 80. Pick one threshold.
4. **Two intensity controls that fight each other.** Every morning card has its own L / N / H (Thu is L, Sat is H) and the week also has a
   whole-week Light / Normal / Hard with "Normal" lit. If Sat is Hard and Thu is Light, what is "Normal" for the week? The pack says per-session
   levels exist; a week-wide switch is not in the code. A week switch is a good idea (set all, then tweak) but it must show "Mixed" when days differ
   and must say it sets every day.
5. **The WIN dial is not believable against the stat numbers.** The three changes are worth +7 points of win chance, yet the stat gains are +0.1 to +0.2
   (the pack: 5 stat points = 72% win, so 0.2 is about 1 point). The only thing that can move the dial that much is a move crossing 30 (a weapon). That may be
   true, but then the dial is a cliff, not training, and the screen does not say so. Also unclear whether 55% already includes the card being dragged
   (the right panel already shows Body hook 29 -> 32 "Usable Wed", so yes; the YOURS count is 3 without it). State what the dial includes.
6. **The hover card hides the answer.** The Wed hover card sits on Fri evening, Sat evening and Sun evening, so the player cannot see the rest of the
   evening row (is there a pad on Sunday? "the pads land Sunday night"). Place hover cards outside the week grid.
7. **Sparring sits in the Mornings tab** of the tray (card says "evening"). Evening cards should be on the Evenings tab only.
8. **Film overtime "$75".** The pack has tape study free in camp and a sessional coach at $450 a week; an overtime fee per film night is not established
   in the pack. If real, it is the only place a session costs money and should be on the tray card too.
9. **Week number.** Day 0 = Mon 5 Jan; Mon 16 Feb is day 42, which is week 8 if the first week is week 1. The top bar says Week 7. Check the counting.
10. **Phase.** 12 days before a bout is PEAK (hardest, sparring twice). The screen shows one sparring night and does not name the phase. The player does not
    learn that the coach's week follows a phase, or that next week is the taper.
11. **"Last pad week before the bout"** with a Saturday bout and Sunday-night pads: fine, but the fatigue chart shows only this week, then "fight night 36";
    where the 36 comes from (taper week) is not shown.
12. **Names:** none found outside the header (coach quote has no name, hover says "the opponent"/no name). Good. "His goal", "he can throw it" use "he": the pack says
    sandbox, never a fixed he/she (S412). Use "the fighter" or follow the fighter's gender in text.
13. **Things the game does that the screen leaves out:** the coach's quality (training runs at 60% with no coach, 0.5 + rating x 0.7 otherwise); the weekly twist
    card with its two priced answers; training-load spikes (acute vs usual load, risk x2-4); injury/condition state; morale; the 50/50, 70/30, 30/70 split
    of a pad night; slip rope and neck work (the tray has no Defence or Durability session at all, so those two cannot be trained from this screen).

## 2. AS A GAME (6)
Good: the week is a picture you fill by dragging, the day columns are readable, the WIN dial answers "does it matter", the fatigue curve is a real
meter, the hover that prices a change (+3.5, what it gives up) is the best idea on the screen, and YOURS stamps show what you changed against the coach.
It is much closer to a game than an info sheet.

Why not 7+:
- Five-second test fails. Where do I start? The eye lands on the header (four panels of text), not on the week. The tray is far left, the intensity is far bottom
  right, the effect of both is in the right panel. Three places to look for one decision.
- Still text-heavy. Roughly 70% of the surface is small type (card labels, "+0.22 Stamina", "gains x0.6", the footer legend, the three-line intensity paragraph,
  the coach quote). A game screen says it with shapes and colour: pips, bars, icons. "+0.22" means nothing to a player; "one pip of a five-pip bar" does.
- Art is stock-like and repeats: Roadwork, Rest and Intervals reuse the same two photos; a card says nothing at 140 px wide. The picture of the fighter is a
  head crop; the screen has no body, no gym, no coach. Compare: Punch Club shows the fighter doing the thing; Football Manager shows a coloured grid with
  clear traffic-light cells; Motorsport Manager shows a few big levers with a car that changes; Two Point shows the room.
- The two big meters the owner asked for exist (fatigue, intensity) but intensity is three buttons plus a paragraph, not a meter; fatigue is a chart you read
  rather than a gauge you feel.
- The right panel is a sheet (stat rows, rings, weight line, quote): it is the "info" half. It could be the fighter standing in the gym with the changing
  parts lit up.
Would I enjoy planning a week here? Yes, for the drag-and-see-the-dial loop. Not yet for ten minutes at a time.

## 3. DEPTH (6)
Real trade-offs: Hard vs fatigue peak; sparring Thursday tires Friday's pads (the coach quote shows it); film night gives up a pad night; diet Cut vs fatigue; a
Hard morning before the weigh-in week. Those change with the bout date and the fighter. Good.

Why not 7+: there is one right plan. The dial is dominated by getting moves past 30 before the bout (the pad ring to 30). The stat gains are tiny (+0.1 to
+0.2), so mornings barely move the dial; the player will drag pads to the threshold, keep fatigue under the line, set Cut if over weight, and be done. The mornings
are almost decoration: nothing in the picture makes the player choose Roadwork over Heavy bag except a goal bar. Nothing is at risk: no injury chance shown as
a number the player gambles with, no twist card, no partner choice, no opponent-specific reason to pick one drill over another (Film opens a tell, but the pads
do not say "this answers what he does"). A good week needs 2-3 pulls that disagree: goal vs the bout, fatigue vs gains, weight vs strength, one fighter's pads vs
another's (the pack says two fighters share the coach's pad nights - AGREED, NOT BUILT, and the screen is silent on it).

## 4. Options: missing, useless
Missing (what each would change):
- Slip rope / neck work / mobility sessions in the tray: lets the player train Defence and Durability (right now a defence-weak fighter cannot fix it here).
- Twist card (sore wrist, partner ill, rain) with two priced answers: the weekly surprise; forces a replan.
- Opponent link: a strip "he: presses, loads up, tires" with each pad card tagged "answers this" (the Why and the tape need the same thread).
- Sparring partner choice and sparring intensity (injury risk is real, 1.3% a week base).
- Pad night split (50/50, 70/30, 30/70) - the pack's real choice inside a night.
- Injury-risk number this week as a gauge (training load spike), not only the fatigue curve.
- Coach / staff effect: which coach runs it and what he adds (pad rating, conditioning rating); the biggest lever the player buys.
- Phase tag (BASE / BUILD / PEAK / TAPER) and next week's taper, so the player sees why the coach put what he put.
- Undo exists; "Coach's week" exists; add "Copy to next week" and a Save-as plan for repeat weeks (Football Manager does this).
Useless or weak:
- The per-card "+0.22 Stamina" numbers on every morning card (same on every card, shown 7 times). Replace with a small pip bar; show the number on hover.
- The footer legend text (small, always on).
- The three-line intensity paragraph: one coloured line is enough, the rest on hover.
- The weight line chart at this size (a line with two numbers); a bar with a limit marker says the same faster.
- The coach's quote avatar line is good, but the quote text repeats what the Fri pad card already shows; make it a button that highlights the cards it talks about.
- The "Mood good" chip: no action behind it here.

## To reach 10/10 (most important first)
1. Fix the numbers so every figure on the screen adds up (Stamina +2.2 vs +0.98; Welter 69 vs limit 65.0; injury x3 vs x2; 72 vs 80). A critic or the owner will find one in a minute.
2. Make the week the hero: the 7-day board takes about 60% of the width and 60% of the height; the tray becomes a slim strip directly above or below it, not a far-left column;
   the header drops to one slim line (fighter, bout countdown, WIN dial). One place to look first.
3. Replace numbers with shapes: each session card shows 1-3 coloured pips for what it grows and flame pips for fatigue; intensity as a three-notch slider on the card;
   whole-week intensity as one big dial that reads Light / Mixed / Normal / Hard. Numbers only on hover.
4. Make fatigue and injury risk live gauges, not charts: a vertical tank per day under each column that fills as the cards drop (green, amber at the gain-slowdown line,
   red at the injury line), animated. Add one injury-risk meter for the week with the number the player is gambling with.
5. Turn the mornings into choices that matter: tie each session to the bout (what the opponent does) or to the goal, show the dial change when a card is dragged for every
   card (not only pads), and add one weekly twist card with two priced answers. Give two-fighter coach sharing its own row when it applies.
6. Real art that changes: a fighter in the gym who plays the session that is being hovered (Punch Club logic); each session has its own picture, no repeats; the
   fighter's body shows tiredness and the weight.
7. Add the missing levers: slip rope, neck, mobility; pad-night split; sparring partner; coach quality; phase tag; copy / save the plan.
8. Never cover the board with a hover card; dock it to the right panel (it replaces "What this week builds" while dragging, and returns after).
9. Remove the fixed he/she and the text legend; keep every sentence under 10 words.

## My 10/10 layout, 1920x1080, panel by panel
- **Top bar (0-56 px):** shell (gym, date, week, cash, CONTINUE as the one pulsing button).
- **Header strip (56-150 px), one line:** left portrait (small) + name + weight class + condition + mood; centre the bout card with a big countdown ("12 days", opponent name in
  this header only) and a phase tag PEAK; right the WIN dial (big, 120 px) with the coach's % struck through and "+7 yours".
- **Week board (150-720 px, x 20-1480):** seven columns. Each column = day name, a morning slot (card 190x150 with a full picture, one name, pip bar for gain, flame pips for
  fatigue, a three-notch intensity lever) and an evening slot (picture, move ring to 30, partner chip). Under every column a vertical fatigue tank (60 px) that fills live. The
  bout day (Sat 28 / weigh-in Fri 27) is marked on a mini timeline over the columns, so the player sees next week's taper. A drag shows a ghost card and a floating pill on the
  WIN dial, not a big box.
- **Tray (720-900 px, x 20-1480):** one horizontal strip, two rows (Mornings: roadwork, intervals, heavy bag, speed bag, slip rope, shadow, strength, neck, mobility, rest;
  Evenings: pads moves and combinations, sparring, film, rest). Each card 130x120, picture and pips. Pin and "drill it" work as now. Hover docks its card into the right panel.
- **Week meters (900-1060 px, x 20-1480):** left, WEEK INTENSITY big three-notch dial (Light / Mixed / Normal / Hard, one coloured line of consequence); centre, INJURY RISK gauge
  with the number this week and the base; right, WEIGHT bar with the limit marker, Hold / Cut switch and the forecast for the weigh-in day.
- **Right panel (x 1500-1900, 150-1060 px):** "THE FIGHTER" - a body figure in the gym with the trained parts lit; under it the stat bars with this week's gain hatched and the goal
  marker; the moves as rings to 30; the coach's suggestion as a button that highlights the cards it means; below it the twist card with two priced answers. While a card is dragged,
  the panel switches to that card's price (win dial change, what it gives up, fatigue peak) and returns after the drop.
- **Colour:** only risk is coloured (green, amber, red); gains are blue; the player's own changes carry a gold YOURS corner. No names outside the header.
