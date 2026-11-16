# DESIGN_LADDER1_V5_CRITIC_JOHN_JOHN - John answer (seat queue SQ201)

Brief: research/DESIGN_LADDER1_V5_CRITIC_JOHN.md
Sent: 2026-11-16 01:10 | collected: 2026-11-16 01:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

On it. I'll score LADDER1 v5 as a fresh critic, starting with a hand check of the Rep formula, the yes-chance sums and the three cases. The owner's computer is still offline, so I can't open `CRITIC_ACCESS.md` or the mockups.

**Logic check.** I worked v5's numbers by hand. The owner's computer is offline, so no probes were run and none of the code facts could be confirmed.

**These hold:**
- **The R3 table is right.** At a gap of +10 the expected chance is 28.5%, so a win pays +11 and a loss costs −5; at +20 it's +14 and −2. The corrected +6 example gives +10 / −6 and their odds part +14.
- **The reach lines are right:** 34, 55 and 62 for Rep 20, 38 and 44.
- **The worked yes chance adds up:** 50 + 14 + 10 − 20 + 6 = 60.
- **Every cell in Cases A and B is right** for Rep, money, members and morale, including both corrections (−3.0 morale, and +10 / −6 at a gap of +6).
- **Case C holds:** 0.64 × 0.52 = 33%, the #1 says yes about 71 from 44, and from 51 their chance is 57%, so protecting fires and the yes falls to 27.

**What doesn't hold:**
1. **The map's own anti-farm test fails on its own money rule.** R4 pays the $450 ticket cut only on a win, so farming a boxer 20 below (86% to win) earns about $387 a bout against roughly $250 for a hard pick. FARM then beats THINK on money and probe 13 fails. Gym standing (+5 flat) and morale (+8 flat) favour the farm the same way, and probe 13 doesn't even measure them. The pack says "a bout adds a $450 ticket cut", which reads as per bout, win or lose (CHECK 5). In the real world, ticket money doesn't depend on who wins. If it's per bout, the money column is the same on every row, and the "$23" in Case A disappears.
2. **The clock's exception never applies.** A week counts as free only when your boxer isn't booked, so a farm bout every fortnight keeps every week booked and the clock never runs. The rule "a bout 20+ below doesn't reset the clock" changes nothing unless those weeks still count as free.
3. **The game has no venue.** The pack (S410) says the game doesn't hold one, yet R6 uses home or away (+10 / −5) and R4 uses away travel. The map marks travel as a CHECK, but not the home or away part of the yes chance.
4. **A no sometimes has no reason to give.** At 85 in 100 with no minus parts, a no has nothing to name, which is exactly the "random refusal" pack 4.5 rules out.
5. **The Pass rule is ambiguous two ways.**
   - "−2 Rep to the challenger" can be read as the challenger losing 2. The offer line ("Passing costs 2 Rep") means your boxer pays 2 to the challenger, and the rule should say so.
   - If rivals obey the same rules, a rival saying no to your ask could count as a Pass that pays you 2. Then you could farm refusals by asking up every day. The map should state that a no to an ask pays nothing, except under OWED.
6. **The cases treat Rep's expected chance as the real chance to win.** In the game, the win is decided by stats and the plan; Rep's formula only sets the pay. The card already shows the code's win band, so the cases should use it. That gap is also the ladder's best hidden decision: a boxer whose training has outrun their Rep earns big points from the boxers above.
7. **The ±7 plan shift is an ESTIMATE.** The measured 14 points is good plan against no plan (59 against 45); bad plan is 41. The plan is also the player's own: in Case A the player would rewrite a plan that walks into the Counter-puncher. Done that way, the Counter-puncher goes to about 85%: +0.6 Rep, 2.4 members, +5.0 morale. The Slugger still wins on Rep and members, so the reading holds.
8. **Case A ignores NOT SAFE.** Your boxer has 6 bouts, so is a novice, but the case never gives the opponents' bout counts. A Rep-27 boxer is likely open (11+ bouts), which would grey that row.
9. **Case B values the regional stage too cheaply.** 0.12 × 5 = 0.6 assumes the stage is always won; the real value is 12 in 100 × the chance of winning the stage × 5, plus the road to the nationals that the stage feeds.
10. **"Study tape" has no path for amateurs.** Tape study opens tells only in a camp, and S428 removed amateur camps. The pack lists a Film evening in the week, so that's the way in.
11. **The card leaves out the bout injury roll.** About 6 in 100 boxers come out of a 3×3 bout injured, win or lose (CODE).

**LADDER1 v5 scores 7 for DEPTH, 6 for GENERAL DESIGN and 7 for PLAY, so it fails the bar on general design by one point.** Fixes 1 to 5 in the 10/10 list are each a line of rules, and they would clear it.

**DEPTH 7.** This is a real step up.
- The full card makes the gym's needs and the boxer's needs pull against each other.
- The yes chance makes timing matter, as Case C shows: the safe step closes the shot at the #1.
- DUCKED and OWED turn a hot streak into leverage.
- Fight weeks cost training, so how often to box is a real trade. At 18 bouts a season that's about −11 stat points, against the pack's 5 points = 72%.

It isn't 8 because the farm still wins for the gym on money, gym standing and morale (logic point 1), and the cases never show the most interesting pick: the boxer who is better than their Rep.

**GENERAL DESIGN 6.** One unit and two names are clean, and so are the single rematch rule, the weight forecast and the folded grey rows.

What holds it at 6 is four rule contradictions:
- the clock exception that never applies;
- the money that makes probe 13 fail;
- the home or away part, which uses a venue the game doesn't have;
- the Pass and ask wording.

On top of those, a no can be a reason-less refusal, and the Look question is listed as open when the owner has already ruled Look B (pack section 7).

**PLAY 7.** It has anticipation: the answer comes the next morning, and there's the clock note, OWED coming due, and the season strip. The upset payoff, "+11 Rep, now ranked 5th", feels earned.

It isn't 8 because rivals have no memory beyond DUCKED and a single last-meeting part. The rival gym is agreed but not built.

**Options**

| Option | Verdict | What it changes |
|---|---|---|
| One ask that covers both dates | **Missing** | Each date has its own seeded answer, so players will ask twice anyway; one ask saves the wasted day |
| "Write a line" on the card's plan chip | **Missing** | Turns "Walks into it" into an action in the Playbook (pack 7: only actionable information) |
| An injury line, win or lose | **Missing** | Prices the 6 in 100 bout injury (CODE) that the card leaves out |
| Pulling out of a bout you asked for | **Missing** | The card prices the ask but not backing out; the $300 empty slot (CODE) is the obvious price |
| Pin as target linked to the goal talk | **Missing** | "Beat the #3 by June" becomes a goal with morale on it (CODE goals) instead of a bare pin |
| Ask for a rematch link | **Useless** | The row's own Ask already handles it under TWICE THIS SEASON; cut it |
| Makes weight filter | **Useless** | Legal now already hides TOO HEAVY, and the Weight at risk chip shows the rest |
| Sponsor 30 and squad camp 45 marks | Useless until confirmed | Cut them unless CHECK 8 finds them in the code |
| Rest until | Keep | Protects a training block from the clock, once a season |
| Not this show / Pass | Keep, with the wording fixed | Gives saying no a price without forcing a bout |
| No EV column | Agree | A single total would put the script back |

**Owner questions, my reading**
1. **Use a fixed threshold, not a seeded roll.** Add each rival manager's temperament as a part (careful −10, normal 0, bold +10), shown after their first answer. That replaces chance with something the player learns, and it keeps "never a random refusal".
2. **Yes to Rep and Gym standing.**
3. **Yes to mandatories on pro tables only.** That matches real amateur matchmaking (CHECK).
4. **Yes to the Pass price,** worded as "Your boxer pays 2 Rep to the challenger".
5. **Look B is already ruled** by pack section 7, so this isn't an open question.
6. **Yes to the draw rule.**

**To reach 10/10**
1. **Make money and standing match the game, then re-run probe 13 on all five lines** (Rep, money, members, gym standing, morale).
   - Pay the $450 cut every bout (per pack 4.13, CHECK 5).
   - Scale gym standing with the Rep won: at least +1, at most +8.
   - Scale win morale with the expected chance: +4 at 86%, +10 at 14%.
   - FARM must lose on the boxer's lines and win only on the gym's money line.
2. **Fix the clock:** weeks booked for a bout 20+ below still count as free.
3. **Write R6 as a threshold with manager temperament,** so every no names its reason. With no minus parts, the answer is always yes.
4. **Rewrite R9's wording:** "Your boxer pays 2 Rep to the challenger." State that a no to your ask pays nothing, except under OWED.
5. **Add a host gym to each club show,** or cut the home or away part and the travel line. Without a venue they can't be built.
6. **Redo the cases with the code's win band, not Rep's expected chance.**
   - Give each opponent's bout count, and grey any NOT SAFE rows.
   - Add a Case D: a boxer whose stats run 5 points ahead of their Rep. That shows the ladder paying for training.
   - Value the regional stage as the chance of missing it × the chance of winning it, plus the nationals road.
7. **Add the missing card lines and links:**
   - injured in 6 of 100, win or lose;
   - a "Write a line" link on the plan chip;
   - one ask for both dates;
   - "Pull out: $300";
   - Pin as target turned into a goal.

   Cut the rematch link, the Makes weight filter, and the 30 and 45 marks unless the code has them.
8. **Make Study tape put a Film evening on the next week** against that opponent, opening one tell (S428: no amateur camp).
9. **Close the CHECKs,** especially 5, 8 and 10. England Boxing's minimum days between bouts and its stoppage medical layoffs set the 18 cap and the 8 weeks (both CHECK).
10. **Draw the page in Look B,** then send it to two fresh critics.

**The 10/10 page (1920×1080, Fights > Who do we fight?, Look B)**
- **Dark top bar (0–64):** the OFFER flag and Continue.
- **Cream whiteboard header (64–140):**
  - your boxer's polaroid, class and record, with the name once;
  - "Rep 38 · 8th" in Permanent Marker.
- **Rep bar as a marker line (140–200):** only the 55 pro mark.
- **Season strip as fixtures pinned on the board (200–250):** your show circled in marker, the regional stage, the nationals, and "Bouts 7 of 18".
- **Offer note (250–300):** a sticky note with Accept, Not this show and "Pass: your boxer pays 2 Rep".
- **Left table (40–1180), in Kalam on cream:**
  - chips for In reach and Legal now, and "Showing 6 of 24 · Show all";
  - the dashed reach line at 55;
  - the folded line "3 can't be asked now ▸";
  - red only for risk: Weight at risk, stopped 12 of 100, injured 6 of 100;
  - your row with a slate tab.
- **Right card (1220–1880), a paper sheet:**
  - "Your boxer v the #3";
  - the yes box ("Leans yes +10", hover for the parts, careful manager −10) and the win box (the code's band, with a "Write a line" link on the plan chip);
  - the win and loss lines in two columns;
  - one dates toggle;
  - To raise the yes;
  - one pulsing ASK FOR THIS BOUT, with Pin as goal and Study tape (Film night) as small links.
- **Type and hover:** nothing under 14 px, and every number opens its sum on hover.

**Sources:** the arithmetic is DERIVED from the map and the pack. The CHECKs, from memory and not looked up this turn:
- that BoxRec's rating gives more points for beating higher-rated opponents;
- that amateur matchmaking pairs boxers by bout count and weight, with no mandatories;
- that England Boxing sets rest periods between bouts and medical layoffs after a stoppage.

The real boxing evidence is limited to those three memory checks. I couldn't open `CRITIC_ACCESS.md` or the mockups, or confirm any code fact, while the owner's computer is offline.
