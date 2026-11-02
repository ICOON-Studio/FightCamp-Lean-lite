# TASK R36 — THE RANGE WALK (Claude)

**Status: COMPLETE** (2026-09-06). Model: top tier, effort high, Fast off.

Stage B of the distance system, greenlit with R35 as option B ("range, then
combos as range walks, then a corner range call"). Stage A (R35) shipped the
band; this stage makes the combination live on it and gives the corner three
words to argue about it. Reads K22 (`research/K22_RANGE_READ.md`).

## What shipped

### 1. The per-link range walk, and its abort point

A combination was already walking the band without anyone noticing: every
landed link runs `_apply_range_delta`, so a teep mid-chain resets the
distance and a shot ends it in the grip. What was missing was the
consequence. Now, before every link after the first:

- the band the link is about to be thrown at is recorded on the chain event
  (`range_from`, `range_walk[]`, `range_to`), and
- if that band is `GATE_BAND_DISTANCE` (two) or more from where the link
  lives, the chain **ABORTS**: `broken`, `broken_by = "range"`, `aborted`,
  `aborted_link`, `aborted_band`.

**An abort is deliberately not a miss.** Nothing flies, no stamina is spent
and — unlike a whiffed link — it leaves no `chain_exposure` behind. Pulling
a shot you cannot reach is the right read and the fight does not punish it
the way it punishes a whiff.

### 2. Chain ENTRY is gated on the first link

Found while testing, and a real bug: the draw gates the SEQUENCE node on its
own authored band, which is not always where its first link is thrown from.
`_resolve_chain` now checks the link that actually flies first and falls back
to a single action when it cannot reach, so a combination is never opened
with a shot that has no chance. Without this the abort fired on link 1 and
the chain threw nothing at all.

### 3. The corner range call (K22 section 6)

Three calls, corner voice, sitting BESIDE the PRESS-family emphasis rather
than replacing it: **STAY LONG → LONG**, **GET INSIDE → POCKET**, **TIE HIM
UP → CLINCH**. K22 ruled out a "hold MID" call — MID is the default and
coaching it says nothing.

- Offered only while the fight is standing, and never the call already
  standing.
- A heard call sets `corner["range_call"]` and `fighter["range_intent"]`,
  and **leaves pace and emphasis exactly where they were** — every other
  instruction keeps the old replace-both behaviour.
- `FightRange.contest` is now fought over `intent_band()` (the call when
  there is one, the fighter's own `preferred_band` otherwise). The call
  never rewrites `preferred_band`, so the comfort tax still measures a
  fighter against his own home band: being ordered inside does not make
  inside feel like home.
- It rides the ordinary listen roll, so a low-rapport fighter waves it off.

### 4. K22's log vocabulary

`FightRange.describe` says the bands by name — "at LONG", "in MID" — instead
of the soft R35 drafts, so a player reading LONG on the ladder hears LONG in
the log. POCKET and CLINCH keep the corner's own words.

## Files

- `Godot/scripts/FightRange.gd` — `CALL_BANDS`, `call_band`, `intent_band`,
  contest fought over intent, K22 vocabulary.
- `Godot/scripts/FightSimulation.gd` — `RANGE_CALL_OPTIONS`, the menu, the
  apply path, `range_intent` on the fighter, the entry gate and the abort.
- `Godot/tests/fight_combo_range_test.gd` (new) — 53 checks.
- `Godot/tests/fight_simulation_test.gd` — the unrestricted-menu count now
  separates the pace/emphasis half from the three range calls.

## Test

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_combo_range_test.gd
```

53/53. `fight_range_test.gd` 86/86, `fight_simulation_test.gd` 234/234,
`combo_chains_test.gd` and `smoke_test.gd` green, full suite green.

## Follow-up for whoever owns catalog accuracy (not fixed here)

Three sequences authored by C21 disagree with their own first link by two
full bands, which is what exposed the entry-gate bug. Per C21's own rule 4
("sequences get the band their FIRST link is thrown from") these are wrong:

| Sequence | Authored | First link | Its band |
| --- | --- | --- | --- |
| `mma_jab_levelchange` | LONG, MID | `mma_dirty_boxing` | CLINCH |
| `mma_doubleleg_mount` | MID | `mma_dirty_boxing` | CLINCH |
| `muay_thai_clinch_knees` | CLINCH | `muay_thai_straight_knee` | LONG, MID |

The engine no longer misbehaves on them — it falls back to a single action —
but until they are corrected those three combinations are effectively
unavailable at the band they are drawn from. Fixing them would remove the
premise of `_test_a_chain_is_never_opened_with_a_shot_that_cannot_reach`,
which would then need a synthetic fixture instead of a catalog one.

## Still open on the range system

M1 (Maria) has not landed: the range LADDER and owner chip that K22 specced
(section 1 and 2) are the visual half of this and are not built here. The
engine writes everything that reading needs — `range_band`, `range_owner`,
`range_event`, per-action `range_band`, and now the chain's `range_walk` —
so the panel is pure UI work once M1 rules how it looks. K22 also names one
engine gap this stage did NOT close: per-round dominant band and owner
tallies for the post-fight card.
