# TASK Q23 — QWEN — FightHudRead CARRIES THE SEAT

Model: Qwen default, `--yolo`. Owner: Qwen. Base: `master` after U29
(`41c0975`). Assigned 2026-09-10. **One task. Do it and stop.**

---

## Why this exists

R91 made the fight produce ground fighting. `FightHudPanel` (Cursor) renders
`FightHudRead.fold` as plain data and nothing else, so the seat must travel
through your fold or the screen can never show it. Cursor (U31) is building
the chip from the contract below RIGHT NOW without reading your file; you
build the fold without reading theirs. The shape is the contract.

## The contract - exact keys, an unseen renderer will read them

`fold(state)` gains one key, `"grapple"`, whose value is EXACTLY what
`FightRealtime.grapple_of(state)` returns:

```gdscript
"grapple": {
	"grappling": bool(state.get("grappling", false)),
	"stance": str(g.get("stance", "standing")),
	"seat": str(g.get("seat", "none")),
	"top": "a" if int(g.get("top", -1)) == 0 else ("b" if int(g.get("top", -1)) == 1 else ""),
	"submission_open": bool(g.get("sub_open", false)),
	"submission_progress": int(g.get("sub_progress", 0)),
	"stall_stage": int(g.get("stall_stage", 0)),
	"stall_ticks": 0 if stance == "standing" or sub_open else maxi(0, int(state.get("tick", 0)) - int(g.get("stall_since", 0))),
}
```

where `g = state.get("grapple", {})`. A state with no `grapple` key (an older
fixture) folds to `grappling false, standing, none, "", false, 0, 0, 0`.

**You are duplicating ten lines of `FightRealtime.grapple_of` on purpose**:
`FightHudRead` has ZERO preloads and must stay that way, so it cannot call the
engine. The test below is what keeps the copy honest.

## Owned files

| File | Lines | Note |
| --- | --- | --- |
| `Godot/scripts/FightHudRead.gd` | 95 | Yours (Q18). Read whole. `fold` `:10`, `_read_side` `:49`. |
| `Godot/tests/fight_hud_read_test.gd` | 268 | Yours. Extend. |
| `research/Q23_DIGEST.md` | new | Short. |

**Do NOT read** `FightHudPanel.gd` (Cursor, U31), `HANDOFF.md`,
`CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md`, any digest, or `GameState.gd`
(14,769 lines). You MAY `grep -n "static func grapple_of" Godot/scripts/FightRealtime.gd`
and read that one function with `sed -n` - it is the thing you are mirroring -
and nothing else in that 1,773-line file.

## Parse gate BEFORE any test

```
python Godot/tools/check_scripts.py Godot/scripts/FightHudRead.gd Godot/tests/fight_hud_read_test.gd
```

## Tests

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_hud_read_test.gd
python Godot/tools/run_tests.py
```

Assert (1) a hand-built state folds to the exact dictionary above, including
the no-`grapple`-key case; (2) **in a real bout**: `load()` `FightRealtime.gd`
at runtime (never preload), run the pinned submission bout - the grappler
`{"power": 60, "technique": 80, "speed": 70, "defense": 60, "conditioning": 85, "fight_iq": 80, "grapple": 95}`
against the fish `{"power": 50, "technique": 40, "speed": 50, "defense": 20, "conditioning": 45, "fight_iq": 20, "grapple": 15}`,
`{"seed": 92001, "rounds": 3}` - tick by tick, and assert `fold(state)["grapple"]
== FightRealtime.grapple_of(state)` key for key at EVERY tick, and that the
fold saw the floor (`stance == "ground"` on at least one tick) and an open
attempt. **Ceiling:** `fails=0`; an all-failed suite line is contention with
another agent's Godot - re-run.

## Done

Commit, push `master`, write `research/Q23_DIGEST.md`, send:

```
python Tools/agent_comms.py send --from qwen --to claude --topic "Q23-done" --body "<commit> <check count> <suite line>"
```

`git add` the mail file into your commit. Stage explicit paths only; the
checkout is shared. Do NOT edit `HANDOFF.md`.

## The trap specific to this task

**`top` is an INDEX on the engine and a SIDE on the read.** 0 is `"a"`, 1 is
`"b"`, anything else is `""`. A renderer given `0` would print nothing for the
red corner. And `stall_ticks` is 0 on the feet and 0 while an attempt is open
- a chip that turned amber during a choke would be lying about the referee.
