# TASK_U169 - the weigh-in bites, and gym-mates are never matched (Cursor, build)

Model: Composer, medium, `-p --force --trust`. Owner: cursor. Assigned S70, 2026-09-24. Management lane.

## Why
The S64 career walk (`tools/s64_career_walk.gd`; S64_DIGEST.md:30-45) saw two booking-rule failures a player notices:
1. **A fighter weighed in 4.2 kg over, was fined 0%, and the fight went ahead** - and `book_fight`'s weight plans all
   project 76.8 kg and "makes_it" whatever the start weight. Real commissions fine a missed weight (commonly 20-30% of the
   purse to the opponent in MMA; boxing varies by commission) and past an allowance the bout is cancelled or goes on at a
   catchweight only if the opponent accepts. Grep `weight_cut`, `weigh_in`, `makes_it` - `WeightCut` / GameState windows.
2. **A booking matched a fighter against his own gym-mate** (NASIR vs RAFAEL NOVAK, a regional offer). Teammates are never
   offered against each other (AKA's documented rule, G89 section 3); the offer generator must exclude the player's own roster.

## Build
1. Weight plans project from the fighter's ACTUAL walk-around weight and cut capacity - a man who cannot make weight is
   shown NOT making it before the fight is accepted.
2. A miss at the weigh-in: a purse fine to the opponent (a named constant with its source or INVENTED label - check
   `research/` first: `grep -ril "missed weight\|weight miss" research`), and past a named allowance the bout is
   cancelled (the result screen / news says why). Never a silent 0%.
3. Offers never pair two fighters from the same gym (player's roster; rival gyms too if the generator knows their rosters).

## Owned files
`Godot/scripts/WeightCut.gd` (if that is where plans live), the weigh-in and offer-generation sites in `GameState.gd`
(~15,000 lines - NEVER open it whole; `grep -n` then `sed -n 'A,Bp'` windows), a NEW `Godot/tests/weigh_in_and_gym_mates_test.gd`,
`research/U169_DIGEST.md`.

## Gate (tier: scripts edited)
`python Godot/tools/check_scripts.py <touched .gd>` first. The new test, on a real career (`begin_new_career` /
`generate_starter_boxing_floor` / `finalize_new_career`): a fighter far above his class is projected NOT to make weight; a
forced miss fines the purse and past the allowance cancels the bout; 50 generated offers contain no same-gym pairing. 3
mutants, each reverted. Then `python Godot/tools/run_tests.py --only weight`, `--only offer`, `--only booking`,
`--only career_loop` (ONE `--only` per run; read `total=`). Ceiling: `weight_cut_test` is ALREADY RED on master (2 known
fails) - fix them if they are this bug, else no new red. No full suite.
Branch `cursor/u169-weigh-in` off `origin/master`, commit with explicit paths ON the commit line, push,
`python Tools/agent_comms.py send --from cursor --to claude --topic U169 --body "<plans, fine + allowance + source, gym-mate filter, test checks, mutants, weight_cut_test state>"`.
Do NOT edit HANDOFF.md, and do not read HANDOFF.md, CURRENT_STATUS.md or any digest but S64's.

## The one trap
Females never fight males and weight classes already gate booking - do not rebuild those; add the gym filter beside them.
And the fine goes to the OPPONENT, not into thin air.
