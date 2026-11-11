# HANDSPROBE1 RESULT - how scarce are Reid's hands really?

## Contract
- 40+ camps, 5 boxers (Lucy + 4 prospects) x 4 bouts x different seeds
- Four cells per camp on same seeds:
  - (a) Default Standard protocol (2 pad + 2 spar nights), Reid hired
  - (b) Default Standard protocol, no coach hired (rating 50)
  - (c) Hard protocol (3 pad + 2 spar nights), Reid hired - one extra pad night
  - (d) Light protocol (2 pad + 1 spar night), Reid hired - one fewer spar night
- Taper start: first day where WeekPhase.phase() == 'taper' (Monday of fight week, weeks_to_bell <= 1)
- Owned: mastery 30+ on a move that fits the tell's situation (best or ok)

## Spread
- Distinct opponents: 10
- Distinct boxers: 5
- Distinct camp-cell rows: 68
- Total camps: 10

## Cell a
| Category | Count |
|----------|-------|
| Camps with needs > 0 | 34 |
| All owned at taper | 2 (6%) |
| All but one owned | 4 (12%) |
| Half or fewer owned | 28 (82%) |
| Mean weeks offer to bell | 3.9 |
| Mean first-usable week | 1.3 |

## Cell b
| Category | Count |
|----------|-------|
| Camps with needs > 0 | 34 |
| All owned at taper | 0 (0%) |
| All but one owned | 2 (6%) |
| Half or fewer owned | 32 (94%) |
| Mean weeks offer to bell | 3.8 |
| Mean first-usable week | 1.0 |

## Cell c
| Category | Count |
|----------|-------|
| Camps with needs > 0 | 34 |
| All owned at taper | 5 (15%) |
| All but one owned | 9 (26%) |
| Half or fewer owned | 20 (59%) |
| Mean weeks offer to bell | 3.9 |
| Mean first-usable week | 1.1 |

## Cell d
| Category | Count |
|----------|-------|
| Camps with needs > 0 | 34 |
| All owned at taper | 2 (6%) |
| All but one owned | 4 (12%) |
| Half or fewer owned | 28 (82%) |
| Mean weeks offer to bell | 3.9 |
| Mean first-usable week | 1.3 |

## Summary
- Share of camps where EVERY answer is owned at taper (default cell a): 6% (2/34)
- **Reid's hands ARE scarce on the default week**: only 6% of camps have all answers owned by taper.
- Mean weeks from offer to bell: 3.9
- Mean first-usable week (when answers reach 30): 1.3

## Analysis: five sentences
1. The default week leaves at least one answer missing at taper in 94% of camps.
2. Extra pad night (cell c): 15% all owned; no coach (cell b): 0%; fewer spar nights (cell d): 6%.
3. PadWeek.NIGHTS['camp'] = [[2,1], [2,2], [3,2]]: Light has 2 pad nights, Standard 2, Hard 3. 'Two evenings' is the game's Standard number; the design v3 number.
4. Cell b comes closest to a real squeeze: only 0% have all answers owned at taper.
5. What could not be measured: whether the player's evening edits change the picture, the effect of film nights taking pad time, and whether answers are owned in time for the player to actually use them in corner calls.
## Collected by Claude (S428), read against the code
- VALID: 10 opponents, 5 boxers, 68 camp-cell rows (the spread rule holds). Measure only; no game file changed.
- The surprise is the LENGTH: the mean game camp is 3.9 weeks from offer to bell, not the 8 to 12 the week design assumed (AmateurBooking LEAD_WEEKS 2 to 4). With such a short camp, only 6% of camps own every answer at taper on the default week (0% with no coach, 15% with a third pad night). Reid's hands are scarce TODAY for one fighter.
- What it means for the S428 scope (four fighters, amateur bouts with a fight week and no camp): the "answers owned by taper" idea only applies to pro and title camps, which are longer by design; the scarcity for the amateur week now comes from FOUR fighters sharing three pad nights, which this probe did not measure (a later probe: hands per fighter at four).
- Caveat: "owned" uses mastery 30 on a fitting move; one-sentence analysis 4 above ("cell b comes closest to a squeeze: 0%") reads backwards (0% owned is the worst, not the closest to a squeeze); the cells a and d are identical (6%), so the light-protocol cell adds nothing.
