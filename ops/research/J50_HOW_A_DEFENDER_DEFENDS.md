# J50 — How a Defender Defends (block, evade, and everything in between)

FightCamp research memo. Task J50 (JOHN), operator brief of 2026-09-25 plus the operator addendum "the defender also should choose to anticipate and counter". Target path in the repo: `research/J50_HOW_A_DEFENDER_DEFENDS.md`. Research only: no game code was written and no repo or other machine was touched. All sources were read on 2026-09-25 (box time, Asia/Nicosia, UTC+3).

**Rules used in this memo.** Every number carries a source ID (see §11), the source date, and a type tag: DEV (game developer statement), ACADEMIC (peer-reviewed paper or thesis), COACH, FIGHTER, PRESS (journalism, including CompuBox figures as published in the press), COUNT (a count I computed myself from a stated data set), COMMUNITY (player forums and fan guides). If I could not find a figure it says NOT FOUND. Where I only saw an abstract or a search-result excerpt of a page rather than the full text, the entry says so. In §10 every game constant is marked SOURCED (taken directly from a source), PROXY (borrowed from a nearby measurement or from another game, so it is a stand-in and not a fact about real fighters), or NOT FOUND (a designer's placeholder that needs tuning).

---

## §0 Short answer

The operator's model has two options: the defender either **blocks** (takes reduced damage, must be at the right height at the right time) or **dodges** (takes no damage if it works, but opens a weakness depending on how he moved). That model is a good skeleton, but real defence is wider in three ways.

1. **There is a whole family of options in between.** Real coaches teach at least fifteen distinct answers to a strike. Some *reduce* damage (high guard or shell, rolling with the punch, shoulder roll). Some *redirect* the strike (parry, catch). Some *destroy the strike's range* rather than moving the head (step back, pivot to an angle, jam or smother inside the arc, clinch). Some are *attacks used as defence*: hitting first so that his strike never finishes (EA's UFC 3 developer calls this "stopping power", S18, 2017, DEV), and the Muay Thai **check** (lifting the shin into a kick), which can hurt the kicker. And there is the option nobody chooses: he never saw it coming and took it clean.
2. **Moving out of range is the most common defence among winners, not blocking or head movement.** In the 12 finals of the 2023 IBA Women's World Championships, "shifting back" was the most used defensive technique by winners (23.3% of their defensive actions, plus another 14.9% "shifting back + counterattack"). Pivoting was strongly linked to winning. Parrying was linked to *losing* (S37, 2025, ACADEMIC). In the UFC, a head strike lands 36.5% of the time, but body strikes land 69.2% and leg strikes 80.4% (S16, COUNT, all UFC bouts to 2026-09-19). The legs and body are where defence fails most.
3. **Anticipation matters more than raw reaction speed.** The arithmetic makes pure reaction nearly impossible. A maximal jab takes about 405 ms from first movement to contact (S2, 2018, ACADEMIC). A simple visual reaction is about 230–250 ms (S1, 2002, ACADEMIC), and at least about 200 ms of that is an unavoidable delay for nerves and muscles. Experts get by because they **read** the strike early. Karate athletes named the target (upper or middle) correctly 96% of the time after seeing only the first 7 video frames (about 233 ms) of an attack, against 80% for novices (S1). A 2022 meta-analysis of 27 studies found experts more accurate (83.3% vs 68.5%) and faster when anticipating attacks (S7, ACADEMIC). Simple reaction time did **not** differ between karate experts and novices (S1). So the edge is in reading, not in faster nerves.

So the better game model is a four-step loop: **perceive** (did he read the tell early, late, or not at all?) → **choose** (block, reduce, redirect, evade, deny range, clinch, strike first, or anticipate early and counter) → **execute** (did the action happen inside the strike's timing window, at the right height and side?) → **consequence** (damage taken, stamina spent, balance and position, and a *counter window* that is sized by what was evaded and how). §10 turns that into tagged constants.

---

## §1 The human answer: how coaches teach it and how a fighter decides

### 1.1 What the fighter has to work with

The numbers in §3 rule out "see the punch, then decide". A jab takes about 400 ms from first movement to contact (S2), and a realistic whole-body defensive reaction takes 300–400 ms (Williams & Elliott 1999, cited in S1). So real defence rests on three layers. (1) **Reading before the strike**: stance, distance, rhythm, habits. Experts fix their gaze on a steady centre, the head and trunk, not on hands and feet. Expert French boxers moved their gaze head → trunk → edges → head (Ripoll 1995, via S6). Hiding the trunk and arm hurt expert fencers (Hagemann 2010, via S6). (2) **Reading the first part of the strike**: karate experts called the target level at 96% from ~7 frames (~233 ms), and novices needed ~100 ms more (S1). At close range "the available time can be less than a simple reaction time" (S6). (3) **A trained default** (shell, guard, habitual movement) when nothing is read. That default is his style.

### 1.2 Boxing

**Cus D'Amato and the peek-a-boo (via Teddy Atlas).** In his instructional material, Atlas teaches the chin tucked and the hands "directly under each eye", so the gloves do not block the fighter's own vision. The stance is square rather than bladed so he can keep attacking. Defence comes mainly from moving the upper body and head while the feet stay set at a controlled distance: **slip straight punches, weave under hooks and uppercuts**. The aim is to end up "outside the other fighter's shoulder, in prime position to throw a fight ending punch". D'Amato's idea, as Atlas relays it, was to be in positions where "you can hit the fighter, and they cannot hit you" (S41, Dynamic Striking summary of an Atlas instructional, undated, COACH-via-PRESS). The cost of this style is that constant head movement uses energy, and a square stance shows a wider target.

**The Mayweather shoulder roll.** Floyd Mayweather Jr.: "My dad taught me the shoulder roll… It's mine because I mastered it… that's the Mayweather defense" (S39, Drink Champs interview Feb 2020, as quoted by World Boxing News 2023, FIGHTER). A BOXRAW technical article describes how it works. The lead shoulder sits directly in front of him, which gives a smaller target and hides the right hand. When the opponent jabs, Floyd "can catch the jab and come over the top with a straight right hand or deflect the jab by turning his shoulder and come back with a sharp straight right hand almost instantly". His counters are usually a short straight right, an uppercut, or less often a right hook. The same article traces the defence to Detroit trainer Dale Williams, who taught Mayweather Sr. to "roll, block and counter punches while remaining in the pocket" (S40, 2018, PRESS). The results in numbers: CompuBox had Mayweather's opponents landing 16% of all punches over a nine-fight prime, "the lowest collective figure recorded in CompuBox's 4,000-fight database", against 46% landed by Floyd (S8, ESPN 2012, PRESS; S9, BoxingScene 2012, PRESS).

**Freddie Roach on reading and countering.** Before Pacquiao–Marquez IV, Roach said of Marquez: "He knows Manny likes to move, for the most part, into the right hand, and he knows not to lead with the jab, because if he does, he gets countered over the top… So he leads with right hands a lot." Roach called Marquez "a pure counterpuncher [who] doesn't come forward too often… always fighting off the back foot and looking for the counter". Chris Byrd said Marquez keeps "constantly moving to his left, staying outside that jab hand" and that "this has got to be drilled in him throughout training camp, every single day". Asked what makes his counter work, Marquez said: "It's everything. The timing, the combinations, my intelligence, my experience. My conditioning, too" (S44, ESPN, 2012-12-07, COACH/FIGHTER). Marquez's trainer Nacho Beristain on the knockout counter in fight IV: "we worked a lot… some of the major boxing people said that it was a stroke of luck and lucky shots only exist in the movies" (S45, BoxingScene, 2017-08-07, COACH).

**What the boxer reads.** The jab hand and lead shoulder (Byrd, Roach), which way he likes to move, repeated patterns (FNC's manual even warns "The boxers learn and adapt to your fighting style quickly. Don't repeat yourself", S23, DEV), and head and trunk motion (S6). Which specific tell carries the information: NOT FOUND.

### 1.3 Muay Thai and kickboxing

The kick changes the menu because the legs and body become targets, and because the shin can be used as a shield that hurts the attacker.

- **Check.** Lift the shin so the kick lands on bone rather than the thigh or ribs. Sylvie von Duuglas-Ittu's film study of Karuhat describes a *forward* check from the rear leg that "can block either side kick", sometimes blocks "two kicks in succession with the same block", lets him switch stance by stepping down forward off the check, and "he kicks or teeps off his forward check crazy fast" (S42, 8limbs.us, undated, COACH/FIGHTER). So the check enables a counter: check → teep or kick, or check → stance switch.
- **Catch.** Trap the kicking leg. Under Thai-style scoring as explained by judge Tony Myers: "Catching kicks does not score unless a strike or throw is returned". A fighter whose leg is caught but "can't be brought down" is read as the stronger boxer (S43, 8limbs.us summary of Tony Myers, undated, COACH). So a catch is only worth something if it leads to a sweep, a dump, or a strike.
- **Arm block on body kicks.** The same scoring summary says "Kicks blocked with your arm on the body still score. Kicks blocked 'in position' don't score" (S43). This matters for a game: an arm block on a body kick reduces damage, but the judges may still count the kick.
- **Lean back.** Taught widely (step the rear foot back, weight back, guard up, counter as the kick returns), but I only saw this in search results, so it is not counted.
- **Teep as defence.** A push-kick to stop a forward-moving opponent. EA's UFC 3 developer writes that "a front kick to the body will always interrupt your opponent's strikes or movement, and will always push them backwards", and that front kicks "are easily caught with a successful low block" (S18, 2017, DEV). That is a game rule, not a measured fact.

In MMA the checked leg kick is also a game rule in EA's model: "checked leg kicks deal back considerable damage. Checking two leg kicks in quick succession will cause a health event to the kicker" (S18, DEV). I found no biomechanical study measuring the force on the kicker's shin when it hits a check: NOT FOUND.

### 1.4 MMA

MMA adds the threat of the takedown, so every high-guard decision has to account for a level change.

- **Level change and sprawl.** Across all UFC bouts in the UFCStats data, takedown attempts succeeded 37.4% of the time (18,851 of 50,380), so the average takedown defence rate is about 62.6% (S16, COUNT, to 2026-09-19).
- **Guard height versus the level change.** EA's UFC 3 design has a strike that ducks (body punches, overhands, and by extension a shot) carry "extra vulnerability on the bottom of the chin, leaving you particularly susceptible to uppercuts and knees", and a raised blocking arm leaves the body on that side exposed (S18, DEV). That is a design statement, but it matches the coaching logic that ducking into a knee is the classic punishment.
- **Frame and stiff-arm.** No primary source with a number was found: NOT FOUND.

### 1.5 What each choice costs and opens

The costs and openings of each choice are set out row by row in the §2 menu (columns *cost*, *opening created*, *counter it enables*). Where a cell says "logic", coaches teach it but I found no measured rate for it.

---

## §2 DEFENCE MENU

Column key. *Answers*: which strikes and target zones the option handles. *Deciding attributes*: what makes one fighter better at it than another. *Timing window*: when it has to happen relative to the strike. *Cost*: what he pays. *Opening created*: what it exposes for the attacker's next strike. *Counter it enables*: the typical return. *Anticipation possible?*: can it be started before the strike is visible, from a read? *Tag*: SOURCED means the row's key claims have a source ID. PARTIAL means some cells are coaching logic with no measured source. NOT FOUND means I found no usable source.

| # | Option | Answers (strike + zone) | Deciding attributes | Timing window | Cost | Opening created | Counter it enables | Anticipation possible? | Tag |
|---|---|---|---|---|---|---|---|---|---|
| 1 | High guard / shell / cover-up | Straights and hooks to the head. Partly body when the elbows are tight | Block skill, arm durability, reflex (FNC ties auto-blocking to "Reflex and Blocking ratings", S24) | Held. FNC and Undisputed reward a *timed* block at the moment of impact with a counter opening (S24, S29) | Block strength drains while held and as it absorbs punches (S23). Damage can "bleed through" (S18, S22). Stamina cost (UFC 5: blocking guarded head movement drains stamina, S46) | Body on the side of the raised arm (S18). Guard broken by mixing left/right and round/straight strikes (S18) | Block → immediate return punch (S29) | Y (raise early on a read) | SOURCED (DEV) |
| 2 | Low block / elbow-down body guard | Body punches and body kicks | Same as 1 | Held or timed | As 1. In Muay Thai an arm block on a body kick may still score for the kicker (S43) | The head (UFC 3 low block = both triggers, protects body and legs only, S18) | Return to the head (Undisputed guide, S29) | Y | SOURCED (DEV/COACH) |
| 3 | Shoulder roll / Philly shell | Straight right and jab to the head (turned shoulder); lead hand covers the body | Timing, knee bend, experience (S40) | Just before contact | Stays in the pocket. Relies on being side-on | NOT FOUND as a measured weakness. Coaching logic says the lead-side body and hooks that come around the shoulder | Straight right "almost instantly", uppercut, right hook (S40) | Y | PARTIAL (PRESS/FIGHTER) |
| 4 | Roll with the punch (partial) | Hooks and straights to the head: the head moves with the punch to cut the force | Timing, neck strength (logic) | During contact | Still takes some of the impact | Off balance briefly | NOT FOUND | N (reactive) | NOT FOUND (no measured force reduction) |
| 5 | Parry | Straights (jab, cross, teep) to head or body | Hand speed, reading | About the last third of the strike's path (NOT FOUND in real fighting; games only) | Hand leaves the guard | Feint then a strike to the other side (logic) | Jab or straight. But in S37 parrying (+4.61 residual) and parry + counter (+3.68) went with **losers** | Y | PARTIAL (ACADEMIC for outcome link) |
| 6 | Catch (glove catch of the jab; catching a kick) | Jab to the head; round and body kicks | Hand speed, grip, balance | At contact | One hand busy | Punches while the hands are low (logic) | Jab catch → straight right (S40). Kick catch → sweep or strike, which is the only way it scores (S43) | Y | SOURCED (PRESS/COACH) |
| 7 | Check (shin block) | Round kicks to the legs and body | Balance, shin conditioning, reading the kick early | Leg must be up before the kick lands | Stands on one leg briefly | Punch while on one leg (logic) | Kick or teep off the check; stance switch (S42). Damage to the kicker in EA UFC (S18) | Y (must start early) | SOURCED (COACH/DEV) |
| 8 | Slip (side lean) | Straights (jab, cross) and uppercuts to the head (UFC 3: side slips evade "all straight arced strikes and upwards arcing strikes aimed at the head", S18) | Head-movement skill (UFC 3: evasion window size "determined by your head movement stats", S18), reading | Short evasion window around impact | Stamina in UFC 5 and Undisputed (S26, S29) | Hook from the side he slipped toward (S46). Slipping *into* a hook = extra damage (S46, community) | Straight or hook counter (S40). UFC 3 update 5: slipping a straight gives a 20-frame counter window. Slipping a jab gives none (S19) | Y | SOURCED (DEV) |
| 9 | Duck / bob-and-weave | Hooks and round kicks to the head; also straights (UFC 3 forward slip evades round and straight head strikes and reduces body damage, S18) | Height difference (UFC 3 update 5 made ducking depend on height, S19), legs, timing | Must be fully low when the strike arrives (Undisputed community guide: "you have to be at motion and 100% low", COMMUNITY) | Stamina; balance | Uppercut and knee (S18, S46) | Hooks on the way up; getting outside the shoulder (S41). UFC 3: 36-frame counter window after evading a hook or uppercut (S19) | Y (weave needs to start on a read of the hook) | SOURCED (DEV/COACH) |
| 10 | Lean / pull back (sway) | Hooks, uppercuts, head kicks; straights only at the edge of range (S18, S19) | Range, reach, balance | Evasion frames; range-dependent (S18) | Weight on the back foot | Body shots and forward-stepping straights (S46; S18) | Straight as his hand comes back ("pull counter", S29) | Y | SOURCED (DEV) |
| 11 | Step back / out of range | Everything, if he is far enough | Foot speed, ring IQ, reach | Before the strike reaches full extension | Gives up ground; pro judges may call it passive | Cornered on ropes or cage | Counter as he over-reaches. S37 winners: shifting back 23.3% of defensive actions, shifting back + counter 14.9% | Y | SOURCED (ACADEMIC) |
| 12 | Pivot / angle | Straights and forward pressure | Footwork, agility | Before or during his entry | Little stamina (logic) | NOT FOUND | Pivot + counter was linked to winners (+2.20 residual, S37) | Y | SOURCED (ACADEMIC) |
| 13 | Jam / smother (step inside the arc) | Hooks, round kicks, long straights: take away their range | Courage, timing, strength, reading | Before the strike reaches its best range | Walks into possible short strikes, elbows, knees | Short uppercuts, knees, elbows (S18 lists elbow range as its own range) | Clinch, short hooks, takedown (MMA) | Y | PARTIAL (DEV for ranges) |
| 14 | Clinch / tie-up | Everything at close range | Clinch strength and skill | After closing the gap | Stamina; in Muay Thai the clinch is a scoring battle of its own | Knees and elbows in the Muay Thai clinch | Knees, dumps (Muay Thai); takedowns (MMA) | Y | PARTIAL |
| 15 | Counter-first (beat him to it) | Any slow or long strike (round kick, overhand) | Hand speed, reading, a shorter strike | Your strike must land before his (UFC 3: stopping power; a straight to the head always interrupts a forward-moving strike; a lead hook "check hook" always interrupts a forward-moving strike, S18) | Risk of a double hit (in UFC 3, if both land on the same frame both deal full damage, S18) | Being hit at the same moment | It *is* the counter | Y (needs a read) | SOURCED (DEV) |
| 16 | Level change / sprawl (MMA) | Takedown shots | Wrestling, hips, reaction | During the shot | Hands drop, head low | Knee to the head as he changes level (S18: ducking exposes the chin to knees) | Front headlock, strikes, getting up | Y | SOURCED (COUNT for TD rate) |
| 17 | Nothing (never saw it) | — | — | — | Full damage. In UFC 3 a strike landed into a "vulnerable" region can do up to 6× damage (S18, DEV) | — | — | — | SOURCED (DEV, game rule only) |

**Prose notes on the menu.** The main correction to the two-option model is **range management** (rows 11–13), a third family that dominates among amateur winners. S37's winners (1,456 defensive actions coded) used: single counterpunch 17.7%, counter + combination 19.4%, shifting back 23.3%, shifting back + counter 14.9%, pivoting 5.6%, ducking 4.0%, parrying 3.6%. Losers parried more (9.7%; parry + counter 4.4% vs 1.2%). S37 had no plain "block" category, so block frequency is NOT FOUND there. Olympic men made about 20 punches, 2.5 defensive movements and 47 vertical hip movements per minute (S38 via S37). Much defence is constant small movement that coders do not count.

The second correction: **"dodge = no damage" and "block = reduced damage" is only roughly true.** A dodge can be partial or can backfire (slipping *into* a hook, S46). A back-sway works only near the edge of the strike's range (S18). A block can stop all of a jab and only part of a head kick (S18, DEV). For real humans I found **no** measured figure for force through a block (§4).

---

## §3 Reaction and anticipation numbers

| Quantity | Value | Conditions / definition | Source | Date | Type |
|---|---|---|---|---|---|
| Simple visual reaction time, karate athletes vs novices | 231–241 ms vs 242–252 ms (not significantly different) | Key press to a dot; left/right hand | S1 Mori et al. | 2002 | ACADEMIC |
| Choice reaction, dot stimulus (high/low) | Athletes 272–273 ms; novices 296–302 ms | Significant group effect | S1 | 2002 | ACADEMIC |
| Choice reaction to *video* of a real attack (upper vs middle target) | Athletes 552 ms; novices 657 ms (~100 ms athlete advantage, credited to anticipation) | Video attacks lasted 430–660 ms from motion start | S1 | 2002 | ACADEMIC |
| Irreducible neural and motor delay | ~200 ms | Mori citing McLeod 1987 | S1 (secondary) | 2002 | ACADEMIC |
| Realistic full defensive reaction | ~300–400 ms | Williams & Elliott 1999, as cited | S1 (secondary) | 2002 | ACADEMIC |
| Target read from partial view | Athletes 96% correct vs novices 80% | Video cut at frame 7 (~233 ms of attack motion at 33 ms per frame) | S1 | 2002 | ACADEMIC |
| Expert vs non-expert anticipation, pooled | Accuracy 83.3% vs 68.5%. Accuracy effect size 1.24 (Hedges g). Reaction time SMD −1.00 | 27 studies, 233 data sets. Karate, taekwondo, boxing (6 studies), sanda, judo, fencing. Boxers were an exception on accuracy | S7 Zhang, Piras, Chen et al. | 2022 | ACADEMIC |
| Fastest reported visual RT in combat athletes (fencers) | 204 ms | Button press to a screen stimulus (Di Russo 2006, as cited) | S6 (secondary) | 2019 | ACADEMIC |
| Karate punch duration | 242 ms | VencesBrito et al. 2011, as cited | S6 (secondary) | 2019 | ACADEMIC |
| Jab, initiation → contact (maximal, into a bag) | 405 ± 150 ms | 15 amateur boxers, 3D motion capture. "Initiation" = start of the countermovement | S2 Stanley et al. | 2018 | ACADEMIC |
| Rear cross | 495 ± 150 ms | same | S2 | 2018 | ACADEMIC |
| Lead hook | 657 ± 145 ms (62% longer than the jab) | same | S2 | 2018 | ACADEMIC |
| Rear hook | 586 ms | same | S2 | 2018 | ACADEMIC |
| Lead / rear uppercut | 627 ± 103 ms / 606 ± 100 ms | same | S2 | 2018 | ACADEMIC |
| Earlier literature pooled in S2 | Straights 357 ± 178 ms; hooks 477 ± 203 ms | Cheraghi 2014, Kimm & Thiel 2015, Piorkowski 2011, Whiting 1988, as cited | S2 (secondary) | 2018 | ACADEMIC |
| Cross, guard → target only (throw phase) | 111 ms (experienced) vs 102 ms (novice). Whole cycle incl. contact and return: 402 ms. Contact 122 ms, retraction 169 ms | Wearable sensor study | S3 Sensors 21(23):7882 | 2021 | ACADEMIC (read as full-text excerpt) |
| Hook, whole cycle | 441 ms experienced vs 479 ms novice | same | S3 | 2021 | ACADEMIC (excerpt) |
| Peak fist speed | Jab 5.85 m/s; cross 6.97 m/s; lead hook 11.95 m/s | same as S2 | S2 | 2018 | ACADEMIC |
| Fist speed at contact; timing of peak | 5.9–8.2 m/s at contact; peaks of 6.6–12.5 m/s reached 8–21 ms before contact | 4 experienced boxers, bag | S51 Whiting et al., AJSM (abstract) | 1988 | ACADEMIC |
| Round kick, stimulus → impact (taekwondo) | Reaction 162 ± 40 ms; kick time 587 ± 90 ms (Estevan 2013, as cited). Kick times 560–610 ms in the citing study | Kicks from a stance | S5 JHK (doi 10.5114/jhk/194067) | 2025 | ACADEMIC |
| Chaining a second kick | Adds 25–40 ms of central processing and ~50 ms of execution | same | S5 | 2025 | ACADEMIC |
| Round kick, full cycle incl. recoil | Muay Thai 1.02 ± 0.15 s; taekwondo 1.54 ± 0.52 s. Recoil = 69% of the cycle; preparation 6%, chamber 14%, extension 11% | Support toe-down → kicking heel-down | S4 Gavagan & Sayers, PLoS One | 2017 | ACADEMIC |
| Derived: round kick onset → impact | ≈ 0.32 s (31% of 1.02 s) | My arithmetic from S4's phase shares (shares were pooled across disciplines) | S4 → derived | — | PROXY |
| Muay Thai kick foot speed at impact | 7.22 m/s (peak 13.24 m/s) | same | S4 | 2017 | ACADEMIC |
| Effect of fatigue on reaction | Taekwondo reaction time rose from 145 ± 51 ms to 223 ± 133 ms after a time-to-exhaustion kicking test. Kick impact fell from 43 ± 27 g to 13 ± 10 g. Response and performance time did not change | 7 male athletes | S49 Sant'Ana et al., Sports Biomechanics (abstract) | 2017 | ACADEMIC |
| Effect of feints on defender accuracy in combat sports | No % figure found. Qualitative: in French boxing, higher-skilled boxers produced *more* false alarms to fakes than lower-skilled boxers (Ripoll et al. 1995, as summarised in S50). S6 notes a kick's direction "can be easily changed… or transformed into a feint, at the beginning of the attack" but not just before contact | — | S6 | 2019 | ACADEMIC (qualitative) |

**Reading the table.** Set a 405 ms jab (S2) against a ~200 ms nerve-and-muscle floor (S1) and a 300–400 ms realistic defensive reaction. A defender who starts reacting only when the fist starts moving barely makes it against a jab, and fails against a fast one (S3's 111 ms throw phase). He has more time against a hook (~590–660 ms). Against a round kick, onset to impact is roughly 0.3–0.6 s depending on how it is defined (S4, S5). That is why checks must start early, and why kicks are easier to read than jabs. The two jab figures (405 ms vs 111 ms) look contradictory because they measure different spans. S2 starts at the first countermovement. S3 starts when the fist leaves the guard. For a game, the useful quantity is the time from **first visible tell** to impact, which is closer to S2's definition.

**How much is anticipation and how much is reaction?** No study gives a single split, so that is NOT FOUND. The best evidence is indirect. (a) Experts are no faster at *simple* reaction, but about 100 ms faster at choosing a response to a realistic attack (S1). (b) Experts can call the target from the first ~233 ms of motion (S1). (c) The pooled expert advantage is large for accuracy (effect size 1.24) and for reaction time (−1.00) (S7). The reasonable reading is that almost all of the expert's edge is in anticipation.

---

## §4 Block placement: head, body, legs, and force through a block

**How often is the guard at the wrong height?** No direct count of "guard at wrong height" events exists in CompuBox or UFCStats: NOT FOUND. The best measurable stand-in is how often strikes land by target zone. In the UFC, body and leg strikes land about twice as often as head strikes:

| Target (UFC sig. strikes, all bouts 1994 – 2026-09-19) | Share of attempts | Landing rate | Share of strikes landed |
|---|---|---|---|
| Head | 77.5% | 36.5% | 63.1% |
| Body | 13.4% | 69.2% | 20.7% |
| Leg | 9.1% | 80.4% | 16.3% |
| Position: distance | 83.1% | 39.9% | 73.9% |
| Position: clinch | 8.5% | 69.8% | 13.2% |
| Position: ground | 8.4% | 69.0% | 12.9% |

(S16, COUNT: 1,471,930 significant-strike attempts over 20,978 rounds in 8,923 bouts, from a public GitHub mirror of UFCStats, data through UFC 331 on 2026-09-19.) Caution: body and leg strikes are also thrown in safer moments (after a combination, or when the defender is backing up), so part of the gap is shot selection, not only guard height.

In boxing, CompuBox reported for the lightweight division average: 28.2% of all punches, 17.7% of jabs and 35.4% of power punches land (S14, ESPN/CompuBox, 2024-07-06, PRESS). About 30% of Shakur Stevenson's landed punches were body shots (30.3%), and 29.3% of his opponent Harutyunyan's (S14). CompuBox's overall power-punch average was 36.9% (S15, 2019, PRESS). CompuBox does not publish a body vs head accuracy split in the pages I read: NOT FOUND.

**Force through a block versus clean.**
- **Real fighters, forearm or glove block vs unblocked head strike: NOT FOUND.** I found no study that measured force or head acceleration for the same strike landing clean versus into a live arm or glove guard.
- **Closest proxies (different situations, not blocks):**
  - Protective padding on a head dummy: in punch-machine tests, an AIBA headguard cut peak head acceleration from about 130 g to about 85 g, roughly a one-third cut. Angular acceleration at 6.85 m/s was "almost halved" (S35, McIntosh & Patton, BJSM 2015, ACADEMIC). This is padding on the head, not an arm in the way.
  - A taekwondo forearm guard cut total impact force on a load cell from 127.5 ± 1.18 kg to 107.25 ± 0.52 kg, about a 16% cut (S36, Ramazanoglu, Arch Budo 2012, ACADEMIC, abstract only). This is equipment on the forearm, not the force passed on to the head.
- **Game conventions (DEV):** EA UFC 3: "the high block may protect you from all the damage, or it may allow a baseline percentage of that strike's damage to bleed through. For example, head kicks have considerable bleed through, whereas jabs have none" (S18, 2017). EA UFC 5: spinning-elbow bleed-through halved "10% to 5%", where bleed-through is "the percentage of damage that goes through regardless of the block meter" (S22, 2024-03-04). The block also wears down: FNC "Block Strength weakens the longer a boxer holds their guard up and as it absorbs punches" (S23). In UFC 5 the long-term block health threshold changed from 85 to 60 (S22). Undisputed: block health regenerates more slowly while block is held and drains faster when dazed (Grok lead, unverified; see Appendix A).

**Standing guard techniques in the sources:** peek-a-boo high hands, chin tucked, square stance (S41). Shoulder roll with the lead shoulder in front and the right hand hidden (S40). Muay Thai high guard with the shin ready to check (S42). UFC 5 added a specific animation for "a high block to defend against leg kicks", where fighters "guard the side of their head when the opponent throws leg kicks" (S21, EA, Dec 2023, DEV). That is a developer admitting that the high guard alone does not answer a leg kick.

---

## §5 Evasion: attributes, risks, counter windows

**Attributes that decide evasion (by source).**
- *Reading and anticipation*: the biggest factor in the academic work (S1, S6, S7).
- *Head-movement skill*: EA UFC 3 sizes the evasion window by the "head movement stats" (S18, DEV).
- *Height*: UFC 3 update 5 made ducking depend on height, so that "an extreme height difference (think Struve vs. Cormier) will render the duck a completely ineffective tool for the taller fighter" (S19, DEV).
- *Range and reach*: a back-sway works only when the strike would land at the edge of its range (S18). In UFC 3 a long-reach fighter also pays an execution-frame penalty and has stricter range needs for maximum damage (S18).
- *Stamina and fatigue*: FNC manual: "As your stamina decreases, your agility goes down, too, lessening your ability to quickly and effectively lean. Lean early, not later" (S23, DEV). Leaning also "requires your feet to be set firmly on the ground" (S23).
- *Foot speed and ring IQ*: shifting back and pivoting were the winners' tools in S37 (ACADEMIC).
- *Experience*: boxers with more than five years of experience had faster visual-motor reaction times than boxers with 1–3 years in a 2023 study (JPES 2023 abstract, seen in search only; no ms values read, so not counted).

**Which evasions carry which risks.** Slip toward a hook = hit harder (S46: side-to-side head movement "leaves the fighter vulnerable to hooks"). Duck into an uppercut or knee (S18: "particularly susceptible to uppercuts and knees"; S46). Lean back into a follow-up (S46: "leaves the body wide open"; S19: after a back slip only round strikes can be blocked on the way back). Evade the first punch and eat the second (S19: slip a jab-straight, throw a hook, "the straight is likely going to land before the hook"). All of these are game rules or guides. Real-fight rates: NOT FOUND.

**Counter windows opened (games only; the real-fight figure is NOT FOUND).** EA UFC 3 update 5 (S19, DEV):

| Evaded strike | Guaranteed counter window |
|---|---|
| Jab | None ("no longer provide you with a safe counter striking window") |
| Straight | 20 frames ("enough time to capitalize with a faster counter, but not enough time to be considered safe") |
| Hook, uppercut, other | 36 frames (same as before the update) |

The frame rate for these frames is not stated in the note. At an assumed 30 fps, 20 and 36 frames would be ~0.67 s and ~1.2 s. At 60 fps they would be ~0.33 s and 0.6 s. That conversion is PROXY. S19 also split head movement into *minor* (less head travel, less stamina, less vulnerability, faster counters, harder to time) and *major* (the opposite). FNC's reviewer noted counter windows became narrower than in Round 4, "where the counter system was almost too powerful" (S24, Eurogamer 2011, PRESS).

---

## §6 Anticipation: reading the pattern and moving before the tell

**What anticipation is in the evidence.** Two layers show up in the sources.
1. *Within one strike*: picking up the tell in the first part of the motion. Karate athletes needed about 7 frames (~233 ms) of attack video to call upper vs middle at 96% accuracy (S1). Experts fixate on a central pivot, the head and trunk, and scan up and down the opponent's centre line (S6). In one karate study, masking the attacker's face *improved* recognition, which S6 reads as possible deception coming through facial expression (Petri et al. 2018, via S6).
2. *Across a fight*: learning his habits. The coach and fighter quotes all describe this. Roach says Marquez "knows Manny likes to move… into the right hand" and "knows not to lead with the jab" (S44). Beristain says the counter that knocked out Pacquiao was drilled for weeks, and "lucky shots only exist in the movies" (S45). Marquez gives "the timing… my intelligence, my experience" (S44). FNC's AI is built on this idea: "The boxers learn and adapt to your fighting style quickly. Don't repeat yourself" (S23, DEV).

**Specific patterns the operator asked about.** *Lazy jab*: the classic reason for the over-the-top counter (Roach on Marquez, S44; Mayweather catching the jab and coming "over the top", S40). *Dropped hand after a kick*: in EA's design a missed or blocked roundhouse leaves the kicker in "a state where you are both vulnerable, and have no way of defending yourself" (S18, DEV). *Rhythm*: guides advise throwing "in between his rhythm" (S29). Measured frequencies for all three: NOT FOUND.

**How many repetitions does it take to spot a pattern?** One on-mat karate study measured this directly. When one attack was repeated every four actions, "the experts picked up the occurrence of the attack pattern after the fifth repetition whereas novices did not". That let experts improve both decision time and accuracy when blocking and counter-attacking (S48, Milazzo et al., J Sports Sci 2016, ACADEMIC, abstract). This is the only measured "time to read" figure I found. It is counted in repetitions of a pattern, not in rounds.

**How many rounds does it take to read a man?** No direct measure was found: NOT FOUND. Three indirect signals, none conclusive:

| Signal | Numbers | Source | Type |
|---|---|---|---|
| UFC sig.-strike accuracy by round, only 5-round bouts that reached round 5 | R1 43.9% → R2 44.7% → R3 45.0% → R4 45.5% → R5 45.5% | S16 | COUNT |
| Same, 3-round bouts that went to round 3 | R1 43.3% → R2 44.2% → R3 44.2% | S16 | COUNT |
| IBA women's finals: Defensive Effectiveness Ratio by round | Winners 0.58 → 0.67 → 0.70. Losers 0.69 → 0.59 → 0.60 | S37 | ACADEMIC |
| IBA women's finals: Offensive Effectiveness Ratio (landed ÷ thrown) by round | Winners 0.39 → 0.38 → 0.39. Losers 0.26 → 0.28 → 0.29 | S37 | ACADEMIC |
| Olympic men: winners showed greater punching accuracy "particularly in the later rounds" | qualitative | S38 via S37 | ACADEMIC (secondary) |

Reading these honestly: UFC accuracy rises by about 1–1.6 percentage points from round 1 to later rounds. That fits "the attacker reads the defender", but it fits "the defender tires" equally well, and the data cannot separate the two. In the IBA finals, the eventual winners' defensive ratio rose round by round while the losers' fell. That is the pattern you would expect if the better fighter was reading the other, but it comes from 12 bouts, and S37's DER definition (the defender's defensive actions divided by the opponent's missed punches) is unusual. For a game, "reading improves over rounds" is a PROXY assumption with weak support, not a measured rate.

**Anticipation versus feints.** Feints are the attacker's counter-move to anticipation. The academic sources confirm experts anticipate better (S7). They also confirm feint opportunities shrink as an attack unfolds, because direction "can be easily changed… or transformed into a feint, at the beginning of the attack. However, this would be not possible just before the contact" (S6). A 2017 review of deceptive actions in sport (S50, Güldenpenning, Kunde & Weigelt, Frontiers in Psychology, ACADEMIC) notes "one study in French boxing, showing that higher skilled boxers produced more false alarms in response to fakes than lower skilled boxers" (Ripoll et al. 1995). So in boxing, skill can make a fighter *more* ready to bite on a feint, because he commits early. A percentage figure for how much a feint cuts defender accuracy in combat sports was NOT FOUND. EA MMA (2010) had a dedicated fake modifier on the shoulder buttons (S33, GameSpot review, 2010-10-21, PRESS).

**Cost of anticipating wrong.** Committing early to the wrong read puts him into the matching opening (S18, S46 game rules). Real-fight measure: NOT FOUND.

---

## §7 Countering

**The counter each defence enables (sourced where possible).**

| Defence | Typical counter | Source / tag |
|---|---|---|
| Slip (outside the jab) | Straight right over or inside the jab; lead hook | S40 (PRESS); UFC 3: counter strikes off slips "sped up… a slipping straight is likely to beat most strikes thrown in combination" (S19, DEV) |
| Pull / lean back | Straight as his hand returns ("Pull Counter") | S29 (PRESS/COMMUNITY); Evolve lean-back counters (lead only) |
| Parry | Jab or straight | Coaching logic only. S37: parry + counter linked to *losing* (ACADEMIC) |
| Catch (jab) | Straight right "over the top" | S40 (PRESS) |
| Check (kick) | Kick or teep off the check; stance switch | S42 (COACH/FIGHTER) |
| Catch (kick) | Sweep, dump, or strike. Only scores if something is returned | S43 (COACH) |
| Block | Return punch right after (Undisputed "block counter") | S29 (PRESS) |
| Duck / weave | Hooks on the way up; "outside the other fighter's shoulder… fight ending punch" | S41 (COACH via PRESS) |
| Shoulder roll | Short straight right, uppercut, sometimes right hook | S40 (PRESS) |
| Step back | Counter as he over-reaches ("shifting back + counterattack" 14.9% of winners' defensive actions) | S37 (ACADEMIC) |
| Pivot | Pivot + counter linked to winning (+2.20) | S37 (ACADEMIC) |
| Strike first | Straight or check hook into a forward-moving opponent always interrupts (game rule) | S18 (DEV) |

**Counter-punchers' CompuBox numbers.** CompuBox's "plus/minus" is a fighter's own connect % minus his opponents' connect %.

| Fighter | Own connect % | Opponents' connect % | Plus/minus | Span | Source (date, type) |
|---|---|---|---|---|---|
| Floyd Mayweather Jr. | 46% | 16% | +30 | Last 9 fights to Apr 2012 | S9 BoxingScene/CompuBox 2012; S8 ESPN 2012 (PRESS) |
| Mayweather vs J. M. Marquez (single fight) | 59% | 12% | +47 (CompuBox's most one-sided major fight) | 2009 | S10 BoxingScene (PRESS) |
| Juan Manuel Marquez | 36% | 29% | +7 | Last 5 fights to 2009 | S12 Bad Left Hook/CompuBox 2009 (PRESS) |
| Bernard Hopkins | 30% | 27% | +3 | Last 5 fights to 2009 | S12 (PRESS) |
| James Toney vs Iran Barkley (single fight) | 65% | 23% | +42 | — | S10 (PRESS) |
| Pernell Whitaker vs Santos Cardona (single fight) | 61% | 24% | +37 | 1994 | S10 (PRESS) |
| Canelo Álvarez | 38% | 24% | +14 | Last 7, to 2012 | S9 (PRESS) |
| Canelo Álvarez (later) | 35% | 21.3% | +13.7 | CompuBox report, last 13 fights | S13 CompuBox (undated page, PRESS) |
| Shakur Stevenson | 36.9% | 16.7% | +20.2 (#1) | last 12 | S13 (PRESS) |
| Dmitry Bivol | 30.9% | 14.2% | +16.7 | last 13 | S13 (PRESS) |
| Stevenson (ESPN version) | 33.7% | 13.3% total, 16.7% power | — | last 9, to Jul 2024. Note: the CompuBox report (S13) gives 16.7% as *total* and 19.5% as power, so the two sources disagree on which figure is which | S14 ESPN 2024 (PRESS) |
| CompuBox overall average | 32% (all punches) | — | — | database of 4,800+ fights, 2012 | S9 (PRESS) |
| Lightweight division average | 28.2% total; 17.7% jab; 35.4% power | — | — | 2024 | S14 (PRESS) |

Pattern: elite defensive boxers hold opponents to about **12–17%** of punches landed (Mayweather 16%, Stevenson 13.3–16.7%, Bivol 13.0–14.2%), against a division average of about **28%** and an overall database average of about **32%**. Classic "counter-punchers" are not all elite defenders on paper. Marquez (+7) and Hopkins (+3) sat in the middle of the pack in 2009 (S12). A counter-puncher's value can come from *what* he lands (hard counters into an opponent moving forward) rather than from a low opponent connect rate.

**How often does a counter attempt eat the second shot?** NOT FOUND in any real-fight data. The only concrete statement is a design choice by EA: after update 5, slipping a jab gives no safe window, because "throwing a counter strike will leave you open for potentially getting hit with a follow up strike that was thrown in combination with the jab" (S19, DEV). S37 found "counterpunch + combination" offensive actions *marginally* associated with losers (+1.96) and single counterpunches marginally associated with losing outcomes (+1.98). That hints that counters are risky at amateur level, but it does not measure being hit back.

**What makes a counter elite (as the sources describe it).** Marquez: "timing, the combinations, my intelligence, my experience… conditioning" (S44). Beristain: drilled repetition of one specific counter for one specific opponent (S45). Byrd: a game plan "drilled… every single day" so the fighter does not slip back into bad habits (S44). BOXRAW on Mayweather: the counter is hidden behind the lead shoulder and comes back "almost instantly" (S40). The academic view is anticipation (S1, S7): the counter-puncher starts his answer from the read, not from the sight of the punch.

---

## §8 Defensive numbers: CompuBox and UFCStats

**UFC significant-strike defence (S16, COUNT).** "Str. Def" is computed as 1 − (opponents' significant strikes landed ÷ attempted), over all UFC rounds in the UFCStats mirror through UFC 331 (2026-09-19). The sample is every fighter with at least 350 significant strikes attempted against him, which gives n = 1,281 fighters.

| Measure | Value |
|---|---|
| League-wide opponent sig.-strike accuracy | 44.9% (660,325 / 1,471,930), so league-average defence is about 55.1% |
| Median fighter Str. Def | **55.3%** |
| 10th / 90th percentile | 46.5% / 63.5% |
| Georges St-Pierre | 73.1% (1,842 attempts against) |
| Demetrious Johnson | 67.2% |
| Dominick Cruz | 65.8% (UFC-only). UFC.com shows 71% (S17), likely a wider sample; I could not reconcile it |
| Jon Jones | 64.1% |
| Ilia Topuria | 62.1% |
| Islam Makhachev | 61.5% |
| Sean O'Malley | 59.8% |
| Anderson Silva | 59.5% |
| Max Holloway / Alexander Volkanovski | 58.7% / 58.7% |
| Israel Adesanya | 55.8% |
| Kamaru Usman / Merab Dvalishvili / Conor McGregor / Alex Pereira | 54.6% / 54.0% / 53.9% / 52.6% |

My figure counts all significant strikes, including clinch and ground strikes, which is also what UFCStats' own "Str. Def" does. Wrestlers who spend time on top (St-Pierre, Johnson) score high partly because they are rarely struck on the ground. So "high Str. Def" is not the same thing as "elite head movement". Adesanya, famous for head movement and range, sits near the median. The "head movement vs high guard style" comparison asked for in the brief needs style labels that UFCStats does not have: NOT FOUND.

**Per weight class, opponent sig.-strike accuracy (S16, COUNT).** Flyweight 43.6%, bantamweight 43.8%, featherweight 44.3%, lightweight 43.4%, welterweight 44.7%, middleweight 46.0%, light heavyweight 47.1%, heavyweight 48.8%. Women: strawweight 44.6%, flyweight 43.2%, bantamweight 45.5%. Strikes land more often as weight goes up, about 5 points more at heavyweight than at lightweight. A game could use this as a per-class modifier (PROXY).

**Boxing (CompuBox, PRESS).** See the table in §7. Elite defenders hold opponents to 12–17% landed, against a division average of ~28% and a database average of 32%. A CompuBox per-weight-class *opponent* connect table: NOT FOUND (only the lightweight average was found, S14).

---

## §9 Game precedent

| Game | Block model | Evade model | Parry / timed defence | Counter window | Source |
|---|---|---|---|---|---|
| Fight Night Champion (EA, 2011) | Hold block. It "will automatically guard… high or low" depending on Reflex and Blocking ratings. Block Strength weakens while held and as it absorbs punches | Lean (feet must be planted; agility drops with stamina: "Lean early, not later"); weave by quarter-circle | A timed block as the punch connects acts as the parry | "Counterpunches now have a narrower window of execution and feel more balanced" than Round 4 | S23 manual (DEV); S24 Eurogamer 2011-02-23 (PRESS) |
| EA Sports MMA (2010) | Hold block | Sway while blocking | Parry = block + flick toward the strike (community-described) | NOT FOUND | S33 GameSpot 2010 (PRESS). Parry input from community pages only |
| EA UFC 3 (2018) | High block (head) / low block (body + legs). Bleed-through per strike (jab 0, head kick "considerable"). Guard breaks under alternating left/right, round/straight patterns | Right-stick slips in 4 directions. Window size = head-movement stat. Forward slip evades round + straight head strikes. Side slip evades straights + uppercuts. Back slip only at edge of range. Lunges with evasive properties | **Parries removed** ("The biggest shock to returning players will likely be that parries are gone") | Update 5: jab 0, straight 20 frames, hook/uppercut 36 frames. Minor vs major head movement | S18 (DEV, 2017-11-23); S19 (DEV) |
| EA UFC 4 (2020) | Not researched in depth. NOT FOUND in this pass | — | — | — | — |
| EA UFC 5 (2023) | Block strength restored to UFC 4 level at launch after the beta was "broken too easily". Jab block-breaking nerfed (stopping power 40% → 30%, jab damage −20%). Leg-kick head-guard animation. Bleed-through % per strike (spinning elbows 10% → 5%) | Head movement "far more responsive" (VideoGamer) but costs stamina | None | Stamina cost for the *attacker*: blocked strikes +7.5%, missed/evaded +10% (Mar 2024 patch) | S20 (DEV, 2023-10-08); S21 (DEV, Dec 2023); S22 (DEV, 2024-03-04); S25, S26 (PRESS) |
| Undisputed (Steel City Interactive, 2023–24) | Hold block with height direction (head/body). Block health system | Lean (pull counter); slips cost stamina ("a bit underpowered", early guide); side step | No parry mechanic (community requests for one, 2024) | Counter = land during his miss or recovery; white flash. Power punches that miss or are blocked have longer recovery | S27 IGN 2024-10-07; S28 patch notes; S29 Gamer Digest (PRESS); S34 Reddit 2024-08-19 (COMMUNITY) |
| Sifu (Sloclap, 2022) | Blocking "will quickly fill your balance gauge" | Dodge (dash); "avoid" by ducking or jumping specific strikes | Parry "at the right time" deflects the blow, "unbalancing your opponent and opening opportunities to counterattack or to throw them down". Inspired by Pak Mei's use of the parry to break structure | Parry frames not published by Sloclap: NOT FOUND. Community guess "maybe 0.2s or 12-20 frames (per 60)" (COMMUNITY, unverified) | S30 PlayStation Blog 2021-11-18 (DEV); S31 Colussi/Sloclap quotes (DEV); S32 Reddit (COMMUNITY) |

**What reviewers praised.** FNC: a timed block or lean/weave is "the most effective method of avoiding damage and setting up lethal counterpunch opportunities", and the narrower counter window felt "more balanced" (S24). UFC 5: "blocks are much stronger, preventing flash knockouts and easy overpowering" (IGN, S25). "The head movement is far more responsive… although it will impact your stamina" (VideoGamer, S26). EA MMA: easy defence plus finite stamina meant "going on an all-out offensive is rarely a good idea" (S33).

**What reviewers and players hated.** UFC 5: "Blocks are still a little iffy" (S26). Strikes that "track" slips (COMMUNITY), which EA partly admitted by fixing spinning strikes that "were unduly tracking evasions" (S22). In the UFC 5 beta the block was broken "too easily" by jab-straight spam (S20). Round 4's counter system was "almost too powerful" (S24), and players remember FNC-era "dancing with parries" (S34). Undisputed has no parry, and players find counter-only opponents tedious (S34). Sifu's parry window feels "very small" to players (S32).

**Lesson for FightCamp (as a manager sim, not an action game).** Each shipped game hit the same problems: blocks too strong (turtling) or too weak (spam breaks them), evasions that "track", and counter windows that are either too generous (Round 4) or unsafe for everything (UFC 3 after update 5, for the jab). EA's solution was to grade the counter window by what was evaded (jab 0 / straight 20 / power 36 frames) and to charge the *attacker* stamina for misses and blocked strikes. Both carry over naturally to a simulation.

---

## §10 A model for the game: perceive → choose → execute → consequence

This is a proposal for how FightCamp's exchange resolver could decide one incoming strike. It is written so the operator's two-option idea (block or dodge) is kept but widened. Every constant is tagged **SOURCED** (taken from a source ID), **PROXY** (borrowed from a nearby measurement or another game; stands in for a real value), or **NOT FOUND** (a placeholder that needs tuning). Fighter attributes are FightCamp's own (the names are suggestions): `Reflex`, `Reading` (fight IQ / anticipation), `HeadMovement`, `Footwork`, `Guard` (block skill), `Durability`, `Stamina`, `Reach`, `Height`, `Clinch`, `Wrestling`.

### Step 1 — PERCEIVE: did he read it, and when?

For each incoming strike, compute `time_available = strike_travel_time − defender_latency`, then grade the read.

| Constant | Proposed value | Tag | Source / reasoning |
|---|---|---|---|
| Neural and motor floor (nobody reacts faster) | 200 ms | SOURCED | S1 (citing McLeod 1987) |
| Simple reaction, typical athlete | 230–250 ms, *not* skill-dependent | SOURCED | S1: no expert–novice difference |
| Realistic defensive reaction | 300–400 ms | SOURCED (secondary) | S1 citing Williams & Elliott 1999 |
| Expert choice-time advantage from reading | ~100 ms faster than a novice | SOURCED | S1 (552 vs 657 ms) |
| Read accuracy from an early view | Expert 96%, novice 80% at ~233 ms of attack motion | SOURCED | S1 |
| Pooled expert vs non-expert accuracy | 83.3% vs 68.5% | SOURCED | S7 |
| Jab travel (tell → contact) | 405 ms (maximal). Scale down for short, snappy jabs | SOURCED (definition caveat) | S2 |
| Cross / lead hook / rear hook / uppercuts | 495 / 657 / 586 / 606–627 ms | SOURCED | S2 |
| Round kick onset → impact | 300–600 ms depending on definition | SOURCED range + PROXY pick | S4 (derived ~0.32 s), S5 (560–610 ms stimulus → impact) |
| Fatigue penalty on reaction | +78 ms (145 → 223 ms) at exhaustion | SOURCED (taekwondo, n = 7) | S49 |
| Distance effect | At close range available time "can be less than a simple reaction time" | SOURCED (qualitative) | S6 |
| Feint effect on read accuracy | Placeholder −10 to −20 points; higher-skill boxers *more* prone to bite on fakes | NOT FOUND (number); direction SOURCED | S50 (Ripoll 1995 via review) |
| Pattern learning | Opponent's repeated combination becomes "known" after ~5 repetitions for an expert reader; never for a novice | SOURCED (karate, lab) | S48 |
| Round-over-round read improvement | +0.5 points of opponent accuracy per round (R1 → R5 ≈ +1.6) | PROXY | S16 (cannot separate reading from fatigue) |

Read grades: **Early** (read before or at the tell: the defender may pick any option, including anticipate-and-counter), **Late** (saw it with time for only fast options: block, small slip, roll), **None** (never saw it: full damage). A suggested rule: P(early) rises with `Reading`, pattern familiarity (S48), and the strike's telegraph (hooks and kicks are longer than jabs, S2/S4). It falls with feints, fatigue (S49), and close range (S6). The exact curve is NOT FOUND and needs tuning.

### Step 2 — CHOOSE: what does he do?

The option set is the §2 menu, grouped into eight families:
1. **Block** (high, low, or leg check), 2. **Reduce** (shell, roll, shoulder roll), 3. **Redirect** (parry, catch), 4. **Evade in place** (slip, duck/weave, pull), 5. **Deny range** (step back, pivot, jam), 6. **Tie up** (clinch, sprawl), 7. **Strike first** (interrupt), 8. **Anticipate + counter** (commit early to a read and pre-load the counter).

Choice rules and constants:

| Rule | Value | Tag | Source |
|---|---|---|---|
| Style weights set the default family | Peek-a-boo → evade + counter. Shell → reduce + counter. Outside boxer → deny range. Muay Thai → check / catch / teep | SOURCED (qualitative) | S41, S40, S37, S42 |
| Winners' defensive mix (amateur boxing), usable as a "good defender" prior | Shift back 23.3%, shift back + counter 14.9%, single counter 17.7%, counter + combo 19.4%, pivot 5.6%, duck 4.0%, parry 3.6% | SOURCED | S37 |
| Losers over-use parry | 9.7% parry, 4.4% parry + counter | SOURCED | S37 |
| Block only covers the chosen height | High = head; low = body + legs | SOURCED (DEV) | S18 |
| Leg kick needs a check or a specific guard | UFC 5 added a leg-kick guard animation | SOURCED (DEV) | S21 |
| Anticipate-and-counter needs an Early read, else it becomes a wrong commitment | — | PROXY (design) | S1, S50 logic |
| Strike-first allowed only if the defender's strike lands before the attacker's | Straight or check hook always interrupts a forward-moving strike (game rule) | SOURCED (DEV, game rule) | S18 |

### Step 3 — EXECUTE: did it work?

| Constant | Proposed value | Tag | Source |
|---|---|---|---|
| Evasion window size | Scales with `HeadMovement` | SOURCED (DEV principle) | S18 |
| Which evasion beats which arc | Side slip: straights + uppercuts. Duck: hooks + straights (height-dependent). Pull: hooks, uppercuts, head kicks, and straights only at the edge of range | SOURCED (DEV) | S18, S19 |
| Duck fails for a much taller fighter vs a shorter one | Height gate | SOURCED (DEV) | S19 |
| Back-sway fails against a forward-stepping strike | Range gate | SOURCED (DEV) | S18 |
| Timed block bonus | Block at the moment of impact → counter window. Held block → strength decays | SOURCED (DEV/PRESS) | S23, S24 |
| Block strength decay while held and on each absorbed hit | Exists. Rate NOT FOUND for real fighters (UFC 5 long-term block threshold 85 → 60) | SOURCED (DEV) / rate PROXY | S22, S23 |
| Guard broken by alternating left/right and round/straight | Exists | SOURCED (DEV) | S18 |
| UFC sig.-strike defence: median / top 10% / best | 55.3% / ≥63.5% / ~73% | SOURCED (COUNT) | S16 |
| Zone landing rates (UFC) | Head 36.5%, body 69.2%, legs 80.4% | SOURCED (COUNT) | S16 |
| Base landing rates to calibrate against | Boxing: elite opponents land 13–17%, division average ~28%, jab 17.7%, power 35.4%. UFC: weight-class accuracy 43.2–48.8%, takedown defence 62.6% (all in §7–§8) | SOURCED | S8, S13, S14, S16 |

### Step 4 — CONSEQUENCE: damage, stamina, position, and the counter window

| Constant | Proposed value | Tag | Source |
|---|---|---|---|
| Clean hit on an unaware / vulnerable fighter | Up to ×6 damage (game rule) | PROXY (DEV rule, not physiology) | S18 |
| Damage through a block | Jab 0%. Hooks small. Head kicks "considerable". Elbows 5–10% (game values) | PROXY | S18, S22 |
| Real force through a forearm or glove block | — | NOT FOUND | — |
| Padding proxy (headguard on a dummy) | ~33–35% cut in peak linear head acceleration | PROXY (different situation) | S35 |
| Forearm guard pad on a load cell | ~16% cut in impact force | PROXY | S36 |
| Evade success | 0 damage. But a slip *into* a hook or a duck *into* an uppercut/knee = bonus damage to the defender | SOURCED (DEV/PRESS) | S18, S46 |
| Opening after each evasion | Side slip → hook side open. Duck → chin to uppercut/knee. Pull → body open; only round strikes blockable on return | SOURCED (DEV/PRESS) | S18, S19, S46 |
| Counter window after evading | Jab: none. Straight: short (20 frames). Hook/uppercut: long (36 frames) | SOURCED (DEV; fps not stated) | S19 |
| Counter window in seconds | 20 f ≈ 0.33–0.67 s; 36 f ≈ 0.6–1.2 s (at 60 or 30 fps) | PROXY | S19 + assumed fps |
| Attacker's stamina cost when he misses or is blocked | Missed/evaded +10%, blocked +7.5% over a landed strike (game tuning) | PROXY (DEV) | S22 |
| Kick checked | Damage to the kicker; two quick checks = "health event" (game rule) | PROXY (DEV) | S18 |
| Kick caught | Only scores if a sweep, dump or strike follows. Being unable to be dumped reads as strength | SOURCED (COACH, Thai scoring) | S43 |
| Body kick arm-blocked | May still score for the kicker; a check "in position" does not | SOURCED (COACH) | S43 |
| Counter attempt eats the follow-up | Real rate NOT FOUND. Game rule: countering a slipped jab is unsafe vs a jab-straight | NOT FOUND / DEV rule | S19 |
| Missed roundhouse leaves the kicker defenceless | Recovery longer than some punches' execution (game rule) | PROXY (DEV) | S18 |

### The anticipate-and-counter branch (operator addendum)

1. **Perceive:** P(early read) = f(`Reading`, pattern count vs threshold ≈ 5 repetitions [S48], strike telegraph [S2, S4], −feint, −fatigue [S49], −close range [S6]).
2. **Choose:** if the read is early and style allows it, **anticipate**: pre-commit to the evasion or block that beats the predicted strike (by arc: S18/S19) and pre-load the counter that fits it (§7 table: slip → straight, pull → straight, catch → right hand, check → teep, kick catch → sweep, weave → hook, pivot → counter).
3. **Execute:** if the prediction is right, success chance is higher than a reactive defence, and the counter lands *during* his recovery (S18 frame advantage). If the prediction is wrong (a feint, or a different strike), the defender has moved into a committed position. Apply the matching opening from Step 4 (for example, weaving early into a jab-uppercut). Size of the "right read" bonus: NOT FOUND (placeholder).
4. **Consequence:** A successful counter scales with the attacker's committed momentum (S18: a counter hits the attacker at raised vulnerability). A failed anticipation gives the attacker the matching opening. In the amateur data, single counters and counter + combo were only *marginally* linked to losing (S37). So counters should be risky but not suicidal.

---

## §11 Sources index

All read on 2026-09-25. "(x)" = abstract or excerpt only.

| ID | Source | Date | Type | URL |
|---|---|---|---|---|
| S1 | Mori, Ohtani & Imanaka, Hum Mov Sci 21:213 (full text, readkong mirror) | 2002-07 | ACADEMIC | https://www.readkong.com/page/reaction-times-and-anticipatory-skills-of-karate-athletes-7444513 (doi 10.1016/S0167-9457(02)00103-3) |
| S2 | Stanley et al., 3D kinematics of maximal punches, amateur boxers (Chester repository) | 2018 | ACADEMIC | https://chesterrep.openrepository.com/server/api/core/bitstreams/3e769a4f-d46b-4921-a2e9-093e0a80e436/content |
| S3 | Smart-wearable boxing study, Sensors 21:7882 (x) | 2021 | ACADEMIC | https://doi.org/10.3390/s21237882 |
| S4 | Gavagan & Sayers, roundhouse kick, PLoS One | 2017 | ACADEMIC | https://pmc.ncbi.nlm.nih.gov/articles/PMC5571909/ |
| S5 | Sequential kicks in taekwondo, J Hum Kinet (x) | 2025 | ACADEMIC | https://doi.org/10.5114/jhk/194067 |
| S6 | Martínez de Quel & Bennett, perceptual-cognitive expertise review, RICYDE | 2019 | ACADEMIC | https://www.redalyc.org/journal/710/71065391002/html/ |
| S7 | Zhang, Piras, Chen et al., anticipation meta-analysis, Front Psychol | 2022-10-28 | ACADEMIC | https://www.frontiersin.org/journals/psychology/articles/10.3389/fpsyg.2022.961960/full |
| S8 | ESPN, Mayweather measures up with greats (CompuBox) (x) | 2012 | PRESS | https://www.espn.com/boxing/story/_/id/7780088/floyd-mayweather-jr-measures-boxing-greats |
| S9 | BoxingScene, CompuBox plus/minus, active fighters (x) | 2012-04 | PRESS | https://www.boxingscene.com/articles/compubox-plus-minus-ratings-active-fighters |
| S10 | BoxingScene, CompuBox greatest plus/minus beatdowns (x) | c. 2013 | PRESS | https://www.boxingscene.com/articles/compuboxs-greatest-one-sided-plus-minus-beatdowns |
| S11 | BoxingScene, Mayweather–McGregor CompuBox numbers (x) | 2017 | PRESS | https://www.boxingscene.com/articles/mayweather-mcgregor-compubox-by-numbers-review |
| S12 | Bad Left Hook, CompuBox plus-minus Mayweather–Marquez (x) | 2009-09-18 | PRESS | https://www.badlefthook.com/2009/9/18/1036070/compubox-plus-minus-for-mayweather |
| S13 | CompuBox By the Numbers report #79 | undated page | PRESS | https://dev.compuboxdata.com/reports/79 |
| S14 | ESPN, Stevenson vs Harutyunyan by the numbers (CompuBox) | 2024-07-06 | PRESS | https://www.espn.com/espn/print?id=40489821 |
| S15 | Bad Left Hook, Spence tops CompuBox power stats | 2019-03-19 | PRESS | https://www.badlefthook.com/2019/3/19/18272492/errol-spence-rises-to-the-top-of-compubox-stats-in-power-punching |
| S16 | My counts: Greco1899 UFCStats mirror, UFC 2 to UFC 331 | data to 2026-09-19 | COUNT | https://github.com/Greco1899/scrape_ufc_stats |
| S17 | UFC.com athlete page, Dominick Cruz | read 2026-09-25 | PRESS | https://www.ufc.com/athlete/dominick-cruz |
| S18 | Harrower (EA), UFC 3 systems blog, via Operation Sports | 2017-11-23 | DEV | https://www.operationsports.com/ea-sports-ufc-3-details-damage-stamina-system-combinations-defense-much/ |
| S19 | EA, UFC 3 Content Update #5 notes (date not shown) | c. 2018 | DEV | https://forums.ea.com/discussions/ufc-franchise-discussion-en/update-5---gameplay-and-a-i-/11412688 |
| S20 | EA, UFC 5 changes since closed beta | 2023-10-08 | DEV | https://www.ea.com/games/ufc/ufc-5/news/ufc-5-post-beta-changes |
| S21 | EA, UFC 5 patch notes 1 | 2023-12 | DEV | https://www.ea.com/games/ufc/ufc-5/news/ufc-5-patch-notes-1 |
| S22 | EA, UFC 5 patch notes 4 | 2024-03-04 | DEV | https://www.ea.com/games/ufc/ufc-5/news/ufc-5-patch-notes-4 |
| S23 | EA, Fight Night Champion X360 manual | 2011 | DEV | https://eaassets-a.akamaihd.net/eahelp/manuals/fight-night-champion-manuals_Microsoft%20XBOX360.pdf |
| S24 | Eurogamer, Fight Night Champion review | 2011-02-23 | PRESS | https://www.eurogamer.net/fight-night-champion-review |
| S25 | IGN, UFC 5 review | 2023-10-27 | PRESS | https://www.ign.com/articles/ea-sports-ufc-5-review |
| S26 | VideoGamer, UFC 5 review | 2023-10-27 | PRESS | https://www.videogamer.com/reviews/ufc-5-review/ |
| S27 | IGN, Undisputed review | 2024-10-07 | PRESS | https://www.ign.com/articles/undisputed-review |
| S28 | Undisputed patch notes | undated | DEV | https://playundisputed.com/news/06849007-dd02-401e-8c64-28c22db5c9f4 |
| S29 | Gamer Digest, Undisputed counter and defence guides (x) | undated | PRESS/COMMUNITY | https://gamerdigest.com/how-to-counterpunch-in-undisputed/ ; https://gamerdigest.com/undisputed-how-to-defend/ |
| S30 | Sloclap, Sifu combat, PlayStation Blog | 2021-11-18 | DEV | https://blog.playstation.com/2021/11/18/how-sifus-kung-fu-combat-works/ |
| S31 | Colussi site, Sloclap quotes on parry (x) | undated | DEV | https://www.benjamincolussi.com/sifu-the-game |
| S32 | Reddit r/SifuGame parry frames thread (x) | c. 2023 | COMMUNITY | https://www.reddit.com/r/SifuGame/comments/14l984y/ |
| S33 | GameSpot, EA Sports MMA review | 2010-10-21 | PRESS | https://www.gamespot.com/reviews/ea-sports-mma-review/1900-6282486/ |
| S34 | Reddit r/undisputedboxing, need a parry (x) | 2024-08-19 | COMMUNITY | https://www.reddit.com/r/undisputedboxing/comments/1ew8wxd/need_a_parry_mechanic/ |
| S35 | McIntosh & Patton, headguard punch-machine tests, BJSM | 2015 | ACADEMIC | https://bjsm.bmj.com/content/49/17/1108 |
| S36 | Ramazanoglu, TKD forearm guards, Arch Budo (x) | 2012 | ACADEMIC | https://archbudo.eu/index.php/latest-publication/2012-volume-8/effectiveness-of-protective-foot-and-forearm-guards-in-taekwondo |
| S37 | IBA women's 2023 finals notational analysis, JFMK 10:350 | 2025 | ACADEMIC | https://pmc.ncbi.nlm.nih.gov/articles/PMC12452553/ |
| S38 | Davis et al., activity profile of elite amateur boxing, IJSPP (via S37) | 2015 | ACADEMIC (secondary) | https://doi.org/10.1123/ijspp.2013-0474 |
| S39 | World Boxing News, shoulder roll origins (Mayweather quote) | 2023-06-28 | FIGHTER (via PRESS) | https://www.worldboxingnews.com/floyd-mayweather-shoulder-roll-defense-origins/ |
| S40 | BOXRAW, Philly shell and Mayweather defence | 2018-04-10 | PRESS | https://boxraw.com/blogs/blog/the-philly-shell-the-shoulder-roll-and-the-mayweather-defense |
| S41 | Dynamic Striking, peek-a-boo with Teddy Atlas | undated | COACH (via PRESS) | https://dynamicstriking.com/blogs/news/peek-a-boo-boxing-with-teddy-atlas |
| S42 | von Duuglas-Ittu, Karuhat's forward check, 8limbs.us | undated | COACH/FIGHTER | https://8limbsus.com/muay-thai-thailand/muay-thai-offensive-defense-karuhat-forward-check-southpaw |
| S43 | 8limbs.us, Tony Myers on Muay Thai scoring | undated | COACH | https://8limbsus.com/muay-thai-thailand/balance-control-keys-muay-thai-scoring-tony-myers |
| S44 | Mulvaney, "Counter intuitive: Marquez the master", ESPN | 2012-12-07 | COACH/FIGHTER (via PRESS) | https://www.espn.com.au/boxing/story/_/id/8723082/finely-honed-craft-juan-manuel-marquez |
| S45 | BoxingScene, Nacho: Marquez KO not lucky | 2017-08-07 | COACH (via PRESS) | https://www.boxingscene.com/articles/nacho-marquezs-knockout-pacquiao-not-lucky-shot |
| S46 | Game Rant, UFC 5 head movement guide (x) | c. 2023 | PRESS | https://gamerant.com/ufc-5-how-use-head-movement/ |
| S47 | BoxingScene, CompuBox Mayweather–Hatton (x) | 2007 | PRESS | https://www.boxingscene.com/articles/compubox-analysis-mayweather-vs-hatton |
| S48 | Milazzo et al., karate situational probability, J Sports Sci (x) | 2016 | ACADEMIC | https://pubmed.ncbi.nlm.nih.gov/26651505/ |
| S49 | Sant'Ana et al., fatigue and TKD kick, Sports Biomech (x) | 2017 | ACADEMIC | https://pubmed.ncbi.nlm.nih.gov/27592682/ |
| S50 | Güldenpenning, Kunde & Weigelt, deceptive actions review, Front Psychol | 2017-05-31 | ACADEMIC | https://www.frontiersin.org/journals/psychology/articles/10.3389/fpsyg.2017.00917/full |
| S51 | Whiting, Gregor & Finerman, boxing kinematics, AJSM (x) | 1988 | ACADEMIC | https://pubmed.ncbi.nlm.nih.gov/3377096/ |

---

## §12 Still unknown (NOT FOUND)

1. Force or head acceleration through a real forearm or glove block vs the same strike landing clean (only proxies, S35/S36, and game values, S18/S22).
2. Force on the kicker's shin when a kick is checked.
3. How often the guard is at the wrong height (only zone landing rates, S16).
4. A single anticipation vs reaction split (only indirect evidence, S1/S7).
5. How much a feint cuts defender accuracy (%) in combat sports (only Ripoll's qualitative result, S50).
6. Rounds needed to read an opponent (only a 5-repetition lab figure, S48, and weak round trends, S16/S37).
7. How often a counter attempt eats the follow-up.
8. Real-fight risk rates for ducking into uppercuts or knees, slipping into hooks, or leaning back into follow-ups.
9. Real-fight parry, slip and block timing windows in ms. Sifu's parry frames were never published.
10. CompuBox opponent connect % by weight class, head vs body split, and head-movement vs high-guard style comparisons.
11. Force reduction from rolling with the punch. Which tell (shoulder, hip, foot) carries the information.
12. EA UFC 4 defence details, and the frame rate behind UFC 3's 20/36-frame windows.

---

## §13 Limits

- **Blocked pages.** UFCStats.com served a JavaScript browser check to curl and a 403 to WebFetch. I did not try to get around it and used a public GitHub mirror instead (S16). Its knockdown column looked broken, so it was not used. PubMed returned 403, so abstracts came from Europe PMC. Some ESPN pages blocked curl and were read through WebFetch.
- **Abstracts or excerpts only:** S3, S5, S8–S12, S29, S31, S32, S36, S46–S49, S51.
- **Secondary citations:** Williams & Elliott 1999, McLeod 1987, Ripoll 1995, Davis 2015, VencesBrito 2011, Di Russo 2006, Estevan 2013 and the pooled punch times are quoted as cited inside S1, S2, S5, S6, S37 or S50.
- **No video transcripts or auto-captions were used.** D'Amato's and Dempsey's own books were not read (the only open copy found was a pirate upload, which I did not use).
- **Game values are tuning, not physiology.** They are tagged PROXY when proposed as constants.
- **My UFC Str. Def counts** include clinch and ground strikes, cover UFC bouts only, and use a ≥350-attempts cut-off. They can differ from UFC.com (Cruz 65.8% vs 71%).
- **CompuBox figures are snapshots** over different fight spans and are not strictly comparable.
- **Prompt injection:** no fetched page and no Grok output contained instructions aimed at me.

---

## Appendix A — Grok CLI leads (grok lead, unverified; not counted)

The Grok CLI pass ran (grok-4.6, reasoning effort xhigh, live search) and the process exited on its own. Its output was badly garbled (parallel streams were interleaved in the text). Leads I **did** verify against the real source were moved into the memo body: Milazzo 2016 (S48), Sant'Ana 2017 (S49), the Ripoll 1995 false-alarm finding via Güldenpenning 2017 (S50), Whiting 1988 (S51), and the UFC 3 36-frame counter window (S19). The following were **not** verified by me and are not used anywhere above (each is a grok lead, unverified):

- Güldenpenning 2017: 17 of 21 studies found deceptive actions impair anticipation.
- Vagner et al. 2023 (Sports 11:141): elite roundhouse execution 0.280 ± 0.099 s vs novices 0.297 ± 0.073 s (paper exists; numbers not in abstract).
- Estevan et al. 2011 (JSCR): roundhouse to head ~270–400 ms by level and distance.
- Sports 2024 12(3):74 review: roundhouse foot speed 6.9–18.3 m/s, force 172–6400 N.
- Atha 1985 (via a thesis): pro rear cross ~100 ms. Whiting rear cross 132 ± 21 ms, rear hook 143 ± 24 ms. Piorkowski 2011 rear cross 353 ± 183 ms, lead hook 446 ± 150 ms.
- Wearable study PMC8659887 throw times: jab 117 ± 25 ms, hook 91 ± 50 ms, uppercut 71 ± 36 ms.
- Rosalie & Müller 2013: only experts beat chance from a static opponent in in-situ karate blocking.
- UFC 5 April 2024 patch: duck startup −1 frame; block stun −10 f (cartwheel kick), −30 f (rolling thunder).
- Undisputed launch notes: block health regenerates more slowly while held and drains faster when dazed.
- Sifu: a community mod treats the stock parry window as 10 frames. IGN called parry timing "super precise".
- Mayweather's last 15 opponents landed 18.9% of total punches. Guerrero 19.4%, Cotto ~20%, Ortiz 17.6%.
- Ring Magazine 2025-07-19: Jesse Rodriguez jab 39.5%, total 48.9%.
- Nash et al. 2015: extra knuckle padding cut punch force 12.6% (pros), 8.4% (untrained). Pain & Challis 2002: tensing the forearm changes energy lost in the segment by ~50%.
- McIntosh & Patton 2015 supplement: 4.99 m/s, 1582 N bare vs 930 N with headguard. BJSM 49:1113: glove + headguard cut peak acceleration 72–93% vs headguard alone.
- Roach "Defense Notes" (YouTube): "when you slip a punch you put yourself in a position to get hit again". Mayweather Sr. (FightHype 2014): learned "catch punches and fire off punches… counter punching" from Del Williams.
- UFCStats career Str. Def: Cruz 70%, A. Silva 60%, Adesanya 55%, Holloway 58%, D. Johnson 67% (close to my §8 counts, except Cruz).
