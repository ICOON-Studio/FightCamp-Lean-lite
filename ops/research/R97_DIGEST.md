# R97 — THE BEAT ADAPTER, AND THE THREE DEFECTS UNDER IT

Claude, 2026-09-10. The seam R96 measured and named.

## What landed

`Godot/scripts/FightBeatAdapter.gd`. Five verbs:

```gdscript
begin(fighter_a, fighter_b, options) -> Dictionary
is_fight_over(state) -> bool
advance_beat(state) -> Dictionary      # ONE presentable event
result(state) -> Dictionary            # the engine's verdict, verbatim
state_view(state) -> Dictionary        # what RingStagePanel.refresh reads
```

`fight_beat_adapter_test.gd` **932/0**. Codex's blind
`fight_beat_adapter_contract_test.gd`, written from the C77 contract and never
from this module, **3661 checks / 0 failures**.

## The design decision that matters

**A beat is a WINDOW of fight-time, not "pump until something happens."**
`BEAT_TICKS` is 280 — 14.0 s at 20 Hz, which is the span `BroadcastRead` already
falls back to for one atomic exchange (U21), so a real-time beat and an old
exchange are the same size of thing and every per-minute figure downstream keeps
meaning what it meant.

Sizing by time rather than by first-impact is **what makes the drop happen.** A
beat that stopped at the first impact would never drop anything, `dropped` would
be structurally zero, and G42's whole rule would be unreachable code behind a
green test — the failure this area has shipped five times. Measured on the seeded
boxing bout: **896 impacts, 66 shown, 830 dropped.** Both counters are asserted
non-zero.

G42 is honoured in both directions. Dropping is permitted and counted; inventing
is forbidden. Every field is copied from an impact the engine emitted, derived by
a total function, or left deliberately empty — `range_band` is the empty case,
because the engine names a `distance` in metres and has no band vocabulary, and
guessing one would be this file inventing a fact about the fight. The module
draws no random numbers: same seed, same beats.

## The three defects, none of them guessed

**1. `wear` is a Dictionary.** `ImpactModel.wear_from` returns
`{region: amount}` because C63's contract is that one blow may eventually cost
two regions. Ranking candidates by `float(event["wear"])` is not a wrong number —
it throws *"Nonexistent 'float' constructor"* on every tie-break. It is summed
now, which is also the honest measure of the biggest blow in a window: what it
cost the man, not how hard it was thrown. **Codex's blind test resolved this
ambiguity identically and independently.**

**2. The ground fight never comes out of `advance_tick`.** Only the IMPACT
subsystem appends to the returned array; every grapple event goes straight to
`state["log"]` via `_log_grapple` (`FightRealtime.gd:1622`). So the first draft's
`grapple_events` counter — which filtered the RETURNED array for grapple kinds —
could only ever read zero. It did, and the test said so in one line. That is the
sixth piece of correct, tested, unrunnable code this area has produced, and it
was caught only because the test asserted the count is **non-zero on an MMA
bout** rather than asserting the filter was correct. It reads the log now: 59
counted.

**3. Copying `wear` by assignment aliased the card.** A shallow copy put the
LOG's own Dictionary object on the beat. Replacing `beat["wear"]` would have been
harmless, but a view reaching in to write `beat["wear"]["head_neck"]` would have
been editing the fight's record of what that punch cost — one level deeper than
the shallow non-aliasing check catches. Nested values are duplicated deeply now,
and the test mutates the nested dictionary specifically.

## What is NOT done, named rather than implied

**`FightNightScreen` is still on `FightSimulation`.** The screen switch needs
equivalents for `finalize_result`, `_record_live`, `is_decision_point` and
`_publish_frame`, across ten test files that drive that screen, and it must carry
BOTH engines because R85 left judo, taekwondo and freestyle wrestling on the
atomic one by ruling. That is U36, assigned to Cursor with U35's survey behind
it. **The engine still has no production caller until U36 lands.**

## Reproduce

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_beat_adapter_test.gd
```
```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_beat_adapter_contract_test.gd
```
