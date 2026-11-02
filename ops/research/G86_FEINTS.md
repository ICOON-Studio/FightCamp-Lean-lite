# G86 - FEINTS

> Grok (Expert mode), delivered 2026-09-24 in chat https://grok.com/c/51ca5758-b573-4e8f-be45-a8347dd98a6a
> ("Worked for 2m 43s", 118 sources). Brief: `research/G86_BRIEF.md`. Saved VERBATIM by Claude in S69 from
> get_page_text; the chat's tables arrive as tab-separated rows and are kept that way rather than re-typed.

FightCamp research brief. Numbers only where a source counted them. Everything else is marked NOT FOUND and given a proxy. CompuBox and UFC Stats/FightMetric do not code feints. Neither does the published amateur-boxing activity-profile literature (Davis / Connorton / Thomson 2016). The only fight-video count of feints found is Hussein 2004.

## 1. Feint rate

### What was counted, and how

```
Source	Sport / sample	Method	Feints
Hussein 2004, Göttingen dissertation	Olympic boxing, Sydney 2000. 16 semis + 12 finals. 4 × 2 min. 19 feint types (eye feints excluded — camera limits). Manual video coding, second-coded by an Armenian coach on 5 bouts	Wide definition: foot, trunk, shoulder, half-step, half-punch, combined and variable-combined	Winners 2,934 coded feints vs losers 2,024 across 28 boxer-performances each. ≈ 105 vs 72 per fighter per 8-min bout ≈ 13.1 vs 9.0 / min. Heavies > lights. Winners used more combined feints (1,021 vs 873) and varied type more across rounds
Thomson, Lamb & Nicholas 2013 (J Sports Sci)	English amateur template: 4 feint types (foot, head/trunk, lead hand, rear hand)	Intra-observer agreement 80–100%; inter-observer weaker but unbiased	Template exists. Published frequencies: NOT FOUND. Thomson & Lamb 2016 (IJPAS, n=92) dropped feints and reported only punches (~25/min) and defences (~10/min)
Davis et al. 2015 / 2017 (JSCR)	Elite amateur 3 × 3, 29 Olympic SF/F then 50 World-Championship bouts	Video activity profile	~20–21 punches/min, ~2.5–3.6 defences/min, ~47–56 vertical hip movements/min. Feints not a category
CompuBox	Pro boxing, live two-operator 4-button board	Jab thrown/landed, power thrown/landed	Does not count feints. Ali–Patterson I R1 is the textbook case: Clay "feinted a lot but threw no serious punches"; CompuBox still only logs the few half-speed jabs
FightMetric / UFC Stats	UFC	Significant / total strikes, TD, control	Does not count feints
Myers 2013 (Advances in PE)	32 Muay Thai bouts, Thai vs UK winners	Notational: punches, kicks, knees, teeps, clinch	~110 offensive techniques per fighter per bout. Feints not a category
```

Pro boxing rate: NOT FOUND.

Proxy: elite amateur under the wide Hussein definition ≈ 9–13 feints/min; under a strict "half-punch / committed start-up" definition the number would be much lower (coach consensus: a few committed feints per minute plus a stream of 10–15% path twitches). Pro 12×3 output is 13–23 punches/min depending on style (CompuBox). A working ratio from Hussein + contemporary punch rates in 2-min amateur rounds (~37–38 punches/min, older Davis citations): ~1 wide-coded feint per 3 punches.

Kickboxing / Muay Thai / MMA rate: NOT FOUND.

Proxy: same kinematic start-ups exist (jab, teep, hip-load for round kick). Thai fighters throw more teeps and body kicks than UK fighters (Myers); those are the threats that make teep-feints and hip-feints land. MMA significant-strike attempts typically ~8–15/min at distance. Feint density is qualitatively high in City Kickboxing / Eugene Barry footage and in boxing-into-MMA styles; there is no count.

### Style / round / level

- Winners feint more than losers (Hussein; p < 0.01). Combined and variable-combined feints drive the gap.
- Heavies feint more than lights (Hussein). Proxy reason: one clean shot ends the fight, so deception is cheaper than trading.
- Counter-punchers vs pressure: NOT FOUND as a counted split. Qualitative only — Mayweather / Hopkins: high density of small feints, low punch volume (Mayweather often 30–35 punches/round). Pressure fighters (GGG, early Pacquiao): fewer pure feints, more committed level-changes and step-ins that double as entries.
- Round: Hussein — winners vary type more from R1 to late rounds; variable feints late are higher in heavies. No per-round rate table survived in usable form.
- Elite vs amateur: NOT FOUND as a head-to-head count. Thomson's template would have allowed it; the 2016 paper did not publish it. Coaching claim that is consistent with Hussein + Hopkins footage: elites use smaller feints at similar or higher density.

## 2. Reaction rate

Share of in-fight feints that draw a visible reaction (flinch, guard raise, slip, step back, counter attempt, level drop): NOT FOUND. No CompuBox, FightMetric, Slack, Wylie, or IJPAS paper codes it.

### What the opponent does — lab and video-task

Ripoll, Kerlirzin, Stein & Reine 1995 (Human Movement Science). French boxing. Experts / intermediates / novices on video: attacks, openings, feints.

- Group differences only in complex (mixed) situations.
- Experts more accurate on real attacks, same RT as novices.
- Experts made more false alarms to feints. When the task was "react to attacks," false-alarm rate sat around 33–35.5% regardless of complexity; openings produced ~10% FA.
- Read: elites are biased toward treating a start-up as real. Missing a real shot costs more than biting a fake.

Pfister, Jackson, Güldenpenning & Williams 2023 (Human Movement Science 89:103092). Boxing-specific spatial-attention task. 20 boxers + 20 non-boxers. Fake punch then real punch, same side or opposite, SOA 200 or 600 ms.

- Same-side fake + 600 ms delay → inhibition of return. Valid-cue RT 355 ms vs invalid 344 ms. IOR = 11 ms, d = 0.81.
- Short SOA (200 ms): no IOR.
- Boxers = non-boxers on RT, errors, and false alarms.
- Years of boxing positively correlated with IOR size. Training does not delete the effect; at 600 ms it can enlarge it.

### Deception literature (Güldenpenning, Kunde, Weigelt and related)

Basketball head-fake is the best-measured deceptive action. It is a gaze/head-direction conflict, not a punch start-up. Transfer to striking is partial — use the numbers as an upper bound on attentional cost, not as a landed-rate lift.

```
Finding	Size	Source
Head-fake RT cost	typically 15–80 ms; 34 ms at 300 ms SOA (d = 1.58), 2 ms at SOA 0, 16 ms at SOA 800	Güldenpenning et al. PLOS One 2021
Error cost	~2–4 percentage points typical; 2.5% vs 0.11% at SOA 200; at 20% fake-frequency, 6.1% vs 2.2%	same lab stream; PMC11281954
High fake-frequency shrinks the effect	20% fakes → large effect; 80% fakes → small or reversed (observers start treating fakes as the default)	Güldenpenning et al. 2018; Alhaj Ahmad Alaboud 2012
Previous-trial fake can wipe the effect in basketball experts (not in soccer players or novices)	trial n–1 adaptation	Weigelt et al. 2016
Cost to produce the fake	+12 ms initiation (444 vs 432 ms); gone after one day of practice if given ≥400 ms prep	Böer, Weigelt, Schütz, Güldenpenning 2024
+100 ms extra initiation on the faker raises opponent "this is a fake" detection by ~10%	Kunde et al. 2019, cited in the production-cost papers
```

How far this transfers to striking. Pfister is the transfer study. The cost that survives in a boxing-shaped task is ~11 ms IOR at 600 ms, not the 34–80 ms basketball head-fake. A jab hangs in the 150–250 ms flight band; 11 ms is a small but real shift in who owns the pocket. The bigger in-fight effect is not the millisecond tax. It is the positional error Ripoll's experts make on purpose: hands go up, weight goes back, hips drop. That is a guard displacement, not an 11 ms RT bump. Share of those displacements, by type: NOT FOUND.

Coaching taxonomy of reactions (no shares): high-guard / parry; slip toward the fake; step back / reset; counter-jab or overhand; level drop for the body; freeze. Different feints buy different ones (jab-feint → parry or high guard; sit/level-feint → elbows in and head exposed; teep-feint → weight back, lead leg light).

## 3. Payoff

Landed-rate of the shot after a feint that drew a reaction, vs an unset shot: NOT FOUND.

Not in CompuBox, FightMetric, UFC Stats, Davis, Thomson 2016, Myers, IJPAS boxing papers, J Sports Sci activity profiles, Lee Wylie, or Jack Slack as a coded rate. Slack / Wylie / Precision Striking / City Kickboxing describe the geometry (feint high → body; feint the lead hip → opposite hook or cross; teep-feint → 1–2 or rear kick; sit-feint → head) and stop there.

Proxies the engine can use:

- Lab error + delay: opponent is 2–4 pp more likely to choose the wrong response and 11–34 ms late. That is a land-chance lift, not a measured one.
- Ripoll: elites already over-react. The feint is fishing in a pond that is biased toward biting.
- Coaching constraint that is load-bearing: a feint with no established threat does not pay. Selberg / Banasiak / almost every feint essay: land the real shot first, then fake it.

### Decay / habituation

Lab is clear. Fight-video is not.

- Global frequency: 80% fake block shrinks the head-fake effect; 20% enlarges it (Güldenpenning 2018). Observers update base rates inside a session.
- Local (trial n–1): one fake can cancel the next fake's effect in experts (Weigelt 2016).
- In-fight decay speed in minutes or unanswered-feint count: NOT FOUND.
- Coaching: after a short run of unanswered feints the opponent stops moving. Re-establish with a real shot of the same family. Nat Hearn / "why aren't your feints working": when they stop biting, hit them.

Tells. Opponent who has seen the same shoulder-twitch three times without a punch attached will time the real one. Production-cost paper: a slow, obvious fake (+100 ms init) makes the fake more readable. Small, on-path feints stay cheap and stay ambiguous.

## 4. Cost to the feinter

```
Cost	Evidence
Time	Committed feint ≈ punch start-up minus contact. Coaching: show 10–15% of the path for a soft feint, more only when you want a freeze or a slot change. Lab production cost +12 ms (basketball), erasable with prep ≥400 ms
Stamina	NOT FOUND as kcal / HR / punch-equivalent. Coaching consensus is consistent: soft feints are cheap (Hopkins, Mayweather); hard feints cost nearly a punch and break stance. Flood-the-radar only works with the cheap ones
Getting countered on the feint	Real. Over-committed half-punch or loaded hip with no hand home is a counter lane. Rate: NOT FOUND
Telegraphing	Stereotyped inventory becomes a tell. Same as decay. Also: a big theatrical feint is less believable against elites than a 10% path twitch (Hopkins / Precision Striking)
```

Net: a small feint is cheaper than a punch, safer than a punch, and only pays if the other man still respects the threat.

## 5. How shipped games model it

```
Game	Input	Cost	AI / opponent	What players said
Fight Night Champion	None. EA confirmed: no punch feint	—	—	Forum complaint 2011: "and you call this a boxing simulation." Devs did not want feint-spam
Undisputed	D-pad left + punch (or stick). Same slot as taunt, poorly documented	Recovery after the animation. 2025 patch introduced a 5–6 s lockout after some feints (bug)	AI "doesn't appear to bite"; online does	Useful vs humans when it works. Spam styles exist. Patch made a dedicated feint-game unusable for a stretch
EA UFC 3 / 4 / 5	Tap RT/R2 shortly after strike start = cancel/feint. Also cancels a kick you will miss	Animation recover + stamina of the cancelled strike. You are still in the pocket for a beat	AI does drop/raise the guard if the start-up is readable. Body-jab feint → head upper is the community staple. Kick feints weaker in UFC 5 than 4	Underused at every level. "Undeniable" transition fakes on the ground are a separate, timing-heavy tech. Spam is limited by stamina and by people who stop biting
Tekken / Street Fighter	Cancel / feint is an input cancel (C. Viper TK/SH cancel, focus-dash cancel), not a read-the-flinch tool	Meter or extra recovery on a failed cancel	Opponent reacts to the frame situation, not to a sold start-up	Different mechanic. Do not copy it into a sim that is trying to model a flinch
```

Lesson for a sim: if feints are free and the AI always bites, players spam. If the AI never bites (Undisputed CPU, Fight Night), the input dies. The live-game that half-works (UFC RT-cancel) still needs a reaction that can be trained out.

## 6. What the engine should gate

Bands are for a committed, readable start-up (lead-hand, rear-hand, sit/level, foot-step, teep/hip-load). Soft 10% twitches can sit above the rate cap as cheap probes with a much lower reaction chance.

```
Discipline	Feint rate	Reaction-rate on a committed feint	Landed-rate lift on the immediate follow-up, if a reaction fired	Decay
Boxing	6–14 / min wide (Hussein 9–13 elite amateur; pro proxy lower on a strict definition, higher for Hopkins/Mayweather small-feint styles). Style split: counter ~upper half, pressure ~lower half. Winners > losers	NOT FOUND in-fight. Gate 0.25–0.45 visible reaction on a committed feint that has a live threat behind it; 0.10–0.20 if the threat is cold. Ripoll FA ~35% is the ceiling for "treat as real" in a forced-choice task, not a fight share	NOT FOUND. Gate +15–30% relative land chance on the next strike of the opposite line or opposite level, only on the exchange that follows a drawn reaction. Unset baseline stays the fighter's normal accuracy	Reaction chance drops after 2–4 unanswered feints of the same family (lab 80% fake-frequency + coaching). Recovers after a landed real shot of that family. High-skill opponents adapt faster (Weigelt n–1)
Kickboxing / Muay Thai	NOT FOUND. Gate 4–10 / min committed (teep, jab, hip-load). Thai-style higher teep-feint share	Same band as boxing. Teep-feint → weight back / lead-leg lift. Hip-feint → check or high guard	Same +15–30% relative on the opposite tool (teep-feint → 1–2 or rear kick; double hip-feint → hook then kick — Knowles/Haggerty pattern)	Same unanswered-count decay. Re-establish with a real teep or real kick
MMA	NOT FOUND. Gate 3–8 / min at distance, lower in the clinch/fence. Small gloves raise the cost of biting, which should raise reaction rate slightly vs boxing (Ripoll logic: missing the real one is worse)	0.30–0.50 when the threat is live — biting a fake 4-oz shot is cheaper than eating it. Level-change feints also sell the shot	Same relative lift on the follow-up strike. Extra line: feint strike → shot. No count exists; keep the lift conservative	Same decay. Fence and TD threat are extra "live threat" flags that keep reactions high
```

Shared rules, all three.

- No reaction, no lift. A feint that does not move the guard is just a short animation.
- Threat flag: a family (jab, cross, teep, low kick, level change) is "live" after it has landed in this fight. Cold family → bottom of the reaction band.
- Timing window: Pfister says ~600 ms same-side is where IOR hurts the defender; Güldenpenning says ~300 ms is where a misleading cue peaks. Follow-up should land inside ~0.3–0.7 s of the feint, not as a new, unset exchange two seconds later.
- Cost: soft feint ≈ small stamina chip + short recover. Hard feint ≈ most of a punch's stamina and a counterable recover. Getting hit during a hard feint is allowed.
- AI must stop biting. That is the whole mechanism.

Still unknown: in-fight reaction share by type, landed-rate lift after a drawn reaction, unanswered-feint half-life in a real round, and any counted feint rate for pro boxing, kickboxing, Muay Thai, or MMA.
