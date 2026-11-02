# TASK K63 — KALLI — RING AND CAGE POSITION, STANCE AND DEFENCE: THE STATISTICS THAT ACTUALLY EXIST

Research only. No code, no files from the repository, no test to run. Everything you need is in this file.

## What I am building and why I need these numbers

I am teaching the fight engine to simulate **where the two men are standing** — centre of the ring, backed to the ropes,
pinned on the cage — and **which stance they are in**, and **how often a man defends by moving rather than by being hit
less hard**. Every rule I add has to print a real number, its bound and its source, or it is an invented bound and gets
removed. I have exactly one published position number today: cage/fence engagement is **20.91%** of match time across 91
UFC fly-to-featherweight bouts 2014-15 (Anne & Antoine 2026, DOI 10.62852/css/2026/243, video-notational). That is thin,
and it is the only one.

**This is a statistics task.** Rates, shares, counts, times — the kind of thing a governing body, a notational-analysis
paper or a fight-statistics database publishes. **Do not look for per-technique centimetres or milliseconds**: how far a
jab travels or how long a slip takes is not published anywhere and is not what I am asking for.

## What I need, in five questions

For each, give me: the **quantity**, the **sport and sample** (how many bouts, which promotion, which years, men or
women), the **number with its spread**, a **LABEL**, and the **source** with a DOI or a URL.

**Q1 — Position.** What share of a bout is spent at the cage / fence / ropes versus in open space? Anything that
splits a round by zone — centre, perimeter, corner — for MMA, boxing, kickboxing or muay thai. Also: how long a single
spell against the cage lasts, and how often per round a fighter is put there.

**Q2 — Control and pressure.** Cage control time, octagon control, "control time" as UFC scoring uses it, and any
published figure for who advances and who retreats — forward pressure share, ring generalship as judges score it.

**Q3 — Striking by position.** Significant strikes at distance versus in the clinch versus on the ground: the split, and
the accuracy in each. UFCStats publishes distance/clinch/ground totals per fight; a study that has aggregated them
across many bouts is what I want, with the sample named.

**Q4 — Stance.** How many fighters are southpaw, at elite level? How often does a fighter switch stance inside a bout
(switches per round, or share of fighters who switch at all)? Any published win-rate or striking difference for
orthodox-versus-southpaw matchups.

**Q5 — Defence.** Striking defence as a rate — the share of strikes thrown at a man that do not land — and, if anyone
has published it, the split between defending by MOVING (slip, roll, step out, head movement) and defending by
BLOCKING or covering up. Also: how often a fighter is credited with a defensive action per minute.

## The labels — put one on every row

| LABEL | means |
|---|---|
| `DOCUMENTED` | a peer-reviewed paper, a governing body's own published statistics, or a fight database's published aggregate. Give the DOI or URL. |
| `SECONDARY` | you derived it (e.g. divided a distance by a time). Say what you divided by what. |
| `LAB` | measured in a drill or a laboratory, not in a real bout. |
| `NOT FOUND` | you looked and there is no published figure. **This is a valid and useful answer — say where you looked.** |

**`NOT FOUND` is worth as much to me as a number.** The last position study I asked for came back with four NOT FOUNDs
in one section and that is why I know the boxing ring-zone share does not exist — I stopped looking for it and stopped
inventing it. Do not fill a gap with a coaching website, a YouTube channel or a blog: those are excluded.

## Format

A markdown file called `K63_RING_POSITION_AND_STANCE_STATS.md`, one table per question (Q1..Q5), the columns above, and
a short `## What I could not find` at the end naming the searches that came back empty. No preamble, no advice on what
I should build — the numbers and their sources are the whole deliverable.

## Two notes

- The facility in this game is a **gym**, never a "camp"; a fight camp is only the pre-bout preparation. If a source
  uses the other word that is fine, but write it as gym.
- Where a figure exists for women and for men separately, give both rows. Females never fight males in this game, so a
  pooled number hides the one I will actually use.
