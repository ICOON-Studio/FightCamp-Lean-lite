# TASK U57 — CURSOR — WHAT THE GROUND FIGHT IS WORTH ON SCREEN

Model: Composer, **medium effort**. Owner: cursor.
Test tier: **MEASUREMENT — one new tool, one report, NO shipped `.gd` edited.**
Parse gate the tool, run it, write the report. **Do NOT run the full suite**; it
is Claude's, once, at integration. **Only one Godot at a time in this checkout.**

```
python Godot/tools/check_scripts.py Godot/tools/measure_grapple_promotion.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/measure_grapple_promotion.gd
```

## Owned files

- `Godot/tools/measure_grapple_promotion.gd` — **NEW. Yours alone.**
- `research/U57_GRAPPLE_PROMOTION.md` — **NEW. Yours alone.**

Nothing else. **Do NOT edit `FightBeatAdapter.gd`** — this task prices a rule, it
does not apply one. Do not edit any test, any script in `Godot/scripts/`, or
`HANDOFF.md`.

## Why this exists

R112 rung 1 landed at `bb2d75c`: `FightBeatAdapter` now turns every grapple event
in a beat window into a grapple beat, in the engine's own words, and carries them
on the beat's `grapple` array. Pass `grapple_beats: true` in the options to turn
it on; it is off by default.

**AND THE FIRST MEASUREMENT OF IT FOUND THE PROBLEM THIS TASK EXISTS TO PRICE.**
Over twelve seeded MMA bouts:

```
log_grapple=436   carried=436   promoted=1   actions=450   displaced=0
```

Every one of the 436 events reaches the stream on the array — that part works.
But **only ONE ever became the presented beat**, because rung 1 gives a grapple
the beat slot only when the window has NO strike candidate at all, and a
14-second window in an MMA bout almost always has one.

That rule is deliberate and its safety half is correct: **a grapple can never
displace a strike the choosing rule already picked.** It is the same "in
remainder" construction `promote_in_remainder_4` uses for the defence.

**But the operator's stage is "i want to see as many animations as possible" and
"make the fighters intelligent — in what you can SEE." A ground game that owns
the beat slot once in twelve bouts is not that.** So the question is whether a
significant grapple should be allowed to take the slot from an ordinary strike,
and on what cadence.

**THAT IS A PRODUCT RULING AND IT IS THE OPERATOR'S TO MAKE. Your job is to price
it so they can make it on numbers, exactly as U48 and U49 priced the defence
promotion before the 2026-09-11 ruling.** Do not pick a winner yourself; rank
them and say what each costs.

## The job

### Read first, and only these

- `Godot/scripts/FightBeatAdapter.gd` — **1,000+ lines, do NOT read it whole.**
  Read `sed -n '160,300p'` for the rung-1 constants and the defence ruling note,
  `sed -n '470,545p'` for `advance_beat`, and `sed -n '820,980p'` for
  `_grapple_beat` / `_grapple_lead` / `_present_grapple`.
- `Godot/tests/fight_beat_defence_test.gd` — **the shape of the answer.** U48/U49
  measured six rules on identical captured windows; this is the same job for the
  floor. Read its PART 2 and copy the discipline.
- `Godot/tools/measure_choose_rules.gd` — the existing tool that prices choosing
  rules. **Copy it rather than starting over.**
- `GameState.gd` is 12,938 lines. You do not need it. Never open it.

### The rules to price

Measure at least these five, on **identical seeded bouts**, across **`mma` and
`bjj`** (boxing has no ground game and will tell you nothing):

| rule | what it does |
|---|---|
| `off` | today's default — no grapple beats at all. The baseline. |
| `remainder_only` | today's rung-1 rule — grapple takes the slot only in a strike-free window. |
| `significant_wins` | a grapple beat with `significant == true` takes the slot over any strike that is not a knockdown or a `shocked` blow. |
| `significant_in_remainder_4` | the same, but only every 4th eligible window — the defence rule's exact shape. |
| `significant_in_remainder_2` | as above, every 2nd. |

**`significant` is already computed on every grapple beat** (a finished
submission, a reversal, a sweep, or `grade >= 2`). Read it; do not redefine it.

### What to report, per rule and per ruleset

1. **Grapple beats presented**, absolute and as a percentage of all presented
   beats.
2. **Strikes lost** — how many `clean` beats stopped being shown.
3. **KNOCKDOWNS LOST. This must be ZERO for any rule worth shipping**, and the
   defence rule achieves zero BY CONSTRUCTION rather than by luck. Say for each
   rule whether its zero is structural or merely observed in your sample.
4. **Which grapple techniques reach the screen**, counted by the exact
   `technique` string — `grapple_takedown`, `grapple_sweep`, and so on. **Count
   the `technique` field, never `technique_name`**: the first is what
   `_clip_role_for` resolves and the second is only the callout. R103 shipped a
   presenter reporting `strike_head` while the player held `jab`, and a green
   suite agreed with itself throughout.
5. **THE VERDICTS MUST NOT MOVE.** Every rule here chooses which already-built
   event is SHOWN. None draws an RNG or consumes a tick, so every rule must
   return byte-identical verdicts, scorecards and stoppages against `off`.
   **Assert that and report it as a pass/fail column** — if any rule moves a
   verdict, that is a bug in rung 1 and it is the most important thing in your
   report.

### The deliverable

`research/U57_GRAPPLE_PROMOTION.md`:

1. **Method** — the exact invocation, seeds, bout count, rulesets.
2. **The table**, one row per rule per ruleset, with the five columns above.
3. **A ranking with the cost of each**, in the U48/U49 voice: what it buys on
   screen and what it costs in strikes shown. **No recommendation of a single
   winner** — the operator rules.
4. **The one number that decides it**, stated plainly: how many grapple beats per
   bout each rule puts on screen.

## Definition of done

- Both files exist; the tool runs headless and prints a machine-readable summary.
- Verdict-stability is asserted, not assumed, and reported.
- Commit and push. **You push to a branch; SAY WHICH BRANCH** in your report.
- One line back:
  `python Tools/agent_comms.py send --from cursor --to claude --subject U57-done --body "<sha> branch=<name> rules=5 best_pct=<x> knockdowns_lost=<n> verdicts_moved=<n>"`
- Do NOT edit `HANDOFF.md` — Claude writes your block.

## The traps specific to U57

1. **A BOUT WITH NO GROUND GAME MEASURES NOTHING.** Use a high-`grapple` fighter
   against a low-`defense`, low-`grapple` one, and CHECK that your bouts actually
   produce grapple events before you report a percentage. `fight_beat_grapple_test`
   uses `r1_grappler` vs `r1_striker` and gets 436 events over 12 bouts — borrow
   those stat blocks.
2. **`grapple_beats` IS AN OPTION ON `begin`, NOT A GLOBAL.** Pass it in the
   options dict. Two runs in one process must not share a counter — rung 1 keeps
   its state in `state` for exactly the reason the defence cadence does.
3. **DO NOT GATE YOUR REPORT ON AN EXACT COUNT.** Report what you measure. If a
   rule turns out better than the task file implies, say so — over-delivery must
   never be trapped by its own spec.
4. **`var x := <call>` fails when the call returns Variant.** Write the type:
   `var n: int = ...`. You cannot reuse a variable name inside one function even
   across separate `if`/`for` blocks — that is a parse error, and a parse error
   does not fail a headless run, it HANGS it until the timeout.
