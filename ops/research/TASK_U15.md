# TASK U15 — CURSOR — THE TOURNAMENT NOBODY CAN SEE

Model: Composer, effort **high**, Fast off. One session.

**Agent:** cursor · **Opened:** 2026-09-08

## Why this exists — verified, not assumed

`GameState.gd` exposes a complete Grand Prix surface:

| accessor | line |
| --- | --- |
| `get_grand_prix_events()` | `:8428` |
| `get_grand_prix_offer(event_id)` | `:8634` |
| `get_grand_prix_invites()` | `:8690` |
| `accept_grand_prix_invite(event_id, athlete_id)` | `:8729` |
| `get_grand_prix_stage_note(offer_id)` | `:9039` |

**Not one panel in the game calls any of them.** Grep `grand_prix` across
`Godot/scripts/`: outside `GameState.gd` there are **zero** hits. The only
callers in the repository are `tests/tournaments_test.gd`. Tournaments are
announced every ten weeks in nine disciplines, invites are generated, brackets
are seeded and resolved, a champion is crowned — and the player cannot see any
of it happen.

## What to build

The SCHEDULE hub shows the tournaments the world is running, and the player can
take a seat from there.

1. **Take each read ONCE per rebuild**, in the existing guarded block, exactly
   the shape U5, U7 and U14 landed: `game_state.has_method("get_grand_prix_
   events")` before the call, result into a member, never a read inside a row
   builder. Eight rows must not mean eight reads.
2. **An announced event prints what it is**: name, discipline, weight class,
   bracket size, and the week it runs. Words, not raw enum values — the house
   rule from U14: `brazilian_jiu_jitsu` reads BRAZILIAN JIU JITSU, never the
   underscored token.
3. **An invite the player holds is actionable.** `get_grand_prix_invites()`
   plus `get_grand_prix_stage_note(offer_id)` for the line that explains where
   the bracket stands. Seating goes through `accept_grand_prix_invite` and
   nothing else — do not write the seat yourself.
4. **Absent read renders exactly as today.** If the accessors are missing, the
   hub draws precisely what it draws now, nothing shifts position, and **that
   absent case is a required test.**

## What you must NOT do

* **Do not print a champion, a belt, a reign or a defence.** Six of the nine
  tournament disciplines have no standing title (C52, R70). A bracket winner
  gets a medal, not a belt, and this screen never uses belt language.
* Do not invent a purse, an entry fee, a prize or a ranking figure. If a number
  is not on the read, it does not go on the screen.
* Do not add a token to `UITokens.gd` (R47/R48 precedent) and do not edit
  `UIKit.gd`.

## Owned files

* `Godot/scripts/ScheduleHubPanel.gd` (2,172 lines — read the rebuild and its
  guarded read block, not the whole file)
* `Godot/tests/schedule_hub_panel_test.gd` (455 lines — extend; small enough
  to read whole)
* `research/U15_DIGEST.md`

Do NOT touch `GameState.gd` (R74 owns it this week), `Tournaments.gd`,
`EventResult.gd`, `ProfileRevampPanel.gd` (U16 owns it), `UIKit.gd`,
`UITokens.gd` or `HANDOFF.md`.

## Gates

```bash
python Godot/tools/check_scripts.py Godot/scripts/ScheduleHubPanel.gd
```

```bash
"$GODOT" --headless --path Godot --script tests/schedule_hub_panel_test.gd
```

`tournaments_test.gd` and `smoke_test.gd` too. The suite was **184/0** at
`5b89cfd` — **184 or better; if it is lower, say so and push anyway.**

## The trap

`get_grand_prix_offer` and `get_grand_prix_invites` are different shapes for
different questions: an OFFER is one event's terms, an INVITE is a seat you
have been given. Printing the offer list where the invite list belongs gives a
screen that looks right and lets the player try to sit in a bracket nobody
asked them to join. Read `sed -n '8634,8730p' GameState.gd` once and confirm
which is which before you draw either.

## Start prompt

```bash
git fetch origin && git rebase origin/master && cat research/TASK_U15.md
```

> You own U15. The task file is self-contained: read it and nothing else. Do
> NOT read `HANDOFF.md`, `CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md` or any
> digest, and do not explore to "get oriented". `GameState.gd` is 14,224 lines
> — never open it whole; you only need the `sed -n '8420,8440p'` and
> `sed -n '8634,8730p'` windows to confirm the read shapes, and you must not
> edit it. `ScheduleHubPanel.gd` is 2,172 lines — read its rebuild and guarded
> read block only. `schedule_hub_panel_test.gd` (455 lines) is small enough to
> read whole. Parse gate before any test, focused tests first, full suite once
> in the background before the commit. Commit, push, write the digest, send one
> line with `python Tools/agent_comms.py send`, and do NOT edit `HANDOFF.md` —
> Claude writes your block. The trap: an OFFER and an INVITE are different
> shapes; confirm which is which before drawing either.
