# S223 DIGEST (2026-10-14) - collect everything, one time bar, locker room built, the animation chain gets the PC alone

## Operator, verbatim, and what was done
- C66 "is the calendar strip in the game ?" / "are we using the calendar strip or no , what ludo says ?" -> Ludo r61: the 12-day strip
  leaves the top bar for the right-edge calendar drawer; approved Q-S221-3 "Approve, build it" -> STRIP1 MERGED 423607ff. The double
  pause/play/date (HUDDEF2) MERGED (Claude kept the day line + STEP IN that Cursor's version dropped).
- C67 "ask ludo to use a 3d rotating globe to pick a country" -> Ludo r61 A approved -> GLOBE1 r1 REJECTED by Claude (UK picked, globe
  faces the North Pacific, pin in the ocean; capture on white) -> round 2 RUNNING cloud Cursor #185.
- C68 "the wall texture is missing" -> gone on today's floor (brick everywhere); still on the board.
- "add option for me to remove the old pictures from the opsboard ... keep the latest versions on" -> /review: Remove/Restore per post
  and per picture, Removed tab, "Older version" marks + one-click sweep, review_add --supersedes (9ff24a8c, 3f3a8dbd); 13 old posts
  moved to Removed (nothing deleted).
- "did codex finished the changing room ?" -> LOCKER1B launched + MERGED 65b8d1e4; operator: "locker room looks beautiful" (gate closed).
- "free up space on e: remove old branches" -> E: 14 -> 90 GB: 10 worktrees + 6 stray folders retired; every commit pushed first
  (ANIMBALANCE1B's 7 local commits -> codex/animbalance1b-local-s223), diffs/untracked saved in E:/FightCamp/wt_retired_s223 (35 MB).
- "what???" (the stuck browser) -> explained; new save method keeps the extension working (memory reference_ludo_ai).

## Merged this session (all by diff, tests named)
HUDDEF2 (+ticker fix) 18/0 | HUDDEF1 + SEETHRU1 253b5d11 (Claude: near-wall flicker - walls judged by full height; capacity plate
off-tree errors; the COACH lying outside the hall on the station view) 46/47->fixed, 12/0 | FIRSTHOUR1B, DESIGNFIX1 (profile AM hunk
NOT taken), CAMPPAY1, BOOKRULE1 contract test only (no-preset fixture kept) e5b89068 46/0 | KM3B (neck capsule) 14/0, nightly red
fighter_reachability green | LOCKER1B 65b8d1e4 (Claude: room view clears the hall shell fully) 26/0 | STRIP1 423607ff 19/0.
PRs/issues closed: #176 #43 #177-#183 #186.

## Rejected / sent back
- PROFILE2E round 12 (cursor/profile2e 34eb4f48): its own still is still full side profile; the test reads face_ok = blind gate.
  DECISION: no round 13 of tuning; next = Codex after the chain, camera from the FACE (eye midpoint + nose tip), gate on the rendered
  image (nose between the eyes). Roadmap PROFILE2 row.
- GLOBE1 r1 (above).

## Ludo
- r61 (21,437 chars) globe + strip + 7 floor HUD defects -> verdict, approved Q-S221-3. C3-C7 HUD pass waits (brief after the chain).
- r62 (24,622 chars) Maria's kits (10 kits, neutral boots with accents, clash resolver) + Kalli's first corner (camp plan pre-selected,
  gold rail, 45 s auto-send) -> verdict on the board Q-S221-4 (OPEN).

## In flight at handover (collect next session)
- ANIMCHAIN2 Codex gpt-6-astra high, PC, EXCLUSIVE Godot (pid 49568, out E:/FightCamp/wt/ANIMCHAIN2_out.txt): FLYFOOT2 (ruling: SOLE
  PLANE from heel/ball/toe mesh vertices, lead 0-12 deg), PAIRLIVE1, ANIMSOURCE1D, then item 4 = the 3-minute fight clip
  (ANIMSOURCE1 worktree docs/previews/fight3min/round1.mp4 + trace JSON). Do NOT run Godot on the PC while it runs.
- NIGHTLY6 Goose #184 resumed (run 38545388504): done ui_kit_book + re-pins doctor_live/referee_live/pad_chain/judge_panel (NOJAB1
  50aad3bc by design); open: corner_instruction_contract, fight_clip_slice, fight_identity, fight_realtime (hang), fight_strike_whole,
  switch_gate_hands_smooth_in_whole. Collect by diff after the chain (tests need the PC).
- GLOBE1 r2 cloud Cursor #185 (run 38546456979) - needs `godot --headless --import` on collect (new PNGs).
- YARDSTICK1 Arena chat 01a139dd (pure J67 realism scorer) - score the chain's 3-minute trace with it.

## Traps this session earned
- A Ludo reply saved by navigating the extension tab to 127.0.0.1 blocks the extension; inject a link and click it (new tab) instead.
- Cloud Cursor capture tools render panels on white: always ask for the game's own flow (`-- as_game`).
- Applying agent diffs: `git diff --binary` (LFS/GLB), `git merge-file` after normalising CRLF for a both-edited file.
- New PNG assets need `--headless --import` before headless tests can load them.
