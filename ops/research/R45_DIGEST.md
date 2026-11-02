# R45 — THE POST-FIGHT SCREEN (digest)

Claude · 2026-09-07 · task file `research/TASK_R45.md`

The eleventh legacy-replacement-era stage and the first that **spends** the
read backlog instead of adding to it. `FightResultPanel.gd` keeps its frame,
its ONE GREEN, its route contract and its four statics; what changed is that
it now reads what the engine and the art had already finished.

## What shipped

1. **The reads ride on the payload.** `FightNightScreen._present_player_result()`
   puts `get_post_fight_read(_fight_state)` (C23) and
   `get_scorecard_read(_result)` (C25) on the payload one line above the
   route, while the ring still holds the live state — C23's range block is
   aggregated from `_fight_state["log"]`, and the log dies with that body.
   Both are pure reads; nothing is settled or advanced there.
2. **The judges' grid replaced the card column.** `_build_scorecards()` walked
   `merged["scorecards"]` into `UIKit.scorecard_row()`, which reads
   `left`/`right`/`judge` — keys the sim has never written. **The old panel
   was printing three "JUDGE 0 0" rows.** It is now M5's extended grid: RND,
   the CONSENSUS pair at full weight, the KD marks, `JUDGE 1..3` as quiet
   ordinal columns (AMBER when a judge parts from the consensus, DIM when it
   agrees), a READ column, and a totals strip carrying the panel's own
   totals and the spread.
3. **The stamp says which decision it was.** C25's `decision_label` prints as
   a stamp under the description — UD / SD / MD and the three draws — with
   M5's card subcopy beside it (`2-1 CARDS`, `2-0-1 CARDS`, `1-1-1 CARDS`,
   `1 WIN · 2 EVEN`). `describe()` was taught the same seven types, so a split
   decision no longer reads "the judges cannot separate them".
4. **The range card, in M4's slot.** Whole-bout band, the owner by surname
   with their share of the standing exchanges, and the per-round dominant
   band. This is the only place R35–R37's work is read back after the bout.
5. **M9's mark.** `title_blocked_by_weight` draws BELT NOT ON THE LINE in
   **LINK on a dashed hairline** — a rule holding, not BAD, not AMBER, no
   STRIPPED banner and no tribunal.
6. **Honest empties.** A KO draws no grid and says why; a one-judge card is a
   first-class layout and is never retitled UNANIMOUS (M5 T7); an absent
   post-fight read draws no range card at all rather than a guessed band; a
   read that arrives with no banded standing exchange says NO DOMINANT BAND.

Layout: the left column is the cards now (verdict → description → stamp →
grid), the right column flows settlement → belt mark → range → aftermath.
`_build_aftermath` and `_build_scorecards` had been drawing **on top of each
other** at y=406/430 since R27; moving the aftermath under the ledger fixes
that as a side effect.

## Gold discipline

M4/M5 spend gold once, on the verdict word. R27 already spends this surface's
single gold on the **winner's name** inside `UIKit.verdict_block`, and five
tests read that contract. So the stamp takes TEXT and its card cue takes LINK:
gold ×1 is kept by not adding a second gold, not by moving the first one.

## Engine gaps named, not filled

1. **`pending_fight_result` carries no `decision_type` and no `scoring_style`.**
   `GameState.gd:10216` freezes `result`, `method`, `scorecards`,
   `final_health` and the rest — but not the two fields R38 and C25 stamped on
   the sim result. A result screen reached **without** the ring (off the
   roster, after a reload) therefore rebuilds the grid correctly from the
   cards and can only type it as plain `DECISION`, even for a three-judge
   panel. Two additive keys on that write fix it. The region belongs to Codex
   this cycle (C30); it is not touched here.
2. **`ScorecardRead.build` ignores its own panel's `decision_type`.** It
   computes `JudgePanel.decision(normalized)` for the totals and then takes
   the type from `result["decision_type"]` only. It could fall back to the
   panel's own answer when the caller has none — which would also close gap 1
   for every caller. C25's file, not this stage's.
3. `title_blocked_by_weight` is decided at **settlement**, after the result
   screen, for the player's own bout; only the world path stamps it on the
   bout row in time. The mark is therefore correct and rarely reached today.

## Files

- `Godot/scripts/FightResultPanel.gd` (415 → 720)
- `Godot/scripts/FightNightScreen.gd` — the payload lines only.
- `Godot/tests/setpiece_panels_test.gd` — 15 new claims, payload-only and
  career-free, so the lab, the ring and a career result share one board.
- No `GameState.gd` edit, no engine edit, no new UIKit variant.

## Test

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/setpiece_panels_test.gd
```
