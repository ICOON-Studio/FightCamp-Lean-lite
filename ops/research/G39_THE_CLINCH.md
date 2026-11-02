# G39 — THE CLINCH: WHAT IT SCORES, WHAT BREAKS IT, WHAT A THROW FROM IT IS WORTH

**Task:** G39. Research only. Owner: Grok.
**Bar:** G34 contract, G35 stall clock, G37 adapter fold, G38 ground-fight read.
**Engine facts used, not re-derived:** seats `none / over_under / guard / half / side / mount / back`; events `clinch_engage`, `clinch_break`, `takedown`, `throw`, `position_change`, `exposure`, `step_out`, `submission_attempt`; control = 1 unit/s to clinch top, 2 side/mount/back, 1 half, 0 guard and standing; throw graded **2 or 4** from takedown arithmetic; **no amplitude, no landing angle, no "back on the mat" fact** — only landing seat and integer hold ticks. R92 seat: standing → `over_under` (10-tick hold at 20 Hz = **0.5 s gate**), `clinch_break`, THROW writing `throw_points_round`.
**Trap:** unpublished primer numbers ("break at 5 s", "clinch throw is always 2"). Where the current book is silent: **NONE PUBLISHED**.

Delivered by Grok at Expert tier, 2026-09-10; driven in the in-app browser by Claude and committed verbatim from the chat.

---

## 0. Verdict table

| Ruleset | Book (edition) | Clinch / cage control scores? | Referee separates on | Throw from clinch | What the engine can honestly emit |
|---|---|---|---|---|---|
| MMA | ABC Unified Rules of MMA, PDF dated Aug 2026 (amendments 1 Jul 2025 non-substantial; scoring text also ABC MMA Scoring Criteria Clarification, Jul 2025) | **No published point.** Fighting-area control is Plan C only if Plan A is even. Holding a position is not dominance. | "Real, significant and/or sustained effort to advance towards finishing." **No clock.** | A completed takedown with an *impactful result* is Effective Grappling (Plan A). The throw is not a numbered event. | `throw` + landing seat + later damage/sub events → Plan A evidence. Clinch seconds → **not_scored**. |
| Muay Thai | IFMA Rules & Regulations v3.057, revised 11 May 2026; WMC Rules §14–15 (current WMC site text); ABC Pro Muay Thai Unified Rules, Jul 2024 / Nov 2024 impl. | Knees / elbows / sweeps-as-kicks score as **skills**. A dump with no weapon: **not a score** (IFMA 29.2.2; WMC 14.3.5). | YAEK / YAK / YEEK = break. **No published seconds** in IFMA or WMC. "5 seconds" is WFMC / amateur primer, not these books. | Hip / lift / judo-wrestling throw: **foul** (IFMA 31.2.8–10, 31.1.4 semi; WMC 15.2; ABC MT K/N). | Skill strikes from the seat: out of G39 scope (striking bus). `throw` from clinch under MT adapters: **not_scored** or **foul**, never points. |
| Judo | IJF SOR Version 14.08.2026 (cycle 2025–28 text still live) | Kumi-kata itself: **0**. Stall → shido. | Mate on non-combativity / false attack. Conventional grip → attack: **45 s if positive progression** (SOR 18.1.1.4). | Ippon / waza-ari / yuko from **four landing criteria + technique identity**, not from seat alone. | Partial landing-plane heuristic from seat. **Ippon REFUSE.** Force / speed / control-to-end / rolling continuity / Kodokan identity: **REFUSE**. |
| FS / GR | UWW International Wrestling Rules, January 2026 | Body lock / over-under: **0** until a scored action. Passivity is a separate procedure (FS 30 s activity period). | Passivity / negative wrestling / fleeing — not a clinch clock. | Art. 38: 2 to stomach/flank or pass-behind; 4 to danger (short amp or grand amp not to immediate danger); 5 standing grand amp **to immediate danger**. | Grade 2 + guard/half/side-not-danger → **2**. Grade 4 + side/mount/back as danger-proxy → **4** (labelled invention). **5 REFUSE** (needs amplitude). |
| BJJ (adapter only) | IBJJF Rules v6.1, Jun 2024, Art. 4.1 | Standing clinch: **0**. | N/A (match clock). | Takedown 2 if opponent lands back / side / seated and top is held **3 s**. | `throw` + landing seat ∈ {guard, half, side, mount, back} + hold ≥ 60 ticks @ 20 Hz → **2**. |

---

## 1. MMA — ABC Unified Rules (2025/2026 text)

**Books.** *Unified Rules of Mixed Martial Arts*, Association of Boxing Commissions, current published PDF Aug 2026 (lineage: Apr 2001; 2016; procedures 2017–2023; rule changes 23 Jul 2024 impl. Nov 2024; **non-substantial 1 Jul 2025**; further rule changes 5 Aug 2026 requested impl. Nov 2027). Judging language in force for this task: same PDF **Judging Criteria** plus *ABC MMA Scoring Criteria Clarification*, July 2025.

### 1.1 Does clinch / cage control score?

**No published numeric score for "clinch control" or "cage control."**

Clarification Jul 2025 and Unified Rules judging block:

- Plan A — Effective striking / grappling.
- Plan B — Effective aggressiveness ("aggressively making attempts to finish the fight").
- Plan C — Control of the fighting area ("who is dictating the pace, place and position of the bout").
- **Plans B and C are not taken into consideration unless Plan A is weighed as even.**

Effective grappling (Unified Rules judging § e; Clarification "SUCCESSFUL GRAPPLING"):

> successful executions and impactful/effective result(s) coming from: takedown(s), submission attempt(s), achieving an advantageous position(s) and reversal(s).

Clarification: Successful striking and successful grappling are equal; both are measured as a **RESULT**. Damage is "legal fighting techniques, the results of which lessen an opponent's capacity and/or will to compete."

Dominance (Unified Rules scoring note 3; Clarification):

> Merely holding a dominant position(s) shall not be a primary factor in assessing dominance. What the fighter does with those positions is what must be assessed.

Clarification on 10-8: "Significant domination such as positional control without damage is not enough to award a 10-8."

**Finding.** Seconds in `over_under` against the cage, with no strike, no takedown result, no submission attempt, are Plan C at best and **not_scored** as an event. They do not become "+1 at 5 s."

### 1.2 What the referee separates on, and after how long

Unified Rules, **Standing up or Breaking Fighters**:

> The Referee shall either stand up or break the fighters when neither fighter is able to or fails to demonstrate real, significant and/or sustained effort to advance towards finishing the fight by any method. Simply maintaining what may be perceived as a superior position will not be considered effort to advance towards finishing the fight nor grounds for a guaranteed opportunity to maintain that position.

**NONE PUBLISHED** for a second-count. Not 5 s. Not 10 s. The test is effort-to-finish, same standing or grounded.

### 1.3 Is a throw from the clinch a "takedown" for Effective Grappling?

Yes, **if it is a successful takedown with an impactful result**. The book lists "takedown(s)" inside Effective Grappling. It does not publish a point value for the throw, does not distinguish hip throw vs trip vs body lock, and does not say "a clinch throw is always a takedown the judges must credit." A throw that produces no damage, no advantageous position kept, no submission attempt, is a change of place — Plan A only if the *result* is impactful.

Legal-throw note (state adoptions of the Unified Rules, e.g. NM 15.6.20): "Any throw with an arc to its motion is to be considered a legal throw" except pile-driver. That is a **foul/legal** line, not a score line.

**Engine:** emit `throw` + grade + landing seat. ABC adapter records it as a Plan A *evidence token*, not a point. `not_scored` as a number.

---

## 2. Muay Thai — IFMA / WMC / ABC Pro MT / stadium

**Books.**

- IFMA *Rules and Regulations* v3.057, revised **11 May 2026** (Rules 26, 29, 31).
- WMC Rules, current official pages: **§14 Scoring System**, **§15 Fouls**, **§9 Referees**.
- ABC *Unified Rules of Professional Muay Thai*, approved Jul 2024, requested impl. Nov 2024.
- Stadium practice (Rajadamnern / Lumpinee / typical Thai stadium cards): **no English numbered break-clock found**. Do not substitute a primer.

### 2.1 What scores in the clinch

**IFMA 29.1.** A Muaythai skill is "a punch, kick, knee or elbow applied with force and intent to cause effect." One score per skill that hits a scoring target unblocked and legal.

**IFMA 29.2.2 Non-Awarding of Points** includes, quoted:

> Throwing the opponent without striking.

**WMC 14.1.** Score when fists, feet, knees, elbows hit "powerfully, accurately, unprotected, and according to the rules."

**WMC 14.3.5** — scoring advantage is **not** awarded for:

> Throwing the opponent on the floor without using any muaythai weapon.

Knees and elbows from the plum / over-under are skills. A sweep that is a **kick** (top of foot / shin) can be a skill if it lands with effect (ABC Pro MT foul J makes that kick-sweep legal; hooking with the *side* of the foot is the illegal reading). Off-balancing that is only a shove: **NONE PUBLISHED** as a point.

### 2.2 What is illegal

| Action | IFMA May 2026 | WMC §15 | ABC Pro MT Jul 2024 |
|---|---|---|---|
| Judo / wrestling throw, hip toss, lift | 31.2.9 lifting by the body; 31.1.4 semi: "Throwing an opponent using the hip"; "Tackling the opponent's body or legs" | **15.2** "Throwing, back breaking, locking the opponent's arms, using Judo and wrestling techniques." | K. "Hip, shoulder, or leg throws (No hip tosses, grape vining, reaping, or lifting an opponent)." N. "Wrestling, back or arm locks or any similar judo or wrestling hold." |
| Hook / immobilise legs with calf, ankle, heel | **31.2.8** foul | not separately listed (covered by 15.2 / 15.11) | J: trip/sweep legal **only** as a kick with top of foot or front of shin, not side of foot |
| Hold a caught leg and walk | **31.2.19** more than **two steps** without a Muaythai skill | **15.7** more than **two steps** without weapons | same two-step cap in the ABC MT family |
| Joint lock | **31.2.10** | 15.2 | N |

So: a R92 THROW that is a hip throw / lift / body-lock suplex is a **foul** under all three books, not a 2.

### 2.3 The referee's break — "5 seconds"

**IFMA 26.3.** Commands: YOOT (stop), **YAEK (break a clinch)** — each athlete steps back and waits for CHOCK. **31.2.21–22** make ignoring YAEK a foul.

**WMC §9.** YUD / **YAK** / CHOK. Same mechanic. No seconds.

**NONE PUBLISHED** in IFMA v3.057 or WMC §9/14/15 for "break after 5 seconds."

Where "5 s" *is* printed: WFMC Rulebook Oct 2024 ("Clinching is allowed for a maximum of 5 seconds"); Western amateur / "unified kickboxing" primers (3–5 s). Those are **not** WMC, **not** IFMA, **not** a Thai stadium statute. G37 precedent: do not import them.

### 2.4 Stadium vs IFMA

Thai stadium judging historically weights late-round clinch knees, off-balance, and dumps that look like Muay Thai more than IFMA's skill-counter. That is culture and commentary. It is **not** a published article with a number this task can bind the engine to. Adapter stays on IFMA/WMC text: dump without a weapon = `not_scored`; dump that is a hip/judo throw = `foul`.

---

## 3. Judo — IJF SOR 2025–28 (current file: SOR 14.08.2026)

**Book.** *IJF Sport and Organisation Rules*, English version **14.08.2026** (also circulated as 24.07.2026 / 21.01.2026 in the same cycle). Scoring and penalties live in Arts. **14, 15, 18**.

### 3.1 Kumi-kata

SOR **18.1.2** (normal kumi-kata): left hand on uke's right judogi (sleeve / collar / chest / top of shoulder / back), right hand on the left side, always above the belt, or vice versa. Non-classical grips (collar-and-lapel, one-side, cross, belt, pocket, pistol) are allowed **when the attitude is positive**. Same grip used to force a bent, blocking posture → shido.

Grip break (**18.1.2.15**): break with one or two hands **and keep at least one grip** = legal. Two-hand break that leaves **no** grip = shido.

Bear hug (**18.1.2.25**): allowed if hands are not clasped into a circle. Clasped hands/arms forming a circle = shido (exception if a stable kumi-kata already existed, or ne-waza → tachi-waza transition).

Leg grab below the top of the inner thigh / trousers / hooking the leg with the hand = shido (cycle 2025–28 standing rule).

### 3.2 Standing stall

**18.1.1.2 False attack** (no intent to throw; attack without / immediately releasing kumi-kata; fake with no kuzushi; blocking leg between uke's legs).

**18.1.1.4 Lack of combativity:**

> In a standing position, after the referee announced "Hajime!" and after kumikata has been established, not to make any attacking moves. The time between conventional kumikata and making an attack is **45 seconds if there is a positive progression**.

Federation primers for the 2025 cycle also say **30 s** after classic hikite + tsurite. The **SOR sentence in the 2026 English file is 45 s if positive progression.** Use 45. The 30 s figure is a seminar shorthand, not a second published clock we can treat as a different article.

No "clinch stall at 5 s." Mate is a referee judgement plus the 45 s progression test.

### 3.3 Ippon / waza-ari / yuko from a throw — what a seat+hold can and cannot do

**Art. 14 Ippon** (nage-waza). Four criteria together: **speed, force, on the back, skilfully controlled until the end of the landing.** Rolling is ippon only with no break in the landing.

**Art. 15 Waza-ari.** Landing more than 90° of the shoulder axis but not on the back; or the four ippon criteria not fully achieved. Whole-side landing; shoulder position is what is read.

**Art. 15 Yuko** (reintroduced this cycle). Includes: side landing at 90° or more toward the front; landing on upper back; side on the shoulder axis plus one elbow or one hand; both buttocks near 90°; one buttock; landing on the neck. **No yuko** if the front of the stomach, front of both hips, or both knees touch first; **no yuko** if two elbows / two arms / two hands touch simultaneously with the buttock(s) or side.

**Osaekomi (Art. 7 / ne-waza table, same cycle):** yuko 5–9 s, waza-ari 10–19 s, ippon 20 s. That clock is **osaekomi**, not "time the throw was kept." It only starts on a Kodokan-recognised hold-down from the top.

**Honest derive from engine facts**

| Engine fact | Can derive? |
|---|---|
| Landing seat `side` | Weak yuko-plane candidate (90° side). **Invention** if we emit yuko. |
| Landing seat `mount` / `back` | Plane is "more on the back" than side — waza-ari *candidate* only. Still missing speed, force, control-to-end, single landing, technique identity. |
| Hold ticks after the throw | **Not** nage-waza. May become osaekomi **only** if the seat is a real osaekomi-waza (side / kesa-like / mount) and we already accepted that fold in G38. Guard / half are not osaekomi. |
| Grade 2 vs 4 | **Not** an IJF criterion. Refuse as an ippon/waza-ari switch. |

**REFUSE (nage-waza from clinch throw):** speed; force / ikioi; control to the end of landing; "largely on the back" vs shoulder-axis 90°; rolling continuity; whether the action is a Kodokan nage-waza at all; two-landing vs one-landing; head-defence / bridge (bridge landing is still ippon in the cycle notes — we have no bridge fact).

**Default if the operator wants any nage number at all (invention, labelled):** `side` → yuko; `mount`/`back` → waza-ari; never ippon from seat+grade. Otherwise emit `not_scored` for the throw and let only osaekomi ticks (G38) score.

---

## 4. Freestyle and Greco — UWW January 2026

**Book.** *International Wrestling Rules*, United World Wrestling, **January 2026** (Bureau letter 12 Dec 2025: English text is the official reference; in force 1 Jan 2026). Scoring: Arts. **34–38**.

### 4.1 Upper-body clinch scoring

There is **no article that awards points for holding a body lock**. Points start when an Art. 38 action is completed.

**Art. 37 Grand Amplitude.** Standing or parterre action that causes the opponent to lose all contact with the ground, is controlled, describes a **broadly sweeping curve in the air**, and is brought to the ground.

**Art. 35 Danger position.** Line of the back / shoulders at an angle **less than 90°** to the mat while resisting a fall. 90° exact = "neutral point," not danger. Chest/stomach facing the mat ends danger.

**Art. 38 values (standing-relevant):**

- **2 points**
  - Overcome and control by passing behind (three of seven contact points on the mat: hands, knees, head, elbows).
  - "Correct and complete throw that brings the opponent into a **prone position (stomach) or lateral position (flank)**. The defensive wrestler must lose control during the throw."
  - Hold that places the opponent's back at **< 90°**, including on one or two outstretched arms.
- **4 points**
  - Standing hold that brings the opponent into danger **in a continuous and dynamic manner**.
  - Lift from the ground into danger over a **short amplitude** (even if attacker's knee(s) are down).
  - Grand amplitude hold that does **not** place the opponent in a **direct and immediate** danger position.
  - Throw from standing or parterre, opponent completely lifted, lands on chest or one/two outstretched arms, short amplitude.
- **5 points**
  - Standing **grand amplitude** that places the defender in a **direct and immediate danger position**.
  - Parterre high-amplitude lift into direct immediate danger.

The Dec 2025 commentary note on "two-point throw" (opponent thrown directly onto stomach or side with loss of control) matches Art. 38's 2-point stomach/flank line. It is not a new third scale.

### 4.2 What grade 2 or 4 + a landing seat can tell

| Wanted UWW score | Engine can tell? |
|---|---|
| 2 — pass-behind / takedown control | **Partial.** Landing `guard` / `half` + control ticks ≈ stomach/flank or "not danger." Label invention if we also require "lost control during the throw" (no engine fact). |
| 2 — throw to stomach / flank | **Partial.** Seat `guard` (and maybe `half`) as flank/prone proxy. |
| 4 — continuous dynamic standing action to danger | **Partial / invention.** Grade 4 + seat `side` / `mount` / `back` as danger-proxy (`back`/`mount` ≈ shoulders toward mat). Missing "continuous and dynamic" and the <90° measurement. |
| 4 — short-amplitude lift to danger | **REFUSE amplitude.** We do not have "left the mat." |
| 4 — grand amp *not* to immediate danger | **REFUSE amplitude.** |
| 5 — standing grand amp *to* immediate danger | **REFUSE.** Needs Art. 37 curve + feet-off-mat + immediate danger. Grade 4 is not 5. |

Greco: same Art. 38 table; legs may not attack. A R92 clinch throw that is a body lock / throw-by is the Greco vocabulary. The point table does not change.

---

## 5. Duration — sourced, not felt

Rulebooks do not publish mean clinch length. Time-motion papers do. Use them only to **check** the 10-tick gate and a stall threshold, not to invent a score.

| Source | What it measured | Number |
|---|---|---|
| Miarka et al. family / BR TMA of MMA bouts (clinch as a situation, men) | **Total** clinch time per bout / per round, not per instance | Bout clinch ≈ **2:00 ± 1:48**; per round ≈ **0:48 ± 0:50** |
| Del Vecchio, Hirata, Franchini 2011, regional MMA TMA | High-intensity *standing* sequences (not named "clinch instance") | **6–9 s** high-intensity standing sequences |
| Bloody Elbow / UFC cage-size note (2015, Zuffa 2001–2015) | Share of fight time in clinch, small vs large cage | Clinch share **+2.3 pp** in 25′ cage; most of it fence control. Not seconds-per-clinch. |
| Cappai et al. 2012, *J Sports Med Phys Fitness* — amateur MT | Clinch-attack time per **120 s** round | **24.58 ± 4.64 s** (20.4 % of the round). Again total, not per instance. |
| IFMA / WMC | Per-clinch seconds | **NONE PUBLISHED** |
| IJF SOR 18.1.1.4 | Grip → attack if positive progression | **45 s** |
| UWW FS | Activity period after passivity | **30 s** (fail to score → 1 pt to opponent) |
| IBJJF Art. 4.1 | Stabilisation after takedown | **3 s** |

**Against the R92 gate.** 10 ticks @ 20 Hz = **0.5 s**. That is shorter than every published sequence above. It is a *debounce*, not a score duration. Keep it.

**Against a clinch-stall threshold.**

- ABC: no clock. G35's 400 ticks = 20 s is an engine stall fire, **not** an ABC article. Using it as the ABC `clinch_break` trigger is an **invention**. Safer ABC rule: break when both sides emit no strike / no position improvement / no throw attempt for N ticks, with N labelled invention. Do not print "5 s."
- MT: no clock in IFMA/WMC. Same.
- IJF: 45 s with positive progression is the published standing number. A dead over-under with no attack is 18.1.1.4, not G35's 20 s.
- UWW: passivity procedure, not a clinch timer. FS 30 s activity period is the only published standing inactivity clock.

---

## 6. REFUSE list

Every clinch fact we **cannot** derive from (seat ∈ {over_under, guard, half, side, mount, back}, hold ticks, throw grade ∈ {2, 4}). A refusal is a finding (G37 §4).

1. Amplitude / "feet above head" / "broadly sweeping curve" (UWW Arts. 37–38 **5**, and the 4-point grand-amp-not-to-danger branch).
2. Landing angle in degrees; "back on the mat"; shoulder-axis 90° vs <90° vs full back (IJF 14–15; UWW 35).
3. Force, speed, control-to-the-end-of-landing, rolling continuity, Kodokan technique identity (IJF 14).
4. Who crossed a line first (already refused in G37 for UWW step-out).
5. ABC "damage" as a numeric (Clarification Jul 2025 is qualitative).
6. ABC / IFMA / WMC **seconds until the referee breaks** a working or idle clinch.
7. "+1 at 5 seconds" of cage control, clinch control, or plum control.
8. "A clinch throw is always 2."
9. MT dump-as-style-point under stadium custom.
10. UWW 4-point "short amplitude lift" branch (needs off-the-mat).
11. Whether a bear hug clasped into a circle (IJF 18.1.2.25) — no hand-clasp fact.
12. Whether the throw used a hip / lift / reap (MT foul test) — no technique-class fact beyond `throw`.
13. IBJJF "seated" vs "all-fours / belly-down then back-control" fork (Art. 4.1.1 vs 4.1.2) — seats do not include "seated" or "turtle."

---

## 7. Engine recommendation (G34 vocabulary only)

### 7.1 What the engine emits

| Event | When | Payload |
|---|---|---|
| `clinch_engage` | Standing → `over_under` and the 10-tick gate held | top id (better lock), seat=`over_under` |
| control units | While seat stays `over_under` | **+1 / s** to the clinch top (G34) |
| `throw` | Clinch ends by a throw that the takedown arithmetic already grades 2 or 4 | `grade: 2\|4`, `landing_seat: guard\|half\|side\|mount\|back`, `hold_ticks` once the landing seat is kept |
| `takedown` | Same action if the existing writer already emits it; do not double-count in an adapter | existing |
| `clinch_break` | Referee / effort-test / stall / YAEK / both separate without a throw | `reason: effort\|stall\|command\|mutual` |
| `position_change` / `exposure` | Unchanged from G34/G38 after landing | existing |
| `submission_attempt` | Unchanged | existing |

Do **not** emit a synthetic `clinch_points` event. Adapters fold what the book publishes.

### 7.2 Adapter fold (G37 table shape)

`not_scored` = the book publishes no number. Invention cells are marked **INV**.

#### abc (Unified Rules MMA + Jul 2025 clarification)

| Emit | Converts to | Notes |
|---|---|---|
| `clinch_engage` | `not_scored` | Plan C only if Plan A even; not an event score |
| control units @ 1/s | `not_scored` | "Merely holding a dominant position shall not be a primary factor" |
| `throw` grade 2 or 4 + any landing seat | `effective_grappling_token` **INV** (still `not_scored` as a point) | Takedown is named inside Plan A; no published 2/4 |
| subsequent strikes / `submission_attempt` from the landing seat | Plan A evidence (existing striking/sub buses) | This is what the book actually weighs |
| `clinch_break` reason=effort | `not_scored` | Standing-up/Breaking paragraph; no clock |

#### ijf (SOR 14.08.2026)

| Emit | Converts to | Notes |
|---|---|---|
| `clinch_engage` / control units | `not_scored` | Kumi-kata is not a score |
| `throw` + `landing_seat=side` | `yuko` **INV** or `not_scored` | Default **INV yuko**. Operator Q1. |
| `throw` + `landing_seat=mount\|back` | `waza-ari` **INV** or `not_scored` | Default **INV waza-ari**. Never ippon. |
| `throw` + `landing_seat=guard\|half` | `not_scored` | Front/stomach/knees-first is explicitly no yuko |
| grade 2 vs 4 | ignored | Not an IJF criterion |
| hold ticks on side/mount after throw | osaekomi table via G38 only | 5–9 yuko / 10–19 waza-ari / 20 ippon |
| no attack for 45 s after engage, no positive progression | `shido` **INV** as a mapping of 18.1.1.4 | Do not use G35's 20 s here |
| false-attack pattern | `shido` only if a false-attack event exists; else **REFUSE** | 18.1.1.2 |

#### uww (International Wrestling Rules Jan 2026, Art. 38)

| Emit | Converts to | Notes |
|---|---|---|
| `clinch_engage` / control units | `not_scored` | No body-lock point |
| `throw` grade 2 + `guard\|half` | **2** | Art. 38 stomach/flank / pass-behind proxy |
| `throw` grade 2 + `side\|mount\|back` | **2** (danger-without-amp branch) | Art. 38 "back < 90°" proxy. Conservative: stay at 2 unless grade is 4. |
| `throw` grade 4 + `side\|mount\|back` | **4** **INV** | Standing-to-danger proxy. Not 5. |
| `throw` grade 4 + `guard\|half` | **2** | Landing is not danger. |
| any throw → 5 | **REFUSE** | Needs Art. 37 amplitude |
| `clinch_break` | `not_scored` | Passivity is a different procedure (FS 30 s activity period) |

#### ibjjf (Rules v6.1 Jun 2024 Art. 4.1)

| Emit | Converts to | Notes |
|---|---|---|
| `clinch_engage` / control units | `not_scored` | Standing is 0 |
| `throw` + landing seat ∈ {guard, half, side, mount, back} + hold ≥ **60 ticks** (3 s @ 20 Hz) | **2** | Art. 4.1.1 back/side/seated + 3 s top. Seats we have are a subset; turtle fork 4.1.2 **REFUSE**. |
| same throw, hold < 60 ticks | advantage **INV** or `not_scored` | Book allows advantage for a takedown not held 3 s. Default `not_scored` unless G37 already folds advantages. |
| then side / mount / back kept 3 s | existing G38 position points (3 pass / 4 mount / 4 back) | Do not re-score the throw |

---

## 8. Open questions (two, each with a default)

**Q1. IJF nage-waza from seat.** Emit the INV heuristic (`side`→yuko, `mount`/`back`→waza-ari, never ippon) or refuse all nage scores from a clinch throw?
**Default:** heuristic, every cell labelled **INV**. Ippon stays REFUSE. Matches "what good looks like": derive what the seat can honestly suggest, refuse the rest.

**Q2. ABC / IFMA clinch_break clock.** Bind `clinch_break reason=stall` to G35's 400 ticks (20 s) or leave break as a pure effort-test with no tick trigger?
**Default:** **no tick trigger** in abc and the MT-facing path. G35's 20 s remains the ground stall it was written for. IJF uses 45 s (18.1.1.4). UWW keeps its own passivity procedure. Do not mint a 5 s MT break.

---

## 9. Ready-to-paste const blocks

```gdscript
# G39 — adapter fold for clinch / throw. not_scored = book publishes no number.
# INV = invention mapping from seat+grade only. REFUSE = do not emit.

const CLINCH_GATE_TICKS := 10          # 0.5 s @ 20 Hz. Debounce, not a score.
const CONTROL_UNITS_CLINCH_TOP := 1    # per second. G34.

const ABC_CLINCH := {
	"clinch_engage": "not_scored",
	"control_units": "not_scored",
	"throw": "effective_grappling_token",  # INV; still not a point value
	"throw_points": "not_scored",
	"clinch_break": "not_scored",
	"break_ticks": null,                   # NONE PUBLISHED
}

const IJF_CLINCH := {
	"clinch_engage": "not_scored",
	"control_units": "not_scored",
	"throw_guard": "not_scored",
	"throw_half": "not_scored",
	"throw_side": "yuko",                  # INV (Q1 default)
	"throw_mount": "waza_ari",             # INV (Q1 default)
	"throw_back": "waza_ari",              # INV (Q1 default)
	"throw_ippon": "REFUSE",
	"use_grade_for_score": false,
	"kumi_attack_shido_s": 45,             # SOR 18.1.1.4
	"osaekomi": {5: "yuko", 10: "waza_ari", 20: "ippon"},  # G38
}

const UWW_CLINCH := {
	"clinch_engage": "not_scored",
	"control_units": "not_scored",
	"throw": {
		"grade2_guard": 2,
		"grade2_half": 2,
		"grade2_side": 2,
		"grade2_mount": 2,
		"grade2_back": 2,
		"grade4_guard": 2,
		"grade4_half": 2,
		"grade4_side": 4,                  # INV danger-proxy
		"grade4_mount": 4,                 # INV
		"grade4_back": 4,                  # INV
	},
	"grand_amplitude_5": "REFUSE",
}

const IBJJF_CLINCH := {
	"clinch_engage": "not_scored",
	"control_units": "not_scored",
	"throw_points": 2,
	"hold_ticks_required": 60,             # 3 s @ 20 Hz, Art. 4.1
	"short_hold": "not_scored",            # default; advantage is INV
	"turtle_fork": "REFUSE",
}
```

---

## Sources (edition + article)

- ABC *Unified Rules of MMA*, published PDF Aug 2026 (amendments 1 Jul 2025; judging block "Effective striking/grappling / Standing up or Breaking Fighters").
- ABC *MMA Scoring Criteria Clarification*, July 2025 (Damage / Dominance / Duration / Successful Grappling / Fighting Area Control).
- IFMA *Rules and Regulations* v3.057, 11 May 2026, Rules 26.3, 29.1, 29.2.2, 31.1.4, 31.2.8–10, 31.2.19, 31.2.21–22.
- WMC Rules §9 (YAK), §14.1 / 14.3.5, §15.2 / 15.7.
- ABC *Unified Rules of Professional Muay Thai*, Jul 2024, fouls J, K, N.
- IJF *Sport and Organisation Rules*, Version 14.08.2026, Arts. 14, 15, 18.1.1.2, 18.1.1.4, 18.1.2.15, 18.1.2.25; osaekomi 5 / 10 / 20 s.
- UWW *International Wrestling Rules*, January 2026, Arts. 35, 37, 38.
- IBJJF Rules Book Version 6.1, June 2024, Art. 4.1.
- Duration: Cappai et al. 2012 (MT clinch-attack time per round); Del Vecchio et al. 2011 (MMA high-intensity standing sequences); Miarka-family MMA TMA (total clinch time per bout/round).

*End G39.*
