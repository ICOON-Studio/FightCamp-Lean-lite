# TASK M5 — THE SCORECARD: THREE JUDGES, ONE DECISION (Maria)

**Status: COMPLETE 2026-09-06** (landed by Claude; boards + spec on `master`). No dependency — start whenever.

Model: top tier, effort medium, Fast off.

Art direction only — a spec plus reference boards, no `.gd`, no `.tscn`. You
push only your own deliverable and never edit `HANDOFF.md`; Claude writes your
block, as with M1, M2, M3 and M4.

## What changed since M4

M4 dressed the post-fight read and asked you to design the decision stamp
family **including the ones the engine cannot yet emit**. That was the right
call and it is now cashed: **R38 landed today.** The engine seats three judges
on a ten-point-must bout, each turning in their own card, and it types the
result properly — `unanimous`, `majority`, `split`, and the three draws
(`unanimous_draw`, `majority_draw`, `split_draw`). A one-judge ruleset returns
a plain `decision` and is never printed as unanimous.

So the stamp you designed has real states behind it now, and there is a second
thing to draw that did not exist when you wrote M4: **the disagreement**.

## What you are dressing (all of it true in the engine as of today)

1. **Three cards, not one.** Every ten-point-must round now carries an array
   of `{judge, a, b}` — one per judge — alongside the consensus card the round
   summary already used. Judges are `Judge 1`, `Judge 2`, `Judge 3`. **They
   have no names and never will** (J1 §4.1: no real official's name anywhere,
   including in a mock-up). The round grid M4 designed shows one column; this
   asks how three columns read without becoming a spreadsheet.
2. **The consensus row versus the judges' rows.** The engine stores the
   MEDIAN judge's card as the round summary — deliberately not an average, so
   the card on screen is always a card a judge actually turned in. Design the
   relationship: which is the primary read, and how a viewer sees that the
   number they are looking at is the middle opinion rather than the whole
   story.
3. **The split, marked.** Some rounds all three judges card the same way; some
   they do not. A player wants to find the round the fight turned on without
   counting. Design that mark, and the read for a bout where the disagreement
   is spread across five rounds rather than sitting in one.
4. **The swing round.** The one round that, flipped, changes the decision.
   It exists as arithmetic and Codex's C25 read will surface it. It is the
   most emotionally loaded number on the screen and it deserves a treatment
   that is not just a highlight.
5. **The decision stamp, now with real states.** Six types plus the plain
   `decision`. M4's family was designed blind; this is the pass where it meets
   the states. A `majority_draw` and a `split_draw` must be distinguishable at
   a glance and must not read as the same thing as a loss.
6. **The three styles still share one family.** Unchanged from M4 and worth
   restating because it constrains everything above: a boxing card (10-9), a
   taekwondo card (raw points), and a judo card (ippon) must look like they
   came from the same game. **The federations have one judge** — the panel
   columns simply are not there. Design the one-judge layout as a first-class
   state, not as a three-column grid with two columns missing.
7. **Honest empties.** A first-round knockout has no cards at all. Every bout
   already in a player's save has one judge and no panel. Neither is an error
   state and neither should look like one.

## What NOT to do

- No `.gd`, no `.tscn`, no edits under `Godot/assets/data/`, no `HANDOFF.md`.
- Do not name a judge. Not in a board, not in a caption, not as flavour.
- Do not design a judge personality, a nationality flag, a reputation meter or
  a controversy indicator. The engine has none of that and J1 P5 parks it.
- Do not redesign the round grid M4 already specified — extend it. If you
  believe M4's grid cannot carry three judges, say so explicitly and show the
  replacement; do not quietly substitute one.
- No live-fight surface. This is the screen the bout ends on.
- Do not invent a scoring rule to make a board look better. If you need a card
  state the engine cannot produce, label it as such.

## Anchors

- `research/TASK_M4.md` and your own M4 delivery — the grid, the stamp
  family and the range card this extends.
- `Godot/scripts/JudgePanel.gd` — the six decision types and how they are
  told apart; `median_card()` for what the consensus row is.
- `research/J1_ORGANIZATION_RULES_AND_JUDGES.md` §4.1 — the naming rule.
- `Godot/tests/judge_panel_test.gd` — every state the engine can actually
  emit today, written as assertions. If a state is not in there, the engine
  cannot produce it yet; design it anyway, and label it.
- The bar: R18's profile renders, as always.

## Deliverable

Your usual: one manifest under `research/`, boards in a staging zip, and
a `CLAUDE_LAND_NOTE_M5.md`. Push only those.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
research/M5_SCORECARD_THREE_JUDGES.md
```
