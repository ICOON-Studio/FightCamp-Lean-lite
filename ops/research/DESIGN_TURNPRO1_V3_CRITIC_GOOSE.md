# TURNPRO1_V3 CRITIC — Goose (Independent Review)

**Critic**: Goose (cloud agent, fresh eyes)  
**Discipline**: Sports management-sim design  
**Date**: 2026-11-19  
**Files read**: 
- `ops/research/DESIGN_TURNPRO1_V3_CRITIC_DOLA.md` (the brief)
- `docs/TURNPROBE2_RESULT.md` (v2 probe results)
- `scripts/state/ProOfferWire.gd` (v2 implementation)
- `scripts/rules/ProCall.gd` (v2 rules)

**NOT read**: Any other critic's file (per instructions).

---

## SCORE depth=7 general=7

---

## DEPTH — 7/10

**What works:**

1. **Day-job path is a genuine second road**. v2 had no visible path for boxers without stipend — they just signed at a loss or never turned pro. v3's "save $150/week for 8-12 weeks, then defer costs" gives half the population a viable alternative. This is the single biggest depth improvement.

2. **Five asks with distinct situations** is better than v2's six asks where three were useless. The situation detection (later4 when bout booked, softer when injury risk high, split when forecast strong, price when membership large, defer when cash low) means each ask has a real use case.

3. **Door closes after 3 declines** adds consequence. v2 had no penalty for declining, so players could wait forever. Now there's a real cost to saying no too many times, and the national title reopen is a nice touch.

4. **Ambition influences decisions** is good. A boxer who wants to turn pro pushing for it, or a title-chaser asking to wait until after nationals, makes the boxer feel like a person, not a spreadsheet row.

**What's missing or weak:**

1. **The day-job path is mechanically simple**. "Wait and save money" is not a deep choice — it's just patience. There's no interesting decision within the path (no "do I take this amateur bout now or wait for a better one?", no "do I bid for a club grant to speed up the fund?"). It's a timer, not a choice.

2. **Some asks still overlap**. Later+4 and softer both delay the debut. A player with a bout booked AND high injury risk has two good asks and must pick one — but they're solving similar problems (more time). The design says they're distinct, but mechanically they're both "push the date back."

3. **No interaction with the rest of the game**. The turning-pro decision doesn't touch training, camps, the playbook, or the corner. It's isolated in the offer modal. A deeper design would let the day-job path affect camp quality (less money = lighter camp), or let ambition affect training intensity (a pro-eager boxer trains harder, a cautious one trains safer).

4. **The dual timeline is confusing**. Showing "stipend path" and "day-job path" side-by-side on NEXT STEP is honest, but it's two numbers to track. A human manager weighs one thing: "can I afford this now?" The design splits that into two ledgers, which is more complex without being more interesting.

**What each option changes:**

- **Later+4**: Pushes debut back 2 weeks, costs $300 purse. Useful when an amateur bout is booked and you can't reschedule.
- **Softer opponent**: Drops opponent by 0.5 rating, but next 2 pro offers are tune-ups (slower ladder). Useful when injury risk is high or stamina is low.
- **Better split**: +10% ticket share (taken) or +5% (countered), but opponent gets harder (taken) or unchanged (countered). Useful when forecast is strong and you're confident.
- **Own ticket price**: $40 tickets (down from $50), +15 extra tickets sold. Useful when membership is large and loyal.
- **Defer costs**: $0 up-front, but $1,345 deducted from purse (vs $1,245 if paid now). Useful when cash is low.

---

## GENERAL DESIGN — 7/10

**What works:**

1. **Clear structure**. The design is well-organized with tables, pass lines, and build order. A developer could read this and know what to build.

2. **Numbers mostly match the code**. Bow Lane's $1,500 purse, 60 break-even, -$25/ticket short, $500 floor, 4 weeks, -1.0 opponent — all match `ProCall.gd`. HF's $1,800 purse, 70 break-even, 30% share, 6 weeks, -1.5 opponent — all match. The constants are consistent.

3. **Failure paths teach**. Showing "Forecast −$870 · Actual −$915 · Levers: defer costs, build more members" after a losing debut is honest and helps the player learn. The door-closing message, the age warning, the deferral cost comparison — all clear.

4. **Buildable from v2**. The day-job path uses existing systems (dues, cuts, amateur bouts). The asks use the existing ask system. The door-close logic uses the existing decline counter. Nothing requires new screens or new mechanics outside the offer modal.

**What's inconsistent or broken:**

1. **v3 says "5 redesigned asks" but the code has 6**. The v3 design claims to have merged later+2 into later+4, but `ProCall.gd` still has both `LATER2_PURSE_CUT := 150` and `LATER4_PURSE_CUT := 300`. The code has 6 asks: later2, later4, softer, split, price, costs. The v3 design lists 5: later4, softer, split, price, defer. This is a discrepancy — either the design is wrong or the code hasn't been updated.

2. **The split ask numbers don't match**. v3 says "+8 pts" for the taken split, but the code has `SPLIT_TAKE_SHARE := 0.10` (10 points). v3 says "+4 pts" for the counter, but the code has `SPLIT_COUNTER_SHARE := 0.05` (5 points). The design and code disagree.

3. **The defer costs fee is confusing**. v3 says "$1,345 from purse" = $1,245 base + $100 fee. But the code has `COSTS_BASE_ADD := 100` and `COSTS_RUNWAY_ADD := 200`. The code charges a $200 fee when runway is short (<8 weeks), not $100. v3 says "+$100 fee when runway <4 weeks" which is ambiguous — does it mean the fee goes up by $100 to $200, or the fee is $100 when runway is short? The threshold also differs: v3 says 4 weeks, code says 8 weeks.

4. **The day-job path's "save $150/week" is not in the code**. The design says the player puts aside $150/week from dues + cuts, but there's no mechanism in `ProOfferWire.gd` or `ProCall.gd` for this. It's a design proposal, not a built feature.

5. **The ambition morale modifiers are not in the code**. v3 says "Turns pro: +5 morale" and "Wants national title: -5 morale; performance -5% at debut", but `ProCall.morale()` only returns -5 or +5 for pro/title ambition when staying or going, with no performance modifier. The design proposes changes that aren't built.

6. **The "national title reopens the door" is not in the code**. v3 says winning a regional title reopens a closed door once, but `ProOfferWire.gd` has no logic for this. It's a design proposal.

**What's useless:**

- **None of the asks are useless** — each has a situation where it's best. This is a real improvement over v2.

**What's missing:**

- **A "sign now, pay later" option**. The design has "pay now" (stipend path) and "defer to purse" (day-job path), but no "sign now and pay the costs from future purses over 2-3 fights." This would give a third road: turn pro immediately without the up-front hit, but commit a share of the next few purses. It's a real option in boxing (promoters often front costs and take a cut).

- **A "negotiate the debut date" option**. The design fixes the debut at 4 or 6 weeks out, but a player might want to push it back further (8 weeks) to build more tickets, or bring it forward (2 weeks) for a lower purse. This would add a slider or a second ask.

---

## To reach 10/10

**Most important first:**

1. **Make the day-job path mechanically interesting**. Add 2-3 decisions within the path: "Bid for a club grant ($500, 42-day wait, 50% chance)" or "Take a paid sparring session ($200, -1 day training)" or "Ask a member to sponsor the debut ($300, +2 loyalty)." Each decision should have a visible cost and benefit, not just a timer. This turns the day-job path from "wait" into "work for it."

2. **Fix the discrepancies between the design and the code**. The split ask should be +10/+5 (code) or the code should be updated to +8/+4 (design). The defer fee should be $100 at 8 weeks (code) or the code should be updated to $100 at 4 weeks (design). The number of asks should be 5 (design) or 6 (code) — pick one and make them match. A design that doesn't match its implementation is not finished.

3. **Add a "sign now, pay later" option**. Let the player turn pro immediately and deduct the $1,245 costs from the next 2-3 purses (say, 20% of each purse until paid). This gives a third road: no up-front cost, no waiting, but a commitment to the promoter. It's a real boxing practice and adds depth.

4. **Let the player negotiate the debut date**. Add a slider or ask: "Debut in 2 weeks (-$400 purse), 4 weeks (standard), 6 weeks (+$200 purse, +10 tickets)." This gives the player control over the timeline and adds a trade-off (speed vs money vs tickets).

5. **Connect the turning-pro decision to the rest of the game**. Let the day-job path affect camp quality (less money = lighter camp, -10% stat gains). Let ambition affect training intensity (pro-eager boxer trains harder, +5% gains; cautious boxer trains safer, -10% injury risk). This makes the turning-pro decision touch the week, the camp, the fight — not just the offer modal.

6. **Simplify the dual timeline**. Instead of showing "stipend path" and "day-job path" side-by-side, show one number: "Cash at signing: $X" and "Weekly swing after signing: +/-$Y." The player doesn't need two ledgers — they need one clear picture of what they can afford.

7. **Add a "walk away" option**. Let the player decline all offers and continue the amateur career with no penalty (other than aging). v2 has "Stay amateur" which counts as a decline. v3 should let the player say "not yet" without it counting against them, as long as they're under 32. This matches real boxing (boxers often turn down early offers to build their amateur record).

---

## 10/10 as a 1920×1080 page

**Layout**: The offer modal is a contract on a desk, two copies side-by-side (Bow Lane left, Harrow & Finch right). Each contract shows:

- **Header**: Promoter name, debut date, opponent name and record
- **The money**: Purse, ticket share, break-even, tickets forecast, gym at signing, weekly swing, weeks to even
- **The asks**: Five buttons, each with a situation tag ("Bout booked", "Injury risk high", "Forecast strong", "Membership large", "Cash low"). Hover shows the price and the counter.
- **The roads**: Three tabs at the bottom: "Sign now (stipend)", "Save the fund (day-job)", "Pay later (future purses)". Each tab shows the cash at signing, the weekly swing, and the weeks to even.
- **The boxer's say**: A line at the top: "She's eager — +5 morale" or "Wants nationals — -5 debut performance" or "Neutral — follows your call"
- **The clock**: A 14-day countdown in the corner, red on the last 3 days
- **The buttons**: "Turn pro with <promoter>" and "Stay amateur (not yet)" and "Walk away (no penalty)"

**Visual style**: Look B — warm tan plaster wall, wood frame, cream paper, marker fonts. The contracts are polaroids with handwritten notes in the margins. The asks are sticky notes. The roads are a whiteboard with a progress bar.

**No names in text**: The body says "your boxer", "the opponent", "the promoter". Names only in headers.

---

## Probe verdict

**Would v3's changes move the 8 failing v2 probe lines?**

1. **No bot dominates (>60%) w104 cash** — v3's day-job path gives PREP and RANK a viable road, so they should sign more often and close the gap with YES. Likely to pass, but the day-job path is mechanically simple (just waiting), so the improvement may be modest. **Verdict: likely pass, but not convincingly.**

2. **PREP beats YES by ≥$1,500 at w104** — v3's day-job path lets PREP save money and defer costs, which should improve its w104 cash. But the design doesn't change PREP's core strategy (prepare more, sign later), so the improvement depends on how much the day-job path helps. **Verdict: likely pass if the day-job path is built as described.**

3. **Stipend timing** — v3's dual ledger shows the stipend path and day-job path side-by-side, which should help the player choose. But the design doesn't change the underlying math (stipend = +$175/week, day-job = -$75/week), so the timing should be the same as v2. **Verdict: unlikely to pass without changing the constants.**

4. **YES debut loses money 40-70% (stipend only)** — v3 says "Constants tuned" but doesn't specify which constants. The v2 code has `PURSE_FLOOR := 500` and `SHORT_TICKET := 25`, which determine the debut purse. To move from 27% to 40-70%, the purse floor would need to drop or the short-ticket penalty would need to increase. **Verdict: unlikely to pass without specific constant changes.**

5. **Door closes 10-20%** — v3 adds door-close logic (3 declines = closed), which should move this from 0% to 10-20%. **Verdict: likely pass if the logic is built.**

6. **Win rate 65-80% at -1.0, 70-85% at -1.5** — v3 says "Opponent gap adjusted" but doesn't specify the new gaps. The v2 code has `opp_gap: 1.0` for Bow Lane and `opp_gap: 1.5` for HF. To move the win rates into the target bands, the gaps would need to be tuned (e.g., -1.2 for Bow Lane, -1.7 for HF). **Verdict: unlikely to pass without specific gap changes.**

7. **Each ask best in ≥10% offers** — v3's situation detection should help, but the design has discrepancies with the code (5 asks vs 6, split numbers don't match). If the design is built as described, this should pass. **Verdict: likely pass if the design is built correctly.**

8. **HF picked ≥25%, both call 25-50%** — v2 already passes this. **Verdict: already passes.**

9. **Ambition aligns ≥70% decisions** — v3's ambition morale modifiers should help, but the design proposes changes that aren't in the code (+5 morale for pro, -5 for title, -5% performance for title at debut). If built as described, this should pass. **Verdict: likely pass if the modifiers are built.**

**Overall**: v3's design changes would likely move 5-6 of the 8 failing lines, but 2-3 lines (stipend timing, debut loss rate, win rates) need specific constant changes that the design doesn't specify. The design is a good start, but it's not complete — the constants need to be tuned and the discrepancies with the code need to be resolved.

---

## Summary

v3 is a solid improvement over v2. The day-job path is a genuine addition, the asks are better designed, and the failure paths teach. But the design has discrepancies with the code (5 asks vs 6, split numbers, defer fee), the day-job path is mechanically simple, and some probe lines need specific constant changes that the design doesn't specify. To reach 10/10, the design needs to make the day-job path more interesting, fix the discrepancies, add a "pay later" option, and connect the turning-pro decision to the rest of the game.

**SCORE depth=7 general=7**
