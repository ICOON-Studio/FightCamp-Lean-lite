# Q75 — What resists a stand-up

## The problem in one table

MMA matchups finish zero submissions despite high ground exchange counts. The MMA striker
(grapple 40, BJJ 35) stands up 81 times against the grappler (grapple 80, BJJ 76). The
Muay Thai striker stands up 80 times against the BJJ fighter. Meanwhile sambo — where
neither man is trying to stand up — finishes 21 of 278 submission lands. The bottom man
keeps getting to his feet, and nothing on top is stopping him.

## The mechanism: two rolls, one trap

An escape has to pass two gates. The first is the **land roll** in `_resolve_action`. The
escape is a technique with role `"escape"`, and like every action its success chance is:

```
success_chance = clampf(0.35 + 0.5 * execution_quality - defense_factor, 0.1, 0.95)
```

The `defense_factor` here is the **top man's** contribution. It is computed by
`_defender_defense_factor(target, ruleset_id, seat_phases, "escape")` multiplied by
`_mobility_factor(target)`. The function walks the top man's technique cache, summing
magnitudes of defence nodes whose phases overlap the current seat and whose effects answer
the incoming role. The answer test goes through `DEFENSE_ANSWERS` and `DEFENSE_CLASSES`:
an effect key answers `"escape"` only if `DEFENSE_ANSWERS[key]` contains a class whose
`DEFENSE_CLASSES` entry includes `"escape"`. No effect key in the current vocabulary
answers the escape class — `control_escape` answers `control`, `guard_control` answers
`control`, `guard_recovery` answers `control`. The technique bonus is therefore always
zero against escapes. But the base term remains:

```
clampf(defense_stat / 100.0 * 0.35 + 0.0, 0.0, 0.6)
```

The top man's defence stat still subtracts from the escape's land chance. A man with
defense 70 gets `0.7 * 0.35 = 0.245` off the success chance before the clamp. His
mobility scales it further via `_mobility_factor`. So the top man **is present** in the
land roll — just not through technique-specific escape counters, because none exist.

The second gate is `_resolve_escape_attempt`, called only after the escape lands. The
formula is:

```
escape_chance = clampf(0.3 + execution_quality * 0.35, 0.1, 0.85)
```

This roll reads **only the escaper's** execution quality. The top man's stats — grapple,
BJJ proficiency, defense, control techniques — do not appear. A single `rng.randf()`
decides it. On success the phase flips to STANDING, `top_side` clears, and the range
drops to CLINCH (they come up tied, matching R35). On failure the bottom man stays down
and the exchange continues.

**The trap**: the top man is not absent from an escape. He is absent from **one of its
two rolls**. He makes it harder to land (roll 1) but does nothing to resist the stand-up
once it lands (roll 2). This is why a high-grapple top man watches the striker stand up
repeatedly — the land roll slows the escape somewhat, but once through, the stand-up is
a coin weighted only by the escaper's quality.

## What clears a submission attempt

A submission accumulates pressure: `strength += magnitude * execution_quality` each land,
with `SUBMISSION_SWITCH_CARRY` preserving a fraction when the attacker switches technique.
The threshold is `SUBMISSION_BASE_THRESHOLD + defense * 0.35 + camp.sub_defense`. The
target's defense stat and camp sub-defense resist the finish, not the attempt. When the
bottom man has nothing eligible — no technique in his cache with role `"escape"` whose
phases match the current seat — `_fallback_action` returns `FALLBACK_ESCAPE`, a tier-1
action with magnitude derived from power and technique stats. It goes through the same
two-roll gate.

## Anchors on disk

Real MMA puts a figure on how long dominant ground position lasts. J20 records that the
UFC lightweight division averaged **17% of fight time in ground control** in 2018, with
Khabib Nurmagomedov at 41% — a specialist tail, not the mean. Across 3,850 UFC decisions,
the fighter with more control time wins **68.2%**, and the win rate climbs with the gap:
51% under one minute, 87.4% at five or more. These are broadcast-logged durations, not
weighted integrals — G38 notes that a man in closed guard for 2:14 has a control-time of
2:14 even though FightCamp scores that seat zero. The anchors confirm that ground control
is a real, measurable, outcome-predicting quantity in the sport, and that the sim should
expect a competent top man to hold position for meaningful stretches.

No anchor on disk gives a mean "how many exchanges a dominant position survives before
the bottom man stands up" — that number does not exist in the published literature. The
17% figure and the 68.2% win rate are the closest proxies: they say that control is real
and that it matters, which is what the sim must reproduce.

## Options

**Option a — the top man's control skill resists the stand-up roll.** Subtract a factor
derived from the top man's grapple and BJJ proficiency from `escape_chance` inside
`_resolve_escape_attempt`. This is the most direct fix: the stand-up roll currently reads
only the escaper; adding the top man's grappling ability makes a BJJ black belt on top
genuinely harder to stand up against. Touches only `_resolve_escape_attempt`. Predicts
submission finishes **up** in BJJ and both MMA matchups (more ground time = more attempts
converting), **same** in judo (Claude is building osaekomi this session) and sambo
(already finishing at 21 of 278 — the problem is not sambo).

**Option b — a landed pin sets a decaying hold bonus.** When the top man holds a dominant
seat (side control, mount, back) for consecutive exchanges, an additional threshold
accumulates that the next escape must beat. The bonus decays per exchange so it does not
compound forever. Touches `_resolve_action` (to track the hold counter) and
`_resolve_escape_attempt` (to read it). Predicts **up** in BJJ and both MMA, **same** in
judo and sambo. More invasive: it adds state to the fight_state dictionary and requires
a decay rule.

**Option c — a failed stand-up carries pressure.** When `_resolve_escape_attempt` lands
but the stand-up roll fails, the bottom man's escape does not zero the top man's
submission pressure — instead it carries `SUBMISSION_SWITCH_CARRY` of the existing
pressure forward. This makes repeated escape attempts accumulate threat rather than
clearing it. Touches only `_resolve_escape_attempt`. Predicts **up** in BJJ and both MMA,
**same** in judo and sambo. Elegant but indirect: it fixes finishes by making the
alternative (staying down) more dangerous, not by making the stand-up itself harder.

## Recommendation

**Option a.** It is the smallest change (one function, one line), it addresses the exact
gap the mechanism analysis found (the top man's absence from roll 2), and it maps to a
real combat fact: a BJJ black belt who has you in side control is harder to stand up
against than a novice, regardless of your own athleticism. Options b and c are viable
but add state or indirect pressure; option a closes the hole directly.

Judo is `same` for all options — osaekomi is Claude's build this session, and the judo
row (0 submission lands, 0 finishes) is a ruleset problem, not a stand-up problem.
