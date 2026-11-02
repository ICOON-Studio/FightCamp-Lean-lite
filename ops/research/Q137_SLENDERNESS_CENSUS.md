# Q137 — Slenderness Census: Which Capsules Are Actually Balls, Across All Twelve Rigs

**Stage:** Q137 (Qwen). **Landed 2026-09-22.**
**Brief:** `research/TASK_Q137.md`.
**Instrument:** `Godot/tools/q137_slenderness_census.gd`.
**Population:** All twelve rigs from `CaptureFighterRoster.ROSTER`, each mounted
at its own stature via `FighterPhysique.height_scale`.

---

## THE POPULATION

| rig | target height |
|---|---|
| f01_m_box_welter | 1.75 m |
| f02_m_box_heavy | 1.93 m |
| f03_f_box_fly | 1.58 m |
| f04_f_box_middle | 1.74 m |
| f05_m_mma_light | 1.78 m |
| f06_m_mma_lhw | 1.89 m |
| f07_f_mma_straw | 1.59 m |
| f08_f_mma_bantam | 1.65 m |
| f09_m_bare_welter | 1.81 m |
| f10_m_bare_heavy | 1.93 m |
| f11_f_bare_feather | 1.68 m |
| f12_f_bare_welter | 1.69 m |

---

## BANDS

| r/L | band | meaning |
|---|---|---|
| `< 0.25` | SEGMENT | a clear capsule — radius well under half the length |
| `>= 0.25` and `< 0.50` | STOUT | fat but still a capsule |
| `>= 0.50` and `< 1.00` | NEEDLE | the caps meet or overlap; a one-end inset destroys it |
| `>= 1.00` (and INF) | BALL | a sphere wearing a capsule's name |

---

## BLOCK 1: PER-RIG TABLE

```
rig                      capsule                 L        r        r/L band      1-end pres%  2-end pres%
f01_m_box_welter         pelvis             0.2155   0.1671     0.7755 NEEDLE          22.5%         0.0%
f01_m_box_welter         thorax             0.2771   0.1208     0.4360 STOUT           56.4%        12.8%
f01_m_box_welter         shoulder_span      0.3685   0.0500     0.1357 SEGMENT         86.4%        72.9%
f01_m_box_welter         neck               0.0583   0.0550     0.9433 NEEDLE           5.7%         0.0%
f01_m_box_welter         head               0.1277   0.1256     0.9836 NEEDLE           3.6%         0.0%
f01_m_box_welter         upper_arm_l        0.2461   0.0711     0.2888 STOUT           71.1%        42.2%
f01_m_box_welter         upper_arm_r        0.2461   0.0689     0.2797 STOUT           72.0%        44.1%
f01_m_box_welter         forearm_l          0.2297   0.0546     0.2376 SEGMENT         76.2%        52.5%
f01_m_box_welter         forearm_r          0.2297   0.0564     0.2454 SEGMENT         75.5%        50.9%
f01_m_box_welter         femur_l            0.4170   0.1165     0.2794 STOUT           72.1%        44.1%
f01_m_box_welter         femur_r            0.4172   0.1157     0.2773 STOUT           72.3%        44.5%
f01_m_box_welter         shin_l             0.4073   0.0772     0.1896 SEGMENT         81.0%        62.1%
f01_m_box_welter         shin_r             0.4073   0.0792     0.1944 SEGMENT         80.6%        61.1%
f01_m_box_welter         foot_l             0.1652   0.0792     0.4795 STOUT           52.1%         4.1%
f01_m_box_welter         foot_r             0.1656   0.0744     0.4490 STOUT           55.1%        10.2%
f02_m_box_heavy          pelvis             0.2424   0.1998     0.8241 NEEDLE          17.6%         0.0%
f02_m_box_heavy          thorax             0.3135   0.1456     0.4644 STOUT           53.6%         7.1%
f02_m_box_heavy          shoulder_span      0.4632   0.0500     0.1079 SEGMENT         89.2%        78.4%
f02_m_box_heavy          neck               0.0795   0.0550     0.6920 NEEDLE          30.8%         0.0%
f02_m_box_heavy          head               0.1124   0.1333     1.1858 BALL             0.0%         0.0%
f02_m_box_heavy          upper_arm_l        0.2491   0.0922     0.3701 STOUT           63.0%        26.0%
f02_m_box_heavy          upper_arm_r        0.2490   0.0901     0.3619 STOUT           63.8%        27.6%
f02_m_box_heavy          forearm_l          0.3037   0.0695     0.2289 SEGMENT         77.1%        54.2%
f02_m_box_heavy          forearm_r          0.3019   0.0715     0.2368 SEGMENT         76.3%        52.6%
f02_m_box_heavy          femur_l            0.4759   0.1437     0.3020 STOUT           69.8%        39.6%
f02_m_box_heavy          femur_r            0.4759   0.1460     0.3068 STOUT           69.3%        38.6%
f02_m_box_heavy          shin_l             0.4336   0.0935     0.2156 SEGMENT         78.4%        56.9%
f02_m_box_heavy          shin_r             0.4314   0.0923     0.2139 SEGMENT         78.6%        57.2%
f02_m_box_heavy          foot_l             0.1862   0.0957     0.5139 NEEDLE          48.6%         0.0%
f02_m_box_heavy          foot_r             0.1802   0.0854     0.4740 STOUT           52.6%         5.2%
f03_f_box_fly            pelvis             0.1866   0.1553     0.8324 NEEDLE          16.8%         0.0%
f03_f_box_fly            thorax             0.2363   0.1148     0.4861 STOUT           51.4%         2.8%
f03_f_box_fly            shoulder_span      0.2959   0.0500     0.1690 SEGMENT         83.1%        66.2%
f03_f_box_fly            neck               0.0449   0.0550     1.2256 BALL             0.0%         0.0%
f03_f_box_fly            head               0.1117   0.1158     1.0364 BALL             0.0%         0.0%
f03_f_box_fly            upper_arm_l        0.2098   0.0549     0.2617 STOUT           73.8%        47.7%
f03_f_box_fly            upper_arm_r        0.2098   0.0547     0.2606 STOUT           73.9%        47.9%
f03_f_box_fly            forearm_l          0.2179   0.0465     0.2134 SEGMENT         78.7%        57.3%
f03_f_box_fly            forearm_r          0.2179   0.0467     0.2142 SEGMENT         78.6%        57.2%
f03_f_box_fly            femur_l            0.3893   0.0991     0.2545 STOUT           74.6%        49.1%
f03_f_box_fly            femur_r            0.3890   0.0999     0.2569 STOUT           74.3%        48.6%
f03_f_box_fly            shin_l             0.3650   0.0656     0.1798 SEGMENT         82.0%        64.0%
f03_f_box_fly            shin_r             0.3658   0.0630     0.1721 SEGMENT         82.8%        65.6%
f03_f_box_fly            foot_l             0.1203   0.0657     0.5461 NEEDLE          45.4%         0.0%
f03_f_box_fly            foot_r             0.1254   0.0614     0.4892 STOUT           51.1%         2.2%
f04_f_box_middle         pelvis             0.2011   0.1855     0.9225 NEEDLE           7.7%         0.0%
f04_f_box_middle         thorax             0.2624   0.1330     0.5068 NEEDLE          49.3%         0.0%
f04_f_box_middle         shoulder_span      0.3531   0.0500     0.1416 SEGMENT         85.8%        71.7%
f04_f_box_middle         neck               0.0560   0.0550     0.9821 NEEDLE           1.8%         0.0%
f04_f_box_middle         head               0.0888   0.1558     1.7538 BALL             0.0%         0.0%
f04_f_box_middle         upper_arm_l        0.2390   0.0636     0.2664 STOUT           73.4%        46.7%
f04_f_box_middle         upper_arm_r        0.2390   0.0632     0.2644 STOUT           73.6%        47.1%
f04_f_box_middle         forearm_l          0.2472   0.0563     0.2278 SEGMENT         77.2%        54.4%
f04_f_box_middle         forearm_r          0.2472   0.0572     0.2313 SEGMENT         76.9%        53.7%
f04_f_box_middle         femur_l            0.4496   0.1170     0.2602 STOUT           74.0%        48.0%
f04_f_box_middle         femur_r            0.4496   0.1137     0.2530 STOUT           74.7%        49.4%
f04_f_box_middle         shin_l             0.3962   0.0750     0.1893 SEGMENT         81.1%        62.1%
f04_f_box_middle         shin_r             0.3962   0.0732     0.1848 SEGMENT         81.5%        63.0%
f04_f_box_middle         foot_l             0.1509   0.0842     0.5576 NEEDLE          44.2%         0.0%
f04_f_box_middle         foot_r             0.1509   0.0782     0.5181 NEEDLE          48.2%         0.0%
f05_m_mma_light          pelvis             0.2145   0.1786     0.8328 NEEDLE          16.7%         0.0%
f05_m_mma_light          thorax             0.2786   0.1232     0.4421 STOUT           55.8%        11.6%
f05_m_mma_light          shoulder_span      0.3759   0.0500     0.1330 SEGMENT         86.7%        73.4%
f05_m_mma_light          neck               0.0841   0.0550     0.6539 NEEDLE          34.6%         0.0%
f05_m_mma_light          head               0.1313   0.1274     0.9708 NEEDLE           4.6%         0.0%
f05_m_mma_light          upper_arm_l        0.2303   0.0770     0.3345 STOUT           66.5%        33.1%
f05_m_mma_light          upper_arm_r        0.2303   0.0746     0.3241 STOUT           67.6%        35.2%
f05_m_mma_light          forearm_l          0.2691   0.0541     0.2011 SEGMENT         79.9%        59.8%
f05_m_mma_light          forearm_r          0.2691   0.0564     0.2097 SEGMENT         79.0%        58.1%
f05_m_mma_light          femur_l            0.4206   0.1190     0.2829 STOUT           71.7%        43.4%
f05_m_mma_light          femur_r            0.4206   0.1179     0.2803 STOUT           72.0%        43.9%
f05_m_mma_light          shin_l             0.4091   0.0812     0.1984 SEGMENT         80.2%        60.3%
f05_m_mma_light          shin_r             0.4091   0.0854     0.2088 SEGMENT         79.1%        58.2%
f05_m_mma_light          foot_l             0.1640   0.0892     0.5436 NEEDLE          45.6%         0.0%
f05_m_mma_light          foot_r             0.1640   0.0757     0.4617 STOUT           53.8%         7.7%
f06_m_mma_lhw            pelvis             0.2331   0.1976     0.8476 NEEDLE          15.2%         0.0%
f06_m_mma_lhw            thorax             0.3012   0.1648     0.5473 NEEDLE          45.3%         0.0%
f06_m_mma_lhw            shoulder_span      0.4651   0.0500     0.1075 SEGMENT         89.3%        78.5%
f06_m_mma_lhw            neck               0.0660   0.0550     0.8329 NEEDLE          16.7%         0.0%
f06_m_mma_lhw            head               0.1230   0.1368     1.1126 BALL             0.0%         0.0%
f06_m_mma_lhw            upper_arm_l        0.2377   0.0961     0.4041 STOUT           59.6%        19.2%
f06_m_mma_lhw            upper_arm_r        0.2377   0.1043     0.4386 STOUT           56.1%        12.3%
f06_m_mma_lhw            forearm_l          0.2941   0.0725     0.2467 SEGMENT         75.3%        50.7%
f06_m_mma_lhw            forearm_r          0.2941   0.0765     0.2600 STOUT           74.0%        48.0%
f06_m_mma_lhw            femur_l            0.4646   0.1435     0.3089 STOUT           69.1%        38.2%
f06_m_mma_lhw            femur_r            0.4612   0.1423     0.3086 STOUT           69.1%        38.3%
f06_m_mma_lhw            shin_l             0.4373   0.1048     0.2396 SEGMENT         76.0%        52.1%
f06_m_mma_lhw            shin_r             0.4363   0.1085     0.2487 SEGMENT         75.1%        50.3%
f06_m_mma_lhw            foot_l             0.1928   0.0912     0.4731 STOUT           52.7%         5.4%
f06_m_mma_lhw            foot_r             0.1882   0.0986     0.5241 NEEDLE          47.6%         0.0%
f07_f_mma_straw          pelvis             0.1762   0.1582     0.8977 NEEDLE          10.2%         0.0%
f07_f_mma_straw          thorax             0.2256   0.1353     0.5997 NEEDLE          40.0%         0.0%
f07_f_mma_straw          shoulder_span      0.3114   0.0500     0.1605 SEGMENT         83.9%        67.9%
f07_f_mma_straw          neck               0.0502   0.0550     1.0952 BALL             0.0%         0.0%
f07_f_mma_straw          head               0.0953   0.1459     1.5312 BALL             0.0%         0.0%
f07_f_mma_straw          upper_arm_l        0.2247   0.0610     0.2715 STOUT           72.9%        45.7%
f07_f_mma_straw          upper_arm_r        0.2247   0.0617     0.2746 STOUT           72.5%        45.1%
f07_f_mma_straw          forearm_l          0.2208   0.0440     0.1991 SEGMENT         80.1%        60.2%
f07_f_mma_straw          forearm_r          0.2208   0.0451     0.2044 SEGMENT         79.6%        59.1%
f07_f_mma_straw          femur_l            0.4061   0.1045     0.2573 STOUT           74.3%        48.5%
f07_f_mma_straw          femur_r            0.4061   0.1013     0.2495 SEGMENT         75.1%        50.1%
f07_f_mma_straw          shin_l             0.3857   0.0695     0.1801 SEGMENT         82.0%        64.0%
f07_f_mma_straw          shin_r             0.3857   0.0705     0.1827 SEGMENT         81.7%        63.5%
f07_f_mma_straw          foot_l             0.1370   0.0671     0.4894 STOUT           51.1%         2.1%
f07_f_mma_straw          foot_r             0.1370   0.0642     0.4684 STOUT           53.2%         6.3%
f08_f_mma_bantam         pelvis             0.1952   0.1687     0.8641 NEEDLE          13.6%         0.0%
f08_f_mma_bantam         thorax             0.2481   0.1369     0.5516 NEEDLE          44.8%         0.0%
f08_f_mma_bantam         shoulder_span      0.3225   0.0500     0.1550 SEGMENT         84.5%        69.0%
f08_f_mma_bantam         neck               0.0595   0.0550     0.9249 NEEDLE           7.5%         0.0%
f08_f_mma_bantam         head               0.0896   0.1381     1.5416 BALL             0.0%         0.0%
f08_f_mma_bantam         upper_arm_l        0.2326   0.0604     0.2598 STOUT           74.0%        48.0%
f08_f_mma_bantam         upper_arm_r        0.2326   0.0607     0.2608 STOUT           73.9%        47.8%
f08_f_mma_bantam         forearm_l          0.2370   0.0482     0.2036 SEGMENT         79.6%        59.3%
f08_f_mma_bantam         forearm_r          0.2370   0.0493     0.2082 SEGMENT         79.2%        58.4%
f08_f_mma_bantam         femur_l            0.4086   0.1086     0.2658 STOUT           73.4%        46.8%
f08_f_mma_bantam         femur_r            0.4086   0.1069     0.2617 STOUT           73.8%        47.7%
f08_f_mma_bantam         shin_l             0.3852   0.0746     0.1937 SEGMENT         80.6%        61.3%
f08_f_mma_bantam         shin_r             0.3852   0.0751     0.1949 SEGMENT         80.5%        61.0%
f08_f_mma_bantam         foot_l             0.1419   0.0782     0.5514 NEEDLE          44.9%         0.0%
f08_f_mma_bantam         foot_r             0.1419   0.0672     0.4735 STOUT           52.7%         5.3%
f09_m_bare_welter        pelvis             0.2215   0.1820     0.8215 NEEDLE          17.8%         0.0%
f09_m_bare_welter        thorax             0.2867   0.1408     0.4910 STOUT           50.9%         1.8%
f09_m_bare_welter        shoulder_span      0.3969   0.0500     0.1260 SEGMENT         87.4%        74.8%
f09_m_bare_welter        neck               0.0763   0.0550     0.7206 NEEDLE          27.9%         0.0%
f09_m_bare_welter        head               0.1108   0.1285     1.1594 BALL             0.0%         0.0%
f09_m_bare_welter        upper_arm_l        0.2553   0.0833     0.3264 STOUT           67.4%        34.7%
f09_m_bare_welter        upper_arm_r        0.2552   0.0780     0.3055 STOUT           69.5%        38.9%
f09_m_bare_welter        forearm_l          0.2497   0.0551     0.2206 SEGMENT         77.9%        55.9%
f09_m_bare_welter        forearm_r          0.2497   0.0555     0.2225 SEGMENT         77.8%        55.5%
f09_m_bare_welter        femur_l            0.4343   0.1248     0.2875 STOUT           71.3%        42.5%
f09_m_bare_welter        femur_r            0.4343   0.1250     0.2878 STOUT           71.2%        42.4%
f09_m_bare_welter        shin_l             0.4143   0.0788     0.1903 SEGMENT         81.0%        61.9%
f09_m_bare_welter        shin_r             0.4143   0.0828     0.1999 SEGMENT         80.0%        60.0%
f09_m_bare_welter        foot_l             0.1801   0.0946     0.5254 NEEDLE          47.5%         0.0%
f09_m_bare_welter        foot_r             0.1801   0.0838     0.4654 STOUT           53.5%         6.9%
f10_m_bare_heavy         pelvis             0.2437   0.2000     0.8207 NEEDLE          17.9%         0.0%
f10_m_bare_heavy         thorax             0.3154   0.1760     0.5581 NEEDLE          44.2%         0.0%
f10_m_bare_heavy         shoulder_span      0.5008   0.0500     0.0998 SEGMENT         90.0%        80.0%
f10_m_bare_heavy         neck               0.0700   0.0550     0.7859 NEEDLE          21.4%         0.0%
f10_m_bare_heavy         head               0.1098   0.1350     1.2298 BALL             0.0%         0.0%
f10_m_bare_heavy         upper_arm_l        0.2756   0.0983     0.3567 STOUT           64.3%        28.7%
f10_m_bare_heavy         upper_arm_r        0.2756   0.0999     0.3623 STOUT           63.8%        27.5%
f10_m_bare_heavy         forearm_l          0.2852   0.0716     0.2509 STOUT           74.9%        49.8%
f10_m_bare_heavy         forearm_r          0.2852   0.0730     0.2559 STOUT           74.4%        48.8%
f10_m_bare_heavy         femur_l            0.4646   0.1466     0.3154 STOUT           68.5%        36.9%
f10_m_bare_heavy         femur_r            0.4633   0.1492     0.3220 STOUT           67.8%        35.6%
f10_m_bare_heavy         shin_l             0.4383   0.1031     0.2353 SEGMENT         76.5%        52.9%
f10_m_bare_heavy         shin_r             0.4394   0.1002     0.2280 SEGMENT         77.2%        54.4%
f10_m_bare_heavy         foot_l             0.1925   0.1058     0.5495 NEEDLE          45.0%         0.0%
f10_m_bare_heavy         foot_r             0.1925   0.1055     0.5482 NEEDLE          45.2%         0.0%
f11_f_bare_feather       pelvis             0.2302   0.1700     0.7385 NEEDLE          26.1%         0.0%
f11_f_bare_feather       thorax             0.2905   0.1364     0.4694 STOUT           53.1%         6.1%
f11_f_bare_feather       shoulder_span      0.3550   0.0500     0.1408 SEGMENT         85.9%        71.8%
f11_f_bare_feather       neck               0.0542   0.0550     1.0145 BALL             0.0%         0.0%
f11_f_bare_feather       head               0.1102   0.1281     1.1631 BALL             0.0%         0.0%
f11_f_bare_feather       upper_arm_l        0.2575   0.0650     0.2523 STOUT           74.8%        49.5%
f11_f_bare_feather       upper_arm_r        0.2575   0.0612     0.2376 SEGMENT         76.2%        52.5%
f11_f_bare_feather       forearm_l          0.2175   0.0406     0.1868 SEGMENT         81.3%        62.6%
f11_f_bare_feather       forearm_r          0.2240   0.0396     0.1769 SEGMENT         82.3%        64.6%
f11_f_bare_feather       femur_l            0.3687   0.1015     0.2754 STOUT           72.5%        44.9%
f11_f_bare_feather       femur_r            0.3689   0.0954     0.2587 STOUT           74.1%        48.3%
f11_f_bare_feather       shin_l             0.3435   0.0667     0.1940 SEGMENT         80.6%        61.2%
f11_f_bare_feather       shin_r             0.3435   0.0673     0.1960 SEGMENT         80.4%        60.8%
f11_f_bare_feather       foot_l             0.1428   0.0805     0.5637 NEEDLE          43.6%         0.0%
f11_f_bare_feather       foot_r             0.1428   0.0687     0.4813 STOUT           51.9%         3.7%
f12_f_bare_welter        pelvis             0.2113   0.1557     0.7368 NEEDLE          26.3%         0.0%
f12_f_bare_welter        thorax             0.2715   0.1339     0.4934 STOUT           50.7%         1.3%
f12_f_bare_welter        shoulder_span      0.3164   0.0500     0.1580 SEGMENT         84.2%        68.4%
f12_f_bare_welter        neck               0.0531   0.0550     1.0352 BALL             0.0%         0.0%
f12_f_bare_welter        head               0.0963   0.1409     1.4628 BALL             0.0%         0.0%
f12_f_bare_welter        upper_arm_l        0.2574   0.0599     0.2327 SEGMENT         76.7%        53.5%
f12_f_bare_welter        upper_arm_r        0.2578   0.0590     0.2288 SEGMENT         77.1%        54.2%
f12_f_bare_welter        forearm_l          0.2456   0.0417     0.1697 SEGMENT         83.0%        66.1%
f12_f_bare_welter        forearm_r          0.2456   0.0420     0.1708 SEGMENT         82.9%        65.8%
f12_f_bare_welter        femur_l            0.3903   0.0947     0.2426 SEGMENT         75.7%        51.5%
f12_f_bare_welter        femur_r            0.3904   0.0956     0.2448 SEGMENT         75.5%        51.0%
f12_f_bare_welter        shin_l             0.3445   0.0662     0.1921 SEGMENT         80.8%        61.6%
f12_f_bare_welter        shin_r             0.3443   0.0690     0.2005 SEGMENT         79.9%        59.9%
f12_f_bare_welter        foot_l             0.1588   0.0696     0.4382 STOUT           56.2%        12.4%
f12_f_bare_welter        foot_r             0.1588   0.0644     0.4052 STOUT           59.5%        19.0%
```

---

## BLOCK 2: ROLL-UP

| capsule | nSEG | nSTOUT | nNEEDLE | nBALL | total | min r/L | med r/L | max r/L |
|---|---|---|---|---|---|---|---|---|
| shoulder_span | 12 | 0 | 0 | 0 | 12 | 0.0998 | 0.1383 | 0.1690 |
| shin_l | 12 | 0 | 0 | 0 | 12 | 0.1798 | 0.1929 | 0.2396 |
| shin_r | 12 | 0 | 0 | 0 | 12 | 0.1721 | 0.1980 | 0.2487 |
| forearm_l | 11 | 1 | 0 | 0 | 12 | 0.1697 | 0.2170 | 0.2509 |
| forearm_r | 10 | 2 | 0 | 0 | 12 | 0.1708 | 0.2183 | 0.2600 |
| femur_l | 1 | 11 | 0 | 0 | 12 | 0.2426 | 0.2774 | 0.3154 |
| femur_r | 2 | 10 | 0 | 0 | 12 | 0.2448 | 0.2695 | 0.3220 |
| upper_arm_l | 1 | 11 | 0 | 0 | 12 | 0.2327 | 0.2801 | 0.4041 |
| upper_arm_r | 2 | 10 | 0 | 0 | 12 | 0.2288 | 0.2772 | 0.4386 |
| thorax | 0 | 7 | 5 | 0 | 12 | 0.4360 | 0.4922 | 0.5997 |
| foot_l | 0 | 4 | 8 | 0 | 12 | 0.4382 | 0.5345 | 0.5637 |
| foot_r | 0 | 9 | 3 | 0 | 12 | 0.4052 | 0.4737 | 0.5482 |
| pelvis | 0 | 0 | 12 | 0 | 12 | 0.7368 | 0.8283 | 0.9225 |
| neck | 0 | 0 | 8 | 4 | 12 | 0.6539 | 0.9341 | 1.2256 |
| head | 0 | 0 | 2 | 10 | 12 | 0.9708 | 1.1744 | 1.7538 |

---

## BLOCK 3: DISAGREEMENTS

Eleven of fifteen capsules disagree across rigs:

| capsule | disagreement |
|---|---|
| **head** | BALL on 10, NEEDLE on 2 (f01 at 0.98, f05 at 0.97) |
| **neck** | NEEDLE on 8, BALL on 4 (f03, f07, f11, f12 — the four smallest statures) |
| **pelvis** | NEEDLE on all 12 — no disagreement, but never a segment either |
| **thorax** | STOUT on 7, NEEDLE on 5 (f04, f06, f07, f08, f10) |
| **foot_l** | STOUT on 4, NEEDLE on 8 |
| **foot_r** | STOUT on 9, NEEDLE on 3 (f04, f06, f10) |
| **forearm_l** | SEGMENT on 11, STOUT on 1 (f10) |
| **forearm_r** | SEGMENT on 10, STOUT on 2 (f06, f10) |
| **femur_l** | STOUT on 11, SEGMENT on 1 (f12) |
| **femur_r** | STOUT on 10, SEGMENT on 2 (f07, f12) |
| **upper_arm_l** | STOUT on 11, SEGMENT on 1 (f12) |
| **upper_arm_r** | STOUT on 10, SEGMENT on 2 (f11, f12) |

Four capsules agree on all twelve rigs: **shoulder_span** (SEGMENT), **shin_l**
(SEGMENT), **shin_r** (SEGMENT), **pelvis** (NEEDLE).

---

## WHAT THE NUMBERS SAY

### Three capsules are balls or needles on every rig

1. **head** — BALL on 10/12 rigs (median r/L 1.17). The two exceptions (f01 at
   0.98, f05 at 0.97) are NEEDLE, not STOUT — they are barely under 1.0 and
   still destroy a one-end inset (3.6% and 4.6% present). **The head is a ball
   wearing a capsule's name on every rig in the population.**

2. **neck** — NEEDLE on 8/12, BALL on 4/12. The four balls are the smallest
   statures: f03 (1.58 m), f07 (1.59 m), f11 (1.68 m), f12 (1.69 m). The
   authored radius is 0.055 m for everyone; the Neck→Head segment is shorter
   than that on the small rigs. **The neck is at best a needle and at worst a
   ball, depending on stature.**

3. **pelvis** — NEEDLE on all 12 rigs, range 0.74–0.92. A one-end inset leaves
   7.7–26.3% present; a two-end inset leaves 0.0% on every rig. **The pelvis is
   the most uniformly destroyed capsule in the set.**

### The thorax splits the population

The depth derivation (S48) brought the thorax under 0.5 on the two rigs S52
measured. But across twelve rigs it reads STOUT on 7 and NEEDLE on 5. The five
NEEDLE rigs are f04 (1.74 m female), f06 (1.89 m MMA), f07 (1.59 m female), f08
(1.65 m female), f10 (1.93 m bare-heavy). **The depth derivation does not
uniformly clear the 0.5 needle boundary.**

### The limbs are mostly clean

Shoulder_span, shins, forearms, femurs, upper arms are all SEGMENT or STOUT —
none reach NEEDLE on more than one rig. The disagreements at the SEGMENT/STOUT
boundary (femur_l on f12, forearm_l on f10) are scaling artefacts at r/L ≈ 0.25,
not structural defects.

### The feet are the surprise

foot_l is NEEDLE on 8/12 rigs and foot_r is NEEDLE on 3/12. The foot capsule
runs LeftFoot→LeftToes (or RightFoot→RightToes) and the radius is a foot
half-width. On the larger rigs the segment is long enough; on the smaller ones
it is not. **The foot is the third capsule (after head and neck) where the
abstraction breaks on a subset of the population.**

---

## REPRODUCE

```
python Godot/tools/check_scripts.py Godot/tools/q137_slenderness_census.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/q137_slenderness_census.gd
```
