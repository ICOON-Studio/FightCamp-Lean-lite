# J24 — WHAT A STOP-HIT COSTS WHEN IT FAILS

**Desk:** FightCamp research, John  
**Date:** 2026-09-13  
**Status:** research only. No engine. No GDScript. No invented rates.  
**Question:** the catalogue tags `stop_hit` (10) and `intercept` (2) as pure benefits. Proposal: holder gets a roll to land first; on success the attacker aborts. Failed roll currently costs nothing. What should a miss cost? Built for takedown counters (knee / uppercut vs double-leg).

**Verification:** every URL below was searched or opened live on **2026-09-13**.

---

**Real combat:** a missed interception is not a no-op. The defender has spent the defensive layer — hips, guard, weight, or right-of-way — and is now in the attacker's path with an open structure. In foil/sabre the rules award the touch to the attacker; in MMA the missed knee leaves the hips where the shot wants them; in boxing the mistimed counter is taken cleaner than a covered punch.

**Shipped games:** they stop interception being free by making the attempt itself a committed action. Miss = recovery frames, extra damage while throwing, a heavy that comes out, a structure break, or a throw that becomes unbreakable. Designers who tried a no-risk version said it had "no risk involved" and would make defence the only thing players do.

---

## How to read this memo

| Grade | Meaning |
| --- | --- |
| **DOCUMENTED** | Quoted or paraphrased from a named primary fetched 2026-09-13: FIE rules, peer-reviewed paper, named coaching text, official game tutorial / patch note, named developer interview. |
| **INFERENCE** | Follows from documented mechanics without adding a number. Not a rate. |
| **NOT FOUND** | Searched live. No usable primary. **A fabricated percentage is worse than none.** |

Real combat and game design are in separate sections. A frame number from Tekken is not a boxing injury rate. A fencing convention is not an MMA completion rate.

**Refuse:** invented TD% vs knee-miss vs sprawl; invented "X% more damage" for a mistimed check hook; wiki rates treated as FightMetric; Fight Encyclopedia blog tables treated as peer-reviewed.

---

## Verdict the catalogue can use

1. **A free failed intercept roll is not how real combat or shipped games work.** Every serious system that lets you try to land first attaches a cost to missing.
2. **Published TD success vs "striker attempted a knee/uppercut" vs "defender sprawled": NOT FOUND.** Do not mint one. The mechanical case that a missed knee is *worse* than a sprawl is strong; the numerical case does not exist in the public record.
3. **Published "hit X% harder than covering" for a mistimed check hook / stop-hit: NOT FOUND.** The *why* (forward/rotational weight, open guard, cannot roll-with) is documented in coaching and in one kinematics paper's combined-velocity remark. The multiplier is not.
4. **The coaching name to steal is fencing: stop-hit (`coup d'arrêt` / `arrêt` / Italian `arresto`) vs counter-time (`contre-temps`).** Foil/sabre rules *are* the cost function. Boxing, wrestling, and Muay Thai describe the same gamble but do not score it as a named foul/priority loss.
5. **What stopped interception being the only thing players do:** the attempt is an attack (committed startup + recovery); being hit *during* it is extra-vulnerable; the opponent has a tool that beats the attempt (feint, throw, counter-time); when the reward got too high, live teams cut it (For Honor 2017).

---

## 1. TAKEDOWN CASE — missed knee / uppercut vs double-leg

**Question:** fighter throws a knee or uppercut at the shooter of a double-leg and misses. Taken down *more easily* than one who sprawled? Published figures: TD success vs striker-attempted vs sprawled defender.

### 1.1 The published comparison does not exist

**NOT FOUND.** Live searches on 2026-09-13 did not return a peer-reviewed, FightMetric, or UFC Stats table that splits takedown *completion* by the defender's choice (knee/uppercut attempt vs sprawl vs hands/whizzer).

Searches run (representative):

- `double leg takedown success rate vs sprawl vs knee strike counter miss MMA`
- `MMA takedown defense sprawl vs striking counter statistics UFC`
- `"takedown success" "knee" OR "counter strike" OR "striking" sprawl statistics MMA paper`
- `site:ufcstats.com takedown defense striking vs wrestling`
- `knee to takedown shot miss MMA taken down easier than sprawl coaching`

What those searches *did* return is listed below. None of it is the split the brief asked for.

### 1.2 What *is* published (aggregate, not the split)

| Figure | Population | What it is **not** | Source | Grade |
| --- | --- | --- | --- | --- |
| Takedowns 1,023 attempted, 323 successful, **31.6%** overall; lower-body takedowns **39.8%** (216/542) | Small-weight-class MMA sample in one methods paper | Not split by defender technique | Chen et al., *Combat Sports Science* (Cambridge Publish), PDF: https://www.cambridgepublish.com/css/article/download/243/250 | **DOCUMENTED** (that paper's count) |
| Winners' median TD% **50.0%** vs losers **20.0%** (exploratory; authors warn: not causal) | 8,461 UFC bouts, 1997–2025 | Not split by sprawl vs strike-counter | Ma, Li, Zhu et al., *BMC Sports Science, Medicine and Rehabilitation* (2026-06-18): https://link.springer.com/article/10.1186/s13102-026-01804-8 | **DOCUMENTED** |
| UFC Stats **TD Def** = share of opponent TD *attempts that did not land* | Per-fighter career pages on ufcstats.com | Does not log *how* the attempt was stuffed | http://ufcstats.com/ | **DOCUMENTED** (definition) |

Career TDD for named sprawl-and-brawl fighters (Liddell, Aldo, etc.) is a **person-rate**, not a technique-rate. Using "Aldo 74% TDD" as "sprawl works 74% of the time" is a category error. **NOT FOUND** as a technique split.

Blog tables that claim "elite sprawl TDD 75–85%" (Fight Encyclopedia, 2026) are **not** used here as rates.

### 1.3 What the two defences actually do to the body

These are mechanics, not rates.

**Sprawl (wrestling / MMA).**

- **DOCUMENTED (named coaching text):** Dan Gable, *Coaching Wrestling Successfully* (Human Kinetics, 1999 / 2nd ed. 2009), is the standard American collegiate reference for drilling the sprawl until it is reflexive. Secondary restatement of Gable's method: hips shoot **backward and down**, chest weight onto the shooter's upper back, legs leave the attacker's reach. (Gable text itself is paywalled; the hip-back definition is also the USA Wrestling / folkstyle teaching, restated across coaching video and manuals.)
- **DOCUMENTED (coaching hierarchy, named answer):** Martial Arts Stack Exchange, 2021-05-01, wrestling-view answer: defence layers are **hands → elbows → head → hips**. "Sprawling is done with the hips, once you have failed to defend with the hands, elbows, and head." https://martialarts.stackexchange.com/questions/10490/is-a-sprawl-or-knee-generally-more-effective-against-takedowns
- **DOCUMENTED (MMA instruction):** Grapplearts / Stephan Kesting, "Sprawl Counter vs Double Leg Tackle" (2012): defender sprawls, **then** knees the stuffed head — knee *after* hips are back, not instead of them. https://www.grapplearts.com/sprawl-counter-vs-double-leg-tackle/

**Knee / uppercut into the shot (MMA / Muay Thai).**

- **DOCUMENTED (Muay Thai names, not MMA rates):** straight knee is **khao trong**; it is a forward thrust off a planted support leg (muaythai.com, "Muay Thai Knees: Explained", 2024-04-21). https://muaythai.com/muay-thai-knees-explained/
- **DOCUMENTED (timing, not a rate):** YouTube video essay *Kneeing the Takedown* (2025-01-18) measures specific UFC sequences at 60 fps and concludes: against a **telegraphed** shot with a punch tell, a knee can land; against a **fast, no-tell** shot (the essay's Khabib / Merab class), "sprawling is much faster than getting a knee up" and a late knee "get[s] wrapped up and taken down." This is one analyst's frame-count of named fights, not a league table. https://www.youtube.com/watch?v=u8WEZSt_g_o
- **DOCUMENTED (successful intercept, not the miss):** Jorge Masvidal flying knee KO of Ben Askren (UFC 239, 2019) is the highlight everyone cites. It is a **landed** intercept. It does not measure the miss.

**INFERENCE (no number):** a missed knee/uppercut is a *worse* takedown defence than a sprawl for four independent mechanical reasons, each the inverse of the sprawl:

1. **Hips did not go back.** The double-leg's job is to get the attacker's shoulders under the defender's hips. Sprawl moves the hips away. A rising knee or standing uppercut keeps (or squares) the hips over the shot.
2. **One support is committed.** A knee requires a planted base leg and a lifting striking leg. That is a one-legged post in the path of a two-arm, two-leg drive. An uppercut similarly plants and loads.
3. **Hands are striking, not posting.** Wrestling's first layers (hands, elbows) are abandoned for the punch/knee. There is no underhook, no cross-face, no down-block.
4. **Weight is forward or square.** The knee's power line is into the shooter — the same direction the shooter is already travelling.

That is why coaches who *do* teach the knee usually teach it **on a read** (level-change tell, punch-then-shot), or **after** a sprawl has already killed the penetration — not as a replacement for hips-back.

**INFERENCE (no number):** "taken down more easily than one who sprawled" — **yes as a mechanical claim**, **not as a published rate**. The catalogue should cost a missed intercept *as if* the defender skipped the sprawl, not as if they were still in a covered stance.

### 1.4 What a miss looks like in the cage (not a rate)

**DOCUMENTED (coaching, named):** Jon Fitch, "When they commit to a strike they are vulnerable" (2025-03-31): a wrestler who makes the striker miss a committed shot is "inside" and "take[s] the easy takedown." This is the *attacker's* view of the same exchange. https://www.youtube.com/watch?v=yKw57Hl1H0s

**DOCUMENTED (MMA vs wrestling difference):** Monarchy MMA, "Why Failed Takedowns Are More Dangerous in MMA" — that page is about the *shooter's* failed shot (knees to a stuffed head). It does **not** quantify the *defender's* failed knee. Cited only to keep the two failures distinct. https://monarchymma.com/classes/adults/mma/mma-takedown/

Highlight KOs (Masvidal–Askren, Edson Barboza–Luke Cocoran class of knee-on-shot) are **success** cases. Using them as the cost of a *miss* would invert the evidence.

---

## 2. STRIKING CASE — mistimed check hook / stop-hit vs covering

**Question:** counter-puncher mistimes a check hook / stop-hit. Hit harder than covering? Why (forward weight, open guard, no roll-with)?

### 2.1 No published "X% harder" figure

**NOT FOUND.** No peer-reviewed paper, CompuBox summary, or named coaching text fetched today gives a numeric damage ratio of "mistimed counter vs covered punch."

Searches run:

- `failed check hook counter punch more damage boxing coaching`
- `boxing counter punch vulnerability open guard leaning into punch biomechanics injury`
- `boxing "covering up" vs counter punch "roll with" "planted" "eat the punch" coaching Teddy Atlas Freddie Roach`
- `Jack Dempsey Championship Fighting punching with the punch roll with punch covering up`

### 2.2 Why coaches say it is worse (the three reasons in the brief, sourced)

**Open guard.**

- **DOCUMENTED:** Honour & Glory Boxing, "Counter Punching Basics" (2025-09-20): "Throwing a punch creates vulnerability. The attacker's guard opens, their weight shifts, and they are momentarily committed." And: "Do not lean forward trying to land counters." https://www.honourandglory.co.uk/blog/counter-punching-basics
- **DOCUMENTED:** Teddy Atlas, *How to Time Your Counter Punches on the Inside* (Dynamic Striking): inside, "tighten your defense" means "hands up and tuck your elbows in"; fighters "open themselves when they punch and leave a tiny opening." The *successful* inside counter is a **short** punch from a **tight** guard — not a wide hook with the other side empty. https://dynamicstriking.com/blogs/news/how-to-time-your-counter-punches-on-the-inside-with-teddy-atlas
- **DOCUMENTED:** Freddie Roach, Wild Card "Defense Notes #2 — Blocking Counter Punches" (2025-01-03): after a right hand, "get it back to your face" immediately because "the Hook's coming"; if you "pull back and you open up here then you [are] wide open." https://www.youtube.com/watch?v=YJIxOai5MOo

**Forward / rotational weight (cannot be a soft target).**

- **DOCUMENTED (check-hook definition):** BoxRec wiki (technique page, used here only for the *definition*, not a rate): check hook = lead hook **plus** pivot on the lead foot / swing of the rear leg, "matador" vs a charging opponent. Requires "foot-speed to take a half-step back and pivot… almost simultaneously." If the pivot is late, the hook is thrown **in the pocket**, i.e. with rotational commitment and without the exit. https://boxrec.com/wiki/index.php/Check_hook
- **DOCUMENTED (named example of success, not the miss):** Floyd Mayweather Jr. vs Ricky Hatton, 2007-12-08, 10th-round check hook. Mayweather has said he learned it in the Michigan amateurs (BoxRec same page). A landed check hook is the *reward* of the gamble.
- **DOCUMENTED:** Coach Joe, "The Check-Hook" (Boxing at the Depot, 2015-11-05): short hook is "more powerful with more defensive risks"; "you are more likely to be punched by throwing a shorter hook." https://boxingatthedepot.com/coach-joes-boxing-technique-the-check-hook/
- **DOCUMENTED:** Precision Striking, "4 Ways to Counter the Check Hook" (2024): when the check-hook thrower is "up tall," the incoming right hand "down the pipe" finds "the face is wide open." That is the **punish** of a committed check hook, i.e. what happens when the gamble is read. https://www.youtube.com/watch?v=jbC1gjCnQqc

**No roll-with.**

- **DOCUMENTED:** Freddie Roach teaching Eddie Futch's favourite counter (TITLE Boxing, 2016-04-21): on the incoming right hand, "You've got to stay in and roll with the shot"; "don't make the mistake of coming up high on that shot… because you'll get crushed." Rolling *with* is a covered, shoulder-deflecting action. A stop-hit / check hook is the opposite commitment: you are punching *into* the line. https://www.youtube.com/watch?v=wOX3UHc_Pd0
- **DOCUMENTED:** "Learn how to ROLL with the PUNCHES" (2025-11-05, coaching video): rolling with a punch is moving the head **in the same direction as the punch** "to take the sting out"; it needs "both feet planted" and a free waist. A fighter who has already committed a hook or intercepting cross does not have a free waist. https://www.youtube.com/watch?v=endtQDbiC04
- Japanese Wikipedia "ボクシングの技術" (covering-up entry): covering is the last-chance defence; the body "rolls" incoming punches off the guard. A punching hand is not in that shell. **UNVERIFIED_SECONDARY** as a manual; cited only as a consistent restatement of covering-up. https://ja.wikipedia.org/wiki/ボクシングの技術

**Additive collision (the "hit harder" physics, without a multiplier).**

- **DOCUMENTED (coaching physics, no number):** Honour & Glory, same article: "When you counter, your punch meets their incoming momentum. The collision is harder than either punch would be alone." That sentence is about a **landed** counter on a coming-in opponent. The **symmetric** statement: if *you* are the one coming in / rotating into *their* punch, you supply the extra relative velocity.
- **DOCUMENTED (kinematics paper, qualitative):** Cheraghi et al., "Kinematics of Straight Right Punch in Boxing" (2014, ResearchGate copy of the published paper): "combined velocities (attacker fist velocity plus counter-attack punch velocity from opponent) could cause severe trauma"; "jumping forward while sparring… could increase whole body momentum and consequently increase head initial velocity that would intensify the magnitude of the impact when they simultaneously receive counter-attack punch." https://www.researchgate.net/publication/281098708_Kinematics_of_Straight_Right_Punch_in_Boxing  
  This is **not** a measured "mistimed check hook vs cover" ratio. It is a documented reason the brief's "forward weight" clause is not folklore.

**INFERENCE (no number):** a mistimed check hook / stop-hit is taken *cleaner and with higher relative velocity* than a covered, rolling punch, because (a) one hand is off the head, (b) the trunk is rotating or weighted into the line, (c) the waist is not free to ride the shot. Call it "harder than covering." Do **not** attach a percentage.

### 2.3 Two different counters — do not collapse them

| Action | What it spends | Miss cost (combat, not a rate) | Grade |
| --- | --- | --- | --- |
| **Cover → then return** (defensive counter) | A moment of guard; head can still roll | You ate a *covered* shot; return may be late | **DOCUMENTED** (FightFlow "defensive counters"; Roach/Futch roll) |
| **Simultaneous / pre-emptive** (check hook, pull-counter, intercepting cross, stop-hit) | Guard *and* the defensive layer in the same beat | You ate an *uncovered, committed* shot | **DOCUMENTED** as the higher-skill, higher-risk bucket (FightFlow "simultaneous" / "pre-emptive", 2026-04-22: https://fightflow.app/blog/boxing-counter-punching) |

The catalogue's `stop_hit` / `intercept` tags are the **second** row. Costing them like a missed jab from a high guard would understate the miss.

---

## 3. COACHING NAME — trading defence for an offensive gamble

**Question:** what do boxing, wrestling, Muay Thai, and fencing *call* this? Fencing may be best.

**Fencing is best.** It is the only one of the four whose **rules** assign the miss, not just a coach's warning.

### 3.1 Fencing — stop-hit, time-hit, counter-time

**DOCUMENTED (FIE definitions, December 2025 technical rules):**

- **Stop-hit:** "a counter-attack made into an attack" (t.12.1).
- **Stop-hit with opposition:** "a counter-attack made while closing the line in which the opponent's attack will be completed" (t.12.2). This is the time-hit.
- **Stop-hit "in time":** "made within a period of fencing time" (t.12.3; cf. t.88, t.105).
- **Counter-time:** "Any action made by the attacker against a stop hit made by his opponent" (t.13.4).

PDF: https://static.fie.org/uploads/40/203315-technical%20rules%20ang.pdf

**DOCUMENTED (the cost of a failed / not-in-time stop-hit — foil):** FIE t.89.4, "Only the fencer who is attacked is counted as hit":

> a) If he makes a stop hit on his opponent's simple attack;  
> …  
> d) If, into a compound attack, he makes a stop hit without being in time.

Same text in FIE Dec 2024 (fechten.org copy) and USA Fencing / Fencing Ireland reprints. https://www.fechten.org/fileadmin/user_upload/Technical_Rules_Englisch_Dec_2024.pdf

That is the cleanest sentence in the whole literature for this memo: **if you gamble the stop-hit on a simple attack and both lights go, you lose.** The parry you did not make is not available. The attacker keeps priority.

**DOCUMENTED (compound-attack exception):** t.88 — into a *compound* attack the defender *may* stop-hit, but only if the stop-hit "arrive[s] before the attacker has begun the final movement of the attack." Miss that interval and t.89.4.d applies: you are the one counted as hit.

**DOCUMENTED (épée is different — and that difference is the point):** épée has no right-of-way. A stop-hit that is late is a **double** (both score) if both arrive inside the lockout, or a loss if the attacker is clearly first. Club coaching (DS Fencing, 2026-04-29): "A 'standing' stop-hit is a double-touch waiting to happen"; "If you stop-hit without retreating, you will almost certainly get a double touch." https://dsfencingclub.com/blog/counter-time-stop-hit-fencing/

**DOCUMENTED (Italian school names):** fencing.net translation of Italian treatises (2007-07-17):

- **Uscite in tempo** — counter-attacks ("exits in tempo").
- **Arresto** — stop-hit: "must anticipate the last tempo of the opponent's action by one or more fencing tempos, AND close the line."
- **Contrazione** — stop-hit with opposition.
- Validity condition: "The fencer executing the counterattack, for it to be valid, must not be touched himself during the action" (except *cavazione in tempo*).

https://fencing.net/archives/counter-offensive-actions-in-italian-fencing/

**DOCUMENTED (named manual):** Aldo Nadi, *On Fencing* (1943; Dover reprint *Nadi on Fencing*): chapter **VIII The Counterattacks** (stop-thrusts); chapter **IX Contretemps Against Stop-Thrusts**. Contents listing: https://store.doverpublications.com/products/9780486443751  
Nadi's competitive memoir also states he based his game "upon the offensive defense of the counterattack and contretemps, as well as upon the third and fourth intention" (quoted on WS Fencing Club's Nadi page). https://wsfencing.wordpress.com/nadi-school-of-fencing/

**DOCUMENTED (German coaching text):** Barth & Beck, *The Complete Guide to Fencing* (Meyer & Meyer): foil stop-hits — "If the fencer who is carrying out the stop hit is also hit he will always be awarded the hit" [i.e. the *attacker's* hit is the one that counts in the conventional weapon]; "An error will turn the intended stop hit into an unjustifiable thrust." Snippet: https://vdoc.pub/documents/the-complete-guide-to-fencing-69utf8u8sbv0

**DOCUMENTED (the trap for the gambler):** counter-time is second intention *against the stop-hit*. The attacker *invites* the intercept, parries it, and scores. Amberger dictionary: "counter-time — a planned action made against an opponent's stop-thrust or stop-cut: drawing the stop hit and then acting upon it." https://ambergers-fencing-dictionary.com/english-reference-dictionary/

**INFERENCE:** fencing is the right name-set for the catalogue because it already encodes:

| Catalogue idea | Fencing name | Cost of failure (conventional weapons) |
| --- | --- | --- |
| Tag: try to land first | **Stop-hit / arrêt / arresto** | Not in time → **you** are hit (t.89.4.a/d) |
| Safer version: land first *and* close the line | **Time-hit / stop-hit with opposition / contrazione** | Still needs the close; a pure race without opposition is the cheap arrêt |
| Opponent who has seen you do this | **Counter-time / contre-temps** | Your intercept is drawn and punished |
| The whole family | **Second intention** | The first action was never the real one |

Épée's double-touch is the *other* costing model: both get hurt. That is closer to MMA (you land the knee *and* get taken down) than foil is.

### 3.2 Boxing — many descriptions, no single rule-name

| Name | Who uses it | What it means | Grade |
| --- | --- | --- | --- |
| **Counter-punching** | Atlas, Roach, Mayweather, every gym | Return (or simultaneous return) on the opponent's punch | **DOCUMENTED** |
| **Check hook** | Mayweather (named); BoxRec definition | Hook + pivot vs a coming-in opponent | **DOCUMENTED** |
| **Intercepting / punch-with** | gym English; FightFlow "pre-emptive counters" | Punch *into* the incoming | **DOCUMENTED** as a category, not a unified term |
| **Trading** | commentary English | Both punch; neither fully defends | **UNVERIFIED_SECONDARY** as a technical name |
| **Aggressive defense** | Jack Dempsey, *Championship Fighting* (1950) | Dempsey's book title and programme: defence that hits. Not a miss-cost rule. | **DOCUMENTED** (book exists; archive.org) |

Dempsey's falling step / jolt is about **putting weight into your own punch**, which is exactly the commitment that makes a *missed* intercept ugly. It is not a name for the gamble.

**NOT FOUND:** a boxing rule or scoring criterion that awards extra points (or a knockdown) specifically because the victim was countering rather than covering. Judges may *see* a cleaner shot; they are not required to log "failed intercept."

### 3.3 Wrestling — the gamble is usually refused

Wrestling's named defences against the double-leg are **down-block, whizzer, sprawl, front headlock** — layers, not a race to hit first. The Stack Exchange hierarchy (hands → elbows → head → hips) is the doctrine: you do **not** skip to an offensive gamble until the defensive layers have failed.

**NOT FOUND:** a standard folkstyle/freestyle name that means "I will knee/strike instead of sprawl." In wrestling there is no legal knee to the head. The MMA choice *is* the ruleset difference.

Gable's programme institutionalised the sprawl as reflexive (*Coaching Wrestling Successfully*). That is the opposite of a stop-hit culture.

### 3.4 Muay Thai — intercepting knee, not "check"

- **Check** in MT/kickboxing almost always means **checking a kick** (shin to shin), not intercepting a shot. Do not reuse it.
- **Khao trong** (straight knee) / **khao chiang** (diagonal) are the weapons. Using them as a *stop* on a changing-level opponent is taught in MMA gyms as a hybrid, not as a traditional stadium-MT named tactic against a double-leg (there is no double-leg in stadium MT).
- **NOT FOUND:** a Thai-language technical name, in a named kru's published manual, that means "trading the sprawl for a knee." English MMA gyms say "knee the shot," "intercepting knee," "flying knee on the shot."

### 3.5 Recommendation for the tag copy

Use **stop-hit** for the benefit and **not in time** (foil) / **double** (épée) / **counter-time** (the punish) for the miss. Boxing "check hook" is a *species*. Wrestling has no analogue because the analogue is illegal. Muay Thai supplies the *weapon* (knee) but not the *costing name*.

---

## 4. SHIPPED GAMES — failed parry / counter is not free

**Question:** EA UFC, Undisputed, Tekken, VF, For Honor, Sifu — failed parry/counter: recovery frames, guard break, extra damage, nothing? What stopped interception being the only thing players do? Prefer developer interview / GDC over wiki.

Real combat ≠ game design. Frame data below is **game design**.

### 4.1 One-line table

| Title | What the intercept *is* | Cost of a miss | What stopped it being the only button | Grade on the cost |
| --- | --- | --- | --- | --- |
| **EA Sports UFC 3–6** | Intercepting strike = a strike thrown into the opponent's strike. "Active strike vulnerability" while you throw. | **Extra damage** if you are hit during your own strike; **leaning into** a punch does more damage than covering / leaning away | Vulnerability is the system; big swings are the highest-vulnerability window; official tutorials tell you not to throw them cold | **DOCUMENTED** (Hayes interviews; official UFC 5/6 tutorials) |
| **Undisputed** | **No parry.** Slips, weaves, pulls, high/low block. Successful *counters* deal extra damage (Counter Punch Modifier stat). | **NOT FOUND** as an official "failed slip = extra damage" rule. Slips cost stamina (early-access guides). Community video (2024-07-30) argues the game **lacks a vulnerability system** | Stamina on slips; guard wear; counter *bonus* is on success, not a miss penalty | **DOCUMENTED** (no parry: Forbes 2024-11-15); **NOT FOUND** (miss-cost) |
| **Tekken 7/8** | Character-specific parries / reversals / sabaki; Power Crush is armour, not a parry | **Whiff-punishable recovery.** Jin parry (T7 test): parries f.2–8, auto-block f.1 and ~f.9–20, **hit f.21–30**, can block again ~f.31. T8: throw vs parry is **unbreakable** | Parries are move-specific, not universal; throws beat them; armour loses to lows | **DOCUMENTED** (Wavu: "Most parries are heavily whiff punishable"); Jin frames = **UNVERIFIED_SECONDARY** (r/Tekken 2018 test, seconded in-thread) |
| **Virtua Fighter** | Reversal / sabaki / inashi — class- and level-specific | **Whiffed reversal animation**; hittable as **minor counter (mC)**; VF4 Evolution FAQ: mC = "+25% of base damage" on recovery / whiffed throw-or-reversal | Reversals lose to the wrong class (two-limb moves often cannot be reversed); catch throws / normal throws beat the attempt | **DOCUMENTED** (VFDC; GameFAQs VF3TB / VF4 Evolution FAQs) |
| **For Honor** | Parry = **heavy attack** timed 300–100 ms before impact | **The heavy comes out.** Feint-bait: opponent lets you swing, then punishes. Official 2017 test: **"Parrying too early consistently opens up your defense"** | Reward was *too high* (guaranteed guard-break); live team **removed guaranteed GB** and made early parry punishable so attacking would not die | **DOCUMENTED** (Ubisoft public-test notes 2017-07-25; GameSpot interview Campos-Oriola / Kieken 2017-07-28) |
| **Sifu** | Tap-guard at impact = parry/deflect; hold-guard = block | **Missed timing → block or get hit.** Block **fills your Structure**; Structure break = **stun**, open to a finisher. You did not get the stun *you* wanted | Structure on block; some attacks are unparriable (glow / throws); dodge and avoid exist so parry is not the only defence | **DOCUMENTED** (PlayStation Blog 2021-11-18; Unreal Engine interview with Sloclap) |

### 4.2 EA Sports UFC — vulnerability, named by the creative director

**DOCUMENTED (Brian Hayes, Creative Director, VG247, 2020-08-04):**

> "Vulnerability, like, are you leaning into a punch? Are you leaning away from a punch? All those things factor in to how much damage a punch does. If I lean away from a punch that is coming, it'll do less damage. If I lean into a punch, it'll do more damage. If I've just thrown a punch and I'm wide open, my vulnerability is very high. So, all those kinds of things factor in to how much your opponent's counter-strike, or well-timed intercepting strike, can do, for sure."

https://www.vg247.com/ufc-4-career-mode-interview

**DOCUMENTED (Hayes, UFC 3 interview, 2018-01-10):** head movement "could also work against you if you move your head into the path of a strike"; slipping into a roundhouse "can actually end up doing more damage… than just a regular strike"; "there's some real risk reward to how you use the defense"; players reported "agency in their own defeat" — they knew they "opened [themselves] up by throwing the big overhand" or "ducked down onto that uppercut." https://www.youtube.com/watch?v=y3-8yVuOYtM

**DOCUMENTED (official tutorials, still live 2026):**

- UFC 5 "Active Strike Vulnerability": "While throwing a strike, your own Strike Vulnerability increases; in other words, you take more damage if you are hit while attempting to throw your own strike." https://www.ea.com/games/ufc/ufc-5/game-objects/tips-and-tricks-hub/game-object/active-strike-vulnerability
- UFC 5 "Defensive Strike Vulnerability": "Moving your head into an opponent's strike (such as ducking into an Uppercut or swaying into a Roundhouse Kick) increases your damage taken." https://www.ea.com/games/ufc/ufc-5/tips-and-tricks-hub/strike-vulnerability-defense
- UFC 6 "How to Manage Active Strike Vulnerability" (2026-09-10): "Whenever you throw a strike, you enter Active Strike Vulnerability. Opponents who land a clean shot during this window deal increased damage." High-vulnerability examples named: spinning kicks, overhands. https://www.ea.com/games/ufc/ufc-6/ufc-6-tips-and-tricks-hub/ufc-6-how-to-manage-active-strike-vulnerability
- UFC 6 "How Attack Vulnerability Works" (2026-09-08): "Every offensive move creates an Attack Vulnerability window. The period during and immediately after throwing a strike where you take more damage." https://www.ea.com/games/ufc/ufc-6/ufc-6-tips-and-tricks-hub/ufc-6-how-attack-vulnerability-works

**INFERENCE:** EA UFC is the closest shipped analogue to the catalogue's intercept roll. The intercept is just a strike. The *cost of throwing it* is built into damage, not into a separate "failed parry" state. A free intercept roll with no vulnerability would be the system Hayes spent three games saying he was *not* building.

GDC 2015 (Harrower / Dowsett, Animation Bootcamp on UFC) is about animation pipeline, not intercept costing. Not used as a costing source. https://www.gamedeveloper.com/production/video-watch-a-blow-by-blow-account-of-animating-ea-s-ufc-games

### 4.3 For Honor — the live team said the quiet part

**DOCUMENTED (Ubisoft, "Public Test – Meta Changes", 2017-07-25):**

> "Parry is one of the best defensive options in the game with the guaranteed Guard Break which itself can guarantee heavy damage… Because Parry reward is so high, Players are encouraged to bait attacks and punish instead of choosing to initiate with an attack of their own."

Changes listed:

- Light-parry frame advantage reduced to match heavy parry
- **Guard Break is no longer guaranteed**
- **"Parrying too early consistently opens up your defense"**
- "In the Technical Test version, Parrying too early will always open you up to be punished."

https://www.ubisoft.com/en-au/game/for-honor/news-updates/1IZoiczWorTTTsrEYprgzR/public-test-meta-changes

**DOCUMENTED (Roman Campos-Oriola, Creative Director, GameSpot, 2017-07-28):** at the top 5–10% "the reward of parrying is a little bit too much"; "the whole mind game is around trying to bait your opponent into attacking, to parry him" — which he *likes* — "It is just that the reward for parrying is overshadowing all of the other actions"; they removed guaranteed GB "because that would be a massive frame-rate advantage." Goal: "make defending slightly less good." https://www.gamespot.com/articles/how-ubisoft-plans-to-fix-for-honor/1100-6452032/

**DOCUMENTED (how a miss is implemented):** parry is a **heavy input**. If the opponent feints, or you are early/late, **you throw a heavy** and sit in its startup (community / guide restatement of the same input: Prima Games; launch tutorial video). That is the recovery cost. It is not "nothing."

**INFERENCE:** For Honor is the best *designer-in-their-own-words* answer to "what stopped interception being the only thing players do?": **they shipped it too strong, watched the turtle meta, and paid a cost on the miss (early parry opens you) plus a cut to the reward (no free GB).**

GDC 2018 (Kieken / Campos-Oriola, post-launch) discusses live ops, not parry frames. GDC 2017 (Le Chevalier, modifiers system) is infrastructure. Not costing sources.

### 4.4 Tekken — parry is a move with a whiff

**DOCUMENTED (Wavu Wiki, Tekken community frame wiki, fetched 2026-09-13):** "Most parries are heavily whiff punishable." Throws cannot be parried; in Tekken 8 a throw used *against* a parry becomes unbreakable. Parries are typed (highs/mids, right punches only, etc.). https://wavu.wiki/t/Parry

**UNVERIFIED_SECONDARY (player lab, Jin T7):** r/Tekken, 2018-08-24, "Results from testing the frames on Jin's parry" — OP: parries f.2–8; second commenter: "blocks frame 1, parries frame 2-8, blocks frames 9-20, gets hit frames 21-30. Can block again at 31f." Not a Bandai Namco post. Do not treat as official frame data. Directionally consistent with Wavu's "heavily whiff punishable."

Power Crush is **armour**, not a parry: you *take* the hit (converted to recoverable health in T8) and your attack continues. That is a different costing model (you paid in HP to keep the turn). Wiki: https://tekken.fandom.com/wiki/Power_Crush — **UNVERIFIED_SECONDARY**; used only to keep armour distinct from parry.

**NOT FOUND:** a Harada / Nakatsu interview fetched today that states a miss-parry frame number. Harada interviews found in this pass were about visual deception / Season 2 backlash, not parry recovery.

### 4.5 Virtua Fighter — failed reversal is a whiffed throw-class animation

**DOCUMENTED (VFDC wiki, "Attacks"):** a reversal "when successful will stop an incoming attack and automatically hit back"; reversals are specific to **attack class and level**. https://virtuafighter.com/wiki/attacks/

**DOCUMENTED (VF3TB General Guide, VFDC):** "executing a reversal without your opponent executing an appropriate attack will result in whiffed reversals animation (just like in case of throws, although the recovery time is quicker)." https://virtuafighter.com/wiki/vf3tb-general-guide-and-movelist/

**DOCUMENTED (GameFAQs, GLC, VF4 Evolution FAQ, 2003-02-19):** minor counter (mC) = "hitting an opponent while he's in the recovery phase of a move or inside **whiffed throw/reversal animation**"; damage "increases with counter hits: +50% … on MC, and **+25% of base damage** … on mC." https://gamefaqs.gamespot.com/arcade/583505-virtua-fighter-4-evolution/faqs/21182

**DOCUMENTED (same FAQ family, VF3TB):** example reversal listings with recovery on miss, e.g. high punch reversal `1-10-30` (execution-active-recovery style notation in that FAQ). That is character-move data, not a universal "failed parry = N frames."

**NOT FOUND:** a Yu Suzuki / Sega AM2 interview fetched today that states the design intent of reversal miss-cost in those words. The costing is in the system docs, not a GDC quote.

### 4.6 Sifu — miss the tap and you paid in Structure

**DOCUMENTED (Sloclap, PlayStation Blog, 2021-11-18, Félix / Sloclap):** Structure gauge "emulate[s] the real combat notion of impacting and breaking the stance"; if *your* Structure fills, "you're unable to fight and defend yourself for a short duration." "Blocking attacks will quickly fill your balance gauge." "Parrying hits at the right time will let you deflect the blow, unbalancing your opponent." Avoids exist for "strong hits that you can't parry." https://blog.playstation.com/2021/11/18/how-sifus-kung-fu-combat-works

**DOCUMENTED (Unreal Engine interview, Pierre Tarno / Jérémy Garczynski, 2022):** same Structure system; "Blocking attacks will quickly fill your balance gauge"; defensive options designed as a *set* (dodge, deflect, avoid) so the player can manage flow — parry is not the only defence. https://www.unrealengine.com/developer-interviews/old-boy-john-wick-sifu-the-design-of-a-pak-mei-master

**INFERENCE:** a failed Sifu parry is usually a **block** (if you held/tapped off-time but still had guard up) or a **hit** (if you were in the tap recovery / wrong layer). The block is not free: it fills Structure toward a stun. That is a "guard break" costing model, not a recovery-frame model.

**NOT FOUND:** an official Sloclap frame table for "missed parry recovery." Player guides (EIP, Outsider Gaming, TechRaptor, 2022) agree on tap-at-impact vs hold-to-block; they do not publish a miss-recovery frame count.

### 4.7 Undisputed — no parry, and no published miss-vulnerability

**DOCUMENTED (Brian Mazique, Forbes, 2024-11-15, post-patch play):** "The block is more effective than before, but **the game still lacks a parrying mechanic.**" "Making a combat sports game with balance and skill gap is tough without adding something that functions as a parry." https://www.forbes.com/sites/brianmazique/2024/11/15/undisputed-drops-surprising-update-and-it-has-improved-gameplay/

**DOCUMENTED (official fighter-stats page):** **Counter Punch Modifier** — "Impacts how much additional damage is dealt by a punch if it's a counter punch." That is a *success* bonus, not a miss penalty. https://playundisputed.com/news/fighter-stats-explained

**DOCUMENTED (Ash Habib, PC Gamer GDC 2023):** the game has "slips, rolls, pulls, pivots, low blocks, high blocks" and a check-hook as a *punch thrown while pivoting* — i.e. the check hook is an **attack with footwork**, not a parry state. https://www.pcgamer.com/undisputed-boxing-game-interview-GDC/

**NOT FOUND (official):** failed slip / failed weave = extra incoming damage. Early-access guides (Gamer Digest 2023) say slips **cost stamina** and are hard to time; that is a resource cost on the *attempt*, not a damage multiplier on the miss.

**UNVERIFIED_SECONDARY:** YouTube "Undisputed Boxing Damage Just Got Better" (2024-07-30) argues Undisputed "does not have a vulnerability system" and that without one, intercepts cannot be costed the EA UFC way. Not a developer quote.

**INFERENCE:** Undisputed is the cautionary SKU. Without a parry *and* without a published vulnerability-on-whiff, community complaints cluster on "power-punch spam" and "slipping doesn't save you." That is what a low-cost intercept environment looks like from the other side: **offence becomes the only thing players do**, which is the same failure mode For Honor named, reached by the opposite door.

### 4.8 Design analogue (not on the requested list, but it is the GDC-grade quote)

The brief asked for GDC / developer interview. The clearest sentence in the whole genre on **"failed parry must not be free"** is **Street Fighter III**, Tomoshi Sadamoto (Capcom Fighters Network column, 2017; EventHubs 2017-10-30):

The original parry input was **back** (same as block). The team rejected it:

> "'That's way too easy!' they said. Do it quickly and you get the parry, drag it out and you get a block. **There was no risk involved.**"

Forward parry means a mistime is **not** a block — you eat the hit. Sadamoto wanted the safety net for beginners; "there was fierce opposition to that." https://www.eventhubs.com/news/2017/oct/30/street-fighter-3s-parry-input-was-originally-going-be-backwards-input-according-mr-sadamoto-creator-system/  
Primary JP: https://game.capcom.com/cfn/sfv/column/132042

Yoshinori Ono later said he would have made 3rd Strike parries *less* mandatory (EventHubs 2019-10-26) — the opposite problem: once the tool is strong *and* necessary, it becomes "the only thing." That is the For Honor turtle-meta in 2D.

**Grade:** **DOCUMENTED** as a designer quote. **Not** a requested SKU. Included because it is the interview the brief's "prefer GDC / dev talk" clause was hunting for.

### 4.9 What actually stops "only intercept"

Across the requested SKUs, five costing levers show up. None of them is "the roll fails and nothing happens."

| Lever | Who uses it | Combat analogue |
| --- | --- | --- |
| **The attempt *is* an attack** (startup + recovery) | For Honor (heavy), Tekken (parry move), VF (reversal animation), UFC (the intercept *is* a strike) | You threw the knee / hook; you are in the animation |
| **Extra damage if hit during the attempt** | EA UFC vulnerability; VF mC +25%; Tekken counter-hit on the whiff | Forward weight + open guard |
| **Resource / stance break** | Sifu Structure on blocked (failed-parry-as-block); For Honor stamina; Undisputed slip stamina | You spent the defensive layer |
| **A tool that beats the attempt** | Tekken/VF throw vs parry; For Honor feint; fencing counter-time | Second intention |
| **Live nerf when reward dominates** | For Honor 2017: cut guaranteed GB; "parrying too early opens you" | FIE already did this in 1910s conventions |

**INFERENCE for the catalogue:** a failed `stop_hit` / `intercept` roll should spend at least one of those levers. Zero-cost failure makes the tag strictly dominant over sprawl, cover, and parry — the For Honor turtle, the Sadamoto "no risk," and the missed-knee-in-the-shot all at once.

---

## 5. What this means for `stop_hit` (10) and `intercept` (2)

The brief: every tag is currently a **benefit**. Failed roll costs nothing. Built for takedown counters.

Research desk, not engine design:

1. **Do not ship a free miss.** Real combat and every requested SKU that has an intercept attach a cost. The only requested SKU with a weak miss-cost (Undisputed) is also the one whose community says offence became the meta.

2. **Takedown-counter miss ≠ striking-counter miss, but both are "you spent the layer."**
   - Takedown: you spent **hips**. Cost in combat is positional (shot completes easier than vs sprawl). **No published %.**
   - Striking: you spent **guard + the ability to roll**. Cost in combat is a cleaner, higher-relative-velocity shot. **No published %.**

3. **Fencing already solved the wording.** Benefit: stop-hit. Miss on a committed attack: *not in time* → the original attack lands as if you never defended (foil t.89.4.a). Opponent who has your number: *counter-time*. Épée double = both-hurt, which is the MMA "you kneed him and he still dumped you" ending.

4. **Do not invent the missing rates.** If the engine needs a modifier on TD success after a missed knee, that is a **design choice**, not a citation. Mark it as such. The mechanical direction of the modifier (easier TD than vs sprawl) is **INFERENCE**; the size is **NOT FOUND**.

5. **Check-hook / intercepting-cross miss is not "you whiffed a jab."** It is simultaneous-counter failure: open hand, rotating trunk, no roll. Cost it closer to "hit while punching" (UFC vulnerability) than to "hit while blocking."

---

## 6. Searches that returned nothing (do not fill the hole)

If a later desk finds one of these, it would change the memo. Until then, the hole is the finding.

| Asked for | Result | Searches |
| --- | --- | --- |
| TD completion % vs defender who attempted a knee/uppercut vs defender who sprawled | **NOT FOUND** | listed in §1.1 |
| Numeric damage ratio, mistimed check hook vs covering | **NOT FOUND** | listed in §2.1 |
| FightMetric / UFC Stats technique-coded TDD (sprawl vs strike-counter) | **NOT FOUND** — UFC Stats logs attempt/land, not defender technique | `site:ufcstats.com` + technique terms |
| Named wrestling term for "I strike instead of sprawl" | **NOT FOUND** (illegal in wrestling) | Gable / USA Wrestling / sprawl manuals |
| Thai-manual name for "knee the shot" as a costed gamble | **NOT FOUND** | kru / khao trong / intercepting knee |
| Official Undisputed "failed slip = extra damage" | **NOT FOUND** | SCI / Habib interviews, official stats page |
| Official Sifu missed-parry frame table | **NOT FOUND** | Sloclap / PS Blog / UE interview |
| Harada quote on parry-miss frames | **NOT FOUND** this pass | Harada / TEKKEN interviews 2025–26 |
| Yu Suzuki quote on reversal-miss cost | **NOT FOUND** this pass | VF system docs used instead |
| GDC talk that *is* the costing talk for UFC intercepts | **NOT FOUND** — GDC 2015 is animation; costing is in Hayes interviews + official tutorials | GDC UFC animation; Hayes VG247 / UFC 3 |

---

## 7. Source list (live 2026-09-13)

### Real combat — rules and papers

- FIE Technical Rules, Dec 2025: https://static.fie.org/uploads/40/203315-technical%20rules%20ang.pdf
- FIE Technical Rules, Dec 2024 reprint: https://www.fechten.org/fileadmin/user_upload/Technical_Rules_Englisch_Dec_2024.pdf
- Ma, Li, Zhu et al., "Temporal trends and weight-class differences in takedown density… 8,461 UFC bouts, 1997–2025," *BMC Sports Sci Med Rehabil* (2026-06-18): https://link.springer.com/article/10.1186/s13102-026-01804-8
- Chen et al., small-weight MMA technical-tactical paper, Cambridge Publish PDF: https://www.cambridgepublish.com/css/article/download/243/250
- Cheraghi et al., "Kinematics of Straight Right Punch in Boxing" (2014): https://www.researchgate.net/publication/281098708_Kinematics_of_Straight_Right_Punch_in_Boxing
- UFC Stats: http://ufcstats.com/

### Real combat — named coaching / manuals

- Aldo Nadi, *On Fencing* / *Nadi on Fencing* (Dover contents): https://store.doverpublications.com/products/9780486443751
- Italian school counter-offence (fencing.net, 2007): https://fencing.net/archives/counter-offensive-actions-in-italian-fencing/
- Barth & Beck, *The Complete Guide to Fencing* (stop-hit snippet): https://vdoc.pub/documents/the-complete-guide-to-fencing-69utf8u8sbv0
- DS Fencing, stop-hit & counter-time (2026-04-29): https://dsfencingclub.com/blog/counter-time-stop-hit-fencing/
- Amberger, *Encyclopedic Dictionary* (counter-time): https://ambergers-fencing-dictionary.com/english-reference-dictionary/
- Dan Gable, *Coaching Wrestling Successfully* (Human Kinetics, 1999/2009) — cited as the named sprawl-drill text; full text paywalled
- Martial Arts Stack Exchange, sprawl vs knee (2021-05-01): https://martialarts.stackexchange.com/questions/10490/is-a-sprawl-or-knee-generally-more-effective-against-takedowns
- Grapplearts, sprawl then knee (2012): https://www.grapplearts.com/sprawl-counter-vs-double-leg-tackle/
- Jack Dempsey, *Championship Fighting* (1950), archive.org record: https://archive.org/details/jack-dempseys-championship-fighting-explosive-punching-and-aggressive-defense-jack-dempsey-z-library
- Honour & Glory, counter-punching basics (2025): https://www.honourandglory.co.uk/blog/counter-punching-basics
- Teddy Atlas, inside counters: https://dynamicstriking.com/blogs/news/how-to-time-your-counter-punches-on-the-inside-with-teddy-atlas
- Freddie Roach, blocking counters: https://www.youtube.com/watch?v=YJIxOai5MOo
- Freddie Roach / Eddie Futch roll-with: https://www.youtube.com/watch?v=wOX3UHc_Pd0
- BoxRec, check hook: https://boxrec.com/wiki/index.php/Check_hook
- Coach Joe, check-hook: https://boxingatthedepot.com/coach-joes-boxing-technique-the-check-hook/
- FightFlow, three categories of counters (2026): https://fightflow.app/blog/boxing-counter-punching
- muaythai.com, knee types (2024): https://muaythai.com/muay-thai-knees-explained/
- *Kneeing the Takedown* video essay (2025): https://www.youtube.com/watch?v=u8WEZSt_g_o
- Jon Fitch, commit-to-strike (2025): https://www.youtube.com/watch?v=yKw57Hl1H0s

### Game design — official / named developers

- Brian Hayes, UFC 4, VG247 (2020-08-04): https://www.vg247.com/ufc-4-career-mode-interview
- Brian Hayes, UFC 3 interview (2018-01-10): https://www.youtube.com/watch?v=y3-8yVuOYtM
- EA UFC 5 Active Strike Vulnerability: https://www.ea.com/games/ufc/ufc-5/game-objects/tips-and-tricks-hub/game-object/active-strike-vulnerability
- EA UFC 5 Defensive Strike Vulnerability: https://www.ea.com/games/ufc/ufc-5/tips-and-tricks-hub/strike-vulnerability-defense
- EA UFC 6 Active Strike Vulnerability (2026-09-10): https://www.ea.com/games/ufc/ufc-6/ufc-6-tips-and-tricks-hub/ufc-6-how-to-manage-active-strike-vulnerability
- EA UFC 6 Attack Vulnerability (2026-09-08): https://www.ea.com/games/ufc/ufc-6/ufc-6-tips-and-tricks-hub/ufc-6-how-attack-vulnerability-works
- Ubisoft For Honor public test (2017-07-25): https://www.ubisoft.com/en-au/game/for-honor/news-updates/1IZoiczWorTTTsrEYprgzR/public-test-meta-changes
- Campos-Oriola / Kieken, GameSpot (2017-07-28): https://www.gamespot.com/articles/how-ubisoft-plans-to-fix-for-honor/1100-6452032/
- Sloclap, PlayStation Blog (2021-11-18): https://blog.playstation.com/2021/11/18/how-sifus-kung-fu-combat-works
- Sloclap, Unreal Engine interview (2022): https://www.unrealengine.com/developer-interviews/old-boy-john-wick-sifu-the-design-of-a-pak-mei-master
- Undisputed official stats: https://playundisputed.com/news/fighter-stats-explained
- Ash Habib, PC Gamer GDC (2023-04-12): https://www.pcgamer.com/undisputed-boxing-game-interview-GDC/
- Mazique, Forbes, Undisputed "lacks a parrying mechanic" (2024-11-15): https://www.forbes.com/sites/brianmazique/2024/11/15/undisputed-drops-surprising-update-and-it-has-improved-gameplay/
- VFDC attacks / reversals: https://virtuafighter.com/wiki/attacks/
- VF3TB guide (whiffed reversal): https://virtuafighter.com/wiki/vf3tb-general-guide-and-movelist/
- GLC, VF4 Evolution FAQ (mC +25%): https://gamefaqs.gamespot.com/arcade/583505-virtua-fighter-4-evolution/faqs/21182
- Wavu, Tekken parry: https://wavu.wiki/t/Parry
- Sadamoto, SFIII parry input (EventHubs 2017-10-30): https://www.eventhubs.com/news/2017/oct/30/street-fighter-3s-parry-input-was-originally-going-be-backwards-input-according-mr-sadamoto-creator-system/
- Sadamoto, CFN primary: https://game.capcom.com/cfn/sfv/column/132042

---

**End of J24.** No engine change is implied. The missing rates stay missing.
