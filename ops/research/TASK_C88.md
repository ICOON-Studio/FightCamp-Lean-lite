# TASK C88 — CODEX — THE BLIND CONTRACT TEST FOR THE PRESENTATION QUEUE

Model: Sonnet tier, **medium effort only — never high**. Owner: codex.
Test tier: **NEW TEST FILE ONLY** — parse gate, then that ONE test. Nothing else.
A new test file cannot break another test. **Do not run the full suite**; it
costs twenty minutes and buys nothing here.

## Owned files

- `Godot/tests/fight_presentation_queue_test.gd` — **NEW. You create it. Yours alone.**

Nothing else. Do not edit `Godot/scripts/FightPresentationQueue.gd`, do not edit
`HANDOFF.md`, do not edit any other test.

## THIS IS A BLIND TEST. READ THE CONTRACT BELOW AND NOTHING ELSE.

`Godot/scripts/FightPresentationQueue.gd` is being written in parallel by Claude.
**DO NOT OPEN IT.** A test written against an implementation only agrees with it.
If the module is not on disk when you start, write the test anyway and let it
fail loudly.

## Why this exists

Our fight simulation has already decided every beat before anything is drawn.
The bought reaction clip is **3.03 seconds**; the beat it has to play on is about
**one second**. Something has to decide what gets cut.

The answer, from a survey of shipped management and sports games (G56), is
**three clocks**: the sim clock, which never waits; a **presentation queue**,
which consumes beats and is **permitted to drop or merge them**; and the authored
clip clock, which owns time **only for set pieces** — a knockdown, a ref step-in.
Football Manager's highlight reel is the genre's open admission that presentation
drops most sim events. **Nobody pauses the match sim so a victim's clip can
finish.**

This module is clock 2. It is a **pure decision function** — no timers, no
signals, no scene — so it is cheap to test exhaustively.

## THE CONTRACT

`Godot/scripts/FightPresentationQueue.gd`, `class_name FightPresentationQueue`,
`extends RefCounted`, **statics only**, **zero preloads**.

### Constants

```
const DECISION_PLAY  := "play"
const DECISION_CUT   := "cut"
const DECISION_MERGE := "merge"
const DECISION_DROP  := "drop"
```

### `static func decide(request: Dictionary, state: Dictionary) -> Dictionary`

One pure state transition. It never mutates either argument.

**`request`** carries:

| key | type | meaning |
|---|---|---|
| `role` | `String` | the role asked for, e.g. `"react_head"` |
| `clip_len_s` | `float` | the clip's full authored length |
| `readable_s` | `float` | the length of its readable peak — contact plus recoil |
| `budget_s` | `float` | seconds until the next beat needs the body |
| `set_piece` | `bool` | true for a knockdown and nothing else today |

**`state`** carries the body's current occupancy:

| key | type | meaning |
|---|---|---|
| `now_s` | `float` | the sim clock |
| `busy_role` | `String` | `""` when the body is free |
| `busy_until_s` | `float` | when the clip in flight ends |
| `busy_set_piece` | `bool` | whether what is in flight is a set piece |

**Returns** a Dictionary with **exactly these keys**:

| key | type | meaning |
|---|---|---|
| `decision` | `String` | one of the four constants |
| `start_s` | `float` | where in the clip to begin |
| `end_s` | `float` | where in the clip to stop |
| `play_s` | `float` | `end_s - start_s`; `0.0` for drop and merge |
| `reason` | `String` | short, non-empty, always |
| `busy_role` | `String` | the NEW state, to be threaded into the next call |
| `busy_until_s` | `float` | the NEW state |
| `busy_set_piece` | `bool` | the NEW state |

### The rules, in priority order

1. **A set piece in flight wins.** If `state.busy_set_piece` is true and
   `now_s < busy_until_s`, everything else is `DROP` — **including another set
   piece.** State comes back unchanged. Nothing interrupts a knockdown.
2. **A set piece request owns the clock.** If `request.set_piece` and the body is
   free (or busy with a non-set-piece), the decision is `PLAY`, in full:
   `start_s = 0.0`, `end_s = clip_len_s`. It interrupts an ordinary clip.
3. **Busy with the SAME role** (and not a set piece): `MERGE`. `play_s = 0.0`,
   and **`busy_until_s` is left where it was — a merge never extends the clip in
   flight.** Two jabs landing inside one reaction read as one reaction.
4. **Busy with a DIFFERENT ordinary role**: `DROP`. A hit reaction may not
   interrupt another hit reaction (CryEngine's documented rule).
5. **Free, and the clip fits the budget** (`clip_len_s <= budget_s`): `PLAY` in
   full.
6. **Free, and the clip is longer than the budget**: `CUT` to the readable peak.
   `start_s = 0.0`, `end_s = min(readable_s, budget_s)`.

In every `PLAY` and `CUT`, the new `busy_until_s` is `now_s + play_s` and the new
`busy_role` is `request.role`.

### Degenerate input — say what happens rather than crashing

- `budget_s <= 0.0` on a free body: `CUT` to `readable_s`. A zero budget must
  never produce a zero-length or negative-length play.
- `readable_s <= 0.0` or `readable_s > clip_len_s`: fall back to `clip_len_s`.
- `clip_len_s <= 0.0`: `DROP`, with a reason saying so.
- An empty `role`: `DROP`.
- **`play_s` is never negative, in any branch.** Assert this on every case you
  generate.

## What to assert

Cover all six rules plus every degenerate case above. Then, past the case table:

1. **THREAD THE STATE.** Feed a realistic sequence of ten to twenty beats through
   `decide`, carrying the returned state into the next call, and assert the
   sequence is coherent — no negative `play_s`, no `busy_until_s` that moves
   backwards, and a set piece never interrupted.
2. **A KNOCKDOWN SURVIVES A STORM.** Start a set piece, then submit six ordinary
   reactions inside its window, and assert **all six are `DROP`** and the set
   piece's `busy_until_s` never moved.
3. **THE MERGE DOES NOT EXTEND.** Rule 3's `busy_until_s` invariant is the one
   most likely to be got wrong. Assert it directly.
4. **PURITY.** Pass a `request` and a `state`, keep copies made with
   `duplicate(true)` before the call, and assert both are **byte-identical after
   the call**. A decision function that mutates its inputs will corrupt the
   caller's state one beat later and look like a presentation bug.

## GDScript traps that cost a fix cycle

- `var x := <call>` fails when the call returns Variant — `.get()` on an untyped
  Dictionary does. Write the type: `var n: float = float(d.get("k", 0.0))`.
- `%` inside a format string must be `%%`.
- Reusing a variable name inside one function is a parse error, **even across
  separate `if` / `for` blocks.** A case-table test hits this constantly.
- **`rc=0` IS NOT A PASS.** A runtime error leaves rc=0, so a broken test prints
  its SCRIPT ERRORs and then prints `0 failure(s)` — a counter it never reached.
  Print an explicit `failures=N` and make sure your counter is reached.
- **A parse error HANGS a headless run** until timeout rather than failing it.
  Parse gate first, every time.

## Gate

```
python Godot/tools/check_scripts.py Godot/tests/fight_presentation_queue_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_presentation_queue_test.gd
```

The exe is in `%LOCALAPPDATA%\Programs\Godot\`.

Last line, machine-readable:

```
PRESENTATION_QUEUE checks=<n> failures=<n>
```

`failures=0` is the target. **If the module is missing or disagrees with this
contract, report the failures — never weaken an assert to go green.** A test that
disagrees with the module is this task delivering.

## Deliver

Commit and push. Then one line:

```
python Tools/agent_comms.py send --from codex --to claude --subject C88-done --body "<sha> checks=N failures=N"
```

Do **not** edit `HANDOFF.md` — Claude writes your block.
