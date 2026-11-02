# TASK_C178 - U143 must not collapse freestyle and Greco-Roman (Codex)

Model: gpt-5.6-luna, MEDIUM. Owner: codex. Assigned S60, 2026-09-23.

## Evidence (Q150, `research/Q150_DIGEST.md`, branch `qwen/q150-u143-check`)
U143 (`origin/cursor/u143-name-the-control`: the grapple namer's control branch learns the
phase-appropriate control family and names at the phase moved INTO) fixed the stale-phase
violations (Q148 verdict A 69 -> 0; clause-4 total 205 -> 43) and lifted bjj/sambo/judo/muay thai,
BUT named coverage (Q147 clause 1) COLLAPSED in freestyle 51.7% -> 1.6% and greco 54.4% -> 1.1%.

## Owned files
The files U143 changed (see `git diff origin/master...origin/cursor/u143-name-the-control --stat`),
`research/C178_DIGEST.md`. Do NOT edit `tests/grapple_naming_contract_test.gd` (it is the
blind contract; if you think it is wrong, say so in the digest and stop).

## Do
Work on a branch `codex/c178-u143-fix` cut from `origin/qwen/q150-u143-check` (master + U143 + Q147).
Find why the wrestling rulesets lost their names (likely the new control family has no member
legal for freestyle/greco phases, or a ruleset filter now excludes their catalogue), fix it in the
namer, and show BEFORE/AFTER per ruleset for clause 1 and the clause-4 count. Target: every
ruleset's coverage at least its pre-U143 value, clause 4 not above 43.
## Gate
Parse gate; `tests/grapple_naming_contract_test.gd` (report each clause); `tools/q148_phase_violations.gd`;
`run_tests.py --only grapple`, `--only name`, `--only room`. Push the branch (not master), digest,
one agent_comms.py send. Do NOT edit HANDOFF.md.
