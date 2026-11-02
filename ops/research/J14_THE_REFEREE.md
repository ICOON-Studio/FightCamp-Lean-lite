# J14 — THE REFEREE (who is not in our model at all)

**Desk:** John (research). **Assigned:** 2026-09-10. **Verification date for every live URL:** 2026-09-10.  
**Status:** study only. No GDScript. No enum. No referee state machine.  
**Scope:** professional boxing and professional MMA. Amateur cited only where it is the place a discarded professional device still lives.

**Grade legend (used on every claim):**

| Grade | Meaning |
| --- | --- |
| **DIRECT** | Quoted or paraphrased from a primary rule, statute, or official mechanics manual fetched 2026-09-10. |
| **INHERITED** | Follows from a DIRECT text without adding a new rule (e.g. “no standing eight” + “count only after a knockdown” ⇒ a standing fighter is not counted). |
| **UNVERIFIED_SECONDARY** | Journalism, Wikipedia, aggregator, or a handbook that restates rules without being the promulgating text. Not used as current law. |
| **UNKNOWN** | Not found, conflicting, not in force yet, or true only if a night’s rules meeting says so. |

An invented rule that looks sourced is worse than an admitted gap. Gaps are listed in § UNKNOWN.

---

## Decisions page

These are research-desk decisions about **what the sources say**, not engine design.

| ID | Decision |
| --- | --- |
| **R1** | Default **professional boxing** in-ring baseline for this memo is the Association of Boxing Commissions **Unified Rules of Boxing**, approved 25 August 2001, last amended **3 August 2016**. That is still the current ABC boxing unified document as of 2026-09-10. Mechanics (how a referee actually counts, breaks, warns, waves off) are taken from the ABC **Boxing Referee Manual, Rev. 08/2025**, which is official ABC guidance, not a statute. |
| **R2** | Default **professional MMA** in-ring baseline is the ABC **Unified Rules of Mixed Martial Arts** PDF hosted August 2026. Black (already-implemented) text is treated as current. Language the PDF itself marks as approved **5 August 2026** with **requested implementation November 2027** (blue double-underline: expanded bodily-function / vomit / bucket procedures) is **not** treated as in-force today. |
| **R3** | Local commission always can override ABC and a sanctioning body. Differences are **named**. This memo does **not** build a jurisdiction table. |
| **R4** | **Standing eight-count is not current** under ABC Unified Boxing (Rule 7, 2016), WBC championship synthesized rules (2016 text still circulated as the championship checklist), WBO Regulations §25 (Jan 2024), Ontario professional boxing rules (updated 22 May 2025), or Wisconsin SPS 192.79 for professionals. It **does** survive in amateur texts (USA Boxing National Rulebook rev. 1 January 2026; World Boxing Competition Rules, Nov 2024). Do not smuggle it into a professional sim as “the count.” |
| **R5** | **Three-knockdown automatic stop is not current ABC Unified Boxing** (Rule 8, 2016). It **is** current in **WBA Contest Rule 12** (rules amended 22 April 2024, PDF hosted June 2026): “Three (3) knockdowns in the same round constitute an automatic knockout.” Ontario **shall** stop a non-championship bout on three knockdowns in a round and **may** continue a championship bout. JBC domestic “free knockdown” from **2016** is reported by JBC’s own Wikipedia page and Japanese boxing Wikipedia; the JBC rulebook PDF was **not** fetched, so that year is **UNVERIFIED_SECONDARY** pending JBC text. BoxingInsider’s 15-state roster is **refused** as current law. |
| **R6** | IBF *Rules Governing Championship Contests* (amendments through 30 April 2025, posted 13 August 2025) are administrative (weight, mandatories, purse bids). They do **not** contain a knockdown/count code. In-ring IBF title fights inherit the local commission / ABC unified set unless that night’s rules meeting says otherwise. **UNKNOWN** whether IBF publishes a separate in-ring knockdown code; none was in the championship-contest PDF. |
| **R7** | Professional MMA has **no ten-count, no mandatory eight, no standing eight**. Nevada NAC 467.740(9) states the boxing count section “do[es] not apply” to MMA. ABC MMA stoppage language is **intelligent defense**, not a count. |
| **R8** | “Protect yourself at all times” is a **pre-bout command** (ABC Referee Manual; BBBofC 3.28). It is **not** a license to hit a downed opponent. Hitting a downed / rising boxer is a listed foul. |
| **R9** | Most of §1 is **frame and card scenery**. Engine-worthy facts, if any, are: boxing knockdown pause + official count; announced point deduction; stoppage reason (already in the model). Not a referee object. |
| **R10** | WBA Rule 12 (3KD = automatic KO) can collide with ABC Rule 8 (no 3KD) on a WBA title in an ABC jurisdiction. **Which text is read in the dressing room that night is UNKNOWN.** Do not invent a supremacy hierarchy. |

---

## Do-not-build list

Do **not** build any of the following. This is a research memo, not a spec.

1. A referee state machine, enum, class, or GDScript object.
2. A “current standing eight” as professional-default.
3. A “three knockdowns = TKO” as professional-default.
4. A jurisdiction table of commissions.
5. A simulated “Referee Gait Test,” verbal Q&A, or concussion-sign classifier as if the engine had a doctor’s eyes.
6. Instant-replay / red-card / green-card UI as rules engine.
7. Towel-throw as a US professional boxing stoppage (ABC Referee Manual: throwing the towel cannot stop a US pro boxing match; the chief second notifies the inspector).
8. MMA ten-count.
9. “Saved by the bell in the last round only.”
10. “Rise at seven and you automatically continue.”
11. “The count is ten wall-clock seconds from canvas contact.”
12. “Protect yourself at all times” as a rule that legalizes punching a downed fighter.
13. BoxingInsider’s state-by-state 3KD list, copied as fact.
14. August 2026 MMA bodily-function language as if it were already in force (requested implementation November 2027).

---

## §1 — What a referee DOES, moment to moment

Observable acts a camera can see. Governing text named. **Simulation fact needed** = the datum an engine would have to possess **if** it were ever asked to emit the act. That column is a research question, not a design.

### 1.1 Sole arbiter (both sports)

| Act | Boxing | MMA | Grade | Simulation fact needed |
| --- | --- | --- | --- | --- |
| Occupy the ring/cage as the only in-bout stoppage authority | ABC Unified Boxing Rule 2: “The referee is the sole arbiter of a bout and is the only individual authorized to stop a contest.” Video/review of a decision is a protest procedure after the fact, not a live override. | ABC Unified MMA Rule 2: same sole-arbiter sentence. Authority begins when inspectors exit the cage/ring and ends when they re-enter. Instant replay (Rule 3) may review a **fight-ending sequence only after the fight has been officially stopped**; the fight shall not be resumed. | DIRECT | Bout-live flag; who is inside the cage/ring; whether a stoppage has already been declared. Not a “ref AI.” |
| Doctor recommends; referee decides (championship boxing, WBC) | WBC championship synthesized rules §3: ring doctor may recommend stoppage by handing a **red card** to the referee; referee makes the final decision. | ABC MMA: referee sole arbiter. Ringside physician examines on referee request. Some commissions write the physician as also authorized to stop (Ontario boxing §5: referee **and** ringside practitioner). | DIRECT (WBC red card; ABC sole arbiter). Commission split is named, not tabulated. | A doctor-recommendation bit the engine does not have. |
| Consult physician without surrendering the bout | ABC Referee Manual: referee can stop at any time if a boxer is in physical danger or the contest is too one-sided; “always feel free to consult with the ring-side physician.” If the physician says stop, “the bout shall be STOPPED.” Nevada NAC 467.713: referee determines whether to stop for injury and **may** consult a ringside physician. | Unified MMA Time Consideration D.2: up to five minutes, at referee discretion, for physician evaluation after a foul. D.3: **“At no time may a referee call a timeout to evaluate the impact of a legal strike, other than when a laceration is present.”** | DIRECT | Injury type (foul vs legal strike vs laceration). The last sentence is the hard MMA constraint. |

### 1.2 The count (boxing). MMA: there is no count.

Covered at article level in §3. Summary of the **acts**:

| Act | Governing rule | Where it does **not** exist | Grade | Simulation fact needed |
| --- | --- | --- | --- | --- |
| Call “Down!”, point to canvas | ABC Referee Manual, Knockdowns. Ontario boxing §14.6. | MMA (no knockdown-count procedure). NAC 467.740(9): boxing count “do[es] not apply” to MMA. | DIRECT | Legal-blow knockdown vs slip vs voluntary knee. Engine knockdown flag is not this determination. |
| Send standing boxer to farthest **neutral** corner | ABC Referee Manual; WBA Rule 11; WBO §25(a); NAC 467.740(1). | MMA. | DIRECT | Who is standing; which corner is farthest-neutral. Frame geometry, not fight math. |
| Pick up the **timekeeper’s** one-second cadence; referee’s count is official | NAC 467.740(2); ABC Referee Manual; Ontario §14.2–14.8. | MMA. | DIRECT | A one-second official-count clock that is **not** wall-clock from canvas (count pauses if the standing boxer leaves the corner). |
| **Mandatory eight** after a knockdown | ABC Unified Boxing Rule 5. WBA Rule 11 last sentence. WBO §25(b). NAC 467.740(2): may not resume until referee has finished counting to eight. May take the count on the floor **or standing**. | **No standing eight** (ABC Rule 7). MMA: no eight at all. | DIRECT | Knockdown occurred; count ≥ 8 before “box.” Rising at 2 does not skip 8. |
| Continue to **ten**; wave both arms if still down | ABC Referee Manual; WBA Rule 11; WBO §25(d); NAC 467.740(4). Referee **may** abort the full 10 if safety would be jeopardized by completing it (NAC 467.740(4); ABC Referee Manual: twitching/closed eyes → stop the count and end). | MMA KO is unconsciousness / cannot intelligently defend, not a 10-count. NAC 467.79615. | DIRECT | Still-down at 10, **or** referee judgment that the boxer cannot intelligently defend before 10. The second is not in engine data. |
| **Standing eight** (halt action and count a standing-but-hurt fighter) | **Forbidden** in ABC Unified Boxing Rule 7 (2016). WBC championship checklist 2016: “There is no standing eight (8) count.” Ontario §14.25. Wisconsin SPS 192.79(7)(b): amateur may; professional may not. ABC Referee Guidelines (2011): “There is NO Standing Eight (8) Count.” | Survives in **amateur**: USA Boxing 19.1(4) and 19.2 (rev. 1 Jan 2026); World Boxing 8.6.1 (Nov 2024). | DIRECT for the prohibition. DIRECT for amateur survival. The often-cited ABC abolition **year 1998** is Wikipedia / BoxingInsider — **UNVERIFIED_SECONDARY**. Current professional status does not depend on that year. | Do not emit. |
| **Three-knockdown automatic stop** | **Forbidden as a rule of automatic stop** in ABC Unified Boxing Rule 8 (2016). ABC Referee Manual: “While a 3-knockdown rule doesn't exist, boxers knocked down 3 times in a round should be closely observed.” WBC 2016 checklist: “There is no automatic TKO with three (3) knockdowns in one round.” WBO §25: no 3KD clause; WBO §26 adopts ABC Uniform Rules. | **Current where named:** WBA Rule 12 (Apr 2024): automatic KO. Ontario §14.23–14.24: shall-stop non-championship; may-continue championship. Amateur USA Boxing 19.6: max three eight-counts in a round / four in a bout (a different device). | DIRECT for ABC/WBC/WBO/Ontario/WBA. JBC 2016 free-knockdown: **UNVERIFIED_SECONDARY**. | Round-knockdown count **plus** which ruleset that night. Default ABC = do not auto-stop. |
| 20-second count out of the ring | ABC Unified Boxing Rule 9. ABC Referee Manual: out of ring onto floor/table → 20 seconds unassisted; **mandatory 18** if they return sooner (manual-only; not in the 13-point unified list). WBA Rule 13: apron 10 seconds, floor 20. NAC 467.757: over the edge 20 seconds (may be helped by anyone **except** seconds/manager); on the platform outside the ropes 10 seconds, unassisted. | MMA in a **ring**: ABC Unified MMA Rule 5: **five (5) minutes** to return, then physician exam, analogous to an accidental foul — not a 20-count. | DIRECT. The 18-count is **Referee Manual**, not Unified Rule 9. | Out-of-ring vs on-apron vs MMA-in-ring. These are different clocks. |
| No save by the bell, any round | ABC Unified Boxing Rule 10. WBO §25(e). WBA Rule 14. WBC checklist. Ontario §14.15. NAC 467.740(6)–(8). BBBofC 3.35 including the final round. | MMA: no count, so no “saved by the bell” doctrine. Round ends on the bell + referee’s call of time (Unified MMA Foul 24). | DIRECT | Down-flag at round-end. Boxing: count continues. |

### 1.3 Break and separation

| Act | Boxing | MMA | Grade | Simulation fact needed |
| --- | --- | --- | --- | --- |
| Verbal **STOP – BREAK – BOX** (and Spanish equivalents) | ABC Referee Manual: basic commands; when physically breaking, first word “Stop,” then “Break”; never walk through the boxers after a break; break at full arm’s length; step straight back. BBBofC 3.39: on “break” both take **one step back** before recommencing; “The parting of Boxers by force should be avoided if possible.” | Unified MMA heading **“Standing up or Breaking Fighters”**: stand up **or** break when **neither** fighter demonstrates “real, significant and/or sustained effort to advance towards finishing the fight by any method.” Maintaining a perceived superior position is **not** effort to finish and is **not** a guaranteed right to keep that position. | DIRECT | Boxing: clinch/hold vs infighting (a visual foul call). MMA: effort-to-finish vs stall-in-control. The game’s stall clock is a timer, not this qualitative test. |
| Do **not** always interrupt | ABC Referee Manual: “Not all rule violations require immediate interruptions of the action; some can be more efficiently handled at the conclusion of the round in the corner.” | Unified MMA Foul Procedures: if a foul **is** called, referee **shall** call time, check the fouled fighter, then assess. | DIRECT | Whether the infraction is being handled live or deferred. Engine does not see “soft warning.” |
| Hitting on the break / during timeout | Boxing foul (Ontario §8.14; NAC 467.675(16)). BBBofC 3.38(j). | Unified MMA Fouls 24–26: after the bell, on/during the break, or while opponent is under the referee’s care. | DIRECT | Action-clock vs timeout vs “under referee care.” |

### 1.4 Warning, point deduction, who is told

| Act | Boxing | MMA | Grade | Simulation fact needed |
| --- | --- | --- | --- | --- |
| Soft warning (hand signal) then hard warning (call time, talk) | ABC Referee Manual, Penalizing-Points: generally soft warnings, then a hard warning (call time, stop action, clearly talk to the offender). Next serious violation: deduct a point or multiple. Severity can skip the ladder. | Unified MMA Foul Procedures step 4: if the fight continues, assess for potential point(s) and/or time. Fence-grab: **may** issue a one-point deduction if the foul caused a substantial effect; if the fouling fighter gained superior position, **restart standing, neutral**. | DIRECT | Infraction history in the bout (warnings already given) **and** severity. Engine does not have “was that a rabbit punch.” |
| Announce the deduction to **boxers, judges, and Commission** | ABC Referee Manual: “Immediately inform judges and commission personnel of your actions.” Summary: “Point deduction: Stop the fight, clearly announce the point deduction to boxers, judges, and Commission.” Ontario §9.10: timeout; offending contestant advised; **each judge and the scorekeeper** notified of points and type of foul; then signal time in. Nevada NAC 467.688(2): as soon as practical after the foul, notify **a representative of the Commission, the judges, and both unarmed combatants**. BBBofC 3.38.2: indicate to the Boxer, their corner, and the Steward in Charge / Area Representative; raise fingers; call out the reason. | Same Unified MMA intentional-foul rule: notify the authorities and deduct two points when an intentional foul causes injury. | DIRECT | A public deduction event: who, how many points, which foul, which round. Judges’ cards already exist; the **announcement** is officiating scenery unless the deduction is the score event. |
| Mandatory **two-point** deduction | ABC Unified Boxing 12.A.2: intentional foul that causes an injury, bout continues → notify authorities, deduct **two (2) points**. “Point deductions for intentional fouls will be mandatory.” Same structure in Unified MMA Intentional Fouls A.2. | Same. | DIRECT | Intentional vs accidental **and** whether an injury was caused. Engine does not have intent. |
| Discretionary one/two for non-injuring fouls | ABC Referee Manual: intentional foul without injury → referee’s discretion to deduct a point or points. Ontario §9.2, §9.6. | Fence-grab: may deduct one if substantial effect. Timidity, fingers outstretched, etc.: referee communication first (Foul 9). | DIRECT | Same intent/effect problem. |

### 1.5 Time-out, doctor, glove, mouthpiece

| Act | Boxing | MMA | Grade | Simulation fact needed |
| --- | --- | --- | --- | --- |
| Mouthpiece: round cannot begin without it; replace at first opportune moment | ABC Unified Boxing Rule 6. Same sentence in Unified MMA Rule 4. Points **may** be deducted if purposely spit. | Same Rule 4. Timidity includes consistently dropping the mouthpiece (Foul 20). | DIRECT | Mouthpiece-in flag; whether dislodge was concurrent with a knockdown (ABC Referee Manual: treat knockdown first, replace before resume). |
| Lost second mouthpiece → TKO (boxing manual) | ABC Referee Manual, Mouthpiece Mechanics: all boxers should have two; if a mouthpiece is lost in the crowd and there is no second, “they lose by TKO.” | Not in Unified MMA text. | DIRECT for boxing manual. UNKNOWN for MMA. | Spare-mouthpiece inventory. Not in the live-game data list. |
| Glove wipe after a fall | NAC 467.735: before resuming after knockdown, fall, or slip, wipe gloves with damp towel or referee’s shirt. **Does not apply to MMA.** ABC Referee Manual: wipe fallen boxer’s gloves of debris after the 8-count, if continuing. Ontario §14.12. | Not applicable (NAC 467.735(2)). | DIRECT | Fall occurred. Pure scenery. |
| Loose tape | ABC Referee Manual: temporarily stop; remove loose tape; generally do not let the corner re-tape during a round. | Not in Unified MMA as a named mechanic. | DIRECT (boxing manual) | Tape-loose flag. Scenery. |
| Medical timeout; 5-minute cap | ABC Referee Manual, Medical Timeout: stop, signal timekeeper, require physician to enter. If examination exceeds **5 minutes**, the bout should be stopped. Physician may get **up to 30 additional seconds** on the intermission, on request. Recommended: give the corner its full minute, start the next round, immediately call time after the bell, send opponent to a neutral corner. | Unified MMA D.1–D.2: up to five minutes to recover from groin or eye poke, or for physician evaluation after a foul. D.3: **no** timeout to evaluate a **legal** strike except laceration. Eye-poke procedure C: cold compress/wet towel; fighter gives verbal yes/no that they can see; physician may evaluate at any time during the timeout. | DIRECT | Foul vs legal strike vs laceration; elapsed timeout; verbal “can you see.” Engine has trauma pips, not visual-field or speech. |
| Low blow: up to 5 minutes, then lose if unwilling | ABC Unified Boxing Rule 13: accidental low blow → continue after a reasonable time **but no more than five (5) minutes**, or lose the fight. ABC Referee Manual: if the referee has already signaled knockdown and begun the count, the boxer should know it was ruled legal. Nevada NAC 467.688(4): claiming a low blow and refusing to continue is a TKO for the willing fighter — **except MMA**. | Unified MMA D.1: groin or eye poke, if able to continue, **up to five minutes**. | DIRECT | Referee’s immediate legal-vs-foul call. Engine cannot reconstruct beltline vs cup. |
| Cuts | ABC Referee Manual, Cuts: generally consult physician; if physician says stop, stop. Prefer to give the corner the minute between rounds. “Most cuts within the orbit of the eye (eyelid) should be stopped.” Impaired vision / swollen shut / exam difficult → stop. | Unified MMA: laceration is a listed TKO reason (referee stoppage or medical stoppage). Cutperson **during a round** is allowed only after a foul-caused laceration, inside the 5-minute foul window (E.1) — that E.1 block is in the Aug 2026 PDF; treat as current unless marked 2027-blue. The vomit/bucket block **is** 2027-blue. | DIRECT | Cut location (orbit vs elsewhere) and vision, not merely a pip count. |
| Self-injury | ABC Unified Boxing 12.A.4; Referee Manual SELF-INJURY: four-round and five-minute rules **do not apply**. Unable to resume when ordered → TKO. | Unified MMA Intentional Fouls A.4: same idea. | DIRECT | Who caused the injury. |

### 1.6 Wave-off

| Act | What the referee is deciding | Grade | Simulation fact needed |
| --- | --- | --- | --- |
| Wave both arms **above the head** | Boxing: still down at 10, or in no condition to continue → KO (ABC Referee Manual; WBA Rule 11; WBO §25(d); Ontario §14.13). | DIRECT | Down at 10 **or** “no condition.” The second is judgment. |
| Wave both hands **at/below waist**, criss-cross, “No knockdown” / “Slip” | Not a legal knockdown (ABC Referee Manual, SLIPS; Ontario §14.5). | DIRECT | Slip vs knockdown. Engine knockdown flag is the output, not the input. |
| Step between, block the injured fighter | ABC Referee Manual, STOPPING THE BOUT: step in between, block further punches, protect the injured boxer. Stay until the doctor enters. | DIRECT | Stoppage already decided. Camera grammar. |
| MMA: stop because fighter **IS NOT** intelligently defending | Unified MMA Types of Decisions, TKO by Referee Stoppage. Subtypes: strikes, laceration, corner stoppage, did not answer the bell. | DIRECT | Intelligent-defense judgment. See §2 and §4. |
| MMA: stop because fighter **CANNOT** intelligently defend | Unified MMA KO by Referee Stoppage, due to strikes. Nevada NAC 467.79615: KO when rendered **unconscious** by a legal maneuver. The ABC text uses “CANNOT INTELLIGENTLY DEFEND”; Nevada uses unconsciousness. Do not collapse the two. | DIRECT (two texts, two wordings) | Unconsciousness vs “cannot defend.” Engine stoppage-reason enum already exists; the **live call** is not computable from pips. |
| Technical submission | Unified MMA: legal submission → unconsciousness or broken/dislocated bone/joint. | DIRECT | Tap, verbal tap/scream, or structural failure. |
| One-sided / serious-injury stop (boxing) | NAC 467.718(1): **may** stop if too one-sided or continuation might subject a combatant to serious injury. 467.718(2): **shall** stop if **both** are in that condition → technical draw. ABC Referee Manual: power to stop if too one-sided or no longer demonstrating ability to successfully defend. | DIRECT | “Too one-sided” is not a scorecard total. Per-round scores do not license this call. |
| Not honestly competing | NAC 467.723: may stop, disqualify, recommend purse hold. BBBofC 3.38(g) “not trying.” Unified MMA Foul 20, timidity. | DIRECT | Intent to avoid combat. Not stamina/HR. |

### 1.7 Deliberate non-intervention (letting a hurt fighter continue) — published guidance

This is the act the camera reads as “the referee is doing nothing.” Published text that licenses it:

| Guidance | Text | Grade |
| --- | --- | --- |
| After the mandatory 8, **verify then stay close** | ABC Referee Manual: after 8, gait test and “Are you OK? Do you want to continue?” “A general rule is if the referee has any doubt, stop the bout.” If satisfied, wipe gloves, **stay close and monitor** the hurt boxer. Watch the walk back at round’s end; check between rounds; recommended to have the doctor check. | DIRECT |
| Gait test contents | Direct the fighter to walk a few steps right or left, stop, turn, walk back. Assess balance and body control. | DIRECT (manual) |
| Shorten distance when stoppage may be imminent | ABC Referee Manual, MOVEMENT/DISTANCE, and ABC Ring Officials Certification Program: shorten distance when fighting on the ropes; fighting ability in doubt; infighting/holding; noise; ten seconds left. Certification page lists evaluation cues: neck-muscle weakening, inability to control basic movement, inability to focus, staggering gait, not listening, fatigue, inability to defend, getting hit with more damaging punches, so far behind that further injury outweighs chance of winning. | DIRECT |
| Concussion signs the referee is told to watch | ABC Referee Manual, GENERAL CONCUSSION SIGNS: headache/pressure, LOC, fog, amnesia, dizziness, tinnitus, double/blurred vision, nausea, vomiting, slurred speech, delayed answers, dazed, fatigue. Observe the walk to the corner; listen in the corner; converse to assess mental state. | DIRECT |
| Three knockdowns, no auto-stop | ABC Referee Manual: 3KD rule doesn’t exist; **observe closely**. That is explicit permission to continue after a third knockdown under ABC. | DIRECT |
| MMA: no timeout to “see if they’re hurt” from a legal shot | Unified MMA D.3: cannot call timeout to evaluate a legal strike except laceration. The legal way to protect a hurt standing/grounded MMA fighter is to **stop the contest** or to **let it continue**. There is no standing eight and no count. | DIRECT |
| MMA intelligent defense (commission training language) | Indiana Combat Sports regulations (fetched 2026-09-10) define “Intelligently Defend Himself” as the fighter’s inability to make a rational/safe decision to tap; open-eyed pride is not a defense against a stoppage. This is **one commission’s training text**, not ABC Unified. Grade **DIRECT** for Indiana; **not** ABC. | DIRECT (Indiana only) |
| WBC doctor red card | Doctor recommends; referee may still be the one who waves it off — or not. Non-intervention after a red card would be a refusal of the recommendation. The WBC text gives the referee the final decision. | DIRECT |

Non-intervention is therefore not “no rule.” It is a published discretion: ABC wants doubt resolved **toward stoppage**; ABC also forbids using a standing eight as a safety valve; MMA forbids a timeout-to-inspect a legal shot. The remaining choice is continue or end.

---

## §2 — Boxing vs MMA divergence

Concrete divergences. Commission differences named. **No jurisdiction table.**

### Count on the ground

- **Boxing:** a fighter who is down is **not** a legal target. Ontario §8.2; NAC 467.675(2); BBBofC 3.38(k). The count **is** the procedure. Down includes hanging on the ropes / ropes-only (ABC Referee Manual; NAC 467.760 — and 467.760(3) says that definition **does not apply to MMA**).
- **MMA:** a grounded opponent may be **punched**. Kneeing/kicking the **head** of a grounded opponent is a foul. Grounded, current ABC Unified MMA Foul 12.a: any part of the body **other than the hands or feet** in contact with the canvas. Stomping a grounded fighter is a foul (Foul 13); axe kicks and standing foot stops are not stomping. There is **no count**. If the grounded fighter is not intelligently defending under strikes, the referee stops (TKO) or, if unconscious, KO (Nevada wording).

### Fence / cage / ropes

- **Boxing:** ropes can **make** a knockdown (ABC Unified via manuals; WBC: if ropes prevent a fall, it is a knockdown). Grabbing ropes to hit is a foul (NAC 467.675(21); Ontario §8.6).
- **MMA:** hands **may** be placed on the fence and used to push off. Toes **may** go through the fence. **Grabbing** the fence (fingers/toes through, controlling own or opponent’s position) is a foul (Foul 15). Remedy can include a point **and** a stand-up restart in a neutral position if the foul produced a superior position.

### Stand-ups

- **Boxing:** the referee breaks a clinch; fighters resume standing because they never legally go to the ground as a phase. A downed boxer must rise unassisted, take the 8, pass the referee’s check, then box.
- **MMA:** the referee **stands fighters up** (or breaks them) when **neither** shows real, significant, sustained effort to **finish**. Superior position without finishing effort is not protected. This is the inactivity tool boxing does not have in this form.

### What “hurt” licenses

- **Boxing, standing and hurt:** the referee may **not** administer a standing eight (ABC Rule 7). Options: let them continue, separate, or stop. After a knockdown, hurt is licensed into a **mandatory 8** plus gait/questions, then continue or wave off.
- **MMA, hurt:** no count, no timeout on a legal strike (except laceration). Hurt licenses either **continuation** (including ground strikes) or **stoppage** for not / cannot intelligently defend. Indiana’s training note (pride, open eyes, still eating shots) is one commission’s gloss of that standard.

### Inactivity stoppage — one sport can end for it; the other mostly cannot as a named result

- **MMA can:** (1) stand-up/break for no finishing effort; (2) **timidity** foul (avoiding contact, running, faking injury, spitting the mouthpiece) with warning / points / DQ; (3) flagrant disregard of instructions. The stand-up is not itself a loss; repeated timidity can become a loss.
- **Boxing cannot**, under ABC Unified, end a bout for “inactivity” as a named result. Closest published tools: NAC 467.723 **not honestly competing** (stop, DQ, purse hold); NAC 467.718 **too one-sided**; BBBofC 3.38(g) **not trying** (caution / points / DQ); ABC Referee Manual one-sided stop. There is **no** ABC “stall clock then TKO.” A boring clinch is a **break**, not a stoppage.

### Other named divergences (not a table)

- **Out of the fighting area:** boxing 20 seconds (ABC Rule 9); MMA-in-a-ring **five minutes** plus physician (Unified MMA Rule 5).
- **Glove wipe:** boxing yes, MMA no (NAC 467.735).
- **Towel:** ABC Referee Manual — towel **cannot** stop a US professional boxing match; chief second tells the inspector. Abroad, investigate. MMA Types of Decisions lists **corner stoppage** as a TKO subtype.
- **Scoring referee:** ABC Unified Boxing Rule 3: three judges score; referee does not. **BBBofC 3.5.1:** in ordinary British contests the referee **scores and** is sole arbiter; three judges only for British/Commonwealth championships (or as Stewards deem). WBO §23(a): normally three judges + non-scoring referee; President **may** appoint two judges and a scoring referee.
- **Physician’s power:** ABC boxing/MMA: referee sole arbiter. Ontario boxing §5: referee **and** ringside practitioner may stop. WBC: doctor red-cards a recommendation. Alabama MMA admin code (fetched 2026-09-10): physician may enter and advise but “shall have no authority to stop a fight.” Do not universalize any of these.
- **Replay:** Unified MMA Rule 3: fight-ending sequence, only after stoppage, no resume. Nevada NAC 467.682(4)–(5): referee may view replay after an injury stop to decide legal blow vs foul, and may call timeout to consult or view replay.

---

## §3 — The count in detail

Professional boxing unless labelled amateur. MMA: **no count** (NAC 467.740(9); Unified MMA Types of Decisions). That is the whole MMA paragraph.

### Duration and against what it is measured

**DIRECT (NAC 467.740(1)–(2); ABC Referee Manual; Ontario §14.2–14.8; WBA Rule 11; WBO §25):**

1. Timekeeper (or knockdown timekeeper) signals **one-second intervals**.
2. Referee **picks up** that cadence after sending the opponent to the farthest neutral corner. The **referee’s count is official**; the timekeeper ceases.
3. Referee announces each second **audibly** and with an **arm/finger** so the downed boxer can see and hear it. Manual: kneel if necessary; do not rely on voice alone.
4. If the standing boxer **leaves** the corner, **stop the count**, put them back, **resume where interrupted**. Wall-clock time from canvas to “ten” is therefore **not** guaranteed to be ten seconds.
5. The unified 13-point ABC list does **not** write the amateur “one second must elapse before ‘one’” rule. Wisconsin SPS 192.79(4) **does** write that interval for its professional code. USA Boxing 19.2 and World Boxing 8.6.3 write it for amateur. **UNKNOWN** whether a given ABC-jurisdiction referee inserts that gap; the ABC Referee Manual says pick up the timekeeper, not “wait one extra second.”

**WBC championship checklist (2016, still the synthesized championship sheet):** knockdown “when three (3) parts of the body touch the canvas.” That is **WBC phrasing**, not ABC. ABC/NAC/WBO/WBA: any body part other than the feet, or helpless on the ropes / ropes-only. Do not universalize “three points of contact.”

### What the fighter must do to beat the count

**DIRECT:**

- Be **up** before the referee completes **ten** (ABC Referee Manual; WBA Rule 11; WBO §25(d)). Ontario §14.1 / §16.2: rise to a **standing and ready** position before 10.
- Still take the **mandatory eight** even if up at two (ABC Rule 5; NAC 467.740(2); WBO §25(b)–(c); WBA Rule 11 last sentence). Ontario §14.10.
- After eight, satisfy the referee of ability to **intelligently defend**: ABC Manual gait test + questions. WBO §25(c): if up at eight, referee **may** examine, “taking all the time needed.” NAC 467.740(3): referee **may** step between “long enough to assure himself or herself” of condition; then order them on “without loss of time.”
- Unassisted. ABC Rule 9 (out of ring). Manual: referee should not assist the downed fighter.
- If they get up and **go down again without a fresh blow**, resume the **same** count (ABC Manual; NAC 467.745; Ontario §14.9; WAC 36-12-140(1)). Wisconsin SPS 192.79(5): if after 8 they immediately fall again without a fresh blow → KO.

**Rise at seven:** they are still down for the purpose of the mandatory eight until eight is completed. They do **not** skip the fitness check. “Up at seven means you continue” is folklore (§ UNKNOWN).

### The bell

**DIRECT — ABC Unified Boxing Rule 10:** “A boxer who has been knocked down cannot be saved by the bell in any round.”

Same result, different wording: WBO §25(e) (timekeeper shall **not** ring; referee continues until the boxer rises or is counted out; **only the referee** decides when that round ended if the knockdown was inside 10 seconds of the end; inadvertent bell is ignored). WBA Rule 14. WBC checklist including the last round. Ontario §14.15: if still down when time expires, timekeeper shall not sound the bell until after the mandatory eight. NAC 467.740(6)–(8): bell not sounded while counting; if the period ends before they arise, count continues; down after the bell from a last-second legal blow is still that round’s knockdown. BBBofC 3.35: continues in **every** round including the final. ABC Referee Manual, PUNCH AT THE BELL: a punch **in motion** at the bell is legal; if the recipient falls, count (bell should not ring); if they rise, still give the full mandatory 8; if fit, signal continue, **then** the bell sounds and the rest minute begins.

Amateur USA Boxing 19.4: bout must not continue until mandatory 8 “even if … the round has come to a close” — a different sport.

### Three-knockdown rule — body, year, current

| Body | Text | Year of the text used | Current? |
| --- | --- | --- | --- |
| **ABC Unified Rules of Boxing Rule 8** | “There is NO Three (3) Knockdown Rule.” | Last amended **3 August 2016** (rule present since the 2001 unified set). | **Yes: no 3KD.** DIRECT. |
| **ABC Boxing Referee Manual** | “While a 3-knockdown rule doesn't exist, boxers knocked down 3 times in a round should be closely observed.” | Rev. **08/2025**. | **Yes: no auto-stop; observe.** DIRECT. |
| **WBC** championship synthesized rules §12 | “There is no automatic TKO with three (3) knockdowns in one round.” | **2016** sheet; still the WBC championship-rules PDF on wbcboxing.com as fetched 2026-09-10. | **Yes: no automatic TKO.** DIRECT for that sheet. UNKNOWN whether a later unpublished WBC circular changed it; none was found. |
| **WBO** Regulations §25 | Count, compulsory eight, ten, no save by bell. **No** three-knockdown clause. §26 adopts ABC Uniform Rules. | **January 2024** PDF. | **Yes: no 3KD clause.** INHERITED from ABC adoption. |
| **IBF** Championship Contest Rules | No knockdown/count article in the 2025 championship-contest PDF. | Amendments through **30 April 2025**. | **UNKNOWN** as IBF-own text. In-ring likely ABC/local. Do not claim IBF “waives” 3KD from this PDF; the PDF is silent. |
| **WBA** Contest Rule 12 | “Three (3) knockdowns in the same round constitute an automatic knockout.” | Amended **22 April 2024**; PDF hosted **June 2026**. | **Yes: automatic KO in WBA’s own contest rules.** DIRECT. Whether a given WBA title in an ABC state actually applies Rule 12 that night is **UNKNOWN**. |
| **Ontario** professional boxing §14.23–14.24 | Non-championship: three knockdowns in a round → referee **shall** stop, TKO. Championship: referee **may** continue if not an immediate health/safety threat. | Published 11 Dec 2024, **updated 22 May 2025**. | **Yes, split by championship.** DIRECT. |
| **Wisconsin** SPS 192.79(8) | Referee **may not** stop a professional bout solely because of three knockdowns in one round. Amateur: stop at any combination of three knockdowns/standing eights in a round. | Live as of fetch 2026-09-07/10. | **Yes: no pro auto-stop.** DIRECT. |
| **Colorado** 4 CCR 740-1.8 M | Three knockdowns same round **shall** lose by TKO; Director may waive. | LII text dated 2025-07-31. | **Yes, unless waived.** DIRECT. |
| **JBC** (Japan, domestic) | JBC Wikipedia: “フリーノックダウン制（2015年まではスリーノックダウン制…）” — free knockdown from **2016**; international title fights follow the sanctioning body. | Wikipedia pages updated 2026-08-30 / 2026-09-05. | **UNVERIFIED_SECONDARY** for the 2016 year until a JBC rulebook PDF is in hand. Do not treat as DIRECT. |
| **Amateur USA Boxing / World Boxing** | Compulsory **eight-count limits** (3 per round / 4 per bout), which is not the professional 3KD rule. | USA Boxing 1 Jan 2026; World Boxing Nov 2024. | Amateur only. |

**Refused:** BoxingInsider (15 Feb 2026) listing Arizona, Connecticut, Florida, Iowa, Maryland, Massachusetts, Michigan, Mississippi, Missouri, **Nevada**, New York, Ohio, Oklahoma, Tennessee, Texas as 3KD states, and claiming “all four major bodies waive it in title fights.” The WBA PDF **contradicts** the second sentence. Nevada NAC 467.740 as published on the Nevada legislature site **4 April 2026 / rev. 4/13/2026** has **no** three-knockdown sentence. Cornell LII also flags 467.740 as repealed 29 Dec 2022 even while the legislature HTML still prints it — that recodification conflict is **UNKNOWN**. This memo **does not** copy BoxingInsider’s roster.

### Standing eight — body, year, current

| Body | Text | Year | Current? |
| --- | --- | --- | --- |
| **ABC Unified Boxing Rule 7** | “There is NO Standing Eight (8) Count.” | **3 August 2016** (present in the 2001 unified set). | **Yes: none.** DIRECT. |
| **ABC Referee Guidelines** | “There is NO Standing Eight (8) Count.” | Last updated **16 March 2011** (PDF). | **Yes: none.** DIRECT. |
| **WBC** championship checklist | “There is no standing eight (8) count.” | **2016**. | **Yes: none.** DIRECT. |
| **WBO** §25 | Count only when the contestant is **down**. No standing-eight grant. | **Jan 2024**. | **Yes: none.** INHERITED. |
| **WBA** Rules 10–12 | Down = body other than feet, or hanging helplessly over the ropes. Count after knockdown. No standing-eight grant. | **Apr 2024**. | **Yes: none found.** INHERITED. Silence is not amateur standing-eight. |
| **Ontario** §14.25 | Referee shall **not**, in the absence of a knockdown, stop to begin a count of eight. | **May 2025**. | **Yes: none.** DIRECT. |
| **Wisconsin** SPS 192.79(7) | Professional: may not. Amateur: may. | Current. | DIRECT. |
| **USA Boxing** 19.1(4), 19.2 | Standing eight is part of the amateur knockdown definition (“semi-conscious… cannot continue”). | **1 Jan 2026**. | **Yes, amateur.** DIRECT. |
| **World Boxing** 8.6.1 | Standing eight when hurt, not fallen, not on the ropes. | **Nov 2024**. | **Yes, amateur.** DIRECT. |
| **ABC abolition year 1998** | Wikipedia “Mandatory eight count”; BoxingInsider. | Secondary. | **UNVERIFIED_SECONDARY.** Current professional prohibition is the 2016 unified rule, not the 1998 anecdote. |

### Double knockdown

ABC Referee Manual; NAC 467.740(5); Ontario §14.14; WAC 36-12-140(8): continue as long as one is down; both still down at 10 → **technical draw** (ABC/NAC/Ontario). Washington WAC: if both rise but neither can continue, go to scorecards.

### Punch after the bell

ABC Referee Manual: if intentional and injury → mandatory 2-point deduction; 5-minute rest **before** the 1-minute rest; doctor; if cannot continue → DQ. If accidental: still 5-minute rest; then four-round accidental-foul result rules.

---

## §4 — What we could not decide today

Live game data named in the task: **six body regions, stamina / heart-rate, discrete trauma pips (cuts/swelling), knockdowns, stall clock, per-round scores, stoppage reason.**

These referee decisions **cannot** be supported by that data. Not “hard.” **Cannot.**

### 1. Foul object — accidental vs intentional, and whether it was a foul at all

Headbutt vs clash, rabbit punch vs legal temple, low blow vs top-of-hip, thumb to the eye vs legal glove, MMA fingers-outstretched vs a legal open-hand frame, fence **push** vs fence **grab**, punch on the break vs punch in the pocket. ABC, WBA, WBO, Ontario, and Unified MMA all make **intent** and **effect** the fork between warning, one point, mandatory two points, DQ, no-contest, and technical decision.

The engine has regions and pips. It does not have a glove angle, a beltline measured at the hip (ABC Referee Manual: neither waistband nor navel is the line), a finger-through-the-cage test, or a referee’s sightline. **Foul object is not decidable.** Any “foul %” table would be fiction.

### 2. Intelligent defense / gait / “are you OK?” / “can you see?”

ABC boxing continue-after-8 is a **gait test plus questions**. MMA TKO is **IS NOT intelligently defending**; MMA KO is **CANNOT** (ABC) or **unconscious** (Nevada). Unified MMA eye-poke procedure requires a verbal yes/no that the fighter can see. Concussion guidance is speech, fog, delayed answers, the walk to the corner.

We have stamina, HR, and trauma pips. We do not have balance, conjugate gaze, speech, delayed answers, or “pride keeping the eyes open while eating shots” (Indiana’s gloss). Mapping HR to a wave-off would be an invented medical rule.

### 3. Slip vs knockdown vs ropes-only vs voluntary knee vs shove

The count, the 10-8 round, and “hitting a downed opponent” all turn on **this** call. ABC Manual: legal blow + any part but the soles, or hanging defenseless, or ropes-only; **or** a voluntary knee. Ontario: wave off “no knockdown” if down for any reason other than a legal blow. WBC adds “three parts of the body.” Engine “knockdowns” is an output someone already decided. The data cannot produce the decision.

### 4. MMA stand-up: effort to finish vs holding a hole

Unified MMA: stand up or break when **neither** shows real, significant, sustained effort to finish; superior position is not enough. The stall clock is elapsed time in a position. It is not “submission attempt / damaging ground strike / advancing position.” Two fighters can stall in a pin with a live stall clock and still be one legal elbow from a finish. The stand-up call is not a timer expiry.

### 5. Doctor cut / vision / “orbit of the eye”

ABC Manual: eyelid/orbit, vision impairment, swollen-shut making exam difficult. Pips can say “cut exists.” They cannot say “vision is gone” or “physician would stop.” Unified MMA D.3 even forbids a timeout to inspect a legal shot unless a laceration is present — so the live call is often continue-or-end with **no** extra data.

### 6. Mouthpiece spat vs knocked out; spare mouthpiece TKO

ABC Unified: points **may** be deducted if purposely spit. Manual: lost in the crowd, no spare → TKO. Not in the data list.

If a stoppage-reason string is already written by some other system, the referee did not decide it. The camera still needs a body in the frame. That is §5.

---

## §5 — What you would NOT build

This is a management game. The referee is at most **a figure in frame** and **a reason on the card**.

**Worth a fact, not a person:**

| Fact | Why it is a fact | Why it is not a referee object |
| --- | --- | --- |
| Boxing knockdown **pause** + official count 8/10 | It stops punching, can end the bout, and changes the round score. | A timer + down-flag. Not an NPC. |
| Announced **point deduction** | It changes the card that round (NAC 467.688(3): deduct in the round of the foul). | A score event. The pointing-at-judges pantomime is scenery. |
| **Stoppage reason** | Already in the model (KO, TKO, doctor, submission, decision). | Keep it. Do not add a referee who “computes” it. |
| MMA **stall clock** | Already in the model; closest legal cousin is the stand-up rule. | Expiry can **suggest** a stand-up in frame. It cannot **be** the Unified “effort to finish” test. |

**Not worth engine state — frame/card scenery, if anything:**

Almost all of §1: STOP/BREAK/BOX, Spanish commands, neutral-corner pointing, finger count, gait test, glove wipe, mouthpiece rinse, loose tape, Vaseline check, beltline lecture, red/green cards, doctor climbing through the ropes, wiping gloves on the shirt, “TIME!” at the bell, raising the winner’s hand, the walk between fighters for the camera.

**Willing conclusion:** **most of §1 is the latter.** Building a referee who decides fouls, intelligent defense, and stand-ups from six regions + HR + pips would be an invented official. The honest product is: the engine already ends the bout; the broadcast grammar needs a body that counts, waves, and stands in between. That body is art and animation, not a rules object.

Do not design it here.

---

## § UNKNOWN / refused folklore

Refused **by name**. Not current professional ABC default. Not to be smuggled.

| Folklore | What the texts actually do | Grade of the refusal |
| --- | --- | --- |
| **Standing eight is how a referee saves a hurt standing pro** | ABC Rule 7 (2016): NO. WBC 2016: NO. Ontario 2025: shall not. Amateur USA Boxing / World Boxing: YES — different sport. | DIRECT prohibition. |
| **Three knockdowns in a round is always TKO** | ABC Rule 8 (2016): NO. WBA Rule 12 (2024): YES in WBA’s own rules. Ontario: only non-championship shall. Not “always.” | DIRECT. |
| **Saved by the bell in the last round** | ABC Rule 10: cannot be saved in **any** round. WBO, WBA, WBC, Ontario, BBBofC 3.35: same. | DIRECT. |
| **The count is ten real seconds from the moment they hit the canvas** | Count is the referee’s cadence after the opponent is in the farthest neutral corner; **pauses** if they leave. Can run long. May be cut short for safety (NAC 467.740(4)). | DIRECT. |
| **If you get up at seven you automatically continue** | Mandatory 8 still runs. Then gait/questions/“time needed” exam (WBO §25(c)). | DIRECT. |
| **“Protect yourself at all times” means you can be hit while down** | Pre-bout command (ABC Manual; BBBofC 3.28). Hitting a downed or rising boxer is a foul (NAC 467.675(2); Ontario §8.2; BBBofC 3.38(k)). | DIRECT. |
| **MMA has a ten-count** | NAC 467.740(9): boxing count does not apply to MMA. Unified MMA stoppage = intelligent defense / unconsciousness. | DIRECT. |
| **Throwing in the towel stops a US pro boxing match** | ABC Referee Manual: it cannot; chief second notifies the inspector. NAC 467.675(31) lists throwing in the towel as a **foul**. MMA does list corner stoppage as TKO. | DIRECT. |
| **The referee scores the fight** | ABC Rule 3: three judges. Exception: BBBofC ordinary shows (referee scores); WBO may appoint a scoring referee. Not the ABC default. | DIRECT. |
| **Knockdown = three points of contact** | WBC 2016 checklist only. ABC/NAC/WBA/WBO: any part but the feet, or ropes. | DIRECT (do not universalize). |
| **ABC abolished the standing eight in 1998, therefore…** | Secondary (Wikipedia, BoxingInsider). Current law is Unified Rule 7 (2016). The year 1998 is **UNVERIFIED_SECONDARY** and unnecessary. | UNVERIFIED_SECONDARY. |
| **All four major bodies waive three-knockdown in title fights** | BoxingInsider 2026. **WBA Rule 12 (2024) says the opposite.** IBF championship PDF is silent. | DIRECT contradiction of the WBA half. |
| **BoxingInsider’s 15-state 3KD list, including Nevada** | Nevada NAC 467.740 as printed 2026-04-13 has no 3KD sentence. List refused. | UNVERIFIED_SECONDARY. |
| **Doctor always can / cannot stop the fight** | Split: ABC sole arbiter; Ontario both; WBC red-card recommendation; Alabama MMA physician “no authority to stop.” | DIRECT split. Do not pick one as universal. |
| **August 2026 MMA vomit/bucket rules are in force today** | PDF: approved 5 Aug 2026, **requested implementation November 2027**. | DIRECT (not in force). |
| **A stall clock expiry is an MMA TKO** | Stand-up/break is not a loss. Timidity can become points/DQ. No ABC “inactivity TKO.” | DIRECT. |
| **IBF in-ring knockdown code** | Not in the championship-contest PDF. | UNKNOWN. |
| **JBC 2016 free-knockdown year** | Wikipedia / JBC wiki. No JBC PDF in hand. | UNVERIFIED_SECONDARY / UNKNOWN as DIRECT. |
| **Which text wins when WBA Rule 12 meets ABC Rule 8 on fight night** | Not found. Dressing-room rules meeting. | UNKNOWN. |
| **Nevada NAC 467.740 still the operative code vs NRUC recodification** | Legislature HTML still prints it (rev. 4/13/2026). Cornell LII marks repeal 12/29/2022. boxing.nv.gov hosts a Nov 2024 NRUC PDF not fully extracted here. | UNKNOWN which binder a 2026 Nevada referee is handed. The printed NAC count text was used as DIRECT **for that HTML**, with this conflict flagged. |
| **Mandatory 18-count after returning to the ring early** | ABC Referee Manual only; not Unified Rule 9 (20 seconds). | DIRECT as manual mechanics; UNKNOWN as universal commission law. |

---

## Sources

All fetched or opened 2026-09-10 unless a page states its own revision date. Primary first.

### Primary — boxing rules and mechanics

1. ABC Unified Rules of Boxing (approved 25 Aug 2001, last amended **3 Aug 2016**). PDF: `https://www.abcboxing.com/wp-content/uploads/2016/10/unified_rules_boxing_rev_august2016.pdf` — also HTML `https://www.abcboxing.com/unified-rules-boxing/`
2. ABC Boxing Referee Manual, **Rev. 08/2025**. `https://www.abcboxing.com/wp-content/uploads/2026/06/ABC-BOXING-REFEREE-MANUAL-rev8-2025.pdf`
3. ABC Referee Rules and Guidelines (PDF, last updated 16 Mar 2011). `https://www.abcboxing.com/ABC_REFEREE_GUIDELINES.pdf`
4. ABC Regulatory Guidelines (modified 27 Jul 2005). `https://www.abcboxing.com/abc-regulatory-guidelines/`
5. ABC Unified Rules index. `https://www.abcboxing.com/unified-rules/`
6. ABC Ring Officials Certification Program (stoppage cues). `https://www.abcboxing.com/ring-officials-certification-program/`
7. Nevada NAC Chapter 467, legislature HTML **[Rev. 4/13/2026]**. Especially 467.668–467.760 (boxing count, fouls, referee duties) and 467.7961–467.79615 (MMA TKO/KO). `https://www.leg.state.nv.us/nac/NAC-467.html`
8. Ontario, *Professional combative sport rules: Boxing*, Part III, updated **22 May 2025**. `https://www.ontario.ca/document/professional-combative-sport-rules-boxing/part-iii-technical-sport-rules`
9. WBA Rules, amended 12 Dec 2022 and **22 Apr 2024**, PDF hosted Jun 2026. Contest Rules 10–21 (down, knockdown, automatic knockout, outside, bell, fouls, referee authority). `https://www.wbaboxing.com/wp-content/uploads/2026/06/WBA-Rules-11.08.2023.pdf`
10. WBO *Regulations of World Championship Contests*, Jan 2024. §§23–26. `https://www.wboboxing.com/wp-content/uploads/2024/01/WBO-Regulations-jan-2024.pdf`
11. WBC *Rules for Championship Fights Synthesized* (2016 PDF, still hosted). §§3, 12. `https://wbcboxing.com/downloads/WBC_RULES_FOR_CHAMPIONSHIP_FIGHTS_SYNTHESIZED-2016.pdf`
12. IBF *Rules Governing Championship Contests*, effective 1 Sep 2006, amendments through **30 Apr 2025**, posted 13 Aug 2025. `https://www.ibf-usba-boxing.com/wp-content/uploads/IBFChampionshipContestRules06_25.pdf`
13. British Boxing Board of Control, *The Rules of Boxing* (site text 2026; full 2026 PDF linked). Especially 3.5, 3.8, 3.28, 3.32–3.40, 3.43. `https://bbbofc.com/boxing-rules` — full PDF `https://bbbofc.com/build/documents/Rules_and_Regulations_2026.pdf`
14. Wisconsin SPS 192.79 (count; no professional standing eight; no professional 3KD auto-stop). `https://docs.legis.wisconsin.gov/code/admin_code/sps/professional_services/190/192/vii/79/4/b`
15. Washington WAC 36-12-140, method of counting. `https://app.leg.wa.gov/wac/default.aspx?cite=36-12-140`
16. Colorado 4 CCR 740-1.8 (three knockdowns / mandatory eight). `https://www.law.cornell.edu/regulations/colorado/4-CCR-740-1.8`
17. Georgia Ga. Comp. R. & Regs. R. 85-1-.07 (count; no standing eight; no save by bell). `https://www.law.cornell.edu/regulations/georgia/Ga-Comp-R-Regs-R-85-1-.07`

### Primary — MMA

18. ABC Unified Rules of Mixed Martial Arts, PDF **August 2026** (header: amended with rule changes 5 Aug 2026, requested implementation Nov 2027; newly approved language in blue). `https://www.abcboxing.com/wp-content/uploads/2026/08/Unified-Rules-of-MMA-8.2026.pdf`
19. ABC MMA Officials Handbook (Oklahoma commission host of the unified text). `https://oklahoma.gov/content/dam/ok/en/osac/documents/ABC%20MMA%20Officials%20Handbook.pdf`
20. Nevada NAC 467.796, 467.7961, 467.79615 (judging; MMA TKO = not intelligently defending while repeatedly struck; MMA KO = unconsciousness). Same NAC-467 URL as (7).
21. Indiana Combat Sports regulations (intelligent-defense training definition). `https://www.in.gov/igc/files/athletics/Regulations-ICS.pdf`
22. Alabama Admin. Code 165-X-3-.08 (physician advises, no authority to stop). `https://admincode.legislature.state.al.us/administrative-code/165-X-3-.08`

### Primary — amateur (standing eight still lives here)

23. USA Boxing National Rulebook, revised **1 January 2026**. Rules 19.1–19.7. `https://assets.contentstack.io/v3/assets/blteb7d012fc7ebef7f/blt5ff28f6e78e9624d/695ed2d8b45570d8a64b74b9/USA_Boxing_Rule_Book_Revisions_-_1.1.2026.pdf`
24. World Boxing Competition Rules, Nov 2024. §8.6. `https://worldboxing.org/wp-content/uploads/2025/09/World-Boxing-Competition-Rules-Nov-2024-Approved-4.pdf`

### Secondary — used only as pointers, never as current law

25. BoxingInsider, “Boxing Rules by State & Title Fight Differences,” 15 Feb 2026. `https://www.boxinginsider.com/almanac/boxing-rules-by-state-title-fight-differences/` — **refused** for the 3KD state roster and “all four bodies waive 3KD.”
26. Wikipedia, “Mandatory eight count,” fetched 2026-09-10. `https://en.wikipedia.org/wiki/Mandatory_eight_count` — **1998 ABC abolition year** is UNVERIFIED_SECONDARY.
27. Japanese Wikipedia “ボクシング” and “日本ボクシングコミッション” (JBC 2016 free-knockdown). `https://ja.wikipedia.org/wiki/ボクシング` — UNVERIFIED_SECONDARY for the 2016 year.
28. OpenSourceSports IBF/WBO restatements. Not used as law.
29. Cornell LII NAC 467.740 “Repealed” note (R089-22A, 29 Dec 2022) vs Nevada legislature HTML still printing 467.740 on 13 Apr 2026 — conflict flagged UNKNOWN.

---

*End J14. No referee was designed.*
