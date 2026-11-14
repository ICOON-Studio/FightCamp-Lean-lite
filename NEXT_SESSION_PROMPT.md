# S474 handover (written 2026-11-14 at the end of S473; S472's handover is in git history)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S474`.

## USAGE RULES (kept)
- Run `get_usage` first. Hand over at 420k context; start the wrap-up at ~385k (S473 ran to 479k - stop earlier).
- Godot jobs through `python ops/Tools/godot_slot.py run --who s474 -- <cmd>`; never wrap Godot in `timeout` inside the slot.
- Never `cd` into an agent worktree; read it with `git -C <wt>`.
- Arena's mirror: `python ops/Tools/lite_mirror.py --lean push` / `--lean relay` (WITHOUT --lean it targets the old repo and fails).
- Dola: if seat_queue says "no CDP on 9333", stop the Cici.exe main process by PID and `python ops/Tools/cici/cici.py launch` (from ops/).

## HIS WORDS THIS SESSION
- "please add shortcuts to see a fight here" -> board Play panel: Fight night, Corner minute, Men's fight, Round 3.
- Flowchart pictures: "yes go with your verdict and have it reviewed by critics and improve if needed"; then "my 4 pictures
  were just for ideas do not attch too much on them" (memory feedback_owner_pictures_are_ideas_s473).
- "use arena more its free same for ludo" (memory feedback_use_arena_ludo_more_s473).
- Ollama: "use also ollama on thebest free model available" -> tried, 16 GB RAM, unusable -> "yes stop using it and delete
  the models to free up space" (done; gemma4:12b kept: "Keep gemma4").
- Higgsfield: "cancel it and request refund please" -> cancelled (no more billing; plan runs to Dec 14), refund email sent.
- "Yes, design it" (step value) and "Yes, build it" (THE FIGHT WEEK).

## FIRST: BUILD THE FIGHT WEEK (AMATEURWEEK1)
His S473 "Yes, build it". The map passed (v8: Dola 8/8, John 7/6): ops/research/DESIGN_AMATEURWEEK1_V8_REVISE_KALLI_KALLI.md,
John's 10/10 list in DESIGN_AMATEURWEEK1_V8_CRITIC_JOHN*. Split it: pure rule modules + tests -> Arena (lite mirror) and Qwen,
each screen from the map's menu table -> Grok Dev, Claude wires and writes the golden-path walk. It unlocks Ask for a fight,
Knowledge and Turning pro (both approved "after the fight week") and push + tank.

## COLLECT
- Qwen KNEESWEEP1 (worktree LEAN_KNEESWEEP1): which knee-solve setting moves the rear knee toward the take; doc only.
  Then fix the knob it names (the rear-knee item; animation progresses every session).
- Seat answers: SQ130 STEPVALUE1 v1 (Kalli) -> two fresh critics; SQ131 coach fit v8, SQ132 weight r4 -> critics;
  SQ133-138: John, Maria, Dola on plan flowchart v2 and club week v7. A map at 6+/6+ on two critics goes to his board.
- His ear: 30 Ludo sounds (pads, corner, clinch, gym room tone) on docs/audio/board_s473 and the review board - all UNHEARD.

## WHAT S473 FOUND
- Rear knee: crouch depth, stance and a sideways hip shift are all ruled out (docs/PELVIS1_RESULT.md); left = the knee solve.
- punch_speed 41 sorted (docs/SPEEDRULER1_RESULT.md): SPEED 11, FIRST 18 (wind-up stillness, partly the kept chest load),
  POP 12, SYNC 0. HOOKCAP2 in: hard hooks 11.4/12.3 m/s, total 42.
- punch_pace.json: the tool is repeatable; a fresh file is 43 v 42 - main's kept (docs/PACEREMEASURE1_RESULT.md).
- PICKSPREAD1 (Arena): punches best 52-66 % of picks, footwork/defence 12-20 %; the bout reads no step mastery (NODEREAD1).
  STEPVALUE1 design is the answer (brief ops/research/DESIGN_STEPVALUE1_V1_KALLI.md).

## NOTES
- Animation item for S474: the rear knee (KNEESWEEP1's knob), Claude.
- The nightly latest.txt is from an old commit: its non-3D reds (bout_read, no_pronoun, words_on_screens, plan_test_it,
  move_tip) all PASS on today's code (checked S473).
- Five move cards have no picture (step_out, pivot_out, roll_out, cut_off, push_off) - not traced; tools/move_pic_ideas*.gd.
