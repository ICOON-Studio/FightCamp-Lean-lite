# TASK_Q144 — IS `fight_metres_test` A FLAKE OR A REAL HANG? THE RECORD IS UNTRUSTWORTHY.

**Model: `qwen3-coder`, medium effort, `--yolo` (NEVER `auto` — auto leaves you
with no shell tool at all).** Worktree `FightCamp-Q114`, cut a FRESH branch off
`origin/master` named `qwen/q144-metres-hang`.

**Read this file and only the files it names.** Do NOT read `HANDOFF.md`,
`CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md` or any digest.

---

## THE SITUATION

`Godot/tests/fight_metres_test.gd` fails the suite with `hang (timeout)` —
`rc=124`, meaning the runner killed it rather than it reporting anything.

**The project's written record says: "it HANGS under contention and PASSES
ALONE."** On 2026-09-23 that note was tested and **it hung on its own run too**
(`run_tests.py --only fight_metres` → `SUITE total=1 fails=1`, hang/timeout).
But another agent was driving Godot at that moment, so **it was not genuinely
alone either**, and the note is now neither confirmed nor refuted.

**So the record is untrustworthy in both directions, and a suite that carries a
permanently-excused red is a suite people stop reading.** Settle it.

---

## THE QUESTION

**Does `fight_metres_test.gd` hang on a quiet machine, and if so, where?**

### 1. RUN IT GENUINELY ALONE, AND PROVE THE MACHINE WAS QUIET

Before the run, capture what else is using the CPU and record it in your report.
On Windows, `Get-Process` filtered to `Godot|codex|cursor|qwen|blender` is
enough; list what you found, including nothing. **A run you cannot show was
quiet is another data point of the same useless kind.** Run it at least
**three** times:

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_metres_test.gd
```

Run it directly like that, NOT through `run_tests.py`, so the runner's own
timeout is not what you are measuring. Time each run. **If it completes, say how
long it took** — a test that takes 9 minutes under a 10-minute timeout is a
different problem from one that never finishes, and the fix is different too.

### 2. IF IT HANGS, FIND WHERE

**Do NOT fix it.** Find the line. The cheap method, in order:

1. `print()` at the top of `_initialize()` — does it start at all? A test that
   never prints its first line is usually a **parse error in a script it
   loads**, not a loop. That is the single most common cause of `rc=124` in this
   project.
2. Bisect with prints down the test body. Report the LAST line that prints.
3. Name the call that does not return.

### 3. SAY WHICH IT IS

One of:

- **(a) It passes when genuinely alone.** The record is right; report the
  timings and how quiet the box was, and say how close to the timeout it runs.
- **(b) It hangs always.** The record is WRONG and has been excusing a real
  red. Name the line.
- **(c) It is slow, not hung.** Report the real duration and whether the
  timeout is simply too tight.

**All three are good answers. (b) is the most valuable and the least
expected — do not shy from it.**

---

## OWNED FILES

- `research/Q144_METRES_HANG.md` — **new, yours.** Your findings.
- `Godot/tests/fight_metres_test.gd` — you may add **temporary prints** while
  bisecting. **REVERT THEM BEFORE YOU COMMIT.** `git diff` must show this file
  unchanged when you push. **Do not fix the test.**

## TEST TIER — THIS TASK *IS* THE TEST RUN

No other gate is owed. If you leave `fight_metres_test.gd` unchanged, as
required, then no `.gd` is edited and there is nothing to parse-gate. **Do NOT
run the full suite** — it is 356 tests and twenty minutes and it is the exact
contention you are trying to measure.

**The exit code alone is NOT a pass**, and here it matters more than usual: a
GDScript runtime error leaves rc=0, and `rc=124` is a kill, not a failure.
Report the raw exit code of every run. Godot's `N RID allocations ... were
leaked at exit` and `N resources still in use at exit` are teardown chatter, not
failures.

---

## THE ONE TRAP SPECIFIC TO THIS TASK

**A hang caused by a parse error in a script the test LOADS will not be in the
test file at all**, and bisecting the test body will therefore find nothing —
you will print your way to the bottom of the file and conclude, wrongly, that
there is no hang. So run the parse gate over the test **and everything it
preloads** before you bisect a single line:

```
python Godot/tools/check_scripts.py Godot/tests/fight_metres_test.gd <each script it preloads>
```

Read the test's `preload` lines and pass every one of them. If the gate is
clean, then bisect. **Say in your report that you did this**, because a later
reader needs to know the cheap cause was ruled out rather than skipped.

---

## WHEN YOU ARE DONE

Commit (your research file only), push `qwen/q144-metres-hang`, and send one
line:

```
python Tools/agent_comms.py send --from qwen --to claude --topic Q144 --body "<one line, NAME THE BRANCH, and say (a), (b) or (c)>"
```

**Do NOT edit `HANDOFF.md`** — I write your block.
