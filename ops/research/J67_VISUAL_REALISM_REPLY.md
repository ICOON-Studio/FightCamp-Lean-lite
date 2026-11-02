# J67: What makes a 3-minute boxing round LOOK real on video, in numbers we can measure

FightCamp research memo, movement anchors. Written 14 Oct 2026.

**Ground rules.** Every number names its population. "NOT FOUND" means I found no published measurement. "ESTIMATE" means a best proxy that I worked out, never a sourced fact. Most published time-motion data comes from **amateur/Olympic** boxing (3 x 3 min). Professional boxing has very little movement data beyond CompuBox punch counts, so pro movement values are mostly estimates scaled from amateur data. Treat them as starting points for tuning, not as truth.

Output anchors you already have (not re-researched): CompuBox per fighter per round: thrown 45-56, landed 13-17, connect 27-32%, jab 40-44% of thrown; about 75-85% of the round at low intensity.

## Key sources (numbered, cited below as [S#])
- [S1] Davis P, Benson PR, Pitty JD, Connorton AJ, Waldock R. *The Activity Profile of Elite Male Amateur Boxing.* IJSPP 10(1):53-57, 2015. 29 Olympic semifinal and final bouts (London 2012), 39 male boxers, age 25.1±3.6 y, body mass 69.7±16.5 kg, 3x3 min. https://journals.humankinetics.com/view/journals/ijspp/10/1/article-p53.xml (tables: https://d.docksci.com/download/the-activity-profile-of-elite-male-amateur-boxing_5ad5e303d64ab21aa0861a01.html)
- [S2] Davis P, Connorton AJ, Driver S, Anderson S, Waldock R. *The Activity Profile of Elite Male Amateur Boxing After the 2013 Rule Changes.* JSCR 32(12), 2018. 50 World Championship bouts, 60 male boxers, 71.7±16.2 kg. DOI 10.1519/JSC.0000000000001864
- [S3] Davis P, Wittekind A, Beneke R. *Amateur Boxing: Activity Profile of Winners and Losers.* IJSPP 2013. 32 novice male boxers, 62.6±4.1 kg, 3x2 min. https://exa.ai/library/publication/0gy2177tzcf
- [S4] Slimani M, Chaabène H, Davis P, Franchini E, Cheour F, Chamari K. *Performance aspects and physiological responses in male amateur boxing competitions: a brief review.* JSCR 31(4):1132-1141, 2017. DOI 10.1519/JSC.0000000000001643
- [S5] *Temporal Structure of Bouts in Men's Olympic Boxing* (Applied Sciences 14(22):10683, 2024). 73 bouts, 80 male boxers, Tokyo 2020, five weight classes from feather to heavy. https://www.mdpi.com/2076-3417/14/22/10683
- [S6] ECSS 2023 abstract on ring generalship tracking. 32 bouts (3x3 min), French elite national championships, 33 boxers (18 women, 15 men). https://www.ecss.mobi/DATA/EDSS/C28/28-2883.pdf
- [S7] *Methodological analysis of boxing activity profile by category*: London 2012 Olympic welterweights (64-69 kg), male, age 21-28. https://www.researchgate.net/publication/343351034
- [S8] Puchol V. et al. (citing Finlay 2022): professional heavyweights. https://dialnet.unirioja.es/descarga/articulo/9076885.pdf
- [S9] *Professional boxing analysis with T-Patterns.* Physiology & Behavior 2021. 15 pro fights won by champions, all ending in round 1-2. https://www.sciencedirect.com/science/article/abs/pii/S0031938421000214
- [S10] *Kinematic and kinetic differences between lead and rear straight punches in elite boxers.* BMC Sports Sci Med Rehabil 2026. https://link.springer.com/article/10.1186/s13102-026-01738-1
- [S11] Biomechanics of the cross, hook and uppercut, junior vs elite boxers (PMC7739747; Proceedings 49(1):61). https://pmc.ncbi.nlm.nih.gov/articles/PMC7739747/ ; https://www.mdpi.com/2504-3900/49/1/61
- [S12] Experienced vs novice straight-punch kinematics (CORE 223208425). https://core.ac.uk/download/223208425.pdf
- [S13] *Time-Motion Analysis of the 2023 Women's World Boxing Championships Finals.* Sports 13(6):187, 2025. https://www.mdpi.com/2075-4663/13/6/187 (the fetch was blocked; the figures come from the search summary only, so check them before relying on them)
- [S14] Coaching literature on stance: ExpertBoxing "The Perfect Boxing Stance" https://expertboxing.com/the-perfect-boxing-stance ; MyBoxingCoach https://www.myboxingcoach.com/stance-and-on-guard/ ; BoxWithSimmy footwork fundamentals https://www.boxwithsimmy.com/post/boxing-footwork-fundamentals-how-to-move-in-the-ring
- [S15] Game reviews: GamingBolt (Undisputed) https://gamingbolt.com/undisputed-review-managing-the-fight ; Operation Sports (Undisputed) https://www.operationsports.com/undisputed-review-boxing-game-worth-owning-if-post-launch-support-holds-up/ ; NoobFeed https://www.noobfeed.com/reviews/undisputed-review ; The AU Review https://www.theaureview.com/games/undisputed-review/ ; Impulse Gamer https://www.impulsegamer.com/undisputed-review-ps5/
- [S16] ESBC dev talks and press: Steel City Interactive alpha feature video (art director Andy Turner, gameplay programmer on feints) https://www.youtube.com/watch?v=swLBjIEjzjo ; SGO movement update (dev director Ash Habib) https://www.sportsgamersonline.com/games/fighting/new-esports-boxing-club-update-shows-movement-in-action/ ; SGO 2022 impressions https://www.sportsgamersonline.com/games/fighting/new-2022-esbc-gameplay-impressions/ ; SGO ESBC vs Fight Night Champion https://www.sportsgamersonline.com/featured/top-5-ways-esbc-wins-against-fight-night-champion/

## The one master number
Elite amateur boxers do about **1.4 actions per second** in total: about **20 punches, 2.5 defensive moves and 47 vertical hip movements per minute** (Olympic SF/F, London 2012 [S1]). After the 2013 rule changes this rose to **1.55 actions/s: 21 punches, 3.6 defensive moves and 56 vertical hip movements/min** (2013 men's World Championships [S2]). [S2] also says the post-2013 game became "long range with straight punches, increased defence and movement around the ring."
**What it means for the game:** the body is almost never still. Hip bob or level change (about 50/min, so roughly one every 1.1-1.3 s) happens far more often than punches. The single strongest realism cue is constant small weight shifts while the fighter is not punching.

---

## 1. Footwork

| Item | Real-world number | Population / source |
|---|---|---|
| Vertical hip movements (bounce or level change) | 47/min; 56/min after 2013 | Olympic men [S1]; World Champs men [S2] |
| Share of round spent moving the feet | 53-56% of round time | London 2012 Olympic welterweights, male [S7] |
| Distance travelled | 155 ± 28 m per 3-min round | French elite national champs, 18 women + 15 men [S6] |
| Steps per minute | NOT FOUND. ESTIMATE 60-120 steps/min of footwork, worked out as 155 m ÷ 3 min ≈ 52 m/min, divided by an assumed 0.3-0.5 m per step for a shuffle step that keeps the stance. Bounce-only steps on the spot come on top of this. | estimate from [S6] |
| Step length | NOT FOUND. ESTIMATE 0.2-0.5 m (a short "step-drag" that keeps stance width; coaches say lead foot first, rear foot follows, never cross the feet [S14]) | estimate + coaching |
| Stance width | NOT FOUND as a measurement. Coaching: "slightly wider than shoulder width" [S14]. ESTIMATE 1.0-1.3x shoulder width side to side, with feet staggered front to back about 1-1.5 foot lengths | coaching [S14], estimate |
| Both feet flat vs heel up | NOT FOUND as a measurement. Coaching says the rear heel stays raised almost all the time and weight sits on the balls of the feet [S14]. ESTIMATE rear heel up 80-95% of the time; both feet flat only when planting for power shots or in the clinch. Lead heel flat or light most of the time. | coaching, estimate |
| Pivots per round | NOT FOUND. ESTIMATE 3-10 clear pivots (lead-foot pivots and angle changes) per round for an outside boxer, 0-4 for a pressure fighter | estimate |

**How to measure it from video:** use a fixed hard-camera angle. Count foot contacts per foot for 30-second windows. Measure step length against the canvas logo or the ring size (most pro rings are 16-24 ft inside the ropes). For stance width, freeze frames between punches and compare heel-to-heel width with shoulder width (acromion to acromion). For heel-up %, sample one frame every 0.5 s. For pivots, count only rotations of 30° or more about the lead foot.
**Most common game error:** feet that slide or skate across the canvas (foot IK not locked), so the motion looks like the fighter is gliding. Also a fully static stance during exchanges, so fighters "stand in the middle like Rock 'Em Sock 'Em Robots" (Operation Sports on early Undisputed [S15]), and fighters "tethered" to always face the opponent on a fixed axis (GamingBolt [S15]).

## 2. Distance

| Item | Real-world number | Population / source |
|---|---|---|
| Mean distance between boxers | 1.23 ± 0.16 m | French elite, mixed sex [S6] |
| Share at long / mid / inside | NOT FOUND as published percentages. ESTIMATE for pro, using the ~75-85% low-intensity anchor: long or out of range 45-60%, mid (jab range) 25-35%, inside or clinch 10-20%; pressure-fighter matchups shift 10-15 points toward inside | estimate |
| Range-change frequency | NOT FOUND. ESTIMATE one range change every 5-10 s (about 6-12 per minute), tied to entries and exits around exchanges | estimate |
| Ring position | Most punching sequences happen in the **centre of the ring**, more than at the ropes or corners. Corner sequences increase after round 1, especially in heavier classes | Tokyo 2020 Olympic men, 73 bouts [S5] |
| Ring position vs winning | Winners fought closer to the centre | 15 pro champion fights [S9] |
| Centre / ropes / corners split | NOT FOUND as percentages. ESTIMATE pro: centre 55-70%, ropes 20-35%, corners 5-15% | estimate |

**How to measure it from video:** map both fighters' feet onto the ring plane with a homography, as [S6] did, or roughly with a 3x3 grid drawn on the canvas. Classify range by hip-to-hip distance: inside under about 0.8 m, mid 0.8-1.4 m, long over 1.4 m (thresholds are ESTIMATES scaled to [S6]'s 1.23 m mean).
**Most common game error:** both fighters glued at one fixed mid distance in the centre (Undisputed "on-rails" feel [S15]). Also no way to trap a fighter on the ropes or in a corner (Impulse Gamer [S15]), and the knockdown sequence teleporting to ring centre (NoobFeed [S15]).

## 3. Rhythm

| Item | Real-world number | Population / source |
|---|---|---|
| Typical exchange | Short sequences of **2-5 punches** are the most common action | Tokyo 2020 Olympic men [S5] |
| Activity : rest ratio | elite 18:1; novice 9:1; novice by round 16:1, 8:1, 6:1 | amateur review [S4] |
| Round length including stoppages | ~200 s per 180 s round | Olympic men [S1] |
| Exchange duration | NOT FOUND. ESTIMATE 1-3 s (2-5 punches at about 0.25-0.5 s per punch) | estimate |
| Gap between exchanges | NOT FOUND. ESTIMATE pro 6-15 s; worked out as ~45-56 punches/round ÷ ~3.5 punches per exchange ≈ 13-16 exchanges/round ≈ one every 11-14 s | estimate from your CompuBox anchors + [S5] |
| Feints per minute | NOT FOUND (no study isolates feints). ESTIMATE 3-10/min for a skilled boxer; feints should outnumber committed exchanges | estimate |
| Resets (both fighters back out to neutral) | NOT FOUND. ESTIMATE 8-15 per round (about one after each exchange) | estimate |
| Pro punch volume (comparison) | 37.6 punches/round, 34.6% landed; jabs 172.4/fight with 27.3% landed, power 147.8/fight with 42.4% landed | professional heavyweights (Finlay 2022 via [S8]) |

**How to measure it from video:** mark the frame times of the first and last punch of each burst. Treat a gap of under 1 s as the same exchange. Feint = a visible shoulder, hand or foot fake with no full extension.
**Most common game error:** a constant even tempo with no long quiet stretches and no feints, so both fighters throw nonstop. Combos that must be entered in advance and play out "canned" (Impulse Gamer [S15]).

## 4. Head and upper body

| Item | Real-world number | Population / source |
|---|---|---|
| Defensive movements | ~2.5/min (pre-2013); ~3.6/min (post-2013) | Olympic men [S1]; World Champs men [S2] |
| Defensive actions per round, all types (arms, trunk, feet) | ~30 per round | cited in [S8] (Dunn et al. 2017; population not specified there) |
| Blocking share of round | ~7% of round time | London 2012 welterweights [S7] |
| Slips/rolls per minute, specifically | NOT FOUND separately. ESTIMATE 2-6/min of visible trunk defence (slip, roll, pull) | estimate within [S1][S2] |
| Head movement while not punching | NOT FOUND as a number. Proxy: 47-56 vertical hip movements/min [S1][S2] mean the head is almost always moving a few cm. ESTIMATE head travels side to side or up and down 3-10 cm in a continuous rhythm | proxy |
| Guard height between punches | NOT FOUND. Coaching: rear glove at cheek or chin, lead glove at eye level and slightly forward. ESTIMATE pros, especially outside boxers, often hold the lead hand lower (shoulder to chest height) | coaching / estimate |

**How to measure it from video:** track the nose or head-top keypoint with pose estimation and measure its displacement and frequency in non-punching windows. For guard height, measure glove height against the chin in frames between punches.
**Most common game error:** a frozen "statue" head between punches. Also defence and offence that cannot overlap: you cannot punch while swaying (GamingBolt, NoobFeed on Undisputed [S15]). Slips that look identical every time.

## 5. Punch mechanics a viewer reads

| Item | Real-world number | Population / source |
|---|---|---|
| Trunk rotation, rear straight (cross) | ~73°, peak trunk angular velocity ~270°/s | elite boxers [S10] |
| Trunk rotation, jab | ~43°, ~220°/s | elite boxers [S10] |
| Pelvis / hip rotation on straights | ~78° pelvis (ASIS line), ~69° hip in experienced boxers vs 49° / 39° in novices | experienced vs novice amateurs [S12] |
| Hooks vs straights | Crosses are driven mostly by elbow extension plus forward travel. Hooks and uppercuts rely more on shoulder-driven rotation. Elite boxers used more pelvis on hooks than juniors | junior vs elite [S11] |
| Return-to-guard time | NOT FOUND. ESTIMATE the return phase takes about as long as the extension or slightly longer (~0.15-0.35 s for a jab), with slower and lower returns when tired | estimate |
| Which hand drops after a punch | NOT FOUND as a measurement. Coaching consensus: the *non-punching* hand should stay home. The common real fault is the *punching* hand coming back low (a lazy jab return), or the left hand dropping on a right hand. ESTIMATE show a visible drop on about 10-30% of punches, more when tired | coaching / estimate |

**How to measure it from video:** use 60+ fps footage. Count frames from full extension until the glove is back at the chin. Measure shoulder-line rotation from a top or front angle.
**Most common game error:** arm-only punches with no hip or shoulder turn. Every punch returning instantly to a perfect guard. Punches clipping through gloves, or arms flailing when punches collide (AU Review, GamingBolt [S15]).

## 6. Clinches and the referee

| Item | Real-world number | Population / source |
|---|---|---|
| Clinches per round | 2.5 ± 2.0 (R1), 3.2 ± 2.1 (R2), 4.8 ± 2.6 (R3) | Olympic men, 3x3 min [S1] |
| Total clinch time per round | 12.6 s (R1), 17.2 s (R2), 28.7 s (R3); works out to about 5-6 s per clinch | Olympic men [S1] |
| Clinch duration | ~4.1 ± 2.3 s per clinch episode | 2023 Women's World Championships finals [S13]; not verified, see source note |
| Referee stops | ~1.7 / 3.0 / 3.1 per round (R1/R2/R3) | Olympic men [S1] (from search summary of the tables) |
| Pro clinches per round | NOT FOUND (no published pro study located). ESTIMATE 2-6 per round, 2-6 s each, with the referee breaking most of them. Heavyweights and tired fighters sit at the top of that range | estimate scaled from [S1] |

**How to measure it from video:** a clinch starts when either fighter's arm wraps, ties up or holds, and ends at separation. Log whether the referee stepped in or called "break".
**Most common game error:** no clinch at all (Undisputed shipped without one, then added a push that players spam [S15]). No referee presence. Punches continuing after the bell (Impulse Gamer [S15]).

## 7. Late-round fatigue (round 3 and later)

- **Amateur 3-round evidence:** novice activity:rest falls from 16:1 to 6:1 between R1 and R3 [S4]. Elite Olympic punch counts *rise* from R1 to R2 and then *fall* from R2 to R3, while vertical hip movement and clinching *rise* in R3 [S1]. In [S1], fatigue shows up as more clinching (more than double from R1 to R3) and more stoppages, not as less bouncing.
- **Pro 10-12 rounds:** NOT FOUND with movement measures. ESTIMATE for late rounds: output down 10-25% from early-round levels, guard 5-10 cm lower between punches, slower returns, flatter feet (heel-up share down 10-20 points), more holding, more time on the ropes.
- **Visible cues to show:** mouth open, lead hand lower, steps shortened, longer pauses between exchanges, more reaching or loading on power shots. Also slower recovery to guard after being hit (SGO noted ESBC fighters "get back to guard as if nothing happened" [S16]).

**How to measure it from video:** compare round 1-3 against round 9-12 on the same metrics (steps/min, guard height, clinches, punch counts).
**Most common game error:** fatigue shown only as a stamina bar, while the animation looks identical in round 12.

## 8. Top 10 things that make game boxing look fake (ranked)
Ranking is my judgement, weighted by how often reviewers and devs raise each issue.
1. **Static or tethered footwork:** fighters locked facing each other on a fixed axis, standing and trading in the centre (GamingBolt, Operation Sports on Undisputed [S15]; Fight Night Champion "getting stuck in the pocket" [S16]).
2. **Foot sliding / clip-stitched locomotion:** ESBC devs explicitly moved away from "clip based animation... it just looks a bit robotic" toward performance-based mocap with weight shift between legs [S16].
3. **No clinch, or a fake substitute** (NoobFeed, Operation Sports [S15]).
4. **Defence and offence can't overlap:** no punching while swaying or slipping (GamingBolt, NoobFeed [S15]).
5. **Clipping:** punches through guards, arms warping in simultaneous exchanges (GamingBolt, AU Review [S15]).
6. **No reaction to damage:** instant reset to a perfect guard after big shots; stunned fighters staying up too long (SGO [S16]; Impulse Gamer [S15]).
7. **Repetitive, low-variety knockdowns and reactions,** plus the knockdown teleporting to the centre (NoobFeed, AU Review [S15]).
8. **Nonstop even tempo:** no quiet feinting phases, and the ring position never changes. No trapping on ropes or corners (Impulse Gamer [S15]).
9. **Arm-only punches** with no hip or trunk rotation. GamingBolt praised Undisputed for angling the body on uppercuts and pivoting the feet on power shots [S15], which shows what viewers notice.
10. **Fatigue invisible in the body,** plus punches after the bell (Impulse Gamer [S15]).

## Tuning table for the devs

| Parameter | Target range | Population | Source |
|---|---|---|---|
| Vertical hip bobs / level changes | 45-56 /min | Olympic and World Champs men | S1, S2 |
| Total actions | 1.4-1.55 /s | Olympic and World Champs men | S1, S2 |
| Punches (amateur ref) | 20-21 /min | Olympic men | S1, S2 |
| Punches (pro ref) | 37.6 /round (HW); your CompuBox 45-56 | pro heavyweights | S8 |
| Defensive moves | 2.5-3.6 /min | Olympic men | S1, S2 |
| Time with feet moving | 53-56% of round | Olympic welterweights | S7 |
| Distance travelled | 155 ± 28 m /round | French elite, mixed | S6 |
| Steps | 60-120 /min (ESTIMATE) | pro/amateur | from S6 |
| Step length | 0.2-0.5 m (ESTIMATE) | n/a | S14 + estimate |
| Stance width | 1.0-1.3x shoulders (ESTIMATE; coaching says "slightly wider") | coaching | S14 |
| Rear heel raised | 80-95% of time (ESTIMATE) | coaching | S14 |
| Pivots | 3-10 /round outside boxer, 0-4 pressure (ESTIMATE) | n/a | none |
| Mean inter-fighter distance | 1.23 ± 0.16 m | French elite | S6 |
| Range split long/mid/inside | 45-60 / 25-35 / 10-20% (ESTIMATE) | pro | none |
| Ring position centre/ropes/corners | 55-70 / 20-35 / 5-15% (ESTIMATE); centre dominant, corners rise after R1 | Olympic men (direction only) | S5, S9 |
| Punches per exchange | 2-5 | Olympic men | S5 |
| Exchange duration | 1-3 s (ESTIMATE) | n/a | none |
| Gap between exchanges | 6-15 s (ESTIMATE) | pro | from CompuBox anchors + S5 |
| Feints | 3-10 /min (ESTIMATE) | n/a | none |
| Trunk rotation, jab | ~43°, ~220°/s | elite | S10 |
| Trunk rotation, cross | ~73°, ~270°/s | elite | S10 |
| Pelvis rotation, straights | ~78° experienced (49° novice) | amateur | S12 |
| Return to guard | 0.15-0.35 s jab (ESTIMATE), +20-50% when tired | n/a | none |
| Clinches | 2.5 → 3.2 → 4.8 per round (R1→R3) | Olympic men | S1 |
| Clinch time | 12.6 → 17.2 → 28.7 s per round; ~4-6 s each | Olympic men; women's WC finals | S1, S13 |
| Pro clinches | 2-6 /round, 2-6 s each (ESTIMATE) | pro | scaled from S1 |
| Referee stops | ~1.7-3.1 /round | Olympic men | S1 |
| Fatigue output drop (late pro rounds) | -10 to -25% (ESTIMATE) | pro | none; amateur trend S1, S4 |
| Fatigue guard drop | 5-10 cm (ESTIMATE) | n/a | none |

**Biggest gaps (worth our own video study):** pro steps/min, stance width, heel-up %, range split, ring-position %, exchange duration, feints, pro clinch counts, and guard height. A fixed-camera study of 10-20 pro rounds, tracked with pose estimation, would replace every ESTIMATE above.
