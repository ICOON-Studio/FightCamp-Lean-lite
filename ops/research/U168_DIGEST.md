# U168 digest — profile and result leftovers (Cursor, 2026-09-24)

## Fixed (how)
1. **Pay vs market** — Overview STANDING keeps the real contract wage on the tug bar left (`$0` stays honest) and adds a `PayGap` caption naming market pay and the weekly gap so inherited $0 deals read as underpaid, not mysterious.
2. **Hero record splits** — KO/SUB/DEC and FINISH rate are two lines (`Splits` height 30px) so the old single row no longer clips at `- FI`.
3. **Result score cells** — Round score labels use full-rect anchors inside the cell so digits centre vertically (S66 low-digit defect).

## Tests
`tests/profile_result_leftovers_test.gd`: 19 checks on day-one Cyprus boxing career (`begin_new_career` / `generate_starter_boxing_floor` / `finalize_new_career`) — tug left/right money, `PayGap` text, splits fit, eight-round card grid anchors. Mutants: single-line splits width, score without full-rect, one-line finish clip.

Focused tier: `--only profile` **4/0**, `--only result` **4/0**, `--only career_loop` **1/0**.

## Walk shots (`tools/s64_career_walk.gd`, `research/u168_walk.plan`)
- Pay + gap: `previews/u168_walk/11_u168_profile_pay_and_record.png`
- Hero splits: same frame (top-right record block)
- Score grid: `previews/u168_walk/13_u168_result_score_cells.png`

## Decision
Left starter weekly at true `$0`; did not inflate displayed pay to market (trap). Explanation is copy beside the tug, not a fake wage.
