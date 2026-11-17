# S508 digest - fight motion week day 13 (2026-11-17)

## Owner
- Comments C426/C427 ("ok" on the coach-neck before/after), C428 (critic's 10/10 coach picture "ok"), C429 (scorecard
  tab "ok"). Q-S294-267 on the board: may films render while he plays (no answer yet). He was not playing when the films
  ran (no game window); the S506 memory records the no-films-while-playing line was my caution, not his rule.
- He asked whether Zapier MCP can help the project: answered - phone pings (board question / build ready / film ready)
  is the one real use today; Discord / socials / sign-ups at Early Access later; it cannot run builds, agents or tests.

## Merged
- Ziva PR 341 COACHNECK2 (diff applied, 80c215476): the coach's neck stands on his chest line in the corner close-up.
  Probe c07: neck to chest 19.0 deg (bar 20), to vertical 13.6. intro_style, ko_continues, file_limits, corner_bar pass.
- Qwen HOOKPAST2 (PR 349, diff applied): HookPast.held reads every held punch (HOOK_HELD line).
- Closed as already on main: PR 342 (PUNCHEND3, superseded by PUNCHEND4), 347 (HOOKPAST1), 348 (HEADSPLIT1).

## HOOKREL1 - the reach lets go over real time (f941278f9)
- s507b hook @3213 came home 0.31 m in a frame at 1.5x: PunchReach let go over OUT_S of CLIP time (~3 frames).
- ReachLimit.out_weight: the let-go is never faster than the same curve on real seconds since the hit (slower wins).
- r1 alone: hit_carry 30 -> 32 (uppercut_hard 0.111 m in a frame: held longer, the aim stayed on her while the 1.5x clip
  glove swung 0.34 m away and _solve_capped dragged the glove back OUT). ReachLimit.in_room: the let-go weight stays
  <= CORR_M / gap(aim, clip glove). Tried and dropped: capping the let-go point at last frame's SHOWN glove (no change -
  the wobble comes from a layer after PunchReach).
- A/B (control `-- norealout`): hit_carry 30 -> 31 (uppercut_hard after the run: 3 turns, a 2 cm wobble at the speed
  change), block_catch 10, the other 13 punch tests unchanged.
- Film s508a vs s507b (same bout all 180 s): HookPast flings 7 -> 4, fling p90 6.3 -> 6.0; landed punches over 6 m/s
  after contact 10 -> 7 (scratch counter, punch clips only); head jumps 92 -> 91.
- The stepping hook (who 1 @3218) stayed 9.7 m/s: it is the clip's own 1.5x recovery (BeatClips.RECOVER_MAX, the measured
  ~0.17 s hook retraction) inside the 0.30 m correction cap, not the let-go.

## HEADJUMP1 step - PopCap caps a held trunk while the landed glove lets go (bc6023516)
- r1 (`holdcap` on every held frame, settle() after): film s508b head jumps 91 -> 63 (per punch clip 0.173 -> 0.103) BUT
  hit_carry 31 -> 57: jabs met her 16-22 cm short on the hit frame (the capped trunk held the shoulder back, the reach
  could not make it up - why S497 exempted the hold). The stepping hook 9.7 -> 13.2 m/s (arm 10 cm longer at the hit).
- Kept: the cap only once the punch has landed and its weight is under full (PopCap._letting_go), then
  PunchReach.settle(). Tests unchanged (hit_carry 31, block_catch 10, uppercut_tail 2, join_return 3, hit_frame 4,
  punch_speed 40). Film s508c vs s508a (same bout): head jumps 91 -> 86, hook 9.7 -> 9.0 m/s, fling p90 6.0 -> 5.8.
  ON by default; `-- noholdcap` = the control arm.
- The 40 % cut of r1 lives on the way IN (the reach's own lean moves the trunk): the next lever must keep the reach -
  e.g. cap the trunk on the way in and let the lean/step cover the distance, measured with HEADSPLIT2's phase split.

## Seats
- Qwen HEADSPLIT2 (S508 brief): each head jump tagged pre / contact / post / late in the punch. HOOKPAST2 (S507 session)
  collected.

## Debt (unchanged except hit_carry 30 -> 31)
uppercut_tail 2, block_absorb 11, hit_carry 31, join_return 3 (hook rep 3: a hit-time event f04 -> 10.1 m/s f06; cross
rep 4: 12.6 m/s after its cut to guard), punch_speed 40, block_catch 10, hit_frame 4, punch_range 1, block_meet 3,
guard_knee, human_feet, rokoko_clips (off-route).

## Films
E:/FightCamp/tmp/fightweek/s508a (HOOKREL1), s508b (holdcap r1, not kept), s508c (shipped state). 180 s, seed 7,
trunktap, csv only (no movie).
