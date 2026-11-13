# S456 handover (written 2026-11-13 at the end of S455; S454's handover is in git history)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S456`.

## USAGE RULES (kept)
- Run `get_usage` first. Hand over at 420k context; wrap-up from ~395k. At most TWO helper sessions / subagents at once.
- Never idle while a test or agent runs: run_in_background and do the next item.

## FIRST: his answer on Q-S294-216
"Training tab E is drawn in the game's own art now (the camp plan's pictures, your round icons kept). Is this the consistent look you
meant?" (Yes, this look / No, change the look). E = `docs/mockups/s455/training_d/training_game_e.png`. Quote his answer and act on it.
His Q-215 words that started it: "there is no consistensy with your previous art syle we need to beconsistent , the buttons stay though".

## DONE IN S455
- Training tab D, then E (docs/mockups/s455/training_d/): 12 pictures by `ludo batch` generate-with-style from the gym picture
  (style_ref.jpg = assets/ui/art/gym_main.jpg; jobs.json; raw files in E:\FightCamp\tmp\s455_ludo_raw), his icons ringed in the stat colour.
  Critics: D Claude 6/6; E Claude 6/6, Dola 7/8 (ops/research/TRAINGAME_CRITIC_S455_*).
- BLOCKLOOK5B collected (Grok PR 256, commit e0912e5f): block_meet ROW lines main vs branch all pass, same gloves; block_catch 9 -> 1.
  Block reel on the review board + sent to him. Export done (Builds/, WHAT_TO_TRY S455 line).
- Fight week v6 (ops/research/AMATEURWEEK1_MAP_V6_S455.md) answers every Kalli SQ64 / John SQ65 point; the critic brief without scores
  (AMATEURWEEK_CRITIC_S455_BRIEF.md: pack + access + job + v6 as PART A + v5 base as PART B) queued Kalli SQ71, John SQ72.
- TASK_POWER1D got its contract block (CONTRACT OK); TASK_BLOCKLOOK5's OWNS line fixed.

## NEXT (Claude)
1. TRAINING TAB F (unless his Q-216 says change the look - then that first). From TRAINGAME_CRITIC_S455_E_CLAUDE.md + _E_DOLA.md:
   - the goal line must be true: a taper week adds ~0 stamina, so "on course" is wrong (say "0.9 short: Hard intervals Wed" or change the goal);
   - one pad-step rule everywhere (a full night vs a half night: Mon 12->21 is +9, Wed half 21->25 is +4: say "+9 a night, +4.5 a half");
   - each morning card shows its effect number (Stamina +0.15) and its L/N/H (click a placed card to change it - Dola);
   - a price on every green tag (hover: what it cost), the diet Hold/Cut beside the WIN dial as a second trade-off;
   - the coach's sureness as a number (corner rule 0.5 + rating/200), not "Fairly sure";
   - the game words stay: Speed, Technique (Shadow and Pads), Fight IQ (sparring), Durability (Neck), Stamina, Power, Defence (Data.LABEL).
   Then a fresh Claude critic (Sonnet subagent, brief = TRAINGAME_CRITIC_S455_BRIEF_E.md with the picture swapped) + Dola. Two at 7+ ->
   the board (with the picture), then the build map.
2. POWER1D in-house (TASK_POWER1D.md; main uppercut_tail_test = failures 27): try never playing the tail - for QUICK_BACK clips freeze
   the AnimationPlayer after contact (HitImpact.recover), call guard() after a real-time 0.10 s, let the join smoother carry the glove;
   measure OVER_HEAD/ELBOW from f01 (the f00 glove sits at a taller opponent's chin by design).
3. Read Kalli SQ71 / John SQ72 (fight week v6) and Kalli SQ69 / John SQ70 (coaches v3) when `start` prints them.
4. PROGBUILD1 step bars (STEPMASTERY1).

## TRAPS (S455)
- Cici: `open --chat` and `read` stuck on an old chat (the coaches v2 answer) twice. What worked: `open --new`, attach, wait 25 s,
  then `send --file ... --wait 1500 --out <file>` in ONE background run - the --out transcript holds her answer.
- Miro P0: the SVG marks surplus slot cards data-deleted; the tool says deletions need his OK, so S455 sent updates only (8 old
  cards in the old surplus slots may still sit below the columns - ask before deleting). The frame height update was rejected
  (children outside the new bounds); harmless.
- godot_slot: every Godot command (tests, hidden-desktop renders, export) goes through `python ops/Tools/godot_slot.py run --who S<n> -- ...`.
- seat_queue paths are relative to ops/ (`research/X.md`), not the repo root.
- No pronouns for the fighter in rows: E had "she" twice before the render (fixed).
