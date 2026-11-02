# TASK C44 — CODEX — THE SEVEN ATTRIBUTES SPEAK WITH ONE VOICE

Model: mid tier, effort **medium**, Fast off. One session.
Runs after C43 and C43F, which are both landed. Engine and one panel.

## Why this exists

C43 added `grapple` as the seventh attribute, and it had to be spelled out by
hand in every place that prints an attribute, because there was no one place.
Q6 then shipped `Godot/scripts/StatWords.gd` — label, gloss and band word for
the seven ids, with `Godot/tests/stat_words_test.gd` green.

**Nothing calls it.** Grepped 2026-09-08: `StatWords` appears in
`Godot/scripts` exactly zero times outside its own file. Meanwhile the labels
live in at least three separate places, and a seventh attribute means three
separate edits, forever.

You make `StatWords` the one place, and you delete the duplicates you own.

## The bug you fix on the way

`AthleteStatModel.gd:322`, `fight_legend_tooltip()`:

```
return "%s\n\n%s\n\n%s\n\n%s\n\n%s\n\n%s" % [
    stat_tooltip("power"), stat_tooltip("technique"), stat_tooltip("speed"),
    stat_tooltip("defense"), stat_tooltip("conditioning"), stat_tooltip("fight_iq"), stat_tooltip("grapple"),
]
```

Six placeholders, seven arguments. C43 added the seventh argument and not the
seventh `%s`. It has never thrown because the function has **no caller** —
grepped, zero, including the tests. Add the seventh `%s`. **Do not invent a
caller for it and do not delete it**; record in your digest that it is
uncalled, the way C41 recorded its buckets.

## Owned files — and only these

- `Godot/scripts/AthleteStatModel.gd` (363 lines, read whole)
- `Godot/scripts/DevelopmentPanel.gd` (440 lines, read whole)
- `Godot/tests/stat_help_test.gd` (114 lines)
- `Godot/tests/development_screen_test.gd` (93 lines)

`Godot/scripts/StatWords.gd` is **read-only**: it is a landed, tested contract.
If you believe it is wrong, say so in the digest and change nothing.

## NOT yours — this is a hard boundary

- **`Godot/scripts/ProfileRevampPanel.gd` is Cursor's, open right now under
  U9.** It holds its own duplicate `STAT_KEYS`/`STAT_LABELS` at `:33-34` and
  spends them at `:795-799` and `:888`. **Do not open it, do not edit it.**
  That duplicate is a named follow-on task, not yours.
- `GameState.gd:141`, `Aging.gd:67`, `AthleteDevelopment.gd:34`,
  `FightOpponentGenerator.gd:15` each hold a `STAT_KEYS` array. Those are
  **iteration order for engine maths, not display**, and they stay exactly as
  they are. `StatWords` is about the words.
- `FightSimulation.gd:60` holds a SIX-key `STAT_KEYS`. It is deliberate and
  documented at `:129`. Do not "fix" it.

## What you change

1. **`AthleteStatModel.gd` delegates the display words.**
   `stat_label(stat_id)` at `:147` returns `StatWords.label(stat_id)` — add the
   preload beside the file's other constants. The seven `"label"` entries in
   the `STATS` table at `:20-73` are then duplicated data: leave the table's
   `category`, `summary`, `fight` and `training` prose exactly as it is (it is
   the mechanics documentation and `StatWords` deliberately does not carry it),
   and make the label come from one place. Where the table's label and
   `StatWords.label` disagree for any id, **stop and report it** — they must
   not both be right.
   `stat_ids()` at `:143` keeps returning the table's order; do not re-source it
   from `StatWords.STAT_IDS` unless the two orders are identical, and say in the
   digest which you found.

2. **`fight_legend_text()` at `:318` is composed, not typed.** Today it is one
   hand-written string listing all seven. Build it from `StatWords.label()` and
   `StatWords.gloss()` over `stat_ids()`, joined with the same `"  •  "`
   separator, so an eighth attribute never needs this line edited again. The
   glosses change wording as a result — that is intended and correct; Q6's
   glosses are the settled ones.

3. **`DevelopmentPanel.gd` stops spelling its own labels.** `:330-332` prints
   `str(key).replace("_", " ").to_upper()`. That accidentally produces the
   right words today and will not survive an id whose label is not its
   underscored name. Use `StatWords.label(key)`. The panel's own `STAT_KEYS` at
   `:26` stays — it is iteration order — but the label string comes from the
   module.

4. **Nothing else.** No new stat, no layout change, no band colours, no
   tooltip rewrite, no touching `T.grade_index`. `StatWords.band_word()` has no
   caller after this task either, and that is fine: the band belongs to a
   screen, and the screen is Cursor's.

## Gate, then tests

```
python Godot/tools/check_scripts.py Godot/scripts/AthleteStatModel.gd Godot/scripts/DevelopmentPanel.gd
```

Focused, in this order:

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/stat_help_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/stat_words_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/development_screen_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/athlete_development_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/smoke_test.gd
```

Add one assertion to `stat_help_test.gd`: `stat_label()` agrees with
`StatWords.label()` for all seven ids, and `fight_legend_text()` names all
seven. Add one to `development_screen_test.gd`: the stat rows print `FIGHT IQ`,
not `FIGHT_IQ`.

Then the full suite ONCE in the background before the commit. **Ceiling, not a
target: 0 failures is the goal; if the suite is better than you were told to
expect, say so and push. Never hold back a better result.**

## The one trap

`AthleteStatModel.gd` is loaded by scene scripts that compile **before the
autoloads**. It must stay a plain `RefCounted` with statics and a `preload` of
another plain script — no `get_node`, no bare `GameState` identifier, no
autoload access, in this file or in `StatWords`. A parse error here does not
fail a headless test, it **hangs** it until the timeout.

## Done means

Both scripts and both tests committed and pushed, a short
`research/C44_DIGEST.md` naming the uncalled `fight_legend_tooltip`, and
one line back with `python Tools/agent_comms.py send`. **Do not edit
`HANDOFF.md`** — Claude writes your block.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
Godot/scripts/AthleteStatModel.gd
Godot/scripts/DevelopmentPanel.gd
Godot/tests/stat_help_test.gd
Godot/tests/stat_words_test.gd
Godot/tests/development_screen_test.gd
Godot/tests/athlete_development_test.gd
Godot/tests/smoke_test.gd
Godot/scripts/StatWords.gd
research/C44_DIGEST.md
```
