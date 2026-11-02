# TASK_U142 — THE MAN UNDERNEATH DOES NOT GET A CHOICE

**Model: `composer-2.5`, medium effort.** Worktree `FightCamp-U114`, cut a FRESH
branch off `origin/master` named `cursor/u142-bottom-man`. Your mail rides your
branch, so name the branch in the message you send.

**Read this file and only the files it names.** Do NOT read `HANDOFF.md`,
`CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md` or any digest.

---

## THE SITUATION

A ground position graph was wired into the fight engine. **Only the TOP man
uses it.** `GroundGraph.EDGES` authors two edges for the man underneath —
`mount_escape` and `side_escape`, both `"actor": "bottom"` — and **they are
never offered to anything.** `edges_from(seat, "top", held)` is the only call.

The bottom man still runs the shipped ladder, which is hardcoded in
`FightRealtime._grapple_ground` under the comment `# 4. THE BOTTOM MAN.`:

```gdscript
if float(gates[bottom_side]) < GROUND_WORK_P:
	var escape: Dictionary = Grapple.position_resolve(
		bottom, top, seat, bottom_fatigue, top_fatigue, float(acts[bottom_side]))
	if not bool(escape.get("success", false)):
		return
	if seat == "guard":
		_move_seat(... "standing", "none", ... "stand_up" ...)
	elif seat == "half":
		_break_balance(top, SWEPT_BALANCE_MAGNITUDE, "sweep", ...)
		_move_seat(... "ground", "guard", bottom_side, "sweep", ...)
	else:
		_move_seat(... "ground", "guard", top_side, "escape", {}, 0)
```

**One destination per seat, and no choice anywhere** — the same defect the graph
was built to end for the top man.

---

## WHAT TO BUILD

**Wire the bottom man's choice behind the SAME `ground_arm` flag**, so it is
live on `"graph"` and `"both"` and absent on `"current"` and `"decay"`.

Follow the top man's wiring, which is already in the file a few lines above
yours — read it and copy its shape. In particular:

- **Consume NO extra random draw.** `_run_grapple` takes FOUR DRAWS, HERE,
  ALWAYS. The top man's chooser rescales the gate roll it was already given off
  its own threshold. **Do the same for the bottom man with HIS roll.** A fifth
  draw shifts every downstream stream and the arms would then differ for a
  reason that is not the decision.
- **When the chooser returns nothing legal, fall back to the shipped ladder**
  rather than inventing a move.
- **Keep `position_resolve` as the success roll**, scaled by the edge's `p_mod`
  exactly as the top man's branch does. Same formula, different scale — do not
  invent a new roll.
- **A sweep must still break the top man's balance.** The shipped `half` branch
  calls `_break_balance(top, SWEPT_BALANCE_MAGNITUDE, "sweep", seconds,
  Balance.DIRECTION_BASE)`. **If your chosen edge is a sweep, that call must
  still happen** — dropping it would silently remove a landed feature, and the
  balance tests would not catch it because they do not go through this path.
- **Record the edge the same way the top man's does**, so the measurement tool
  can read it.

**`mount_escape` and `side_escape` both land in `guard`, which is where the
shipped ladder sends an escape anyway.** So on today's authored data your change
may move very little. **THAT IS A LEGITIMATE RESULT AND YOU MUST REPORT IT AS
ONE** — do not add edges to `GroundGraph.gd` to make the number move. If the
honest finding is "the bottom man now chooses, and with the current edge set the
choice is between one option and nothing", say exactly that. **A stage that
reports a small number honestly is worth more here than one that manufactures a
big one**, and this project has shipped several of the former on purpose.

---

## OWNED FILES

- `Godot/scripts/FightRealtime.gd` — **edit ONLY the `# 4. THE BOTTOM MAN.`
  branch inside `_grapple_ground`**, plus any small helper you add at the end of
  the file. Touch nothing else in it.
- `research/U142_DIGEST.md` — new, yours.

**`FightRealtime.gd` is 4,700+ lines — NEVER open it whole.** Grep for
`# 4. THE BOTTOM MAN.` and read a `sed -n` window around it; grep for
`_ground_graph_on` and `_choose_ground_edge` and read those. That is all you
need. `GroundGraph.gd` is 320 lines and you may read it whole.

**DO NOT EDIT `GroundGraph.gd`.** Its contract test was written blind and the
edge set is authored deliberately.

**DO NOT EDIT `Godot/tests/ground_graph_contract_test.gd` or
`Godot/tests/ground_arm_wiring_test.gd`.** If either goes red, that is a
FINDING — report which assertion broke and whether the contract or your change
is wrong. Do not bend a test to go green.

**ANOTHER AGENT MAY BE EDITING `begin` AND `_build_fighter` IN THE SAME FILE.**
Stay out of both. Work on your own branch in your own worktree and rebase before
you push; I integrate.

---

## TEST TIER — A SCRIPT IS EDITED, SO THIS IS THE MIDDLE TIER

Parse gate FIRST. **A parse error HANGS a headless test for 600 s instead of
failing it:**

```
python Godot/tools/check_scripts.py Godot/scripts/FightRealtime.gd
```

Then, and nothing more:

```
python Godot/tools/run_tests.py --only ground_arm_wiring
python Godot/tools/run_tests.py --only ground_graph
python Godot/tools/run_tests.py --only grapple
```

**DO NOT RUN THE FULL SUITE.** 356 tests, twenty minutes, and it is the
integrator's job. **Gates are CEILINGS:** `fails=0` or better.

**The exit code alone is NOT a pass.** A GDScript runtime error leaves rc=0, so
a broken test prints `SCRIPT ERROR` lines, then `0 failure(s)`, then exits 0.
Read the output. Godot's `N RID allocations ...` and `N resources still in use
at exit` are teardown chatter and are already filtered.

### AND MEASURE IT — THIS IS THE DELIVERABLE

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/s58_ground_arms.gd
```

**Run it on the UNCHANGED tree FIRST and keep that output**, or you have nothing
to compare to. Its `current` arm checks against `research/S56_ground_exits.json`
integer for integer and **FAILS on any drift** — that is your proof you did not
disturb the control. Report, before and after:

- the control arm's MATCH line, verbatim;
- the seat-share table for all four arms;
- the edge tally, which should now contain bottom-actor edges;
- how a ground spell ends (`stand_up` / `stall` / `round_or_bout_end`), because
  **that is where a bottom-man change should show up if it shows up anywhere.**

---

## GDSCRIPT TRAPS

- `var x := <call>` fails when the call returns Variant. Write the type.
- **Reusing a variable name inside one function is a parse error**, even across
  separate `if` / `for` blocks — and `_grapple_ground` is a long function that
  already uses `escape`, `advance`, `attempt`, `to_seat`, `via` and `edge`.
  **Pick fresh names or you will not get past the parse gate.**
- `%` inside a format string must be `%%`.

## THE ONE TRAP SPECIFIC TO THIS TASK

**A seat change by anyone ends the tick** — the file says so: "the top man
(submission or advance), then the bottom man, and a seat change by anyone ends
the tick, so two changes never share one." The bottom man's branch runs AFTER
the top man's and only if the top man did not already move the seat. **If you
return early in the wrong place you will silently starve the bottom man**, and
the symptom will be that escapes simply stop happening — which looks like a
tuning outcome, not a bug. Check `stand_up` in the exits table before and after:
if it collapses, that is what happened.

---

## WHEN YOU ARE DONE

Commit, push `cursor/u142-bottom-man`, write `U142_DIGEST.md`, and send one
line:

```
python Tools/agent_comms.py send --from cursor --to claude --topic U142 --body "<one line, NAME THE BRANCH cursor/u142-bottom-man>"
```

**Do NOT edit `HANDOFF.md`** — I write your block.
