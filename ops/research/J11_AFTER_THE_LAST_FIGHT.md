# J11 — After the Last Fight: What Happens When They Stop Competing

**Desk:** John (research)  
**Date:** 2026-09-07  
**Status:** research and proposals only. No `.gd` / `.tscn` / `assets/data` writes. No HANDOFF edits. No UI design.  
**Verification date for all live URLs in this file:** 2026-09-07 unless a source is dated otherwise.  
**Grade vocabulary (from J1 / J10):** `DIRECT` = a primary PDF, commission regulation, federation rulebook, or peer-reviewed dataset states the fact. `INHERITED` = copied from a parent standard or from general (non-combat) athletic-career literature and labelled as such, not claimed as that sport’s published number. `UNVERIFIED_SECONDARY` = media, blogs, commercial analytics, Wikipedia, books without a methods paper. `UNKNOWN` = no source. **A number without a source is UNKNOWN by definition.**

**What this file is not:** a reopening of J10’s peak windows, yearly stat deltas, or KO-risk tables. Cite J10; do not relitigate them. J10 §2 #12 (frequency ranking of why careers end) and #14 (how often a retirement is reversed) sit next to this question. This pass **pushes #14 once more, then rules it**. #12 is not this desk’s job to invent.

**What R51b shipped (assignment fact, not re-read in this workspace):** a fighter asks to retire, the player answers, a granted retirement moves them off the roster into the world population with `status: "retired"`. Then nothing — no next life, and the gym does not know what it lost or gained.

---

## Decisions page (operator calls)

| # | Call | Recommendation | Why (one line) |
|---|------|----------------|----------------|
| D1 | Stay-in-sport **share is UNKNOWN**. Encode **roles + licence gates**, not a %. | Do not ship `p_remain_in_sport = 0.XX`. Ship a role taxonomy and the second’s / coach licence that actually lets a retired fighter work. | No combat-sport population census of post-fight occupations exists. Federations and commissions publish *how to get the licence*, not *how many take it*. |
| D2 | Retired → staff at the **player’s gym** is a **case class**, not a sourced probability | If the gym-keep mechanic ships, it is an **offer / event** labelled authored (`grade: UNKNOWN` as a rate). Gym relationship can flavour who gets the offer. | Stay-at-home-gym, open-own-gym, follow-a-star, and leave-the-sport all exist as documented classes. None has a stay-vs-leave %. |
| D3 | Retirement **reversal rate remains UNKNOWN** (J10 §2 #14 stands after a second push) | Comebacks are fighter- or player-initiated. Gate them on **medical / inactivity flags** (ARP, NSAC, NYSAC, CSAC, NJ), not on a population lottery. | Celebrity comeback lists are selected on the dependent variable. No commission dataset publishes P(unretire \| announced retirement). |
| D4 | A coach’s **own fighting record does not get a quality formula** | Do not encode `fighter_wins → coach_skill`. Federations do not require a fighting record to coach. If a former-fighter staff bonus exists, it is **authored flavour** (trust, gym loyalty), not researched quality. | Everywhere-claimed, sourced-nowhere as a combat regression. Côté & Gilbert define coaching effectiveness as knowledge + athlete outcomes + context, not W–L. USA Wrestling Gold: no athletic-accomplishment waiver. |
| D5 | Medical / licence **outranks “he wants to” at the exit** (extends J10 D8) | ARP rec. 1: clear on **current** medical status and conditioning, **regardless of past athletic achievements**. CSAC may administratively *retire* a boxer (CCR 283). NSAC reviews 38 / 36 months off / 425 rounds; it does not auto-deny. | The medical hold already exists in `BodyReadiness`. The exit needs a **licence / clearance** object, not a folklore “chin” or a cinematic unretirement. |
| D6 | Do **not** average sex / sport / era / amateur–pro (J10 D6) | Federation books (BJJ / judo / wrestling / taekwondo / WKF / sport sambo) **age-band**; they do not hang up the gloves. Pro striking commissions license **seconds** as a separate object. Women’s post-career occupation tables: **UNKNOWN**. | Averaging Olympic judoka dual-career support with a California journeyman’s pension is a data crime. |
| D7 | The game word is a **role + `retired`**, not a made-up identity | Use `coach` / `trainer` / `second` / `cutman` / (BJJ) `professor` / (Muay Thai) `kru` plus `status: retired`. Do not make `old head` the only catalog label. Do not use `alumni`, `inactive`, `RTD`, or `house fighter` for this person. | Wrong word is accidental design: `inactive` implies they might fight tomorrow; `house fighter` is an *active* gym representative; `RTD` is a bout result; `old head` is documented but culturally specific. |
| D8 | Dual-role **while still competing** is real; same-night box-and-coach is often forbidden | A fighter may already be holding pads / cornering teammates before they retire. England Boxing: dual registration allowed, **not** boxing and coaching on the same event. | The “retired → suddenly a coach” cinematic is slower and leakier than the dual-role that already exists. |
| D9 | There is a **third exit**: commission-forced retirement | Player-granted and fighter-asked (R51b) are not the whole set. CA CCR 283: the commission may retire a boxer from further competition for health, mental condition, or inability to compete. One-eye blindness is a hard NSAC bar (NAC 467.017(3)). | Medical hold is a pause. Licence denial / administrative retirement is a career end. The game currently has only the pause. |
| D10 | If the game must author a number, **label it UNKNOWN** | Placeholder slopes, offer chances, and 0–100 “next-life” weights are design. They are not citations. | Same bar as J10 D3 / D4. A dressed guess is worse than a hole. |
| D11 | Do **not** treat California’s boxer pension as a stay-in-sport rate | The pension is the state’s recognition that many boxers *left*. Eligibility is rounds-in-California, not occupation. Vocational draw at 36 requires *retirement*. | LAT 2023–24: accounts exist because boxers are hard to find after they stop. That is exit economics, not a coaching census. |
| D12 | Inactivity ≠ announced retirement ≠ administrative retirement | Three different objects. ARP/NSAC/NYSAC inactivity batteries apply to **returning combatants**. A second’s licence is a **different licence**. A social-media “I’m done” is not a commission status. | Collapsing them would encode a false mechanic. |

**Priority ruling:** P0 = (1) role taxonomy + competitor→second/coach **licence gates**, (2) medical-gated comeback flags that **reuse and extend** J10’s ARP/NSAC/ABC-family set, (3) commission-forced retirement as a third exit next to R51b’s ask/grant. P1 = gym-keep as an **offer**, not a lottery. P2 = vocabulary. **Do not block a next-life module on a stay-in-sport percentage. That percentage does not exist.**

**One operator question:** When a fighter is granted retirement, should the gym get a **staff-offer event** (authored, labelled `UNKNOWN` as a rate, flavoured by gym relationship) **or** only a world-population `status: "retired"` flag until a later design task authors gym staff?

---

## 0. File-level anchors (what the game has today)

This workspace does not contain a live Godot checkout. The following are **assignment facts** from TASK_J11.md plus J10’s excerpts. They are not independently re-read here.

| Object | In the game today (per TASK / J10) | Grade of that statement |
|--------|-------------------------------------|-------------------------|
| Fighter asks to retire; player answers | R51b shipped | Assignment fact (TASK_J11) |
| Granted retirement → world population `status: "retired"` | R51b shipped | Assignment fact |
| Next-life role (coach, second, owner, official, …) | **Nothing** | Assignment fact |
| Gym knows what it lost / gained | **Nothing** | Assignment fact |
| Chronological age integer | Yes (J10 starter excerpt 19–27) | DIRECT to J10 excerpt |
| `BodyReadiness.medical_hold_*` | Yes | DIRECT to J10 excerpt |
| Licence / MRI / commission clearance object | **No** (week-hold, not a licence) | DIRECT to J10 |
| Comeback flag | **No** (J10) | DIRECT to J10 excerpts |
| Staff / coach entity on the gym | **Not in J10 excerpts** | UNKNOWN in this pass |
| Named real athletes as catalog rows | Forbidden (J10 do-not-build #7; restated here) | — |

**If a later module already shipped a stay-in-sport %, a gym-keep lottery, a fighter-record→coach-skill formula, or a 70% comeback constant:** write the contradiction down. **Fix is later.** This file is the input.

J10 contradictions that still apply and are **not** this desk’s fix: single prime-age constant; sex-averaged peaks; yearly game-stat deltas as facts; boxing-style hang-up on IBJJF/IJF/UWW/WT books; 18–31 vs 19–27 generation (J10 §0.3).

---

## 1. Table Claude can lift (each row graded)

**How to read this section.** A DIRECT grade on a *licence rule* is a rule. A DIRECT grade on a *population observation* is a sample, not a law. An UNKNOWN cell must not be filled with a plausible number and then cited. Suggested authored events are labelled UNKNOWN as rates.

### 1.1 Role taxonomy after the last fight

These are **objects that exist**. They are not shares of a retired population.

| `role_id` | What it is in the sport | How it is licensed / credentialed | Fighting record required? | Typical “how soon” that *is* sourced | Grade | Do not treat as |
|-----------|-------------------------|-----------------------------------|---------------------------|--------------------------------------|-------|-----------------|
| `coach_amateur_fed` | Club / national-team coach in USA Boxing, USA Wrestling, England Boxing, judo/WKF-family | Federation coaching pathway (Green/Bronze/Silver/Gold; Copper–Gold; L1–L3). SafeSport / DBS / first aid / safeguarding sit on the licence. | **No** in the sourced pathways | USA Boxing Green = online exam; USA Wrestling Copper ≈ 4 hours; England Boxing L1 = 4-day course, 18+ to hold the licence | DIRECT | A sourced % of retirees who take it |
| `trainer_pro_uk` | BBBofC Trainer/Second: may train *and* second | BBBofC Rules 2024 §16. Trainer/Second vs Second are **different** licences. First Aid required, renewed every 3 years. Trainer purse cap 10% if gross purse ≤ £10,000. | Not a published W–L bar; “experience” is expected for a trainer | First Aid is a gate, not a delay distribution | DIRECT | A US commission second |
| `second` / `cornerman` | Fight-night corner. Ali Act: *licensee* = “trainer, second, or cut man” | Separate **second’s licence**. Age 18 common. CA: written exam + demonstration (4 CCR 218 boxing; 4 CCR 545 kickboxing/MMA). NV: $50 application; manager may second without a second’s licence (NAC 467.057). CO: licensed ≥48 hours before the event; max 3 corners. WA: 18+. NC: no exam, no experience, no physical. MA: application details background; cut work may require a coagulant demo. | **No** combatant MRI/eye/blood battery in the second applications sourced | Hours-to-days (CO 48-hour rule) for the *licence*; not a career-transition delay | DIRECT | The gym’s everyday coach |
| `cutman` | Swelling / cuts between rounds | Usually the **same second’s licence**. Ali Act names “cut man” as a licensee class. MMA promotions often *provide* cutmen (greasing concern). | No formal certification in the commission texts pulled | Apprenticeship is industrial knowledge (Wikipedia / trade press) | DIRECT on Ali Act naming; UNVERIFIED_SECONDARY on “no formal training” | A separate medical licence |
| `chief_second` | The corner’s spokesman to the referee | Identified to inspector/referee before the bout (ABC referee manual; MN / CO / PA / MO rules) | Same as second | Same night as the bout | DIRECT | Head coach of the gym |
| `official` | Referee / judge / timekeeper | USA Boxing officials L1–L3; ABC Boxing Referee Manual 2025; NSAC NAC 467.062. England Boxing: dual coach/official possible with Supervisor sanction. | No sourced fight-record requirement | USA Boxing L1 = clinic + 80% exam; L2 after 24 months active L1 | DIRECT on pathway; UNKNOWN as a former-fighter share | A gym staff slot |
| `gym_owner` | Runs the building / affiliation | Business licence, not a combatant licence. BJJ: affiliate / own academy under a lineage. | n/a | UNKNOWN as a delay | UNKNOWN as a rate; DIRECT that the object exists | A sourced “most retirees open gyms” |
| `padholder` / assistant trainer | Holds mitts, runs classes, is “around the gym” | Often **no** fight-night second licence until they corner. England Boxing L1 may assist a L2 and **may corner**. | No | Dual-role can start **during** the fighting career | DIRECT that L1 can corner; UNKNOWN as a population delay | Head coach |
| `commentator` / `ambassador` / `matchmaker` / `promoter` | Media, brand, booking | Promotion / commission promoter-matchmaker licences are separate objects (NAC 467.052 promoter) | n/a | UNKNOWN | UNKNOWN as shares | Gym staff |
| `left_the_sport` | Not in any combat role | CA Professional Boxers’ Pension: vested on CA rounds; payable at 50, or vocational at 36 **if retired**. MMA CA pension bill approved 2023 (LAT). | n/a | Pension contact often first attempted at 50 (LAT) | DIRECT on eligibility rules; UNKNOWN occupation mix of leavers | A stay-in-sport rate |
| `masters_competitor` | Still competing in an age band (IBJJF Masters, etc.) | Federation age-band, not retirement (J10 D5) | n/a | IBJJF Masters 1 starts at 30 | DIRECT (J10) | A boxing-style hang-up |

**How soon, as a number:** UNKNOWN as a population. What *is* sourced is the **gate**, not the delay distribution: federation courses are hours-to-days-to-a-year-in-grade; a Colorado second can be licensed 48 hours before the bell; a dual-role fighter may already be coaching teammates *before* the last fight.

**INHERITED only, mixed sports, do not copy onto fighters as a combat number:** Kuettel, Boyle, Christensen, Schmid 2018 (*Sport Exerc Psychol Rev*), n = 231 Swiss + 86 Danish + 84 Polish former elite athletes, **35 sports**: 74% of the **Polish** sample worked in a sports-related job (coach, sports teacher, club administrator) vs 35% Swiss and 31% Danish; mean adaptation ~9 months; 60–67% retired voluntarily; 30% Polish and 39% Danish *considered* a comeback ≥1 year later vs 10% Swiss. **Do not encode 74% as an MMA or boxing stay-in-sport rate.** It is a national-system effect (Poland’s sport-job pipeline), not a cage effect.

### 1.2 Competitor → corner: licence gates (the mechanic the gym actually needs)

A retired fighter cannot legally work a **professional** corner in ABC-family jurisdictions without a second’s (or manager’s) licence. That is the honest gate between `status: retired` and “staff on fight night.”

| `gate_id` | Jurisdiction | What the applicant must do | Combatant medical battery? | Age | Grade | Source |
|-----------|--------------|----------------------------|----------------------------|-----|-------|--------|
| `ca_second_boxing` | CSAC | Written exam on fundamentals + CA law; **demonstrate the duties of a second**; waiver if currently licensed as a second elsewhere without discipline | **No** | Not a medical age gate | DIRECT | 4 CCR 218(b) |
| `ca_second_mma_kb` | CSAC | Same shape for martial arts / kickboxing | **No** | — | DIRECT | 4 CCR 545 |
| `ca_manager_as_second` | CSAC | Licensed manager may act as a second without a second’s licence | **No** | — | DIRECT | 4 CCR 215 |
| `nv_second` | NSAC | Application + $50 + photos + criminal / financial-interest questions | **No** | — | DIRECT | NSAC Second App (legacy PDF); NAC 467.012 lists second including trainer |
| `nv_manager_as_second` | NSAC | Licensed manager may act as a second without a second’s licence | **No** | — | DIRECT | NAC 467.057 |
| `co_corner` | Colorado | Licence ≥48 hours before start; 18+; equipment list (bucket, gauze, enswell, cut solutions, …); max 3 corners unless permission | **No** | 18 | DIRECT | 4 CCR 740-1.12 |
| `wa_second` | Washington DOL | 18+; application | **No** | 18 | DIRECT | dol.wa.gov second licence page |
| `nc_second` | NC | Stand-alone licence; **no exam, no education, no experience, no physical** (O*NET 2024) | **No** | — | DIRECT as that listing | onetonline.org licence 37-30913 |
| `in_second` | Indiana | Application, photo ID proving 18+, photo, fee; no CE, no exam, no physical (CareerOneStop) | **No** | 18 | DIRECT as that listing | CareerOneStop licence 18-0000000205 |
| `ma_second` | Massachusetts | Application details background and experience; cut work may require coagulant demonstration | **No** | — | DIRECT | 523 CMR 6.05 |
| `bbbofc_trainer` | UK professional | Trainer/Second licence; First Aid before grant, renew every 3 years; training diary; 10% purse cap ≤ £10k | Not a combatant MRI battery | — | DIRECT | BBBofC Rules and Regulations 2024 §16 |
| `bbbofc_second_only` | UK professional | Second’s licence **does not** permit the holder to act as a Trainer | — | — | DIRECT | BBBofC §16.2 |
| `usa_boxing_second` | USA Boxing amateur | Seconds = certified coaches credentialed for the field of play | Coach pathway, not combatant | 18 for coach licence | DIRECT | USA Boxing National Rulebook rev. 1 Jan 2026, “Seconds” |
| `england_boxing_corner` | England Boxing | L1 Assistant Coach **may corner**; L2 Full Coach independent; 18+; DBS, first aid+AED, safeguarding | Coach pathway | 17 to take L1, 18 to licence | DIRECT | England Boxing Coaching Policy Apr 2025; Rule Book §5 |
| `usa_wrestling_coach` | USA Wrestling | Copper (≈12-and-under) / Bronze (13+); SafeSport + background; **competitive experience not mandatory** | No | — | DIRECT | themat.com / Coachbridge summary of NCEP |
| `usaw_gold_no_waiver` | USA Wrestling Gold | “There are **no waivers** for this task based on previous athletic accomplishments as this task analyzes coaching skills and not athletic proficiency.” | — | — | DIRECT | wrestlingtexas.com Gold Certification page quoting NCEP |
| `suspended_second` | ABC-family | A second **under suspension** shall not work a corner | n/a | — | DIRECT | MN pro boxing rules; SC 20-7.4; 58 Pa. Code §21.10(j) |

**Ali Act definition (federal, boxing):** 15 U.S.C. § 6301(4) — *licensee* means “an individual who serves as a trainer, second, or cut man for a boxer.” DIRECT.

**CSAC volume (not a retired-fighter share):** sunset paper, FY 2017/18 ≈ 1,930 second licences vs ≈ 103 managers. DIRECT as licence counts; UNKNOWN as “how many were former fighters.”

**Do not collapse:** a **gym coach** (everyday teaching) and a **licensed second** (fight night) are different objects. The game’s “retired fighter becomes staff” needs both if they are to work a corner.

### 1.3 Comeback / returning combatant (push on J10 #14, then rule)

**Ruling:** P(announced retirement is reversed) in any single sport or commission dataset = **UNKNOWN**. This desk pushed. The hole is still a hole.

What *is* sourced is the **returning-combatant medical battery** — which applies whether they announced retirement or merely went quiet.

| `flag_id` | Trigger | What the regulator does | Already in game? | Grade | Source |
|-----------|---------|-------------------------|------------------|-------|--------|
| `arp_inactive_12_mo` | Professional inactivity > 1 year | High-risk combatant (LOE V). Extra screening. | No inactivity clock (J10) | DIRECT | ARP 2026 high-risk statement (J10 #10) |
| `nsac_inactive_36_mo` | No pro fight in 36 months | “Comprehensive Contestant” battery; **Commission (or Chair) review**, not auto-deny | No | DIRECT | NAC 467.017(1)(d); NSAC PHYSICAL-2025 |
| `nsac_age_38` | Age 38 or turns 38 this calendar year | Same comprehensive contestant + Commission review | Age integer exists | DIRECT | NAC 467.017(1)(b); PHYSICAL-2025 |
| `nsac_rounds_425` | >425 professional rounds | Same | No rounds-total (J10) | DIRECT | NAC 467.017(1)(c) |
| `nsac_one_eye` | Blind in one eye / physician recommends against | **Will not** issue or renew combatant licence | No | DIRECT | NAC 467.017(3) |
| `nsac_serious_head` | Cerebral hemorrhage or serious head injury | Commission review before issue/renewal | Partial via medical hold | DIRECT | NAC 467.017(4) |
| `nysac_high_risk` | 40+ **or** 6 consecutive losses any method **or** 3 consecutive TKO/KO **or** 1+ year inactivity after starting pro career **or** 10+ pro losses | Extra MRI (SWI/GRE), MRA, neuro exam, neurocognitive (ImPACT or paper), cardiac, extended labs | No | DIRECT | NYSAC Medical Manual 8 May 2024, §7 |
| `csac_no_age_limit` | — | **No age limit.** Extra testing discretionary. Listed factors include actual age, bouts, rounds, KOs with LOC in 12 months, **inactivity > 12 calendar months**, last-24-month record, vision (Rule 282), previous cerebral hemorrhage. Passing tests **does not guarantee** a licence: applicant **must demonstrate ability to perform**. | No | DIRECT | CSAC FAQs |
| `csac_admin_retire` | Ability to perform questionable (health, mental condition, no longer able to compete, any other reason) | Commission may **retire the boxer from further competition** | No | DIRECT | 4 CCR 283 |
| `co_45_five_years` | Age 45+ **and** not routinely fighting permitted events for the past five years | Extra: general physical + Senior Athletes Fitness Examination (SAFE), routine EKG and/or physician-recommended tests | No | DIRECT | 4 CCR 740-1.6(D)(3) |
| `nj_six_losses` | Six consecutive losses | **Automatically suspended** until commission-appointed medical exam | No | DIRECT | N.J.A.C. 13:46-12B.3(a) |
| `nj_inactive_1_yr` | Inactive one year or more | Suspended until the same medical exam | No | DIRECT | N.J.A.C. 13:46-12B.3(b) |
| `ma_age_35_default` | Reached 35th birthday | Default **bar**; commission discretion with physical. Exceptions: world champion still active; former world champion inactive ≤ 2 years. Amateur 16+ as amateur. | No | DIRECT | Mass. G.L. c. 147 § 39 (Acts 2009 ch. 169 text as pulled) |
| `arp_older_35_cv` | Age > 35 | Older fighter. Annual AHA 14-point CV screen; ECG at initial licensure and annually; BP >160/100 disqualifying until controlled | No | DIRECT | Bianchi et al. 2024 *Phys Sportsmed*; Combat Sports Law recap of Table 1 |
| `arp_older_40_neuro` | Age ≥ 40 | MRI+MRA (SWI/GRE) at initial licensure; MRI every 3 years; neuropsychological eval at initial + every 3 years | No | DIRECT | Same Table 1 (neuro at **40**). ARP 2-page summary PDF on ringsidearp.org says neuro at 35 — **conflict**; prefer the peer-reviewed Table 1. |
| `arp_clear_current_not_past` | Any older / returning fighter | Clearance in the context of **current** medical status and conditioning, **regardless of past athletic achievements** | No | DIRECT | ARP 2024 rec. 1 |

**J10 inactivity / layoff performance (do not reopen as new research):** FightAlpha / AgentMMA 2026 UFC decided-fight tables are **UNVERIFIED_SECONDARY**, inactivity not announced-retirement, and already in J10 Q6. Direction: ≥12 months vs an active opponent looks worse. Peer-reviewed confirmation: UNKNOWN. Geezers Boxing n=20 celebrities “70% return within 5 years”: **do not lift** (selected on the dependent variable; J10 already killed it).

**What a game may honestly do instead of a reversal rate:**

1. Keep `status: retired` as a state (R51b).  
2. Allow a comeback **request** (fighter or player).  
3. Run the **returning-combatant flag set** above. Failed clearance = no fight, not a cutscene.  
4. Do **not** roll a sourced 0.70.  
5. If a first-fight-back modifier is needed, reuse J10’s labelled-UNKNOWN / UNVERIFIED_SECONDARY layoff direction; do not invent a new “rust-off” cinematic as research.

Kuettel 2018 (INHERITED, mixed sports): 10–39% *considered* a comeback ≥1 year later. That is not P(reversed). Do not encode it as combat.

### 1.4 Gym-keep (the mechanic the game most needs)

**Ruling:** stay-with-the-gym-that-trained-them vs leave vs open-own is **UNKNOWN as a rate**. It is **real as case classes**.

| `case_id` | What it is | What is evidenced | Encode as | Grade |
|-----------|------------|-------------------|-----------|-------|
| `stay_home_gym` | Former fighter remains at the gym that trained them, now coaching / holding pads / cornering | Ethnography: Sacha 2015, one South L.A. amateur gym, coaches as “old head” mentors. Journalism case class: champion-to-coach staying at the same MMA gym (The Athletic 2019 — **do not catalog the name**). Dual-role while competing is common enough to be a Sherdog feature (2018). | Staff-offer flavoured by gym relationship | DIRECT that the class exists (ethnography); UNVERIFIED_SECONDARY on named MMA examples; UNKNOWN as a % |
| `open_own` | Leaves (or affiliates out) and opens a gym | Industrial pattern in MMA/BJJ (own gym as USP of a former fighter). BJJ lineage/affiliate model. Fighters Only / trade press. | A later-career event, not automatic | UNVERIFIED_SECONDARY as “most obvious path”; UNKNOWN as a % |
| `follow_star` / travelling cornerman | Leaves with a teammate or becomes a hired second | Commission second licences exist specifically so corners can work *other people’s* fights | Second licence without gym employment | DIRECT that the licence exists; UNKNOWN as a % |
| `leave_sport` | No combat role | CA pension exists because boxers are hard to find after they stop (LAT 2023–24). Hong & Hong 2023: Olympian judokas (n=8) report identity/goal loss; coaching felt like the only paid option for some because they had no other qualification. | World-pop `retired` with no gym hook | DIRECT on pension/eligibility and on the qualitative judo paper; UNKNOWN as a % |
| `dual_role_active` | Coaches / corners **while still licensed as a combatant** | England Boxing Rule Book §5.4: dual registration allowed; **not** box and coach on the same event. USA Boxing / many MMA gyms run this every week. | A flag *before* retirement | DIRECT on the EB rule; UNKNOWN as a prevalence |

**Suggested authored (UNKNOWN as a rate) gym-keep sketch — not a citation:**

- On granted retirement, if gym relationship is high and the fighter is not under a medical career-ender, fire a **staff-offer** (`padholder` or `assistant_trainer`).  
- Accepting the offer does **not** put them in a pro corner until a `second` licence gate is passed.  
- Refusing / no offer → world-pop `retired`.  
- Opening-own-gym and leave-sport are later events, not this desk’s numbers.

That sketch is **UNKNOWN**. It is here so Claude does not invent a different sketch and call *that* researched.

### 1.5 Coach quality vs fighting record

| Claim | Status | Grade | What to encode |
|-------|--------|-------|----------------|
| Better fighter record → better coach | **Sourced nowhere** as a combat-sport regression of W–L / titles / win% on pupil outcomes | UNKNOWN | **Do not encode** |
| Fighting experience is required to coach | **False** as a federation rule in the pathways pulled | DIRECT | No `min_fights_to_coach` gate |
| Time spent as an athlete in the sport correlates with later high-school coaching success | Gilbert, Lichtenwaldt, Gilbert, Zelezny, Côté 2009, n=16, **basketball and cross-country**, not combat | INHERITED; not W–L | Do not copy onto FightCamp coaches |
| Coaching effectiveness = professional + interpersonal + intrapersonal knowledge applied to athlete competence / confidence / connection / character in a context | Côté & Gilbert 2009 *Int J Sports Sci Coach* | INHERITED (all-sport definition) | If a coach-quality object exists, it is **knowledge / outcomes**, not the staff member’s old record |
| USA Wrestling Gold will not waive coaching tasks for previous athletic accomplishments | NCEP Gold text | DIRECT | — |
| “Great fighters make great coaches” / inverse “best performers are rarely the best coaches” | Trade blogs, TUF win% lists, honour-and-glory trainer roundups | UNVERIFIED_SECONDARY | Flavour text at most |
| Champion-to-elite-full-time-coach described as “a rarity” in MMA | The Athletic 2019 | UNVERIFIED_SECONDARY | Not a rate |

**Lift rule:** a former fighter on staff may carry **gym loyalty / trust / dual-role continuity**. That is design. It is not a researched `fight_iq` inheritance onto pupils.

### 1.6 Vocabulary (wrong word = accidental design)

| Term | Who uses it | Means | Use in game? | Grade |
|------|-------------|-------|--------------|-------|
| `second` / cornerman | Commissions, Ali Act, ABC | Licensed fight-night corner | **Yes**, as the fight-night role | DIRECT |
| `trainer` | Boxing gyms, BBBofC, Ali Act | Gym teacher and/or licensed trainer | **Yes**, boxing-shaped gyms | DIRECT |
| `coach` | MMA, wrestling, Olympic federations, England Boxing | Everyday teacher; may also corner | **Yes**, MMA/Olympic-shaped gyms | DIRECT |
| `cutman` / cut man | Ali Act; corners | Cuts and swelling | **Yes**, as a specialist second | DIRECT (Ali Act) |
| `chief second` | ABC referee manual, state rules | Corner spokesman | **Yes**, fight night | DIRECT |
| `professor` | BJJ academies | Black-belt instructor | **Yes**, on BJJ books | UNVERIFIED_SECONDARY as universal; DIRECT as widespread gym usage |
| `kru` / `ajarn` | Muay Thai | Teacher / master | **Yes**, on Muay Thai books, not as a universal | UNVERIFIED_SECONDARY as English-gym default; DIRECT as Thai usage |
| `sensei` | Judo / karate dojo | Teacher | Use on traditional dojo books; sport federations often say `coach` | UNVERIFIED_SECONDARY as the sport-judo default |
| `old head` | US amateur boxing gym ethnography | Older male mentor in the gym, enforcing gym-vs-street rules | **Flavour**, not the only catalog label (culturally specific) | DIRECT as Sacha 2015’s term for that gym |
| `retired` | Commissions (CA can *retire* a boxer); journalists | No longer competing; in CA, an administrative act | **Yes**, as `status` | DIRECT |
| `inactive` | Commissions | No recent fight; still a combatant until they fail a battery | **No** as the identity of a retired person | DIRECT as a medical flag, not a noun |
| `house fighter` / `stablemate` | Gyms, boxing press | **Active** fighter who represents the gym | **No** for a retired person | UNVERIFIED_SECONDARY usage; meaning is active |
| `veteran` | Press | Often still fighting | **No** as the retired noun | — |
| `RTD` | BoxRec / bout result | Retired on the stool **this bout** | **No** as a career status | DIRECT as a result code |
| `alumni` | Colleges, not gyms | — | **No** | — |
| `legend` | Marketing | Honorific | **No** as a role | — |
| `staff` | HR | Employment | Too thin alone: hides the second-licence gate | — |

**Recommendation:** store `status: retired` plus a `role` from the taxonomy. The gym’s sentence is “he’s in the corner now” or “he holds pads,” not “he is an alumnus.”

### 1.7 Do not encode this

1. Any `p_remain_in_sport`, `p_stay_at_gym`, `p_unretire`, or `p_open_gym` presented as researched.  
2. Geezers Boxing 70% / 5.15-year gap / 68.75% comeback-win (n=20 celebrities).  
3. Kuettel 74% Polish sport-jobs as an MMA or boxing number.  
4. `fighter_record → coach_quality` (or titles, or win%).  
5. A 0–100 “next-life pressure” formula.  
6. Yearly coaching-quality deltas.  
7. Sex-averaged post-career pathways.  
8. Boxing hang-up-the-gloves cinematic on IBJJF / IJF / UWW / WT / WKF / sport sambo books (J10 D5).  
9. Catalog rows of named real athletes.  
10. `old head` as the **only** identity string.  
11. Equating `inactive`, `retired`, and `RTD`.  
12. A tissue `chin` stat (J10 D8).  
13. Sport-wide cornerman wage tables.  
14. FightAlpha layoff tables as *announced-retirement* reversal (they are inactivity).  
15. “Great fighters make great coaches” as a mechanic.  
16. California pension counts as a stay-in-sport census.  
17. A single ABC-family second exam (CA has one; NV/NC do not).  
18. Silent reuse of men’s post-career anecdotes onto women’s books.

---

## 2. What this desk could NOT source

This list is first-class. Mark these `UNKNOWN` in data rather than filling them.

1. **Share of fighters remaining in ANY combat role** (coach, cornerman, matchmaker, cutman, commentator, promoter, gym owner, official, ambassador) after the last professional fight, in any single sport, as a population rate.  
2. **How soon** after the last fight that role begins, as a distribution. Dual-role *during* the career is evidenced; a delay-from-last-bell is not.  
3. **Stay at the training gym vs leave vs open-own vs follow-a-star**, as percentages of a defined retired population.  
4. **P(announced retirement is reversed)** in any sport or commission dataset (J10 §2 #14 **stands** after a second push). Celebrity lists are not a rate.  
5. **Layoff length among reversed retirements** as a distribution (distinct from inactivity layoffs).  
6. **Comeback performance after an announced retirement** as a peer-reviewed effect size. J10’s commercial UFC layoff tables remain inactivity, UNVERIFIED_SECONDARY.  
7. **A coach’s own fighting record as a predictor of coaching quality** in boxing, MMA, Muay Thai, kickboxing, BJJ, judo, wrestling, taekwondo, karate, or sambo.  
8. **Women’s** post-career occupation tables in any of those sports.  
9. **Muay Thai / kickboxing / sambo / Karate Combat** post-career censuses.  
10. **Amateur vs professional** stay-in-sport rates (do not average).  
11. **Share of licensed seconds / cutmen / referees who are former combatants.** CSAC second-licence *counts* exist; the former-fighter fraction does not.  
12. **Frequency ranking of why careers end** as % of a population (J10 §2 #12 **stands**).  
13. **Time from last fight to first licensed second assignment.**  
14. **Dual-role prevalence** (fighting and coaching in the same season) as a %.  
15. **Sport-wide cornerman / cutman wage tables.** Ali Act and BBBofC 10% caps are rules, not wages.  
16. **NSAC vs CSAC vs NYSAC vs BBBofC vs England Boxing** as one second-licence exam. They disagree.  
17. **Female vs male** next-life mix.  
18. **Whether R51b already shipped gym-staff after retirement.** Not in this workspace.  
19. **Polish MMA n=88 retirement *occupation* table.** Lenartowicz et al. 2025 surveyed *active* male pros (mean age 27.5, ≥3 pro fights) on career *planning*; the occupation-after-retirement crosstab was not in the open abstract.  
20. **Olympian-to-coach % inside combat sports.** Mixed-sport Olympian surveys exist; a judo/wrestling/boxing-only table was not sourced this pass. Hong & Hong 2023 is n=8 qualitative.

---

## 3. Answers to the six questions

### Q1 — Do they stay in the sport?

**The share remaining in ANY role is UNKNOWN.** This desk looked for a commission registry follow-up, a federation alumni survey, and a peer-reviewed combat occupation table. None of those objects appeared. A number here would be invented.

**What is sourceable:**

**A. Case classes (not rates).** After the last fight, people show up as: gym coach / padholder; licensed second / cutman; gym owner / BJJ affiliate; official; commentator / ambassador; matchmaker / promoter; masters-age competitor (federation books); or gone. Hong & Hong 2023 (Olympian judokas, n=8, 5M/3F, Portugal/Korea/UK, 1–13 years post-retirement): identity and goal loss are the shared themes; some moved into coaching because it was the available paid identity, and at least one felt trapped in it. DIRECT as qualitative evidence, **not** a %. Lenartowicz, Dobrzycki, Cynarski 2025 (Polish male MMA, n=88 active + 15 interviews): retirement *planning* was “strategic personal management”; the sample is **still fighting** (related IMC paper: mean age 27.5). DIRECT that planning exists; UNKNOWN as post-fight occupations.

**B. Federation coaching-licence pathways — fighting record not required.**

- **USA Boxing** (2026): Green (online, 50 questions, 100%) → Bronze (in-person) → Silver → Gold (application, Colorado Springs, $1,000, Silver + nutrition + S&C + USADA). SafeSport and CDC Heads Up sit on the coach card. Seconds in competition = certified coaches credentialed for the field of play. DIRECT.  
- **USA Wrestling NCEP:** Copper / Bronze / Silver / Gold. Competitive experience **not mandatory**. Gold text: **no waiver** for previous athletic accomplishments — the task grades *coaching*, not athletic proficiency. DIRECT.  
- **England Boxing:** L1 Assistant (4 days, 17 to take, 18 to licence; may **corner**) → L2 Full (L1 + 1 year, may found a club) → L3 Senior (23+, L2 + 5 years). DBS, first aid+AED, safeguarding. Dual boxer/coach/official registration with same-event limits. DIRECT.  
- **IBA** (2024): sports-management course with **priority enrolment for retired athletes** — a pathway, not a rate. DIRECT that the pathway was offered.

**C. Commission second’s-licence requirements — competitor→corner is a *different licence*.** See §1.2. The honest sentence: a retired fighter who wants to work a pro corner needs a second’s (or manager’s) licence; that licence is 18+, often cheap, sometimes an exam-and-demo (California), sometimes paperwork (Nevada, North Carolina). It is **not** the combatant MRI/eye/blood battery.

**D. INHERITED mixed-sport occupation numbers — do not copy.** Kuettel 2018: 31–74% in sport-related jobs depending on *country*, 35 sports, elite Olympic-pipeline athletes. Polish athletes used the sport network to find work; Swiss and Danish less so. That is a labour-market finding. It is not “74% of UFC retirees coach.”

**E. How soon?** UNKNOWN as a distribution. Dual-role can start **before** the last fight. Federation courses are hours to a year-in-grade. A Colorado second can be licensed 48 hours before the bell. Kuettel’s ~9-month adaptation and 7–11-month pre-retirement planning window is INHERITED mixed-sport, not combat.

**F. Leaving is also real.** California Professional Boxers’ Pension Plan (4 CCR 401 et seq.; CSAC FAQ flyer): vest on 10 scheduled CA rounds in each of four calendar years **and** 75 scheduled CA rounds after 1 Jul 1981, without a 36-month break of service before age 50. Payable at 50; vocational education draw at **36 if retired**; death benefit before 50. LAT 2023: >1,900 accounts; about a quarter vested; historically paid 235 boxers ~$4m; ~6% of those who could have claimed in the investigation year were paid. DIRECT on rules; UNVERIFIED_SECONDARY on the investigative counts; UNKNOWN as what those boxers *do*. MMA CA pension bill signed 2023 (LAT 28 Dec 2023) — DIRECT that the legislature copied the boxer model, not that MMA occupation data exists.

### Q2 — Does the gym keep them?

**UNKNOWN as a rate. Real as a case class.** This is the mechanic the game most needs, so the honesty matters.

**Stay.** Sacha, J.O. (2015). *Fighting Feelings: The Emotional Labor of “Old Heads” in an Amateur Boxing Gym.* *Sociological Perspectives.* 13-month ethnography, South Los Angeles amateur gym: the coaches **are** the gym’s older mentors; they invent and enforce rules that differentiate the gym from “the street,” and they run “emotional regimens.” DIRECT that *in that gym* the people who stay and teach are the old heads. It is one gym, amateur, not a stay-vs-leave %. MMA/boxing journalism documents fighters remaining at the camp that trained them and becoming the everyday coach — a **class**, not a census (do not catalog names).

**Leave and open.** Opening a gym (or a BJJ affiliate under a professor’s lineage) is the other industrial path. Trade press calls it “the most obvious career path.” UNVERIFIED_SECONDARY as a slogan; UNKNOWN as a %.

**Leave the sport.** The California pension investigation exists because the commission could not find people. Hong & Hong 2023: even Olympians who *did* coach described identity loss and, for some, a feeling of having no other qualification. DIRECT as qualitative.

**Dual-role before retirement.** England Boxing §5.4 is the cleanest rule: you may hold boxer and coach memberships; you may not box and coach on the **same event**. Many MMA gyms run fighter-coaches every week. The “last fight → next day head coach” cinematic skips the years of holding pads while still competing.

**What the game may honestly do:** fire a **staff-offer** on granted retirement, flavoured by gym relationship, labelled UNKNOWN as a rate. Passing the offer makes them gym staff; working a **pro corner** still wants a second’s licence. Do not roll `p_stay = 0.40` and cite this file.

### Q3 — The comeback (second push, then rule)

**Pushed.** Still **UNKNOWN** as a population rate of reversed *announced* retirements, in any single sport or commission dataset.

**What was checked this pass that J10 did not lean on:**

- BoxRec’s own wiki: “retire” in British usage is also the **bout result** RTD. Not a career census.  
- NYSAC / NJ / CSAC / NSAC / Colorado / Massachusetts: these are **returning-combatant** batteries and (in CA) administrative retirement. They prove returns happen often enough to write a rule. They do not count them.  
- Kuettel 2018: 10% Swiss / 30% Polish / 39% Danish former elites *considered* a comeback ≥1 year later. INHERITED, mixed sports, **consideration ≠ reversal**.  
- Geezers Boxing n=20: 70% of a list *built from people who came back* returned within 5 years. Selected on the dependent variable. UNVERIFIED_SECONDARY. **Do not lift.** (J10 already said this; it is still true.)  
- Shurzy / betting blogs on “retirement returns”: UNVERIFIED_SECONDARY, not a commission dataset.  
- Lenartowicz 2025 Polish MMA: planning, not unretirement counts.

**Layoff length among reversed retirements:** UNKNOWN. J10’s FightAlpha inactivity tables (UNVERIFIED_SECONDARY) remain the only numeric layoff-vs-win object; they are **not** announced-retirement.

**What a game may honestly do instead:** see §1.3. Player/fighter-initiated request + medical flags. No 70%. No cinematic rust-off as research. If a first-fight-back modifier is required, reuse J10’s labelled direction (≥12 months vs an active opponent looks worse; confounding not removed).

### Q4 — Does a coach’s own fighting record predict coaching quality?

**Everywhere claimed. Sourced nowhere as a combat-sport result.**

There is no paper in the set pulled that regresses a coach’s professional W–L, titles, or win% on pupil win%, title rate, or any other outcome, in boxing, MMA, Muay Thai, kickboxing, BJJ, judo, wrestling, taekwondo, karate, or sambo.

**What exists instead:**

1. **Federations do not require a fighting record to coach.** USA Boxing Green is an online exam. USA Wrestling Copper is open to parents and volunteers; Gold **refuses** an athletic-accomplishment waiver. England Boxing L1 is a four-day course plus DBS/first aid/safeguarding. DIRECT.  
2. **Coaching-science definition (INHERITED, all-sport):** Côté & Gilbert 2009 — effectiveness is the consistent application of professional, interpersonal, and intrapersonal **knowledge** to improve competence, confidence, connection, and character in a specific context. The definition’s inputs are knowledge and athlete outcomes, not the coach’s old record.  
3. **Nearest quantitative claim is not combat and is not W–L:** Gilbert et al. 2009, n=16 successful US high-school coaches (basketball, cross-country): time (seasons/hours) as an *athlete in the sport they now coach* correlated with five success measures. INHERITED; small n; not a fight record.  
4. **Trade folklore both ways:** lists of great trainers who never fought professionally; lists of former fighters who became successful coaches; TUF coach win%; “best performers are rarely the best coaches.” All UNVERIFIED_SECONDARY. The Athletic 2019 calling a champion-to-elite-coach path “a rarity” is a journalist’s observation, not a denominator.  
5. **Nigerian review (UNVERIFIED_SECONDARY / opinion piece in a faculty journal):** athletic glory alone, without academic/professional coaching intelligence, is “not sufficient.” Not a dataset.

**Lift rule:** do not encode `record → coach_quality`. A former-fighter staff member may carry **trust** (they have been the one taking the walk). That is design flavour. ARP rec. 1 is the medical twin of this: past achievements do not clear you to fight, and they do not, on the evidence, clear you to coach.

### Q5 — Licensing and age (extend J10 medical-hold > folklore to the exit)

J10 D8: medical licence / hold outranks folklore “chin.” This pass extends that to **older fighter, returning fighter, and competitor→corner**.

**Older fighter — they still want to compete.**

| Body | Age object | What it actually does | Grade |
|------|------------|-----------------------|-------|
| ARP 2024 | Older fighter **>35**; CV from 35; neuro from **40** (Table 1). Summary PDF on ringsidearp.org says neuro at 35 — **conflict; prefer the journal Table 1**. | Extra ECG, AHA 14-point, BP >160/100 DQ; MRI+MRA+NP at 40 and every 3 years. Rec. 1: current status, **not** past achievements. Counselling regarding **retirement** is in the abstract’s scope. | DIRECT |
| NSAC | 38 / 425 rounds / 36 months inactive | Comprehensive contestant + **Commission review**, not auto-deny. One-eye = hard no. Cerebral hemorrhage = Commission review. | DIRECT |
| NYSAC | High-risk: **40+**, 6 consecutive any-method, 3 consecutive TKO/KO, **1+ year inactivity**, 10+ losses | Extra MRI/MRA/neuro/NP/cardiac/labs. MRI every 3 years for everyone on Chart I. | DIRECT |
| CSAC | **No age limit** | Discretionary extra testing. Inactivity >12 months is a listed factor. Must still **demonstrate ability to perform**. Commission may **retire** the boxer (CCR 283). | DIRECT |
| Colorado | **45+ and** not routinely fighting for 5 years | SAFE + EKG etc. | DIRECT |
| Massachusetts | **35th birthday** default bar | Discretionary exception with physical; champion exceptions. | DIRECT |
| New Jersey | 6 consecutive losses; 1 year inactive | **Automatic suspension** until commission medical. | DIRECT |
| ARP 2026 high-risk | Age **>35** (LOE V); inactivity >1 year pro (LOE V) | High-risk flag, not a formula | DIRECT (J10) |

**Returning fighter — they want the combatant licence back.**

There is no separate “comeback licence.” It is the combatant licence with the inactivity / age / rounds battery. ARP >1 year, NSAC 36 months, NYSAC 1+ year, CSAC >12 months, NJ 1 year, Colorado 45+ and 5 years quiet. **Passing the battery is not a right to a bout** (CSAC FAQ: ability to perform still required).

**Competitor → corner — they want to work, not fight.**

Different licence. No combatant MRI/eye/blood battery in the second applications sourced. Age 18 common. California is the strict ABC-family example (exam + demo). Nevada is paperwork + $50; a licensed manager may second without a second’s licence. A second under suspension cannot work. England Boxing L1 may corner amateurs. BBBofC splits Trainer/Second from Second-only.

**The folklore this kills:** “He was a champion, so he can come back.” ARP rec. 1 says the opposite. “He wants to corner, so he needs another MRI.” Not in the second-licence texts pulled. “The gym can just put him in the corner tomorrow.” Not in California, and not if he is under suspension.

### Q6 — What does the sport call them?

The game currently has no word. A wrong word is a design decision made by accident.

**Commission English:** `second`, `trainer`, `cut man` (Ali Act), `manager`, `retired` (California can *retire* a boxer). `Inactive` is a medical/eligibility flag, not an identity.

**Gym English:** boxing `trainer` / assistant trainer / “he holds pads”; MMA `coach`; BJJ `professor`; Muay Thai `kru` / `ajarn`; judo/karate dojo `sensei` (sport federations often `coach`); wrestling `coach`. Fight night: `cornerman`, `chief second`, `cutman`.

**Documented slang with a paper behind it:** `old head` — Sacha 2015, amateur boxing gym, older male mentor. Real. Culturally specific (US, racialised gym vernacular). **Do not** make it the only catalog string.

**False friends:**

- `house fighter` / `stablemate` = **active** gym representatives.  
- `veteran` = often still fighting.  
- `RTD` = this-bout result.  
- `alumni` = campus, not the gym.  
- `inactive` = might fight next month if they pass the battery.

**Recommendation:** `status: retired` + a `role` from §1.1. The sentence in the gym is a job (“he’s in the corner,” “he holds pads,” “he’s the professor”), not an honorific.

---

## 4. Sex, sport, amateur–pro (do not average)

J10 D6 still applies. This file adds next-life rows.

| Topic | Do | Do not |
|-------|----|--------|
| Olympic / federation books | Age-band / leave the national team; coaching pathways (USA Wrestling, England Boxing, USA Boxing, judo federations) | Hang-up-the-gloves event (J10 D5) |
| Pro boxing / pro MMA / stadium striking | Commission second licence; combatant inactivity battery to come back | Copy federation “coach course → done” as the pro-corner gate |
| Women | Keep a separate UNKNOWN on post-career occupation mix | Copy men’s journalism case classes as a women’s rate |
| Dual-role | England Boxing same-event ban is amateur-federation | Assume pro commissions use the same dual-registration rule |
| Pension | CA boxer pension is **boxers** (MMA bill 2023 is a separate object) | Treat pension vesting as a coaching census |
| Kuettel 31–74% | INHERITED mixed-sport, country-dependent | Average Poland with Switzerland and call it “fighters” |

---

## 5. Priority ruling and one operator question

**P0** — Role taxonomy + competitor→second/coach licence gates; medical-gated comeback flags that reuse J10’s ARP/NSAC set and add NYSAC / CSAC 283 / NJ auto-suspend / MA 35 / CO 45+5y; commission-forced retirement as a third exit beside R51b ask/grant.

**P1** — Gym-keep as a **staff-offer event** (authored, `UNKNOWN` as a rate), not a lottery. Dual-role-while-active as a flag that can pre-exist retirement.

**P2** — Vocabulary: `status: retired` + role noun. Do not ship `old head` as the only word.

**Do not block** a next-life module on a stay-in-sport percentage, a reversal percentage, or a fighter-record→coach-quality formula. Those numbers were not found.

**One operator question:** When a fighter is granted retirement, should the gym get a **staff-offer event** (authored, labelled `UNKNOWN` as a rate, flavoured by gym relationship) **or** only a world-population `status: "retired"` flag until a later design task authors gym staff?

---

## 6. Sources (verified 2026-09-07)

**Peer-reviewed / official (prefer these):**

1. Bianchi D, Sethi NK, et al. (2024). Care of the older fighter: Position statement of the Association of Ringside Physicians. *Phys Sportsmed* 52(6):585–591. https://pubmed.ncbi.nlm.nih.gov/38708547/ — summary PDF (neuro-age **conflicts** with Table 1): https://ringsidearp.org/wp-content/uploads/2024/05/OlderFighters-Summary.pdf  
2. Combat Sports Law recap of ARP Table 1 (neuro at 40, CV at 35): https://combatsportslaw.com/2024/05/09/ringside-doctors-publish-peer-reviewed-position-on-licencing-older-fighters/  
3. Munshi J et al. (2026). Identifying high-risk combat sport athletes: Position statement of the ARP. *Clin J Sport Med* 36(3):218–223. (J10 #10)  
4. Nevada NAC 467.017 (age 38 / 425 rounds / 36 months inactive; one-eye bar; head-injury review): https://www.law.cornell.edu/regulations/nevada/NAC-467-017  
5. Nevada NAC 467.057 (manager may second without a second’s licence): https://www.law.cornell.edu/regulations/nevada/NAC-467-057  
6. NSAC Physical 2025 (debut / standard 18–37 / comprehensive contestant): https://boxing.nv.gov/uploadedFiles/boxingnvgov/content/Licensing/PHYSICAL-2025_W-INSTR.pdf  
7. NSAC Second licence application (fee $50): https://boxing.nv.gov/uploadedFiles/boxingnvgov/content/Licensing/Renewal/Second_App.pdf  
8. Cal. Code Regs. tit. 4, § 218 (boxing second: exam + demonstration): https://www.law.cornell.edu/regulations/california/4-CCR-218  
9. Cal. Code Regs. tit. 4, § 215 (manager acting as second): https://carules.elaws.us/code/t.4_d.2_ch.1_art2_sec.215  
10. Cal. Code Regs. tit. 4, § 283 (commission may **retire** a boxer): https://www.law.cornell.edu/regulations/california/4-CCR-283  
11. Cal. Code Regs. tit. 4, § 545 (MMA/kickboxing second): https://carules.elaws.us/code/t.4_d.2_ch.2_art4_sec.545  
12. CSAC FAQs (no age limit; inactivity >12 months as a listed factor; ability to perform): https://www.dca.ca.gov/csac/forms_pubs/publications/faqs.shtml  
13. NYSAC Medical Manual (8 May 2024), §7 High-Risk Combatants; Chart I: https://dos.ny.gov/system/files/documents/2024/05/nysac-medical-manual-5-8-2484.pdf  
14. N.J.A.C. 13:46-12B.3 (six consecutive losses; one-year inactivity → medical): https://www.law.cornell.edu/regulations/new-jersey/N-J-A-C-13-46-12B-3  
15. Colorado 4 CCR 740-1.6(D)(3) (age 45 + 5 years not routinely fighting): https://www.law.cornell.edu/regulations/colorado/4-CCR-740-1.6  
16. Colorado 4 CCR 740-1.12 (corners: 18+, 48 hours, max 3): https://www.law.cornell.edu/regulations/colorado/4-CCR-740-1.12  
17. Massachusetts G.L. c. 147 § 39 (35th birthday default bar; champion exceptions) via Acts 2009 ch. 169: https://malegislature.gov/Laws/SessionLaws/Acts/2009/Chapter169  
18. 15 U.S.C. § 6301(4) (Ali Act / PBSA: licensee = trainer, second, or cut man): https://www.law.cornell.edu/uscode/text/15/6301  
19. BBBofC *Rules and Regulations* 2024, §16 Trainer/Second and Seconds (First Aid; 10% cap): https://bbbofc.com/build/documents/Rules_and_Regulations_2024.pdf  
20. USA Boxing National Rulebook, rev. 1 Jan 2026 (Seconds = certified coaches): https://assets.contentstack.io/v3/assets/blteb7d012fc7ebef7f/blt5ff28f6e78e9624d/695ed2d8b45570d8a64b74b9/USA_Boxing_Rule_Book_Revisions_-_1.1.2026.pdf  
21. USA Boxing coaching pathway (Green / Bronze / Silver / Gold): https://usaboxingeducation.org/page/7523/coaching-pathway  
22. England Boxing coaching pathway and Coaching Policy (Apr 2025): https://www.englandboxing.org/coaching/ — https://www.englandboxing.org/wp-content/uploads/2025/04/Coaching-Rules-Policy-Final-Apr-25.pdf  
23. England Boxing Rule Book §5 (dual registration; same-event ban): https://www.englandboxing.org/wp-content/uploads/2023/09/Rule-Book-Final.pdf  
24. USA Wrestling NCEP certification levels: https://www.themat.com/coaches/ncep-certification — Gold “no athletic waiver” quote: https://wrestlingtexas.com/usa-coaches-certifications/  
25. Washington DOL second licence: https://dol.wa.gov/professional-licenses/second-combative-sports/get-your-license-second-combative-sports  
26. 523 CMR 6.05 (Massachusetts second): https://www.mass.gov/doc/523-cmr-6-licensing-and-registration/download  
27. ABC Boxing Referee Manual, rev. Aug 2025 (chief second identified in dressing room): https://www.abcboxing.com/wp-content/uploads/2026/06/ABC-BOXING-REFEREE-MANUAL-rev8-2025.pdf  
28. Minnesota professional boxing rules (seconds licensed; suspended second cannot work): https://www.dli.mn.gov/sites/default/files/pdf/MN-PROFESSIONAL-BOXING-RULES.pdf  
29. Cal. Code Regs. tit. 4, § 401 (boxers’ pension: break in service = <10 CA rounds in 36 months before age 50): https://www.law.cornell.edu/regulations/california/4-CCR-401  
30. CSAC *Boxers: Do You Have Money Coming?* pension flyer: https://www.dca.ca.gov/csac/forms_pubs/publications/pension_plan.pdf — eligibility explainer PDF: https://www.dca.ca.gov/csac/forms_pubs/forms/boxpension.pdf  
31. Hong HJ, Hong SH. (2023). Fighting for Olympic dreams and life beyond: Olympian judokas… *Front Psychol* 14:1269174. PMC: https://pmc.ncbi.nlm.nih.gov/articles/PMC10562602/  
32. Kuettel A, Boyle E, Christensen MK, Schmid J. (2018). A cross-national comparison of the transition out of elite sport of Swiss, Danish, and Polish athletes. *Sport Exerc Psychol Rev* 14(1):3–22. Accepted MS: https://findresearcher.sdu.dk/ws/files/140714007/SEPR_Akuttel_Cross_national_Comparison_of_Athletic_Retirement.pdf  
33. Côté J, Gilbert W. (2009). An integrative definition of coaching effectiveness and expertise. *Int J Sports Sci Coach* 4(3):307–323. https://doi.org/10.1260/174795409789623892  
34. Gilbert W, Lichtenwaldt L, Gilbert J, Zelezny L, Côté J. (2009). Developmental profiles of successful high school coaches. *Int J Sports Sci Coach* 4(3). (basketball / XC; INHERITED)  
35. Sacha JO. (2015). Fighting Feelings: The Emotional Labor of “Old Heads” in an Amateur Boxing Gym. *Sociological Perspectives.* https://doi.org/10.1177/0731121415596083  
36. Park S, Lavallee D, Tod D. (2013). Athletes’ career transition out of sport: a systematic review. *Int Rev Sport Exerc Psychol* 6(1):22–53. https://doi.org/10.1080/1750984X.2012.687053  
37. Lenartowicz M, Dobrzycki A, Cynarski WJ. (2025). Sport career transitions of professional Polish Mixed Martial Arts athletes. *Eur J Sport Soc* 22(4):371–389. https://doi.org/10.1080/16138171.2025.2504249 (abstract; occupation crosstab not open)  
38. Stambulova N et al. (2009 / 2021 ISSP position stands) — cited inside Hong 2023 for the ~15–20% of elite athletes who seek psychological help after retiring. INHERITED; not a stay-in-sport rate.

**J10 (do not reopen peak/decline tables):**

39. `/workspace/j11/J10_THE_YEARS.md` — especially D4–D8, §1.4 retirement-pressure flags, §2 #12 and #14, Q4–Q6.

**UNVERIFIED_SECONDARY (use only with that grade):**

40. Geezers Boxing celebrity comeback n=20: https://www.geezersboxing.co.uk/news/post/retirement-ages  
41. The Athletic (2019). Champion-to-coach “rarity” (named example used as citation only, not a data row): https://www.nytimes.com/athletic/1111510/2019/08/01/how-mma-geek-mike-brown-went-from-champion-fighter-to-celebrated-coach/  
42. Los Angeles Times (2023–24). California boxers’ pension investigation: https://www.latimes.com/california/story/2023-05-11/california-retired-boxers-pension-plan-failing-to-deliver — https://www.latimes.com/california/story/2023-12-28/california-pays-out-record-amount-to-boxers-owed-pensions — https://www.latimes.com/california/story/2024-01-02/california-retired-boxers-pension-primary-mission-failed  
43. Fighters Only / trade “what happens when MMA stars retire” (open-a-gym as “most obvious path”).  
44. Honour and Glory, “Greatest Boxing Trainers Who Never Fought”: https://www.honourandglory.co.uk/blog/greatest-boxing-trainers-who-never-fought  
45. Wikipedia, Cutman (apprenticeship; MMA promotions provide cutmen): https://en.wikipedia.org/wiki/Cutman  
46. Wikipedia, Cornerman: https://en.wikipedia.org/wiki/Cornerman  
47. FightAlpha / AgentMMA UFC layoff tables — already graded in J10 Q6; inactivity not announced retirement.  
48. CSAC sunset background paper (second-licence volume ~1,930 in FY 2017/18): https://abp.assembly.ca.gov/sites/abp.assembly.ca.gov/files/Sunset%202019%20Background%20Paper%20CSAC.pdf  
49. O*NET / CareerOneStop second-licence listings (NC, IN): https://www.onetonline.org/link/licenseinfo?id=37-30913  
50. IBA & ISDE sports-management course (priority for retired athletes, 2024): https://www.iba.sport/about-iba-development/iba-isde-course/

**Local:**

51. `/workspace/j11/TASK_J11.md`  
52. `/workspace/j11/J10_THE_YEARS.md`

---

## 7. Do-not-build list (this desk)

1. **No researched stay-in-sport %, gym-keep %, or unretirement %.** If engineering needs a placeholder, `grade: UNKNOWN`.  
2. **No `fighter_record → coach_quality` formula.**  
3. **No Geezers 70%.**  
4. **No Kuettel 74% copied onto MMA/boxing.**  
5. **No catalog rows of named real athletes** (named people as *citations* are allowed).  
6. **No boxing hang-up cinematic on federation age-band books.**  
7. **No collapsing `inactive` / `retired` / `RTD`.**  
8. **No `old head` as the only identity string.**  
9. **No second-licence medical battery copied from the combatant form.**  
10. **No “he was a champion so he can come back” override of ARP rec. 1 / CSAC 283 / NSAC 467.017.**  
11. **No R51b / `.gd` / HANDOFF edits from this desk.**  
12. **No reopening of J10 peak windows or yearly stat deltas.**

---

## 8. Implementation notes for Claude (still research, not a patch)

- R51b’s `status: "retired"` in world population is the hook. Next-life is a **role** on that person, not a new species of athlete.  
- Fight-night cornering wants a **second** licence object even if the gym already employs them. California is the strict template (exam + demo); Nevada is the paperwork template. Do not invent a hybrid and call it ABC.  
- `BodyReadiness.medical_hold` remains the pause. Comeback reads that hook **plus** inactivity/age/rounds flags. Administrative retirement (CCR 283) is a career end, not a pause.  
- Dual-role-while-active can pre-empt the “suddenly a coach” event. England Boxing’s same-event ban is a clean design constraint if a fighter is still on the roster and also in a teammate’s corner.  
- Women’s books: next-life occupation mix is UNKNOWN. Do not copy men’s journalism.  
- If a staff-offer ships before the operator answers the question in the decisions page, label the chance UNKNOWN in data.

---

*End of J11. Research only. 2026-09-07.*
