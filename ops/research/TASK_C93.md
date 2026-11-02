# TASK C93 — CODEX — APPLY THE ELEVATION LADDER THAT IS ALREADY DECIDED

Model: gpt-5.6-luna, **medium effort — never high**. Owner: codex.
Test tier: **ONE SCRIPT EDITED, and the edit is a TABLE OF NUMBERS THAT IS
ALREADY WRITTEN.** Parse gate, re-render, two named subsets. Nothing else.
**Do NOT run the full suite** — it is Claude's at integration. **ONLY ONE GODOT
AT A TIME in this checkout.**

```
python Godot/tools/check_scripts.py Godot/scripts/UITokens.gd
python Godot/tools/run_tests.py --only ui_kit
python Godot/tools/run_tests.py --only ui_material
```

## Owned files

- `Godot/scripts/UITokens.gd` — yours for this task, and **only the `_ELEVATION`
  table inside it.**

Nothing else. Do NOT edit `UIKit.gd`, `ProfileRevampPanel.gd` (another agent
holds it this session), `HANDOFF.md`, or any test.
`GameState.gd` is 12,938 lines. You do not need it. **Never open it.**

## Why this exists

Q51 found that **a black shadow on our `#1c2230` ground has nothing to contrast
against**, so past a few pixels it reads as a murky smudge rather than as depth.
**The rim light does the elevation work; the shadow only separates a card from
what is behind it.** The first cut spent 22 px at 45% opacity under the hero card,
which is exactly the smudge Q51 describes.

The corrected table was worked out and **verified against Q51 but never applied
and never rendered.** This task is the applying. **There is no judgement in it —
the numbers below are the answer.**

## THE TABLE. Apply exactly this to `_ELEVATION` in `UITokens.gd`

| level | lift | shadow | alpha | y | rim |
|---|---|---|---|---|---|
| `RESTING` | unchanged | **2** | **0.22** | **1** | unchanged |
| `LIFTED` | unchanged | **4** | **0.30** | **2** | unchanged |
| `HERO` | **0.130** | **7** | **0.36** | **3** | **0.20** |

**Everything else in the file is unchanged.** Do not retune a level that is not
in this table, do not adjust a colour, and do not "improve" the numbers — they
were checked against Q51 already and a fourth opinion is not wanted here.

## Then render it

Re-render the fighter profile so the change is on the record:

```
Godot_v4.7.2-stable_win64_console.exe --path Godot --script tools/render_profile_revamp.gd -- "../previews/c93/after"
```

That is **WINDOWED, not headless** — do not add `--headless`, the tool needs a
real viewport to capture. **Render into `docs/previews/c93/after` and NOWHERE
ELSE.** In particular:

- **Never render into `DesignLibrary/screens/profile_revamp/`** — that is the
  approved reference this work is judged against, and overwriting it destroys the
  only thing that shows what "clean" looked like.
- **Do not render into `docs/previews/u54/`** — another agent owns that directory
  this session.

## Definition of done

- `UITokens.gd` carries the table above and nothing else changed.
- `--only ui_kit` and `--only ui_material` both pass. **`failures=0` is a
  CEILING, not an exact count** — if you find something else already failing and
  fix it, say so and push the better result.
- `git add -- Godot/scripts/UITokens.gd` (and the `c93/after` renders if you want
  them on the record), commit, push to master.
- One line back:
  `python Tools/agent_comms.py send --from codex --to claude --subject C93-done --body "<sha> levels=3 ui_kit=pass ui_material=pass rendered=yes|no"`
- Do NOT edit `HANDOFF.md` — Claude writes your block.

## The traps specific to C93

1. **U53's blind test asserts ORDERING ONLY, and that was deliberate** — it
   checks that HERO sits above LIFTED sits above RESTING, not that any level
   holds a particular number. So it **survives this retune and must still pass**.
   If it fails, you have broken the ordering, not the test: RESTING 2 < LIFTED 4
   < HERO 7, and the alphas rise the same way. **Do not edit that test.**
2. **A STALE ASSERTION IS NOT A LICENCE TO EDIT A TEST.** If some other test pins
   a literal elevation number, prove which of the two is wrong before touching
   either, and say which in the commit message.
3. **The renderer is Forward+ now** (project-wide, operator's call 2026-09-11).
   Capture tools that pass `--rendering-method gl_compatibility` explicitly still
   override it — if your render comes out flat and grey, that is why, and it is
   not the elevation table.
4. **`var x := <call>` fails when the call returns Variant.** Write the type:
   `var n: int = ...`. A parse error does not fail a headless run, it **HANGS**
   it until the timeout — so parse-gate before you render.
