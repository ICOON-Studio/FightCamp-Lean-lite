# TASK_K75 - KALLI - REVIEW THE PHASE-FIRST SKILL TREE AND PROPOSE IMPROVEMENTS

**Owner:** kalli. **Research only - no .gd, no .tscn, no layout geometry.**
Stage to `_kalli_delivery/` and ping Claude.

## Why this, and it is a review rather than a build

**The operator chose the PHASE-FIRST skill tree** out of three iterations and
then said two things about it: *"very simplistic you can use the space for more
descriptive, like the fighter personality can also be shown there"* and *"the
fonts i dont like them at all i do not want these fonts in any menu"*. The
fonts are changed and the header now carries the fighter. **The operator then
asked for the screen to be reviewed by agents, with proposed improvements.**

You own the WORDS. Not geometry, not colour, not type.

## The screen as it stands, described so you can review it without seeing it

**1280x720. Header band, 112 px**, five blocks left to right:

- a portrait placeholder, 88 px wide;
- **identity**: `MOSES OKONKWO` at 26 px; `14-2-0` with `9 KO - 3 SUB` beside
  it; `27 - Welterweight - Nigeria - Ironside Gym`; two chips,
  `TEMPERAMENTAL` and `SOUTHPAW`;
- **WHAT HE WANTS**: heading, then `A title shot this year`, then
  `He will take a hard fight to move up. He will not wait.`, then a machine
  line `goal rank_up - urgency HIGH`;
- **WHERE HE IS STRONG**: four labelled bars - `clinch 81 his best phase`,
  `standing 64 orthodox-heavy`, `ground top 38 holds, rarely finishes`,
  `ground bottom 19 gets held there`.

**Below it, a phase band**: STANDING 483 / CLINCH 153 / GROUND TOP 53 /
GROUND BOTTOM 52 / SCRAMBLE 15, each with `N - n known`, band width
proportional to share. Under it one line of prose: *"He is a clinch fighter who
does not know it yet - 9 of his 11 knockdowns started from a tie-up."*

**Then three columns** headed `ENTER IT` / `WORK INSIDE IT` / `LEAVE IT`, each
with a sub-line (`how he gets hold of the man`, `what he does once he has it`,
`on his terms, or the other man's`) and six technique rows.

**Right rail, 330 px**: the hover preview and the four clip states you already
specified in K74.

## What to deliver

1. **THE PERSONALITY LINE.** `TEMPERAMENTAL` is one of eight real labels in
   `career_goals.json` (Ambitious, Analytical, Charismatic, Disciplined,
   Fearless, Loyal, Reserved, Temperamental). A bare chip says almost nothing.
   **Give the 60-char line each of the eight would show beside the chip**, in
   the register of a manager reading a file on a man he employs. Mark each
   COMPUTED or NOT COMPUTED against what the engine actually holds.

2. **"WHAT HE WANTS" IS TWO SENTENCES AND ONE MACHINE LINE.** Review that
   shape. The goal ids are real: `rank_up`, `top_promotion`, `champion`,
   `top_of_the_ladder`, `mastery`, `get_paid`, `stay_loyal`. Give the headline
   (<= 34 chars) and the consequence line (<= 60 chars) for **all seven**.
   **The consequence line is the valuable half** - it says what this wanting
   makes him DO, which is what a manager acts on.

3. **THE READ LINE.** *"He is a clinch fighter who does not know it yet"* is a
   claim about the man derived from his own numbers. **Is that honest, and what
   is the template?** Give the pattern and three more instances of it, each
   with the quantity it is derived from named. **And say plainly which ones the
   engine cannot currently compute** - K72 and K74 both got this right and it
   is why you are on this.

4. **THE COLUMN HEADS.** `ENTER IT` / `WORK INSIDE IT` / `LEAVE IT` with their
   sub-lines. Do they survive being applied to STANDING and GROUND as well, or
   does each phase need its own three verbs? Give the set for all five phases
   if so.

5. **WHAT YOU WOULD CUT.** A screen with no named omissions has not been
   costed.

## THE TRAP

**Writing flavour.** Every line here is read by a manager deciding what to do
next week. A sentence that sounds good and tells him nothing is worse than a
blunt number. And **do not write a line the engine cannot back** - a
personality line implying the sim models temperament in a fight, when it does
not, is exactly the quiet lie K70 exists to refuse.

## WHAT ALREADY EXISTS - READ BEFORE YOU START

Ask Claude to paste anything you need; you have no checkout. Relevant and
already on disk: **K70** (honesty and reporting), **K71** (causation card),
**K72** (corner card), **K73** (region crossing sentences), **K74** (the four
technique-modal states - this screen's right rail is yours already), and
**G64/G65/G66** for the type scale and the labels convention. **A negative
result is a result** and NOT COMPUTED is a real answer.
