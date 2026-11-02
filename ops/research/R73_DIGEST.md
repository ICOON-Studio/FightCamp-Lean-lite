# R73 DIGEST — The goal without a belt

**Agent:** claude · **Landed:** 2026-09-08 · **Depends on:** R70 (landed),
C52 (`cb376bd`)

## What was broken

R70 retired every standing belt in the six `event` disciplines — wrestling,
judo, brazilian jiu jitsu, taekwondo, sanda, sambo — and nothing downstream
was told. Three seams, one chain:

1. `CareerGoals.gate("champion")` tested only `not holds_title`. In an event
   discipline that is permanently true, so **BECOME CHAMPION was permanently
   live and could never complete** — its progress reaches 100 only through
   `holds_title` and otherwise caps at 50.
2. The goal promotes the `title_shot` ask, and
   `FighterRequests.trigger_holds("title_shot")` never asked whether a belt
   existed, so the fighter raised it.
3. `booking_satisfies("title_shot")` needs a champion opponent, which comes
   from `GameState._title_shot_champion_for` — and that returns `{}` because
   `get_championships()` has no key for the division.

**A judoka asked for a title shot the world could not book, forever, and was
never satisfied.** An ask that can be raised and never answered.

## What changed

**1. One classifier, not a second one.** `_request_context`
(`GameState.gd:6620`) now carries
`division_bears_belt = WorldPopulation.discipline_bears_belt(discipline)`.
That is R70's own accessor (`WorldPopulation.gd:120`); nothing re-reads
`championship_rules.json`. `_career_goal_context` (`:6167`) copies it across.

**2. `champion` closes where no belt exists.** `gate("champion")` is now
`not holds_title and bears_belt`.

**3. `top_of_the_ladder` — NUMBER ONE — opens in its place.** The belt-less
world's version of BECOME CHAMPION, gated on `not bears_belt and rank != 1`,
so the two are **mutually exclusive by construction** and a fighter never sees
both. Progress comes from `rank` alone — 1 is 100, 2-3 is 75, 4-8 is 50, 9-15
is 25, unranked 0 — which is state the save already holds, per the standing
R14 rule. Urgency is `champion`'s shape shifted one rank up. It promotes the
`step_up` ask, which the world can actually answer.

**4. The unanswerable ask is never raised.** `trigger_holds("title_shot")`
returns false where no belt exists, before it looks at rank or streak.

**Every new context key defaults to `true`.** A caller that builds its context
by hand — which is most of the existing suite — behaves exactly as it did
before R73. That defaulting is asserted three times in the test rather than
assumed.

## What this deliberately does NOT do

* **No medals.** Progress does not come from event results: the `event_result`
  object C52 specified does not exist yet (G23 is writing the pure module for
  it). When it lands, a medal goal supersedes NUMBER ONE — that is the follow
  up, and it was not pre-built here.
* `_title_shot_champion_for` is untouched. Returning `{}` where no belt exists
  is correct; the fix was to stop asking.
* No panel, no token, no `WorldPopulation.gd` and no `championship_rules.json`
  edit.

## Files

`Godot/scripts/CareerGoals.gd`, `Godot/scripts/FighterRequests.gd`,
`Godot/scripts/GameState.gd` (two windows only),
`Godot/assets/data/career_goals.json`, `Godot/tests/career_goals_test.gd`.

## Verification

```bash
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/career_goals_test.gd
```

Parse gate 4/0. `career_goals_test` 0 failures (13 new assertions),
`fighter_requests_test` 0, `ambitions_test` 0, `smoke_test` 0.
