# S256 DIGEST (2026-10-18) - two operator defects fixed, counter window + mitt pop live, nightly parked list, 3 agent runs out

## Operator input (quoted)
- Board Q-S249-4 roadmap: "Approve" (acted on in S255; this stage continues its slices).
- Review C110 (markup on the S254 dock still): "bad placement it covers the action on the ring".
- Review C111 (qm_pad_side_by_side.mp4 @10.0 s): "the fingers of MH look very weird fix them".
- No comments yet on "Punch timing: old vs new" -> that visual gate stays OPEN.

## What now works (evidence)
- C110 FIXED 5bcb2102: the corner-shout dock sits on the screen's bottom edge, one compact row (146 -> 98 px, top y 734 -> 974 at
  1080p, call line moved to the card tooltip). shout_dock_test gains the bottom-10% check (red on shipped: top 734); shout_bar/live
  green. Game-camera stills docs/previews/s256_dock_c110/ (guard + exchange, STILL_FRAMING OK) on the review board.
- C111 FIXED 98ea7542: QuickMagic tracked a coach wearing mitts, so its finger channels were guesses (straight/bent back on the MH).
  AFMotion: every qm_ role drops tracked fingers and holds the ActionForge jab fist (0.15 s). qm_fingers_test red on shipped (ratio
  1.04), green 0.54 (= the jab-fist control; rest pose reads 1.00). New side-by-side docs/previews/s256_qm_fingers/ (yaw 180).
- COUNTER WINDOW LIVE 19664ddd (Q-S249-5 "Build it", Ludo r119): FightRealtime._run_impact opens the thrower's CounterWindow on
  his punch's own clock (stage contact/recover, else contact 0.30 s + PunchTiming offset); a blow landing inside the target's window
  cannot be slipped (fl_chance = EVASION_INSIDE), logged `countered`. Switch counter_window (GAME_ON + DEMO_SWITCHES). No new RNG draw.
  counter_window_wire_test red on master -> green: 24/3099 blows countered (0.8%), 0 slipped vs 9.6% outside; sloppy+tired window
  0.271 s vs sharp+fresh 0.202 s; OFF arm 0. game_switches_test engine_keys was stale since S253 (corner_shouts) - fixed.
  OPEN: crit +25% / rocked +20% have no roll in the sim; 0.8% is low because nothing aims into the window (counter-punchers should).
- MITT POP LIVE 6335114d (Q-S249-6 "All three"): PadPair plays a glove sample on the coach's mitt at each of the 7 loop contacts,
  pitch / clean-vs-slap by the fighter's move_mastery (rules/MittPop.gd); switch mitt_pop. mitt_pop_wire_test (real GymClub3D pad
  round) red -> green: 7 pops per clip loop, clean pitch sharp 1.102 vs raw 0.938, OFF 0. Audio not heard by the operator yet.
- MITTPOP1 module collected 8039b4ac (Arena push hit GitHub 500 - files copied from its diff view; logic mutants red).
- NIGHTLYPARK1 collected 82e26f37 (Arena PR #267 + review fixes): run_tests.select_tests honours tests/parked_tests.json -
  fight_contact_stop (MMA kick) and promotions_board leave the full suite (PARKED lines, parked=<n>), exact --only revives one;
  asset_manifest: 7 packs, the 6 shipped folders approved from their own provenance.json -> asset_manifest_test failures=0.

## Not merged (reviewed)
- PREVIEWLOOK1 round 1 (Cursor cursor/issue-260, 6cbc3b47): boots float BESIDE the feet in the live fight (still
  docs/previews/s256_boots/03_boots_feet_crop.png), wears_boots matched mh_boxer paths before the discipline, framing 70% vs 78-86%.
  Round 2 brief in issue #260 body + TASK_PREVIEWLOOK1.md (world-space boot gates, discipline-first fix given, guard -> REPORT).

## In flight (name them at start)
- Cursor #260 PREVIEWLOOK1 round 2 (cursor/issue-260). Cursor #266 WEIGHSCALE1 (cursor/issue-266).
- Arena SHOUTCAL1 (chat 01a1509d-...-9058747531d4, brief TASK_SHOUTCAL1.md): r117 levers -> engine + one LEVER_GAIN to 0.60-0.65;
  Arena #264 (the batch test) stays open until it lands.

## Decisions (Claude, developer)
- Counter window wired on the evasion lever only; crit/rocked wait for a design answer (the sim has no crit roll) - next slice.
- Shout calibration through ONE global LEVER_GAIN, never per-shout numbers (Ludo's relative design stays).
- Parked tests are a data list the runner reads (ruling + why per entry), not deleted tests.

## Next (S257)
Collect the 3 runs as they land; CampMeters -> goal strip (Cursor brief, after #266); CUTVISIBLE1 to Cursor after #266; counter
window slice 2 (Ludo: crit/rocked mapping + counter-punchers aiming into the window); FIGHTGAP1 (boxers overlap on stills - seen
again on s256_dock_c110/02); operator listens to the mitt pop (board).
