# GRAPPLEFIX1 - the 47 played moves, pure vs as the game draws them

S399 GRAPPLEFIX1. Measured by `ops/Tools/lean_grapple_fix_table.py` (tools/grapple_orbit.gd `nofilm=1`, headless, --fixed-fps 30, bones read on Skeleton3D.skeleton_updated). **pure** = the GrappleMap recording on our women, no layers (what the board's previews showed). **game** = the belt match's drawing: GrapplePlayer contact on (GrappleDrawn placement, GrappleLimbs clearance + holds), GrapplePose IK, GrappleGrip, the browser's pacing. Each cell is `pure / game main / game r4`. Bold = over the bar.

Bars: torso inside <= 3 cm; a limb or head parked inside the other's torso/head <= 2 cm for over 0.2 s; one-frame pop <= 3 cm; jerk p95 <= 60 m/s^3; direction flips <= 0.1 /s per bone. Sorted worst first by the game arm on `main`.

- game `main`: **2/47** moves pass every bar
- game `r4`: **9/47** moves pass every bar
- pure: 1/47

**source** (last two columns) = GrappleMap's own figure as played, measured the same way with its viewer's thickness (joint spheres + limb midpoint radii from Eelis/GrappleMap src/positions.cpp and src/players.hpp), so a move where the source is clear and ours is not is OUR mapping's fault.

| move | kind | torso cm | park cm | pop cm | jerk | flips/s | source torso / park cm | fails (game r4) |
|---|---|---|---|---|---|---|---|---|
| 1140 Drop Seoi Nage | takedown | **7.7** / **5.6** / **6.9** | **16.0** / **6.6** / **8.3** | 0.0 / **26.4** / 0.0 | **78** / **2268** / **665** | 0.09 / **1.39** / **0.32** | 2.9 / 6.2 | torso_in_m, limb_park_m, jerk_p95, flips_s |
| 1470 Leg Weave Takedown | takedown | **4.3** / **4.8** / **4.2** | **10.0** / **7.9** / **14.1** | 0.0 / 0.0 / 0.0 | **69** / **2085** / **1047** | 0.04 / **0.97** / **0.29** | 1.4 / 4.0 | torso_in_m, limb_park_m, jerk_p95, flips_s |
| 1198 Hail Mary Escape | advance | **22.7** / **6.5** / **4.0** | **17.0** / **7.2** / **9.0** | 0.0 / **9.4** / 0.0 | **75** / **920** / **429** | 0.08 / **0.55** / **0.19** | 4.5 / 7.8 | torso_in_m, limb_park_m, jerk_p95, flips_s |
| 680 To Perpendicular Triangle | advance | 1.9 / 0.0 / 0.0 | **17.6** / **14.7** / **5.2** | 0.0 / 0.0 / 0.0 | **62** / **509** / **321** | 0.00 / **0.84** / **0.37** | 0.0 / 10.8 | limb_park_m, jerk_p95, flips_s |
| 727 To Mounted Arm Triangle | sub | **6.4** / **4.9** / **3.1** | **14.2** / **7.4** / **6.0** | 0.0 / 1.2 / 0.0 | 30 / **514** / **184** | 0.00 / **0.91** / **0.34** | 3.4 / 6.8 | torso_in_m, limb_park_m, jerk_p95, flips_s |
| 1629 Roll To Guard | advance | **6.5** / **3.7** / 1.8 | **15.2** / **12.7** / **8.8** | 0.0 / **21.4** / 0.0 | 11 / **239** / **128** | 0.00 / **0.23** / **0.20** | 4.7 / 8.8 | limb_park_m, jerk_p95, flips_s |
| 620 Crossface | mount | 1.8 / **4.4** / 1.5 | **11.4** / **6.6** / **8.6** | 0.0 / 0.0 / 0.0 | 22 / **464** / **133** | 0.02 / **0.73** / 0.09 | 0.0 / 4.7 | limb_park_m, jerk_p95 |
| 1294 Helicopter | sweep | 0.0 / 0.0 / 0.0 | **12.2** / **2.4** / **7.7** | 0.0 / 0.0 / 0.0 | 17 / **685** / **585** | 0.01 / **0.50** / **0.21** | 0.0 / 4.9 | limb_park_m, jerk_p95, flips_s |
| 1170 Bottom Goes For Single | advance | **4.4** / 1.2 / 0.0 | **9.4** / **2.2** / 0.0 | 0.0 / 0.0 / 0.0 | 29 / **323** / **152** | 0.04 / **1.10** / **0.32** | 0.0 / 3.1 | jerk_p95, flips_s |
| 726 Wiggle Out | advance | **11.8** / **3.2** / 0.0 | **15.7** / **12.8** / **15.8** | 0.0 / 0.0 / 0.0 | 24 / **249** / **169** | 0.03 / **0.68** / **0.35** | 4.4 / 7.4 | limb_park_m, jerk_p95, flips_s |
| 1029 Tap | advance | **6.2** / **3.7** / 1.7 | **15.1** / **12.4** / **10.9** | 0.0 / 0.0 / 0.0 | 30 / **378** / **242** | 0.05 / **0.31** / **0.18** | 0.0 / 5.2 | limb_park_m, jerk_p95, flips_s |
| 690 Pendulum Sweep Start | advance | 0.0 / 0.0 / 0.0 | **15.8** / **14.8** / **12.5** | 0.0 / 0.0 / 0.0 | 8 / **220** / 48 | 0.00 / **0.45** / 0.06 | 0.0 / 6.4 | limb_park_m |
| 1368 Leg Hook Sweep | sweep | **13.5** / **7.3** / **5.4** | **12.9** / **4.3** / **2.6** | 0.0 / 0.0 / 0.0 | 13 / **524** / **252** | 0.00 / **0.32** / 0.08 | 2.3 / 5.9 | torso_in_m, limb_park_m, jerk_p95 |
| 622 Escape | sweep | 2.6 / 2.6 / 1.4 | **13.0** / 0.8 / 0.9 | 0.0 / 0.0 / 0.0 | 4 / **174** / 29 | 0.00 / **1.05** / 0.03 | 0.0 / 8.5 |  |
| 856 To Seated Lower Back Control | sweep | **13.6** / **4.9** / 2.9 | **13.4** / **12.4** / **5.7** | 0.0 / 0.0 / 0.0 | 25 / **225** / **140** | 0.00 / **0.37** / **0.16** | 3.2 / 6.9 | limb_park_m, jerk_p95, flips_s |
| 693 To Arm Lock | sub | 0.0 / 0.0 / 0.0 | **11.0** / **9.8** / **10.4** | 0.0 / 0.0 / 0.0 | 18 / **100** / 35 | 0.00 / **0.43** / 0.10 | 0.0 / 4.0 | limb_park_m |
| 702 Top Posts, Bottom Kimuras | sweep | **10.8** / **4.0** / 2.2 | **14.2** / **5.1** / 1.1 | 0.0 / 0.0 / 0.0 | 12 / **322** / **243** | 0.00 / **0.26** / **0.24** | 8.8 / 9.3 | jerk_p95, flips_s |
| 2041 To Twister Roll Start | advance | **5.9** / **3.4** / 1.7 | **11.3** / **13.1** / **12.6** | 0.0 / 0.0 / 0.0 | 11 / **93** / **62** | 0.00 / **0.26** / **0.17** | 2.0 / 5.2 | limb_park_m, jerk_p95, flips_s |
| 1683 Fireman | takedown | **6.7** / **5.0** / 3.0 | **11.4** / 1.9 / **2.8** | 0.0 / 0.0 / 0.0 | 15 / **389** / **131** | 0.00 / **0.24** / **0.39** | 2.8 / 4.2 | limb_park_m, jerk_p95, flips_s |
| 695 Hip Bump | sweep | **5.6** / **4.3** / 0.2 | **14.7** / **4.6** / **4.7** | 0.0 / 0.0 / 0.0 | 8 / **219** / **66** | 0.00 / **0.34** / **0.11** | 0.0 / 2.7 | limb_park_m, jerk_p95, flips_s |
| 698 To Seated Full Guard Guillotine | sub | **6.4** / 3.0 / 1.3 | **10.1** / **3.5** / 1.1 | 0.0 / 0.0 / 0.0 | 19 / **225** / **96** | 0.02 / **0.42** / 0.06 | 6.9 / 5.0 | jerk_p95 |
| 988 Shrimp Escape | advance | 1.5 / 1.5 / 1.2 | **14.3** / **7.7** / **5.7** | 0.0 / 0.0 / 0.0 | 17 / **259** / **68** | 0.00 / **0.13** / 0.05 | 0.0 / 3.6 | limb_park_m, jerk_p95 |
| 637 To Side | sub | **11.3** / **3.2** / 1.4 | **11.0** / **5.5** / **5.1** | 0.0 / 0.0 / 0.0 | 8 / **116** / 45 | 0.00 / **0.39** / 0.09 | 5.5 / 7.0 | limb_park_m |
| 731 Sweep | sweep | 0.0 / 0.0 / 0.0 | **5.3** / 0.0 / 0.0 | 0.0 / 0.0 / 0.0 | 20 / **200** / **122** | 0.02 / **0.42** / **0.18** | 0.0 / 2.9 | jerk_p95, flips_s |
| 759 Backtake | back | **7.7** / **4.8** / 3.0 | **13.5** / **6.9** / **2.9** | 0.0 / 0.0 / 0.0 | 13 / **171** / **84** | 0.00 / **0.16** / **0.12** | 4.4 / 5.3 | limb_park_m, jerk_p95, flips_s |
| 922 To Half | advance | 1.5 / 0.0 / 0.0 | **13.0** / **5.8** / 0.4 | 0.0 / 0.0 / 0.0 | 15 / **171** / **76** | 0.00 / **0.25** / 0.08 | 2.6 / 6.7 | jerk_p95 |
| 688 Rotate | advance | 1.9 / 0.0 / 0.0 | **13.7** / **11.3** / **2.5** | 0.0 / 0.0 / 0.0 | 47 / **73** / 49 | 0.00 / 0.00 / 0.00 | 0.0 / 7.9 | limb_park_m |
| 990 To Full Guard | advance | 0.0 / 0.0 / 0.0 | **12.0** / 0.0 / 0.0 | 0.0 / 0.0 / 0.0 | 20 / **136** / 44 | 0.00 / **0.45** / 0.03 | 0.0 / 0.0 |  |
| 1138 Top Lets Bottom Push Leg | pass | **5.0** / 1.4 / 0.0 | **14.3** / 1.9 / 0.6 | 0.0 / 0.0 / 0.0 | 16 / **121** / 28 | 0.00 / **0.36** / 0.00 | 0.0 / 3.3 |  |
| 863 Bottom Rolls Onto Side And Snatc | advance | **9.6** / **4.2** / 2.2 | **11.3** / **5.0** / **2.6** | 0.0 / 0.0 / 0.0 | 26 / **106** / **81** | 0.00 / **0.14** / 0.05 | 5.3 / 4.2 | limb_park_m, jerk_p95 |
| 1190 Top Pushes | sweep | **5.6** / 3.0 / 1.5 | **13.3** / **6.1** / **3.5** | 0.0 / 0.0 / 0.0 | 17 / **107** / **79** | 0.00 / 0.03 / 0.00 | 3.4 / 4.0 | limb_park_m, jerk_p95 |
| 860 Bottom Turns Away, Top Gets Seat | back | **7.0** / 1.1 / 0.0 | **15.2** / **2.3** / 0.0 | 0.0 / 0.0 / 0.0 | 25 / **192** / **149** | 0.00 / **0.11** / 0.00 | 10.9 / 8.5 | jerk_p95 |
| 1235 To 50/50 | advance | 0.0 / 0.0 / 0.0 | **11.3** / **5.5** / **6.7** | 0.0 / 0.0 / 0.0 | 42 / **88** / **81** | **0.11** / **0.12** / **0.11** | 0.0 / 4.4 | limb_park_m, jerk_p95, flips_s |
| 619 Sweep Finish | mount | **8.2** / **4.4** / 2.5 | **13.2** / **3.2** / **2.3** | 0.0 / 0.0 / 0.0 | 18 / **130** / **70** | 0.00 / **0.11** / 0.09 | 2.0 / 4.3 | limb_park_m, jerk_p95 |
| 781 Pass | pass | **5.3** / **3.9** / 2.2 | **13.5** / **5.0** / **3.9** | 0.0 / 0.0 / 0.0 | 6 / **84** / **67** | 0.00 / 0.04 / 0.04 | 0.7 / 4.0 | limb_park_m, jerk_p95 |
| 1217 Bottom Bails | advance | 0.0 / 0.0 / 0.0 | **11.7** / **4.3** / 0.0 | 0.0 / 0.0 / 0.0 | 24 / **112** / **81** | 0.00 / **0.11** / 0.10 | 0.0 / 4.9 | jerk_p95 |
| 1314 Top Drops To Side | advance | 0.0 / 0.0 / 0.0 | **15.7** / **2.9** / 1.5 | 0.0 / 0.0 / 0.0 | 31 / **124** / 33 | 0.00 / **0.15** / 0.03 | 0.0 / 5.7 |  |
| 1943 To Front Headlock Vs Single | advance | **8.5** / **3.8** / 1.9 | **6.2** / **4.0** / 0.0 | 0.0 / 0.0 / 0.0 | 39 / **102** / 33 | 0.00 / 0.04 / 0.07 | 0.0 / 6.4 |  |
| 623 Upa Escape | advance | **5.0** / 3.0 / 0.2 | **9.8** / **2.9** / **2.1** | 0.0 / 0.0 / 0.0 | 18 / **126** / 43 | 0.04 / **0.14** / 0.07 | 0.0 / 3.1 | limb_park_m |
| 755 Step Over | advance | **5.8** / **4.0** / 2.4 | **16.1** / **2.2** / 1.7 | 0.0 / 0.0 / 0.0 | 16 / **133** / **93** | 0.00 / **0.11** / 0.04 | 7.1 / 4.7 | jerk_p95 |
| 886 Omoplata | sub | 2.2 / 1.8 / 0.7 | **13.9** / 1.9 / 1.1 | 0.0 / 0.0 / 0.0 | 24 / **139** / **61** | 0.01 / **0.12** / 0.03 | 0.0 / 6.0 | jerk_p95 |
| 954 To Honey Hole | advance | 0.0 / 0.0 / 0.0 | **13.2** / **2.2** / 0.0 | 0.0 / 0.0 / 0.0 | 10 / **79** / 56 | 0.00 / **0.18** / 0.08 | 0.0 / 4.2 |  |
| 664 Bottom Gets To Knees | advance | 0.8 / 0.0 / 0.0 | **10.3** / 0.8 / 0.0 | 0.0 / 0.0 / 0.0 | 23 / **110** / **69** | 0.00 / **0.13** / 0.03 | 6.7 / 6.2 | jerk_p95 |
| 656 Aldo Pass | mount | **5.0** / **4.1** / 2.6 | **11.9** / 1.7 / 1.2 | 0.0 / 0.0 / 0.0 | 10 / **73** / 32 | 0.00 / **0.11** / 0.05 | 0.0 / 5.4 |  |
| 1295r To Double Unders W/ Feet On Hips | advance | - / 0.0 / 0.0 | - / 0.0 / 0.4 | - / 0.0 / 0.0 | - / **66** / **69** | - / 0.00 / 0.00 | 1.6 / 3.5 | jerk_p95 |
| 1295 To Posture Broken Seated Butterf | advance | 0.0 / 0.0 / 0.0 | **15.7** / 0.0 / 0.4 | 0.0 / 0.0 / 0.0 | 31 / 55 / 50 | 0.00 / 0.00 / 0.00 | 1.6 / 3.5 |  |
| 787 Pin Knee | advance | 0.0 / 0.0 / 0.0 | 0.0 / 0.0 / 0.0 | 0.0 / 0.0 / 0.0 | 11 / 24 / 28 | 0.00 / 0.00 / 0.00 | 0.0 / 0.0 |  |

