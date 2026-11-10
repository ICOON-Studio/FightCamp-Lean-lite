# Cornerman's dream fight screen (S419): what a corner expects and the game does not have

Drawing: fight_dream_corner.png. Gold NEW = needs something the game lacks today. Untagged = exists (the first drawing's elements). Known flaw: the jaw and gut rings sit tight against the tanks.

Ranked by how much a corner misses it.

1. Ring position and distance map (medium). What: a small top-down ring with both boxers, the corners and a line for the gap. Needs: a position and range state per exchange. The pack lists places (outside, long, mid, inside, clinch, ropes) in the plan, so the data partly exists; whether it is held live per exchange is unsure. Why: a corner shouts "off the ropes", "get out of the corner", "cut the ring". Changes: Jab and move vs Tie up vs Draw the lead; shows who is pinned.
2. Opponent's corner call (medium). What: the other corner's shout, shown as a chip. Needs: an AI call per exchange, a rule that shifts the opponent's edge. Why: a corner reads the other stool and expects to be answered. Changes: answer it with the counter call.
3. Heart rate and breathing (medium). What: a heart number with a pulse line, faster as energy falls. Needs: a derived value from energy, drain and effort, and a recovery curve between rounds. Why: corners judge recovery by breathing, not a bar. Changes: Breathe vs Push, and whether the minute is enough.
4. Referee warnings (small to medium). What: pips for warnings (holding, low blow) and a point deduction. Needs: a referee rule module and fouls. Unsure the game has fouls at all. Changes: stop clinching, pick Tie up less.
5. Judges' live cards (medium). What: three small estimates per judge, one unknown. Needs: per-judge scoring noise; the pack has three judges after the bout and an estimate before. Why: a corner knows the round is close. Changes: Push in a close round, Save in a lead.
6. Second voice in the corner (medium). What: the assistant's suggestion chip beside the head coach's call. Needs: a staff-skill-driven tip, sometimes wrong. Why: a real corner has two voices. Changes: choose between them; a skilled assistant makes the hint more right.
7. Towel (small). What: a throw-in button, never pre-selected. Needs: a stoppage rule for corner stoppage with a morale and record cost. Why: protecting a boxer is the corner's duty. Changes: ends a lost fight early (pack: an AGREED stop-or-go card exists for cuts, not built).
8. More body places: jaw and solar plexus (small data, medium rules). Needs: places in damage, with knockout weight for the jaw and wind for the plexus. Why: the corner calls "watch the jaw" and "to the gut". Changes: Hands up vs Go to the body targets.
9. Cutman kit in the minute (not on this screen): water, ice, swab by place (the pack has RECOVER with 3 points and a cutman job already, so only per-place variety is new).

Build first: the ring map. The other items add a number; this one changes which call is right in the next 30 seconds.
