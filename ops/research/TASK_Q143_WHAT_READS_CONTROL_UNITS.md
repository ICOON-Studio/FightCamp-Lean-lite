# TASK_Q143 — IF CONTROL WERE PAID IN TENTHS, WHAT WOULD BREAK?

**Model: `qwen3-coder`, medium effort, `--yolo` (NEVER `auto` — auto leaves you
with no shell tool at all).** Worktree `FightCamp-Q114`, cut a FRESH branch off
`origin/master` named `qwen/q143-control-resolution`.

**Read this file and only the files it names.** Do NOT read `HANDOFF.md`,
`CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md` or any digest.

---

## THE SITUATION, PROVEN BY ARITHMETIC

Ground control is scored in **whole units**. `Godot/scripts/GrappleSeat.gd`:

```gdscript
static func control_units(stance: String, seat: String, has_top: bool) -> int:
	if stance == "clinch" and seat == "over_under" and has_top:
		return 1
	if stance == "ground":
		if seat == "side" or seat == "mount" or seat == "back":
			return 2
		if seat == "half":
			return 1
	return 0
```

A separate module discounts a position that is held without progress, floored so
that inactive control is reduced and never erased:

```gdscript
const CONTROL_FLOOR := 1
return maxi(CONTROL_FLOOR, flat_units - steps)
```

**With `flat_units = 2` and `CONTROL_FLOOR = 1` there are exactly TWO integers
between the value and the floor.** So a graded discount is not expressible: every
possible implementation is a single cliff, and the only free parameter is *when*
it fires. An attempt to give it a curve was measured and refused — it could only
move the step from 120 ticks to 239, because no seat has more than one unit of
range. **Half guard (1 unit) cannot decay at all**, since its flat value already
equals the floor.

The obvious repair is **resolution**: pay control in tenths (or accrue
fractional control and floor it at emission). **That changes what every existing
scorecard adds up to**, so it is a product ruling and it is NOT yours to make.

---

## WHAT I WANT: THE CENSUS, NOT THE CHANGE

**DO NOT CHANGE THE RESOLUTION. DO NOT EDIT `GrappleSeat.gd`.** I want to know
what would break, before anyone decides.

**Find every place in the repo that consumes a control unit**, and for each one
report: the `file:line`, what it does with the value, and — the part that
matters — **whether it would still be correct if the value became a float or a
ten-times-larger integer.**

Search for the real thing, not the category: `control_units`, `"control"` as a
log `kind`, `units`, and anything that folds a scorecard. Start from
`GrappleSeat.control_units` and `state["control_units"]` and follow the readers.

### THE FOUR QUESTIONS

1. **WHO READS IT?** The full list with `file:line`. Include tests, tools and
   screens, not just engine scripts — **a test that hardcodes `2` is exactly the
   thing that would break silently.**
2. **WHICH READERS ASSUME AN INTEGER?** Name each one and quote the line. Look
   specifically for: `int(...)` casts, `==` comparisons against a literal,
   string formatting with `%d`, dictionary keys built from the value, and any
   accumulation into a variable typed `int`.
3. **WHICH READERS ASSUME A SCALE?** A reader that compares control to a
   threshold, or weights it against another counter, breaks if the unit gets ten
   times bigger even though it is still an integer. **This is the subtler half
   and it is the half I expect to be missed** — a `%d` that prints `25` instead
   of `2.5` is visible; a judge weighting `control * 0.2` against `takedowns` is
   not.
4. **WHAT IS THE SMALLEST CHANGE THAT WOULD WORK?** Given 1–3, say whether the
   repair is (a) floats all the way through, (b) integers ten times larger with
   display divided at the edge, or (c) something else. **Price it in files
   touched and name the riskiest one.** If you conclude the resolution change is
   not worth it and the cliff should simply be documented as intended, say so —
   **that is a legitimate answer and it is worth more than a reluctant yes.**

---

## OWNED FILES

- `research/Q143_CONTROL_RESOLUTION.md` — **new, yours. The census.**

**That is the only file you create or edit.** This is a READ-ONLY
investigation.

**`Godot/scripts/FightRealtime.gd` is 4,700+ lines — NEVER open it whole.**
Grep it and read `sed -n` windows around the hits. `GrappleSeat.gd` is small
enough to read whole.

## TEST TIER — NONE

**No `.gd` file is edited, so there is NO gate at all.** Not the parse gate, not
a test. `git status -s` before staging is the whole check. **Do not run the
suite** — it is 356 tests and twenty minutes and it would tell you nothing about
a document.

---

## THE ONE TRAP SPECIFIC TO THIS TASK

**A grep for `control_units` will not find the readers that matter.** The value
travels as a plain `units` field on a log event (`{"kind": "control", ...,
"units": n}`), and it is folded into scorecards by adapters that never mention
the words "control units" at all. **A census that lists only the literal
identifier is the failure mode here**, and it will look complete.

So: follow the VALUE, not the name. Find where `"kind": "control"` events are
read, find what `state["control_units"]` feeds, and find every scoring fold that
takes a control-shaped input. **Say explicitly in your report how you searched
and what you might still have missed** — an honest gap named is worth more than
a confident list that is short.

---

## WHEN YOU ARE DONE

Commit, push `qwen/q143-control-resolution`, and send one line:

```
python Tools/agent_comms.py send --from qwen --to claude --topic Q143 --body "<one line, NAME THE BRANCH>"
```

**Do NOT edit `HANDOFF.md`** — I write your block.
