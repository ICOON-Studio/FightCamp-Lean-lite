# Competition Ruleset Research

Part of the CLAUDE RESEARCH ASSIGNMENT (see `HANDOFF.md`, 2026-08-30). Source
ledger and human-readable comparison of every competition variant researched
for the fifteen required disciplines. Compiled from five parallel research
passes, each using WebSearch/WebFetch against primary governing-body
documents. Confidence tags follow the assignment's standard: **DIRECT**
(explicitly stated in a primary source actually read), **INFERRED**
(reasonable extension, not verbatim), **CONFLICTING** (sources disagree —
both reported), **UNKNOWN** (could not verify — not guessed).

Status: **PROPOSAL / RESEARCH RECORD.** This document itself changes no
runtime data. `combat_rulesets.json` remains the live prototype contract;
`Godot/assets/data/competition_rulesets_v2.json` (built from this research)
is additive and not wired into anything yet.

**Retrieval date for all sources below: 2026-08-30**, unless individually
noted otherwise.

**Coverage status:** all 15 required disciplines complete (MMA, Boxing,
Kickboxing, Muay Thai, Savate, Karate, Wrestling, Judo, Sambo, Capoeira,
Arnis, Pencak Silat, BJJ, Sanda, Taekwondo). BJJ/Sanda/Taekwondo's research
pass was interrupted once by an API rate limit mid-task; the retry
completed successfully and its findings are included below.

---

## MMA

### Association of Boxing Commissions (ABC) — Unified Rules of MMA (Professional)

Governing body: Association of Boxing Commissions and Combative Sports
(ABC). Jurisdiction: United States (and commissions that adopt ABC rules).
Ruleset: "Unified Rules of Mixed Martial Arts," approved April 2001,
amended through 6 Aug 2025.

- **Age:** not specified in this document — `UNKNOWN` for professional (the
  amateur documents below specify 18+).
- **Sex/divisions:** men's and women's use identical weight classes/rules;
  women's-specific apparel specified (rash guard/sports bra). `DIRECT`
- **Weight classes** `DIRECT`: Atomweight (≤105 lb), Straw (105–115),
  Flyweight (115–125), Bantamweight (125–135), Featherweight (135–145),
  Lightweight (145–155), Super Lightweight (155–165), Welterweight
  (165–170), Super Welterweight (170–175), Middleweight (175–185), Super
  Middleweight (185–195), Light Heavyweight (195–205), Cruiserweight
  (205–225), Heavyweight (225–265), Super Heavyweight (>265 lb). Catch-weight
  max 5 lb spread.
- **Arena:** dimensions `UNKNOWN` — left to sanctioning commission.
- **Equipment:** mouthpiece mandatory; hand wraps (max 2"×15yd gauze +
  1.25"×10' tape, no knuckle coverage); no joint taping except a
  non-Velcro neoprene sleeve; male groin protection mandatory; glove weight
  `UNKNOWN` in this source (commonly reported elsewhere as 4 oz, not
  confirmed here).
- **Rounds** `DIRECT`: 5-minute rounds, 1-minute rest, 1–5 rounds per bout,
  never more than 5 rounds/25 minutes.
- **Scoring** `DIRECT`: 10-Point Must, ≥3 judges. Priority: (A) effective
  striking/grappling, (B) effective aggressiveness, (C) area control — B/C
  only matter if A is even.
- **Win methods** `DIRECT`: Submission, TKO (referee/medical stoppage), KO,
  Disqualification, No Contest, Decision (unanimous/split/majority), Draw,
  Technical Decision, Technical Draw.
- **Grounded-opponent definition** `DIRECT`: any body part but hands/feet
  touching the canvas = grounded; cannot be kneed/kicked to the head.
  Elbow strikes ARE legal on the ground (only the 12-to-6 downward elbow is
  banned).
- **Medical:** ringside physician mandatory; ambulance + ≥2 EMTs required
  on-site for the whole event.
- **Fouls** `DIRECT` (abbreviated — full list in source): head-butting, eye
  gouging, biting, groin strikes, downward 12-to-6 elbow, strikes to spine/
  back of head, small-joint manipulation (fingers/toes; large joints
  permitted), fence-grabbing, throwing opponent out of the cage,
  stomping/kicking a grounded opponent's head, timidity.

### ABC Amateur MMA (Unified Rules)

- **Age** `DIRECT`: 18+ on contest date.
- **Divisions** `DIRECT`: Novice (<3 verified bouts) and Advanced (>3).
- **Weight classes** `DIRECT`: Flyweight (≤125, 10 lb spread), Bantamweight
  (126–135), Featherweight (136–145), Lightweight (146–155), Welterweight
  (156–170), Middleweight (171–185), Light Heavyweight (186–205), Cruiser
  Heavyweight (206–230), Heavyweight (231–265), Super Heavyweight (>265).
- **Equipment** `DIRECT`: mandatory shin guards, gloves ≥6 oz
  (promoter-supplied only), mouthpiece, no gi.
- **Rounds** `DIRECT`: max 3×3 min, 1-min rest.
- **Key differentiator — Novice vs Advanced** `DIRECT`: Novice bouts ban all
  strikes to a grounded opponent's head; Advanced bouts permit them. This
  is the only rules difference between the two divisions.
- **Fouls** `DIRECT`: same core list as professional, PLUS (stricter than
  pro): all elbow strikes banned outright, all knee strikes to the head
  banned outright (any position), linear kicks to the knee joint banned,
  heel hooks and toe holds banned (straight kneebars/ankle locks remain
  legal), neck cranks restricted.

### IMMAF Unified Amateur MMA Rules

Governing body: International MMA Federation (IMMAF). Jurisdiction:
international. Ruleset text dated 2015 baseline (15.11.15); `CONFLICTING`/
`UNKNOWN` whether a newer consolidated edition supersedes it, though it
appears to remain current as linked from IMMAF's own site.

- **Rounds** `DIRECT`: non-championship 3×3 min, 1-min rest.
- **Weight classes** `DIRECT`: Straw (<115 lb) through Super Heavyweight
  (>265 lb), 10 classes.
- **Ring/cage** `DIRECT`: circular or ≥8-sided, 20×20 ft min to 32×32 ft
  max, ≥1" foam padding, platform ≤4 ft high.
- **Equipment** `DIRECT`: gloves ≥8 oz (promoter-supplied, amateur-specific
  design), mandatory shin guards, mouthpiece, male groin protector
  mandatory.
- **Scoring** `DIRECT`: 10-Point Must, 3 judges, time-sliding weight
  between striking/grappling based on how much of the round was grounded.
- **Grounded-opponent rule** `DIRECT`: universally banned for ALL amateurs
  (no Novice/Advanced split, unlike ABC's amateur code).
- **Medical** `DIRECT`: Hepatitis B/C and HIV test certificates (<1 yr old)
  required before licensure; mandatory post-contest exam.
- **Forbidden Techniques (stricter absolute bans, beyond the ordinary foul
  list)** `DIRECT`: full elbow/forearm strike ban (any kind, not just
  downward), heel hook ban, twister/spinal-pressure submission ban, full
  knee-to-head ban (standing or grounded). Disqualification after 3 fouls
  or one flagrant foul.

**Cross-cutting MMA finding:** professional (ABC), amateur-advanced (ABC),
amateur-novice (ABC), and international-amateur (IMMAF) are four
meaningfully different legal-technique sets — most notably on elbows (legal
pro / banned amateur), knees to a grounded opponent's head (legal pro,
legal ABC-Advanced, banned ABC-Novice, banned IMMAF), and leg locks (heel
hooks/toe holds banned in both amateur codes, legal pro). The technique
catalog's MMA nodes (`mma_guard_gnp`, `mma_mount_finish`, etc.) will need
per-ruleset legality entries reflecting this, not one blanket "MMA" rule.

---

## Boxing

### ABC — Professional Boxing (Male and Female)

Governing body: Association of Boxing Commissions (ABC). Jurisdiction: USA/
territories. Document: "Regulatory Guidelines and Rules for All World and
Regional Championship Bouts."

- **Age:** ≥18, Federal ID Card required (Ali Act compliance).
- **Weight classes (full table, `DIRECT`)**: 17 classes, Mini Flyweight
  (≤105 lb, 8 oz gloves) through Heavyweight (>200 lb, 10 oz gloves), each
  with a stated weight-difference allowance (3–12 lb) and glove weight (8 or
  10 oz — both wear the heavier glove if straddling the threshold).
- **Rounds** `DIRECT`: male max 12×3 min; **female max 10×2 min** (shorter
  rounds, fewer rounds than men).
- **Ring** `DIRECT`: 16–20 ft square inside ropes, apron ≥2 ft beyond, 4
  ropes.
- **Equipment:** hand wraps ≤20 yd gauze + ≤8 ft tape, no knuckle coverage;
  new gloves mandatory for title bouts.
- **Scoring** `DIRECT`: 10-Point Must, 3 judges. Criteria: clean punching,
  effective aggressiveness, ring generalship, defense.
- **Win methods:** Points/Decision, TKO, KO (10-count), Disqualification, No
  Decision, Technical Decision, Technical Draw.
- **Medical/suspension** `DIRECT`: TKO-by-head-blows → min 30-day
  suspension; KO → min 60-day suspension; mandatory 7-day rest after every
  bout regardless of outcome. Female boxers additionally require a
  negative pregnancy test (≤14 days old) before every bout.
- **Fouls** `DIRECT`: below the belt, hitting a downed opponent,
  holding-and-hitting, headbutting, rabbit punches, kidney punches, low
  blows, biting, thumbing the eyes, hitting on the break, and more (full
  list in source).

### World Boxing — Olympic-Style Amateur Boxing

Governing body: World Boxing (current Olympic-cycle federation, succeeded
the suspended IBA/AIBA). Ruleset in force November 2024. Jurisdiction:
international.

- **Age categories** `DIRECT`: Elite (19–40), U19 (17–18), U17 (15–16,
  "Boys/Girls"), U15 (13–14, national-federation-regulated), Masters (>40,
  national-federation-regulated).
- **Rounds** `DIRECT`: 3 rounds for all categories; 3 min (Elite/U19), 2 min
  (U17); 1-min rest; mandatory 12-hour gap between any boxer's bouts.
- **Weight classes** `DIRECT`: Elite Men/Women each 10 classes (2025
  schedule); U19 mirrors Elite; U17 Boys/Girls share 13 classes.
- **Ring** `DIRECT`: min 6.10m inside ropes, platform 100cm high.
- **Equipment — key amateur-internal split** `DIRECT`: gloves 10 oz
  (women/U17 men/lighter U19-Elite men classes) or 12 oz (heavier men's
  classes); **headguards mandatory for U17/U19/Elite Women, but explicitly
  NOT worn by Elite Men** — a deliberate rule, the single biggest split
  within the amateur code itself.
- **Scoring** `DIRECT`: 10-Point Must, **5 judges** (not 3, unlike pro
  boxing/MMA). Every round MUST have a winner — no 10-10 draws (unlike pro
  boxing).
- **Win methods** `DIRECT`: Points, RSC (Referee Stops Contest), RSC-I
  (injury), Abandonment, Disqualification, DQB (unsportsmanlike DQ,
  distinct category), Knockout, Walkover.
- **Standing-8-count cap** `DIRECT`: max 3 per round, max 4 per bout — no
  equivalent cap found in the pro-boxing source.
- **Medical:** governed by a separate document not independently fetched —
  `UNKNOWN` specific suspension-day tables (contrast with pro boxing's
  explicit 30/60-day figures).

**Cross-cutting Boxing finding:** the single biggest legality/eligibility
difference between the two Boxing rulesets is round count/length (12×3 for
pro men vs 3×3 or 3×2 for amateur) and headgear (none for pro or Elite Men
amateur, mandatory for every other amateur category) — round-count data
should live per-ruleset, not as one shared boxing constant.

---

## Kickboxing

Governing body: World Association of Kickboxing Organizations (WAKO).
Ruleset: "WAKO Rules," Ring Sports chapters, V18 (stated to remain current
minimum Aug 2016–Aug 2020; `CONFLICTING`/`UNKNOWN` whether a later "v.2"
consolidated 2022 edition has since superseded this exact text — V18 is
what was actually read). Jurisdiction: international. Five genuinely
distinct disciplines share only partial rules — **do not treat "kickboxing"
as one ruleset.**

### Full Contact (Ring)

- **Age/weight (shared FC/Low Kick/K-1)** `DIRECT`: Younger Juniors (15–16),
  Older Juniors (17–18), Seniors (19–40); weight tables per category/sex.
- **Ring** `DIRECT`: 520–610cm square inside ropes.
- **Rounds** `DIRECT`: 3×2 min, 1-min rest — same for all ring disciplines,
  all ages.
- **Equipment** `DIRECT`: headguard, 10 oz gloves, mandatory shin guards
  (sock-type instep covers explicitly PROHIBITED), mandatory groin
  protection.
- **Legal targets** `DIRECT`: head (front/side/top), torso (front/side
  above waist), leg (ankle-level only, for sweeps) — **no kicks below the
  waist.**
- **Minimum kick quota** `DIRECT`: 6 kicks/round, 18/fight — shortfall draws
  a minus point (max 2, cumulative to DQ). No equivalent quota in Low Kick
  or K-1.
- **Win methods** `DIRECT`: Points, Abandonment, Stoppage/RSC/RSC-H, DISQ,
  Walkover, KO (10-count), TKO via 3-knockdown rule (2 for Younger
  Juniors).
- **Medical** `DIRECT`: KO/RSC-H → min 4-week ban; 2nd within 3 months →
  min 3-month ban; mandatory CT scan after any registered KO/RSC-H.
- **Fouls** `DIRECT`: throat/kidney/groin/spine/back-of-head/joint attacks,
  knee/shin(-as-weapon)/elbow/headbutt strikes, kicks below the waist,
  **any ground attack — bout stops the instant any part but the feet
  touches the floor**, clinching/wrestling, oiling.

### Low Kick (Ring)

- Shares Full Contact's ring/weight/age/rounds/officials/medical/win-method
  rules verbatim. `DIRECT`
- **Delta:** adds thighs (outside/inside/back of hip) as a legal kick
  target — the discipline-defining feature. No kick-quota rule (article not
  carried over from Full Contact). Still bans front-of-hip and
  under-the-knee kicks.

### K-1 Style (Ring)

- Shares ring/weight/age/rounds/win-methods with Full Contact/Low Kick.
  `DIRECT`
- **Legal targets** `DIRECT`: head, torso, **legs — any part** (broadest
  leg-target rule of the three).
- **Key differentiator** `DIRECT`: **knee strikes are legal**, targeting any
  part of body/head, but only ONE knee attack per clinch (both hands on
  neck/shoulders) and it must be thrown immediately. **Elbow strikes are
  explicitly forbidden.** No kick-quota rule.
- **Fouls (delta):** leg-grabbing, front-of-thigh/knee/shin kicks/knee
  attacks, >1 knee per clinch, somersault kicks, elbow strikes.

### Point Fighting (Tatami — semi-contact, mat not ring)

- **Age categories** `DIRECT` — broadest of any WAKO discipline: Children
  (7–9) through Veterans/Master Class (41–55).
- **Rounds:** standard individual-bout duration `UNKNOWN` (not found in the
  chapter retrieved; team-format durations were found: 1×2 min per
  matchup).
- **Legal targets** `DIRECT`: head (front/forehead/**back**/side — back of
  head IS legal here, unlike every other WAKO discipline), torso
  (front/side), feet (sweeps only).
- **Equipment** `DIRECT`: headguard, elbow pads (unique to this discipline
  among those researched), point-fighting gloves.
- **Scoring — defining mechanic** `DIRECT`: requires ≥2 concurring
  raised-arm calls from 3 officials; sound-based scoring explicitly
  disallowed.
- **Win methods:** no explicit KO/TKO/RSC categories defined in this
  chapter (consistent with its light-contact character) — `UNKNOWN` how
  injury stoppage is formally categorized here.

### Kick Light (Tatami — continuous, light-but-real contact)

- **Age categories** `DIRECT`: Older Cadets (13–15) through Master
  Class/Veterans (41–55) — no Children/Younger Cadets division, unlike
  Point Fighting.
- **Legal targets** `DIRECT`: head, torso, **legs (thigh, inside/outside/
  back — blocked leg kicks score nothing)**, feet.
- **Legal techniques** `DIRECT`: direct/uppercut/hook punches (**no
  backfist — explicitly banned**, unlike Point Fighting where backfist is
  legal); kicks to torso/head only (not thigh) for front/side/spinning
  back; roundhouse/hook/crescent/axe/jump kicks. **Punches to the legs
  explicitly banned** (hand strikes are head/torso only).
- **Scoring** `DIRECT`: graduated by difficulty — 1 push (standard
  technique), 2 (jump kick to body, or head kick), 3 (jump kick to head).

**Cross-cutting Kickboxing finding:** these five WAKO disciplines share a
ring/weight/age skeleton (Full Contact/Low Kick/K-1) or a lighter
skeleton (Point Fighting/Kick Light), but their legal-target and
legal-technique sets are meaningfully different from each other (low kicks
legal only in Low Kick; knees legal only in K-1; elbows illegal
everywhere; backfist banned in Kick Light but legal in Point Fighting).
The technique catalog's single `kickboxing` discipline should be legality-
matrixed per WAKO style rather than treated as one ruleset — see
`TECHNIQUE_CATALOG_AUDIT.md` finding 3.

---

## Muay Thai

### IFMA — Muaythai Combat | Full Contact (amateur/Olympic pathway)

Governing body: International Federation of Muaythai Associations (IFMA).
Ruleset v3.0, revised 11 May 2026. Jurisdiction: international.

- **Age categories** `DIRECT`: 11 bands, U8 (6–7) through Masters 45+
  (45–50).
- **Weight classes** `DIRECT`: full per-age/sex tables, e.g. Elite/Masters
  45–91+ kg.
- **Ring** `DIRECT`: 6.0–6.5m inside ropes.
- **Equipment** `DIRECT`: 10 oz gloves; mandatory headguard, shin guards,
  **elbow guards for all divisions**; body protector mandatory U12–U24 and
  Masters 40+/45+, **not worn** in Elite/Masters 35+.
- **Rounds** `DIRECT`: always 3 rounds; length/rest varies 1–3 min by age
  band.
- **Scoring** `DIRECT`: Ten-Point Must (default) or an electronic
  Strike-by-Strike system at Technical Delegate discretion.
- **Legal targets** `DIRECT`: any part of the body **except groin and
  cervical spine** (C1–C7 + occipital bone).
- **Elbow/knee restrictions by age — key finding** `DIRECT`: unrestricted
  for Masters/Elite/U24/U18/U16; **U14/U12: no elbow or knee strikes to the
  head**; **U10/U8: no strikes to the head at all, any weapon.**
- **Compulsory Count Limit (TKO trigger)** `DIRECT`: 2–3 counts/round or
  3–4/bout depending on age band.
- **Medical/suspension** `DIRECT`: 1st head-KO/RSCH → min 30-day
  suspension; 2nd within 90 days → min 90-day; 3rd within 12 months → min
  12-month; neurologist clearance required to return.
- **Fouls** `DIRECT`: biting, headbutting, eye-pressing, non-Muaythai
  takedowns (sweeping without a strike, hip-throws, tackling), leg-hooking
  with calf/ankle/heel, joint-locking, striking a grounded/downed/rising
  opponent, holding a caught kick and pushing >2 steps without striking.

### IFMA — Muaythai Technical | Semi Contact

- Same age/weight/officials framework as Full Contact but **light-contact
  only**; full-power strikes are themselves a foul; escalating
  Caution→Warning→Warning→DQ for ring-avoidance. `DIRECT`

### WMC — Professional Muay Thai

Governing body: World Muaythai Council (WMC). Source dated ~April 2020
(no in-document revision date — exact effective date `UNKNOWN` beyond
that). Jurisdiction: international/professional.

- **Age:** ≥18, no stated maximum.
- **Weight classes** `DIRECT`: 19 classes, 5 lb max spread.
- **Ring** `DIRECT`: 6.10m or 7.30m square.
- **Gloves by class** `DIRECT`: 6 oz (lightest) through 10 oz (Super
  Welterweight+).
- **Rounds** `DIRECT`: **5×3 min, 2-min rest** — longer/harder than IFMA's
  amateur format.
- **Elbow/knee/clinch — key finding** `DIRECT`: **no restriction on elbow
  or knee strikes, and no clinch time-limit specified** — a marked contrast
  to IFMA's age-based amateur restrictions. Only foul: knee strikes
  deliberately targeting the groin.
- **Win methods** `DIRECT`: Points, KO, TKO, Disqualification, Walkover,
  Draw (majority even score or simultaneous double-count-out), No Decision
  ("not in earnest"), No Contest.
- **Medical/suspension** `DIRECT`: 7/14/21-day tiers by rounds fought;
  30-day tier for a KO/TKO loss; 90-day tier for KO/TKO from two
  consecutive head blows.
- **Female competition:** same core rules; mandatory chest/abdomen
  protectors; gender verification via medical exam; female-only referee/
  judges except exceptional cases. `DIRECT`

**Cross-cutting Muay Thai finding:** the amateur/pro elbow-and-knee
restriction gap is large and age-dependent on the amateur side, and
entirely unrestricted on the pro side — this is one of the highest-value,
clearest legality-matrix entries available (Muay Thai's `elbow`/`knee`
catalog nodes need per-ruleset, and on the amateur side per-age-band,
legality records, not one blanket "muay_thai" rule).

---

## Savate

### FISav — World Championship Assaut (event regulation, not a full technical rulebook)

Governing body: Fédération Internationale de Savate (FISav). Document:
2026 World Championship Savate ASSAUT regulation. **Important gap** `DIRECT`
finding: FISav does **not** appear to publish a standalone public technical
rulebook (target areas, scoring points, fouls) — its documents page lists
only championship-specific event regulations, which explicitly defer to
"the general rules of the Fédération Internationale de Savate" without
publishing that document separately. Flagged `UNKNOWN`/`CONFLICTING`.

- **Age (this event only):** single combined 18+ bracket for the World
  Championship; national competitions use finer brackets. `DIRECT`
- **Weight classes** `DIRECT`: 8 classes/sex.
- **Rounds** `DIRECT`: 3×2 min.
- **Equipment** `DIRECT`: Savate Integrale suit, savate shoes, gum shield;
  shin pads and headguard **optional** (each athlete's independent choice
  regardless of opponent); groin/breast protection compulsory.

### FFSbf&DA — French National Technical Rules (used because FISav has no public technical rulebook — explicitly a national, not international, source)

Governing body: Fédération Française de Savate Boxe Française et
Disciplines Associées. Document updated September 2024.

#### Savate Assaut
- **Definition** `DIRECT`: technique/style-scored; power is strictly
  excluded.
- **Age categories** `DIRECT`: 8 bands, Pré-poussins (7–9) through Vétérans
  (40+).
- **Scoring** `DIRECT`: kick to low line = 1 pt, medium = 2, high = 4;
  punch = 1 pt (max 2 pts counted per combination).
- **Legal targets** `DIRECT`: kicks — head front/side, all faces of trunk,
  lower limbs; punches — head front/side, trunk front/side.
- **Illegal targets** `DIRECT`: groin, nape/back/top of head; women's chest
  additionally illegal for kicks; anything below the belt illegal for
  punches (both sexes; also chest for women).
- **Sweeps explicitly legal** `DIRECT`.

#### Savate Combat (2ème and 1ère Série — full-power tier, distinct from Assaut)
- **Two internal tiers** `DIRECT`: 2ème série (entry, headguard mandatory)
  and 1ère série (advanced, headguard generally forbidden). Promotion
  gated by a competition-points system.
- **Age** `DIRECT`: Cadet 2nd-year minimum for 2ème série; Junior 1st-year
  minimum for 1ère série; max age 40 (35–40 needs cardiac clearance).
- **Rounds vary sharply by competition tier** `DIRECT`: 3×2 up to 7×2
  depending on event level — no single fixed format, unlike Assaut's
  uniform 3×2.
- **Medical — "hors combat" 4-type classification** `DIRECT`: type 4
  (cerebral-origin consciousness disturbance) → min 28-day rest + mandatory
  neuro exam; 2nd type-4 in a season → min 4-month stoppage; 4 cumulative
  type-4 events in a career → federal medical review.

**Cross-cutting Savate finding:** Assaut vs Combat is fundamentally a
**contact-power** distinction, not a technique-list distinction — the same
techniques are broadly legal in both, but Assaut requires controlled/no-
power delivery. This matches `TECHNIQUE_CATALOG_AUDIT.md` finding 3's
recommendation: legality-matrix by contact-control level rather than
forking the node list.

---

## Karate

### WKF — Kumite Competition Rules

Governing body: World Karate Federation (WKF), the Olympic-recognized body.
Version 2026.01, valid from 1 January 2026. Jurisdiction: international.
(Per the assignment's own caution: other independent karate bodies exist —
WUKF, ITKF, various style federations — this research covers WKF only, and
that scoping is stated explicitly rather than treating "Karate" as one
universal ruleset.)

- **Age/weight (full table)** `DIRECT`: Senior (18+), U21, Junior (16–<18),
  Cadet (14–<16), U14 (12–<14) — each with 5 weight classes/sex.
- **Competition area** `DIRECT`: 8m×8m matted square + 1m boundary strip +
  2m safety area.
- **Equipment** `DIRECT`: WKF-approved mitts, mandatory body protector
  (male; female chest-and-body), shin/foot pads, groin guard (male);
  under-14 additionally requires a helmet.
- **Match duration** `DIRECT`: Senior/U21 3 min; Cadet/Junior 2 min;
  U14 1.5 min.
- **Scoring** `DIRECT`: YUKO=1 (punch/strike), WAZA-ARI=2 (body kick),
  IPPON=3 (head kick, or any technique landing with opponent grounded).
  Six-criteria test required (form, attitude, vigor, awareness, timing,
  distance).
- **Contact control** `DIRECT`: body techniques may land with controlled
  impact; head techniques must stop within 5cm(kick)/2cm(hand) or be a
  light skin-touch — **no contact at all permitted to the throat.**
- **Win methods** `DIRECT`: 8-point lead auto-ends bout; time-up = higher
  score; tiebreak via SENSHU → ippon count → waza-ari count → judges' vote;
  also HANSOKU (bout DQ), SHIKKAKU (tournament DQ), KIKEN (withdrawal).
- **Fouls** `DIRECT`: excessive contact, any throat contact, attacks to
  arms/legs/groin/joints/instep, open-hand face attacks, dangerous throws
  (pivot point must not exceed hip height; over-shoulder/sacrifice throws
  forbidden), feigning injury, self-endangerment, passivity, clinching/
  wrestling without an attempted score.
- **Penalty ladder** `DIRECT`: CHUI (warning, ≤3) → HANSOKU CHUI → HANSOKU →
  SHIKKAKU.

---

## Wrestling

### United World Wrestling (UWW) — shared structural facts (Freestyle + Greco-Roman)

Governing body: UWW. Ruleset dated January 2026 edition. Jurisdiction:
international/Olympic.

- **Age categories** `DIRECT`: U15 (14–15), U17 (16–17), U20 (18–20), U23
  (19–23), Senior (20+, no upper bound), Veterans (35+).
- **Mat** `DIRECT`: 9m-diameter circular area + 1.5m protection border; 1m
  passivity zone inside the edge.
- **Match structure (U20/U23/Senior)** `DIRECT`: two 3-min periods, 30-sec
  break. Younger age-group period lengths `UNKNOWN`.
- **Fall (pin):** both shoulders down long enough for the referee to
  confirm control.
- **Officiating** `DIRECT`: 3 mat officials (Referee, Judge, Mat Chairman),
  none the same nationality as either wrestler; one challenge per wrestler
  per match.

### Freestyle Wrestling

- **Weight classes (Senior/U23/U20, men)** `DIRECT`: 57, 61, 65, 70, 74, 79,
  86, 92, 97, 125 kg (women's classes not itemized in this pass —
  `UNKNOWN` exact list, though the same 10-class structure is standard).
- **Legal holds** `DIRECT`: leg grasping, tripping, and active leg use are
  all permitted without restriction.
- **Scoring** `DIRECT`: 1 pt (step-out/basic reversal), 2 pt (controlled
  pass-behind, correct throw to prone, back exposure <90°), 4 pt (standing
  hold to danger, short lift to danger, grand-amplitude throw without
  immediate danger), 5 pt (grand-amplitude throw with immediate danger,
  high-amplitude par-terre throw to danger).
- **Technical superiority threshold** `DIRECT`: 10-point gap.

### Greco-Roman Wrestling

- **Weight classes (Senior/U23/U20, men)** `DIRECT`: 55, 60, 63, 67, 72, 77,
  82, 87, 97, 130 kg.
- **Core restriction — verified exact wording, `DIRECT`, quoted:** *"it is
  strictly forbidden to grasp the opponent below the belt line, or to trip
  him or to use the legs actively on his opponent to perform any action."*
  This is the highest-confidence, cleanest example in the whole research
  pass of a genuinely discipline-variant-specific illegal-technique rule —
  Wrestling's `wrestling_single_leg`, `wrestling_double_leg`, and
  `wrestling_ankle_pick` catalog nodes should be marked `illegal` for
  Greco-Roman and `legal` for Freestyle.
- **Par-terre bottom-wrestler restrictions (Greco-specific)** `DIRECT`: max
  one hand on opponent's upper body while defending; no closed-arm
  blocking; no active leg use while defending.
- **Technical superiority threshold** `DIRECT`: **8-point gap** (lower than
  Freestyle's 10 — confirms the two styles are not interchangeable even in
  scoring mechanics, not just legal holds).
- **2026 rule change note:** a reported removal of a "two defensive leg
  fouls" provision for Greco-Roman in the 2026 edition is `CONFLICTING`/
  unverified — sourced from a search snippet, not confirmed against the
  full primary-document read-through.

---

## Judo

### International Judo Federation (IJF)

Governing body: IJF. Current documents: SOR v.14.08.2026 (full rules) and
SOR Refereeing Rules v.21.01.2026, both confirmed current via ijf.org's own
document index (`DIRECT` for version/currency; the full-size PDFs exceeded
fetch tooling limits, so content below is cross-verified via a 2024-03-12
SOR edition, a 2018 SOR mirror for structurally stable provisions, and a
Feb-2026 national-federation explainer of the 2026-28 rule changes — flagged
per-item below). Jurisdiction: international/Olympic. No professional judo
circuit exists under IJF.

- **Age categories** `DIRECT`: Cadets (15–17), Juniors/U21 (15–20), Seniors
  (15+, no upper bound), Veterans (30+).
- **Weight classes** `DIRECT`: Senior 7 classes/sex (Men −60 to +100kg,
  Women −48 to +78kg); Junior 9 classes/sex; Cadet 8 classes/sex.
- **Contest area** `DIRECT`: 8×8m min to 10×10m max + ≥3m safety area +
  50cm free zone. Exact common-safety-area figure at Olympic level is
  `CONFLICTING` between two sources (4m vs 6m).
- **Match duration** `DIRECT`: 4 minutes real (net) time for Senior/Junior/
  Cadet alike.
- **Golden score:** activates on any tie, no time limit, any technical
  score or hansoku-make ends it; automatic waza-ari after 10 sec of
  osaekomi during golden score specifically. `DIRECT`
- **Scoring — Yuko reinstated for the 2026-28 cycle** `DIRECT`/`CONFLICTING`
  on exact date: Ippon (full point, ends match), Waza-ari (lesser throw or
  10–19 sec hold; two = ippon-equivalent), **Yuko** (reinstated after its
  2017 removal — side/back landings, 5–9 sec hold) — the *existence* of
  yuko's return is well-corroborated `DIRECT`, the *precise effective
  competition date* is `CONFLICTING` across secondary sources.
- **Leg-grab rule — verified current status** `DIRECT`, quoted from SOR
  Art. 18.1.2: leg grabbing/trouser grabbing/blocking a leg with hands is a
  **shido (penalty)**, EXCEPT when both athletes are already in a clear
  ne-waza (ground) position and the standing action has stopped. This
  confirms the catalog audit's hypothesis: `judo_osotogari`, `judo_ogoshi`,
  `judo_seoinage`, and `judo_uchimata` (hip/leg-sweep throws that don't
  rely on hand-gripping the leg) remain unaffected by this restriction.
- **Hansoku-make (direct DQ) offenses** `DIRECT`: head-diving on specific
  named throws, kawazu-gake (leg-winding fall), kani-basami (scissor
  takedown), do-jime (body-scissor lock), ashi-garami (entangled leg
  lock), actions endangering the neck/spine, and several others (full list
  in source).
- **Medical:** fault-based default (injury-causing athlete loses if fault
  is attributable; indeterminate-cause injury defaults to the injured
  athlete losing); same bleeding injury may be treated twice, 3rd
  occurrence = loss.

---

## Sambo

### International SAMBO Federation (FIAS)

Governing body: FIAS (current confirmed official name). Ruleset: 2023
edition (most recent approval 22 May 2023), published separately for Sport
and Combat SAMBO. Jurisdiction: international.

- **Shared age categories** `DIRECT`: Cadets 14–16, Youth 16–18, Juniors
  18–20, Adults U24 18–23, Adults 18+, Masters in 5-year bands from 35 up.
- **Shared mat** `DIRECT`: 11×11m overall, 8m-diameter circular working
  area.
- **Insurance requirement — key equipment/safety divergence** `DIRECT`:
  Sport SAMBO requires min. USD 10,000 sports insurance; **Combat SAMBO
  requires min. USD 100,000** — a materially higher bar reflecting the
  added striking risk.

### Sport SAMBO

- **Match duration** `DIRECT`: Adults/Juniors 5 min; Youth/Cadets 4 min;
  Masters <65 4 min; Masters 65+ 3 min.
- **Weight classes (adult)** `DIRECT`: Men 46–98+kg (10 classes), Women
  41–80+kg (10 classes).
- **Legal techniques — key finding** `DIRECT`: throws, hold-downs, and
  painful holds (joint locks) only. **No striking of any kind and no
  chokeholds** — confirmed absent from the scoring articles (chokes appear
  only in the Combat SAMBO document).
- **Prohibited (warning + opponent score, repeat = withdrawal)** `DIRECT`:
  intentional head-first throws, standing painful holds, knee/ankle
  scissor locks, direct spinal/neck pressure, finger/toe locks,
  **chokeholds (explicitly banned)**, and any direct strike.

### Combat SAMBO

- **Match duration** `DIRECT`: 5 min, adults and juniors alike.
- **Weight classes** `DIRECT`: Men 58–98+kg (7 classes, missing Sport
  SAMBO's lowest 46kg bracket), Women 50–80+kg (7 classes).
- **Required protective equipment (the key equipment divergence from Sport
  SAMBO)** `DIRECT`: helmet, strike-gripping gloves, shin guards, groin
  cup/chest protector — none required in Sport SAMBO.
- **Legal striking — the core distinction from Sport SAMBO** `DIRECT`:
  punches (any part of fist but the palm), kicks (instep/edge/heel, shin,
  knee), elbow strikes to torso/limbs, knee strikes; head strikes permitted
  (helmet-protected). **Gender-differentiated restriction:** for men,
  elbow/head strikes to the head are banned only in ground position; for
  **women, banned in both standing and ground positions.**
- **Prohibited strikes** `DIRECT`: open-glove/palm-heel/finger strikes,
  strikes to back of head/crown/throat/collarbone/spine/tailbone,
  intentional groin strikes, striking an opponent without a helmet.

**Cross-cutting Sambo finding (feeds `TECHNIQUE_CATALOG_AUDIT.md` finding
2):** the catalog's single `sambo` discipline currently includes a striking
node (`sambo_strike_bodylock`) that is confirmed illegal under Sport SAMBO
(no striking permitted at all) and legal under Combat SAMBO — exactly the
legality-matrix split recommended in the catalog audit, now backed by a
direct primary-source citation.

---

## Capoeira

**Honest headline finding, `DIRECT`:** competitive/sparring capoeira is
**not standardized under one universally-recognized governing body** the
way judo or wrestling are. Most capoeira practiced worldwide is the
traditional non-competitive *roda* (game), governed by informal tradition
and *mestre* authority, with no written sparring/scoring ruleset. Several
self-declared federations (World Capoeira Federation/WCF, Confederação
Brasileira de Capoeira/CBC, ABADÁ-Capoeira, and smaller regional bodies)
each publish their own competition rules and compete with each other for
legitimacy rather than operating under one umbrella. **No single
authoritative body should be presented to the user as "the" capoeira
governing body** — if the game needs one workable ruleset, WCF's is the
most complete and independently verifiable, but this must be flagged as one
federation among several, not a Judo-style universal authority.

### World Capoeira Federation (WCF) — Competition Rules 2024

Approved by WCF Management Board 28 January 2026. Jurisdiction:
international (WCF-sanctioned events only).

- **Divisioning:** gender, age, weight, and (for some events) grade —
  exact numeric brackets are left to each event's own regulations, not
  fixed federation-wide. `DIRECT`/`UNKNOWN` specifics.
- **Contest area (the *roda*)** `DIRECT`: 4.5m-diameter circle; a live
  musical *Bateria* (berimbau/atabaque/pandeiro/agogô ensemble) sits
  centrally and is a scored, mandatory part of the contest itself —
  movement must rhythmically match it (no equivalent in any other
  researched discipline).
- **Protective equipment — key finding** `DIRECT`: **none.** Competitors
  compete barefoot in only a t-shirt/trousers/rank cord; no gloves,
  headgear, mouthguard, or groin guard anywhere in the rulebook. Safety is
  enforced entirely through the "light, controlled touch only" contact
  rule rather than equipment — structurally different from every other
  discipline researched.
- **Rounds** `DIRECT`: adults 2×45 sec (90 sec total); a tied 1st/2nd round
  triggers a 30-sec 3rd round.
- **Scoring — 5-judge system, each with a distinct mandate** `DIRECT`:
  Judges 1–2 score *Jogo & Rhythm* / *Techniques* / *Physique & Ethics*
  rubrics; Judge 3 scores line kicks; Judge 4 scores acrobatic *floreio*
  movements; Judge 5 scores takedowns.
- **A drawn individual match is explicitly not permitted.** `DIRECT`
- **Legal targets** `DIRECT`: open body and head, **excluding face and
  throat**; only light controlled-touch contact is legal.
- **Fouls** `DIRECT`: head strikes to the face, knee strikes, elbow strikes,
  scissor takedowns targeting the neck (body-targeted scissors legal),
  suffocation/choking/joint locks ("painful holds"), groin strikes,
  wrestling, grabbing without an immediate legal takedown technique.

**Implication for the catalog:** Capoeira's technique nodes (already
correctly named per the audit) remain valid vocabulary regardless of this
finding, but the "which competition ruleset governs Capoeira" question has
a genuinely different, weaker answer than every other discipline — this
should be surfaced to the user as a design decision (use WCF as a
provisional single ruleset with a clear in-game disclaimer, or treat
Capoeira as exhibition-only without a competitive ruleset) rather than
silently picking one.

---

## Arnis

### WEKAF (World Eskrima Kali Arnis Federation) / PEKAF (Philippine Eskrima Kali Arnis Federation)

Two closely linked bodies: WEKAF (international) traces to 1988/1989;
PEKAF is the Philippines' legally-designated national sports association
for Arnis under **Republic Act No. 9850** ("National Arnis Law," 2009),
which declares Arnis the Philippines' national martial art/sport. WEKAF's
rulebook itself credits PEKAF for parts of its content, confirming
coordination rather than competition between the two bodies. Ruleset
version v3.1, released 24 Aug 2025. Jurisdiction: international
(WEKAF-sanctioned events).

- **Age categories** `DIRECT`: extensive — Sparring divisions from Juniors
  mixed 0–9y through Seniors 57+y (height-based, not weight-based, for
  children/juniors); Forms divisions similarly banded.
- **Sex divisions** `DIRECT`: separate men's/women's for adults/seniors;
  mixed only for the youngest children's bracket.
- **Weight classes** `DIRECT`: extensive per-age/sex tables for adults;
  children/juniors use height instead.
- **Contest area** `DIRECT`: Live Stick/Padded Sparring ring 5–7m square;
  Forms ring 7–9m square.
- **Equipment** `DIRECT`: mandatory headgear + body protector + gloves +
  groin protector (male); weapon (*olisi*, live stick) ≤70cm/≤200g/≤2.6cm
  diameter, tournament-supplied.
- **Rounds** `DIRECT`: Live Stick 3×1 min (30-sec rest); Padded Sparring
  one 2-min round or 3×1 min.
- **Scoring** `DIRECT`: Live Stick uses a 10-Point Must system (boxing-
  style); Padded Sparring uses 1 point per confirmed hit + disarm scoring +
  an "Advantage Point" first-scorer tiebreak rule.
- **Win methods** `DIRECT`: Points, TKO (**including 3 disarms within a
  match** as an explicit TKO trigger — a mechanic unique to weapon-based
  Arnis among all researched disciplines), Disqualification, No Contest,
  Walkover.
- **Legal targets (Live Stick)** `DIRECT`: any part above the knee except
  groin and neck; back of head always illegal.
- **Fouls** `DIRECT`: thrusts and butt strikes (*punyo*) and two-handed
  strikes are banned in Live Stick specifically; grappling/wrestling/
  joint-locking (even for disarming) banned; hitting a downed/rising/
  surrendering opponent banned.
- **Foul penalty ladder** `DIRECT`: casual warning → official warning →
  1-pt deduction → 2nd-pt deduction → disqualification.

**Confirms the technique catalog's existing safeguard:** Arnis's own
`ruleset_note` field ("Weapon techniques require an Arnis ruleset or
exhibition; they are not legal in unarmed MMA") is directly validated by
this research — Arnis nodes should carry `not_applicable`/`illegal` for
every non-weapon ruleset in the legality matrix, exactly as the catalog
already anticipates.

---

## Pencak Silat

### PERSILAT (International Pencak Silat Federation) — Tanding (Sparring) Category

Document read is a training/summary presentation of PERSILAT's official
regulation (Tuah Bin Hashim, PERSILAT/Singapore Silat Federation, dated
23-Mar-2016). `CONFLICTING`/`UNKNOWN`: a possibly newer "Version 7
(09/10/2023)" edition was referenced in search results but not
independently verified — treat 2016-sourced figures as potentially
superseded. Jurisdiction: international.

- **Age/sex/weight** `DIRECT` divisions exist (Pre-Teen through Master I/
  II; male/female separate); exact age-year boundaries and weight-class kg
  figures were `UNKNOWN` in the primary document read (re-weighing occurs
  15 min before the match and functions as a tiebreaker).
- **Contest area** `DIRECT`: 10×10m arena, 8m-diameter circular match
  ground, bright-green padded mat.
- **Equipment** `DIRECT`: body protector, corner-identification sash,
  **mandatory plastic groin guard for all competitors, male and female.**
- **Rounds** `DIRECT`: always 3 rounds, 1.5–2 min each depending on age
  category, 1-min rest.
- **Scoring (point table)** `DIRECT`: 1 pt (unblocked hand strike), 2 pt
  (unblocked foot strike), 3 pt (successful drop/takedown), plus
  dodge-then-counter combination bonuses (1+1, 1+2), and a 1+3 bonus for a
  leg-grab followed by a drop. Penalty deductions: −1 to −10 across a
  4-tier reprimand/warning ladder.
- **Legal targets** `DIRECT`: trunk only (chest, abdomen from navel up,
  ribs, back excluding the spinal cord directly). **Lower limb (ankle and
  below) may only be targeted to unbalance/drop the opponent — non-
  scoring.**
- **Win methods** `DIRECT`: Points (majority decision, cascading tiebreaks),
  TKO (request/medical/towel/10-count), **Absolute Victory** (a valid
  knockdown the opponent can't rise from by count of 10), RSC, Walkover,
  Disqualification.
- **Fouls** `DIRECT`: attacking illegal areas (neck, head, groin, thighs,
  spinal cord directly), direct joint-break attempts, headbutts, wrestling,
  biting, scratching, hair-pulling, provoking/insulting conduct, gripping
  while attacking.
- **Medical** `DIRECT`: competition doctor has 120 sec to rule
  fit/unfit ("unfit" = TKO loss); a winner-by-opponent's-injury-DQ cannot
  compete in their next match without doctor clearance.

---

## Brazilian Jiu-Jitsu

### IBJJF (International Brazilian Jiu-Jitsu Federation)

Governing body: IBJJF — a private, for-profit federation; the dominant
global amateur sport-BJJ rule-setter, **not** an Olympic/IOC-recognized
body. Ruleset: IBJJF Rules Book v6.1, published June 2024. Jurisdiction:
global. **Competition level: amateur only** — BJJ has no real professional
governing body analogous to boxing's commissions; "professional" BJJ exists
only as informally-promoted superfight/grappling events (ADCC, WNO,
Polaris) run by private promotions with one-off rules, not a licensing
authority (`INFERRED` from the absence of any pro-license structure in the
primary source).

Gi and No-Gi share the **same rulebook**, differing only in specific
carve-outs — broken out below as the assignment requires.

#### Gi

- **Age divisions & match duration** `DIRECT` (full table, abbreviated):
  Mighty Mite I (age 4) through Master 7 (age 61+), each with its own
  duration; Adult duration itself varies by belt (White 5 min through
  Black 10 min); no maximum age for Adult/Master.
- **Sex divisions** `DIRECT`: separate male/female, distinct uniform rules.
- **Weight classes (Adult)** `INFERRED` — **not published in the primary
  rulebook itself** (IBJJF issues weight tables per-event separately);
  figures given in `competition_rulesets_v2.json` are corroborated across
  multiple independent secondary sources but not independently verified
  against a primary IBJJF document.
- **Mat:** 64m² minimum to 100m² maximum total (combat area + safety
  area), assembled from foam segments.
- **Scoring** `DIRECT`: takedown=2, sweep=2, knee-on-belly=2, guard pass=3,
  mount/back mount=4, back control=4; 3-second stabilization required;
  advantages are tiebreakers only.
- **Win methods** `DIRECT`: Submission, Stoppage (cramp/medical/bleeding/
  loss of bodily control), Disqualification, Loss of Consciousness, Score,
  Referee Decision, Random pick (last resort).
- **Penalties** `DIRECT`: escalating 1st=mark → 2nd=advantage to opponent →
  3rd=2pts to opponent → 4th=disqualification (extra steps under 15).
- **No strikes of any kind at any level** — punches/elbows/knees/headbutts/
  kicks are universal fouls, not belt-gated. `DIRECT`

#### No-Gi

Same rulebook/scoring/win-methods as Gi, with deltas `DIRECT`: no kimono
(rash guard + shorts); grabbing one's own or the opponent's uniform is a
unique serious foul (the inverse of Gi, where grips are central); Adult
brown/black gets its **own** (most permissive) belt-restriction column,
distinct from Gi brown/black. Match duration for No-Gi Adult/Master is
`UNKNOWN` — not published as a separate table in the source read.

#### The IBJJF belt/age-restricted submission table — the highest-value dataset in this research pass

Source: IBJJF Rules Book v6.1, p.29, "Technical Fouls — Illegal Moves,"
visually confirmed against the rendered PDF page, not just text extraction
— `DIRECT`, the highest-confidence single finding in this whole research
pass. 26 techniques, each banned for some divisions and legal for others;
legality **expands as belt/age rises**. The clearest pattern:

- **Only six techniques are illegal at every level, including adult black
  belt No-Gi:** slam, spinal lock without a choke, scissor *takedown* (a
  standing/flying technique — see the naming-precision note below, this is
  **not** the same as a guard "scissor sweep"), bending fingers backward, a
  belt-grab headfirst throw, and a suplex that drives the opponent's
  head/neck into the mat.
- **Heel hooks, knee-twisting locks, and knee reaping are legal only for
  Adult-through-Master-7 brown/black belts** (both Gi and No-Gi) — this
  single fact answers the practical game-design question of why a
  lower-belt AI opponent should never attempt a leg lock.
- **Omoplata and Triangle (pulling the head) are illegal only for the
  4–12yrs and 13–15yrs age divisions** — legal from Juvenile (16–17)/white
  belt Adult upward. An age gate, not a belt gate, for these two
  specifically.
- Everything else on the list (straight foot locks, wrist locks, calf/bicep
  slicers, kneebars, toe holds, closed-guard kidney/rib compression) sits
  somewhere between those extremes — full detail preserved verbatim in the
  research agent's report and applied per-technique in
  `technique_legality_matrix.json`.

**Naming-precision finding, carried into `TECHNIQUE_CATALOG_AUDIT.md`:**
the catalog's `bjj_scissor_sweep` node (a fundamental ground-based guard
sweep, phase `ground_bottom`) is **not** the same technique as IBJJF's
universally-banned "scissor takedown" (a standing/flying technique) despite
the similar name. `bjj_scissor_sweep` remains legal at every level; this is
flagged explicitly to prevent the two being conflated later.

**Other universal fouls (all belts/ages, not restricted by rank)** `DIRECT`:
biting, hair-pulling, eye/groin attacks, slippery substances, blocking the
opponent's airway with the hands, bare-hand neck grip/windpipe pressure
without the gi.

---

## Sanda

### IWUF (International Wushu Federation)

Governing body: IWUF, the IOC-recognized international federation for
Wushu (Sanda is its full-contact fighting discipline). Ruleset: "Wushu
Sanda Competition Rules & Judging Methods (2024)," approved 23 Jul 2024,
**effective 1 Jan 2025.** Jurisdiction: international. Level:
amateur/Olympic-track. A separate, longstanding Chinese domestic
professional/kickboxing-style commercial Sanda scene exists but is outside
this federation's ruleset scope (`INFERRED`, not addressed in the
rulebook).

- **Age categories** `DIRECT`: Children 9–11, Junior 12–14, Youth 15–17,
  Adult 18–40 inclusive.
- **Weight classes (Adult)** `DIRECT`: 12 classes, Under 48kg through Over
  100kg.
- **Rounds** `DIRECT`: 3×2 min, 1-min rest; win = taking 2 of 3 rounds;
  younger divisions may use shortened 1.5-min rounds.
- **Arena — lei-tai platform** `DIRECT`: 8m×8m raised platform, 80cm high,
  red boundary line, a yellow warning line 90cm inward from each side.
- **Legal targets** `DIRECT`: head, torso, thighs. **Illegal targets:**
  back of the head, neck, groin.
- **Permitted techniques** `DIRECT`: "all wushu punching, kicking, and
  throwing/wrestling techniques."
- **Scoring** `DIRECT`: 2pts for a platform fall, a stayed-standing
  opponent-fall, a valid kick to torso/head, a forced count, or an opponent
  warning; 1pt for a valid punch to torso/head, a valid kick to the thigh,
  or an opponent admonishment.
- **Fouls** `DIRECT`: headbutts, elbows, knees, adverse/hyperextending
  joint attacks, head-first throws/slams, attacking a downed opponent's
  head. None of the ten `sanda_*` catalog nodes (all punches/kicks/throws/
  catches) fall into any banned category — consistent, no catalog concern.
- **Win methods** `DIRECT`: Absolute victory (mismatch, 10-count failure,
  3 forced counts, 12+ point round gap), round win (2 forced counts, 2
  platform falls, or points), bout win (best-of-3 rounds).
- **Medical** `DIRECT`: health certificate (EEG/ECG/blood pressure) within
  15 days pre-registration; mandatory life insurance certificate.

---

## Taekwondo

### World Taekwondo (WT) — Kyorugi (sparring)

Governing body: World Taekwondo (WT, formerly WTF), the Olympic-recognized
federation. Ruleset: "Competition Rules & Interpretation," in force 1 Jun
2026 (most recent amendment 11 Apr 2026). Jurisdiction: international/
Olympic. **This covers WT specifically** — the separate ITF (International
Taekwon-Do Federation) governs a different, non-Olympic style that *does*
permit hand strikes to the head; that is a different governing body's
ruleset entirely, not a version difference within WT.

- **Age categories** `DIRECT`: Cadet 12–14, Junior 15–17, Senior 17+.
- **Weight classes** `DIRECT`: multiple formats by event tier (Olympic 4
  classes/sex; 6- and 8-category formats also used); Junior 10/sex; Cadet
  9/sex plus an optional height-based alternative.
- **Arena** `DIRECT`: 8m×8m square or ~8m-diameter octagonal contest area
  inside a 10–12m envelope, plus a new 60cm interior "Alert Area" band.
- **Rounds** `DIRECT`: 3×2 min, 1-min rest; a tie after round 3 triggers a
  1-minute Golden Round.
- **Legal targets — the key finding** `DIRECT`: trunk permits both fist and
  foot techniques; **head (above the collarbone) permits foot techniques
  only — punches to the head are explicitly illegal.** This has been WT's
  consistent position across its amendment history, not something that
  varies by rule edition; it's a difference from the separate ITF
  federation, not a WT rule change over time.
- **Scoring (PSS electronic)** `DIRECT`: punch to trunk=1, kick to trunk=2,
  kick to head=3, turning kick to trunk=4, turning kick to head=6, opponent
  penalized=1 (2 late in a round).
- **Win methods** `DIRECT`: RSC, PTF (final score), PTG (20-point gap),
  GDP (golden point), SUP (superiority decision), WDR, DSQ, PUN (10
  accumulated penalties), DQB.
- **Fouls** `DIRECT`: boundary crossing, falling down, avoiding/delaying,
  grabbing/pushing, kicking below the waist, hitting the head with the
  hand, head-butting/kneeing, attacking a fallen opponent.
- **Medical** `DIRECT`: SCAT5 concussion evaluation required within 30
  minutes of any head injury/KO; a moderate-to-severe head-trauma
  suspension is mandatory and cannot be waived.

**Confirms an existing catalog correctness finding:** all ten `tkd_*`
catalog nodes are kicks, with zero hand-strike nodes — this already
correctly matches WT's hand-strikes-to-head ban, independently verified
here rather than merely assumed.

---

## Cross-cutting findings for the game's data model

1. **No researched federation publishes a physical-attribute entry
   minimum** for beginning training in a discipline — every hard
   requirement found is age, weight, medical clearance, or (for BJJ) belt
   rank, never a strength/speed/technique floor. This directly confirms
   `PROGRESSION_AND_FIGHT_EXECUTION_AUDIT.md` section A's recommendation
   against inventing one.
2. **Weight classes are never shared across disciplines** — every single
   researched ruleset has its own distinct class boundaries (compare MMA's
   Flyweight 115–125 lb to Boxing's Flyweight 108–112 lb to Judo's −60kg
   senior class). `ATHLETE_MODEL_PROPOSAL.md`'s decision to resolve
   `competition_weight_class_id` per-ruleset from a canonical
   `current_weight_kg`, rather than storing one display string, is
   confirmed necessary by this research, not just theoretically motivated.
3. **Age divisions are real and vary hugely by discipline** — from WAKO
   Point Fighting's 6 bands (ages 7 through 55) to MMA's simple 18+/no-
   upper-bound. Age-eligibility logic needs to be ruleset-scoped, not one
   shared "age >= X" check.
4. **"Amateur vs professional" is not a universal axis** — it's a real,
   separately-ruled distinction for MMA, Boxing, Muay Thai, and (per FFSbf&DA)
   internally-tiered for Savate, but Judo, Wrestling, Sambo, Taekwondo,
   Sanda, and (confirmed) BJJ have no professional governing tier at all
   under their primary federations — BJJ specifically has no licensing
   authority resembling a boxing commission; "professional" BJJ is only
   informally-promoted superfight events run by private promotions with
   one-off rules. The `amateur_or_pro_status_by_discipline` field proposed
   in `ATHLETE_MODEL_PROPOSAL.md` should allow `not_applicable`, not force
   every discipline into the same binary.
5. **Contact-control variants (WAKO Point Fighting/Kick Light, Savate
   Assaut/Combat, Muay Thai amateur/pro elbow-knee rules) are extremely
   common** — nearly every striking discipline researched has at least one
   light-contact/full-contact split. This validates the catalog audit's
   general recommendation to solve these via the legality matrix's
   `restricted` status (with a contact-control note) rather than by
   forking catalog nodes per contact level.
6. **A hard gate can be belt/rank rather than age or medical** — BJJ is the
   clearest example researched: heel hooks, knee-twisting locks, and knee
   reaping are illegal below Adult-to-Master-7 brown/black belt regardless
   of the athlete's age, a genuinely different *kind* of hard gate from
   every other discipline's age/medical/weight gates. `rank_by_discipline`
   in `ATHLETE_MODEL_PROPOSAL.md` needs to carry real per-technique
   consequences for BJJ specifically, not just a cosmetic belt display.

---

## Master source list

Full citations are preserved per-discipline above (each governing body's
primary document, with URL, edition/version, and retrieval date). This
section is a flat index for quick lookup; see the discipline sections for
complete bibliographic detail and the specific facts each source supports.

1. Unified Rules of Mixed Martial Arts (Professional) — ABC, Aug 2025.
2. Unified Rules of Mixed Martial Arts (Aug 2019 mirror) — ABC.
3. ABC Amateur Mixed Martial Arts (Unified Rules) — ABC.
4. IMMAF Unified Amateur Mixed Martial Arts Rules — IMMAF, 2015 baseline.
5. Regulatory Guidelines and Rules for All World and Regional Championship
   Bouts (Professional Boxing) — ABC.
6. World Boxing Competition Rules — World Boxing, in force Nov 2024.
7. WAKO Rules — Chapter 7 (Ring General), Chapter 8 (Full Contact), Chapter
   9 (Low Kick), Chapter 10 (K-1), Chapter 3 (Point Fighting), Chapter 5
   (Kick Light) — WAKO, V18.
8. IFMA Rules & Regulations for International Competition, v3.0 — IFMA,
   May 2026.
9. World Muaythai Council (WMC) Rules and Regulations for Competitions —
   WMC, ~2020.
10. Rules for the 2026 World Championship Savate ASSAUT — FISav.
11. Mémento Formation FFSbf&DA — Cahier N°7: Les Règlements — FFSbf&DA,
    Sept 2024.
12. World Karate Federation Kumite Competition Rules, v2026.01 — WKF.
13. International Wrestling Rules (Greco-Roman/Freestyle) — UWW, Jan 2026.
14. International SAMBO Rules (Sport SAMBO, Combat SAMBO), 2023 edition —
    FIAS.
15. IJF Sport and Organisation Rules, v.14.08.2026 and v.21.01.2026
    (Refereeing), cross-verified via 2024-03-12 and 2018 SOR editions and a
    Feb-2026 national-federation rule-change explainer — IJF.
16. World Capoeira Federation Competition Rules 2024 — WCF, Jan 2026.
17. WEKAF Rules and Regulations Governing International Tournament
    Competition, v3.1 — WEKAF, Aug 2025.
18. Republic Act No. 9850 ("National Arnis Law") — Official Gazette of the
    Republic of the Philippines, 2009.
19. Competition Regulation of International Pencak Silat Federation —
    PERSILAT/Singapore Silat Federation, 2016.
20. IBJJF Rules Book, Version 6.1 — IBJJF, June 2024.
21. Wushu Sanda Competition Rules & Judging Methods (2024) — IWUF, effective
    1 Jan 2025.
22. WT Competition Rules & Interpretation — World Taekwondo, in force 1 Jun
    2026.
