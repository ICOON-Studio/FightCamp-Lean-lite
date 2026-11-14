# S473 handover (written 2026-11-14 at the end of S472; S471's handover is in git history)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S473`.

## USAGE RULES (kept)
- Run `get_usage` first. Hand over at 420k context; start the wrap-up at ~385k.
- Never idle while a test or agent runs: keep a second item ready that needs no Godot.
- Godot jobs go through `python ops/Tools/godot_slot.py run --who s473 -- <cmd>`. Do NOT wrap the Godot call in `timeout`
  inside the slot (S472: every test came back rc=1 with no output). A hidden-desktop job prints nothing without `--log=<file>`.
- Never `cd` into an agent worktree (S472 did it once by mistake; read-only, nothing changed). Read it with `git -C <wt>`.
- Some tests run WINDOWED only (their header says so: punch_range_test, hit_gap_probe). Headless they have no 3D stage.

## HIS WORDS THIS SESSION
- C398 "if this is corner minute why it has the gyms background" -> fixed (fight night on a solid venue dark).
- C399 "kind of heavy on the eye, lighten it up a bit" -> "Lighter still" -> "Light enough" (3D corner card #62513f at 0.86).
- "Take's 18" -> the rear knee stands 18 deg inside the toes, as the source take does.
- Still NOT answered: his verdicts on the four flowchart fight-plan pictures (asked three times now).

## WHAT S472 DID
- Corner minute look (MainFlow.gd fight scrim opaque; CornerOverlay.gd card panel). Stills on the review board.
- SPLIT471 (Qwen) collected as a diff AND fixed: PunchReach lost `_along` (ReachLimit calls it by name in the game: every
  punch errored), `weight` and `STRAIGHT` (tests read them). Forwarders in PunchReach. Lesson: after a split, grep the
  removed names across scripts/tests/tools INCLUDING call("_name") strings and `static var`s, not only `func`.
  punch_form output identical with and without the split; hit_frame 3 and punch_speed 41 = the pre-split counts.
- Rear knee: tools/stance_raw.py (Blender) measures the take in the rig's terms. The take's rear knee: 17.8 deg inside its
  toes (lead 1.2); its stance: rear toes 45 deg, balls 0.46 along x 0.39 across, pelvis line 68.6 deg off the lead toes.
  Giving the rig the take's stance moved guard_knee the WRONG way: the foot is not the cause. REAR_BAND_DEG 0 -> 18 (his
  pick on tools/knee_band_still.gd stills); boxer_footwork_test's knee bar split: lead <= 8, rear <= 20. footwork 0;
  guard_knee red (-0.031 / -0.017 v +0.029, gap halved) -> the rest is the hips.
- Double hook CLOSED: PunchReach's target is live; the far hit is ReachLimit's 0.30 m cap off the clip's glove (probe arm
  `-- reachwhy`: by cap 0.097, by arm length 0), shown as a graze by design. docs/CLASH2_RESULT.md S472.
- Guard still tool (fight3d_still.gd f01_guard) shoots 6 frames after setup, before the 0.80 -> 0.88 m step-out: the
  "standing inside each other" picture is the tool, not the game.
- Played fight (hit_gap_probe, hidden desktop): 0 script errors, 33 landed, 1 far - identical to S471.

## FIRST
1. Nightly 05:00 (first with FIXED_FPS tags and S472's knee): diff, measure, do not chase.
2. Qwen PELVIS1 launched 18:22 S472 (worktree LEAN_PELVIS1, branch qwen/pelvis1): the rig's hips v the take in
   stance_raw.py's numbers -> docs/PELVIS1_RESULT.md. It is yours: collect by diff (tools/pelvis_probe.gd + the doc only),
   then fix the biggest difference it names. Next for Qwen after it: the punch_speed ruler (41 failures, pre-existing).
3. Seats: PLANFLOW1 v2 (SQ122) -> two fresh critics -> his board; club week v6 critics (SQ123, SQ124); weight r3 (SQ116),
   coach fit v7 (SQ118) -> critics.
3b. IN AT THE END OF S472 (committed, not yet acted on): Maria on club week v6 = depth 7, general 5 (misses general by
   one -> Kalli v7 with her list); Kalli coach fit v7 and weight r3 -> two fresh critics each.
4. Token leak: token_log.csv has a night now; find the minutes with a big delta, then remove the logging block.
5. Play the crack card in the exe. plan_bots_test red (step bars) closes with PLANFLOW1 v2.

## NOTES
- Animation item for S473: the hips (guard_knee's rest), Qwen or Claude.
- start's "COLLECT CARDVISIT1" line is stale (verified S465); the 16 HELD worktrees are old seat runs.
- The P0 Miro map: two surplus empty card slots were NOT deleted (Miro deletion needs his OK).
