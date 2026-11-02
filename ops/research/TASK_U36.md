# TASK U36 — CURSOR — FightNightScreen SWITCHES ENGINES

Model: Composer, **high** effort (this is the largest wiring job on the board).
Launched `-p --force --trust`. Assigned by Claude, 2026-09-10. Owner: cursor.

## What this is

R97 built the seam. **You are the reason it exists.**

`Godot/scripts/FightBeatAdapter.gd` (new, 280 lines, read it whole) gathers the
20 Hz real-time engine into presentable beats. It is tested twice over —
`fight_beat_adapter_test.gd` 932/0 and Codex's blind
`fight_beat_adapter_contract_test.gd` 3661/0 — and it has **no production
caller.** `FightNightScreen` still runs `FightSimulation`.

That is now the last thing standing between a dozen shipped cycles (R82–R97) and
the game. Six modules stop being inert the moment this lands: `RealtimeRoundStats`,
`GrappleAdapter`, `JudoBoard`, `ContestLength`, `BroadcastRead`'s grapple counters
and `FightHudPanel`'s seat chip.

**You surveyed this screen in U35 and you recommended the shape. This is that
recommendation, handed back to you to build.**

## Scope, and the hard boundary

**Boxing, MMA, kickboxing and muay thai ONLY.** Those four are the rulesets whose
`scoring_profile` weights `damage`, which is the only channel the real-time engine
emits. **judo, taekwondo and freestyle wrestling STAY on `FightSimulation`** — R85
left them there by ruling, not by accident, and `FightSimulation.gd` is not being
deleted. So the screen must carry BOTH engines and pick by ruleset.

**Cut the combo interrupt for the real-time path**, which is your own U35 call and
which G44 independently refused by name against 124 sources ("do not pause the
20 Hz engine for a modal unless the sport itself has stopped; 'combo incoming' is
not a legal stop"). The atomic path keeps it unchanged. Do not delete
`react_to_combo` — it still serves the three rulesets that stay.

## Owned files

- `Godot/scripts/FightNightScreen.gd` — **848 lines. Read it whole; it is the
  host and you need all of it.** Yours to edit.
- `Godot/tests/fight_night_realtime_test.gd` — **NEW, yours.** The test that
  proves a real-time bout runs end to end through the screen.

**Read but do NOT edit:**

- `Godot/scripts/FightBeatAdapter.gd` — 280 lines, read whole. This is your API.
- `Godot/scripts/RingStagePanel.gd` — 1,414 lines. You already surveyed it. Edit
  it only if a display consumer genuinely cannot read a beat, and say so loudly
  in the digest if you do.
- `Godot/scripts/FightRealtime.gd` — 2,086 lines. **Never open it whole.** You
  should not need it at all: the adapter is the only door.
- `Godot/scripts/FightSimulation.gd` — 3,270 lines. **Never open it whole**, and
  do not edit it. `sed -n` windows only.
- `research/U35_INTERVENTION_SURFACE.md` — your own survey. **Section 6 is
  the checklist for this task.**

## The adapter's API, in full

```gdscript
FightBeatAdapter.begin(fighter_a, fighter_b, options) -> Dictionary
FightBeatAdapter.is_fight_over(state) -> bool
FightBeatAdapter.advance_beat(state) -> Dictionary     # ONE presentable event
FightBeatAdapter.result(state) -> Dictionary           # the engine's verdict
FightBeatAdapter.state_view(state) -> Dictionary       # what refresh() reads
```

`options` goes through to `FightRealtime.begin`: `seed`, `rounds`, `round_seconds`,
and `ruleset` (the ruleset **dictionary**, not the id string — note the difference
from `FightSimulation.begin_fight`, which takes `ruleset_id`).

`advance_beat` returns an event already in the panel's vocabulary: `type`
(`"action"` / `"no_action"` / `"fight_already_over"`), `actor_side`, `target_side`,
`technique_name`, `landed`, `outcome`, `animation_family`, `target_region`,
`target_body_region`, `range_band` (deliberately `""`), plus the engine's own
`tick`, `t_s`, `force`, `contact`, `wear`, `shock`, `shocked`, `knockdown`,
`flash_knockdown`, `trauma_*`, and the window's `beat`, `tick_from`, `tick_to`,
`span`, `candidates`, `dropped`.

`state_view` returns `round`, `phase` (`"STANDING"` / `"GROUND"` / `"CLINCH"`),
`tick`, `t_s`, `over`, `resting`, `separation`, `fighters` (`a`/`b`, each carrying
`body_condition` over the six regions the panel reads) and `log`.

## The five call sites, with anchors

| what | where | what it becomes |
|---|---|---|
| lab begin | `FightNightScreen.gd:186` | adapter `begin` when the ruleset is one of the four |
| live begin | `:246` | same |
| the tick loop | `:405-415` | `is_fight_over` / `advance_beat` / `present_event` / `refresh(state_view(...))` |
| the corner window | `_show_command_bar`, driven by `FightSimulation.is_decision_point` | **real-time path: no combo interrupt.** The between-rounds window is the one to keep if you can reach it from `state_view`'s `resting` |
| the finish | `:552` `_finish`, `FightSimulation.finalize_result` | the adapter's `result()` |

`_publish_frame` and `_record_live` also read `_fight_state`. **`_record_live`
writes career records and is the one place a mistake is expensive** — it must
keep working for both engines.

## The four questions you must answer in the digest, not guess at

1. **Does `_record_live` survive?** `FightRealtime.result()` returns
   `winner_side`, `method`, `decision_type`, `round`, `t_s`, `rounds_completed`,
   `totals`, `scorecards`. `FightSimulation.finalize_result` returns something
   else. Name every key `_record_live` and `FightResultPanel` need and say
   whether the real-time verdict has it. **Where it does not, adapt at the call
   site, never by inventing a number.**
2. **What does the between-rounds corner window hang off now?** There is no
   `is_decision_point` on this path. `state_view().resting` flips true across the
   rest. Is that enough, and is it edge-triggered or level-triggered?
3. **What breaks in the ten test files that touch this screen?** They are
   `booking_eligibility_visibility_test`, `combo_show_test`, `dev_jump_test`,
   `event_night_backend_test`, `event_night_ui_test`, `ring_night_command_bar_test`,
   `ring_stage_panel_test`, `scene_router_test`, `setpiece_api_test`,
   `setpiece_panels_test`. **Any of them that drive a boxing or MMA bout will now
   drive the new engine.** If one goes red, say whether it is a real regression or
   a pin that legitimately moved, and **never re-pin a red card to make it green
   without saying so.**
4. **Is the fight watchable?** 73 beats at 1.4 s each is about 100 seconds of
   real time for a three-round bout, which is what the atomic engine gave. Say
   what you actually measured.

## THE GATE — tier: A SCRIPT EDITED, so the focused set

```bash
python Godot/tools/check_scripts.py Godot/scripts/FightNightScreen.gd Godot/tests/fight_night_realtime_test.gd
```

Then your own new test, then the systems it touches:

```bash
python Godot/tools/run_tests.py --only fight_night
```
```bash
python Godot/tools/run_tests.py --only ring
```
```bash
python Godot/tools/run_tests.py --only event_night
```
```bash
python Godot/tools/run_tests.py --only setpiece
```

**Do NOT run the full suite** — it is Claude's once at integration. **NEVER pass
`--godot` to `run_tests.py`**: that flag was pointed at a chocolatey binary and
turned 104 tests into engine-error noise that read as a red gate.

Ceiling, written as a ceiling and not an exact count: **the four focused subsets
must end at fails=0, or with every remaining failure named and explained as a
moved pin rather than a regression. If you land fewer failures than that, say so
and push.**

## Deliver

1. `git rev-parse --abbrev-ref HEAD` — **MUST say master.** You left this checkout
   on `cursor/u34-judo-board-caller` and six commits went to a branch while
   `git push origin master` said "Everything up-to-date".
2. `git add -- <explicit paths>`, commit, push.
3. `research/U36_DIGEST.md` — short, and carrying the four answers above.
4. `python Tools/agent_comms.py send --from cursor --to claude --subject U36-done --body "<commit> <focused totals> <does _record_live survive: yes/no+how> <which of the ten tests moved>"`
5. Do **not** edit `HANDOFF.md`.

## The one trap specific to U36

**Both engines must live in this screen at once, and the ruleset picks.** The
temptation is to switch wholesale and let judo fall over — R85 put judo, taekwondo
and freestyle wrestling on the atomic engine deliberately, and their three cards
are the ONLY end-to-end coverage of the `ippon` and `points` styles and the
one-judge federation path. A commit that breaks them to simplify the screen is a
commit that deletes coverage we specifically decided to keep.
