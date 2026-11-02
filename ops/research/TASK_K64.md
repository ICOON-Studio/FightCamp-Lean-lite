# TASK K64 - KALLI - HOW OFTEN DOES A FIGHT END WITHOUT ANYONE BEING KNOCKED DOWN?

**Agent:** Kalli (research) - no shell, no checkout, no repo paths needed
**Assigned:** 2026-09-20 by Claude
**Deliverable:** one research answer, labelled. Claude lands the file; you never edit HANDOFF.md.

---

## THE QUESTION

A UFC bout ends by KO or TKO about **32-34%** of the time. Of bouts in which a knockdown happens,
**63.5%** end by KO/TKO, and a knockdown happens in **35.1%** of bouts. So knockdowns account for
35.1% x 63.5% = **22.3%** of all bouts ending by stoppage.

**That leaves roughly ten percentage points of KO/TKO that arrive WITHOUT a knockdown, and I need
to know what they are and how often each occurs.**

Candidates to separate, because they are different mechanisms with different causes:

1. **Doctor stoppage** - the ringside physician halts it (a cut, an eye, a broken nose).
2. **Referee stoppage on accumulation** - a man taking sustained punishment who never goes down;
   the classic "standing TKO".
3. **Corner retirement / corner stoppage** - the corner throws in the towel between or during
   rounds.
4. **Retirement or injury** - a man cannot continue (a broken hand, a torn knee, a rib).
5. **Verbal submission to strikes**, if the statistics separate it.

## WHAT I NEED, IN ORDER OF USEFULNESS

1. **The share of all bouts ending by each of those**, ideally UFC and ideally modern era
   (2014-2026). A single combined "TKO not from a knockdown" figure is already useful if the
   breakdown does not exist.
2. **Of the stoppages that are NOT from a knockdown, what share is each mechanism?**
3. **Whether the official statistics even distinguish them.** UFC Stats records a method string;
   if "TKO - Doctor's Stoppage" is a distinct value and the others are not, say so, because that
   determines what can ever be measured.
4. **Anything on how long accumulation takes** - rounds, or minutes of sustained punishment, before
   a standing TKO. Even a range or a single well-documented example is worth having.

## LABEL EVERYTHING, AND A LABELLED ABSENCE IS A RESULT

- **DOCUMENTED** - read off an official or primary source this session, with the URL and the date
  you opened it, and quote the definition verbatim where there is one.
- **INHERITED** - a secondary aggregate or a scrape someone else published.
- **INFERENCE** - your own arithmetic, marked as yours.
- **NOT FOUND** - searched, nothing there.

**A paraphrased definition is how a four-times-wrong knockdown rate got into our corpus and cost a
pass**, so quote rather than summarise. And **do not reconcile figures that disagree by picking the
convenient one** - if two sources disagree, the answer is that they disagree, which source is
safer, and why.

## WHY IT MATTERS, SO YOU CAN JUDGE YOUR OWN SCOPE

Our fight engine now produces knockdowns at very nearly the real rate (35.0% of bouts against
35.1%) and converts them at very nearly the real rate (65.1% against 63.5%). Both halves land. But
it produces **almost no stoppages that do not come from a knockdown**, so its overall KO/TKO share
sits around 22-23% against the sport's 32-34% - and the entire gap is the mechanism you are being
asked about. Without a real figure to aim at I would be inventing one.

**No repo paths, no git, no test commands, no code.** This is a literature question.
