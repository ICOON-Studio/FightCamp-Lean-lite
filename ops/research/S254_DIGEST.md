# S254 DIGEST (2026-10-18) - shout dock collected, production roadmap, Undisputed timing study

## Operator words this session (verbatim)
- "you have permission to delete the 333 merged branches"
- "can you ask paul to make a production roadmap to see what will be fixed when etc and check if you and ludo approve it"
- "also you can rea on undisputed (animations logic etc) , assign maybe ziva to help with this. Will this help us?" + the link
  github.com/morluto/rea
- Still comments: C107 "fine as placeholder" (corner card jobs.png - kept); C108/C109 MARKUP on the Techniques jab still: "this doesn't
  look good" (the 3D preview boxer).

## Shipped
- Q-S249-1 CLOSED: the 333 branches of `AgentComms/branch_prune.json` `on_master` deleted from origin (each tip re-checked unchanged
  first; 0 skipped, 0 batch failures; sample ref gone in ls-remote; origin now 542 heads).
- SHOUTDOCK1 (Cursor #259) collected by diff e91b81a4 (FightWorldLiveScreen `_sync_shout_bar`, LudoShoutBar, shout_dock_test; HANDOFF.md
  line left out). Tests shout_bar/shout_live/shout_dock SUITE total=3 fails=0. Game-camera still (new `tools/shout_dock_still.gd`,
  as_game, fighter A with 7 drilled bars): STILL_FRAMING OK; the dock reads 91 DRILLED / 74 SHARP / 68 SHARP / 55 USABLE / 46 USABLE /
  22 RAW (!). Defect seen on the still: calls-left pips drawn as 26 px bars (HBox stretch) - fixed 131e9672 (SIZE_SHRINK_CENTER), re-shot.
  Issue #259 closed, run archived. Still on 8787/review.
- PRODUCTION ROADMAP (`research/PRODUCTION_ROADMAP_S254.md`): Paul (pm_bot P36, 22,036 chars, raw `PAUL_ROADMAP_S254_raw.md`) ->
  Claude review (4 changes: branch delete done, dock done, C108 is an art call for Ludo, punch timing missing) -> Ludo r119 (17,749 chars,
  marked picture uploaded) -> verdict: S255 goal strip + Readiness/Wear meters + punch timing; S256 watchable jab; S257 training day +
  coach; S258 opponent + fight + progress; S259 .exe + polish; S260 Steam EA. Board: Q-S249-4 (order), -5 (counter window, new mechanic),
  -6 (weigh-in / visible cut / mitt sound), -7 (demo scope: fixed slots, no promotions, Steam spend waits) - each with the roadmap attached.
- UNDISPUTED STUDY (`research/UNDISPUTED_STUDY_S254.md`, dumps in E:\FightCamp\tmp\undisputed_study): Unity 2022.3.45f1 IL2CPP,
  so the S243 TPM route (global-metadata names + UnityPy) - REA not needed; Ziva is a Godot seat and was offline. 3,152 clips: jab head
  impact 0.365 s, control back 0.116 s after impact (all punches 0.11-0.17 s); ours lock 0.42 s (jab) to 1.4 s (body shots) after
  contact (`clip_phases.json`). Ludo r119 B adopts it (per-punch offsets, body contacts 0.40/0.44/0.32, inertial blend, 2-frame hold).
- PREVIEWLOOK1 briefed and launched: Cursor issue #260 (TASK_PREVIEWLOOK1.md) - Ludo's trunks/plinth/4-light rig/FOV 32 camera, the
  fight's own guard, and BOOTS: `FighterKit.wears_boots` only matches the old `_box_` bodies, so every MetaHuman boxer is barefoot in the
  ring too (seen on the S254 dock still).

## Decided (developer calls)
- Collected the dock by diff, not the branch; HANDOFF.md claim line dropped (that file is not the handoff system).
- Undisputed through UnityPy, not REA: IL2CPP metadata + typetrees give names and clip events directly; REA's Windows Ghidra is
  experimental and slower for the same answer.
- Ludo's punch numbers taken as RELATIVE offsets on our own clips, not his absolute contact times (invented for clips we do not have).
- The preview boxer goes to Cursor (Godot UI owner) with geometric checks; the boot gap is a defect fixed now in the same task.

## Lessons
- Out-File (PowerShell 5.1) writes a BOM - `git apply` rejects that patch; use `git diff --output=<file>`.
- run_tests `--only` takes ONE comma-separated value, not space-separated names.
- UnityPy on Undisputed needs `FALLBACK_UNITY_VERSION="2022.3.45f1"` (bundles strip it; header of data.unity3d has it).
- A background job chained after `pc_watchdog -Once` reports the watchdog's AMBER exit 255, not the job's - read the log.

## In flight
- Cursor PREVIEWLOOK1 #260 (branch cursor/issue-260) - collect first next session.

## Next
See roadmap `now.next_action` (S255).

## HANDOFF
- working commit: see roadmap `last_working_commit`
- evidence: s254_shoutdock still, SUITE lines above, branch_prune list, LUDO_R119_raw.txt, timing_table.md
- remaining: board answers Q-S249-4..7; PREVIEWLOOK1 collect + stills; S255 meters + punch timing; Arena 100-bout check
- exact next action: roadmap now.next_action
