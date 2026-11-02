# Fight Plans — research and design (2026-09-03)

Author: Claude (lead developer), solo. Requested by the user: "do a full
research on fight plans of each discipline — what they consist of, how they
look, and how we can best implement them in game to make sense."

Sequencing decision (user, 2026-09-03): **fix Fight Plans → then Fight Camp
(its button lives INSIDE the fighter's profile) → then redesign all scenes.**
This document is the research + the proposed design for the first step.
Nothing here is implemented yet.

---

## 1. What a "fight plan" is in FightCamp today (the honest baseline)

- `GameState.FIGHT_PLAN_IDS = ["balanced", "striking", "grappling"]`. Chosen
  at booking (the `FightContractScreen` picker, or the plan overlays in
  `EventsBoard`/`OfficeHub`), gated by real discipline competency
  (`get_available_fight_plans` via `evaluate_mma_transition_eligibility`),
  stored as `athlete["fight_plan"]`, carried into the fight snapshot.
- In the simulator the plan does exactly two things: it sets the starting
  corner `emphasis` (`_plan_starting_emphasis`) and it BANS the opposite
  emphasis from the corner menu for the whole fight
  (`PLAN_EXCLUDED_EMPHASIS`). Emphasis drives `EMPHASIS_ROLE_PRIORITY`
  (PRIMARY / SECONDARY / OPPORTUNISTIC / AVOID per technique role) →
  `FIGHT_PLAN_MULTIPLIER` (1.4 / 1.0 / 0.8 / 0.15) in the technique draw.
- Pace (aggressive / balanced / cautious) is a separate corner knob, not part
  of the plan. `FightPlanExplainer` explains the priorities the sim uses (it
  owns no second formula). There is no plan data file — plans are constants.
- **The judge is discipline-blind.** `_close_round` scores every round the
  same way: `striking_score` (= damage), `control_score`, takedowns, and a
  10-9 / 10-8 by margin. Yet `competition_rulesets_v2.json` already holds
  THIRTY researched scoring systems (10-point must, IBJJF positional points,
  WT electronic, WKF yuko/waza-ari/ippon, silat 1/2/3, sanda platform
  points, judo ippon/waza-ari, sambo 4/2/1, savate target-zone values…).

Verdict: today's plan is one axis — striking ↔ grappling — plus a pace knob.
It cannot express range, targets, pace across rounds, the gripping /
positional / distance duels that decide real fights, scoring-aware
priorities, or opponent-specific adjustments. And because the judge ignores
the ruleset, a "correct" BJJ or judo plan could not be rewarded even if the
plan existed.

---

## 2. Per-discipline findings — what a plan consists of, sport by sport

Format: scoring model (what the ruleset rewards) → the game's round
structure (`combat_rulesets.json`) → the components of a real plan → the
style archetypes coaches actually name → the signature battle that decides
whether the plan works. Sources at the end.

### Boxing
- Scoring: 10-point must — clean effective punches, damage, knockdowns, ring
  generalship. In game: 8 × 3:00.
- Components: RANGE (outside / mid / inside), PACE and output, TARGET (head
  vs body work), RING CONTROL (cut off the ring vs lateral movement), TIMING
  (lead vs counter), and a ROUND PLAN (feel-out → build → close).
- Archetypes (coaching literature names four, often five): **out-boxer**
  (distance, footwork, jab-heavy, makes you chase), **swarmer / pressure
  fighter** (close distance, overwhelm with output, bob-and-weave), **slugger**
  (power, fewer punches), **boxer-puncher** (adapts, mixes range and power),
  **counter-puncher** (patient timing, punishes mistakes). Fighters switch
  styles mid-bout to exploit an opponent.
- Signature battle: **the jab / distance** — who controls range.

### Kickboxing (K-1 / GLORY / WAKO)
- Scoring: judges favour clean strikes, damage, knockdowns, aggression;
  VOLUME swings rounds. Limited clinch (typically one strike, then break). In
  game: 3 × 3:00.
- Components: the Dutch template (jab → cross → hook → rear low kick),
  LOW-KICK ATTRITION (legs erode mobility across the fight), high-volume
  pressure to sway judges, RING CONTROL (cutting off, trapping on the ropes).
- Archetypes: **Dutch pressure** (boxing chains into low kicks), **Thai-
  influenced kicker** (body/leg kicks, teeps), **counter striker**.
- Signature battle: the **low kick vs check** exchange and ring position.

### Muay Thai
- Scoring: effect-based — the fighter landing the most strikes WITH EFFECT
  wins the round; **clinch dominance scores heavily**; ring position and
  pace control break ties. In game: 5 × 3:00.
- Components: a genuine ROUND CURVE — round 1 is assessment (jab and teep as
  range finders, conserve), round 2 builds and tests defensive patterns and
  begins clinch dominance, round 3 is the pivotal peak (traditional Thai
  judging weights the middle rounds), then bank; the TEEP as the jab (range
  and rhythm control); LOW KICKS as cumulative breakdown; the CLINCH with
  knees and elbows dictating pace.
- Archetypes (the Thai style names): **Muay Khao** (knee/clinch), **Muay Tae**
  (kicker), **Muay Femur** (technician, timing), **Muay Mat** (puncher).
- Signature battle: **clinch entry** — who gets to the plum on their terms.

### Wrestling (freestyle / Greco)
- Scoring: takedown 2, step-out 1, exposure 4-5 by amplitude; passivity /
  shot-clock rules force action. In game: 2 × 3:00.
- Components: TIES and hand-fighting, ATTACK SELECTION (single / double /
  high-crotch), POSITION and level, TEMPO ("let them come" and pace yourself
  vs relentless attack rate), CONDITIONING (matches are won by who keeps the
  intensity longest), SCOUTING to steer the match away from undesirable
  positions.
- Archetypes: **pressure / attack-rate**, **positional counter**, **scrambler**.
- Signature battle: **the tie-up** — who wins hand-fighting and position.

### Brazilian Jiu-Jitsu (IBJJF)
- Scoring: positions — takedown 2, sweep 2, knee-on-belly 2, guard pass 3,
  mount / back 4; a position must be STABILISED (3 s); advantages; stalling
  is penalised (you may not back away from a seated guard). In game: 1 ×
  10:00.
- Components: a THREE-PHASE PLAN — opening (grips, pull guard or shoot, deny
  the opponent's preferred position), middle (score early, advance
  systematically), endgame (ahead: hold and avoid risk; behind: calculated
  aggression; tied: force the action); the POSITIONAL LADDER (takedown or
  sweep → pass → mount / back → submit).
- Archetypes: **guard player** vs **passer**; **points player** vs
  **submission hunter**.
- Signature battle: **guard vs pass** (passing has overtaken guard at the top
  level: powerful passes right off the guard pull, first 30 seconds).

### Judo (IJF)
- Scoring: ippon ends it; waza-ari (two = ippon-equivalent); shido penalties
  (three = loss); golden score. In game: 1 × 4:00.
- Components: **KUMI-KATA** — "plan your grip like a throw; don't improvise";
  different gripping plans for different opponents; grip-breaking to regain
  control; RE-GRIPPING before a throw scores significantly more; KUZUSHI
  (balance breaking), timing, distance, combinations and feints; the
  NAGE-WAZA → NE-WAZA transition drilled as one action.
- Archetypes: **grip-dominant thrower**, **counter-thrower**, **ne-waza
  specialist**.
- Signature battle: **the grip** — the fight is decided before the throw.

### Karate (WKF kumite)
- Scoring: yuko 1 (punch), waza-ari 2 (body kick), ippon 3 (head kick / any
  technique on a downed opponent); win by 8-point gap or on points;
  **SENSHU** (the first unopposed point) decides ties — and is forfeited for
  avoiding combat in the last 15 s; hantei favours who INITIATES. Scoring
  distance is measured (2 cm hand / 5 cm foot). In game: 1 × 3:00.
- Components: DISTANCE and TIMING, INITIATIVE (take senshu early), risk
  management late (don't run: jogai and avoidance penalties), the choice
  between hand blitzes (frequent, 1 pt) and kicks (rarer, 2-3 pts).
- Archetypes: **blitz / lead-hand attacker**, **deai counter fighter**,
  **kicker**.
- Signature battle: **distance and first initiative** (senshu).

### Taekwondo (WT kyorugi)
- Scoring: electronic PSS with force thresholds; punch to trunk 1, kick to
  trunk 2, head kick 3, turning kick 4 / 5. In game: 3 × 2:00.
- Components: the "chess match" of bouncing footwork and reading intent;
  the CUT KICK as the jab (already in the catalog); HEAD-KICK RISK/REWARD
  (+1 point but longer balance recovery and counter exposure); scoring
  EXCHANGES rather than single shots.
- Archetypes: **front-leg cut-kick controller**, **head-hunter**,
  **counter-kicker**.
- Signature battle: **footwork and the first kick of the exchange**.

### Sanda (IWUF)
- Scoring: 2 points when the opponent falls off the LEITAI platform, falls
  while you remain standing, or for a valid kick to the torso; clinches
  limited to a few seconds. In game: not yet a combat ruleset (catalog and
  competition rulesets exist).
- Components: KICK-CATCH THROWS, PLATFORM / EDGE CONTROL (pushing off scores),
  short clinch windows, a striking → throw rhythm.
- Archetypes: **catch-and-dump thrower**, **striker**, **edge pusher**.
- Signature battle: **the kick catch** and the platform edge.

### Sambo (sport / combat)
- Scoring: throws score by whether YOU stay standing (4 / 2 / 1); holds 20 s
  / 10 s; leg locks legal (sport), strikes and chokes added in combat;
  stalling penalised liberally — action-forward. In game: 1 × 5:00.
- Components: THROW SELECTION for the standing-throw bonus, the THROW → LEG
  LOCK chain (already an authored combo), holds as points, relentless
  engagement.
- Archetypes: **thrower-to-leglock**, **control / hold player**.
- Signature battle: **the throw entry** — staying upright while they fall.

### Savate (boxe française)
- Scoring: ASSAUT rewards clean controlled touches by TARGET ZONE (low 1 /
  medium 2 / high 4, punch 1 — precision over force); COMBAT scores power and
  effect; DISTANCE MANAGEMENT is "a pillar of strategy". In game: no combat
  ruleset yet.
- Components: distance, the chassé bas (low kick) opened by feints and hand
  attacks, target-zone value hunting (high kicks are worth four).
- Archetypes: **distance kicker**, **in-fighter with hands**.
- Signature battle: **distance** — who lands clean at their range.

### Capoeira (WCF)
- Judged as a GAME — jogo, rhythm, technique, ethics rubrics across judges.
  It is not a fight plan in the same sense. Proposal: a PLAN-LITE (flow /
  evasion / counter emphasis) rather than the full model.

### Arnis / Eskrima (WEKAF)
- Scoring: live stick 10-point must per encounter/exchange; head shots take
  precedence; DEFENSE IS MANDATORY (its absence is penalised); strikes that
  "would end a real confrontation" score higher. In game: 3 × 1:00 typical
  (no combat ruleset yet).
- Components: exchange-based scoring, defence-then-counter chains (already
  an authored combo), head targeting, disarms.
- Archetypes: **aggressive slasher**, **block-and-counter**.
- Signature battle: **the exchange** — who lands clean and defends.

### Pencak Silat (tanding)
- Scoring: hand strike 1, foot strike 2, DROP / takedown 3, and +1 / +2 for a
  successful dodge-then-counter; winners use defence more than losers.
- Components: pasang (stance), langkah (footwork patterns), catch-kick
  takedowns (jatuhan), the dodge-counter bonus as the core scoring engine.
- Archetypes: **counter-defender**, **aggressive scorer**, **takedown
  specialist**.
- Signature battle: **the catch** — reading the kick and dropping them.

### MMA
- Scoring: 10-point must with priority striking / grappling > effective
  aggression > area control; IMMAF adds time-sliding weights. In game: 3 ×
  5:00.
- Components: WHERE THE FIGHT HAPPENS (the striker keeps it standing —
  sprawl, underhook; the grappler closes, clinches, takes down), CAGE CONTROL
  (pin, steer, reset), phase blending, ROUND STRATEGY, CORNER ADJUSTMENTS
  from what the fight reveals.
- Archetypes: **sprawl-and-brawl**, **wrestle-and-ground-and-pound**,
  **submission grappler**, **clinch / dirty boxer**, **point striker**.
- Signature battle: **the takedown / cage** — who decides where it happens.

---

## 3. Synthesis — every fight plan has the same seven parts

Across fifteen disciplines the vocabulary differs but the anatomy does not.
A fight plan is:

1. **A style archetype** — the fighter's way of winning (pressure / volume,
   distance / control, counter / timing, power / finish, positional grinder,
   submission hunter, thrower).
2. **Where the fight happens** — preferred range and phase (outside, mid,
   pocket, clinch, ground; keep it standing vs take it down; ring / cage /
   platform control).
3. **What earns the win under THIS ruleset** — the scoring-aware priorities
   (damage and knockdowns; volume and activity; touches by target zone;
   positions, passes and sweeps; throws and holds; platform falls;
   initiative / senshu).
4. **Targets** — head, body, legs (the body-targeting engine already
   exists).
5. **A pace curve across rounds** — feel-out, build, peak, bank; last-round
   urgency; the stamina budget (which the combo stamina rule already
   enforces).
6. **A signature battle** — the one duel that decides whether the plan is
   viable: the jab in boxing, kumi-kata in judo, guard-vs-pass in BJJ, the
   tie-up in wrestling, clinch entry in Muay Thai, the cage in MMA, distance
   in karate and savate, the catch in silat and sanda.
7. **Adjustments** — scouting the opponent before, contingencies during ("if
   behind after round 2, pressure"; "if hurt, survive"; "if they tire, walk
   them down"), corner calls, and the opponent's reads of a one-note plan.

What management games teach (MMA Tycoon, MMA Manager 2, The MMA Manager
Game): many 0-100 sliders read badly; a few EXPLICIT either/or choices and
"focus areas" (pick up to two: head hunting, body work, clinch, ground
control, defensive priority, fast start) read well; corner instructions
should DECAY (50% per round); a fight camp is sliders across weeks that build
TEMPORARY boosts. The pattern to copy is focus + few clear choices; the
pattern to avoid is a wall of sliders.

---

## 4. Proposed in-game model — "Fight Plan v2"

Principle: a plan is DATA, not a code constant, and it is expressed in
terms the simulator already understands so no second combat formula is
born. Two additions make plans "make sense": a ruleset-aware judge, and
plan archetypes per discipline.

### 4.1 The judge learns the ruleset (`scoring_profile`)
Add a machine-readable `scoring_profile` to each combat ruleset (derived
from the researched text already in `competition_rulesets_v2.json`):
weights for damage, landed volume, knockdowns, control time, takedowns /
throws (with a "stayed standing" bonus for sambo / judo), positions (pass /
mount / back), submission attempts, touches by target zone (savate / TKD /
silat / karate), platform falls (sanda), initiative (karate senshu), and a
round-scoring STYLE: 10-point must (boxing / MMA / Muay Thai / kickboxing /
arnis), point accumulation (TKD / karate / savate assaut / silat / sanda /
wrestling / BJJ / sambo), or ippon-decisive (judo, sambo's 4-point throw).
`_close_round` and `_finish_fight` score by the profile. Most inputs exist
already (striking_score, control_score, takedowns, knockdowns, per-technique
lands, target regions, submission attempts); touches-by-zone and platform
falls need small new counters; "decisive throw" is a takedown with a
magnitude threshold.

### 4.2 Plan archetypes per discipline (`fight_plans.json`)
Each discipline family lists 3-4 archetypes (from §2). An archetype bundles
the seven parts as sim-native data:
- `role_priority` — the existing PRIMARY / SECONDARY / OPPORTUNISTIC / AVOID
  map per technique role (drives the draw exactly as emphasis does today).
- `phase_preference` — keep-standing vs take-it-down bias (weights for
  takedown / escape / control by phase) and a ring / cage / platform
  control term.
- `target_bias` — head / body / legs weights feeding `_technique_target_region`.
- `pace_curve` — pace per round (e.g. Muay Thai: cautious R1-2, aggressive
  R3-4, balanced R5; boxing 8 rounds: feel-out, build, close), auto-set at
  each round boundary unless the corner overrides.
- `scoring_focus` — which profile terms this plan banks (mirrors 4.1).
- `signature_battle` — the named duel (grip / distance / tie-up / clinch
  entry / cage / catch) resolved per round from the relevant stats and
  learned techniques; winning it shifts initiative and phase for the round.
- `contingencies` — rules the coach turns into timely suggestions ("behind
  after round 2 → pressure", "hurt → survive", "opponent gassing → walk
  down"); the coach's TACTICAL rating decides how good and how early, the
  rapport LISTEN ROLL decides whether the fighter executes, and the
  opponent's READS punish a one-note plan (all three mechanics exist).
- `requirements` — competency gates as today, plus technique-role minimums
  (a grip-dominant thrower needs takedown techniques; a submission hunter
  needs submissions).
- `game_plan_chains` — the coach's combo picks (Stage 3) become part of the
  plan.
- Capoeira: plan-lite (flow / evasion / counter only).

### 4.3 How a plan flows through the game
- **Booking**: the picker lists the discipline's archetypes (replacing the
  three ids), gated by requirements; `FightPlanExplainer` explains the
  archetype in the fighter's own arsenal.
- **The bout**: the snapshot carries the bundle; the draw applies role /
  phase / target weights; the pace curve sets the corner pace each round;
  the corner can still override (pace, emphasis, reactions, "let the
  combination go"); the signature battle is fought each round; contingencies
  surface as coach suggestions; the judge scores by the ruleset profile.
- **Fight Camp (next stage)**: camp weeks build TEMPORARY boosts aligned to
  the chosen plan (its roles, targets, combos, signature battle) — which is
  why the plan must exist first. Its button lives in the profile.
- **The profile (redesign)**: shows the fighter's natural style (their best-
  fitting archetype), the current plan, the signature-battle record, and the
  Fight Camp button.

---

## 5. Implementation stages (proposal, all headless-testable)
- **Stage A — data + judge**: `fight_plans.json` archetypes; `scoring_profile`
  per combat ruleset; `_close_round` / `_finish_fight` by profile; the new
  counters (touches by zone, platform falls, decisive throw). Tests: a BJJ
  bout scores positions, a TKD bout scores head kicks over trunk, boxing
  unchanged.
- **Stage B — the plan in the sim**: role / phase / target weights and the
  pace curve from the plan; requirements; snapshot; the picker lists
  archetypes; explainer.
- **Stage C — the signature battle + contingencies**: per-round duel;
  contingency rules → coach suggestions (tactical) through the listen roll;
  reads.
- **Stage D — Fight Camp** (its own stage, button in the profile): weeks →
  temporary boosts aligned to the plan.
- Then the scene redesign.

---

## 6. Decisions for the user
1. Plan cadence: chosen at booking only (today), or chosen at booking, refined
   during camp, locked on fight day (recommended).
2. Archetypes per discipline: the 3-4 named in §2 (recommended), or fewer.
3. A ruleset-aware judge: yes (recommended — without it, plans cannot make
   sense per discipline) or keep the single judge.
4. Round pace: automatic from the plan with corner override (recommended) or
   fully manual.
5. Contingencies: auto-suggested by the coach (tactical rating, listen roll)
   (recommended) or manual only.
6. Capoeira: plan-lite (recommended).

---

## Sources
Boxing — Evolve Daily (swarmer style), Boxing Wiki (styles and technique),
Ringside (boxer-puncher), Ring Kong (styles explained), LoneBoxer (five
styles), Box With Simmy (choosing a style). Kickboxing — GLORY (the art of
low kicks), Fairtex (Muay Thai vs Dutch), Fight Encyclopedia (K-1 / Glory
combinations), Austin Kickboxing (Glory strategies). Muay Thai — Evolve
Daily (scoring systems; low-kick combinations), Muay Thailand (scoring),
HKT (rounds and strategy), Fairtex (teep mastery), Ground Control (strategy
tips). Wrestling — Fanatic Wrestling (strategies), Play With Rules
(freestyle rules and scoring), AWA Wisconsin (game plans), Wrestler Mom
(winning strategies). BJJ — BJJ Atlas (competition strategy), bjj-app wiki
(competition guide; points guide), AIBJJ and LetsBJJ (IBJJF rules), The
Grappler's Watch (JiuJitsu Con analysis). Judo — Judo Training (Hajime-Matte
model), judo.science (the grip game), My Judo Training (competition
strategies), re-gripping study (UPI library). Karate — WKF Kumite
Competition Rules 2023 / 2026. Taekwondo — BSTF (WT rules), SportsEdTV
(kyorugi rules), Golden Hour (modern scoring), Spinning Kick TKD
(competition guide). Sanda — IWUF (Sanda), Arizona Sanda Association, MCMA
(complete guide). Sambo — FIAS rules, Grappler HQ (combat vs sport), Way of
the Fighter. Savate — FightFocus (assaut rules), Combat Arena (savate
guide), Savate Montréal. Arnis — WEKAF rules (full contact; padded stick),
Water Mountain (competition rules). Pencak Silat — ActiveSG (scoring), the
ResearchGate tanding tactics analysis, WFMAF. MMA — Evolve Daily (strikers
and grapplers; using the cage), Fightstyle (cage control), Establish The Run
(analysis), Oboe (modern MMA strategy). Management games — MMA Tycoon wiki
(fight tactics; slider strategies), The MMA Manager Game (App Store), MMA
Manager guides (GamingonPhone, Level Winner).
