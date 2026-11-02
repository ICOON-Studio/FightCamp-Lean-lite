# TASK_D8 - DOLA - THE ENDPOINT STACKING YOU OFFERED TO DERIVE

**Owner:** dola. **Reply in chat with the full text and the runnable HTML.**

## You already found this, and you offered to finish it

Your D7 answer ended: *"Fix direction: Shorten your thorax segment so its upper
endpoint sits at the base of the head/neck - or shift the thorax capsule
downward so it no longer covers the neck region. Radius reduction alone will not
fix this - the centreline position is the blocker. Would you like me to derive
the exact endpoint coordinates that would align your thorax to the same stacking
as mine at your stature scale?"*

**Yes. That is this task.** And your finding has since been confirmed
independently twice, which is why it is now the lead:

- We narrowed the thorax from 0.1909 m to a chest-DEPTH-derived 0.1418 m. The
  neck is still 0/128 reachable. **You said radius alone would not fix it and
  you were right.**
- A blind contract test written by a different agent, which had not seen your
  answer or ours, found the same thing and named the HEAD as the blocker. A
  corrected measurement says it is **both**: head 39 of 128 directions at
  0.169 m deep, thorax 89 of 128 at 0.181 m deep.

## Our numbers, so you can derive against them rather than guess

Capsules are `{p0, p1, r}` in metres, rest pose. Each runs between two BONE
rest origins; `extent` includes the hemispherical end caps.

**f01, 1.78 m stature:**

| capsule | bones | p0.y -> p1.y | r | seg len | extent y (with caps) |
|---|---|---|---|---|---|
| thorax | Chest -> Neck | 0.3164 -> 0.5945 | 0.1231 | 0.2824 | 0.1933 .. **0.7176** |
| neck | Neck -> Head | 0.5945 -> 0.6501 | 0.0550 | 0.0594 | 0.5395 .. 0.7051 |
| head | Head -> skull centroid | 0.6501 -> 0.7658 | 0.1280 | 0.1301 | **0.5221** .. 0.8938 |

**f02, 1.88 m stature:**

| capsule | bones | p0.y -> p1.y | r | seg len | extent y (with caps) |
|---|---|---|---|---|---|
| thorax | Chest -> Neck | 0.3421 -> 0.6429 | 0.1418 | 0.3054 | 0.2004 .. **0.7847** |
| neck | Neck -> Head | 0.6429 -> 0.7106 | 0.0550 | 0.0774 | 0.5879 .. 0.7656 |
| head | Head -> skull centroid | 0.7106 -> 0.7989 | 0.1299 | 0.1095 | **0.5807** .. 0.9288 |

Read the bold numbers together and the problem is plain: on f01 the neck
occupies y 0.5945..0.6501, the thorax's top cap reaches **0.7176** and the
head's bottom cap reaches down to **0.5221**. The neck is inside both.

The two facts that matter:
- **`neck`/`head` surface gap is -0.1830 m on f01 and -0.1849 m on f02.** The
  head contains the neck entirely on both rigs.
- **The head capsule's lower cap reaches 0.0724 m BELOW the Neck bone on f01**,
  0.0622 m on f02.

## The question

**Give the endpoint coordinates - p0 and p1 for `thorax`, `neck` and `head` - at
1.78 m and at 1.85 m stature, that reproduce YOUR stacking**, where the neck
reads 92.7% exposed.

For each capsule say whether you moved the endpoint, the radius, or both, and by
how much. **We expect endpoints, because that is your own diagnosis** - if your
derivation turns out to need a radius change too, say so; a result that
contradicts your D7 conclusion is more useful than one that agrees with it.

## Two constraints that are not negotiable

1. **A capsule's endpoints are BONE POSITIONS.** Ours are the rest origins of
   `Chest`, `Neck` and `Head` on a real skeleton - we cannot move a bone without
   moving the mesh that is skinned to it. So say explicitly, for each endpoint
   you move: is this a bone position, or an OFFSET from the bone that the capsule
   builder would apply? An offset we can do. Moving the skeleton we cannot.
2. **Scale with stature.** Give the rule, not only the two numbers, so a 1.65 m
   flyweight and a 1.95 m heavyweight both work.

## Deliver

Runnable HTML that PRINTS the derived endpoints and then re-measures neck
exposure with them, on both statures. We run it before believing any number -
your v4 passed every threshold with bodies that could not bend, which is why
this is the standing rule and not a comment on this task.

**State your rig's own numbers beside ours in the same table.** A derivation
that does not say what it was derived FROM cannot be told from a fixture later.

## WHAT ALREADY EXISTS - READ BEFORE YOU START (operator rule 2026-09-22)

**"The agents should have all available information on existing researches and
tools."** This checkout holds **789 research documents, 220 Godot tools and 116
drivers**, and until today no task file told you they were there.

`RESEARCH_INDEX.md` at the repo root is the generated list - one line per
artefact, with what it is. **GREP IT, DO NOT READ IT WHOLE** (it is 213 KB;
reading it costs more than the exploration it replaces):

```
grep -in '<your topic>' RESEARCH_INDEX.md
```

Ask Claude to paste any document you need - you have no checkout.

Then read the two or three that match, and nothing else. **A research document
is a FINDING, not an instruction** - it reports what was true when it was
written. If it names a file, a function or a flag, check that still exists
before building on it.

**AND A NEGATIVE RESULT IS A RESULT.** Several documents record that something
does NOT work - paired clip generation, a purchasable grappling pack, a numbered
referee break clock. Those are the most expensive findings in the set, and
re-running one wastes your whole pass.

**If the index shows something already answers part of your task, SAY SO in
your digest and build on it** rather than deriving it again. If it shows
something that CONTRADICTS your result, say that too - a contradiction found
early is worth more than a clean number found late.
