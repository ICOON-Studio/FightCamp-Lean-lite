# TASK_K67 — What real data exists on damage by STRIKE FAMILY and TARGET REGION?

**Owner: Kalli.  Research only — no repo, no code, no test.**

---

## THE QUESTION, AND IT IS A SOURCING QUESTION

Our fight engine resolves every strike through ONE force model. A jab, an elbow,
a head kick and a knee differ only by the thrower's `power` attribute and a
binary `setup` / `damage` role flag. Nothing in the engine says an elbow cuts,
that a liver shot folds a man, or that a head kick ends fights more often than a
hook does.

We want to change that. **Before we invent numbers, find out which numbers
actually exist.** This task produces no code and no recommendation about our
engine — it produces a sourced evidence table, and an honest statement of where
the evidence runs out.

## WHAT WE ALREADY HOLD, so you do not re-find it

From our validation corpus (J20), already sourced and in use:

- **3.9%** of landed standing **power-HEAD** strikes produce a knockdown
  (Fightnomics / FightMetric, ~2013). By round: 5.3% R1 → 2.4% R2 → 1.5% R3.
  Note the denominator: landed power head strikes **while standing**, not bouts.
- **~1 knockdown per 10 minutes** of distance standing time, both fighters.
- **63.5%** conditional finish rate once a knockdown occurs.
- Striking accuracy is significant landed ÷ significant attempted, and UFC warns
  body and ground shots **inflate** it relative to distance head shots.

**The published knockdown statistic is already head-specific.** That is the
shape of evidence we want more of.

## WHAT TO FIND

For each question, give the **number, its exact denominator, the source, the
year, and the sample size**. A number without its denominator is unusable — the
3.9% above was misread in this project once already because "knockdown rate"
sounds like "% of bouts" and is not.

1. **Finish / knockdown rate by STRIKE FAMILY.** Punch, elbow, knee, kick — and
   within kicks, head vs body vs leg. Which strikes end fights, and how often
   per landed strike of that type? UFC / FightMetric / Fightnomics breakdowns,
   published KO-cause tabulations, academic reviews of MMA or boxing stoppages.
2. **Damage by TARGET REGION.** Head vs body vs leg: relative stoppage
   contribution, relative accumulation, anything on body-shot stoppages
   specifically (they are famously under-counted).
3. **ELBOWS specifically.** Our engine has no notion of a cut. What is the real
   rate of cuts / doctor stoppages, and what share are caused by elbows? Is
   there a published figure for elbow-caused stoppages vs punch-caused?
4. **LEG KICKS.** Cumulative effect — is there anything measured on leg kicks
   causing stoppage or measurable mobility loss over a fight?
5. **WHERE THE EVIDENCE RUNS OUT.** State plainly which of the above has NO
   usable public number. That is a finding, not a gap in your work — we need to
   know what we will have to author blind.

## WHAT NOT TO DO

- **Do not tell us what our engine should do.** No recommended multipliers, no
  suggested coefficients. We will derive those ourselves from what you find,
  and a recommendation dressed as evidence is how unsourced constants get in.
- **Do not estimate, interpolate or average across sources to fill a hole.**
  An explicit "no public figure found" is worth more than a plausible guess,
  and this project has been burned by exactly that.
- Do not use per-technique centimetre or millisecond biomechanics studies — the
  operator has ruled that approach out for this project.

## SHAPE OF THE DELIVERABLE

A single markdown document, `research/K67_DAMAGE_BY_STRIKE_AND_TARGET.md`,
containing:

- one table per question above, with columns: **figure | denominator | source |
  year | sample | confidence**,
- a short paragraph per row where the denominator is subtle or easy to misread,
- a final section, **"WHAT HAS NO NUMBER"**, listing every question you could
  not answer from a real source.

Return the whole document in your reply. You have no checkout — do not attempt
to clone, and do not run any repo command.

## THE TRAP SPECIFIC TO THIS TASK

**"Knockout percentage" is almost always reported per BOUT and we need it per
LANDED STRIKE.** A source saying "43% of UFC fights end by KO/TKO" tells us
nothing about how hard an elbow is relative to a hook. When a source gives only
the per-bout form, record it as such and say so in the denominator column rather
than converting it.
