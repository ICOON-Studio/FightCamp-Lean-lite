# S166 digest - POPUPS1 fixed, TIMELINE1 built (NAV1 slice 1), HOME wire card fixed (Claude, 2026-10-05)

Operator rulings this session (verbatim answers to the start questions):
- NAV1: **"go"** - Option B, the gym is the menu + the timeline bar (NAV1_THE_GYM_IS_THE_MENU.md). Settled; do not re-ask.
- The S165 popups: **"Black console window"**.

## What now works
- **POPUPS1 - no Godot console window can reach a monitor.** Cause: on Windows 11 a `*_console.exe` is handed to Windows
  Terminal, which opens on the INPUT desktop whatever desktop or flags the caller gave it; `godot_desktop.ps1` started its
  job with CREATE_NEW_CONSOLE, and `run_tests.py`, `check_scripts.py`, `c223_parallel.py` still defaulted to
  `_console.exe` (the S162b memory rule was never applied to the tools). Fix (4575d8ca): every launcher maps a
  `_console.exe` (also a `GODOT_EXE`/`FIGHTCAMP_GODOT_EXE` override) to its GUI sibling (`Godot_v4.7.2-stable_win64.exe`,
  `FightCamp.exe`), CREATE_NO_WINDOW on every child, godot_desktop's cmd now CREATE_NO_WINDOW. GUI exe output still
  reaches pipes and redirects (measured). CLAUDE.md s6 test command updated.
- **Tools/popup_probe.ps1** proves a launcher silent: snapshots visible top-level windows + WindowsTerminal/OpenConsole
  processes, polls 10 ms, lists every NEW one. Control arm (`-Control`, a form at -32000) reads SEEN 1. SILENT:
  check_scripts, run_tests, godot_hidden windowed job, godot_hidden with the exported `FightCamp_console.exe`, and both
  full as_game walks of this session (51 s, 84 s).
- **TIMELINE1 (256d51ab)** behind switch `timeline_bar` (career flag; OFF in the game until the operator's OK; user arg
  `timeline_bar` turns it on): the top bar's date plate + CONTINUE become pause / play (1 day per 4 s) / fast (1 day per s),
  today, 14 days with a pin per MY GYM row (gold = needs the coach, dim = bill, tooltip lists the rows), and a gold ribbon
  "Stopped · <why> · <ACTION>" that opens the row's route.
  - `scripts/TimelineClock.gd` (pure): a day is always the shell's own CONTINUE (`CareerRoot.on_continue`, now returns its
    step); it stops BEFORE a day holding a decision (`GameState.decision_due_today()`, extracted from
    `advance_to_next_decision`, one rule for both), on a refusal (BLOCKED), at every week's end (WEEK REVIEW); held on any
    screen but a bare HOME and while a story card shows. PLAY on a stopped dated row = "go through it" (the CONTINUE
    press); after a WEEK REVIEW stop the next Monday's own decision still stops (seen: DEADLINE@63 after WEEK REVIEW@63).
    One shared clock (`TimelineClock.shared()`) - CareerRoot is rebuilt after every setpiece.
  - `tests/timeline_clock_test.gd` 17/0: DevJump slot 7 seed 707, 4 generated fighters, one booked into his own sport +
    a promise; 28 days by button vs by clock at FAST -> career JSON byte-identical (minus `meta` wall-clock stamps, the
    only keys two seeds differ in); stops on every decision day [56, 63] and no other; FAST 31 s for 28 days. MUTANT
    (due check off) reads missed [56, 63].
  - `tests/timeline_bar_test.gd` 55/0: OFF control keeps the plate; ON pins match get_schedule_my_gym day by day; PLAY on
    the camp day stops before the day moves with the ribbon naming it; a hub open holds; FAST takes exactly one day.
  - Seen on the game's screen (as_game walk `research/s166_timeline_walk.plan`, stills `docs/previews/s166_timeline/`):
    31 paused bar, 33 stopped on the camp with the ribbon, 42 FAST lit running Fri 9 Jan, 43 the week review reached.
  - 20 + 8 neighbour tests green (header_, shell_, day_feed, schedule_, career_root, story_card, guide_card,
    tutorial_guide, first_job, week_review, day_clock, home_, needs_you).
- **HOME 'On the wire' fix (b84eaa17)** - seen on still 42: headlines ran past the card. A long Label came out text-wide
  (472 px in a 426 px slot) though clip_text was on; DayFeedPanel._text now sizes it again once in the tree; ellipsis +
  the whole line on a tooltip. `tests/day_feed_wire_fit_test.gd` red on the shipped tree, 14/0 after.
- **NAV1 research collected** (all three via gbot, they could not land files - "Beast offline"): K86 (Kalli, full audit
  text) -> `K86_SCREEN_GAP_AUDIT.md`; J62 (John) and M42 (Maria) chat summaries -> `J62_HUB_REFERENCE_LOGIC.md`,
  `M42_HUB_MOCKUPS.md`; full pastes requested 18:37. All three recommended Option A; the operator ruled B - their shared
  risk ("continuous time skips the week review / camp") is exactly what TIMELINE1's test proves cannot happen.

## Not done / owed
- **Arena not launched**: brief `TASK_STORY4A_WALL_STATE.md` (StoryCampaign.wall() pure read + story_wall_test) is
  pushed; arena.ai renders nothing while the browser pane is hidden (S166: body text 0 chars). NIGHTLY1C2 (chat 01a10c46)
  has no branch/PR yet - its chat could not be read for the same reason.
- GitHub Actions minutes are gone until 11-01: Arena PRs get no CI; run their tests locally before merging.
- NIGHTLY: unchanged since the S163 check (latest = 26b106e9, 13 fails) - no new red.
- The operator OK on the bar: a video of the first minutes is owed with GYM-CLICK1 (NAV1 promise: "a 90-second video of
  the first ten minutes"); stills only so far.

## Next (decision)
GYM-CLICK1 behind `gym_is_menu`: the HOME gym's places become the menu (office desk -> offers/schedule panel, staff room
-> staff, door -> scouting, front desk -> members, ring -> sparring, a fighter -> his card), each hub opening as a panel
over the gym with the clock held; rail hidden only with the switch on; the coach-by-the-door replaces the FIRST JOB box.
Then the 90 s video of the first ten minutes with both switches on, sent to the operator for his OK. First 15 minutes:
launch Arena STORY4A (pane visible), collect J62/M42 full pastes, check NIGHTLY1C2's chat.
