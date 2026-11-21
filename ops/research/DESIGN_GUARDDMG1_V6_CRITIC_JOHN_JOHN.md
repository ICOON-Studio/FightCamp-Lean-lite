# DESIGN_GUARDDMG1_V6_CRITIC_JOHN_JOHN - John answer (seat queue SQ274)

Brief: research/DESIGN_GUARDDMG1_V6_CRITIC_JOHN.md
Sent: 2026-11-21 15:10 | collected: 2026-11-21 15:40 by Tools/seat_queue.py (the 30-min reconcile)
Attachments on the bot's box (not downloaded): guard_v6_10.html
Verify the sources before using it.

---

On it. First I'm checking v6's exchange sums: the win shifts from the dice and the size of the Hands table. Then I'll score the design and send the missing and useless options, To reach 10/10 and the 1920×1080 page. Beast is still offline, so I can't open `CRITIC_ACCESS.md` and this will be a reading of the pack and map.

The guard v6 critic is underway. When it's done I'll post the logic check, then the full return with the page image, then the HTML file.

**Logic check on v6.** The map's sums hold; two of its numbers and the stacking don't.

- **The dice table is right.** From an even exchange, +3 gives 4.4 more wins in 100, +5 gives 7.3, +8 gives 11.4 and +17 gives 22.4. The Hands sizes also hold: −7 gives 10.0 fewer, +6 gives 8.7 more. The same edge shrinks away from even: +6 is worth 5.9 at +20 and 4.5 at +30.
- **The whole mechanic is as big as a plan.** Picking the best Hands for each of the opponent's games adds 8 to 18 wins in 100, depending on grade. A good plan adds 14.
- **Stacking counts one act twice.** "Hands up" plus High against a loader is +23. "Let your hands go" plus Loose plus Push against a tiring opponent is +29.
- **The 2.5 count tables are right, but only with Godot's rounding.** Python rounds 6 to 4 under ×0.75, so the tests must use Godot's rounding.
- **The example line can't happen.** "Lost 4-3 − 2 on the guard" is impossible under High. A 4-3 loss becomes "Lost 3-2, 1 on the guard".
- **The power factor checks out.** Power 40 gives ×0.86 and power 80 gives ×1.23.
- **Defence backfires.** Blocks come from misses, so Defence 90 blocks 68% against 58% at Defence 40. That means about 17% more guard wear.
- **Rope trade, pro 6 rounds:**
  - Normal all bout wins 3.00 rounds.
  - High for 3, then Loose for 3, wins 3.23.
  - Normal, then Loose once the opponent tires anyway, wins 3.32.
  - So probe bar 4 needs that last option as a control, or it passes on Loose's +6 alone.
- **The referee's look rises slowly.** It gains about 1 a round, so a stoppage in round 2 or 3 needs a boxer losing nearly every exchange.
- **The rule book backs one cut item.** England Boxing 10.3.2 is real in the 2026 rule book. The same book's 12.1.1(l) makes a fully passive double cover a foul, which v6 leaves out.

# GUARDDMG1 V6 critic: guard damage, covering must change who wins the exchange
This is a static reading: Beast is offline, so I couldn't open `CRITIC_ACCESS.md`, the code or the mockups. I changed nothing.

**DEPTH 7 · GENERAL DESIGN 6 · PLAY 7. Not designed yet: GENERAL DESIGN is one point short.**

v6 fixes the method v5 was faulted for. The guard now enters the exchange's sum before the dice, so covering finally wins and loses rounds. The trade is honest boxing: cover against a loader, open up on a tired opponent, survive when hurt, and wear a presser down before switching. Four rules work against that aim:
- the shouts and the setting count the same act twice;
- Loose is a free Push;
- better Defence wears the guard faster;
- the probe's bars mostly test that the table was typed in correctly.

**DEPTH 7**
- **For:**
  - Every column wins somewhere and loses somewhere. Normal is best only against the counter-puncher.
  - Wear limits High: it takes 8% more wear a block, and a worn guard then costs −2 or −4 an exchange.
  - The drain gives a pro-only choice: cover now, open up later.
  - Loose's ×1.3 hurt chance and the referee's look give each side a price.
- **Against:**
  - With the opponent's game shown as a clue, the table is a lookup. READ is that lookup, worth 8 to 18 wins in 100, which is plan-sized.
  - Loose costs no energy.
  - The real decisions (when the guard is too worn, when the drain has done enough) are thin beside the lookup.

**GENERAL DESIGN 6**
- **For:** it's built from code with line numbers. It is one pure module and one line in the sum, uses the same grade rule as the corner calls, keeps amateur and pro apart, and the probe has a control and a mutant.
- **Against:**
  1. **One act, two edges.** A shout stacks with the setting that means the same thing (+23, +29).
  2. **Loose has no energy price,** though "throw more" is exactly what Push already charges for.
  3. **Defence backfires,** and High is graded on head movement, the opposite of a shell.
  4. **Save and High stack** to land ×0.56.
  5. **The probe can't fail for the reason it names.** Bar 6 passes by how it's built, bar 4 has no "Loose on Tiring" control, and nothing caps Hands below the size of a plan.
  6. **Words.** The impossible "4-3" example. "{opp}'s big shots miss" puts a name in a call line. "High" sits next to the "Gloves high" tile.
  7. **Screen load.** A third standing row beside Pace and Aim, on a dark and tight bar, with no layout given.

**PLAY 7**
- **For:** watching the presser's energy fall toward 45, then switching on "mouth is open", is a real beat. A worn guard and dropping arms are a visible clock, and the Why line on the hands closes the loop.
- **Against:** as a lookup for every exchange it's a chore, up to 6 clicks a round. It also lives only on fight night.

**Options**

| Option | Verdict | What it changes |
|---|---|---|
| High | Keep, rename "Cover", grade on Defence + shoulder endurance | +6 against a loader, +3/+5 when your boxer is tired/hurt, −2 to −8 elsewhere; 1 in 3 of the opponent's landed punches become blocks; your boxer lands ×0.75; +8% wear; hurt ×0.7; drains a presser 1 an exchange |
| Normal | Keep | Today's fight; best against a counter-puncher |
| Loose | Change: rename "Open up", add an energy price | +2 to +6 against pressing, range, tiring and hurt; −6 to −10 against a counter, a loader or when your boxer is in trouble; hurt ×1.3; costs no energy today |
| Shouts "Hands up" / "Let your hands go" | Keep, no stacking | Count the larger of the call and the setting, never the sum |
| Aim "Through the guard" (pro) | Keep | The opponent's guard wears ×1.5; your boxer lands 1 fewer clean |
| Worn guard −2/−4 (both sides) | Keep | Wear wins rounds and limits High |
| Referee's gauge | Keep, merged | A higher stop chance after a count; at 10 the fight is stopped as outclassed |
| Counter off a blocked power punch | Change | +1 landed decides nothing; make it +2 to the next exchange |
| Defence → block share | Change | It must turn landed punches into blocks, not misses into blocks |
| Tie up Sharp +13, the dropped-right habit | Keep | Small, real links to the week |
| ONE CHANGE tiles | Keep, rename "Protect the head" / "Protect the body" | Where punches land, not who wins |
| `hands_next`, `posture_damage`, `blocked_strikes`, the clinch stamina line | Useless: cut | Nothing changes |
| **Missing:** Hands as a plan line | Add | "When the opponent tires → Open up", rated Beats it / Works / Walks into it; the corner bar overrides it |
| **Missing:** amateur passivity warning | Add | Real rules make a passive double cover a foul; a warning takes a point and the third disqualifies |
| **Missing:** the opponent covers too (pro) | Add | Gives Aim Body and "Through the guard" their moment |

**The map's open points**
- **Refusing neck work:** agree, because it would count Durability twice. Use shoulder endurance instead.
- **Cutting `hands_next`:** agree, but the shout must then replace the setting's edge, not add to it.
- **Cutting the warning price:** disagree in part. England Boxing 2026, rule 12.1.1(l), makes "completely passive defence by means of double cover" a foul. Rule 12.3.2 takes 1 point per judge for each warning, and the third disqualifies. Build it for amateurs only. The game can't deduct points yet.
- **Keeping posture out:** agree.
- **ONE CHANGE rename:** agree, and go further: make Hands "Cover / Normal / Open up".
- **England Boxing 10.3.2:** verified in the 2026 book: "outclassed or is receiving excessive punishment… the Bout will be stopped".

**Evidence**
- A scoring blow must land "without being blocked or guarded": **SOURCED**, AIBA rules 2010, 11.1.1.
- Passive double cover is a foul: **SOURCED**, England Boxing 2026, 12.1.1(l), and AIBA 2010, 12.1.13.
- Referees ask "Are the boxer's hands up?" and stop one-sided fights: **SOURCED**, ABC Boxing Referee Manual (2026 file).
- A high guard beats a loader: **SOURCED**, Las Vegas Sun 2005 and CompuBox via BoxingScene 2007.
  - Trinidad landed 58 of 557 punches on Wright (10%) and 43 of 230 power punches (19%). He had landed 66% of his power punches on Mayorga.
- Throwing less loses rounds: **SOURCED**, CompuBox 2007. Wright threw 32 to Taylor's 37 in the last round, lost it on two cards, and the fight was drawn.
- A shell must keep jabbing: **SOURCED**, CompuBox 2007. Wright landed 185 of 588 jabs against Trinidad.
- CompuBox doesn't count blocks: **SOURCED**, The Boxing Bulletin 2009.
- Amateur stoppages are rare: **SOURCED**, IBA tournament statistics.
  - At the 2017 Worlds, referees stopped 1.7% of bouts.
  - At the 2021 Worlds, they stopped 4.2%.
- The share of punches blocked rather than missed, and force through a guard: **NOT FOUND**.
- A high guard leaves the body open: **CHECK**. It's coaching lore and I found no study.

**To reach 10/10 (most important first)**
1. **No double counting.** When a shout and the setting agree, `HandsEdge.points` counts the larger of the two.
2. **Give Open up an energy price:** 1 energy an exchange, costing like Push on an empty tank.
3. **Fix Defence.** Have it turn landed punches into blocks, or set block share to 0.70 − Defence/500. Grade Cover on Defence plus shoulder endurance.
4. **Add a probe bar.** READ over NORMAL must come out at +4 to +8 wins in 100 in even bouts. If it's higher, scale table 2.2 down.
5. **Replace bar 6.**
   - An option that watches the guard and energy must beat READ in at least 3 of 12 cells.
   - In pro 6 against a heavy presser, the rope trade must beat "Normal, then Open up on Tiring" by 3 or more.
   - Print how often the opponent's game changes from one exchange to the next.
6. **Put Hands in the plan** as conditional lines on the round rows, with the corner bar overriding. CHECK that `PlanFile` can carry a condition.
7. **Amateur passivity by the rule book.** A round of Cover with 0 or 1 landed earns a caution. The next earns a warning and −1 on every card. The third disqualifies. This needs a deduction in `BoutRules.cards_of`, which the game can't do yet.
8. **Catch and counter.** A blocked power punch gives +2 to the next exchange.
9. **Words.**
   - Cover / Normal / Open up, and Protect the head / Protect the body.
   - "Lost 3-2 − 1 on the guard".
   - "The opponent's big shots miss".
   - Combined cuts in the hover ("Save + Cover: lands 6→3").
10. **The opponent covers when hurt (pro).** This needs an opponent-side flag, and its sizes are an ESTIMATE.
11. **Lighter screen.** Make Hands one 3-notch switch beside Pace. The corner minute shows only the coach's pick and its reason.
12. **The game can't do these yet:** 12-round bouts, and hand height in the 3D fight (FIGHTPLAYER2).

**The 10/10 page** (1920×1080, image below) is the pro corner minute after round 3. It's dark and tight, with the coach's note on cream paper, and colour only for risk.
- **Header:** the names, and the only pulsing button, OUT FOR ROUND 4.
- **Left:** your boxer's energy, the guard at 46% marked WORN −2 in amber, the referee's look at 3 of 10, and the round-3 strip.
- **Centre:** the coach's note: "The opponent pressed all round and is down to 49. Under 45 it tires 3 times in 4. Cover one more round, then open up." Below it, the opponent's energy meter has a dashed line at 45.
- **Right:** the three Hands choices with their costs, and "a shout replaces the setting for 30 s, never adds to it".
