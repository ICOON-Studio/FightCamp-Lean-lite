# TASK_D10 - DOLA - WHAT ACTUALLY MAKES A THROW AN IPPON

**No checkout needed. Everything is inline.** Reply in chat with the ruling and
the derivation. **A runnable page only if you want to show the numbers moving -
the answer is the deliverable, not code.**

## The failing test, exactly as it fails

`fight_scoring_test` has been red for weeks and was never read. It says:

```
FAIL: a clean uchi-mata carries enough magnitude to be an ippon (19 >= 22)
FAIL: judo: a perfectly executed uchi-mata is IPPON and ends the bout at once
```

## How our engine decides an ippon today

**A technique's MAGNITUDE is the sum of the absolute values of its authored
effects, and nothing else:**

```gdscript
static func _technique_magnitude(technique: Dictionary) -> float:
    var effects := technique.get("match", {}).get("effects", {})
    var total := 0.0
    for key in effects:
        total += absf(float(effects[key]))
    return total
```

The judo ruleset then carries `"ippon_threshold": 22` and
`"ippon_by_points": 2.0` (two waza-ari make an ippon - awase-waza, which works).

So the three judo throws in our catalogue are:

| technique | tier | authored effects | **magnitude** | ippon at 22? |
|---|---|---|---|---|
| `judo_osotogari` | 1 | takedown 9, throw_setup 7 | **16** | no |
| `judo_uchimata` | 2 | takedown 11, throw_setup 8 | **19** | **no - this is the failure** |
| `judo_seoinage` | 4 | takedown 15, throw_setup 10 | **25** | yes |

**The test asserts a clean uchi-mata should be an ippon. At 19 against 22 it is
not, and it never has been.**

## THE QUESTION, AND IT IS NOT "WHAT SHOULD THE NUMBER BE"

Read that table again. **Our model makes ippon a property of WHICH THROW YOU
USE.** Seoi-nage is always an ippon; o-soto-gari never is; uchi-mata sits just
under the line. Execution quality is not in the decision at all - the test
calls `_technique_magnitude(uchimata)` with no fighter, no opponent and no
execution term, and compares it straight to the threshold.

**That is what I think is wrong, and I want your ruling on it.**

1. **UNDER IJF RULES, WHAT ACTUALLY MAKES A THROW AN IPPON?** Quote the current
   rule text. My understanding is that it is about CONTROL, LANDING LARGELY ON
   THE BACK, SPEED and FORCE - i.e. HOW the throw was executed - and that **any**
   throw can be ippon if thrown perfectly, while **any** throw can be waza-ari
   or nothing if thrown badly. **If that is right, a per-technique threshold is
   the wrong model and no value of 22 fixes it.** If I am wrong, say so.

2. **IS THERE ANY SENSE IN WHICH SOME THROWS ARE MORE LIKELY TO SCORE IPPON?**
   If the rule is about execution, is there still a real, citable difference in
   IPPON RATE between throw families at competition level? A number with a
   denominator would settle whether a per-technique term belongs in the model at
   all, even as a weighting. **NOT FOUND is a real answer** and is more useful
   than a guess.

3. **WHAT SHOULD THE MODEL BE?** Given the engine already computes, at the
   moment a technique resolves, a `mastery_norm` (how well this fighter knows
   this technique) and a `plan_alignment` (whether it fits his game plan), plus
   the defender's own state - **propose the ippon decision.** Name the inputs,
   the shape, and say which of them we already have versus which would have to
   be invented. **A model needing a quantity nobody measures is not a model.**

4. **AND WAZA-ARI.** The same rule text distinguishes ippon from waza-ari by
   degree, and our engine already awards waza-ari and counts two as an ippon.
   **If the ippon decision changes, waza-ari must change with it or the gap
   between them becomes arbitrary.** Give both or say why one suffices.

## Two constraints

- **This is a management sim.** The player never throws anything; he picks
  fighters, trains them and sets a plan. Whatever you propose has to be
  decidable from the engine's own state at the moment a throw lands.
- **Do NOT propose retuning 22 as the answer**, unless your reading of the rules
  genuinely says a per-technique magnitude threshold is correct - in which case
  say so plainly and give the value with your reasoning. **We have a standing
  rule against tuning a number nobody measured toward a number nobody
  published, and it has cost us four times.**

## THE TRAP

**Answering the test instead of the question.** The easy move is "raise
uchi-mata's authored effects to 22" or "lower the threshold to 19". Either
makes the test green and leaves the model saying that o-soto-gari can never be
an ippon, which - if my reading of the rules is right - is false about judo.
**Tell me what is true about judo first, and what that implies for the model
second.**

## What to lead with

One line: **is a per-technique magnitude threshold the right model for ippon,
yes or no.** Then the rule text, then the proposal, then the one thing you are
least sure about.
