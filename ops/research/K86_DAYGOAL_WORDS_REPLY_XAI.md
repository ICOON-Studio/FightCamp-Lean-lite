# Kalli reply via xAI API (model grok-4.7, route responses+web_search (stream), 5045 chars, 168 s)
# Task: research/TASK_K86_DAYGOAL_WORDS.md

The plate is a coach target with a printed payout, not a third vital. Old copy failed because “at the bell” and an orange underline read as another stamina bar.

**1. Copy** (drop in as-is; counts include spaces)

Header, 31: `COACH: +3 morale, +2 trust each`

Stamina line, 31: `End last block with stamina 30+`

Jab line, 32: `Jab reaches Usable before Friday`

Resolved, same rows, still under 40:
- Met: `Met. +3 morale, +2 trust`
- Stamina miss: `Missed. Ended at 29.` (print the real end value)
- Jab miss: `Missed Friday. No bonus.`

Reward stays on the header and on the Met line. The live line is only the win condition. “Usable” stays capitalized so it matches the stage name already on the jab station. No “bell”.

Payout is the bonus already in the design, locked so the sentence can name it: **+3 morale and +2 coach trust per goal, once, when that line resolves.** Two goals can pay. A goal cannot pay twice.

**2. How progress reads**

Reuse the stamina icon on row 1 and the jab-station icon on row 2. Underline is 2px, directly under the words, not beside the vitals.

Stamina row — a finish check, not a grind:
- Right-hand chip is current stamina, same number and same color as the stamina bar. Example: `41`.
- Underline stays at **0%** all day. Filling it would lie, because stamina can still fall.
- No ticks. No partial credit. **30 pays. 29 pays 0.**
- Last block ends: chip freezes. If stamina ≥ 30, underline snaps to 100% in the game’s existing positive color, icon becomes a check, text becomes the Met line, morale +3, trust +2. If ≤ 29, underline stays 0%, icon becomes an X, text becomes `Missed. Ended at {n}.`, both stats do not move.

Jab row — the station’s own meter, copied, not recalculated:
- Chip is the Usable percent already on the jab technique. Example: `60%`.
- Underline fills to that same percent. Other stations do not move it.
- Five ticks under the line, the day letters the week already uses, through Friday. A tick fills when that day ends, drilled or not. Ticks are time left, not credit.
- The moment the station flips to Usable, it pays once, text becomes the Met line, ticks hide, row is no longer live. Friday close under 100% (including 99%) pays 0 and shows `Missed Friday. No bonus.`

Miss is not a fine. Gains already earned stay.

If abused:
- PACE YOURSELF on every block (gains ×0.75, drain ×0.60) can lock the 30. You still only get +3/+2. The plate does not refund the 25% gains, and this payout does not change gains, drain, or card strength.
- POWER THROUGH (gains ×1.30, drain ×1.25) can buy the miss. You keep the extra gains and get 0 from the row. That is allowed. The plate is pressure, not a tax.
- CRISP FORM (+35% card drill, no drain change) can finish Jab and still miss 30. One card cannot clear both lines.
- Cap is already two goals. Stamina pays once per day. Jab pays once per goal, then the row hides. No third goal, no re-roll after the last block, no second Jab claim Tue–Fri.

**3. Where and when**

Same spot: top-left, under the fighter name, under the stamina and strain bars, left-aligned to the name. **8px gap below the strain bar** so the underline cannot merge with it. Never between the name and the bars. Never to the right of the bars.

Selected fighter only. **Hidden when that fighter has no live goal.** Do not show an empty plate. One goal shows the header plus that row. Stamina row: day start through resolve, Met/Missed stays until the day advances, then gone. Jab row: from the day it is set until it pays or Friday misses, including days you do not drill jab, then gone.

**4. Demo**

Keep it in the demo: it is the only line on the floor that says what the intensity cards are for, and one resolved day teaches it.

**5. First-hour path** (mechanics already on)

1. Gym floor. Click the fighter. Name, stamina, strain, and the plate appear under the bars.
2. Read the header: coach, +3 morale and +2 trust for each goal met.
3. Read row 1, `End last block with stamina 30+`, and the chip. It matches the stamina bar. The underline is empty and stays empty.
4. Read row 2, `Jab reaches Usable before Friday`, the percent, and the day ticks. That percent matches the jab technique.
5. Open a block. Cards on offer are POWER THROUGH (+30% gains, 25% more burn), CRISP FORM (+35% card drill), PACE YOURSELF (−25% gains, 40% less drain).
6. Put PACE YOURSELF on a block if the chip is close to 30. You are buying the finish line with gains. Put POWER THROUGH on another block and watch the chip drop after that block. The underline still does not fill.
7. Run the non-jab blocks. Jab percent and jab underline do not move.
8. Go to the jab station. Drill with CRISP FORM. Station percent and plate underline move together.
9. End the last block. ≥30 swaps row 1 to `Met. +3 morale, +2 trust` and those two stats rise by that. ≤29 swaps to `Missed. Ended at {n}.` and they do not rise.
10. Leave the jab row up. It pays the same Met line once, when the station hits Usable, or it misses at Friday close. It does not pay on the days in between.
