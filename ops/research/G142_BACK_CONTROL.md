# G142 - Back control: from hooks-in to the tap or the escape (Grok, collected S112)

Source: Grok Expert, grok.com/c/2b00a75e-8321-43af-938a-7dd00e5f898c (22.8 KB artifact, 108 sources), condensed by
Claude. Grades: S sourced, P proxy, J judgement.

## Disposition (Claude, S112)

**ADOPT the hazard table in section 6 as the back seat's spec.** It becomes a Qwen task after Q207 (one down / one up)
lands: a back-seat census tool against the acceptance bands below, then retune the existing `back` ground seat in
`FightRealtime.gd` to the two-stage machine (control -> RNC locked). Rule from the brief: **miss a band -> retune a
lambda, never add a state.** Deferred as Grok says: crucifix/truck, crank sub-types, women's own table, a per-fighter
retention rating (one skill scalar later), standing back without hooks (stays G139 fence).
**Caveat:** every visit-level number is J. No public UFC visit-level back census exists; the S anchors are fight-level
(RNC = 7.5% of fights, 39% of subs; back = 45.5% of modern sub positions; locked RNC -> LOC 8.9 s). The implied check
(0.35 visits x 22% RNC = 7.7% of fights) is what binds; a Sportradar `backControlTime` scrape (~10 s of back per fight
implied) is the first census that could falsify it - change visit FREQUENCY then, not the exit mix.

## Prefab check (datasets)
UFCStats (free to browse, bout control only, finish strings incl. "From Back Control"); Sportradar UFC DDE
(`backControlTime`, `endingPosition` - commercial, docs public); Stellpflug 2020/2022 (904 chokes; RNC 49.1% of
chokes; 11% LOC; T&F); JCM 2025 14:7467 and Appl Sci 2026 16(4):2034 (both CC BY, finish position only); FightAlpha /
GrapplerHQ / Fight Encyclopedia scrapes (RNC 38.9-39.8% of subs); BJJ Heroes ADCC/IBJJF origin counts (grappling,
P only). **None tags visit duration or visit exits.**

## Entries (share of MMA back-takes, J on G141 + ADCC P)
Turtle ride 32 | FHL go-behind 18 | scramble 18 | standing/fence rear body-lock dumped to hooks 20 | failed sweep /
guard exposure 8 | other 4. Census band: turtle 25-40, FHL 12-25, scramble 12-25, fence/standing 15-28, sweep 5-15.

## Visit length (J)
Pooled median 18 s (P25-75 8-40, mean ~28). Hooks flat 16 s; hooks upright 22 s; body triangle 35 s; fence 28 s.
Locked RNC -> tap/LOC 6-10 s (S 8.9 s to LOC).

## Exits (share of visits, J calibrated to S fight-level counts)
RNC finish 22 | other choke 2 | GnP TKO 3 | escape to guard 24 | bottom turns to top 6 | bottom stands/sheds 20 |
top to mount 8 | ref stand-up 4 (almost all fence) | clock censors 11. A failed RNC attempt is NOT an exit.
RNC finish given a credited attempt 40% (J); fully locked figure-four 75% (J).

## Strikes
Significant head strikes landed 0.22/s in control (~2.2 per 10 s) when punching; 0.04/s while the choke is locked.
Each landed head shot x1.15 on that second's `rnc_lock` (cap x1.8) - punches set the choke. Idle back time does not
raise TKO or sub odds (FightMetric 2014, S).

## Weight class and sex
One table. Men and women submit at the same rate (Fares 2025, p=0.853); women's subs split 50/50 chokes/joints vs
men 70/30 (small n). Scale ENTRY rate by division grappling density; GnP TKO up at LHW/HW. Exit mix moves <5 points.

## Section 6 - the table (per second, competing risks; hooks + open + flat, male LW-MW)
Stage A (control): rnc_lock 0.040, other_choke_lock 0.004, gnp_tko 0.0012, esc_guard 0.014, esc_top 0.0035,
esc_stand 0.012, to_mount 0.0045, ref_stand 0.0010 (sum 0.0802, mean dwell 12.5 s).
Stage B (RNC locked): rnc_finish 0.090, rnc_fail (back to A) 0.050, esc_any 0.020 (sum 0.160, mean 6.3 s).
Other choke uses Stage B with finish 0.050.
Flag multipliers on Stage A (rnc_lock / esc_stand / esc_guard / gnp_tko / ref_stand):
body triangle 0.75/0.45/0.55/0.6/0.7; fence 0.70/1.60/0.70/0.8/2.2; upright 0.80/1.30/0.85/1.1/1.6;
HW-LHW 0.85/1.10/1.00/1.4/1.0; WSW-FLW 1.05/0.95/1.00/0.7/1.0.

## Acceptance bands (10k sim visits: baseline + 30% fence + 20% triangle + 15% upright)
Median visit 14-24 s; mean 24-36 s; RNC finish 18-26%; any sub 20-28%; GnP TKO 1.5-5%; to guard 18-30%;
stand/shed 15-28%; to top 3-10%; to mount 5-12%; ref stand 2-7%; clock 8-15%; RNC finish|attempt 32-50%;
LOC share of RNC finishes 8-15%; locked RNC -> LOC 7-11 s; sig head shots per 10 s in A 1.2-2.8;
RNC share of sim subs 36-48%; back as sub position 40-52%.
Fight-level: ~0.35 back visits/fight, ~10 s of back per fight, P(RNC finish | fight) ~0.075 (S 0.075).

## Sources (keyed)
FightAlpha 2026 (659/8,745); GrapplerHQ 2026; Fight Encyclopedia 2025; Stellpflug Phys Sportsmed 2022 and IJPAS
2020; Fares JSMPF 2025; J Clin Med 14:7467 (2025, CC BY); Almeida/Santos Appl Sci 16:2034 (2026, CC BY); Bloody
Elbow/FightMetric 2014-03-26; UFC PI book 2018; Sportradar UFC DDE docs; UFCStats; BJJ Heroes ADCC/IBJJF; G141.
