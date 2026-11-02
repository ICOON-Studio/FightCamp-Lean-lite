# TASK G21 — GROK — IS THIS CHAMPION LATE? (grok)

Model: mid tier, effort **medium**, Fast off. One session.

A pure module and its test. **Zero preloads**, statics only, no node access, no
RNG, no file access, no `res://` path. You have no repository checkout and you
do not need one: build and test in a throwaway Godot 4.7 project holding only
your two files, exactly as G13, G15, G16, G17, G18, G19 and G20 were built.
Claude splices it, runs the real suite and writes your `HANDOFF.md` block.

Deliver exactly two files:

- `Godot/scripts/TitleTenure.gd`
- `Godot/tests/title_tenure_test.gd`

## Why this exists

The game can say how long a champion has held a belt (G15 `BeltLineage`). It
cannot say whether that champion is **late** — overdue a defence, or sat still
long enough that the belt should be at risk. Deciding the actual numbers is a
research call nobody has made yet, so **this module never authors one**: every
threshold arrives as an argument. You answer "given this window, where does this
champion stand", and the window comes from the caller.

## The contract — exact names, exact order, exact strings

An unseen test written from THIS section will call your module, so nothing here
is a suggestion.

```
static func tenure(belt: Dictionary, current_week: int, rules: Dictionary) -> Dictionary
```

`belt` may carry: `since_week` (int), `last_defended_week` (int), `defences`
(int), `title_status` (String). `rules` may carry: `defence_due_weeks` (int)
and `vacate_after_weeks` (int).

Returns EXACTLY these keys, always all of them:

```
ok                  bool    false when the inputs cannot answer the question
state               String  one of: current, due, overdue, vacatable, unknown
weeks_held          int     current_week - since_week, floored at 0
weeks_since_defence int     see below
weeks_until_due     int     0 when already due or later
weeks_until_vacate  int     0 when already vacatable
defences            int     passed through
unknown             Array   the names of the inputs that were missing or unusable
```

Rules, in this order:

1. `since_week` <= 0, or `current_week` <= 0, or `current_week < since_week`:
   `ok` false, `state` `"unknown"`, every number 0, and `unknown` names what was
   wrong — `"since_week"` and/or `"current_week"`.
2. **`weeks_since_defence` counts from the last defence, or from the day the
   belt was won when there has never been one.** A champion with `defences` 0
   has never defended whatever `last_defended_week` says — the engine stamps
   that field with the week the belt was WON — so in that case count from
   `since_week` and add `"last_defended_week"` to `unknown`.
3. `title_status` present and not `"champion"` and not `"held"`: `ok` true,
   `state` `"unknown"`, and `"title_status"` in `unknown`. A vacant or interim
   belt has no tenure to be late on.
4. With `defence_due_weeks` > 0: `state` is `"current"` while
   `weeks_since_defence` < it, and `"due"` at or past it. Missing or <= 0, add
   `"defence_due_weeks"` to `unknown` and never return `"due"`.
5. With `vacate_after_weeks` > 0 and `weeks_since_defence` >= it: `state` is
   `"vacatable"`, which outranks every other state. Missing or <= 0, add
   `"vacate_after_weeks"` to `unknown` and never return `"vacatable"`.
6. `"overdue"` is `"due"` plus at least double `defence_due_weeks`, and only
   when `vacate_after_weeks` did not already make it `"vacatable"`.
7. `weeks_until_due` / `weeks_until_vacate` are the remaining whole weeks,
   floored at 0, and are 0 whenever their threshold is missing.

Also:

```
static func words(read: Dictionary) -> String
```

Uppercase, no punctuation at the ends, exactly these forms:
`"CURRENT"`, `"DEFENCE DUE"`, `"OVERDUE BY N WEEKS"`, `"MAY BE VACATED"`,
`"NOT KNOWN"`. `N` is `weeks_since_defence` minus `defence_due_weeks`.

## Rules

- Statics only. No `class_name`. No `preload`. No `const` pointing at a path.
- Never invent a threshold. A missing rule is `unknown`, never a default of 8.
- Integer maths only; no floats in the output.
- The test must cover: a healthy champion, one exactly on the due week, one past
  it, one past the vacate line, a never-defended champion, a vacant belt, a
  belt with no rules at all, and bad inputs. Assert every returned key exists in
  every branch.

## Owned files

```
Godot/scripts/TitleTenure.gd
Godot/tests/title_tenure_test.gd
```

## Parse gate and test

You have no checkout, so there is no repository command for you. Build and run
your two files in a throwaway Godot 4.7 project; Claude runs the real suite
after splicing. Report the check count your own test prints.

## The one trap

**`last_defended_week` lies about a champion who has never defended.** The
engine stamps it with the week the belt was won and leaves `defences` at 0, so
reading the date alone makes every brand-new champion look freshly defended.
The count is the fact; the date only agrees once the count is above zero. This
exact bug shipped once already and was fixed on the board side — do not rebuild
it here.
