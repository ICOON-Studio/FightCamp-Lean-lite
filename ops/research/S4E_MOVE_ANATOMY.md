# WHAT A MOVE NEEDS, WHICH LIMB THROWS IT, WHERE IT LANDS — AND WHY MOVES DO NOT BLEND

Claude, 2026-09-16, answering the operator directly: *"Analyze what each move requires to execute and blend with other
moves. How our engine knows which limb to move to execute the moves and where is the target?"*

Instruments: `Godot/tools/probe_technique_coverage.gd`. Population: two men differentiated INSIDE each ruleset and
legal for it (operator rules 2026-09-12) — A 183 cm striker, B 176 cm grappler. 10–20 seeds per ruleset per arm.

## 1. WHAT A MOVE REQUIRES TO EXECUTE

A catalogue node becomes a throwable move only if it passes **four gates** in `FightMoves.move_from_node`, and is then
selected only if it passes **two more** at throw time.

| # | gate | where | refuses |
|---|---|---|---|
| 1 | `role` ∈ `setup / damage / counter` | `move_from_node:1` | `defense`, `adaptation`, `control`, `takedown`, `transition` |
| 2 | no effect in `GRAPPLE_EFFECTS` (53 words) | `move_from_node:2` | every throw, sweep, submission — **and, until this commit, five punches** |
| 3 | `phases` folds to at least one stance | `_stances_for` | a node with no standing/clinch/ground phase |
| 4 | at least one target region the ruleset permits | `_regions_for` | a leg kick under boxing — *structurally*, not as a zero weight |
| 5 | the man has LEARNED it, or it is tier ≤ 2 | `moves_for` | everything above tier 2 for an untrained fighter |
| 6 | its `bands` include the current band and its `stances` the current stance | `live_set` | a CLINCH-only move at LONG range |

**Requirements the catalogue authors and the engine NEVER READS:** `requires.attributes` (a rear uppercut asks for
power 32 / technique 32), `requires.prerequisites` (a cross needs a jab), `requires.reps`, `requires.discipline`, and
`grade` / `grade_rank`. Those gate the *training* system, not the fight. **In a live bout a man's attributes do not
decide which techniques he can throw — only whether they land.**

## 2. HOW THE ENGINE KNOWS WHICH LIMB — MOSTLY, IT DOES NOT

| ruleset | engine names the hand | falls to TICK PARITY |
|---|---:|---:|
| boxing | 2,431 of 9,847 (**24.7%**) — lead 798, rear 1,633 | **75.3%** |
| kickboxing | 1,747 of 8,940 (19.5%) | **80.5%** |
| muay thai | 2,416 of 12,075 (20.0%) | **80.0%** |
| mma | 2,332 of 13,754 (17.0%) | **83.0%** |

The chain is `FightStance.family` → `hand_for_family` → the beat's `hand` → `FightStageDirector.hand_for`. `family`
matches **on the id and name string** (`JAB_MARKERS`, `REAR_HAND_MARKERS`) because *"the catalogue carries no per-move
hand tag to read"*. A jab is the lead hand, a cross is the rear. **Everything else — every hook, every uppercut, every
kick, every knee and every elbow — emits no hand at all**, and the presenter picks by whether the impact's tick number
is even or odd (`FightStageDirector.gd:156`).

**And no kick ever names a leg.** `hand_for_family` returns `""` for kicks by construction, so which leg throws a
roundhouse is decided by tick parity in the room. There is no `leg` field anywhere in the engine.

## 3. HOW IT KNOWS WHERE THE TARGET IS — ALWAYS, AND WELL

This half is sound. Every move carries a **normalised region map** built by `_regions_for` from its own effect words
(`head_damage` → 85% head / 15% body; `leg_damage` → 45/45/10; `kick_damage` → the ruleset's own spread), falling back
to the ruleset spread when the node hints nothing. **The ruleset has the last word and it is a RULE, not a weight**: a
region it gives zero weight cannot be struck, so a technique whose every target is illegal is dropped entirely.

`FightMoves.select` then walks the JOINT distribution over (technique, region) in **one** `randf()` —
P(technique) × P(region | technique) — which is why the seven-draw contract holds. Measured delivery:

| ruleset | head | body | legs |
|---|---:|---:|---:|
| boxing | 66.1% | 33.9% | 0.0% (structurally illegal) |
| kickboxing | 54.5% | 37.9% | 7.6% |
| muay thai | 47.9% | 42.5% | 9.5% |
| mma | 49.5% | 42.8% | 7.7% |

The target is a *region* — `head_neck`, `torso_core`, `left_leg` — never a point in space. At 20 Hz an impact is a force
arriving at a region, and the room's contact solve is what turns that into a place a fist goes.

## 4. HOW MOVES BLEND WITH OTHER MOVES — THEY DO NOT

The catalogue authors a full chaining vocabulary: `combo_open`, `chain_open`, `entry_open`, `counter_open`,
`angle_entry`, `first_step`, `rhythm`, `timing`. **`FightRealtime` reads none of it.**

`grep` over `Godot/scripts`: `combo_open` has exactly one consumer and it is `FightSimulation.gd:1629` — **the atomic
engine we are replacing**. Same for the rest. In the real-time engine the entire combo mechanism is:

```gdscript
static func combo_boost(since_s: float) -> float:
    if since_s < 0.0 or since_s > COMBO_WINDOW_S:
        return 1.0
    return COMBO_BOOST
```

A flat multiplier on **who throws next**, applied to the share contest — blind to which technique was just thrown and
to what it opened. **A jab does not open a cross. A double jab is not a jab twice. A feint opens nothing.** C132 said
this of `combo_open`; it is true of the whole family.

**This is the single largest authored-but-inert system in the fight.** It is not a bug to patch: it is a design slice —
a `last_technique` and an until-tick beside `last_throw_tick`, with the opener words weighting the next draw.

## 5. THE FIX THIS COMMIT MAKES — FIVE PUNCHES NOBODY HAS EVER THROWN

`GRAPPLE_EFFECTS` contained `chain_open` and `entry_open`, which are **striking** setup words. They refused:

`boxing_rear_uppercut` · `boxing_double_jab` · `boxing_jab_body` · `boxing_feint` · `boxing_rhythm_change` ·
`kickboxing_question_mark` — in boxing, kickboxing, muay thai and MMA alike.

The control is one row away: `boxing_lead_uppercut` carries `combo_open`, which is not in that list, and is thrown 577
times in twenty kickboxing bouts. **The difference between a lead uppercut that works and a rear uppercut that does not
was one word in a list.**

**IT WAS NOT A SIMPLE DELETION, AND CHECKING THAT WAS THE WORK.** `grapple_move_from_node` reads the SAME list
*positively*, so deleting the words would have dropped `mma_jab_levelchange` out of **both** palettes, leaving a
technique that exists nowhere. Of the four nodes the original comment names, three are still refused without the pair
(`wrestling_duck_under` by `go_behind_open`, `wrestling_level_change` by `entry_accuracy`, `mma_sprawl_fronthead` by
`takedown_defense`). Only `mma_jab_levelchange` depended on `entry_open` alone — so **the data was fixed where the data
was wrong**: it now carries `takedown_ready`, the catalogue's own unambiguous word for what a jab into a level change
does. Two lines of JSON.

A `range_delta >= 1` rule was tried first and **rejected by measurement**: it would have refused 19 real strikes
including `boxing_step_in_out` (thrown 833 times) and `muay_thai_khao_loi`. Closing distance is not grappling.

### The A/B, `strike_openers` off vs on

| ruleset | throwable palette OFF | ON | still refused |
|---|---:|---:|---|
| boxing | 13 | **17** | `boxing_pivot_footwork` only |
| kickboxing | 24 | **28** | `boxing_pivot_footwork`, `kickboxing_switch_kick` |
| muay thai | 39 | **43** | `boxing_pivot_footwork` |
| mma | 51 | **55** | — |

`boxing_pivot_footwork`'s role is `adaptation`, not a strike role — **it is refused correctly**: a pivot is footwork,
and C133 Q4 already recorded that there is nowhere in this engine for a defence or a movement that is not a blow.

**`strike_openers` defaults OFF.** It adds techniques to every striking palette, which moves the technique choice on
every seeded tick and therefore every recorded verdict in the project. Turning it on is its own slice with its own
re-baseline. Switched off: `fight_realtime_test` (376 checks), `fight_strike_band`, `grapple_adapter`,
`fight_beat_adapter`, `realtime_round_stats`, `fight_stoppage` all green. `fight_scoring` is red and was red on master.

## 6. THE UNLOCKED FIXTURE THE OPERATOR ASKED FOR

`FightMoves.full_progress()` marks every catalogue node learned. **It unlocks; it does not legalise** — a fighter
handed it still gets only what his ruleset permits, because `moves_for` filters by discipline and `move_from_node`
refuses any node whose every target region the ruleset zeroes. A boxer with everything unlocked still cannot kick.

| ruleset | tier 1-2 palette | UNLOCKED | thrown | coverage |
|---|---:|---:|---:|---:|
| boxing | 13 | **30** | 28 | 93.3% |
| kickboxing | 24 | **46** | 43 | 93.5% |
| muay thai | 39 | **100** | 97 | 97.0% |
| mma | 51 | **118** | 115 | 97.5% |

**The engine holds up with a full palette** — it still throws 93–97.5% of everything it is handed. And the target mix
moves: boxing head/body goes 66.1/33.9 → **56.3/43.7**.

**BUT THE MMA LEG SHARE DOES NOT MOVE** — 7.7% → 7.5% unlocked, against J20 D3's documented 14–18%. A bigger palette is
not the lever, which is worth knowing because the roadmap has named technique selection as the lever for months.

## Open

1. **`boxing_feint` enters the palette and is still never thrown** in any ruleset, over four arms. Reachable and
   unselected is a different defect from unreachable, and it is not diagnosed.
2. **Unlocked, four more are never thrown**: `boxing_drawing`, `boxing_inside_uppercut`, `kickboxing_clinch_knee`,
   `muay_thai_clinch_knees`. The two clinch knees are CLINCH-band and a standing fight may simply not reach them; the
   two boxing nodes are not explained.
3. **The chaining vocabulary is inert** (section 4). The largest authored-but-unread system in the fight.
4. **No kick names a leg, and 75–83% of throws name no limb at all** (section 2). The room decides by tick parity.
5. **`requires.attributes` and `requires.prerequisites` are never read in a fight** (section 1). Whether a fighter
   *should* be able to throw what he has not trained for is an operator question, not a defect.
6. Turning `strike_openers` on is a full re-baseline of every seeded pin.

## Re-running it

```
godot --headless --path Godot --script tools/probe_technique_coverage.gd -- seeds=20
godot --headless --path Godot --script tools/probe_technique_coverage.gd -- seeds=20 openers
godot --headless --path Godot --script tools/probe_technique_coverage.gd -- seeds=20 unlocked
godot --headless --path Godot --script tools/probe_technique_coverage.gd -- seeds=20 openers unlocked
```
