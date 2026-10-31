# S324 - next session (written S323, 2026-10-31)

Start: `git pull && python Tools/agent_comms.py start` in E:\FightCamp\Game, then work in E:\FightCamp\Lean.

Where it stands: update 26 exported (41/41 tests): tired shows, the body view everywhere (with a key), Pace + Aim (balance-
checked), broadcast round/result pages, referee 13 % on screen, `-- jump=round3`. Digest: Game Godot/research/S323_DIGEST.md.
The operator APPROVED the make-it-a-game plan ("Build it"): Game Godot/research/MAKE_IT_A_GAME_PLAN_S323.md - updates
27 money that bites, 28 injuries + the 30-day KO rule, 29 train hard or rest + a body report after each fight, 30 the road
to the National Championships. Production map: Miro P0-P9 (right of frame 11), linked on the ops board's "Production map".

1. Board: Q-S294-42 (update 26 verdict), Q-S294-43 (Ziva's model - his money).
2. UPDATE 27. Collect Qwen GYMBILLS1 (running: branch qwen/gymbills1, wt E:/FightCamp/wt/LEAN_GYMBILLS1, out
   E:/FightCamp/wt/GYMBILLS1_out.txt) by diff + `tests/gym_bills_test.gd`. Wire it: the weekly clock keeps cash and
   weeks-below-zero (GymBills.next_below), the MONEY page line, a NEEDS YOU flag on "warn"/"red", the close screen on
   "closed" (career summary -> load / new career), new careers start with GymBills.start_cash, a loss costs ranking and
   members. Update Lean CLAUDE.md "Decided numbers" (dues now $35/month, rent $1,800/month, start cash ~3 months).
3. Balance-check (skill): a 26-week career harness - careless (always fight, never rest) vs sensible; bounds in the plan
   (careless closes in 15-40 %, sensible under 5 %). Quick start must still offer a first bout in week 2.
4. Brief InjuryRoll (update 28) to Qwen the moment GymBills lands (plan decision 2: ~6 % a bout from the bout's damage,
   types and weeks out, England Boxing's KO ladder, training injury from the load ratio).
5. At wrap-up: move the Miro P0/P5/P6 cards (Lean CLAUDE.md step 3b), export, WHAT_TO_TRY, board question.

Skills installed (user scope): balance-check, playtest-report, design-review, godot-ui-theming,
godot-animation-tree-mastery, godot-economy-system (wallet/transactions patterns for update 27), godot-genre-simulation.
Traps: a var initialised from a function that reads a later-declared var gets null; restoring .import files under a running
editor blocks run_scene; open an agent's screenshots before quoting them (Ziva Baby generated its own).
