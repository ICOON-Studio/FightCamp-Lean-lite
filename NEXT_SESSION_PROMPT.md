# S475 handover (written 2026-11-14 at the end of S474; S473's handover is in git history)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S475`.
S474 did NOT redraw the Miro P0 frame (context ran out): redraw it at the start (`where_we_are.py svg` -> one
canvas_update_from_svg; its stderr asks for TRIM + LEARN this time - follow Tools/where_we_are_svg.py docstring step 3).

## USAGE RULES (kept)
- Run `get_usage` first. Hand over at 420k context; start the wrap-up at ~385k (S474 reached 417k before starting it - stop earlier).
- Godot jobs through `python ops/Tools/godot_slot.py run --who s475 -- <cmd>`; never wrap Godot in `timeout` inside the slot.
- Arena: `python ops/Tools/lite_mirror.py --lean push` first; the repo is ICOON-Studio/FightCamp-Lean-lite, branch main; a short
  prompt that names ops/research/TASK_<ID>.md works (Arena reads the brief from the repo). New chat per task.
- Goose: 3 tasks a day (GOOSE_PER_DAY). seat_dispatch holds Goose rows while Qwen runs; file the issue by hand
  (`gh issue create --label goose --title "<ID> - <title>" --body-file ops/research/TASK_<ID>.md`).

## HIS WORDS THIS SESSION
- C401 sound picks "6,9,12,14,18,23,28,30" (one per sound), then the redo board "2,6,8" -> 11 kept in assets/audio/sounds.json.
- "we mightneed it if you get low on credits,set it up" ($200 Console API credits) -> ops/research/API_CREDITS_FALLBACK_S474.md
  (the desktop Code tab cannot use them; the `claude` CLI with /login Console account can; manual switch).
- "higgsfeld refused the refund, will i keep the credits forever?" -> no: plan credits end with the paid period (Dec 14).
  Offered to spend them on approved asset work before then: no answer yet.

## IN FLIGHT (yours - collect, do not relaunch)
- Arena FWPICK1 (assistant's fight-week pick) chat https://arena.ai/agent/01a1db8f-0c20-7c3f-a84c-864baacf9434
- Arena REGIONSHOWS1 (club-show calendar + slots) chat https://arena.ai/agent/01a1db96-14b1-7162-8f51-db28c29688f8
- Qwen SOUNDWIRE2 (wire the 11 kept sounds; needs the 11 .ogg.import sidecars; sound_bank_test), then KNEERULER1 queued.
- Seat queue: SQ139 Dola + SQ140 John score the fight week screen mockup (docs/mockups/s474/fight_week_v1.png);
  SQ130-138 design loop answers (STEPVALUE1, coach fit v8, weight r4, plan flowchart v2 John/Maria, club week v7).
Collect = take the files by diff onto main, run the test here, commit, close the PR/issue, archive the live_runs row.

## FIRST: KEEP BUILDING THE FIGHT WEEK (AMATEURWEEK1)
On main (all green here): scripts/rules/WeighGap.gd, BoutSheet.gd, FightWeek.gd, FightWeekEvents.gd, FilmTruth.gd;
WeekPhase amateur branch (bout.fight_week: week before = Build, fight week by bout.load); BoutRules.first_round_edge
(bout.r1_edge, live + forecast); BoutRules.tank_parts_for adds the fight week's choice layer. NOTHING sets fight_week yet.
Order: 1) collect the agents above. 2) Q-S294-229 (his 7 rules): on his answer - Savings brief (Goose), WeekPhase.LOAD_DEFAULT
tick_over, the Bouts.weigh club-show branch (ops/research/AMATEURWEEK1_CHECKS_S474.md item 3; rivals need a walking weight).
3) Critics on the screen -> fix -> his board for the look -> Grok Dev builds it from the mockup. 4) THE SWITCH in one change:
amateur bouts booked with fight_week true (Bouts.accept), Set camp gone for them, lead 1-3 weeks from RegionShows +
BoutSheet, FightWeek.round_one -> bout.r1_edge at the bell, ring rust (BoutSheet.rusty) too, golden path walks it.

## NOTES
- Animation item for S475: the rear knee, Qwen KNEERULER1 (do both knee rulers read the raw take as the take?).
  docs/KNEESWEEP1_RESULT.md + KNEESWEEP2_RESULT.md: knee settings and foot turn are exhausted; the two rulers disagree ~1 deg.
- Tank decision (S474): the game's own tiredness layer stays (2 a point over 50, cap 20); the map's 1-a-point layer is NOT used.
- Coach away (map 4.1): the other boxers train at 60% (no coach rating; Sim.gd:45), not 0.85.
