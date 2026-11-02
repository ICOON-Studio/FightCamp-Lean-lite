# TASK U10 — CURSOR — THE BODY GETS ITS OWN COLUMN

Model: **Cursor Grok 4.6**, effort **high**, Fast off. One session.
Runs after U9 and R63, both landed on master.

## Why this exists

The operator looked at the BODY LAB after U9 and said, correctly, that there
was still no body. R63 put one there — but **honestly labelled it as half a
job**: the region block is full, so the figure is a watermark *behind* the six
cells. In the render it collides with the TORSO / CORE bar and the CAGE 85
caption. It reads as a ghost under text, not as a body a player looks at.

You give it a column.

## Owned files — and only these

- `Godot/scripts/ProfileRevampPanel.gd` (3,163 lines — do NOT open it whole)
- `Godot/tests/profile_revamp_test.gd`
- `Godot/tests/body_region_screen_test.gd`

Anchors:

- `:44-47` — `const REGIONS`, six `[id, label, x, y]` rows. These positions are
  the cell layout.
- `:48-55` — R63's `FIGURE_ART` and `FIGURE_RECT`.
- `:2224` — `_build_body_lab`: the BODY frame is 740 wide, RECOVERY 742.
- `:2235` — `_draw_body_figure`, R63's plate.
- `:2309` — `_fill_regions`, the cell loop. Cell literals to know about:
  `cell.size` and `caption.size` are `220.0` wide, the gauge bar is `150.0`,
  the BINDING mark sits at x `158.0`, and the cage tick divides by `150.0`.

## Part 1 — the column

Restructure the region block inside the existing 740-wide BODY frame:

- A figure column on the left, roughly 150–190 px wide and the full height of
  the cell block (~244 px), with the figure drawn **unobstructed** at a real
  alpha — it is the subject now, not a watermark.
- The six cells to the right of it, keeping their **anatomical arrangement**:
  head above, arms flanking the torso, legs below. That arrangement is U3 Q1's
  identity and survives; the cells get narrower, not reordered.
- Narrow the cells and their bars to fit. Every `220.0` / `150.0` / `158.0`
  literal above moves together — introduce a constant for the cell width and
  the bar width rather than editing six numbers by hand.

**`RECOVERY & WEIGHT` is off limits.** It is hard-positioned to about 722 px of
its 742 (`conditioning` at x 392 with a 280 bar, the cut message at x 372 by
350 wide) and narrowing it clips. Take no width from it.

## Part 2 — the clipping in the hero

Same file, and visible in every profile render: the hero row truncates. `REACH`
is cut off mid-label, and the board strip prints
`FEATURED BOUT VS TOMAS BAPTISTE (0-4-` with the bracket unclosed. Fix both —
either the field fits or it is shortened deliberately, but a sentence must not
stop mid-word. **A `Label` outside a Container does not autowrap reliably;
break lines with `\n` or clip on a boundary you chose.**

## Refusals

- **No new read, no new engine call.** `get_body_read` already carries
  everything: `phase`, `phase_board`, `record`, per-region `injury`, `ceiling`.
- **No word invented.** `InjuryWords` (Q3), `RecoveryWords` (Q4) and
  `StatWords` (Q6) own every string. U9's date lines and grade rules stand
  exactly as they are: DIRECT stated flat, AUTHORED as THE GYM ESTIMATES,
  UNKNOWN as NO DATE SET, and the grade words never reach a Label.
- **Do not rename nodes beginning with `Region`.** `body_region_screen_test`
  counts them by prefix and expects exactly six.
- **`GameState.gd` is not yours.** Neither is `ProfileRevampPanel`'s duplicate
  `STAT_KEYS` / `STAT_LABELS` at `:33-34` — that is a named follow-on from C44.

## Gotchas that will cost you a cycle

- A `TextureRect` keeps the TEXTURE's size as its minimum until `expand_mode`
  is set: set `expand_mode` and `stretch_mode` **before** `texture` and `size`,
  or the size you assign is clamped straight back up (R31).
- `modulate` MULTIPLIES. R63's first attempt tinted the plate by the full band
  colour and rendered nothing at all on a dark ground.
- A Control with full-rect anchors must never have `size` assigned when it is
  mounted — with anchors at 0..1 that writes the OFFSETS (R31).

## Gate, then tests

```
python Godot/tools/check_scripts.py Godot/scripts/ProfileRevampPanel.gd
```

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/profile_revamp_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/body_region_screen_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/schedule_hub_panel_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/smoke_test.gd
```

Then the full suite ONCE in the background before the commit. **Ceiling, not a
target: 175/175 or better; if it is better, say so and push.**

## Look at it

You shipped `Godot/tools/CaptureU9InjuryScreen.gd` and it is the reason this
task exists — R63 was checked by eye with it. Use it again, and **put the PNG
in your report**. Its `output_dir` at the top is a Linux path; change it for
your environment and do not commit that change.

## Done means

Both files committed and pushed (branch or master, your call — rebase on
origin/master first), a short `research/U10_DIGEST.md`, one line back
with `agent_comms.py send`, and **no `HANDOFF.md` hunk** — Claude writes your
block.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
Godot/scripts/ProfileRevampPanel.gd
Godot/tests/profile_revamp_test.gd
Godot/tests/body_region_screen_test.gd
Godot/tests/schedule_hub_panel_test.gd
Godot/tests/smoke_test.gd
research/U10_DIGEST.md
```
