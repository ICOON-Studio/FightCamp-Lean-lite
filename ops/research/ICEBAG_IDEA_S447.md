# Ice bag in the corner minute - the owner's idea (S447, 2026-11-13), and what we already measured

## His words (verbatim)
"Hold-to-Cool Gauge: Give the player an Ice Bag tool during the corner phase. Holding it on the fighter rapidly drains their
Overheat / Fatigue meter, boosting stamina recovery for the next round. Dragging it the next part/limb each with its own meter
it debuffs them" / "The 'Over-Iced' Sweet Spot: Add a threshold on the meter. If the player holds the ice on past the optimal
zone (e.g., longer than 20-25 in-game seconds), the fighter gets a temporary 'Cold & Stiff' debuff for the first 30 seconds of
the next round (lowering punch speed and head movement). We need to wire this to head movement, is that possible"

## Already measured (docs/PUSHPROBE2_RESULT.md, arm E, S443, 46,800 real bouts)
Neck ice cut up to 15 % off the next round's wind drain; past 30 s the first 30 s of the next round lost 4 hand speed and 4
power. Result: cooling CHANGES results (+1.5 win points at 3 rounds, +2.5 at 6) but is NOT a decision as sized: "always ice
the whole minute" was best in 14 of 19 and 17 of 20 cells; the cold cost far less than the drain bought; the 60 s never pressed.

## Head movement: wirable
The rules already carry `head_movement` (Attrs.gd: 0.65 defence + 0.35 flexibility) and Duels uses it as the answer to power
shots, step-ins and counters (Duels.gd 20-54). "Cold & stiff" = a minus on head_movement and hand_speed for the round's first
exchange (an exchange is 30 s) - a rules change, not a 3D one; the 3D fight then shows slower slips because it shows the result.

## Claude's read (for his call)
Fun only if over-icing really costs: cold-and-stiff on HEAD MOVEMENT is the fix the S443 numbers asked for, because it costs
most against a power puncher or a counter-puncher (the opponent decides how much it hurts = a real read, not a habit). Keep
three places, not every limb: neck (wind), shoulders (hand speed/power), legs (feet); the ice competes with water, cuts and the
talk for the 60 s. Gauge shows the sweet band. Measure with the arm E harness before building: pass = no ice habit best in
more than 6 of 10 cells. Order: Ask for a fight comes first (his order; the corner-bars work was parked until it is done, Q-205).
