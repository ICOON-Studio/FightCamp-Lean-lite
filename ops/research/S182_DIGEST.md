# S182 digest - the club is ON, one dialog at a time, sponsors/person/moments merged, the camp disconnect found (Claude, 2026-10-09)

## What now works
- **The new club is ON in the game** (`gym3d_main` + `gym4_club` default = game mode; `--script` tests stay the OFF arm). Operator's
  verdict was already in the S181 record (21:42, after stills + video): "stills are ok not great i hope there isno issue with items
  being too close on the walls anddoors of other rooms" - clearances fixed S181. Q-S181-1 closed with his words. `club_on_in_game_test`
  passes both modes, red with the default reverted.
- **One dialog at a time in the club**: the as_game walk (docs/previews/s182_club_walk/08_home.png, opened) showed Dessa's story card
  over HIRE A COACH. The club now holds its hire/interview card while a story card is up and offers it after the choice or LATER.
  `club_one_dialog_test` PASS, red without the hold; story/club neighbours 27/27. Walk re-run: story first, hire after - fixed.
- **SPONSOR2** (Qwen, K88 Kalli): 15 fictional local-to-global businesses, never fight organisations; new conditions
  reputation_min / win_within / no_missed_weight; pitch line on the office offer. sponsorship 49/49; entity_pathways P12 rewritten to
  the K88 ruling.
- **PERSON1** (Qwen): every candidate card says "<Style>. <Strength>, but <flaw>." (design review finding 6).
- **MOMENTS1** (Arena PR #65): `FightMoments.causal_moments` (call -> effect, scout read, turning round). Pure, NOT wired yet.
- **Arena pushes to ICOON-Studio again** (operator reconnected GitHub; PRs #64, #65 prove it). ARENA-GITHUB blocker removed.
- `start` now says: QUOTE each board answer in the first message and act on it (operator S182: "check answers on opsboard , always
  check that at session start"); CLAUDE.md s3.
- Walker: a press on a toggle button toggles it (coach-hire tags).

## Found
- **Design review finding 1 is a REAL disconnect**: `FightRealtime.gd` (the engine that settles the player's bout) reads none of the
  camp's bout edges (strike_success, defense_bonus, stamina_discount, composure...); only the old FightSimulation does. The camp
  reaches the live bout only through the plan-fit `overall`. CAMPVIS1 (Qwen) wires it behind `camp_live` (OFF): landed on
  qwen/campvis1 1c1f4e9d (40 seeds: +2.2 landed points, win share 71%) - **review owed, not merged**.

## In flight
- Cursor CORNER1 (first corner played, plan as default order, SIM asks once) - wt GYM4G, branch cursor/corner1, still running.

## Next (roadmap now)
Review+merge CAMPVIS1 -> collect CORNER1 -> wire MOMENTS1 (corner calls logged per round) -> GYM5-LOOK (operator's reference,
artstation DAg4wy: one look-dev still first, TASK_GYM5_LOOK_ART_PASS.md) -> continue the club walk to the first bout.

## Owed / not done
- The exe build + exe walk (S181 next step 2) was not run; the dev-tree as_game walk reached the coach hire (the old s117 plan predates
  the empty-gym start; new plan research/s182_club_walk.plan).
