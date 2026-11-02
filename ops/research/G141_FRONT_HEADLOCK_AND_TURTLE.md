# G141 - Front headlock and turtle: where stuffed shots go (S103)

Owner: grok (Expert). Collected S104 2026-09-27 from grok.com/c/6e3aa2b9-ca0b-4963-82bc-b4d8dda83979 (artifact
`G141_FRONT_HEADLOCK_AND_TURTLE.md`, 16.2 KB, 116 sources). Claude's CONDENSED transcription - every figure and grade
kept, prose and table layout trimmed. Grades: S sourced, P proxy (BJJ/wrestling graph, adjacent UFC stat), J judgement.

## What would a human do? (Grok's coach and coder frames)
Coach: after a stuffed shot the sprawler's first job is the head - snap it, cut an angle, then choke (guillotine /
D'Arce / anaconda), go behind, flatten and pound, or let him stand. The shooter's first job is a post and a hip: stand
(hand-fight, come up on the fence), sit out, re-shoot a single, or turtle and wait. FHL and turtle are short decision
states, not rest. Coder: FightMetric/Sportradar do not tag them; our engine resets stuffed shots to distance or dumps
them into guard, deleting the two commonest landings and the exits they feed (guillotine, back take, snap-down, stand-up).

## Prefab check (Grok)
No licensed public dataset tags FHL or turtle as MMA positions. UFCStats: Distance/Clinch/Ground only, subs typed
(RNC, Guillotine, Triangle, Arm Triangle, Other Choke). Sportradar UFC 5.0 enum: FHL falls in clinch/miscGround, turtle in
miscGround (commercial, counts not public). BJJ Graph (bjjgraph.org): FHL/turtle top/bottom with "% of attempts", method
unpublished -> P. GrappleMap (GitHub Eelis/GrappleMap, open source): positions, no MMA frequencies. Fightnomics:
guillotine attempt vs finish. A real census needs film coding; until then G138 priors + UFC sub shares + BJJ Graph mixes.

## 1. Entries (share of stuffed shots; G138 priors, all J)
FHL 20% (15-25) | turtle 12% (10-15) | reset to distance / separate 45-55% | fence clinch (G139) 10-15% | one down, one
up (G140) 5-8% | dump to guard 3-6% (over-represented in our engine). Other entries: failed guard pull -> FHL (small);
sweep/granby fail -> turtle or FHL (P/J); knockdown, man turtles -> turtle, higher TKO hazard (J); snap-down from collar
tie -> FHL, BJJ Graph 60% of committed snaps (P); seatbelt lost -> turtle, BJJ Graph 55% (P).
Census acceptance (>=300 UFC 2022-2026 stuffed shots): FHL 15-25%, turtle 10-15%, distance reset 40-60%.

## 2. FHL exits (MMA pocket 6-18 s, median 10 s, J; BJJ Graph mat dwell 15-90 s is not UFC)
| Exit | Share | Median s | Notes | Grade |
|---|---:|---:|---|---|
| Guillotine attempt | 28% | 4-8 | finish-given-attempt 13-17% (Fightnomics 2024 13%, hist ~17%, FM 2006-13 13.6%); shallow 8-12%, deep 20-25% | S rate, J share |
| D'Arce / anaconda attempt | 10% | 6-12 | D'Arce 2.8% + anaconda 2.3% of 1,659 UFC subs (GrapplerHQ); once locked treat 15-25% | S share, J |
| Go-behind / back take | 18% | 5-10 | BJJ Graph FHL->back 14% of top attempts; hooks-in 50-65% if it lands | P/J |
| Snap-down to mat | 12% | 3-8 | lands turtle or side | J |
| Bottom stands | 18% | 6-14 | BJJ Graph technical stand 16% + stand-and-circle 11% of attempts | P/J |
| Re-shot / single | 6% | 4-8 | | J |
| Referee stand-up | 5% | 12-20+ | only if both stall | J |
| Other (necktie, crucifix, separate) | 3% | - | neckties <1% of UFC finishes | S/J |
Guillotine: most attempted UFC sub family, 2nd commonest tap (~17.7%, 293/1,659) - high volume, low conversion.

## 3. Turtle exits (MMA 5-15 s typical, J; a static turtle draws a warning then a stand-up)
| Exit | Share | Median s | Notes | Grade |
|---|---:|---:|---|---|
| Back taken (seatbelt + a hook) | 30% | 6-12 | BJJ Graph 60% when chosen; sit-outs cut it | P/J |
| Bottom stands | 28% | 5-12 | primary MMA goal; fence helps | J |
| Sit-out / roll to guard | 16% | 3-8 | punished if the roll shows the back | P/J |
| Top circles to FHL | 12% | 4-8 | BJJ Graph 55% when chosen | P/J |
| GnP stoppage | 3-5% of visits | 8-20 | flattened/crucifix turtle is the TKO shape, not a tight shell | J |
| Referee stand-up | 8% | 15-25 after warning | ABC 2025: stand when neither shows real, sustained effort to finish; position alone not enough | S rule, J |
| Crucifix / other | 2% | - | | J |
Two hooks + seatbelt = back control (existing machine); one hook, no harness = still turtle.

## 4. Legal strikes (Unified Rules, ABC, grounded rewrite effective 1 Nov 2024) - S
Grounded = any body part other than hands or feet on the canvas (hands-down on the soles is NOT grounded). FHL with the
shooter on a knee, and a tight turtle, are grounded: knees/kicks to the head ILLEGAL; punches/elbows to the head legal
(12-6 elbows legal since Nov 2024); knees to the body legal. Shooter posting on hands and feet only: not grounded, head
knees legal - the "knee on the way up". What the top man throws (J, landed per 10 s): FHL 2-4 (short punches, forearm,
body knee); turtle beside/on hips 3-6 punching, 0-1 hunting hooks; flattened/crucifix 6-12 (where TKOs happen). No soccer
kicks or head knees under Unified Rules; ONE Championship differs - a ruleset flag, out of scope.

## 5. Weight class and sex
Same entries and exits for all (J). Hazard shifts modestly: heavier -> more flattened-turtle GnP TKO, fewer choke
finishes; lighter and women -> more submission share (S/P). UFC subs ~19.3% of fights (1,659/8,591); women 21.1% vs men
17.3% (2014-17); takedown density by class small (eps^2 0.005-0.007, 8,461 bouts, BMC 2026). Keep ONE table; scale GnP
TKO up with weight and choke finish down (J).

## 6. Smallest sim addition
Two states: FHL (top has head+arm, bottom bent on a knee or both; no hooks, no guard) and TURTLE (bottom on knees and
hands, back exposed, no hooks). Deferred flags: FHL `posture` (standing FHL), TURTLE `flat` (raises GnP TKO, lowers
stand-up).
From a stuffed shot: FHL 0.20, TURTLE 0.12, G139 fence 0.12, G140 one-down 0.06, distance 0.50.
FHL per-second hazards (residual = stay, median ~10 s): GUILLOTINE_ATT 0.032, DARCE_ANACONDA_ATT 0.011, GO_BEHIND 0.020
(-> back or G140), SNAP_TO_MAT 0.014 (-> turtle, flat), BOTTOM_STAND 0.020 (-> distance / G139 at the fence), RESHOOT
0.007, REF_STAND 0.004 after t>12 s. A guillotine attempt then: finish 0.13 (0.20 locked deep), else scramble 0.45 back
to FHL / 0.35 bottom stands / 0.20 guard.
TURTLE per-second (median ~8 s): BACK_TAKE 0.038, BOTTOM_STAND 0.035, SITOUT_TO_GUARD 0.020, TO_FHL 0.015, GNP_TKO 0.004
(raise with `flat` or head damage), REF_STAND 0.008 after t>15 s.
Strike overlay: grounded by default in both - head-knee rate 0; posting to the feet flips grounded off for 1-2 s.

**Acceptance for a census:** stuffed shot -> FHL 15-25%, -> turtle 10-15%; FHL median 8-12 s, turtle 6-12 s; FHL ->
guillotine attempt 22-32% of exits; guillotine attempt -> finish 12-18%; turtle -> hooks-in 25-35%, -> stand 22-35%,
-> referee stand-up 5-12%, -> TKO 2-6% of visits; head knees landed on a turtle = 0.
Deferred: necktie/crucifix states, standing vs kneeling FHL, per-weight tables, ONE knees, a film recode, and using BJJ
Graph percentages raw (they are mat attempt-mixes, not UFC resolutions).

## Sources (compact, as Grok gave them)
G138 priors; UFCStats/GrapplerHQ scrape (8,591 bouts, 1,659 subs: RNC 39.1%, guillotine 17.7%, D'Arce 2.8%, anaconda
2.3%); Fightnomics/Kuhn guillotine 13% (2024), ~17% historical, FightMetric 2006-13 13.6% via Bloody Elbow; Sportradar
position enum; ABC Unified Rules grounded rewrite 1 Nov 2024 and 2025 stand-up language (Goddard / Beltran / CSAC
explainers); BJJ Graph FHL/turtle mixes; BMC Sports Sci Med Rehabil 2026 (8,461 bouts); Bello et al. 2021 sex split;
Appl. Sci. 2026 "Twenty Years in the Octagon" (subs concentrate on back control, 45.5%).

## Claude's disposition (S104)
Build queue after Q207 (one down / one up): a stuffed shot in MMA routes by §6's entry split into FHL / TURTLE instead of
distance-or-guard, with §6's exits and the §4 strike overlay. Gate on §6's acceptance, measured with Q205's census
extended. Queue as TASK_Q208 once Q207 lands.
