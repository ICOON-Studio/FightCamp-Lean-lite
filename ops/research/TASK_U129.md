# TASK_U129 - CURSOR - THE ROUND-JUST-SCORED CARD

**Owner:** cursor
**Model:** `composer-2.5`, MEDIUM. `-p --force --trust --workspace <worktree>`
**Test tier:** parse gate on every touched `.gd`, then
`python Godot/tools/run_tests.py --only ui`. `--only` DOES NOT STACK - one
substring per invocation, read `total=` to confirm how many ran. Do NOT run the
full suite.

## Why this, and it is fully specified already

G65 landed at `research/G65_BETWEEN_ROUND.md` and section 2 gives the
between-round scored card to the pixel. You built `UIKit.region_panel` under
U128 and it merged clean; this is the same shape of job on a spec that is
already costed, and it reuses the `stat_row` pitch option you added.

**Read `G65_BETWEEN_ROUND.md` section 2 and section 3 only.** You do not need the
rest of the document and you must not re-derive G64.

## What to build - `UIKit.scored_card(...)`

Per G65 section 2, exactly:

- Frame **560 x 236**. Four columns: **STAT 200 / A 120 / B 120 / delta 120**.
- Header **28 px**, title text `R n` where `n` is the round that just ended.
- **6 data rows at 30 px pitch** (not the HUD's 24 - this table is read, not
  glanced). Label 12 px, numbers 14 px tabular, numbers right-aligned.
- Arithmetic that must hold: `6*30 + 28 header + 16 pad + 12 title rule = 236`.
- **Delta is signed and tabular, and ZERO IS WRITTEN `0`, NEVER BLANK** (G63 G,
  restated in G65 section 2). This is the one rule most likely to be missed.
- Rows, in order: Thrown, Landed, Accuracy %, Head landed, KD, Score this round.
- Reject anything that is not exactly 6 rows by returning `null`, the way
  `region_panel` rejects a five-region input - and do it WITHOUT `push_error`,
  so the suite does not read the intentional negative case as an engine error.

Also add `UIKit.corner_tray(...)` per G65 section 3 **if and only if** the card
lands inside your budget: recommended **560 x 44** at y=356, four alternates
**128 x 36** at y=408 with gutter 8 (`128*4 + 8*3 = 536`, inset 12), confirm line
**560 x 20** at y=452. Tray height 116. If you cannot finish both, ship the card
alone and say so - a half-built tray is worse than none.

**Character budgets are a CONTRACT, not decoration:** the recommended line holds
**60 characters hard** at 14 px and an alternate chip holds **14**. Over-length
text ellipsises; the box does not grow. K72 writes the words and must not have
to guess the width.

## Owned files, with real sizes

- `Godot/scripts/UIKit.gd` - LARGE, never open it whole. Read `sed -n 'A,Bp'`
  windows around `static func region_panel` and `static func stat_row`.
- `Godot/scripts/UITokens.gd` - small, read it whole. New tokens go here, never
  as bare literals in UIKit.
- `Godot/tests/ui_scored_card_test.gd` - NEW, yours.
- `research/U129_DIGEST.md` - NEW, yours.

## Gate

Parse gate first. Then `--only ui`. **`tests/ui_stat_row_contract_test.gd` must
stay at checks=18 failures=0 and `tests/ui_region_panel_contract_test.gd` at
checks=86 failures=0** - if either moves you have changed something you do not
own. `ui_kit_book_test.gd` is a PRE-EXISTING failure; it is not yours and you do
not need to fix it.

## THE TRAP

A Control with full-rect anchors must NEVER have `size` assigned when it is
mounted - with anchors at 0..1 that writes the OFFSETS and the node ends up twice
the parent. Let the anchors fill it and pass the size down. Same family: set
`expand_mode` and `stretch_mode` on a TextureRect BEFORE `texture`/`size`, or the
size you assign is clamped straight back up.

**Second trap, and it bit U128:** the spec says "tabular integer" in several
places and the project has already ruled on what that means -
`UIKit.region_number` rounds but never ONTO the sentinels 0 and 100. Use that
helper for any 0-100 quantity rather than writing a new rounding rule.

## Deliver

Fresh branch off `origin/master`. Commit with explicit paths, message ending
`Co-Authored-By: Claude Opus 5 <noreply@anthropic.com>`, push the branch, write
the digest, then
`python Tools/agent_comms.py send --from cursor --to claude --subject u129-ready --body "<one line>"`.
Do NOT edit `HANDOFF.md`.
