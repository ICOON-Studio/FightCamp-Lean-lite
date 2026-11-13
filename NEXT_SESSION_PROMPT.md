# S455 handover (written 2026-11-13 at the end of S454; S453's handover is in git history)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S455`.

## USAGE RULES (kept)
- Run `get_usage` first. Hand over at 420k context; wrap-up from ~395k. At most TWO helper sessions / subagents at once.
- Never idle while a test or agent runs: run_in_background and do the next item.

## FIRST: his answer on Q-S294-215
"Training tab redrawn as a game (C) ... Keep this direction for the build?" (Yes, this direction / Change the look first). C is
`docs/mockups/s454/training/training_game_c.png` (+ B painted on the review board). Quote his answer and act on it.

## DONE IN S454
- His Q-214 comment ("lacks art ... too text heavy ... how much do you rate it for a game"): the S439 redesign rated ~4/10 as a game; three
  game-style drafts A / B / C in docs/mockups/s454/training/ (html + png). C = Ludo "Comic Book" pictures (img_comic/) + his stylized round
  icons (icons/cut/), fatigue tank per day, week goal Peak/Build/Recover, coach card struck out under changes, risk pips.
- Critics on each: Dola 7/8 (A, B, C), fresh Claude critics 6/6 (A, B, C). Answers: ops/research/TRAINGAME_CRITIC_S454_*.md.
- COACHFIT v3 (ops/research/COACHFIT1_MAP_V3_S454.md) from Maria 6/5 + Dola 8/8; critic copy without scores
  COACHFIT_CRITIC_S454_BRIEF.md queued to Kalli SQ69 and John SQ70.
- Miro works again: P0 redrawn (done / now / next), ids learned.

## NEXT (Claude)
1. TRAINING TAB D (if he says yes; if he asks for a look change, do that first): fix every logic defect in
   TRAINGAME_CRITIC_S454_C_CLAUDE.md - injury bands from InjuryRoll (x2 at 76, x3 at 80) named Fresh / Working / Tired / Overreached with
   the effect printed on the line; check-hook steps Mon 12->21, Wed 21->25, Fri 25->32 everywhere; the weapons text matches the rings;
   a bar for every stat a card grows (Footwork, Defence); Sunday evening a real slot; one dated weight margin; hover "why" on each WIN tag
   and greyed +0 cards; 14 px minimum text; icon ring colour = the stat's bar colour; trim the right column (clicked card, builds, one
   danger). Then a fresh Claude critic (Sonnet subagent) + Dola (Cici, JPG attachment). Two at 7+ -> the board, then the build map.
2. BLOCKLOOK5B (Grok Dev, PR 256): not pushed by session end (head 59de1097). When it lands compare block_meet ROW lines main vs branch.
3. Read Kalli SQ69 / John SQ70 (coaches v3) and John SQ65 (fight week v5); write fight week v6.
4. POWER1D (TASK_POWER1D.md S453 section), PROGBUILD1 step bars.
5. Qwen is idle (idle guard): brief a pure module once a design is approved (e.g. the training screen's fatigue band word + week load tier).

## TRAPS (S454)
- Cici `send` printed VERIFIED while the brief sat unsent in the composer (the send button was disabled during a 1 MB PNG upload).
  Attach a ~400 KB JPG, wait 15 s, then send; check `cici.py status` before trusting it.
- Ludo raw downloads are big (120 MB for ~30 pictures): keep 512 px JPGs in the repo, raw files in E:\FightCamp\tmp\s454_ludo_raw.
- A critic brief must never carry earlier scores: strip the map's history paragraph (done for coaches v3).
- Miro: send only changed widgets; no data-deleted lines except this module's own surplus slots.
