# DESIGN THE FIGHT PLAN PROPERLY — IT IS THE PLAYER'S ONLY LEVER

**LONG-RUNNING TASK - it does not finish in one pass.** Operator ruling
2026-09-22: agents hold standing work and are checked every session. Claude
re-cuts this brief from what landed; it is never restarted from scratch.

**Owner:** grok. **Design only - write no code, change no file.** No checkout
and no Godot, so every answer is prose, tables and data shapes. Paid to
30 Sep and barely used: work this hard.

## What exists today, exactly

`Godot/assets/data/fight_plans.json` - **34 plans**, one to four per
discipline. Each has this shape, and this is a real one:

```json
{"id": "boxing_out_boxer", "rulesets": ["boxing"], "name": "Out-boxer",
 "coach_line": "Distance and footwork. Jab, move, make them chase you.",
 "role_priority": {"setup": "PRIMARY", "counter": "PRIMARY", "damage": "SECONDARY"},
 "pace_curve": ["cautious", "balanced", "balanced"],
 "target_bias": {"head": 1.0, "body": 0.7, "legs": 0.3},
 "phase": "standing", "excludes_emphasis": "grappling",
 "requires": {"competency": "striking", "roles": {"setup": 1}},
 "banks": "clean punches and ring generalship"}
```

`Godot/scripts/FightPlans.gd` loads them. The engine reads `plan_alignment`
when it scores a technique.

## Why this matters more than it looks

**The fight plan is the ONLY thing the player chooses that changes how a fight
is fought.** Everything else - attributes, learned techniques, the opponent -
is set before the bell. If two plans produce the same fight, the player has no
lever at all.

## The standing questions, in priority order

1. **DO THE 34 PLANS ACTUALLY DIFFER?** `pace_curve`, `target_bias` and
   `role_priority` are the whole of a plan's mechanical content. Work out, from
   the data shape alone, how much of the space they can express - and say which
   pairs of plans are so close that no player could tell them apart. Name the
   pairs. This is the most useful thing you can produce and it needs no code.
2. **WHAT IS MISSING FROM THE SHAPE?** A real game plan says things this schema
   cannot: what to do when you are hurt, when to change plan, what to refuse,
   how to treat the other man's known strength. Propose the smallest set of new
   fields that buys the most, and for each one say what the engine would have
   to read for it to matter. A field nothing reads is decoration.
3. **THE PLAN SHOULD RESPOND TO THE FIGHT.** `pace_curve` is three words, one
   per round, fixed before the bell. A corner can change instructions between
   rounds (`FightBeatAdapter.CORNER_OPTIONS` exists), so a plan that cannot
   change is already inconsistent with the rest of the game. Design the
   relationship between the plan and the corner.
4. **GRAPPLING PLANS ARE THIN.** `phase` is a single word and
   `excludes_emphasis` is a blunt instrument. A BJJ guard player and a BJJ
   passer differ in ways `target_bias: {head, body, legs}` cannot say at all.
   Propose what a ground plan needs.
5. **COACH LINES.** One sentence per plan, and they are the player's whole
   understanding of what they picked. Say which of the 34 mislead.

## Rules

- **Do not invent a number you cannot justify.** If a weight should exist, say
  what it does and what would set it - not a value you made up.
- **Every proposal names what READS it.** A plan field that no part of the
  engine consumes is worse than nothing, because it looks like a feature.
- Work from the schema above. You have no checkout; you do not need one.
- **Say what you would NOT add**, and why. That half is usually the useful one.

## Every pass ends with an artefact and a line saying what is still wrong

A table, a schema proposal, a named list of indistinguishable plans - something
that can be argued with. A pass that reports the design is finished is the one
that gets checked hardest.
