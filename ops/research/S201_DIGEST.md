# S201 DIGEST (2026-10-11) - real drawer stills, three real gym floors, session cost cut, Codex on the plan quota

## Operator words this session (verbatim)
- "why at the start of the session everytime the contxet start from~96k , we cannot work a session properly like that"
- "is there any way the projects do not mix and consume so many tokens at the start of each session"
- "are we using this ?" (OpenAI API $11.90 auto-recharge) / "codex was at 90% left unused yesterday and today it reseted to 100% ,
  it could have done so much more work on the animations ... :("
- "i turned autorecharge off move handover to 330k and continue i still havent seen any stills"

## Session cost (start context)
- Measured from the session logs: the first request is ~91.6k tokens before anything runs (S199 91.9k, S200 91.4k). get_usage
  breakdown: system tools 37k, MCP tools 25k, memory files (CLAUDE.md + MEMORY.md) 16k, skills 7k, system prompt 7k. Projects do
  NOT mix: other projects' files never load; only account-wide connectors (names only, deferred) are shared.
- Cut: MEMORY.md 25k -> 5.5k chars (166 older lines -> memory/MEMORY_ARCHIVE.md); `start` 36k -> 20k chars (rows tagged
  "[S200 DONE]" were printed as OPEN - _CLOSED_STATE now allows a stage tag; rows cut at 160; Arena branch names dropped; warn lines
  capped at 200). `.claude/settings.json` had a missing comma (invalid JSON - its hooks/permissions were ignored) - fixed.
- Handover moved to ~330k (CLAUDE.md s2/s3). This session still passed it (474k): opening 1920x1080 stills costs ~1.5-2k each and
  many were opened while debugging. NEXT SESSION: open stills at scale, fewer re-reads.

## Money / quota
- OpenAI API: CODEX_API_KEY repo secret (added 10-10 08:21) billed ~10 cloud-agent `codex` runs on 10-10 (auto-recharge $11.90).
  Operator turned auto-recharge OFF. Rule (memory feedback_use_codex_plan_quota_first): Codex runs LOCALLY on the ChatGPT plan
  (auth_mode chatgpt) first and is kept busy on animation; the `codex` issue label (API) only with his OK.

## What now works / landed
- Q-S199-1 REAL drawer stills: `tools/real_drawer_stills.gd` had never produced past still 1 - the fresh career had an EMPTY roster
  (roster[0] SCRIPT ERROR = the "hang"), the hall camera lives in a SubViewport (shot 3 never ran), HIRE A COACH covered the hall
  (hidden with hall.hide_hire). Five versions + side-by-side on the board as **Q-S200-1**: A closed, B 38% full height (today), C hall
  shifted, D 28% (the readout cards are cut - built for 700 px), E 38% card fit to its content (RECOMMENDED: the drawer holds only 9
  ratings + 6 body regions today, so full height is half empty). DrawerHost.width_ratio added (default 0.382).
- Q-S199-2 GYMLAYOUT1 - three competing floors INTO THE GAME, real game camera, no generated images, board **Q-S200-2**:
  - Loader: `club_layout=<name>` (cmdline) or career `club_layout` loads assets/data/club_layouts/<name>.json over gym_club.json
    (GymClubLayout.layout_variant/reload; ClubZones reads through it). None = today's floor, byte-identical.
  - A Claude (Tools/gym_layouts/author_claude.py): 11 heavy bags all on walls, ring 1 m off the back wall, one strength corner,
    quiet recovery by physio, skipping floor, clear walks - 0 rule breaks.
  - B Ludo round 36 (LUDO_ROUND36_ASK/S201.txt, 14,385 chars verbatim; author_ludo.py T1-T7 engine-forced changes only): 6 bags,
    ring 0.4 m off the wall, ice tub on the floor - 3 breaks. Ludo's own table overlapped defence_drill with the bike.
  - C Cursor (author_cursor.py, merged by diff): 10 bags, 3 too far off the west wall, kit behind a bag - 5 breaks.
  - Checker: Qwen GYMRULES1 `scripts/rules/ClubLayoutRules.gd` (R1 bags on walls, R2 nothing behind a bag, R3 spacing, R4 walk
    clear, R5 right zone, R6 sane counts) 20/0, catches today's junk (15 breaks). S201: optional drawn sizes - a floor item's x/z is
    its CORNER and a heavy bag is DRAWN 3 x 3 m around it (ClubZones.item_zone_size), so bags are judged where the player sees them.
  - Tests: club_layout_variants_test (today = control 15 breaks, claude must be clean) PASS; gym_club_layout_test 70/70 on today
    AND all three (its ring control now derived from the ring's own zone).
- Arena collected: CAMPSLOTS1A (PR #113, 82/0) + FACILITYDIR1A (PR #114, 128/0) merged by diff, PRs closed.

## Runs in flight (yours to collect)
- HUMAN2b - Codex sol LOCAL (ChatGPT plan), wt E:/FightCamp/wt/HUMAN2, branch codex/human2 (checkpoint c39081ee: honest foot-lock
  flags, OFF diff 0.0, STEP 2 still FAIL hop=244). Relaunched with answers: room/bench/C223 wiring allowed, footwork probe like
  HUMAN1's, no cleanup, realism 1300 s. Out: E:/FightCamp/wt/HUMAN2b_out.txt.
- WIRE-LASTSPAR - Cursor, wt E:/FightCamp/wt/WIRELASTSPAR, branch cursor/wire-lastspar, TASK_WIRE_LASTSPAR.md (Thursday 2-round
  test spar -> SparRead summary -> LastSpar drawer; switch last_spar_screen OFF). Out: WIRELASTSPAR_out.txt.
- EQUIPMOTION1A - Arena chat 01a12b33-2c02-72bc-998a-e65008d86fa3, TASK_EQUIPMOTION1A.md (pure machine motion + test).

## Defects seen, not yet fixed (queue)
- Drawer header: the composure chip is clipped at the right edge; drawer title repeats the fighter's name (test-locked contract -
  profile_drawer_test wants the title = the name; left as is).
- The gym sign shows "DEV JUMP 707" in DevJump-seeded stills (seed gym name).
- bench_water draws as a grey block when it has no dressing; kettlebell/medicine-ball sets render as grey boxes.
- E: free space 11-18 GB with ~40 worktrees - prune merged worktrees each session.

## Next (decision)
Collect HUMAN2b, WIRE-LASTSPAR, EQUIPMOTION1A as they land. Read the board answers Q-S200-1 (drawer) and Q-S200-2 (floor) - the
winning floor becomes gym_club.json (BAGRIG1 re-lays bags to it), the drawer variant gets built. Keep local Codex busy on HUMAN3+.
