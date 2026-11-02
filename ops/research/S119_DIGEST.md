# S119 DIGEST - boxing 2/36 -> 10/36; stoppages at the BoxRec rate; gloves fixed; clipping rule + guard styles researched

Milestone: PLAYABLE WITH A BOXER. HEAD at write: c4a5413f + this digest.

## Collected and merged
- **C223 run 8** (Codex, a934adca, base c7b3fce9) merged AS A DIFF -> **8812a447**. Boxing EXACT-that-PASSED
  **2/36 -> 5/36**: boxing_jab_body (Mixamo Long_Body_Jab), boxing_one_two and boxing_double_jab (SEQUENCE entries of
  the certified jab/cross, half-retraction cut 0.7667 s). 12 bound rows + 8 chain rows PASS on the four generated legal
  bodies; no threshold moved; seam mutants 20/20 rejected. Stills opened by Claude: double jab (heavy C), one-two
  (welter B), body jab (welter A) read as their SHOT_LIST rows. Focused: boxing_ 4/0, fight_presentation_queue,
  paired_stage_player, fight_hold_binding 1/0 each. Parse 5/0.
- **Q211** (Qwen, db088000) merged -> **22d71d18**. BOXING_OUTPUT_CONTACT_LADDER 0.74 -> 0.60. Census re-run by Claude
  on the merged tree (`tools/u195_engine_census.gd -- bouts=20 ruleset=boxing switch=feint`, 3 differentiated matchups
  pooled, 60 bouts/arm) reproduced the digest exactly: game arm KO+TKO **45.0%** (BoxRec 47%), connect 33.0%,
  KD bouts 31.7%. The TitleHonours preload in GameState.gd was reviewed and kept (global class; fresh-worktree cache).
  Focused: boxing_output, fight_feint x2, judge_panel, fight_strike_whole, title_honours - all pass.
- **Probe defect fixed:** `tools/s117_jab_share_probe.gd` divided by 3 full rounds even when bouts stop early
  (read 34.4 thrown/round). It now also prints per FOUGHT round: **50.1** (CompuBox 45-56), 8.25 of 12 rounds fought;
  feints 21.2 per man per round = ~7/min (G86 6-14).
- **G146** (Grok) collected: no sourced pro-boxing draw rate exists; PROXY 2-3% of all bouts; 10-10 ~1% of rounds.

## Found
- Census boxing draws 11.7% of bouts in BOTH arms. Not 10-10 rounds (boxing scores 10-10 only on an exact float tie):
  4-4 splits over 8 rounds between deliberately EVEN pairs. Judges NOT touched - Q212 measures the booked population.

## Verified playable
`tools/s64_career_walk.gd -- plan=res://research/s117_boxer_walk.plan as_game` on the merged tree: 83 steps,
failures=0, no SCRIPT ERROR; result screen UD 29-28 x3 (amateur, $0 purse correct), next week, saved.

## In flight (theirs to finish, the next session collects)
- **C223 run 9** - Codex gpt-6-astra medium, worktree Temp/FightCamp-C223, branch codex/c223-boxing-kb-clips,
  base 8db1c12a: strike-phase warp for the slow hook/uppercut sources (V+T), B at the root, then the rest of the 36.
- **Q212** - Qwen, worktree Temp/FightCamp-Q212, branch qwen/q212-booked-census: booked-bout census.

## Suite
No full suite in session (nightly rule). Subsets above only. Nightly `AgentComms/nightly/latest.txt`: 2026-09-28 at
6d2a4201, total=457 fails=23 (S118 fixed strike_whole + judge_panel; smoke_test, result_screen_why and 19 more still
listed) - the 09-29 nightly on this master is next session's step 0; not re-run here because two agents are running.

## Second stage (after the first ship, operator kept the session going)
- **C223 run 9 merged** (inside 21878ca9 - committed under the topic-pages message because the diff was already staged;
  focused tests passed after: boxing_ 4/0, presentation_queue, paired_stage_player, hold_binding, cc_skin,
  gloves_both_corners 1/0). Boxing **10/36**: + lead/rear hook, lead/rear uppercut, body hook via `strike_warp`
  (strike span only; whole-clip-warp mutant rejected). Rear hook edge-tuned (13.9988/14 m/s, heavy C) - re-open.
- **Q212 merged** (25f10c82) after one send-back (tool hardcoded boxing rules - the game's S65 per-discipline ruleset
  was fine): booked boxing KO+TKO 46.7%, draws 5.8%, **0 split decisions in 54** - judges never disagree (open).
- **Gloves fixed** (fb7efb7a): they read local poses; the active ragdoll + FighterFist are SkeletonModifier3Ds, so the
  glove sat where the hand was before the ragdoll moved it. Now posed on skeleton_updated from the final pose.
- **Operator videos** (tools/s119_showreel.gd, s119_live_record.gd): certified moves; live room 30 s; RamsterZ vs Mixamo
  jab (operator prefers RamsterZ - it passes every smoothness row, sat out only on speed). Live spacing 3 min: median
  1.05 m, 20.9% inside 0.80 m. FEINTS are invisible in the room (engine ~7/min, room presents none).
- **Research collected** (all in topic pages + memory `project_research_findings_S119`): G146 draw rate (PROXY 2-3%),
  G147 clipping rule (head >1 cm/>1 f, torso >2 cm/>3 f; blends 80-300 ms), D64 8 guard styles + defence/fatigue.
- **Q213** first cut (078a9cb3): live FAIL 26 events, but HEAD counted glove-on-arm; sent back.
- Stage B real % 58 (formula on the ops board); clip coverage re-measured 160/537 = 29.8%.

## In flight at handover (the next session owns them)
- **C223 run 10** - Codex, worktree Temp/FightCamp-C223, branch codex/c223-boxing-kb-clips, base 5c17c08c.
- **Q213 send-back 1** - Qwen, worktree Temp/FightCamp-Q213, branch qwen/q213-clipping-gate, base 6dbec08e.
