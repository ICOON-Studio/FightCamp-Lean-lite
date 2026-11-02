# J18 — THE OTHER SEVENTY PERCENT (locomotion for the ticks that are not a punch)

**Desk:** John (research). **Assigned:** 2026-09-10. **Verification date for every live URL:** 2026-09-10.  
**Status:** study only. No GDScript. No animation graph. No vendor. No price.  
**Scope:** what to **add** to J17’s type-first ten so the **71% of ticks spent at distance** are not covered by one `idle`. FightCamp is about to buy clips once for twelve fighters. The engine already names four intents (`FightIntent`: close, hold, retreat, circle). Clips are **in-place**. The engine owns translation (G42). This memo does **not** reopen J17’s punch-type list, reach-variant refusal, block/slip-as-pose, knockdown 2–3, or shared library.

**Grade legend (same as J17 / J15):**

| Grade | Meaning |
| --- | --- |
| **DIRECT** | Quoted or paraphrased from a primary talk, postmortem, official manual, store page, or named developer, fetched 2026-09-10. |
| **INHERITED** | Follows from a DIRECT text without adding a new number. |
| **UNVERIFIED_SECONDARY** | Journalism, wiki, forum, marketplace copy, or a paywalled interview recovered only as a snippet. Not used as a clip census. |
| **UNKNOWN** | Not found, conflicting, or true only as a given night’s production choice. |

An invented locomotion clip count that looks sourced is worse than **NOT FOUND**. Studios rarely publish per-fighter SKU lists. “Industry does not publish this” is a finding.

**Default (cite; do not reopen):**

- **J17** (`/workspace/j18/J17_THE_CLIP_COUNT.md`): buy punch **type** not target; **no** reach variants; `block` / `slip` = held pose / analog lean, not purchased one-shots; knockdown **2–3 clips** not J15’s 12 filmable states; **shared library**; Punch-Out is the cheapest set that still reads as a fight. Type-first ten: `idle`, `jab`, `cross`, `hook_lead`, `hook_rear`, `uppercut`, `react_head`, `react_body`, `knockdown_fall`, `get_up`.
- **G42**: 20 Hz core is the fight; **engine owns translation**; clips **in-place, never root motion**; locomotion cycle speed matched to sim movement; attack clips are not time-scaled the way cycles are.
- **M14 / M15**: live camera **FIXED**. HOME: fov **50**, pitch **−20 to −22°**, eye **3.8–4.2 m**, stand-off **9–11 m**, over near ropes. Elevated three-quarter is the slide-mask. CLAIM-TIGHT is the one labelled exit.
- **Same-hour engine measurement (brief; not a published boxing statistic):** **28.7%** of ticks inside striking range; **~71%** at distance (circling, closing, retreating, resetting). J17’s ten budgets **one clip** (`idle`) for that 71%. That is the hole this memo fills.

---

## Decisions

These are research-desk decisions about **what the sources say a locomotion add-on should be**, not engine design. Typeable. Claude can act without the body.

1. **Buy four in-place locomotion cycles, mapped 1:1 onto `FightIntent`. Do not buy an 8-direction walk/run pack, and do not buy starts / stops / pivots / refaces.** The four: `loc_fwd` (close), `loc_back` (retreat), `loc_circle_l`, `loc_circle_r`. `idle` already in J17 is **hold** (stance-bounce). Facing the opponent is an engine yaw, not a purchased pivot. The sport-shape of the cycle is a **shuffle / bounce-step**, not a third-person walk/run (Thomson GPS mean **0.6 m·s⁻¹**).
2. **Blend space vs discrete: either playback, same purchase.** A blend space still needs the **corner clips**. FightIntent is four named states, not a 360° analog stick. Discrete four-state is the honest graph. A 2D blend (direction × speed) with those four corners plus `idle` at speed 0 is the upgrade path **without a new buy**. 8-dir, starts, stops, pivots are a motion-match budget (Epic melee sample: **65** loco files before you count anything else). G42 already refused motion-matching.
3. **In-place foot-slide at this camera: match play-rate to sim speed (G42). Residual skate of a few centimetres is inside a shipped melee clamp and is partly masked on HOME.** For Honor clamps the entity **15 cm** to the simulated point. Maria / M14 is **right for close and retreat** (depth compression on elevated ¾). She is **only partly right for circle** (screen-lateral on a front-of-ring camera). CLAIM-TIGHT will **not** hide a glide — do not translate on the tight. No boxing title publishes a break speed in m·s⁻¹. **NOT FOUND** as a number; do not invent one.
4. **Do not buy condition-keyed idles (fresh / exhausted / winning / hurt).** One stance. Stamina and per-region damage are already continuous; play them as **rate + additive posture**, which is how Fight Night talks about fatigue and how UFC mixed unique idles onto a **shared** locomotion set. Marketplace “tired / hurt idle” files are **pack composition**, not a required SKU. UFC 1: unique **idle pose** per fighter, **not** unique locomotion per idle — they did not have the budget.
5. **Cheapest set that still reads as a fight at distance:** *Punch-Out!!* (NES 1987 / Wii 2009) again — **zero ring-translation clips**, because the game has **no ring translation**. That is the tell for a fixed-lane brawler, not for a 3D ring with `circle`. Next cheapest **named** pattern that actually translates: a 2D fighter’s `idle` + walk-forward + walk-back (*Street Fighter 6* still ships that grammar). That **fails** `FightIntent.circle`. Smallest 3D set that covers the four intents: **idle + four in-place shuffles**.
6. **Q6 one-liner:** After six punches, buy **locomotion** (a close-cycle), **not** a seventh punch and **not** a second knockdown.
7. **Revised total: 14 clips = J17’s ten + four locomotion cycles.** Do not steal a punch slot or a knockdown slot to pay for it. The 71% is the hole; the ten already spent `idle` on hold.
8. **Refuse:** vendors; prices; GDScript; animation graphs; enums; root motion; unique locomotion libraries × 12 fighters; “buy 8-dir + starts/stops/pivots because blend spaces exist”; J15’s 12 downed states; zipdo-style “41.5% of bouts have a knockdown”; invented per-title locomotion censuses.
9. **NOT FOUND (do not invent):** how many distinct **locomotion clips** a single fighter carries in Fight Night, Undisputed, UFC, or Real Boxing, as a published SKU count. UFC 1’s “6 to 7,000 animation assets” is a **whole-game** library. Undisputed’s “revolutionary footwork” is a **feature line**, not a file count.
10. This memo does **not** design code.

---

## False premises in the brief (correct first)

The brief’s questions are the right questions. These readings of them would be wrong:

| Premise | Correction | Grade |
| --- | --- | --- |
| J17’s ten already covers a fight because it has `idle`. | `idle` is **hold**. 71% of ticks are close / retreat / circle. One bounce loop for translation is the hole. | INHERITED (J17 ten + engine measurement). |
| A blend space means we buy fewer clips. | A blend space **interpolates between samples you already bought**. Epic: you plot clips on the graph. 8-dir still needs eight corners. | DIRECT (Epic Blend Spaces docs). |
| In-place + engine slide is unshippable, so we must buy root motion. | G42 already refused root motion (judges score the tick). For Honor, Just Cause 3, and UFC 2009 all drive the capsule and treat animation as the picture. | DIRECT (G42; Clavet; JC3 GDC; Ueno 2010). |
| Elevated ¾ makes foot-slide irrelevant, so one idle is enough. | M14 masks **category** of glide, especially **depth**. Circle is often **lateral on HOME**. Idle-glide on 71% of ticks is still the picture of the fight. | INHERITED (M14 §6 + FightIntent.circle). |
| Tired/hurt need their own purchased idles because stamina is already in the sim. | Fight Night slows lean and breaks posture from **meters**, not from a second idle SKU. UFC bought unique **idles**, then **procedurally mixed** locomotion on top. | DIRECT. |
| Punch-Out is the wrong tell because it has no locomotion. | Punch-Out is the tell for **what you can drop**. You can drop ring-walk if the game has no ring. FightCamp has a ring and four intents. The Punch-Out lesson is: **do not buy what the sport-shape does not play**. | INHERITED (J17 §6 + this memo §5). |
| Next clip after six punches is a seventh punch (more offense) or a second knockdown (more drama). | 71% of **time** is out of range. Knockdowns are a **rare event** whose frequency as “share of bouts” is **NOT FOUND** (J15). A second fall clip does not fill the 71%. | INHERITED (measurement + J15 Decision 7). |
| Marketplace 8-dir boxing packs are a shipped fighter’s locomotion census. | Packs publish SKUs. Studios almost never do. Use packs only as “what a vendor thinks a minimum set is.” | INHERITED (J17 same rule). |

---

## 1. THE COUNT — how many locomotion clips does a boxing / MMA game carry for out-of-range game?

**Question:** forward, back, lateral both ways, pivot, reset, bounce / stance-idle. Real list + which titles **publish** it.

**Answer they can use:** **NOT FOUND as a per-fighter SKU census** in any shipped boxing or MMA title. What is published is (a) **player-facing footwork features**, (b) **whole-game** asset totals, (c) **procedural refusals** (UFC: do not capture unique locomotion per idle), and (d) **pack / sample** file lists, which are not a Fight Night library.

### 1.1 Full-price boxing / MMA — what is published

| Title | What they actually said | Locomotion SKUs? | Grade |
| --- | --- | --- | --- |
| **EA Sports UFC** (2014), Geoff Harrower & Lee Dowsett, GDC 2015 Animation Bootcamp | Roster **over 100 fighters**. Authenticity required **unique idle poses for every fighter**. “I knew we did not have the budget or the time to capture unique locomotion sets over top of every one of these idle poses,” so they built a **procedural** mix: a **movement state machine** (idle → movement, “pretty standard”) plus procedural **turn-in-place**. Priorities: visual quality, **no foot sliding**, conservation of momentum, **and** twitch responsiveness. Additive **second copy** of the locomotion machine on hips/spine so a punch and a step coexist. | Unique **idles**, **shared** locomotion, procedural turns. How many walk/strafe cycles in the shared set: **NOT FOUND**. | DIRECT (GDC talk transcript). |
| **EA Sports UFC 2** (2016), Harrower & Mathiesen | Ground-game napkin math treated as **impossible**; solved with **mixed idles** + procedural IK, not by buying the multiplied clips. Standing locomotion is not recensus’d. | Standing loco count: **NOT FOUND**. The moral is the same as J17: **do not multiply clips**. | DIRECT (GDC 2016). |
| **EA UFC 2009 Undisputed**, Hiroki Ueno, GDC 2010 | Havok + animation reference poses + full-body IK. Stated goal: **“Use fewer animations more efficiently.”** Punch reaches the body the collision system named. | Fewer clips, IK, not a published loco list. | DIRECT (G42 citation of Ueno; GDC Vault session page). |
| **Fight Night Champion** (2011) | Left stick **moves** the boxer; **flick** = fast lunge / step. Stepping punch when opponent is **outside punching range** (J17). Footwork is a **system** (tap-step vs hold-move; different stamina). Hayes stamina: four regional meters including **legs**; conditioning vs endurance. Community / lab: walking the ring is cheap stamina; **flick-steps** are expensive; gassed boxers get **slower, flatter** movement. Store-era copy: “improved locomotion.” | Analog 360° stick implies a directional set **exists**. File count: **NOT FOUND**. | DIRECT (Hayes attacking tutorial; Hayes stamina walkthrough; FNC manual movement). UNKNOWN (clip count). |
| **Undisputed** (Steel City, 2024) | Steam: “**Revolutionary footwork mechanics**, including a Loose Movement toggle… and **Flat-Footed Movement when your stamina drops.**” “More than 60 individual punches.” Community comparison videos treat **footwork** as the live argument vs Fight Night. | Feature line, not a SKU list. Flat-footed-when-gassed is a **condition on locomotion**, not a published second library. Clip count: **NOT FOUND**. | DIRECT (Steam store, fetched 2026-09-10). |
| **EA Sports MMA** (2010), Simon Sherr | All fighters **share source animations**; procedural tune; fighter-specific **strikes**. Heat-seeking **moves the fighter into range** (J17). | Shared library. Loco subset size: **NOT FOUND**. | DIRECT (J17 §1.1 / Sherr). |
| **Real Boxing** (2012) | Postmortem does not publish a clip count. Distance problem was **three captured reaches + still IK** (J17). Locomotion: unpublished. | **NOT FOUND**. | DIRECT (postmortem; J17). |

**Fight-management titles** with 2D or no ring are not a locomotion source.

### 1.2 What *is* published as a locomotion **file list** (not a shipped fighter)

Use only as **composition**: the kinds of clips a locomotion system is built from. Do not install these numbers as FightCamp’s buy.

| Source | Published locomotion list | Grade |
| --- | --- | --- |
| **Epic / marketplace “Melee Walk Locomotion” (UE5 Animation Sample family)** | **Idles 2**; **Loops 15** (walk F / F_L / F_R / B / B_L / B_R / LL / LR / RL / RR, some with `_02`); **Pivots 10**; **Refaces 8**; **Starts 10**; **Turns 8**; **Stops 12**. That is **~65** locomotion files before attacks. Pack copy: **143** melee-inspired locomotive animations, **root motion**, for **motion-matched** locomotion. | DIRECT as pack copy. **UNVERIFIED_SECONDARY** as ship practice. This is the budget G42 named and **refused** (motion matching; “a 97-clip pack is not a matching database”). |
| **“Street Fight Animations” pack copy** | **2** idle stances; **8** walks; **8** runs; **8** footwork; dodge 4 directions; tired stance **also listed**. | DIRECT as pack copy. UNVERIFIED_SECONDARY as ship. |
| **UE5 boxing character animation (ArtStation listing)** | Locomotion **25**: walking **8 directions**, running **8 directions**, dodging **4**, jump 3, idle 1, idle_alert 1. | DIRECT as pack copy. UNVERIFIED_SECONDARY as ship. |
| **MoCap Online Punch Starter / Basic** (J17) | Starter: **idle + fidget**, **no** walk set. Basic: idle, idle_hurt, idle_tired, idle_really_tired — still **stance**, not ring-walk. | DIRECT as pack copy (J17). The “boxing starter” market often **omits** locomotion and sells punches. That is why J17’s ten has the same hole. |

### 1.3 Versus fighting (different sport — 2D lane, not a ring)

| Title | Published locomotion | Grade |
| --- | --- | --- |
| ***Street Fighter 6*** | SuperCombo: hold toward / back to **walk forward / back**. Compilation videos: every character ships **idle, walk forward, walk back**, plus a **burnout** (tired) walk/idle variant. No circle, no ring. | DIRECT (SuperCombo Movement page; ADAPT Chance compilation description). |
| ***Punch-Out!!* (NES / Wii)** | Little Mac: idle/stance, jab L/R, hook L/R, dodge L/R, duck, block, star punch, knockdown/get-up. **No walk-around-the-ring.** The opponent is a giant in a lane. Mac’s “movement” is **dodge / duck**, which J17 already treated as discrete defense. | DIRECT (Punch-Out wiki moves; GameFAQs; J17 §6). |

**Range, stated honestly:**

- **Shipped boxing/MMA per-fighter locomotion census:** **NOT FOUND.**
- **What full-price talks actually authorise:** a **shared** directional set + **one** stance idle (unique pose optional) + **procedural** turn / mix. Not 65 motion-match files. Not unique locos × roster.
- **What a 2D fighter ships and publishes:** **idle + forward + back** (and, in SF6, a tired **variant** of those).
- **What a motion-match melee pack ships:** **dozens to 100+** (idles, 8-dir loops, starts, stops, pivots, turns, refaces). That is the **ceiling**, and it is the wrong sport-shape for four named intents.
- **Minimum that matches FightCamp’s four intents:** **idle (hold) + 4 in-place shuffles** (close, retreat, circle L, circle R). Pivot and reset are **not** intents. Bounce **is** idle.

**INHERITED for the buy:** do not purchase the Epic melee sample’s 65. Do not invent that Fight Night “must be 8-dir because analog stick.” Analog stick is how a **player** aims; the **sim** here already collapsed that to four named states.

---

## 2. CLIP SET OR BLEND SPACE?

**Question:** continuously blend directional cycles? Does that change what we **buy**?

**Decision: playback may blend; the purchase is still the corners.** A blend space is not a clip. It is a graph you put clips on.

### 2.1 What a blend space needs

Epic Blend Spaces docs (UE 5.x, fetched 2026-09-10): a Blend Space is an asset where you **plot samples** (animation sequences) on a 1D or 2D graph; the pose is a **blend of those samples** from axis inputs. Typical locomotion example in the same docs: **direction × speed**, cycle clips at the compass points, idle at speed 0.

Craft copy that restates the same contract (vendor blogs, graded **UNVERIFIED_SECONDARY** as ship practice, useful only as the interpolation claim):

- 4-dir: maximum gap 45°.
- 8-dir: maximum gap 22.5°; “standard for modern third-person.”
- “How many samples for smooth 360° at two speeds?” — answers in the **8–12** range (4-dir walk + 4-dir run, optional diagonals).

**DIRECT from Epic, INHERITED for the buy:** interpolating between forward and left **still requires a forward clip and a left clip**. You cannot buy “a blend space” instead of cycles. You can **play** four cycles as a blend instead of as a state machine.

### 2.2 FightIntent is not a 360° stick

| Intent | Clip | Why this, not 8-dir |
| --- | --- | --- |
| **hold** | `idle` (already J17 #1) | Stance-bounce. Speed 0. Davis’s “vertical hip movements” live here. |
| **close** | `loc_fwd` | Shuffle toward. |
| **retreat** | `loc_back` | Shuffle away. Boxing stance is not a mirrored forward. |
| **circle** | `loc_circle_l` + `loc_circle_r` | Lateral both ways. Orthodoxy is **asymmetric** (lead foot forward); a mirrored strafe is a different gait. One circle clip + flip is the **desperate** cut, not the research default. |

No `FightIntent.pivot`. No `FightIntent.reset`. Engine already yaws to face. UFC spent **procedural turn-in-place** specifically to avoid capturing turns on top of every idle — and they had 100+ unique idles. FightCamp has a **shared** idle (J17 Decision 6). Do not buy pivots.

Starts / stops: a blend from `idle` to a cycle is the cheap transition. The melee-sample **10 starts + 12 stops** are motion-match coverage. G42: do not start that list.

### 2.3 Does blending change the cart?

**No.** Same four cycles + idle. Blend space = how they **play**. Discrete four-state = how they **play**. Both are legal under G42 (in-place, engine translates, rate-scale the cycle to sim speed).

**Do not buy 8-dir because “we might blend.”** 8-dir is for analog 360° locomotion in a third-person action game. The sim already named four states. Extra diagonals are interpolation quality, not a missing intent.

---

## 3. THE IN-PLACE PROBLEM — how badly does foot sliding read?

**Constraint (G42, non-negotiable):** clips cannot carry root motion; the engine slides the body; cycle play-rate is matched to sim movement.

**Question:** at what speeds does it break? Maria: elevated three-quarter partly masks — is she right? Tolerance at **this** camera?

**Decision: match play-rate (already G42). A few centimetres of residual skate is inside a shipped melee clamp. Maria is right for close/retreat, only partly right for circle. Do not invent a break speed.**

### 3.1 What shipped games actually did with in-place locomotion

| Source | Contract | Grade |
| --- | --- | --- |
| **G42** | For Honor, Just Cause 3, and Unreal “root motion from montages only” agree for a sim-driven actor: **locomotion is in-place, the capsule is the truth.** If a purchased clip’s root translates the fighter, tick 4,113 and the body on screen are different fights. Judges score the first. **Locomotion cycles are routinely rate-scaled to match capsule speed.** Attack clips are not. | DIRECT. |
| **Just Cause 3**, Jeet Shroff & Alex Crowhurst, GDC 2015 | **Game-driven movement:** logic evaluates motion → physics moves the capsule → animation **selects a clip to match**. Animations “could be thought of as well authored on the spot.” Animation-driven (root) was the **other** model; they did not make it the default because coverage explodes. | DIRECT (GDC talk transcript). |
| **For Honor**, Simon Clavet | Code chooses the trajectory; animation is **“a cosmetic detail on top.”** Entity (centre of mass) **clamped ~15 cm** to the simulated point. Delay accepted because **predictability beat responsiveness**. Motion matching is how they **picked** the clip, not how they **authorised the capsule**. G42 already refused matching as the live layer. | DIRECT (GameAnim writeup of the talk; GDC Vault session; Chinese/JP session notes restating the 15 cm clamp). |
| **UFC 2009**, Ueno | IK so the glove arrives **without** letting the clip walk the man. | DIRECT (G42). |
| **UFC 1 (2014)**, Harrower | Visual bar included **“no foot sliding.”** They still did not capture unique locomotion per idle; they mixed procedurally and used additive locomotion so steps continue under punches. | DIRECT. |

**INHERITED:** in-place + engine translation is not a FightCamp eccentricity. It is the **sim-authoritative** pattern G42 already picked. Root motion is how you **lie about distance**.

### 3.2 Maria / M14 — is the elevated three-quarter a mask?

**Cite M14, do not reopen the dial.** HOME: fov 50, pitch −20…−22°, eye 3.8–4.2 m, stand-off 9–11 m, over near ropes, mid-thigh-up weight, **fixed** during live action. M14 Decision 6 / §6: “elevated ¾ compresses ground travel”; “FOV 50° + 9–11 m stand-off”; “avoid side-on / worm’s-eye”; “do not cut on every slide.” Art direction “buys a category of locomotion animation we otherwise have to purchase.”

**Geometry (INHERITED from M14 numbers, not a published perception study):**

Screen-space travel of a point on the canvas scales with ground Δ × focal scale × (1 / stand-off) × viewing incidence.

- At **~10 m** stand-off, **50° vertical fov**, 1080p: a **5 cm** ground slide subtends **~0.3° ≈ 6 px**. A **15 cm** For Honor clamp subtends **~0.9° ≈ 18 px**.
- **Close / retreat** are mostly **in depth** on a front-of-ring camera. Pitch −21° **compresses** that axis. Maria is **right**.
- **Circle** on HOME is often **screen-lateral**. Lateral is **not** compressed by look-down. Maria is **only partly right**. Idle-gliding a circle is the tell the ¾ does **not** eat.
- **CLAIM-TIGHT** (eye 1.6–1.8 m above canvas, fov 35–40°) is a **closer, flatter** shot. The same 5–15 cm skate **screams**. M14 already: tight is labelled, brief, and a **claim**. Do not spend the tight on a translating fighter.

**Is she right?** **Yes, as a category of mask on HOME for depth travel.** **No, as a licence to skip locomotion clips.** The mask makes a **matched-rate shuffle** readable. It does not make **idle-on-a-moving-capsule** look like boxing for 71% of a round.

### 3.3 When does it break? (no invented m·s⁻¹)

| Claim | Status |
| --- | --- |
| A published boxing title names “slide breaks at *X* m·s⁻¹” | **NOT FOUND.** |
| “±20% playback is invisible” | G42 already: **unsourced folklore** for **attack** clips. Modest rate tweaks on **locomotion cycles** are normal. Do not build a punch policy on it; **do** rate-scale cycles to the sim (G42). |
| Foot IK / speed-planting | Epic IK Retargeter: plant when a foot-speed **curve** is below a **Speed Threshold** (their example: **30**, in **curve units**, not m·s⁻¹). UE Foot Placement: lock when world-space foot speed is under a threshold. DigitalRune / craft: IK **glue** during planted frames. These **hide residual** skate; they do not replace a cycle. |
| Stride warp / play-rate vs travel | Horizontal slide is **play-rate not matching travel** (engine blogs, UNVERIFIED_SECONDARY as boxing). G42 already ordered the fix: **match cycle speed to sim movement**. Thomson’s amateur GPS mean **0.6 m·s⁻¹** is a **shuffle**. A walk cycle authored at ~1.4 m·s⁻¹ **will** skate if you play it at boxing speed without a rate match. |
| Break in **this** picture | **UNKNOWN** as a number. Practical tells from the sources: (1) **speed mismatch** (cycle vs capsule) — fix with play-rate, already required; (2) **idle-glide on circle** — fix with a lateral cycle; (3) **CLAIM-TIGHT + translation** — don’t; (4) **side-on / 19° fov** — M14 already refused. |

**Tolerance they can type:** residual skate **inside ~15 cm** (For Honor’s published clamp) is the only **named** envelope in a shipped melee game. At HOME, that is **small in pixels** and **peripheral** (mid-thigh-up). **Idle-glide across metres of ring** is not inside that envelope. IK plant on **hold**. Rate-match on **close / retreat / circle**. No root motion.

---

## 4. STANCE-IDLE vs CONDITION — purchase or procedural?

**Question:** does stance-idle change with the fight (fresh / exhausted, winning / hurt)? Multiple idles keyed to condition = purchase, or procedural lean? Stamina + per-region damage are already continuous.

**Decision: one purchased stance. Condition is procedural / additive on meters you already have. Do not buy a tired-idle family.**

| Source | What they did | Buy a second idle? | Grade |
| --- | --- | --- | --- |
| **UFC 1**, Harrower | Unique **idle pose** per fighter (personality). **Could not afford** unique locomotion **on top of** those idles. Procedural mix. Additive locomotion on spine/hips. | Unique idle was a **roster-authenticity** cost UFC paid because fans know how a named fighter **stands**. FightCamp: **shared library** (J17). Do not import UFC’s per-fighter idle bill. | DIRECT. |
| **Fight Night Champion**, Hayes | Regional anaerobic fatigue: **left arm, right arm, torso, legs**. Conditioning (short) vs endurance (long). Lean **agility drops as stamina drops**; “lean early, not later.” Sway **tied to stamina**: gassed sway is **smaller and more upright** (community restatement of a contemporaneous blog). Walking the ring is cheap; flick-steps and punches are not. | Fatigue is a **meter driving the same moves**, not a second idle SKU in anything Hayes published. | DIRECT (Hayes stamina videos; FNC manual lean). UNVERIFIED_SECONDARY on the sway-blog restatement. |
| **Undisputed** Steam | **Flat-footed movement when stamina drops.** Loose-movement toggle when fresh. | Condition is a **locomotion mode**, still unpublished as extra clips. Could be rate + pose or a second cycle; they do not say. | DIRECT (feature line). UNKNOWN (implementation). |
| **Street Fighter 6** | Unique idle **per character**, plus a **burnout** idle/walk (Drive Gauge empty). Compilation videos exist specifically to show the tired **variant**. | Versus-fighter **movelist** logic: burnout is a **named state** with authored walks. Different genre. Useful only as “tired can be a **variant of the same directions**, not a new direction.” | DIRECT as “SF6 ships a tired walk.” UNVERIFIED_SECONDARY as boxing. |
| **MoCap Online Punch Basic** (J17) | `Idle_Hurt_V1`, `Idle_Really_Tired_V1`, `Idle_Tired` as **catalogue lines**. | Pack composition. J17 already: optional tired idle is **polish**, not the ten. | DIRECT as pack copy. UNVERIFIED_SECONDARY as ship. |
| **Jungbluth / Sherr** (J17) | Additive flinch / masked physics on a small reaction set. | Same trick on **posture**: an additive slump over the **same** idle. | INHERITED. |

**INHERITED for the buy:** stamina and six-region damage are **already continuous**. Keying extra idles to buckets (fresh / tired / hurt) **quantises** a signal the sim keeps smooth. UFC’s lesson is the opposite of a shopping list: they paid for unique **stands**, then **refused** to pay for unique **walks**. FightCamp should not buy either unique stands **or** condition-stands. One shared bounce. Slow it, slump it, flatten the circle when the legs meter is empty — that is Fight Night’s grammar.

**Winning vs hurt as a purchased idle:** **NOT FOUND** as a boxing-title SKU practice. Presentation of “winning” in FNC / Punch-Out is **between rounds** and **celebration**, which J17 did not put on the live ten.

---

## 5. THE TELL — cheapest set that still reads as a fight **at distance**

**Question:** smallest locomotion list a title got away with + title. Punch-Out again?

**Punch-Out again — as the drop, not as the ring.**

**Title: *Punch-Out!!* (NES, 1987), still the grammar of *Punch-Out!!* (Wii, 2009).**

Little Mac at distance **does not locomote**. The “out of range” game is: **idle bounce, then dodge L / dodge R / duck / block**, then a punch. The opponent stays a giant in a lane. There is **no circle**, **no close-cycle**, **no retreat-cycle**. J17 already used this list as the cheapest **fight**. This memo uses it as the cheapest **distance game**: **zero translation clips**, because the **sport-shape has no translation**.

FightCamp **does** translate. The engine named **circle**. Punch-Out cannot be the 3D ring buy. It is the reminder: **do not buy pivots, resets, 8-dir, starts, stops, or tired idles if the sim does not play them.**

**Next cheapest named pattern that actually moves a body in world space:**

**Title: *Street Fighter 6* (and the 2D fighter grammar generally).** Idle + **walk forward** + **walk back**. SuperCombo documents only those two walks. That has been enough to read as a fight **in a lane** for four decades. It **fails** `FightIntent.circle`. Do not buy a 2D fighter’s two walks and then **glide** the circle.

**Cheapest 3D set that covers the four intents (no shipped boxing title publishes this as a SKU list — state that):**

1. `idle` (hold / bounce) — already J17  
2. `loc_fwd` (close)  
3. `loc_back` (retreat)  
4. `loc_circle_l`  
5. `loc_circle_r`  

That is **four new clips**. Desperate cut: one `loc_circle` mirrored (asymmetric stance will look wrong on one side). Do not cut `loc_fwd`; close is the intent that turns the 71% into the 28.7%.

**Full-price boxing does not get away with Punch-Out’s zero.** Fight Night ships analog stick-and-move. Undisputed advertises footwork as a headline. UFC treated locomotion quality (no slide, unique idle, additive steps under punches) as a **Gen-4 bar**. None of them published the file count. The **research** floor for a translating ring is the four-intent set, not “whatever Punch-Out did in a lane.”

---

## 6. ORDERING — next after six punches?

**Question:** seventh punch, locomotion cycle, or second knockdown? Numbers given: **71%** out of range; **47.5%** of scored strikes land in the top two distance buckets; knockdowns in **41.5%** of bouts.

**Q6 one-liner (Decision 6):** After six punches, buy **locomotion** (a close-cycle), **not** a seventh punch and **not** a second knockdown.

### 6.1 Grade the three numbers first

| Number | What it is | Grade |
| --- | --- | --- |
| **28.7% / ~71%** of ticks in / out of striking range | Same-hour **engine** measurement in the brief. Not a CompuBox statistic. Not Davis. | **DIRECT as a FightCamp measurement** (this desk’s hour). **Not** a published sport census. |
| **47.5%** of scored strikes in the top two distance buckets | Same-hour engine measurement in the brief (strikes that **do** land, by distance). | **DIRECT as a FightCamp measurement.** Does **not** argue for a seventh punch: it says landed punches cluster; it does not say 71% of **time** should look like a punch. |
| **41.5%** of bouts contain a knockdown | **Refuse.** J15 Decision 7: knockdown **frequency** (share of pro bouts with ≥1 / per-bout rate) is **NOT FOUND**. J15 named zipdo.co “1.2 per fight / 44% of rounds” as refused folklore. 41.5% is the same family. KO/TKO as a **result** is published; it is not this clock and not a clip-priority. | **UNKNOWN / refused** (J15). Do not use it to rank a second knockdown against locomotion. |

**Published analogs (different units — do not equate to 71%):**

- Davis et al., elite male amateur, *IJSPP* 2015: ~**20 punches**, ~**2.5** defensive movements, ~**47 vertical hip movements**, **per minute**. More bounce-steps than punches. DIRECT (abstract / paper trail).
- Davis et al., post-2013 rules, *JSCR* 2018: ~**21** punches, ~**3.6** defences, ~**56** VHM per minute; “boxing has become **long range** with straight punches, increased defense and **movement around the ring**.” DIRECT (abstract).
- Thomson PhD (Chester, 2015): GPS on amateur boxing movement **35.9 m·min⁻¹**, mean **0.6 m·s⁻¹**. DIRECT (thesis abstract / body snippet). That is a **shuffle**, not a run.

Those studies support the **shape** of the hole (most of a round is not a punch; the legs work continuously; modern amateur boxing lives at range). They do **not** license inventing 71% as a sport fact. The 71% is **this engine’s** tick census.

### 6.2 Why locomotion beats a seventh punch

J17 already bought **five** punch types in the ten (`jab`, `cross`, `hook_lead`, `hook_rear`, `uppercut`). J17’s optional extras were **step-in** (Fight Night’s range solution) or a **miss** variant — not a sixth target, not a seventh type. A “sixth punch” in Q6 is the counterfactual: if they spend the first six slots on punches, **slot seven is not another punch**.

- **71% of time** is out of range. A seventh punch is authored for the **28.7%**.
- J17: **no reach variants**; range is **step-in or IK / move-into-range** (Fight Night, EA MMA). The missing picture of “moving into range” **is** `loc_fwd`, not a longer jab.
- 47.5% of **landed** strikes clustering in two distance buckets is an argument for **J17’s type-first list + one height modifier**, which is already settled. It is not an argument that the **out-of-range majority** should keep looking like `idle`.

### 6.3 Why locomotion beats a second knockdown

J17 already spent **two** of the ten on knockdown (`knockdown_fall`, `get_up`). J17 Decision 4: **2–3 clips**, not 12. A hard-fall / KO vs a bounce-up is the only extra the sources keep talking about. That extra is **polish on a rare event**.

- J15: how often a knockdown happens is **NOT FOUND**. Do not rank clips from 41.5%.
- A knockdown that **does** happen is already readable with fall + get-up (and M15’s KD frame). UFC 2 **replaced canned KO variety with physics** because more KO clips still looked repetitive (J17).
- **Time share:** a knockdown clock is **~10–25 s** of a bout that is otherwise minutes of circling (J15). Locomotion is the minutes.

### 6.4 Order, if the budget is a drip

After J17’s ten, in this order:

1. **`loc_fwd`** — close. Turns distance into the pocket. Fight Night’s stick-toward. EA MMA’s heat-seeking is this motion plus a punch.  
2. **`loc_back`** — retreat. The other half of stick-and-move.  
3. **`loc_circle_l` / `loc_circle_r`** — the intent the 2D-fighter grammar cannot fake; the axis HOME does **not** fully mask.  
4. Only then: J17’s optional **step-in punch**, **miss**, **hard-fall / KO**, **tired additive** — not a seventh punch type, not a condition idle.

If they can only afford **one** clip beyond J17’s ten: **`loc_fwd`**. Not a seventh punch. Not a second knockdown.

---

## Recommended buy (research, not a cart)

**Revised total: 14 clips** for a boxing FightCamp. J17’s ten stand. Four locomotion cycles are **added**. Shared library (J17). In-place (G42). No root motion.

| # | Role | Intent / job | New? |
| --- | --- | --- | --- |
| 1 | `idle` | **hold** — stance-bounce | J17 |
| 2 | `jab` | type | J17 |
| 3 | `cross` | type | J17 |
| 4 | `hook_lead` | type | J17 |
| 5 | `hook_rear` | type | J17 |
| 6 | `uppercut` | type | J17 |
| 7 | `react_head` | landed head | J17 |
| 8 | `react_body` | landed body | J17 |
| 9 | `knockdown_fall` | one fall | J17 |
| 10 | `get_up` | other half of the clock | J17 |
| 11 | `loc_fwd` | **close** | **J18** |
| 12 | `loc_back` | **retreat** | **J18** |
| 13 | `loc_circle_l` | **circle** | **J18** |
| 14 | `loc_circle_r` | **circle** | **J18** |

Playback: discrete four-state **or** a 2D blend with these four at the compass and `idle` at speed 0. **Same files.** Rate-scale each cycle to the sim (G42). Shuffle, not walk. IK plant on hold. Do not translate on CLAIM-TIGHT.

**Do not buy:** 8-dir walk + 8-dir run; starts / stops / pivots / refaces / turns; unique locomotion × 12 fighters; condition idles (tired / hurt / winning); a seventh punch to “fill” distance; a second knockdown **instead of** locomotion; root-motion cycles; reach ×3 (J17).

**Desperate 13:** drop `loc_circle_r` and mirror `loc_circle_l`. Expect the rear-side circle to read wrong on an orthodox stance. Not the research default.

**If the ruleset is MMA:** laterals still matter; takedown entries are a **different** purchase (G42 already: ground is one clip in 97, stop). This memo does not smuggle ground.

---

## § UNKNOWN / refused

| Item | Status |
| --- | --- |
| Per-fighter locomotion **clip** count for Fight Night, Undisputed, UFC, Real Boxing | **NOT FOUND.** Industry does not publish this as a SKU census. |
| Whether Fight Night’s analog stick is 4-dir, 8-dir, or motion-matched under the hood | **NOT FOUND.** Feature is analog move + flick-step. |
| Whether Undisputed’s “flat-footed when gassed” is a second cycle or a rate/pose | **NOT FOUND.** |
| A published **m·s⁻¹** at which in-place slide “breaks” in a boxing title | **NOT FOUND.** |
| 41.5% of bouts contain a knockdown | **Refused** (J15 Decision 7; zipdo-family). |
| Equating 71% engine ticks with Davis’s VHM or Thomson’s metres | **Refused.** Different units. Cite as analog of **shape** only. |
| Blend space as a way to buy **zero** directional clips | **Refused.** Epic: samples on a graph. |
| Root motion to “solve” slide | **Refused** (G42). |
| Unique locomotion per fighter because UFC had unique **idles** | **Refused.** Harrower: they **could not** capture locos per idle. |
| Condition-keyed idle family as a required buy | **Refused** as required. Optional polish only (J17). |
| Vendors / prices | **Refused.** |
| GDScript / architecture / enums | **Refused.** |
| Reopening J17 punch-type list, reach variants, block/slip, knockdown 2–3, shared library | **Refused.** |
| Reopening M14 camera numbers or G42 in-place | **Refused.** |

---

## Do-not-build

1. Leaving J17’s ten unchanged and hoping HOME hides 71% of ticks as `idle`.  
2. An 8-dir + start/stop/pivot cart because a melee motion-match pack lists 65 files.  
3. A blend space with no corner clips.  
4. Root-motion locomotion “so the feet don’t slide.”  
5. Unique locomotion libraries × 12 fighters, or unique locos per condition.  
6. A seventh punch or a second knockdown **in place of** the first locomotion cycle.  
7. Ranking clips from zipdo / 41.5%.  
8. Code, graphs, vendors, prices.  
9. Invented locomotion counts.

---

## Sources

All fetched or opened **2026-09-10** unless a page states its own date. Primary first.

### Settled local (cite, do not reopen)

1. J17 — THE CLIP COUNT. Local: `/workspace/j18/J17_THE_CLIP_COUNT.md`. Type-first ten; no reach variants; block/slip poses; knockdown 2–3; shared library; Punch-Out tell.
2. G42 — THE CLIP IS 0.82 s AND THE ENGINE TICKS AT 20 Hz. Local: `/workspace/fightcamp-m14/research/G42_CLIP_TIME_VS_TICK_TIME.md`. Engine owns translation; in-place; rate-scale locomotion; refuse root motion and motion matching.
3. M14 — THE 3D FRAME. Local: `/workspace/fightcamp-m14/M14_THE_3D_FRAME.md`. HOME fov 50, pitch −20…−22°, eye 3.8–4.2 m, stand-off 9–11 m; slide-mask; fixed live camera.
4. J15 — THE KNOCKDOWN CLOCK. Local: `/workspace/j17/J15_THE_KNOCKDOWN_CLOCK.md` (also `/workspace/j15/`). Frequency **NOT FOUND**; refuse zipdo rates; ordinary clock ~10–25 s.

### Primary — boxing / MMA games, talks, store, manuals

5. Geoff Harrower & Lee Dowsett, GDC 2015 Animation Bootcamp, “Inside The UFC Animation System.” Unique idle per fighter; **no budget** for unique locomotion on top; movement state machine; procedural turn-in-place; no foot sliding as a bar; additive locomotion. `https://www.youtube.com/watch?v=Xw47OUed9vE` — GDC Vault: `https://gdcvault.com/play/1021794/Animation-Bootcamp-UFC-Animation`
6. Geoff Harrower & Jeremy Mathiesen, GDC 2016, “Embracing Animation Complexity in EA UFC 2 Through Procedural Techniques.” Mixed idles; procedural refusal of combinatorial clip explosion. `https://www.youtube.com/watch?v=1nSshgQ3HM4`
7. Hiroki Ueno, GDC 2010, “The Next Generation of Fighting Games: Physics & Animation in UFC 2009 Undisputed.” Fewer animations, IK targeting. GDC Vault: `https://www.gdcvault.com/play/1012304/The-Next-Generation-of-Fighting`
8. Brian Hayes, *Fight Night Champion* Attacking Tutorial, 21 Feb 2011. Stick movement; stepping punches outside range. `https://www.youtube.com/watch?v=l3JoCbjRx9k`
9. Brian Hayes, *Fight Night Champion* stamina / regional anaerobic fatigue. Legs as a region; conditioning vs endurance. `https://www.youtube.com/watch?v=MdMBm7AIsvU` — also `https://www.youtube.com/watch?v=uL1SGRWBlpU`
10. *Fight Night Champion* PS3 manual. Left stick move; flick lunge; lean requires planted feet; stamina cuts agility. `https://eaassets-a.akamaihd.net/eahelp/manuals/fight-night-champion-manuals_Sony%20Playstation%203.pdf` — mirror: `https://manuals.plus/m/2cb6e1c60235569e09142e4c959c6cf388525920e7c8590501a814a2c65413c3`
11. EA Sports Live, “Tips on Footwork in Fight Night Champion,” 2 Mar 2011. Flick-step; step-in punch. `https://www.youtube.com/watch?v=59nScaF7fpY`
12. Steel City Interactive, *Undisputed* Steam store. “Revolutionary footwork”; Loose Movement; **Flat-Footed Movement when stamina drops**; “More than 60 individual punches.” Fetched 2026-09-10. `https://store.steampowered.com/app/1451190/Undisputed/`
13. *Punch-Out!!* (Wii) Little Mac moves (no ring walk). `https://punchout.fandom.com/wiki/Little_Mac` — GameFAQs: `https://gamefaqs.gamespot.com/wii/954363-punch-out/faqs/59380`
14. Simon Sherr, “Power of the Punch in EA Sports MMA” (heat-seeking range; shared source). Reproduced: `https://forum.mmajunkie.com/threads/ea-sports-mma-official-discussion-thread.26367/page-3` — GameDev.net Tiburon: `https://gamedev.net/tutorials/visual-arts/building-brawl-handling-interacting-characters-r2777`

### Primary — in-place locomotion, blend spaces, slide (not boxing SKUs)

15. Simon Clavet / Ubisoft, motion matching in *For Honor*. Animation as cosmetic on a **simulated** trajectory; **~15 cm** clamp. GameAnim: `https://www.gameanim.com/2016/05/03/motion-matching-ubisofts-honor/` — GDC Vault: `https://www.gdcvault.com/play/1023280/Motion%20Matching%20and%20The%20Road` — session notes restating 15 cm: `https://gwb.tencent.com/community/detail/107589`
16. Jeet Shroff & Alex Crowhurst, GDC 2015, “Realizing Responsive High Fidelity Character Movement in Just Cause 3.” Game-driven movement; in-place “authored on the spot”; animation-driven rejected as default. `https://www.youtube.com/watch?v=4Go_hzVhh90` — GDC Vault: `https://gdcvault.com/play/1021981/Finding-Balance-Realizing-Responsive-High`
17. Epic Games, Blend Spaces documentation. Samples plotted on a graph; locomotion example is direction × speed. Fetched 2026-09-10. `https://dev.epicgames.com/documentation/en-us/unreal-engine/blend-spaces-in-unreal-engine`
18. Epic Games, “Fix Foot Sliding with IK Retargeter.” Speed-planting; example **Speed Threshold = 30** (curve units). `https://dev.epicgames.com/documentation/en-us/unreal-engine/fix-foot-sliding-with-ik-retargeter-in-unreal-engine/?application_version=5.2`

### Primary — 2D fighter locomotion grammar (lane, not ring)

19. SuperCombo, *Street Fighter 6* Movement. Walk forward / walk back only, as the documented grounded walks. `https://wiki.supercombo.gg/w/Street_Fighter_6/Movement`
20. ADAPT Chance, “Regular and Burnout Walking Animations For Street Fighter 6.” Idle, walk forward, walk back, burnout (tired) variants. `https://www.youtube.com/watch?v=ekCROM6-Pkw`

### Primary — time-motion (shape of the 71%, not the 71%)

21. Davis, Wittekind, Beneke, “Amateur Boxing: Activity Profile of Winners and Losers,” *IJSPP* 2013 / Davis et al. 2015 elite male amateur: ~20 punches, ~2.5 defences, ~47 VHM **per minute**. `https://www.researchgate.net/publication/262356320_The_Activity_Profile_of_Elite_Male_Amateur_Boxing`
22. Davis, Connorton, Driver, Anderson, Waldock, “The Activity Profile of Elite Male Amateur Boxing After the 2013 Rule Changes,” *J Strength Cond Res* 32(12), 2018. ~21 punches, ~3.6 defences, ~56 VHM / min; boxing **long range**, more **movement around the ring**. `https://journals.lww.com/nsca-jscr/fulltext/2018/12000/the_activity_profile_of_elite_male_amateur_boxing.18.aspx`
23. Edward Thomson, PhD thesis, University of Chester, 2015. GPS: **35.9 m·min⁻¹**, mean **0.6 m·s⁻¹**. `https://chesterrep.openrepository.com/handle/10034/613507` — PDF: `https://chesterrep.openrepository.com/bitstream/10034/613507/1/Edward%2BThomson%2B%282015%29.%2BPhD%2Bthesis.pdf`

### Pack catalogues (composition only; not vendors, not prices, not ship censuses)

24. UE5 Animation Sample / Fab “Melee Walk Locomotion.” 2 idles, 15 loops, 10 pivots, 8 refaces, 10 starts, 8 turns, 12 stops; 143 loco anims; root motion; motion-match. `https://www.fab.com/listings/2bfc9081-688c-457e-bcc1-8d72f794dc98`
25. “Street Fight Animations” pack copy. 8 walks, 8 runs, 8 footwork, 2 idles, tired stance. Preview: `https://www.youtube.com/watch?v=N-hP-cEy6uA`
26. ArtStation, “UE5 Boxing Character Animation.” Walking 8-dir, running 8-dir, idle, idle_alert. `https://www.artstation.com/marketplace/p/0eK6g/animation-resource-ue5-boxing-character-animation`
27. MoCap Online Punch Starter / Basic idle lists (tired/hurt as catalogue). `https://mocaponline.com/products/PUNCH` — J17 already bound.

### Secondary — pointers, never a census

28. Game Developer, “Video: Watch a blow-by-blow account of animating EA's UFC games,” 17 Aug 2015. Pointer to the GDC 2015 talk. `https://www.gamedeveloper.com/production/video-watch-a-blow-by-blow-account-of-animating-ea-s-ufc-games`
29. Wikipedia, *Undisputed* (video game); *Fight Night Champion*. Restate features, not clip counts.
30. Community FNC stamina lab / posture-break videos. Useful as “gassed reads slower,” not as a SKU list. e.g. `https://www.youtube.com/watch?v=RN1e1PcjkHE`

---

*End J18. No locomotion count was invented. J17’s ten stand. Add four in-place shuffles. Blend space does not cut the cart. Maria is right for depth, not for circle. After six punches, buy a close-cycle. Total 14.*
