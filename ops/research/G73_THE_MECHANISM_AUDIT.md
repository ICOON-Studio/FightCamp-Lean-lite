# G73 - THE MECHANISM AUDIT

> Collected S67, 2026-09-24, from Grok's in-app chat "Mechanism Audit for FightCamp Combat Engine"
> (https://grok.com/c/a35438b1-752f-4075-ba41-a2768a932140), 40 sources (links in the chat). Grok's answer as
> rendered text; tables re-set as markdown. NOTE: Grok read the engine at `8f1a826`, not current master.

Desk: FightCamp research
Date: 2026-09-24
Kind: research, no code
Question: which real cause-and-effect chains does the fight engine not model?

Why it exists: prior work calibrated outcomes (J20: pace, accuracy, target mix, KO/sub/decision, knockdowns, takedowns). An engine can hit those anchors with dice. "Trap" was never on the list because nobody audited causes. G72 designs traps. This memo lists the rest of that class.

Engine snapshot used: Guru-Meditation/FightCamp @ 8f1a826. Files read: FightIntent.gd, FightFootwork.gd, FightMoves.gd, GrappleResolve.gd, GroundGraph.gd, RingSpace.gd, BalanceState.gd, technique_catalog.json v6, fight_plans.json v2, J20_THE_VALIDATION_CORPUS.md, S58_THE_GROUND_GRAPH_WIRED.md.

Verified, as asked. Movement intents are exactly close / hold / retreat / circle (FightIntent.INTENTS). Circle is a throttled lateral walk (FightFootwork.THROTTLE_CIRCLE = 0.65). There is no pivot/angle intent and no ring-cutting decision. RingSpace.place_of returns CENTRE / ROPES / CORNER; FightIntent.decide only special-cases place == "CORNER" as escape (w_circle = 0.6, w_retreat = 0.4). RingSpace.pressure exists and is not read by the intent picker. Catalogue nodes boxing_cutoff_ring, boxing_angle_step, boxing_pivot_footwork, boxing_pivot_out, boxing_feint, mma_underhook_cage exist as learnable names. FightMoves prices none of their effect keys (entry_open, angle_attack, boundary_control, feint, cage_control). It reads three families only — head / body / leg — as a target hint, never as a chain.

## 1. Catalogue of mechanisms

Each row is a chain: trigger → what it opens → cost. Source is coaching/analyst literature, not an engine number.

### Striking

| # | Chain | Trigger | Opens | Cost | Source |
|---|---|---|---|---|---|
| S1 | Feint → reaction → the shot the reaction opens | Half-jab, shoulder twitch, hip turn, level dip | A committed slip, cover, or step that leaves a line (cross down the middle, hook to the open side, kick to the planted leg) | Time and a tell. A feint that is never paid off stops drawing. A feint that is always the same becomes the tell. | Lee Wylie: feint as a question ("what does he do with his guard if I rotate the rear shoulder?"). Jack Slack, Elementary Striking: feint one way, attack the other; jab as the fundamental lead. |
| S2 | Jab sets range for the rear hand | Lead straight that occupies the opponent's lead hand or eyes, whether it lands or not | Rear straight / overhand on a now-known gap | Lead-side exposure; a good reader slips outside and meets you (Pacquiao split-entry / Slack cross-counter). | Wylie on Chavez vs Camacho: jab as muffler, not as a hammer. Slack: the jab is the important lead because it hides the shoulder. |
| S3 | Body work that drops the guard later | Repeated body jab / hook / kick to the midsection | Hands come down in later rounds; head shots that were blocked in R1 land in R3–R5; cardio to move and hold the guard both fall | You give up some immediate head scoring. You eat counters while low. | Wylie on the body jab (Robinson, Leonard): set a low pattern, then feint low and go high. Wylie on cutting off: once contained, "work the body, thereby stealing the stamina needed to move" (Canelo–Lara). |
| S4 | Pivot / angle off the line after a combination | After a 1-2 (or any committed pair), step offline so the opponent's reset faces empty air | You are no longer on his rear-hand line; your next shot is a hook or rear straight from 45–90° | Miss the step and you are square, or you walk onto the check hook. | Fight Primer Stick and Move (tai sabaki / V-step / classical side step). Slack Elementary Striking: angle off the right hand mid-combination. |
| S5 | Cut off the ring / cage | Diagonal and intercepting steps toward where he will be, not where he is; jab / feint to make the exit predictable | He runs out of exits; you work at the ropes/fence instead of chasing | Over-commit and he pivots off and you eat the check hook. Long combinations that carry the shoulders past the hips reopen the exit you just closed. | Wylie Q&A #2: do not retrace his footsteps; meet him; corral first, then spend. MiddleEasy, How Cage Cutting Works (2026): six-step sequence — pressure without sprinting, feint to freeze an exit, fence as second defender. Slack on Topuria: low kick when the man circles off the lead leg, so the pivot stops. |
| S6 | Cage / rope pressure drains cardio | Contained man must circle and punch and defend. Fence takes his stance (Slack, Art of the Stance: Velasquez pressing the face to the fence destroys the opponent's stance while keeping his own). | Output and escape quality fall as the tank falls. Shots that were easy to slip become stationary. | Your own tank. A sloppy cut is just a chase. | Wylie: contained man loses the feeling of control and rushes. Slack stance piece: fence as stance-killer. |
| S7 | Hand trap / milling → opening | Forearm or palm occupies or pins a guard hand | The trapped side cannot parry; rear hand or knee travels the cleared lane | Both of your hands are busy; you can be hit while trapping. | Slack Elementary Striking (handfighting / milling). Bloody Elbow 2018 trapping primer (Machida clearing a path; Font trapping on the cage; Mayweather check-hook trap into a pivot). |
| S8 | Counter-timing a predictable pattern | He always throws 1-2-hook, always resets to the same side, always low-kicks on the circle | You are already moving on his third beat (Marquez counter combinations; Aldo; Slack's delayed counter / "make him miss and make him pay") | Guess wrong and you walk onto the shot you thought you had timed. | Slack, Ringcraft: The Three Initiatives (lead / delayed counter / cross-counter). |
| S9 | Level change after strikes (or strike after level change) | Jab or cross that makes him stand tall, then the shot; or a level-change feint that makes the hands drop, then the punch | Takedown on a high man, or head shot on a man who sat down to sprawl | The feint that is never a shot gets timed. The shot that is never a punch gets sprawled on forever. | Catalogue itself names mma_jab_levelchange ("Jab to Level-Change Feint") and wrestling_level_change. Coaching commonplace across MMA. |
| S10 | Teep / long push that forces a reaction | Lead teep to belly or hip | Step-back → cross; fold → head kick / knee; planted lead → low kick; hands drop → cross | Catchable. Dropping the rear hand on the teep is a chin invitation. | Muay Thai coaching corpus (Evolve, Fairtex, Sabaidee): the follow-up is chosen from his reaction, not from a pre-written combo. |
| S11 | Damage that changes behaviour (hurt, shelling) | A shot that is not a knockdown but is a change of mind — high guard, no return, feet stop, eyes go | Finish sequence, or a cheap clinch, or a reset you do not allow | Swinging on a hurt man who is still dangerous. | Universal coaching. Slack delayed-counter section: a covered-up man is a different problem from a fresh one. J20 distinguishes KD from KO for this reason. |

### Clinch

| # | Chain | Trigger | Opens | Cost | Source |
|---|---|---|---|---|---|
| C1 | Underhook → takedown or cage control | Win the inside tie; especially against the fence | Single / body-lock / trip; he cannot circle off; dirty boxing or grind | Give up the underhook and you are the one on the fence. Head position lost = you get turned. | Cage-wrestling coaching (Couture lineage; Khabib's title run as underhook-cage grind). Fight Encyclopedia: single underhook on the cage is enough to launch; double unders is "almost no defensive options." |
| C2 | Over-under / plum / collar-tie posture break | Control of the head + one underhook or two-hand plum | Knees, snaps to front headlock, trips; his punches have no posture | Knees and elbows come back. Thai plum is a scoring fight of its own. | Muay Khao coaching; Danaher front-headlock system (head control first, then arm; chest pressure stops the stand). |
| C3 | Pummel win as a fork | Hand-fight until one man has both unders or a decisive underhook | Same as C1, or the turn that puts him on the fence | Losing the pummel is how you get taken down without a "shot" ever being logged. | Same cage-wrestling corpus. |
| C4 | Front headlock as a dilemma, not a choke | Snap or stuffed shot → head and arm | Guillotine / anaconda / darce / go-behind. Defence of one opens another. | Hang on too long and he stands, or you get reversed. | Danaher Front Headlock System (BJJ Graph): "defensive responses to one attack open pathways to others." |

### Grappling / ground

| # | Chain | Trigger | Opens | Cost | Source |
|---|---|---|---|---|---|
| G1 | Trap → submission dilemma | A control that already limits a degree of freedom (straight jacket, ashi, triangle, kimura grip) | He cannot defend neck and arms at once; every defence is a different finish or a back-take | Forcing a finish that is not there loses the control. | Danaher: Dilemma Principle + Central Problem Principle. Straight Jacket: cannot defend neck without exposing arms. BJJ Heroes on DDS: 70% strangle rate from back in the observed sample; 90% of finishes from three controls (back + body triangle, saddle, outside ashi). G72 owns the design of this class. |
| G2 | Submission threat used to earn position | Attack the finish first | The defence is the pass, the back-take, or the sweep | The threat has to be real. A fake submission that never bites stops being a threat. | "The System That Replaced Jiu-Jitsu's Fundamentals" (DDS): submission threat → positional advancement, not the old "position before submission" only. |
| G3 | Trap-and-roll / hitchhiker / technical escape | Bottom man frames a specific control (mount arm-trap, side underhook, half-guard lockdown) and rolls through the weight | Reversal, not a stall-clock stand-up | Fail the roll and you are flatter than before. | Standard BJJ escape pedagogy. Half-guard underhook battle (old school / Plan B back-take / kimura when he posts). |
| G4 | Action–reaction on the mat | Threaten a sweep so he posts; threaten a pass so a foot trails | The post is the kimura; the trailing foot is the leg entry | Over-threaten and you give the underhook. | BJJ Graph Action and Reaction; Danaher leglock vol. 1 (defend the pass → foot trails → inside position). |
| G5 | Back control as a hand-fight, not a seat | Seatbelt + chest-to-back. Chin rise of one wrist-width → hand in. | RNC vs armbar vs body triangle. Defence of the neck is the arm trap. | Hooks without the upper-body fight is not the back. | Danaher Back Attacks / Straight Jacket: hidden hands, default-to-strangle on chin rise. |

## 2. The audit

Legend: YES = the chain is a live cause in the engine. PART = a piece exists (a name, a stat, a place-word, a meter) but the consequence is missing. NO = not modelled.

| # | Chain | Verdict | Why (file / function) |
|---|---|---|---|
| S1 | Feint → reaction → opened shot | NO | boxing_feint is a catalogue setup node (effects.entry_open, distance_read). FightMoves does not spend entry_open. There is no opponent-reaction state. A feint is at best another selectable technique name, not a question the other man answers. |
| S2 | Jab sets range for the rear hand | PART | Range bands exist (FightMoves.SCALED_LONG / SCALED_MID; FightIntent.preferred_range from Hristovski shape D≈1.2). Combo continuation exists as time since this man last threw (COMBO_WINDOW_S = 0.35, Piorkowski et al. 2011 lab proxy; COMBO_BOOST). That is "same thrower goes again," not "the jab occupied his lead hand so the rear hand is now the right shot." Plans can mark setup PRIMARY (fight_plans.json boxing_out_boxer). ROLE_PRIORITY_FROM_PLAN is default off. |
| S3 | Body work drops the guard later | NO | Plans already ask for it (boxing_pressure coach_line: "Body first"; target_bias.body = 1.3). Target mix is a pick weight, not a delayed guard state. Nothing in the read files lowers future head-defence after accumulated torso damage. J20 already records the engine's body share as high (28.2% vs real ~19–23%) — so the engine throws body shots without the reason body shots exist. |
| S4 | Pivot / angle off the line | NO | Catalogue has boxing_angle_step, boxing_pivot_footwork, boxing_pivot_out, boxing_check_hook_pivot. Intents do not. Circle is a walk around the man, facing unchanged as a tactical fact. No "I am now 45° off his rear hand" flag. |
| S5 | Cut off the ring / cage | NO | boxing_cutoff_ring is a tier-3 skill (role: control, boundary_control, opponent_mobility: -7). Intent picker never hunts the far exit. Corner handling is the victim's escape, not the hunter's intercept. Wylie's "meet him where he will be" is the opposite of close along the current gap vector. |
| S6 | Cage pressure drains cardio | PART | Stamina already taxes CLOSE (FightIntent.decide redistributes close-weight onto hold/circle as the tank falls). RingSpace.pressure is a geometric 0..1 and is not wired into that tax. Being on the fence does not cost extra tank, and does not steal his ability to circle. Slack's "fence takes the stance" is unmodelled. |
| S7 | Hand trap → opening | NO | arnis_empty_hand_trap is the only *trap* strike-adjacent node; MMA/boxing have no live hand-occupancy. Guard is not two occupiable hands. G72 is the trap study; this row stays NO until that ships and is spent. |
| S8 | Counter a predictable pattern | NO | No per-opponent pattern memory. counter is a catalogue role and a plan priority, not "he has thrown this pair twice, sit on the third." Slack's three initiatives are not states. |
| S9 | Level change after strikes | PART | mma_jab_levelchange was deliberately moved onto the grapple palette via takedown_ready so it would not log as a punch (FightMoves header). The chain "punch then shot on the same reaction" is therefore two separate streams. wrestling_level_change is setup for grappling, not a feint that opens a cross. |
| S10 | Teep forces a reaction | PART | muay_thai_teep and friends exist and can land as body/leg damage. The reaction fork (step back / fold / plant / catch) does not. |
| S11 | Damage changes behaviour | PART | Knockdowns, fatigue multipliers (GrappleResolve via FatigueCurve), and BalanceState staggers exist. Stagger/kuzushi is a short off-base window (0.2–2.0 s curves), not a policy change (shell, stop returning, grab a clinch, refuse to lead). A hurt man still picks from the same four intents. |
| C1 | Underhook → TD / cage control | PART | mma_underhook_cage exists (cage_control, escape_or_takedown). Clinch takedowns use a different attribute mix (GrappleResolve.CLINCH_OFF_WEIGHTS) and land in guard/half/side by grade. There is no live underhook/overhook occupancy, so "he won the pummel" is not a fact the next tick can read. Fence is a ROPES place-word, not a second defender. |
| C2 | Posture break in the clinch | NO as a chain | Clinch is a stance/position. Head control is not a resource. |
| C3 | Pummel as a fork | NO | No tie-state. |
| C4 | Front headlock dilemma | NO | front_headlock_open is a catalogue effect word in FightMoves.GRAPPLE_EFFECTS. GrappleResolve.submission_advance is a single progress meter + FINISH_P = 1/7 coin at 100. That is the dice J20 warned about. No fork. |
| G1 | Trap → submission dilemma | NO | Progress meter + flat finish coin (GrappleResolve.submission_advance, FINISH_P). GroundGraph edges are seat-to-seat (mount_to_back, side_to_mount, …), not control-that-opens-a-fork. S58: bottom man is unwired; submissions are a pre-empting gate from mount, not a dilemma off a trap. G72's job. |
| G2 | Submission threat earns position | NO | Graph reward is position points. A failed sub does not become a better seat. S58 measured the opposite side-effect: chooser-first reduced submissions 42 → 36 / 120 bouts because leaving mount abandoned the sub gate. |
| G3 | Trap-and-roll escape | NO | Bottom edges authored (mount_escape, side_escape) and "deliberately never offered" (S58 §5). Escapes still run the shipped ladder, not a trapped-arm roll. |
| G4 | Action–reaction on the mat | NO | Graph terms are skill / plan / reward / hold_value. No "he posted, so kimura." |
| G5 | Back as a hand-fight | PART | back is a seat. S58 got it off 0.11% → 2.47% of ground time by running the chooser before the mount sub gate. It is still a seat timer, not a chin-rise / hidden-hand fight. DDS "70% from back" is an outcome you can fake with a higher FINISH_P. |

What the engine does model as causes (so this list stays honest): preferred-range seeking and reach-blind-spot bumps (FightIntent.contested_range); stamina flattening aggression; finite footwork inertia (FightFootwork.advance); combo time-window; region-targeted impact; takedown success as a weighted-stat roll with a small kuzushi bite (KUZUSHI_DEFENCE_BITE = 0.25, live on 0.72% of shots per S24); ground seats with a top-man chooser; hold-value decay as one integer step (S58 §5b: not the curve the header describes). Those are real mechanisms. They are not the list above.

## 3. Ranking of the missing

Scored on (a) how much of a real fight they decide, (b) what the player can SEE and TRAIN (reps → technique level; fight plan priority; result-screen "why"), (c) cost to add without inventing a constant. G1/G2 (traps) are out of the top five because G72 already owns them.

| Rank | Mechanism | (a) Decides | (b) See / train / why | (c) Cost |
|---|---|---|---|---|
| 1 | S1 Feint → reaction → opened shot | Every striking exchange that is not a coin-flip. This is why a jab is not just a low-power punch. | Visible: he flinches, you fire. Train: boxing_feint (already in the tree, 112 reps, needs boxing_jab). Plan: setup PRIMARY already exists. Why: "he bought the shoulder, the cross was free." | Medium. Needs a short-lived reaction flag on the defender, consumed by the next technique. No new locomotion. |
| 2 | S5 Cut off the ring / cage | Who works and who runs. Pressure plans are currently a pace adjective. | Visible: exits close, he hits the fence. Train: boxing_cutoff_ring (tier 3, already authored). Plan: boxing_pressure coach_line already says "cut the ring" and the intent picker cannot. Why: "he was put on the fence in R2 and stayed there." | Medium-high. Needs a hunter intent (or a read of RingSpace that aims at the far exit), not another throttle on close. |
| 3 | S3 Body work → later guard / tank | Late-round shape of boxing and Thai fights. The reason "body first" is a plan and not a target slider. | Visible: hands drop, he stops circling. Train: boxing_jab_body, body hook, body kick — all present. Why: "the head shots in R3 were paid for in R1." | Medium. Needs a slow guard/mobility modifier driven by accumulated torso (and later leg) damage. Must not be a hidden KO multiplier. |
| 4 | S4 Angle / pivot off the line | Converts a landed pair into a safe next pair. Without it, combinations are volume on a rail. | Visible: he resets facing a shoulder. Train: boxing_angle_step, boxing_pivot_footwork, boxing_check_hook_pivot. Why: "the 1-2 landed and he was gone before the return." | Medium. One facing/angle bit plus a post-combo step. Circle is the wrong verb. |
| 5 | C1 Underhook → cage control / takedown | The actual MMA clinch fight (Khabib-shaped bouts, most fence time). Distance-wrestling already has a roll; fence-wrestling does not have a grip. | Visible: he is pinned, then dumped or ground. Train: mma_underhook_cage. Why: "he lost the underhook on the fence, not a 12-metre shot." | Medium. One clinch-tie state (under / over / none) that GrappleResolve.takedown_resolve and fence-stay can read. Do not invent a new success formula; scale the existing one (p_mod pattern from GroundGraph). |

Honourable missing, not top five: S8 pattern-timing (high a, weak published denominator, easy to fake); S11 hurt-policy (high a, overlaps knockdown/stagger already there); S6 extra fence-tax (falls out of #2 if cutting is real); G3 trap-and-roll (blocked on S58's "bottom man is its own slice"); C4 front-headlock fork (subset of G72).

## 4. Top five — state, readers, training, why, calibration figure

No authored constants. Each "calibrate against" is a published quantity or a named corpus, not a number we made up.

### 1. Feint → reaction → opened shot
- State needed: a short-lived defender flag: what he answered with (cover-high, slip-in, slip-out, step-back, level-sit, nothing). Set by a feint technique; consumed by the next strike or shot; expires if unused.
- What reads it: strike selection (the shot that matches the answer) and the result-screen reasoner.
- Training link: fighter must know boxing_feint (prereqs already boxing_distance_read, boxing_jab). A man who has not learned it cannot ask the question.
- Result-screen why: "Feint bought a high cover; rear hand went to the body" / "Feint bought nothing; he stopped answering."
- Calibrate against: not a made-up draw-rate. Use what is already sourced for combinations: Davis 2015 elite amateur, ~10 two-punch combinations per boxer per round (already the denominator behind COMBO_BOOST). A feint that opens should show up as a change in which second shot is chosen, not as a new finish coin. Wylie/Slack remain the qualitative test: if the second shot does not depend on the answer, the flag is dead.

### 2. Cut off the ring / cage
- State needed: hunter vs hunted relative to the far wall, not only gap-to-opponent. RingSpace.wall_margins / open_room already compute the geometry. Intent must be allowed to step toward the escape door.
- What reads it: movement (FightIntent.decide today cannot); later, strike target when place_of(defender) != CENTRE.
- Training link: boxing_cutoff_ring (prereqs boxing_circle_lead, boxing_circle_rear). Plans that already claim the behaviour (boxing_pressure, Dutch pressure, Topuria-style corralling) stay lying until this is live.
- Result-screen why: "Exits closed at 2:10 of R2; X of Y significant strikes after that were on the fence."
- Calibrate against: J20 position strike-share (distance 72.6 / clinch 13.4 / ground 14.1 of significant strikes — Fight Algorithm Volume Machine, 8,555 fights). Time-share distance/clinch/ground UFC-wide is NOT FOUND (J20 §C). Do not invent one. Measure engine fence-time as a new column and hold it next to the strike-share, not next to a fake minute-share.

### 3. Body work → later guard / tank
- State needed: accumulated torso (and, separately, leg) damage as a behaviour modifier: willingness to hold a high guard, willingness to circle. Not a damage multiplier on the next head shot.
- What reads it: defence on head shots; FightIntent circle/retreat weights; late-round pace.
- Training link: boxing_jab_body / boxing_jab_body_head (the down-up Wylie describes). Plan target_bias.body becomes a cause instead of a paint job.
- Result-screen why: "Body share early; head accuracy against him rose after the tank went."
- Calibrate against: J20 D3 target mix (league ~61–65 head / 19–23 body / 14–18 leg) and D1 pace. If adding the chain raises late-round head accuracy against the body-worn man, that is the sign it is working. Do not tune a "hands-drop coefficient." Mańka-Malara 2022 gives significant-head-received per minute (mean 2.41) as a received-damage check, not as a guard-drop number — because that number is unpublished.

### 4. Angle / pivot off the line
- State needed: facing, or an "off the rear-hand line" bit, set by a pivot/angle technique after a throw, cleared when he turns with you.
- What reads it: legality / payoff of the next rear-hand vs hook; whether his return is still on line.
- Training link: boxing_angle_step, boxing_pivot_footwork, boxing_check_hook_pivot. Check-hook-and-pivot is the counter to a sloppy cut (#2), so these two want to land as a pair or not at all.
- Result-screen why: "1-2 landed, angle taken, return missed."
- Calibrate against: no published "degrees off-line per combination." Refuse a degree constant. Use Davis 2015 combination counts plus the engine's own facing log: share of post-combo throws that occur after an angle step, among men who know the step. Slack/Fight Primer remain the visual acceptance test.

### 5. Underhook → cage control / takedown
- State needed: clinch-tie ∈ {none, under, over, double-under} plus RingSpace place. That is enough for "he cannot circle" and for a p_mod on the existing clinch takedown roll.
- What reads it: GrappleResolve.takedown_resolve (already splits standing vs clinch weights); fence-stay; dirty-boxing availability.
- Training link: mma_underhook_cage. A striker who never learned it can still be put on the fence by geometry (#2) and still have a path out.
- Result-screen why: "Lost the underhook on the fence; takedown from the tie, not from open space."
- Calibrate against: J20 D6 — takedowns landed / attempted and 35–40% accuracy, by division (fly ~7.5 att / 2.8 landed per fighter-fight; HW ~3.7 / 1.5). S24 already measured engine accuracy at 51.3% with the kuzushi bite on 0.72% of shots; do not "fix" D6 by inflating fence-TD success. UFC-wide clinch-time is still NOT FOUND. Khabib-style control time is a fighter tail on the Record Book, not a league mean to copy.

## 5. What NOT to add, and why
- A flatter submission coin, or a second one. That is how the 19% sub share was once faked. G1 is a control that forces a choice, not a higher FINISH_P.
- Pattern-recognition as a hidden IQ stat. S8 is real in film rooms. There is no published "he repeats his 1-2 on beat three" column. An authored detector will become a finish dial with extra steps.
- Hand-occupancy physics / full milling. S7 is real (Slack, Mayweather, Machida). It needs two guard-hands as resources and it fights the whole strike resolver. Leave it until traps (G72) prove the smaller version.
- Danaher subsystems as extra graphs. Straight jacket, saddle, outside ashi, front headlock systems are teaching architectures. The engine needs the dilemma shape (G72) and a grip/seat the result screen can name. 534 scraped edges was already refused by four agents on S57.
- A UFC-wide clinch/ground time-share target. J20 searched and marked it NOT FOUND. Wiring #2 or #5 to a fabricated minute-share repeats the outcome-calibration error this study exists to stop.
- Stance or angle as a damage multiplier. Already refused (U18 D3; BalanceState header). Angle changes which shot is on line, not how hard the same shot hits.
- Bottom-man graph + trap-and-roll in the same slice as any of the top five. S58 recorded that wiring the bottom man is its own control-armed slice. Mixing it in will make S56's integer match undiagnosable.
- Tuning DECAY_GATES or KUZUSHI_DEFENCE_BITE to stand in for a missing chain. Both are authored and already measured as the wrong lever (S58, S24).
- Teaching the catalogue effect keys to price fights. FightMoves refused that rope on purpose (140 effect keys). Spend one new state per chain, from the list above, not entry_open: 8 as a silent modifier.

Still unknown: the fraction of real UFC significant-strike openings that were produced by a prior feint or trap rather than by raw speed or a guess — no logger stores that cause, only the outcome.
