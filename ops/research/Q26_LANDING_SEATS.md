# Q26 — The throw that can only ever land in two places

**One sentence:** the landing seat is an ENGINE invention; every major
rulebook is silent on where the thrower ends up, and the engine's one line
of seat assignment (`GrappleResolve.gd:53`) reaches only `side` and `guard`,
leaving `mount`, `back` and `half` permanently unreachable from a throw.

---

## 1. What the engine can and cannot say today — with anchors

### The line

```gdscript
# GrappleResolve.gd:53
var to_seat: String = "side" if grade == 4 else "guard"
```

A throw's landing seat is a pure function of its grade. Grade 4 → `side`,
grade 2 → `guard`. No other seat is ever written. Both the standing shot
(`FightRealtime.gd:1576-1591`, `from_stance = "standing"`) and the clinch
throw (`FightRealtime.gd:1660-1683`, `from_stance = "clinch"`) call the same
`takedown_resolve` and read the same `to_seat`.

### Seat × event reachability

Built from `GrappleResolve.takedown_resolve` (:40-55),
`GrappleResolve.position_resolve` (:58-76), and `FightRealtime._grapple_ground`
(:1800-1835). ✅ = this event can write this seat. — = it cannot.

| Seat | throw | takedown | position_change (top) | sweep / escape (bottom) |
|---|---|---|---|---|
| `guard` | ✅ grade 2 | ✅ grade 2 | ✅ from `none`/`over_under` | ✅ from `half` (sweep) |
| `half` | — | — | — | N/A (source only) |
| `side` | ✅ grade 4 | ✅ grade 4 | ✅ from `guard`/`half` (pass) | — |
| `mount` | — | — | ✅ from `side` (advance) | — |
| `back` | — | — | ✅ from `mount` (advance) | — |

`position_resolve` can reach `mount` and `back` by sequential advancement
(guard → side → mount → back), but a throw or takedown never deposits a
fighter there directly.

### `half` has no writer

`half` is in the vocabulary (`GrappleSeat.gd:8`), in three adapter tables
(`GrappleAdapter.gd:362,372`), in `hold_ticks`, `control_units` and
`is_dominant`. But no code path in `GrappleResolve.gd` or `FightRealtime.gd`
ever writes `to_seat = "half"`. The position_resolve match block (:64-73)
transitions FROM `half` (to `side`) but never TO it. The bottom-man escape
block (:1828) sweeps from `half` to `guard` but never deposits anyone in
`half`. **`half` is a ghost seat: read by adapters, reachable by transition
diagram, but unreachable in play.**

### How long the engine holds the landing seat

After a throw lands, `_move_seat` (`FightRealtime.gd:1683-1684`) writes the
seat and stores a `pending` scoring event with `due_tick = tick + gate_ticks`.
The gate is `Seat.hold_ticks("ground", "guard")` = 20 ticks (1.0 s at 20 Hz),
hard-coded to `"guard"` regardless of the actual landing seat — a throw into
`side` gets guard's 20-tick gate, not side's 60.

A `position_change` can advance the seat on the next successful ground-work
tick after the hold gate passes. So "throw into side, then advance to mount"
is possible in principle — but only if the throw landed in `side` first, and
only after 20 ticks of held top. The chain guard → side → mount → back
requires three successive successful position advances, each with its own
60-tick gate.

### Muay Thai grapples — confirmed

`_scores_grappling` (`FightRealtime.gd:1440-1445`) returns true when any of
`takedowns`, `throws`, `positions`, `submissions` weights is > 0. The muay_thai
scoring profile (`combat_rulesets.json:148-156`) has `"takedowns": 1.5`.
**Muay Thai bouts enter the grapple pipeline.** Takedowns fire, throws fire,
and every one of them lands in `side` or `guard`. The `throws: 0.0` weight
means the adapter's throw table is never consulted for MT scoring, but the
engine still resolves and logs throw events — they just fold to zero.

---

## 2. What a landing seat should be, from the books

### IJF — SOR 14.08.2026, Art. 14 / Art. 15

Art. 14 (ippon) reads: speed, force, largely on the back, skilfully controlled
to the end of the landing. Art. 15 (waza-ari) reads the shoulder axis past 90°.
Art. 15 (yuko, reintroduced this cycle) reads side-landing at 90°, upper back,
both buttocks, neck.

**None of these articles name where the thrower (tori) ends up.** They read
the uke's landing plane, speed and continuity. No published article maps a
throw class to a resulting hold position for the thrower.

**Answer: NONE PUBLISHED.** The engine's `side`/`guard` split is an invention
labelled INV, as G39 §3.3 already established.

### IBJJF — Rules v6.1, Jun 2024, Art. 4.1

Art. 4.1.1: a takedown scores when the opponent lands on back, side or seated
AND top position is held for 3 seconds. The book reads the opponent's landing
and the 3-second top control. It does not say which position the thrower must
end in.

**Answer: NONE PUBLISHED.** The thrower's landing seat is again an invention.

### UWW — International Wrestling Rules, January 2026, Art. 35/37/38

Art. 38: 2 points for a takedown to stomach or flank, 4 points to danger
position (back less than 90°). Art. 37: amplitude (feet-to-air-to-danger) for
the 5-point throw. The book reads where the opponent lands relative to danger.
It does not name the thrower's resulting position.

**Answer: NONE PUBLISHED.**

### Verdict

**Every book is silent.** The three major rulebooks read the opponent's
landing plane and the throw's amplitude, not the thrower's resulting seat.
The landing seat is an engine invention, and the recommendation below is
labelled **INV** throughout.

---

## 3. The recommendation — a distribution from existing draws

### Constraint: no new random draw

R91 asserts four draws per decision tick on the grapple stream
(`FightRealtime.gd:1541-1548`): `gate_a`, `act_a`, `gate_b`, `act_b`. The
`fight_realtime_test.gd` replay harness pins the generator to these four and
every pinned card depends on the count. A fifth draw breaks replay.

**The seat must come out of rolls the engine already makes.** The two
candidates are:

1. **The action roll** (`act` in `takedown_resolve`) — already read, already
   deterministic from the seed.
2. **The power comparison** (`power >= defense + 15`) — already read inside
   `_takedown_grade` to decide grade 2 vs 4.

Both are available without a new draw.

### The arithmetic

Replace `GrappleResolve.gd:53` with a three-tier assignment that reads the
action roll's position inside the success band (already computed as `p`) and
the power comparison (already computed in `_takedown_grade`):

```gdscript
# INV — landing seat from existing rolls. No new RNG draw.
# roll is the action roll, p is the success probability.
# power_dominant is _stat(attacker, "power") >= _stat(defender, "defense") + 15.0
# (the same comparison _takedown_grade already makes).

static func _landing_seat(roll: float, p: float, power_dominant: bool) -> String:
    var deepest_sixth: float = p * (1.0 / 6.0)
    if roll < deepest_sixth and power_dominant:
        return "mount"
    if roll < deepest_sixth * 2.0 and power_dominant:
        return "back"
    # Grade 4 band (hardest third) → side; grade 2 band → guard.
    # This preserves the existing grade ↔ seat mapping as the default.
    var hardest_third_start: float = p * (2.0 / 3.0)
    if roll >= hardest_third_start or power_dominant:
        return "side"
    return "guard"
```

### Why this distribution

The success band is `[0, p)`. The tiers carve it into sixths:

| Slice | Condition | Seat | Approximate frequency |
|---|---|---|---|
| Roll in deepest ⅙ AND power dominant | `roll < p/6` AND `power ≥ defense+15` | `mount` | ~2-4% of successful throws |
| Roll in next ⅙ AND power dominant | `roll < p/3` AND `power ≥ defense+15` AND not mount | `back` | ~2-4% of successful throws |
| Hardest ⅓ OR power dominant (remaining) | grade 4 band, not mount/back | `side` | ~25-35% of successful throws |
| Easiest ⅔ AND not power dominant | grade 2 band | `guard` | ~60-70% of successful throws |

**Mount and back together stay below ~8% of successful throws.** Real judo
throws rarely end in mount and almost never in direct back control; a
distribution that makes waza-ari common has moved judo's scoring by an order
of magnitude. The power-dominant gate (`power ≥ defense + 15`) is the same
bar `_takedown_grade` already uses for grade 4, so mount/back from a throw
requires both a decisive action roll AND a clear power advantage — the
engine's own measure of a dominant throw.

**Guard remains the most common landing.** Most MMA takedowns land in guard;
most judo throws that do not score ippon leave the thrower standing or in a
non-dominant position. The 60-70% guard frequency matches the existing
grade-2 majority.

### Clinch vs standing

The same arithmetic applies to both. The only difference is the offensive
weight set: `CLINCH_OFF_WEIGHTS` (grapple 0.55) vs `STANDING_OFF_WEIGHTS`
(grapple 0.45, power 0.20). Standing shots weight power higher, so
`power_dominant` fires slightly more often from a standing shot — which is
correct: a standing snap-down is more likely to put the thrower on top than
a clinch throw where both men are already tied up.

### What about `half`?

**Do not add `half` as a throw landing.** No rulebook describes a throw that
lands the thrower in half guard, and the engine's own position graph treats
half as a transitional seat (passed through on the way from guard to side),
not a destination. Adding it would create a throw that the adapters cannot
honestly score — G39 §7.2 already marks `half` as `not_scored` for IJF and
as a low-band landing for UWW.

### What about the hold-tick bug?

`FightRealtime.gd:1684` passes `Seat.hold_ticks("ground", "guard")` = 20
for every throw, regardless of landing seat. If throws start landing in
`side` (already possible) or `mount`/`back` (under this recommendation), the
hold gate should be `Seat.hold_ticks("ground", to_seat)` — 60 ticks for
side/mount/back, 20 for guard. This is a separate fix from the seat
assignment, but a build task adopting the recommendation should carry it.

---

## 4. What moves if it is adopted

### Tests that pin a landing seat

```
Godot/tests/fight_realtime_test.gd
    :1748  asserts to_seat ∈ ["guard", "side"] for every throw
           → MUST change: throws can now land in mount or back
    :1821  asserts waza_ari count == 0 from 24 judo bouts
           → MUST change: mount/back landings produce waza-ari under IJF
    :1828  asserts mount+back throw count == 0
           → MUST change: this is the finding Q26 resolves
    :1807-1815  adapter unit tests for throw→seat mapping
           → NO CHANGE: these test the adapter table, not the engine

Godot/tests/grapple_resolve_test.gd
    :38-39  asserts takedown result has to_seat key
           → NO CHANGE: the key still exists, the values expand

Godot/tests/grapple_contract_test.gd
    :133  asserts takedown has to_seat
           → NO CHANGE: same

Godot/tests/grapple_adapter_contract_test.gd
    all to_seat references
           → NO CHANGE: adapter tables are rulebook-derived, not engine-derived

Godot/tests/grapple_clinch_contract_test.gd
    :154, :210  iterate seats for adapter tests
           → NO CHANGE: adapter tests, not engine tests
```

### Would pinned judge scorecards move?

**Yes, for judo.** The 24-bout R93 measurement (`fight_realtime_test.gd:1860`)
currently shows `throw_bands = {"yuko": 6}` and zero waza-ari. Under the
recommendation, ~4-8% of throws land in mount or back, converting from yuko
to waza-ari. Over 24 bouts with ~6 scoring throws each, roughly 1-2 throws
per measurement would shift from yuko to waza-ari. The pinned scorecard
assertion at `:1821` would go red and must be re-pinned.

**For UWW,** throws that previously scored 2 points (grade 2 into guard) or
2 points (grade 4 into side) may now score 4 points (grade 4 into mount or
back, the danger branch). The UWW point totals in adapter tests would shift
slightly upward.

**For IBJJF,** the takedown still requires 3 seconds of top control. A throw
into mount or back with 60-tick hold gate scores the same 2 points as a throw
into side or guard — the IBJJF table reads hold time, not landing seat. No
scorecard movement.

**For MMA/abc,** throws are `not_scored` as a point event (effective
grappling token only). No scorecard movement.

### Cost of the build task

Low. One line in `GrappleResolve.gd` (the `to_seat` assignment), one new
static function (`_landing_seat`), one fix to `FightRealtime.gd:1684` (the
hold-tick gate), and re-pinning of two assertions in
`fight_realtime_test.gd`. The adapter tables do not change. The seat
vocabulary does not change. No new file, no new state key.

---

## 5. Open questions

**Q1. Should `back` be reachable from a throw at all?** Real judo has
sacrifice throws (sutemi-waza) that can land the opponent on their back while
the thrower ends up behind, but these are rare and the engine has no
throw-class vocabulary to distinguish them. **Default: keep `back` reachable
but gated on power-dominant AND the deepest roll slice (~2-4%).** If the
operator prefers a more conservative distribution, removing `back` and giving
its slice to `mount` is a one-line change and does not affect the draw
budget.

**Q2. Should the hold-tick gate follow the landing seat?** A throw into
`mount` with only 20 ticks of hold (the current guard gate) scores before the
position has stabilised. G34 §2 gives side/mount/back a 60-tick gate.
**Default: yes, `Seat.hold_ticks("ground", to_seat)` instead of the hard-coded
`"guard"`.** This is a bug fix that should ride with the seat assignment, not
a separate task.

**Q3. Should `half` remain a ghost seat?** It is in the vocabulary, in three
adapter tables, and in the position graph, but no code path reaches it.
Leaving it is harmless; removing it would touch `GrappleSeat.gd`,
`GrappleAdapter.gd`, and `GrappleResolve.position_resolve`. **Default: leave
it.** A future task (a sweep from side into half guard, for instance) could
give it a writer without expanding the vocabulary.
