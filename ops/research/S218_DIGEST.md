# S218 DIGEST (2026-10-13) - PC crash recovery, story mode built (2 of 3), nightly reds cleared, Grok Dev live

## What now works (master)
- **Story mode (board Q-S212-12 "Approve - build it", Ludo r52):** STORYMODE1A rules (885a87ef, Arena #154): two switches story
  + guidance, presets house_that_holds / guided_sandbox / open_sandbox (+ campaign_veteran custom), one-way convert_to_sandbox,
  neutral beside expiry. STORYMODE1B screens (4f2bc6da, cloud Cursor #155): New Career START strip + ADVANCED; Settings STORY
  section with CONVERT TO PURE SANDBOX + plain warning. STORYTUT1 (aae73099, Kalli recast + cloud Cursor #157): the first hour is
  Mara Solano at Calder House, Leo + Anvil Street retired, women opponents Elena Perez / Nadia Kerr, Claude's 3 corrections in;
  old male prospects moved verbatim to assets/data/bench_fighters.json (BenchCast.gd) so benches are unchanged.
- **Fight engine (1300461b):** Recovery Rate live (RECOVERY1B/1D, switch recovery_rate in DEMO_SWITCHES); a delayed collapse in the
  rest retires him when it comes due (corner gets its minute); doctor towel = RTD at a bell check / TKO at a mid-round check; every
  stoppage names a cause.
- **Gym floor (4f2bc6da, Qwen NIGHTLY6A):** slot metres -> floor cells (FLOOR_CELL_METRES), free in-bounds slot used, out-of-bounds
  refused, preview migrates slots. NOTE Claude first removed Qwen's free-slot fallback, equip_slots_test went red, restored it.
- **Bodies (da0048d7, Grok BODYPICK1):** boxers get the MetaHuman body nearest their weight/height.
- **Icons (1236bcc9):** Maria round 4, Ludo's style (Q-S212-15 "Take Ludo's change"), 54 move icons rasterized by tools/svg_icons_to_png.gd.
- **Mixamo batch 2 (ee713ddd):** 6 clips (corner rest, count stand/knee, cornerman, 2 walkouts), 121/121 gate PASS.
- **Pure modules merged:** PunchShapeMath (SHAPEGATE1), TapeReadoutRows (RECOVERY1C_A), StationIntegrity (STATIONWEAR1A),
  FightUsageTally (FIGHTLOG1A) - all Arena.
- **Asset manifest (141e8adb, Grok Dev's first PR #156):** Mixamo library claimed; the test exits 1 on failure.
- **Tooling:** .claude/skills/visual-gate (start flags animation briefs without it); Tools/board_reconcile.py + task "FightCamp Board
  Reconcile" (30 min); "FightCamp Heat Governor" now starts at logon; CLAUDE.md gates first; MEMORY index halved; UIKit.filter_strip
  chips sized by the built button (9f750692).

## Evidence
Story 15/0 + 18/0 + 24/0; fight-end 9/0; floor 38/0; recovery 13/1433/11/223/in-round/game_switches PASS; body pick 16/0 + mh2 both
arms; Mixamo bake 121 PASS; nightly 10-13: the 5 new reds fixed (causation_real_path, corner_card_wired, creation_api, smoke,
training_floor_3d) + asset_manifest -> expect 4 reds next nightly (fight_pair_live, fight_stage_realism, fighter_reachability_contract
mpfb_m_178, switch_gate_face_drawn_foe).

## Incidents
- 13:09 PC hard crash (Event 41, bugcheck 0) under 3 agents' Godot tests + Brave/TheCrust; governor had no autostart. Now 2 PC
  agents max; governor scheduled at logon (memory project_pc_crash_s218).
- A stale .git/index.lock stopped one commit while the chained command closed issues 151/155 with the wrong sha; corrected on GitHub.
- Arena in Brave = grey skeleton; the built-in pane works (memory reference_arena_agent).

## In flight at handover (YOURS next session)
- Codex ANIMSOURCE1D FIX2 continue (wt ANIMSOURCE1): wrists 22/22 done; guard roll / face clearance / spacing with Claude's rulings
  (anatomical shoulder yaw, pitch by phase/role, Ludo r50 = spec). Out file E:/FightCamp/wt/ANIMSOURCE1D_fix2_continue_out.txt.
- Cursor PROFILE2E r9c (wt PROFILE2E). Out E:/FightCamp/wt/PROFILE2E_r9c_out.txt.
- TECHSTAGE1: 37/37 on the branch; Claude merged master into codex/techstage1 (0901bc14, conflict = both switches kept); merged tree
  50/52 - the 2 misses are switch_gate_contact_push_carry / face_drawn_foe killed by the runner timeout; solo re-run queued
  -> face_drawn_foe PASS; contact_push_carry FAIL on the merged tree (pops ON 12 vs OFF 8; master control ON 12 < OFF 21). FIX5 prompt ready (E:/FightCamp/wt/TECHSTAGE1_fix5_prompt.txt) for the first free Codex seat; merge only after it passes.
- Grok Dev STATIONWEAR1B: brief on master (TASK_STATIONWEAR1B.md) - NOT YET SENT (Windows input panel blocked the app).
- Waiting the operator: nothing open on the board except his review of the New Career still / icons / cast stills.

## HANDOFF
Next session: (1) launch Codex TECHSTAGE1 FIX5 (prompt ready) when a PC seat frees; merge after its gates pass; (2) send Grok Dev
"git pull master, then do research/TASK_STATIONWEAR1B.md"; (3) collect Codex ANIMSOURCE1D + Cursor PROFILE2E (open every
still - visual-gate skill); (4) STORYPARITY1: Ludo ask for the sandbox promoter-offer + debt-event numbers, then brief; (5) MIXAMO1B
on the next free Codex seat; (6) the 4 remaining nightly reds; (7) FIGHTLOG1 wiring after TECHSTAGE1 merges (FightUsageTally is on
master); (8) boots for the MetaHuman boxers (WARDROBE1) and female-look variety (MH5).
