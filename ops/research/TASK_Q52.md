# TASK Q52 — QWEN — THE NUMBERS BEHIND MOTION

Model: qwen, medium effort. Owner: qwen.
Test tier: **RESEARCH — no `.gd` file is touched.** NO parse gate, NO test, and
do NOT run the suite. `git status -s` before you stage is the whole check.

## Owned files

- `research/Q52_MOTION_SPEC.md` — **NEW. You create it. Yours alone.**

Nothing else. Do not edit `HANDOFF.md`, `CURRENT_STATUS.md`, any `.gd` file, or
any other research file.

## Why this exists

Q51 gave us the numbers for how a surface should LOOK. This is the other half:
how it should MOVE. Our operator's standing note is that a screenshot does not
show motion — gradients that drift, panels that settle, buttons with weight,
none of it survives a still — and our kit currently has three motion helpers
(a fade-in, a dial sweep, a pulse) whose durations and curves were picked by
eye, with no system behind them.

Same method as Q51, and the same reason it is going to you: **label every answer
`DOCUMENTED`, `INFERENCE` or `NOT FOUND`.** A DOCUMENTED figure carries its
source URL. A figure you reasoned out is INFERENCE even when you are confident.

## Q1 — The published duration scales

For **Material Design 3**, **Apple HIG** and **Microsoft Fluent 2**: the
documented duration tokens, in milliseconds, with the name each system gives
them and what each is FOR. MD3 in particular publishes a short/medium/long/
extra-long set with four steps each — transcribe the table rather than
summarising it.

Then the mapping: which duration does each system specify for a small element
changing state (a button press, a checkbox), for a panel appearing, for a
full-screen transition, and for something LEAVING versus something ARRIVING.
**Is exit consistently faster than entrance? By how much?**

## Q2 — The easing curves, as actual numbers

Not "ease-out". The **cubic-bezier control points** or the named spring
parameters each system publishes, per curve, with which curve goes with which
duration. MD3's emphasised / standard / legacy sets, Apple's, Fluent's.

Then the part we actually need: **map each published curve onto Godot's
`Tween.TransitionType` + `EaseType` pair** — `TRANS_CUBIC`, `TRANS_QUART`,
`TRANS_EXPO`, `TRANS_BACK`, `TRANS_ELASTIC`, `TRANS_SPRING` with `EASE_IN`,
`EASE_OUT`, `EASE_IN_OUT`. Godot cannot take an arbitrary bezier in a simple
Tween, so for each published curve say which Godot pair is the closest fit and
how close. This mapping is the deliverable; mark it INFERENCE unless you find it
documented.

## Q3 — Stagger, and when a list animates at all

- What interval do the published systems specify between items in a
  **staggered** list or grid entrance? In ms.
- Is there a documented CAP — a number of items past which stagger is dropped
  because the last item arrives too late to feel responsive?
- Do any of them say a list should NOT animate on every rebuild? Our screens
  rebuild wholesale on a data change, and a fade-in that replays every time the
  player clicks a tab is worse than no animation at all. Find whatever is
  documented about **repeat** and about respecting *prefers-reduced-motion*.

## Q4 — The moment: what the systems say about celebration

Our standing product rule is that **every mechanic carries at least one MOMENT
worth a screenshot** — gauges, dials, glow, medallions, celebration. Ours is a
sports-management game: a win, a title, a level-up.

- Is there documented guidance on the duration and curve of a **value counting
  up** (a number ticking from 0 to its total)? What does it say about easing —
  linear, or decelerating?
- Anything documented on **glow / bloom pulse** rates, or on how long a
  celebratory state should hold before it releases?
- If the design systems are silent, say `NOT FOUND` and then look at what GAME
  UI practice documents instead — and label that clearly as a different class of
  source.

## The shape of the deliverable

`research/Q52_MOTION_SPEC.md`. Tables, not prose. Every figure labelled and
sourced. Finish with a section headed **"THE SPEC WE SHOULD ADOPT"** giving, as
one table: our named motion roles (state change, panel enter, panel exit, tab
switch, dial sweep, count-up, celebration hold) and for each one a duration in
ms, a Godot `TRANS_*` / `EASE_*` pair, and a stagger interval where it applies.
That section is allowed to be INFERENCE; say so.

Keep it under 250 lines.

## Definition of done

- The file exists and every answer carries `DOCUMENTED` / `INFERENCE` /
  `NOT FOUND`.
- Q2's Godot mapping table is present and complete — it is the part that gets
  used.
- `git add -- research/Q52_MOTION_SPEC.md`, commit, push.
- One line back:
  `python Tools/agent_comms.py send --from qwen --to claude --subject Q52-done --body "<sha> <one-line answer to Q1 exit-vs-entrance> <the Godot pair you recommend for a panel entrance>"`

## The trap specific to Q52

**A duration without a curve is useless, and so is a curve without a duration.**
Every row in your final table needs both. And do not give us a single global
"animation duration" — the entire point of the published scales is that a 40 ms
state change and a 500 ms screen transition are different quantities, and a kit
that animates everything at one speed is exactly as flat in time as our panels
currently are in depth.
