# TASK Q24 — QWEN — MUAY THAI: WHAT THE CLINCH SCORES, AND WHAT THE ADAPTER MUST REFUSE

Model: **Qwen default, `--yolo`, medium effort.** Owner: Qwen. Base: `master`
after `9cf17de`. Assigned 2026-09-10 by Claude.

**This is a RESEARCH task with a checkout.** You are not writing a module. You
are writing one file, `research/Q24_MUAY_THAI_ADAPTER.md`, and every
claim in it about our engine must carry a `file:line` anchor you looked at.
That is the whole reason this study is yours and not an API-side agent's: they
could cite the rulebooks and had to guess at the code. You can read both.

---

## Why this exists

R92 shipped `GrappleAdapter.gd` — four rulebooks (`ijf`, `uww`, `ibjjf`,
`abc`) that convert engine grapple events into what each book actually scores.
`R92_DIGEST.md` finding 3 is the hole:

> **Muay thai folds engine units** although G39 says a dump without a weapon
> is not scored and a hip throw is a foul; an MT adapter is a new task.

That is this task. Today a muay thai bout reaches
`RealtimeRoundStats.fold(log, side, round, ruleset)`
(`Godot/scripts/RealtimeRoundStats.gd:93`), finds no entry for `muay_thai` in
`ADAPTER_FOR` (`:29`), and falls to `_fold_grapple` (`:135`) — **the engine's
own units**. So under muay thai a throw currently adds `grade` (2 or 4) into
`throw_points_round` and one into `takedowns_round`, and control seconds
convert into `control_score`. G39 says the book scores none of that, and that
the throw itself may be a **foul**. We are printing plausible numbers that are
wrong — the exact failure R85 named for taekwondo, one file over.

**You are deciding nothing.** You are producing the CONTRACT a later build
task types in. Where the book is silent, the answer is `NONE PUBLISHED` and
the cell is a refusal, not a guess.

## Your sources

1. **`research/G39_THE_CLINCH.md` §2 (Muay Thai), §5, §6, §7.2** — Grok's
   sourced pass. `sed -n '71,122p' research/G39_THE_CLINCH.md` and
   `sed -n '218,300p' …`. It names the editions: IFMA Rules & Regulations
   v3.057 (11 May 2026), WMC Rules §14–15, ABC Unified Rules of Professional
   Muay Thai (Jul 2024 / Nov 2024 impl.).
2. **`research/G37_THE_ADAPTER_FOLD.md`** — the TABLE SHAPE your
   deliverable must copy, and §4 for how a refusal is written up. Read the
   section headings first (`grep -n '^#' …`) and then only the sections you
   need. Do not read it end to end.
3. **The code**, for anchors only, listed under "Anchors" below.

You may search the web for the current IFMA / WMC / ABC-MT text to confirm an
article number. **Cite edition and article for every number.** A primer, a
gym blog or a "5 seconds" folk rule is not a source — G39 §6 item 6 already
refuses that one by name.

## The deliverable

**One file: `research/Q24_MUAY_THAI_ADAPTER.md`.** No code, no test, no
edit to any `.gd` file, no edit to `HANDOFF.md`.

It must contain, in this order:

### 1. Verdict table (one row per engine emission)

Copy G37's shape exactly. Columns: `Emit | Converts to | Article | Notes`.
The emissions the engine can produce are fixed and you must cover **all** of
them — take the list from `GrappleAdapter._norm`
(`Godot/scripts/GrappleAdapter.gd:60`) and `_fold_grapple_ruleset`
(`Godot/scripts/RealtimeRoundStats.gd:159`):

`clinch_engage`, `clinch_break`, `control` (units/second), `takedown`,
`throw` (with `grade` ∈ {2,4} and `to_seat`), `position_change`, `exposure`,
`submission_attempt`, `step_out`.

Every cell is one of: a **published number** (with the article), `not_scored`
(the book publishes no number for it), `foul` (the book penalises it — say
which foul and what it costs), or `REFUSE` (we cannot honestly derive the fact
the book asks for). `not_scored` and `foul` are different answers and must not
be merged.

### 2. The foul question, answered explicitly

G39 says a hip / lift / judo-wrestling throw is a foul (IFMA 31.2.8–10, WMC
15.2, ABC-MT K/N) and that a dump with no weapon is not a score (IFMA 29.2.2,
WMC 14.3.5). **The engine emits `throw` with a `grade` and a landing seat and
NO technique class** — `GrappleAdapter._norm` proves it, there is no `via`
value that says "hip throw". So answer the question the build task will ask:

- Can we tell a legal MT sweep from an illegal hip throw from what the engine
  emits? If not, say `REFUSE` and say what fact would be needed.
- If every `throw` under MT is indistinguishable, what is the honest fold —
  `not_scored` for all of them, or `foul` for all of them? **Pick one and
  argue it from the books.** A wrong foul is a deducted point that never
  happened; a wrong `not_scored` is a legal sweep that scored nothing. Say
  which error the books make cheaper.

### 3. The three federations, where they disagree

IFMA vs WMC vs ABC-MT and, separately, **stadium custom**. G39 §2.4 flags
stadium vs IFMA. Say plainly whether one adapter key can serve all three or
whether this needs more than one, and if more than one, name them. Do not
invent a stadium ruleset we have no book for.

### 4. Ready-to-paste block

A GDScript `const` block in G39 §9's style, named `MT_CLINCH`, with every
cell from §1 and a trailing comment on each invention. It must be typed
straight into `GrappleAdapter.gd` by a later task without a decision left in
it.

### 5. What this changes in our engine, with anchors

Exactly which lines a build task edits, and what moves:

- the `ADAPTER_FOR` entry at `RealtimeRoundStats.gd:29`;
- whether `scores_grappling` (`GrappleAdapter.gd:103`) and
  `FightRealtime._scores_grappling` (`FightRealtime.gd:1434`) still answer
  correctly for muay thai — check the muay_thai scoring profile's weights
  before you claim either way;
- which tests would move. `grep -rln 'muay_thai' Godot/tests/` and name them.

**Say whether a muay thai bout in this engine grapples at all today.** That is
a fact, not an opinion: read `_scores_grappling` and the muay_thai profile and
report the answer. If the answer is no, say so loudly — it changes the size of
the build task and it is exactly the kind of thing that gets assumed.

### 6. Open questions, each with a default

G39 §8's form. At most three. Every one gets a recommended default so the
operator can approve by saying "defaults".

## Anchors — read these windows, nothing else

```
Godot/scripts/GrappleAdapter.gd          346 lines — small enough to read whole
Godot/scripts/RealtimeRoundStats.gd      256 lines — small enough to read whole
Godot/scripts/FightRealtime.gd           ~1900 lines — NEVER open it whole
    :1434  _scores_grappling
    :1596  _grapple_clinch  (what a clinch emits)
    :380-390  where ruleset_id is set on the state
```

`GameState.gd` is ~13,000 lines. **You do not need it for this task. Do not
open it.**

The muay_thai scoring profile: find it with
`grep -rn 'muay_thai' Godot/scripts/*.gd Godot/data/*.json Godot/*.json` and
follow the one hit that carries weights. Do not read a whole data file.

## Owned files

* `research/Q24_MUAY_THAI_ADAPTER.md` — NEW, and the ONLY file this task
  creates or edits. No `.gd` file, no test, no `HANDOFF.md`.

## Gate

No parse gate and no test run — you are adding one Markdown file and touching
no script. Before you commit, `git status -s` and confirm the ONLY change is
`research/Q24_MUAY_THAI_ADAPTER.md`. If anything else is dirty it is
another agent's work in a shared checkout: stage your explicit path only,
never `git add -A`.

## Commit, push, report

```
git add -- research/Q24_MUAY_THAI_ADAPTER.md
git commit    # house style; check `git log --oneline -5` first
git push origin master
python Tools/agent_comms.py send --from qwen --to claude --subject Q24-done --body "<commit> — <one line: does MT grapple today, and the foul-vs-not_scored call>"
```

Do **not** edit `HANDOFF.md`. Claude writes your block.

## The trap specific to this task

**The books' silence is the finding.** G39 already established that IFMA and
WMC publish no seconds for a clinch break and no point for clinch control. The
temptation is to fill those cells from a coaching primer or from what the
engine happens to make convenient, and produce a table that looks complete.
A table with `NONE PUBLISHED` in six cells is the correct deliverable and is
worth more than a full one. **The second trap is scope:** you are writing the
contract, not the adapter. If you find yourself opening
`GrappleAdapter.gd` to edit it, stop — that is a later task, and typing it now
means the blind test that will check it was written against your code.
