# TASK U13 — THE CAREER THAT IS INVISIBLE (cursor)

Model: Composer, effort **high**, Fast off. One session. **Both dependencies
have LANDED** — see "What is already on master" before you start.

**Refreshed 2026-09-08 after R71, G22, C51 and R72 shipped.** The anchors below
are current; do not trust an older copy of this file.

## Why this exists

R70 shipped on 2026-09-08 and **retired** the world titles this game should
never have created — judo, wrestling, taekwondo, Brazilian jiu-jitsu, sanda and
sambo, where a world championship is an EVENT won on a date rather than a belt
somebody carries and defends. A retired title is **not** a deleted title: those
rows were moved whole out of the live standings into a separate record, keeping
holder, reign and defences, so a save where a fighter held the judo world title
for forty weeks still says so.

**Nothing reads that record.** `GameState.get_retired_championships()` exists
and has exactly one reference in the whole codebase: its own definition. And the
profile's honours are one gold chip built from `get_athlete_titles()` —
`DevelopmentPanel.gd:405-407` prints `"CHAMPION"` or `"CHAMPION ×N"` and
nothing else. So a fighter's career shows what they hold **today** and nothing
about what they won, and a fighter whose only title was retired shows nothing at
all.

Your job is the surface: the profile says what this fighter has won.

## What is already on master

This was written to run in parallel with two other tasks. **Both have shipped**,
so the read you draw is live and you can call it on the first try:

- **`Godot/scripts/TitleHonours.gd`** (G22, 144 lines) — the pure module. Read
  it if you like; it is small. Its `summary(rows)` is the chip.
- **`GameState.get_athlete_honours(athlete_id)`** (R71) — returns the finished,
  sorted rows described below. Tested by `Godot/tests/athlete_honours_test.gd`.

**You still guard the call, and you still test the absent case.** Not because
the read might be missing today, but because this panel is a scene script and
scene scripts compile before the autoloads — it must never name `GameState` as
a bare identifier. The panel already has the idiom: `_call()` at
`DevelopmentPanel.gd:67` does `game_state.has_method(method)` and returns a
fallback, and `_titles()` at `:93` is one line on top of it. Your `_honours()`
is the same one line, and the fallback is `[]`.

**Do not write either dependency, and do not copy the composition.** For the
chip, `preload("res://scripts/TitleHonours.gd")` next to the panel's existing
preloads and call `summary()` — do not count standings yourself and do not ask
Claude for a new GameState door.

## The contract you draw against

`get_athlete_honours(athlete_id: String) -> Array` returns rows already sorted
(held first, then interim, then retired; most recent reign first inside each).
Every row carries exactly:

| key | type | value |
|---|---|---|
| `key` | String | `"<discipline>\|<weight_class>\|<sex>"` |
| `discipline` | String | e.g. `"judo"`, `"muay_thai"` |
| `weight_class` | String | e.g. `"Lightweight"` |
| `sex` | String | `"male"` or `"female"` |
| `standing` | String | `"held"`, `"interim"` or `"retired"` |
| `label` | String | e.g. `"Men's Lightweight — Judo"`; `""` when the key is malformed |
| `since_week` | int | the week the reign began; 0 when unknown |
| `defenses` | int | successful defences |
| `weeks_held` | int | length of the reign — **always 0 on a `"retired"` row** |
| `weeks_held_source` | String | `"counted"`, or `"absent"` on every `"retired"` row |
| `organization_id` | String | sanctioning promotion, `""` when none |
| `retired_reason` | String | `"event_discipline"` on a retired row, `""` otherwise |

A companion summary is the module's own static — preload
`res://scripts/TitleHonours.gd` and call `TitleHonours.summary(rows)` →
`{"held": int, "interim": int, "retired": int, "chip": String}` where `chip` is
`""`, `"CHAMPION"`, `"CHAMPION ×N"`, `"INTERIM CHAMPION"`, `"RETIRED TITLE"` or
`"RETIRED TITLE ×N"`. Prefer the read's rows and this summary over counting
things yourself.

## What to build

1. **The chip keeps working.** `DevelopmentPanel.gd:405-410`, inside
   `_build_standing()` (`:388`), currently builds a gold `CHAMPION` /
   `CHAMPION ×N` chip from `_titles()`. Drive it from `summary().chip` instead,
   so a fighter whose only title was retired finally gets one (`RETIRED TITLE`).
   When the read is absent, leave the existing behaviour exactly as it is.
2. **An honours section on the profile**, drawn only when there is at least one
   row. One line per honour, and each line must make its standing unmissable at
   a glance — a held title, an interim, and a retired title must not read the
   same.
3. **A retired line says why, and says nothing it does not know.**
   `weeks_held_source == "absent"` is the game admitting it does not know when
   that reign ended, because R70 deliberately stamped no retirement week — a
   catalogue correction is not something that happened in the world on a date.
   So a retired line prints its `since_week` if it has one and **prints no
   duration and no end date**. An em dash or "—" is the right shape for a figure
   the game does not have; a zero is not, and neither is "0 weeks".
4. **The empty state.** A fighter who has won nothing draws no section — not an
   empty box, not a heading with nothing under it.

## Owned files

```
Godot/scripts/DevelopmentPanel.gd
Godot/tests/development_panel_test.gd
```

`Godot/tests/development_panel_test.gd` **does not exist — you create it**, in
the shape the other panel tests take (`profile_revamp_test.gd` is the nearest
model). **Not owned and not to be edited:**
`Godot/scripts/GameState.gd` (14,219 lines — never open it whole; R71's read is
already in it), `Godot/scripts/TitleHonours.gd` (G22's, already on master),
`Godot/scripts/ChampionshipRead.gd`,
`Godot/scripts/WorldPopulation.gd`, `Godot/scripts/UIKit.gd`, `HANDOFF.md`.
`DevelopmentPanel.gd` is 441 lines — small enough to read whole.

## The trap

**"Retired" does not mean "lost".** These titles were taken off the board by a
rules correction, not by anybody's defeat, and the fighter never stopped being
the last person to hold one. Nothing you draw may say BEATEN, LOST, STRIPPED,
VACATED or FORMER-as-in-dethroned, and a retired row must never sit in a list
headed as though it were something the fighter still holds. The honest reading
is closer to "this title no longer exists" than to "this fighter no longer holds
it", and the line should leave a player with the first impression, not the
second.

Second trap, smaller: in this game a **belt** is a championship somebody
carries. A Brazilian jiu-jitsu blue belt is a rank awarded by an instructor and
never won off an opponent — a different noun that shares the word. Nothing on
this screen is about belt colours; if a string could be read either way, rewrite
it.

## Parse gate

```
python Godot/tools/check_scripts.py Godot/scripts/DevelopmentPanel.gd Godot/tests/development_panel_test.gd
```

## Tests

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/development_panel_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/profile_revamp_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/smoke_test.gd
```

Then the full suite once in the background before the commit. **Fails=0 or
better; if the suite comes in lower than you expected, say so and push anyway.**

## Done means

Branch pushed, digest at `research/U13_DIGEST.md`, one line sent with
`python Tools/agent_comms.py send --from cursor --to claude --topic "U13 done"`,
and **no edit to `HANDOFF.md`** — Claude writes your block.

---

## START PROMPT (operator pastes this to Cursor)

```bash
git fetch origin && git rebase origin/master && cat research/TASK_U13.md
```

> You own U13. The task file is self-contained — read it and nothing else. Do
> NOT read `HANDOFF.md`, `CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md` or any
> digest, and do not explore to "get oriented". You own
> `Godot/scripts/DevelopmentPanel.gd` (441 lines — read it whole) and
> `Godot/tests/development_panel_test.gd`, which does not exist yet and is
> yours to create. You may also read `Godot/scripts/TitleHonours.gd` (144
> lines) — it is small and it is the chip. Do NOT edit `GameState.gd` (14,219
> lines — never open it whole; the read you need is already in it),
> `TitleHonours.gd`, `ChampionshipRead.gd`, `WorldPopulation.gd`, `UIKit.gd` or
> `HANDOFF.md`. Parse gate before any test, focused tests first, full suite once
> in the background before the commit. Commit, push, write the digest, send one
> line with `agent_comms.py send`.
>
> **Both dependencies have landed** — `GameState.get_athlete_honours()` and
> `TitleHonours.gd` are on master, so draw the real rows, not a fallback. You
> still route the call through the panel's existing `_call()` helper at
> `DevelopmentPanel.gd:67`, which already does `has_method` and returns a
> fallback: this is a scene script and scene scripts compile before the
> autoloads, so it must never name `GameState` as a bare identifier.
> `_honours()` is one line beside `_titles()` at `:93`. Cover the absent-read
> case in your test anyway. No stub read and no local copy of the composition —
> `preload` the module for `summary()`.
>
> **The trap: "retired" does not mean "lost".** R70 took those titles off the
> board with a rules correction, not a defeat — the fighter never stopped being
> the last person to hold one. Nothing you draw may say BEATEN, LOST, STRIPPED
> or VACATED, and a retired row must never sit under a heading that implies the
> fighter still holds it. A retired line prints no duration and no end date:
> `weeks_held` is 0 and `weeks_held_source` is `"absent"` because the game does
> not know when that reign ended — an em dash, never a zero and never
> "0 weeks".
