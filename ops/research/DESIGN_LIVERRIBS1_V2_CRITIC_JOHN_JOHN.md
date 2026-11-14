# DESIGN_LIVERRIBS1_V2_CRITIC_JOHN_JOHN - John answer (seat queue SQ91)

Brief: research/DESIGN_LIVERRIBS1_V2_CRITIC_JOHN.md
Sent: 2026-11-14 10:00 | collected: 2026-11-14 10:42 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I'm reading LIVERRIBS1 v2 against the pack and my v1 notes now. One return covers both copies of the request. It comes next.

# LIVERRIBS1 v2 (S460): critic

Scores: **depth 7/10, general design 6/10, play 7/10**. That **passes the owner's bar**, with general design at the floor.
- I couldn't open `CRITIC_ACCESS.md` or the board, because your computer is offline, so I judged from the map and the pack.
- Names and pronouns pass: every line says "the opponent", "your boxer" or a neutral "they", and names sit only in the two corner headers.

**What v2 fixed that the game now gets right:**
- The liver is always on the right side, and the hand that throws sets which side it hits.
- There are rear-hand body punches.
- Hurt ribs now pay off tonight: a lower guard and a slower hand on that side.
- The crack is now a 25 in 100 roll at the bell, not a sure thing.
- The crack card shows the full price.
- The opponent's corner can retire a boxer.
- There's a defence choice for each side.
- The amateur count rules are in.
- Durability, Strength and Explosiveness replace the old Power stat.

## Answer to `CHECK (John)`: the body-knockdown target

I found no sourced share of knockdowns from body shots, amateur or pro (NOT FOUND in this pass). So 10–20% is the owner's call, not a real-world figure.

The two targets on the board also measure different things:
- **"10–20% of all knockdowns"** is a share.
- **"Two or three liver-hurt rounds a season should end in a body count"** is a rate per hurt round.

A club boxer has about 9–11 bouts a season, and few of those reach a hurt liver. If 1 in 3 hurt rounds should fold, \(p\) needs about 8% a hook at 5 liver hooks a round, which is the cap. That would push the body share well past 20% for a body-puncher.

So pick one: **body knockdowns per 100 bouts** (my suggestion: 2–4, ESTIMATE), measured by `LIVERPROBE1`, and let the share fall out of it.

## Logic check

**1. The new hand rule changes every boxer's body attack by stance, which the map doesn't count.**
- Today every body punch is `3b`, the lead hook. Under the new rule, an orthodox attacker's `3b` always lands on the liver at ×1.3, and a southpaw's `3b` always lands on the ribs at ×0.55.
- Until a boxer drills the new `4b` or `2b` past 30 (weeks of pad nights; new moves start at New), an orthodox body attack drains **30% more** than today and a southpaw's drains **45% less**.
- The claim "neutral at 60/40" no longer holds, because traffic is now set by the hands each boxer owns, not by `LIVER_SHARE`.
- Every opponent has the same gap: the map never gives opponents `4b` or `2b`, so the AI can't "switch to the other side" (4.3) without a rear body punch.

**2. Against a southpaw, the liver beats the ribs by about 4 to 1.**
- An orthodox lead hook reaches the southpaw's liver on the 30%-covered lead side: 0.7 × 1.3 = **0.91** drain per throw.
- The rear hand to the ribs hits the 60%-covered rear side: 0.4 × 0.55 = **0.22**, plus the hurt-ribs penalty to the southpaw's power hand.
- Orthodox against orthodox is closer (0.52 for the liver, 0.385 for the ribs plus the guard drop), so that matchup is a real choice.
- The probe bar ("each Aim best in at least one of four matchups") would pass even if the liver wins three of four. It doesn't test for "no dominant pick".

**3. The crack card needs a forecast the game doesn't have.** `BoutRead` forecasts before the bout. "Win chance N in 100" between rounds needs a mid-bout mode that takes the current round, meters, scorecards and the crack. That isn't built and isn't in the build list.

**4. "No left-side pads" has no meaning yet.** Drill cards are moves, not sides. The map has to list which moves each stance throws with the left hand:
- Orthodox: jab, lead hook, `3b`, check hook, lead uppercut.
- Southpaw: cross, `4b`, `2b`, rear uppercut.
Then it has to say those cards are locked while the crack heals.

**5. The corner minute grows past what's agreed.** The agreed fight night has "three fixes, time for two". ONE CHANGE would now hold a habit fix, Elbows in, Gloves high, Right elbow in and Left elbow in, plus a one-click Aim switch. The two new side elbows overlap the existing Elbows in. Make them one Elbows in choice with a side: both, right or left.

**6. Smaller gaps:**
- **Drain scaling:** rule 1 scales drain by Durability, while the footnote says Durability plus Stamina. Pick one.
- **The "Body threat" line:** the owner held back "camp injury risk" lines. On the bout offer this line is fine only if the player can act on it. Tie it to a found tell ("Breaks ribs") with its answer ("Left elbow in"), or keep it on hover.
- **The opponent's switch:** the AI switches only after 2 rounds of heavy cover, so in a 3-round amateur bout it can fire once at most, in round 3. Say that it's meant for pro fights.
- **Layoff bar vs new outcomes:** the "+10% layoff days" bar fights against a new 84-day outcome. Say which wins if they clash.
- **Right ribs:** all rib injuries now sit on the left. The lower right ribs over the liver can fracture too. Keeping that out is a fair simplification, but say it's a choice.
- **Heal times:** the [NHS](https://www.nhs.uk/conditions/broken-or-bruised-ribs/) says ribs heal in 2–6 weeks. The 35-day short end fits. 84 days with 1 in 10 at +28 is long, but it's fair as a "fought on it" price. Keep it marked ESTIMATE.

## Scores, with reasons

**Depth 7.** The mechanic now ties together:
- stance, the hand you throw, guard cover, Aim, the hurt-ribs penalty, the crack card's three prices, the elbow defence and the opponent's corner.
- The player reads a tell, aims, gets a payoff tonight and pays a price later.

It falls short of 8 because opponents can't change hands (point 1), so the side game is one-sided.

**General design 6.** The rules are complete and mostly consistent. Three things hold it at the floor:
- The stance change shifts every boxer's body drain by 30–45% (point 1).
- Against a southpaw the liver beats the ribs about 4 to 1 (point 2).
- The crack card needs a mid-bout forecast that isn't built (point 3).

**Play 7.** The crack card is the best decision moment in fight night so far: three clear prices and a real win chance. The elbow-in choice gives the defender a real choice too. Play drops if the corner minute bloats (point 5).

## Options

| Option | What it changes | Verdict |
|---|---|---|
| Aim: Body (liver) | 1.3× drain and the fold chance; opponent's corner may retire them | Keep. Dominant against southpaws, so tune it |
| Aim: Ribs | 0.55× drain, hurt guard and slower hand on that side, crack roll | Keep. Now earns its place against orthodox boxers |
| `4b` and `2b` (new moves) | Rear-hand body punches; set which side you hit | Keep. Needs starting mastery for existing boxers |
| Right or Left elbow in | +20 cover on that side, −10 head cover on that side | Keep, but merge into Elbows in as a side choice |
| One-click Aim switch | Prints the corner's read as a button | Useful, but it plays for you. Show it only after the tell is found |
| Crack card: Pull out | 35 days, stoppage-loss price | Keep |
| Crack card: Defend the side | No punches with that hand, guard −4, 63 days | Keep. Strong pick for a pressure boxer whose jab hand is cracked |
| Crack card: Fight through | That arm ×0.6, guard −10, 84 days, 1 in 10 at +28 | Keep |
| Opponent corner retires | 40% or 65% at the bell | Keep. Show the roll in the log |
| "Body threat" line | Shows rib risk before the bout | Keep it only with an answer attached |

**Missing options:**
- **Opponents' body hands:** no opponent has `4b` or `2b`.
- **A "work the ribs back" plan:** there's no camp drill to strengthen the rib side after a bruise. A one-week core block at −20% heal would fill the gap.

## To reach 10/10

1. **Fix the stance shift.**
   - Every existing boxer and opponent gets `4b` and `2b` at 70% of their current `3b` mastery.
   - Re-tune liver and rib drain so today's average body drain holds within ±5% for an orthodox attacker and a southpaw attacker. Measure that in `LIVERPROBE1` before any other tuning.
2. **Give opponents body hands by style.**
   - Pressure and Volume styles throw `3b` and `4b` at 50/50.
   - Counter and Boxer styles throw `3b` and `2b` at 70/30.
   - Rule 4.3's switch shifts those weights by 30 points.
3. **Raise the probe bar to "no dominant Aim".**
   - In each of the four stance matchups, liver against ribs drain per throw (counting the hurt-ribs penalty as value) stays within 1.5 to 1.
   - Against a southpaw, take cover on their lead side from 30 to 40, or the liver multiplier against the lead side from 1.3 to 1.15.
4. **Build `BoutRead` mid-bout mode.** It takes the round number, both tanks, both rib meters and the cards so far. It returns the win chance for each crack-card choice. List it as the first build step, because the card can't ship without it.
5. **Define the hand lock for each stance** (list in point 4), and gray those pad cards with "Cracked rib" in the tooltip.
6. **Merge the side elbows into Elbows in** (both, right or left) so the corner keeps three fixes. Show the one-click Aim switch only once the tell "Hurt liver" or "Hurt ribs" is in the log.
7. **Pick the drain scaling:** Durability alone. Make the footnote match.
8. **Body knockdown target:** the owner sets it in body knockdowns per 100 bouts. My suggestion is 2–4 (ESTIMATE, no source found). The probe measures that, not a share.
9. **Add a rib-recovery camp block:** one week, no sparring, rib heal −20%, at the price of one week's training gain.
10. **State the gaps in the map:**
    - The right ribs can't fracture, by choice.
    - The opponent's switch matters in pro bouts only.
    - Layoff days lose to the crack outcome when the two bars clash.

## The 1920×1080 page (fight night, corner minute with a crack)

This is a dark full-screen modal over the ring, like the agreed fight night.

**Top strip (1920×72):**
- Round 2 of 3, with the bell clock.
- Scorecards as three judge chips.
- "Corner: [boxer name]" in the header. This is the only name on the page.

**Left column (560 wide), "Your boxer":**
- The tank bar and the head guard bar.
- A torso outline with the liver (right) and ribs (left). The cracked side is shaded red, labeled "Cracked rib (left)".
- Three status rows: "Left hand ×0.6 if fighting through", "Guard −10" and "Heals: 35–84 days".

**Centre (800 wide), the crack card, 720×520:**
- Title: "Cracked rib: what now?"
- Three option tiles, 220 each:
  - **Pull out:** 35 days off, stoppage loss −4 reputation and −12 morale, win chance 0.
  - **Defend the side:** no punches with that hand, guard −4, 63 days, win chance N in 100.
  - **Fight through:** that arm ×0.6, guard −10, 84 days with a 1 in 10 chance of 28 more, win chance N in 100.
- Each tile shows its win chance from `BoutRead` in large digits and its days off in smaller type.
- Below the tiles is one line from the coach in plain words, for example "The opponent is fading; the side will hold for one round".
- There's no default highlight, so the player must pick.

**Right column (560 wide), "The opponent":**
- Their tank and rib meters.
- The found tells as chips, for example "Breaks ribs" and "Drops right elbow".
- The opponent corner's chance to retire, for example "Their corner may stop it: 40%".

**Bottom strip (1920×120):**
- ONE CHANGE with three fixes: Habit, Elbows in (with a both, right or left picker) and Gloves high.
- "Time for two" is marked with two dots.
- The Aim switch button shows only after a found tell.
- CONTINUE sits on the right in the agreed accent color, apart from the green.
