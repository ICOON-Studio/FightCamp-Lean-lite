Kalli - game design review, boxing management sim (FightCamp, Godot). We are adding "hit feel" to the watched fight: the captured
mocap clip stays pure for the man throwing; on a CLEAN landed blow both fighters freeze for a few frames (hit stop) and only the man
who is hit gets a short physical reaction (head/neck/upper chest), back on his clip in 0.15-0.25 s. Review these numbers for a
BROADCAST-camera boxing sim (not an arcade fighter): are they right, too much, too little? Give your numbers with a reason each.

1. Hit stop frames at 60 fps: clean head blow 4 + 8 x power (4..12); glancing = half (min 2); blocked/missed/slipped 0; body blow = 2 fewer.
2. Impulse on the struck segment (N*s) = (glove 0.45 kg + 0.5 x arm 3.5 kg) x wrist speed (m/s) x (0.5 + 0.5 x power) x contact factor
   (clean 1.0, glancing 0.45, absorbed 0.2), cap 25. Severity: < 6 light, < 14 solid, else heavy.
3. Reaction profiles: light = stiffness 50 -> 20, damping 6, recovery 0.15 s, Head only; solid = 50 -> 8, damping 4, 0.20 s, Head+Neck+
   UpperChest; heavy = 50 -> 3, damping 2, 0.25 s, + Chest. Head:torso mass 1:7 (1:6.5 heavy).
4. Should a jab ever hit-stop? Should the freeze scale with the crowd/broadcast moment (title fight, knockdown)?
Answer as long and complete as you like.
