# J15 — THE KNOCKDOWN CLOCK (how long is a knockdown, and what fills the time)

**Desk:** John (research). **Assigned:** 2026-09-10. **Verification date for every live URL:** 2026-09-10.  
**Status:** study only. No GDScript. No enum. No referee state machine.  
**Scope:** professional boxing knockdown as a **timed pause** (canvas-touch to fight-live-again). Professional MMA treated separately and briefly: it is **not** the same event. Amateur cited only where a discarded professional device still lives, or where a cadence gap is written that ABC Unified does not write.

**Grade legend (same as J14):**

| Grade | Meaning |
| --- | --- |
| **DIRECT** | Quoted or paraphrased from a primary rule, statute, or official mechanics manual fetched 2026-09-10. |
| **INHERITED** | Follows from a DIRECT text without adding a new rule. |
| **UNVERIFIED_SECONDARY** | Journalism, Wikipedia, aggregator, or a handbook that restates rules without being the promulgating text. Not used as current law. |
| **UNKNOWN** | Not found, conflicting, not in force yet, or true only if a night’s rules meeting says so. |

An invented duration that looks sourced is worse than an admitted gap. Gaps are listed in § UNKNOWN.

**Default (cite J14; do not re-derive):** professional boxing in-ring baseline = Association of Boxing Commissions **Unified Rules of Boxing**, approved 25 August 2001, last amended **3 August 2016** (J14 **R1**). Mechanics of the count, send, gait, wipe, and wave-on = ABC **Boxing Referee Manual, Rev. 08/2025** (J14 **R1**). Standing eight is **not** current professional ABC (J14 **R4**). Three-knockdown automatic stop is **not** ABC Unified Rule 8; it **is** WBA Contest Rule 12 (J14 **R5**). MMA has **no** ten-count, **no** mandatory eight, **no** standing eight (J14 **R7**). Local commission can override; differences are **named**, not tabulated (J14 **R3**).

---

## Decisions

These are research-desk decisions about **what the sources say**, not engine design. Ten lines.

1. **Clock they build to (ordinary continuing knockdown, canvas-touch → fight live again):** **about 10–25 seconds.** Not a published statute. **INHERITED** from 1-second cadence + mandatory eight + glove wipe + a short fitness check. Shortest legitimate bounce-up still eats the full eight **plus** wipe (~**10–12 s**). Longest ordinary (slow rise, gait, questions) ~**20–25 s**. WBO “all the time needed,” a corner-pause, mouthpiece replace, or doctor consult can run longer; those are not the ordinary clock.
2. **“Eight” is the eighth one-second count number**, not eight wall-clock seconds from canvas. The official count is the **referee’s**, picked up from the timekeeper after (or while) sending the standing fighter; it **pauses** if that fighter leaves the farthest neutral corner (J14 already refused “ten wall-clock seconds from canvas”).
3. **Rose-from vs did-not is not a skip-eight category under ABC.** Bounce-straight-up still gets the full mandatory eight. He **may** take the count on the floor **or standing**. Wisconsin Muay Thai “flash knockdown” (SPS 192.79(2)) is **not** boxing default.
4. **Downed-fighter body states (distinct filmable / clip-buy):** (1) falling; (2) land-on (glove / knee / seat / back / face / all-fours); (3) on-canvas taking count; (4) ropes-only / hanging / held-up; (5) voluntary knee; (6) rising, including **act-of-rising still legally down**; (7) soles-only but bent over (no longer downed); (8) standing taking the count; (9) gait-test walk; (10) one-step toward the referee; (11) glove-wipe stance; (12) ready / “box”; plus wave-off still-down (stoppage, not a continue).
5. **Other fighter:** referee sends him to the **farthest neutral corner**; he stays until ordered to box. If he does not go / leaves, the **count stops** and resumes where interrupted. Timekeeper may already be counting before he arrives; the **referee’s** count is official.
6. **MMA knockdown is not a discrete timed event.** No ten-count, no mandatory eight, no standing eight (J14 **R7**). Grounded opponent may be punched. No timeout to inspect a legal strike except laceration. Usable finding: **the clock is boxing-only.**
7. **How often (knockdowns per pro bout / share of bouts with ≥1):** **not found.** Do not use zipdo.co’s “1.2 per fight / 44% of rounds.” KO/TKO as a **bout result** is published; it is not this clock.
8. **Refuse:** standing eight as current pro ABC; 3KD auto-stop as ABC default; MMA ten-count; “the count is ten (or eight) wall-clock seconds from canvas”; “up at seven you automatically continue”; flash-skip-eight as boxing default; zipdo knockdown rates; a referee object, enum, or state machine.
9. **Out-of-ring 20-count, apron 10-count, ABC Manual mandatory-18, and the 5-minute foul/medical windows are different clocks.** Do not fold them into the ordinary knockdown range.
10. This memo does **not** design code.

---

## False premises in the brief (correct first)

The brief’s questions are the right questions. These readings of them would be wrong:

| Premise | Correction | Grade |
| --- | --- | --- |
| A knockdown lasts eight (or ten) **wall-clock** seconds from canvas. | Cadence is **one-second intervals**. “Eight” is a **count number**. Pick-up delay and corner-pauses mean canvas→“eight” is **not** guaranteed to be eight seconds. J14 already listed “the count is ten wall-clock seconds from canvas contact” as refused folklore. | DIRECT (cadence + pause). INHERITED (therefore not a wall-clock eight from canvas). |
| Standing eight is how a referee “saves” a hurt standing pro, or is “the count.” | **No.** ABC Unified Boxing Rule 7 (2016): “There is NO Standing Eight (8) Count.” Amateur only (J14 **R4**). This memo does not reopen it. | DIRECT (J14 **R4**). |
| Bounce-up skips the mandatory eight, or “rose-from” is a separate rules category that shortens the clock. | ABC Unified Rule 5: mandatory eight after knockdowns is **standard procedure in all bouts.** NAC 467.740(2): may not resume until the referee has **finished counting to eight**; may take the count **on the floor or standing**. Rise at two still waits for eight. | DIRECT. |
| MMA has a knockdown clock analogous to boxing. | NAC 467.740(9): boxing count **does not apply** to MMA. Unified MMA stoppage = intelligent defense / (Nevada) unconsciousness. **Not a discrete timed event.** | DIRECT (J14 **R7**). |
| Three knockdowns in a round always ends it, so the clock is truncated by a 3KD rule. | Not ABC (Rule 8). **Is** WBA Rule 12. Named, not default (J14 **R5**). | DIRECT. |
| Knockdown = three points of contact. | WBC 2016 championship checklist only. ABC/NAC/WBA/WBO: any part but the feet, or ropes. Do not universalize (J14). | DIRECT. |

J14 cite correction, not a reopening: J14 pointed at Wisconsin **SPS 192.79** for the professional boxing count. **SPS 192.30** is boxing (Subchapter IV). **SPS 192.79** is Muay Thai (Subchapter VII). The 1-second-before-“one” sentence **is** in boxing SPS 192.30(3)(a). The **flash-knockdown skip** is **only** in Muay Thai SPS 192.79(2). Standing-eight prohibition for Wisconsin **professionals** is in both (boxing 192.30(6); Muay Thai 192.79(7)). The standing-eight **binding** does not move.

---

## J14 bindings used here (cite; do not re-derive)

From `/workspace/j15/J14_THE_REFEREE.md`, fetched-and-bound 2026-09-10:

- **R1 / R4.** Default pro boxing = ABC Unified Boxing (last amended 3 August 2016) + ABC Referee Manual Rev. 08/2025. **Standing eight is not current professional ABC.** It survives in amateur (USA Boxing 1 Jan 2026; World Boxing Nov 2024).
- **R5.** **Three-knockdown automatic stop is not ABC Unified Rule 8.** It **is** WBA Contest Rule 12 (amended 22 April 2024). Ontario splits championship / non-championship. Do not install 3KD as the professional default.
- **R7.** Professional MMA: **no ten-count, no mandatory eight, no standing eight.** Nevada NAC 467.740(9): boxing count “do[es] not apply” to MMA. Stoppage language is intelligent defense (ABC MMA) / unconsciousness (Nevada KO).
- **R3.** No jurisdiction matrix. Default common practice plus **named** differences.
- J14 do-not-build still in force here: no referee object; no “current standing eight” as pro-default; no “three knockdowns = TKO” as pro-default; no “the count is ten wall-clock seconds from canvas”; no “rise at seven and you automatically continue”; no MMA ten-count.

This memo adds the **clock**, the **body states**, the **other fighter’s station**, the **MMA non-event**, and the **frequency** question. It does not redesign the referee.

---

## 1. HEADLINE — how long is a knockdown in seconds

**Question:** canvas touch → fight live again. Parts: ref reaching + starting the count; cadence (is “eight” eight seconds? pace variance); mandatory eight even when up immediately; referee check (questions, glove wipe, eyes); wave-on. Realistic shortest–longest **ordinary** knockdown. That range is the number they build to.

**Answer they build to:** **about 10–25 seconds** for an ordinary knockdown that **continues**. Grade of the **range**: **INHERITED**. No primary text publishes “a knockdown lasts *n* seconds.” The range is the sum of acts the texts **do** publish.

### 1.1 What starts the clock

A legal knockdown, as the referee determines it, is **not** “any fall.”

**DIRECT — ABC Referee Manual Rev. 08/2025, KNOCKDOWNS:**

A knockdown occurs when, as determined by the referee:

1. As a result of a legal blow or blows:
   - a boxer touches the canvas with any part of their body other than the soles of their feet;
   - a boxer is hanging defenselessly on, through, or over the ropes; and/or
   - only the ropes are preventing a boxer from being knocked down.
2. A boxer **voluntarily** goes down (e.g. takes a knee).

When struck by a legal blow(s) and going down, the referee should command **“Down!”** and point to the canvas.

**DIRECT — ABC Unified Boxing Rule 5 (2016):** “The Mandatory Eight (8) Count after knockdowns will be standard procedure in all bouts.”

**DIRECT — NAC 467.760 (HTML rev. 4/13/2026):** down = any part other than the feet on the floor; hanging over the ropes without the ability to protect himself and cannot fall; or would have fallen but was held up by the ropes. **Does not apply to MMA** (467.760(3)).

A slip is **not** this clock. ABC Manual, SLIPS: wave both hands criss-cross at/below the waist, “No Knockdown” / “Slip.” Ontario §14.5: same criss-cross, “no knockdown.” Glove wipe still happens after a slip (NAC 467.735; Ontario §14.12) — that is a **short scenery beat**, not a mandatory eight.

### 1.2 Reaching, sending, starting — the seconds before “one”

Three clocks are in the room. They are not the same.

| Who | When they start | Grade |
| --- | --- | --- |
| **Knockdown timekeeper** | **Immediately** on the down, one-second intervals, loud, arm/fingers, until the referee takes the count or waves it off. | DIRECT — Ontario §14.2–14.3. Wisconsin SPS 192.30(3)(a): timekeeper immediately. NAC 467.740(2): timekeeper gives the referee the correct 1-second interval. |
| **Referee** | ABC Manual: **direct the standing boxer to the farthest Neutral Corner and then pick up the count from the Timekeeper.** Ontario §14.6–14.7: after calling “down,” order the opponent to the farthest neutral corner, **thereafter** pick up from the knockdown timekeeper. | DIRECT. Send **then** pick up is the ABC/Ontario order. |
| **NAC 467.740(1)** | Referee shall order the opponent to the farthest neutral corner **and shall immediately begin the count** over the one who is down. Audible seconds; arm; downward motion = end of each second. | DIRECT. NAC writes “immediately begin” in the same sentence as the send. Slightly different **order** than the Manual’s “then pick up.” Both: the **referee’s count is official**; once he picks up, the timekeeper ceases (NAC 467.740(2)). |

So: the timekeeper can be on “two” or “three” before the referee’s mouth is in the count. The referee **joins** the timekeeper’s number; he does not restart at one. **UNKNOWN** as a measured average how many seconds the send takes. The texts say immediately / thereafter, not “after *n* seconds.”

**Does the count start before the standing fighter goes?**

- **Timekeeper:** yes, immediately (Ontario; Wisconsin).
- **Referee’s official count:** ABC Manual implies **after** the send. NAC says begin immediately **and** send. If the standing fighter **fails to stay**, the referee **shall** (NAC, WBO, WBA) / **may** (Ontario §14.11) **cease counting** until he is back, then resume **where interrupted**. A count that started is not a count that finishes.

**Amateur / Wisconsin gap before “one” — named, not ABC Unified.**

- USA Boxing 19.2 (rev. 1 Jan 2026) and World Boxing 8.6.3: **before “one,” one second must have elapsed** from the knockdown.
- Wisconsin **SPS 192.30(3)(a)** (professional **boxing**): same sentence.
- ABC Unified 13-point list **does not** write that gap. ABC Referee Manual: pick up the timekeeper, not “wait one extra second.” J14 already flagged this as **UNKNOWN** for a given ABC-jurisdiction referee.

IBA Referee-Judge Regulations 2023 (amateur): send the uncounted boxer to the neutral corner **while allowing one second to pass**, then begin. Different sport.

### 1.3 Cadence — is “eight” eight seconds? Pace variance

**DIRECT — the interval is one second:**

- NAC 467.740(2): timekeeper gives the **correct 1-second interval**. Referee’s count is official.
- Ontario §14.8: continue the count of **one-second intervals**, loud, arm and upraised fingers.
- Wisconsin SPS 192.30(3)(b): **intervals of one second between the numbers**; hand so the downed boxer is aware.
- ABC Manual: announce verbally **and** finger-count each second so the fallen boxer can **see and hear**; kneel if necessary; do not rely on voice alone. “Referees should practice counting.” 2011 Guidelines, KNOCKDOWN MECHANICS: count aloud and succinctly; use **both hands** when counting six through ten; hands in line with the boxer’s eyes; do not fan, wave, or over-dramatize.

**Is “eight” eight seconds?**

| Text | What “eight” is | Grade |
| --- | --- | --- |
| ABC Unified Rule 5 | “Mandatory Eight (8) **Count**” | DIRECT — a **count**, not a published wall-clock. |
| NAC 467.740(2) | May not resume until the referee has **finished counting to eight** | DIRECT — count number eight. |
| ABC Manual | “mandatory (8) count”; arise before **(10)** still take the 8 | DIRECT. |
| WBA Rule 11 (Apr 2024) | A boxer who rises and can continue “shall receive a **minimum count of eight (8) seconds**.” | DIRECT — WBA writes **seconds**. Named difference of **wording**, not a second clock. |
| BBBofC 3.33 (site text 2026) | Shall not permit a boxer to continue, if in their opinion they are able, “until the **expiration of 8 seconds following the knock down**.” Timekeeper (3.32) “count off the seconds **strictly in accordance with their watch**.” | DIRECT — BBBofC is more wall-clock in phrasing. Named difference, not ABC default. |
| WBO §25(b)–(c) (Jan 2024) | Fallen fighter “shall take the **compulsory eight (8) count**.” If up at eight, referee **may** examine, “**taking all the time needed**.” | DIRECT. |

**Canvas → spoken “eight” is therefore not guaranteed to be eight seconds**, because: (1) pick-up delay; (2) possible 1-second-before-one gap (Wisconsin / amateur, not ABC Unified); (3) **pauses** if the standing fighter leaves the corner; (4) the referee may **abort** the count for safety (NAC 467.740(4); ABC Manual: twitching / closed eyes → stop the count and end).

**Pace variance (do referees count fast or slow in the wild):** **not found** as a measured study. Manuals tell them to practice and to use the timekeeper’s interval. Live “fast counts” are commentary folklore. Grade **UNKNOWN** as a number; **UNVERIFIED_SECONDARY** as a complaint. Do not build a random ±20% jitter and call it a rule.

### 1.4 Mandatory eight even when up immediately

**DIRECT, and this is the floor of the continue-clock:**

- ABC Unified Rule 5: mandatory eight after knockdowns, all bouts.
- NAC 467.740(2): **no** knocked-down combatant may resume until the referee has finished counting to eight. **May take the count on the floor or standing.**
- ABC Manual: if the fallen boxer arises **any time before 10**, the referee, **after giving the mandatory (8) count**, verifies ability to intelligently defend (gait + questions if indicated).
- WBA Rule 11 last sentence: minimum count of eight seconds if he rises and can continue.
- WBO §25(b): compulsory eight.
- Ontario §14.10: shall not be allowed to continue until after the referee has finished a **mandatory count to eight**.
- Wisconsin SPS 192.30(4): bout may not continue until the referee has reached 8, **even if the boxer is ready to continue before then**.
- ABC 2011 Guidelines §12: administer mandatory eight after **all legal knockdowns**; may terminate the count if the boxer needs medical attention.

**Rise at two, three, seven:** still wait for eight. Then the fitness check. “Up at seven means you continue” is folklore (J14; restated below).

**Mouthpiece out concurrent with the knockdown (ABC Manual, MOUTHPIECE MECHANICS):** treat the knockdown first (mandatory 8 + evaluation); replace the mouthpiece **before** resume. Adds seconds. Not the ordinary shortest path; it is a named extra beat.

### 1.5 Referee check after eight — questions, gait, eyes, wipe, wave-on

This is the **variable** that stretches 10–12 seconds into 20–25.

**Wipe — always after a knockdown that continues. DIRECT:**

- NAC 467.735: before resuming after knockdown, fall, or slip, wipe gloves with a **damp towel or the referee’s shirt**. **Does not apply to MMA.**
- ABC Manual: if satisfied they can safely continue, wipe the fallen boxer’s gloves of debris, **then** stay close and monitor.
- Ontario §14.12: before a fallen / slipped / knocked-down contestant can continue, wipe the gloves clean.
- ABC 2011 Guidelines, WIPING OF GLOVES / KNOCKDOWN MECHANICS step 5: at the count of **eight or nine**, ask if he can continue and have him **take one step towards you**; **don’t touch** the boxer; about **one arm’s length**; **wipe AFTER the step, not before**; then “Have boxing resume immediately.”

**Gait / questions — not a full medical exam, and not mandatory on every clean bounce-up. DIRECT:**

- ABC Manual, after 8: verify intelligent defense by the **“Referee Gait Test”** and asking a few questions. **“Are you OK? Do you want to continue?”** “A general rule is if the referee has any doubt, stop the bout.”
- **Gait test contents (same manual, REFEREE GAIT TEST):** when the boxer **appears concussed or unsteady** after rising before 10, direct him to walk a few steps **right or left**, stop, turn, walk back. Assess balance and body control.
- ABC Bare-Knuckle Unified Rules 2026 (not boxing default; named cousin): gait by stepping forward then left and right; questions “Are you OK?”, “Do you want to continue?”
- WBO §25(c): if up at eight, referee **may** examine, “**taking all the time needed**.” If fit, **promptly** order the contest to continue.
- NAC 467.740(3): if he arises before 10, referee **may** step between “**long enough to assure himself or herself**” of condition; if assured, order them on “**without loss of time**.” During that intervention, a blow by either may be a foul.
- 2011 Guidelines mechanics: look during the count for **position of the eyes, glassy stare, dilation of pupils, lack of steady equilibrium, bad cuts or bleeding**. Eyes are a **look**, not a published verbal “follow my finger” test.

**Wave-on:** 2011 Guidelines step 6: “Have boxing resume immediately.” ABC Manual: if satisfied, wipe, stay close, monitor. The resume command in Wisconsin boxing is **“Box”** (SPS 192.30(2)). ABC Manual’s basic commands include **BOX**. There is no published extra “ceremonial” delay after the wipe on a clean bounce-up.

**Wave-off (not a continue-clock; listed so it is not confused with wave-on):**

- Still down at 10, or in no condition: wave **both arms above the head** (ABC Manual; WBA Rule 11; WBO §25(d); Ontario §14.13; NAC 467.740(4)).
- Referee **may abort** the full 10 if safety would be jeopardized (NAC 467.740(4)). ABC Manual: hard knockdown, **eyes closed** or **twitching/spasms** → stop the count and end. That can make canvas→stoppage **shorter** than eight. It is a **stoppage**, not “fight live again.”

### 1.6 Ordinary range, assembled

No source times a knockdown with a stopwatch. The range is **INHERITED** from the acts above.

| Path | What fills the time | Realistic wall-clock | Grade |
| --- | --- | --- | --- |
| **Shortest legitimate continue** | Bounce-up at 1–2; standing fighter goes; referee picks up; count runs to **8**; one-step (2011) or a look; **wipe**; “box.” Cannot skip 8. Cannot skip wipe after a knockdown. | **~10–12 seconds** | INHERITED. **Not found** as a published measurement. |
| **Typical continue** (up by 4–8, brief look, wipe) | Pick-up 1–3 s + cadence to 8 + wipe/look 2–5 s | **~12–18 seconds** | INHERITED. |
| **Longest ordinary continue** | Slow rise; count to 8/9; **gait** (walk, stop, turn, walk back); “Are you OK? Do you want to continue?”; wipe after the step; wave-on. One short corner-pause possible. | **~20–25 seconds** | INHERITED. WBO “all the time needed” is **unbounded** — that is a named stretch, not the ordinary cap. |
| **Not ordinary — do not fold in** | Out of ring onto floor/table: **20 s** unassisted (ABC Unified Rule 9; NAC 467.757; ABC Manual mandatory **18** if they return sooner — Manual-only). Apron: **10 s** (NAC 467.757(2); WBA Rule 13). Doctor / foul window: **up to 5 minutes**. Serial corner-pauses. Mouthpiece lost-in-crowd. | Different clocks | DIRECT as separate devices. |

**Build-to number:** **10–25 seconds** for the ordinary continuing knockdown. Shorter than ~10 s as a **continue** would require skipping the mandatory eight or the wipe — that is not ABC. Longer than ~25 s is possible (WBO exam; corner-pause; mouthpiece) but is no longer the ordinary beat.

**What they should not build:** a single timer that is “always 8.00 seconds from canvas.” J14 already refused that.

---

## 2. He rises immediately — is rose-from vs did-not a real distinction?

**Short answer:** it is a **real visual distinction** and a **real “still-down / no-longer-down” distinction for hitting**. It is **not** a rules category that **skips the mandatory eight**. Bounce-straight-up still gets the full eight. Shortest legitimate knockdown is the **~10–12 s** path in §1.6.

### 2.1 What the rules actually split

| Split | What it does | What it does **not** do | Grade |
| --- | --- | --- | --- |
| **Up before 10** vs **still down at 10** | Up before 10: still take 8, then check, then continue or stop. Still down at 10: KO, wave both arms above the head. Ontario §16.2: rise to a **standing and ready** position before 10, or it is a knockout. | Does not skip 8. | DIRECT. |
| **Taking the count on the floor** vs **standing** | NAC 467.740(2): he **may** take the count either on the floor **or standing**. | Standing-during-count is **not** a standing eight (no knockdown). It is the **same** knockdown count, taken on the feet. | DIRECT. |
| **Still down while rising** vs **no longer downed** | ABC 2011 Guidelines §15: “The boxer is to be considered to still be in a **downed position when rising** from a knockdown.” BBBofC 3.32.1(d): “down” includes **“when a Boxer is in the act of rising”** until he has regained his feet **and** is in a position and condition to defend. Hitting a man who is down **or getting up** is a foul (Ontario §8.2; NAC 467.675(2); BBBofC 3.38(k)). | ABC Manual 08/2025: once **no part other than the soles** is touching, he is **no longer a downed fighter** — **even if bent over (not fully upright)**. Referee **stops the count** in the sense of the downed-status, **continues the assessment after completing the mandatory 8**. Those two sentences are the live ABC mechanics: **soles-only = not a legal target**; **mandatory 8 still runs**. | DIRECT. Do not collapse “not a legal target” into “the count is over.” |
| **Get up and go down again without a fresh blow** | Resume the **same** count (ABC Manual; NAC 467.745; Ontario §14.9). Wisconsin SPS 192.30(4): if after 8 he immediately falls again without a fresh blow → **KO**. | Not a new knockdown. | DIRECT. |
| **Flash knockdown** | Wisconsin **Muay Thai** SPS 192.79(2): rises immediately → subsections (3)–(6) (neutral corner, count, mandatory 8, double-down) **do not apply**. | **Not** in Wisconsin **boxing** SPS 192.30. **Not** ABC. **Not** NAC. **Not** Ontario. **Not** WBA/WBO. Do not import it. | DIRECT as Muay Thai only. |

### 2.2 Bounce-straight-up still gets the full mandatory eight

Yes. Every professional default text in the default stack says so (Unified Rule 5; NAC 467.740(2); ABC Manual; WBA Rule 11; WBO §25(b); Ontario §14.10; Wisconsin boxing SPS 192.30(4)). Grade **DIRECT**.

The 2011 Guidelines still want the **step toward the referee** at eight or nine and the wipe **after** that step, even on a man who has been on his feet since “two.”

### 2.3 Shortest legitimate knockdown

**~10–12 seconds** canvas → live, ABC default: pick-up + count to eight + wipe + box. **INHERITED.** **Not found** as a stopwatch study.

A **slip** with a wipe and an immediate restart can be **shorter**. That is **not** a knockdown.

A **safety abort** before eight is a **stoppage**, not a short continue.

Wisconsin Muay Thai flash (no count) is **not** boxing.

---

## 3. DOWNED FIGHTER — body states (animation / clip-buy)

Each row is a **distinct filmable state**. Several may play in one knockdown. This is research about what the camera can see under the rules, not an animation spec.

| # | State | What the texts say | Still a legal target? | Grade |
| --- | --- | --- | --- | --- |
| **D1 Falling** | Hit, going down: backward, forward, delayed legs-gone, spin. Not yet “down” until contact / ropes / voluntary knee. | The knockdown **call** is the referee’s (ABC Manual; WBO §25(f): only the referee determines whether there has been a knockdown). | Yes, until the down conditions are met — and hitting a man **dropping to the floor** is already a BBBofC foul (3.38(k)). | DIRECT (call); the fall itself is physics. |
| **D2 Land-on** | First contact other than soles: **glove**, **knee**, **seat**, **back**, **face**, **all-fours**. All of these are “any part other than the soles.” | ABC Manual 1.a; NAC 467.760(1)(a); Ontario §14.1. WBC “three parts of the body” is **WBC phrasing**, not ABC (J14). | Down. Hitting is a foul. | DIRECT. Separate landings are **clip variants of one legal state**, not separate rules. |
| **D3 On canvas, taking count** | Supine, prone, sitting, one knee, all fours, rolling, covering up. He **may** stay down until eight; he **may** get up and take the rest standing (NAC 467.740(2)). | Referee kneels if needed so he can **see and hear** the count (ABC Manual). | Down. | DIRECT. |
| **D4 Ropes-only / hanging / held-up** | No canvas required. Helpless on, through, or over the ropes; or only the ropes prevent the fall. | ABC Manual 1.b–c; NAC 467.760(1)(b)–(c); Ontario §14.1(b)–(c); WBA Rule 10; WBO §25(f). Referee **may count him out** on the ropes (NAC 467.760(2)). | Down. | DIRECT. |
| **D5 Voluntary knee** | Takes a knee. ABC Manual lists this as a knockdown (condition 2). | Count runs. | Down. | DIRECT (ABC Manual). |
| **D6 Rising (act of rising)** | Hands on canvas, one knee, pulling up. **Unassisted by persons.** | ABC Manual: referee **should not assist** the downed fighter in any way. Out-of-ring: unassisted by seconds/spectators (ABC Unified Rule 9; NAC 467.757). BBBofC 3.33: regain feet **unassisted**. 2011 Guidelines §15: still in a **downed position when rising**. BBBofC 3.32.1(d): down **while in the act of rising**. | **Still down** for hitting purposes until soles-only (ABC Manual 08/2025) / until on his feet and able to defend (BBBofC). | DIRECT. |
| **D6b Using the ropes as a handhold to rise** | Common on film. | **not found** as a professional ABC **prohibition**. “Unassisted” in the out-of-ring and rise texts means **no persons** (seconds, spectators, referee). Holding the ropes **to punch** is a foul (NAC 467.675(21); Ontario §8.6; Wisconsin boxing SPS 192.28(6) “attacking while holding the ropes”). That is not the same sentence as “may not grab a rope to stand.” Amateur “unfair use of the ropes” is a different sport. Do not invent a pro ban; do not invent a pro grant. | UNKNOWN as a dedicated rise-by-ropes rule. | UNKNOWN / **not found**. |
| **D7 Soles-only, bent over** | Up, not upright. | ABC Manual 08/2025: **no longer a downed fighter**; complete the mandatory 8, then assess. | **Not** a legal target (no longer downed). Count to 8 **still runs**. | DIRECT. |
| **D8 Standing, taking the count** | On his feet before eight, waiting. | NAC 467.740(2): count may be taken standing. This is **not** a standing eight. | Not downed once soles-only (ABC Manual). Opponent is still in the neutral corner. | DIRECT. |
| **D9 Gait-test walk** | A few steps right or left, stop, turn, walk back (ABC Manual). Or one step toward the referee (2011 Guidelines at 8 or 9). Bare-knuckle cousin: step forward then left and right. | Used when he **appears concussed or unsteady** (ABC Manual). WBO: **may**, all the time needed. NAC: **may**, without loss of time. | Not downed. Opponent still parked. | DIRECT. |
| **D10 Glove-wipe stance** | Hands out; referee wipes on towel or shirt. | **After** the step toward the ref, not before (2011 Guidelines). After 8, if continuing (ABC Manual). | Not downed. | DIRECT. |
| **D11 Ready / “box”** | Fight stance; referee waves them on. | Wisconsin: command **“Box.”** 2011: resume immediately. | Live. | DIRECT. |
| **D12 Wave-off still-down** | Still on canvas or ropes at 10; or twitching / closed eyes mid-count. | Arms **above the head**. Stay with him until the doctor enters (ABC Manual). | Bout over. | DIRECT. |
| **D13 Out of the ring** (not ordinary) | Through the ropes onto apron, or off the platform onto floor/table. | Apron: 10 s (NAC; WBA). Floor: 20 s unassisted (ABC Rule 9; NAC; WBA). ABC Manual: mandatory **18** if he returns sooner (Manual-only). Amateur USA Boxing 19.7: **30 s after the 8-count** — different sport. | Different clock. | DIRECT. |

**Where he goes during the count:** he is **not** sent to a corner. He stays at the knockdown spot (or stands there taking the count). After eight, gait may walk a few steps **at the referee’s direction**. Then they box from that area. **not found:** a rule that he must walk to center, or to his own corner, during the count.

**Land-on variants as separate clip buys:** legally one state (any part but soles). Visually: glove-touch, knee, seat, back, face, all-fours, delayed collapse to a delayed glove. Those are art, not extra rules.

---

## 4. OTHER fighter — where, who sends, how long, if he does not go

**Who sends:** the **referee**. ABC Manual: direct the standing boxer to the **farthest Neutral Corner**. NAC 467.740(1): order the opponent to the farthest neutral corner **by pointing to the corner**. Ontario §14.7: same. WBA Rule 11: farthest neutral corner **in relation to the down boxer**, pointing. WBO §25(a): farthest neutral corner. 2011 Guidelines mechanics step 2: “Motion the scoring boxer to the furthest neutral corner.”

**Where:** the **farthest neutral** corner — not his own corner, not “any corner.” Geometry of the ring, relative to where the man went down.

**How long he stands there:** from the send until the referee orders boxing to resume (after 8 + check + wipe), **or** until the bout is waved off. He does not get a published “rest clock” of his own. Wisconsin SPS 192.30(2): the bout may not continue until the command **“Box.”**

**If he does not go, or leaves:**

| Text | Consequence | Does the count start anyway? | Grade |
| --- | --- | --- | --- |
| **NAC 467.740(3)** | Referee **shall cease counting** until the opponent has returned; then continue **from the point interrupted**. | NAC 467.740(1) already had the referee beginning immediately. The **official** count **pauses**. | DIRECT. |
| **ABC Manual** | If he comes out: **STOP THE COUNT**, put him back, **resume counting**. Keep an eye on him during the count. | Pick-up is **after** the send. If he never goes, the referee does not have a clean pick-up. | DIRECT. |
| **Ontario §14.11** | Referee **may** cease counting until they have returned, then continue from the interruption. | Knockdown timekeeper is already counting (14.2). Referee picks up after the send (14.7). | DIRECT — Ontario “may,” not “shall.” |
| **WBA Rule 11** | **Shall** stop the count until he retires to the indicated corner, then continue from the interruption. | Referee takes the count from the timekeeper and counts immediately. | DIRECT. |
| **WBO §25(b)** | **Shall** stop the count until the boxer returns, then resume at the interruption. Compulsory eight still applies. | Same. | DIRECT. |

**He does not get to skip the eight by lingering.** The downed man is not saved by the standing man’s misconduct; the count **holds**. Wall-clock time **lengthens**. That is one reason canvas→“ten” is not ten seconds (J14).

**During the intervention after eight** (NAC 467.740(3)): a blow by **either** may be a foul. The standing fighter is not released to hit until ordered on.

**MMA:** there is no equivalent “go to the farthest neutral corner and wait for an eight.” If the opponent is grounded, he may be **followed to the floor and punched** (head kicks/knees to a grounded opponent are the foul, not punches). See §5.

---

## 5. MMA separately — no count (J14). What happens in seconds after an MMA knockdown?

**Usable finding, stated plainly: an MMA “knockdown” is not a discrete timed event.** There is no ten-count, no mandatory eight, no standing eight (J14 **R7**). The boxing clock **does not apply**. Do not build an MMA knockdown timer.

**DIRECT:**

- NAC 467.740(9): the boxing counting section **does not apply** to mixed martial arts.
- NAC 467.735(2): glove wipe **does not apply** to MMA.
- NAC 467.760(3): boxing “down” definition **does not apply** to MMA.
- ABC Unified MMA Types of Decisions (PDF August 2026, fetched 2026-09-10): **TKO** = referee stops because the combatant **IS NOT** intelligently defending (strikes, laceration, corner, did not answer the bell). **KO** = referee stops because the combatant **CANNOT** intelligently defend, due to strikes.
- Nevada NAC 467.7961: MMA TKO includes “**not intelligently defending himself or herself while being repeatedly struck**.”
- Nevada NAC 467.79615: MMA KO when “**rendered unconscious** because of a strike, kick or other legal maneuver.” Do not collapse ABC’s CANNOT-defend into Nevada’s unconsciousness (J14 already split these).
- Unified MMA Time Consideration **D.3**: “**At no time may a referee call a timeout to evaluate the impact of a legal strike, other than when a laceration is present.**”
- Unified MMA Foul 12 / grounded (current ABC): a fighter is grounded — and may not be legally **kneed or kicked to the head** — when any part of the body **other than the hands or feet** is in contact with the canvas. **Punches** to a grounded opponent are legal. Stomping a grounded fighter is a foul (Foul 13).

**What happens in seconds, in practice the rules allow:**

| Actor | After a legal blow that puts an MMA fighter on the canvas | Clock? |
| --- | --- | --- |
| **Referee** | Does **not** start a count. Does **not** send anyone to a neutral corner as a count procedure. Options: **let it continue** (including ground strikes) or **stop** for not / cannot intelligently defend. Cannot call time to “see if they’re hurt” from a legal shot unless a laceration is present (D.3). | No published pause. |
| **Downed fighter** | May be **punched** on the ground. May recover, scramble, attempt a takedown reversal or submission, or go out. There is no “you have until eight.” | Not a count. |
| **Standing / following fighter** | May follow down and continue with **legal** ground strikes immediately. Must not knee/kick the **head** of a grounded opponent; must not stomp. | Immediate, unless the referee is already stopping. |

**Window before ground continue or stop:** **not found** as a number of seconds. The legal structure is **binary and untimed**: continue (ground is a phase) or stop. A referee who is already close may step in in a fraction of a second; a referee who is not may see several unanswered shots. Mapping that to a 1.5-second or 3-second “MMA knockdown window” would be an invented rule.

**MMA-in-a-ring, knocked out of the fighting area:** Unified MMA Rule 5 — **five (5) minutes** to return, then physician, analogous to an accidental foul — **not** a 20-count (J14). Different sport-clock.

**Build implication (research, not a spec):** the knockdown **clock** is **boxing-only**. MMA “went down from a strike” is either **ongoing ground fighting** or a **stoppage**. It is not an 8-count cutscene.

---

## 6. HOW OFTEN — knockdowns per pro bout / share of bouts with ≥1

**Knockdowns (the counted event) per professional boxing bout, and the share of bouts with ≥1 knockdown: `not found`.**

What **was** found, and must not be substituted:

| Claim | What it actually is | Grade | Use for the engine? |
| --- | --- | --- | --- |
| zipdo.co “Boxing Statistics \| 2026 Verified Research Data” (page dated 12 Feb 2026): “The average number of knockdowns per professional fight is 1.2, with 8% having 3+ knockdowns”; “44% of rounds in professional boxing end with a knockdown.” | Aggregator. No method, no BoxRec extract, no CompuBox extract. Internally absurd (44% of **rounds** ending in a knockdown cannot sit next to real KO/TKO rates). | **UNVERIFIED_SECONDARY** and **refused**. Treat as folklore. | **No.** |
| CompuBox | Punch thrown/landed (jab vs power). Wikipedia / BoxRec wiki: operators do **not** log knockdowns as the product. Database size is fights tracked for **punches**, not a knockdown census. | DIRECT that CompuBox is punch-tracking. **not found** as a knockdown-per-bout table. | Not this question. |
| BoxRec | Bout **results** include KO, TKO, RTD, decisions. A TKO is often a standing stoppage or a corner stop **without** a counted knockdown. A KO is usually a counted-out knockdown **or** an unconscious stop, depending on the commission’s paperwork. BoxRec does not publish “knockdowns in this bout = *n*” as a standard field in the sources fetched today. | **not found** as a knockdown-event rate. | Do not equate KO% with knockdown%. |
| Combat Sports Law (10 Apr 2025) restating a *Neurology* paper, “Gender Differences of Concussions in Professional Boxing,” BoxRec 1 Jan 2014–1 Jan 2024: **14,555** women’s matches — **5% KO, 24% TKO** (29% KO/TKO). **222,683** men’s matches — **15% KO, 32% TKO** (47% KO/TKO). Per-minute rates nearly even. | Journalism restating a paper. Not a knockdown count. Many TKOs have **zero** counted knockdowns; many knockdowns do **not** end the bout. | **UNVERIFIED_SECONDARY** for the percentages (paper not opened as PDF today). Directionally useful **only** as “stoppage-by-KO/TKO is common in men, less so in women,” **not** as knockdowns-per-bout. | Check **stoppage mix**, not the knockdown clock. |
| PubMed / *Phys Sportsmed* 2024, “Knockout rates across the states…” (BoxRec, 6-month window): KO/TKO rates vary by weight, sex, Fight Exposure Score; heavyweights, males, FES 0 higher. | KO/TKO **result** rates, not knockdown events. | UNVERIFIED_SECONDARY as to the exact table (abstract only fetched). | Same limit. |
| Zazryn et al., *Clin J Sport Med* 2009: Victoria 1997–2005, 907 fights, injury rate 23.6 / 100 fights, mostly head/face lacerations. | Injuries, not knockdowns. | UNVERIFIED_SECONDARY (abstract). | No. |

**Honest engine check, if they need a number today:** they **do not have** a knockdowns-per-bout rate from a primary or even a competent secondary census. They **do** have, at UNVERIFIED_SECONDARY grade, that **on the order of one-third to one-half of men’s professional bouts end KO/TKO**, and a **smaller** share of women’s bouts, and that this is **not** the same statistic as “share of bouts with a counted knockdown.” Installing 1.2 knockdowns per fight because a 2026 listicle said so would be a fake calibration.

---

## Named differences (not a matrix)

Default remains ABC Unified + ABC Referee Manual Rev. 08/2025. These are **named**, not a commission table.

| Difference | Where | Vs default |
| --- | --- | --- |
| Standing eight | ABC Rule 7: **NO**. Amateur USA Boxing / World Boxing: **YES**. Wisconsin boxing SPS 192.30(6): referee **may not** give a standing 8. Wisconsin boxing SPS 192.30(1)(d) **does** define a standing semi-conscious fighter as “down” (amateur-shaped definition). That is a **knockdown-by-definition**, not ABC Unified. | Do not install standing eight as pro default (J14 **R4**). |
| 3KD auto-stop | ABC Rule 8: **NO**. WBA Rule 12: **YES**, automatic KO. Ontario: **shall** stop non-championship; **may** continue championship. Wisconsin boxing SPS 192.30(7): **may not** stop solely for 3 KD. | J14 **R5**. |
| 1 second before “one” | Written: Wisconsin SPS 192.30(3)(a); amateur USA Boxing 19.2; World Boxing. **Not** written in ABC Unified 13-point list or ABC Referee Manual. | UNKNOWN whether a given ABC referee inserts it. |
| “Eight seconds” vs “count of eight” | WBA Rule 11 and BBBofC 3.33 use **seconds**. ABC/NAC/Ontario/WBO use **count**. | Same device, different wording. BBBofC timekeeper counts “strictly in accordance with their watch.” |
| WBO exam length | §25(c): **all the time needed**. NAC 467.740(3): **without loss of time**. | WBO can stretch the post-8 check past the ordinary 20–25 s. |
| Ontario pause if standing fighter leaves | **May** cease counting. NAC/WBA/WBO/ABC Manual: **shall** / do. | Named. |
| Flash knockdown (no 8) | Wisconsin **Muay Thai** SPS 192.79(2) only. | **Not boxing.** |
| Out-of-ring clock | ABC Unified Rule 9: 20 s. NAC: 20 s over the edge (help from anyone **except** seconds/manager); 10 s on the apron, unassisted. WBA Rule 13: apron 10, floor 20. ABC Manual: mandatory **18** if back early (Manual-only). Amateur USA Boxing: 30 s **after** the 8-count. MMA-in-a-ring: **five minutes**. | Different clocks; not the ordinary KD range. |
| “Down” while rising | BBBofC 3.32.1(d) explicit. ABC 2011 Guidelines: still downed when rising. ABC Manual 08/2025: soles-only, even bent over, **no longer downed**. | Same sport, slightly different “when hitting becomes legal again.” Default for this memo: **2025 Manual** (J14 **R1**). |
| WBC three points of contact | WBC 2016 championship synthesized sheet. | Do not universalize (J14). |
| Scoring referee | ABC: three judges, referee does not score. BBBofC ordinary shows: referee scores. | J14. Not a clock issue. |
| IBF in-ring knockdown code | Not in the championship-contest PDF (J14 **R6**). | UNKNOWN as IBF-own text. |

---

## § UNKNOWN / refused folklore

Refused **by name**. Not current professional ABC default. Not to be smuggled.

| Folklore | What the texts actually do | Grade of the refusal |
| --- | --- | --- |
| **Standing eight is the pro count / how you save a hurt standing man** | ABC Rule 7: NO. Amateur: YES. J14 **R4**. | DIRECT. Not reopened. |
| **The count is eight (or ten) real seconds from canvas** | Cadence is 1-second intervals **after** pick-up; **pauses** if the standing man leaves; may abort for safety. | DIRECT. |
| **Bounce-up skips the eight / “flash knockdown” is ABC** | Mandatory 8 in all ABC-default texts. Flash-skip is Wisconsin **Muay Thai** only. | DIRECT. |
| **Up at seven, you automatically continue** | Still take 8. Then gait/questions/“time needed” (WBO). | DIRECT. |
| **MMA has a ten-count / an eight-count / a 2-second ‘knockdown window’** | NAC 467.740(9); Unified MMA intelligent defense; D.3 no timeout on a legal strike. A 2-second MMA window would be invented. | DIRECT / (window) **not found**. |
| **zipdo 1.2 knockdowns/fight and 44% of rounds** | No method. Refused. | UNVERIFIED_SECONDARY. |
| **Knockdown = three points of contact** | WBC 2016 only. | DIRECT (do not universalize). |
| **Using the ropes to get up is illegal / is explicitly legal under ABC** | **not found** as a dedicated pro ABC sentence. Unassisted = no **persons**. | UNKNOWN. |
| **Measured referee pace variance (±x%)** | **not found.** Manuals say practice and follow the timekeeper. | UNKNOWN. |
| **Average send-to-corner time before “one”** | **not found.** | UNKNOWN. |
| **Share of pro bouts with ≥1 counted knockdown; knockdowns per bout** | **not found.** KO/TKO result rates are a different statistic. | UNKNOWN as a knockdown census. |
| **ABC abolished standing eight in 1998, therefore…** | Secondary (Wikipedia, BoxingInsider). Current law is Unified Rule 7 (2016). J14. | UNVERIFIED_SECONDARY. |
| **Mandatory 18 after returning to the ring early** | ABC Referee Manual only; not Unified Rule 9. | DIRECT as manual mechanics; UNKNOWN as universal commission law. |
| **Which text wins when WBA Rule 12 meets ABC Rule 8 on fight night** | Dressing-room rules meeting. J14 **R10**. | UNKNOWN. |
| **Nevada NAC 467.740 vs NRUC recodification** | Legislature HTML still prints 467.740 (rev. 4/13/2026). Cornell LII marks repeal 12/29/2022. Same conflict J14 flagged. This memo uses the **printed NAC count text** as DIRECT **for that HTML**, with the conflict noted. | UNKNOWN which binder a 2026 Nevada referee is handed. |
| **JBC 2016 free-knockdown year** | Wikipedia. No JBC PDF in hand. J14. | UNVERIFIED_SECONDARY. |

---

## Do-not-build (no referee object, no code)

This is a research memo. **Do not** build any of the following from it.

1. A referee state machine, enum, class, or GDScript object (J14).
2. A knockdown timer that is **exactly 8.00 or 10.00 wall-clock seconds from canvas**.
3. A “flash knockdown” skip-eight as professional boxing default.
4. A standing eight as professional default.
5. A three-knockdown auto-stop as professional default.
6. An MMA ten-count, mandatory eight, or invented “X-second knockdown window.”
7. A gait-test / “Are you OK?” / pupil classifier as engine logic (J14 already: intelligent defense is not computable from pips).
8. A jurisdiction table.
9. zipdo.co’s 1.2 knockdowns/fight as a spawn rate.
10. Out-of-ring 20 / apron 10 / doctor 5:00 folded into the ordinary 10–25 s clock.
11. “Protect yourself at all times” as a license to hit a downed or rising man (J14).
12. Code, animation state graphs, or clip-naming schemes. The body-state list in §3 is a **research inventory of filmable states**, not an implementation.

**What the clock is, if anything later becomes a fact rather than a person:** a **boxing-only pause** whose ordinary length is **about 10–25 seconds**, floored by the **mandatory eight** and the **wipe**, stretched by **gait/questions** and **corner-pauses**, ended by **“box”** or by a **wave-off**. The referee remains scenery. The pause is the event.

Do not design it here.

---

## Sources

All fetched or opened **2026-09-10** unless a page states its own revision date. Primary first.

### Primary — boxing rules and mechanics

1. ABC Unified Rules of Boxing (approved 25 Aug 2001, last amended **3 Aug 2016**). HTML: `https://www.abcboxing.com/unified-rules-boxing/` — PDF: `https://www.abcboxing.com/wp-content/uploads/2016/10/unified_rules_boxing_rev_august2016.pdf`
2. ABC Boxing Referee Manual, **Rev. 08/2025**. `https://www.abcboxing.com/wp-content/uploads/2026/06/ABC-BOXING-REFEREE-MANUAL-rev8-2025.pdf`
3. ABC Referee Rules and Guidelines (PDF, last updated **16 Mar 2011**), including **KNOCKDOWN MECHANICS**. `https://www.abcboxing.com/ABC_REFEREE_GUIDELINES.pdf`
4. Nevada NAC Chapter 467, legislature HTML **[Rev. 4/13/2026]**. Especially 467.735 (wipe; not MMA), 467.740 (count; not MMA), 467.745 (resume count), 467.757 (through the ropes), 467.760 (down; not MMA), 467.7961 / 467.79615 (MMA TKO/KO). `https://www.leg.state.nv.us/nac/NAC-467.html`
5. Ontario, *Professional combative sport rules: Boxing*, Part III, updated **22 May 2025**, §14 Knockdowns. `https://www.ontario.ca/document/professional-combative-sport-rules-boxing/part-iii-technical-sport-rules`
6. WBA Rules, amended 12 Dec 2022 and **22 Apr 2024**, PDF hosted Jun 2026. Contest Rules 10–14 (down, knockdown, automatic knockout, outside, bell). `https://www.wbaboxing.com/wp-content/uploads/2026/06/WBA-Rules-11.08.2023.pdf` — index: `https://www.wbaboxing.com/wba-regulations/rules-of-world-boxing-association`
7. WBO *Regulations of World Championship Contests*, **January 2024**, **§25 COUNT**. `https://www.wboboxing.com/wp-content/uploads/2024/01/WBO-Regulations-jan-2024.pdf`
8. British Boxing Board of Control, *The Rules of Boxing*, site text 2026, **3.32–3.35** (down; 8 seconds following the knockdown; unassisted; no save by the bell any round including the last). `https://bbbofc.com/boxing-rules` — full PDF `https://bbbofc.com/build/documents/Rules_and_Regulations_2026.pdf`
9. Wisconsin SPS **192.30** (boxing procedures after knock-downs; 1 second before “one”; mandatory 8; no professional standing 8; no 3KD auto-stop). `https://docs.legis.wisconsin.gov/document/administrativecode/SPS%20192.30` — LII: `https://www.law.cornell.edu/regulations/wisconsin/Wis-Admin-Code-SS-SPS-192-30`
10. Wisconsin SPS **192.79** (Muay Thai; **flash knockdown** at (2); not boxing). `https://www.law.cornell.edu/regulations/wisconsin/Wis-Admin-Code-SS-SPS-192-79`
11. Washington WAC 36-12-140 (method of counting; mandatory eight; continue to 10 if not up at eight; WSR 26-01-119 effective 17 Jan 2026). `https://app.leg.wa.gov/wac/default.aspx?cite=36-12-140`
12. ABC Bare-Knuckle Fighting Unified Rules 2026 (gait-test cousin; **not** boxing default). `https://www.abcboxing.com/wp-content/uploads/2026/08/ABC-Bare-Knuckle-Fighting-Unified-Rules-2026.pdf`

### Primary — MMA (to show the clock does not exist)

13. ABC Unified Rules of Mixed Martial Arts, PDF **August 2026**. Types of Decisions (IS NOT / CANNOT intelligently defend); Time Consideration D.3 (no timeout on a legal strike except laceration); Foul 12 grounded definition. `https://www.abcboxing.com/wp-content/uploads/2026/08/Unified-Rules-of-MMA-8.2026.pdf`
14. Nevada NAC 467.7961, 467.79615 (MMA TKO / KO). Same NAC-467 URL as (4).
15. Nevada NRUC 5.040 / 5.050 (Nov 2024 PDF): MMA TKO = not intelligently defending while repeatedly struck; MMA KO = unconsciousness. `https://boxing.nv.gov/uploadedFiles/boxingnvgov/content/faq/sections/2024-11-20-NRUC-OFFICIAL-FINAL.pdf`

### Primary — amateur (cadence gap; standing eight still lives here)

16. USA Boxing National Rulebook, revised **1 January 2026**, 19.2–19.4 (1 second before “one”; mandatory 8 even if ready or round over). `https://assets.contentstack.io/v3/assets/blteb7d012fc7ebef7f/blt5ff28f6e78e9624d/695ed2d8b45570d8a64b74b9/USA_Boxing_Rule_Book_Revisions_-_1.1.2026.pdf`
17. IBA Referee and Judges Manual / Referee-Judge Regulations 2023 (send while allowing one second to pass). `https://www.iba.sport/wp-content/uploads/2023/01/Referee-Judge-Regulations-2023-1-2.pdf`

### Secondary — pointers only, never current law; several refused

18. Wikipedia, “Mandatory eight count,” fetched 2026-09-10. `https://en.wikipedia.org/wiki/Mandatory_eight_count` — history anecdotes; **1998 ABC standing-eight abolition year** remains UNVERIFIED_SECONDARY (J14).
19. Combat Sports Law, 10 Apr 2025, restating *Neurology* “Gender Differences of Concussions in Professional Boxing” (BoxRec 2014–2024 KO/TKO **result** rates, not knockdown counts). `https://combatsportslaw.com/2025/04/10/study-male-and-female-boxers-suffer-almost-identical-concussion-rates/`
20. PubMed abstract, *Phys Sportsmed* 2024, “Knockout rates across the states…” `https://pubmed.ncbi.nlm.nih.gov/37990916/`
21. zipdo.co, “Boxing Statistics \| 2026 Verified Research Data,” 12 Feb 2026. `https://zipdo.co/boxing-statistics/` — **refused** for 1.2 knockdowns/fight and 44% of rounds.
22. BoxRec wiki, “Knockdown.” `https://boxrec.com/wiki/index.php/Knockdown` — restatement, not law.
23. J14 — THE REFEREE. Local: `/workspace/j15/J14_THE_REFEREE.md`. Bindings **R1, R3, R4, R5, R7, R10** and the count-detail in J14 §3 are **cited**, not re-litigated.

---

*End J15. No referee was designed. The ordinary boxing knockdown is about 10–25 seconds. MMA does not have this clock.*
