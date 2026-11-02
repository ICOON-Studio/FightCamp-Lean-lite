# TASK U67 — CURSOR — A JAB AND A CROSS COST THE SAME TO LEARN

Model: Composer, **medium effort**. Owner: cursor.

**Test tier: ONE DATA FILE EDITED plus ONE NEW TEST.** Parse gate your new test,
run it, then the three named subsets. **Do NOT run the full suite** — it is
Claude's, once, at integration. **ONLY ONE GODOT AT A TIME in this checkout**: if
a `Godot_v4.7.2-stable_win64_console.exe` is running, wait for it.

```
python Godot/tools/check_scripts.py Godot/tests/technique_cost_curve_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/technique_cost_curve_test.gd
python Godot/tools/run_tests.py --only technique
python Godot/tools/run_tests.py --only athlete_development
python Godot/tools/run_tests.py --only skill_tree
```

## Owned files

- `Godot/assets/data/technique_catalog.json` — **the `requires.reps` and
  `requires.discipline` fields ONLY.** Change nothing else in it: not `match`,
  not `role`, not `kind`, not `effects`, not `prerequisites`, not `tier`.
- `Godot/tests/technique_cost_curve_test.gd` — **NEW, yours alone.**
- `research/U67_COST_CURVE.md` — **NEW, yours alone.**

Do **NOT** edit `HANDOFF.md`, any script, or any other test.

## The finding, measured

S1 merged six re-authored discipline trees. Two of them carry a real learning
curve and four do not. Within a single tier, these are the counts of DISTINCT
values:

| discipline | nodes | reps t1/t2/t3/t4 | discipline gate | attribute-sum |
|---|---:|---|---|---|
| judo | 115 | **7/15/14/6** | 7/15/11/6 | 7/13/10/6 |
| muay_thai | 95 | **8/9/10/11** | 7/8/9/6 | 5/13/17/11 |
| karate | 173 | 1/2/3/2 | 1/3/3/2 | 2/4/4/3 |
| brazilian_jiu_jitsu | 72 | 1/1/2/1 | 1/1/2/1 | 1/1/3/1 |
| boxing | 54 | **1/1/1/1** | 1/1/1/1 | 5/6/7/3 |
| kickboxing | 25 | 2/1/1/1 | 2/1/1/1 | 4/9/3/2 |

**324 of 696 nodes have a training cost that carries no information.** Every
boxing tier-2 technique costs exactly 110 reps. A jab and a cross cost the same,
so the player's choice of what to train is a choice between identical prices.

**THE SIGNAL IS ALREADY IN THE NODES, WHICH IS WHY THIS IS A REPAIR AND NOT AN
INVENTION.** Look at boxing's row: reps and the discipline gate are flat at
`1/1/1/1`, but the **attribute-sum varies 5/6/7/3**. The author *did*
differentiate these techniques — a check hook demands more than a jab — and then
priced them identically. Judo and muay thai, delivered by the same process,
relate all three.

## What to do

1. **MEASURE THE EXEMPLAR FIRST.** In judo and muay thai, how does
   `requires.reps` relate to the node's own attribute demand within its tier?
   Fit it honestly — is it linear in the attribute sum, in the max attribute, in
   the count of prerequisites, in some combination? **Report the relationship and
   how well it actually fits** (spread, outliers). If it fits badly, say so:
   that is a finding, and it changes what you do next.
2. **APPLY THAT RELATIONSHIP ONE DISCIPLINE AT A TIME — THIS IS AN OPERATOR
   RULING (2026-09-12) AND IT IS NOT OPTIONAL.** Boxing, then kickboxing, then
   karate: each its own commit, each with the three `--only` subsets run before
   you move to the next. The catalogue merge went in as one 696-node sweep and
   when six tests went red afterwards there was no cheap way to say which tree
   caused it. One tree per commit is bisectable; a sweep is not.

   **If boxing's retune moves a test you did not expect, STOP and report it
   before touching kickboxing.** That is the whole point of the split — you find
   out on 54 nodes instead of on 252.

   Keep each tier's total or mean cost roughly where it is — **you are
   redistributing within a tier, not inflating the tree.** Say what you held
   constant, per discipline.
3. **BJJ IS DIFFERENT AND YOU MUST NOT FAKE IT.** Its attribute-sums are
   `1/1/3/1` — there is no differentiation to derive from, so any curve you put
   on BJJ would be invented. **Leave BJJ alone**, and report it as needing
   authoring rather than derivation.
4. Write `Godot/tests/technique_cost_curve_test.gd`, which asserts the PROPERTY,
   not your numbers: **within any tier of a discipline with more than N nodes,
   `requires.reps` must take more than one distinct value**, and the spread must
   not be degenerate. Derive the discipline list and node counts from the
   catalogue at run time — do not hardcode which trees to check, or the test
   stops covering a tree the day someone adds one.

## The output

`U67_COST_CURVE.md` opens with these lines and nothing before them:

```
U67 fitted_on=<judo,muay_thai> relation=<one line> fit_quality=<your measure>
U67 retuned_disciplines=<list> nodes_changed=<int> commits=<one per discipline>
U67 tier_mean_before=<t1/t2/t3/t4> tier_mean_after=<t1/t2/t3/t4>
U67 bjj=left_alone_needs_authoring
```

**One line per discipline as well**, so each tree's effect is separable:

```
U67 <discipline> nodes=<n> reps_before=<min..max> reps_after=<min..max> tests_moved=<none|names>
```

## A CONSEQUENCE YOU SHOULD KNOW ABOUT — BUT MUST NOT AIM AT

`athlete_development_test` currently fails 6 checks, all cascading from one:
`boxing_stance_guard` requires **45** reps where one training week delivers
**44**, so boxing's entry technique no longer learns in its minimum week. It was
40 on master and R128's flat tier-1 value of 45 moved it across that line.

**Do not target that test.** Deriving a curve and then nudging one node until a
test goes green is fitting data to a fixture, which is the exact defect this
catalogue has already paid for repeatedly. Derive the curve properly; then
report what it yields for `boxing_stance_guard` and whether those 6 checks pass
as a result. **If your honest curve leaves it above 44, say so and leave it** —
that is a real answer and it tells us the one-week assumption is the thing to
question.

## Rules

- **Do not copy master's old values.** They are a fossil of a 272-node catalogue
  and restoring them is exactly the "keep your own copy of the answer" defect
  this tree has been bitten by all day. Derive from the live exemplar.
- Report what you measure. If judo's relationship is weak, a weak fit reported
  honestly beats a strong one asserted.
- `Godot/assets/data/technique_catalog.json` is large — parse it in code, do not
  read it by eye. `GameState.gd` is 12,938 lines and you do not need it.

## Done

- Your test green; `--only technique`, `--only athlete_development` and
  `--only skill_tree` at **fails=0 as a CEILING** — if a pre-existing failure
  disappears, say so and push.
- `git status -s` FIRST, then `git add --` your three explicit paths only. Never
  `git add -A`, and never a bare `git stash` / `reset --hard` / `checkout .` /
  `clean` — this checkout is shared.
- Commit ending `Co-Authored-By: Cursor <noreply@cursor.com>`, then push.
- One line of mail:
  `python Tools/agent_comms.py send --from cursor --to claude --topic U67-done --body "<hash> relation=<short> nodes_changed=<n> stance_guard_reps=<n> athlete_dev_fails=<n>"`
- **Do NOT edit `HANDOFF.md` or `AgentComms/roadmap.json`** — Claude writes your
  block. You wrote into both on U65 despite the task file forbidding it.

## THE ONE TRAP

**`requires.discipline` is a GATE, not a cost, and the two move together in the
flat trees only because both were filled in from the tier.** If you retune reps
and leave the discipline gate flat, a tier-2 boxing technique still unlocks at
exactly the same proficiency as every other tier-2 boxing technique and the
player still has no meaningful choice — you will have fixed half the problem and
the measurement in your own table will say so. Decide deliberately whether the
gate moves with the cost, and state which you chose and why.
