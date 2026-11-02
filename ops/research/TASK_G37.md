# TASK G37 — GROK — THE ADAPTER FOLD: HOW EACH RULESET SCORES A GRAPPLE

Model: **Grok, Expert (deep research).** Owner: Grok. Research only — **no
code, no repo, no test command.** Deliverable is one markdown file, delivered
inline in the chat as raw markdown; Claude commits it.

---

## Why this exists, and why it is being asked BEFORE it is needed

The grappling arc has four halves on master and they are all **inert** —
nothing calls them. The next stage (R91) wires them into the live fight:
seats advance per tick, control accrues, and the five counters have to reach
the judges who already exist.

**The engine emits one vocabulary. Each ruleset scores it differently.** That
conversion is the adapter fold, and `G34` §6 sketched it for judo, freestyle
wrestling, BJJ and MMA but left real holes — C67 flagged **BJJ advantages** and
**1-D UWW step-out semantics** as unresolved when it wrote the blind test, and
they are still unresolved. R91 will hit those holes on the day it starts.

This task exists so it doesn't. **A question put to the operator is a research
task that was not assigned in time.**

## What you already own, and must not re-derive

* **`G34_GRAPPLING_CONTRACT.md`** — yours. §1 the event vocabulary, §2 seats
  and the control-unit table, §6 the ruleset map, §8 the five counters. **Its
  numbers are settled.** Do not re-open the position point table.
* **`G35_REFEREE_AND_METHODS.md`** — yours. The fifth method and the stall
  clock.
* **One thing G34 got structurally wrong, already ruled** (R90, from G34's own
  numbers): there is **no `is_dominant` predicate in the contract**, and there
  should not be. Dominance is a **graded quantity** — 0, 1 or 2 control units
  per scoring tick — not a boolean. `clinch`-with-a-top and `half` both score
  **1**; `side`, `mount` and `back` score **2**; `guard` and `standing` score
  **0**. Treat control as that integral throughout, and never as a flag.

## What to answer

For each of **judo (IJF), freestyle wrestling (UWW), BJJ (IBJJF) and MMA
(Unified/ABC)** — the four rulesets whose `scoring_profile` weights grappling:

1. **The conversion table.** For every event in G34 §1 and every seat in §2,
   what does this ruleset award, and when? Sourced to the current rulebook,
   with the year. Where the engine emits something the ruleset does not score,
   say "not scored" rather than inventing a mapping.
2. **The hold gates.** G34 put ONE stability gate in the engine (60 ticks /
   3.0s, the IBJJF number) and pushed ruleset-specific holds into the adapter.
   Judo osaekomi is the obvious case (10s / 20s). Give **each** ruleset's own
   hold requirements in seconds, sourced. If a ruleset has none, say so.
3. **BJJ advantages — the hole C67 named.** IBJJF awards advantages for
   *near* actions: a sweep that did not finish, a submission that threatened.
   **Is an advantage derivable from what the engine emits**, or does it need an
   event we do not have? Answer concretely, and if it needs a new event, name
   it, define it, and say what triggers it. **"Add an advantage counter" is not
   an answer** unless you say what sets it.
4. **UWW step-out — the other hole.** Our ring is effectively 1-D
   (`RingSpace`/`separation`). A wrestling step-out is a 2-D boundary fact.
   **Can a 1-D model produce an honest step-out at all?** If it can, define the
   test precisely. **If it cannot, say so and say what the honest fallback is**
   — including "wrestling should not use the real-time engine yet", which is a
   legitimate answer and would match what R85 already found for taekwondo.
5. **The stall clock, per ruleset.** G35 defined one. Who actually penalises
   stalling, after how long, and with what — a warning, a point to the
   opponent, a position reset? Sourced.
6. **What a submission finish means to each.** MMA and BJJ end the bout. Judo
   has shime-waza / kansetsu-waza with its own constraints. UWW freestyle has
   no submissions at all. Say what `METHOD_SUBMISSION` means where it cannot
   happen.

## The thing that will be wrong if you get it wrong

**Do not average four rulesets into one "grappling score".** The whole point of
the adapter pattern is that the engine stays neutral and each federation reads
it its own way. If two rulesets genuinely disagree about what an event is worth,
that disagreement belongs in the table as two different numbers, not smoothed
into a compromise nobody uses.

And the standing rule for every number you report: **a published rule replaces
an authored one; a population claim never does.** "Most matches see about two
takedowns" is not a rule. If a ruleset publishes no threshold, say **none
published** — never `0`, which is a much stronger claim.

## What good looks like

G34, G35 and G36 are the bar and all three are yours. G36 in particular is the
shape to copy: a verdict table up front, sourced detail per subject, an explicit
REFUSE list, and ready-to-paste blocks at the end. Close with:

* **One conversion table per ruleset**, event/seat → award, in a form a build
  task can be typed from directly.
* **A ready-to-paste hold-gate block** in seconds, per ruleset, carrying only
  sourced numbers.
* **An explicit REFUSE list**: every ruleset or mechanic you could not map
  honestly, and why. Wrestling step-out is a candidate; so is anything whose
  rulebook you could not source.
* **At most two open questions for the operator, each with a default
  recommendation.** If you can decide it, decide it.

## Deliverable

**ONE file: `G37_THE_ADAPTER_FOLD.md`.** Nothing else.

**You have no checkout and no Godot.** Write no GDScript beyond small const or
dictionary blocks, propose no preload, and expect to run nothing. **Print the
finished markdown inline in the chat** — do not attach it as a document, because
a document artifact's text cannot be read out and you will be asked to reprint
it.

## The trap specific to this task

**Judo's osaekomi gate is the one most likely to be quietly wrong**, because
G34 already made a decision about it that you must not overturn by accident:
the **engine** holds one universal 60-tick gate and only emits "held in
`side|mount` with `top=X` for N ticks"; the **adapter** applies the 10s/20s.
Your table must respect that split — give the adapter's seconds, not a new
engine threshold. If you believe the split itself is wrong, say so in a
clearly-marked section at the end rather than re-specifying §2, which is wired
into a passing test.
