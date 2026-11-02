# TASK G32 — GROK — TRAUMA IS DISCRETE: THE CUT ABOVE THE EYE

Model: your default, high effort. Owner: Grok. Deliverable: **ONE new file**,
`Godot/scripts/FightTrauma.gd`. **Do not write a test.** Its test is G32T, a
separate task written from this same contract by somebody who will not see your
code — that is deliberate, because a test written against an implementation
only ever agrees with it.

You have no checkout and no Godot. **Do not run any repo command and do not try
to clone anything.** This module has **ZERO preloads**, which is what makes it
testable on its own.

---

## Why

R85R drove Undisputed first-hand and came back with this, which is the finding
this task exists for:

> **Attrition is continuous; trauma is discrete.** Head and body are bars
> because they accumulate. Cuts and swelling are four-step pips because a cut
> is an EVENT... we model the head as one continuous 0–100 float, so we have no
> way to express "he has a bad cut over the left eye".

That is exactly right and it is exactly our gap. Our fight already tracks a
`head_neck` condition that slides from 100 down to 0. It cannot say that a man
is cut, where, or how badly — and a cut is the single most visible thing in a
boxing broadcast, the thing that stops fights and the thing a corner works on.

Your module is that missing vocabulary. It is **pure arithmetic over a plain
Dictionary**: no engine state, no nodes, no RNG, no preloads, no `class_name`
dependency on anything else in the repo.

## The contract — these EXACT names, argument orders and strings

An unseen test will call this. Every name below is part of the contract.

`Godot/scripts/FightTrauma.gd`, `class_name FightTrauma`,
`extends RefCounted`, statics only.

```gdscript
## The six places a fighter's face actually opens up. This exact list, this
## exact order, these exact strings.
const SITES := ["left_brow", "right_brow", "left_eye", "right_eye", "nose", "lip"]

## The two kinds of visible trauma. These exact strings.
const KINDS := ["cut", "swelling"]

## Four pips, R85R's own count. A site/kind never exceeds this.
const MAX_PIPS := 4


## A fighter with an unmarked face. Returns a NEW dictionary every call:
##   { "<site>": { "cut": 0, "swelling": 0 }, ... } for all six sites.
static func fresh() -> Dictionary

## 0..MAX_PIPS. An unknown site or kind returns 0 - never an error, never -1.
static func severity(trauma: Dictionary, site: String, kind: String) -> int

## How likely this blow is to make it worse. 0.0..1.0.
## `force` is 0.0..1.0. Already-damaged tissue opens more easily, so this
## RISES with `current_pips` - but it must return 0.0 at MAX_PIPS, because a
## site already at four cannot get worse and a caller must not have to know it.
static func aggravate_chance(force: float, current_pips: int) -> float

## Applies one blow. Returns a NEW dictionary and NEVER mutates `trauma` -
## the caller keeps the old one to compare against.
## `roll` is the caller's draw, 0.0..1.0: this module owns no RNG. The pip is
## added when `roll < aggravate_chance(force, current)`, and never otherwise.
## An unknown site or kind returns an unchanged copy.
static func aggravate(trauma: Dictionary, site: String, kind: String, force: float, roll: float) -> Dictionary

## The worst single mark on the face, which is what a broadcast names.
##   { "site": String, "kind": String, "pips": int }
## An unmarked face returns pips 0 and EMPTY STRINGS for site and kind.
## Ties break by the order of SITES, then by the order of KINDS, so the answer
## is stable and a test can predict it.
static func worst(trauma: Dictionary) -> Dictionary

## Every pip on the face added together. An unmarked face is 0.
static func total_pips(trauma: Dictionary) -> int

## The broadcast word for a pip count. EXACTLY these five strings:
##   0 -> ""   1 -> "NICK"   2 -> "CUT"   3 -> "BAD CUT"   4 -> "SEVERE"
## Out of range clamps into it; never returns anything else.
static func words(pips: int) -> String
```

**Do not add public functions beyond these.** Private helpers prefixed `_` are
fine and encouraged.

## The rules the contract has to keep

1. **`aggravate` is PURE.** It returns a new dictionary and leaves the one it
   was given untouched. This is the assertion most likely to catch a real
   defect, because a Dictionary in GDScript is a reference type and the
   obvious implementation mutates in place by accident.
2. **A pip is never lost and never skips.** One call adds at most one pip, to
   at most one site/kind. It never decreases.
3. **`MAX_PIPS` is a hard ceiling** reachable by repeated calls and never
   exceeded, and `aggravate_chance` is exactly 0.0 there.
4. **NAN and INF are safe on every float argument**, and resolve to the
   HARMLESS end — no pip added, chance 0.0. A broken number must never open a
   cut. (`is_nan()` and `is_inf()` are the GDScript tests.)
5. **Deterministic.** Same inputs, same output. The only randomness is the
   `roll` the caller hands you.
6. `severity`, `worst`, `total_pips` and `words` never throw on a malformed or
   empty dictionary — they return the empty answer.

## Owned files

| File | Note |
| --- | --- |
| `Godot/scripts/FightTrauma.gd` | **Yours. New. The only file you create.** |

Nothing else. **Do not write a test** — that is G32T. **Do not touch**
`HANDOFF.md`, any other script, or any digest.

## No parse gate, no test command, no repo commands

You have no checkout. Write the one file and hand it back. Claude splices it,
runs the parse gate and the real suite, and reports the result — you never poll
for it.

## GDScript traps that will cost you the pass

* `var x := <call>` **fails** when the call returns Variant — which
  `dictionary.get(...)` and `.size()` on an untyped value both do. Write the
  type: `var n: int = ...`, `var d: Dictionary = ...`.
* **Reusing a variable name inside one function is a parse error**, even
  across separate `if` or `for` blocks. Your loops over SITES and KINDS are
  exactly where this bites.
* `%` inside a format string must be `%%`.
* Use `.duplicate(true)` for the deep copy in `aggravate` — a shallow
  `.duplicate()` copies the outer dictionary but shares the per-site inner
  ones, so the "returns a new dictionary" rule would pass a naive check and
  still mutate the caller's data. This is the single likeliest defect in the
  file.

## The trap specific to this task

**Do not model healing, do not model bleeding, and do not touch
`head_neck`.** This module answers one question — how marked up is his face —
and nothing else. Recovery between rounds belongs to `ImpactModel`, which
already has it, and the continuous head condition is a separate channel that
R86 just finished. A module that quietly grows a second damage model is a
module we cannot wire in.

## When you are done

Hand back the complete contents of `Godot/scripts/FightTrauma.gd` and nothing
else — no test, no summary of the repo, no other file. One or two sentences on
what you chose for `aggravate_chance`'s shape and why is useful; a long essay
is not.
