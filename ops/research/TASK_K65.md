# TASK_K65 — how far apart do fighters stand, and how often does a boxer go down?

**Agent:** Kalli · **Model:** research mode · **Effort:** medium · **Fast:** off
**Deliverable:** one markdown answer, sent back in chat. No code, no repo paths, no files.

You are a sports-science researcher. Two questions, both about **published measured numbers**, both
with a strict labelling rule below. **`NOT FOUND` is a first-class, valuable answer** — eight
`NOT FOUND` rows in your last study were the most useful part of it, because they stopped us
searching. Do not pad, do not infer, do not reason from first principles.

---

## QUESTION 1 — inter-fighter distance, and the athletes it was measured on

We rely on one figure: **Schortgen et al., ECSS 2023 — elite boxers stand a mean 1.23 ± 0.16 m
apart.** We need to know **who those athletes were**, because the number is useless to us without it.

Report, for that study and for any other that measures inter-fighter distance in a combat sport:

1. **The athletes' ARM SPAN or REACH** — mean, range, or any body-size measure at all (height,
   mass, weight class). A separation of 1.23 m means one thing for a 190 cm-reach heavyweight and
   another for a 172 cm-reach flyweight, and we cannot compare our simulation to the figure without
   knowing which.
2. The **sex** and **competitive level** of the sample, and the **sample size**.
3. Whether the 1.23 m is measured **centre-to-centre, chest-to-chest, or some other landmark**, and
   whether it is a whole-bout mean or a standing-only mean.
4. **Any other published inter-fighter distance figure** in boxing, kickboxing, Muay Thai or MMA,
   with the same columns.

**If the abstract does not publish the athletes' body sizes, say `NOT FOUND` and say so plainly.**
That is the answer we expect and it is worth having: it tells us the figure can only ever be a
loose sanity check, never a target, and we will stop trying to hit it.

## QUESTION 2 — the boxing knockdown and stoppage rates

Everything we have on knockdowns comes from UFC/MMA data (Fightnomics, FightMetric). We need the
**boxing** equivalents. For professional boxing, report:

1. **Knockdowns per bout** — mean, and the share of bouts containing at least one.
2. **The outcome mix**: what share of professional bouts end by KO, by TKO/RSC (referee stops
   contest), by decision, by other.
3. Whether any source publishes **knockdowns as a share of landed power head punches** (the UFC
   figure is 3.9%, defined as distance knockdowns divided by total landed distance power head
   strikes). We expect `NOT FOUND` — CompuBox does not publish knockdowns against landed power
   punches — but ask, because if it exists it is the single most valuable number in this task.
4. Whether the outcome mix differs meaningfully **by weight class** and, if so, in which direction.

---

## THE LABELLING RULE — every row carries one of these, and rows without one are discarded

- **DOCUMENTED** — you have the study or governing-body publication, and you name it: authors, year,
  title, journal or body, and DOI or URL. Quote the sentence the number comes from, verbatim.
- **UNVERIFIED_SECONDARY** — the number appears in a search result, a blog, a wiki, a news article
  or a summary, and you could not open the primary source. Say which secondary source, and say that
  you could not open the primary.
- **NOT FOUND** — you looked and the number is not published. Say **where you looked**.

**Do not convert, average, or combine numbers across sources.** If two sources disagree, report both
rows and say they disagree. An estimate you derived yourself is not a row; it is a note at the end,
clearly marked as yours.

## WHAT NOT TO DO

- Do not answer with per-technique biomechanics (punch velocities, force in newtons, joint angles).
  That is a different literature and it is not what this asks.
- Do not give us training advice, coaching opinion or technique description.
- Do not pad a `NOT FOUND` into a paragraph of adjacent findings. One line, then where you looked.

## WHY IT MATTERS, IN ONE PARAGRAPH

Our fight simulation puts two specific men 1.06 m apart and a test was failing it against
Schortgen's 1.23 m. Our two men have 186 cm and 172 cm of reach, and their own modelled standoff is
1.087 m — the simulation is doing exactly what it is told. Whether it is doing the *right* thing
depends entirely on how big Schortgen's boxers were, and that is question 1. Question 2 is the same
shape: we calibrated knockdowns against MMA data and then measured boxing, and we have nothing
boxing-specific to check the answer against.
