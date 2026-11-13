# PROGRESSION_CRITIC_S448C_JOHN - John answer (seat queue SQ54)

Brief: research/PROGRESSION_CRITIC_S448C_BRIEF.md
Sent: 2026-11-13 11:05 | collected: 2026-11-13 11:24 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

# PROGRESSION v3 (S448): critic

Depth **7/10**, play **7/10**. I'd defend this to the owner. Holding as a weekly rule, the plan holding its own moves, frozen fades in fight weeks, styles that change the fight, and a read the player can see before the bout together make a career-long choice. What keeps it off 8 is a sparring rule that doesn't match the code, a pro milestone the game can't observe, style sets that overlap too much, one useless hire, and the new names rule.

## 1. Logic check

- **The sparring hold doesn't match the code.** The pack's S448 units note says a sparring night *shares* 180 units over the moves on the fighter's cards and plan. M3 says the 180 "count for every move in the fighter's plan", so every move gets the full amount. With a 6-line plan plus cards, each move's share is about 20 to 30 units. That meets a Sharp hold (20) but never a Signature hold (40). Section 6 and HOLD1's budget both assume the full count. Either the hold reads the move's share, which makes a bigger plan thin out what sparring holds (a real trade), or the code changes. The map has to say which.
- **READ-PROOF can't be seen in a game.** "The read costing under 2 in 100 for two bouts" is a probe statistic. A single bout doesn't produce a cost in wins per 100, so the milestone can never light up on a Monday. It needs a count from the bout itself (see the To reach 10/10 list).
- **Names outside headers.** The new owner rule says a person's name sits in the screen's header once, and nowhere in options, buttons, rows, lines or tooltips. Section 6 runs on names (Tess, Samira, Lucy, Ana's class night), and the mockups get drawn from that section. In the Club > People market, names belong only on each coach's card header. Every row, button and Monday line must say "your coach", "the assistant" or "the young coach". The map's own Monday line ("Young coach: 12 pad sessions to 65") already follows the rule.
- **The pronoun rules conflict.** The new pack line says options use "her / him / the opponent / your coach". S412 says never a fixed he or she in text or mockups, and the map follows S412. Someone has to settle which rule wins before SITWORDS1. I'd keep S412 and write "the boxer" or the role.
- **The old trainer is a hire nobody takes.** The Signature rate tops out at pads 75, so above that, pads only add bar speed. The old trainer at pads 80 gives a bar speed of 1.32 against Reid's 1.30 (at 74), about 2% faster for twice the wage ($900 against $450), and doesn't grow. COACHMARKET1 will fail on this hire.
- **"Coach holds it" depends on an unbuilt control.** It uses the AGREED "Coach runs it" control (C20), which isn't built (pack 4.12). List it as a dependency in the build order, like C17.
- **The award tests change real awards.** M10 rewrites the content of the real GB Boxing Awards (Standard, Bronze and so on) to test footwork nodes and held Sharp moves. Pack 7 allows real names only where legal and accurate. Either keep the real tests, or rename the grades as the club's own.
- **Section 6 has a timing problem.** By week 9, Samira already holds Cut off at Sharp. Cut off is row 3, which needs 9 moves Usable and Step in at 60. Reaching that by week 9 is unlikely at the map's cadence. PROGPROBE1 should report the week each row opens.

## 2. Depth: 7/10

**The pick is a real decision.** Rows open by how many moves are Usable, cards give reasons without a pre-mark, and PICKSPREAD1 has the right bar.

**Holding is now the right shape.** Writing the plan decides what survives, the camp phase changes the price, and the coach's default keeps it from becoming a chore.

**Style overlap pulls toward easy holds.** Cross sits in three sets and Pivot in three. A fighter holding Jab, Cross, Lead hook, Step back and Pivot qualifies for three styles at once. That makes Cross and Pivot automatic holds and leaves "pick one style" with no cost.

**The coach's default may decide the specialty.** If the coach holds the plan's moves and any Signature, a player who never opens the board still gets a style. The decision only exists for players who override it. The Monday review must show what the coach dropped, so the player sees there was a choice.

**Weak nodes:** Herd and Push off, as before. TREEVALUE1 merging them is right.

**Every unlock changes fight night:** the fire share, the grade, styles (1.5 to 4 in 100), the read, and fading clips in the 3D. No invisible +1s are left.

## 3. Play: 7/10

A next thing on all three clocks, a pick in week 1, holds frozen in fight weeks, and a pro stage defined by the read make Continue worth pressing at every stage. Amateurs and pros now play differently.

What stops an 8: READ-PROOF, the pro season's milestone, can't light up as written. The veteran stage still depends on C17 sparring pairs before it has anything to do.

## 4. Options and menus

| Place | Verdict |
|---|---|
| Profile, NEXT UNLOCKS | Keep. |
| The tree with the Specialty board | Right place. Add a style preview: for each set within one move, what its effect would be and which move is missing. |
| Combos, Game plan (cap 7, read target marked) | Keep. |
| Week, pad-night board as the top row | Keep. This is where the club-wide trade-off shows. |
| Monday review | Add "the coach dropped X to hold Y" when the coach's default drops anything. |
| Home needs | Keep. |
| Fighters cards | Keep. |
| Bout card from the style word, Fight prep with tell and read | Keep. |
| Fight night, the Why | Keep. |
| Club > People market | Names on card headers only. Cut the old trainer, or give that hire a reason. |
| Signing card, Pro offer | Keep. The Pro offer line follows the names rule. |

The coach side is about the right depth: five hires, growth, a rate instead of a gate, a let-go price. Fix the old trainer and stop there.

## To reach 10/10 (mechanics, most important first)

1. **Make the sparring hold read the move's share.** A move in the plan is held by sparring when its share of the 180 units meets its hold (Sharp 20, Signature 40). More plan lines then mean thinner shares, so the plan's size becomes the hold trade-off. HOLD1 re-runs on that rule.
2. **Make READ-PROOF observable.** It lights when, in two pro bouts running, the read line won at least half its exchanges in the rounds it was read, or the read was split by a second line (rule 2). Probe the target, but light the milestone from the bout's own counts.
3. **Limit style overlap.** Each move sits in at most two sets, and STYLE1 reports how often a fighter qualifies for two or more styles at once (target under 1 in 4). For example, Boxer-puncher becomes Cross, Check hook and Step back, and Pivot stays only in Out-boxer and Counter-puncher.
4. **Give the old trainer a real reason, or cut the hire.** Two options: the coach's signature drill opens at 20 sessions instead of 40, or this coach alone lifts the Signature rate to x1.15 above pads 75.
5. **Show what the coach's default drops.** Monday review lists "dropped X, holding Y" with Undo, so the choice is visible without making it a need.
6. **Build C20 before "Coach holds it",** and C17 before veteran teaching. Put both in the build order ahead of SPECIALTY1 and M8.
7. **Re-set or rename the awards.** Either keep the real award tests, or call the grades the club's own (for example Club Grade 1 to 6).
8. **Apply the names rule on every row in the map,** and settle S412 against "her / him" before SITWORDS1.
9. **Report the week each row opens** in PROGPROBE1, and fix section 6's timing to what it measures.

## The 10/10 tree page at 1920×1080

- **Rail (96 px) and dark top bar (64 px):** as they are now.
- **Header, 120 px:** the fighter's name appears once here, beside the comic portrait. Then class, record, rank, height and reach, the named style with its one-line effect, and either the award (amateurs) or READ-PROOF progress (pros).
- **Tree whiteboard, left, 1080 × 700:** four columns of magnets in three rows, with a By branch / By place in the ring toggle.
  - Each magnet has a bar with ticks at 30, 60 and 85, a grade letter, and a gold pin when FIGHT-PROVEN.
  - Rings mark the moves in the slots. Held moves show a share clock, frozen moves a snowflake in fight week, and fading moves a red date.
  - Locked moves are chalk outlines with the line they wait for. The cap and its Technique need are shown on the bar.
- **Right column, 640 px wide, three panels:**
  - **Slot (260 px):** either the coach's three cards (weeks to Usable, modes it answers, what it opens, grade, what waits, Pick), or the move in the slot with Swap and its price.
  - **Specialty board (300 px):** held moves with their share and how each is covered (sparring share, pads or bag). The coach's hold is marked, with Hold and Drop. Then the style preview: each set within one move, its effect, and the missing move. For a pro, a "Their corner waits for: 1-2" line with Change the plan.
  - **Selected node (140 px):** Watch, Drill, the plan answers it gives, and the combinations it opens.
- **Clocks strip, full width, 120 px:** Week (nearest line and its day), Season (award or READ-PROOF with its count), Career (pro offer, next Signature, or a coach milestone).
- **Pad-night strip, along the bottom, 80 px:** the club's 8 nights split into learning and holding, plus the $75 overtime night.

**Bottom line:** v3 is the first version I'd send to the owner. Fix the sparring share, make READ-PROOF readable from a bout, and cut the style overlap. Then run HOLD1 and STYLE1, and draw it.
