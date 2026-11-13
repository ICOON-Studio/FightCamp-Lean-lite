# Training screen (game B), fresh critic, S454

Read: brief B, CRITIC_PACK, the picture, and grep of WeekPlan / Attrs / InjuryRoll.

## 1. Logic check
- WEIGHT LIMIT. The header says "65 kg" and the diet strip says "64.98 limit 65.0". The fighter is a man (Kwame). The pack gives men's limits 57.5 / 60 / 70 / 75; 65.0 is a women's class. Either the fighter or the limit is wrong. Also 65.9 -> 64.98 is only a 0.9 kg fall in a week, so the "Cut" switch is carrying it; fine, but "65 kg" in the header and "65.9 now" disagree (one is class, one is weight; label it).
- THE TANK LIES ON A PREVIEW. Saturday's tank reads 61 while the warning on the card says "Fatigue 61 -> 77". The tank should show the dragged result (77, over the 76 line) while the card is held, else the number you read is the wrong one. The hatched band hints at it but the big figure contradicts the warning.
- "Injury risk x2" at the dashed line (76) agrees with InjuryRoll (x1 to 72, x2 at 76, x3 at overreach 80). But from 80 the game also cuts gains x0.6 and risk x3; the screen shows only x2, so the real cliff (80) is not drawn.
- WEEK LOAD says "peak 66 Thu"; the tanks agree (66 on Thu). OK. "injury 1.0 in 100" matches the ~1.3% base order. OK.
- Check hook numbers: Mon pads 12 -> 21, Wed card 21 -> 32 "with Fri", Fri card 25 -> 32. Wed would have to take 21 -> 25 alone, and the right panel says Wed's gain is 21 -> 32 in total. The Wed card mixes its own gain with Friday's. Confusing: say "Wed: 21 -> 25, Fri: 25 -> 32".
- Heavy bag / speed bag / strength show "Power" and "Hand speed" as what they grow. Attrs.gd SESSION_ATTRS names Strength and Explosiveness for the heavy bag (the 14-ability model). The screen uses the old 7-stat words. Pick one vocabulary; the right-hand bars use the old words too, so the screen is at least self-consistent, but it will clash with the profile.
- The "In Wed" tag on Friday evening and "Gives up: the 1-2-3 waits one more night" are not explained; "In Wed" is jargon for "this is already counted in Wednesday's gain".
- Names outside the header: none seen (opponent is "the opponent", "Film the opponent"). Pass. "Coach's week 48%" is fine.
- Nothing impossible by the rules: pad work lands Sunday, last pad week before a Saturday bout (fight week is taper, no pads), consistent with the pack.

## 2. AS A GAME: 6 / 10
Good: it is a real board. Seven days of picture cards, a fatigue tank per day, a win dial that moves, a dashed risk line, dragging a session onto a day with a warning before the drop. That is closer to Motorsport Manager's setup plus Football Manager's weekly grid than anything before, and the pictures make each card readable at a glance. The fatigue meter and the live win dial are what the owner asked for.
Bad:
- Five seconds test: I can see "seven days, two cards each, drag from below". I cannot see in five seconds what the goal of the week is. The dial says 55% but not what I should do to move it. Nothing says "this is the lever that matters most".
- Still text heavy where it counts: the right column has 20+ lines of small type; the cards carry tiny chips (N/L/H, flame, tag, "YOURS"). At 1920 the 11 px labels will not read on a laptop.
- Art is generic: the same boxer-in-gym generation on every morning card; the eight morning pictures look alike, so the picture does not tell sessions apart as well as the title does. Evening pad cards are nearly identical.
- Morning cards show an arrow and a flame but not the size of the gain in plain terms except a tiny green tag (+0.2). A player cannot tell "heavy bag +0.1 Power" from "roadwork +0.2 Stamina" as better or worse, because the tags are all 0.1-0.3 and the win dial moves in units of "points" that are never explained.
- The weekly card, diet, load dial and builds are stacked in a side column in the same weight as the board; no hierarchy between the decision (the board) and the report (the builds).
Versus: Football Manager is worse (all tables); Punch Club is more tactile and has bigger icons; Motorsport Manager has a clearer single "pit-stop strategy" focal shape; Two Point reads better because everything has one big icon and one number. This is above FM and about Boxing Manager's level, below Two Point.

## 3. DEPTH: 6 / 10
Real trade-offs exist: Hard vs Light per morning against the tank; sparring now (Ring IQ) against injury risk x2 a week before the bout; film ($75, opens a tell) against pads; the Cut switch against fatigue; Fire back vs Stay quiet on the weekly card. The pad split 50/50 trades one combination against another, and "the 1-2-3 waits one more night" is a good cost line.
But there is mostly one right plan:
- The win dial gives one number to optimise. Coach's week 48%, yours 55%: the player will just push the dial up. Nothing makes a "worse for the dial" choice worth it (e.g. save a hand, keep a prospect fresh for the next bout).
- Only one fight matters (Saturday 28). No cost beyond it: this week's fatigue does not carry into the camp after the bout, the mood, the next goal, or the second boxer. The roster is four fighters, but this screen is one fighter with no pad-night sharing across fighters (still not built).
- Injury risk is a single threshold line; no "risk of what" (hand, cut, head) as the Gauges rules already compute (three pips).
- No uncertainty: all gains show exact numbers (+3.5, 29 -> 32). A coach would give a range and a confidence; the surprise on Monday is the game.

## 4. Options
Missing:
1. A "Goal of the week" pick that re-sorts the cards (Peak for the bout / Build base / Recover / Learn a move). Changes which cards get highlighted and what the dial means.
2. Per-day "what moves the dial most" hint: a star on the best open slot (e.g. "Sat evening Sparring +4 but x2 risk").
3. Hand and cut risk pips (Gauges.gd) on sparring and hard bag, instead of one line.
4. Rest of the carry-over: fatigue on Sunday night against the bout week (taper) shown as a small tank at the end of the board.
5. Compare coach vs yours per card (a ghost of the coach's choice on changed cards).
6. Weight forecast per day on the tank strip (cut costs fatigue: tie the two).
7. For two fighters in camp: the shared pad night cost (agreed, not built).
Useless or weak:
- "Last week" button (what does it do beside Coach's week? show it only when last week differs).
- Both "Undo" and "Clear" on the same strip is fine, but the three text buttons are low priority; fold under a menu.
- The tiny N/L/H lever on every morning: three buttons x six cards = 18 targets, most never touched. One tap on the card cycling L/N/H with a big flame count is faster.
- The weekly card inside this screen when it has no link to training (Fire back / Stay quiet): put it as a flag on Home, not here.
- "Mood Good" in the header: not actionable here.

## To reach 10/10 (most important first)
1. Give the screen one focal question: a "WEEK GOAL" chip row at the top (Peak for the bout, Build, Recover) that decides what the dial counts, and shows the dial's tradeoff, not just its height. A 10 has "55% to win" plus "+4 if you take the risk on Saturday".
2. Make every card a decision at a glance: one big icon per session (a different silhouette: running shoe, bag, rope, dumbbell, ring), the gain as a large coloured +value, flames as a fill bar, not tiny glyphs. Cut text on the cards to a title and one number.
3. Fix the logic: the tank shows the preview number (77) while dragging; draw the 80 cliff (gains x0.6, risk x3) beside the 76 line; correct the men's weight limit; split the Check-hook gains per night.
4. Put hand / cut / head risk pips on sparring and heavy-bag cards (from Gauges.gd) and make the cost of a risk visible beyond the fight week (injury layoff days).
5. Show uncertainty and carry-over: gains as a range with the coach's confidence, and a small "after the bout" strip: fatigue, mood, next goal so this week's choice reaches the next one.
6. Reduce right-column text: one headline card (what this session does on fight night), a stats mini-chart, and move the weekly card and diet out. Minimum 14 px type.
7. Show the coach's plan as a ghost on changed cards so "YOURS" means better or worse by how much.
8. Sharing: with two fighters in camp show the pad-night split (agreed, not built; needs the two-camp rule).
9. A reveal on CONTINUE: the week plays as a seven-day strip, tanks rising, gain popping (a short moment, not a modal).
10. Varied art: individual illustrated cards per session instead of the same gym model; evening cards need distinct pictures for Pads vs Sparring vs Film.

## My 10/10 layout, 1920x1080
- Top strip (0-90 px): left, fighter portrait, name, weight class, record. Centre, the bout poster: opponent face, date, countdown, LAST PAD WEEK badge. Right, the big pulsing CONTINUE. Cash and date in the shell bar above.
- WEEK GOAL row (90-170 px, full width): three large chips (Peak for the bout / Build / Recover) with a small icon; the chosen chip tints the board. At right, the WIN dial big (140 px) with "coach's week 48 -> yours 55" and a one-line "+4 if you spar Saturday (risk x2)".
- Board (170-720 px, x 0-1300): seven columns, 170 px wide. Each column: day name and date; a morning card with a large unique session icon, the session name, a +value in big green, a flame bar of three slots and one big cycling L/N/H button; an evening card of the same shape (pads show the punch ring filling to 30, sparring shows three risk pips: cut, hand, head). Under each day, the fatigue tank, 120 px tall, number big, dashed line at 76 and a red line at 80, the preview fill drawn as a hatched overlay with the new number. Under the board, a narrow Sunday-night strip "after the bout: fatigue 20, mood +10".
- Right column (x 1320-1920, 170-720 px): top, the selected card in large (picture 560x200, "on fight night" line, "what it gives up" line, split 50/50). Below, "this week builds": six stat bars with the gain hatched and the fight-night effect word. Below that, move rings (4 across) with the word ladder.
- Bottom tray (730-1000 px): SESSIONS as 12 picture cards 150 px wide, draggable, with a divider mornings | evenings; hover shows numbers at Light, Normal, Hard in a chart.
- Bottom bar (1000-1080 px): weight now / on the day against the limit with the Hold / Cut switch; Week load dial; Undo, Coach's week, Clear as three small buttons at left.
- The weekly card is a flag on Home and a toast, not a panel here.
