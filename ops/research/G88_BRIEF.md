# G88 - THE CROWDED FLOOR: how many members does a combat gym's floor carry at once? (Research, no code) - FightCamp, 2026-09-24

FightCamp is a combat-sports gym management game (Godot). You can read the repo through your GitHub connector (this brief
is research/G88_BRIEF.md). S69 shipped your own G74 slice one: members = a SHARE of a city pool, and CROWDING - the
fight team's training yield falls when (fighters + members x peak_fraction) exceeds the floor's station capacity. Every
crowding number is INVENTED (Godot/assets/data/membership.json: crowd_peak_fraction 0.15, crowd_yield_slope 0.3, floor
0.6), because J8 N10 found no combat-gym utilisation figure. We want real numbers before slice two.

## The questions
PEAK SHARE: of a combat gym's members, what share is on the floor in the busiest slot (evening class)? Class-attendance
data from gym software vendors (Gymdesk, Zen Planner, Mindbody, Glofox, PushPress, Spark Membership), BJJ/MMA/boxing gym
owner surveys, fitness-industry utilisation (IHRSA/HFA peak-hour share) - say which transfers and how far.
CLASS SIZE AND KIT: typical class size in a boxing / Muay Thai / BJJ / MMA class; members per heavy bag, per ring, per
mat square metre at a full class; the point at which owners add a class or kit (waitlists, capped classes).
WHAT CROWDING COSTS: any evidence that a packed class trains worse - rounds per bag, coach attention per student, injury
rate vs mat density (BJJ collisions), pros leaving busy gyms for quiet sessions; how fight teams are scheduled around
member classes (separate pro sessions, open mat).
HOW GAMES MODEL IT: gym/fitness management games (Gym Simulator, Punch Club 2, Two Point Hospital-style queues,
Football Manager training facilities) - how capacity and crowding reduce output.
WHAT THE ENGINE SHOULD GATE: a table - peak share band, members per station at "full", the overload at which training
quality measurably drops and by how much - each figure with its source, NOT FOUND where there is none.

## Deliverable
ONE markdown document titled "G88 - THE CROWDED FLOOR", sources inline, ending with one line saying what is still unknown.
PASTE THE WHOLE DOCUMENT IN THE CHAT as your reply (the operator cannot open files in your sandbox).
