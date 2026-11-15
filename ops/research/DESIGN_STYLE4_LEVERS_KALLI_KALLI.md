# DESIGN_STYLE4_LEVERS_KALLI_KALLI - Kalli answer (seat queue SQ174)

Brief: research/DESIGN_STYLE4_LEVERS_KALLI.md
Sent: 2026-11-15 12:10 | collected: 2026-11-15 12:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

On it: I'm writing one new lever each for Boxer-puncher, Counter-puncher and Slugger, plus a six-style matchup table and the 10/10 list.

# STYLE4: a lever for every style that the fight reads each round (S484 follow-up, 2026-11-15)

I didn't open the critic pack, the progression map (PROGRESSION_MAP_S448.md) or STYLE3_RESULT.md. This works from the table and the style pictures quoted in the brief. The three moves for each style come from map lines 144–150 (CHECK the names). Every new number is an ESTIMATE until Goose's harness runs it.

## The rule all three share (ask 3)
**A lever pays only through the style's moves.** Its strength is the lever × (style moves on the fighter's card ÷ 3), so one move gives a third and all three give full strength. A fighter with no style moves gets nothing. The lever never touches a stat. The rule also applies to the three existing levers, so the six styles behave the same way.

## 1. Boxer-puncher: "holds the middle, steps in behind the cross"
- **What it touches:** range, the same pull Out-boxer uses toward long range, but aimed at middle range.
- **The lever:** every exchange, the range pull goes toward middle by +0.10 (ESTIMATE, matching Out-boxer's +0.1). At middle range, a line that opens with the cross gets +0.05 plan edge (ESTIMATE).
- **Reads:** about 720, every exchange like Out-boxer. Applied about 720 for the pull, and the edge whenever range is middle.
- **Why it misses less than today:** today's version waits for an edge the plan already has. This one makes middle range happen.
- **Style card:** "Pulls the fight back to middle range, where the cross lands."

## 2. Counter-puncher: "held stance, steps back and returns"
- **What it touches:** counter exchanges and the opponent's missed punches. Most exchanges contain a miss.
- **The lever:** each opponent punch that misses gives the counter-puncher's next line +0.10 edge (ESTIMATE). That's capped at one return per exchange, so volume doesn't stack it.
- **Reads:** every exchange where the opponent throws, about 720. Applied in about 6 in 10 exchanges (ESTIMATE, the share with at least one miss). That's against 60 applied today.
- **Why it misses less than today:** "loads up or presses" was rare. A miss is common, and it's what a counter-puncher really feeds on.
- **Style card:** "Every punch the opponent misses opens a return shot."

## 3. Slugger: "rolls under, plants to hook"
- **What it touches:** damage per landed power punch, the hooks and uppercuts, at middle and short range. Today's lever touched knockdowns, which happen about 2 times in 100 bouts.
- **The lever:** landed hooks and uppercuts at middle or short range do ×1.15 damage (ESTIMATE). Damage wears the opponent down, so the knockdown chance rises through the bout without a separate roll.
- **Reads:** every landed power punch inside long range, about 300–400 (ESTIMATE), against 8 today.
- **The cost:** at long range the lever is off, so an Out-boxer who keeps the fight long switches it off.
- **Style card:** "Hooks and uppercuts that land up close hurt more."

## 4. Matchups across all six
Each style beats two, loses to two and has one even fight. So no style is best against everything, and Volume puncher now loses to Out-boxer and to Slugger.

| Style | Beats | Loses to | Even | Why |
|---|---|---|---|---|
| Out-boxer | Slugger, Volume puncher | Pressure fighter, Boxer-puncher | Counter-puncher | Long range switches off the slugger's damage and cuts combo chains. Pressure and the middle-range pull take long range away. |
| Volume puncher | Counter-puncher, Boxer-puncher | Out-boxer, Slugger | Pressure fighter | Short combos miss little, which starves counters, and they outwork the middle. Standing in front gets hooked. |
| Pressure fighter | Out-boxer, Boxer-puncher | Counter-puncher, Slugger | Volume puncher | Forcing range in beats both range-pullers. Pressing throws misses and walks into hooks. |
| Boxer-puncher | Out-boxer, Counter-puncher | Pressure fighter, Volume puncher | Slugger | Middle range denies long range. A measured cross-led line gives few misses to return. |
| Counter-puncher | Pressure fighter, Slugger | Boxer-puncher, Volume puncher | Out-boxer | Big and pressing punches miss often. Neither patient style offers many misses. |
| Slugger | Pressure fighter, Volume puncher | Out-boxer, Counter-puncher | Boxer-puncher | Opponents who come inside get hooked. Long range switches the lever off, and misses get countered. |

**Target per style:** worth 1.5–4 wins in 100 (the brief's band). Win share in a winning matchup about 55–60, and in a losing one about 40–45 (ESTIMATE, NOT COMPUTED).

**Out-boxer (0.8) and Pressure fighter (1.0)** sit below the band today. I'm not proposing new levers for them, because the ask covers three styles. Their numbers should be re-measured once the matchup table above exists, since both gain a clear victim from it.

## 5. Kit gaps
- Style cards need one line of 60 characters or fewer. All three lines above fit.
- A matchup line on the opponent card ("Style edge: yours" or "theirs") isn't in the kit. That's for Claude or the owner to rule on.

## To reach 10/10 (most important first)
1. **Run the six-by-six matchup grid** in Goose's harness, 20 fighters × 20 bouts a cell, with reads, applied and worth for each lever. Pass when every style is worth 1.5–4 wins in 100 and none has a winning record against all five others.
2. **Measure each matchup's win share** against the table in section 4. Any "beats" cell under 52 or any "loses" cell over 48 means that lever's number gets tuned first.
3. **Check the gate:** with 1 style move on the card the lever pays a third, with 3 it pays full, and with none it pays zero. Probe all three cases for each style.
4. **Cap the counter return** at one per exchange in the probe. Report how many returns fire per bout against Volume puncher (they should fall well below the count against Pressure fighter).
5. **Confirm the slugger's damage feeds the knockdown chance** through accumulated damage rather than a separate roll. Report knockdowns per 100 bouts before and after (ESTIMATE: up from about 2).
6. **Re-measure Out-boxer and Pressure fighter** under the new table. If either stays under 1.5, send it a lever brief (STYLE5).
7. **CHECK the move names** from map lines 144–150 against each lever's trigger. For example, Slugger's three should include a hook or uppercut, or the gate means nothing.
8. **Ship the style-card lines** in the size-12 kit. Add the "Style edge" line to the opponent card only if the owner rules it in.
9. **Show the lever on the fight log:** "Return shot", "Pulled to middle" and "Heavy hook", each logged when it fires, so the player sees the style working. That needs a log line, and the game may not have one yet (CHECK).
10. **Update the critic pack** with the six levers and the matchup table when they land (S403).
