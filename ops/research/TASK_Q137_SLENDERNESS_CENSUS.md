# TASK_Q137 — QWEN — WHICH CAPSULES ARE ACTUALLY BALLS, ACROSS ALL TWELVE RIGS

**Owner:** qwen
**Model:** `qwen3-coder`, MEDIUM. `--yolo` (never `auto` — `auto` leaves you
with no shell tool at all).
**Worktree:** `C:\Users\user\AppData\Local\Temp\FightCamp-Q114`. **Cut a FRESH
branch off `origin/master` first** — the worktree sits on an old branch.
**Test tier:** parse gate on every touched `.gd`, then your own tool. **Do NOT
run the full suite** — it is Claude's, once, at integration, and it costs
forty minutes.

## THE QUESTION, IN ONE SENTENCE

**For every capsule on every one of our twelve rigs, what is `r/L`, and how many
of them are balls wearing a capsule's name?**

## WHY IT IS BEING ASKED NOW — READ THIS, IT IS THE WHOLE BRIEF

Read `research/S52_THE_PRESENT_RATIO.md` first. It is short.

A fighter is modelled as capsules: a segment between two bone positions, a
radius, and a hemispherical cap at each end. Dola's fix for an unreachable neck
was to **inset each endpoint by that capsule's own radius**. Three arms of that
rule were measured yesterday on two rigs and **all three were refused**, because
the new `Present Ratio` control showed they were not clearing the neck, they
were deleting it.

**The one nobody forecast is the head.** Our `head` capsule runs from the Head
bone to the skull's vertex centroid — 0.0774 m on f02 — and its radius is a
skull half-width, which is **larger than that**. The inset ran one endpoint
through the other and the capsule collapsed to a point: **0.0% present**.

John's J41 memo reaches the same boundary from the anthropometry, independently:
remaining length after a double inset is `L − 2r`, so **`r/L ≥ 0.5` is a
needle**, and a segment past that is the wrong abstraction whatever rule you
apply to it.

**So: two rigs told us the head is a ball. Twelve rigs will tell us how many
others are, and on whom.** That is the scope of the next fix and nobody has it.

## WHAT TO BUILD

`Godot/tools/q137_slenderness_census.gd`, a headless SceneTree script.

For every rig in the fighter model set, and every capsule
`FighterCapsules.build_report` returns:

1. `length_m` — `p0.distance_to(p1)` as built.
2. `radius_m` — the capsule's `r` as built.
3. `authored_m` — from the report's **`extents`** block, key `authored_m`.
   **Take it from there; do NOT recompute it.** It is the bone-to-bone distance
   captured before anything moves an endpoint, and a census that derives its own
   denominator from the thing it is measuring cannot fail.
4. `r_over_L` = `radius_m / length_m`, and `INF` when `length_m <= 0.0`.
5. The band, by this table — **inclusive at the number named**:

   | r/L | band |
   |---|---|
   | `< 0.25` | `SEGMENT` |
   | `>= 0.25` and `< 0.50` | `STOUT` |
   | `>= 0.50` and `< 1.00` | `NEEDLE` |
   | `>= 1.00` (and `INF`) | `BALL` |

6. `surviving_1` = `max(0.0, length_m - radius_m)` — what a ONE-end inset
   leaves, and `surviving_2` = `max(0.0, length_m - 2 * radius_m)` for two.
7. The present ratio of each, via
   `CapsulePresence.present_ratio(surviving_N, authored_m)`. **Use that module,
   do not reimplement the arithmetic** — `Godot/scripts/CapsulePresence.gd`,
   static, pure, no autoload.

## THE OUTPUT

Three blocks, in this order:

**(1) The per-rig table.** One row per capsule per rig:
`rig | capsule | L | r | r/L | band | 1-end present% | 2-end present%`.

**(2) The roll-up, which is the answer.** Per capsule NAME across all twelve
rigs: how many rigs put it in each band, plus min/median/max `r/L`.
**This is the table the next fix is chosen from**, so make it the readable one.

**(3) The disagreements.** Every capsule whose band is **not the same on all
twelve rigs** — a capsule that is a `STOUT` on a welterweight and a `NEEDLE` on
a heavyweight is a scaling problem, and that is a different fix from one that is
a ball on everybody. **Name them explicitly. If there are none, say so — a
negative result is a result.**

End with `SUITE total=1 fails=N`.

## THE POPULATION — NAME IT IN YOUR OWN OUTPUT

`Godot/assets/models/fighters/` holds the rigs; Q132's capsule census already
walked twelve of them, so **read which twelve from `Godot/tools/q132_capsule_census.gd`
rather than listing your own** — one table, never a copy. Print each rig's file
name and its target height in the header.

**Every rig must be mounted at ITS OWN stature, never a shared one.** A Tripo
export is at arbitrary scale and only `FighterPhysique.height_scale()` makes it
metres; a census run at one height measures the scale factor, not the anatomy.
`Godot/tools/s52_present_ratio.gd` has the loading pattern — `_load_rig` — and
it is worth copying the shape of.

## Owned files

- `Godot/tools/q137_slenderness_census.gd`
- `research/Q137_SLENDERNESS_CENSUS.md` (the tables above, as markdown)
- `research/Q137_DIGEST.md`

You own nothing else. **Do not edit `FighterCapsules.gd`, `CapsulePresence.gd`
or any test** — this is a measurement, and if it wants a module changed that is
a finding to report, not a change to make.

## Gate

```
python Godot/tools/check_scripts.py Godot/tools/q137_slenderness_census.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/q137_slenderness_census.gd
```

The exe is in `%LOCALAPPDATA%\Programs\Godot\`. **No suite run.**

## What already exists, so you do not rebuild it

`RESEARCH_INDEX.md` — 789 research documents, 220 tools, 116 drivers, one line
each. **GREP IT, NEVER READ IT WHOLE** (214 KB). Worth running:
`grep -i 'capsule' RESEARCH_INDEX.md`, `grep -i 'census' RESEARCH_INDEX.md`.
**A negative result is a result** — say so in the digest.

## Rules

- Never `git stash`, `git reset --hard`, `git checkout .`, `git clean` or
  `git add -A`. Stage explicit paths only.
- Commit, push your branch, write the digest, send one line with
  `python Tools/agent_comms.py send`. **Do NOT edit `HANDOFF.md`.**

## THE TRAPS SPECIFIC TO THIS TASK

1. **`var x := <call>` fails when the call returns Variant.** `.size()` or
   `.get()` on an untyped value, or a static on a `load()`ed script, all return
   Variant. Write the type: `var n: int = ...`. A parse error does not fail a
   headless run, it **HANGS** it until the timeout.
2. **`%` inside a format string must be `%%`.** You will be printing
   percentages on every row.
3. **Reusing a variable name inside one function is a parse error in GDScript,
   even across separate `if`/`for` blocks.** This tool has nested loops over
   rigs and capsules; name the inner ones differently.
4. **`INF` has to survive the band comparison.** `INF >= 1.00` is `true` and
   that is the `BALL` band — but if you write the bands as a subtraction or a
   `clamp`, `INF` stops behaving. Compare directly, and **assert the
   zero-length case explicitly in your own output** so a reader can see it was
   handled rather than skipped.
5. **Your API content filter killed a run on 2026-09-22 and the retry passed.
   Retry once before rewording anything.**
