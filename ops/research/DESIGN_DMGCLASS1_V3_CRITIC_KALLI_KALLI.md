# DESIGN_DMGCLASS1_V3_CRITIC_KALLI_KALLI - Kalli answer (seat queue SQ275)

Brief: research/DESIGN_DMGCLASS1_V3_CRITIC_KALLI.md
Sent: 2026-11-21 16:10 | collected: 2026-11-21 16:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I'm scoring DMGCLASS1 v3 from the pack and the map. The repo still isn't reachable from here, so I can't open `CRITIC_ACCESS.md`.

# DMGCLASS1 v3: critic score (S459, fresh critic, 2026-11-21)

**Depth 5 · General design 6 · Play 5.** As a piece of engineering and honesty, v3 is a big step up. It withdraws invented numbers, uses one knob instead of three, gives every boxer shape a cell, and builds a probe that can fail. But its own evidence argues the mechanic away: inside 55 to 75 kg, weight barely moves stoppages. What's left is mostly reads beside buttons the game already has, and the one sex factor is fitted where it should be derived.

## Depth: 5 / 10
**What works**
- **The turn-pro line is the real decision, and v3 found it.** Section 2's biggest real step is the ruleset (amateur about 5-12 in 100, pro 29 for women and 47 for men, all COUNTED). Putting it on the turn-pro call, beside buttons that already exist, prices "Stay amateur" for a thin-chinned boxer.
- **Chin against the field** is a true read: "protect early / can be moved fast / a puncher here", with half the 12-point scale as the line. It gives the signing card something to weigh.
- **The towel row gets a per-cell frequency** ("the card comes about 1 fight in N here"), so the line pick means something in each cell.
- **The camp line** (more chin means fewer stoppages here) ties the week to fight night.

**Why it stops at 5**
1. **The class itself is never a choice.** No code moves a boxer to another class (1.3), and the move is pushed to MOVECLASS1. At signing the player picks from a handful of walk-ins and prospects, each with a fixed class. So "which class you sign" means which person you sign, and the deciding fact is that person's chin, not the class.
2. **The read mostly says the same thing in every amateur cell.** Women's amateur weights are flat (10.6 / 9.5 / 11.2, COUNTED), and the men's slope is a small UNVERIFIED 0.15. The THIS DIVISION rates on the signing card and the perk-road tail will print nearly the same number in every amateur division. By the owner's rule, a number that never changes a pick is noise.
3. **The field read measures hand-written data, not a rule.** The map itself says the men's amateur rivals are rated lower (53-62) than the women's (58-65). "Chin against this field's punch" will tell men's boxers they're safer because of how `Data.DIVISION_RIVALS` was typed. The probe keeps the rule and the pools apart, but the signing row doesn't.
4. **The camp line points at a lever the camp doesn't have.** Camp focus is Conditioning, Power, Technique, Defence or Speed, with no chin or Durability. Even through neck-work mornings, four points is about 3 weeks of five Hard neck mornings: 1.0 a focused week, x1.3 Hard, and the coach factor about 0.9-1.0 (DERIVED from 4.1; that neck work raises Durability is CHECK). That collides with red days and overreach. Telling the player "four more chin this camp" when it isn't reachable breaks "only actionable information".
5. **Turning pro is priced, but waiting isn't.** The line shows the pro rate now, not what Stay amateur buys (more chin, more wins, a later and safer debut). Without that contrast it's a warning, not a trade-off. Real boxing shows the cost of not waiting: an Olympic lightweight silver medallist, Amir Khan, was knocked out in the first round by Breidis Prescott in 2008, three years into his pro career. His chin against the pro field was the open question, and an amateur medal didn't answer it.

## General design: 6 / 10
**What works**
- Section 1.6 corrects every false v2 claim. The withdrawal of the sixteen ranges in section 2 is exemplary, and the trust tags (CODE, COUNTED, UNVERIFIED, ESTIMATE) are used honestly.
- One `count_mult`, read at the two count chances before the caps, with damage and the hurt rolls untouched. That's buildable and keeps every rest, injury and stand-down rule class-free.
- "One cell per bout, taken once, both sides get it" is the right rule, backed by the owner's rulings, with a test that fails on an empty cell. Emptying the cache between arms is a good catch.
- The probe has a control, a fit and a mutant arm that must fail, and a void rule if the control passes everything.

**What it loses points on**
1. **The women's pro factor contradicts the map's own honesty line.** Section 2 says per minute the sexes are "nearly equal", the gap is round length, and a hidden "women hit softer" number would be dishonest. Then 3.2 fits a separate women's pro anchor, which is exactly a per-round "softer" number found by fitting. Counts roll once a round (`Knockdowns.round_counts`), so a two-minute round is 4 of the 6 exchanges: the factor can be **derived** as pro anchor x 4/6 and labelled as round length. 4/6 = 0.67 sits inside the map's own 0.50-0.75 bound, so the bound becomes a check instead of a fit, and one fitted number disappears.
2. **The pro targets aren't the same kind of bout as the fit.** 29 and 47 are every BoxRec bout from 2014 to 2024, padded records and journeymen included, with many 4-rounders. The world arm fits on 6/8/10-round bouts between boxers rated 64-80, which are far closer matches. Fitting close bouts to a mismatch-heavy rate inflates the anchors. Either weight the world arm by a real gap mix, or find a rate for competitive bouts. Until then, both pro anchors are suspect.
3. **Two colour rules for one danger.** The towel keeps absolute lines because "a corner judges absolute danger" (4.1 row 4). The offer rows go relative to the cell, so in the men's pro cell a 40% stopped chance could show amber. Pick one: absolute colours for danger, with the cell's usual number printed as text.
4. **The towel's price is left wrong.** An RTD still counts as a stopped loss in five places (1.4): members and reputation, the +8 pro rest weeks, the lesson cut, a double loyalty hit and the knowledge read. The towel is this mechanic's main fight-night decision, and pulling out costs as much as being stopped plus 14 days. Handing that to "the main session" leaves the core trade-off mispriced in every cell.
5. **The class list.** Section 1.3 gives men's amateur classes as 55 / 60 / 70 / 75 (the code). The owner's standing list is men's 57.5 / 60 / 70 / 75. Either the code or the ruling is out of date. Flag it to Claude, because the cell lookup reads `limit`.
6. **Scope is fine.** Five build steps, each small, with a menu table that names "Nothing" where nothing changes. That's the right instinct.

## Play: 5 / 10
- The good moments are the turn-pro call ("as a pro here about 47 in 100 end early") and a Why sentence after a stoppage that names punch against chin.
- Week to week, nothing new pulls the player back. The camp line can't be acted on as written, the perk tail repeats itself in amateur cells, and the class can't be changed. There's anticipation only at two moments in a career (signing, turning pro).
- The sandbox gains a real difference between men's and women's careers. That's good, as long as it reads as round length on screen and not as a hidden rule.

## Options: what each changes, what's missing, what's useless (S403)

### What each option changes (as v3 writes it)
| Option | Changes | Verdict |
|---|---|---|
| `count_mult` per cell | How often a clean shot brings a count, so how often bouts end early, in watched and world bouts | Keep. Derive women's pro instead of fitting it |
| THIS DIVISION row (interview, trial) | Shows two rates, chin against the field and the read, beside Sign / Pass and the starting focus | Keep the read. Drop the amateur rate where cells match |
| Prospect card line | The read as a range (plus or minus 5) | Keep |
| Turn-pro line | Pro against amateur rate, chin against the pro field | Keep, and add what waiting buys |
| Ask and late-ask word shift | Unlikely / possible / a real risk moved by `12 x ln(count_mult)`. The maths is right: the count chance grows by e every 12 points | Keep. 0 in the control cell |
| Offer-row colours relative to the cell | Amber and red move with the cell's usual | Change: absolute colours, usual as text |
| `stop_chance` fallbacks and day-one KO share from the cell | Day-one records agree with what the world produces | Keep |
| Towel row: "1 fight in N here" | Prices each line per cell | Keep |
| Towel strip: "A usual round here" | Context for the next-round risk | Keep |
| Camp card chin line | Should move what's trained | Not actionable as written (Depth 4) |
| Perk-road tail | "A count comes about 1 bout in N here" on Iron chin and Finisher | Only where it differs: pro, or men against women |
| Why sentence after a stoppage or towel | Names the night's punch over chin against the usual | Keep |

### Missing
1. **What Stay amateur buys:** the pro rate at today's chin against the forecast chin after N more weeks and wins.
2. **A chin lever with a real number:** neck work's forecast to fight night on the camp card or the Week goal line, or Durability added as a camp focus (an owner call, because it's a new pick).
3. **A fair towel price:** an RTD costs like a points loss plus the 14 days.
4. **Moving a class:** without it, "class" is never a choice. MOVECLASS1 needs a slot in the order of work, not "later".
5. **A rule that matches the target to the bout:** fit the pro anchors on a gap mix that matches the source.

### Useless or near-useless
- The amateur division rates on the signing card where the cells sit within 3 points (all women's amateur).
- A separately fitted women's pro anchor.
- Relative offer colours.
- "Four more chin this camp" as a number nobody can reach.

## To reach 10/10 (most important first; sizes are ESTIMATES for the probe)

1. **Derive sex from round length.**
   - Women's pro `count_mult` = the pro anchor x 4/6, because a two-minute round is 4 exchanges of 30 seconds. Write it as round length in `ClassDamage`, and show "two-minute rounds" on the turn-pro line.
   - Men's amateur stays the one fitted sex number, about 1/0.83 = 1.2 from John's per-minute ratio, until the John brief checks it.
   - The 0.50-0.75 ratio bound becomes a check, not a fit.
   - That leaves at most four fitted numbers: the men's amateur anchor, one pro anchor and up to two slopes.
2. **Fit the pro anchors on comparable bouts.**
   - The probe's world arm reports stoppages by rating gap.
   - The fit uses the gap mix of real pro cards, or a COUNTED rate for competitive bouts that John finds.
   - Add 4-round player bouts to the mix.
   - If no such source exists, mark both pro anchors UNVERIFIED and keep the bound wide.
3. **Price the towel properly, here.** An RTD counts as a points loss (1 member, 2 reputation) plus the towel's 14 days out. No +8 pro rest weeks, no stopped-lesson cut, and no "stopped" loyalty on top of the towel's own. Change those five places in `BoutFinish.run`, with one test.
4. **Price waiting on the turn-pro call.** Add a third line: "Stay amateur 8 more weeks: chin about X by then, pro early endings about M2 in 100." X comes from the Week's own Durability forecast at the current plan, and M2 from the cell at the new chin. Stay amateur then has a number to beat.
5. **Make the chin line actionable.** On the camp card, show the Durability forecast to fight night from the current mornings, and the stop chance at that forecast against this opponent: "Neck work 3 mornings a week: chin 58 to 60 by fight night, 1 fewer stoppage in 100." Separately, ask the owner whether Durability joins the camp focus list.
6. **Read the field from a fair pool.** The signing read compares chin against the division's pool after a parity check. If men's amateur rivals sit 5 points lower by accident, fix `Data.DIVISION_RIVALS` first. If it's on purpose, the owner says so and the read stays.
7. **Show only what differs.**
   - The signing card shows the read (protect early / can be moved fast / a puncher here) and the pro rate.
   - The amateur rate shows only where it sits 3+ points from the women's amateur control.
   - The perk-road tail shows the same way.
   - Probe bound: each read word goes to 10-50 in 100 of the real prospects and walk-ins, or the thresholds move.
8. **Use one colour rule for danger.** Offer rows keep absolute lines (red 15, amber 7 for the stopped chance), and the row adds "usual here: N". The towel does the same, as it already does.
9. **Settle the class list.** Ask the owner whether the men's lightest amateur class is 55 or 57.5, then fix the code or the ruling before `ClassDamage` reads `limit`.
10. **Schedule MOVECLASS1** as step 6 in section 7, at the turn-pro call first ("Debut at welterweight"), using the cell's `count_mult` and the chin-against-field read of the next class.
11. **Two more probe bars.**
    - The ratio of women's pro to men's pro from round length alone falls inside 0.50-0.75.
    - The turn-pro wait line's predicted M2 is within 3 points of a measured run at the forecast chin.

Everything except the camp focus question and MOVECLASS1 builds from code the map already names.

## The 10/10 page at 1920×1080: the turn-pro call
It's in the Look B office: the whiteboard on the warm plaster wall, Kalam marker notes, numbers in IBM Plex Mono, Bebas Neue heads, nothing under 12 px. There's one figure, your boxer's existing comic portrait, head to feet, as a polaroid at the left. Gold goes on the coach's pick only. No green. All figures are **example data**.

- **Header** (0–90 px): "THE PRO CALL", the boxer's name once, women's lightweight 60 kg, 8-1, chin 58.
- **Left third:** the polaroid, record, the two houses' terms in the shape built in S523, and "Offer stands 9 days · 2 declines left".
- **Centre, three stacked rows on the whiteboard:**
  1. **Amateur here:** "Bouts end early about 9 in 100." Small, because nothing hangs on it.
  2. **Pro here:** "About 29 in 100 end early · two-minute rounds." Underneath is the read against the pro field's punch, 64: "Chin 58 · protect early". The arrow is drawn in marker.
  3. **Stay amateur 8 more weeks:** "Neck work 3 mornings: chin about 61 · pro early endings about 24 in 100 · the call comes back after 2 more wins." The gold box is around this row with the coach's note: "Two more on the chin and she's ready."
- **Right third:** the buttons "Turn pro with Bow Lane", "Turn pro with Harrow & Finch" and "Stay amateur", all slate, each with its morale line. Hovering a row's number breaks it into parts: ruleset, round length, chin against punch.
- **Foot strip:** "Same price in every class: a stoppage is 30 days out and 2 off the chin ceiling. Only how often it happens changes."
- **Motion:** the bars tween when the mouse moves from Turn pro to Stay amateur, so the rate visibly drops from 29 to 24. Nothing opens by itself.

DMGCLASS1 v3 scores Depth 5, General design 6 and Play 5, so it misses the 7+ bar on both. The engineering and the honesty about the evidence are much better than v2.

The trouble is that its own evidence shows weight barely changes stoppages, and the class can't be chosen after signing. That leaves mostly reads beside buttons the game already has.

The fixes that matter most:
- Derive the women's pro factor from two-minute rounds instead of fitting it.
- Fit the pro numbers on fair matchups, not on all BoxRec bouts.
- Price a towel as a points loss, not as a stoppage.
- Put on the turn-pro call what staying amateur buys.

One thing needs your call: the code has men's lightest amateur class at 55 kg, but your ruling says 57.5 kg.
