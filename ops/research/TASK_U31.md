# TASK U31 — CURSOR — THE SEAT CHIP: G38's GROUND-FIGHT READ ON FightHudPanel

Model: **Cursor, `-p --force --trust`.** Owner: Cursor. Base: `master` after
U29 (`41c0975`). Assigned 2026-09-10.

---

## Why this exists

R91 made the fight produce ground fighting; nothing shows it. G38 (Grok, 115
sources, `research/G38_THE_GROUND_FIGHT_READ.md`) is the design and it
says the read is **QUIETER, not busier**: one seat chip, attempt pips only while
an attempt is open, a stall colour, and nothing else. This task is that chip.
G38's exact words: "If the seat chip is missing and BroadcastRead is blank, it
will read as hung. That is the whole bug R91 will ship into unless the chip
lands first."

## Read G38 §5, the one-screen spec and the seat-label block. That is the design; do not redesign it.

## The contract - the data you render, so you need not read its producer

`FightHudPanel` renders a `FightHudRead.fold` as plain data (U25). Qwen (Q23)
is adding a `grapple` block to that fold, in flight now. Its shape is FIXED
and is exactly what `FightRealtime.grapple_of()` already returns:

```gdscript
read["grapple"] = {
	"grappling": bool,             # false = this ruleset never grapples
	"stance": "standing"|"clinch"|"ground",
	"seat": "none"|"over_under"|"guard"|"half"|"side"|"mount"|"back",
	"top": "a"|"b"|"",             # the man on top, in SIDES
	"submission_open": bool,
	"submission_progress": int,    # 0..100
	"stall_stage": int,            # 0 idle, 1 warned, 2 stood up
	"stall_ticks": int,            # ticks held in this seat, 0 on the feet
}
```

**If `read` has no `grapple` key, draw nothing** - the panel must render an
older fold unchanged. Do NOT read `Godot/scripts/FightHudRead.gd`; render the
contract. If Q23 has not landed when you test, hand-build the dictionary.

## What to build, from G38 §5

* **A. The seat chip.** Visible only when `grappling` and `stance != "standing"`.
  Copy from G38's seat-label table (`over_under` → CLINCH, `guard` → GUARD,
  `half` → HALF, `side` → SIDE, `mount` → MOUNT, `back` → BACK). Format
  `{CORNER} · {LABEL}` when `top` is a side (the corner word the panel already
  uses for that side), `{LABEL}` when `top` is `""`. **GUARD stays visible when
  top is set** - "the 0 is a scoring fact, not a visibility fact."
* **B. Attempt pips.** Visible only while `submission_open`. Five discrete pips
  from `submission_progress` (0-19 / 20-39 / 40-59 / 60-79 / 80-100), the R85R
  trauma language, in the same column as the trauma pips. Label `SUB` plus the
  seat word (G38 Q1 default: no hold name exists yet).
* **C. Stall colour on the chip.** Amber at `stall_ticks >= 300`, red at
  `>= 400` (G38 Q2 default: the corner sees the referee coming). No countdown
  number.
* **What does NOT appear** (G38's refuse list, and the test asserts absence): no
  running control clock, no control-unit counter, no points, no input prompt,
  no chip on the feet.

## Owned files

| File | Lines | Note |
| --- | --- | --- |
| `Godot/scripts/FightHudPanel.gd` | 403 | Yours (U25/U28). Small enough to read whole. `_build_side` `:154`, `_build_heart` `:182`, `_build_worst` `:208`, `_build_regions` `:225`, `MAX_PIPS` `:20`. |
| `Godot/tests/fight_hud_panel_test.gd` | 238 | Yours. Extend. |
| `research/U31_DIGEST.md` | new | Short. |

**Do NOT read** `HANDOFF.md`, `CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md`, any
digest, `FightHudRead.gd` (Qwen, in flight), `FightRealtime.gd` (Claude, R92),
or `GameState.gd` (14,769 lines). G38 and this file are your inputs.

## Parse gate BEFORE any test

```
python Godot/tools/check_scripts.py Godot/scripts/FightHudPanel.gd Godot/tests/fight_hud_panel_test.gd
```

## Tests

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_hud_panel_test.gd
python Godot/tools/run_tests.py
```

Assert with hand-built reads: chip hidden on the feet and when `grappling` is
false; every seat label; the corner prefix; GUARD visible with a top; pips
count per band and hidden when no attempt; amber and red thresholds; and that
an old fold with no `grapple` key renders exactly as before. **Ceiling:**
`fails=0`. Another agent may be running Godot; an all-failed suite line is
contention, re-run.

## Done

Commit, **push `master` directly**, write `research/U31_DIGEST.md`, send:

```
python Tools/agent_comms.py send --from cursor --to claude --topic "U31-done" --body "<commit> <check count> <suite line>"
```

`git add` the mail file into your commit. Stage explicit paths only; the
checkout is shared. Do NOT edit `HANDOFF.md`.

## The trap specific to this task

**R31.** A Control with full-rect anchors must never have `size` assigned when
mounted - it writes the offsets and the node ends up twice the parent. Let the
anchors fill and pass sizes down, as the panel already does. And the design
trap G38 named: the instinct when the panel looks empty is to add a meter. Do
not. The chip, the pips and the colour are the whole read.
