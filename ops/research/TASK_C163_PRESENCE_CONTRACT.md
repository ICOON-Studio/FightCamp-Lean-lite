# C163 — THE BLIND CONTRACT TEST FOR PRESENT RATIO

**Owner:** codex (`gpt-5.6-luna`, MEDIUM). Contract test, not animation.
**Tier: parse gate, then your own test, then `--only presence`. NO SUITE RUN.**

## THIS IS A BLIND TEST AND THAT IS THE WHOLE POINT

**The module does not exist yet. Claude writes it next session, from the same
contract you are reading, without seeing your test.** You must not write the
module, and there will be nothing to read if you go looking — that is
deliberate. A test written against an implementation only ever agrees with
it, and the thresholds below are exactly where a misreading would ship
silently.

This split has paid twice here. C142 wrote the `CASCY_TO_UE4` contract test
before the map existed, skipped green, and passed for real with all four
mutants caught once the map landed. C159 landed first-pass, checks=42
failures=0, and corrected ITSELF against the contract text when the module
disagreed with its expectation.

## WHERE THE CONTRACT COMES FROM, SO YOU CAN JUDGE IT

`research/D11_HEAD_CAP_ANSWER.md` — read it, it is short, and it is the
only background you need.

The short version: a capsule's "exposure" percentage was being used on its own
to decide whether a body part was reachable for a grapple. Codex's own
objection to that — *"accessibility can improve by DELETING PROTECTIVE
GEOMETRY"* — turned out to be exactly right. The rule currently in our tree
reads **92.7% exposed** and, measured the new way, **7.4% present**: the neck
did not become reachable, it became absent. So every reading is now a PAIR,
and this module is the thing that computes and judges the pair.

## THE CONTRACT — EXACT NAMES, ARGUMENT ORDER AND RETURN SHAPES

The module will be `Godot/scripts/CapsulePresence.gd`. Every function is
`static`. Nothing in it touches a rig, a scene or an autoload — it is pure
arithmetic over two numbers, which is why it can be tested blind.

```gdscript
static func present_ratio(measured_extent_m: float, authored_extent_m: float) -> float
```
Returns `measured / authored * 100.0`, clamped to `0.0 .. 100.0`.
**`authored_extent_m <= 0.0` returns `0.0`** — never a division by zero and
never `INF`. A measured extent larger than the authored one clamps to `100.0`.

```gdscript
static func classify(exposure_pct: float, present_pct: float) -> String
```
Returns exactly one of these five strings, upper case, no other value ever:

| exposure | present | returns |
|---|---|---|
| `>= 90.0` | `>= 95.0` | `"REACHABLE"` |
| `>= 90.0` | `>= 50.0` and `< 95.0` | `"PARTIAL"` |
| `>= 90.0` | `< 50.0` | `"DELETED"` |
| `< 90.0` | `>= 95.0` | `"OBSCURED"` |
| `< 90.0` | `< 95.0` | `"ABSENT"` |

**The boundaries are INCLUSIVE at the number named.** Exposure of exactly
`90.0` is the high band. Present of exactly `95.0` is the top band; exactly
`50.0` is the middle band. Test each boundary from both sides — that is the
single most useful thing in this file, and it is where a from-scratch
implementation will disagree with the table.

```gdscript
static func passes(exposure_pct: float, present_pct: float) -> bool
```
`true` only when `exposure_pct >= 90.0 and present_pct >= 95.0` — i.e. exactly
when `classify` returns `"REACHABLE"`. **These two must never disagree**, and
a test that asserts they agree across a grid is worth more than either alone.

```gdscript
static func format_pair(exposure_pct: float, present_pct: float) -> String
```
Returns `"<exposure> | <present>"` with **exactly one decimal place on each
number, a percent sign on each, and a space-pipe-space separator**. So
`format_pair(92.7, 7.4)` is exactly `"92.7% | 7.4%"`. Rounding is
half-away-from-zero at one decimal.

## THE THREE REAL ROWS, WHICH YOUR TEST MUST CONTAIN

From Dola's own rig. These are not invented and they anchor the whole thing:

| arm | exposure | present | classify | passes |
|---|---|---|---|---|
| A (the rule in our tree today) | 92.7 | 7.4 | `"DELETED"` | `false` |
| B (head shortened only) | 91.8 | 91.3 | `"PARTIAL"` | `false` |
| C (both offsets, recommended) | 99.4 | 100.0 | `"REACHABLE"` | `true` |

**If your test says arm A is anything but `DELETED`, you have misread the
contract and the whole exercise has failed.**

## Owned files

- `Godot/tests/capsule_presence_contract_test.gd`
- `research/C163_DIGEST.md`

**You own NOTHING else. Do not create `CapsulePresence.gd`.**

## What to do when the module is missing

`load("res://scripts/CapsulePresence.gd")` will return `null` today. **Skip
green and say so loudly in the output** — print a line naming the module as
absent and exit 0 with `SUITE total=0 fails=0`. Do NOT fail: a red for a file
that was never meant to exist yet tells nobody anything, and C142 handled this
exact case correctly by skipping.

## Gate

```
python Godot/tools/check_scripts.py Godot/tests/capsule_presence_contract_test.gd
python Godot/tools/run_tests.py --only presence
```

`--only` does NOT stack — one per invocation, and read `total=` to confirm how
many ran. **Do not run the full suite**; it is Claude's, once, at integration.

## Rules

- **DO NOT fetch and DO NOT rebase** — the checkout is current, and a rebase
  here refuses over the untracked `.uid` / `.import` / scratch files this
  checkout always carries. You stopped at exactly that on C160 and stopping
  was right.
- Never `git stash`, `git reset --hard`, `git checkout .`, `git clean` or
  `git add -A`. Stage explicit paths only.
- Read `D11_HEAD_CAP_ANSWER.md` and this file. Nothing else. Do not read
  `HANDOFF.md`, `CURRENT_STATUS.md` or any digest.
- **Do not write `CapsulePresence.gd`, even as a stub**, and do not go looking
  for a draft of it. If you write it, the test is no longer blind and the
  exercise is worthless.

## And then argue against the contract

End the digest with the strongest case you can make that this contract is
WRONG — that a five-band classification is over-engineered, or that one of
the thresholds is in the wrong place, or that `PARTIAL` and `ABSENT` are
distinctions nobody will act on. Dola named her own weakest point unprompted
(whether the underlying rule survives the shoulder girdle at all); do the
same for the contract. That half of the brief has produced the shipped answer
twice here.
