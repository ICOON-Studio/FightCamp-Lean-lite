# THE CORNER GIVES COMMANDS AND NOTHING ON SCREEN ASKS FOR THEM

**Owner:** codex (`gpt-5.6-luna`, MEDIUM). UI wiring, not animation.
**Tier: parse gate, the focused test, `--only corner` and `--only ui`. NO
suite run.**

## What already exists, so none of it gets rebuilt

**THE ENGINE SIDE IS DONE.** `Godot/scripts/FightBeatAdapter.gd`:

- `CORNER_OPTIONS` (:251) - the instructions themselves.
- `get_available_corner_instructions(state, side)` (:487) - what this man's
  corner may say right now.
- `apply_corner_instruction(state, side, instruction)` (:499) - what it does to
  him, including how it moves his preferred range.

`Godot/scripts/CornerAdvice.gd` and `Godot/scripts/CornerRulesRead.gd` are
there too.

**THE WORDS ARE DONE.** `research/K72_CORNER_CARD.md` is Kalli's copy for
the corner card - use her sentences, do not write new ones. A mock exists at
`research/RING_K16_corner.png`.

**WHAT IS MISSING IS THE SCREEN.** Nothing calls
`get_available_corner_instructions` and nothing calls
`apply_corner_instruction`. The between-rounds moment has no UI at all.

## What to build

A corner panel shown **between rounds**, that:

1. Asks the adapter what is available for this fighter, and shows exactly
   those - never a hardcoded list. If the adapter offers three, three appear.
2. Uses K72's copy for each one.
3. Sends the chosen instruction back through `apply_corner_instruction` and
   shows what changed, in the fighter's own terms.
4. **Reads the fight to decide what the corner is worried about.** The engine
   already tracks damage by region, stamina and the round's scoring - a corner
   that says the same thing after a dominant round and a terrible one is not a
   corner.
5. Is **skippable**, and defaults sensibly if the player does nothing. A career
   game plays many fights.

Build it with `UIKit` like every other screen in this project, and register it
in the kit book if that is how sibling panels do it - follow
`Godot/scripts/FightResultPanel.gd` and `RingStagePanel.gd` for the house
pattern rather than inventing a layout.

## The test - `Godot/tests/corner_panel_test.gd`

1. The panel offers **exactly** what `get_available_corner_instructions`
   returns - add a fake option to the adapter's list in the test and the panel
   must show it. This is the check that stops a hardcoded copy drifting.
2. Choosing one calls `apply_corner_instruction` and the returned state
   differs from the state before.
3. Skipping changes nothing.
4. The panel renders at the kit's own size with no clipped text. **Note
   `clip_text` on labels: a long instruction must WRAP or be budgeted, not be
   silently cut** - that bit this project today on the fight callout.

**Prove it with mutants:** hardcode the option list; ignore the chosen
instruction; return the pre-change state. Each must go RED. Report
`total=N red=N missed=0`.

## Gate

```
python Godot/tools/check_scripts.py <each .gd you touched>
python Godot/tools/run_tests.py --only corner
python Godot/tools/run_tests.py --only ui
```

`--only ui` is 17 and must not go down. `--only` DOES NOT STACK - one per
invocation, and read `total=` to confirm how many ran.

## Rules

- **DO NOT fetch or rebase** - the checkout is shared and current. Never
  `git stash`, `reset --hard` or `add -A`; stage explicit paths only.
- Read only the files named above. Do not read `HANDOFF.md`,
  `CURRENT_STATUS.md` or any digest.
- Use Kalli's words. If you need a sentence she did not write, say so rather
  than inventing one - copy is hers.
- End with the mutant table, both `--only` numbers, and **what is still wrong**.

## AND IT GOES IN THE FIGHT SCENE, NOT ONLY A SEPARATE SCREEN

**Operator, 2026-09-22: "this should be implemented to the fight scene too."**

The live 3D room is `Godot/scenes/FightWorldLive.tscn`, driven by
`FightWorldLiveScreen.gd`, with `RingStagePanel.gd` already drawing the HUD
over it - the callout line, the fighter readouts, the round clock. That panel
is the house pattern for anything that sits on top of the fight, and the corner
belongs there between rounds rather than in a screen the player is thrown to.

So there are TWO surfaces and they share one source of truth:

- **In the room, between rounds.** The bout is live, the bodies are still
  there, the round has just ended. The corner panel appears over the fight the
  way a HUD element does, takes the instruction, and gets out of the way. It
  must not stop the room rendering and must not require a scene change.
- **The standalone screen** for the flows that are not the 3D room.

**Build the panel ONCE and mount it in both.** Two copies of the same options
list is exactly how a hardcoded list drifts from the adapter's, which is the
defect check 1 exists to catch.

**Two traps the room will hand you, both real and both cost a pass here today:**

- `RingStagePanel._say_event` handles `chain` and `action` only. A beat whose
  `type` is anything else - `grapple`, for one - **returns early and is
  silently dropped.** If you hook a corner event through that function, verify
  it actually arrives rather than assuming it does.
- The camera is now free: the player can orbit and zoom during the fight
  (`FightWorldLiveScreen._unhandled_input`). Your panel must take its clicks
  through `_gui_input` or equivalent so a drag on the panel does not also spin
  the camera, and a drag on the room still does.
