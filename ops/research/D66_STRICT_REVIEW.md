<!-- D66 - Dola (browser research agent), delivered S132 2026-09-30 from TASK_D66_STRICT_GAME_REVIEW.md + 15 s131_exe_walk
     screenshots. Dola's text, unedited, from its own heading down (the brief above it in the chat is dropped). Opinion from
     screenshots only, as it says at the end. Collected by Claude S132. -->

# D66 - Strict review

---

## 1. VERDICT
**Score: 5/10 — Solid bones, unpolished and under-explained**
- The core loop (manage gym → build fighter → plan camp → fight) is distinct and promising.
- But systems are opaque, interfaces cluttered, and many critical rules are never taught.
- Players will feel lost, not empowered — the opposite of great management sims.
- Right now it’s a prototype with promise, not a game that respects the player’s time.
- Biggest flaw: **Lack of feedback, clarity, and meaningful decision weight** — choices feel arbitrary rather than skillful.

---

## 2. WEAKNESSES (ranked top 10)

| # | Screenshot | Issue | Why it hurts | Fix |
|---|---|---|---|---|
| 1 | 08_home | **No onboarding or tutorial** — every panel, number, and icon is unexplained. "Ready to book", "quiet week", condition/fatigue bars have zero definition. | New players freeze; they don’t know what matters or where to start. Trust evaporates. | Progressive guided first week: highlight 1 action at a time; add persistent "What is this?" tooltips on every stat/button. |
| 2 | 13_card_overview | **Attribute scale & colour coding are unclear** — numbers 0–40, letters D/E, bars with no baseline. No explanation of ceiling vs base vs fight-ready. | Players can’t tell if 36 speed is good, average, or maxed; no sense of progress. | Standardise to 0–100; colour-code by tier (novice → elite); label base/target/ceiling visibly; add 1-sentence "This stat controls X" hover text. |
| 3 | 60_start_a_camp | **Camp choices lack consequence preview** — "The Striking Shark", "The Marathon Man" etc. are flavour phrases with no visible stat or style impact. "Projection: nothing to choose yet" is empty space. | Choices feel like gambling, not planning. No way to learn what works. | Every camp focus shows: **+Power +8, -Defence -3 / Opponent style: Southpaw → your adjustment: +Technique +5**. Show before committing. |
| 4 | 21_program | **Training calendar is passive** — all days OFF; no quick-set templates, no "balanced / endurance / power" presets. | Setting up a week feels like tedious data entry rather than strategy. | Add 1-click presets; drag-and-drop to copy days; colour-code intensity; auto-balance fatigue across the roster. |
| 5 | 14_skills_&_moves | **Skill tree is locked & unrevealed** — every node says LOCKED; no path visible, no requirements shown beyond the first node. Proficiency 60 means nothing without a scale. | Players can’t plan development; the tree feels like a tease, not a progression system. | Reveal the full tree from day one; grey out locked nodes but show exactly what unlocks them (Proficiency ≥ 65 + 2 weeks training); show chains and prerequisites. |
| 6 | 47_offers | **Fight offers have no difficulty indicator** — "even bout" is vague; no ranking gap, no opponent record preview, no stylistic matchup edge. | Accepting fights is blind; players can’t tell if they’re feeding a fighter or setting them up to shine. | Add clear matchup summary: **W/L record, style advantage, projected win %, risk of injury, purse vs reputation gain**. |
| 7 | 38_finance | **Financials are superficial** — net –$231/week, $25k cash, no breakdown of income vs expenses, no forecast. | Can’t tell if you’re growing or dying; no strategy around sponsorships or membership pricing. | Breakdown tab: monthly income (members, sponsors, purses) vs costs (coaches, rent, staff); 12-week forecast; "raise membership fees?" risk/reward prompt. |
| 8 | 33_floor | **Floor space is confusing** — 36/40 used, 1.1x load, no explanation of what stations do or which fighters use them. Expansion $12k with no ROI estimate. | Players don’t know if buying space helps; floor feels like decoration not gameplay. | Label each station’s purpose: **Heavy Bag → Power/Conditioning; Mat → Grappling; Ring → Technique/Defence**. Show: "Expand → +4 stations, supports 2 more fighters, +$X/mo revenue". |
| 9 | 62_technical_flow | **Fatigue/recovery math is hidden** — "Fatigue +6/week, –6 injury risk" but no total fatigue cap, no recovery speed formula. | Players can’t schedule safely; overtraining is a mystery penalty. | Clear fatigue meter 0–100; recovery rate per day; warning: "This schedule will exceed safe fatigue limit — risk of injury". |
| 10 | 17_body_lab | **Body regions are decorative** — all 100/100 "sound"; no explanation of how damage carries between fights or what training does to regions. | Body Lab feels like a fancy screen with no gameplay weight. | Show: "Left arm durability: 85 → repeated strikes risk injury"; training programmes that target recovery or strengthening; carryover: bruising/swelling visible → next fight penalty. |

---

## 3. NEW FUN MECHANICS — Adapted from genre best

### A. Focus Allocation System — *Mad Games Tycoon 2* style
- **How it plays**: Each fight camp gives **10 focus points** to distribute across 5 core vectors: *Striking, Defence, Stamina, Range, Style Adaptation*. Every slider has a **sweet spot** — over-investing creates diminishing returns or penalties (e.g. max Stamina = slower starts; max Defence = counter-punch vulnerability).
- **Player learns**: Each opponent and style has an optimal band. Southpaws need more Range; brawlers need Defence at mid-range. Over time you build a mental playbook of stylistic counters.
- **Ties to engine**: Directly feeds into bout simulation — Range determines who controls the centre; Stamina degrades round-by-round based on allocation; Style Adaptation softens opponent stat edges.
- **Risk**: Spread too thin → no strength; over-specialise → exploitable hole.

### B. Camp Resource Budget — *Football Manager* training intensity
- **How it plays**: Camp has finite **Energy budget** (0–100). High-intensity work drains faster; rest days replenish. You choose: sparring intensity, film study hours, strength sessions, rest.
- **Player learns**: Pushing hard early then tapering = peak fight-night freshness. Every fighter has a personal rhythm — some need rest-heavy, others need constant work.
- **Ties to engine**: Energy translates directly to fatigue curve in the fight. Film study → "read opponent" accuracy bonus.
- **Risk**: Too intense → injury or flat performance; too soft → under-prepared.

### C. Corner Priority Wheel — *Frostpunk* law & choice
- **How it plays**: Between rounds, a **3–5 choice dial** appears: "Push pace / Fix defence / Target body / Rest & recover / Change stance". Each choice shifts a visible momentum bar and consumes limited fighter stamina.
- **Player learns**: Read knockdowns, swelling, breathing, and opponent patterns — adjust *mid-fight*. Not just pre-planning but live adaptation.
- **Ties to engine**: Real-time momentum shifts; wrong call = lost round; perfect adjustment = turnaround.
- **Risk**: Panic choices cost stamina for later rounds; sticking to plan when it’s failing = stoppage.

### D. Style Matchup Chart — *Out of the Park Baseball* scouting
- **How it plays**: Film study reveals a **matchup matrix** showing your style vs theirs: *Strong / Neutral / Weak* with percentage edge. Boxing orthodox vs southpaw; MMA striker vs grappler.
- **Player learns**: Which matchups to chase and which to avoid; when to change style or train a counter.
- **Ties to engine**: Percentage edges applied to all relevant rolls; visible in fight preview so you never walk in blind.
- **Risk**: Over-reliance on matchup edge → neglect fundamentals; opponent changes style mid-camp.

### E. Roster Synergy & Culture — *Two Point Hospital* staff morale
- **How it plays**: Fighters sharing styles or training partners boost each other’s gains; conflicting personalities or overcrowded floor reduce morale and focus. Build a culture — aggressive vs technical vs defensive gym identity.
- **Player learns**: Balance individual training with team chemistry; recruit compatible fighters; assign partners strategically.
- **Ties to engine**: Partner bonus % applied during camp; morale = late-round resilience; gym identity shapes reputation and who signs.
- **Risk**: Close team = cliques; star signing disrupts everyone else.

### F. Skill Tree Specialisation — *Punch Club* branching
- **How it plays**: At key career milestones, pick **one branch** that locks others: *Pure Boxer / Counter-Puncher / Pressure Fighter*. Each has unique tree nodes and passive bonuses.
- **Player learns**: Commit to an identity, not just collect moves. Build a recognisable fighter brand.
- **Ties to engine**: Unlocks exclusive plan options and corner commands; opponents scouting you will adapt to your known style.
- **Risk**: Inflexible against counters; must plan long-term.

### G. Weight Cut Tension System — *Motorsport Manager* resource management
- **How it plays**: Days-out slider — aggressive cut = size advantage but drained stamina; conservative = fresh but physically smaller. Real-time countdown with "hit target / miss / dangerously low" states.
- **Player learns**: Know your fighter’s body; track weight daily; manage recovery after cut.
- **Ties to engine**: Weight difference = strength/endurance modifier; missed cut = fine + penalty.
- **Risk**: Too aggressive → depleted; too safe → physically outmatched.

---

## 4. AAA PRESENTATION — Top 3 mechanics polished

### 1. Fight Plan & Focus Allocation
- **Reference**: *Football Manager 2025 — Match Setup*
- **Before fight**: Clean 5-panel radial diagram — each axis = focus area. Current allocation highlighted; opponent profile overlay shows their strengths/weaknesses as a second shaded shape. **"Your plan vs Theirs"** side-by-side visual comparison.
- **During**: Real-time momentum graph updating round-by-round; colour shifts from blue → amber → red as plan succeeds or unravels.
- **After**: "The Plans" breakdown — which choices won/lost which rounds; replayable key moments tagged with your decision ("You chose to press → knockdown in R3").

### 2. Fight Camp Timeline
- **Reference**: *Star Wars: Squadrons — Mission Briefing*
- **Before**: Horizontal timeline with intensity heatmap. Green = building, amber = peaking, red = danger zone. Drag to shift focus; instant visual feedback on freshness vs readiness.
- **During**: Weekly milestone cards — "Style adjustment complete", "Stamina baseline reached", "Minor niggles detected". Brief, cinematic, satisfying.
- **After**: Debrief dashboard — what camp mechanics moved the needle; permanent stat gain preview.

### 3. Live Fight & Corner Interaction
- **Reference**: *EA Sports UFC 5 — Fight Flow*
- **During**: Minimal overlay — momentum arrow, visible fatigue/sweating/swelling, round timer. Between rounds: **3-second pause** → clean circular menu slides in; coach voice + text prompt: *"He’s slowing — push the pace"* / *"His left eye is closing — go to the body"*. Choices feel urgent and informed.
- **After**: Highlight reel with decision log — every key moment annotated with your plan/corner choice. "You adjusted to southpaw stance → landed 42% more power shots".

---

## 5. The ONE thing to build before 6 October
**A complete, guided first fight flow — explained at every step.**

From accepting the offer → setting the camp → weight cut → watching the fight → reading the result — **every screen must explain what you’re looking at and why it matters**. No unexplained numbers, no empty "projection" boxes, no locked trees without unlock rules visible. The demo doesn’t need all features; it needs **clarity, feedback, and one fully satisfying loop** that leaves the player thinking, *"I see what I did there — next time I’ll do it better."* That is the difference between a tech demo and a game people will care about.

---

*Opinion: assessment based on screenshots only; balance and underlying systems may differ in live play.*