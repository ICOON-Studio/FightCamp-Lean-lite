# S206 digest (2026-10-11/12) - the 7-tab fighter profile on real data, 3 animation layers, V3 HUD default, 12 seats working

## What now works (evidence opened by Claude)
- V3 HUD IS THE GAME'S DEFAULT (board Q-S204-2: "since this all we have after 40 days of development use it but its is not looking
  right to me"). Operator mark 2 fixed (opaque plates, FIND A FIGHT a gold link inside the plate, "to Tue" inside Continue).
  playable_loop T4 presses the player's real control (Continue under HUD2/V3) - 9/0 with V3 on and off.
- FIGHTER PROFILE, 7 LIVE TABS (operator S206: "a proper player profile card with its subtabs fully completed"): OVERVIEW,
  TECHNIQUES (54-node tree in 5 states, 3D stage), MEDICAL, TRAINING PLAN, FIGHT RECORD, CONTRACT, CAMP - Ludo r41 TEXT spec
  (87.5k chars; his image model drew the tree column EMPTY twice), real reads only (his invented fields listed and left out).
  Built by Cursor (PROFILE2C local, PROFILE2D cloud), Arena (PROFILE3A TechniqueTree, PROFILE3E PlanWeights), Antigravity (PROFILE3D
  OpponentCompare), Codex (PROFILE3B 3D stage); header strip + wiring by Claude. Tests: profile_tabs 855, profile_tabs_b 101,
  wiring 13, technique_tree 135, plan_weights 83, opponent_compare 69, profile_stage 202 - all 0 fails, mutants red.
  Stills docs/previews/s206_profile_tabs (on the board, WORK IN PROGRESS - see open defects).
- ANIMATION (board Q-S204-1 "build it all with your corrections"), all behind switches OFF: IntentBus (ANIMBUS1, Arena code did not
  parse - Claude rewrote to the contract), PUNCH S-CURVE (ANIMSCURVE1, Codex sol; production contact time wins over clip_phases.json
  - jab 0.3225 vs 0.25), FATIGUE POSTURE + GLOVE SPRINGS (ANIMFATIGUE1, Codex sol; wrists drop 8.4-11.5 cm at stamina 0.40),
  C224 inside-uppercut gate (Qwen cloud). Benchmark step 6 column now logs phases (was 0). 18/18 fight_stage subset green.
- TECHNIQUE SEED (TECHSEED1A, Qwen cloud): the techniques a fighter already knows from specialty + bouts + stats (41/0).
- PC HEAT FIX (operator: "stay on the plan, do the cache fix and see how it goes"): Tools/seed_godot_cache.ps1 seeds every agent
  worktree with the 4.4 GB import cache - a fresh-worktree full import drove the PC to 87 C / 100% CPU. On RED: suspend (not kill).
- OPERATOR SHEET (board Q-S205-2 "keep Godot, take the 4 ideas"): tone rule filed (ui_screens.md), BROADCASTCUT1A on OpenCode,
  stress+afflictions -> John/Kalli now, Ludo next; um win drive not adopted (drives the real mouse/keyboard).
- RESEARCH: John (why we don't look like Two Point Hospital - mixed photoreal/toy/realistic styles; fix = one stylised style),
  Maria (readability checklist), Kalli (profile tab priorities). Board Q-S205-3 asks the gym look + a US$39.99 prop pack.

## Open defects (first things next session)
1. PROFILE STAGE CAMERA shows the fighter's BACK (s206_profile_tabs/2_tab1b_techniques_jab.jpg): fixed-axis presets are wrong for a
   bladed stance - aim the camera from the rig's own facing (Hips/Spine forward + stance blade); the boots show bare skin at the heel.
2. LEARNED 0/54 on every fighter until TECHSEED1B (Arena, running) seeds world + starters.
3. Profile stills fighter: seeded DevJump roster can hold no boxer - profile2_stills now signs an affordable boxer itself.
4. fight_stage_realism_test red (7 rules) -> TASK_REALISM1 (Codex sol, worktree seeded, NOT launched - PC was hot).

## Operator design idea (S206, verbatim, NOT yet designed) - next Ludo ask
"when a customer comes to check in for the first time (scene zooms to the reception desk or it comes up as model with option you
want to register new customer if yes then zoom to the reception desk if not nothing happens and stays at this angle) the player
standing behind the reception desk and customer in front, on the right side is the checking application" (+ a reception desk model
picture: dark slatted front, wood top, "RECEPTION" band). D39: Ludo first, verdict, board approval, then build.

## Decided (Claude, developer)
- Ludo profile = text spec + build to it; no more UI image asks (dense screens come back empty).
- Agent diffs: plain git apply, never -3 in the shared checkout (it blocked the floor session's commits).
- Codex briefs: no "two runs" wording - keep fixing until green; astra only after sol fails the whole task (operator S206).

## In flight at handover
Codex ANIMUPPERCUT1 (sol, wt E:/FightCamp/wt/ANIMUPPERCUT1), Arena TECHSEED1B (chat 01a12cb8), Qwen cloud ANIMBALANCE1A (issue
#118 re-run), OpenCode BROADCASTCUT1A (issue #121), John J_STRESS, Kalli K_STRESS, Maria M_STYLE_SHEET (gbot threads).

## HANDOFF
Next action = roadmap now.next_action (S206). Last working code commit: the profile stills commit on master.
