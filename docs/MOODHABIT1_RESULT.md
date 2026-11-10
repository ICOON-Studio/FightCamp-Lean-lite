# MOODHABIT1 RESULT

What a boxer's mood and each habit are worth in wins. Measured only - no game files changed.

## Control

| Cell | Win% |
|------|------|
| Steady (morale 60), corner calls, Maria Ortega | 41.3% |

Control reproduces fire_level_probe's 41.3% exactly.

## Functions that carry each effect

### Mood (FighterProfile.gd)

- `FighterProfile.mood(morale)` returns the mood word: Fired up (>=75), Steady (50-74), Flat (30-49), Low (<30)
- `FighterProfile.TRUST` dict: Fired up 1.05, Steady 1.0, Flat 0.85, Low 0.7
- `FighterProfile.trust(f)` returns the trust multiplier from morale
- Trust multiplies `Exchanges.uptake(coachability, shouts)` - how much of the corner's word she takes in
- `CornerTrust.lands(f)` returns false when mood is Low (morale < 30): she stops taking in the corner's word entirely

### Habits (HabitFix.gd)

- `FighterProfile.HABITS` array: 20 habits (drops_right_after_jab, slow_starter, digs_body_when_hurt, freezes_on_ropes, switches_stance_under_pressure, talks_when_ahead, loads_up_when_hurt, covers_up_when_hurt, wide_hook_tell, retreats_straight_back, admires_her_work, fades_late, lunges_with_jab, head_down_inside, clinches_when_tired, bites_on_feints, low_lead_hand, one_and_done, chases_stoppage, waits_too_long)
- `HabitFix.PUNISHED_BY` dict: maps each habit to the situations that punish it (counter, press, range, she_hurt, she_tired, loadup)
- `HabitFix.punished(habits, sit, n, i, last)` returns the habit this exchange punishes
- `HabitFix.cost(habit, fix, hold)` returns power points lost: -6.0 if unpunished, less if the corner fixed it
- `LiveRound.gd` line 245: `habit_pts = Exchanges.HABIT_BOUT * HabitFix.cost(...)` - the habit's cost in the exchange

## Tables

### Mood (corner calls, vs Maria Ortega)

| Mood | Morale | Win% | Gap to Steady |
|------|--------|------|---------------|
| Fired up | 80 | 41.3% | 0.0 |
| Steady | 60 | 41.3% | -- |
| Flat | 40 | 40.5% | -0.8 |
| Low | 20 | 40.5% | -0.8 |

### Mood (corner silent, vs Maria Ortega)

| Mood | Morale | Win% | Gap to Steady |
|------|--------|------|---------------|
| Fired up | 80 | 38.5% | 0.0 |
| Steady | 60 | 38.5% | -- |
| Flat | 40 | 38.5% | 0.0 |
| Low | 20 | 38.5% | 0.0 |

### Habits (corner calls, 400 bouts per cell)

| Habit | Punishing opp | With | Without | Gap | Safe opp | With | Without | Gap |
|-------|---------------|------|---------|-----|----------|------|---------|-----|
| wide_hook_tell | Priya (counter) | 16.3% | 31.3% | -15.0 | Maria | 37.0% | 41.3% | -4.3 |
| freezes_on_ropes | Maria (press) | 27.8% | 41.3% | -13.5 | Priya | 29.5% | 31.3% | -1.8 |
| switches_stance_under_pressure | Maria (press) | 27.8% | 41.3% | -13.5 | Priya | 29.5% | 31.3% | -1.8 |
| retreats_straight_back | Maria (press) | 27.8% | 41.3% | -13.5 | Priya | 29.5% | 31.3% | -1.8 |
| head_down_inside | Maria (press) | 27.8% | 41.3% | -13.5 | Priya | 29.5% | 31.3% | -1.8 |
| one_and_done | Maria (press) | 27.8% | 41.3% | -13.5 | Priya | 29.5% | 31.3% | -1.8 |
| drops_right_after_jab | Priya (counter) | 20.0% | 31.3% | -11.3 | Maria | 38.3% | 41.3% | -3.0 |
| talks_when_ahead | Priya (counter) | 20.0% | 31.3% | -11.3 | Maria | 38.3% | 41.3% | -3.0 |
| admires_her_work | Priya (counter) | 20.0% | 31.3% | -11.3 | Maria | 38.3% | 41.3% | -3.0 |
| bites_on_feints | Priya (counter) | 20.0% | 31.3% | -11.3 | Maria | 38.3% | 41.3% | -3.0 |
| fades_late | Maria (default) | 33.3% | 41.3% | -8.0 | Maria | 33.3% | 41.3% | -8.0 |
| clinches_when_tired | Maria (default) | 34.8% | 41.3% | -6.5 | Maria | 34.8% | 41.3% | -6.5 |
| low_lead_hand | Maria (default) | 38.0% | 41.3% | -3.3 | Maria | 38.0% | 41.3% | -3.3 |
| lunges_with_jab | Maria (default) | 39.8% | 41.3% | -1.5 | Maria | 39.8% | 41.3% | -1.5 |
| waits_too_long | Maria (default) | 39.8% | 41.3% | -1.5 | Maria | 39.8% | 41.3% | -1.5 |
| loads_up_when_hurt | Maria (default) | 40.0% | 41.3% | -1.3 | Maria | 40.0% | 41.3% | -1.3 |
| covers_up_when_hurt | Maria (default) | 40.0% | 41.3% | -1.3 | Maria | 40.0% | 41.3% | -1.3 |
| slow_starter | Maria (default) | 41.3% | 41.3% | 0.0 | Maria | 41.3% | 41.3% | 0.0 |
| digs_body_when_hurt | Maria (default) | 41.3% | 41.3% | 0.0 | Maria | 41.3% | 41.3% | 0.0 |
| chases_stoppage | Maria (default) | 41.3% | 41.3% | 0.0 | Maria | 41.3% | 41.3% | 0.0 |

Note: "Punishing opp" = opponent whose style creates the situation that punishes this habit. "Safe opp" = opponent whose style does not. Priya (Counter-puncher) punishes counter-situation habits; Maria (Pressure fighter) punishes press-situation habits. Some habits (slow_starter, fades_late, clinches_when_tired, etc.) have no style-specific punisher in the opponent pool, so both columns use Maria.

## Five sentences

1. **Keeping a boxer out of Flat is NOT worth an evening of Reid's hands** - the gap from Steady to Flat is only -0.8 points when the corner calls, and 0.0 when the corner is silent. The task's threshold was 2 points; mood's effect is under 1 point. The game's mood band changes how much of the corner's word she takes in (FighterProfile.TRUST: 1.05 / 1.0 / 0.85 / 0.7), but this translates to less than 1 point of win rate because the corner's calls themselves are worth only ~2.8 points (41.3% calls vs 38.5% silent), and mood's multiplier on that is small.

2. **The habits worth four evenings (2+ points) are wide_hook_tell (-15.0 vs counter-puncher, -4.3 vs pressure), freezes_on_ropes (-13.5 vs pressure), switches_stance_under_pressure (-13.5), retreats_straight_back (-13.5), head_down_inside (-13.5), one_and_done (-13.5), drops_right_after_jab (-11.3 vs counter), talks_when_ahead (-11.3), admires_her_work (-11.3), bites_on_feints (-11.3), fades_late (-8.0), and clinches_when_tired (-6.5).** These are the habits the corner should work on first - they cost 6 to 15 points of win rate when the right opponent punishes them.

3. **The habits that are decoration (under 2 points) are lunges_with_jab (-1.5), waits_too_long (-1.5), loads_up_when_hurt (-1.3), covers_up_when_hurt (-1.3), slow_starter (0.0), digs_body_when_hurt (0.0), and chases_stoppage (0.0).** These either rarely fire (slow_starter only costs in round 1's first exchanges; fades_late only in the last minute) or are situationally rare (chases_stoppage needs the opponent hurt).

4. **The corner's silence changes the answer for mood but not for habits** - when the corner is silent, mood has zero effect (all moods win 38.5%), because trust only multiplies the corner's word, and no word is spoken. But habits still cost the same (-13.5 for freezes_on_ropes vs Maria) because habits are punished by the opponent's style, not by the corner's calls. The corner can fix one habit per round, but the probe measures the habit's raw cost without corner intervention.

5. **What I could not measure:** the probe tests one boxer (Lucy) against three opponents; different boxers with different stats and styles may shift the numbers. The probe also does not measure the corner's fix working - it measures the habit's cost when unpunished vs when the corner has not fixed it. The interaction between mood and habits (a Low fighter who does not listen to the corner's fix) is not measured here; it would require running the probe with the corner calling a fix and measuring whether the fix holds less when morale is low.

## Collected by Claude (S428), read against the code
- Low (20) equals Flat (40) in every cell: `CornerTrust.lands(f)` is not called anywhere the fight runs (grep scripts/ tools/), so
  "Low stops taking the corner's word" is a rule on paper only; Low gets the 0.7 uptake like Flat gets 0.85, and both round to the
  same 40.5% at 400 bouts. A fix would be worth up to the corner's whole 2.8 points for a Low boxer, still under the 2-point
  gate for Flat but not for Low.
- Five habits share one number (-13.5 / -11.3): HabitFix.cost is one flat cost, so the habit's name changes WHICH opponent
  punishes it, not how much. The week design must not price habits by name.
- Mood is NOT worth an evening of Reid's hands (under 1 point). Habits are (most 6 to 15 points against the right opponent).
  So: v4 drops "the other boxer feels second" as a paid claim; the habit claim stays and is priced by the opponent's file.
