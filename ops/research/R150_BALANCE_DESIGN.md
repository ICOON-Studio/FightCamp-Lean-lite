# R150 — HOW BALANCE GOES IN, FROM THE OPERATOR'S DEFINITION

Claude, 2026-09-19. Follows R149, which found balance built three times and
wired zero times. **R149 audited; this designs.** Measured at `e6cfca61`.

---

## 0. THE RULING, VERBATIM — this is the design authority for everything below

> Balance in Mixed Martial Arts (MMA) and combat sports is interpreted as the
> **dynamic control of your center of gravity over a shifting base of support to
> deliver maximal force, absorb impact, and prevent takedowns.**
>
> **Striking and Stand-Up Dynamics**
> **Weight Distribution:** Fighters keep weight centered or slightly forward,
> avoiding over-committing to either foot when throwing punches to prevent
> getting swept or countered.
> **Single-Leg Commitment:** Kicking sports like Muay Thai treat balance as a
> single-leg discipline, requiring full bodyweight stability on the standing leg
> while the other strikes.
> **Posture and Reach:** Leaning forward or overextending punches shifts the
> center of gravity outside the base of support, compromising recovery and
> exposing the fighter to takedowns.
>
> **Grappling, Takedowns, and Scrambles**
> **Lowering the Center of Gravity:** Grapplers bend their knees and lower their
> hips to create a heavy, stable base that resists throws.
> **Disruption:** Offense relies on breaking an opponent's balance by
> manipulating their center of pressure relative to their footing.
> **Transitions:** MMA requires seamless balance adjustments between upright
> striking stances and grounded positions on the mat.

---

## 1. THE FIRST THING THIS CHANGES: R149's PLAN WAS TOO NARROW

R149 proposal 3 was "connect `BalanceState` to `GrappleResolve`" — because that
is the one seam `BalanceState`'s own header names. **The ruling says balance has
THREE outputs, and takedown defence is only the third of them:**

| the ruling says balance is for… | engine site | wired today |
|---|---|---|
| **"deliver maximal force"** | strike damage — `FightSimulation:3619` neighbourhood | no |
| **"absorb impact"** | the knockdown/stagger roll — S17's `hurt_threshold_base` seam | no |
| **"prevent takedowns"** | `GrappleResolve._success_probability:137-139` | no |

So the module's header under-specified its own job, and R149 inherited that.
**Wiring only GrappleResolve would implement one third of the ruling and would
leave balance invisible in striking, which is where the player watches.**

---

## 2. THE ATTACK SIDE IS ALREADY PAID FOR — AND IT WAS BUILT TO FIT

"Disruption: offense relies on breaking an opponent's balance." That half is
authored and has been all along.

**All four of `BalanceState`'s causes have real catalogue sources**, counted over
the 696 technique nodes:

| `BalanceState` cause | authored effects that feed it | techniques |
|---|---|---:|
| `kuzushi` | `balance_break`, `off_balance_threat`, `throw_setup` | **88** |
| `stagger` | `knockdown_power`, `impact`, `pushback` | **59** |
| `sweep` | `sweep`, `sweep_threat` | **28** |
| `stuffed_shot` | `counter_takedown`, `takedown_defense`, `throw_defense` | **15** |

**190 of 696 techniques (27%) already carry an effect that maps to a cause the
module already implements.**

**And the numbers were designed together.** `balance_break` magnitudes in the
catalogue run **5..15**. `BalanceState.MAGNITUDE_CEILING` is **16.0**. That is
not a coincidence — it is two halves of one design that were never joined. The
normalisation `clampf(magnitude / ceiling, 0, 1)` lands authored data in
0.31..0.94 without a single number being retuned.

---

## 3. THE GAP: NOTHING MODELS A MAN COSTING HIMSELF HIS OWN BALANCE

Two of the ruling's three striking clauses are about **self-inflicted** balance
loss — over-committing on a punch, overextending, standing on one leg to kick.

**The catalogue has 140 distinct effect keys over 696 nodes and not one of them
is the attacker's own balance cost.** The nearest candidates:

- `risk` — 4 nodes only, magnitudes 4..9, too rare to carry a rule.
- `counter_open` — 54 nodes, 3..10. **Direction unconfirmed:** `FightMoves.gd`
  discusses `chain_open` and `entry_open` as *striking setup* words, which
  suggests `counter_open` may mean "opens a counter FOR me" rather than "leaves
  ME open". **This must be read before it is used**, and it is the single
  cheapest thing to check before any build starts.

So the ruling's grappling half is fully funded by existing data, and **its
striking half needs either a new per-technique field or a rule derived from
fields that already exist.** The derived route is much cheaper:

- **Single-leg commitment** → `match.technique_class == "kick"` (**95 nodes**).
  A kick puts the kicker on one leg for its duration. **Obstacle, measured:
  `technique_class` is ABSENT on 403 of 696 nodes (58%)** — and on 22 of the 26
  `balance_break` carriers. So a class-driven rule silently exempts most of the
  catalogue. That is a data job before it is a code job.
- **Over-commitment** → derive from what a technique already declares: heavy
  `damage`/`knockdown_power` with a long recovery is a committed strike. No new
  authoring, but it is an inference rather than a designed value.

---

## 4. WHAT RESISTS AND WHAT RECOVERS — AND WHY THIS NEEDS NO NEW ATTRIBUTE

The ruling calls balance "dynamic **control**". Control is a competence, so
something must decide how much a break costs a man and how fast he gets back.
**Three standing facts settle this without an eighth stat:**

1. **The footwork ruling:** footwork is *"purely scoring and rhythm, and helps
   dodge, repositioning and in general is the catalyst in transitioning
   **defined by speed**"*. Balance over a **shifting base** is footwork by
   another name.
2. **`FightFootwork.acceleration` already does exactly this shape** — it reads
   `speed`, `conditioning` and the **live stamina tank**, and a tired man's
   acceleration is scaled down to a floor. "A man on empty cannot check his
   weight and go the other way" is that function's own comment, and it is the
   ruling's sentence in code.
3. **`GrappleResolve.DEF_WEIGHTS` already blends the base-stability stats** for
   the takedown case.

**So: recovery rate is `speed`-gated (and stamina-scaled), resistance is the
existing weighted stat blend. No new attribute, no save migration.**

### 4a. THIS REVERSES THE RECOMMENDATION I GAVE ON THE TRAINING TAG

In R149 I recommended leaving the `balance` equipment tag deliberately unmapped,
on the grounds that a state is not a stat. **The ruling changes the basis of
that, and the honest thing is to say so rather than defend it.** If balance
recovery is speed-gated, then `balance` → `speed` on the judo tatami stops being
the arbitrary pick R149 called it and becomes the one mapping consistent with
both rulings — and it is also the only candidate that is not inert on that
station. **Recommendation now: map `balance` → `speed`.** It is a small gameplay
change (a 4th stat on one station), and it should still be the operator's call,
but it is no longer a coin-toss between decorative options.

---

## 5. WHAT THE TRANSITIONS CLAUSE COSTS

"Seamless balance adjustments between upright striking stances and grounded
positions." The phase vocabulary is already there and is richer than expected —
`standing` 483, `clinch` 153, `ground_top` 53, `ground_bottom` 52, `ground` 55,
`scramble` 15, plus cage and weapon variants.

**The cheap version is that a phase change costs balance and the module already
has the cause for it: `stuffed_shot`, whose `kuzushi_at` does NOT decay** — it
returns the full normalised value until cleared, and `is_position_handover()`
exists to flag exactly that. It was built for a position handover. Scrambles are
position handovers.

---

## 6. STANCE — THE PREREQUISITE THE MODULE ASKED FOR ALREADY EXISTS

`BalanceState.gd:8` defers direction with: *"orthodox/southpaw stance will define
weak lines when the vector lands"*, and `direction_modelled()` returns `false`.

**`FightStance.gd` is live and called by `FightSimulation`, `FightMoves` and
`FightRealtime`** — one stance model, both engines, with a settled
`stance_matchup`. **The blocker the module records was removed after it was
written and nobody went back.** Direction is therefore reachable, but it is
still the last step, not the first: it is worth nothing until something reads
magnitude.

**Constraint from U18 D3, which binds any direction work:** stance flips *"which
hand is the 'long' hand and which body kick is free"*. It is **not** a damage
multiplier. A weak-line rule must express itself as which break lands, not as
extra damage.

---

## 7. THE BUILD, STAGED

Each stage is shippable alone and each one is visible in the game.

| # | stage | size | why this order |
|---|---|---|---|
| **0** | **Read `counter_open`'s real direction** (54 nodes) and decide the `balance` tag | tiny | Everything in stage 2 depends on whether a self-exposure vocabulary already exists |
| **1** | **Fighter carries a `balance_state`; opponent techniques break it; `GrappleResolve` reads it** | small-med | 190 techniques already feed it, magnitudes already fit the ceiling, one multiplication at a site that already applies one |
| **2** | **The other two outputs** — balance scales force delivery and impact absorption | medium | Completes the ruling's three outputs; makes balance visible in striking, which is where the player watches |
| **3** | **Self-inflicted balance cost** — kicks (single-leg) and over-commitment | medium | Gated on stage 0 and on `technique_class` coverage (58% missing) |
| **4** | **Phase-change cost on scrambles** via `stuffed_shot` | small | The non-decaying cause already exists for it |
| **5** | **Direction / weak lines** off `FightStance` | medium | Only worth it once magnitude is read; must not become a damage multiplier |

**Measurement discipline this must follow, from the standing rules:** the
fixture must be a differentiated, ruleset-legal matchup (never identical
fighters, never a man who cannot legally kick in a kicking ruleset), and the
before/after must print all the moved columns, not one headline.

---

## 8. WHAT IS NOT SETTLED AND SHOULD NOT BE GUESSED

- **`counter_open`'s direction** (stage 0) — the whole self-cost design hangs on it.
- **`technique_class` on 403 nodes** — a data job nobody has scoped.
- **How big a balance break should be** — the ruling gives shape, not magnitude.
  The authored 5..15 is a starting distribution, not a calibration.

## 9. TEST COMMAND

No `.gd` touched — research tier, no gate.

```
python Godot/tools/run_tests.py --only balance_state
```

---

# CORRECTION, 2026-09-19 (S19) — STAGE 3 NEEDS NO AUTHORING

**Section 3 and stage 7.3 above are WRONG about the striking half, and the
error is worth reading before acting on either.** They conclude that the
ruling's over-commitment clause "has no authored field" and needs new
per-technique authoring. That conclusion came from searching the CATALOGUE's
140 effect keys and finding nothing — and it is true that the catalogue has no
such key. **It is false that the game has no such model.**

`Godot/scripts/FightCommitment.gd` — 151 lines, live in `FightRealtime`,
footage-measured — IS the self-cost model. Its own sourcing (J24, from Honour &
Glory Boxing, Freddie Roach and Teddy Atlas) is the operator's clause almost
word for word: *"Throwing a punch creates vulnerability. The attacker's guard
opens, **their weight shifts**, and they are momentarily committed."*

- `COMMIT_S := 0.267` — Q110/U107 p50 of extension + return over 423 lead-hand
  moves across 16 videos.
- `Commit.is_committed(fighter, tick)` — the trigger, already called.
- `commit_until_tick` — set on every throw at `FightRealtime:2529`.

So the over-commitment clause is roughly **ten lines**, not an authoring pass:
while a man is inside his own throw he carries a standing kuzushi, and
`_refresh_balance` takes the larger of that and any decaying break. It
self-clears when the window expires.

**It does not double-count.** `is_committed` today suppresses only the
thrower's STRIKING defence — he cannot slip a punch, but he sprawls at full
strength. The ruling's "overextending … exposes the fighter to takedowns" is
the other channel, and it is exactly the one still missing.

**What IS genuinely blocked is only the single-leg half**, and it already has
an assigned owner. `FightCommitment`'s own header: *"NO MEASUREMENT — THE REAR
HAND AND THE KICK. Q110's instrument tracked the LEAD hand only, so `COMMIT_S`
is applied to every throw for want of a second figure. TASK_U110 is the
assigned research."* U110 is PC-only. `technique_class` missing on 403 of 696
nodes blocks the scope on top of that.

**THE GENERAL LESSON, and it is the third time this exact shape has cost a
stage:** R149 found balance built three times and wired zero times, and then
this file went looking for a self-cost model in the DATA and missed one sitting
in `scripts/`. Searching the catalogue is not searching the game. Grep the
module tree for the CONCEPT before concluding it has to be authored.
