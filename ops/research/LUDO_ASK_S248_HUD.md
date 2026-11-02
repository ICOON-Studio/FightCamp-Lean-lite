# Ludo ask S248 - floor HUD redesign (operator rejected r112) + coach walk timing

## Part 1 - the operator's verdict on your HUD mockup (r112), verbatim
"nope .ludo keeps considering that this is a mobile game .... thats not how sim/manager games look , its very simplestic no actual
stats to make the player understand how good the fighter is , terrible design"

FightCamp is a PC deep management sim (Steam, mouse + keyboard, 1920x1080 and up). Think Football Manager, Motorsport Manager,
Two Point Museum's info panels, Out of the Park Baseball, World of Wrestling/Boxing manager games - dense, readable, number-led
panels; NOT portrait cards, leather/gold frames, round gauges or anything that reads as a phone game.

Design the TRAINING-FLOOR HUD again, as a full pixel spec I can build in Godot (Control nodes):
1. The fighter side panel (left): name, record, weight class, age; EVERY attribute we track with its number (power, speed,
   technique, defence, chin, stamina/conditioning, footwork, ring IQ - say which you'd show and how grouped), today's gains per
   attribute (+0.7 etc.), potential/ceiling indication, stamina + strain bars with numbers, current station + minutes left,
   coach on/off his station, the day-plan block he is in. How does the player read "how good is he" at a glance AND in detail?
2. The top bar: clock, day, speed controls, money, PLAN, and the new OFFICE PC button (it carries a red badge "2 NEW BOUTS"; it
   replaced the pin that floated over the office). Where does it go, what size.
3. Goal cards (day goal / week goal): number-led layout, progress as numbers and a thin bar, AT RISK / ON TRACK states.
4. Typography sizes, colours (dark warm panel palette is fine: panel #2a2019, text #f6eddc, gold #f0c233, good #4fc46a, bad red),
   row heights, spacing, panel widths in px at 1920x1080.
5. What a hover tooltip on an attribute shows (the breakdown: base, gym equipment bonus, coach bonus, fatigue penalty).
Give the longest, most complete answer you can - every number. A mockup image after the text spec is welcome, but the text spec
with numbers is what gets built.

## Part 2 - coach walk timing (a number I will not pick myself)
The coach used to "teleport": his walk across the gym was squeezed into 2.5-5 s, so on a 32 m walk he glided at 6.4 m/s. He
now walks at a human 1.5 m/s. The game clock runs 0.2 real seconds per game minute, so a 32 m walk = 21 s = ~107 game minutes
in which the fighter trains UNCOACHED (the coached bonus starts when the coach arrives). The fighter's own walks also now take
real time (the clock slows while he walks, as before).
Question: is ~100 uncoached game minutes for a cross-gym coach walk right for the design? Options I see: keep it (positioning
the coach matters - a real decision), make the clock slow down during his walk like the fighter's, or count the coached bonus
from the moment he is sent. Give your verdict with the reason.
