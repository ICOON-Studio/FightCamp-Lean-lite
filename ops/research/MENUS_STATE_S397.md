# Menus state at hand-over (S397 menus side session, 2026-11-07)

Goal of the work: take the menus from a blind 5/10 to 8/10 (a fresh general-purpose Claude critic per round, never shown
earlier scores or reasoning; 8 = as clear as Football Manager / Corner King). The history is in NEXT_SESSION_PROMPT.md,
the "MENUS S397" block.

## Latest blind scores per page
- Whole set: S396 rounds 1-3 scored 5 / 5.5 / 5; S397 rounds 4 / 5 / 6 scored 5.5 / 5.8 / 6.2 (r6 stills). Stopped by the stall rule.
- Round 6 by page: Club > Money 7.5, World > Rankings 7.5, Records / Handbook / Settings 7, Roster / People / Week 5.
- Week alone, after the rework: 5.0 -> 5.6 (r7, next week planned on weekends). After round 2 and the layout pass it
  scored 5.5 four times (r8, r9). Stopped there, and the redesign below started.
- Playbook: blind 5 (Moves 5, Game plan 4, Combos 6, Escapes 5). Another session scored it in 94924b29 and wrote its faults into NEXT_SESSION_PROMPT.

## Week redesign: status
- Design doc: docs/WEEK_REDESIGN_S397.md. It holds the designer seat's output, Claude's yes/no verdict on each point,
  and the v2 spec.
- Designer seat: Cline 3.0.74 in plan mode (`cline -p -c E:/FightCamp/Lean -t 900 "<brief>"`, design only). The brief is
  in the Claude scratchpad, not the repo; the doc summarises it.
- Critic rounds on the design TEXT (each critic reads the current still r9/fighter_week.png and the spec):
  - v1 scored 6.5 and 6.5.
  - v2 (in the doc) scored 6.5 and 6.5. Their shared faults, for v3:
    1. Clicking an evening to cycle its kind is risky: it can silently drop a drill, and the same click also drops a
       held card. Fix: a small Rest / Pads / Spar control on each evening's head; the card body stays a drop target.
    2. The load chip wraps Hard -> Light. Fix: a segmented L / N / H control.
    3. Four ways to edit. Fix: one grammar, e.g. mornings and evenings both open a popover that previews each choice.
    4. Week sessions /16 and day tiredness /100 aren't linked. Fix: each day shows its session cost ("+2"); the meter
       tooltip names the heavy days.
    5. Gold means three things. Fix: drop targets in blue.
    6. Missing actions: take a drill off a night (x on the card, drag back to the tray).
    7. The goal needs an end point: "65 -> 67 by Sunday" with a target tick.
    8. Lock wording: "Can't pass 38 until the cross improves"; label the tick "usable"; show the tier ladder once.
- Built: nothing of the redesign yet. Rule: build only at 8 from two fresh critics, then re-score the built stills.
- v2 needs a rule change (no new mechanic): per-evening kinds stored in the week exceptions (WeekPhase edits), with
  PadWeek.lay taking the pad-night count from the evenings set instead of the Light / Standard / Hard step. The doc's
  last paragraph has the detail.
- Coordinate with the Fighter profiles session (local_149a03f4, branch claude/fighter-profiles-*): six stats become
  ~21 named attributes. Bars and labels draw what the week preview reports; no stat names hard-coded. Pull main often.
- Do not touch: scripts/fight3d, BJJ, the fight-model files, the first-hour flow, the pro Fights section, money rules.

## Shipped this session (all on main)
- eef01c07: weekends plan next week (WeekPhase.ahead_view / keep_ahead, week_edits_next promoted on Monday;
  tests/weekend_plan_test.gd).
- b1d4fd31:
  - WeekCoach.advice/fix: the coach line names the day and gets a Do it button; the gap is said in words.
  - Rest nights are one-line strips; "holds the pads" is said once; one CONTINUE.
  - Bug fixed: the next-week view carried this week's run evenings (DrillWeek NOTED).
- d70c2263: move names in the plain font; a gold card leads with the move.
- 72bca9a9 (layout pass):
  - The coach row sits under GOAL; EVENINGS shows pads and sparring together; WEEK LOAD.
  - The bar key; plain card lines ("on no pads night yet", "needs a better cross").
  - Mornings name their stat; a shorter strip.
- Earlier rounds: 59f38b1c, 5f8913ee, 08f9719c, a11e97fc, 465a3adf (see NEXT_SESSION_PROMPT).

## Open fix lists (not started)
- Structural, from round 6:
  1. One mastery word per move everywhere.
  2. Fill or resize the near-empty pages (Roster, History, People, News).
  3. One label for "Enter <fighter>"; NEW GOAL goes into the Needs strip.
  4. Overview: radar or bars, not both.
  5. One fixture list.
  6. The Playbook viewer opens only when something is picked.
  7. Brush font for page titles only.
  8. Records shows "missed the goal" on fight night.
  9. Championships highlights a past step.
- Week: v3 from the eight points above, then two fresh critics; build at 8. Until then the page holds at 5.5.

## Tools
- All stills:
  `python tools/hidden_desktop.py run --timeout=300 --log=<dir>/log.txt "$LOCALAPPDATA/Programs/Godot/Godot_v4.7.2-stable_win64.exe" --path . --windowed --resolution 1920x1080 --audio-driver Dummy --script res://tools/cut_pages_still.gd -- <dir>`
  It writes 19 PNGs from the TestJump "nationals" save (Sat 7 Feb). Rounds so far: E:/FightCamp/tmp/s397/r4 ... r9.
- Tests: headless with `--audio-driver Dummy`, only the touched ones. The Week set is weekend_plan_test,
  week_coach_test, drill_card_test, drill_pick_test, plan_tray_test, plan_cards_test, test_pad_edit,
  week_board_clarity_test, first_week_test, training_week_test, plan_board_test, camp_cards_test, menus_round4_test,
  no_pronoun_test. All green at 72bca9a9.
- Critic prompt: in this session's history; short form in NEXT_SESSION_PROMPT. Give the critic one still, the context
  line, and ask for SCORE / GOOD / TOP FAULTS in under 250 words.

## Uncommitted or half-done
- docs/WEEK_REDESIGN_S397.md and this note are committed together.
- None of this session's code is left uncommitted. The other modified files in the shared folder belong to other
  sessions: Matchmaking.gd, ProLadder.gd, matchmaking_bots_test.gd, the ops/AgentComms json files, and the .import / .uid files.
