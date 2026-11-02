# TASK G36 — GROK — THE FIVE LADDERS WE NEVER LOOKED FOR

Model: **Grok, Expert (deep research).** Owner: Grok. Research only — **no
code, no repo, no test command.** Deliverable is one markdown file, delivered
in the chat; Claude commits it.

---

## Why this exists

R89 wired `GradeLadder.gd` into the game, so a practitioner grade now runs on
a clock, costs the gym money and appears on the player's read. It carries
ladders for **seven** of the game's **fifteen** disciplines: brazilian jiu
jitsu, judo, karate, taekwondo, muay thai, kickboxing and mma.

The other eight are not one group, and that is the whole point of this task.

**Three are correctly empty and are NOT yours.** C52 reviewed World Boxing,
UWW and IWUF material and found no practitioner grade in **boxing**,
**wrestling** or **sanda**. Those sports have records and titles, not grades.
Do not research them, do not propose a ladder for them, and if you find one,
say so in a separate clearly-marked section rather than adding it — a grade
belt is *awarded* and a championship belt is *won from an opponent*, and
confusing the two is the exact thing C52's separation rule exists to prevent.

**Five were never surveyed at all, and that is a research gap wearing an
absence's clothes.** C52's grade pass covered the disciplines the game fights
under most; these five fell off it. At least two almost certainly DO have a
real, documented ladder, which means the game is currently telling the player
a false "no such thing" for them.

## What to answer, per discipline

**savate, sambo, pencak silat, arnis, capoeira.** For each:

1. **Is there a practitioner grade ladder at all?** Answer with a source or
   answer UNKNOWN. "Probably" is not an answer; an honest UNKNOWN is.
2. **The exact level names, lowest rung first**, as a list of lowercase
   snake_case tokens suitable for a const array. Real names, in the
   federation's own vocabulary — not translations of convenience.
3. **Who issues it**, and whether it is one universal system or issuer-scoped.
   This is the decisive test and it has a precedent both ways: karate KEPT its
   ladder despite C52 finding no universal WKF grade division, because kyu/dan
   is a shared *shape* even where the issuer varies. A discipline whose rungs
   differ in **sequence** between bodies, not merely in who signs the
   certificate, fails that test and should be reported as having no universal
   ladder.
4. **Any published MINIMUM TIME at a rung** (in weeks or months) and **any
   published MINIMUM AGE**, with the source. If none is published, say so
   explicitly — see the next section, this matters more than it looks.
5. **Anything the grade GATES**: competition entry, teaching, coaching,
   officiating. C52 found grade benefits are discipline-specific and
   portability is never assumed.

## What is already known and must not be re-derived

* **Sambo:** C52 recorded that FIAS launched a ten-level practitioner
  qualification system in 2026 but **did not source the level names**. That is
  the specific hole. Start there.
* **Savate:** the FFSbf&DA progression is by coloured *glove* rather than
  belt. Get the exact sequence and the official French names.
* **Capoeira:** *cordas* exist, but Regional, Angola and contemporary groups
  differ. This is the one most likely to fail question 3 honestly. If it does,
  say so plainly — a refusal is a finding.
* **Pencak silat** (Persilat *sabuk*) and **arnis** (WEKAF) are open.

## The thing that will be wrong if you get it wrong

**A missing time minimum is not zero.** `GradeLadder` treats an unsourced
interval as `-1` = "no sourced rule", never `0`, because zero is a different
and much stronger claim. R89 then fills the gap with the game's own authored
52-week interval, clearly labelled as the game's. So:

* If you find a real published minimum, it **replaces** the authored one and
  the game will say `sourced`.
* If you find none, say **none published** and the game keeps saying
  `authored`.
* **Never** report a minimum you inferred from a typical practitioner's
  timeline, a school's website, or "most people take about two years."
  A population claim is not a rule. C55 refused exactly this class of number
  and R89 depends on that refusal holding.

## What good looks like

G34 and G35 are the bar and both are yours. Sourced, specific, willing to
state an inference AS an inference, and ending in something a build task can
be typed from. Close with:

* **A ready-to-paste const block per discipline that HAS a ladder**, in the
  shape `GradeLadder.gd` already uses:

  ```
  const LADDER_SAVATE: Array = ["...", "...", ...]   # lowest rung first
  ```

* **A ready-to-paste `MINIMUM_WEEKS` block** keyed `"<discipline>|<from>|<to>"`
  and a `MINIMUM_AGE` block keyed `"<discipline>|<grade>"`, carrying ONLY
  sourced numbers.
* **An explicit REFUSE list**: every discipline of the five you could not
  source a universal ladder for, and why.
* **At most two open questions for the operator, each with a default
  recommendation.** If you can decide it, decide it.

## Deliverable

**ONE file: `research/G36_THE_FIVE_LADDERS.md`.** Nothing else.

**You have no checkout and no Godot** — write no GDScript beyond the const
blocks above, propose no preload, and expect to run nothing. Deliver the
finished markdown in the chat and Claude will commit it.

## The trap specific to this task

**Do not touch the seven ladders that already exist.** They are wired into a
shipped weekly pass with a passing 79-check test, and a const array that moves
under it changes what every existing fighter's grade means. If you believe a
rung in an existing ladder is wrong, say so in a clearly-marked section at the
end rather than re-specifying it.
