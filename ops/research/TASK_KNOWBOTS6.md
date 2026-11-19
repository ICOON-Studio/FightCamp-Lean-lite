# TASK KNOWBOTS6 - does a shared misread make knowing a boxer pay? (probe, no screen)

Status: OPEN (S526, Claude main). Discipline: boxing. Model: Goose (cloud) - a probe, no window.
Scope: `ops/research/KNOWLEDGE_SCOPE_S525.md` phase 2 (decision S526 below). Previous: docs/KNOWBOTS5_RESULT.md.

## Why (KNOWBOTS5, read it)
Pool: true rating spread best-median 20.0, best-worst 30.5 (NOT flat). Mean |shown - true| on the rating: 0.83.
ORACLE (true rating) vs BLIND on top-10s: +11.1 / +9.8 / +7.3% (one set under 8% = VOID by a hair); bout wins, win share,
final rating within +-2%. ORACLE-POT and ORACLE-BOTH LOSE to BLIND (-18.8% top-10s on one set). So potential is not the
missing truth. The cause is the shown number itself: `Knowledge._offset` draws an independent offset per ATTRIBUTE
(OFFSET_LO..OFFSET_HI = -0.6..0.6 x the group width 8-15), and ~20 independent errors average out in the rating.
A real scout misreads the WHOLE kid (a gym fighter who freezes in bouts, a slow starter who looks ordinary): the error is
shared across attributes.

## The probe
Same worlds, signers and measures as tools/knowbots5_probe.gd (copy it; preload tools/knowbots4_pool.gd read-only).
Add ONE probe-side lever: a prospect-level shared offset. Each prospect draws `s` uniform in -0.6..0.6 (hash of its seed,
"shared"); every attribute's offset becomes `rho * s + (1 - rho) * own_offset` (own_offset = Knowledge._offset's value),
then the centre is built exactly as `Knowledge.range_of` builds it (truth + (offset + hype lift) x width). Do it in the
probe (a wrapper that computes the shown centre), never by editing scripts/.
Arms: rho = 0.0 (must equal KNOWBOTS5's numbers - the control), 0.5, 0.8, 1.0.
Signers: BLIND and ORACLE only (drop the potential oracles - KNOWBOTS5 settled them).
Print per rho: mean |shown - true| on the rating, and per set (7000-7059, 8000-8059, 9000-9059) ORACLE vs BLIND on
top-10s, bout wins, win share, final true rating, as (oracle - blind) / blind %. PASS for a rho = 8%+ on every set for
one measure. Name the smallest passing rho.

## Contract
OWNS: tools/knowbots6_probe.gd, docs/KNOWBOTS6_RESULT.md
RED_TEST: tools/knowbots6_probe.gd -> KNOWBOTS6 done
REGRESSION: knowledge_test, know_reads_test (read-only: run them, never edit them)
VISUAL: no
NOT YOURS: every file in scripts/ and tests/, tools/knowbots4_*.gd, tools/knowbots5_probe.gd. The result page is WRITTEN BY
THE PROBE from the run's numbers. PR body: `RESULT: tools/knowbots6_probe.gd -> control_match=<yes|no> err=<r0,r05,r08,r1>
pass_rho=<rho|none> top10=<pct per set at the passing rho>`. Each file under 500 lines. Pilot 4 worlds first, print the
projected time; KNOWBOTS5 projected 48 min for 4 bots - with 2 bots x 4 arms keep inside 90 minutes (cut worlds per set
to 40 if the pilot says so, and print that).

## Prior research
`python ops/Tools/prior_research.py knowbots knowledge` -> TASK_KNOWBOTS3/4/5, docs/KNOWBOTS4/5_RESULT.md,
KNOWLEDGE_SCOPE_S525.md, DESIGN_KNOWLEDGE_V3_REVISE_KALLI_KALLI.md s10.

## What would a human do?
Ask whether the shop window lies. If every prospect's paper is nearly true, no scout earns his fee; the question is how
wrong a first look has to be, and in which way, before a closer look pays.

## Prefab check
None: the probe reuses the game's world, knowbots4_pool.gd and Knowledge.range_of's maths.

## The one trap
rho = 0 must reproduce KNOWBOTS5's ORACLE and BLIND numbers to the digit; if it does not, the wrapper is wrong - fix that
before reading any other arm.
