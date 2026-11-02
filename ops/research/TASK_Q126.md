# TASK_Q126 - the pair-gap BASELINE, taken on master BEFORE S41 moves it

Model: qwen3-coder, medium. You own Q126. This file is self-contained: read it
and the files it names, nothing else. Do NOT read `HANDOFF.md`,
`CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md` or any digest, and do not explore to
"get oriented".

## WHY THIS IS URGENT AND WHY IT IS YOURS

Claude is about to change `FightClipRetarget.SILHOUETTE_SEGMENTS`, a shipped
constant that every bound clip in the game reads. That change moves the hip-to-
hip gap of every authored pair. **The numbers it moves have never been written
down, so there is nothing to compare the result against.** Your job is to write
them down first, from the tree as it stands, before the change lands.

It is yours rather than Claude's on purpose: a control arm measured by the same
hand that makes the change is not a control. You measure master untouched.

**DO NOT EDIT ANY `.gd` FILE. DO NOT CHANGE `SILHOUETTE_SEGMENTS`.** If you find
yourself editing a script, you have misread the task.

## START FROM MASTER, NOT FROM YOUR WORKTREE'S BRANCH

Your worktree sits on an old branch. First command, exactly:

    git fetch origin
    git checkout -B qwen/q126-pair-gap-baseline origin/master

Confirm with `git log --oneline -1` that you are on `6aba786e` or later. If you
are not on a commit descended from `origin/master`, STOP and say so.

## THE INSTRUMENT ALREADY EXISTS - DO NOT WRITE ONE

`Godot/tools/pair_gap_report.gd` is the S31 gate instrument. One key per run:

    Godot_v4.7.2-stable_win64_console.exe --headless --path Godot \
        --script tools/pair_gap_report.gd -- <binding_key>

The exe is in `%LOCALAPPDATA%\Programs\Godot\`. Each run prints exactly one
summary line, and that line is the deliverable:

    PAIRGAP key=<k> table=<t> frames=<n> min_gap_m=<f> max_gap_m=<f> mean_gap_m=<f>

A line starting `FAIL` is a real result - record it verbatim as the row for that
key and carry on to the next key. Do not repair it and do not skip it.

## THE NINE KEYS

Read them from `Godot/scripts/FightClipBinding.gd:888` (`PAIRED_BINDINGS`) rather
than trusting this list, but they are:

    grapple_sweep, grapple_takedown, grapple_throw, grapple_submission_attempt,
    grapple_submission_finish, grapple_escape, grapple_clinch_break,
    grapple_control, grapple_stand_up

`grapple_escape` and `grapple_clinch_break` bind the SAME pair file. Run both
anyway and record both - if the two rows differ, that is a finding and you say
so in the digest.

## DELIVERABLE

**ONE new file, `research/Q126_PAIR_GAP_BASELINE.md`, 60 lines at most.**

- `## POPULATION` - name the commit you measured (`git rev-parse --short HEAD`),
  the two fighter GLBs `pair_gap_report.gd` hardcodes (read them off
  `FIGHTER_A`/`FIGHTER_B` at the top of the file, and state their weight limits
  are DIFFERENT - welter and heavy - which is deliberate: this project never
  measures two identical fighters), and the exe version string.
- `## BASELINE` - a markdown table, one row per key, columns exactly
  `key | table | frames | min_gap_m | max_gap_m | mean_gap_m`, six decimal
  places, copied from the `PAIRGAP` lines. A `FAIL` key gets its verbatim FAIL
  text in a single merged cell.
- `## RAW` - the nine (or fewer) `PAIRGAP`/`FAIL` lines verbatim, in a fenced
  block, so a later reader can diff them without re-running anything.
- `## WHAT THIS IS FOR` - two sentences: these are the BEFORE numbers for the
  S41 girdle change; anyone quoting an AFTER number must quote the matching row
  here beside it.

**Generate the table from the captured output with a script, do not type it.**
Put that script at `Tools/q126_pair_gap_table.py` and commit it too, so the
table can be regenerated. Read the captured logs from files you redirect to -
do not re-run Godot to fill a cell.

## TEST TIER - THIS IS A RESEARCH TASK, THERE IS NO GATE

You touch no `.gd` file, so: **no parse gate and NO test run at all.** Not the
suite, not a focused test. `git status -s` before staging is the whole check.
If you catch yourself starting `run_tests.py`, stop - it costs forty minutes and
buys nothing here.

## THE TRAPS, AND EACH HAS COST THIS PROJECT A PASS

- **A Godot run's exit code 0 is NOT a pass.** A GDScript runtime error leaves
  rc=0. Read the `PAIRGAP` line itself; if a run prints no `PAIRGAP` and no
  `FAIL`, that run is a hang or a crash - record it as such, do not call it
  zero.
- **Run the keys ONE AT A TIME, sequentially.** Concurrent Godot boots on this
  box produce false all-failed results.
- **Redirect to ABSOLUTE paths.** In this harness a shell variable does not
  survive a newline, so `S=/path && nohup ... > $S/a.log` works on line one and
  writes to `/a.log` on line two. Write the full path in every redirect.
- **Do not "fix" a gap that looks wrong.** A large or negative-looking gap is
  data. Your job is the number, not the verdict.

## OWNED FILES

- `research/Q126_PAIR_GAP_BASELINE.md` (new)
- `Tools/q126_pair_gap_table.py` (new)

Nothing else. If a third file changes, you have gone outside the task.

## FINISH

Commit both files with explicit paths (`git add -- <files>`; never
`git add .`, and never stage `AgentComms/` or `audio_exports/`). Push
`qwen/q126-pair-gap-baseline`. Then ONE line back:

    python Tools/agent_comms.py send --from qwen --to claude --topic q126-ready --body "<hash>, <n> keys measured, min/max across the set"

Do NOT edit `HANDOFF.md`.

## THE ONE TRAP SPECIFIC TO THIS TASK

**Measure BEFORE you pull again.** If Claude pushes the S41 change while you are
running, a `git pull` mid-task silently turns your BEFORE table into an AFTER
table and nothing in the output would show it. Pin to the commit you checked out
at the start, never pull during the run, and print that hash in the digest.
