# TASK_G75 — GROK — THE MAN UNDERNEATH: HOW OFTEN DOES HE GET OUT, AND TO WHERE?

**Research. No code, no repo, no test command.** Deliverable: one document.
**Research mode / Expert. NEVER Build mode.** Owner: grok. Assigned S59, 2026-09-23.

## Owned files

- `research/G75_THE_MAN_UNDERNEATH.md` — Claude saves your answer here.

## WHY

Our fight engine now has a ground graph: from each ground position (guard,
half guard, side control, mount, back, turtle) the man ON TOP picks an edge -
advance, submit, hold. The man UNDERNEATH is being wired this week, and his
edges (escape to guard, sweep, stand up, give the back) carry probabilities
nobody has sourced. We want real numbers from real grappling, before we tune.

## WHAT I WANT

1. **Per bottom position** (half guard, side control, mount, back, turtle,
   and closed guard as the bottom man's attacking seat): of the times the
   bottom man changes the position, what share goes WHERE - recover guard,
   sweep to top, stand up, concede something worse, get submitted. Published
   match-analysis studies (BJJ, submission grappling, MMA ground phases) are
   the target: e.g. positional-transition studies of IBJJF / ADCC footage,
   FightMetric/UFC Stats ground data, sports-science papers on time-motion
   and positional sequences in BJJ.
2. **How long a position lasts** before either man changes it, per position,
   in seconds - median and spread if published.
3. **MMA vs gi vs no-gi** - does the bottom man escape more or less under each?
   Say which the numbers come from; an MMA ground phase has strikes and a
   gi match has grips, and they are not interchangeable.
4. **Stand-up from the bottom in MMA** specifically: how often does a
   downed fighter get back to his feet, and how quickly.

## RULES

- **MARK EVERY NUMBER measured (with source, N, and population) or your
  judgement.** A design call wearing a measurement's clothes is what has
  burned this project repeatedly.
- **WHAT YOU COULD NOT FIND** is its own section. A negative result is a result.
- **ARGUE AGAINST YOURSELF**: what is the strongest case that transition
  shares from elite footage are the wrong anchor for a career sim where most
  fighters are not elite?
- Female fighters never fight males; if a study pools sexes, say so.
