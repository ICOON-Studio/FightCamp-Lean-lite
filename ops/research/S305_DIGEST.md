# S305 digest (2026-10-29) - fight words agree with the ring; real upset numbers set the balance proposal

## What now works
- Arena WORDSCONTRACT1 collected (Lean PR #7, squash 7c005b7): `tests/fight_words_contract_test.gd`, a blind contract test
  written from the module headers, plays 32,400 seeded rounds (two different fighters x 3 opponents x rounds 1-3 x both
  winners x 3 margins x 300 seeds). CI green.
- Its 3 FINDINGs fixed (Lean 95a69f5):
  1. The corner card's landed totals skipped `rear_hook` and `lead_uppercut` (RoundStyle plays them; CornerCard.WORD did
     not list them): 6,375 rounds with wrong totals, 239 with the wrong top punch. WORD/SHORT now list every punch beat.
  2. A combo picked longer than the lead's punches left in the pool was cut short by `_take` and then captioned "landed
     whole" (51 rounds). RoundScript caps the run at `_left(pool, lead)` before the combo pick.
  The test's FINDINGS list is empty again - all three are hard checks.
- John J-UPSETS1 (SQ18) collected and committed (J_UPSETS1_JOHN.md, mojibake repaired): pro boxing favourites win 86.2% of
  decided fights (4,536 fights); UFC by odds band 53-89%; Olympic red corner 50.5%. His target: ~60/75/88% at a
  slight/clear/big edge, never above ~95%.
- Measured (Lean tools/balance_targets.gd, b1809db, 800 bouts a row vs Priya, real rounds): spread 27 -> edge +3 66%,
  +5 78%, +8 86%, +13 95%, -5 27%. Spread 14 (the S304 proposal) stays too certain (+5 91%, +8 98%).
  BALANCE_S304.md (board Q-S294-8 attachment) now proposes 27 with the full table.
- TASK_BALAPPLY1 brief ready for Goose (spread 27, Combos.tired_penalty ramp max 6 from FRESH_AT, RoundScript margin
  bands scale with the spread so close/clear/dominant keep today's mix).

## Evidence
- `fight_words_contract_test` -> WORDSCONTRACT failures=0 with FINDINGS empty; round_script, corner_card, combo_words,
  combos, fight_feel, round_style, habit_beats, knockdowns, golden_path -> 0 failures (local headless, Godot 4.7.2).

## Decided (developer calls)
- 27, not 14: the analytic fit (P(bout) = p^2(3-2p), triangular roll difference) and the measurement agree; 14 would leave
  a 5-point favourite at 91% against a real ~75%.
- Margin bands must scale with the spread, or nearly every round would read "dominant 6-1" at 27.

## Not done
- Lean issues #1 #3 #5 (merged Goose tasks) still open: the permission guard refused `gh issue close` (external write).
- Goose idle: its only lane item (BALAPPLY1) waits on Q-S294-8.

## HANDOFF
Next: S306 - board Q-S294-8 -> launch TASK_BALAPPLY1 on Goose -> collect -> re-film round 3 -> update 7; his verdict on the
S304 film; then ask him (board) whether the gym floor (RESTART_PLAN week 5+) is next.

## S305 continued (same session, after the operator's "Yes, both" and his film comments)
- Balance live: Goose BALAPPLY1 -> Lean PR #9 (ddc6432), CI 22/22 incl. golden path. Spread 27, tiredness ramp (max 6 from
  energy 70), RoundScript margin bands 6.75 / 18.0.
- C138 "body shots do not seem to have any impact" (film S304): only 1 of 11 body shots landed and its reaction
  (gut-shot v1 short at 1.25x) barely moved her. tools/fight3d_bodyshot.gd stages one landed body shot the game's way.
  ActionForge (his ask) has only Hit Chest, 0.33 s, arms down - weaker. Our Punch Pro gut-shot v3 folds her: now used.
- "reaction is way too slow" / "make it more fluid ... not always reset to a default clip": what studios do - pose
  matching back into the loop, inertialized joins, reactions on the blow, hitstun. Built: BeatClips.react_fast (peak 0.22 s
  after the blow), IdleMatch.gd (enter the guard idle at the nearest pose, one of 3), JoinSmoother.join(half_life,
  duration) (guard 0.1 s / 0.45 s, strikes 0.06 s) - Lean 998f5af.
- "still no reaction animation on body shots": the film's joins log showed the reaction overwritten by the next beat's
  defence/fidget. HitStun.gd (ea66dcc): reactions cut inside 0.3 s 5/21 -> 0/21 on the same seeded film; body shots 0.7 s each.
- tools/fight3d_gallery.gd + gallery_reel.py: the move reel - 7 punches x 6 outcomes + tired/count/KO/win, 46 labelled cases.
- Seen in the reel, queued: slips/weaves always to the left; a blocked body shot plays a head cover-up.

## HANDOFF (updated)
Next: S306 - his verdict on the S305 film + move reel; slip side; elbow block for body shots; update 7 export.
- "Yes, fix both": slips/weaves pick the side from the attacker's real hand (BeatClips.defence), a blocked body shot is taken
  on the elbow (HitSnap.brace) - Lean 5509f28, reel v2 on the board.
- "memory fix tool is not working": the RAM trim loop died 10-29 01:05 (0xC000013A, logon-only trigger) and Opera (4.3 GB,
  the biggest) was not on its list. Restarted via its task, kept alive by the 30-min reconcile, Opera added (Game 86178ee3).
- Disk (measured, nothing deleted): E: 27 GB free - Steam 234 GB (Phantom Blade Zero 151), Game repo 44, E:\Projects 32,
  SpaceGame_helpers 14, EVE 12, wt 12, backup_D 9.7, two old actions-runner-fightcamp 5.9 each. C: 7.4 GB free - Google Play
  Games VM disk 86 GB, Program Files 114, .codex 31.6, Downloads 21.7, Windows.old 20.9, Temp 11.5; the iCloud folders
  (399 GB listed) are cloud-only, 0 on disk.
- "sidestep returns back to the same point": the Pro dodges are exported in place (hips pinned in the source); S306 first.
- Cleanup (operator 'Yes, clean it'): deleted the two old Guru-Meditation runners (no service/process), wt\g158_out (10-05 logs), E:\FightCamp\tmp (S301-S305 renders; claudekit_src kept), tmp_mh, C: Temp older than 2 days. E: 25.5 -> 42.2 GB free, C: 7.3 -> 13.2 GB. Kept: wt\UI_REF (TPM reference), wt\ZIVA.
