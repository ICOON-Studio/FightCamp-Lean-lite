# S145 DIGEST - 2026-10-02 (evening): icons in the exe, the first hour, a fight for every fighter

## 1. What now works (each with its evidence)
- **P10 icons blank in the .exe - FIXED at the cause** (48a7bd03, 3e6f48dc). IconKit/flags read the raw .svg TEXT through
  FileAccess; an export packs only the imported texture (the S144 pck held `activity.svg.import`, never `activity.svg`).
  348 icon svgs (78 Lucide + 270 flags) import as `keep`. `build_playable.py` now parses the pck FILE TABLE and FAILS the
  build if any is missing (first version scanned bytes and false-failed 25 paths whose length is a multiple of 4 - no NUL
  pad; caught by the build itself). Evidence: rebuilt exe, 0 of 348 missing, BUILD OK; still
  `docs/previews/s145/exe_home_empty_gym_icons.png` (as_game exe walk) - date, Continue, rail, hotspots, bell all render.
- Same audit, same class of bug: VenueCrowd's VAT `.exr` (Image.load_from_file) and 5 PNGs read raw (MetaHumanRig micro
  normal, Office3D trophies) were never beside the exe. build_playable copies `.exr` + `RAW_IMAGES`; VenueCrowd falls back
  to the exe dir like RawAsset.
- **First hour (U213 items 1-4)**: HOME with 0 fighters -> FIRST JOB "Sign your first boxer" -> Scouting FIGHTERS; fighters
  but no coach -> "Hire a coach" -> Scouting STAFF. STAFF room: HIRE A COACH button; "N OF M FIGHTERS HAVE A COACH" counts
  the ROSTER (was coach places, "0 OF 0"). Creation step 3 in an empty gym: "No fighters yet - you sign your first boxer in
  Scouting". Office pin "without a coach". Offers desk: the G156 world read is a player line ("THE WORLD THIS WEEK · N EVENTS
  SCHEDULED IN M COUNTRIES"), the full read in its tooltip (P29); "THE GAME IS GUESSING" -> "ON STANDARD RULES" (P35).
  Evidence: tests/first_job_card_test.gd 8/8 (3 careers, populations printed), mutant (card off) -> 4 FAIL; 9-test affected
  set 9/0; exe stills (home + creation, as_game) opened.
- **C243 CRITICAL - a bookable first fight for every fighter (PLAYTEST P32)**. Root causes MEASURED (the brief's code-read
  causes were only part of it):
  1. A SIGNED fighter has no `country` (only `origin_country`); the amateur code fell back to `get_gym().get("country")`,
     which does not exist (the career keeps it in `world.country`) -> every signed amateur had NO amateur body at all.
     Starters worked only because finalize stamps their country. Fix: `_athlete_home_country/_city`.
  2. The world's novices are spread over 175 countries x classes x sexes x disciplines, so a debutant's bucket is empty
     for MEN too (0 bouts in 3 weeks for a 0-0 man and a 0-0 woman). Fix: CLUB-SHOW NOVICES - when the bucket is empty,
     3 deterministic 0-0 novices (own seed, sex/class/discipline/country matched, ids `novice_<bucket>_<n>` - no "|"
     because amateur offer ids are "|"-joined) join the world. Game ON (`career.club_show_novices`, default
     `empty_gym_start()`); headless --script = control arm. No new career key written at finalize (hash safety).
  3. Amateur bouts inherited the PRO tier's fame gate from the opponent's rating ("220 FAME REQUIRED" for a debutant's club
     bout). Amateur offers set `fame_required = 0`.
  4. Generated pro offers are sex-aware: women's classes get women's offers from their own seed (`fight_offer_w|...`,
     id `<tier>_<class>_w_<week>`, `opponent_sex: female`); every man's offer is byte-identical. book_fight refuses a
     generated offer across divisions (same-sex rule, never silent).
  5. Honest counts: `get_bookable_offer_count()` (sum of the desk's per-fighter read) feeds the Office pin, the Fights
     badge and the NEXT FIGHT card - an empty gym said "3 offers waiting".
  Evidence: tests/first_fight_for_every_fighter_test.gd (blind to the implementation, written first and run on the old
  code): FEMALE Anong Castillo (F, Flyweight, 0-0-0) books week 0 vs a female novice; MALE Gabriel Williams (M,
  Bantamweight, 0-0-0) books week 0; CONTROL (novices off, same woman) reads 0 bookable for 3 weeks = the S144 defect;
  Office count == bookable count every week in every arm. Each cause showed its own failure on the way (no body ->
  "OFFER NOT AVAILABLE" (pipe id) -> "220 FAME REQUIRED"). FAILS=0.
  Affected set (69 tests, --jobs 2): 66 pass; home_pin_counts pinned the OLD contract (Office = every generated offer) -
  updated to bookable-now, derived from the desks in the test itself (0 failures); the other 2 fails
  (fight_back_bands_contract, fighter_reachability_contract) are red in the 10-02 nightly on master too.

## 2. Agents
- **Grok OUT** (18:28): Grok Build API 402 "usage balance exhausted" - C243 run died after 37 turns with no edits; G158 run 3
  had already ended on its own compaction mid-mutant batch. Claude checkpointed G158's 11 new switch tests + edits
  (77c3461d on grok/g158-switch-gates). Cursor + Qwen were already out of credits -> only Codex is in rotation.
- Codex: MH2 (astra) + Q213B (luna) still RUNNING at handover (last commits a9a734fb / ceb04637). Weekly 65% (read 18:08).
- U211 (FOOTLOCK, Claude owns the owed gates): affected suite 13 -> 2 fails, BOTH also red in the 10-02 nightly on master
  (fight_stage_technique_fidelity rc=1, fight_stage_realism hang) = not U211's. C223 production gate (2 procs) was still
  running at handover from E:/FightCamp/wt/U211 (report previews/c223/u211_c223.json there).

## 3. Next (decision, not a menu)
C243 + U213 items 1-4 are on master -> the next session: (1) collect MH2 / Q213B as they land (open output, merge as diff);
(2) read U211's C223 report; if all rows pass as on master, record the 20 s as_game room video and merge U211 (slide -30%);
(3) U213 item 5 (week review: real stat deltas, payroll accrued/due, layout) - Claude writes it unless a seat frees;
(4) rebuild + PLAYTEST PASS 2 (PLAYTEST_PROTOCOL.md, s144_live_walk.gd -- as_game) on the exe; then the operator's own
cold session. C241 run 4 (glove) on the first free Codex seat.

## 4. Gates run this session
- first_job_card_test 8/0 (+ mutant 4 FAIL); first_fight_for_every_fighter_test FAILS=0 (control arm reads the defect).
- run_tests --only creation_api,creation_root,day_feed_screen,first_job_card,home_pin_counts,icon_kit,staff_hub_panel,
  staff_room,venue_crowd --jobs 2: 9/0.
- run_tests --only booking,offer,amateur,fight_gate,career,contract,home_pin,shell_chrome,day_feed,first_job,first_fight,
  schedule_hub,club --jobs 2: SUITE total=69 fails=3 -> home_pin_counts fixed (contract change, 0 failures on rerun); 2 = master's
  own nightly fails.
