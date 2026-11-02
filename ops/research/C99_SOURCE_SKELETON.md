# C99 source skeleton

| subject | height m | arm / height | leg / height | forearm / upper arm | shin / thigh | shoulder / height | hip / height | forearm difference | arm difference |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| source RamsterZ FBX (BindPose) | 1.627057 | 0.352265 | 0.508702 | 0.889121 | 0.944204 | 0.217573 | 0.110701 | — | — |
| f01_m_box_welter | 1.582617 | 0.318399 | 0.551586 | 0.933203 | 0.976834 | 0.246575 | 0.118809 | +4.96% | -9.61% |
| f02_m_box_heavy | 1.613149 | 0.328482 | 0.540466 | 1.219439 | 0.911068 | 0.275229 | 0.128522 | +37.15% | -6.75% |
| f03_f_box_fly | 1.476562 | 0.321226 | 0.566528 | 1.038964 | 0.937506 | 0.222222 | 0.129712 | +16.85% | -8.81% |
| f04_f_box_middle | 1.503906 | 0.325390 | 0.566093 | 1.034541 | 0.881371 | 0.236364 | 0.140909 | +16.36% | -7.63% |
| f05_m_mma_light | 1.582617 | 0.327525 | 0.544189 | 1.168602 | 0.972639 | 0.246575 | 0.127854 | +31.43% | -7.02% |
| f06_m_mma_lhw | 0.867188 | 0.324503 | 0.550294 | 1.237084 | 0.941335 | 0.283784 | 0.135210 | +39.14% | -7.88% |
| f07_f_mma_straw | 1.486573 | 0.329602 | 0.585802 | 0.982944 | 0.949687 | 0.230415 | 0.147465 | +10.55% | -6.43% |
| f08_f_mma_bantam | 0.855469 | 0.332410 | 0.561973 | 1.019049 | 0.942545 | 0.228311 | 0.146119 | +14.61% | -5.64% |
| f09_m_bare_welter | 1.611524 | 0.319532 | 0.536920 | 0.977797 | 0.953932 | 0.251161 | 0.125561 | +9.97% | -9.29% |
| f10_m_bare_heavy | 1.612514 | 0.333411 | 0.536735 | 1.034848 | 0.943377 | 0.297674 | 0.148837 | +16.39% | -5.35% |
| f11_f_bare_feather | 1.480367 | 0.334454 | 0.501485 | 0.844493 | 0.931837 | 0.250000 | 0.148220 | -5.02% | -5.06% |
| f12_f_bare_welter | 1.476562 | 0.353395 | 0.516195 | 0.954056 | 0.882779 | 0.222270 | 0.129630 | +7.30% | +0.32% |

## WHAT A PUNCH CLIP DOES ON EACH BODY

The source arm chain measured 0.573155 m (upper arm plus forearm, ending at
the source hand joint). The following is the full-extension hand-position
proxy requested for the rotation-only retarget: source chain scaled to the
fighter's measured bone height, fighter chain measured from upperarm to hand,
and fighter minus scaled source. The FBX has no separate punch-fist endpoint,
so the hand joint is the measured endpoint.

| fighter | source chain scaled to fighter height m | fighter chain m | difference m |
|---|---:|---:|---:|
| f01_m_box_welter | 0.557500 | 0.503904 | -0.053596 |
| f02_m_box_heavy | 0.568255 | 0.529891 | -0.038364 |
| f03_f_box_fly | 0.520141 | 0.474310 | -0.045831 |
| f04_f_box_middle | 0.529773 | 0.489356 | -0.040417 |
| f05_m_mma_light | 0.557500 | 0.518347 | -0.039153 |
| f06_m_mma_lhw | 0.305479 | 0.281405 | -0.024075 |
| f07_f_mma_straw | 0.523667 | 0.489977 | -0.033690 |
| f08_f_mma_bantam | 0.301351 | 0.284367 | -0.016985 |
| f09_m_bare_welter | 0.567683 | 0.514933 | -0.052750 |
| f10_m_bare_heavy | 0.568032 | 0.537629 | -0.030402 |
| f11_f_bare_feather | 0.521481 | 0.495114 | -0.026367 |
| f12_f_bare_welter | 0.520141 | 0.521810 | +0.001669 |

**MEASURED:** The source uses `Objects > Pose` with `Type=BindPose` and its
global `PoseNode/Matrix` translations, scaled by `UnitScaleFactor=1` cm to
metres. All 22 mapped source bones were found. Source height is the `head`
Z position above the lower `ball_l`/`ball_r` Z position, with no head-top
offset: 1.627057 m. Left/right upper-arm, forearm, thigh, and shin lengths
agree within 2%.

**MEASURED:** C98's heights are mesh heights (vertex max minus min). This
report's heights are bone heights (`Head` above the lower `Toes`), so the
original C98 mesh-height ratio columns are not directly comparable. The table
above recomputes all twelve fighter ratios using bone height, making those
ratios like-for-like with the source.

**INFERENCE:** With rotation-only retargeting and no IK, the negative values
in the second table mean the fighter's measured full-extension hand position
is shorter than the source clip's height-scaled chain. The largest forearm
ratio mismatch is f06 (+39.14%); the largest arm-ratio mismatch is f02
(+37.15%). These are length/proportion implications, not a frame-by-frame
measurement of a rendered punch.

**NOT FOUND:** A separate fist or fingertip endpoint in the requested mapped
chain was not used; the hand joint is the available endpoint.
