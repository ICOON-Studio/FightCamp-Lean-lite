# TASK R80 — CLAUDE — THE BURST UNDER THE NAMED TECHNIQUE, AND THE STANCE THAT MATTERS

**Owner:** claude
**Model:** Opus, effort **high**, Fast **off**.
Reason: `FightSimulation.gd` is the core of the game and this changes the shape
of the event every consumer reads. New system, core file, contract that another
agent builds against unseen.

## Why this exists

U18 (merged `d8c6e33`) measured the gap. Davis 2015: a real round is **~20
punches + 2.5 defenses + 47 hip movements per minute**. We resolve **one named
technique every 14 fight-seconds**. The range ladder is already correct — U18
checked it against the coaching manuals and it matches. What is missing is
**flow**, and U18 is explicit that the fix is **event granularity, not a new
attribute**:

> Refuse: adding attributes beyond the seven. The missing feel is event
> granularity and clocks, not a new 0-100.

This task adds the granularity. It does **not** add an eighth attribute, XY
positions, or a cadence change (see the C17 Q1 ruling in `HANDOFF.md`
`## Direction notes`, 2026-09-09: the atomic exchange stands).

## Part 1 — the burst payload

Every `type == "action"` event gains one new key, `burst`. **This is a contract:
U19 (Cursor) is printing these exact names without seeing your code.** Exact
names, exact types, no renaming.

```gdscript
event["burst"] = {
    "thrown":       int,    # strikes thrown across this 14-fight-second exchange
    "landed":       int,    # of those, how many connected
    "jab_share":    float,  # 0.0..1.0, share of `thrown` that were jabs/probes
    "defense_used": int,    # discrete defensive acts by the target this exchange
    "steps":        int,    # footwork atoms: forward / back / lead-side / rear-side
}
```

Rules:

- `landed <= thrown`, always. `jab_share` is clamped `0.0..1.0`.
- The **named technique is still the headline** and still decides the outcome.
  The burst is texture underneath it and **must not change who wins** — it is
  derived from the same seeded rng after the outcome is resolved, never before.
  This is the single most important constraint in the task: `advance_exchange()`
  must produce the identical outcome sequence for a given seed with and without
  the burst.
- Anchor the magnitudes on U18 D1. One exchange is 14 fight-seconds ≈ 0.233 min,
  so a plausible baseline is `thrown` ≈ 4-5, `defense_used` ≈ 0-1, `steps` ≈ 11.
  Scale with the actor's `conditioning` and `speed` and with the range band —
  POCKET throws more than LONG. Do not invent a new stat to drive it.
- A landed headline technique should be consistent with its burst: if the event
  landed, `landed >= 1`.
- `_defense_event` / slip events (`:1582`) and chain links may carry a burst too,
  but a paused chain event (`event["paused"]`) must not — it has not resolved.

## Part 2 — stance matchup

`stance` is already on the athlete and already does real work in the gym:
`GameState.gd:974` matches sparring partners on it. **The fight is the only
place that ignores it.**

Add to every action event:

```gdscript
event["stance_matchup"] = "closed"   # both fighters same stance
event["stance_matchup"] = "open"     # orthodox vs southpaw
```

Then apply U18 D3's ruling as a **weighting on the existing exchange**, not new
state:

- **Open stance:** the rear hand and the body kick to the open side get a small
  edge; the jab becomes a cross-body probe, so lower `jab_share` a little.
- **Closed stance:** jab-and-step; raise `jab_share` a little.

Keep the effect small and legible. U18 is explicit that this flips *which hand
is long and which body kick is free* — it is not a new damage multiplier.

**Do not add switch-hitting as a third stance.** U18: not until a fighter has an
authored switch skill (`mma_stance_switch` exists as a node but no fighter owns
it). Guard height (high/long/peekaboo) is also out of scope — it is a pose loop
for later, not an attribute.

## Owned files

- `Godot/scripts/FightSimulation.gd` — **2,954 lines. Never open it whole.**
  Anchors: `:60` (STAT_KEYS — read only, add nothing),
  `:231` (`ANIMATION_FAMILY_BY_ROLE` — **C59 is editing this, do not touch it**),
  `:417` (`advance_exchange`, the stamp point at `:452-463` is where `burst` and
  `stance_matchup` belong), `:1288-1300` (`_resolve_exchange` builds the action
  event), `:1491` (chain link event), `:1582` (slip event), `:2283` (defense role
  exclusion).
- `Godot/tests/fight_simulation_test.gd` — new coverage.
- `HANDOFF.md` — your own R80 block only.

**Do NOT touch** `RingStagePanel.gd` (C59 owns it this cycle) or
`AthleteDevelopment.gd`. If the burst wants `technique_progress`
(`AthleteDevelopment.gd:83`) to set the camp's jab share, that is the **next**
slice, not this one — name it as a follow-up and stop.

## Gate

```bash
python Godot/tools/check_scripts.py Godot/scripts/FightSimulation.gd Godot/tests/fight_simulation_test.gd
```
Focused first, then the suite once in the background before the commit:
```bash
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_simulation_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/combo_chains_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_scoring_test.gd
python Godot/tools/run_tests.py
```
`fails=0`, or better than you found it — if you fix a pre-existing failure too,
say so and push. Never gate on an exact count.

**The determinism test is the real gate:** run the same seed twice, once with
the burst written and once with it suppressed, and assert the outcome sequence
(`outcome`, `landed`, `damage`, winner) is byte-identical. If the burst can move
a fight, it is wrong.

## The trap

The burst is read by a consumer you will never see. U19 is written from **this
file's contract**, not from your code — so a renamed key or a float where an int
was promised breaks Cursor silently, and the break shows up as a blank broadcast
panel, not a failing test. Emit exactly the five names above, exactly those
types, on exactly `type == "action"` events.
