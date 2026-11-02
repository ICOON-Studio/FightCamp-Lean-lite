# TASK R101 — CLAUDE — THE FIGHT READS THE CATALOGUE

Model: Opus, **high** effort, Fast OFF. This is the engine's decision core.
Owner: claude. Tier: **THE FULL SUITE, ONCE, AT INTEGRATION** — this is the
integration stage and it moves every seeded fight.

## The finding this stage exists to act on

**The game already models everything the fight was about to have invented for
it, and the real-time engine reads none of it.**

| what the operator asked for | where it already lives | read by `FightRealtime`? |
|---|---|---|
| personality | `athlete["personality"]`, 8 labels, `CareerGoals.personality_of` | **no** |
| aggression | `FightPlans.PACES` = cautious / balanced / aggressive, and `pace_for_round()` varies it by round | **no** |
| fight plan | `athlete["fight_plan"]` + `FightPlans.gd`: `target_bias`, `role_map`, `phase_factor` | **no** |
| situation awareness | the `fight_iq` stat | **no** |
| a palette of moves | `assets/data/technique_catalog.json` — **272 nodes, 15 disciplines** | **no** |
| which moves this man knows | `athlete["technique_progress"]`, `["discipline_proficiency"]` | **no** |

Verified: `grep -c "personality\|fight_plan" Godot/scripts/FightRealtime.gd` → **0**.
`grep -c "technique_progress\|discipline_proficiency" …` → **0**.

Every technique node already carries what a move needs:

```
boxing_jab       role setup    phases [standing]         range_band [LONG, MID]
                 effects accuracy 7, range_control 6, combo_open 5
                 requires technique 25, speed 25, prereq boxing_stance_guard, 80 reps
boxing_lead_hook role damage   phases [standing, pocket] range_band [MID, POCKET]
                 effects damage 10, angle_attack 7
boxing_slip_counter role counter  range_band [MID]  effects evasion 9, counter_accuracy 10
```

Ten roles: setup, damage, counter, defense, control, takedown, transition,
escape, submission, adaptation.

**So this stage is not a design exercise. It is a connection.**

## The two defects it closes

1. **`FightRealtime.gd:1287` — who throws next is an unweighted coin flip**,
   `rng.randf() < 0.5`, every impact. No combinations, no counters, no
   initiative, and a far better striker throws exactly as often as the man he is
   beating.
2. **The region is rolled from a shared weight table** before anything knows what
   technique was thrown — which is why Q39 could derive neither *significant
   strikes* nor *strike types*, and why boxing emits 12% leg strikes.

**The shape of the fix, and the ordering is the whole point:** a fighter decides
whether to initiate, then **selects a move he has actually trained** whose
`range_band` fits the current separation and whose `role` fits his plan — and
**region and force fall OUT of that move** rather than being rolled first.

## What must land before a line is written

- **G49** (Grok): what a real striking exchange is made of — combination length,
  the true conditional for "who throws next", whether momentum is real. It is
  asked sceptically; if momentum is mostly a narrator's illusion, the coin flip
  is less wrong than it looks and this stage gets simpler.
- **J21** (John): what a "move" is in models people take seriously, the minimum
  property set, the selection mechanism, and **the definition of a significant
  strike** — which we must match to be scored against UFC Stats.
- **J20** (John): the validation corpus. The scoreboard this stage will be
  measured against.
- **C85** (Codex): the ruleset-aware target picker. **Land it FIRST and rebaseline
  once** — it moves the same pins this stage does, and re-pinning twice for one
  day's work is waste.

Do not start until G49 and J21 are in. An engine decision core built on intuition
is exactly what this project has spent the day removing.

## The rules that govern it

- **`range_band` is the bridge.** The catalogue speaks LONG / MID / POCKET; G47's
  anatomy gives long ~1.1–1.5 m, pocket ~0.6–1.1 m, clinch ≲0.5–0.6 m; the engine
  measures a separation in metres. **R97's `FightBeatAdapter` emits `range_band`
  EMPTY** with a comment saying the engine names a distance and never a band —
  that mapping has been waiting for this stage. Fill it once, in one place.
- **A fighter may only throw what he has trained.** `requires` and
  `technique_progress` exist; a fighter throwing a move he never learned is the
  same class of lie as inventing an event.
- **Determinism is not negotiable.** R82's byte-exact replay is the foundation
  everything since rests on. Draws stay unconditional and counted; a move
  selection that draws a variable number of times per tick makes the stream
  position depend on the fight's content.
- **This moves every pinned scorecard.** R85's rule stands: nobody re-pins a red
  card to make it green. Re-run, re-pin deliberately, in one commit, and say
  which moved and why.
- Keep `FightSimulation.gd` — judo, taekwondo and freestyle wrestling still ride
  it by R85's ruling.

## The trap most likely to cost this stage

**Do not let the catalogue become a second engine.** 272 nodes with ten roles and
seven effect keys is enough rope to rebuild the whole fight inside a JSON file,
and the effects (`accuracy`, `damage`, `range_control`, `combo_open`, `evasion`,
`counter_accuracy`, `angle_attack`) are *not* on the same scale as anything
`ImpactModel` currently prices. **One module prices every blow in this game** —
that is C63's ruling and it is why `make_impact` exists. The move must feed
`ImpactModel`, never bypass it.

The second trap: **272 moves is a purchase list too.** We are buying ~13
animation clips. Most of the catalogue will never be shown, and that is correct —
but the beat presenter must degrade honestly when a move has no clip, exactly as
`FightClipBinding.missing_roles()` already does, and never substitute a different
technique's animation for the one that was thrown.
