# TASK C85 — CODEX — THE TARGET PICKER LEARNS THE RULESET

Model: Codex, **high** effort, Fast OFF.
Owner: codex. Tier: **A SCRIPT IS EDITED** — parse gate, then
`python Godot/tools/run_tests.py --only fight` and `--only judge`. The full suite
is Claude's at integration.

**DO NOT START THIS UNTIL CLAUDE SAYS THE SUITE IS CLEAR.** A rebaseline of every
seeded fight is in flight; starting early corrupts both.

## Why this exists — a defect with a named cause at last

R84 ruled the strike-target distribution: **0.60 head / 0.28 torso / 0.06 each
leg, arms deliberately 0.00**. That ruling was for MMA and it was right for MMA.

**It is applied to every ruleset in the game.** Q39 (`2aeb62f`) measured a boxing
bout and found **12.1% of landed strikes are LEG strikes**, and named the cause:
`TARGET_WEIGHTS` is a single shared table with no per-ruleset override. A boxer
throws kicks, in 12% of his landed work, and has since the distribution was
written.

This has been reported three separate times and fixed none of them — R99 found
it in the stage director and kept its mapping faithful **on purpose**, because
showing a body shot for a leg strike would be presenting a different exchange.
The mapping was never the defect. **This is the defect, and this is where it is
fixed.**

It also has a direct money consequence: the animation purchase list was nearly
sized to include kick footage for a boxing game.

## What to do

Give the target distribution a **per-ruleset table**, defaulting to R84's
existing weights so nothing that is right today changes.

- **Boxing:** head and torso only. **Legs 0.00, arms 0.00.** A boxer cannot
  legally strike a leg, so this is not tuning, it is the rulebook.
- **MMA, kickboxing, muay thai:** R84's weights stand unchanged. Do not touch
  them; they are a ruling and they are not yours to revisit.
- **Anything else:** the existing default.
- **Renormalise.** When legs come out, their weight goes to head and torso in
  their existing proportion — do not leave a distribution summing to 0.88, and
  do not silently hand the whole 0.12 to the head. Say in the digest which way
  you sent it and why.

Where the ruleset name comes from is your first question to answer from the
code, not from guessing — `FightRealtime` already carries the ruleset for the
scoring profile and the stall ladder. **Find how those reach the tick and use the
same route.** Do not add a new parameter to a public function if the state
already holds it.

## Anchors — read WINDOWS, never the whole file

`FightRealtime.gd` is ~2100 lines. **Never open it whole.**
- `grep -n "TARGET_WEIGHTS" Godot/scripts/*.gd` — start here; the table may live
  in `ImpactModel.gd` rather than the engine.
- `sed -n '1420,1470p' Godot/scripts/FightRealtime.gd` — where an impact is built
  and the region chosen.
- `grep -n "ruleset" Godot/scripts/FightRealtime.gd | head -30` — how the ruleset
  already reaches the tick.
`research/Q39_OUR_NUMBERS.md` is the measurement that found this — read its
target-distribution section, not the whole file.

## What the test must prove

**Assert the feature OCCURS, not that it is permitted.** Run real seeded bouts.

1. **A boxing bout produces ZERO leg strikes** over a decent sample — and this is
   the one place an exact zero IS the correct gate, because it is a rule, not a
   rate. Say so in a comment so nobody later "fixes" it into a ceiling.
2. **An MMA bout still produces leg strikes**, at a rate close to what it
   produced before. **A change that silences legs everywhere is the same bug
   wearing the other hat** — assert MMA legs are non-zero and print the share.
3. The head/torso split for boxing sums to 1.0 and neither is zero.
4. Print both distributions. A future reader must be able to see what changed
   without re-deriving it.

## The pins — read this before you commit

This moves seeded fights. **R85's rule stands: nobody re-pins a red card to make
it green.** If a pinned scorecard moves:
- **Do not edit the pin file to match.**
- Report exactly which pins moved, and say so in your message.
- Claude re-pins deliberately, at integration, in one place.

That is not bureaucracy — a pinned card quietly edited to match new behaviour is
a suite that has stopped checking, which is precisely the R75 failure.

## Gate

```
python Godot/tools/check_scripts.py <every .gd you touched>
python Godot/tools/run_tests.py --only fight
python Godot/tools/run_tests.py --only judge
```

**rc=0 is NOT a pass (R75).** Read the output. **Never pass `--godot` to
`run_tests.py`.** `git status -s` first, `git add -- <explicit paths>` only, push
**master**, `git rev-parse --abbrev-ref HEAD` before believing it landed.

`python Tools/agent_comms.py send --from codex --to claude --subject C85-done --body "<sha> boxing-legs=0 mma-legs=<n>% renormalised-to=<head/torso> fight=<n>/<f> judge=<n>/<f> pins-moved=<list-or-none>"`

Do NOT edit `HANDOFF.md`.

**The one trap specific to this task:** the tempting shortcut is to zero the leg
weights for boxing and stop. Then the distribution sums to 0.88, every other
weight is silently inflated by the normaliser — or worse, is not — and the head
share moves for a reason nobody wrote down. **Renormalise explicitly and say
which way.** A distribution that does not sum to one is a defect that will be
found months later by someone measuring something else entirely.
