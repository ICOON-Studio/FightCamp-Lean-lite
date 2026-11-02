# TASK G151 - WC1: the weight cut as a fight-week decision - research and spec, no code (Grok, S133)

Model: Grok Build CLI default. Worktree `D:/FightCamp/wt/G148` re-branched `grok/g151-weight-cut-spec` from master.

## Why
Dola's D66 mechanic G (`research/D66_STRICT_REVIEW.md`): "Weight Cut Tension System - aggressive cut = size
advantage but drained stamina; conservative = fresh but physically smaller". Roadmap backlog WC1: "fight week offers a
cut depth; deeper = weight edge + stamina/durability cost at the bell, missing weight = fine; sourced ranges before
numbers". This task is the SOURCED RANGES and the spec - someone codes it after.

## Prior research (read first - do not redo what exists)
`python Tools/prior_research.py weight cut rehydration weigh-in dehydration` and read what it names (the J-series on
weigh-ins and weight classes, J53 handbook terms, the fight-week screen notes). Our engine side: `Godot/scripts/`
grep `weigh`, `walk_weight`, `weight_cut` to see what the game already models.

## What would a human do?
A sports scientist + designer: collect the measured numbers (typical cut % of body mass for boxers, rehydration gained
between weigh-in and the bout, the performance effects measured at each cut depth, the documented dangers), then write a
three-choice decision (light / standard / hard cut) whose effects are those numbers, mapped onto variables the engine
already has (stamina at the bell, conditioning, durability/chin, weight difference).

## Prefab check
Research-only. Sources: peer-reviewed studies (Reale, Barley, Crighton, Franchini, Matthews and others on combat-sport
weight making), commission rules for weigh-ins (ABC, same-day checks where they exist). Label every number DOCUMENTED
(a measured study), SECONDARY or NO STUDY, with the source and year.

## Owned files
NEW `research/G151_WEIGHT_CUT_SPEC.md` only.

## Deliver
`G151_WEIGHT_CUT_SPEC.md`: (1) a sourced table of numbers with labels; (2) the three-choice spec with each choice's
effects in engine variables (name the variable and file where it lives - grep, do not guess); (3) what the fight-week
screen shows before the choice (plain words, one line each); (4) the risks (e.g. a hard cut that misses weight). Under
1,200 words. `git add` the one file, commit, `git push -u origin grok/g151-weight-cut-spec`. No code changes.
