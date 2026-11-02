# TASK FLOORWIRE1 - Corner Rehearsal + Load Ledger on the floor, every floor decision on Ludo's one card (S235)

Seat: Grok Dev (coding seat, own Linux box, Godot 4.7.2, no LFS) - you own the gym floor this round (FLOORCUTS1 collected 85c90de9).
Branch `grok/floorwire1`, PR to master; Claude reviews and merges by diff. Discipline: BOXING (the demo's gym floor).
New features ship ON: one switch per mechanic in `GameSwitches.GAME_ON`; plain `--script` tests are the OFF control arm.

## What is on master already (read these files - do not rewrite them)
- `scripts/rules/CornerRehearsal.gd` (Ludo r99 K8): summary(block), counter_station(kind), calls(block, state), apply(call, block, state),
  auto_call(block, state), should_show(state). Test tests/corner_rehearsal_test.gd green.
- `scripts/rules/LoadLedger.gd` (Ludo r99 K9): create_new_week(), block_cost(kind, minutes, cue), spend(ledger, cost, day), status(ledger),
  injury_mult(ledger), niggle_forced(ledger, day), week_end(ledger), forecast(ledger, plan). Test tests/load_ledger_test.gd green.
  (Qwen is re-tuning its CONSTANTS against real camp loads in parallel - call the functions, never copy its numbers.)
- `scripts/ui/FloorDecisionCard.gd` (Ludo r100): show_card({title, text, options:[{id,label,key,hint,disabled,why,auto}], timer_s, tone}),
  signal chosen(option_id). `scripts/ui/LoadLedgerStrip.gd`: set_ledger(status, forecast). Tests green.
- research/ludo_rx/LUDO_R100_part2.txt PART B: Ludo's rule - decisions QUEUE (FIFO), never two cards at once; the clock holds while a card is open.
- `scripts/GymHall3D.gd` (2,860 lines; never read whole - grep): the floor day. Existing decisions, each with a pending dict + an answer func +
  a toast with key hints: breakthrough (`breakthrough_pending`, `breakthrough_answer`, ~1590-1640), niggle (`niggle_pending`, `niggle_answer`,
  ~1480-1545), floor events (`floor_event_pending`, `floor_event_answer`, after breakthrough_answer), form breakdown (`form_state == "SLOPPY"`,
  `form_answer` or similar - grep). `_gain_tick()` runs the checks every game minute. Block ends: grep `STATION_BLOCK_MINUTES` / `_block_mark` /
  `last_block_check` (BlockStopCheck at minutes 200/400).
- `scripts/GymClub3D.gd`: `_unhandled_input` (~1327) maps keys L/B, A/B, P/T, F/X to those answers.

## Do
1. LOAD LEDGER (switch `load_ledger`): GameState keeps the week's ledger on the athlete (`athlete["load_ledger"]`, created with
   create_new_week() when missing; week_end() when the career week rolls - grep where the career week advances). Every finished floor block
   spends block_cost(station_kind, minutes, cue) on that day. injury_mult feeds the niggle roll (Niggle.from_soreness's pick threshold);
   niggle_forced makes a niggle certain. Put LoadLedgerStrip on the floor HUD under the boxer card (top-left), set_ledger after each block.
2. CORNER REHEARSAL (switch `corner_rehearsal`): when a station block ends and should_show(state) is true, open the card with calls(block,
   state) (PUSH / SWAP / ICE, greyed with their why), 10 s timer, auto_call when it runs out; apply() sets the NEXT block's mods (gain mult,
   strain, swap to counter_station via the existing station queue, ICE = 20 min break that clears wear on the sorest part).
3. ONE CARD FOR EVERY DECISION (switch `decision_card`): a FIFO queue in GymHall3D; breakthrough, niggle, floor event, form breakdown and corner
   rehearsal each PUSH a card instead of (only) a toast; the card's chosen(option_id) calls the existing answer func; the keys in
   GymClub3D._unhandled_input stay working and answer the OPEN card. The game clock holds while a card is open. With decision_card OFF the old
   toasts + keys behave exactly as today (control arm).

## Tests (red on master first - paste the red lines in the PR body)
- New `tests/floor_wire_test.gd` modelled on tests/breakthrough_floor_test.gd and tests/floor_events_floor_test.gd (GymClub3D room, models off,
  `career[...]` switches): a block end opens a corner card; PUSH raises the next block's gain mult; ICE takes a break and lowers wear; the
  ledger's spent grows by block_cost after a block; over-budget forces a niggle within 2 days; two decisions at once -> one card open, the
  second opens after the first is chosen; the clock does not advance while a card is open; all switches OFF -> no card, ledger untouched.
- Must stay green: breakthrough_floor_test, floor_events_floor_test, niggle_floor_test, form_breakdown_floor_test, floor_cuts_test,
  corner_rehearsal_test, load_ledger_test, floor_decision_card_test, load_ledger_strip_test, floor_actions_test, block_stop_floor_test.
- `gym_club_3d_test` needs LFS models: if your box cannot load them, say so in the PR; Claude runs it.
- Parse gate: `python Godot/tools/check_scripts.py <every touched .gd>`.

## Rules
GDSCRIPT_TRAPS.md (typed reads, no `:=` on a Variant, no `%%`). GameState.gd is ~29,000 lines - grep and read windows only. Do not edit the
Ludo modules (rules/CornerRehearsal, rules/LoadLedger, ui/FloorDecisionCard, ui/LoadLedgerStrip) - if one has a bug, say so in the PR.
Comment "FLOORWIRE1 DONE" with the test lines.

## Prior research
GYMFLOOR_MECHANICS_IDEAS_S234.md (Ludo r97 order), LUDO_R99_raw.txt + part2 (K8/K9 + HUD placement), LUDO_R100_part2.txt PART B (queue),
J62_TRAINING_DAY_REPLY.md (real loads), your FLOORCUTS1 PR #215.

## What would a human do?
A coach reviews each round as it ends and calls the next one; a strength coach keeps a weekly load sheet; nobody shouts two things at once.

## Prefab check
None - Ludo wrote the modules and the card.

## The one trap
The clock-hold: a card that opens while the day keeps running makes every timed mechanic fire behind the card. Test that minute does not
advance while a card is open.
