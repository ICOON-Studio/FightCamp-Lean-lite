# R52 — THE YEARS, SOURCED (COMPLETE 2026-09-07)

J10 replaced the authored peak curve wholesale, split by sex, every row
graded. The camp's second age table is gone.

## Contract

```gdscript
peak_window(discipline, sex := "") -> {"from", "to", "grade"}
band_for(age, discipline, sex := "") -> String
grade_for(discipline, sex := "") -> String          # NEW
years_past_peak(athlete) -> int                     # NEW
injury_fragility(athlete) -> float                  # NEW
year_step(athlete, new_age)                         # signature unchanged, reads sex off the athlete
retirement_pressure(athlete, career_week)           # signature unchanged
birth_week_for / has_birthday                       # unchanged
```

`sex` defaults everywhere, so `GameState.gd` and C34's `WorldPopulation.gd`
compile untouched. An empty sex reads the male/mixed row. Vocabulary is
`WorldPopulation.athlete_sex()`'s: `"male"` / `"female"`.

## Windows, R51a -> R52 (male/mixed row)

| discipline | was | now | grade |
|---|---|---|---|
| boxing | 26-33 | **27-33** | UNVERIFIED_SECONDARY (pro; amateur 22-27 M / 23-29 F kept as a comment) |
| brazilian_jiu_jitsu | 27-35 | **23-29** | UNVERIFIED_SECONDARY |
| judo | 23-30 | **23-28** M / **22-28** F | DIRECT |
| karate | 24-31 | **22-28** | INHERITED (Olympic combat cluster, not WKF's own) |
| mma | 27-33 | 27-33 | DIRECT |
| taekwondo | 22-29 | **22-28** M / **21-27** F | DIRECT |
| wrestling | 24-30 | **23-29** M / **20-28** F | DIRECT (women's row spans a sourced conflict) |
| arnis, capoeira, kickboxing, muay_thai, pencak_silat, sambo, sanda, savate | 24-32 each | **25-31** (DEFAULT_PEAK) | UNKNOWN |

Every bookable discipline is still a key, so nothing reaches the default by
accident: an empty row set is the statement "J10 could not source this".
Women's pro boxing and women's MMA are UNKNOWN and fall to the default —
they are **not** served the men's row. `brazilian_jiu_jitsu` at 27-35 was the
one number that was simply wrong; it moved 4 years younger and 6 narrower.

`BAND_STEPS` is byte-identical and still marked AUTHORED / UNKNOWN. J10 1.3:
no combat sport publishes yearly integer stat deltas; only the direction is
defensible.

## Second item: the camp's age table is gone

`FightCamp.injury_chance()` no longer reads `age_30_mult` / `age_33_mult`;
both keys were **removed from `fight_camp.json`** rather than left as a
fallback, because dead tuning that nothing reads is how a second table grows
back. The camp now calls `Aging.injury_fragility(athlete)`: 1.0 inside or
before the window, **1.2** at 1-2 years past, **1.4** at 3+. Same two numbers,
measured from the fighter's own window instead of a bare birthday.

Who moves, at the same age:

- **boxing, mma** (window ends 33): x1.2 from 34 and x1.4 from 36 — four
  clean years back. A 30-year-old MMA fighter is inside his window and is no
  longer taxed at all.
- **wrestling M, brazilian_jiu_jitsu** (29): x1.2 from 30, x1.4 from 32 —
  within a year of the old table.
- **judo, karate, taekwondo M, wrestling F** (28): x1.2 from 29, x1.4 from 31.
- **taekwondo F** (27): x1.2 from 28, x1.4 from 30 — three years earlier.
- **the eight UNKNOWN disciplines** (default 25-31): x1.2 from 32, x1.4 from
  34 — two years later than the flat table.

Fixtures did not move: `fight_camp_test`'s athletes carry no discipline, land
on the default window and get exactly the old 1.0 / 1.4.

## retirement_pressure: re-shaped, scale preserved

Inputs are now named for J10 1.4's commission flags. Changes:

- **+10 at age 38** (NSAC comprehensive-licence battery). The ARP high-risk
  cut at 35 is deliberately *not* scored on top — for every window in the file
  a 35-year-old is already past it, and the years ramp is that same fact told
  once, with the discipline and the sex in it.
- **Inactivity retuned to the sourced triggers**: 52 weeks (+15, ARP) and 156
  weeks (+10 more, NSAC). The old unsourced 26-week tier is gone.
- **Medical hold 15 -> 20**; injured status still 10, still taken at the
  maximum and never summed.
- Morale kept at 18/12 with a comment saying it is *not* one of J10's flags —
  it is this game's own instrument. Money, family and a lost title stay
  unscored: J10 has no rate for any of them.

**`AGING_RETIRE_PRESSURE_LINE` (62) keeps its meaning and `GameState.gd` was
not touched.** Age alone still tops out at 55 (45 cap + 10 at 38), so the ask
still needs a second reason — a losing run, a hold, a layoff — exactly as
R51b intended.

## One thing C35 must fix (not mine here)

`year_step()` now reads sex off the athlete, but
`GameState._apply_birthday()` still computes `band_before` with
`Aging.band_for(age, discipline)` — no sex. For a female fighter in a
discipline whose women's row differs, the two can disagree, and the "enters
their peak years" headline can fire twice (once at the male row's edge, once
at the female row's). Same class of mismatch in `get_aging_read()`, which
quotes a sex-less window next to a sex-aware `next_year`. One argument each;
it belongs with C35's pass that threads `athlete_sex()` through.

## Tests

`tests/aging_test.gd` — 88 checks, 0 failures (was 66). New coverage: the
default-sex contract, the taekwondo/judo sex split, UNKNOWN rows refusing the
men's window, width 6-9 and a valid grade on every row and both sexes, and
the fragility ladder. `fight_camp_test.gd` gained one check proving an MMA
34-year-old is now less fragile than a taekwondo one at the same age.

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/aging_test.gd
```
