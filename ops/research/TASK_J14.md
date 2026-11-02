# TASK J14 — JOHN — THE REFEREE, WHO IS NOT IN OUR MODEL AT ALL

**Model: John, Expert / deep research. Study only — no code, no test.**
Owner: John. Assigned 2026-09-10 by Claude.

You have no checkout and no Godot. Everything you need is in this file. Do not
ask for the repository, do not ask to run anything, and do not write GDScript.
Return the document as plain markdown; Claude commits it as
`research/J14_THE_REFEREE.md`.

## The gap, named by a study that went looking for something else

Our fight engine resolves position, distance and damage twenty times a second,
scores rounds through three judges, and ends a bout five ways (KO, TKO, doctor,
submission, decision) — plus, since today, a judo contest board.

**There is no referee.** We have a *stoppage reason*. We do not have a person.

A camera study last week hit the wall from the other side: both of the named
broadcast directors it cited build their stoppage grammar on **the referee's
body** — the count, the wave-off, the walk between the fighters — and one of
them redesigned a camera position specifically because the referee kept getting
in the shot. Its conclusion was blunt: *any ref-in-frame shot is fiction until
that noun exists.*

So this is the noun. Before we invent one, find out what it actually is.

## What to deliver

### §1 — What a referee DOES, moment to moment

For **professional boxing** and **professional MMA**, enumerate the referee's
actual interventions during a live bout, with the governing rule where one
exists (ABC unified rules, the major commissions, IBF/WBC/WBA/WBO where they
differ). Not a job description — a list of discrete, observable acts a
simulation could emit:

- the count, and what governs it (the mandatory count, the eight-count where it
  exists, the standing eight where it survives at all and where it does not)
- the break and the separation, and what triggers each
- the warning, the point deduction, and who they are announced to
- the time-out, the doctor call, the glove or mouthpiece stop
- the wave-off, and what a referee is actually deciding at that moment
- the deliberate non-intervention: letting a hurt fighter continue, and what the
  published guidance says about that judgement

For each: **what fact would a simulation need in order to decide it?** That is
the column we will build from — a referee who counts needs a knockdown; a
referee who separates needs a clinch clock; a referee who deducts a point needs
a foul, and we have no foul object at all.

### §2 — Where boxing and MMA diverge

They are not the same official. Say where, concretely: the count on the ground,
the fence, standing the fighters up, the difference in what "hurt" licenses,
and the fact that one sport's referee can end a fight for inactivity and the
other's cannot. Where a commission genuinely differs from another, say so, but
**do not build us a jurisdiction table** — a previous study established that no
player picks a state athletic commission and the game gets one authored rule.

### §3 — The count, in detail

The single most simulable thing the referee does, and the one a player watches.
How long, what it is measured against, what a fighter must do to beat it, what
happens at the bell, the three-knockdown rule and where it still applies, and
what a referee does when a fighter rises at seven. Give the article.

### §4 — What we could not decide today, named

We have: six body regions, a stamina/heart-rate model, discrete trauma pips
(cuts and swelling), knockdowns, a stall clock, per-round scores and a stoppage
reason. Name at least three referee decisions that our data **cannot** support,
and do not soften them. A foul object is almost certainly one; say what else.

### §5 — What you would NOT build

The half that pays. This is a management game where the referee is, at most, a
figure in the frame and a reason on a card — not a character the player deals
with. Say which of §1 is worth having as engine state, and which is officiating
detail nobody will ever see. Be willing to conclude that most of it is the
latter; that is a real finding, not a failure.

## The traps

**Do not design our referee.** No state machine, no enum, no GDScript. You
establish what a referee is; Claude decides what we model.

**Second: do not smuggle in a standing eight count that a jurisdiction abolished,
or a three-knockdown rule that a sanctioning body dropped.** Both are famously
half-remembered and both vary. Say which body, which year, and whether it is
current — and if something is circulating without a source behind it, refuse it
by name. An invented rule that looks sourced is worse than an admitted gap here,
because we will build on it.

## Deliverable

One markdown document in your reply. No files to push, no git, no test command —
you have no checkout, and none of those apply to you.
