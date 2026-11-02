# TASK Q8T - QWEN - THE TEST FOR A FIGHTING SURFACE'S WORDS

Model: Qwen3.8-Max, effort high. One session.
Runs in parallel with Q8. Do not wait for it, and do not ask to see it.

You have no repository and you do not need one. This file is complete.

## ONE FILE. THE TEST. DO NOT SEND THE MODULE.

Send `Godot/tests/surface_words_test.gd` and nothing else.

If you find yourself writing `SurfaceWords.gd`, stop: that is someone else's
task and your copy would be discarded.

## Owned files

```
Godot/tests/surface_words_test.gd
```

## Why you are not shown the implementation

A test written against an implementation only ever agrees with it. This one is
written from the SAME contract the module's author was given, reproduced below
in full, so that where the two disagree the disagreement is real. On the Q5
pair this arrangement caught two real faults within a minute of the module
arriving; on Q7 the two halves agreed outright at 41 checks.

## The subject

`Godot/scripts/SurfaceWords.gd`, `extends RefCounted`, statics only, no
preloads. It turns a fighting surface into the words a player reads. It never
names a discipline - labels arrive already resolved and are used verbatim - and
it never prints an internal grade.

## THE SEPARATOR - read this before anything else

House style is CAPITALS, and the separator between two parts of a line is:

    space, MIDDLE DOT, space

The middle dot is Unicode U+00B7 (decimal 183), the character named MIDDLE DOT.
It is NOT a hyphen, NOT a bullet U+2022, NOT a period, NOT an asterisk.

Do not type that character by hand and do not trust it to survive a copy and
paste. Build it from its code point instead, which is exact and cannot be
mangled. Put this helper in your test and use it to compose every expected
string that contains a separator:

    static func _sep() -> String:
        return " " + char(183) + " "

`char(183)` is a Godot global function and returns the single MIDDLE DOT
character, so `_sep()` is the three-character string: space, U+00B7, space.

So the expected value for a composed line is written like this, never as a
pasted literal:

    var expected: String = "BOXING" + _sep() + "FOUGHT IN A RING"

The module's author was given the same instruction, so both sides build the
separator the same way and a mangled paste cannot make the pair disagree over
a character neither of them chose.

Below, wherever the contract shows a composed string, the three letters SEP
stand for that separator. `"ALSO LAWFUL" SEP "RING"` means the concatenation
`"ALSO LAWFUL" + _sep() + "RING"`.

## The contract you test against

"empty" below always means the zero-length String `""`.

### `surface_label(kind: String) -> String`

- `"ring"` returns `RING`
- `"cage"` returns `CAGE`
- `"mat"` returns `MAT`
- anything else, the empty String included, returns the empty String

### `fought_on(kind: String) -> String`

- `"ring"` returns `FOUGHT IN A RING`
- `"cage"` returns `FOUGHT IN A CAGE`
- `"mat"` returns `FOUGHT ON A MAT`
- anything else returns the empty String

THE PREPOSITION CHANGES WITH THE SURFACE: a fighter is IN a ring and a cage,
and ON a mat.

### `surface_line(discipline_label: String, kind: String) -> String`

- Returns the empty String when either argument is empty, or when `kind` is
  not one of the three.
- Otherwise returns `discipline_label` SEP `fought_on(kind)`.

### `borrowed_line(surface_label_words: String) -> String`

- Returns the empty String when the argument is empty.
- Otherwise returns `"NO OFFICIAL SURFACE PUBLISHED"` SEP
  `"USING A "` followed immediately by `surface_label_words`.

Note the single space between `USING A` and the words, and no trailing space.

### `no_surface_line() -> String`

Takes nothing. Returns exactly:

    NO SURFACE ON RECORD FOR THIS SPORT

### `alternate_line(surface_label_words: String) -> String`

- Returns the empty String when the argument is empty.
- Otherwise returns `"ALSO LAWFUL"` SEP `surface_label_words`.

### `span_line(metres: float) -> String`

- Returns the empty String when `metres` is not above `0.0`. Zero and every
  negative value are empty.
- Otherwise the number to ONE decimal place, then a space, a capital M, a
  space, and the word ACROSS. One decimal always, even for a whole number.

Every function returns the empty String rather than a placeholder. There is no
`NONE`, no dash, no `N/A`, no `TBD`. `no_surface_line()` is the single
exception and exists precisely to say the record is empty.

## The shape every test in this project has

```gdscript
extends SceneTree
## Q8T: SurfaceWords, pure. A surface in, English out. No career, save or
## GameState. What this file really guards: the preposition, the one decimal,
## and a refusal that never becomes an empty ring.

var failures := 0


func _initialize() -> void:
    var W = load("res://scripts/SurfaceWords.gd")
    _test_the_three_surfaces(W)
    # ... your groups ...
    print("Q8T surface words: %d failure(s)" % failures)
    quit(1 if failures > 0 else 0)


func _check(condition: bool, message: String) -> void:
    if condition:
        print("OK: ", message)
    else:
        print("FAIL: ", message)
        failures += 1


static func _sep() -> String:
    return " " + char(183) + " "
```

`load()` inside `_initialize()`, never a top-level `preload`. Group the checks
into `_test_*(W)` functions: one flat function of fifty checks is a file
nobody can read a failure out of.

## What your test must catch

Compare every expected string with `==`, never `contains`. The separators and
the preposition are the whole point.

1. All three kinds through `surface_label` and `fought_on`, full-string.

2. THE PREPOSITION. Assert `fought_on("mat")` ends in `ON A MAT`, and that
   `fought_on("ring")` and `fought_on("cage")` do NOT contain `ON A`. A module
   that pastes one preposition for all three passes every other check here.

3. Junk kinds: the empty String, `"RING"` in upper case, `"rings"`,
   `"octagon"`, `"tatami"`. Every one returns the empty String from both
   `surface_label` and `fought_on`. Assert they ARE empty, not merely that
   they are not the right word.

4. `surface_line` with both arguments good; with an empty label; with an empty
   kind; with a bad kind and a good label. Only the first returns anything.

5. The composed exact string: `surface_line("BOXING", "ring")` equals
   `"BOXING" + _sep() + "FOUGHT IN A RING"`.

6. `borrowed_line("MAT")` equals
   `"NO OFFICIAL SURFACE PUBLISHED" + _sep() + "USING A MAT"`, and
   `borrowed_line("")` is empty.

7. `no_surface_line()` is exactly `NO SURFACE ON RECORD FOR THIS SPORT`, and
   it is NOT empty. This is the one function that must never return the empty
   String.

8. `alternate_line("RING")` equals `"ALSO LAWFUL" + _sep() + "RING"`, and
   `alternate_line("")` is empty.

9. `span_line` AND THE ONE DECIMAL. `6.096` gives `6.1 M ACROSS`; `12.0` gives
   `12.0 M ACROSS` (assert it is NOT `12 M ACROSS`); `0.0` gives the empty
   String; `-3.0` gives the empty String; `9.0` gives `9.0 M ACROSS`; `5.4864`
   gives `5.5 M ACROSS`, because it rounds.

10. NO GRADE WORD EVER REACHES A PLAYER. Run every function above through a
    sample of inputs and assert that no returned string anywhere contains
    `DIRECT`, `INHERITED`, `UNKNOWN`, `GRADE`, `SOURCED` or `TBD`.

11. NO VERDICT. Assert nothing returned contains `PROPER`, `REAL`, `FAKE`,
    `CHEAP`, `BEST` or `WRONG`. The words say what the surface is and stop.

Around 40 checks. Do not stop at the first failure: count them all and print
the total, so one bad string does not hide six others.

## GDScript traps

- A literal `%` inside a format string must be doubled to `%%`. You need a
  single real `%` only as the format operator itself.
- Reusing one variable name twice inside a single function is a parse error,
  even in two separate `if` blocks.
- `var n := arr.size()` on an untyped value infers Variant. Write
  `var n: int = ...`.
- A missing static on the module raises at call time. That is a real failure to
  report, not something to guard around with `has_method`.
- Tabs and spaces cannot be mixed for indentation in one file. Pick one.

## Done means

One file, `surface_words_test.gd`, sent as a file. No module, no repository
command, no `HANDOFF.md`. Claude runs it against the delivered module and
reports which side was wrong.
