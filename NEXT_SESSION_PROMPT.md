# Next session: S305 (written S304, 2026-10-29, after cloud seats + balance + block fix)

## Start
1. `cd /e/FightCamp/Game && git pull && python Tools/agent_comms.py start`, then work in `E:\FightCamp\Lean` (`git pull`).
2. Board Q-S294-8 (balance, page Godot/research/BALANCE_S304.md in the Game repo): his answer decides the first job.
3. John SQ18 J-UPSETS1 (favourite win rates) - `start` prints SEAT ANSWERS; open the sources before using a number.
4. Did he run `python Tools/lite_mirror.py --lean push` (in E:\FightCamp\Game)? `gh api repos/ICOON-Studio/FightCamp-Lean-lite/commits`
   not empty = yes -> add `lite_mirror.py --lean sync` to Tools/board_reconcile.py (own process, CREATE_NO_WINDOW) and launch
   the first Arena task on Lean (lite mirror, its PRs relay to FightCamp-Lean).

## The job, in order
1. If Q-S294-8 approved: a Goose issue on Lean - BoutRules.ROUND_SPREAD from John's numbers (14 if they agree) and
   Combos.tired_penalty -> the ramp (FRESH_AT 70 -> RAMP 6 at 0), gated by BalanceHarness tests (5-pt underdog 0.10-0.25,
   unfit r1 - r3 >= 0.08 vs a steady opponent); then re-film round 3 (tools/fight3d_film.gd) and check the words still match.
2. His verdict on the S304 film (block cover-up) and update 6.
3. Keep Goose busy: one Lean issue labelled `goose` at all times (Claude opens its PR: Actions may not).

## Where it stands (Lean 9a6119e)
- CI: .github/workflows/ci.yml (21 tests, every PR). Goose: .github/workflows/goose.yml + .github/CLOUD_AGENT.md.
- scripts/rules/BalanceHarness.gd: bout/win_share/grid (BALANCE1), live_bout/round_shares through Bouts._energy
  (BALANCE2), spread/tired/ramp_max what-ifs + sweep (BALANCE3). tools/balance_report.gd, tools/balance_options.gd.
- Block = mc_to_block (BeatClips.DEFENCE); tools/glove_height_check.gd [-- over=0.03 clips=a,b] measures clips.
- tools/fight3d_film.gd films rounds 1-3, `joins=<csv>` logs the clip + bones per frame (find a clip by its moment).
- Traps: the permission guard blocks pushes to the public mirror (operator runs it); his FightCamp.exe is usually open
  (the .exe copy fails, the .pck is in place); hidden_desktop.py needs `--log=` to keep Godot's output.

## Wrap-up duties
CLAUDE.md "Wrap-up": tests + export, ops board roadmap, rewrite this file, memorize the session, ask before handing over.
