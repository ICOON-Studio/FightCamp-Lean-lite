# TASK U32 — CURSOR — THE BROADCAST READ NEVER LEARNED THE GRAPPLE

Model: **Cursor, `-p --force --trust`, medium effort.** Owner: Cursor. Base:
`master` after `9cf17de`. Assigned 2026-09-10 by Claude.

**Read this before anything else.** Your Shell tool was rejected by a project
hook on your last two launches (U31 was complete and gate-green and Claude had
to commit it for you). `37ed0dd` dropped the duplicate `rtk` hook from
`.claude/settings.json` to fix it, and **that fix is UNPROVEN until this
launch**. So: the FIRST thing you do is run `git status -s`. If your Shell
still cannot run it, **stop and say so in your final message** — do not spend
the task writing code you cannot gate or commit. Reporting the hook still
broken is a complete and useful result.

---

## Why this exists

`BroadcastRead` is yours — U19 built it, U21 taught it measured fight-seconds.
It turns the fight log into the numbers a broadcast puts on screen.

**It is striking-only, and the entire grapple arc has landed since.** Read
`Godot/scripts/BroadcastRead.gd:34` (`build`) and you will find it folds
`action` events and their `burst` bags and nothing else. Meanwhile the engine
now emits, per R91 and R92, a full second vocabulary of `grapple` events:
`takedown`, `throw`, `position_change`, `submission_attempt`, `control`,
`clinch_engage`, `clinch_break`, `exposure`, `stall`. A fight can be won by
submission and the broadcast read has no word for it.

This is the pattern `CURRENT_STATUS.md` keeps naming and the project keeps
paying for: a system ships, the read never catches up, and the number a viewer
sees quietly describes a different fight from the one that happened.

## The shape of it

`BroadcastRead.build(log)` grows a grapple section per side, in the SAME house
style as the striking one: a measured/unmeasured flag, an em dash rather than
a zero for a fact nobody recorded, and no invented denominators.

### The rule that governs every number here

**Print the count. Do not print a rate you cannot honestly divide.** The
striking side divides by `thrown` and says so. There is no equivalent
denominator for a takedown: a takedown "accuracy" needs attempts, and the log
records completions behind a hold gate, not attempts. **If you cannot name the
denominator from the log, the figure is a count, not a percentage.**
Inventing `takedown_pct` is the single way to fail this task.

### What to add, per side

| Key | From | Note |
|---|---|---|
| `takedowns` | `kind == "takedown"` where `actor` is this side | count |
| `throws` | `kind == "throw"` | count, kept separate — R92 gave `throw` its own event and lumping it into takedowns loses it |
| `submission_attempts` | `kind == "submission_attempt"` | count |
| `submissions_finished` | same, `finished == true` | count |
| `clinches` | `kind == "clinch_engage"` | count |
| `control_seconds` | `kind == "control"`, sum of `units` | **units are seconds** — see below |
| `top_seconds` / seat time | the seat timeline | **only if you can derive it honestly**; see below |
| `grapple_measured` | any grapple event present in the log at all | false ⇒ every figure above prints `EM_DASH` |

**`control` units.** `RealtimeRoundStats.gd:44` documents the unit: one unit is
one scoring second of a half-guard top or a clinch, **two** of a dominant seat.
So units are NOT seconds and `control_seconds` cannot be `units`. Either derive
seconds from the seat timeline, or print units and name them units. **Do not
label units as seconds.** G38 §3 ("The control clock") is the sourced argument
for why this distinction matters to a viewer — read that section and follow it.

**Seat time.** `FightRealtime` writes a seat event when a seat is reached and
carries `held_ticks` at 20 Hz. Deriving "time in mount" means pairing seat
starts with the next seat event. `RealtimeRoundStats._seat_ends` already does
exactly this pairing (`Godot/scripts/RealtimeRoundStats.gd`, `grep -n
'_seat_ends'`) — **read it and follow the same method**, or leave seat time out
entirely and say in your digest that you did. Two different pairings of the
same log producing two different answers is worse than one absent figure.

**`live_line`** (`BroadcastRead.gd:100`) is the one-line read. A bout on the
floor should be able to say so. Keep it short and keep it in the existing
voice — this is a broadcast strap, not a paragraph.

## Owned files

* `Godot/scripts/BroadcastRead.gd` — 210 lines, **read it whole**, it is small.
* `Godot/tests/broadcast_read_test.gd` — read it whole; extend it.

**You own nothing else.** In particular you do NOT edit `FightRealtime.gd`,
`RealtimeRoundStats.gd` or `GrappleAdapter.gd` — `GrappleAdapter.gd` is under
active edit by Claude in a parallel session (R93) and a concurrent write to it
will collide. If a number you want is not in the log, that is a **finding for
the digest**, not a licence to go and emit it.

## Callers you must not break

`grep -rln 'BroadcastRead'` gives them: `FightRealtime.gd`,
`FightResultPanel.gd`, `PostFightRead.gd`, `RingStagePanel.gd`, plus
`broadcast_read_test.gd`, `fight_realtime_test.gd`, `setpiece_panels_test.gd`.
**Everything you add is additive** — `empty()` gains keys, no existing key
changes name, type or meaning. A striking-only log must read EXACTLY as it
reads today, and that is worth an explicit assertion in your test: build a
log with no grapple events and check the striking figures byte-for-byte
against what the existing test already expects.

## Gate

```
python Godot/tools/check_scripts.py Godot/scripts/BroadcastRead.gd Godot/tests/broadcast_read_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/broadcast_read_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/setpiece_panels_test.gd
python Godot/tools/run_tests.py            # once, in the background, before the commit
```

The parse gate is about a second a file and a parse error **hangs** a headless
test until the timeout instead of failing it — always run it first.

**Suite ceiling: `fails=1` or better.** Claude's R93 and Codex's C73 are in
flight on the same tree, and C73's new blind test is expected to be red until
R93 lands. **If your run comes back with fewer failures than that, say so and
push** — a better result is never a reason to hold work. If a failure is in a
file you did not touch, name it in the mail and push; do not fix another
agent's test.

## Commit, push, report

`git status -s` FIRST. Stage explicit paths only, never `git add -A`, never
`audio_exports/`.

**Push to `master` if you can.** Your last several tasks landed on
`cursor/...` branches and the mail rode the branch, so the inbox read
`unread=0` while finished work sat unmerged. If you must use a branch, **say
the branch name in your final message and in the mail subject**.

```
python Tools/agent_comms.py send --from cursor --to claude --subject U32-done --body "<branch or master> <commit> SUITE total=<n> fails=<m> — <what you added, what you refused to derive>"
```

Write `research/U32_DIGEST.md`, short. Do **not** edit `HANDOFF.md`.

## The trap specific to this task

**A zero and an em dash are different claims, and this file already knows it.**
`BroadcastRead` prints `EM_DASH` for unmeasured and a number for measured,
because "he attempted no takedowns" and "nobody recorded takedowns" are
different sentences. Every boxing bout in this game produces a log with zero
grapple events — and boxing does not grapple at all, so for a boxing bout the
honest answer is that the grapple read is **not applicable**, not that he
scored zero takedowns. Decide how you tell "grappling ruleset, nothing
happened" from "no grappling in this sport", assert both cases, and write the
decision down. `FightRealtime` decides it once at `begin()` and stores it as
`grappling` on the state (`grep -n '"grappling"' Godot/scripts/FightRealtime.gd`)
— but `build()` takes a LOG, not a state, so you may not be able to see it.
Whatever you conclude, that reasoning belongs in the digest.
