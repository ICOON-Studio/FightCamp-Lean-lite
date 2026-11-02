# TASK U16 — CURSOR — THE GRAND PRIX ON THE RECORD

Model: Composer, effort **high**, Fast off. One session. Runs in parallel with
U15 and R74 and waits for neither.

**Agent:** cursor · **Opened:** 2026-09-08

## Why this exists — verified, not assumed

`_gp_champion_crowned` (`GameState.gd:8868`) appends to a `grand_prix_titles`
array on the athlete who wins a Grand Prix: event name, week, weight class,
discipline. It is a real, saved, durable career fact.

**Nothing reads it.** Grep `grand_prix_titles`: two writes in `GameState.gd`
(`:8868`, `:8870`) and three assertions in `tests/tournaments_test.gd`
(`:187`, `:232`, `:245`). No panel. A fighter can win the judo Grand Prix and
the profile shows no trace of it — the FIGHT RECORD tab knows about bouts and
the year spine (U8) and about honours (R71/U13), and knows nothing about this.

## What to build

The profile prints what a tournament run produced.

1. **One guarded read per rebuild**, the shape U8, U13 and U14 landed. The
   array lives on the athlete, so take it where the card is already composed
   and never inside a row builder.
2. **Each title prints as a line**: the event, the week it was won, the
   division. Words, not raw tokens — `brazilian_jiu_jitsu` reads BRAZILIAN JIU
   JITSU.
3. **No titles renders NOTHING** — no empty header, no placeholder row, no
   "0 titles". The house pattern is U7's: an empty section prints nothing at
   all, and the sections below it do not move.
4. **Absent read renders exactly as today**, and **that absent case is a
   required test.**

## What you must NOT do

* **This is not a belt.** A Grand Prix win is a dated event result, not a
  reign: never print "champion", "defending", "reign", "defences" or a belt
  chip beside it. Six of the nine tournament disciplines have no standing
  title at all (C52, R70), and the seventh's belt is a different object
  entirely.
* Do not read, rename or migrate `grand_prix_titles` in `GameState.gd` — you
  do not own that file and R74 is inside it this week.
* **R74 is adding an `event_results` array beside `grand_prix_titles` in
  parallel with you.** Do not try to read it, do not guess its shape, and do
  not leave a stub for it. `grand_prix_titles` is guaranteed to survive R74
  unchanged; that is the only thing you read.
* No new token in `UITokens.gd` (R47/R48), no `UIKit.gd` edit.

## Owned files

* `Godot/scripts/ProfileRevampPanel.gd` (3,224 lines — **never open it whole.**
  Read the FIGHT RECORD tab builder and the card-compose window only)
* `Godot/tests/profile_revamp_test.gd` (793 lines — extend)
* `research/U16_DIGEST.md`

Do NOT touch `GameState.gd` (R74), `ScheduleHubPanel.gd` (U15),
`EventResult.gd`, `Tournaments.gd`, `UIKit.gd`, `UITokens.gd` or `HANDOFF.md`.

## Gates

```bash
python Godot/tools/check_scripts.py Godot/scripts/ProfileRevampPanel.gd
```

```bash
"$GODOT" --headless --path Godot --script tests/profile_revamp_test.gd
```

`smoke_test.gd` too. The suite was **184/0** at `5b89cfd` — **184 or better;
if it is lower, say so and push anyway.**

## The trap

`ProfileRevampPanel.gd` is a scene script compiled before the autoloads. Use
`get_node_or_null("/root/GameState")` plus `has_method`, never the bare
`GameState` identifier — the bare identifier compiles in the editor and fails
at runtime in exactly this class of script. A `Label` you position yourself,
outside a Container, will not autowrap: break the line with `\n`.

## Start prompt

```bash
git fetch origin && git rebase origin/master && cat research/TASK_U16.md
```

> You own U16. The task file is self-contained: read it and nothing else. Do
> NOT read `HANDOFF.md`, `CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md` or any
> digest, and do not explore to "get oriented". `ProfileRevampPanel.gd` is
> 3,224 lines — never open it whole; read the FIGHT RECORD tab builder and the
> card-compose window only. `profile_revamp_test.gd` is 793 lines — extend it,
> do not rewrite it. You must not edit `GameState.gd`: R74 is inside it this
> week, and the only field you read is `grand_prix_titles`, which survives R74
> unchanged. Parse gate before any test, focused tests first, full suite once
> in the background before the commit. Commit, push, write the digest, send one
> line with `python Tools/agent_comms.py send`, and do NOT edit `HANDOFF.md` —
> Claude writes your block. The trap: this is a scene script compiled before
> the autoloads, so reach GameState with `get_node_or_null("/root/GameState")`
> plus `has_method`, never the bare identifier.
