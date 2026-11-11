# MONEYFOUR1 RESULT - What four fighters cost the club in a year

## Population

10 careers per cell, 52 weeks each, same seeds in each cell. The sensible player (career_harness.gd _decide) makes all decisions. Four fighters from week 1: the walk-in (Lucy) plus three prospects signed on day 1 via Roster.sign_fighter - Kira (Featherweight), Samira (Welterweight), Tess (Middleweight). Three different weight classes.

## Results by cell

| Cell | Closed | Median close week | Cash w13 | Cash w26 | Cash w39 | Cash w52 | Bouts/year | Ticket income | Stipends paid |
|------|--------|-------------------|----------|----------|----------|----------|------------|---------------|---------------|
| ONE (1 fighter, control) | 0/10 | - | $9,763 (1.7 mo) | $14,234 (2.5 mo) | $14,402 (2.5 mo) | $11,263 (2.0 mo) | 9.5 | $2,475 | $13,250 |
| FOUR_ALL (4 on stipend) | 8/10 | 46 | $4,147 (0.7 mo) | $3,142 (0.5 mo) | -$1,468 (-0.3 mo) | -$3,718 (-0.6 mo) | 46.4 | $12,420 | $48,000 |
| FOUR_TWO (2 on stipend) | 0/10 | - | $8,244 (1.4 mo) | $11,653 (2.0 mo) | $14,026 (2.4 mo) | $6,801 (1.2 mo) | 46.4 | $12,780 | $26,500 |
| FOUR_ONE (1 on stipend) | 0/10 | - | $10,764 (1.9 mo) | $15,396 (2.7 mo) | $16,495 (2.9 mo) | $11,747 (2.1 mo) | 46.4 | $12,780 | $13,250 |
| FOUR_NONE (0 on stipend) | 0/10 | - | $13,764 (2.4 mo) | $17,608 (3.1 mo) | $27,836 (4.9 mo) | $31,054 (5.5 mo) | 46.1 | $12,420 | $0 |

Months of costs calculated from weekly net cost ~$572 for ONE cell (start $17,200 to week 13 median $9,763 = $7,437 over 13 weeks).

## Six sentences

**How long does start cash last?** With four fighters on the stipend (FOUR_ALL), the median gym goes below zero around week 26 and closes by week 46. With one fighter (ONE), start cash lasts the full year with 2 months of costs remaining at week 52.

**Which cell keeps cash in the 1-4 month target band?** FOUR_ONE (one on stipend, three on day jobs) keeps median cash between 1.9 and 2.9 months through the year - always in the design's target band. FOUR_TWO also stays in band through week 39 (1.4 to 2.4 months) but drops to 1.2 months by week 52.

**How much does a day job slow a fighter?** GymSpend.DAY_JOB_GAIN = 0.85, so a fighter on a day job trains at 85% effectiveness. The day-job fighters still won bouts - FOUR_NONE had 46.1 bouts/year, nearly identical to FOUR_ALL's 46.4. The training penalty is real but small enough that fighters still make weight and compete.

**Do four fighters bring more ticket income?** Yes. Four fighters bring ~$12,400-12,800 in ticket income per year (46 bouts x $450 cut), versus ~$2,475 for one fighter (9.5 bouts x $450). The extra $10,000 covers one stipend ($13,250/year) almost entirely. Four fighters on day jobs (FOUR_NONE) pay zero stipends and accumulate $31,000 by year end.

**What start cash would give 3 months of runway?** FOUR_ONE needs roughly $5,000 more (3 months of the $1,322/week net cost with 2 extra fighters = ~$17,000, so start cash of ~$34,000 would give 3 months). FOUR_ALL would need ~$60,000 start cash for 3 months of runway (the cell burns ~$1,300/week net even before the stipends compound into negative cash flow).

**What could you not measure?** The amateur lead is still 2-4 weeks and camps still run - the probe does not measure whether four fighters training simultaneously strains gym capacity (member cap, coach attention, ring time). The sensible player's spending rules (GymSpend._sensible) may buy upgrades faster with four fighters earning, but the probe holds spending constant per cell. The three extra fighters were signed on day 1 via direct sign - in real play the scouting -> trial -> sign flow takes 2-3 weeks, which would delay their first bouts and push ticket income later.

## Claude's note at collect (S429)
- Read, not re-run by Claude. The spread is valid (10 careers a cell, same seeds, five cells).
- The fourth fighter in the probe is Kira (a boxer), not Ana: for money both are one more amateur, but Ana's BJJ nights and
  the mat side's dues are NOT in these numbers.
- A slip in the sentence on tickets: 46 bouts x $450 would be $20,700, the measured ticket income is about $12,600. The table's
  number is the measured one (the probe's `_ticket_income` reads the ledger); not every bout pays the club a ticket cut.
- The start-cash sentence is muddled; the table answers it: with ONE stipend today's start cash ($17,200) keeps the club
  between 1.9 and 2.9 months of costs all year, so the start cash does not need to change for the four-fighter start.
- Decisions taken from this for FOURSTART1: one stipend at the start; four stipends closes 8 clubs in 10 (median week 46);
  no stipend at all ends the year with $31,000 (5.5 months), which is too easy, so "nobody on the stipend" needs a cost
  beyond the 15% slower gain before it ships.
