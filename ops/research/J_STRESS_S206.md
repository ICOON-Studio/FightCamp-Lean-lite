<!-- John (gbot thread), J_STRESS_S206 reply verbatim, collected S207 2026-10-12 -->
J_STRESS_S206 is finished. Sports science already has a ladder that maps onto stress and afflictions. Overreaching that recovers in days to weeks is the normal tiredness level, non-functional overreaching lasts weeks to months, and overtraining syndrome lasts more than 2 months. Weight cutting is the best-measured boxing stressor. I propose 12 states (9 negative, 3 positive) plus one optional. The full document follows in four parts.
# J_STRESS_S206 - Stress and afflictions, grounded in real boxing

- **Date:** 2026-10-11 (Asia/Nicosia)
- **Owner:** John Research
- **For:** FightCamp design (Godot 4.7.2 boxing gym management sim). This is research only. It contains no game code.
- **Scope:** Real-world grounding for a Darkest-Dungeon-style STRESS + AFFLICTIONS layer: what sports science says, what real fighters and coaches have done under stress, how other management games model it, a proposed set of boxing-true states, and design cautions.
- **Terminology rule used in this document:** the facility is a **gym**. "**Fight camp**" means only the preparation period before a bout. Neither word is used for the other.
- **Evidence tags:** **SOURCED** [n] = backed by numbered source n in section 6 (all accessed 2026-10-11). **JUDGEMENT** = the author's design opinion or inference, not a finding. **NOT FOUND** = searched for but could not verify, so no claim is made.
- **Reading note:** Numbers in section 4 (percent modifiers, durations in game weeks) are all JUDGEMENT starting points for tuning. They are not real-world measurements.

---

## 0. Answer first

1. **Real sport science already has a ladder that maps closely onto "stress -> affliction".** Functional overreaching (FOR) is a planned dip that recovers in days to weeks. Non-functional overreaching (NFOR) takes weeks to months. Overtraining syndrome (OTS) means more than 2 months of lost performance, with recovery taking months or longer. **SOURCED** [1][2][3]. A FightCamp stress meter can follow this directly: a short "tired", a mid-length "Overcooked", and a long, rare "Burnt out". **JUDGEMENT**
2. **Non-training stress counts.** The consensus says OTS often comes with an extra stressor besides training load, and lists low calorie intake (negative energy balance) among the factors to check. **SOURCED** [1][2]. Young athletes' NFOR/OT was *not* predicted by training load, and psychosocial factors mattered. **SOURCED** [5]. So money worries, losses and weight cuts should feed the same meter as hard sparring. **JUDGEMENT**
3. **Weight cutting is the most boxing-specific stressor with hard numbers.** Amateur boxers who dropped about 5.2% of body weight in a week showed more anger, fatigue and tension, less vigour, and worse performance. **SOURCED** [27]. A judo review found the same mood pattern. **SOURCED** [28]. Extreme cuts have caused kidney injury, hospitalisations and deaths: Leandro Souza in 2013, Yang Jian Bing in 2015, and Khabib Nurmagomedov hospitalised in 2017. **SOURCED** [30][38][35][56]
4. **Hard sparring is a real, cumulative cost, and gyms have a "gym wars" culture around it.** More fight exposure is linked to smaller brain volumes and slower processing speed in active pro fighters. **SOURCED** [31]. Symptom changes from single sparring sessions are rare and vary by person. **SOURCED** [32]. Head trauma should be modelled as **injury/health**, not as "stress". **JUDGEMENT**
5. **Documented stressed-fighter behaviours fit the states proposed here.** Examples: pulling out to manage mental health (Ryan Garcia, 2021) [41]; depression and substance use after reaching the top (Tyson Fury, 2016) [43]; collapse after a defining loss (Ricky Hatton, after 2009) [46][47]; hiding a medical problem because of pressure (Teofimo Lopez, 2021) [49]; walking out of a fight camp over gym politics (Paulie Malignaggi, 2017) [51]; missing weight badly (Garcia, 2024) [42]; turning up heavy after a big win (Buster Douglas, 1990) [54]; and using a loss as fuel (Wladimir Klitschko) [55]. **SOURCED**
6. **Games teach three lessons.** (a) Players accept harsh stress when they can see and influence it (Darkest Dungeon stress bar, RimWorld thresholds). (b) Random swings that feel unfair get punished in reviews, for example DD2's random negative relationships. (c) Spirals and grind need built-in brakes, such as RimWorld's 3-day "Catharsis" mood buff after a break. Punch Club's daily stat decay was its most-criticised system. **SOURCED** [61-69][71-80]
7. **Proposed: 12 states (9 negative, 3 positive).** Overcooked, Burnt out, Lost the hunger, Drained by the cut, Gun-shy, Gym bully, Playing hurt, Money on my mind, Off the rails, Ring rust, plus the positives Point to prove, Locked in and Gym leader. Each has a trigger, effect, cure, duration and a real-world anchor (section 4). **JUDGEMENT** built on SOURCED anchors.
8. **Handle mental health carefully.** IOC 2019/2026 consensus says mental health symptoms are common in elite athletes (meta-analysis range 19-34% in current athletes) and need screening and professional treatment. **SOURCED** [10][11][12]. FightCamp should model *observable behaviour and performance states*, not diagnose "depression", and should never let a quick tavern-style purchase "cure" a clinical condition. **JUDGEMENT**

---

## 1. Sports science

### 1.1 Definitions: the training-stress ladder

| State | Definition (plain English) | Performance drop lasts | Outcome | Tag |
|---|---|---|---|---|
| Acute fatigue | Normal tiredness after a session | Day(s) | Recovers, adapts | SOURCED [3] (table cites ECSS/ACSM) |
| Functional overreaching (FOR) | Deliberately heavy block; short-term dip; better after rest | Days to weeks | Positive (supercompensation) | SOURCED [1][2] |
| Non-functional overreaching (NFOR) | Too much load for too long; longer dip; full recovery after rest; extra psychological and/or hormonal symptoms | Weeks to months | Negative (symptoms, lost training time) | SOURCED [1][2] |
| Overtraining syndrome (OTS) | Like extreme NFOR but (1) performance decrement >2 months, (2) more severe symptoms across psychological, neurological, endocrine and immune systems, (3) an extra stressor not explained by other disease | Months; one review says "several months to years" for full recovery | Negative; possible end of athletic career | SOURCED [2][3] |
| Athlete burnout | A psychological syndrome with three parts: emotional/physical exhaustion, reduced sense of accomplishment, and devaluation of the sport | Not defined by a time window in the source | Linked to stress, amotivation, low enjoyment | SOURCED [7] |
| Mental fatigue | Tiredness caused by long, demanding cognitive work | Acute (session-level) | Worse endurance performance, mainly through higher perceived effort; max strength/power unaffected | SOURCED [8] |

Key nuances:
- NFOR and OTS can only be told apart **in hindsight**, by how long recovery takes, and only after other diseases are ruled out. No single marker meets all criteria. **SOURCED** [1]
- One practical rule in a clinical guide: if less than 14-21 days of rest is needed to return to previous performance, call it NFOR. If more, "OTS is diagnosed by some." **SOURCED** [2]
- The consensus abstract says it is "generally thought" that OTS symptoms are more severe than NFOR, but that "there is no scientific evidence to either confirm or refute this". **SOURCED** [1]. Design implication: the difference is mostly **duration**, not a different symptom list. **JUDGEMENT**
- Mental fatigue matters for boxing because rounds are repeated high-intensity efforts. The systematic review found effects on endurance tasks, not on max strength or power. **SOURCED** [8]. A 2025 opinion piece argues mental fatigue is an "unseen ongoing battle" in Olympic combat sports. **SOURCED** [9] (title and framing only; the abstract has no data). **JUDGEMENT:** in-game, mental fatigue should hurt late-round output and decision-making, not one-punch power.

### 1.2 Markers coaches can watch

| Marker | What happens | Strength of evidence | Tag |
|---|---|---|---|
| Performance drop | The defining sign of NFOR/OTS; needs a baseline to compare against | Core of the definition | SOURCED [1][2] |
| Mood (POMS) | In 400 swimmers monitored 1975-1986, mood disturbance rose in a dose-response way with training load and returned to baseline when load was reduced | Classic, long-running field data | SOURCED [15] |
| Self-reported well-being (Hooper-style daily log: sleep, fatigue, stress, soreness) | In 14 elite swimmers, well-being ratings explained 76% of the variance in staleness scores. During the taper they explained 72% of race-time improvement | Small sample, strong signal | SOURCED [17][16] |
| Subjective vs objective measures | Across 56 studies, subjective measures (mood, perceived stress) tracked acute and chronic load better than blood markers or heart rate, and the two often did not correlate | Systematic review | SOURCED [22] |
| Heart rate variability (HRV) | Useful but tricky. In elite athletes both rises *and* falls have been linked to poor adaptation, so you need each athlete's long-term "fingerprint" | Narrative/practitioner review | SOURCED [21] |
| Hormones, biochemical, immune markers | Used, but none meet all the criteria for general acceptance | Consensus | SOURCED [1] |
| Plasma catecholamines at rest | Added predictive value for staleness in one study | Single study | SOURCED [17] |
| Illness / infection | Coaches in strength sports cite more upper-respiratory infections as a warning sign | Qualitative coach interviews | SOURCED [4] |
| Sleep | Sleep disturbance is among the most common mental health symptoms reported in elite athletes | Meta-analysis | SOURCED [12] |
| Low energy availability (REDs) | Early psychological signs: mood changes, fatigue, psychological conflict. Severe: anxiety, depressive symptoms, eating disorders | IOC REDs subgroup review | SOURCED [14][13] |

### 1.3 Monitoring tools coaches actually use

| Tool | What it is | Notes / caveats | Tag |
|---|---|---|---|
| sRPE (session RPE x minutes) | Athlete rates how hard the whole session felt. Multiply by duration for a "load" number | Validated against heart-rate methods for interval and team-sport work. A single number for any session type | SOURCED [18] |
| ACWR (acute:chronic workload ratio) | Last ~week's load divided by longer-term load; promoted as an injury predictor | Strongly criticised: "no evidence supporting the use of ACWR" for training decisions; ratio artefacts | SOURCED [19][20] |
| Hooper index | Daily 1-7 ratings of sleep, stress, fatigue, soreness | Origin papers above | SOURCED [16][17] |
| POMS / BAM | Mood questionnaires; the POMS "iceberg" vs "inverted iceberg" idea comes from this line of work | Long history; the shorter BAM+ has been tested in rugby | SOURCED [15]; BAM+ existence SOURCED via search listing (Shearer et al. 2016, J Sci Med Sport, DOI 10.1016/j.jsams.2016.09.012) |
| RESTQ-Sport | Recovery-stress questionnaire; long and short (36-item) versions validated | Kellmann's original manual not verified here | SOURCED (versions exist: [83][84]); original manual NOT FOUND |
| Athlete Burnout Questionnaire (ABQ) | 3 subscales: exhaustion, reduced accomplishment, devaluation | Validated in swimmers and college athletes | SOURCED [7] |
| HRV (morning, rolling average) | Daily readiness signal | Needs averaging and individual baselines | SOURCED [21] |
| Recovery consensus | Balance of stress (training, competition, *other life demands*) and recovery is key. Monitor systematically | 2018 consensus | SOURCED [23] |
| Mental health screening | IOC 2026: routine screening with validated instruments is recommended | Consensus | SOURCED [11] |

### 1.4 How coaches fix it

- **Rest and load reduction.** Mood disturbance falls back to baseline when load is reduced. **SOURCED** [15]. NFOR recovers fully with rest, by definition. **SOURCED** [1][2]
- **Rule out other causes first.** Check for infection, illness, low calorie intake, low carbohydrate or protein, and iron or magnesium deficiency. **SOURCED** [1]
- **Address the environment, not just the athlete.** Management must cover both treating the individual and improving the environments athletes train in. **SOURCED** [10]. Treatment may include psychotherapy and medication. Many athletes can keep training with support, but participation sometimes has to change. **SOURCED** [11]
- **Interdisciplinary care for under-fuelling (REDs).** Clinicians should not underestimate athletes' "drive for success and denial of health consequences". **SOURCED** [14]
- **Coaches' own view:** strength-sport coaches saw OTS as rare and sometimes struggled to separate it from "work ethic". **SOURCED** [4]

### 1.5 Prevalence

| Population | Figure | Tag |
|---|---|---|
| Young English athletes (n=376, 19 sports) | 29% reported NFOR/OT at least once; higher in individual sports, females and elite level; training load *not* a significant predictor | SOURCED [5] |
| Endurance athletes (estimate) | 7-21% NFOR/OTS during a training cycle ("estimates") | SOURCED [4] (secondary citation) |
| Adolescent elite athletes (n=980, 29 sports) | 1-9% showed elevated burnout scores on the four subscales; no link with training load | SOURCED [6] |
| Current elite athletes (meta-analysis) | 19% (alcohol misuse) to 34% (anxiety/depression symptoms) | SOURCED [12] |
| Former elite athletes | 16% (distress) to 26% (anxiety/depression symptoms) | SOURCED [12] |
| Boxing-specific OTS or burnout prevalence | No peer-reviewed boxing figure found | NOT FOUND |
| Combat-sport-specific mental health meta-analysis | Not found in this search | NOT FOUND |

### 1.6 Combat-specific stressors

#### Rapid weight loss (RWL)

| Study | Who | Key numbers | Tag |
|---|---|---|---|
| Hall & Lane 2001 | 16 experienced amateur boxers | Cut avg 5.16% of body weight in one week, mainly by restricting fluid and food. At championship weight: worse circuit performance, more anger, fatigue and tension, less vigour | SOURCED [27] |
| Artioli et al. 2010 | 822 judo athletes | 86% had cut weight to compete (89% excluding heavyweights). Usual cut 2-5% (mean 2.5%), many 5-10%. 3 +/- 5 cuts per season, each within 7 +/- 7 days. First cut at age 12.6. Elite athletes cut more aggressively | SOURCED [26] |
| Barley et al. 2018 | 637 athletes, 7 combat sports incl. boxing | Body-mass manipulation in all sports. MMA highest sauna use (76%) and water loading (67%). Skipping meals ~58% outside taekwondo/wrestling | SOURCED [24]. Boxing-only percentages not in abstract: NOT FOUND |
| Reale et al. 2017 | Review, Olympic combat sports | Gives a decision tree for acute weight loss with minimal performance loss | SOURCED [25] |
| Lakicevic et al. 2020 | Systematic review, 14 studies, 1,103 judokas (>=5% loss in <=7 days) | Tension, anger and fatigue up; vigour down. Performance effects "ambiguous" | SOURCED [28] |
| Matthews & Nicholas 2017 | 7 UK MMA athletes | Lost 5.6 kg (8%) in the week; regained 7.4 kg (11.7%) in ~32 h. At weigh-in 57% dehydrated, 43% severely dehydrated | SOURCED [29] |
| Kasper et al. 2019 (case) | 1 elite male MMA athlete | 18.1% body mass lost over 8 weeks; 9.3% in final 24 h. Testosterone <3 nmol/L, acute kidney injury | SOURCED [30] |
| IOC REDs 2023 | Consensus | Low energy availability leads to health and performance harms in men and women | SOURCED [13] |

Design read: the cut should raise stress and worsen mood/attitude in fight week every time. The *performance* effect on fight night should be smaller and more variable, because the evidence there is "ambiguous". **JUDGEMENT** grounded in [27][28]

#### Sparring and head impacts

- 224 pro fighters (131 MMA, 93 boxers): more fights, more years and a higher Fight Exposure Score were linked to smaller thalamus and caudate volumes, slower processing speed, and greater likelihood of cognitive impairment. **SOURCED** [31]
- 7 boxers, 16 sparring sessions with instrumented mouthguards: as a group, no change in symptoms before vs after. 4 of 16 sessions (25%), from 3 boxers, showed a symptom-score rise >5. The link to impact dose was unclear, which supports individual-specific approaches. **SOURCED** [32]
- Retired fighters with *better* win-loss records showed more impulsiveness and slower processing (n=212). Successful fighters did not score better on any test. **SOURCED** [33]
- Gym war culture: a 2004 ESPN/MaxBoxing "Gym Wars" column describes a seven-round sparring war between Danny Green and James Toney at Freddie Roach's Wild Card gym. Trainers "give a fighter the benefit of the doubt as long as he's willing and punching back". **SOURCED** [52]. A 2025 Guardian investigation of BoxRaw/The Ring "Sparring Club" events describes mismatched sessions that became real fights, and a concussion that cancelled a fighter's next bout. USA Boxing prohibits "sparring as entertainment". **SOURCED** [53]
- A direct Freddie Roach quote on limiting sparring to protect fighters' brains: **NOT FOUND** in this search.

#### Post-defeat responses

- Peer-reviewed data on psychological responses to defeat in boxing specifically (rates, durations): **NOT FOUND**.
- Documented cases: Ricky Hatton described depression and contemplating suicide after his 2009 knockout loss to Manny Pacquiao. **SOURCED** [46][47]. Klitschko described the 2004 Brewster loss as a turning point that changed how he trained. **SOURCED** [55]. Teofimo Lopez on his 2021 loss: "The only person that beat me was myself". **SOURCED** [50]
- **JUDGEMENT:** a loss should be able to push a fighter either way (Gun-shy / Off the rails vs Point to prove). Resilience traits and support should tilt the odds.

#### Injury psychology

- Review of 11 studies (983 athletes): motivation, confidence and low fear were linked to returning to pre-injury level, and returning faster. **Fear** was a prominent emotion at return to sport. **SOURCED** [34]
- Mental health symptoms raise the risk of physical injury and slow recovery. **SOURCED** [10]

#### Financial stress (purses, no union)

- British boxers "have never had a successful trade union"; one is being planned by the Global Fighters' Association (Feb 2026). Former British champion Paul Smith: "there's nothing in place for fighters to protect them". **SOURCED** [57]
- The British Boxing Board of Control's general secretary on a duty of care to ex-boxers: "Financially, it's impossible" (Mar 2026). **SOURCED** [58]
- California runs the only state boxers' pension in the US (per LA Times). In 2022 only 12 of ~200 eligible boxers (6%) claimed it. Journeyman heavyweight Mike Jameson said a $50,000 purse against George Foreman became $14,500 take-home after manager, trainer and taxes. "Ballet Boxer" Milford Kemp's biggest purse was $2,500. **SOURCED** [59]
- Peer-reviewed data linking money stress to performance in boxers: **NOT FOUND**.
## 2. Real behaviours of stressed fighters

| Behaviour | Example (who, when) | What happened | Source | Source date |
|---|---|---|---|---|
| Pulling out to protect mental health | Ryan Garcia, Apr 2021 | Withdrew from 9 Jul 2021 Fortuna fight to "manage my health and wellbeing". Had said "I still struggle everyday with anxiety and depression" | [41a][41b][41c] | 2021-04-24/25 |
| Abandoning fight camp; depression; cocaine and drinking | Tyson Fury, May-Oct 2016 | Said he abandoned his fight camp in Holland in May and "From that day forward, I've never done any training"; described depression and suicidal thoughts; vacated titles 12 Oct 2016 | [43][44][45] | 2016-10-04; 2016-10-05 |
| Losing purpose after reaching the goal | Tyson Fury (looking back on 2015 win) | "When I win, I'm not going to have a goal anymore" | [45] | 2020-02-13 (secondary report of a Mike Tyson interview) |
| Turning up out of shape after a big win | Buster Douglas, Oct 1990 | Weighed 246 lb for Holyfield, 14.5 lb above his weight for the Tyson upset. "I got a little depressed because of the things going on" | [54] | 1990-10-24 |
| Depression, drinking, drugs after a defining loss | Ricky Hatton, after 2009 Pacquiao KO | "I was going deeper and deeper into depression"; later said he tried to take his life "several times". Hatton died 14 Sep 2025 aged 46 (police: no suspicious circumstances). Cause is not stated here | [46][47][48] | 2011-09-29; 2016-12-29; 2025-09-14 |
| Hiding a medical problem because of pressure | Teofimo Lopez, Nov 2021 | Fought with pneumomediastinum. "If I told everybody, they would've canceled the fight... I didn't want to hear people say, 'Oh, another postponement.'" | [49] | 2021-12-04 |
| Self-blame after defeat | Teofimo Lopez, 2022 | "The only person that beat me was myself." Had also spoken about suicidal thoughts | [50] | 2022-08-12 |
| Gym politics / leaving fight camp | Paulie Malignaggi in Conor McGregor's 2017 camp | Quit as sparring partner after photos of him on the canvas were released; called it a push, not a knockdown | [51a][51b] | 2017-08-04 |
| Sparring war / ego sparring | Danny Green vs James Toney, Wild Card gym, Aug 2004 | Seven hard rounds. Toney after: "Next time you talk ... about me I'm going to ... you up for real!" | [52] | 2004-10-15 |
| Over-aggression in "sparring" | Sparring Club, Brooklyn, 11 Jul 2025 | A trainer on site: "if a fighter is hurt, the guy who hurt him backs off... Taylor didn't". Opponent concussed; his 25 Jul bout cancelled | [53] | 2025-08-09 |
| Missing weight badly / defiance | Ryan Garcia vs Devin Haney, Apr 2024 | 143.2 lb, 3.2 lb over the 140 limit; "I put myself through hell" and later "I got a 3 pound advantage" | [42] | 2024-04-19 |
| Weight-cut hospitalisation; bout cancelled | Khabib Nurmagomedov, UFC 209, Mar 2017 | Taken to hospital "due to weight management medical issues"; title bout cancelled on doctor's recommendation | [56] | 2017-03-03 |
| Weight-cut death | Leandro "Feijao" Souza, Shooto Brazil 43, 26 Sep 2013 | Short-notice fight; reportedly had to lose 33 lb in a week; reportedly took diuretics; collapsed in a sauna; preliminary finding: haemorrhagic stroke | [38][39][40] | 2013-09-27/28 |
| Weight-cut death | Yang Jian Bing, ONE Championship, 11 Dec 2015 | Collapsed severely dehydrated a day before the bout; autopsy: acute myocardial infarction. ONE banned dehydration cutting and brought in hydration testing | [35][36][37] | 2015-12-12/23 |
| Loss as fuel (positive) | Wladimir Klitschko, after 2004 Brewster loss | "I knew I could lose my sporting career if I didn't change. I trained myself in a certain way after that." Still re-watched the fight 10 years later | [55] | 2014-11-14 |
| Money stress after career | Retired boxers in California | Pensions largely unclaimed; small take-home pay; post-career jobs | [59] | 2023-05-11 |
| Sparring avoidance (refusing or dodging sparring) | Second-hand e-mail in [52] says Toney "had missed two scheduled sparring sessions" with Green; Roach said nothing was officially scheduled | Weak, contested anecdote | [52] | 2004-10-15 |
| Devin Haney stress behaviour | Searched; nothing verifiable on stress or mental health in this pass | NOT FOUND | - | - |

Patterns (JUDGEMENT):
- **Both extremes of results are risky.** Fury and Douglas show trouble after a *win*; Hatton after a *loss*. A meter driven only by losses would miss half of this.
- **Pressure makes fighters hide things** (Lopez). A stressed fighter's self-report should become *less* reliable, which ties directly into sports science's reliance on self-report [22].
- **Fight week is where stress peaks** (weight cut, hospitalisations, missed weight). Stress should spike visibly then.
- **Gym social dynamics are real** (Malignaggi, Green-Toney, Sparring Club). A gym-level atmosphere stat is justified.

---

## 3. How other management games model morale and stress

### 3.1 Mechanics and numbers

| Game | Mechanic | Numbers | Tag |
|---|---|---|---|
| **Darkest Dungeon (2016)** | Stress bar per hero. At 100, a "resolve test" gives an Affliction or (less often) a Virtue. At 200, a heart attack: Death's Door, or death if already there | Range 0-200; threshold 100. Base Virtue chance 25%, adjustable 1-95%, trinkets up to 75%. Virtue resets stress to 40-45. Capped at 100 when back in town. Idle heroes recover 5/week (15 with upgrade); Tavern/Abbey remove large amounts plus the affliction for gold and one week out. Afflicted heroes disobey and stress allies. Stress damage reduction capped at 80% | SOURCED [61][62] |
| **Darkest Dungeon II (2023)** | Stress 0-10. Negative "banter" grows with stress and damages relationships, "a snowballing effect". At 10: Meltdown or Resolute | 0-3 no negative banter; 7-9 ~90% negative; at 10: 80% Meltdown / 20% Resolute (base). Meltdown: HP set to 10%, worse relationships, 40% chance of a negative quirk | SOURCED [63] |
| **RimWorld** | Mood is the sum of "thoughts". Below a threshold, pawns can have mental breaks (minor/major/extreme). High mood brings random "inspirations" | Base minor break threshold 35%; major 20%; extreme 5%. Average time between breaks 4 days (minor), 0.8 (major), 0.5 (extreme) while below threshold. After a break: +40 "Catharsis" for 3 days. Inspirations only above 49% mood; average gap 210 days at 50% mood down to 10 days at 100%; most last 8 days | SOURCED [64][65] |
| **Football Manager** | Morale (current mood) plus Happiness broken into Promises, Morale, Training, Treatment, Club, Management, Playing Time. Squad Dynamics: hierarchy, social groups, dressing-room atmosphere. Mentoring groups. Rest and "jadedness" | Morale scale from "Abysmal" to "Superb". Happiness 8 levels "Delighted" to "Devastated". Hierarchy: Team Leaders > Highly Influential > Influential > Other. Leaders' grievances "permeate through the rest of the squad". Mentoring needs >=3 players and works best with similar profiles; its returns eventually max out. Rest 1 day to 2 weeks "can be an effective morale-booster". Over-training youth "could result in burnout" | SOURCED [66][67][82] |
| **Motorsport Manager (2016)** | Driver Morale stat plus permanent and temporary traits | "Happy drivers are more likely to perform well, whereas unhappy drivers are more likely to want to leave". Temporary traits include "Burnt Out" (-1 all driver stats), "Feeling Blue" (morale -30), "Refocused" (+1), "Renewed Passion" (+1), "Mentor" (teammates improve faster). Traits like "Green Eyed Monster" (morale -15 if teammate paid more) | SOURCED [68] |
| **Punch Club (2016)** | Needs: health, mood, hunger, energy. Daily stat decay | Mood below 50% halves training points. Fighting (win or lose) restores much mood. Stats lose "9 times the stat worth of mini points" every day. Repeating the same exercise back to back is less effective (24-48 h overtraining timer) | SOURCED [69] |
| **WWE 2K24 MyGM** | Superstar morale, separate from popularity | Morale depends on booking, treatment, granted requests and kept promises; low morale risks defection to the rival show. Exact numbers NOT FOUND | SOURCED [70] |
| The Sims (needs) / FM "Concerns" detail | Not researched in depth this pass | - | NOT FOUND (not checked) |

### 3.2 What players liked and hated (dated quotes)

All Steam quotes are from public Steam reviews retrieved via Steam's public review API. The date is the review's creation date (UTC). Helpful-vote counts are shown to indicate reach. Review URLs follow Steam's `steamcommunity.com/profiles/<id>/recommended/<appid>/` pattern built from the API author id; they were not opened one by one.

| Game | Liked / hated | Quote | Date | Source |
|---|---|---|---|---|
| Darkest Dungeon | Liked: stress as a second resource | "Stress & Affliction System : HP isn't your only resource." | 2026-07-30 | [71] |
| Darkest Dungeon | Mixed: random outcomes cut both ways | "RNG is in a weird place some times it got me frustrated sometimes it got me excited when i got virtue." | 2026-09-16 | [72] |
| Darkest Dungeon | Hated: stress relief cost spiral | "their stress reduction cost total > the gold you're taking in, too many diseases, bad quicks that are locked in" | 2015-12-25 (454 helpful) | [73] |
| Darkest Dungeon | Hated: losing invested heroes, then grind | "there are only so many times I can lose a high level character before all I can see is the grind it will take to train a new character all the way back up again." | 2016-06-12 | [74] |
| Darkest Dungeon | Hated: stress leaks to the player | "My video game time is to unwind and I find this game stresses me out." | 2022-08-20 (224 helpful) | [75] |
| Darkest Dungeon II | Hated: random relationships too punishing | "Negative relationship boons are too severe for how random they are." | 2024-06-29 (524 helpful) | [76] |
| Darkest Dungeon II | Hated: loss of agency | "...feels unfair, forces you to play with certain skills therefore ruining player agency ... while also forcing romantic relationships on your heroes with no input from the player." | 2024-01-12 | [77] |
| Darkest Dungeon II | Hated: murky mechanics | "...murky mechanics and unforgiving RNG." | 2023-05-10 (1,334 helpful) | [78] |
| RimWorld | Liked: breaks create stories | "Karen the Crafting Goddess has decided to have a mental break because someone insulted her hat three months ago." | 2024-09-30 | [79a] |
| RimWorld | Hated: spirals; opaque rules | "And they so often cause death spirals." / "...you have to figure out on your own or look up in the wiki ... mental breaks and more." | 2016-07-21; 2021-09-16 | [79b][79c] |
| RimWorld | Hated: mood micromanagement | "But really i'm micromanaging pissy moods..." | 2022-01-19 | [79d] |
| Punch Club | Hated: decay grind | "The crippling stat decay system: training or not, your progress will drop by roughly 50 % everyday regardless." | 2016-01-24 (424 helpful) | [80a] |
| Punch Club | Hated: dev tone on the fix | "the devs added a 'no stats decay' option mode ... labelling it as 'suuuuuuuuuuuuuuper easy mode' and disabling achievements" | 2016-12-16 | [80b] |
| Football Manager 2024 | Hated: broken promises system | "Interactions/promises are completely broken to the point where most people just avoid them completely if poissible." | 2024-01-16 | [81a] |
| Football Manager 2024 | Hated: unhappiness that makes no sense | "...a player being unhappy with a promise when it was actually fulfilled" | 2024-01-01 | [81b] |
| Motorsport Manager | Liked: in-race morale levers | "In race radio messages and dilemmas to boost morale of your driver." | 2022-03-21 | [85] |
| Motorsport Manager | Hated: morale penalties players avoid | "You're better off denying the interview, because it frequently results in a morale penalty for one of your teammates." | 2017-10-07 | [86] |
| Press quotes on these systems (Eurogamer, PC Gamer, etc.) | Not gathered this pass | - | - | NOT FOUND (not checked) |

### 3.3 Lessons for FightCamp (JUDGEMENT)

1. **Make the meter visible and the causes readable.** DD's bar and RimWorld's list of thoughts are praised or at least accepted. FM's opaque interactions draw anger. Every stress change should show a reason line, e.g. "+6 hard sparring (8 rounds)". [66][79c][81a]
2. **Random rolls at a threshold are fine if the odds are shown and can be changed.** DD shows a 25% base virtue chance that trinkets can move. DD2's random relationships felt unfair. Let gym staff and traits move the odds, and show the odds. [62][76]
3. **Build in a spiral brake.** RimWorld gives +40 Catharsis for 3 days after a break. DD2's banter openly "snowballs". FightCamp should give a short relief buff after an affliction fires, and cap stress gain per in-game week. [64][63]
4. **Avoid pure decay grind.** Punch Club's daily stat decay is its top complaint. Stress recovery should be passive and *fast at low stress*, with harsh effects only at the high end. [80a]
5. **Respect player investment.** Losing a high-level hero to RNG reads as wasted time [74]. A fighter's career should not end from one unlucky roll. Severe outcomes need several warnings. **JUDGEMENT**
6. **Social contagion works but needs a hierarchy.** FM's "leaders' unhappiness spreads" maps onto a gym's senior pro. Mentoring needs similar profiles and fades over time. [66][67]
7. **Positive states give hope.** DD Virtue, DD2 Resolute, RimWorld Inspiration and MM "Renewed Passion" are the moments players remember fondly [72]. FightCamp should include 2-3 positive states.
## 4. Boxing-true states for FightCamp

Assumptions for all states (JUDGEMENT):
- One **Stress** meter per fighter, 0-100. **Resolve check at 80** (not 100) so the danger zone is visible before it fires. Weekly passive recovery is faster at low stress (e.g. -10/wk under 40, -4/wk over 70).
- Inputs (JUDGEMENT values): hard sparring round +0.5-1.0 each, weighted by partner level gap; weight cut in fight week +5 per 1% of body mass cut beyond 3%; loss +10 (KO loss +20); injury +5-15; money below 4 weeks' living costs +3/wk; big win -10 now, but sets a "goal vacuum" flag (see Lost the hunger).
- Monitoring staff (strength coach, physio, sports psychologist) reveal hidden stress or give early warnings, mirroring Hooper/POMS/HRV practice [16][17][21][22].
- "Fight camp" below always means the pre-bout preparation period. The building is the "gym".

| # | State (type) | Cause / game trigger | Effect: training | Effect: fight | Cure (what coach/player does) | Duration | Real-world anchor |
|---|---|---|---|---|---|---|---|
| 1 | **Overcooked** (neg; NFOR) | Stress >= 80 with high training load for >= 2 consecutive weeks, OR training load > 130% of 4-week average for 2 weeks | Training gains -40 to -60%; sparring injury risk +20%; mood text: flat, irritable | Late-round output -10 to -15%; slower recovery between rounds | Deload: cut load by >= 50% for 1-3 weeks; no hard sparring. Ignoring it for 4+ weeks escalates to Burnt out | 2-6 game weeks | NFOR "weeks to months", recovers fully with rest [1][2]; mood returns to baseline when load drops [15] |
| 2 | **Burnt out** (neg; rare; OTS/burnout) | Overcooked left untreated 4+ weeks, OR stress >= 90 for 6+ weeks with an extra stressor (cut, money, loss) | Training gains -70%; 30% chance per week of skipping sessions; ABQ-style flavour text (exhausted / "what's the point") | All fight attributes -10%; pull-out risk if a fight is booked (20%/week of fight camp) | Extended rest 8-24 weeks; reduce non-training stressors; sports psychologist halves duration. Cannot be bought off | 2-6 game months | OTS >2 months, months or longer [2][3]; burnout = exhaustion + reduced accomplishment + devaluation [7]; prevalence low (1-9% elevated burnout in adolescents [6]) |
| 3 | **Lost the hunger** (neg; motivation) | Wins a title or career-best payday (goal vacuum), OR 12+ months with no meaningful fight offers | Attendance 70-85%; gains -25%; arrives above walking-weight target (+3-6% body mass) | Fitness and tank -10%; may accept easier fights only | Set a new goal (mandatory, rival, bigger weight class); short break; new fight camp setting | Until a new goal is set (4-16 weeks) | Fury: "When I win, I'm not going to have a goal anymore" [45]; Douglas 246 lb after Tyson win [54] |
| 4 | **Drained by the cut** (neg; fight week) | Fight-week cut > 5% of body mass, OR third hard cut within 12 months | Fight-week sessions -30% quality; stress +; irritability can trigger gym arguments | Rounds 1-3 near normal; later-round output -5 to -15%; small chance (2-5% per extra 1% cut beyond 8%) of a medical event that cancels the bout (fighter hospitalised) | Move up a weight class; longer, gradual cut planned by a nutritionist; hydration rules; never IV rehydration if the commission bans it | Fight week + 1-2 weeks after | Mood: anger, fatigue, tension up, vigour down, worse performance [27][28]; extreme cuts: kidney injury [30]; Khabib hospitalised [56]; deaths [38][35]; ONE hydration rules [37] |
| 5 | **Gun-shy** (neg) | KO or heavy-knockdown loss, OR being badly hurt in sparring, with low resilience trait | Avoids hard sparring (refuses 30-50% of hard sparring sessions); technical drills unaffected | Punch output -15 to -25%; lower willingness to exchange; more clinching/retreating | Gradual return: light/technical sparring with trusted partners, then build; confidence wins vs safe opponents; sports psychologist | 4-12 weeks; resolves faster with each confidence win | Fear prominent on return from injury; confidence + low fear predict return [34]. Boxing-specific peer-reviewed data on post-KO "gun-shyness": NOT FOUND, so this is a JUDGEMENT state |
| 6 | **Gym bully** (neg; social) | High-aggression trait + stress >= 70 + rival in the gym or recent ego hit (lost a sparring session, public criticism) | Over-hits in sparring: partner injury/concussion risk x2; sparring partners' stress +; gym atmosphere -; partners may refuse to work with him | Short term: +5% aggression; but fight-plan discipline -10% | Coach pairs him only with bigger/senior partners, sets sparring rules, separates rivals; talk with head coach; fine/suspend under gym rules | Until stress < 50 or rival leaves (2-8 weeks) | Green-Toney "gym war" and its aftermath [52]; Sparring Club "Taylor didn't" back off, concussed opponent [53]; Malignaggi walked out of a fight camp [51] |
| 7 | **Playing hurt** (neg; hidden) | Has an injury or illness AND (big fight booked, OR a previous postponement, OR money stress) | Reports "fine": hides the injury from the player unless the physio or doctor checks | Hidden injury can worsen in the bout; chance of fight-night collapse or a stoppage loss | Medical check-ups in fight camp; a culture where postponing is not punished (a gym policy toggle); good relationship with the head coach lowers concealment chance | Until detected or the fight happens | Teofimo Lopez concealed symptoms because of pressure and fear of "another postponement" [49]; athletes deny health consequences in pursuit of goals [14] |
| 8 | **Money on my mind** (neg; financial) | Savings < 4 weeks' costs, OR purse withheld, OR debt event | Takes side work: 10-20% fewer training hours; stress +3/week | More likely to accept short-notice or bad-matchup fights; may push for a cut to a lower class for a title shot | Gym advances money (with a relationship cost), lines up sponsorship, better manager deal, sensible fight scheduling | Until savings recover | No union, no safety net [57][58]; purses shrink after deductions; pensions unclaimed [59]. Short-notice fight + extreme cut preceded Souza's death [38] |
| 9 | **Off the rails** (neg; severe; handle with care) | Major loss or career shock + stress >= 90 + low support; OR repeated Burnt out | Misses 40-60% of sessions; weight drifts up; may be out of contact for days; other fighters' stress rises slightly | If a fight is booked: high pull-out chance; if he fights, large penalties | **Not fixable by spending.** Player can: give time away, connect him with professional help (unlocks a "support" path), protect his contract. Recovery is slow and non-linear; relapse possible. No punishment options shown | 3-12 game months | Fury 2016: no training, drinking, cocaine, psychiatric care [43][44]; Hatton after the 2009 loss [46][47]; IOC: needs professional treatment [10][11]. See section 5 for wording |
| 10 | **Ring rust** (neg; mild; time-based) | > 12 months since last bout | None in training | Timing/accuracy -3 to -5% for rounds 1-4, fading by round 6 | Tune-up fight; extra hard sparring in fight camp (costs stress) | First fight back | Peer-reviewed evidence: NOT FOUND. A non-peer-reviewed UFC data blog reports the longer-layoff fighter winning 41.0% after 365+ days vs 48.1% overall [60]; treat as weak |
| 11 | **Point to prove** (pos; virtue-like) | Loss (esp. close or controversial) + high resilience trait, OR resolve check passes at 80 (base chance 20-30%, staff and traits can raise it) | Training gains +15 to +25%; perfect attendance; accepts hard sparring without stress gain for 4 weeks | Conditioning +5%; composure +5% | None needed. Ends when the target fight is done or after 12 weeks | 6-12 weeks | Klitschko after Brewster: "I trained myself in a certain way after that"; still motivated by "payback" a decade later [55] |
| 12 | **Locked in** (pos) | Fight camp with stress <= 30 for the final 2 weeks, good sleep/recovery, a proper taper | Sharper sessions (+10% technique gains); low injury risk | Fewer mistakes: -20% chance of tactical errors; +5% accuracy | None. Lost if stress rises above 50 | Final 2 weeks of fight camp + fight night | Well-being during the taper explained 72% of performance improvement [17]; mood falls back to baseline when load is reduced [15]; recovery-stress balance is key [23] |
| 13 | **Gym leader** (pos; social; optional) | Senior pro with high professionalism and stress <= 40, mentoring >= 2 juniors | Mentored juniors: stress gain -15%, gains +5% | None for the leader | Keep him happy; if he turns Gym bully or Off the rails, the bonus reverses for 2 weeks | While conditions hold | Game analogue: FM mentoring and leader influence [66][67]; MM "Mentor" trait [68]. Real boxing study: NOT FOUND, so this is JUDGEMENT |

Notes on the table:
- State 13 is optional, which makes the list 12 core states plus one optional. All numeric ranges are **JUDGEMENT**.
- **Head trauma is deliberately not a stress state.** Concussion or "foggy after sparring" should be an injury with a medical hold, because the evidence is about brain health and individual susceptibility, not mood [31][32]. **JUDGEMENT**
- **Order of checks (JUDGEMENT):** at the resolve check, roll positive vs negative first, then choose the negative state from the *dominant stress source* in the last 4 weeks (sparring-heavy leads to Overcooked or Gym bully; cut-heavy to Drained; loss-heavy to Gun-shy or Lost the hunger; money-heavy to Money on my mind). This makes states feel *caused*, not random, answering the DD2 complaint [76].
- **"Chasing the knockout"** (reckless KO-hunting under stress) was considered. A verifiable real-world anchor was NOT FOUND (impulsiveness in retired successful fighters [33] is not the same thing), so it is left out of the core list. **JUDGEMENT**

---

## 5. Design cautions (JUDGEMENT, grounded in section 3)

1. **RNG frustration.** The most-repeated complaint across DD1/DD2 is randomness that wipes out invested characters [73][74][76][78]. Fixes: show the odds at the resolve check; let staff, traits and gym upgrades move them; tie the chosen affliction to the dominant stress source; never let one roll end a career.
2. **Death spirals.** DD2's banter "snowballing" [63], RimWorld players' "death spirals" [79b], and DD's "stress reduction cost > gold" [73] all describe loops where stress causes more stress. Fixes: (a) a relief buff after an affliction fires (like RimWorld Catharsis, +40 for 3 days [64]); (b) a cap on weekly stress gain; (c) a cheap baseline recovery option (rest week) that always works for Overcooked; (d) gym-wide contagion capped (one stressed fighter cannot push the whole gym over the threshold in one week).
3. **Opaque stress.** FM24's interaction/promise system drew "completely broken" reviews [81a][81b]; RimWorld players complain about needing the wiki [79c]. Fixes: every stress delta has a cause line; a weekly "stress report" from staff (Hooper-style 1-7 sleep/fatigue/stress/soreness, which mirrors real practice [16][22]); hidden stress only for **Playing hurt**, and the game says when information is hidden.
4. **Grind and decay.** Punch Club's decay drew the most criticism, and the developers' mocking label for the no-decay mode made it worse [80a][80b]. Fixes: no stat decay from stress alone; offer difficulty sliders with neutral names and no achievement lock (JUDGEMENT).
5. **Player stress leaking.** "I find this game stresses me out" [75]. Offer a "Stress intensity" setting (Off / Light / Standard / Harsh).
6. **Mental health sensitivity.** About one in three current elite athletes reports anxiety/depression symptoms [12], and the IOC recommends screening and professional treatment [10][11]. So:
   - **Do not** name states with clinical labels ("Depressed", "Bipolar", "Suicidal"). Use behaviour/performance language ("Off the rails", "Lost the hunger", "Burnt out").
   - **Do not** let gold buy instant cures for the severe state (unlike DD's Tavern/Abbey [61]). The severe state needs time, support and a professional-help path. Never offer "fine him" or "release him" as the main buttons.
   - **No suicide, self-harm or drug-use depiction** in event text. Real cases (Fury, Hatton) should not be used as named in-game events. If the game ever features real people, legal review is needed (JUDGEMENT).
   - Add an optional **content note** and a **support-resources link** in the menu when the stress layer is on (JUDGEMENT; common industry practice, not verified here).
   - Do not imply weight-cut deaths are "bad luck" rolls. Make the risk rise with the size of the cut and show it in the cut planner, with a warning, as ONE Championship's real hydration and walking-weight rules do [37].
7. **Head injuries are not "stress".** Keep concussion and brain health as medical systems (holds, clearance, cumulative exposure) so the game does not suggest grit can overcome brain injury [31][32][53].
8. **Wording.** Use "gym" for the building and "fight camp" only for pre-bout preparation in all UI strings (team rule). Avoid "insane", "crazy", "lunatic" (DD-style flavour). Prefer "rattled", "flat", "wired", "drained".
## 6. Sources (all accessed 2026-10-11)

Peer-reviewed and consensus
1. Meeusen R, et al. Prevention, diagnosis, and treatment of the overtraining syndrome: joint consensus statement of the ECSS and ACSM. Med Sci Sports Exerc 45(1):186-205. 2013-01. DOI 10.1249/MSS.0b013e318279a10a. https://pubmed.ncbi.nlm.nih.gov/23247672/
2. Kreher JB, Schwartz JB. Overtraining syndrome: a practical guide. Sports Health 4(2). 2012-03. DOI 10.1177/1941738111434406. https://pmc.ncbi.nlm.nih.gov/articles/PMC3435910/
3. Symons IK, Bruce L, Main LC. Impact of overtraining on cognitive function in endurance athletes: a systematic review. Sports Med Open. 2023-08-08. DOI 10.1186/s40798-023-00614-3. https://pmc.ncbi.nlm.nih.gov/articles/PMC10409951/
4. Bell L, et al. "Is it overtraining or just work ethic?" Sports (Basel). 2021-06-07. DOI 10.3390/sports9060085. https://pmc.ncbi.nlm.nih.gov/articles/PMC8227793/
5. Matos NF, Winsley RJ, Williams CA. Prevalence of NFOR/OT in young English athletes. Med Sci Sports Exerc 43(7):1287-94. 2011-07. DOI 10.1249/MSS.0b013e318207f87b. https://pubmed.ncbi.nlm.nih.gov/21131861/
6. Gustafsson H, et al. Prevalence of burnout in competitive adolescent athletes. The Sport Psychologist 21(1):21. 2007-03. DOI 10.1123/tsp.21.1.21. https://doi.org/10.1123/tsp.21.1.21
7. Raedeke TD, Smith AL. Development and preliminary validation of an athlete burnout measure. J Sport Exerc Psychol 23(4):281-306. 2001-12. DOI 10.1123/jsep.23.4.281. https://pubmed.ncbi.nlm.nih.gov/28682196/
8. Van Cutsem J, et al. The effects of mental fatigue on physical performance: a systematic review. Sports Med 47(8):1569-88. 2017-08. DOI 10.1007/s40279-016-0672-0. https://pubmed.ncbi.nlm.nih.gov/28044281/
9. Bian C, Kons RL, et al. Mental fatigue in Olympic combat sports: the unseen ongoing battle. Front Sports Act Living. 2025-11-13. DOI 10.3389/fspor.2025.1697860. https://pubmed.ncbi.nlm.nih.gov/41323869/
10. Reardon CL, et al. Mental health in elite athletes: IOC consensus statement (2019). Br J Sports Med 53(11):667-699. 2019-06. DOI 10.1136/bjsports-2019-100715. https://pubmed.ncbi.nlm.nih.gov/31097450/
11. Reardon CL, Gouttebarge V, et al. Mental health in elite athletes: IOC consensus statement (2026). Br J Sports Med 60(15):1083-1130. 2026-08-12. DOI 10.1136/bjsports-2025-111514. https://pubmed.ncbi.nlm.nih.gov/42580854/
12. Gouttebarge V, et al. Occurrence of mental health symptoms and disorders in current and former elite athletes: systematic review and meta-analysis. Br J Sports Med 53(11):700-706. 2019-06. DOI 10.1136/bjsports-2019-100671. https://pmc.ncbi.nlm.nih.gov/articles/PMC6579497/
13. Mountjoy M, et al. 2023 IOC consensus statement on REDs. Br J Sports Med 57(17):1073-1097. 2023-09. DOI 10.1136/bjsports-2023-106994. https://pubmed.ncbi.nlm.nih.gov/37752011/
14. Pensgaard AM, et al. Intersection of mental health issues and REDs. Br J Sports Med 57(17):1127-35. 2023-09. DOI 10.1136/bjsports-2023-106867. https://pubmed.ncbi.nlm.nih.gov/37752005/
15. Morgan WP, et al. Psychological monitoring of overtraining and staleness. Br J Sports Med 21(3):107-14. 1987-09. DOI 10.1136/bjsm.21.3.107. https://pmc.ncbi.nlm.nih.gov/articles/PMC1478455/
16. Hooper SL, Mackinnon LT. Monitoring overtraining in athletes. Recommendations. Sports Med 20(5):321-7. 1995-11. DOI 10.2165/00007256-199520050-00003. https://pubmed.ncbi.nlm.nih.gov/8571005/
17. Hooper SL, et al. Markers for monitoring overtraining and recovery. Med Sci Sports Exerc 27(1):106-12. 1995-01. PMID 7898325. https://pubmed.ncbi.nlm.nih.gov/7898325/
18. Foster C, et al. A new approach to monitoring exercise training. J Strength Cond Res 15(1):109-15. 2001-02. PMID 11708692. https://pubmed.ncbi.nlm.nih.gov/11708692/
19. Gabbett TJ. The training-injury prevention paradox. Br J Sports Med 50(5):273-80. 2016-01-12. DOI 10.1136/bjsports-2015-095788. https://pmc.ncbi.nlm.nih.gov/articles/PMC4789704/
20. Impellizzeri FM, et al. Acute:chronic workload ratio: conceptual issues and fundamental pitfalls. Int J Sports Physiol Perform 15(6):907-13. 2020-06-05. DOI 10.1123/ijspp.2019-0864. https://pubmed.ncbi.nlm.nih.gov/32502973/
21. Plews DJ, et al. Training adaptation and heart rate variability in elite endurance athletes. Sports Med 43(9):773-81. 2013-09. DOI 10.1007/s40279-013-0071-8. https://pubmed.ncbi.nlm.nih.gov/23852425/
22. Saw AE, Main LC, Gastin PB. Monitoring the athlete training response: subjective self-reported measures trump commonly used objective measures. Br J Sports Med 50(5):281-91. 2015-09-09. DOI 10.1136/bjsports-2015-094758. https://pmc.ncbi.nlm.nih.gov/articles/PMC4789708/
23. Kellmann M, et al. Recovery and performance in sport: consensus statement. Int J Sports Physiol Perform 13(2):240-5. 2018-02. DOI 10.1123/ijspp.2017-0759. https://pubmed.ncbi.nlm.nih.gov/29345524/
24. Barley OR, Chapman DW, Abbiss CR. Weight loss strategies in combat sports and concerning habits in MMA. Int J Sports Physiol Perform 13(7):933-9. 2018. DOI 10.1123/ijspp.2017-0715. https://pubmed.ncbi.nlm.nih.gov/29283792/
25. Reale R, Slater G, Burke LM. Acute-weight-loss strategies for combat sports. Int J Sports Physiol Perform 12(2):142-51. 2017-02. DOI 10.1123/ijspp.2016-0211. https://pubmed.ncbi.nlm.nih.gov/27347784/
26. Artioli GG, et al. Prevalence, magnitude, and methods of rapid weight loss among judo competitors. Med Sci Sports Exerc 42(3):436-42. 2010-03. DOI 10.1249/MSS.0b013e3181ba8055. https://pubmed.ncbi.nlm.nih.gov/19952804/
27. Hall CJ, Lane AM. Effects of rapid weight loss on mood and performance among amateur boxers. Br J Sports Med 35(6):390-5. 2001-12. DOI 10.1136/bjsm.35.6.390. https://pmc.ncbi.nlm.nih.gov/articles/PMC1724425/
28. Lakicevic N, et al. Effects of rapid weight loss on judo athletes: a systematic review. Nutrients 12(5):1220. 2020-04-26. DOI 10.3390/nu12051220. https://pmc.ncbi.nlm.nih.gov/articles/PMC7281976/
29. Matthews JJ, Nicholas C. Extreme rapid weight loss and rapid weight gain in UK MMA athletes. Int J Sport Nutr Exerc Metab 27(2):122-9. 2017-04. DOI 10.1123/ijsnem.2016-0174. https://pubmed.ncbi.nlm.nih.gov/27710145/
30. Kasper AM, et al. Case study: extreme weight making ... acute kidney injury in a male MMA athlete. Int J Sport Nutr Exerc Metab 29(3):331-8. 2019-05. DOI 10.1123/ijsnem.2018-0029. https://pubmed.ncbi.nlm.nih.gov/29989458/
31. Bernick C, et al. Repeated head trauma ... the Professional Fighters' Brain Health Study. Br J Sports Med 49(15):1007-11. 2015-08. DOI 10.1136/bjsports-2014-093877. https://pmc.ncbi.nlm.nih.gov/articles/PMC4518758/
32. Le Flao E, et al. Exploring the link between acute symptom changes and repetitive head impacts in boxing sparring. J Sci Med Sport 29(8):843-54. 2026-07. DOI 10.1016/j.jsams.2026.01.018. https://pubmed.ncbi.nlm.nih.gov/41672855/
33. Bryant BR, et al. Association of win-loss record with neuropsychiatric symptoms and brain health among professional fighters. J Neuropsychiatry Clin Neurosci 36(2):118-24. 2024. DOI 10.1176/appi.neuropsych.20230108. https://pubmed.ncbi.nlm.nih.gov/38258377/
34. Ardern CL, et al. Psychological factors associated with returning to sport following injury. Br J Sports Med 47(17):1120-6. 2013-11. DOI 10.1136/bjsports-2012-091203. https://pubmed.ncbi.nlm.nih.gov/23064083/

Journalism and documented cases
35. SCMP, Heart attack caused Yang Jianbing's death, 2015-12-23. https://www.scmp.com/sport/china/article/1894393/heart-attack-caused-chinese-mma-fighters-death-ahead-philippines-bout
36. Sherdog, ONE Championship official statement, 2015-12-12. https://www.sherdog.com/news/pressreleases/ONE-CHAMPIONSHIP-OFFICIAL-STATEMENT-97197
37. Sherdog, One Championship adopts new weigh-in policy, 2015-12-23. https://www.sherdog.com/news/news/One-Championship-Adopts-New-WeighIn-Policy-Following-Recent-Fighter-Death-97649 (also https://realcombatmedia.com/2015/12/one-championship/)
38. MMA Fighting, Leandro 'Feijao' Silva dies from stroke, 2013-09-27. https://www.mmafighting.com/2013/9/27/4778112/leandro-feijao-silva-dies-from-stroke-before-shooto-43-weigh-ins
39. MMA Fighting, Leandro Souza reportedly took diuretic pills, 2013-09-28. https://www.mmafighting.com/2013/9/28/4780878/leandro-souza-took-diuretic-pills-before-shooto-weigh-ins
40. Folha de S.Paulo, Morte reabre discussão sobre perda de peso, 2013-09-28. https://www1.folha.uol.com.br/fsp/esporte/131285-morte-reabre-discussao-sobre-perda-de-peso.shtml
41a. ESPN, Ryan Garcia abruptly pulls out of July fight, 2021-04-24. https://www.espn.com/boxing/story/_/id/31324625/ryan-garcia-abruptly-pulls-july-fight-javier-fortuna
41b. BBC Sport, Ryan Garcia pulls out to 'manage mental health', 2021-04-25. https://www.bbc.com/sport/boxing/56877709
41c. Ring News 24, 2021-04-24. https://www.ringnews24.com/2021/04/24/ryan-garcia-withdraws-from-javier-fortuna-bout-citing-mental-health-issues/ (also The Independent, 2021-04-25: https://www.independent.co.uk/sport/boxing/ryan-garcia-mental-health-fortuna-fight-b1837127.html)
42. The Guardian, Ryan Garcia badly misses weight, 2024-04-19. https://www.theguardian.com/sport/2024/apr/19/ryan-garcia-misses-weight-devin-haney-fight-weigh-ins
43. Rolling Stone, Tyson Fury interview, 2016-10-04. https://www.rollingstone.com/culture/culture-sports/world-heavyweight-champion-tyson-fury-ive-done-lots-of-cocaine-119571/
44. ESPN, Tyson Fury admits to 'lots of' cocaine use, 2016-10-05. https://www.espn.co.uk/boxing/story/_/id/17716915/tyson-fury-admits-lots-cocaine-use-talks-suicidal-thoughts-mental-health-issues
45. Irish Mirror, Fury's admission becoming champion was a 'disaster', 2020-02-13. https://www.irishmirror.ie/sport/other-sport/boxing/tyson-furys-heartbreaking-admission-becoming-21491518
46. BBC Sport, Ricky Hatton considered suicide after Pacquiao defeat, 2011-09-29. https://www.bbc.com/sport/boxing/15114640
47. BBC Sport, Ricky Hatton: 'I tried to kill myself several times', 2016-12-29. https://www.bbc.com/sport/boxing/38458724
48. The Guardian, Ricky Hatton dies aged 46, 2025-09-14. https://www.theguardian.com/sport/2025/sep/14/ricky-hatton-former-boxing-world-champion-dies
49. ESPN, Teofimo Lopez 'lucky he's not dead', 2021-12-04. https://www.espn.in/boxing/story/_/id/32785972/doctor-says-teofimo-lopez-lucky-not-dead-boxer-found-fought-air-chest
50. ESPN, 'The only person that beat me was myself', 2022-08-12. https://www.espn.co.uk/boxing/story/_/id/34380827/teofimo-lopez-vs-pedro-campa-teofimo-lopez-learn-mistakes
51a. BBC Sport, Malignaggi quits sparring role, 2017-08-04. https://www.bbc.co.uk/sport/boxing/40814914
51b. ESPN, Malignaggi throwing in towel as McGregor sparring partner, 2017-08-04. https://www.espn.com/boxing/story/_/id/20240996/paulie-malignaggi-throwing-towel-conor-mcgregor-sparring-partner
52. ESPN / MaxBoxing (Doug Fischer), "Gym Wars", 2004-10-15. https://www.espn.com/espn/print?id=1902402
53. The Guardian, Sparring Club investigation, 2025-08-09. https://www.theguardian.com/sport/2025/aug/09/sparring-club-boxraw-ring-video-safety-concerns
54. UPI Archives, Douglas weighs in heavy 246, 1990-10-24. https://www.upi.com/Archives/1990/10/24/Douglas-weighs-in-heavy-246/8673656740800/
55. ESPN, Loss to Brewster still drives Klitschko, 2014-11-14. https://www.espn.com/boxing/story/_/id/11873997/memory-lamon-brewster-loss-drives-wladimir-klitschko
56. MMA Fighting, UFC statement on Khabib Nurmagomedov, 2017-03-03. https://www.mmafighting.com/2017/3/3/14805818/ufc-releases-statement-on-khabib-nurmagomedov
57. BBC Sport, Will British boxing finally get a fighter's union?, 2026-02-17. https://www.bbc.com/sport/boxing/articles/cvg1plm3zd5o
58. BBC Sport, What can be done to help boxers' welfare, 2026-03-25. https://www.bbc.com/sport/boxing/articles/c78l97lp02lo
59. Los Angeles Times, California's boxer pension failing many, 2023-05-11. https://www.latimes.com/california/story/2023-05-11/california-retired-boxers-pension-plan-failing-to-deliver
60. FightAlpha (non-peer-reviewed), Does ring rust matter in UFC fights?, 2026-06-01. https://fightalpha.com/articles/does-ring-rust-matter-ufc

Games: mechanics (living wiki pages; dates NOT FOUND unless stated)
61. Darkest Dungeon Wiki, Stress. https://darkestdungeon.wiki.gg/wiki/Stress
62. Darkest Dungeon Wiki, Virtue. https://darkestdungeon.wiki.gg/wiki/Virtue
63. Darkest Dungeon Wiki, Stress (DD II). https://darkestdungeon.wiki.gg/wiki/Stress_(Darkest_Dungeon_II)
64. RimWorld Wiki, Mental break. https://rimworldwiki.com/wiki/Mental_break
65. RimWorld Wiki, Inspiration. https://rimworldwiki.com/wiki/Inspiration
66. SI, FM2023 manual: Your Squad, Team Report and Dynamics. https://community.sports-interactive.com/sigames-manual/football-manager-2023/your-squad-team-report-and-dynamics-r4727/
67. SI, FM2024 manual: Training. https://community.sports-interactive.com/sigames-manual/football-manager-2024/training-r4961/
68. Motorsport Manager PC Wiki, Drivers. https://motorsportmanagerpc.fandom.com/wiki/Drivers
69. Punch Club Wiki, Getting Started. https://punchclub.wiki.gg/wiki/Guides_and_Tips_(Punch_Club_1)/Getting_Started
70. The SmackDown Hotel, WWE 2K24 MyGM guide, 2024-09-21. https://www.thesmackdownhotel.com/news/wwe2k24/wwe-2k24-mygm-mode-full-guide-all-features-tips-tricks

Games: player reviews (Steam; review creation date UTC)
71. Darkest Dungeon review, 2026-07-30 (app 262060; author id not recorded).
72. Darkest Dungeon review, 2026-09-16 (app 262060; author id not recorded).
73. DD review, 2015-12-25. https://steamcommunity.com/profiles/76561198040225003/recommended/262060/
74. DD review, 2016-06-12. https://steamcommunity.com/profiles/76561198125338054/recommended/262060/
75. DD review, 2022-08-20. https://steamcommunity.com/profiles/76561198015948202/recommended/262060/
76. DD II review, 2024-06-29. https://steamcommunity.com/profiles/76561198000778151/recommended/1940340/
77. DD II review, 2024-01-12. https://steamcommunity.com/profiles/76561197982237517/recommended/1940340/
78. DD II review, 2023-05-10. https://steamcommunity.com/profiles/76561197971074683/recommended/1940340/
79a. RimWorld review, 2024-09-30. https://steamcommunity.com/profiles/76561198038327205/recommended/294100/
79b. RimWorld review, 2016-07-21. https://steamcommunity.com/profiles/76561197999390811/recommended/294100/
79c. RimWorld review, 2021-09-16. https://steamcommunity.com/profiles/76561197963576980/recommended/294100/
79d. RimWorld review, 2022-01-19. https://steamcommunity.com/profiles/76561198011706494/recommended/294100/
80a. Punch Club review, 2016-01-24. https://steamcommunity.com/profiles/76561198012531787/recommended/394310/
80b. Punch Club review, 2016-12-16. https://steamcommunity.com/profiles/76561197965229974/recommended/394310/
81a. FM2024 review, 2024-01-16. https://steamcommunity.com/profiles/76561198025404044/recommended/2252570/
81b. FM2024 review, 2024-01-01. https://steamcommunity.com/profiles/76561198033006928/recommended/2252570/
82. FM Scout (BTFM), Morale and Relationships in Football Manager, 2022-05-25. https://www.fmscout.com/a-morale-and-relationships-in-football-manager.html
83. Nicolas M, et al. Short version of the RESTQ-Sport in elite swimmers. J Sport Health Sci. 2016-05-10. DOI 10.1016/j.jshs.2016.03.007. https://pmc.ncbi.nlm.nih.gov/articles/PMC6349564/
84. Gnacinski SL, et al. Psychometric properties of the RESTQ-Sport-36. Front Psychol. 2021-05-26. DOI 10.3389/fpsyg.2021.671919. https://pmc.ncbi.nlm.nih.gov/articles/PMC8187868/
85. Motorsport Manager review, 2022-03-21. https://steamcommunity.com/profiles/76561197986296583/recommended/415200/
86. Motorsport Manager review, 2017-10-07. https://steamcommunity.com/profiles/76561198244185880/recommended/415200/

---

## 7. Limits

- **Abstract-level reading.** Most papers were read at abstract level (PubMed/Europe PMC). The ECSS/ACSM 2013 full text was not opened. Its recovery-duration table is cited through Kreher & Schwartz [2] and Symons et al. [3]. Treat exact wording as secondary.
- **Boxing-specific gaps (NOT FOUND):** boxing OTS/burnout prevalence; boxing-specific mental health meta-analysis; peer-reviewed post-KO "gun-shy" data; peer-reviewed "ring rust" data; boxing-only weight-cut percentages from Barley et al.; HRV studies in boxers; a direct Freddie Roach quote on limiting sparring; any verifiable Devin Haney stress or mental-health case.
- **Journalism is not clinical evidence.** Fighter cases show that behaviours happen, not how often. Quotes are as reported by the outlet. Some details (Souza's diuretics, the 33 lb figure) were reported at the time and in preliminary findings, not a final medical report.
- **Steam reviews are self-selected.** They are biased toward strong opinions, and recent reviews overweight current patch states. Items 71-72 lack recorded author ids. Review URLs were built from API ids, not opened one by one. Press reviews were not gathered.
- **Wikis are community-maintained and change over time.** Numbers (DD 25% virtue, RimWorld 35/20/5%, DD2 80/20) reflect the pages on the access date and may differ by game version.
- **Some 2026 sources** (IOC 2026 update [11], Le Flao 2026 [32], BBC 2026 [57][58], FightAlpha [60]) are recent and have had little follow-up scrutiny.
- **Section 4 numbers are untested design proposals.** They need prototyping and playtesting.
- **Sensitive content.** This document quotes real people's statements about depression and suicidal thoughts for design grounding only. They should not be turned into in-game events.

---

That's the whole document. One thing to know: the file didn't get saved to my computer, because the safety check errored on the write twice. This chat copy is the only full version, so Claude can land it from here as `research/J_STRESS_S206.md`.
