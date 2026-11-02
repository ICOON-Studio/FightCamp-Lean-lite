# TASK R74 — CLAUDE — THE TOURNAMENT THAT RECORDS EVERYONE

Model: Opus, effort **high**, Fast off. One session, its own `/clear`.

**Agent:** claude · **Opened:** 2026-09-08 · Greenlit by the operator
2026-09-08 ("go with the tournament").

## Why this exists — verified, not assumed

The game already runs tournaments. `Tournaments.gd` (128 lines) is a pure
bracket module — seeding, pairings, round names, condition, purse — and
`GameState.gd` drives a full Grand Prix around it: announce
(`_announce_grand_prix:8471`), invite (`get_grand_prix_invites:8690`), seat
(`accept_grand_prix_invite:8729`), fight the player's bout
(`_after_grand_prix_bout:8914`), run the rest of the bracket in the world
(`_resolve_grand_prix_rest:8875`), crown (`_gp_champion_crowned:8855`).

`assets/data/tournaments.json` runs it in **nine** disciplines: kickboxing,
karate, judo, wrestling, brazilian_jiu_jitsu, taekwondo, muay_thai, sambo,
mma. Six of those are C52's **event disciplines with no standing belt**.

**The gap: only the winner is recorded, and only as a title line.**
`_gp_champion_crowned:8868` appends to `grand_prix_titles` — event name, week,
weight class, discipline — on the champion and on nobody else. Enter a judo
Grand Prix, lose the final, and the game stores **nothing at all**: no silver,
no placing, no contest count, no record that you were ever there.

Meanwhile `EventResult.gd` (G23, landed today, 264 lines) is exactly that
record — placing, medal, contests, wins, ranking points, selection effect,
division axes — and has **ZERO production callers**. Grep it: only
`tests/event_result_test.gd`.

This is C52 build order **step 2**, and it is the smallest honest change: the
bracket machinery already exists and is not being rewritten.

**Correct a likely assumption before you start.** `_gp_champion_crowned` does
NOT write `championships`, `holder_id`, a reign or a defence. It writes its own
`grand_prix_titles` array. R70 is not being violated today — the problem is
that the record is winner-only and is a third ad-hoc shape beside
`championships` and `retired_championships`, not that it is a belt.

## What to build

Every athlete seated in a Grand Prix in an **event discipline** comes out of it
with one `EventResult` record.

1. **Produce a result per seat, not per champion.** When a Grand Prix
   completes, write one `EventResult.make(...)` per athlete who was seated —
   the player's fighter and the world entrants alike — with the placing the
   bracket actually produced.
2. **Placing comes from the bracket, never from a guess.** Winner `gold`,
   beaten finalist `silver`, beaten semi-finalists `bronze`, beaten
   quarter-finalists `fifth`. A size-4 bracket has no `fifth`. Someone who
   never fought is `participated`. Anything you cannot derive is `unknown` —
   `EventResult` already ranks it 999.
3. **Store them and read them back.** An `event_results` array on the athlete
   plus one public getter in the house style. Deterministic order:
   `EventResult.sort_results`.
4. **`grand_prix_titles` stays exactly as it is.** Saves carry it, three
   `tournaments_test.gd` assertions read it (`:187`, `:232`, `:245`), and
   **U16 is printing it on the profile in parallel with this task.** Do not
   rename it, do not migrate it, do not delete it. The new array sits beside
   it.

## What you must NOT do (C52's explicit non-decisions)

* **No belt, no holder, no reign, no defence, no "defending champion".** A
  medal is not a title. `EventResult` has no function that returns a holder;
  do not add one anywhere else either.
* **No invented number.** `ranking_points` stays `0` and `selection_effect`
  stays `"none"` unless a sourced rule says otherwise — and none does yet.
  UNKNOWN is not zero, so do not dress a zero up as a finding. Say in the
  digest that both are unsourced placeholders.
* **Do not simulate each internal contest as a normal bout.** C52's migration
  table rejects this outright: the week hold, the card model and
  `medical_hold_until_week` cannot represent a same-day ladder honestly. The
  bracket already resolves as one event — keep it that way.
* **Do not touch the belt disciplines' championship path.** MMA and the other
  belt disciplines keep behaving exactly as they do today.

## Owned files

* `Godot/scripts/GameState.gd` (**14,224 lines — never open it whole.** Read
  `sed -n '8420,8480p'`, `sed -n '8850,8915p'` and `sed -n '10530,10650p'`
  windows; the honours read is at `:10537`/`:10635`.)
* `Godot/tests/tournaments_test.gd` (274 lines — small enough to read whole)
* `research/R74_DIGEST.md`

Do NOT touch `EventResult.gd` (G23's contract is settled and its test pins
it), `Tournaments.gd`, `ScheduleHubPanel.gd` (U15 owns it this week),
`ProfileRevampPanel.gd` (U16 owns it), or `HANDOFF.md` beyond your own block.

## Gates

```bash
python Godot/tools/check_scripts.py Godot/scripts/GameState.gd Godot/tests/tournaments_test.gd
```

Focused first, then the full suite once in the background before the commit:

```bash
"$GODOT" --headless --path Godot --script tests/tournaments_test.gd
```

`event_result_test.gd` and `smoke_test.gd` too. The suite was **184/0** at
`5b89cfd` — **184 or better; if it is lower, say so and push anyway** rather
than holding a good result back.

## The trap

`_resolve_grand_prix_rest:8875` breaks out of its loop in three different
places — final reached, winners exhausted, and an empty champion id — and
`_resolve_grand_prix:8898` is a separate entry point for a bracket the player
never seated. A result written in only one of those paths means a tournament
the player skipped records nothing, which is the exact bug this task exists to
fix. Write the results where the event is marked `completed`, once, not at the
crowning.
