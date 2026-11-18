# TASK RIVALOFFER1 - offers from rival gyms and the DUCKED / OWED flags (pure rules + test, ladder v6 R9 + R6)

Status: OPEN (S517, Claude main line). Discipline: boxing. Model: qwen3-coder.
Source: ops/research/LADDERWIRE_SCOPE_S515.md stage 3 ("R9 offers from rival gyms: Accept / Not this show (once a
season) / Pass (-2 to the challenger)") and stage 2 ("DUCKED / OWED (R6) as two flags on the rival"). The approved map:
ops/research/DESIGN_LADDER1_V6_DOLA.md lines 1047-1164 (R6 "Will they say yes?", R9 "Offers from opposing gyms").
The ladder's pure rules already exist in scripts/rules/LadderRep.gd (reach_up, in_reach, far_below, expected, change,
apply, price, grey, yes_score, clock). Claude wires the game side (Region day loop, the offer card); this task is the
pure rules only.

## Contract
OWNS: scripts/rules/RivalOffer.gd, tests/rival_offer_test.gd
RED_TEST: tests/rival_offer_test.gd -> RIVAL_OFFER failures=0
REGRESSION: ladder_rep_test, ladder_points_test
VISUAL: no

## Prior research
`python ops/Tools/prior_research.py ladder offer ducked owed`. Read scripts/rules/LadderRep.gd whole (its style: static
funcs, no class_name, no preload of state scripts, plain Dictionaries), tests/ladder_rep_test.gd (the test style: SceneTree,
_check, prints `<NAME> failures=N`, quit(1) on a failure), and ops/research/GDSCRIPT_TRAPS.md.

## What would a human do?
A rival club's matchmaker rings: "our girl wants yours on the 14th". You take it, say "not this show" (you can do that
once a season with each of them, no harm done), or turn it down and the region hears you passed (-2 ladder points to the
challenger). If your boxer is hurt, resting, too heavy or already booked, turning it down costs nothing.
When a boxer ranked just above yours keeps saying No while yours is hot, she is DUCKING; two ducks in 8 weeks and she
OWES you: the next ask starts at 95, and if she still says No, she pays your boxer +3 points.

## Prefab check
None: our own ladder rules (map R6/R9); no library applies.

## The job - scripts/rules/RivalOffer.gd (extends RefCounted, static funcs, under 200 lines)
Weeks are integers (the game's week number); points are the ladder's 0-100 "rep".
1. `const PASS_COST := 2`, `const COOLDOWN_WEEKS := 8`, `const OWED_SCORE := 95`, `const OWED_PAY := 3`,
   `const DUCK_WINDOW := 8`, `const DUCK_RANK_GAP := 8` (map R6: "ranked 0-8 above").
2. `who_offers(mine: Dictionary, rivals: Array, week: int) -> Dictionary` - the rival gym that rings this week, or {}.
   mine = {"rep": int, "free": bool} (free = not booked / injured / resting / too heavy). Each rival = {"name", "rep",
   "last_offer_week" (-1 = never), "booked": bool}. A rival may offer when: not booked, her rep is BELOW mine, mine is in
   her reach (LadderRep.in_reach(her_rep, my_rep)), and week - last_offer_week >= COOLDOWN_WEEKS (or never). Of those, the
   one with the highest rep; ties by name (deterministic - never a random pick).
3. `answer(choice: String, state: Dictionary) -> Dictionary`. choice: "accept" | "not_this_show" | "pass".
   state = {"free": bool (as above), "not_this_show_used": bool (this rival, this season), "week": int}.
   Returns {"ok": bool, "booked": bool, "my_delta": int, "their_delta": int, "not_this_show_used": bool,
   "next_offer_week": int, "why": String (plain words, shown on the card)}:
   - accept: booked true, deltas 0, next_offer_week = week + COOLDOWN_WEEKS.
   - not_this_show: if not used yet this season: free, used becomes true. If already used: it counts as a pass (say so in why).
   - pass: my_delta -PASS_COST, their_delta +PASS_COST, unless state.free is false (hurt / resting / too heavy / booked):
     then 0 and why says it was free. next_offer_week = week + COOLDOWN_WEEKS.
4. `ducked(rank_gap: int, said_no: bool, my_hot: bool) -> bool` - true when she is ranked 0..DUCK_RANK_GAP places above
   (rank_gap = my_rank - her_rank, so 0..8), said No, and my boxer is hot.
5. `owed(duck_weeks: Array, week: int) -> bool` - two or more ducks within the last DUCK_WINDOW weeks.
6. `owed_answer(owed_now: bool, score: int) -> Dictionary` - {"score": OWED_SCORE if owed_now else score,
   "no_pays": OWED_PAY if owed_now else 0}: on an owed ask the score starts at 95 and a No pays my boxer +3.
7. `season_reset(rival: Dictionary) -> Dictionary` - a copy with not_this_show_used false (1 January); ducks and
   cooldowns carry over.

## tests/rival_offer_test.gd (SceneTree, prints `RIVAL_OFFER failures=N`, quit(1) on failure)
At least 16 checks, rivals with different reps and names (never two identical rivals): who_offers picks the highest-rep
eligible rival; skips booked, above-me, out-of-reach and cooling-down rivals; ties by name; {} when none. answer: accept
books; not_this_show free once then a pass; pass -2 / +2; pass free when not free; next_offer_week. ducked edges (gap 0,
8, 9, -1; not hot; said yes). owed with 1 duck, 2 in window, 2 with one outside the window. owed_answer both ways.
season_reset clears only the not-this-show flag.

## Rules for this seat
Godot only through godot_slot, headless, `--audio-driver Dummy`, `--fixed-fps 60`. Run:
`python ops/Tools/godot_slot.py run --who rivaloffer1 -- "$LOCALAPPDATA/Programs/Godot/Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tests/rival_offer_test.gd`
No screens opened. Nothing outside OWNS; never touch scripts/fight3d/. No file over 500 lines.

## The one trap
LadderRep.in_reach takes (my_rep, their_rep) from the CHALLENGER's side: here the challenger is the rival, so the call
is in_reach(her_rep, my_rep). Read reach_up before using it.
