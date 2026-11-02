# TASK GOAL1 - the fighter's GOAL WITH A DEADLINE as one pure module (S238, LOOP1 slice 3)

Seat: Arena (pure module + test, cloud). Branch `arena/<chat-id>-fightcamp`, PR to master; Claude merges by diff - never the Merge
button. Model: Arena default. Discipline: BOXING (the demo). No kicks, knees, clinch, MMA in fixtures.

Operator S237 (verbatim): "Start a fighter comes in , he is setting the goals and there is a timeline for that goal ( find my a fight
within a month eg ) [...] in the meantime the player needs check the progress according the goal and minor changes due to fatigue
,stress etc". Approved (board Q-S237-1): "build it, [...] the loop , animations,workout,feeling of progrsession and improvement from
training these are what matters for now". Verdict: research/LOOP1_VERDICT_S238.md (loop step 1 + 7).
Design source: lead designer Ludo r102, `research/ludo_rx/LUDO_R102_LOOP1_raw.txt` section C (the goal card, archetypes,
ON TRACK / AT RISK / OFF TRACK, success and failure). Use its shapes; its numbers are design values, mark them so.

## Do - new `Godot/scripts/rules/FighterGoal.gd`
extends RefCounted, static funcs only, no class_name, no autoload, NO preload, NO randomness except a seeded pick
`float(absi(hash("%s|%d" % [seed, i])) % 10000) / 10000.0`. Never modify an argument; return fresh dictionaries.
1. `ARCHETYPES` const: 4 boxing goals, each {id, title, days, targets: {stat: value} and/or {"booked_fight": true}, persona line}:
   - "debut_inside_a_month" (28 days): get a pro debut booked and reach conditioning >= 65.
   - "make_the_weight" (14 days): reach the class limit weight (kg) with chin/stamina not below a floor.
   - "southpaw_answer" (21 days): technique +X and footwork +Y (stat keys the game uses: power, technique, speed, defense,
     conditioning, fight_iq - same keys as UIKit._creation_starter_stats).
   - "upset_the_gatekeeper" (35 days): a booked fight vs a higher-ranked opponent + readiness targets.
2. `pick_for(fighter: Dictionary, seed: String) -> Dictionary` - an archetype that fits him (a 0-0-0 amateur gets the debut goal; a
   heavy fighter over his class limit gets make_the_weight; otherwise the seeded pick among the rest). Returns a GOAL:
   `{id, title, start_day, deadline_day, targets, start_stats, persona_line}`.
3. `progress(goal, fighter_now: Dictionary, today_day: int, gains_rate: Dictionary) -> Dictionary` ->
   `{days_left, share_done: 0..1, projected_share: float, status: "ON_TRACK"|"AT_RISK"|"OFF_TRACK"|"MET"|"MISSED", line, per_target: [...]}`.
   - projected = current + gains_rate (per day, from the meters' gains read) x days_left, per target.
   - ON_TRACK: projected reaches 100% at least 2 days before the deadline (Ludo r102); AT_RISK: projected misses by 10-20%;
     OFF_TRACK: misses by more; MET when every target is reached; MISSED when days_left < 0 and not met.
4. `outcome(goal, met: bool) -> Dictionary` -> `{trust_delta, morale_delta, line}` (Ludo r102: success trust +25; failure: trust and
   morale drop, a walk-out warning line - design values, marked).
5. `card(goal, progress) -> Dictionary` -> the strings the UI shows: title, "DAYS LEFT 18", status word, one line per target
   ("Conditioning 58 / 65"), colour key ("cool" / "amber" / "red" / "gold").

## Tests (red on master first - paste the red line in the PR body)
New `Godot/tests/fighter_goal_test.gd` (extends SceneTree, `_initialize`, prints `FIGHTER_GOAL failures=N`, quit(1) on fail).
Population printed - three DIFFERENT boxers: a 0-0-0 male welterweight amateur (gets the debut goal), a male middleweight 3 kg over
his limit (gets make_the_weight), a female featherweight 6-1 orthodox (seeded pick). Assert: pick rules; progress ON_TRACK / AT_RISK /
OFF_TRACK / MET / MISSED each reached by a constructed case; projected uses gains_rate; days_left counts down; arguments unchanged;
same seed -> same goal. Run: `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/fighter_goal_test.gd`.
Parse gate first: `python Godot/tools/check_scripts.py Godot/scripts/rules/FighterGoal.gd Godot/tests/fighter_goal_test.gd`.

## Rules
GDSCRIPT_TRAPS.md. Create only those two files. New features ship ON (CLAUDE.md s10) - the wiring round is Claude's. THE ONE TRAP:
never delete or weaken a test to go green.

## Prior research
LOOP1_SCOPE_S237.md, LOOP1_VERDICT_S238.md, LUDO_R102_LOOP1_raw.txt (section C), TrainingMeters.gd (the gains read this consumes),
J63_PLAN_CHANGE_REPLY.md (no invented sport-science numbers - mark design values).

## What would a human do?
The fighter tells the coach "get me a fight in a month"; the coach writes the date on the whiteboard, the two numbers that must move,
and every evening looks at whether the line is heading there in time.

## Prefab check
None - our own rules.
