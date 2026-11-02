# TASK Q8 - QWEN - THE WORDS FOR A FIGHTING SURFACE

Model: Qwen3.8-Max, effort high. One session. Runs after Q7.
Its test is TASK Q8T, a separate task. You are not asked for one.

You have no repository and you do not need one. This file is complete.
Build it in a throwaway Godot 4.7 project holding only your one file.

## ONE FILE. THE MODULE. DO NOT SEND A TEST.

Send `SurfaceWords.gd` and nothing else.

The test is TASK Q8T, its own task with its own author, written from THIS
file's contract rather than from your code. So the API below is a contract:
exact names, exact argument order, exact strings, exact separators. A test you
will never see will compare them with `==`.

Q7 was the first pair where both halves arrived and agreed outright: 41
checks, 0 failures. Same shape of job.

## Owned files

```
Godot/scripts/SurfaceWords.gd
```

## Why this exists

A bout is fought on one of three surfaces, and which one is decided by the
discipline on the card: boxing and kickboxing in a ring, MMA in a cage, judo
and karate and wrestling on a mat. A module already makes that decision and
returns ids. Two sports are deliberately refused - nobody published a surface
for them and the game will not invent one - and four more are answered by
borrowing the nearest sport that does publish one.

Every one of those four states needs words, and the borrowing and the refusal
need words that are honest without being technical. You ship them.

## THE SEPARATOR - read this before anything else

House style is CAPITALS, and the separator between two parts of a line is:

    space, MIDDLE DOT, space

The middle dot is Unicode U+00B7 (decimal 183), the character named MIDDLE DOT.
It is NOT a hyphen, NOT a bullet U+2022, NOT a period, NOT an asterisk.

Do not type that character by hand and do not trust it to survive a copy and
paste. Build it from its code point instead, which is exact and cannot be
mangled. Put this helper in the file and call it everywhere:

    static func _sep() -> String:
        return " " + char(183) + " "

`char(183)` is a Godot global function and returns the single MIDDLE DOT
character, so `_sep()` is the three-character string: space, U+00B7, space.
Every composed line below uses exactly that and nothing else. (It has to be a
function, not a `const`: a `const` may only hold a compile-time constant
expression, and a call to `char()` is not one.)

## What you must NOT do

- Never name a discipline. You do not know how this game spells `muay_thai` or
  what it calls it on screen. Every function takes a label the caller has
  already resolved and uses it verbatim: never re-cased, never trimmed.
- Never decide which surface a sport uses. You are given the answer.
- Never print a grade. `DIRECT`, `INHERITED` and `UNKNOWN` are internal
  bookkeeping and a player must never read one. You turn them into English.
- No preload, no `res://`, no node, no autoload, no RNG, no file access.
  Statics only, `extends RefCounted`.
- No `he`, `she`, `his` or `her`. Both sexes fight in this game.

## The contract

Seven static functions. "empty" below always means the zero-length String `""`.

### 1. `static func surface_label(kind: String) -> String`

- `kind` is `"ring"`: return `RING`
- `kind` is `"cage"`: return `CAGE`
- `kind` is `"mat"`: return `MAT`
- anything else, the empty String included: return the empty String

### 2. `static func fought_on(kind: String) -> String`

The sentence a card prints.

- `kind` is `"ring"`: return `FOUGHT IN A RING`
- `kind` is `"cage"`: return `FOUGHT IN A CAGE`
- `kind` is `"mat"`: return `FOUGHT ON A MAT`
- anything else: return the empty String

The preposition changes with the surface and that is the point of the function:
a fighter is IN a ring and a cage, and ON a mat.

### 3. `static func surface_line(discipline_label: String, kind: String) -> String`

- Return the empty String when either argument is empty, or when `kind` is not
  one of the three.
- Otherwise return `discipline_label + _sep() + fought_on(kind)`.

Worked example. `surface_line("BOXING", "ring")` returns the string that reads:

    BOXING, space, middle dot, space, FOUGHT IN A RING

### 4. `static func borrowed_line(surface_label_words: String) -> String`

For a sport whose surface was taken from another sport because its own
governing body publishes none. The caller passes the words for the SURFACE, not
the sport it was borrowed from.

- Return the empty String when the argument is empty.
- Otherwise return `"NO OFFICIAL SURFACE PUBLISHED" + _sep() + "USING A " + surface_label_words`.

So `borrowed_line("MAT")` reads:

    NO OFFICIAL SURFACE PUBLISHED, space, middle dot, space, USING A MAT

Note the single space between `USING A` and the words, and that there is no
trailing space.

### 5. `static func no_surface_line() -> String`

The refusal, for a sport with no sourced surface at all. Takes nothing and
returns exactly:

    NO SURFACE ON RECORD FOR THIS SPORT

It is not `UNKNOWN`, not `NONE`, not `TBD`, and it never becomes an empty ring.

### 6. `static func alternate_line(surface_label_words: String) -> String`

One sport's own rulebook publishes TWO lawful surfaces. This names the one not
in use, so the choice stays visible.

- Return the empty String when the argument is empty.
- Otherwise return `"ALSO LAWFUL" + _sep() + surface_label_words`.

So `alternate_line("RING")` reads:

    ALSO LAWFUL, space, middle dot, space, RING

### 7. `static func span_line(metres: float) -> String`

How far across the surface is, for a caption.

- Return the empty String when `metres` is not above `0.0`. Zero and every
  negative value are empty.
- Otherwise return the number to ONE decimal place, then a space, a capital M,
  a space, and the word ACROSS. In full: `"%.1f" % metres + " M ACROSS"`.

So `span_line(6.096)` is `6.1 M ACROSS`, `span_line(12.0)` is `12.0 M ACROSS`,
`span_line(5.4864)` is `5.5 M ACROSS`, and `span_line(0.0)` is the empty
String. ONE DECIMAL ALWAYS, even for a whole number: `12.0`, never `12`.

## Every function returns the empty String rather than a fallback

There is no `"NONE"`, no dash, no placeholder. An empty String is how the
caller learns there is nothing to print, and a cheerful default would be drawn
on a screen as though it were a fact. The one exception is `no_surface_line()`,
which exists precisely to say the record is empty.

## GDScript traps

- A literal `%` inside a format string must be doubled to `%%`. You need a
  single real `%` only as the format operator itself.
- Reusing one variable name twice inside a single function is a parse error,
  even in two separate `if` blocks.
- `var s := some_call()` can infer Variant. Write `var s: String = ...`.
- One decimal place is `"%.1f"`, and it rounds: `6.096` becomes `6.1`.
- Tabs and spaces cannot be mixed for indentation in one file. Pick one.

## Done means

One file, `SurfaceWords.gd`, sent as a file. No test, no repository command, no
`HANDOFF.md`. If any line of the contract above seems wrong, say so in one line
and ship it as written anyway - the test is being built from the same contract.
