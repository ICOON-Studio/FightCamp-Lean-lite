# Week design v1 - sim-vet critic (S425)

Lens: Football Manager / Motorsport Manager / Two Point. Question: linked decisions all career, or chores by week 3?
Read: brief, CRITIC_PACK (first 150 lines), WEEK_DESIGN_V1, week_v1.png/html. Not read: CRITIC_ACCESS, s419/s416 look refs.

## 1. Two weeks played
CAMP WEEK (Lucy 19 days out, Danny Flat)
- Mon: twist card (priced pair, coach default exists), lay Reid's three evenings, sparring night (partner, intensity, line),
  Danny's offer. Real decisions: the lay and the sparring line. Twist card and the offer are the old game's cards.
- Tue: NOTHING. Wed: a tell opens (a flag, no stop), sparring happens (watching, no input). Nothing to do.
- Thu: stop, report, two changes of four. The best day of the week. Real if the report differs each time.
- Fri: Danny's offer (answer by Fri; the card prices it). Sat, Sun: NOTHING, stated outright.
- Dead days: Tue, Wed, Sat, Sun = 4 of 7. The week has two decision days. "Things to do" is Monday plus Thursday.
- Auto-button from week 3: Reid's lay (his default is the nearer bell; a rich one-boxer club never overrides), the
  sparring intensity (Working is the standard), the twist card (coach pick), Danny's offer when Flat.
QUIET WEEK
- Mon: same lay without a bell: sharpen a back-up, newcomers, or an eye. Thu fires "only on news": the design's own
  measurement says it may fire in over half the quiet weeks or never. A quiet week is Monday plus a coin-flip Thursday.
  The player's win condition is "ask for a fight", a button, with the reason coming back. That is a form, not play.

## 2. Is each decision real?
- Pads on a missing answer vs back-up vs sharpening: REAL, but only while a bell is near AND an opponent is scouted. With
  one boxer in camp the option set collapses to "the nearer bell" = CHORE.
- Eye on sparring: DEAD as a choice. Eye on, you get the report; eye off, you lose it. Always right in camp. Only in
  the last pad week is it wrong, and there the taper rule already forbids pads. It reads as a toggle, not a fork.
- Newcomers' evening: ALWAYS WRONG in camp (a card slips), ALWAYS RIGHT in a quiet week (nothing else to spend on).
  Two modes, no tension inside either. The invented "4 of 6 stay" is a lottery shown as a price.
- Half and half: right only for two single moves; the design itself says wrong for combos. Almost never right = DEAD.
- Class off (-$115): a cash tax. Right when cash is fine, always. Not a decision, a bill.
- Clubmate / other camper / visitor $160: the visitor is right only when the opponent's style is known, and then it is
  always right if you can pay $160. Clubmate vs camper: a calendar test (bell over 10 days). Rule-lookups, not choices.
- Technical / Working / Hard: Technical for tired, Hard 2-3 weeks out against a presser, Working otherwise. The right
  setting is printed in the design. Solved by reading one table. CHORE after week 2.
- Show or hold a line: the best idea in the design (a bigger night in sight). REAL, but its size rests on an invented
  rule and "hold costs 2 to 14 wins in 100" is a price, not a fork, until the regional is scheduled.
- Swap to the back-up in the corner: REAL only if the read rule gives points back. Today it gives zero. It is a stated link.
- Two Thursday changes of four: they are priced but the report names which one is right. If the report names the weapon,
  you change the arrow. That is a lookup the report solves. REAL only when two reports disagree with the scale.
- The chain: Mon lay -> Wed report -> Thu change -> Fri evening -> fight -> seen record -> next card. The weeks-link
  to the career is only a "?" on the card until the opponent is scouted. The chain is on paper; two of its links
  (seen -> next card; promise -> next camp) are text.

## 3. Anticipation and reward
- Thursday report: real anticipation, once the report text varies (needs 40+ varied lines or it is a template by week 6).
- Next Monday: "landed / late / surprise and why" is good, but it is a read-back of what you already knew.
- Fight night: the corner note "Kovacs's corner is waiting for the Jab-Jab" is a real moment, if the swap pays.
- Season: nothing. No season beat in the design; the Road ticks are the only long thread.
- Reward is mostly a bigger or greener number (green board, 3 of 4, 4 of 6 stay). The two rewards that open a new choice:
  the HOUSE LINE (frees back-up evenings) and a found prospect. Everything else is a tick. A Football Manager veteran wants
  the reward to be a new problem, and only the house line is one.

## 4. What rests on invented numbers
The one that collapses it: "a seen line is waited for from the first bell, -6.5 points, and a drilled back-up wins part
of it back." Today a swap wins nothing back. If measurements 1 and 2 fail, the film on you is only marks on a page, the
sparring report loses its purpose (what is a report for, if the plan's answer to a tell does not bite?), the hold/show
fork dies, the back-up claim (Friday's first card) loses its stake, and the evening pool shrinks to pads versus newcomers.
What is left: a week board of dated things, a Thursday news stop, a four-price offer card. A sound dashboard, not depth.
Second weakest: "two changes" and "Thursday" are invented and the stop fires only on news, so the loop's rhythm is a guess.

## 5. Wired and shown
- Right places: Training (one editor, two doors), Playbook (seen/held/back-up), Fights (four prices).
- Hard for a player to find: "feels second" and the promise live on Overview, but the cause is a lay done weeks ago.
- Shown but not actionable: the readiness line ("Lucy owns 3 of 4") on Fights is a number, not a button; the rival file's
  "what each rival has seen" has no act until the player can pick whom to fight by it. The corner eye icon is read-only.
- Nothing yet on Club > Gym. Fine.

## 6. The screen, element by element
- Nav + date chips: KEEP. "1 late" needs a reason on it (the scale), CHANGE.
- Week board (7 columns x 3 rows): KEEP as the spine. CHANGE: Sat/Sun and half the Reid row are hatched dead stripes,
  so it reads as an empty calendar; give the dead cells a word (Off, Class) or collapse them. The Thursday dashed column
  is the right idea. "?" on Friday is clear.
- Chips "3 evenings", "19 days" (twice), "Flat - no Reid 2 wks": KEEP the first; CUT the duplicates (19 days is on three boards).
- Reid's Friday board (three claims): KEEP. CHANGE: the cost line "Danny Low: 70%" and "Both wait" are words; give each
  claim a bar for gain and a bar for loss, the same scale. One slot, three claims, no hidden claim = the best part.
- Danny's offer board: CHANGE. Four tiles (85% Flat / 2 of 4 by taper / 1-2 seen / 0 wks clash) need a manual: "1-2 seen"
  and "0 wks clash" are not game words. Say "He knows Jab-Jab" and "no camp clash."
- Thursday call board: CHANGE. It repeats Lucy's row (Report, Tell, +0.4 kg) and shows two empty slots "1 2" and four
  small icons, "2 changes". Which changes? Unreadable at five seconds. Cut the repeat, name the three changes.
- Sparring Wed board: KEEP the three faces and three weights. CUT "Technical/Working/Hard" as a default row; show it only
  when the player changes it. "Step back" and "Reid watches" chips are info the player cannot act on = CUT or make buttons.
- Lucy's plan board: CHANGE. The mini bars with a marker and chips "Seen / Fri? / Unseen / Held" are a table of label and
  value that needs a manual. "Held" with a lock is not a word a player has met.
- Bell box + Start week: KEEP. "taper in 12" is good.
- Too much for one screen: yes. Seven boards, 19+ chips, ~12 faces. Hard fails: label that needs a manual (Held, Seen,
  Unseen, clash, "Fri ?"), and a table of label and value rows (the plan board). Look capped at 4.

## 7. Scores (0 to 10)
look 4 | clarity in five seconds 4 | depth 5 | things to do in a week 5 | anticipation 6 | reward for playing on 4

## 8. To reach 10/10 (most important first)
1. Give the film-on-you a way back that exists today, not a measured one. Make the wait symmetric: a seen line that is
   waited for is a trap the player can bait (show a decoy line in bout 1, hold the real one). Then the player is the
   one outthinking a reading corner, which is the idea, and it no longer rests on one invented swap.
2. Make Thursday always a fork with a real stake, not "only on news": one binding change each week that moves a stake
   shown on Monday (the weight, the back-up, the Friday slot). A fixed day beats a rare one for rhythm.
3. Make the lay un-automatable: every claim carries a cost in a thing that matters LATER (a Flat boxer's 3rd week, a
   member leaving, a card slipping past taper), shown on one scale, and let one claim cost a future week (a promise).
4. Add a season beat: the regional draw, a rival's film on you, a house line to earn. Something to look forward to
   beyond next Thursday, and something that opens a NEW choice when it lands.
5. Cut the Home to four boards: week board, the Friday fork, the fight card, Start week. Move offer, sparring picks
   and plan marks into drawers on the cell you click.
6. Rename every label to game words; no label that needs a manual (Seen/Held/Unseen -> "He knows it", "Saved for the big night").
7. Fill Tue, Wed, Sat, Sun with one live thing each: a mid-week scale check, a tell to pick up, a member who asks for a word,
   an offer that lapses. A day with no ask is not a day.
8. Make the report varied: 40+ reports keyed to the line, the partner and the habit, so Thursday is not a template by week 6.
