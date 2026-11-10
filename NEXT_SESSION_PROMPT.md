# S420 handover (written 2026-11-10, S420 main session)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S421` and redraw the map (recipe: ops/Tools/where_we_are_svg.py docstring; he said yes to deleting its own spare cards, Q-163).
Older handovers: S419's is in git (170fb73c), S396 to S417 in ops/research/HANDOVERS_S349_S417.md.

## FIRST: his answers on the board
- Q-S294-169: Training tab A or B. The board said A (Q-164), in chat he said "the B approach seems good". Build his pick: B = docs/mockups/s419/training_b.html + training_b_painted_ludo.png (ops/research/TRAINING_B_DECISION_S419.md section 3); A = training_a.png. Ludo paints the pick, his yes, then a Cursor brief (type floor 20 px, at most 70 words).
- Q-S294-165 At a glance (A ring / B card), Q-S294-167 Club People (coverage board / staff wall): still open.
- Q-S294-168 marked from his chat words: fight display B with A's parts (ops/research/FIGHT_DISPLAY_DECISION_S419.md).

## Collected S420 (all on main, exported, HE HAS NOT PLAYED IT)
- BLOCKMEET2 (Qwen, PR 154): the PR did not compile (BeatFire used MoveStudio by a name it cannot see) and its glove lift moved the hand bone alone, tearing the wrist 8.5 cm. Now scripts/fight3d/BlockGloveLift.gd turns the whole arm at the shoulder to face height; tests/block_meet_test.gd has a WRIST bar read through BoneAttachment3D (get_bone_global_pose in a test reads the pose BEFORE the modifiers), proven red 15/15 on the old lift. Face bar 0.10 -> 0.08 with the reason. The test drives FightStage.arm_block directly: BeatFire's own path is checked only by compiling and the Moves-preview film.
- LOOKSLATE5 (Cursor, PR 153): Money on slate. Prices were cut on main too ("$12,00", "$280 a"): MoneyTags price never clips now, the week line gives way with "...".
- REARHAND5B (Qwen, PR 140): right hooks keep the hand at chest height (film: tools/rear_hook_film.gd move=pro_right_hook, a new tool that films any clip frame by frame; IdleMatch.freeze needs the ANIMATION name, "rear_hook" plays nothing). Its test is NOT taken: it reads res://.godot/orig_*.res, a retargeted copy only the seat had.
- TAPEVERSUS1 (Cursor, PR 157): one tale of the tape (scripts/rules/TapeRows.gd). His mid-session note "reach is not shown ... sorry i meant weight": the opponent table (Data.gd) has no weight, so TapeRows.opp_weight gives her a weigh-in 0.2-0.8 kg under the limit (her name decides); the offer's row is "WEIGHT, LIMIT 60" with both weights; REACH added to the offer; fight night 28 px off the edges.
- FIGHTSLIDE1 (Qwen, PR 155): 1.5 m of foot slide a boxer-round, a FLOOR (its ruler counts a foot moving > 0.25 m/s as not planted); causes were guesses.
- wood_kit_test: its tag check was stale since S419's see-through tags; fixed.

## Running / queued (dispatcher launches them; my render held them back)
- AGY LEGTREMBLE2 (the animation item, BASE agy/legtremble1): round 1 never compiled (FightClips.setup_clips does not exist: load_into) and smoothed clips IN MEMORY in the test. Round 2 bakes into the shipped .res and measures the files. Collect: run the test, show it red on main's clips, then re-render the board films (clip_orbit) and LOOK.
- QWEN FIGHTSLIDE2 (each cause switched off, a ruler that sees fast slides), then KDFIX1 (downed boxer sways).
- CURSOR LOOKSLATE7 (roster strip, review cards), then LOOKSLATE6 (World).
- Uncollected: PR 105 MENUPLAYBOOK1 (CI red), R11C (goose/issue-149).

## Seen, not fixed
- Luke Reid's portrait near black on Club People; a bare "roster places" icon in the staff strip; the bout offer's left corner note over the boot.
- The hologram groups six hit places into three ("do we only have 2 hit points"): a design question, not asked yet.
- The animation page shows 1 of 169 clips by its own rule; he read it as "only 1 animation".
- The count after a knockdown still waits on the replay with no time limit; no case for the opponent's knockdown.
- Held worktrees LEAN_FIGHTERMODEL4G / GYM3D2 / MONEYOD2: superseded, look then retire.

## Traps (new this session)
- PowerShell Get-Content -Raw | Set-Content re-encodes a UTF-8 file: "·" became "Â·" in VersusPanel.gd (repaired). Edit files with Python or the Edit tool only.
- `cd` into a worktree in the Bash tool moves the session folder: absolute paths.
- A seat's test can pass because it never runs the game's path (BLOCKMEET2 called arm_block, not BeatFire; LEGTREMBLE1 smoothed in memory): check what the test calls before trusting its green.
- The hidden desktop swallows stdout: tools write a .txt next to their frames (rear_hook_film.gd does).
- `seat_dispatch.py --help` RUNS the dispatcher (a dry list of WAIT lines here).

SETTINGS: this session ran on Opus 5.5 | weekly all-models use at 86% on 11-10 (resets 11-12) | Cursor Grok 4.7 High.
