# S191 digest (2026-10-10) - Ludo's design built out: 11 merges, fight camera fixed, HUD on, cloud Qwen back

## Operator rulings this session (verbatim)
- Board: Q-S189-1 "Approve all V1-V12" (D40), Q-S189-2 "Approve V13", Q-S189-3 "Approve V14" (D41), Q-S191-1 "Approve V15" (D42).
- "why not add those ?" / "it sounds a good addition" -> D43 (composure latency Shaken 0.30 s / Broken 0.60 s, HUD band tag).
- "turn the hud on" -> Ludo fight HUD ON in the game (demo_switches_on()).
- "fix the fucking camera once and for all i do not want to see any more pictures with feet only" -> camera fix + still guard.
- "when i need to approve something i want to be able to see it on the opsboard" -> ask --attach, board renders docs/stills.
- "are these real ? why you are not assigning all these ?" -> waiting list re-checked (stale seat notes), work assigned.
- "move more work to arena, keep it busy and check qwen for cloud now"; "yes update it" (Ludo project document).

## What now works (evidence = commit)
- FIGHT CAMERA: windowed boxing runs force the game's `broadcast` shot + follow (11 still tools asked for mat shots that cut heads off);
  `framing_report()` + `tools/still_framing.gd save_if_framed` refuse any still without both men head-to-feet. 9be65758; proof
  camera_framing_check 3/3 frames, stills opened.
- LUDO FIGHT HUD (V12) ON in the game: cards with head/stamina bars + live pulse BPM green/amber/red, centre pill, towel tray. b521cbb3,
  6b8618d3; 197 BPM red on a clean head hit seen on the game camera.
- PAD CHAINS (V8) fire in the live fight behind `pad_chains` OFF (Codex). 140f998f; 99/0, switch-OFF hash = original engine.
- DOCTOR LIVE (V15) behind `ludo_doctor` OFF (Codex): one cut model, inspection overlay, towel / wave on, scar on the sheet. 90afc830;
  1,566/0, 8-seed OFF hashes.
- PURE MODULES merged (Arena / Qwen): PromoterTrap (V11), CutsDoctor (V15), Tells + authored Perez/Miller tells (V4), WeighInCut (V9),
  LudoCast (cloud Qwen), FightWeek (Mon-Sat), FirstHour (16 beats). Each with its test + a Claude mutant caught.
- CAMP SCREEN PLAYUI1E merged (icon chips, nothing clips; Claude fixed "0%%" + clipped purse) ac647054.
- OPS BOARD: approvals carry their doc/still (server attach_view.py, ask --attach refuses approvals without); a stale duplicate
  board server killed; page had stopped rendering after a bad plan edit - fixed.
- LUDO: project document updated to V1-V15 (old text backed up, LUDO_PROJECT_DOC_BACKUP_S191.md); round 7 (doctor numbers) and round 8
  (build order + its own GDScript - reference only) saved verbatim.
- CLOUD QWEN back: Token Plan key re-saved to QWEN_API_KEY (operator); CAST1 + ANGLE1 ran in the cloud. QwenCloud pay-as-you-go key
  (QWEN_PAYG_API_KEY, local + secret) works on dashscope-intl for qwen3.8-max / deepseek-v4-pro / kimi-k2.7-code / glm-5.2 (free quotas
  to 2026-12-08, operator turned auto-stop ON for all models) - not yet wired as a seat.

## Findings
- G158B: angle_guard and hand_contact_sync (CHOP3's fix) show no effect; push_on_line helps 25% not 30%. ANGLE1: angle_guard's flat
  result is a POPULATION mismatch (IQ-50 fighter blocked by design; southpaw outside = default) - Qwen's engine "fix" (drops 'ropes win')
  NOT merged; ANGLE1B re-measures. Tests stay off master.
- Claude's own misses, fixed: launched Codex DOC2 in the main checkout (no CODEX_REPO) - killed in 2 min, memory written; a brief's
  push_error broke CUT3A's CI; a sed mutant that matched nothing (re-run properly); "-25 BPM is new" was a misread.

## In flight at handover (collect, do not relaunch)
- Cursor LUDO-GYMUI1 (wt E:/FightCamp/wt/LUDOGYMUI1, branch cursor/ludo-gymui1) - Ludo gym screen behind ludo_gym OFF.
- Arena LUDO-COMPOSURE1 (chat 01a122b3-a558-7e7d-93da-d1ee9bdcf2cb) - on merge set counter latency to D43 (0/0.15/0.30/0.60).
- Arena LUDO-CORNER2P (chat 01a12332-fa45-737c-9a08-ece0481fce61) - CornerBreak.resolve_break.
- Cloud Qwen ANGLE1B (issue #83) - no engine change.

## Next (decision, Ludo's order)
1. Collect the four runs above. 2. LUDO-CORNER2A on Codex sol (brief ready; needs COMPOSURE1 merged; launch with CODEX_REPO).
3. LUDO-CORNER2B (the corner drawer UI over CornerBreak) on Cursor after GYMUI1. 4. LUDO-WEEK2 (fight week live), LUDO-HOUR1 (first hour
+ Vance's trap). 5. FOOTLOCK after CORNER2A; CHOP4 after. 6. Wire the QwenCloud pay-as-you-go seat (free models) for pure modules.
Switches waiting the operator's OK on a still/video: pad_chains, ludo_doctor (stills in docs/previews/doc2).
