# KNOWBUILD1 result - the signing card in the game: a prospect as a moment, read on ranges (S545)

Branch `build/knowbuild1`. Brief `ops/research/TASK_KNOWBUILD1.md`; spec `ops/research/DESIGN_KNOW_STAKES1_V9.md` with the
owner's interview answers K1-K4 (`PUSH_KNOW_INTERVIEW_S543.md`) on top. Worker: Claude (Opus 5.5), Code Mode tab.

## Verdict
Built and walked: a scouted name arrives with its region bout and the rival club's 7-day window; the signing card shows
the read as three RANGES against the level, the 21-day strip, and the calls as cards (Sign now, Start the trial, Wait for
the bout; Pass at the foot); the trial runs by the day with tomorrow's question picked each evening (K4); Sign lands on
the new boxer's profile whose top card says what changed (no pop-up); the window running out writes the rival's line in
Mail and a got-away row; Pass writes no news. A signing holds a place to the season's end (K1, no bond).
`tests/knowbuild1_walk_test.gd` walks the three endings, Pass, and save mid-trial; the golden path walks a trial to day 3.

## METHOD lines (quoted from the brief)
- A DECISION SCREEN IS A SCENE, AND A CLICK SHOWS WHAT CHANGED (owner S544/S545).
- NOTHING CUT BY THE SCREEN (owner S544).
- LITTLE TEXT (owner S545).

## Step 0 - the walk, red first
`tests/knowbuild1_walk_test.gd` committed red (2ebefb159: the rules did not exist). Added to `tools/run_tests.sh`.

## Step 1 - the rules (pure + state)
- `scripts/rules/ProspectClock.gd` (new, pure): `truths` / `merit` (the greybox's merit), `ranges` (body, skills, under
  fire from `Knowledge.range_of`; the ceiling's own half-width, 14 before the pad test), `estimate`, `rival_likes` (the
  rival's own fresh look on seed + 7777), `window` (map 3C: last day 7 when the rival's look is above the level, 14 when
  not, plus 0-6; 7 days long), `rival_day`, `bout_day` (a Saturday 4-18 days out: region shows are Saturdays - decided,
  the map says only "4 to 18 days"), `odds_tomorrow` ("1 in 5"), `odds_before` (window days before the bout),
  `season_end`, `why` (map 0.8: "now clear of the level" / "now under the level" / "still across the level").
- `scripts/rules/KnowReads.gd`: `PRICE_TRIAL_DAY` 36 (map C1, measured B2); `QUESTIONS` body / skills / pads / spar
  (K4); `apply_trial_day(k, q)`: body 16, skills 12, the pad test halves the ceiling's half-width, the hard spar opens
  under fire (`Knowledge.hard_spar`) and marks the pressure trait seen; a question asked again narrows half as much as
  the time before (the map's day-1 / day-6 body pair, 16 then 8); `least_asked`. `PRICE_TEST_DAY`, `PRICE_TRIAL_WEEKS`
  and `_apply_test_day` are gone: `test_day` is the body question; `trial` (the old 4-week $500 read) is now the map's
  seven-day ladder by the day ($252), kept only for the KNOWBOTS probes in `tools/`.
- `scripts/rules/ProspectGen.gd` (new, pure): after the five named prospects the scout brings generated names (a seeded
  copy of a named prospect's frame - division, weight, style - with its own name, record, stats, personality), drawn
  until the first look sits within 2 of the level (map 3D). Fictional names.
- `scripts/state/ProspectWire.gd` (new, state): `start` / `restart` / `day` (Sim.step_day): one name every 28-42 days,
  at most two open; on arrival `bout_day`, `window_from`, `window_to`, `rival_day`, `likes`, `club` (a region club in
  the division), `know` (Knowledge record + `ceil_hw`). Open names train in the open session (body and skills 8 a week);
  the bout opens under fire rough (half-width 11.5) and moves the record. `start_trial` / `ask` (Another day) /
  `send_home` / `pass_on` / `sign`; the trial day pays $36 through `Career.pay`, refunded in full if the rival signs
  during it; at most 7 days; an evening left unanswered (a probe) asks the least-asked question, and day 7 unanswered
  sends the prospect home. The rival's day: state `gone`, one news line in Mail ("<club> sign the prospect <name>,
  <date>."), a got-away row `{d, club, look, passed, div, est}` (KNOWBUILD2's return bout reads it), and a region row in
  `c.rivals` (`got_away`: the day). Pass: state `passed`, the same row marked passed, the region row, NO news line.
  `needs` / `stops` / `stop_today` for the Needs strip and Continue. `Career.scout` holds the arrival clock.
- `scripts/state/Roster.gd`: `invite` accepts a name not yet scouted (old saves and the probes); `sign_prospect` hands a
  trial-by-the-day to `ProspectWire.sign`. An old save's Monday trial ("invited") starts the new trial on its day and runs
  day 1 at once.

### K1 - the place, not dollars; the season length
No bond. A signing holds one of the gym's places to **the season's end: the season's national final** (SeasonPath:
entries close on day 70 of each 364-day year; the last national round is 50 days later), **at least 91 days ahead** - the
three months a newly registered boxer must be registered to enter the championships at all (`SeasonPath.MIN_CLUB_DAYS`).
So a signing is held 91 to 455 days, about nine months on average. Why: "a season" in this game is the championship year
(SeasonPath, Champs, LadderSeason); ending the hold at its last event keeps the hold readable ("Held to Tue 5 May"), and
the 91-day floor stops a signing in the last weeks of a season from being held for almost nothing.
**The let-go button** lives on the boxer's Overview (`DarkOverview.gd:432`, built by `ApproachCard.let_go_button`). While
held it reads **"Held to Tue 5 May"** (the date), greyed, hover: "Signed for the season: the place is the gym's commitment
until the season's end."; `Leaving.let_go_price` returns why_not "signed to the season's end, <date>", so the act refuses
it too. The stipend the boxer draws is unchanged. Leaving on their own (loyalty) or to an approach still works: only the
player's letting go is held.

## Step 2 - the screens (wired and shown)
| Menu | Shows | File |
|---|---|---|
| Signing card (a scene) | the prospect painted in the gym (caption "the scout saw them at the region show"); BODY / SKILLS / CEILING as range text + a band on a 0-100 track with the level's tick (bands tween in); the 21-day strip (safe days green, the window red, the bout gold, today outlined); SIGN NOW (place n of m, held to <date>, $250 a week, "1 in 3 end under the level"), START THE TRIAL ($36 a day, tomorrow: body, holds a place, "<club>: n in 7 may decide tomorrow"), WAIT FOR THE BOUT (free, boxes <date>, under fire: rough, "<club>: n in 7 may sign before it"; only with a bout inside the window); Pass and Back plain | `scripts/ui/modals/Prospect.gd`, `scripts/ui/ProspectScene.gd` (beside ProScene), `scenes/modals/Prospect.tscn`, `MainFlow` |
| Trial evening | TRIAL DAY n; today's question before -> after as two bands with the why line; the hard spar adds "Under pressure: <trait>"; the three reads now; tomorrow's question as four picture buttons (BODY / SKILLS / PAD TEST / HARD SPAR, "again" when asked before; hover says what it narrows and the spar's risk); "<club> may decide tomorrow: 1 in 5"; Paid so far; Send home, Sign | `scripts/ui/modals/Trial.gd` (rewritten: the S354 three week cards are gone) |
| After Sign | the new boxer's profile; top card SIGNED, "Signed after 2 trial days. Plan the first week.", PLACES 1 of 3 -> 2 of 3, HELD TO <date> NEW, STIPEND $250 a week NEW, THE READ body a-b, skills c-d NEW; one pulsing Plan the week; no pop-up | `WhatsNew.news_sign` / `card`, `RosterActs._signed` |
| Continue + Needs | a trial evening blocks time: "Trial day 3: decide tonight" (TRIAL DAY n flag); Continue stops once on the bout day ("The prospect boxes tonight"), the window's first day ("<club> decide from today") and last day ("<club> decide today at the latest"). Not during the first hour (FirstHour.quiet: until the gym's first bout), which keeps its own pace | `ProspectWire.needs/stops/stop_today`, `Needs.gd`, `Clock.gd` |
| Find a fighter / reception | open names as face cards with the same three bands and "<club> decide by <date>", See the card opens the signing card; the roster strip's button too (StripOpen_<id>); a GOT AWAY card: name, club (or "passed"), date, the last look; the walk-in at reception shows the same three-range read (no strip: no dates) | `areas/Fighters.gd`, `RosterCards.gd`, `modals/Interview.gd` |
| Mail + got-away | the rival's line in the Inbox (unread); the got-away list on Find a fighter | `OfficeMail.gd` unchanged (reads the news) |
Words: "the gym", "the prospect", clubs in full; no he/she (no_pronoun_test green); colours from Palette (palette_guard_test green).

## Step 3 - the jumps and the stills
`TestJump`: `prospect`, `prospecttrial`, `prospectsigned`, `prospectgone`; four board buttons in
`ops/AgentComms/launch_targets.json` ("Prospect: the card / trial evening / signed / got away") and their play tasks in
`ops/Tools/register_play_tasks.ps1` - the coordinator re-runs that script on the PC after the merge (this worker
did not register scheduled tasks). `test_jump_test` checks each; for Sign the same check as the pro block: lands on the
profile with nothing open, and Plan the week leaves nothing open.

Stills (`tools/jump_snapshot.gd` on the never-shown desktop, `--log`, through `godot_slot`): `JUMP_SNAPSHOT bounds=0`,
all four reached. Opened each myself:
- `docs/playtest/s545_prospect/jump_prospect_real.png` - the signing card. SCENE: Kira painted in the gym on the left, the
  three call cards each with a painting, a name, four facts and its own button; no key / value rows. LITTLE TEXT: one
  number or two words per fact ("$36 a day", "Held to Tue 5 May", "1 in 3"), the how in the hover. Nothing cut.
- `jump_prospecttrial_real.png` - trial day 2's evening: skills 47-72 -> 52-65 as two bands, "still across the level";
  four picture questions; "Fisher ABC may decide tomorrow: 0 in 7"; Send home, Sign. Nothing cut.
- `jump_prospectsigned_real.png` - after Sign: the profile, its top card SIGNED, PLACES 1 of 3 -> 2 of 3, HELD TO / STIPEND /
  THE READ marked NEW, Plan the week pulsing; no pop-up; the Overview's let-go button reads "Held to Tue 5 May", greyed.
- `jump_prospectgone_real.png` - the office computer's Mail: "Fisher ABC sign the prospect Kira Mensah, Wed 21 Jan." unread
  at the top of the Inbox.
Fixed after the first look: WAIT FOR THE BOUT was cut at its card's edge (the title one size down); the question
pictures showed only the gym (the hub sheets are 16 frames of 96 px: one frame shown); the bout fell on a Tuesday (now a
Saturday, the region show's night); the trial jump's top bar showed the arrival day (redrawn).

## Tests
Run one at a time on the PC through `godot_slot` (headless, Dummy audio, --fixed-fps 60), after the last code change:
```
RESULT: tests/knowbuild1_walk_test.gd -> KNOWBUILD1_WALK failures=0
RESULT: tests/golden_path_test.gd -> GOLDEN_PATH failures=0
RESULT: tests/save_load_test.gd -> SAVE_LOAD checks=88 failures=0
RESULT: tests/file_limits_test.gd -> FILE_LIMITS failures=0
RESULT: tests/no_pronoun_test.gd -> NO_PRONOUN failures=0
RESULT: tests/palette_guard_test.gd -> PALETTE_GUARD files=374 exempt=31 raw=29 over=0 new=0 shrunk=0
RESULT: tests/words_on_screens_test.gd -> WORDS_ON_SCREENS failures=0
RESULT: tests/plain_words_test.gd -> PLAIN_WORDS failures=0
RESULT: tests/test_jump_test.gd -> TESTJUMP failures=0
RESULT: tests/office_screen_test.gd -> OFFICE_SCREEN failures=0
RESULT: tests/know_misread_test.gd -> KNOW_MISREAD failures=0 (11 checks)
RESULT: tests/know_reads_test.gd -> KNOW_READS failures=0 (21 checks)
RESULT: tests/know_wire_test.gd -> KNOW_WIRE failures=0
RESULT: tests/knowledge_keep_test.gd -> KNOWLEDGE_KEEP failures=0 (13 checks)
RESULT: tests/knowledge_shared_test.gd -> KNOWLEDGE_SHARED failures=0 (4 checks)
RESULT: tests/knowledge_test.gd -> KNOWLEDGE failures=0 (17 checks)
RESULT: tests/playtest_s375_test.gd -> PLAYTEST_S375 failures=0
RESULT: tests/roster_cards_test.gd -> ROSTER_CARDS failures=0
RESULT: tests/refuse_walkin_test.gd -> REFUSE_WALKIN failures=0
RESULT: tests/gym_spend_test.gd -> GYM_SPEND failures=0
RESULT: tests/first_hour_test.gd -> FIRST_HOUR failures=0
RESULT: tests/first_hour_walk_test.gd -> FIRST_HOUR_WALK failures=0 minutes=30.2
RESULT: tests/start_slate_test.gd -> START_SLATE failures=0
RESULT: tests/club_week_walk_test.gd -> CLUB_WEEK_WALK failures=0
RESULT: tests/male_boxer_test.gd -> MALE_BOXER failures=0
RESULT: tests/move_tip_test.gd -> MOVE_TIP PASS
RESULT: tests/roster_slate_test.gd -> ROSTER_SLATE failures=0
RESULT: tests/weigh_forecast_test.gd -> WEIGH_FORECAST failures=0
RESULT: tests/leaving_test.gd -> LEAVING PASS fails=0
RESULT: tests/approach_ui_test.gd -> APPROACH_UI PASS fails=0
RESULT: tests/card_ask_test.gd -> CARD_ASK failures=0
RESULT: tests/p4p_visit_test.gd -> P4P_VISIT failures=0
RESULT: tests/women_classes_test.gd -> WOMEN_CLASSES failures=0
RESULT: tests/roster_rows_page_test.gd -> ROSTER_ROWS_PAGE failures=0
RESULT: tests/promises_test.gd -> PROMISES PASS fails=0
RESULT: tests/office_desk_test.gd -> OFFICE_DESK failures=0
RESULT: tests/grey_reason_test.gd -> PASS grey_reason_test
RESULT: tests/two_boxers_two_years_test.gd -> TWO_BOXERS_TWO_YEARS PASS
RESULT: tests/test_club_test.gd -> test_club_test PASS
```
The full suite was not run (it runs at 05:00).

### Tests rewritten to the owner's new rules (none deleted)
| Test | The rule it tested | Now |
|---|---|---|
| `know_reads_test` _test_prices | trial $500 (4 weeks, half stipend); test day $60 | trial $36 a day; test day = a trial day ($36); every question $36 (map C1, C2) |
| `know_reads_test` _test_test_day | the test day narrows twice under 5 bouts | _test_trial_days: each question narrows its own group, a second ask less, pad test 14 -> 7 -> 5.25, the spar opens under fire (K4) |
| `golden_path_test` week 4 scouting | Invite to a free Monday trial, three week cards, sign | the scout brings Kira; her card -> Start the trial -> two questions -> signed on trial day 3; the profile says what changed (the test keeps the rival's window off the three days) |
| `golden_path_test` week 1 | Continue runs 7 days straight to the review | Continue may stop once on a scouted name's day, then on to the review |
| `golden_path_test` Mail count | unread <= 40 | unread <= 40 + one line per name a rival signed (a club signing is the gym's own mail, not a rival result) |
| `golden_path_test` Kira's record | 2 bouts after her first | one more than when she was signed (her own region bout counts) |
| `save_load_test` | five featherweights in the region table | five + the names that got away (they box on in the region, K1's story) |
| `playtest_s375_test` part 3 | the S443 scouted +/-5 range; the invite keeps it | the card's Knowledge range; a trial started keeps it and says so |
| `roster_cards_test` | StripInvite_kira | StripOpen_kira (the strip opens the signing card) |
| `two_boxers_two_years_test` | invite -> Monday trial -> sign | start the trial by the day -> sign on the first evening |
`know_misread_test` needed no change: `test_day` and `trial` still narrow without flipping the misread.

## Feedback loops (the brief's table) and the two-year walk
`tests/knowbuild1_walk_test.gd`, a quick-start career on seed 1, the policy "sign every name on the first look while a
place is free, else let the window run" for 728 days:
```
  b: day 0 body 54-70, skills 47-71, ceiling 77-100 | day 3 body 57-64, skills 52-64, ceiling 81-95
WALK2Y names seen 22, signed 5 (2.5 a year), flops 2, gone to rivals 17; the gym's places 3 (boxers and the mat)
WALK2Y places blocked by flops: 244 place-days (0.7 place-years) for a gym that always signs on the first look
WALK2Y region level 61.67 -> 62.15 (drift +0.48)
```
| The loop | Cap | Measured |
|---|---|---|
| Better signings -> wins -> cash -> more trial days | 3 places, two names open, 7 trial days a name ($252) | caps in code (`free_places`, `OPEN_MAX`, `TRIAL_MAX_DAYS`) |
| A wrong signing holds a place for the season -> no room for the next name -> the rival signs them | the season ends and the place frees; at most one got-away a window | the always-sign gym's flops held places for the place-days printed above |
| Got-away names -> stronger region rows -> a higher level | the level is a mean of many rows | drift printed above, under the 2-point stop line |
| Trial days / waiting -> the rival's window | fixed on arrival | `rival_day` is drawn once in `arrive`; nothing writes it again |
ONE-REP TRIAL (the brief's "one prospect walked by hand through prospect -> trial -> sign in the windowed game"): the
`prospectsigned` jump on the hidden desktop printed, for Kira Mensah (level 62.1; boxes Sat 17 Jan; Fisher ABC decide Fri
16 - Thu 22 Jan, signs Wed 21 Jan): arrived body 54-71, skills 47-72, ceiling 77-100; trial day 1 (body) body 57-65; trial
day 2 (skills) skills 52-65; signed, $72 paid.

## What the map says that the code could not do (written down, not invented)
- **The hard spar's injury x2 that night**: a prospect is not on the roster, and `Injuries` rolls only roster boxers'
  training hours; there is no base injury chance for a visitor to double. The spar's tiredness (+15) is kept on the
  trial and added to the boxer's week fatigue on signing; the hover names both risks. A prospect injury roll needs a base
  rate from real sparring-injury data (John) - not invented here.
- **K3, three to five signings a year**: the two-year walk at always-sign-on-the-first-look signs 2.5 a year (5 in two years), because the
  gym's 3 places are full most of the time (K1 holds each signing to the season's end) - names keep coming (22 in two years) and go to the
  rivals. With more places (a second club coach, bigger premises: `GymSpend.places`) the count rises; the walk is the
  measurement, not a tuning.
- **The first walk-in "uses the same card"**: the reception card keeps its frame (start_slate_test, the first hour and the
  golden path drive it) and its Sign / Pass with the starting focus (the gym's only boxer cannot be "waited for"); it now
  shows the same three-range read, seeded as `KnowWire.start` seeds the signed boxer, so the profile starts on that read.
- **Not in this build** (as the brief says): numbers for signed boxers (map 3E - the profile's attribute board still shows
  single numbers beside the ranges on the what-changed card), the return bout (KNOWBUILD2: the got-away row stores who,
  where, the date and the look), the "Last time" strip, the region show's Watch row beyond the Continue stop.

## Art a second pass should ask Ludo for
The trial's four question pictures use frame 4 of the hub sprite sheets (a back view of one male boxer, 96 x 128) over
the gym backdrop: a painted front view per question (the fitness test, pad rounds, the pad test, a hard spar) in the
roster's painted style; a region-show backdrop for WAIT FOR THE BOUT (it borrows `title_ring.jpg`); a crest per rival
club for the window strip.
