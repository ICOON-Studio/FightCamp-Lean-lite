# R101 — DESIGN NOTES BEFORE A LINE IS WRITTEN

Claude, 2026-09-10. Recorded during the R100 confirmation gate, from reading
only — no engine file has been edited. **These are findings and open questions,
not decisions.** R101's code waits on J21 (John, the move palette), which is in
flight.

G49 and G50 are both IN and both are captured (`G49_THE_EXCHANGE.md`,
`G50_WHO_IS_PRESSING.md`).

---

## 1. THE CONDITIONAL, AS THE RESEARCH LEFT IT

G49 proposed three terms. G50 removed one. What survives:

| term | status | source |
|---|---|---|
| time since this fighter's last throw (burst / combo window) | **KEEP** — G49's highest-value conditional | G49 |
| his own baseline volume share (from the MAN: attributes, plan, pace) | **KEEP** — volume is measured everywhere and is emphatically not 50/50 | G49 |
| who is pressing | **DROP** | G50: narrator's word; and where measured over ~7,300 rounds it added essentially nothing to scores once punches were controlled |
| "who just landed" | **DROP** — explicitly counter-recommended | G49 |
| a momentum flag | **DROP** — weakly evidenced at strike grain | G49 |

Range still **gates the action set** (Hristovski, via G49) — that is the
`range_band` bridge and is unaffected.

## 2. THE DETERMINISM CONSTRAINT IS CHEAPER THAN FEARED

`FightRealtime.gd` `_run_impact` (the coin flip is at :1287) is documented as
taking **seven unconditional draws per built impact**, and R86's own comment
warns that a *conditional* draw would make the stream's position depend on the
fight's content and shift every seeded fight.

**The actor pick is a single `rng.randf()`:**

```
var actor_side: String = "a" if rng.randf() < 0.5 else "b"
```

So the fix is a **threshold change, not an extra draw**:
`rng.randf() < p_a`, where `p_a` is computed from state already in hand.
**The draw count is unchanged, the draw stays unconditional, and R82's
byte-exact replay contract holds for free.** Only the values move — which they
must, because that is the point of the stage.

This is the single most important structural fact for R101 and it means the
change is small.

## 3. THE PALETTE IS SMALL, NOT 272

The catalogue is 272 nodes across **15 disciplines, 18–20 nodes each**. A
fighter does not choose from 272 — **boxing is 18 nodes**, and only some are
strikes:

```
boxing roles: damage 7, counter 5, setup 2, defense 2, adaptation 2
```

The full boxing palette, with role and range bands:

| node | role | range_band |
|---|---|---|
| boxing_jab | setup | LONG, MID |
| boxing_double_jab | setup | LONG, MID |
| boxing_cross | damage | MID |
| boxing_lead_hook | damage | MID, POCKET |
| boxing_body_hook | damage | MID, POCKET |
| boxing_overhand | damage | MID, POCKET |
| boxing_lead_uppercut | damage | MID, POCKET |
| boxing_liver_combo | damage | LONG, MID |
| boxing_six_punch_combo | damage | MID, POCKET |
| boxing_rear_uppercut | counter | MID, POCKET |
| boxing_slip_counter | counter | MID |
| boxing_check_hook | counter | MID, POCKET |
| boxing_pull_counter | counter | MID |
| boxing_check_hook_pivot | counter | MID, POCKET |
| boxing_stance_guard | defense | MID, POCKET |
| boxing_shoulder_roll | defense | MID, POCKET |
| boxing_pivot_footwork | adaptation | MID, POCKET |
| boxing_cutoff_ring | adaptation | MID, POCKET |

Each node also carries `requires` — `discipline` level, an `attributes` map, a
`prerequisites` list and a `reps` count — which is the machinery for "a fighter
may only throw what he has trained".

## 4. THE TRAP I FOUND BY READING — TWO BAND VOCABULARIES THAT DO NOT LINE UP

**This is the most valuable thing in this note and it would have cost a cycle.**

- **The catalogue speaks** `LONG` / `MID` / `POCKET`.
- **G47's anatomy speaks** long ~1.1–1.5 m, pocket ~0.6–1.1 m, clinch ≲0.5–0.6 m.

**These are two different three-band vocabularies and the names do not mean the
same thing.** The catalogue's middle band is `MID`; G47's middle band is
`pocket`. Mapping the catalogue's `POCKET` onto G47's `pocket` would put the
catalogue's *lowest* band onto the anatomy's *middle* one.

Now put the engine's own measured distribution against it. `STRIKE_RANGE` is
**1.1 m and `_run_impact` returns `{}` above it** — the engine refuses any strike
beyond the gate. Q34's histogram (re-confirmed in tonight's gate run: 178,024
scored strikes) is:

```
[0.6,0.7) 9.3%   [0.7,0.8) 12.4%   [0.8,0.9) 13.9%
[0.9,1.0) 17.6%  [1.0,1.1) 23.9%   [1.1,1.2) 0.0%
```

**77% of scored strikes fall in 0.6–1.1 m, and NOTHING is above 1.1 m, ever.**

So if the bands are mapped literally onto G47's metres:
- `LONG` (1.1–1.5 m) becomes **structurally unreachable** — the gate refuses it;
- everything lands in one band, and the other two are dead.

**A jab is a LONG/MID technique and it is the most thrown punch in boxing.** A
mapping that silences LONG, or that collapses every strike into one band, would
make most of the palette unselectable — and it would do it *quietly*, behind a
green test, which is precisely the failure mode this area has shipped five times
(`absorbed`/`slipped` unproducible, stamina never drained, the arithmetically
unreachable flash knockdown, osaekomi's dead ladder, `FightStamina` inert).

**Consequence for R101: the band boundaries must be derived from the engine's own
measured separation distribution, not adopted from G47's prose, and the mapping
must be asserted by OCCURRENCE — every band a ruleset can reach must be shown to
actually occur in real bouts, with a floor, not merely be permitted.** If a band
cannot occur, that is a finding to report, not a number to quietly widen.

Open question for the stage, not settled here: whether `LONG` should mean "at the
top of the gate" (say 0.95–1.10) rather than G47's 1.1–1.5, which would make the
catalogue's three bands describe *the reachable range* rather than *the anatomy*.
That is a judgement call and it must be labelled AUTHORED when it is made.

## 5. WHAT C85 IS ABOUT TO CHANGE UNDER THIS

`TARGET_WEIGHTS` at `FightRealtime.gd:315` is one shared table. Its own comment
already anticipates the fix — "One table, so a ruleset can override the split
later without touching the draw" — and `begin()` already receives the ruleset
(`Scoring.profile_for(options.get("ruleset", {}))`), so the route exists.

**C85 lands first and the pins are re-pinned once**, for both stages together.

## 6. STILL OPEN, WAITING ON J21

- What a "move" is in models people take seriously, and the minimum property set.
- The **definition of a significant strike** — needed to be scored against UFC
  Stats at all, and flagged NOT DERIVABLE by Q39.
- The selection mechanism: how a fighter picks *which* move once he has decided
  to throw.

**G51 (Grok, in flight) covers the adjacent gap**: what a miss is, and whether a
simulator needs one. Our accuracy is 57.1% against a real 40–49%, and it is
*identical across two rulesets*, which is what an unmodelled number looks like.
