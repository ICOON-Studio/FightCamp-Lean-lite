# U137 — BUILD `ApproachSweep.gd`, THE SWEEP THAT IS COPY-PASTED INTO THREE PROBES

**Owner:** cursor (`composer-2.5`, MEDIUM). Worktree `FightCamp-U114`.
**Cut a FRESH branch off `origin/master` named `cursor/u137-approach-sweep`.**
**Tier: parse gate, then `--only approach_sweep`, then the two probe re-runs
below. NO FULL SUITE RUN** — that is Claude's, once, at integration.

## YOU ARE THE MODULE HALF OF A BLIND SPLIT. THE TEST IS ALREADY ON DISK.

`Godot/tests/approach_sweep_contract_test.gd` exists (commit `cdb1e5fb`). It was
written by another agent from the contract below, **without ever seeing an
implementation**, and it currently skips green because the module is absent.

**DO NOT OPEN THAT TEST FILE. Not to peek, not to "check the shape", not at the
end.** A module written against its own test only ever agrees with it. This
split has paid five times on this project — twice it found a genuine
contradiction inside the contract that no implementation could satisfy, which is
worth more than the test itself. You write the module from the contract; then
you run the test and find out.

If the test goes red, **the test is not automatically wrong**. Read the failure,
decide which side is right, and say so in the digest with the reasoning. If the
CONTRACT is ambiguous, fix it in the module with a named constant and record the
ambiguity — that is the most valuable outcome this task can have.

## WHERE THE CONTRACT IS

`research/TASK_C166_APPROACH_SWEEP_CONTRACT.md`, section **"THE CONTRACT —
EXACT NAMES, ARGUMENT ORDER AND RETURN SHAPES"** through the end of **"THE ROWS
YOUR TEST MUST CONTAIN"**.

**THAT FILE WAS ADDRESSED TO A DIFFERENT AGENT AND TELLS IT "do not write the
module". THAT INSTRUCTION IS NOT YOURS — you are the one writing it.** Read the
contract sections; ignore the ownership and gate sections, which are that
agent's. Its "ROWS YOUR TEST MUST CONTAIN" list is the behaviour your module
must exhibit, so read it as a specification, not as a test plan.

Read nothing else in that file's neighbourhood. **Do NOT read `HANDOFF.md`,
`CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md` or any digest, and do not explore to
"get oriented".**

## WHY THIS MODULE EXISTS — THE DEFECT IT REMOVES

The 128-direction reachability sweep ("can a hand get onto this body part
without entering another capsule of the SAME body") is copy-pasted into three
probes. Two of those copies `break` on the first blocker they find. **The first
blocker found is not the worst one, so the reported blocker depends on array
iteration order.** That cost a wrong diagnosis: one audit named `thorax` as the
neck's blocker while a blind test named `head`, off the same rig. The true
answer was BOTH, and the deeper one is the one that matters.

`blocker()` therefore **scores every candidate and returns the deepest**. There
is no `break` anywhere in this module.

## OWNED FILES — you own these and nothing else

- `Godot/scripts/ApproachSweep.gd`            (NEW — the module)
- `Godot/tools/s47_contact_offsets.gd`        (convert to use it)
- `Godot/tools/s52_present_ratio.gd`          (convert to use it)
- `research/U137_DIGEST.md`             (NEW — your digest)

**DO NOT TOUCH `Godot/tools/s53_ball_capsules.gd`.** Claude is editing it in the
main checkout this session and a conflict there costs both of us. It is the
third copy and it will be converted separately.

**DO NOT TOUCH** `ApproachBand.gd`, `CapsuleShape.gd`, `FighterCapsules.gd`,
`FightPoseSolver.gd`, `HANDOFF.md`, or any test file.

## FILES YOU MAY READ

- `research/TASK_C166_APPROACH_SWEEP_CONTRACT.md` — the contract.
- `Godot/scripts/ApproachBand.gd` — already shipped, 171 lines, read it whole.
  `in_band`, `band_for`, `banded_fraction` and `elevation_deg` are the four you
  need.
- `Godot/tools/s47_contact_offsets.gd` and `Godot/tools/s52_present_ratio.gd` —
  you are converting them, so read them whole.
- `RESEARCH_INDEX.md` — **GREP IT, NEVER READ IT WHOLE** (214 KB, 789 documents,
  220 tools, 116 drivers). Worth running: `grep -i 'sweep' RESEARCH_INDEX.md`
  and `grep -i 'reachab\|exposure' RESEARCH_INDEX.md`. **A negative result is a
  result** — say so in the digest.

`FighterCapsules.gd` is large — **do not open it whole.** You do not need it: a
capsule is just `{"name": String, "p0": Vector3, "p1": Vector3, "r": float}` and
that is the whole interface.

## PART 1 — THE MODULE

`Godot/scripts/ApproachSweep.gd`, every function `static`, **zero preloads**,
touching no rig, no scene and no autoload. It is arithmetic over points and
capsules, which is exactly why it can be tested blind.

Five functions, names and argument order EXACTLY as the contract gives them:
`direction`, `point_to_segment`, `hand_position`, `blocker`, `sweep`.

Three things the contract calls out that are easy to get wrong:

1. **A sphere is `p0 == p1`.** `FighterCapsules` promotes the head to a sphere
   on load, so a zero-length capsule is the NORMAL case here, not an edge case.
   `point_to_segment` and `blocker` must both handle it with no division by zero
   and no `NAN`.
2. **An unknown `target_name` returns an EMPTY `Dictionary` `{}`**, not a zeroed
   one. A caller that asked about a capsule this body does not have must be able
   to tell that apart from one that genuinely measured zero.
3. **`direction` must return a UNIT vector** for every in-range index. A lattice
   that quietly returns short vectors puts the hand INSIDE the target and every
   reading goes green. `count <= 0` returns `Vector3.ZERO`; `index` is clamped
   into `[0, count-1]`.

## PART 2 — CONVERT THE TWO PROBES, AND THE DIFF IS THE DELIVERABLE

Replace each probe's private copy of the sweep with a call into the module.
Delete the dead private helpers you replace; do not leave them beside the call.

**CAPTURE BOTH PROBES' OUTPUT BEFORE YOU CHANGE THEM.** Run each tool on the
unchanged tree first and save the log; then convert; then run again and diff.

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/s47_contact_offsets.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/s52_present_ratio.gd
```

**THE NUMBERS ARE EXPECTED TO MOVE, AND THAT IS THE POINT — DO NOT FORCE THEM
EQUAL.** Wherever a probe used to `break` on the first blocker, the `worst`
column will now name a DIFFERENT, DEEPER capsule. That is the defect being
fixed, not a regression.

**So the gate is not "identical". The gate is "every changed line is explained".**
In the digest, list each line that changed, and for each one say which of these
it is:

- `worst` names a deeper blocker than before → **the early-exit fix**, expected,
  quote the old and new depth.
- a `usable`/`pct` count changed → **investigate before accepting it.** The set
  of blocked directions should NOT move just because you stopped breaking early;
  a direction blocked by anything is blocked. A changed count means the module
  and the probe disagree about something real. Name it.
- anything else → name it and explain it.

**If NOTHING changed in either probe, say so plainly and check why** — either
both copies already scored every candidate, or your module is not actually being
called. Prove it is being called before you report "no change": an unchanged
measurement is evidence only if the instrument could have read differently.

## GATE — in this order

```
python Godot/tools/check_scripts.py Godot/scripts/ApproachSweep.gd Godot/tools/s47_contact_offsets.gd Godot/tools/s52_present_ratio.gd
python Godot/tools/run_tests.py --only approach_sweep
```

A parse error **HANGS** a headless test for 600 s instead of failing it, so the
parse gate runs FIRST, always.

`--only` **DOES NOT STACK** — a second `--only` REPLACES the first. One per
invocation, and **read the `total=` line** to confirm the filter actually
matched. `total=0` means your filter is wrong, not that the test passed.

**The gate is `total=1 fails=0` on `--only approach_sweep`.** If the blind test
goes red, that is a RESULT — fix the module if the test is right, and if the
test is wrong, say exactly which row and why in the digest. Do not edit the test
to make it pass; you do not own it.

**rc=0 IS NOT A PASS.** A GDScript runtime error exits 0. A test printing
nothing is a failure. Read the `SUITE` line.

## THE TRAP SPECIFIC TO THIS TASK

**`run_tests.py` reads the LOG for self-reported failure** (`run_tests.py:136-140`):
any line starting `FAIL`/`FAILED`, any `failures=N` with `N > 0`, any
`N failure(s)`. Your two probe re-runs print diagnostics — if any of them uses
those words, a green run is condemned anyway. Use `checks_failed=` if you need
that vocabulary.

**And the second one: `var x := <call>` fails when the call returns Variant** —
`.size()` or `.get()` on an untyped value, a static on a `load()`ed script.
Write the type: `var n: int = ...`. Reusing a variable name inside one function
is a parse error even across separate `if`/`for` blocks. `%` inside a format
string must be `%%`.

## FINISH

1. Commit with **explicit paths on the commit line** (`git add -- <files>`) —
   never a bare `git add`. This checkout is shared and another agent's WIP may
   be pre-staged. Run `git show --stat HEAD` afterwards and check it carries
   only your files.
2. **Commit after each step.** An honest partial beats an uncommitted whole.
3. Push `cursor/u137-approach-sweep`.
4. Write `research/U137_DIGEST.md`: the module, the blind test's verdict,
   **the full before/after diff table for both probes with every changed line
   explained**, and anything in the contract you found ambiguous.
5. One line back: `python Tools/agent_comms.py send --from cursor --to claude
   --subject "U137 ready" --body "<one line, and NAME THE BRANCH
   cursor/u137-approach-sweep>"`.
6. **Do NOT edit `HANDOFF.md`.** Claude writes your block.
