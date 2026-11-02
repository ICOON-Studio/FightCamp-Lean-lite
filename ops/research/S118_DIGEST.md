# S118 DIGEST - 2026-09-28 - boxing 2/36 (the cross), feints stop eating punches, a gate that could not pass

## Milestone: PLAYABLE WITH A BOXER (stage B)
Boxing EXACT-that-PASSED: 1/36 -> 2/36 (jab, **cross**). Kickboxing 0/20.

## What landed (master)
- **C223 run 7 merged as a diff** (`10223311`, branch `f4001d85`): `boxing_cross` = owned RamsterZ
  H2H_StraightPunchInPlace, exact, passes every row on generated welter a/b and heavy c/d, both directions; 20/20 seam
  mutants rejected. Stills opened (`docs/previews/c223/run7_bound_owned_cross_*`): rear straight with hip turn at 0.30 s;
  a deep post-contact dip at 0.55 s is the source's own recoil (accepted, noted). Hooks, uppercuts, body shots and the
  one-two/double-jab chains stopped with rows (J/V/T/B). The 8 rejected archive GLBs stay on the branch only.
- **Feints no longer spend a throw decision** (`d9e71be5`, boxing_output only): the feint banks the punch the man
  decided on; his next attempt passes the gate. S117 probe (`tools/s117_jab_share_probe.gd -- switches output`):
  32.4 -> 45.7 actions/man/round (about 49 punches counting combinations as their punches; CompuBox 45-56), feints
  6.0 -> 9.2/min. `boxing_output_test` proves it on out-boxer/counter vs pressure: feint ON 47.3 vs OFF 42.2 thrown/rd;
  the HEAD control FAILS it (36.5 vs 42.2). MMA/kickboxing untouched.
- **C223 timing-band defect fixed** (`d6372beb`): hook/uppercut onset-to-impact bands misread K32 - the uppercut band
  606-627 ms was two Stanley MEANS (a 21 ms window no take can hit), the hook floor 477 was Piorkowski's earlier
  ACTION clock. Now K32's fist-onset..Stanley-initiation bracket, as the jab/cross rows already were (hooks 132-657 /
  132-586, uppercuts 71-627 / 71-606). Upper bounds unchanged. SHOT_LIST_STRIKING rows corrected to match.
- **Tale-of-the-tape silhouette** (`52a714c3`): when both corners hash to one face the tape stepped with a 3-face rule,
  so faces 10-12 showed a SILHOUETTE on fight night (walk `s118_walk/73_fight_night.png`) and the rest a different face
  than the intro. Now the intro's next-pool-face step; test fails 11/12 on the old code.
- **Walk re-run as the game** (`s117_boxer_walk.plan -- as_game`, out `docs/previews/s118_walk/`): career -> ... ->
  RESULT -> next week -> save, no dead end. Round-bell card photographed at +6 s: "4 weeks of fight camp. Now it's three
  minutes." Result: Larkin 10.8 / Pereira 13.0 output per min, jab share 46% / 26%.
- Re-pins after S117's engine moves (separation floor, legal demo bodies, feint refit, catalogue fixes):
  `fight_strike_whole` OFF hashes (two runs agree), `judge_panel` T4/T8R (superseded by the fixture fix below).

- **Body skin follows the face** (`f723113d`): the generated body and the portrait were each drawn from the id, so a
  dark body stood under a light face (walk 76). The 12 male portraits are tagged by the ancestry they show
  (`TaleOfTape.PORTRAIT_ANCESTRY`) and `apply_identity` takes the displayed face in the fight room and on the training
  floor. Test: 240 draws match; a no-op mutant misses 156. Re-walk 76_bout_live: both bodies now match their faces.
- **judge_panel fixture de-identicalised** (`74488aaf`): the 62-v-64 pair was one man twice but for fight_iq (mma_5 was
  60 v 60). Now outboxer v pressure in the test and in `tools/find_r101_seeds.gd` (`panel <lo> <hi>`); 12 cards
  re-pinned by the test's own two-run check; T11 re-found on the new pair (kickboxing 300, boxing 9: majority draws;
  no split or majority in 1..300).

## Boxing switch census (S118, master 74488aaf, `tools/u195_engine_census.gd -- bouts=20 ruleset=boxing switch=feint`)
3 populations pooled, 60 bouts an arm. Anchor: boxing ~47% KO/TKO (BoxRec, G108).

| arm | sig/min | acc | finish | KO+TKO | KD bouts |
|---|---:|---:|---:|---:|---:|
| OFF | 5.77 | 52.9% | 33.3% | 33.3% | 20.0% |
| game (all ON) | 10.83 | 40.6% | 75.0% | 63.3% | 45.0% |
| only feint | 3.92 | 54.1% | 21.7% | 21.7% | 13.3% |
| all ON minus feint | 9.24 | 39.6% | 71.7% | 65.0% | 50.0% |

The pre-S117 log (Cursor's leftover, 00:04) had feint killing finishes (36.7% -> 9.2%); after S117's refit it no
longer does. The game arm now OVERSHOOTS, and it is boxing_output's doing (minus-feint is the same) -> TASK_Q211.

## In flight at handover (collect in S119)
- Codex C223 RUN 8: worktree `C:/Users/user/AppData/Local/Temp/FightCamp-C223`, branch `codex/c223-boxing-kb-clips`,
  base `c7b3fce9`. Merge as a diff from that base.
- Qwen Q211: worktree `C:/Users/user/AppData/Local/Temp/FightCamp-Q211`, branch `qwen/q211-boxing-stoppages`.

## Open
- The fixture sweep (switches OFF) shows 40/300 boxing unanimous draws (13%) - Q211 reports the draw share.
- No female generated bodies (known gap). U195 room arm waits for D3 (it records video).

Suite: no full suite in session (nightly rule); subsets run: boxing_output, fight_feint, fight_commitment,
fight_defence_model, fight_targeting, fight_strike_whole, judge_panel, boxing_idle_binding, boxing_join_discontinuity,
generated_portrait_fallback, tale_of_tape_data - all 0 fails. Nightly
`AgentComms/nightly/latest.txt`: 2026-09-28 at 6d2a4201, total=457 fails=23 (strike_whole and judge_panel among them,
both fixed here).
