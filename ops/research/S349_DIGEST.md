# S349 DIGEST - 2026-11-01 - her week round her body, build your own combos (Lean update 50)

Lean commits: deb659c (training board), d64eb8a (Combos tab, ComboFlow rule 6, Try combos). Game: roadmap, live runs,
Q-S294-73, TASK_TRAINCLIPS1.md.

## Operator input this session (quoted)
- Q-S294-72 (training mockup, S348): "the text has nothing to do with the picture, combo and learning like wtf ?
  everythingis wrong in the boxes". Read: the cards were settings (load, focus, weight, learning, combo) with lines to
  random body points; his MMA picture's cards are EXERCISES, each pointing at what it trains.
- C201 (flow game plan still): "also make it look like a game, give the players a list with optional moves etc to try
  things like combos".

## What shipped
1. **FIGHTERS > Training = TrainingBoard** (`scripts/ui/TrainingBoard.gd`, rules `scripts/rules/TrainingWeek.gd`, 8 tests).
   Her own body (portrait + mask, no hurt rings) in the middle; 8 sessions round her, one per stat plus the coach's pads:
   sparring (Ring IQ, head), neck work (Chin, neck), shadow boxing (Technique, lead shoulder), heavy bag (Power, rear
   shoulder), speed bag (Hand speed, lead arm), pads (new move + combo, the learning move's hand), slip rope (Defence,
   waist), roadwork (Conditioning, legs). Lead/rear flip for a southpaw; columns by the point's side. Each card: hours
   (pads 20 %, main 32 %, support 16 %, the other five share 32 % of her load), the stat's real gain this week
   (Sim.daily_gain), the coach's why, her week cards as "her drill" chips, Make it her main (= focus; camp-locked with the
   reason). Load / weight / coach in the header. Stills docs/playtest/S349/training (t1 as she starts, t2 after Make it her
   main on the heavy bag: power +0.9, shadow boxing SUPPORT). Old dropdown list removed (named controls kept).
   Station-to-stat mapping checked against the old project's equipment catalogue (heavy bag -> power, speed bag -> hand
   speed, ring -> sparring/ring craft, cardio -> stamina). On the board as **Q-S294-73** (keep it / change it).
2. **PLAYBOOK > Combos = ComboBuilder** (`scripts/ui/ComboBuilder.gd`, `tests/combo_builder_test.gd` 6 tests): MOVES TO TRY
   (punches / defence / feet; an unlearned punch dimmed with why), START FROM HER BOOK (unlearned dimmed), the chain as
   numbered rows with the coach's cue, FLOWS / WORKABLE / CLUMSY + score + tank cost, KEY LESSONS (deduped), Play it
   (`MovePlayer.show_chain`), Save to her book (`f["book"]`), Drill it on the pads (book combos, act "combo"). Stills
   docs/playtest/S349/combos. The plan's flow view has **Try combos** (FlowView opts "try") -> this tab (C201).
3. **ComboFlow rule 6** (his "Build a smart combination" sheet, "move your head after punching"): a chain ending on a
   slip / roll / step after its punches +10; ending on a punch gets the coach's note, no penalty (book combos stay FLOWS).
   1-2 = 70, 1-2 slip = 80.

## Collected / sent back (each measured on our GPU, primary source = the run, not the report)
- **GROUND3 r1** (Qwen 37ce27f): bounds pass over 400 seeds, BUT `chance()` = base x 1.08^(gap/20): a 40-point gap moves
  odds x1.17; G144 says x1.25-1.70 per +20 with caps. All-rounders' ground time 29.9 % (bound edge; research 15-25 %), sub
  finishes 4-6 % (UFC ~15-20 %), "ctrl_a=271.6%" is seconds. -> **Qwen r2** (E:/FightCamp/wt/LEAN_GROUND3_r2_prompt.md).
- **PADWORK1 r3** (Goose 5633c78) FAIL: `_track_mitt_to_glove` moves the mitt onto her glove every frame, so the probe reads
  gap=0.035 on every punch (self-measure); jab still: glove sunk in the mitt, mitts render as jagged stacked discs; hook
  still: her hand in guard, mitt in the air; black backdrop. Stills kept in docs/playtest/S349/padwork_r3 (not merged).
  -> **Goose r4** (issue #13 body: coach presents the mitt before the punch from HER clip's contact pose, probe gaps must
  differ between punches, smooth mitt mesh, our floor).
- **CLINCH2 r2** (Goose 31ccc38): applied cleanly on main, then `tools/clinch_check.gd` on our GPU = CLINCH OK 2/6 (overlap
  glove-head 0.04 m, heads 0.21-0.28 m, hands, digs 0/5) - the report said 6/6; probe also prints !is_inside_tree errors.
  Reverted. -> **Goose r3** (issue #14: merge main first, fix the probe setup, 6/6 on the merged tree).
- **SMOOTH3** (Goose issue 18) still running at stage end.
- **TRAINCLIPS1** NEW -> Cursor (wt E:/FightCamp/wt/LEAN_TRAINCLIPS1, brief research/TASK_TRAINCLIPS1.md): 8 pictures
  of her doing each session from clips already in Lean, shown on the training cards (operator S338: agents do animations).

## Decided (Claude, developer)
- Settings are not sessions: load and weight belong in the header; combo + new move live inside the pads card.
- A custom chain is saved as data only (her book); only book combinations reach the sim (Drill it = combo_learning).
- PADWORK1 has had 3 red rounds: round 4 carries a code audit, not a retry (memory: audit before more fix rounds).

## Next (roadmap now.next_action)
Q-S294-73 + comments; collect GROUND3 r2, TRAINCLIPS1, SMOOTH3, PADWORK1 r4, CLINCH2 r3 on the GPU; Pad rounds plan off the
pads card on his yes; C197 corner card; Playbook map tree look.

## HANDOFF
- Working commit: Lean d64eb8a (pushed), Game roadmap/digest commit of S349.
- Runs in flight: GROUND3 r2 (qwen, pid 9800), TRAINCLIPS1 (cursor, pid 47592), SMOOTH3 / PADWORK1 r4 / CLINCH2 r3 (goose,
  cloud). All in AgentComms/live_runs.json.
- Exact next action: `git pull && python Tools/agent_comms.py start`, then roadmap now.next_action (1).
