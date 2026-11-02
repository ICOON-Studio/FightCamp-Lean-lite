# TASK R73 — CLAUDE — THE GOAL WITHOUT A BELT

Model: Opus 5, effort **high**, Fast off. One session.

**Agent:** claude · **Model:** Opus 5, effort **high**, Fast **off** ·
**Opened:** 2026-09-08 · **Depends on:** R70 (landed), C52 (landed, `cb376bd`)

## The hole, verified before writing this file

R70 retired every standing belt in the six `event` disciplines
(`championship_rules.json` `belt_authority`: wrestling, judo,
brazilian_jiu_jitsu, taekwondo, sanda, sambo). Nothing downstream was told.

1. `CareerGoals.gate("champion")` (`Godot/scripts/CareerGoals.gd:77-78`)
   returns `not holds_title`. In an event discipline `holds_title` is now
   permanently false, so **BECOME CHAMPION is permanently live and can never
   complete** — `progress` (`:101-108`) reaches 100 only via `holds_title`
   and otherwise caps at 50.
2. The goal promotes the `title_shot` ask
   (`Godot/assets/data/career_goals.json:45`).
   `FighterRequests.trigger_holds("title_shot")`
   (`Godot/scripts/FighterRequests.gd:83-85`) tests rank, win streak and
   `holds_title` — **it never asks whether a belt exists** — so the fighter
   does raise the ask.
3. `booking_satisfies("title_shot")` (`:167-168`) needs `champion_opponent`,
   which comes from `_title_shot_champion_for`
   (`Godot/scripts/GameState.gd:9457-9466`). That reads
   `get_championships().get(key, {})`, the key does not exist, and it returns
   `{}` at `:9461`. Its two callers (`:9491`, `:9515`) then drop the offer.

**So a judoka asks for a title shot the world cannot book, forever, and is
never satisfied.** That is the whole bug: an ask that can be raised and can
never be answered.

## What to build

**1. The context learns whether a belt exists.**
`_career_goal_context` (`GameState.gd:6167-6176`) adds
`context["division_bears_belt"] = WorldPopulation.discipline_bears_belt(
str(athlete.get("discipline", "")))`. `discipline_bears_belt` already exists at
`Godot/scripts/WorldPopulation.gd:120` — do NOT write a second classifier and
do NOT read the JSON from anywhere else. `_request_context` gets the same key
so `FighterRequests` can see it.

**2. `champion` closes where no belt exists.**
`CareerGoals.gate("champion")` becomes
`not holds_title and bool(context.get("division_bears_belt", true))`. The
default is `true` so every existing caller and test that passes no such key
behaves exactly as today.

**3. A goal that CAN complete replaces it: `top_of_the_ladder`.**
New row in `career_goals.json` — `{"id": "top_of_the_ladder", "label": "NUMBER
ONE", "icon": "trophy", "ask": "step_up", "suppresses": "", "blurb": "Be the
best in the division."}` — plus a `personality_shift` row mirroring
`champion`'s weights (Ambitious 0.35, Fearless 0.3, Reserved -0.1).

* `gate`: `not bool(context.get("division_bears_belt", true))` and `rank != 1`.
  It is the belt-less world's version of `champion`, so the two are mutually
  exclusive by construction and a fighter never sees both.
* `progress`: from `rank` only, which the save already holds — rank 1 is 100,
  2-3 is 75, 4-8 is 50, 9-15 is 25, unranked (`rank <= 0` or `> 15`) is 0.
* `urgency`: 0.8 at rank 2-3, 0.5 at 4-8, 0.2 otherwise — `champion`'s shape.

Progress comes only from state the save holds (the standing R14 rule). It does
NOT come from medals: the `event_result` object C52 specified does not exist
yet, and this task must not invent it. When G23's `EventResult.gd` and the
event object land, a medal goal supersedes this one — say so in the digest, do
not pre-build it.

**4. The unanswerable ask is never raised.**
`FighterRequests.trigger_holds("title_shot")` gains
`and bool(context.get("division_bears_belt", true))`. Same defaulting rule.

## Owned files

* `Godot/scripts/CareerGoals.gd` (221 lines — read whole)
* `Godot/scripts/FighterRequests.gd` (215 lines — read whole)
* `Godot/assets/data/career_goals.json`
* `Godot/scripts/GameState.gd` — **12,900+ lines, never open it whole.** Only
  two windows: `sed -n '6167,6196p'` (`_career_goal_context`) and the
  `_request_context` builder.
* `Godot/tests/career_goals_test.gd` (extend; create if absent)

Do NOT touch `WorldPopulation.gd`, `championship_rules.json`,
`_title_shot_champion_for`, or any panel. `DevelopmentPanel.gd` belongs to U13
this week.

## Gates

```bash
python Godot/tools/check_scripts.py Godot/scripts/CareerGoals.gd Godot/scripts/FighterRequests.gd Godot/scripts/GameState.gd
```

Focused, then the full suite once in the background before the commit:

```bash
"$GODOT" --headless --path Godot --script tests/career_goals_test.gd
```

Also run `fighter_requests_test.gd` and `ambitions_test.gd` — both read the
same context builder.

## The trap

`gate()` and `trigger_holds()` are called from tests that build their context
dictionaries by hand and will not carry the new key. **Default it to `true`
everywhere**, or every belt-bearing assertion in the existing suite flips.
