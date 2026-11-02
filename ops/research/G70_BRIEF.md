# FIGHTPLAN_DESIGN - PASS 3 (Grok, Research mode) - S66, 2026-09-24

You are on the long-running FightCamp fight-plan design task. Passes 1 and 2 (G68, G69) are done.
G69 found the engine reads almost nothing off a plan on the real-time path: `ROLE_PRIORITY_FROM_PLAN := false`,
`phase_factor` only in the old atomic engine, and the grapple path reads no plan field at all. Its order: make
existing fields live on the grapple path first, then add `seat_bias`. It declined: per-plan hurt/abandon scripts,
technique deny-lists, opponent-strength fields, a plan-level preferred_range.

## THIS PASS: the two questions still open
**Q3 - THE PLAN AND THE CORNER ARE TWO DICTIONARIES WITH NO RELATIONSHIP.** Between rounds the corner may give one
of these six instructions (real-time path); each writes the fighter's preferred range / pace for the NEXT round
only. There is no listen roll on the real-time path.
- pace cautious - "Conserve - box off the back foot"
- pace balanced - "Hold the centre"
- pace aggressive - "Push forward"
- pace balanced, range stay_long - "Stay long - stop chasing"
- pace balanced, range get_inside - "Get inside"
- pace aggressive, emphasis finish - "Go for the finish"
The plan's pace_curve is three words fixed before the bell. Design the relationship: does a corner call override
the plan, bend it, or get refused when it contradicts the plan (an out-boxer told "Get inside")? What does the
player SEE when the two disagree? What does the engine read, and when?
**Q5 - COACH LINES.** Each plan's one sentence is the player's whole understanding of it. Using the table below,
name every line that promises something the plan's own fields do not do (e.g. "body first" with a body bias
under 1.0; "footwork" when nothing reads footwork), and every pair of plans whose lines differ but whose fields
are indistinguishable. Propose a replacement line only where you can tie it to a field.

## Rules
- Do not invent a number you cannot justify; say what would set it.
- Every proposal names what READS it. A field nothing reads is decoration.
- Say what you would NOT add, and why.
- You have no checkout; everything you need is here. Do not write code.

## Deliverable
ONE markdown document titled `G70 - PLAN AND CORNER; COACH LINES THAT LIE`, ending with a line that says what is
still wrong.

## The 34 plans - id | rulesets | name | pace_curve | target_bias | phase | role_priority | coach_line
| id | rulesets | name | pace | target_bias | phase | role_priority | coach_line |
|---|---|---|---|---|---|---|---|
| boxing_out_boxer | boxing | Out-boxer | cautious/balanced/balanced | {"head": 1.0, "body": 0.7, "legs": 0.3} | standing | {"setup": "PRIMARY", "counter": "PRIMARY", "damage": "SECONDARY"} | Distance and footwork. Jab, move, make them chase you. |
| boxing_pressure | boxing | Pressure fighter | aggressive/aggressive/balanced | {"head": 0.9, "body": 1.3, "legs": 0.3} | standing | {"damage": "PRIMARY", "setup": "SECONDARY", "counter": "OPPORTUNISTIC"} | Close the distance, cut the ring, bury them in output. Body first. |
| boxing_boxer_puncher | boxing | Boxer-puncher | balanced/balanced/aggressive | {"head": 1.1, "body": 1.0, "legs": 0.3} | standing | {"damage": "PRIMARY", "setup": "PRIMARY", "counter": "SECONDARY"} | Box behind the jab, sit down on the shots that matter. |
| boxing_counter_puncher | boxing | Counter-puncher | cautious/cautious/balanced | {"head": 1.2, "body": 0.8, "legs": 0.3} | standing | {"counter": "PRIMARY", "setup": "SECONDARY", "damage": "OPPORTUNISTIC"} | Patience. Make them lead, punish every mistake. |
| kickboxing_dutch_pressure | kickboxing | Dutch pressure | aggressive/aggressive/aggressive | {"head": 0.9, "body": 1.0, "legs": 1.4} | standing | {"damage": "PRIMARY", "setup": "SECONDARY", "counter": "OPPORTUNISTIC", "control": "AVOID"} | Hands into the low kick, every time. Break the legs, sway the judges with volume. |
| kickboxing_thai_kicker | kickboxing | Thai-style kicker | balanced/balanced/aggressive | {"head": 0.7, "body": 1.4, "legs": 1.4} | standing | {"damage": "PRIMARY", "setup": "PRIMARY", "control": "SECONDARY"} | Teep to measure, body and leg kicks to break them down. |
| kickboxing_counter_striker | kickboxing | Counter striker | cautious/balanced/balanced | {"head": 1.2, "body": 0.9, "legs": 0.8} | standing | {"counter": "PRIMARY", "setup": "SECONDARY", "damage": "SECONDARY"} | Let them commit, then answer clean. Check the kick, return the hands. |
| muay_thai_khao | muay_thai | Muay Khao | cautious/aggressive/balanced | {"head": 0.9, "body": 1.4, "legs": 0.8} | any | {"control": "PRIMARY", "takedown": "PRIMARY", "damage": "SECONDARY", "counter": "OPPORTUNISTIC"} | Walk them down into the clinch. Knees, sweeps, dictate the pace from the plum. |
| muay_thai_tae | muay_thai | Muay Tae | cautious/balanced/aggressive | {"head": 0.8, "body": 1.3, "legs": 1.4} | standing | {"damage": "PRIMARY", "setup": "PRIMARY", "control": "OPPORTUNISTIC", "takedown": "AVOID"} | The kicker. Teep the rhythm, chop the legs and the body until they fold. |
| muay_thai_femur | muay_thai | Muay Femur | cautious/balanced/balanced | {"head": 1.0, "body": 1.0, "legs": 1.0} | any | {"counter": "PRIMARY", "setup": "PRIMARY", "damage": "SECONDARY", "takedown": "SECONDARY"} | The technician. Read them in round one, then time everything they throw. |
| muay_thai_mat | muay_thai | Muay Mat | balanced/aggressive/aggressive | {"head": 1.4, "body": 1.1, "legs": 0.5} | standing | {"damage": "PRIMARY", "counter": "SECONDARY", "control": "AVOID", "takedown": "AVOID"} | The puncher. Hands first, elbows close, hunt the finish. |
| wrestling_attack_rate | freestyle_wrestling,greco_roman | Pressure (attack rate) | aggressive/aggressive/aggressive | {"head": 1.0, "body": 1.0, "legs": 1.0} | ground | {"takedown": "PRIMARY", "setup": "PRIMARY", "control": "SECONDARY", "escape": "OPPORTUNISTIC"} | Hand-fight, shoot, re-shoot. Nobody keeps this pace but you. |
| wrestling_positional | freestyle_wrestling,greco_roman | Positional counter | cautious/balanced/aggressive | {"head": 1.0, "body": 1.0, "legs": 1.0} | any | {"counter": "PRIMARY", "control": "PRIMARY", "takedown": "SECONDARY", "escape": "SECONDARY"} | Win the tie-up, let them come, score off their shots. |
| wrestling_scrambler | freestyle_wrestling,greco_roman | Scrambler | balanced/aggressive/balanced | {"head": 1.0, "body": 1.0, "legs": 1.0} | any | {"escape": "PRIMARY", "transition": "PRIMARY", "takedown": "SECONDARY", "control": "SECONDARY"} | Every position is a chance. Funk out, re-attack, never settle. |
| bjj_guard_player | bjj | Guard player | cautious/balanced/balanced | {"head": 1.0, "body": 1.0, "legs": 1.0} | ground | {"transition": "PRIMARY", "submission": "PRIMARY", "control": "SECONDARY", "takedown": "AVOID"} | Pull, build the guard, sweep or submit from the bottom. |
| bjj_passer | bjj | Passer | aggressive/balanced/balanced | {"head": 1.0, "body": 1.0, "legs": 1.0} | ground | {"takedown": "PRIMARY", "transition": "PRIMARY", "control": "PRIMARY", "submission": "SECONDARY"} | Take them down or make them pull, then pass with pressure and hold the top. |
| bjj_submission_hunter | bjj | Submission hunter | balanced/aggressive/aggressive | {"head": 1.0, "body": 1.0, "legs": 1.0} | ground | {"submission": "PRIMARY", "transition": "SECONDARY", "escape": "SECONDARY", "control": "OPPORTUNISTIC"} | Points are a tiebreaker. Attack the finish from everywhere. |
| bjj_points_player | bjj | Points player | balanced/balanced/cautious | {"head": 1.0, "body": 1.0, "legs": 1.0} | ground | {"control": "PRIMARY", "transition": "PRIMARY", "takedown": "SECONDARY", "submission": "OPPORTUNISTIC"} | Score early, advance the ladder, then hold what you have. |
| judo_grip_thrower | judo | Grip-dominant thrower | balanced/aggressive/aggressive | {"head": 1.0, "body": 1.0, "legs": 1.0} | standing | {"setup": "PRIMARY", "takedown": "PRIMARY", "control": "SECONDARY", "submission": "OPPORTUNISTIC"} | Plan the grip like a throw. Win kumi-kata, then launch. |
| judo_counter_thrower | judo | Counter-thrower | cautious/balanced/balanced | {"head": 1.0, "body": 1.0, "legs": 1.0} | standing | {"counter": "PRIMARY", "takedown": "SECONDARY", "setup": "SECONDARY"} | Let them attack. Their momentum is your throw. |
| judo_newaza | judo | Ne-waza specialist | balanced/balanced/aggressive | {"head": 1.0, "body": 1.0, "legs": 1.0} | ground | {"control": "PRIMARY", "submission": "PRIMARY", "transition": "PRIMARY", "takedown": "SECONDARY"} | Any throw is a door to the ground. Pin, turn, submit. |
| karate_blitz | karate | Blitz (lead hand) | aggressive/balanced/cautious | {"head": 1.2, "body": 1.0, "legs": 0.3} | standing | {"setup": "PRIMARY", "damage": "PRIMARY", "counter": "OPPORTUNISTIC", "takedown": "AVOID"} | Take senshu early. Gyaku-zuki off the blitz, then manage the lead. |
| karate_deai | karate | Deai counter | cautious/cautious/balanced | {"head": 1.1, "body": 1.0, "legs": 0.3} | standing | {"counter": "PRIMARY", "setup": "SECONDARY", "damage": "SECONDARY"} | Meet them on the way in. Timing beats speed. |
| karate_kicker | karate | Kicker | balanced/balanced/aggressive | {"head": 1.3, "body": 1.2, "legs": 0.3} | standing | {"damage": "PRIMARY", "setup": "SECONDARY", "takedown": "OPPORTUNISTIC"} | Hunt the three-pointer. Jodan kicks and sweeps to a downed opponent. |
| tkd_cut_kick_controller | taekwondo | Cut-kick controller | cautious/balanced/balanced | {"head": 0.8, "body": 1.4, "legs": 0.3} | standing | {"setup": "PRIMARY", "counter": "SECONDARY", "damage": "SECONDARY"} | The cut kick is your jab. Own the distance, score the exchange. |
| tkd_head_hunter | taekwondo | Head-hunter | balanced/aggressive/aggressive | {"head": 1.6, "body": 0.7, "legs": 0.3} | standing | {"damage": "PRIMARY", "setup": "SECONDARY", "counter": "OPPORTUNISTIC"} | Three points beat two. Take the risk, land the head kick. |
| tkd_counter_kicker | taekwondo | Counter-kicker | cautious/cautious/balanced | {"head": 1.1, "body": 1.1, "legs": 0.3} | standing | {"counter": "PRIMARY", "setup": "SECONDARY", "damage": "OPPORTUNISTIC"} | Bounce, read the intent, answer the first kick with a better one. |
| sambo_thrower_leglock | sambo | Thrower to leg lock | aggressive/aggressive/balanced | {"head": 1.0, "body": 1.0, "legs": 1.0} | any | {"takedown": "PRIMARY", "submission": "PRIMARY", "transition": "SECONDARY", "setup": "SECONDARY"} | Throw and stay standing for four, then dive on the leg. |
| sambo_hold_player | sambo | Hold player | balanced/balanced/cautious | {"head": 1.0, "body": 1.0, "legs": 1.0} | ground | {"control": "PRIMARY", "transition": "PRIMARY", "takedown": "SECONDARY", "submission": "OPPORTUNISTIC"} | Throw for points, then hold for twenty seconds. Bank it. |
| sambo_counter_thrower | sambo | Counter thrower | cautious/balanced/balanced | {"head": 1.0, "body": 1.0, "legs": 1.0} | standing | {"counter": "PRIMARY", "takedown": "SECONDARY", "submission": "SECONDARY"} | Invite the entry, answer with the throw they never saw. |
| mma_sprawl_and_brawl | mma | Sprawl and brawl | balanced/balanced/aggressive | {"head": 1.2, "body": 1.0, "legs": 1.0} | standing | {"damage": "PRIMARY", "counter": "PRIMARY", "escape": "SECONDARY", "control": "OPPORTUNISTIC", "takedown": "AVOID"} | Keep it standing. Sprawl, get up, make them strike with you. |
| mma_wrestle_gnp | mma | Wrestle and ground-and-pound | aggressive/balanced/balanced | {"head": 1.2, "body": 1.0, "legs": 0.8} | ground | {"takedown": "PRIMARY", "control": "PRIMARY", "damage": "SECONDARY", "escape": "SECONDARY", "submission": "OPPORTUNISTIC"} | Take them down, hold them there, punish from the top. |
| mma_submission_grappler | mma | Submission grappler | balanced/balanced/aggressive | {"head": 1.0, "body": 1.0, "legs": 1.0} | ground | {"takedown": "PRIMARY", "submission": "PRIMARY", "transition": "PRIMARY", "control": "SECONDARY", "damage": "AVOID"} | Get it to the ground by any route and hunt the tap. |
| mma_clinch_boxer | mma | Clinch and dirty boxing | aggressive/aggressive/balanced | {"head": 1.0, "body": 1.3, "legs": 0.6} | any | {"control": "PRIMARY", "damage": "PRIMARY", "takedown": "SECONDARY", "counter": "SECONDARY"} | Pin them on the cage. Short shots, knees, wear them down. |
