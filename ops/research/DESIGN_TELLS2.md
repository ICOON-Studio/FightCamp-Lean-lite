# DESIGN_TELLS2 - one body tell before each beat, version 2 (S563, from the ALLPLAY2 playtest)

Owner S563: "do you thinkwe should show opponents itentions like more draditional card games or it is fine the way it is ?
Can you have ziva and some other agents playtest the current version and provide feedback".
Status: DESIGN + words-only trial. Nothing of it is on the pages yet; a rule change is measured on the instrument first
(METHOD: the slice is balanced on the instrument, never by hand).

## 1. What the playtest said (ops/research/allplay2/<seat>/ALLPLAY2_<SEAT>.md)
| Seat | Bouts | Pick | Fun no tells / with tells | One line |
|---|---|---|---|---|
| Claude | 6 (3 + 3) | one body tell | 7 / 8 | "too true and too narrow": 50 of 54 tells true, the Jabber never lied |
| Arena | 6 (tells first) | one body tell, AND keep his last three beats | 6 / 8 | his punches landed 27 times blind, 17 with tells; never knocked down with tells, 3 times without |
| Ziva | 6 (tells first) | one body tell, with four fixes | 3 / 8 | "they are worth about 4 points a bout": 1 win 1 draw 1 loss with tells, three 26-30 losses without |
| Dola | 4 (tells first) | one body tell | 6 / 8 (depth 5 / 8) | "the fake tell must follow a consistent rhythm - never random"; a fake with no pattern felt "cheated" |
| Antigravity | 4 | (running; asked after its report) | | |
Four of four say NO to his whole plan and YES to one body tell. Fun with tells: 8, 8, 8, 8.

All seats that answered: NOT his whole plan. Claude: "The fight becomes a lock to solve, and the clinch and feint lose
their surprise." Arena: two hands guard four lines and the order decides who lands first, so "with his plan in view, every
beat I played has one correct answer that I could work out by sum".

## 2. What version 2 changes (each from a beat a seat played)
1. EVERY MAN LIES ABOUT ONE BEAT IN FIVE, each lie tied to ONE state the player can see. The trial's lies fired 0 of 18
   (Jabber, for Claude), 6 of 18 (Jabber, for Arena: "the best bout I played"), 1 of 18 (Slugger: "a lookup table by
   round 2"). The conditions are chosen from `tell_rates.mjs` (the page's AI in both corners), section 3.
2. THE BELL LEDGER SAYS WHEN EACH FAKE CAME: "knees 2 fakes, both the beat after you blocked his body punch" (Arena T3:
   "I found WHAT he hides but not WHEN"; Dola: a fake with no pattern felt like cheating). The rule is learnt from the
   ledger, never from a tooltip.
3. THE FRONT FOOT MEANS NOTHING INSIDE. At Inside a step in changes nothing, so "front foot creeps" there was a free
   "he throws nothing" (Arena T2 R2b3, R2b5, T3 R1b5). Inside, the step is not a cue; the tell comes from his hands.
4. "QUIET" IS SPLIT. "His weight sits on his back foot" = a back off or a clinch; "a quiet guard" = no big punch, no
   step. The quiet tell hid a clinch that cost Claude 5 stamina at 4 health (b6 R3B2).
5. A FAKE COSTS THE LIAR 1 STAMINA, and he fakes only when his real beat is lighter than the cue (Kalli SQ335). So a lie
   that is caught leaves a gap to hit (Claude: "When the Slugger lied he clinched, and my punch was wiped out").
6. KEPT: one cue a beat, never his moment; his last three beats and his hands this round stay on his card (Arena: the
   tell says which line to CLOSE, his hand habits which line to HIT).

## 3. The lie conditions (measured, tell_rates.mjs: the page's AI in both corners, 12 bouts a man, seed 1)
| Man | Version 1 condition (fired) | Version 2 condition | Version 2 fakes as built (bluffs only) |
|---|---|---|---|
| Jabber | ahead on health (20% AI v AI; 0 of 18 for a player who leads) | the beat after he backed off | 29% of beats |
| Slugger | stamina 3 or less AND holding (1 of 18, 0 of 18) | the beat after you landed on him | 27% |
| Body Snatcher | the beat after you blocked his BODY punch (9%) | the beat after you blocked ANY punch of his | 13% |
Every version 2 condition is on screen (his last beat, the story of the last beat) and none depends on who is winning, so
a strong player sees the lies too. Raw: ops/research/allplay2/tell_rates_v2.txt. In the words tool: `play_cli.mjs new
<f> opp=<n> tells=2`.

## 3b. What else the four reports agree on (not tells; each goes to its own measure)
- A KNOCKDOWN HEALS (Arena, Ziva): down at 1 health, up on 6 with a full bar - "the correct play at 1 health is to walk
  into a punch" (Ziva). A rule: measured before it changes.
- THE CLINCH DELETES A PAID BEAT for free (Claude, Ziva; Arena less so) - CLINCHFIX2 at Arena already measures it.
- LONG IS A CORRIDOR (all four): only 1-damage jabs reach, and every round starts there.
- HIS HABIT READ IS INVISIBLE (Claude, Arena, Ziva): the rule fires and nothing says so.
- His pull counter on YOU is not shown before the beat (Arena, Ziva: "a jab for 3").

## 4. What is measured before the page (bars)
- Following every tell blindly wins at most 55% against each man; a player who knows a man's lie wins 70%+ (Kalli's bars).
- Each man's lie fires on 15-25% of beats in AI-v-AI bouts.
- The fake's stamina cost does not move the nine balance bars (balance.mjs, tweak file).
Then a second playtest round (the same seats, ALLPLAY3), then the page: the tell as a pose of his body (three guard poses
per man: rear shoulder back, knees bent, weight on the back foot) - never words near the men (S562), the cue word in the
ring's corner badge.

## Feedback loops
- Tell -> the player covers -> his punches land less -> he loses -> (game) nothing feeds back into his lying. Cap: his lie
  rate is fixed per man; the fake costs him 1 stamina, so lying more tires him (a cap that grows with use).
- The player's own tells (Kalli: your big punches show a cue to him) are NOT in version 2: one side first.
