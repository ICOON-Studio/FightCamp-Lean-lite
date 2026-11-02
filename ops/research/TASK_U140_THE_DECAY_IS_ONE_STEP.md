# TASK_U140 — THE HOLD DECAY IS ONE STEP AND ITS HEADER CLAIMS A CURVE

**Model: `composer-2.5`, medium effort.** Worktree `FightCamp-U114`, cut a FRESH
branch off `origin/master` named `cursor/u140-decay-shape`. Your mail rides your
branch, so name the branch in the message you send.

**Read this file and only the files it names.** Do NOT read `HANDOFF.md`,
`CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md` or any digest, and do not explore the
repo to "get oriented".

---

## THE DEFECT, MEASURED

`Godot/scripts/GroundGraph.gd` carries a hold-cost function:

```gdscript
const DECAY_GATES := 2
const CONTROL_FLOOR := 1

static func control_units_decayed(flat_units: int, held_ticks: int,
		gate_ticks: int, arm: String) -> int:
	...
	var window: int = gate_ticks * DECAY_GATES
	var steps: int = int(floor(float(held_ticks) / float(window)))
	if steps <= 0:
		return flat_units
	return maxi(CONTROL_FLOOR, flat_units - steps)
```

Its header describes **"one step of decay per `DECAY_GATES` multiples of that
seat's own `hold_ticks`"** — a ladder. **The integers cannot climb it.** With
the engine's real values (`flat_units = 2` for side/mount/back, `gate_ticks =
60`, `CONTROL_FLOOR = 1`) the function has exactly **two** outputs:

```
held   side/mount/back(flat=2)   half(flat=1)   hold_value(=decayed(2)/2)
     0            2                  1               1.00
   119            2                  1               1.00
   120            1                  1               0.50
  6000            1                  1               0.50
```

**Two findings, both confirmed by calculation:**

1. **It is ONE STEP, at 120 ticks, and the only step there will ever be.**
   `flat - steps` hits the floor after a single decrement from 2.
2. **Half guard never decays at all**, because its flat value of 1 already
   equals `CONTROL_FLOOR`. So the three dominant seats are compressed to half
   guard's rate and half guard is untouched.

A stage measured the consequence: scored control fell from **8.01 to 5.85 units
per 100 ground ticks, a 27% cut** — produced by a single binary step rather
than by any curve.

---

## THE QUESTION, AND IT IS NOT "PICK A NUMBER"

**`DECAY_GATES = 2` is AUTHORED AGAINST NO STUDY and it stays that way.** Do not
tune it, and do not go looking for a real-world figure for it — there is none,
and inventing one is worse than leaving it honest.

**Your job is the SHAPE.** The intent the header states is a graded discount on
static control: worth full value early, less later, never zero. The integers
deliver a cliff. **Make the function able to express the shape its header
already claims, and measure what that costs.**

### What the shape must satisfy — this is the contract

- **Monotonic non-increasing** in `held_ticks`.
- **Full value** while `held_ticks` is below the first window.
- **Never below `CONTROL_FLOOR`**, and `CONTROL_FLOOR` stays 1. *Real judging
  discounts inactive control, it does not erase it*, and zeroing it would let a
  losing man escape all scoring consequence by simply enduring.
- **Still an INTEGER return.** Control units are counted, and a float here would
  silently change what every existing scorecard adds up to. If you need finer
  resolution than integers allow, say so explicitly and propose how — do not
  quietly change the return type.
- **`current` and `graph` arms return `flat_units` unchanged.** That is what
  keeps the control arm byte-identical, and it is non-negotiable.
- **A 1-unit seat must be able to decay too**, or say in your digest why it
  should not.

**There is more than one honest answer here** — a finer window, a different
floor rule, a payout resolution change, or an argued case that the cliff is
actually correct and only the header is wrong. **That last one is a real
option**: if you conclude the one-step cliff is the right mechanism and the
documentation is the only defect, say so, fix the header, and defend it. A
measurement that refuses its own premise is worth more here than one that
confirms it.

---

## OWNED FILES

- `Godot/scripts/GroundGraph.gd` — yours. **320 lines, read it whole.**
- `research/U140_DIGEST.md` — new, yours.

**DO NOT EDIT `Godot/scripts/FightRealtime.gd`.** Two other agents are working
in that file this session and you will collide. You may RUN tools that read it;
you may not change it.

**DO NOT EDIT `Godot/tests/ground_graph_contract_test.gd`.** It is a contract
test written blind against the definition, and bending it to match your change
is the exact failure it exists to prevent. **If your change makes it red, that
is a FINDING** — report it, say which assertion broke and whether the contract
or your change is wrong, and do not edit the test to go green.

---

## TEST TIER — A SCRIPT IS EDITED, SO THIS IS THE MIDDLE TIER

Parse gate FIRST. **A parse error HANGS a headless test for 600 s instead of
failing it**, so never skip it:

```
python Godot/tools/check_scripts.py Godot/scripts/GroundGraph.gd
```

Then, and nothing more:

```
python Godot/tools/run_tests.py --only ground_graph
python Godot/tools/run_tests.py --only grapple
```

**DO NOT RUN THE FULL SUITE.** It is 356 tests, about twenty minutes, and it is
the integrator's job once at the end — not yours.

**Gate as a CEILING, never an exact count:** both must read `fails=0` **or
better**. If you land something better than asked, say so and push it.

### AND MEASURE WHAT YOUR SHAPE COSTS — THIS IS THE DELIVERABLE

Two tools already exist and you must run both:

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/s58_roll_sweep.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/s58_ground_arms.gd
```

The second is the one that matters. **It checks the `current` arm against
`research/S56_ground_exits.json` integer for integer and FAILS on any drift** —
so it is your proof that you did not disturb the control. Report from it:

- the control arm's MATCH line, verbatim;
- `units/100t` for all four arms, before and after your change;
- the side-control `mean_held_s` for all four arms, before and after;
- the seat-share table, before and after.

**Run it on the UNCHANGED tree FIRST and keep that output**, or you will have
nothing to compare to. That is this project's own rule and it has been paid for
more than once.

**The exit code alone is NOT a pass.** A GDScript runtime error leaves rc=0, so
a clobbered test prints twenty `SCRIPT ERROR` lines, then prints `0 failure(s)`,
then exits 0. Read the output, not the code. Godot's `N RID allocations ... were
leaked at exit` and `N resources still in use at exit` are teardown chatter and
are already filtered — do not "fix" anything by grepping for ERROR.

---

## GDSCRIPT TRAPS

- `var x := <call>` fails when the call returns Variant (a `.size()` or `.get()`
  on an untyped value, a static on a `load()`ed script). Write the type:
  `var n: int = ...`.
- **Reusing a variable name inside one function is a parse error**, even across
  separate `if` / `for` blocks.
- `%` inside a format string must be `%%`.

---

## THE ONE TRAP SPECIFIC TO THIS TASK

**`score_edge` calls `control_units_decayed(2, held, gate, "decay")` with the
arm HARDCODED and the flat value HARDCODED at 2.** So the chooser's
`hold_value` term rides the same function you are changing, on every arm,
including `graph` — which is why `both` and `graph` behave identically today. If
you change the function's shape you change **both** the payout and the chooser's
weighting, in one edit, and the seat shares will move for two reasons at once.
**Say which of your reported deltas is payout and which is chooser**, or the
measurement cannot be read. If you cannot separate them, that itself is worth
reporting as a coupling defect.

---

## WHEN YOU ARE DONE

Commit, push `cursor/u140-decay-shape`, write `U140_DIGEST.md`, and send one
line:

```
python Tools/agent_comms.py send --from cursor --to claude --topic U140 --body "<one line, NAME THE BRANCH cursor/u140-decay-shape>"
```

**Do NOT edit `HANDOFF.md`** — I write your block.
