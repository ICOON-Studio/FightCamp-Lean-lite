# COACHFIT_SCOPE_S528 - coach fit: a numeric sheet from the code before any more map rounds (CLAUDE.md item 8)

Source: COACHFIT1 v9 critic Arena (ops/research/DESIGN_COACHFIT1_V9_CRITIC_ARENA.md, depth 5 general 4), after NINE
map rounds (v1-v9, Kalli then Dola) that never reached 7/7. Verdict: the METHOD is wrong, not one defect. Each round
rewrote prose maps on a chat seat (twice cut off mid-build-list); no round started from the code. Meanwhile
scripts/rules/CoachFit.gd (v8, 208 lines, pure: fit 10-90 around 50, gain_mult 0.5 + fit/100, tired_mult
1.125 - 0.0025 x fit, ceilings, coach time, bond steps, tempers / modes) is BUILT and called by NOTHING in the game.

METHOD (until phase 1 is approved): no session sends another COACHFIT map round to a chat seat; work does the phases.

## Phase 1 - one numeric sheet (Claude), `ops/research/COACHFIT_SHEET.md`
One table, every row = a number the game would use: name, value, the function that holds it (CoachFit.gd or the
existing lever), what it multiplies, and the existing lever it REPLACES or MULTIPLIES (never both). Join each of the
map's four channels to exactly one existing lever:
- gain -> the morning / evening gain (WeekPlan / MorningWire coached mornings: today's coach_rating route)
- tiredness -> WeekPlan day fatigue (the 0.92-1.08 drift Arena asks for: tired_mult clamped)
- word taken in (corner) -> Exchanges.uptake x FighterProfile.trust (already live: fit multiplies, never adds)
- correction absorption -> HabitFix (already live)
Cut every row with no lever, no cost or no choice (Arena's list: SHIELD as a free mode, Steady Hand shown as a mode,
Film on the fit grid). Bond, tempers and modes stay only where a row shows a real trade-off.

## Phase 2 - the probe (Qwen), COACHFITPROBE2
On the sheet's numbers: two coaches x four boxers x a season; the pass lines Arena's 10/10 list names (no mode best in
every cell; a mismatched coach costs a measurable amount; the fatigue drift stays inside 0.92-1.08).

## Phase 3 - two fresh critics on the SHEET + its probe, not on a prose map. 7+/7+ -> his board -> build (wire CoachFit
into the four levers, each wire behind GameSwitches, tests red first).

## Board
Roadmap: COACHFIT1 row -> "phase 1: numeric sheet from the code (Claude)". COACHFIT1 v9's Dola critic (SQ238) is read
for its 10/10 list only.
