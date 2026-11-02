# G75 - STRIKE SPEEDS: how fast and how long each real strike is (Grok, research) - S67, 2026-09-24

FightCamp is a combat-sports gym management game (Godot) with a 3D fight room that plays retargeted strike clips. The
operator watched the latest recording and said, verbatim: "still some moves are being executed extremely fast like uh,
elbows ... weird uh, hand movement". Our own agents then measured our clips against their vendor sources and found the
retarget is faithful (a strike runs ~0.88x its source), elbows peak at <= 1.18x their source, and one body kick reads
9.6x - which turned out to be measuring the STANDING foot. So every comparison so far has been clip-vs-clip. Nobody has
put a REAL number beside it. This brief asks for the real numbers. Research only - no code.

## The questions
1. **Peak effector speed (m/s) by strike class, measured on real athletes**: jab, cross, lead hook, rear hook, uppercut,
   overhand, horizontal elbow, upward elbow, spinning back elbow, straight knee, jumping knee, teep/front kick, low
   roundhouse (thigh), body roundhouse, head roundhouse, spinning back kick. Say WHICH point was tracked (fist/wrist,
   elbow tip, knee, foot/shin/ankle), the method (optical mocap, IMU, high-speed video), the population (elite/amateur,
   n, sex, discipline) and the source (peer-reviewed first: e.g. Journal of Sports Sciences, Sports Biomechanics, PLoS
   One, IJPAS; then theses; then broadcast/sports-science features). Give the range, not one number.
2. **Duration**: time from movement onset to impact, and impact to return/recovery, by the same classes. The operator's
   complaint is about READABILITY - so: how long is a real elbow on screen at 30 fps, and what makes a fast real strike
   READ on a broadcast (anticipation/wind-up frames, contact hold, follow-through)?
3. **How shipped fight games present strike speed** (EA UFC 3/4/5, Fight Night Champion, Tekken/Street Fighter frame
   data, Undisputed): do they play strikes at real speed, slow them, add anticipation or hit-stop frames? What did players
   say about strikes looking "too fast" or "floaty" (link reviews/forums/GDC talks)?
4. **What the game should gate**: for each class, the real band a clip's peak effector speed should sit inside, and the
   minimum on-screen duration below which a strike stops reading - each figure with its source, NOT FOUND where there is
   none. Say plainly which classes have no measured source.

## Deliverable
ONE markdown document titled `G75 - STRIKE SPEEDS`, sources inline, PASTED IN THE CHAT as your reply (the operator
cannot open files in your sandbox), ending with one line saying what is still unknown.
