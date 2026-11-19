# TASK KNOWBOTS5 - which truth decides a career: rating, potential or neither? (probe, no screen)

Status: OPEN (S525, Claude main). Discipline: boxing. Model: Goose (cloud) - a probe, no window.
Scope: `ops/research/KNOWLEDGE_SCOPE_S525.md` phase 1. Previous: docs/KNOWBOTS4_RESULT.md (VOID: ORACLE by today's true
rating beats BLIND by under 8% on top-10s, bout wins and final true rating, all three seed sets).

## Part 1 - the pool (print it first)
For seeds 7000-7059, every prospect a bot could sign: true rating, potential, age, shown centre, hype, (shown - true).
Print per world: the spread (best - median, best - worst) of true rating and of potential, and the mean |shown - true|.

## Part 2 - four signers, same worlds, 4 years, three seed sets (7000-7059, 8000-8059, 9000-9059)
BLIND (best shown centre), ORACLE (highest true rating - KNOWBOTS4's), ORACLE-POT (highest potential), ORACLE-BOTH
(highest projected rating after 4 years: true rating grown by the game's training headroom rule, Training pace 1.0 a
focused week x clamp((potential - stat) / 25, 0.10, 1.25), age as the game ages boxers - read the game's own code for it,
name the function). Print for each bot: top-10 appearances, bout wins, win share, final TRUE rating of the signed boxer.
Verdict per oracle: (oracle - BLIND) / BLIND on each measure and set; PASS = 8%+ on every set for one measure.

## Contract
OWNS: tools/knowbots5_probe.gd, docs/KNOWBOTS5_RESULT.md (the probe may preload tools/knowbots4_pool.gd, read-only)
RED_TEST: tools/knowbots5_probe.gd -> KNOWBOTS5 done
REGRESSION: knowledge_test, know_reads_test, world_years_test (read-only: run them, never edit them)
VISUAL: no
NOT YOURS: every file in scripts/ and tests/, tools/knowbots4_*.gd. The result page is WRITTEN BY THE PROBE from the run's
numbers. PR body: `RESULT: tools/knowbots5_probe.gd -> oracle=<pct,pct,pct> oracle_pot=<...> oracle_both=<...> measure=<name>
pool_rating_spread=<n> pool_pot_spread=<n> shown_err=<n>`. Each file under 500 lines. Pilot 4 worlds first, print the
projected time; stop at 90 minutes of run time (KNOWBOTS4 fitted; TURNPROBE1 timed out at 60 - keep inside).

## Prior research
`python ops/Tools/prior_research.py knowbots knowledge potential` -> TASK_KNOWBOTS3/4, docs/KNOWBOTS3/4_RESULT.md,
DESIGN_KNOWLEDGE_V3_REVISE_KALLI_KALLI.md s10.

## What would a human do?
A scout's job is to see what a kid will BECOME. Before pricing reads, check which truth the game rewards knowing.

## Prefab check
None: the probe reuses the game's world and knowbots4_pool.gd.

## The one trap
Projecting growth with your own formula: read the game's training code and call it, or copy its constants by name.
