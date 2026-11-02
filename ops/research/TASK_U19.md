# TASK U19 — CURSOR — THE BROADCAST READ

**Owner:** cursor
**Model:** Composer, effort **medium**.
Reason: reads and presentation over a contract that is already written down.
Your own research specified it, so the judgement is done; this is the build.

## Why this exists

This is item 3 of your own U18 build order (merged `d8c6e33`). U18 D9 is the
spec: the missing feel is broadcast-shaped **reads**, not new combat physics.

> **Refuse:** adding attributes beyond the seven. The missing feel is event
> granularity and clocks, not a new 0-100.

R80 (Claude, in parallel) is adding the granularity to the event. **You are not
waiting for it.** You build against the contract below and test with your own
fixture. That is deliberate: a test written against an implementation only
agrees with it.

## The contract you are building against

R80 stamps this on every `type == "action"` event in the fight log. These names
are fixed. Do not rename them, do not guess at extras.

```gdscript
event["burst"] = {
    "thrown":       int,    # strikes thrown across this 14-fight-second exchange
    "landed":       int,    # of those, how many connected
    "jab_share":    float,  # 0.0..1.0
    "defense_used": int,    # discrete defensive acts by the target
    "steps":        int,    # footwork atoms
}
event["stance_matchup"] = "closed"   # or "open"
```

Already on the event today, verified in `FightSimulation.gd`: `round` (`:457`),
`range_owner` (`:463`), `actor_side` / `target_side` (`:455-456`),
`landed`, `outcome`, `technique_name`, `role`, `animation_family`.
The band is stamped on the action; `range_owner` says who won the distance.

**Every event you read may lack `burst`** — R80 may not have landed yet, and old
saves never will. Treat a missing `burst` as "not measured" and print an em dash,
never a zero. A zero is a lie about a fight that was never instrumented.

## What to build

A **post-fight broadcast read**, plus the live line on the move strip.

Derived from the log, all of it, no new state:

| Read | From |
|---|---|
| Output / min | sum `thrown` ÷ fight minutes |
| Connect % | sum `landed` ÷ sum `thrown` |
| Jab share | `thrown`-weighted mean of `jab_share` |
| Defense used / min | sum `defense_used` ÷ fight minutes |
| Steps / min | sum `steps` ÷ fight minutes |
| Time at band | count of events per band ÷ total, as a % |
| Range owned | `range_owner` share per side |
| Stance matchup | `stance_matchup`, printed once — `CLOSED` or `OPEN` |

One exchange is **14 fight-seconds** — that is the conversion for every
"per minute" figure. Do not hardcode a round length; derive it.

Present it per fighter, side by side, the way a broadcast card does. Follow the
existing UIKit surfaces — this must look like the rest of the game, not like a
debug dump. Hold it to the commercial bar the other screens meet.

## Owned files

- `Godot/scripts/RingStagePanel.gd` — **1,348 lines, do not open it whole.**
  The move strip lives here; `:884` is the family consumer.
  **C59 (Codex) is editing `:884` and the `match` block at `:889` this cycle.**
  Stay out of those lines — take the strip's text/readout, not the choreography.
- The post-fight surface and its test.
- `Godot/tests/` — your own new test.

**Do NOT touch** `FightSimulation.gd` — R80 owns it this cycle. If you need a
field that is not in the contract above, do not add it yourself: say so in your
report and it becomes the next slice.

## Gate

```bash
python Godot/tools/check_scripts.py <each .gd you touched>
```
Then focused, then the suite once in the background before the commit:
```bash
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/ring_stage_panel_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_playback_test.gd
python Godot/tools/run_tests.py
```
`fails=0`, or better than you found it — if you fix a pre-existing failure too,
say so and push. Never gate on an exact count.

Your fixture: build a fake log of action events carrying `burst` and
`stance_matchup` by hand, and assert the derived figures. Also assert the
**missing-`burst`** path renders an em dash and does not divide by zero — that
is the case that will actually ship first.

## The trap

`connect %` divides by `thrown`. An exchange where nothing was thrown, a log
with no action events at all, and a log predating R80 are all real and all
divide by zero. Every one of the eight reads needs its empty case decided before
it is printed, and the answer is an em dash, not `0%` — a fighter who threw
nothing did not miss everything.
