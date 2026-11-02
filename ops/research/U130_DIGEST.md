# U130 digest — post-fight result block + causation box

**Branch:** `cursor/u130-post-fight-result` (contains `145742ab`; same factories on `origin/master`)

## Shipped

- `UIKit.result_block(winner, loser, method, round_number, time_text, opts)` — 840×64, line1 28 px / line2 18 px; `DRAW` and `NC` layouts per G66 §2; unknown methods return `null` (no `push_error`).
- `UIKit.causation_box(bullets, opts)` — 840×148, `CAUSE` header, five fixed 22 px slots, 14 px type; `_clip_measure_width` at 576 px inner measure; >5 bullets → `null`.
- Tokens in `UITokens.gd`; five kit-book variants + PNGs (`result-*`, `causation-*`).
- `Godot/tests/ui_post_fight_test.gd` — geometry, draw/NC/method reject, measure clip both ways (72 narrow caps vs wide overflow before length 72).

## Gate

- `check_scripts.py` on `UIKit.gd`, `UITokens.gd`, `ui_post_fight_test.gd` — fails=0
- `run_tests.py --only ui` — **total=17 fails=0** (kit book **325** variants/renders)

## Index

Built on G66 §2/§4 only; did not re-derive G64/G65. `RESEARCH_INDEX.md` grep confirmed G66 as the layout authority; K71 content is caller text, not this box.
