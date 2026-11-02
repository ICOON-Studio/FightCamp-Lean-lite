# S219 DIGEST (2026-10-13) - jabs back, New Career finished (Ludo-approved), Codex talks to Ludo, station wear B+C

## What now works (master)
- **Boxers throw the jab again (NOJAB1, cloud Codex codex/issue-160, by diff):** FightMoves.select's stage-2 "golden-ratio
  decorrelation" made the head jab unreachable inside the setup role - 0 boxing_jab in 120 s on every seed (probe
  tools/probe_pair_beats.gd). Now the stage-2 roll is the role-conditional local position; movement-only x0.25 in both boxing arms;
  base jab usage x1.8. New jab_share_test (20 seeds x 3 cohorts x both arms, jab family 25-55%, head jab >= 15%, control red).
  composure_live master-log hash re-pinned (every seeded bout changes by design).
- **New Career step 3 finished (NEWCAREER2 + 2B; operator C58; Ludo r53 verdict A, r55 "APPROVED WITH FIXES" 8.2/10, all 7 fixes
  in; palette WARM BROWN = D47 from board Q-S219-1):** real runway from the weekly burn (amber when < 12 wks, BURN shown), equipment
  cards with 10-step condition bars + upkeep + what each trains, one dashed install block, starter attribute bars, label-free floor
  blueprint + pitch card + OPEN GYM on the right; story start pre-fills Calder House Boxing Club and starts with Mara Solano; in the
  GAME the sandbox starts open the S144 empty gym (preview = save); the New Career starts are boxing-only (generator boxing_only);
  with no start named (tests, old saves) the legacy boxer/MMA/wrestler fixture is unchanged. Fixed nightly red creation_api (C14).
- **Station wear B + C (Grok Dev PRs #159, #161, by diff; switch station_wear OFF):** stations wear with use, a worn station trains
  less, can injure (seeded, existing injury path) or break; SERVICE / REPLACE; station card shows the tweened integrity bar.
- **Gym floor round 6 (cursor/gymlook3a 6af7517c + 6a737783, NOT merged yet):** brick on the east + west walls (C57), the junk props
  gone (C55/C56: a wall-mounted whiteboard and anatomy poster standing in open floor, grey water-bottle cylinders, white flats, a
  red cube on the apron, a stool under the deck). Ludo r54 art review: "yes with fixes" 5.8/10 -> GYMLOOK3B list.
- **Codex has web access + Ludo (operator: "give web acess to codex", "can you ask from codex to communicate directly with ludo"):**
  Tools/codex_task.cmd gives every run a Playwright MCP browser (headless Brave, profile E:\FightCamp\codex_browser_profile, signed
  in to Ludo by the operator; probe lands on Ask Ludo "Gym Management Screen"); the ludo CLI (E:\FightCamp\tools\npm\ludo.cmd,
  logged in, Pro, 805 credits) gives Codex 3D rig + text-to-animation (0.2 cr, 4 candidates). Method in AgentComms/CODEX_TOOLKIT.md.
  TRAP: the Claude app is an MSIX package - its npm -g installs land in its private AppData, invisible to other shells.
- **Tests fixed to the shipped tree:** fighter_reachability_contract now witnesses the MetaHuman men (mh_boxer_01/04 via
  MetaHumanRig.load_fighter; still red for the REAL reason, KM3B); playable_loop walks OPEN SANDBOX + a named bout button.

## Evidence
NOJAB1: --only jab_share,fight_moves,selection,q113,q194,boxing_output,feint,footwork,certified,fight_plan,q226,determinism,
fight_realtime,composure,in_round,boxing_clinch 27/28 (fight_pair_live red for real reasons -> PAIRLIVE1). NEWCAREER2+2B:
new_career_finished 41/0, creation_api 20/0, creation_root 50/0, playable_loop T1-T9, --only new_career,creation,boot_root,
playable_loop,first_hour,story,front_door 24/0. Station wear: 27/0, 39/0, --only station,day_lap,daylap,equip,injur,game_switches
22/0. Renders opened by Claude: DesignLibrary/screens/creation/gym.png; gymlook3a r6b stills (8787/review).

## Delegated this session
Arena STORYPARITY1A (chat 01a135de, arena/b27b6e2a-fightcamp - stalled once, nudged, running); cloud Cursor NEWCAREER2 (#158,
merged); cloud Codex NOJAB1 (#160, merged); Grok Dev STATIONWEAR1B (merged), 1C (merged), 1D (running); Codex FLYFOOT1 (running,
wt E:/FightCamp/wt/FLYFOOT1); Cursor PROFILE2E r10 (checkpoint 53904677) + r11 (running); Codex ANIMSOURCE1D continue (hung 15:49,
stopped, WIP b5bb8c06). Ludo rounds 53, 54, 55.

## Lessons
- Always read the board (questions.json answers, media_comments.json) before saying "waiting for your answers" (operator S219).
- Board attachments must live inside the repo (an E:\ path is not served).
- A Codex run can hang silently: check ~/.codex/sessions/<date>/rollout-*.jsonl LastWriteTime, not the cmd process.
- A UI render captured 2 frames after build shows the entry tweens mid-flight - wait ~1.2 s (render_creation.gd now does).
- Saving a long Ask Ludo reply: the reply's own "Copy response" button + Get-Clipboard (back up / restore the operator's clipboard).
- A stale .git/index.lock appeared 4 times with no git alive; the 21:50 one matched a curl to the ops board's /api/roadmap - suspect the
  board server's git calls being cut off (Tools/opsboard/server.py): next session, give its git calls no-lock flags (GIT_OPTIONAL_LOCKS=0).

## HANDOFF
Next session: (1) collect Codex FLYFOOT1 (gate red on master first; open every still - visual-gate skill), then on the Codex seat:
TECHSTAGE1 FIX5 (prompt E:/FightCamp/wt/TECHSTAGE1_fix5_prompt.txt), ANIMSOURCE1D relaunch (WIP b5bb8c06), KM3B, PAIRLIVE1,
LUDOANIM1; (2) collect Arena STORYPARITY1A (review the PR + CI log yourself, never Arena's merge button), then brief STORYPARITY1B
wiring (cloud Cursor); (3) collect Grok Dev STATIONWEAR1D + Cursor PROFILE2E r11 (stills); (4) GYMLOOK3A: merge after the operator's
OK on the r6 stills (8787/review), then GYMLOOK3B (Ludo r54 list) for Cursor; (5) the operator's OK on the New Career screen
(8787/review); (6) FIGHTLOG1 wiring after TECHSTAGE1, MIXAMO1B, WARDROBE1 boots + MH5 women variety.
