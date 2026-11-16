# S496 handover (written 2026-11-16 at the end of S495)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S496`.

## FIRST - ANIMATION ITEM: the glove clipping, an AUDIT before any new round
BODYLOOK1 is done for now (PR 324 merged on his Q-258 "Yes, merge it"; left for his eye: the coach's collar front stands a
finger off the neck in the hunched close-up, one kink on a strap edge - only if he says so). The glove clipping ran six Qwen
rounds (CLASH5-CLASH10), every one failed or measured worse than main (PR 321 closed S495). The rules call for an audit
after two red rounds: read the CLASH9/CLASH10 results and the clash pass yourself, name the cause, then brief ONE fix
(candidate from S494: converge the glove pair on the DRAWN axis inside one loop). Stills on the game camera before any merge.

## WAITING ON HIM
- Q-259 Training K v6c (his Q-257 note "why the fuck you put ask for a fight on the training screen ?": the button is off,
  the no-bout panel says only the plain training week, the selected card is the boxer with no bout):
  docs/mockups/s495/training_k/training_k_v6c_nobout.png (+ training_k_v6.png, the fight-week state). On "Yes": build it -
  WeekCards.gd (552 lines) is split first.

## RUNNING - COLLECT WHEN THEY LAND (by diff + their own test; never a whole-file take)
- Qwen ONELOOK2 (fight HUD onto the one palette, HudBars + HudRegroup, 53 loose colours; launched 09:04, ETA ~11:00 11-16,
  branch qwen/onelook2). Render before/after fight stills on the hidden desktop (game camera, still_framing), his OK first.
- Goose FILMCOUNT1 (issue #326, branch goose/issue-326; launched 09:08). Goose's PR step FAILED on #322/#323 - collect from
  the branch. Read its FINDS table and noise numbers: noise avg < 3%, worst < 8%; floors jab habits >= 50% one film. If a
  floor missed, Claude retunes FilmBout's rates (they are estimates).
- Grok Dev FIGHTPAGE1 (the fight analysis page, film-night mode; sent 09:14, branch grok/fightpage1, ETA ~13:30). Render it
  at 1920x1080, text 1.0 and 1.3 (TextScale.overflow empty), judge against docs/mockups/s495/fight_analysis/fight_analysis_v3.png,
  then his board with the picture.
- Kalli SQ202 (LADDER1 v6) and SQ203 (COACHSPEC1 r6) - both missed the bar on John's 6 for general design (LADDER1 v5: Dola
  8/8/8, John 7/6/7; COACHSPEC1 r5: John 7/6/7, Dola REFUSED - "I can't generate the requested content"). On Kalli's answers:
  two fresh critics each (`design_loop.py critic ... --seat dola` and `--seat john`); 7+ depth and 7+ general from both -> his board.

## THE FIGHT ANALYSIS PAGE (his Q-256 "Yes, build it"; map ops/research/FIGHTFILM1_MAP_V3_S495.md)
On main: scripts/rules/FightLog.gd, FilmPattern.gd, FilmBout.gd (S495 collected with fixes: real opponent profile into
RoundScript, threat bias before habits and off the jab, FightLog tie order, scout words lowercased) and
scripts/fight3d/BoutTape.gd (AfterFight.book writes m["tape"]: every punch of a booked bout, 388 lines a 3-round bout, after
facts for both corners, the habit tag kept). Claude wires next, once FIGHTPAGE1 + FILMCOUNT1 are in:
1. The film-night stop in the fight week (FightWeekPlan film night -> FightAnalysis.for_tape; checks = FilmPattern.checks by
   coach rating; on_check = FilmCount.check; on_file -> OppFile at FilmPattern.figure).
2. FilmEdge pays at the figure until confirmed (map 3.5); FilmTruth states on the opponent's cards.
3. Result page tab "Punch by punch" over m["tape"]; History keeps the last 20 tapes (~400 lines each).
4. Live fight log panel (map section 4) -> a Grok Dev brief once FIGHTPAGE1 lands (one screen per task).
5. Golden path (map section 6) walks it end to end.

## ONELOOK1 (one look) after ONELOOK2
Palette baseline 649. Next files: RosterCards 22, ReadPanel 18, MatMap 16, MatchupCards 15, WhiteboardKit 13. UI.gd (41),
WoodKit (34) and WeekCards (33) need a split first (line limits). Each with before/after stills.

## NOTES
- `tools/export.sh` worked twice today (08:57, 09:14); it re-stamps ~2,300 .import files (leave them uncommitted).
- `gbot.py send --file` resolves a relative path from ops/: pass an absolute path.
- Godot jobs go through `python ops/Tools/godot_slot.py run --who <you> -- <godot command>` (rule_guard blocks a direct launch).
- Fight video analyzer (S495 research, its own session): report ops/research/FIGHT_VIDEO_ANALYZER_S495.md; data outside the repo.
