# TASK_K71 — KALLI — THE CAUSATION CARD, SPECIFIED

**Owner:** Kalli, research
**No checkout, no shell, no Godot.** Reply in chat with the full text.

## Why this, and it is your own recommendation made concrete

K70 was the most actionable thing collected this cycle. Its ranked answer put the
**post-fight Causation Card** first, and its closing line is why it is being built
before anything else in this track:

> All three are primarily surfacing and copy. They do not require retuning the
> calibrated MMA anchors. **If the engine already knows why a fight ended, honesty
> is a reporting problem.**

And the line that decided the order: *"If only one ships: #1. An unexplained
win/loss is the trust failure."*

K70 described the card in one paragraph. **This task turns it into something
buildable.**

## The question

**Exactly what goes on the card, in what order, and how is each line worded?**

## What to deliver — `K71_CAUSATION_CARD.md`

1. **THE FIXED SKELETON.** What is always present, in order, regardless of how the
   fight ended. K70 says method, time, 3–5 bullets, and a decision score line when
   it went the distance. **Lock that down**: which elements, which order, and what
   each is called.
2. **THE BULLET GRAMMAR.** This is the heart of it. A bullet must name a mechanism
   and its evidence, in one line, without jargon. Give the **template** and at
   least twelve worked examples across different endings:
   - a one-punch knockout
   - an accumulation TKO
   - a submission
   - a decision the player won narrowly
   - a decision the player lost narrowly
   - a decision that was one-sided
   - a doctor stoppage on a cut
   - a fight ended by leg damage
   - a fight where the loser was winning until a single exchange
   - a fight both men were fading in
   - a squash where the gap was simply large
   - a draw
   **A template with no worked examples is not a spec** — the examples are where
   the wording is decided.
3. **THE RANKING RULE.** Three to five bullets, but a fight generates dozens of
   facts. **What decides which make the card?** Give an explicit ordering rule.
   "The most important ones" is not a rule.
4. **WHAT IS FORBIDDEN ON THE CARD.** Specific. Candidates: raw probabilities,
   internal constant names, anything that reads as an excuse, anything implying
   the result was random, hedging. Say which and why.
5. **THE LOSING CASE IS THE ONLY ONE THAT MATTERS.** K69's retention killer is
   outcomes players cannot trust, and nobody distrusts a win. **Write the losing
   card twice** — once badly (the version that makes a player quit) and once well
   — and say what the difference is in one sentence.
6. **WHAT IT NEEDS THE ENGINE TO RETAIN.** List the quantities each bullet type
   requires. K70 already names the likely set: landed strikes by target, knockdown
   and rock flags, grappling control time, damage bins. **Be exact**, because this
   list is what a build task will implement, and anything missing from it becomes a
   bullet that cannot be written.
7. **THE DRAW AND THE FLUKE.** The two hardest cards. A draw has no story shape,
   and a flash knockout in round one has almost no evidence behind it. Write both.

## Ground it

Cite what real games do where you can — FM's match analysis, OOTP's game recap,
UFC career mode post-fight, boxing broadcast punch-stat graphics. **Where a figure
or format is not published, say NOT FOUND** rather than estimating; J34 is the
model and its five NOT FOUNDs were the answer.

## THE TRAP

**Do not design the visual.** No colours, no sizes, no layout — M22 owns the
palette and a separate task owns the geometry. **Your unit is the SENTENCE.** If
you find yourself describing a panel, write the words that go in it instead.

**Second trap, and it is the one that would undo K70's own finding:** do not
recommend any change to what the engine computes. The whole value of your last
answer was that these are surfacing and copy. **If a bullet you want cannot be
written from something the engine already knows, say so explicitly and put it in
section 6** — that is a request for retention, which is cheap, not a request for
new simulation, which is not.

## Deliver

Reply in chat with the full text of `K71_CAUSATION_CARD.md`. Claude lands it and
writes your HANDOFF block — you never edit `HANDOFF.md`.
