# S457 handover (written 2026-11-13 at the end of S456; S455's handover is in git history)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S457`.

## FIRST: his answer on Q-S294-217 (asked after the ship)
He asked: "i am confused with the training tab , is it supposed to be a sub card in players profile or a seperate training scene where you select training for each fighter ?". A-G were drawn as a profile tab (breadcrumb Fighters > name > Training), against his C293 (TRAINSCENE1: training as its own scene, the profile tab a summary). Recommended: one Training scene, the four fighters as portraits on top, the G week board below for the picked fighter, the profile tab a summary + Open in Training. Draw H in whichever shape he picks.

## USAGE RULES (kept)
- Run `get_usage` first. Hand over at 420k context; wrap-up from ~395k. At most TWO helper sessions / subagents at once.
- Never idle while a test or agent runs: run_in_background and do the next item.

## DONE IN S456
- His Q-S294-216 answer: "Yes, this look" (Training tab E). Then his note: "i would like to see more stylised icons there like in the
  playbooks , keep art syle consistent" -> every session icon is now in the Playbook's ink look (docs/mockups/s456/training_f/icons/):
  8 from the game's own baked ink cards (assets/ui/training/mh_boxer_07_*, the Playbook's pipeline), sparring = the Playbook's 1-2 card,
  6 new by Ludo (generate-with-style from a 4-card ink strip; docs/mockups/s456/ink_icons/jobs*.json; 8 credits).
- Training tab F (docs/mockups/s456/training_f/training_game_f.png): every number traced to WeekPlan / TrainingPreview / MoveMastery /
  PadWeek (a morning ~+0.09; pad gains shrink near the cap - one rule; fatigue carried in 62: coach's week 74 Wed Tired, the player's 70);
  L/N/H on every morning, effect + tiredness on every card, prices on tags, Hold/Cut with what Hold does, coach 80% sure (0.5 + 60/200).
  Critics F: Claude 7/6, Dola 8/9 -> G.
- Training tab G (training_game_g.png): film is NOT a chance (OppFile opens one hidden tell a session in a fixed order; a week runs as one
  block) - the dropped right was found last week, Tue's film opens her weakness, its +2.5 counts only if a Usable move answers it (dial
  53-55%); the coach's cards ghosted where the week changed; the coach gives reasons, not the answer; a check hook ladder.
  Critics G: Claude 6/6, Dola 7/9 (ops/research/TRAINGAME_CRITIC_S456_G_*). Pronouns fixed after the round (coach note, film card).
- Coaches v3 critics in: Kalli SQ69 6/5, John SQ70 6/6 (ops/research/COACHFIT_CRITIC_S454_*) -> coaches map v4 needed.
- SPECIALTY1 (held moves, pure module) briefed (ops/research/TASK_SPECIALTY1.md) and launched on Qwen (wt LEAN_SPECIALTY1, qwen/specialty1).
- POWER1D (uppercut tail, in-house subagent): not landed - the quick-back patch (freeze at contact, guard after 0.10 s) took uppercut_tail 26 -> 18-20 and the pops away but hit_carry 42 vs 40, punch_speed 41 vs 39, so game code reverted; patch in ops/research/POWER1D_S456_quickback.patch; the remaining reds are the test's reads (glove top, one pre-punch frame, carry counting the way home) - TASK_POWER1D S456 section.

## NEXT (Claude)
1. TRAINING TAB: Training tab H from TRAINGAME_CRITIC_S456_G_CLAUDE.md + _G_DOLA.md and F's Claude list: (a) a WHAT THE WEEK BUYS strip (stat bars now -> bout, goal marked, moving while you drag) - asked by both Claude rounds; (b) far fewer numbers on cards: one gain number a card, tiredness under each day; (c) the pad rule back in words (G dropped F's sentence, so the critic read +3 vs +9 as a contradiction again); (d) L/N/H on evening cards too (Dola) - check PadWeek/WeekPlan support it first, else say why not; (e) the Hold/Cut state shown by the tick. Depth needs a cost that does not net into one number: the film bet is in; look for a second real one in the rules (injury that stays: InjuryRoll weeks out), never invent. Two fresh critics at 7+ -> the board with the picture.
2. POWER1D: decide the test contract (TASK_POWER1D S456 section): OVER_HEAD at the glove's lowest point, BACK in the spine's frame, hit_carry without an uppercut's post-contact return; then `git apply ops/research/POWER1D_S456_quickback.patch`, run the full regression list on an idle GREEN PC (godot_slot), film seed 4242 + 3 seeds, review board.
3. Collect SPECIALTY1 (Qwen PR) by diff + parse + test; then wire it into PadWeek's week (Claude, map section 10 task 8).
4. Coaches map v4 from Kalli SQ69 + John SQ70 (both: the fit arithmetic can't reach its top word, the screen solves the week ("best swap"
   printed), the head coach vs the 60% rule, the corner's shouts unsettled). Then fresh critics.
5. Read Kalli SQ71 / John SQ72 (fight week v6) when `start` prints them.

## TRAPS (S456)
- Ludo generate-with-style from an ink strip draws light paper tiles unless the prompt says "dark background edge to edge, no tile".
- Raw Ludo output is ~4 MB a picture: move it to E:\FightCamp\tmp before committing (S456: 25 MB).
- A heredoc with many quotes failed in the Bash tool (rtk rewrite?): write Python to a scratch file and run it.
- Cici: `open --new`, attach, wait 25 s, `send --file ... --wait 1500 --out <file>` in ONE background run worked twice.
