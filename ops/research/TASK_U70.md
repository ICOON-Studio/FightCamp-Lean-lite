# TASK U70 - CURSOR - THE GROUND IS VISIBLE NOW, AND NOBODY CAN FINISH A SUBMISSION

Model: Composer, **medium effort**. Owner: cursor.

**Test tier: RESEARCH, NO `.gd` TOUCHED - NO GATE AT ALL.** **Do NOT start Godot
for any reason**: Claude is running S1d's tests in this checkout. Every number
comes from reading code and JSON, and from arithmetic you show.

## Owned files

- `research/U70_SUBMISSION_ACCUMULATOR.md` - **NEW, yours alone.**

Nothing else. **Do NOT edit any script, test, `technique_catalog.json`,
`HANDOFF.md` or `AgentComms/roadmap.json`.**

## Why this exists

S1d gave BJJ's ground techniques the seats S1's merge had erased (`f851924`). The
ground fight now exists - and a seeded measurement shows the next defect.
`Godot/tools/measure_ground_seats.gd`, 40 bouts per matchup, catalogue md5
`8e8cbaf210d19cf8327e7ecc43012af7`:

- **BJJ guard player vs pressure passer** (bjj rules): 1,462 ground exchanges, 0%
  fallback, 32 distinct ground techniques - kimura thrown 282 times, americana 108,
  guillotine 104, armbar 102, cross collar 88. **One submission in 40 bouts.**
- **MMA grappler vs striker** (mma rules): RNC 43, kimura 43, armbar 36 from top.
  **Zero submissions.** The grappler wins 0 of 40.

J20's anchor (`research/J20_THE_VALIDATION_CORPUS.md:42`, row D4): modern
UFC standard divisions end **17.2% by submission**.

The suspected cause, NOT yet verified - that is your job: the attempt accumulator
in `_apply_landed_effect`'s `submission` arm keeps ONE attempt per fighter and
REPLACES it whenever a different submission technique lands, and S1 tripled every
palette.

## Scope

1. **The mechanism, exactly.** `Godot/scripts/FightSimulation.gd` is 3,292 lines -
   never open it whole. Read `sed -n '2105,2125p'` (the submission arm; threshold
   `SUBMISSION_BASE_THRESHOLD = 55.0` at `:133`), `sed -n '2400,2422p'`
   (`_resolve_escape_attempt`, which clears BOTH fighters' attempts), `sed -n
   '1455,1475p'` (where `submission_finish` ends the bout), `sed -n '2800,2815p'`
   (round reset), and `sed -n '2649,2670p'` (`_technique_magnitude`). State every
   write and every clear of `submission_attempt`, with lines. Is there ANY decay,
   carry-over or chaining?
2. **The arithmetic.** From `Godot/assets/data/technique_catalog.json` (nodes under
   `disciplines[].nodes[]`), the BJJ submission nodes' magnitudes. For a defender
   with `defense` 60-66 (the fixtures in the measurement tool's header), how many
   CONSECUTIVE landed attempts of ONE technique cross the threshold at execution
   quality 0.6, 0.75 and 0.9? Then, if a fighter knows k submissions and picks
   among them roughly evenly, what is the chance of that streak - for k = 2 (a
   pre-merge palette) and k = 7-9 (the fixtures now)? Show the working. Read the
   selection weighting in `_weighted_choice` (`sed -n '2560,2640p'`) enough to say
   whether "roughly evenly" is fair.
3. **Is it the only cause?** Name anything else in those windows that also
   suppresses finishes (escapes clearing attempts, the bottom man's escape rate,
   stamina gates). Rank the causes by how much each one matters, with the number
   behind each rank.
4. **Three options, each with what it moves.** At least: (a) one accumulator per
   TARGET that a switch to another submission keeps a fraction of - a real chain
   (armbar to triangle to omoplata); (b) a per-technique strength map that does
   not reset on a switch; (c) leave the accumulator and change the threshold. For
   each: which rulesets it touches (BJJ, MMA, sambo, judo all use this arm), and a
   rough predicted submission rate from your part-2 arithmetic. **Recommend one.**

## THE TRAP

**Do not tune to 17.2%.** That is a UFC-wide rate across all matchups; a pure BJJ
bout under bjj rules and a grappler-versus-striker MMA bout are different
populations and should not produce the same number. Say what population each
anchor is for. A fix that makes every ground bout end by submission is as wrong
as one where none does.

## Done

- THIS CHECKOUT IS SHARED WITH A LIVE CLAUDE SESSION. Stay on `master`. **Never**
  run `git checkout`, `git switch`, `git branch`, `git stash`, `git reset`,
  `git clean`, `git add -A`, `git pull` or `git push`.
- `git status -s` first, then commit ONLY your file, path-limited:
  `git add -- research/U70_SUBMISSION_ACCUMULATOR.md` then
  `git commit -m "U70: ..." -- research/U70_SUBMISSION_ACCUMULATOR.md`,
  ending with `Co-Authored-By: Cursor <noreply@cursor.com>`. **Do not push.**
- One line of mail:
  `python Tools/agent_comms.py send --from cursor --to claude --topic U70-done --body "<hash> clears=<n> streak_needed_q075=<n> p_streak_k2=<x> p_streak_k8=<x> recommend=<a|b|c>"`
- Do NOT edit `HANDOFF.md`.
