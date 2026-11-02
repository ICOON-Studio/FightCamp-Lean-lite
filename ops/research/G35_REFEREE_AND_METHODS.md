# G35 — The Referee, and the Fifth Method

Author: Grok (Expert, 110 sources), 2026-09-10. Delivered in the in-app
browser and committed unchanged by Claude — Grok has no checkout.

Research contract. **Does not reopen G34** seats, events, counters,
position-point table, or submission rate.

G34 is in flight: `GrappleSeat.gd`, `GrappleResolve.gd`, and the blind
contract test are being built against it. This document answers the two
questions that build will hit next: how a grappling contest ends, and who
moves two men who have stopped moving.

Inference is marked as inference.

## 0. Existing engine vocabulary

The real-time engine currently ends a fight with four atomic strings:

```
METHOD_KO       := "KO"
METHOD_TKO      := "TKO"
METHOD_DOCTOR   := "DOCTOR STOPPAGE"
METHOD_DECISION := "DECISION"
```

There is no submission. G34 §5 established the rate (19.3% of 8,591 UFC
bouts) and the attempt/finish split. It did not name the method or say who
owns it.

## 1. How a grappling contest ends

### 1.1 Minimum method set across the four rulesets

| Ruleset | Official end conditions that matter here |
| --- | --- |
| MMA (ABC Unified Rules, Aug 2026) | Submission (tap / verbal tap / technical submission); KO; TKO (referee / corner / did-not-answer / medical); decision (unanimous / split / majority / technical); draw variants; DQ; no contest. |
| Judo (IJF SOR, 2025–28 cycle) | Ippon (throw, 20s osaekomi, or tap/maitta/unconsciousness from shime/kansetsu); waza-ari-awasete-ippon; hansoku-make (direct or third shido); golden-score continuation until a score or hansoku-make. There is no "points decision" in the MMA sense: time expiry with a lead is still a score win; a true tie goes to golden score. |
| Freestyle (UWW 2026) | Fall (pin); technical superiority (10-point gap FS / WW); decision on points + criteria; injury (VIN); forfeit (VFO); disqualification (DSQ); 3 cautions. |
| BJJ (IBJJF Rules v6.1, 2024) | Submission (tap / verbal / scream-in-hold / loss of consciousness from a legal hold); points at time; advantages then referee decision if tied; DQ on accumulated penalties; injury / doctor / uncontained bleed / loss of bodily function. |

Sources: ABC Unified Rules of MMA (Aug 2026 PDF); ABC Officials Handbook
language on tap / verbal / technical submission; UWW International Wrestling
Rules (cdn.uww.org, Jan 2026) Arts. 29, 41–43, 46; IBJJF Rules Book v6.1
2024, match-end and Art. 6.2.1 / 7; IJF Sport and Organisation Rules Art. 14
(ippon), Art. 17 (osaekomi), Art. 18 (shido / hansoku-make).

### 1.2 Answers to the four vocabulary questions

**Submission is a method.** ABC names it as its own result family, sibling to
KO/TKO, not a subtype of TKO. IBJJF and UWW grappling do the same. UFC public
records treat it as a third finish bucket next to KO/TKO and decision
(1,659 / 8,591 = 19.3%). The engine must grow a fifth atomic string. That is
the whole of "the fifth method."

**Ippon is not a method.** It is a score that ends the contest when it is
reached. Three different engine facts produce it:

* a throwing score (standing, outside this document);
* osaekomi held 20 seconds (pin-timer threshold);
* surrender or unconsciousness in shime-waza / kansetsu-waza (the same
  physical fact as a submission).

*Inference:* the engine never emits `"IPPON"`. The IJF adapter maps
`METHOD_SUBMISSION` and "osaekomi reached 20s" onto the ippon result line.

**A grappling points win is `METHOD_DECISION`.** Time expired, someone had
more points. IBJJF points, UWW points, and MMA 10-point-must are three
scorecards sitting on the same engine fact: the clock hit zero with both men
still able to continue. The adapter writes the public string (POINTS,
DECISION, VPO). **Do not invent `METHOD_POINTS`.**

**Technical superiority is a score threshold, not a method.** UWW FS:
10-point gap, whistle after the current action completes (Art. 43). IBJJF has
no mercy rule at a point gap. *Inference:* adapter watches the G34 point table
and posts a stop. Engine does not name it.

**Injury default sits on `METHOD_DOCTOR`.** UWW VIN, IBJJF doctor/bleed/vomit,
ABC "TKO due to Medical Stoppage." The engine already has the medical stop.
Adapters rename.

**Disqualification and no-contest are adapter results on an official-stop
fact.** ABC: DQ from intentional foul / accumulated fouls / flagrant
disregard; NC from an accidental foul before enough rounds. UWW: DSQ, three
cautions. IBJJF: fourth penalty. IJF: third shido = hansoku-make. The engine
should expose a generic official-stop so settlement can write DQ / NC / HSM;
it should **not** grow `METHOD_DQ` as a fifth-and-sixth combat method. Those
are legal outcomes, not combat outcomes.

### 1.3 Engine vs adapter (same test as G34)

G34's governing inference: the engine emits one neutral fact; the ruleset
adapter converts it. A method the engine must name is expensive. A method an
adapter derives is cheap.

| String / outcome | Side | Why |
| --- | --- | --- |
| KO | ENGINE (exists) | Physical fact: cannot intelligently defend, from strikes. |
| TKO | ENGINE (exists) | Physical fact: is not intelligently defending, from strikes. |
| DOCTOR STOPPAGE | ENGINE (exists) | Official medical fact. Adapters may display TKO-doctor / VIN. |
| DECISION | ENGINE (exists) | Clock fact. Adapters display UD/SD/MD, POINTS, VPO. |
| SUBMISSION | **ENGINE (new)** | Physical fact the other four cannot express: the hold ended the man. |
| Technical submission | ADAPTER | ABC subtype. Same hold, `finish_mode = UNCONSCIOUS` or `JOINT`. |
| Ippon | ADAPTER | Score or hold-timer or submission, IJF-labelled. |
| Fall / pin | ADAPTER | Position + confirmation window. Not a strike, not a tap. |
| Technical superiority | ADAPTER | Point differential on G34's table. |
| Injury default / VIN | ADAPTER | Relabel of DOCTOR. |
| DQ / hansoku-make / 4th penalty | ADAPTER | Foul ledger. |
| No contest / technical decision / technical draw | ADAPTER | Foul + clock + scorecards. |
| Forfeit / VFO | ADAPTER | Did not start. Outside the tick loop. |

**One new engine method. Everything else is a label.**

### 1.4 Does a submission finish need anything the impact log cannot carry?

**Yes. Do not hang a tap on the impact log.**

The impact log is a strike record: who hit whom, with what, how hard, which
region. A submission finish is not an impact. It is a hold that the defender
stopped resisting, or that removed consciousness, or that destroyed a joint.

G34 already has (or is building) submission attempts as grappling events. The
finish is the attempt's terminal state. Required record shape — one event,
written once, at the tick the contest stops:

```
SubmissionFinish
  tick            : int          # 20 Hz integer time
  attacker        : id
  defender        : id
  seat            : G34 seat     # position at finish; do not invent a new seat
  hold_family     : CHOKE | JOINT | OTHER
  hold_id         : string       # adapter/catalogue name, not an engine enum
  finish_mode     : TAP | VERBAL | UNCONSCIOUS | JOINT
  attempt_start   : int          # tick the attempt opened
  method          : "SUBMISSION" # the engine string
```

That is the whole addition. No damage-region write. No new impact type.
`UNCONSCIOUS` and `JOINT` are how the ABC adapter prints "Technical
Submission." `TAP` and `VERBAL` print "Submission."

*Inference:* body-damage / `BodyReadiness` already owns cuts, breaks, and
medical holds. A joint-destruction finish may also flag an injury for the
medical system. That flag is a side write, not the method.

## 2. Who intervenes when nothing is happening

A seat model with a stability gate and no referee produces a man who takes
guard in round one and is still there at the bell. Every ruleset on the roster
already answered this. They answered it differently.

### 2.1 MMA (Unified / ABC)

Rule text (ABC Unified Rules of MMA, Aug 2026):

> The Referee shall either stand up or break the fighters when neither fighter
> is able to or fails to demonstrate real, significant and/or sustained effort
> to advance towards finishing the fight by any method. Simply maintaining
> what may be perceived as a superior position will not be considered effort
> to advance towards finishing the fight nor grounds for a guaranteed
> opportunity to maintain that position.

**There is no published second-count in the Unified Rules.** The standard is
qualitative: effort to finish, not effort to hold. Herb Dean's working brief
to fighters is the same sentence in the cage: he talks first ("let's work"),
he is not looking for busywork, he is looking for posture to strike, a pass,
or a submission. Closed-guard pitter-patter that never opens the guard does
not count; a static closed guard from bottom does not save the position
either.

**How often.** No commission publishes stand-ups per round. That number is not
in the rulebook and it is not in the result database. What exists is
referee-style reporting and a small number of notorious cards (e.g. UFC 319,
Goddard standing Chimaev / Du Plessis more than once from positions that
looked dominant). *Inference, stated as inference:* in a five-minute MMA round
that spends most of its time in closed or half guard with no pass, no
submission attempt, and no damaging GnP, a warning inside 20–30 seconds of
freeze and a stand-up inside the same round are normal officiating, not an
edge case. Treat "at least one intervention opportunity per stalled ground
round" as the design target, not a measured rate.

Timidity (avoiding contact, faking injury, dumping the mouthpiece) is a
separate foul. Do not fold it into the stall clock.

### 2.2 UWW freestyle

**This is the timed mechanism.** It is the one the tick engine can hold almost
verbatim.

UWW International Wrestling Rules, Art. 46 (freestyle), 2026 text:

* Passivity = blocking, interlocking fingers, thwarting, generally avoiding
  wrestling.
* First offence: brief stop, verbal warning V ("Attention").
* Second offence: brief stop, guilty wrestler marked, **30-second
  mandatory-score period** starts. Passive wrestler must score in those 30
  seconds; otherwise the opponent is awarded one point even if the opponent
  also scored during the window.
* Do not start or end the activity period in the middle of a viable action.
* If the first period is 0–0 at 2:00, the referee **must** designate one
  wrestler inactive and apply the same procedure. A first period must not end
  0–0.
* Under 30 seconds left in a period: if the whole officiating body agrees one
  man is evading, opponent gets one point and a caution (fleeing the hold).
  Challengeable.
* One verbal warning per wrestler per match; later calls go straight to
  activity time.
* U15 / U17 / Veterans: no verbal warning, straight to activity time; 0–0
  forced call at 1:00 of a 2-minute period.

Officials' teaching shorthand (USAW / UWW education): plan on roughly three
passivity structures in a 0–0 first period and two in the second — the clock
is a match-shaping tool, not a last resort.

### 2.3 IBJJF

IBJJF Rules v6.1 (2024), Art. 6.2.1 / 7.3:

* Lack of combativeness = one athlete clearly not pursuing positional
  progression.
* Also: **both** athletes showing no combativeness at once.
* Dual guard-pull: referee starts a **20-second countdown**. If at 20s nobody
  has top, a submission locked, or an imminent scoring move — even if they are
  wiggling — stop, penalise both, restart standing.
* Closed guard, named: top does not try to pass and stops bottom progressing;
  bottom wraps the torso / clutches without a submission or score.
* Side control / north-south without progression: stalling.
* 50/50 + lapel or belt grip: 20 seconds to progress or take the penalty.
* **Not** stalling: defending attacks from mount, back, side, north-south;
  holding mount or back while the position's technical characteristics are
  respected.

Penalty ladder (serious-foul ladder; stalling uses it):

1. mark penalty;
2. advantage to opponent;
3. two points to opponent;
4. disqualification.

Referee counts 20 consecutive seconds, command **LUTE!**, then the penalty.

**Advantages are a scoring bandage for near-misses** (almost-sweep,
almost-sub). They are not an intervention. Do not put them on the stall clock.

### 2.4 Judo (IJF)

Two coupled tools, not one.

**Matte / osaekomi cycle.** Mate is called, among other reasons, "when during
ne-waza there is no evident progress." The athletes return to hajime standing.
Osaekomi is the exception that must not be broken: pin timer runs 5s yuko /
10s waza-ari / 20s ippon (2025 cycle restored yuko; osaekomi ippon remains
20s). Toketa if the pin breaks. A live shime or kansetsu with progress is also
not mate.

**Shido for non-combativity.** Art. 18.1.1: negative positions, no search for
an attack, false attack, pulling to ne-waza without a legal entry. Standing,
after grips, the allowed time to produce an attack is 30 seconds in the 2025
IJF announcement ("Kumi-kata will be given 30 secs time for an attack") and 45
seconds if there is positive progression in some SOR printings. Third shido is
hansoku-make (loss of the contest; technical HSM still allows the rest of the
tournament).

*Inference:* ne-waza that has stopped progressing is a **mate**, not a shido,
unless the lack of progress is itself the non-combativity the standing rule is
punishing. The adapter decides which of the two official acts to fire. The
engine only has to say "this clinch/ground exchange produced no change."

### 2.5 Cross-cut: one engine mechanism, four conversions

**Yes.** The same shape as G34's stability gate works here.

All four rulesets punish the same observable:

> **N ticks in the current seat with no seat change and no submission
> attempt.**

That is the entire engine fact. Call it the **stall clock**.

What differs is only the conversion:

| Adapter | On first fire | On second fire | On clock expiry of a must-score window |
| --- | --- | --- | --- |
| MMA | Warning ("work"). Do not reset the seat. | Stand-up. Seat → standing. | n/a |
| UWW FS | V warning. | Open 30s activity window on the designated man. | +1 to opponent; wrestling continues. |
| IBJJF | Penalty on the ladder. Restart in place, or standing if dual-stall / dual-pull. | Next rung. 4th = DQ. | n/a (the 20s is the fire) |
| IJF ne-waza | Mate, return to standing. | Further dead ne-waza can carry a shido if the adapter calls non-combativity. | n/a |

A forced unification that also tried to own *who* is passive, whether the
restart is standing, and whether a point is awarded would fit none of them.
Those three decisions stay in the adapter. **The engine owns the counter.**

Reset the counter on any of:

* G34 seat change;
* G34 submission-attempt open;
* a scoring event the active adapter recognises (pass, sweep, takedown,
  exposure, throw);
* MMA only, adapter option: a strike the impact log marks as damaging, not a
  touch.

Do not reset on mere posture shifts inside the same seat. That is the busywork
Dean rejects and the "they are moving" clause IBJJF explicitly ignores on a
dual pull.

## 3. Proposed method vocabulary

Exact strings. Engine / adapter marked.

```
# ENGINE — emitted by the fight loop
METHOD_KO          := "KO"                 # exists
METHOD_TKO         := "TKO"                # exists
METHOD_DOCTOR      := "DOCTOR STOPPAGE"    # exists
METHOD_DECISION    := "DECISION"           # exists
METHOD_SUBMISSION  := "SUBMISSION"         # NEW — the fifth method
```

```
# ADAPTER — never stored as the engine method
# MMA
"TECHNICAL SUBMISSION"     # SUBMISSION + finish_mode UNCONSCIOUS|JOINT
"TECHNICAL DECISION"
"NO CONTEST"
"DISQUALIFICATION"
"TECHNICAL DRAW" | "UNANIMOUS DRAW" | "MAJORITY DRAW" | "SPLIT DRAW"

# IJF
"IPPON"                    # from throw, 20s osaekomi, or SUBMISSION
"WAZA-ARI-AWASETE-IPPON"
"HANSOKU-MAKE"

# UWW
"FALL"                     # pin confirmed
"TECHNICAL SUPERIORITY"    # 10-pt FS gap
"INJURY"                   # VIN, alias of DOCTOR
"FORFEIT"
"DISQUALIFICATION"         # DSQ / 3 cautions

# IBJJF
"POINTS"                   # display alias of DECISION
"REFEREE DECISION"         # tie broken by ref after points=advantages=penalties
```

Settlement writes `method` = `METHOD_*` from the engine column, and
`method_label` from the adapter column for the result strip and the record
book. Query layers that currently switch on four strings add one branch.

## 4. Proposed intervention mechanism

Name: **StallClock**. Integer ticks. 20 Hz. Never a float. Never "store
seconds, derive ticks."

```
STALL_HZ                    := 20
STALL_FIRE_TICKS            := 400    # 20 seconds — first fire
STALL_ACTIVITY_TICKS        := 600    # 30 seconds — UWW must-score window
```

Why 400 and not 600 as the first fire: 20s is the IBJJF *written* number, sits
inside the MMA informal 20–30s band, and is shorter than UWW's second stage so
the UWW adapter can still do V-then-30s without the engine inventing a third
constant. UWW's 30s is `STALL_ACTIVITY_TICKS`, opened by the adapter after the
first fire, not a different engine clock.

State the engine holds:

```
stall_ticks     : int     # 0..STALL_FIRE_TICKS (or ACTIVITY once opened)
stall_stage     : int     # 0 idle, 1 fired once, 2 activity window
stall_on        : id|0    # who the current window names; 0 = both
```

Events the engine emits (facts, not rulings):

```
STALL_FIRE              # stall_ticks hit STALL_FIRE_TICKS
STALL_ACTIVITY_EXPIRED  # activity window hit STALL_ACTIVITY_TICKS with no score
STALL_RESET             # counter cleared by a legal reset condition
```

The adapter is the only writer of:

* warning vs stand-up vs mate vs penalty vs +1;
* who `stall_on` names (UWW must pick a colour; IBJJF may name both);
* whether the seat is cleared.

**Tick ownership:** `stall_ticks` increments only while both men are in a
grounded or clinched seat the adapter has marked as stall-eligible. Standing
striking does not run this clock. A standing MMA clinch break is a different
official act; out of scope.

## 5. Refuse

Do not model:

* Referee personality, "quick stand-up refs," or per-official stoppage style.
  One clock, one conversion table per ruleset.
* Video challenge / mat chairman confirmation as a gameplay beat. UWW and IJF
  care; the engine does not.
* IBJJF advantages as engine events. They are a scoring leftover after time,
  not an intervention.
* Golden score as a new method. It is extra time on the same clock fact,
  ending in a score, a submission, or hansoku-make.
* Verbal-tap phonetics, "scream vs tap," or tap-count. `finish_mode` is
  enough.
* Timidity, fleeing the mat, belt-grab standing stall, false attack, and
  kumi-kata legality as extra engine clocks. Those are adapter fouls. If they
  need a timer they rent StallClock or they don't.
* A sixth engine method for DQ, NC, FALL, IPPON, or TECHNICAL SUPERIORITY.
* Changing G34 seats, G34 events, G34 counters, the position-point table, or
  the 19.3% submission rate.

## 6. Open questions

Two. Each has a default. If this page is typed into a build task without an
operator answer, use the default.

**Q1. Does technical submission get its own engine string?**

No. **Default:** `METHOD_SUBMISSION` + `finish_mode`. ABC's "technical" is a
label for unconsciousness or a destroyed joint, which the finish record
already carries. A second engine string would split the one physical fact
G34's rate was measured on.

**Q2. First-fire threshold 400 ticks or 600?**

**Default:** `STALL_FIRE_TICKS = 400` (20s). UWW's 30s is the activity window
that opens after the first fire, not the first fire. If live MMA feel reads as
too twitchy once `GrappleSeat` is running, raise the MMA adapter's first-fire
conversion to "warn at 400, stand at 600" without touching the engine
constant.

## 7. Build contract (what a follow-on task can type from)

1. Add `METHOD_SUBMISSION := "SUBMISSION"` next to the existing four. No other
   new `METHOD_*`.
2. Add `SubmissionFinish` with the fields in §1.4. Wire it as the terminal
   state of a G34 submission attempt. Do not write it through the impact log.
3. Add `StallClock` at 20 Hz with the two integer thresholds in §4. Emit
   `STALL_FIRE`, `STALL_ACTIVITY_EXPIRED`, `STALL_RESET`. Reset rules in §2.5.
4. Each ruleset adapter consumes those three events and performs only the
   conversion in the §2.5 table.
5. Settlement continues to store the engine `METHOD_*` string. Public result
   text is `method_label` from the adapter list in §3.

That is the whole of G35. Scoring stays in G34.

## Appendix A — Source list

1. Association of Boxing Commissions, *Unified Rules of MMA*, August 2026,
   abcboxing.com PDF. Result types; "Standing up or Breaking Fighters";
   referee as sole arbiter; timidity.
2. ABC Officials Handbook / commission restatements of ABC result types: tap,
   verbal tap, technical submission; TKO medical vs referee.
3. GrapplerHQ / FightAlpha compilations of UFC outcome mix on 8,591–8,597
   bouts: KO/TKO ~32.6%, submission 19.3%, decision ~46.8%, other ~1.4%. G34's
   19.3% figure is the same family of snapshot.
4. United World Wrestling, *International Wrestling Rules*, January 2026,
   cdn.uww.org. Arts. 29, 41–43 (victory types, technical superiority 10 FS /
   8 GR), Art. 46 (freestyle passivity, 30s activity, 0–0 at 2:00).
5. IBJJF Rules Book Version 6.1, 2024. Art. 6.2.1 lack of combativeness;
   20-second count; closed-guard and 50/50 examples; penalty ladder Art. 7;
   match-end conditions.
6. IJF Sport and Organisation Rules Art. 11 (mate, including "no evident
   progress" in ne-waza), Art. 17 (osaekomi 20s ippon / 10s waza-ari; 5s yuko
   on 2025 cycle), Art. 18.1 / 18.1.1 (shido, third = hansoku-make, lack of
   combativity). IJF 13 Dec 2024 rule announcement: kumi-kata 30s to attack;
   yuko restored.
7. Herb Dean on stand-ups (post-UFC 319 briefings, 2025): warn first, demand
   effort to finish, superior position is not a protected lease.

## Appendix B — G34 collision watch

Nothing in this document changes a G34 seat, event name, counter, point value,
or the 19.3% rate.

If a later reading of G34's attempt event is missing `attempt_start` or a hold
family, `SubmissionFinish` still needs those two fields. That is an additive
write, not a G34 edit. Flag it to the `GrappleResolve` owner rather than
revising G34 under them.
