# TASK_U124 — Does any of OUR gates score only the pairs it declared?

**Owner:** cursor
**Model:** `composer-2.5`, medium effort
**Launch:** `-p --force --trust --model composer-2.5 --workspace <worktree>`
**Test tier:** parse gate on any `.gd` you touch, then `run_tests.py --only pair`
and SEPARATELY `--only stage`. `--only` DOES NOT STACK — one per invocation.
**Do NOT run the full suite.**

## Why you, and why the answer is not known in advance

You are being given this because U123 refuted my own hypothesis about the
10,576 deg/s spike and found the real cause. **I do not know the answer to this
one either, and I have a specific reason to fear it.**

On 2026-09-22 I ran an outside contributor's two-body pose solver. It reported
`pen = 0.0046 m` and PASSED its own threshold — while the two torsos were
**0.2208 m inside each other**. The bug was not in the geometry. It was that its
worst-penetration figure was computed **only over the capsule pairs it had
declared as intended contacts**. Everything it had not thought to declare was
invisible to it. On all thirteen of its poses, the worst real interpenetration
was never a declared pair.

**The question: does FightCamp do the same thing anywhere?**

This is the general defect class — *a gate whose search space is supplied by the
thing it is grading*. It has bitten this project before under other names
(`validate_technique_nodes` learned its allowed values from the catalogue it was
validating; a realism test took its floor from the data it was judging). So the
prior is that we have at least one.

## Where to look

Search for gates, checks and tests that iterate a **declared/authored list** and
report a worst-case or a pass/fail from it, rather than iterating the **full
space**. Starting points, not an exhaustive list:

- `Godot/scripts/FightPoseSolver.gd` — `evaluate()` at `:161`,
  `resolvable_contacts()` at `:286`. Does anything compute a worst penetration
  from a `contacts` array rather than from all body pairs?
- `Godot/tests/fight_pose_solver_test.gd`
- `Godot/tests/s41_pair_contact.gd`, `Godot/tools/s41_pairgap_diff.py`
- `Godot/tests/pair_gap_report.gd` — **known to measure hips-to-hips only** and
  therefore blind to anything below `Hips`. That one is already documented; use
  it as the worked example of the shape you are hunting, not as a finding.
- `Godot/tools/check_scripts.py`, `Godot/tools/run_tests.py`
- anything under `Godot/tests/` matching `grep -rn "for .* in .*contacts\|declared\|authored" Godot/tests/ Godot/scripts/`

## What a finding looks like

For each one: the `file:line`, what the gate iterates, what it CANNOT see, and —
this is the part that makes it real — **a concrete input that would pass the gate
while being wrong**. A gate that is technically narrow but cannot actually be
fooled is not a finding; say so and move on.

Rank them. Worst first. If you find none, say so plainly and show me the two or
three you checked hardest — that is a useful result and I will believe it.

## Owned files

- `research/U124_DECLARED_ONLY_GATES.md` — CREATE, yours alone.
- Everything else is **READ-ONLY**. Do not fix anything you find; I want the
  census first, and a fix bundled with a census hides how bad it was.

`GameState.gd` is ~13,000 lines — **never open it whole.** If you need it, grep
for the symbol and read a `sed -n 'A,Bp'` window.

## Trap specific to this task

**Do not confuse "narrow on purpose" with "blind".** A test that deliberately
checks one pair, named in its own output, and says so, is fine. The defect is a
gate that reports a **worst-case or a global verdict** from a partial set while
presenting it as complete. Quote the line that makes the claim global.

## Deliverable and gate

Write `research/U124_DECLARED_ONLY_GATES.md` and nothing else. **This is a research task: no `.gd` file is
touched, so there is NO gate at all** — not the parse gate, not a test. Do not
run the suite; it costs twenty minutes and proves nothing about a markdown file.
`git status -s` before you stage is the whole check.

Commit and push `master`, then send one line:

```bash
python Tools/agent_comms.py send --from cursor --to claude --subject u124-ready --body "<one line>"
```

**Do NOT edit `HANDOFF.md`.** Stage explicit paths only (`git add -- <files>`);
never `audio_exports/`. Check `git status -s` first — another agent's
work-in-progress may be pre-staged, and a path-limited add can still sweep it in.

Keep it under 400 lines. Lead with a three-line summary: the single most
important thing you found, the single thing you would change first, and whether
you think the direction is right.
