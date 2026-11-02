G150 puts a plain-text hover on each Body Lab region and on Technical Flow's fatigue and injury-risk figures.
Training needs 80, amber is 60, and the cage needs 90 of the head, 85 of the torso and 80 of each limb. Those numbers are BodyReadiness's accessors.
A region under its cage line says it blocks a bout. A region under 80 says it blocks training.
Rest and a recovery station are measured with apply_activity on a copy at 40. On the starter boxer that week is +9 from rest, +17 from the station, and +7 more when the station is aimed at the region.
The cleared week that spends a region most is ring for the head and torso (5), bags for the arms (5) and cardio for the legs (5).
A bout writes its damage onto that number, and the next bout reads what is left.
Technical Flow adds +6 fatigue a camp week, stored from 0 to 100. The last camp week also adds -10 from the taper.
A bout is refused above 85, which is BodyReadiness.competition_fatigue_max.
A rest week changes fatigue by -15. The seven days apply -2, -2, -2, -3, -2, -2, -2.
Technical Flow's injury base is 0, so a camp week rolls no injury. Fatigue at or above 60 multiplies a non-zero camp roll by 1.5. A training week that ends at or above 95 fatigue rolls a 15 percent injury.
