# TASK Q25 — QWEN — THE GROUND FIGHT READ, AUDITED AGAINST WHAT WE ACTUALLY BUILT

Model: **Qwen default, `--yolo`, medium effort.** Owner: Qwen. Base: `master`
after Q24. Assigned 2026-09-10 by Claude.

**This study was going to Maria (art direction).** It is rewritten for you and
the rewrite is the point: Maria has no checkout and could only have described
a screen she has never seen. **You can open the panel that ships.** So this is
not "draw a mock" — it is an audit of G38's recommendation against
`FightHudPanel.gd` as built, ending in a spec a build task can type without
one design decision left in it.

Deliverable: one file, `research/Q25_GROUND_READ_AUDIT.md`. No `.gd`
edits. No `HANDOFF.md` edit.

---

## Why this exists

The grapple arc landed in five pieces across four agents — G34 the contract,
G38 the read, U25/U28 the HUD panel, U31 the seat chip, Q23 the fold that
carries the seat. **Nobody has ever checked the shipped panel against G38's
spec.** Each piece was gated on its own test, which is precisely the failure
`CURRENT_STATUS.md` names: "every test checked a single function in isolation
and none asked whether the pieces could ever line up."

G38's verdict is that the ground read is **quieter, not busier**: a seat chip,
attempt pips, and silence. That is an unusual instruction and it is easy to
implement half of — the chip and the pips are the fun part, the silence is the
part that gets forgotten.

## Your sources

1. **`research/G38_THE_GROUND_FIGHT_READ.md`** — §5 "Recommendation",
   §5's "What deliberately does not appear", §6 "What it should sound like",
   and the "One-screen spec" at the end. `grep -n '^#' ` it first, then
   `sed -n` those sections. **§1 and §2 (broadcast and game teardowns) are
   background you do NOT need** — do not read them, they are long.
2. **The code**, whole where it is small, windowed where it is not.
3. `research/G39_THE_CLINCH.md` §7.1 only (`sed -n '264,282p'`), for what
   a clinch emits — the clinch seat is newer than G38 and G38 never saw it.

## The deliverable, in this order

### 1. The audit table — G38 asked for, we shipped, verdict

One row per element in G38 §5 "What appears" and one row per element in "What
deliberately does not appear". Columns:

`G38 element | Shipped? | Where (file:line) | Verdict`

Verdict is one of **MATCHES**, **PARTIAL** (say what is missing), **ABSENT**,
or **VIOLATION** (we show something G38 says must not appear). A VIOLATION row
is the most valuable thing in this document — look for one honestly before
concluding there are none.

Anchors to start from, all of them verified before you cite them:

```
Godot/scripts/FightHudPanel.gd   533 lines — read it whole, it is small
    :43   SEAT_LABELS            the G38 seat-label table
    :342  _build_seat_chip       chip text, corner word, stall amber/red
    :373  _build_submission      the attempt pips
    :399  _build_submission_orphan
    :515  the test-facing read (what the panel says it drew)
Godot/scripts/FightHudRead.gd    110 lines — read it whole (Q23 put the seat in it)
Godot/scripts/GrappleSeat.gd      89 lines — read it whole (the seat vocabulary)
Godot/tests/fight_hud_panel_test.gd  398 lines — read it whole; it is the
                                     record of what the panel is CHECKED to do
```

`Godot/scripts/UIKit.gd` is **7,352 lines — never open it whole.** You need
exactly two things from it: the signature of `UIKit.chip(...)` and the list of
chip `kind` values it accepts. Get them with
`grep -n 'func chip' Godot/scripts/UIKit.gd` and read that one function's
window with `sed -n`.

`Godot/scripts/UITokens.gd` is 171 lines — read it whole. You will need the
real token names.

### 2. The silence audit

G38's hardest instruction. Answer these as facts with anchors, not opinions:

- What does the panel draw during a **stalled, uneventful** ground position?
  Trace `_build_seat_chip` with `stall_ticks` past amber and past red and say
  exactly what changes on screen.
- Does anything **animate, pulse, count up or re-render per tick** while
  nothing is happening? Look for it. A number that ticks upward is the loudest
  thing a quiet screen can do.
- Is there any surface that appears ONLY on the ground and would read as the
  UI having hung if the fight stayed there for ninety seconds? G38 §5's "How
  the UI says 'deliberately quiet' rather than 'hung'" is the bar.

### 3. The clinch, which G38 never saw

R92 added a standing clinch seat (`over_under`) after G38 was written. U31
mapped it to the word `CLINCH` (`FightHudPanel.gd:45`). G38's read was
designed for a fight on the floor. Say whether the same treatment is right for
a fight standing up and tied up, and name every place the panel would need to
distinguish the two. **This is the one place you are asked for a
recommendation rather than an audit** — make it, argue it from G38's own
principle, and label it INVENTION.

### 4. The spec — what a build task types

Only for rows that came back PARTIAL, ABSENT or VIOLATION. For each:

- the exact file and function that changes;
- the exact **existing** `UITokens` constant and `UIKit` chip kind to use;
- the copy, verbatim, in the panel's existing voice (short, upper-case where
  the panel is upper-case);
- what its assertion in `fight_hud_panel_test.gd` looks like — the read key
  and the expected value, in the style the file already uses.

**No new token may be proposed.** `HANDOFF.md` records two token rulings (R47,
R48) where a study named colours that do not exist and the ruling was that
`UITokens.gd` is not edited. If the palette genuinely cannot express something,
that is a finding — write it as one and stop, do not mint a colour.

### 5. Findings and open questions

At most three questions, each with a recommended default, G39 §8's form.

## Owned files

* `research/Q25_GROUND_READ_AUDIT.md` — NEW, and the ONLY file this task
  creates or edits. No `.gd` file, no test, no `HANDOFF.md`.

## Gate

No parse gate, no test run — one Markdown file, no script touched. Before
committing, `git status -s`: the ONLY change is
`research/Q25_GROUND_READ_AUDIT.md`. Stage that explicit path. Never
`git add -A` in this shared checkout.

## Commit, push, report

```
git add -- research/Q25_GROUND_READ_AUDIT.md
git commit    # house style; check `git log --oneline -5` first
git push origin master
python Tools/agent_comms.py send --from qwen --to claude --subject Q25-done --body "<commit> — <one line: how many MATCHES / PARTIAL / ABSENT / VIOLATION>"
```

Do **not** edit `HANDOFF.md`.

## The trap specific to this task

**An audit that finds everything correct is the failure mode here**, because
it is the cheap answer and it is what an agent produces when it reads the spec
and the code in the same pass and lets each explain the other. Read G38 §5 and
write down its list of elements FIRST, in your notes, before you open
`FightHudPanel.gd`. Then check the panel against your list. That ordering is
the whole method and it is the same reason this project writes tests blind.

**Second trap:** you are auditing the READ — what the screen says. You are not
auditing whether the numbers behind it are right. If you find a number you
believe is wrong, that is a finding for the report, not a thing to go and fix.
