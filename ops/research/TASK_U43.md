# TASK U43 — CURSOR — THE BEAT LEARNS THE TECHNIQUE IT WAS ALWAYS MISSING

Model: cursor-agent `-p --force --trust`, **medium** effort.
Owner: cursor. Deliverable: `Godot/scripts/FightBeatAdapter.gd` +
`Godot/tests/fight_beat_technique_test.gd` (new) + `research/U43_DIGEST.md`.
Owned files: those three. **Nothing else** — and specifically **not**
`Godot/scripts/FightRealtime.gd`, which Claude is editing in parallel right now.

**Tier: parse gate, then `python Godot/tools/run_tests.py --only beat` and
`--only broadcast`. NOT the full suite** — Claude runs that once at integration.

## Why this exists

`FightBeatAdapter.gd:37` carries an apology:

> The one field that had to be left empty is `range_band`. The view says a
> band; the engine names a distance and never names a technique.

and `:394` fills `beat["technique_name"]` out of `REGION_WORDS` — the honest
placeholder R97 could write, because there was no technique to name.

**R101 is landing the technique right now.** The engine's impact record gains
six fields, and this task is the half that reads them.

## THE CONTRACT — the impact record after R101

`FightRealtime._run_impact` returns these **in addition to** everything it
already returns (`region`, `force`, `contact`, `distance`, `place`, `wear`, …):

| field | type | meaning |
|---|---|---|
| `technique` | String | the catalogue node id, e.g. `"boxing_jab"`. **Empty string** when the thrower had no legal move for the situation and the engine fell back to the old region roll. |
| `technique_name` | String | the catalogue display name, e.g. `"Jab"`. Empty exactly when `technique` is empty. |
| `role` | String | the node's match role: one of `setup damage counter defense control takedown transition escape submission adaptation`. Empty exactly when `technique` is empty. |
| `band` | String | `"LONG"`, `"MID"`, `"POCKET"` or `"CLINCH"`. **Never empty** — it is derived from the separation and does not depend on a technique being found. |
| `position` | String | `"distance"`, `"clinch"` or `"ground"`. FightMetric's position axis, off the grapple stance. |
| `significant` | bool | FightMetric's rule: **any** strike at `distance`, plus **power** strikes in clinch and on the ground. A distance jab is significant; a short clinch strike is not. |

**Treat every one of them as optional on read.** Use `.get(key, default)`. Logs
written before R101 do not carry them and a beat built from an old log must not
break. That is the same discipline U32 used when the grapple arrived.

## What to build

1. **`range_band` stops being empty.** Fill `beat["range_band"]` from the
   record's `band`. Delete the apology at `:37` and replace it with what the
   field now means. If the record has no `band` (an old log), leave it empty —
   empty still means "the engine did not say", it just stops meaning "the engine
   can never say".

2. **`technique_name` prefers the real name.** When the record names a
   technique, the beat says *that*. When it does not, keep the existing
   `REGION_WORDS` fallback exactly as it is — it is still the honest word for a
   throw the engine could not name.

3. **M19'S RULE, AND IT IS THE POINT OF THIS TASK.** Maria's study
   (`research/M19_THE_MISSING_CLIP.md`) settled what the presenter does
   when a named technique has no clip, and R101 will name far more techniques
   than the ~13 clips we are buying — **a majority of throws having no clip is
   CORRECT, not a gap**:

   > play the matching-region **reaction on the receiver**, leave the thrower on
   > his current locomotion or idle, and **never play a different technique's
   > clip**.

   The beat must carry that decision explicitly rather than leaving it to the
   view to guess. Add a field saying whether a clip was found for this
   technique and what to play if not. `FightClipBinding.missing_roles()` is the
   existing precedent for degrading honestly; follow its shape, do not
   re-invent it. **Never substitute another technique's animation.** A beat that
   says "jab" and plays a hook is the lie this whole rule exists to forbid.

4. **The test asserts by OCCURRENCE, with a floor.** This area has shipped five
   pieces of correct, tested, unreachable code. `fight_beat_technique_test.gd`
   must run a real seeded bout through the engine and the adapter and assert
   that **named techniques actually arrive** — a floor on the count of beats
   carrying a non-empty `technique`, a floor on the number of DISTINCT
   techniques seen, and that **every band the ruleset can reach actually
   occurs**. Asserting that the field is *permitted* proves nothing.
   If R101 has not landed when you run, the fields will be absent and the test
   will be red — **say so in your mail, do not weaken the assertion to make it
   green.**

## The traps

- **Do not edit `FightRealtime.gd`.** Claude is in it. A concurrent edit there
  loses one of us a stage.
- **Do not edit any pinned test or any judge scorecard.** R101 moves those and
  Claude re-pins them once, deliberately, in one commit.
- **`beat["technique_name"]` already exists** and views read it. Widening what
  fills it is fine; changing its type or removing it is not.
- Godot's `N RID allocations … leaked at exit` is teardown chatter, not a
  failure.
- `rc=0 is NOT a pass`. Read the runner's own `SUITE total=N fails=M` line.

## When you are done

Rebase on `origin/master`, stage only your three paths, commit, push, and send
one line:
`python Tools/agent_comms.py send --from cursor --to claude --subject "U43-done" --body "<sha> <beats with a technique / distinct techniques / bands seen> <clip-missing behaviour>"`.
Do **not** edit `HANDOFF.md` — Claude writes your block.
