# J19 — THE JOINS (what turns fourteen clips into a fight)

**Desk:** John (research). **Assigned:** 2026-09-10. **Verification date for every live URL:** 2026-09-10.  
**Status:** study only. No GDScript. No animation graph. No vendor. No price.  
**Scope:** the **joins** between J17’s type-first ten and J18’s four in-place locomotion cycles. Fourteen clips are not a fight. Wrong joins = slideshow. This memo does **not** reopen J17’s punch-type list, reach-variant refusal, block/slip-as-pose, knockdown 2–3, or shared library; does **not** reopen J18’s four-intent cart, blend-space-as-playback, or motion-matching refusal; does **not** reopen G42’s in-place / no-root-motion contract or M14’s camera dial.

**Grade legend (same as J17 / J18):**

| Grade | Meaning |
| --- | --- |
| **DIRECT** | Quoted or paraphrased from a primary talk, postmortem, official manual, store page, or named developer, fetched 2026-09-10. |
| **INHERITED** | Follows from a DIRECT text without adding a new number. |
| **UNVERIFIED_SECONDARY** | Journalism, wiki, forum, marketplace copy, or a paywalled interview recovered only as a snippet. Not used as a blend-duration census. |
| **UNKNOWN** | Not found, conflicting, or true only as a given night’s production choice. |

An invented blend duration that looks sourced is worse than **NOT FOUND**. Boxing and MMA titles almost never publish milliseconds. “Industry does not publish this” is a finding.

**Default (cite; do not reopen):**

- **J17** (`/workspace/j19/J17_THE_CLIP_COUNT.md`): type-first ten (`idle`, `jab`, `cross`, `hook_lead`, `hook_rear`, `uppercut`, `react_head`, `react_body`, `knockdown_fall`, `get_up`); no reach variants; `block` / `slip` = held pose / analog lean; knockdown **2–3**; shared library.
- **J18** (`/workspace/j19/J18_THE_OTHER_SEVENTY_PERCENT.md`): add four in-place shuffles (`loc_fwd`, `loc_back`, `loc_circle_l`, `loc_circle_r`); **14 clips total**; no 8-dir / starts / stops / pivots; no motion matching (Epic melee sample’s **~65** loco files is the refused budget).
- **G42**: engine owns translation; clips in-place; locomotion rate-scaled to sim; attack clips are not; no root motion; no motion matching.
- **Brief (this hour, not a published boxing statistic):** beat = 14 s window; punch clip **<1 s**; **~84%** of presented fight-time with no strike clip (locomotion fills it). Common transition: **cycle → punch → cycle** (thousands / fight), not punch → punch. `FightIntent` re-decides close / hold / retreat / circle often → **cycle → cycle** also frequent.

---

## Decisions

These are research-desk decisions about **what the sources say the joins are**, not engine design. Typeable. Claude can act without the body.

1. **Blend durations — boxing/MMA titles: NOT FOUND as published ms or frames. Do not invent.** The only **published** numbers in the record are **engine defaults** and **craft talks**, not Fight Night / UFC / Undisputed SKUs. Unity Animator default transition duration = **0.25 s**. Unreal `Play Slot Animation` / montage Blend In / Blend Out default = **0.25 s**. Godot `AnimationPlayer.playback_default_blend_time` default = **0.0 s**. Epic inertialization guidance: keep duration **< 0.4 s**. Jungbluth (additive hit-react, 12-frame clip): **1-frame blend-in, 12-frame blend-out**. Massoudi (hit into react): **crossfade = 0**. **Most actionable typed set, labelled as engine/craft not boxing census:** cycle → cycle **~200–250 ms** (engine loco default ballpark); cycle → attack **shorter than 250 ms** (250 ms is ~30% of a <1 s punch — that is a large fraction, not a snap); attack → cycle **blend-out of the punch, same order as cycle → attack**; punch → react **0–1 frame in** (Massoudi 0; Jungbluth additive 1f). Claude picks the exact ms. This desk will not mint a boxing number.

2. **Upper-body layering over a continuing lower-body cycle: YES for locomotion-under-punch and for light flinch. NO as the punch itself.** UFC 1 ran a **second copy of the locomotion state machine as additive on hips / spine** so a punch and a step could coexist. EA MMA: layer / override / add on any body part. Epic’s official layered-blend example is **shoot while walking**, not punch. Naive **spine-up punch over walking legs** is the FPS pattern and a **trap for boxing** (the punch *is* the hips and the plant). When: **full-body punch + additive loco underneath** (UFC); **additive flinch on continuing action** for light hits (Jungbluth / Sherr). Not: punch as an upper-body montage over a shuffle.

3. **Interrupt mid-punch when hit: abort to reaction.** Engine scores impacts continuously. Play-to-completion of the punch after the sim already scored a hit on you is the second-clock failure G42 named (Undisputed desync family). Full hit-reacts **do interrupt** (Jungbluth). EA MMA: keep your feet through **most** reactions; stun / stumble / knockdown when the hit is big. Light hits: additive / mask, do not steal the punch. Dark Souls / For Honor default: incoming hit **interrupts the attack** unless poise / hyper-armor. FightCamp has no published poise SKU — treat stun-or-worse as **abort punch → react**. Do not play the punch out.

4. **Purchase specification (on the 14, not extra SKUs): one shared guard.** Every clip starts and ends in the same orthodox (or southpaw) stance family. Cycles loop (first ≈ last pose). Punch recovery is **inside** the punch clip, back to that guard. Reactions start from a hit pose and end blendable into the same guard. Pose-match the set. **Do not buy per-pair in/out poses** (G42: that is a fighting-game authoring list). Sync / foot-phase markers belong **in** the four cycles. Contact is a **notify on the punch**, not a clip. Cuttable vs blend-only: boxing sim is **blend + interrupt**, not Street Fighter cancel windows.

5. **Worst failure at 9–11 m fixed HOME: silhouette pop on cycle → punch, then wrong-foot punch.** At postage-stamp scale the read is whole-body mass (M16 / M17), not a 5 cm skate (J18: ~6 px). A guard jump reads as a slideshow. A punch whose arm fires while the shuffle is on the other foot reads as disconnected mass. Circle **double-step** is next (lateral, not compressed by look-down). Floaty 250 ms blend on a <1 s punch eats the snap. Playing a punch to completion after a scored hit is two fights.

6. **Q6 one-liner: do transitions need their own purchased clips? NO.** Plant / step-out / recovery are **not** a fifteenth family. Joins are made from the 14. Marketplace “Idle_To_Block” and “mocap transitions vs simple blending” are **pack composition**, not a shipped Fight Night SKU. UFC paid for **procedural turn-in-place** specifically to avoid capturing extra transition sets. Absolver’s flow is **authored into the move** (each clip ends in the stance the next starts from), not a second cart.

7. **Refuse:** vendors; prices; GDScript; animation graphs; enums; invented blend ms as if Fight Night published them; motion matching; root-motion joins; per-pair in/out pose libraries; “buy the Epic melee sample’s starts / stops / pivots so blends work”; reopening J17 / J18 / G42 / M14.

8. **NOT FOUND (do not invent):** blend duration in ms or frames inside Fight Night, Undisputed, UFC, or Real Boxing, as a published number. Whether Fight Night aborts a punch on every landed incoming (G42 says stun interrupts; Hayes tutorials fetched this hour do not say it). Whether Undisputed’s combo-flow is a blend time or a string clip.

9. This memo does **not** design code.

---

## False premises in the brief (correct first)

The brief’s questions are the right questions. These readings of them would be wrong:

| Premise | Correction | Grade |
| --- | --- | --- |
| Fourteen clips already fight if each file is good. | A fight is **cycle → punch → cycle**, thousands of times, plus **cycle → cycle** when intent flips. The join **is** the picture of the 84%. | INHERITED (brief + J18). |
| Upper-body punch over walking legs is “how melee does it.” | Epic’s official layer example is **shooting**. UFC’s shipped boxing-adjacent answer is **full-body punch + additive locomotion underneath**. Mask-only on the shared spine was **not enough** (Harrower). | DIRECT. |
| Someone published “cycle → attack = *X* ms” for a boxing title. | **NOT FOUND.** Engine defaults are 250 ms (Unity, Unreal montage) or 0 ms (Godot AnimationPlayer). Those are starting values, not a Fight Night census. | DIRECT (engine docs). UNKNOWN (boxing titles). |
| A punch that has started must play to the end or it will pop. | Full hit-reacts **interrupt** (Jungbluth). EA MMA’s failure mode is being **trapped in unresponsive animation**. The sim already scored the incoming. | DIRECT. |
| Smooth joins require purchased plant / step-out / recovery clips. | UFC refused unique locomotion-on-idle and captured **procedural turns** instead. Absolver authors the end-stance **into** the move. Marketplace “transitions” are pack copy. | DIRECT / INHERITED. |
| Foot skate is the worst tell at HOME. | J18 already: 5 cm ≈ 6 px; 15 cm For Honor clamp ≈ 18 px; depth is compressed; **circle is lateral**. A **pose pop** of the silhouette is a bigger postage-stamp error than a few centimetres of skate. | INHERITED (J18 §3). |
| Punch-Out is the join model. | Punch-Out has **no blend** because it has **no ring translation** and discrete sprites. It is the tell for **what you can drop**, not for 3D cycle → punch. | INHERITED (J17 §6, J18 §5). |

---

## 1. MECHANISM — what fighting / melee titles actually use

**Question:** crossfade, blend tree, additive, state machine + transition rules, notifies? Loco → attack and back: full-body interrupt, or upper-body layer over a continuing lower-body cycle? Standard or trap?

**Answer they can use:** shipped combat-sports titles describe a **mixer**, not one knob. The pieces that show up by name:

| Mechanism | What it is | Who names it for fights | Grade |
| --- | --- | --- | --- |
| **State machine + transition rules** | Named states (idle / move / attack / react); a rule decides when you may leave. UFC 1: “pretty standard” movement state machine, idle → movement. Godot: Immediate / Sync / At End, plus `xfade_time`. Unity: conditions + optional exit time + **interruption**. Unreal: transition rules output a bool; duration is a blend setting. | Harrower GDC 2015; engine manuals. | DIRECT. |
| **Crossfade (standard blend)** | Pose A → pose B over a duration. Both poses evaluated for the fade. Unity default **0.25 s**. Unreal montage default **0.25 s**. Godot AnimationPlayer default **0.0 s**. | Engine docs. | DIRECT. |
| **Blend space / blend tree** | Interpolate **samples you already bought** (J18). Direction × speed for cycles. Not a punch solution by itself (G42). | Epic Blend Spaces; J18. | DIRECT / INHERITED. |
| **Additive layer** | Second pose **added** to a base. UFC 1: **second copy of the locomotion machine, additive on hips / spine**, lock-step with the full-body machine, so a punch and a step coexist. EA MMA: “layer, override, and subtract or add animation to any part of the body at any time (similar to Photoshop layers).” Jungbluth: additive **hit** is a half-measure. | Harrower; Sherr / Murdock; Jungbluth. | DIRECT. |
| **Override / mask / layered blend per bone** | Replace a bone chain (Epic: `spine_01` up = shoot while walk). UFC 1 tried dynamic masks; **not enough on the shared spine joints** — that is why the additive twin machine existed. | Epic layered-animations guide; Harrower (G42 restatement of the talk). | DIRECT. |
| **Inertialization** | Stop evaluating the outgoing clip; ease velocity toward the incoming. Epic: keep **< 0.4 s**; do not use when poses are extremely different. | Epic Transition Rules / Blend Nodes docs. | DIRECT. |
| **Notifies / markers** | Events **on** a clip: foot plant, contact, sound. Epic: notifies synchronized to sequences; **Sync Markers** keep blended cycles in phase. Not extra clips. Godot OneShot can **FIRE** or **ABORT**. | Epic Animation Notifies; Godot AnimationTree. | DIRECT. |
| **IK / foot plant** | UFC 1: procedural foot planting so mixing and hip alteration do not slide the feet. EA MMA: HumanIK foot positions. Residual skate hide, not a join clip. | Harrower; Murdock. | DIRECT. |

### 1.1 Loco → attack → loco: what titles actually do

**Combat sports (the relevant sport-shape):**

| Title | Loco → attack | Attack → loco | Full-body or layered? | Grade |
| --- | --- | --- | --- | --- |
| **EA Sports UFC 1** (Harrower & Dowsett, GDC 2015) | Movement state machine is standard. Punch is a full-body action. **Additive second locomotion machine on hips / spine** so the step continues under the punch. Foot IK plant on top. | Return to the movement machine; additive copy stays in lock-step. | **Full-body punch + additive loco underneath.** Mask-only was tried and **failed** the shared spine. | DIRECT (talk transcript + J18). |
| **EA Sports MMA** (Sherr; Murdock / GameDev.net) | Heat-seeking **moves the fighter into range** then plays the strike (J17). Strikes are parameterized (power, speed, visual skill, combo window). Circling **while throwing** is a left-stick steer on the strike. | Combo window, then recovery as visual skill (over-commit vs recover quickly). | **Layer / override / add** any body part. Not “upper-body punch only.” | DIRECT. |
| **Fight Night Champion** | Stick moves; **stepping punch** if opponent is outside range (J17) — that is a **full-body** extra family, not an arm layer. | Recovery is in the punch. Stun is a sim event (G42: stun interrupts the clip). Hayes attacking / defensive tutorials fetched this hour do **not** publish a blend ms. | Full-body punches. Block = arms to the spot while you can still punch (J17). | DIRECT (step-in). UNKNOWN (blend ms; punch-abort on every hit). |
| **UFC 2009** (Ueno) | Fewer animations, IK so the glove arrives without the clip walking the man (G42). | — | Full-body + IK, not a layer cart. | DIRECT (G42). |

**Melee / action (different sport — use as mechanism, not as a boxing buy):**

| Title / talk | What they do | Trap if copied blindly | Grade |
| --- | --- | --- | --- |
| **Epic layered animations** (official) | Run + **shoot** on `spine_01` up via Layered blend per bone + UpperBody slot. Docs say you *could* use this for melee. | The worked example is a **gun**. A boxing punch that does not rotate the hips is a fake. | DIRECT. |
| **Jungbluth**, *Anatomy of a Hit Reaction* | Full hit-reacts **interrupt**. Additive reacts are a **half-measure**: only head / torso rotation is safe; translating the hips while walking = weird legs. | Additive punch-on-loco has the same hip problem as additive hit-on-walk. | DIRECT (talk transcript). |
| **Starke et al.**, SIGGRAPH 2021 *Neural Animation Layering* (martial arts) | Traditional additive / override / transition layering “typically requiring significant tuning” and produces artifacts that “violate physics.” Their *Walk Punch* is **learned** layering of locomotion curves with a punch — research, not a shipped boxing title. | Do not install neural layering as the live buy. The talk is evidence that **naive layering is a known trap**. | DIRECT (talk / patent restatement of the paper). |
| **Absolver** (Sloclap) | Each move **begins and ends in a stance**. Flow is authored **into** the clip so the next move starts from that pose. Eurogamer: other games “blink noticeably between states unless committed to a combo”; Absolver’s transitions are clean because the **end pose is the next start pose**. | That is a **purchase spec on existing clips**, not extra transition SKUs. Also a versus-fighter combo grammar (punch → punch), which is **not** FightCamp’s common path. | DIRECT. |
| **Sifu** (Roger / Tarno) | Keyframed attacks in **build-up / force / release**. Chain by authoring the next move, not by a blend-space of 65 locos. Height cheated because they could not afford every height (J17). | Full-body committed strikes. Not a layer-over-walk boxing sim. | DIRECT / UNVERIFIED_SECONDARY (talk). |
| **Street Fighter / Dustloop** | Cancel = **cut recovery** into the next clip. Animation **is** the rules (G42 refused this architecture). Blend ≈ 0. | Do not buy SF cancel windows. Useful only as: **0 blend is how you keep a <1 s punch sharp.** | DIRECT (SuperCombo Cancel page; G42). |
| **For Honor** | Default: getting hit **interrupts** the attack unless hyper-armor. Animation is cosmetic on a simulated trajectory (J18). | Interrupt rule, not a blend-ms. | DIRECT (wiki / glossary; Clavet via J18). |
| **Dark Souls** | Poise: if the bar breaks, the **action is interrupted**; if not, the swing plays through. | FightCamp has no poise SKU. The pattern is **severity gates interrupt vs play-through**. | DIRECT (Fextralife / wikidot poise). |
| **Punch-Out!!** | Discrete sprites. No 3D blend. No ring walk (J18). | Not a join model for 14 in-place clips. | DIRECT (J17 / J18). |

### 1.2 Standard or trap?

**Standard (combat sports, named):**

1. **State machine** for idle / move / attack / react.  
2. **Crossfade** between states.  
3. **Full-body punch** (weight shift is the punch).  
4. **Additive locomotion underneath** so the shuffle does not die for the 0.8 s of the punch (UFC 1).  
5. **Additive or masked flinch** for hits that must **not** stun (Sherr: keep your feet through most of them).  
6. **Notifies** on contact and foot plant.  
7. **IK** to hide residual skate and to make the glove arrive (J17 reach refusal).

**Trap:**

- **Upper-body-only punch over a continuing walk.** That is Epic’s **firearm** tutorial. Harrower already found mask-on-spine insufficient. Jungbluth: hip translation on a walking base makes ugly legs. A boxing punch from a shuffle that does not plant / rotate the hips will read as a waving arm at HOME.
- **Motion matching** a plant out of 65 loco files (J18 / G42 refused).
- **Playing the punch to completion** because “blends look smoother.” That is the unresponsive trap Sherr named.
- **Per-pair transition clips** as the way joins work (fighting-game authoring list; G42: do not start it).

**INHERITED for FightCamp:** cycle → punch is a **full-body one-shot over (or mixed with) the cycle**, not a spine-up montage. The cycle may **continue additively on the lower body** so the 84% does not freeze every time a jab fires. Attack → cycle is a **blend-out back into the same four shuffles**. Cycle → cycle is a **crossfade of two loops**, ideally in phase (sync markers), not a purchased start/stop.

---

## 2. BLEND DURATIONS — the most actionable number

**Question:** ms or frames if published, for cycle → attack, attack → cycle, cycle → cycle.

**Decision: NOT FOUND as a boxing/MMA title number. Report engine defaults and craft talks. Do not mint a Fight Night millisecond.**

### 2.1 What boxing / MMA titles published

| Title | Published blend duration | Grade |
| --- | --- | --- |
| Fight Night Champion | **NOT FOUND.** Hayes FSPC / attacking / defensive tutorials: punch types, step-in, block-as-arms. No ms. | DIRECT as absence. |
| Undisputed | **NOT FOUND.** Steam: 60+ punches, footwork features. No ms. | DIRECT as absence. |
| EA UFC 1 / 2 | **NOT FOUND.** Harrower: responsiveness vs visual quality; additive loco; no foot sliding as a **bar**, not as a fade time. | DIRECT as absence. |
| EA MMA | **NOT FOUND.** Sherr: speed is time-to-land from input; combo **window** is a statistic, not a fade. “Responsiveness WILL NOT suffer to visuals.” | DIRECT (priority). UNKNOWN (ms). |
| Real Boxing | **NOT FOUND.** Postmortem is distance + IK (J17). | DIRECT as absence. |

**Industry does not publish this.** That is the finding.

### 2.2 What *is* published (engines and craft)

These are **starting defaults** and **talk numbers**. They are not a shipped boxer’s fade.

| Source | Number | Applies to | Grade |
| --- | --- | --- | --- |
| **Unity Animator** | Default **Transition Duration = 0.25 s** (issue tracker: expected 0.25; forum: “exit time 0.75 and transition duration 0.25”). Manual: duration in seconds if Fixed Duration. Transition graph draws **IK foot contact** so you can see slips. | State-to-state, including loco. | DIRECT (`class-Transition`; issue 853292; discussions). |
| **Unreal montage / slot** | `play_slot_animation(..., blend_in_time=0.25, blend_out_time=0.25)`. AnimMontage Blend In / Blend Out default **(0.25, Linear)**. | One-shot (attack) over whatever is underneath. | DIRECT (Python API 4.27; ueHow / montage editor). |
| **Unreal inertialization** | “Keeping your blend duration **short, less than 0.4 seconds** is best.” Do not inertialize when poses are extremely different. | Alternative to crossfade. | DIRECT (Transition Rules docs). |
| **Godot AnimationPlayer** | `playback_default_blend_time` **= 0.0**. Per-pair `set_blend_time` exists. AnimationTree state-machine `xfade_time` is a property (no single factory default in the 4.5 tree page). Workshop copy uses **0.2 s** as an example. | Default is **cut**, not 250 ms. | DIRECT (class docs). UNVERIFIED_SECONDARY (0.2 workshop). |
| **Jungbluth** additive hit | **12-frame** animation; **1-frame blend-in**, **12-frame blend-out**. At 30 fps that is **~33 ms in / ~400 ms out**; at 60 fps **~16 ms / ~200 ms**. Purpose: jarring impact, then get out of the way of the action underneath. | Additive **react**, not loco → punch. | DIRECT (talk). |
| **Massoudi**, “The Role of Animations in Hit Effects” (Epic of Kings) | “**The cross fade times should be equal to zero while transitioning to hit animations.**” Hit anims start from a damaged pose (high kinetic energy). Uninterruptible enemy swings use **additive shakes** instead of cancel. | **Into react.** Zero fade is the snap. | DIRECT. |
| **G42** | “**0.10–0.20 s** blend from clip A to B so the cut is not a pop.” Clips that share a stance. | Craft restatement, **not** a boxing-title citation. | INHERITED as G42. **Not** a Fight Night number. |
| **Indie / vendor craft** | UE tutorial: “a nice **250 millisecond** blend” loco → attack montage. Game Creator melee docs: transition in/out “around **0.1 and 0.4 seconds**.” | Not a shipped title. | UNVERIFIED_SECONDARY. |

### 2.3 Why 250 ms is the wrong boxing punch number even though it is the engine default

Brief: punch clip **<1 s**. G42’s measured combo punch ≈ **0.82 s**. Unity / Unreal **default 250 ms** is **~30% of that clip**. A third of a jab spent interpolating from a shuffle is how a punch goes **floaty**. That is why:

- Street Fighter **cancels** instead of fading (different architecture — G42 refused — but the **duration lesson** stands).
- Massoudi sets **hit** fade to **0**.
- Jungbluth uses **1 frame in** for impact.
- Sherr: responsiveness will not suffer to visuals.
- Epic: inertialization wants **short** fades; long fades on dissimilar poses are the failure case.

**Cycle → cycle** can sit on the engine loco default. Unity even draws foot-contact in the transition graph because **phase mismatch** (not duration alone) is the loco failure. A 250 ms fade between two **pose-matched, in-phase** shuffles is ordinary. A 250 ms fade between **out-of-phase** shuffles is a **double-step**.

**Cycle → attack** wants **shorter than the loco default** if the punch is <1 s, **unless** the punch’s first pose already *is* the shuffle/idle guard (then the fade can be short because the poses agree). Shared start pose **buys** a shorter fade. That is Decision 4, not a new clip.

**Attack → cycle** is the montage blend-out (Unreal default 250 ms again — same fraction-of-punch problem). Recovery authored **into** the punch’s last frames, matching the guard, lets the fade be short.

### 2.4 Typed ballpark (labelled — not a census)

| Join | Boxing title ms | What is published | What this desk will type |
| --- | --- | --- | --- |
| **cycle → cycle** | **NOT FOUND** | Unity default 250 ms; Godot player default 0; Epic inertialization <400 ms | **~200–250 ms** as engine-loco ballpark **if** cycles share stance and foot phase. Shorter if they pop. Not a Fight Night fact. |
| **cycle → attack** | **NOT FOUND** | Unreal montage in 250 ms; G42 100–200 ms (unsourced as boxing) | **Shorter than 250 ms.** 250 ms is a large fraction of a <1 s punch. Shared start pose is how you go short without a pop. |
| **attack → cycle** | **NOT FOUND** | Unreal montage out 250 ms | **Same order as cycle → attack.** Recovery-in-clip + shared end pose. |
| **punch → react** (interrupt) | **NOT FOUND** in boxing titles | Massoudi **0**; Jungbluth additive **1f in** | **0–1 frame in.** Snap is the hit. Blend **out** of the react can be longer (Jungbluth 12f out on additive). |
| **light flinch (additive, no interrupt)** | **NOT FOUND** in boxing titles | Jungbluth 1f / 12f | Use that shape: **short in, longer out**, so the cycle underneath returns. |

Claude may pick other ms. **Do not write them back into this memo as if a boxing title published them.**

---

## 3. INTERRUPT MID-PUNCH WHEN HIT

**Question:** abort to reaction, blend out, or play to completion? Engine scores impacts continuously.

**Decision: abort to reaction when the incoming is a real hit. Additive flinch only for the “barely notice” band. Do not play the punch to completion.**

| Source | Rule | Grade |
| --- | --- | --- |
| **EA MMA**, Sherr | Hit reactions “infinitely variable” via **blend, skeletal masking, and physics**. “**You can keep your feet (and your ability to move and block the next strike) through most of them.**” Avoids being “**Trapped in unresponsive animation.**” Severity: barely notice → stumble → stun → knockdown → flash KO. If you were throwing a big overhand and got hit **in the same direction as your momentum**, you are more likely thrown off balance. | DIRECT. Light = keep the action. Big = the action yields. |
| **Jungbluth** | “The entire point of a hit reaction animation is to make the attack feel powerful.” **Additive because you’re trying not to interrupt** → only head / some body rotation; result often a hitch. “**Full hit-reacts do interrupt.**” Short blend **in**, longer **out** if you must stay additive. | DIRECT. |
| **Massoudi** | Into hit: **zero crossfade**. Some enemy attacks are **uninterruptible**; then additive shakes on top. Player hits that **should** cancel, cancel. | DIRECT (hack-and-slash, not boxing — mechanism still). |
| **For Honor** | Default: a connecting attack **interrupts** the opponent’s attack unless the move has **hyper-armor**. | DIRECT. |
| **Dark Souls** | Poise: if the bar hits 0, “an enemy’s attack **interrupts your action**.” If poise holds, the swing **plays through**. | DIRECT. |
| **Street Fighter** | Hitstun **locks** the receiver; the attacker’s cancel is a designed hole in **recovery**, not “play my punch out after I got hit.” | DIRECT (SuperCombo). Different architecture (G42). |
| **G42** | Fight Night: “a stun interrupts that clip.” Playing a 2.47 s string while the engine landed five is a **lie**. Undisputed combo-flow desync = two clocks, no winner. | INHERITED (G42). Fight Night punch-abort **on every tick-hit** (not only stun): **UNKNOWN** this hour — Hayes tutorials do not say it. |
| **Engine (this project)** | Scores impacts continuously. The card is the fight (G42). | INHERITED. |

**INHERITED rule they can type:**

| Incoming (sim already has this) | Picture |
| --- | --- |
| Glancing / “barely notice” (M17: 5.6% glancing = scale, not a SKU) | **Do not abort the punch.** Additive flinch / mask (Sherr, Jungbluth, M17 scale). |
| Clean head / body that should **read** (M17’s two reacts) | **Abort the punch. Blend into `react_head` / `react_body`.** Fade **in** is 0–1 frame (Massoudi / Jungbluth). |
| Stun / knockdown | **Abort.** Then J17’s fall / get-up (committed — G42). |

**Play to completion is the wrong default.** It is how you get Sherr’s “trapped” and G42’s second fight. Blend-out-without-a-react (just fade the punch back to idle while the head does nothing) **fails M17**: at HOME the **receiver’s silhouette** is the read.

Godot’s OneShot **ABORT** is the engine verb for this (docs). Not a graph design — a named capability.

---

## 4. WHAT MUST BE AUTHORED INTO A CLIP

**Question:** shared start/end pose? Cuttable vs blend-only? Purchase specification before spend?

**Decision: one shared guard across the 14. Loop the cycles. Recover the punch into that guard. Do not buy per-pair in/outs. Boxing sim = blend + interrupt, not SF cut-windows.**

### 4.1 Shared pose — the actual spec

| Authoring | Why | Grade |
| --- | --- | --- |
| **Same stance family** on idle, four cycles, five punches, two reacts | G42: if the jab ends in a different guard than the hook starts, “the blend will swim.” UFC mixed unique **idles** onto **shared** locomotion and still needed procedural help; FightCamp shares **one** idle (J17 / J18). | DIRECT / INHERITED. |
| **Cycles loop:** first frame ≈ last frame | Ordinary cycle contract. Godot: blending without a RESET / rest pose treats missing tracks as identity and **pops**. | DIRECT (Godot “For better blending”). |
| **Punch starts in the idle/shuffle guard** and **ends there** | Absolver: each move **ends in the stance the next starts from** — that is why other games “blink” and Absolver does not. Sifu: build-up / force / **release**. Recovery is the last third of the punch, not a purchased clip. | DIRECT. |
| **React starts from a hit pose**, ends blendable | Massoudi: hit anims “started from a damaged pose” because kinetic energy is already there. Zero fade **in** only works if that first pose **is** the hit. End pose returns toward the shared guard so you can re-enter a cycle. | DIRECT. |
| **Foot-phase / sync markers on the four cycles** | Epic Sync Markers: keep blended cycles in phase. Unity transition graph: white line = foot contact; smooth that line or you **slip / jump**. Out-of-phase cycle → cycle = **double-step**. | DIRECT. |
| **Contact notify on the punch** | Epic notifies: events on the sequence (sound, particles, custom). The **sim already scored** the impact (G42); the notify is for the **picture** (glove, sweat — Fight Night art blog, J17). Not a fifteenth clip. | DIRECT. |
| **In-place** | G42 / J18. Packs that advertise in-place (MCO Punch: “ALL INCLUDED AS IN-PLACE”) match the constraint; root-motion versions do not. | DIRECT / INHERITED. |

**Do not author:** a unique start pose per punch-from-`loc_fwd` vs punch-from-`idle` vs punch-from-`loc_circle_l`. That is the **per-pair list** G42 refused. UFC’s lesson on unique idles was: **do not then capture unique locomotion on top**. FightCamp should not capture unique punches-from-each-cycle either.

### 4.2 Cuttable vs blend-only

| Genre | Contract | FightCamp? |
| --- | --- | --- |
| **Versus fighter** (Street Fighter) | Startup / active / recovery **are the rules**. Cancels are **holes cut in recovery**. Blend ≈ 0. | **No.** G42: we cannot become this. |
| **Souls / For Honor** | Attack is committed **until** poise / hyper-armor fails, then **cut** to stagger. | Interrupt **yes** (Decision 3). Poise meter **not** a buy. |
| **Boxing / MMA sim** (Sherr, Harrower) | Mixer: blend, mask, add, IK. Combo **windows** are stats, not authored cancel frames. Responsiveness > pretty fade. | **Blend + interrupt.** Punches are interruptible one-shots. Knockdown is committed (G42 / J17). |
| **Punch-Out** | Discrete cut. No fade. | Not 3D joins. |

**Purchase specification before spend (typeable):**

1. One guard. Lead foot, hands, height — same family on all 14.  
2. Four cycles: looping, in-place, shuffle (J18), **footfalls marked**.  
3. Five punches: in-place, **start = that guard**, **end = that guard**, contact marked; recovery **inside** the file.  
4. Two reacts: start = hit pose, end = blendable guard; not 1:1 with punch types (J17 / M17).  
5. Fall / get-up: committed; get-up ends in the guard.  
6. **No** plant, step-out, punch-from-walk, idle-to-block as extra roles (J17 already refused block-as-one-shot).  
7. Pose-match in the capture / edit. Marketplace copy that brags about pose-matching is describing **this spec**, not a second cart.

### 4.3 What packs sell that is *not* this spec

MoCap Online Punch (fetched 2026-09-10): “**All idles and transitions have been carefully pose-matched for seamless motion trees.**” “**Detailed motion-captured transitions to and from Idles and locomotions add heightened realism compared to simple blending.**” Starter list actually ships `Idle_To_Block` / `Block_To_Idle` as files; it does **not** ship `loc_fwd` start/stop. Pro marketing includes a “full transition library” as a **tier** vs Starter’s “basic transition set.”

**Grade:** DIRECT as pack copy. **UNVERIFIED_SECONDARY** as ship practice. J17 already: packs are composition, not Fight Night. J18 already: starts/stops are the motion-match budget. The useful sentence in the copy is **pose-matched**, which is Decision 4, not a SKU.

---

## 5. COST OF GETTING IT WRONG — at 9–11 m fixed HOME

**Question:** popping, sliding, floaty double-step, wrong-foot punch — worst at this camera?

**Cite M14 / J18, do not reopen the dial.** HOME: fov 50, pitch −20…−22°, eye 3.8–4.2 m, stand-off **9–11 m**, fixed, mid-thigh-up. J18: 5 cm skate ≈ 6 px; 15 cm For Honor clamp ≈ 18 px; **close/retreat compressed in depth**; **circle is screen-lateral** and not eaten by look-down. M16 / M17: at postage stamp the surviving cue is **whole-body silhouette path**.

| Failure | What it is | At 9–11 m HOME | Rank |
| --- | --- | --- | --- |
| **Silhouette pop** (cycle → punch or cycle → cycle with unmatched guard) | Hands / head jump to a new pose in one fade. Absolver’s “blink between states.” Unity: “jumps in animation.” | **Worst.** The postage stamp **is** the silhouette. A 20–30 cm hand/head jump is many more pixels than a 5 cm foot skate. Happens **thousands of times** (cycle → punch). | **1** |
| **Wrong-foot punch** | Punch clip’s plant is the lead foot; the shuffle is mid-stride on the other foot. Hips and arm disagree. Jungbluth: translating hips on a walking base = “weird legs popping.” UFC spent additive loco + foot plant so a punch and a step **coexist** instead of fighting. | **Second.** Reads as **disconnected mass** — the M16 failure. Depth compression does **not** hide a torso that is still circling while the arm jabs down-camera. | **2** |
| **Floaty double-step** (cycle → cycle out of phase) | Two loops crossfaded without sync: an extra step, or feet interpolating through the floor. Unity transition graph exists to stop this. | **Third**, and **worse on circle** (lateral, unmasked — J18 Maria-only-partly-right). On close/retreat, extra depth-steps are smaller in screen space. | **3** |
| **Floaty punch** (250 ms fade eating a <1 s clip) | The jab never snaps; it eases out of the shuffle. Massoudi: floaty hits fail impact. | **Tied for third.** At HOME you lose the **strike** in the 84% sea of locomotion. The punch becomes a smear. | **3** |
| **Foot skate** (rate mismatch, or idle on a moving capsule) | J18 / G42: match play-rate. Residual few cm inside For Honor’s 15 cm. Idle-glide across **metres** is not that envelope. | **Not the worst at HOME** for a **matched** shuffle. **Is** the worst if they skip the four cycles and idle-glide the 71/84%. That hole is already J18. | **4** (unless they skip locos) |
| **Punch plays out after a scored incoming** | Two fights. G42 desync. Sherr “trapped.” | **Rules failure** more than a camera failure. Still visible as a man punching through a head-snap. | **Do not ship** |

**Worst they can type:** **pose pop on cycle → punch**, then **wrong-foot punch**. Those are join bugs, not clip-quality bugs, and they fire on the common path. CLAIM-TIGHT would scream skate (J18); this memo does not reopen the camera — do not spend the tight on a translating join.

**INHERITED fix (already in the 14 + Decisions 1–4):** pose-match; short fade on punches; additive loco under the punch **or** accept a brief full-body plant; sync the cycles; abort to react on a real hit; rate-match cycles (G42).

---

## 6. IS ANY OF THIS A PURCHASE?

**Question:** own transition clips (plant, step-out, recovery) or always made from owned clips? **Answer plainly** — only part that changes credits spent.

**Q6 one-liner: NO.**

| Candidate extra | What sources actually do | Buy? |
| --- | --- | --- |
| **Plant / weight-shift into the punch** | Fight Night’s **stepping punch** is a **punch family** when outside range (J17: one extra family, not 3 lengths). Inside range, the plant is **in the punch clip**. UFC: additive loco + foot IK, not a plant SKU. | **No extra clip.** If they ever buy J17’s optional step-in, that is a **punch**, already ranked after the four locos (J18). |
| **Step-out / recovery** | Recovery is the **end of the punch** (Sifu release; Absolver end-stance; Sherr visual skill = recover quickly vs over-commit). | **No.** Author into the five punches. |
| **Idle ↔ block one-shots** | MCO lists `Idle_To_Block`, `Block_To_Idle`. J17: block is a **held pose**, not a purchased one-shot. | **No.** |
| **Starts / stops / pivots / refaces** | Epic melee sample **~65** files. J18 refused. UFC: **procedural turn-in-place** so they would not capture turns on every idle. | **No.** |
| **Punch-from-walk, punch-from-strafe, …** | Combinatorial explosion. UFC 2 GDC moral (J17/J18): do not multiply clips. | **No.** |
| **Per-pair in/out poses** | G42: fighting-game authoring list. **Do not start that list.** | **No.** |
| **Pose-matching / sync markers / contact notifies** | Authored **into** the 14. Pack copy calls pose-match “transitions.” | **Spec, not SKUs.** |

**Always made from owned clips:** cycle → punch → cycle is **playback** of files 1–14. Cycle → cycle is **playback** of the four locos + idle. Punch → react is **playback** of a punch interrupted into a react you already bought (J17). The join budget is **authoring discipline + fade times + one additive loco layer + interrupt**, not credits.

Marketplace “transitions vs simple blending” is a **sales line** that the pose-matched 14 already satisfy if Decision 4 is in the brief to whoever captures or edits.

**The only later purchase that is still a punch, not a join:** J17’s optional **step-in** (Fight Night’s actual range extra). It is not required for the joins of the 14.

---

## Recommended joins (research, not a graph)

**Cart unchanged: 14.** J17 ten + J18 four. Shared library. In-place.

| Join | How titles do it | Fade (labelled) | Layer? | Interrupt? |
| --- | --- | --- | --- | --- |
| **cycle → cycle** (intent flip) | Crossfade two pose-matched loops; keep phase (sync / foot contact) | Engine loco ballpark **~200–250 ms** | No | n/a |
| **cycle → punch** (thousands / fight) | Full-body punch; UFC additive loco under it so the shuffle does not die | **Shorter than 250 ms**; shared start pose | **Yes: loco under punch** (UFC). **No: punch as upper-body-only** | Incoming real hit: **abort** |
| **punch → cycle** | Blend-out; recovery **in** the punch | Same order as cycle → punch | Loco resumes as base | If hit during recovery: **abort to react** |
| **punch → react** | Full interrupt (Jungbluth); zero/1f in (Massoudi / Jungbluth) | **0–1 frame in** | Light only: additive flinch, **no** abort | **Abort** on clean/stun |
| **cycle → react** | Same as punch → react, from a loop | **0–1 frame in** | Light: additive on the cycle (Sherr keep-feet) | Abort if the hit should read (M17) |
| **any → knockdown** | Committed (G42 / J17) | Ordinary blend into a committed clip | No | Sim gates it |

**Do not buy:** plant, step-out, recovery, idle-to-block, starts/stops/pivots, punch-from-each-cycle, per-pair in/outs, motion-match coverage.

---

## § UNKNOWN / refused

| Item | Status |
| --- | --- |
| Blend duration in **ms or frames** inside Fight Night, Undisputed, UFC, Real Boxing | **NOT FOUND.** Do not invent. |
| Whether Fight Night aborts a punch on every landed incoming (vs only on stun) | **UNKNOWN.** G42: stun interrupts. Hayes tutorials this hour: not stated. |
| Whether Undisputed combo-flow is blend time, string clip, or physics | **NOT FOUND.** |
| Exact UFC additive-layer weights / bone list | **NOT FOUND.** Named: second locomotion machine, hips / spine, lock-step. |
| A published “wrong-foot punch breaks at *X* px / *X* m·s⁻¹” | **NOT FOUND.** |
| 250 ms as a **boxing** number | **Refused.** It is a Unity / Unreal **default**, not a title census. |
| Upper-body-only punch over walk as the boxing standard | **Refused.** Epic firearm tutorial; UFC found mask-only insufficient. |
| Play-to-completion of a punch after a scored incoming | **Refused** as the default (Sherr trapped; G42 second clock). |
| Purchased plant / step-out / recovery / starts / stops / pivots | **Refused** (J18 + this Q6). |
| Per-pair in/out pose library | **Refused** (G42). |
| Motion matching | **Refused** (G42 / J18). |
| Root-motion joins | **Refused** (G42). |
| Vendors / prices / GDScript / animation graphs / enums | **Refused.** |
| Reopening J17, J18, G42 in-place, M14 camera | **Refused.** |

---

## Do-not-build

1. Treating the 14 as a slideshow (cut with no shared pose).  
2. 250 ms on a <1 s punch because “that is the engine default,” without noticing it is ~30% of the clip.  
3. Inventing a Fight Night millisecond.  
4. Upper-body jab over a walk cycle as the boxing join.  
5. Playing punches to completion after the sim scored a hit.  
6. A fifteenth family of plant / step-out / recovery clips.  
7. Starts / stops / pivots because a melee pack lists 65.  
8. Per-pair in/out poses.  
9. Motion matching or root motion to “solve” joins.  
10. Code, graphs, vendors, prices.

---

## Sources

All fetched or opened **2026-09-10** unless a page states its own date. Primary first.

### Settled local (cite, do not reopen)

1. J17 — THE CLIP COUNT. Local: `/workspace/j19/J17_THE_CLIP_COUNT.md`. Type-first ten; no reach variants; block/slip poses; knockdown 2–3; shared library.
2. J18 — THE OTHER SEVENTY PERCENT. Local: `/workspace/j19/J18_THE_OTHER_SEVENTY_PERCENT.md`. Four in-place shuffles; 14 total; no motion match; HOME slide geometry.
3. G42 — THE CLIP IS 0.82 s AND THE ENGINE TICKS AT 20 Hz. Local: `/workspace/fightcamp-m14/research/G42_CLIP_TIME_VS_TICK_TIME.md`. In-place; additive UFC twin machine; 0.10–0.20 s as G42 craft; stun interrupt; no matching.
4. M14 / M16 / M17. HOME 9–11 m; silhouette-at-distance; two reacts. Do not reopen the dial.

### Primary — boxing / MMA talks, blogs, interviews

5. Geoff Harrower & Lee Dowsett, GDC 2015 Animation Bootcamp, “Inside The UFC Animation System.” Movement state machine; additive second locomotion machine; foot plant; unique idles / shared loco. `https://www.youtube.com/watch?v=Xw47OUed9vE` — GDC Vault: `https://gdcvault.com/play/1021794/Animation-Bootcamp-UFC-Animation`
6. Simon Sherr, “Power of the Punch in EA Sports MMA,” reproduced MMAJunkie forums, 3 Jun 2010. Heat-seeking; combo windows; hit reactions blend/mask/physics; keep your feet; “trapped in unresponsive animation”; responsiveness will not suffer to visuals. `https://forum.mmajunkie.com/threads/ea-sports-mma-official-discussion-thread.26367/page-3`
7. Kelly L. Murdock, “Building Brawl-Handling Interacting Characters in EA Sport's MMA,” GameDev.net, 30 Nov 2010. Layer / override / add; HumanIK; shared source. `https://gamedev.net/tutorials/visual-arts/building-brawl-handling-interacting-characters-r2777`
8. Brian Hayes, *Fight Night Champion* Attacking Tutorial, 21 Feb 2011. Stepping punches. `https://www.youtube.com/watch?v=l3JoCbjRx9k` — FSPC: `https://www.youtube.com/watch?v=sDPWPstX0rw`
9. EA, “EA SPORTS Fight Night Champion Art,” 15 Feb 2011. Physics flinch, not canned. `https://www.ea.com/en-gb/news/fight-night-champion-art`

### Primary — hit interrupt, layering craft

10. Mike Jungbluth, “Anatomy of a Hit Reaction.” Additive = half-measure; 1f in / 12f out; full reacts interrupt. `https://www.youtube.com/watch?v=PSm4MZsDgJA` — GameAnim pointer: `https://www.gameanim.com/2017/03/27/anatomy-hit-reaction/`
11. Peyman Massoudi, “The Role of Animations in Hit Effects,” Game Developer, 25 Mar 2016. Zero crossfade into hits; additive when uninterruptible. `https://www.gamedeveloper.com/programming/the-role-of-animations-in-hit-effects`
12. Sebastian Starke et al., SIGGRAPH 2021, “Neural Animation Layering for Synthesizing Martial Arts Movements.” Traditional layering artifacts; Walk Punch as learned layering. `https://www.youtube.com/watch?v=SkJNxLYNwN0` — patent restatement: `https://patents.google.com/patent/US12444115B2/en`

### Primary — engine manuals (defaults, layer, notify, interrupt verbs)

13. Unity Manual, Animation transitions. Duration; Fixed Duration; interruption; foot-contact graph. Unity 6.0, fetched 2026-09-10. `https://docs.unity3d.com/6000.0/Documentation/Manual/class-Transition.html` — default 0.25 s: Unity issue 853292; `https://discussions.unity.com/t/how-to-change-default-settings-for-animator-state-transitions/798413`
14. Unreal Engine, Using Layered Animations. Official **shoot-while-run** on `spine_01`; “could” be melee. `https://dev.epicgames.com/documentation/en-us/unreal-engine/using-layered-animations-in-unreal-engine?application_version=5.4`
15. Unreal Engine, Transition Rules. Standard blend duration; inertialization **< 0.4 s**; notifies in transition graphs. `https://dev.epicgames.com/documentation/en-us/unreal-engine/transition-rules-in-unreal-engine`
16. Unreal Engine, Animation Blueprint Blend Nodes. Inertialization vs crossfade; layered blend per bone. `https://dev.epicgames.com/documentation/en-us/unreal-engine/animation-blueprint-blend-nodes-in-unreal-engine`
17. Unreal Engine, Animation Notifies. Contact/foot events; Sync Markers. `https://dev.epicgames.com/documentation/en-us/unreal-engine/animation-notifies-in-unreal-engine`
18. Unreal Python API, `AnimInstance.play_slot_animation` default **blend_in_time = 0.25**, **blend_out_time = 0.25**. `https://docs.unrealengine.com/4.27/en-US/PythonAPI/class/AnimInstance.html`
19. Godot 4.5, Using AnimationTree. OneShot FIRE/ABORT; filters; state-machine xfade; Sync vs Immediate. `https://docs.godotengine.org/en/4.5/tutorials/animation/animation_tree.html`
20. Godot 4.5, AnimationPlayer. `playback_default_blend_time = 0.0`. `https://docs.godotengine.org/en/4.5/classes/class_animationplayer.html`

### Primary — other titles (mechanism only)

21. SuperCombo, Cancel. Interrupt in-progress animation; recovery cut. `https://wiki.supercombo.gg/w/Cancel`
22. Eurogamer, “The neverending quest for Absolver's ultimate martial art,” 5 May 2020. End-stance = next start; other games blink between states. `https://www.eurogamer.net/the-quest-for-the-ultimate-videogame-martial-art`
23. Point'n Think, interview with Kévin Roger (Sifu). Build-up / force / release. `https://www.pointnthink.fr/en/interview-kevin-roger-sifu/`
24. Dark Souls poise: interrupt vs play-through. `https://darksouls.wiki.fextralife.com/Poise` — `https://darksouls.wikidot.com/poise`
25. For Honor Feint / hyper-armor interrupt. `https://forhonor.fandom.com/wiki/Feint`

### Pack catalogues (composition only; not vendors, not prices, not ship censuses)

26. MoCap Online Punch. Pose-matched idles; “transitions … compared to simple blending”; Starter list includes `Idle_To_Block` / `Block_To_Idle`; in-place. Fetched 2026-09-10. `https://mocaponline.com/products/punch`

### Secondary — pointers, never a blend census

27. Game Developer, “Video: Watch a blow-by-blow account of animating EA's UFC games,” 17 Aug 2015. Pointer to GDC 2015. `https://www.gamedeveloper.com/production/video-watch-a-blow-by-blow-account-of-animating-ea-s-ufc-games`
28. Digital Trends, Sifu animation interview, 8 Feb 2022. Keyframes, chain. `https://www.digitaltrends.com/gaming/sloclap-sifu-animation-interview/`

---

*End J19. No blend duration was invented as a boxing-title number. Upper-body punch-over-walk is the firearm tutorial, not UFC. Interrupt the punch when the sim scores a real hit. Shared guard is a spec on the 14. Q6 is NO.*
