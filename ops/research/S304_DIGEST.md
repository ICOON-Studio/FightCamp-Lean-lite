# S304 digest (2026-10-29) - cloud seats on the new game, balance measured, the block fixed

## What now works
- **Lean CI**: `.github/workflows/ci.yml` runs all Lean tests on Linux for every PR and push to main (21/21, ~45 s).
- **Goose on Lean**: `.github/workflows/goose.yml` (ported; label an issue `goose`). Run 1 stopped after 3 min on words
  ("Now I'll create the files", no tool call) and lost nothing only because nothing was written; fixed: a named session
  resumed with a nudge until the report holds a RESULT line, and new uncommitted files are collected. Actions may not
  open PRs in FightCamp-Lean - Claude opens them (`gh pr create --head goose/issue-<n>`).
- **Three Goose tasks merged the same session**: BALANCE1 harness (Lean #2 be1ed2b), BALANCE2 round-by-round through the
  real round (Bouts._energy parity test, #4 8566472), BALANCE3 spread/tiredness what-ifs (#6 aca8780).
- **Block**: the three-round film showed Blue holding her rear glove straight up over her head ~0.7 s on a blocked jab.
  The in-game joins log named the block clip; `tools/glove_height_check.gd` (new) measured all 10 block clips: every Pro
  block and mc_block_hit hold the hand over the temple line 1-4.6 s. Block = mc_to_block (cover-up) now; in game the
  hand median is -0.01 m vs the head bone (was +0.05), seen on the game camera (Lean 4cbb2aa).
- **JoinSmoother**: 52,184 "axis must be normalized" errors per film -> 0 (non-unit offset; it turned nothing).
- **Film**: `tools/fight3d_film.gd` films all 3 rounds and prints both fighters (Lucy: speed 63 / cond 62.5 out-boxer;
  Maria: southpaw pressure fighter, rating 61.5, fades after round 2). Sent + 8787/review.
- Update 6 .pck exported; WHAT_TO_TRY update 6 (Lean 7b5b36c).

## Evidence (measured)
- Bare round model (BALANCE1): vs rating 62, Standard camp: avg 55 -> 0%, avg 60 -> 42%, avg 70 -> 100%.
- Real round (BALANCE2): r3 >= r1 at every conditioning (cond 50 vs Maria 0.34 -> 0.53). Tired penalty bites only under
  energy 20; round 3 starts at 61-68.
- What-ifs (BALANCE3 + tools/balance_options.gd, n 400-600): spread 14 -> 5-pt underdog 14-20%, 3-pt favourite ~80%;
  ramp 6 -> unfit vs steady opponent r1 65% -> r3 52% (today 63 -> 63). Fader opponent + corner +1 from round 2 keep r3
  easy against Maria whatever the ramp.

## Decisions (developer)
- Goose is the Lean cloud seat for pure harness/rule work; PRs collected by diff + CI the same session.
- The block plays the cover-up; pro_hit_by_uppercut_v1 keeps its arms-up reaction (a reaction, not a guard).
- Balance: proposed spread 6 -> 14 (final from John J-UPSETS1) + tiredness ramp (70 -> 6 pts) - **on the board Q-S294-8,
  nothing changed in the game until he answers**.

## Not done / blocked
- `python Tools/lite_mirror.py --lean push` (public mirror, needed for Arena) - the permission guard denied it as data
  exfiltration; the operator runs it. FightCamp-Lean-lite exists but is empty. Then the board_reconcile --lean sync.
- John SQ18 J-UPSETS1 queued (favourite win rates).

## HANDOFF
Next: S305 per roadmap `now.next_action` - apply Q-S294-8 if approved (Goose task, BalanceHarness gate, re-film round 3),
mirror sync + Arena once he pushed, his verdict on the S304 film.
