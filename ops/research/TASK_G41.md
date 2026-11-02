# TASK G41 — GROK — JUDO, WRESTLING AND BJJ ARE NOT ROUNDS

**Model: Grok, Expert. Research only — no code, no module, no test.**
Owner: Grok. Assigned 2026-09-10 by Claude.

You have no checkout and no Godot. Everything you need is in this file. Do not
ask for the repository, do not ask to run anything, and do not write GDScript.

## The gap, measured before you were asked

Our engine runs every contest as ROUNDS with a CORNER between them. That shape
is boxing's, and we applied it to all eleven rulesets. The three grappling
rulesets carry these numbers today, and we know at least one is wrong:

| ruleset | `rounds` | `round_seconds` | what the engine then does between them |
|---|---|---|---|
| `judo` | 1 | 240 | nothing — there is no between |
| `freestyle_wrestling` | 2 | 180 | a full corner: rest, recovery, a scorecard |
| `bjj` | 1 | 600 | nothing — there is no between |

The engine's round break is load-bearing in three places, not one:

1. **Recovery.** A corner is a flat credit against accumulated wear plus a
   minute of wind back. Eleven corners are why a 12-round fight is survivable.
2. **Scoring.** Judges score PER ROUND and the round is the unit of the card.
3. **Stoppage.** Several rules ask "at the end of the round".

So "how long is the contest" is not the question. The question is **what our
round break is standing in for in each of these three sports, and where it is
standing in for nothing at all.**

## What to deliver

One document. Return it to Claude as plain markdown text in the chat — Claude
commits it as `research/G41_NOT_ROUNDS.md`. Aim for something a build
task can be written from without re-reading your sources.

### §1 — The contest clock, per sport, with the article

For **judo (IJF)**, **freestyle wrestling (UWW)** and **BJJ (IBJJF)**, state:

- The actual contest length and how it is divided, if it is.
- Whether the clock STOPS, and on what. This is the one that matters most and
  the one our model has no concept of: we run a continuous tick.
- What happens between divisions when there are any (wrestling's break).
- Overtime / golden score / sudden death, and whether it is a NEW period or a
  continuation of the same one.
- Belt-, age- and level-dependent variation, especially IBJJF, where the adult
  black belt and the white belt are not the same contest.

Cite the governing article for each (IJF SOR, UWW International Wrestling
Rules, IBJJF Rule Book), the way G39 and G40 did. **Give the edition/year you
are quoting.** If a rule changed in the last two cycles, say which one is
current and name the superseded one — you did this correctly on G40 (Art. 16)
and it was the reason that task landed clean.

### §2 — What replaces the corner

For each of the three, answer the recovery question directly: **is there any
sanctioned interval in which a competitor recovers?** Wrestling's break, a
judo matte/sonomama, an IBJJF stoppage to reset position. For each interval,
say how long it is and whether it is REST or merely a STOP.

This is the section a build slice will actually consume, so be concrete:
a stopped clock during which a fighter is standing still is not the same thing
as a minute on a stool with a corner working on him, and our model currently
cannot express the difference.

### §3 — What the scoring unit is when it is not a round

Judo's board (ippon / waza-ari / shido) is already built. Wrestling and BJJ
score CUMULATIVELY across the whole contest. So: if there is no round, what is
the judges' unit, when is a card produced, and what does "he won round 2" even
mean in a sport with no round 2? Say plainly which of the three has judges at
all in the sense we mean, and which is scored by the referee plus a table.

### §4 — The three refusals

Name at least three things about these contests our vocabulary CANNOT express
today, and do not soften them. You have seen this project take a real finding
better than a tidy one: R92's osaekomi ladder was dead code behind a green
test, and saying so was worth more than a fold that looked complete. Candidates
you may confirm or reject: a stopped clock, a referee-ordered position reset,
per-belt contest length, passivity/shido clocks that run only while standing.

### §5 — What you would NOT change

The most useful half of this study. Our round model is wrong for these three
sports, but three grappling rulesets are a small part of the game and the
engine is shared with eight striking ones. Say which of your findings are worth
building and which are depth nobody will ever see — the same call the operator
made on corner rules, where genuine per-state differences were deliberately
collapsed into one authored rule because no player picks a state commission.

## The trap

**Do not design our fix.** You are not writing the tick loop, the data schema
or the module. Two of your last studies were most valuable where they said "the
books are silent, here is what is published and here is what is circulating but
unsourced" — G39 §6 refusing the WFMC five-second clinch clock is the model. If
a sport genuinely does not publish something, the deliverable is that it does
not, named, with the unsourced version refused BY NAME. An invented number that
looks sourced is worse than an admitted gap, because we will build on it.

Second trap: **judo already has a board.** `JudoBoard.gd` landed yesterday from
your G40 and it ends a contest on ippon, on waza-ari-awasete-ippon and on a
third shido. Do not re-derive it. §1 for judo is about the CLOCK — golden
score, matte, sonomama, osaekomi's own clock — not about what ends the fight.
