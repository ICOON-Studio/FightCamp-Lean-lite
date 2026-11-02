# TASK C64 — CODEX — THE KNOCKDOWN THAT CANNOT HAPPEN

**Model:** Sonnet 5 · medium effort · Fast off.

## The defect

`ImpactModel.is_flash_knockdown` is **mathematically unreachable**. It is your
own module (C63), and R83 found it the moment the core started building
through it: a whole fight, 947 impacts, **zero** flash knockdowns, and not
because the dice were cold.

Work the constants out (`Godot/scripts/ImpactModel.gd:43-58`):

```
shock_chance, head:  HEAD_SHOCK_BASE * force^2 * (1 + head_wear)
                     max = 0.08 * 1.0 * (1 + 1.0)          = 0.16
shock_chance, torso: LIVER_SHOCK_BASE * force^2
                     max = 0.04 * 1.0                      = 0.04
is_flash_knockdown:  shock >= FLASH_SHOCK_FLOOR            = 0.25
```

0.16 < 0.25, so the head branch can never clear the bar. 0.04 < 0.25, so the
body branch cannot either. **`is_flash_knockdown` returns `false` for every
input `shock_chance` is capable of producing.**

It is worse than the bare numbers suggest, and this is the part to design
against rather than patch around. The head's 0.16 ceiling is only reached
against a head at **0.0** — a destroyed man. But `is_flash_knockdown` also
demands `head_neck_remaining >= FLASH_HEALTHY_HEAD_FLOOR` (80.0), and at
exactly 80 remaining the shock ceiling is `0.08 * 1.0 * 1.2 = 0.096`. The two
conditions move in **opposite directions**: everything that raises the shock
lowers the head condition the flash rule insists on. Closing the gap only at
the maximum would still leave the feature dead across the whole realistic
middle of a fight.

Two constants are dead for the same reason and should stop lying:
`HEAD_SHOCK_MAX` (0.45, real ceiling 0.16) and `LIVER_SHOCK_MAX` (0.20, real
ceiling 0.04) are `clampf` bounds that nothing can ever reach.

## What U20 asked for

A flash knockdown is the **recovered** knockdown — he goes down, he gets up,
the fight continues. It is meant to be *rare but real* against a **healthy**
head; that is the whole point of the `>= 80` gate, and it is why the fix is
not simply "delete the healthy-head condition".

## The job

Retune so that a flash knockdown is reachable and rare against a healthy head,
and keep every other guarantee C63's 33 checks already make. **The shape of
the fix is yours** — you own the balance here — but it must satisfy:

1. A clean head impact at high force against a head at 100.0 has a **non-zero**
   flash-knockdown probability.
2. It stays **rare**: over a full R83 fight (~950 impacts, ~250 clean, of which
   roughly half are head) the expected count is single digits, not dozens.
3. Danger still **rises** as the head wears — that is U20's core rule and R83
   depends on it.
4. `HEAD_SHOCK_MAX` and `LIVER_SHOCK_MAX` either become reachable or are
   removed. A `clampf` bound that cannot be hit is a comment pretending to be
   code.
5. `shock_chance` still returns 0.0 for anything that is not a `clean` contact,
   and for a `clean` limb shot.

Raising `HEAD_SHOCK_BASE`, lowering `FLASH_SHOCK_FLOOR`, or reworking how the
two gates compose are all acceptable. Say in the digest which you chose **and
what the resulting per-fight rate is** — a number, not an adjective.

## The trap

**Do not test this by asserting a probability against a magic number.** The
defect got through 33 passing checks precisely because every one of them
tested a function in isolation and none asked whether the pieces could ever
line up. Add at least one check that composes them the way the engine does:
feed `shock_chance`'s **own output** into `is_flash_knockdown` and assert the
pair can produce `true` for a plausible impact — and that it does so for a
healthy head, not only a destroyed one. A test that never crosses the seam
between two functions is how this survived a stage.

## Owned files

- `Godot/scripts/ImpactModel.gd`
- `Godot/tests/impact_model_test.gd`
- `research/C64_DIGEST.md` — new.

**Do NOT touch `Godot/scripts/FightRealtime.gd`.** Claude owns it for R84, and
it consumes your module through `make_impact` / `wear_from` / `shock_chance` /
`is_flash_knockdown` — those four signatures are a **contract and must not
change**. Constants inside them are yours; names and argument orders are not.
`FightSimulation.gd` stays untouched under the rebaseline ruling.

## Why this is blocking

**R84 (scoring, stoppage and result) cannot start until this lands.** Stoppage
reads knockdowns, and right now the engine cannot produce one. `RoundScoring`
already weights `knockdowns_round`, so a permanently-zero knockdown count
would quietly bias every scorecard the rebaseline (R85) is about to pin as the
new ground truth.

## Parse gate, then tests

```
python Godot/tools/check_scripts.py Godot/scripts/ImpactModel.gd Godot/tests/impact_model_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/impact_model_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_realtime_test.gd
```

Run `fight_realtime_test.gd` too — it is the consumer, it is not yours to
edit, and it must stay green. Its seeded-replay gate will shift its *content*
(different shock rolls, different fights) but must still pass: R83's
assertions are about self-consistency, not about pinned values.

## Gate

`python Godot/tools/run_tests.py` → **`fails=0` or better.** It reads
`total=199 fails=0` at `e2bb15f`. If it comes back red, check
`tasklist | grep -ci godot` and re-run any failure alone before believing it —
Q16 (the suite's concurrency defect) has not landed yet.
