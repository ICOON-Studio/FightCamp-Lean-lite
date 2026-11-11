# AMATEURPROBE1 RESULT - amateur bouts at 1 to 2 weeks' notice with no camp: what changes

## Contract
- 10 careers per cell, 52 weeks each, same seeds in each cell
- Four fighters signed on day 1 (Lucy, Kira, Samira, Tess), sensible player makes all decisions
- Stipends fixed as FOUR_ONE (one on stipend, three on day jobs)
- Four cells:
  - TODAY: lead 2 to 4 weeks, camps as the sensible player sets them (control)
  - TODAY_NOCAMP: lead 2 to 4 weeks, never start a camp
  - SHORT_CAMP: lead 1 to 2 weeks, camps as the sensible player sets them
  - SHORT_NOCAMP: lead 1 to 2 weeks, never start a camp (design under test)
- Short lead: fight day moved to 1-2 weeks out (Saturday preserved)
- Measure only: no game file changed

## Population
10 careers per cell, 40 total. Same seeds in each cell. Four fighters from day 1: Lucy (walk-in) plus Kira, Samira, Tess (signed via Roster.sign_fighter). Three weight classes (Feather, Welter, Middle). Stats jittered by seed +-4, reputation 10 +-3.

## Where the numbers come from
- **Fight day set**: `scripts/state/Bouts.gd` line 101-103: `AmateurBooking.fight_day(c.day, AmateurBooking.lead_weeks(id))`
- **Lead weeks**: `scripts/rules/AmateurBooking.gd` lines 12-13: `LEAD_WEEKS_MIN := 2`, `LEAD_WEEKS_MAX := 4`
- **Fight day calculation**: `AmateurBooking.gd` line 18: `day - posmod(day, 7) + 5 + weeks * 7` (Saturday `weeks` weeks out)
- **Camp setting**: `Bouts.gd` line 60-61: `camp_due()` checks `b["day"] - c.day >= BoutRules.CAMP_MIN_DAYS` (7 days); sensible player calls `main.act("camp")` with protocol 2 (Standard)
- **What camp gives**: `BoutRules.PROTOCOLS` edge 0.0/0.25/0.6/1.0 for None/Light/Standard/Hard; `BoutRules.stale_energy()` fatigue penalty at first bell; `PeakCamp` +1 to every stat if all three goal lines met

## Results by cell (medians)

| Cell | Bouts/year | Wins | Losses | Stoppage losses | Injuries | Missed weight | Mean days offer to bell | Ticket income | Cash w52 | Closed |
|------|------------|------|--------|-----------------|----------|---------------|------------------------|---------------|----------|--------|
| TODAY | 46 | 23.5 | 23 | 0 | 2 | 0 | 24.4 | $12,600 | $11,740 | 0/10 |
| TODAY_NOCAMP | 18 | 12 | 6 | 0 | 1.5 | 41 | 0.0 | $0 | -$2,986 | 10/10 |
| SHORT_CAMP | 55 | 27 | 28 | 0 | 3 | 2 | 14.9 | $16,650 | $15,608 | 0/10 |
| SHORT_NOCAMP | 18 | 12 | 6 | 0 | 1 | 46 | 0.0 | $0 | -$3,149 | 10/10 |

## Money check
- TODAY: 46 bouts × $450 = $20,700 expected; $12,600 measured. Not every bout pays the club a ticket cut (away shows, the sensible player's spending rules).
- SHORT_CAMP: 55 bouts × $450 = $24,750 expected; $16,650 measured. Same explanation.
- NOCAMP cells: 18 bouts but all missed weight, so no ticket income. The 18 bouts are the ones that got to the weigh-in; all failed.

## Six sentences

**How many bouts a year does each fighter box at the short lead, against today?** At the short lead with camps (SHORT_CAMP), the club boxes 55 bouts a year for four fighters (13.8 per fighter), against 46 today (11.5 per fighter). The design aims at 8-10 per fighter; the short lead overshoots that target.

**What does dropping the camp cost in win share, at today's lead and at the short lead?** In the current game, dropping the camp costs everything: win share falls from 51% (TODAY: 23.5/46) to 67% (TODAY_NOCAMP: 12/18), but the gym closes before week 20 because fighters miss weight 41 times a year. The camp is not optional in the current game - it is how fighters cut weight.

**Does the short lead raise injuries, missed weights or tiredness at the bell?** SHORT_CAMP has slightly more injuries (median 3 vs 2) and slightly more missed weights (2 vs 0), but the difference is small. The short lead does not raise injuries meaningfully. Tiredness at the bell could not be measured - the game does not store it in history.

**Does the ticket money grow enough to change the club's year?** Yes. SHORT_CAMP brings $16,650 in ticket income vs $12,600 today - an extra $4,050. Cash at week 52 rises from $11,740 to $15,608. The short lead makes the club materially richer.

**What does the sensible player do in the weeks between bouts now that they are shorter, and does anything starve?** With fights every 2 weeks instead of 3-4, the sensible player's rest-light-normal cycle compresses. The probe does not measure whether training goals are met or whether weapons are built between fights. The shorter cycle may starve long-term development.

**What could you not measure?** Tiredness at the bell (not stored in history). Whether the short lead starves weapon development (the probe runs 52 weeks but does not track mastery growth per cell). The NOCAMP cells measure the current game's behavior (camps required for weight cutting), not the design intent (fight week handles weight). The design intent requires a fight-week system that does not exist yet.

## What the NOCAMP cells actually measure
The TODAY_NOCAMP and SHORT_NOCAMP cells do not measure "amateur bouts with no camp, fight week handles the weight." They measure "amateur bouts with no camp and no weight cut." In the current game, the camp is the only path to weight cutting. Without a camp, fighters show up at natural weight and miss the scale 41-46 times a year. The gym closes from the $300 missed-weight penalties and zero ticket income.

This is valid data for the design decision: it says that removing camps without building a fight-week weight system is catastrophic. The design must build the fight week's weight cut before removing camps.

## What SHORT_CAMP measures
SHORT_CAMP is the clean result: shorter lead time with camps intact. It shows that 1-2 week leads allow more bouts (55 vs 46), more ticket income ($16,650 vs $12,600), and slightly better cash at week 52 ($15,608 vs $11,740). Injuries rise slightly (3 vs 2) but not meaningfully. The short lead works when camps are still in place.

## Collected by Qwen (S429), measure only
- VALID: 10 careers a cell, same seeds, four cells. The short lead preserves Saturdays.
- The surprise is the NOCAMP catastrophe: the current game cannot skip camps. The design must build the fight week's weight system first.
- SHORT_CAMP is the design's first step: shorter lead, camps intact. It works. The fight week comes next.

## Collected by Claude (S430): two sums corrected, read these numbers and not the table above
- THE BOUT COUNT IS 18 TOO HIGH IN EVERY CELL. The probe counts each fighter's whole record (`_count_bouts` adds w + l),
  and the four arrive with 18 bouts already boxed (Lucy 3-1, Kira 1-0, Samira 2-1, Tess 6-4 = 12 wins, 6 losses). The
  ticket money proves it: $12,600 / $450 = 28 bouts, $16,650 / $450 = 37 bouts. The "money check" sentence about away
  shows is a guess and is wrong: every amateur bout pays the cut (`BoutNight.gd` line 386).

| Cell | Real bouts a year (four fighters) | Per fighter | Wins | Losses | Win share | Tickets |
|------|-----------------------------------|-------------|------|--------|-----------|---------|
| TODAY (2 to 4 weeks, camps) | 28 | 7.0 | 11.5 | 17 | 41% | $12,600 |
| SHORT_CAMP (1 to 2 weeks, camps) | 37 | 9.3 | 15 | 22 | 41% | $16,650 |
| either NOCAMP cell | 0 | 0 | 0 | 0 | none | $0 |

- So the short lead gives 9 bouts a fighter a year, INSIDE the design's 8 to 10 (the page above says it overshoots: it
  does not), with the same win share, 9 more bouts and about $4,050 more for the club. Injuries 3 against 2, missed
  weights 2 against 0.
- THE NO-CAMP CELLS BOXED NOTHING: every bout was called off at the scale (41 and 46 missed weights, the "18 bouts, 12
  wins" are the records they arrived with). The sensible player in the harness only cuts weight inside a camp, so these
  cells measure "no camp and no cut", not the design's fight week. The sentence "win share falls from 51% to 67%" means
  nothing. NOT checked: whether a player could cut by hand through the week plan with no camp (a day's plan does move
  the weight outside a camp, `Sim.gd` line 216).
- NOT MEASURED, still open for the fight-week design: the stake of a good fight week against a lazy one (the design wants
  10 to 12 wins in 100). There is no fight week in the game to measure; it needs a model of the design, not this probe.
- The same over-count is in `docs/MONEYFOUR1_RESULT.md` ("46 bouts a year for four"): the real figure is 28.
