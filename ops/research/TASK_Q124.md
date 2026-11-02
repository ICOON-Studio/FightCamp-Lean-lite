# TASK_Q124 — QWEN — WHICH PUBLISHED FIGURES ARE EXTREMA, AND SO SUSPECT

**Owner: Qwen.  Model: `qwen3-coder`, MEDIUM effort.**
Launch from your worktree: `Set-Location <wt>; Get-Content <prompt> -Raw |
qwen.cmd --yolo -m qwen3-coder`. PowerShell reports exit 1 on the yolo warning —
**read the `.out` file, never the rc.**

**Test tier: NO GATE AT ALL — this task touches no `.gd` file.** Not the parse
gate, not a test. `git status -s` before staging is the whole check. You are
writing Python and Markdown only.

**Owned files (yours, nobody else touches them this run):**
- `research/Q124_check.py`  (NEW — your own gate)
- `research/Q124_EXTREMA_AUDIT.md`  (NEW — your report)
- `research/Q124_extrema.json`  (NEW — the machine-readable list)

**You own NOTHING else.** Do not edit any `.gd` file, any other research
document, or `HANDOFF.md`.

---

## WHY THIS EXISTS

Godot's clip loaders resample every animation onto a `bake_fps` grid whose
default is **30**. Any clip authored above 30 Hz has been arriving in this
project with the intervening frames interpolated back in.

S39 measured the cost on a 120 Hz motion capture and found the shape of the
damage, which is the important part:

- the **minimum** of a quantity moved 0.1407 m → **0.1455 m** (+3.4%)
- the **median** of the same quantity moved 0.1960 m → **0.1950 m** (−0.5%)

**A resample destroys single-frame extrema and leaves distributions alone.** So
every figure this project has published that is a MINIMUM, a MAXIMUM, a PEAK, a
CLOSEST, a WORST or a FIRST-FRAME value — taken through a clip load — is
suspect by up to a few per cent in the direction that flatters or flattens the
peak. Every figure that is a median, a mean, a p50 or a share is not.

**Nobody knows how many of the published numbers are extrema.** That is the
question. This is an AUDIT OF THE RECORD, not of the code.

---

## WHAT TO DO

Walk `research/*.md` — every file, no exceptions — and find every
**quantitative claim that is an extremum**.

### What counts as an extremum

A figure introduced by, or labelled with, any of: `min`, `minimum`, `max`,
`maximum`, `peak`, `worst`, `closest`, `furthest`, `largest`, `smallest`,
`deepest`, `highest`, `lowest`, `p0`, `p100`, `first frame`, `at contact`.

A figure labelled `p10`/`p50`/`p90`, `median`, `mean`, `average`, `share`,
`rate`, `%`, or a COUNT of things is **not** an extremum. Counts are exact and a
resample does not change them.

### What counts as "taken through a clip load"

The document must be reporting a measurement made by a tool that loads an
animation file. You cannot run Godot, so decide this from the text: the document
names a `.glb`/`.fbx` file, or a `Godot/tools/*.gd` measuring tool, or a clip
stem, or a retarget/bake/pose/skeleton quantity in metres or degrees.

A figure from a study of real-world footage, a literature anchor, a survey of
prices, a token count or a test count is **NOT** in scope even if it is a
maximum. **Say so explicitly when you exclude one** — the exclusions are half
the value of this audit.

### Output

`research/Q124_extrema.json`: a list of objects with keys
`doc` (filename), `line` (1-based line number), `quote` (the sentence, ≤200
chars), `kind` (one of the extremum words above), `value` (the number as a
string, with its unit if one is given), `clip_evidence` (what in the text says
this came through a clip load), and `confidence` (`"high"` or `"low"`).

Plus a top-level `summary`: `docs_scanned`, `docs_with_extrema`,
`extrema_found`, `high_confidence`.

---

## YOUR OWN GATE — `research/Q124_check.py`

A research agent answers the question it prefers, so this script exists to make
that visible. It must:

1. Fail if `docs_scanned` is fewer than the actual number of `*.md` files in
   `research/` — **recount them itself with `glob`**, never trust the
   stored figure.
2. For every entry, **re-open `doc` at `line` and confirm `quote` is really
   there** (substring match after whitespace normalisation). A quote that is not
   in the file at that line is a fabrication and must fail loudly, naming the
   doc and line.
3. Fail if any entry's `kind` is not in the allowed extremum vocabulary.
4. Fail if any entry's `value` does not parse as a number after stripping units.
5. Fail if `high_confidence` is 0 — an audit that found nothing it would stand
   behind has not done the job.
6. Recompute all four `summary` counts from the entries and fail on mismatch.

Check 2 is the point of the script. **A gate that reads its answer from its
subject cannot fail**; this one re-derives every quote from the files on disk.

Run it and paste its output into your report:

```
python research/Q124_check.py
```

---

## WHAT THE REPORT MUST ANSWER

`research/Q124_EXTREMA_AUDIT.md`, short, answering exactly four questions:

1. **How many extrema are there, across how many documents?**
2. **Which ten are the most load-bearing** — the ones another document, a task
   file, or a gate quotes back? Grep for each value as a string across
   `research/`, `Godot/tests/` and `Godot/tools/` and say which are cited
   elsewhere. A number nobody reuses is cheap to re-take; a number a test gates
   on is not.
3. **Which are already known to be safe?** A figure measured from a clip whose
   native rate is 30 Hz or below loses nothing to a 30 Hz bake. You cannot read
   the rates — Cursor is measuring them in parallel as U122 — so **list what you
   would need from that census to clear each one**, by clip stem.
4. **Which figures did you EXCLUDE, and why?** List them. An audit that reports
   only its hits cannot be checked.

---

## TRAPS

- **Do not read `HANDOFF.md`, `HANDOFF_ARCHIVE.md` or `CURRENT_STATUS.md`.**
  They are large, they are not the corpus, and reading them costs a pass for
  nothing. `research/*.md` is the whole scope.
- **Do not re-derive or re-measure any figure.** You have no Godot and no clips.
  Quoting the record accurately is the entire job; a number you "corrected" is a
  number you invented.
- `git status -s` before you stage. Stage explicit paths only, never
  `audio_exports/`, and never a bare `git stash`/`reset --hard`/`clean` — this
  is a shared checkout and a concurrent stash once wiped a finished stage.
- **Never gate on an exact count.** If you find more extrema than you expected,
  that is over-delivery; report it and pass.

---

## WHEN YOU ARE DONE

1. Commit your three files by explicit path, message ending
   `Co-Authored-By: Claude Opus 5 <noreply@anthropic.com>`. Push.
2. One line back: `python Tools/agent_comms.py send --from qwen --to claude
   --subject q124-ready --body "<sha>, extrema=N across M docs, check PASS"`
3. **Do NOT edit `HANDOFF.md`.** Claude writes your block.

---

## THE ONE TRAP SPECIFIC TO THIS TASK

**The word "minimum" appears in this corpus far more often as a THRESHOLD than
as a MEASUREMENT** — "a minimum of three sources", "minimum viable", "the
minimum gap the booking allows". Those are rules, not readings, and a resample
cannot touch them. If your count comes back in the hundreds you have swept up
the thresholds; the `clip_evidence` field is what forces you to separate them,
so fill it honestly and mark anything you are unsure of `"low"`.
