# J17 — THE CLIP COUNT (how many striking animations a shipped fighter actually carries)

**Desk:** John (research). **Assigned:** 2026-09-10. **Verification date for every live URL:** 2026-09-10.  
**Status:** study only. No GDScript. No animation graph. No vendor. No price.  
**Scope:** what a **purchase list of ten roles** should have been, given how boxing / MMA / fighting titles actually ship animation. FightCamp is about to buy clips once for twelve fighters. The stage-director list is: idle, strike_head, strike_body, strike_leg, react_head, react_body, react_leg, block, slip, knockdown. Block already suspected ~never plays; leg strikes already suspected out of a boxing bout. This memo does **not** re-derive those two suspicions.

**Grade legend (same as J15):**

| Grade | Meaning |
| --- | --- |
| **DIRECT** | Quoted or paraphrased from a primary talk, postmortem, official manual, store page, or named developer, fetched 2026-09-10. |
| **INHERITED** | Follows from a DIRECT text without adding a new number. |
| **UNVERIFIED_SECONDARY** | Journalism, wiki, forum, marketplace copy, or a paywalled interview recovered only as a snippet. Not used as a clip census. |
| **UNKNOWN** | Not found, conflicting, or true only as a given night’s production choice. |

An invented clip count that looks sourced is worse than **NOT FOUND**. Studios rarely publish per-fighter SKU lists. “Industry does not publish this” is a finding.

**Default (cite J15; do not reopen):** J15 listed **12 filmable downed-fighter body states** as a **research inventory of what the camera can see under the rules**, not as an animation spec and not as a clip-buy. This memo uses that list only as a comparison for Q4. It does not reopen the knockdown clock.

---

## Decisions

These are research-desk decisions about **what the sources say a ten-role list should have been**, not engine design. Typeable. Claude can act without the body.

1. **Revise the ten roles. Do not buy by target (head / body / leg).** Buy by **punch type**, then a **height modifier**. Boxing-first replacement of the ten: `idle`, `jab`, `cross`, `hook_lead`, `hook_rear`, `uppercut`, `react_head`, `react_body`, `knockdown_fall`, `get_up`. Drop `strike_leg` and `react_leg` from a boxing bout. Drop `block` and `slip` as **purchased roles** unless the fight is Punch-Out-shaped (discrete dodge buttons). If the tenth slot is kept, spend it on a second knockdown (hard fall / KO) **or** a step-in punch, not on a third target.
2. **Buy reach variants? NO.** Do not multiply the purchase ×3–4 for short / mid / long of the same punch. Shipped titles close a miss-range with **one clip + adjustment** (step-in punch, “heat-seeking” range, IK / HumanIK / motion warp). Real Boxing **did** capture three distances **and still needed IK**. That is the expensive lesson, not the shopping list.
3. **Reaction:strike ratio: far fewer dedicated reaction clips than strike clips.** Not 1:1 per target. Not more reactions than strikes as SKUs. Full-price sims make reactions from **blend / mask / additive / physics** on a small reaction set. Marketplace “starter” packs that sell ~as many hit files as punch files are **pack composition**, not a shipped fighter’s library.
4. **Knockdown count: 2–3 clips, not 12.** Typical ship: fall (maybe light vs hard), on-canvas / count pose, get-up. J15’s 12 are **filmable rule-states**, not SKUs. No sourced title distinguishes twelve downed body-states as twelve purchased clips. UFC 1’s canned KOs were already repetitive; UFC 2 **replaced canned KO with physics**.
5. **What is reused, not bought:** `block` in Fight Night / EA MMA is a **held pose / arm-to-spot**, not a one-shot clip. `slip` in Fight Night / UFC 2 is **analog head / lean**, not a purchased slip clip. Head vs body on a punch is a **modifier** (Fight Night lean-forward = body), not two strike families. Fighters in EA MMA **share source animations**; stars get extras, not a unique ten.
6. **Do not buy the same ten once-each for twelve fighters as twelve unique libraries.** Shared library + a few signature punches for named boxers is how Fight Night and EA MMA talk about it. Unique-per-fighter full sets are **NOT FOUND** as a published boxing/MMA practice.
7. **The tell (smallest set that still reads as a fight):** *Punch-Out!!* (NES 1987 / Wii 2009) Little Mac: jab L, jab R, hook L, hook R, dodge L, dodge R, duck, block, star punch, knockdown, get-up. That is the cheapest list a famous boxing title got away with. It is **type-first**, not target-first, and it has **no leg strike**.
8. **Refuse:** vendors; prices; GDScript; animation graphs; enums; “buy three reach versions of every punch”; “buy J15’s 12 downed states”; standing-eight / knockdown-clock reopen; zipdo-style invented rates; a per-fighter clip census invented from marketplace pack sizes.
9. **NOT FOUND (do not invent):** how many distinct striking **clips** a single fighter carries in Fight Night, Undisputed, UFC, or Real Boxing, as a published SKU count. Undisputed’s “60+ individual punches” is a **player-facing punch list**, not a per-fighter clip census. UFC 1’s “6 to 7,000 animation assets” is a **whole-game** library for 100+ fighters, not per fighter.
10. This memo does **not** design code.

---

## False premises in the brief (correct first)

The brief’s questions are the right questions. These readings of them would be wrong:

| Premise | Correction | Grade |
| --- | --- | --- |
| The ten roles are the right **kinds** of thing; the only question is how many of each. | The ten are **target-sliced** (head/body/leg) plus two defenses plus one knockdown. Shipped boxing titles slice **punch type** (jab / cross / hook / uppercut / overhand) and treat height as a modifier. | DIRECT (Fight Night FSPC; Undisputed punch list). |
| Block and slip must be purchased clips because they are on the director list. | Fight Night: one block **button**, boxer puts the arms on the punch; lean modifier + stick = head movement. UFC 2: independent high/low block + 360° head. Punch-Out buys dodge/duck/block because those **are** the inputs. | DIRECT. |
| Reach miss ⇒ buy 3–4 length versions of every punch. | Real Boxing captured three distances **and still** used IK. EA MMA “heat-seeking” **moves the fighter into range**. Fight Night **step-in punch** when the opponent is outside range. UE Motion Warping’s official example is a punch. | DIRECT. |
| J15’s 12 downed states ⇒ 12 knockdown clips. | J15: filmable **rule-states**, not SKUs. Hayes (UFC 2): canned KO is repetitive; physics replaced it. Punch-Out: a few knockdown flavors, not twelve body-states. | DIRECT (J15 §3; Hayes). |
| Twelve fighters × ten unique roles is how boxing games ship. | EA MMA: **all fighters share source animations**; procedural tune + some fighter-specific strikes. Fight Night: unique punches for **stars**, not a unique ten for everyone. | DIRECT. |
| A marketplace pack’s file count is a shipped title’s per-fighter count. | Packs publish SKUs. Studios almost never do. Use packs only as “what a vendor thinks a minimum set is,” graded UNVERIFIED_SECONDARY for ship practice. | INHERITED. |

---

## 1. THE COUNT — how many distinct striking animations does one fighter carry?

**Question:** shipped fighting / fight-management games (boxing & MMA especially): ranges + named titles. Minimum for acceptable read vs full-price ship, if sources allow.

**Answer they can use:** **NOT FOUND as a per-fighter SKU census.** What shipped titles **do** publish is punch **types**, whole-game asset totals, and (for 2D versus fighters) **frames**, which are a different unit. Do not convert frames to clips.

### 1.1 Full-price boxing / MMA — what is published

| Title | What they actually said | Unit | Per fighter? | Grade |
| --- | --- | --- | --- | --- |
| **Fight Night Champion** (EA Canada, 2011) | Full-Spectrum Punch Control: flick stick through **straight, flared straight, overhand, hook, hookercut, uppercut** per hand. Body = lean-forward **modifier**. Power = **modifier**. Stepping punch when opponent is **outside punching range**. “There are **twice as many punches** available with FSPC compared to TPC.” Stars (Pacquiao, Tyson, Ali, Roy Jones Jr., Frazier) have **unique punch animations**. | Player-facing **punch types** + modifiers, not a clip count | Unique extras for **named** boxers; generic created boxer uses the shared set. How many clips that is: **NOT FOUND**. | DIRECT (Hayes FSPC video; FNC attacking tutorial; Game Informer / Bulletin “twice as many punch types”; IGN FSPC). |
| **Undisputed** (Steel City Interactive, 2024) | Steam / features: “**More than 60 individual punches.** Punch from multiple angles and directions.” Review restatement: four general types (body, straight, uppercut, quick jabs) expanded to 60+ by footing, angle, combos, strong modifier. | Player-facing punch **catalogue** | **NOT FOUND** whether 60 is shared library or per fighter. Roster is 70+ licensed fighters; a unique 60 each would be thousands of strike clips with no source saying that. | DIRECT (Steam store text). INHERITED (do not read as 60 unique clips × every fighter). |
| **EA Sports UFC** (2014) | Geoff Harrower, GDC 2015 Animation Bootcamp: **4 gameplay animators** + 1 presentation; shipped with “**6 to 7,000 animation assets**”; roster “**over 100 fighters**”; submissions: **26** submissions × **21** two-man animations each. “We didn’t end up shipping with many of any of [EA MMA’s] animations.” | **Whole-game** assets | 6–7k / 100+ fighters is **not** 60–70 clips each. Grapple/submission two-man content dominates the number. Standing-strike share: **NOT FOUND**. | DIRECT (GDC talk transcript). |
| **EA Sports UFC 2** (2016) | GDC 2016: combinatorial ground-game napkin math (8×8 states × 4 clips × 15 positions) treated as **impossible** on the same animator budget; solved with **procedural / relative IK**, not by buying the multiplied clips. “Thousands of new animations” in a Grappling/KO marketing video — still not a per-fighter strike census. | Ground-game **explosion**, then procedural refusal | Strike-only per fighter: **NOT FOUND**. | DIRECT (GDC 2016 transcript; UFC 2 gameplay series video). |
| **EA Sports MMA** (2010) | Animation director Simon Sherr: **all fighters share the same source animations**; procedural system tunes look; each fighter mocapped a **base set** plus **fighter-specific strikes**. HumanIK + relative IK + “touch tags” for contact. Adding new punches is a designer/animator action, not an engineer one — implies a **library**, not a published count. | Shared library + extras | Base-set size: **NOT FOUND**. | DIRECT (Sherr MMA blog; GameDev.net Tiburon interview). |
| **Real Boxing** (Vivid Games, 2012) | 5-month, $300k mobile UE3 title. Mocap with real boxers. Postmortem **does not** publish a clip count. Distance problem is discussed as a **failure mode**, not a SKU list (see §2). | — | **NOT FOUND**. | DIRECT (Gamasutra/Game Developer postmortem). |

**Fight-management games** (Title Bout, boxing manager titles with 2D or no ring): they often ship **no** 3D striking library. They are not a clip-count source. **NOT FOUND** as a useful floor for FightCamp’s purchase.

### 1.2 Versus fighting (different genre — frames and movelists, not boxing SKUs)

Use only as a **ceiling / different sport**. Do not buy a Street Fighter movelist for a boxing sim.

| Title | Published number | Grade |
| --- | --- | --- |
| *Street Fighter III: 3rd Strike* | Guinness: **23,039** in-game character animation **frames** (whole game, 1999). | DIRECT (Guinness page). Frames ≠ clips. |
| *Skullgirls* | Art director Alex Ahad: **1,200–1,500 hand-drawn frames per character** (attacks, specials, intros). Lead animator Mariel: ~**1,300** average. Guinness: **11,515** frames / 8 characters = **1,439** average. | DIRECT (Skullgirls art trailer; skullgirls.com 2011 animation post; Guinness). Frames ≠ clips. |
| *Street Fighter 6* | Forum reconstruction: “minimum of around **60 attack animations**” per character (normals, command normals, throws, specials, drive, supers) **not counting** walk/dash/jump. | **UNVERIFIED_SECONDARY**. Versus-fighter movelist, not boxing. |

### 1.3 Minimum that still **reads** as a fight (not a full-price sim)

This is the **acceptable-read** floor, from titles that got away with a tiny list, plus published “starter” pack **composition** (pack copy is not a studio budget).

| Source | Offensive striking set | Notes | Grade |
| --- | --- | --- | --- |
| ***Punch-Out!!* (Wii, 2009) — Little Mac** | Left jab, right jab, left hook, right hook, left/right star punch. | Plus dodge L/R, duck, block. No body-as-separate-family in the player moveset (jabs vs hooks are **height/type**). No legs. | DIRECT (Punch-Out wiki moves; GameFAQs control list). |
| ***Punch-Out!!* (NES, 1987)** | Left/right high and low punches (jab vs hook by hold-up), star punch. | Same type-first logic. Sprite-sheet **clip count**: **NOT FOUND** as a numbered census (sheet exists; nobody published “N animations”). | DIRECT (moves). UNKNOWN (sprite count). |
| **Accolade *Fight Night* (C64, 1985)** | Head blow, body blow, superblow. | Three punch types. Reads as boxing on an 8-bit. | UNVERIFIED_SECONDARY (manual archive). |
| **Published “starter” mocap pack composition** (MoCap Online Punch Starter / Punch Basic) | Starter: **6 punches** (jab, hook, uppercut × L/R) + hits + KO. Basic: **18 punches** (each type × hard × miss) + **19 hits/blocks** + 5 KO/cele. | Vendor catalogue, **not** a shipped Fight Night. Useful only as “what the market thinks a minimum boxing set contains”: **types**, not targets; **miss** variants appear before **reach** variants. | UNVERIFIED_SECONDARY as ship practice. DIRECT as pack copy. |
| **Unity “Basic Boxing/Fighting” pack copy** | 9 punches (jab/hook/cross/upper × high/low), 2 block **stances**, 3 dodges, 6 hit reactions, 3 KOs, idle. | High/low is **height of the same type**, which is closer to Fight Night’s body modifier than to `strike_head` / `strike_body` / `strike_leg`. | UNVERIFIED_SECONDARY as ship practice. DIRECT as pack copy. |

**Range, stated honestly:**

- **Acceptable read (boxing, not a brawl):** on the order of **4–8 strike types** (jab / cross / hook × side / uppercut), **not** 3 target buckets. Named title: *Punch-Out!!*.
- **Full-price boxing sim, player-facing:** on the order of **dozens of punch types** (Fight Night’s 6×2 hands + body + power + step-in; Undisputed’s “60+”). Clip files behind that: **NOT FOUND**.
- **Full-price MMA, whole game:** **thousands** of assets (UFC 1: 6–7k) **shared** across a 100+ roster, with ground/submission eating a large unknown share.
- **Per-fighter unique striking library of “exactly ten roles”:** no sourced title ships that shape.

Jazz Brousseau / We Got This Covered (Fight Night Champion interview) is widely quoted as capturing “**several hundred punch animations**” in a Darcy Hinds mocap session. The live page is login-walled; the snippet is consistent with “hundreds of **takes** in a capture session,” which is **not** “hundreds of shipped clips per fighter.” Grade **UNVERIFIED_SECONDARY**. Do not install 300 as the buy.

---

## 2. REACH VARIANTS — multiple clips, or one + adjust?

**Question (load-bearing):** when the sim says a punch lands at a distance the animation doesn’t cover: buy 3–4 reach versions, or one clip + IK / warp / playback scale?

**Decision: do not buy reach variants.** Adjustment is what shipped combat-sports titles describe. Reach variants ×3–4 the purchase; the titles that tried capture-at-three-distances **still** wrote IK.

| Title / talk | What they did | Buy 3–4 reaches? | Grade |
| --- | --- | --- | --- |
| **Real Boxing** postmortem, “Kismet and Animation” | “**We recorded three different distances for each hit**, so that devs could afford to choose the best one. However, we still had the unusual situation when the boxers began to attack at the same time. We had to use a couple of tricks… **collision detection, inverse kinematics** and selection of the most appropriate action.” | They **tried** multi-distance capture. It was **not enough**. IK still required. This is the closest thing in the record to FightCamp’s ×3–4 idea, and the postmortem files it under **What Went Wrong**. | DIRECT. |
| **EA Sports MMA**, Simon Sherr, “Power of the Punch” | “**RANGE — We do something we lovingly call ‘Heat Seeking’.** We didn’t want skilled, trained fighters whiffing strikes they would never miss if the target is stationary. A trained fighter will also not throw a jab while touching noses, he will back up to make clean contact. … if you as the user throw a strike, **we will move you into a range that will make contact**. … the range you initiate the strike will affect the strike’s speed and power, and will affect your own vulnerability. … Each fighter has a **per strike maximum range** though.” | **No extra clips.** One strike; **locomote into range**; too-far can still whiff and cost stamina. Distance is a **tuning slider**, not a SKU. | DIRECT. |
| **Fight Night Champion**, Brian Hayes attacking tutorial | “**Stepping punches** can be used to close the distance… pushing towards the opponent with the left stick and punching will automatically perform a stepping punch **if the opponent is outside your punching range**.” | **One extra family** (step-in), not 3 lengths × every punch. | DIRECT. |
| **EA MMA / UFC**, contact | Tiburon: HumanIK + **relative IK** + “touch tags” to **maintain contact** between fighters. UFC 1 GDC: relative IK on two-man takedowns/clinch; scale-to-fit so small legs wrap wide shoulders **instead of special-case clips**. UFC 2 GDC: relative IK as the alternative to multiplying ground clips. | IK to **make contact**, not a purchased reach pack. | DIRECT. |
| **Unreal Engine Motion Warping** docs | Official example: “a simple Motion Warping example of a character **warping to a target to punch**.” Inside Unreal (2021): melee / “boop their forehead” is the stated use case. | Engine feature exists so you **do not** author a clip per distance. | DIRECT (docs + Epic stream). |
| **Sifu** (Sloclap talk) | Could not afford “every height for every target”; retarget / cheat the attack downward. | Height, not reach — same **do not multiply clips** moral. | UNVERIFIED_SECONDARY (talk transcript). |

**INHERITED:** buying short/mid/long × every punch is the thing Real Boxing already paid for and then **had to paper over with IK**. Fight Night’s cheaper extra is **one step-in family**. MMA’s cheaper extra is **move the body, then play the punch**. None of these are “purchase three lengths of `strike_head`.”

Playback-scale-only (time-warp the same clip to fake reach) is **NOT FOUND** as a named boxing-title practice. Do not recommend it; do not forbid it. The sourced pattern is **range-move or IK/warp**, not timescale.

---

## 3. Reactions vs strikes — as many, more, or far fewer?

**Question:** ratio of hit-reactions to strikes.

**Decision: far fewer dedicated reaction clips than strike clips.** Playback can look like “a reaction every time you land,” because the same few reactions are **blended, masked, additived, or physics-driven**.

| Source | What they said | Ratio as SKUs | Grade |
| --- | --- | --- | --- |
| **EA MMA**, Sherr | “**HIT REACTIONS — Hit reactions in EA SPORTS MMA are infinitely variable through a combination of animation blending, skeletal masking, and physics.** You can keep your feet (and your ability to move and block the next strike) through most of them.” Severity from “barely notice” → stumble → stun → knockdown → flash KO. | **Not a clip-per-punch list.** One system, many looks. | DIRECT. |
| **UFC 2**, Hayes | UFC 1 KOs were **canned** (hand-animated or stunt mocap) — realistic **and repetitive**. UFC 2: procedural KO; “new hit reactions provide organic visual cues.” Marketing: not canned. | Canned KO **failed the variety test**. Physics replaced **more KO clips**. | DIRECT. |
| **Fight Night Champion** art blog | Muscle flinch/clench “receiving a blow that either lands or is **blocked**” is a **physics / deformation** beat, “none of which are canned effects.” | Reaction **look** ≠ reaction **clip**. | DIRECT (ea.com FNC art). |
| **Mike Jungbluth**, “Anatomy of a Hit Reaction” (GDC-adjacent talk) | Additive hit reactions are “**a half-measure at best**”: they don’t interrupt, so they can’t fully sell power; safest additive is head + torso rotation. Full hit-reacts **do** interrupt. | Industry craft: few full-body reacts + optional additive flinch — **not** 1:1 with the strike list. | DIRECT (talk transcript). |
| **Starter mocap packs** | Punch Starter: **6 punches / 9 hits / 3 KOs**. Punch Basic: **18 punches / 19 hits-blocks**. Unity basic boxing copy: **9 punches / 6 hit reactions / 3 KOs**. | Packs sell **on the order of as many hit files as punch files** at the **minimum** SKU. That is **catalogue**, not Fight Night. | UNVERIFIED_SECONDARY as ship ratio. DIRECT as pack copy. |

**Do not buy `react_leg` for a boxing bout.** There is no sourced boxing title whose player-facing strike list is “head, body, **leg**.” MMA **does** have leg kicks (EA UFC media notes “a ton of different leg kicks”); that is a **ruleset** buy, not a boxing-ten buy.

**Head vs body reactions:** two is enough to **read**. Fight Night already treats body as a **modifier on the punch**, not a third family. A light and a heavy (or additive flinch vs full react) is how Sherr and Jungbluth talk. Three target reacts is the director list mirroring three strike targets — the same false slice.

---

## 4. Knockdown — how many distinct down / getting-up animations?

**Question:** boxing game count. Driven by where-hit vs how-hard? J15 listed 12 filmable downed states — does any shipped title distinguish that many, or is the real number 2–3?

**Cite J15, do not reopen.** J15 Decision 4 / §3: twelve **filmable** states (falling; land-on; on-canvas taking count; ropes-only; voluntary knee; rising still legally down; soles-only bent over; standing taking count; gait-test; glove-wipe; ready/“box”; wave-off still-down). That is **what a camera can see under ABC mechanics**. It is **not** a SKU list. J15 already: “Do not design… animation state graphs, or clip-naming schemes.”

**Shipped titles: 2–3 clips, or physics instead of clips. Nobody sourced distinguishes twelve.**

| Title | Knockdown / get-up practice | vs J15’s 12 | Grade |
| --- | --- | --- | --- |
| **UFC 1** | Canned KO animations (animator or stunt mocap). Hayes: looked real, **got repetitive**. “It’s obviously not possible to put in 200 million unique knockout animations.” | Canned set was **already too small to hide**. Not 12 states. | DIRECT (Hayes, MMA Fighting 13 Nov 2015; GodIsAGeek interview). |
| **UFC 2** | **Procedural KO physics.** Direction of strike + direction of the man being hit + momentum. Semi-conscious balance / leg stiffness so it is not “marionette strings cut” (that was Fight Night 2004 physics, which Hayes calls hilarious and unrealistic). | Variety from **math**, not from 12 clips. | DIRECT. |
| **Fight Night 2004** | Full physics knockouts. Hayes: marionette. | Physics, not 12 states. | DIRECT (Hayes). |
| **Fight Night Champion** | Manual: recover from knockdown; harder each time. Flash knockdowns exist as a **gameplay** beat (skills, body/heart). Get-up is a player recovery, not a 12-state machine. How many fall clips: **NOT FOUND**. | Clock (J15) is **not** implemented as 12 clips in any sourced FNC interview. | DIRECT (manual recovery). UNKNOWN (clip count). |
| ***Punch-Out!!* (Wii)** | Compilation video: knockdowns distinguished by **which punch** (jab / hook / Star Punch) plus **KO** and **TKO**, per opponent. Giga Mac can rise as early as “2.” | **3 knockdown flavors + 2 finish types**, opponent-specific. Still **not** J15’s 12 (no gait-test, no glove-wipe, no ropes-only, no soles-only bent-over as separate clips). | DIRECT (Nintendo Unity compilation title/description; wiki Giga Mac). |
| **Marketplace packs** | Starter: 1–3 KOs + countdown. Unity basic: 3 KOs (body, head×2). “350 Boxing Animations” copy: several get-ups (facedown 180 CW/CCW) + several knockout/hurt. | Even a **350-file** vendor pack does not enumerate J15’s 12 rule-states. Get-up variants are **facing / rotation**, not legal sub-states. | UNVERIFIED_SECONDARY as ship. DIRECT as pack copy. |

**Where-hit vs how-hard:** Hayes (UFC 2) names **direction and momentum** (how the shot travels, how the body is already moving) as the KO drivers — **how hard / which way**, not twelve land-on types. Fight Night flash-KD from **body** on a low Heart rating is a **gameplay flag**, not a new land-on clip. J15 already: land-on (glove / knee / seat / back / face / all-fours) are **clip variants of one legal state**, not separate rules.

**INHERITED for the buy:** **2 clips** if desperate (fall + get-up). **3** if they want the count to **read** (fall, downed-on-canvas loop, get-up). A hard-fall / KO vs a bounce-up fall is the only extra that sources keep talking about. Do not buy D1–D12.

---

## 5. What is reused — which of the ten roles are blend / pose, not a new clip?

| Director role | What shipped titles actually do | Buy as its own clip? | Grade |
| --- | --- | --- | --- |
| **idle** | Shared stance. EA MMA: shared source. Fight Night: locomotion + stance. Tired/hurt idles appear in **packs** and in FNC as stamina presentation, not as a required ten. | **Yes, one stance.** Optional tired idle is a polish extra. | DIRECT. |
| **strike_head / strike_body / strike_leg** | Fight Night: **one punch family**, body = **lean-forward modifier**. Hayes: “To throw any of these punches to the body, simply hold down the lean body punch modifier.” Undisputed: body is a **type/angle**, inside a 60+ punch list, not a third of three. Legs: boxing **no**; MMA **yes** as kicks. | **Do not buy three target families.** Buy **types**. Body = second height or modifier. Legs = **refuse for boxing**. | DIRECT. |
| **react_head / react_body / react_leg** | Blend / mask / physics (Sherr). Additive flinch on top of locomotion (Jungbluth). Packs: a handful of hit_head / hit_body. | **Two** (head, body), not three. Prefer **light + heavy** or additive-over-idle over six target reacts. | DIRECT / INHERITED. |
| **block** | **Fight Night Champion** defensive tutorial (Hayes): “**there’s no need to choose a blocking direction**… your boxer will move their arms to the right spot.” One button; reflexive cover; can punch **while holding block**. **EA MMA:** “Turtle Up” = cover, take shots on the arms; block strength decays until you **let go**. **Punch-Out:** block **is** a discrete hold-up input — that game’s whole language is discrete. | **Boxing sim: no, not a purchased one-shot clip.** A **looping guard pose** (idle-with-hands-up) is enough if they insist on seeing a guard. Punch-Out-shaped input: then yes, a block pose. | DIRECT. |
| **slip** | **Fight Night:** lean modifier + left stick; feet planted; “slip, duck and avoid.” Weave is a **stick circle**, not a clip name. **UFC 2:** “**360° control of your fighter’s head movement**.” **EA MMA:** dodge (timed) vs slip (in the pocket) vs parry — **systems**, clip count unpublished. **Punch-Out:** dodge L/R and duck **are** the game; those **are** clips/sprites. | **Boxing sim with analog lean: no purchased slip clip.** Head offset / lean pose layered on idle. Discrete-dodge game: buy dodge L, dodge R, duck — that **replaces** slip on the list. | DIRECT. |
| **knockdown** | See §4. Get-up is the clip they actually need **after** the fall. Count, wipe, gait are **J15 clock / referee scenery**, not fighter SKUs. | **Fall + get-up** (optional downed loop). Not 12. | INHERITED from §4 + J15. |

**Shared library:** EA MMA DIRECT: “All fighters share the same source animations, but the procedural animation system lets the team tune the visuals in real-time.” Fight Night DIRECT: unique punches for **stars**, not unique everything. UFC 1: 6–7k assets for **100+** fighters. **INHERITED:** twelve fighters should share the revised list; do not buy twelve unique tens.

---

## 6. THE TELL — cheapest set that still reads as a fight

**Smallest list a named title got away with:**

**Title: *Punch-Out!!* (NES, 1987), still the grammar of *Punch-Out!!* (Wii, 2009).**

Little Mac’s in-fight set that **reads as boxing** to anyone who has seen the game:

1. Idle / stance (implied)  
2. Jab left  
3. Jab right  
4. Hook left  
5. Hook right  
6. Dodge left  
7. Dodge right  
8. Duck  
9. Block (hold)  
10. Star punch (special)  
11. Knockdown / KO (on the opponent; Mac has a downed / get-up of his own)

That is **type-first, side-first, discrete-defense**. It is **not** head/body/leg. It has **no leg strike**. Block is a **hold**. Slip is **dodge + duck**, because those are the buttons. It has been enough to read as a fight for four decades, including a 2009 full-price Nintendo boxing game.

**Even cheaper, still a “fight” (not boxing):** Accolade *Fight Night* (C64) — head blow, body blow, superblow. Three strikes. Reads as a boxing **videogame** on 1985 hardware. Not a sim.

**Starter mocap “fistfight” (vendor copy, not a title):** 6 punches (jab/hook/upper × L/R) + idle + block loop + a few hits + one knockout. That reads as **a brawl**. It does **not** read as boxing until jab vs hook vs uppercut are distinct — which is already the Punch-Out tell.

**Full-price tell (what they add after the Punch-Out ten):** more **punch types** (overhand, shovel/hookercut, flared straight), a **body modifier**, a **power modifier**, a **step-in** for range, unique punches for **stars**, physics on the **hit**, not 3 targets × 12 fighters.

---

## Recommended buy (research, not a cart)

If they keep **exactly ten roles** for a **boxing** FightCamp:

| # | Role | Why this, not the director’s name |
| --- | --- | --- |
| 1 | `idle` | Stance. Shared. |
| 2 | `jab` | The punch boxing games are **for**. |
| 3 | `cross` | Rear straight. |
| 4 | `hook_lead` | Side. |
| 5 | `hook_rear` | Side. |
| 6 | `uppercut` | One is enough at this budget; L/R if a slot frees. |
| 7 | `react_head` | Must **read** a landed head shot. |
| 8 | `react_body` | Must **read** a landed body shot. |
| 9 | `knockdown_fall` | One fall. Hard vs bounce is a later extra. |
| 10 | `get_up` | The other half of a knockdown **clock** (J15: ordinary continue is ~10–25 s of **standing there**, not of new land-on clips). |

**Do not buy:** `strike_leg`, `react_leg`, reach ×3, J15’s 12 downed states, unique tens × 12 fighters, a one-shot `block` clip, a one-shot `slip` clip (unless they commit to Punch-Out discrete dodges — then **replace** `uppercut` or `cross` with `dodge_l` / `dodge_r` / `duck`, do not add legs).

**Optional eleventh/twelfth if a slot appears:** step-in punch (Fight Night’s actual range solution); miss variant (packs author miss **before** they author reach); tired idle.

**If the ruleset is MMA, not boxing:** then and only then a **leg kick** belongs. That is a different purchase. Do not smuggle it into a boxing ten because the target picker is ruleset-independent. The brief already suspects this; this memo does not re-derive it.

---

## § UNKNOWN / refused

| Item | Status |
| --- | --- |
| Per-fighter distinct **striking clip** count for Fight Night, Undisputed, UFC, Real Boxing | **NOT FOUND.** Industry does not publish this as a SKU census. |
| Exact reaction:strike **file** ratio inside any shipped boxing/MMA title | **NOT FOUND.** Sherr describes a **system**, not a ratio. |
| Whether any shipped title authors J15’s 12 downed states as 12 clips | **NOT FOUND.** Closest: Punch-Out’s 3 knockdown flavors; UFC canned KO (count unpublished, described as too few); UFC 2 physics (zero canned). |
| Jazz Brousseau “several hundred punch animations” as a shipped number | **UNVERIFIED_SECONDARY** (login-walled interview; snippet only). Treat as mocap-session volume, not SKUs. |
| Playback-scale as the named reach solution in a boxing title | **NOT FOUND.** |
| Block as a purchased one-shot clip in Fight Night | **Refused as a reading.** Hayes: one button, arms to the spot. |
| Vendors / prices | **Refused.** |
| GDScript / architecture / enums | **Refused.** |
| Reopening J15 knockdown clock, standing eight, 3KD, MMA ten-count | **Refused.** J15 / J14 still bind. |

---

## Do-not-build

1. A ten-role cart that is `strike_head / strike_body / strike_leg` + matching reacts.  
2. Reach ×3–4 of every punch.  
3. Twelve knockdown clips because J15 listed twelve **states**.  
4. Unique libraries × 12 fighters.  
5. A `block` one-shot and a `slip` one-shot as the defense story of a boxing sim.  
6. Code, graphs, vendors, prices.  
7. Invented clip counts.

---

## Sources

All fetched or opened **2026-09-10** unless a page states its own date. Primary first.

### Primary — boxing / MMA games, talks, postmortems

1. Brian Hayes, *Fight Night Champion* Full Spectrum Punch Control. IGN / EA Nordic, 27 Jan 2011. `https://www.youtube.com/watch?v=sDPWPstX0rw` — also `https://www.youtube.com/watch?v=OSjXMYwitig`
2. Brian Hayes, *Fight Night Champion* Attacking Tutorial, 21 Feb 2011. `https://www.youtube.com/watch?v=l3JoCbjRx9k`
3. Brian Hayes, *Fight Night Champion* Defensive Tutorial, 21 Feb 2011. `https://www.youtube.com/watch?v=mgonHes0iKA` — reflexive block, no direction; lean = slip/duck.
4. *Fight Night Champion* PS3 manual (EA Help PDF). Body modifier, power modifier, knockdown recovery. `https://eaassets-a.akamaihd.net/eahelp/manuals/fight-night-champion-manuals_Sony%20Playstation%203.pdf`
5. EA, “EA SPORTS Fight Night Champion Art,” 15 Feb 2011. Physics / flinch, not canned. `https://www.ea.com/en-gb/news/fight-night-champion-art`
6. Matt Bertz / Game Informer via *The Bulletin*, “Building a better boxer,” 14 Jan 2011. “Twice as many punch types”; mocap of signature punches. `https://bendbulletin.com/2011/01/14/building-a-better-boxer/`
7. Jazz Brousseau quoting Hayes, We Got This Covered, Fight Night Champion interview. “Twice as many punches available with FSPC compared to TPC.” (Live page login-walled; snippet fetched 2026-09-10.) `https://wegotthiscovered.com/gaming/interview-fn-champion/`
8. Steel City Interactive, *Undisputed* Steam store / features. “More than 60 individual punches.” `https://store.steampowered.com/app/1451190/Undisputed/`
9. Geoff Harrower & Lee Dowsett, GDC 2015 Animation Bootcamp, “Inside The UFC Animation System.” 6–7,000 assets; 4 gameplay animators; 26 submissions × 21 two-man clips; relative IK. `https://www.youtube.com/watch?v=Xw47OUed9vE` — GDC Vault: `https://gdcvault.com/play/1021794/Animation-Bootcamp-UFC-Animation`
10. Geoff Harrower & Jeremy Mathiesen, GDC 2016, “Embracing Animation Complexity in EA UFC 2 Through Procedural Techniques.” Combinatorial ground math; relative IK instead of ×10 content. `https://www.youtube.com/watch?v=1nSshgQ3HM4`
11. Brian Hayes, MMA Fighting interview, 13 Nov 2015. UFC 1 canned KO vs UFC 2 procedural KO; Fight Night 2004 marionette physics. `https://www.mmafighting.com/2015/11/13/9724426/one-on-one-with-brian-hayes-creative-director-of-ea-sports-ufc-2` — parallel: `https://godisageek.com/2015/11/ea-sports-ufc-2-interview/`
12. EA / GameSpot, UFC 2 gameplay series: KO physics, 360° head movement, independent high/low block. 12 Jan 2016. `https://www.youtube.com/watch?v=CxjGzVOtYFI`
13. Simon Sherr, “Power of the Punch in EA Sports MMA,” reproduced on MMAJunkie forums 3 Jun 2010. Heat-seeking range; infinitely variable hit reactions; turtle-up / dodge / slip / parry. `https://forum.mmajunkie.com/threads/ea-sports-mma-official-discussion-thread.26367/page-3`
14. Kelly L. Murdock, “Building Brawl-Handling Interacting Characters in EA Sport's MMA,” GameDev.net, 30 Nov 2010. Shared source animations; HumanIK contact; layer/override/add. `https://gamedev.net/tutorials/visual-arts/building-brawl-handling-interacting-characters-r2777`
15. Krystian Komisarek, “Postmortem: Vivid Games' *Real Boxing*,” Game Developer / Gamasutra, 21 Jan 2013. **Three distances per hit; still needed IK.** `https://www.gamedeveloper.com/business/postmortem-vivid-games-i-real-boxing-i-`
16. Epic Games, Motion Warping docs (UE 5.6). Punch-to-target example. `https://dev.epicgames.com/documentation/en-us/unreal-engine/motion-warping-in-unreal-engine` — also `https://docs.unrealengine.com/en-US/motion-warping-in-unreal-engine/`
17. *Punch-Out!!* (Wii) Little Mac moves: jab L/R, hook L/R, dodge L/R, duck, block, star punch. `https://punchout.fandom.com/wiki/Little_Mac` — GameFAQs controls: `https://gamefaqs.gamespot.com/wii/954363-punch-out/faqs/59380`
18. Nintendo Unity, “Punch-Out!! Wii HD - All Opponent Knockdown, KO & TKO Animations.” Jab / hook / Star Punch knockdowns + KO + TKO. `https://www.youtube.com/watch?v=duMzg4I6mgE`

### Primary — 2D fighter frame counts (different unit; ceiling only)

19. Alex Ahad, Skullgirls art / animation process. 1,200–1,500 frames per character. `https://www.youtube.com/watch?v=5VkDXBsIXso`
20. Mariel, “On Animation in Skullgirls,” 19 Apr 2011. ~1,300 frames average. `https://skullgirls.com/2011/04/on-animation-in-skullgirls/`
21. Guinness World Records, most frames of animation in a 2D fighter (*SFIII: 3rd Strike*, 23,039). `https://www.guinnessworldrecords.com/world-records/98823-most-frames-of-animation-in-a-2d-fighter-videogame` — Skullgirls per-character: `https://www.guinnessworldrecords.cn/world-records/105505-most-frames-of-animation-per-character-in-a-videogame`

### Craft talks (reactions, not boxing SKUs)

22. Mike Jungbluth, “Anatomy of a Hit Reaction.” Additive = half-measure. `https://www.youtube.com/watch?v=PSm4MZsDgJA`
23. H. F. / Game Developer, “The Role of Animations in Hit Effects,” 25 Mar 2016. Additive shakes when full react would cancel. `https://www.gamedeveloper.com/programming/the-role-of-animations-in-hit-effects`

### Pack catalogues (composition only; not vendors, not prices, not ship censuses)

24. MoCap Online, Punch Starter / Punch Basic animation lists. 6 punches + 9 hits + 3 KOs; 18 punches + 19 hits/blocks. `https://mocaponline.com/products/punch` — Basic list also mirrored at `https://mocaponline.com/products/ue4-punch-basic`
25. Unity Asset Store copy, “Basic Boxing/Fighting Animations” (high/low of jab/hook/cross, not three targets). Retrieved via asset index 2026-09-10.

### Secondary — pointers, never a census

26. Kotaku, “Fighting on New Terms, but Still a Champion,” 3 Mar 2011. FNC punch-out-of-duck, inside jab, slip-to-outside. `https://kotaku.com/fighting-on-new-terms-but-still-a-champion-5775125`
27. Wikipedia, *Fight Night Champion*; *Undisputed* (video game). Restate FSPC / “60+ punches.” `https://en.wikipedia.org/wiki/Fight_Night_Champion` — `https://en.wikipedia.org/wiki/Undisputed_(video_game)`
28. J15 — THE KNOCKDOWN CLOCK. Local: `/workspace/j17/J15_THE_KNOCKDOWN_CLOCK.md`. **12 filmable downed states** cited, not re-litigated.

---

*End J17. No clip count was invented. The ten roles should have been punch types, not targets. Do not buy reach variants. Knockdown is 2–3, not J15’s 12. The tell is Punch-Out.*
