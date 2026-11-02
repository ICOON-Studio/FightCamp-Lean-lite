# TASK G40 — GROK — `JudoBoard.gd`: THE CONTEST BOARD THAT ENDS A JUDO FIGHT

Model: **Grok, Expert tier.** Owner: Grok. Assigned 2026-09-10 by Claude.
**Pure module. ZERO preloads. One file. Do not write a test — G40T is a
separate task and someone else writes it from this same contract, blind.**

You have no checkout and no Godot. You are not asked to run anything. Paste
the finished file back in the chat and Claude commits it verbatim.

---

## Why this exists

R92 and R93 gave the fight engine a grappling adapter: a throw that lands in
judo now comes back as **yuko** or **waza-ari**, per landing seat, per your
own G39 §7.2. A submission comes back as **ippon**.

**Nothing accumulates them, and nothing ends the contest.** The engine ends a
bout by KO, TKO, doctor's stoppage, submission or decision — five endings
borrowed from MMA and boxing. A judo contest does not end that way. It ends on
an ippon, on two waza-ari combined, or on a third shido, and if it ends level
it goes to golden score. Today none of that exists anywhere in the game.

That is what you are writing: the **board**, and only the board. It knows
nothing about our engine, takes no fighter, reads no clock, and has no
preload. It is a pure function of the awards it has been handed.

## Your sources

Your own **G39 §3** is the starting point (it cites IJF SOR Version
14.08.2026, Arts. 14, 15, 18.1.1.2, 18.1.1.4, 18.1.2.15, 18.1.2.25, and the
osaekomi 5 / 10 / 20 table). **It does not cover everything this module
needs** — it was written about the clinch. You will have to read the current
IJF Sport and Organisation Rules for the contest-ending arithmetic:

- Does **waza-ari awasete ippon** apply in the current cycle? Two waza-ari
  combined into ippon; this rule was removed in one cycle and restored in
  another, so **cite the edition and article for whichever answer is current**.
- Does **yuko** accumulate into anything? Three yuko is not a waza-ari in any
  modern cycle, but say so with the article rather than from memory.
- **Shido**: how many before hansoku-make, does a shido score for the
  opponent, and does a shido decide a contest that is otherwise level at the
  end of regulation?
- **Hansoku-make**: direct, and by accumulated shido — is the consequence the
  same for the contest result?
- **Golden score**: what starts it, what ends it, and does a score in golden
  score win regardless of what stood at regulation time?

**Where the current book is silent, the answer is `NONE PUBLISHED` and the
behaviour is a documented refusal, exactly as G34–G39 did it.** Cite edition
and article on every rule you encode, in a comment above the code that
implements it. That citation discipline is why your research has been trusted
here, and this module carries the same bar.

## THE CONTRACT — exact names, argument order, strings

An unseen test will be written from this section alone, by another agent who
will never read your file. **Every name, every argument order, every string
literal below is binding.** If you think one is wrong, implement it as written
and say so in your notes.

```gdscript
# JudoBoard.gd — statics only, ZERO preloads.
extends RefCounted

const AWARDS := ["ippon", "waza_ari", "yuko", "shido", "hansoku_make"]

static func fresh() -> Dictionary
static func apply(board: Dictionary, side: String, award: String) -> Dictionary
static func decide(board: Dictionary) -> Dictionary
static func result(board: Dictionary) -> Dictionary
static func score_line(board: Dictionary, side: String) -> String
static func reasons() -> Array
```

### `fresh() -> Dictionary`

```gdscript
{
  "a": {"waza_ari": 0, "yuko": 0, "shido": 0},
  "b": {"waza_ari": 0, "yuko": 0, "shido": 0},
  "over": false,
  "winner": "",              # "a", "b", or "" while undecided
  "reason": "",              # one of reasons(), "" while undecided
  "golden_score": false,
}
```

Exactly those keys, exactly those spellings, in that nesting.

### `apply(board, side, award) -> Dictionary`

- Returns a **NEW** dictionary. **It must never mutate the board it was
  given** — the caller keeps the old board, and a test will check that the
  input is unchanged after the call. In GDScript a `Dictionary` is a
  reference type and `duplicate()` is shallow, so a nested per-side dictionary
  needs its own copy. This is the single most likely defect in the file.
- `side` is `"a"` or `"b"`. Any other value returns the board unchanged.
- `award` is one of `AWARDS`. Any other value returns the board unchanged.
- Applying an award to a board whose `over` is already `true` returns it
  unchanged. A finished contest cannot be scored on.
- An `"ippon"` ends the contest to that side.
- Everything else follows the rules you sourced above.

### `decide(board) -> Dictionary`

Called **once, when regulation time expires.** Returns a new board. Either it
is decided (`over` true, `winner` and `reason` set) or the contest is level
and it returns `golden_score: true` with `over` still false. Calling `decide`
on a board that is already `over` returns it unchanged.

### `result(board) -> Dictionary`

`{"over": bool, "winner": String, "reason": String}` — a read-only view, no
computation, no side effects.

### `score_line(board, side) -> String`

The board as a viewer reads it: waza-ari, yuko and shido counts, in that
order, each printed as a single upper-case letter followed by its count,
joined with **one space**, **omitting any count that is zero**.

- `W` for waza-ari, `Y` for yuko, `S` for shido.
- waza_ari 1, yuko 0, shido 2 → `"W1 S2"`
- waza_ari 0, yuko 3, shido 0 → `"Y3"`
- everything zero → `"-"` (a single hyphen, not an empty string)
- an unknown `side` → `"-"`

### `reasons() -> Array`

Every string `reason` can hold, so a caller can switch on them exhaustively.
**This exact list, this order:**

```gdscript
["ippon", "waza_ari_awasete_ippon", "hansoku_make_shido",
 "hansoku_make_direct", "waza_ari", "yuko", "golden_score"]
```

`""` is not in the list — it is the absence of a reason, not a reason.

If your reading of the rules says one of these can never occur, **still return
the full list** and say which one is dead and why in your notes. A list that
changes shape breaks the unseen test for a reason that has nothing to do with
judo.

## Constraints — these are the ones that get broken

1. **ZERO preloads, zero `load()`, zero autoload references.** No
   `GameState`, no `UIKit`, no `UITokens`, no `preload("res://...")` of any
   kind. The file must be droppable into an empty Godot project with nothing
   else in it. Every previous pure module that reached for one preload cost a
   round trip.
2. **Statics only.** Every function is `static func`. No member variables, no
   `_init`, no state held in the file.
3. **No `class_name`.** Callers do `preload("res://scripts/JudoBoard.gd")`.
4. `var x := <call>` **fails to parse** in GDScript when the call returns
   Variant — anything off `.get()` or `.size()` on an untyped value. Write the
   type: `var n: int = int(d.get("yuko", 0))`. This is the most common parse
   failure in this project and it hangs a headless test rather than failing it.
5. A `%` inside a format string must be `%%`.
6. Reusing a variable name inside one function is a parse error in GDScript,
   **even across separate `if` or `for` blocks.**
7. Comment in the house voice: what the rule is, which article it comes from,
   and what is refused. Mark anything you had to author with **AUTHORED** or
   **INV** and say why the book left it open.

## Owned files

* `Godot/scripts/JudoBoard.gd` — NEW, and the ONLY file this task produces.
  Grok has no checkout; Claude commits what Grok pastes. No test — `G40T` is
  its own task, written blind from the same contract.

## Deliverable

**One file: `Godot/scripts/JudoBoard.gd`.** Paste it complete in the chat, in
one fenced GDScript block, top to bottom, no ellipses and no "unchanged
above" — Claude commits exactly what you paste.

Then, **outside** the code block, in at most fifteen lines:

- the editions and articles you used, one line each;
- anything you had to author because the book is silent;
- any disagreement you have with this contract, which stays a note and never a
  change to the names above.

**Do not write a test.** `G40T` is its own task, written from this contract by
an agent who will not see your file. That split is deliberate: a test written
against an implementation only agrees with it. It has found real defects four
times on this arc.

## The trap specific to this task

**`apply` mutating its argument.** Dictionaries are references in GDScript and
`duplicate()` copies only the top level, so the obvious implementation hands
back a "new" board whose `a` and `b` are the same two dictionaries the caller
still holds — and every historical board in the caller's hands silently
becomes the current one. It passes every test that only ever looks at the
latest board, which is most of them. Copy both nested sides explicitly.

**Second trap: waza-ari awasete ippon is a rule you must look up, not recall.**
It has been true, then false, then true again across cycles. Whichever the
current SOR says, cite the article next to the code.
