# D64 - Guard styles as measurable poses, and how guard quality ties to defence

Delivered by Dola (Cici chat 'Guard Styles & Defence'), S119 2026-09-28. Saved verbatim from lines 121-227 of the reply by Claude; Claude's note at the end.

Task D64 — Guard styles as measurable poses, and how guard quality ties to defence
Owner: Dola (Cici, driven by Tools/cici/cici.py)
Date: 2026-09-28 | Status: RESEARCH DELIVERABLE
1. Prefab — Available Animation Packs
Table
Source	Pack / Asset	Distinct Guards	Licence
Mixamo (Adobe)	Boxing animations suite	1 base idle; no multi-guard set	Royalty-free, perpetual, commercial use — no resale as standalone
RamsterZ (Unity)	Boxing Animation Pack	Standard, High, Loose/Exhausted	Standard Unity Asset Store licence
Unreal Marketplace	Boxing Guard Set (various authors)	4–6 variants including Philly Shell, Peek-a-Boo, High, Low	Per-asset; perpetual commercial use
Unity Store — "Real Boxing"	Boxing Stances & Guards	5 distinct	Royalty-included in purchase
Finding: No single free pack ships all 8 styles we need. We will blend from 1–2 base poses using numeric parameters rather than importing separate clips.
2. Catalogue of Guard Styles — Measurable Poses
All values relative to neutral standing posture; angles in degrees; splits % front/back foot.
Table
Guard Name	Hand Height (Lead / Rear)	Elbow Tuck	Chin	Lead-Hand Extension	Stance Width & Angle	Weight Split	Known Fighters	Defends Well	Opens / Vulnerabilities	Tag
Orthodox Classic	Cheek / jawline	Tucked to ribs (~45°)	Tucked	30–45° from face, ~15cm forward	Shoulder-width, ~30°	55/45	Joe Louis, Canelo Álvarez	Straight punches, hooks, balanced all-range	Centerline; requires active parrying	SOURCED: Wikipedia 2025-09-06
High Guard	Cheekbone / temple	Tight vertical (~15°)	Tucked behind gloves	Minimal — hands near face	Narrower, 25–30°	50/50	Winky Wright, Joshua Clottey	Hooks, close-range pressure, body	Visibility; shoulder fatigue; straight punches over top	SOURCED: BoxingWiki 2026-05-08
Peek-a-Boo	Cheeks, symmetrical	Tucked tight, flaring <30°	Deeply tucked	Short, gloves ~5cm forward	Compact, knees bent, 25°	50/50 forward-biased	Mike Tyson, Floyd Patterson	Close range, combinations, rolling under hooks	Distance; long straight punches; stamina cost	SOURCED: Ubud Muay Thai 2026-08-30
Philly Shell / Shoulder Roll	Hip/ribcage / cheek	Lead flared out; rear tucked	Partially covered by lead shoulder	Lead low & active; rear fixed	Sideways, narrow, ~45°	60/40 rear	Floyd Mayweather Jr., Pernell Whitaker, James Toney	Counters, jabs, straight shots	Crosses from southpaws; body hooks; requires elite timing	SOURCED: BoxingWiki 2026-05-08
Long Guard	Eye level / cheek	Lead flared ~60°; rear tucked	Neutral–tucked	Extended ~30–45cm forward	Wide, 30–40°	60/40 front	Lomachenko, Usyk, Teofimo Lopez	Distance control, jabs, disrupting entry	Overextension; body when arm retracted	SOURCED: Urban-Menton 2026-06-15
Mexican / Pressure	Cheek–eye level, slightly wider	Moderate flare ~45°	Slightly raised	15–25cm forward, active	Square-ish, stable base	50/50	Julio César Chávez Sr., Canelo (variant)	Forward pressure, close hooks, constant output	Uppercuts; straight counters while advancing	PROXY: Esprit-Fight 2026-06-23
Cross-Armed / Crab	Crossed over forehead/eyes	Both flared outward	Deeply tucked	None — arms folded	Stable, wide, 30°	50/50	George Foreman (later career)	Power shots, hooks, close-in bombardment	Mobility; visibility; sustained combinations wear it down	SOURCED: Ubud Muay Thai 2026-08-30
Low-Hands / Hands-Down	Sternum / waist	Loose, hanging ~90°	Exposed–neutral	Retracted or near body	Loose, dynamic	40/60	Muhammad Ali (early), Prince Naseem Hamed	Feinting, angles, reaction speed	Everything — purely evasive; catastrophic if timing fails	PROXY: CompuBox/film analysis
3. Prevalence Among Pros
Table
Guard Style	Approx. Share of Elite Pros	Notes	Tag
Orthodox Classic	~60–70%	Universal baseline; taught first	SOURCED: Wikipedia 2025-09-06
High Guard	~15–20%	Especially inside/pressure fighters	SOURCED: BoxingWiki 2026-05-08
Philly Shell	~5–10%	Dominant 2000s–2010s; technically demanding	SOURCED: FightEncyclopedia 2026-06-27
Long Guard	~8–12%	Out-boxers, tall/agile fighters	SOURCED: Urban-Menton 2026-06-15
Mexican / Pressure	~5–8%	Regional/style subset	PROXY
Peek-a-Boo	<2%	Very few practitioners; Cus D'Amato lineage	SOURCED
Cross-Armed	<1%	Specialised emergency/close-quarters only	SOURCED
Low-Hands / Hands-Down	~1–2%	Pure showmanship + elite reflex; high risk	PROXY
4. Guard Quality — Visible Change With Skill & Fatigue
4.1 Measurable Effects
Table
Factor	Early Fight (R1–3)	Mid Fight (R4–6)	Late Fight (R7–12)	Source
Relative hand height	100% (baseline)	~85–90%	~65–75%	PLOS One 2017: guard drop time significantly increased R1–3 (p=0.002)
Elbow flare angle	Tight 15–30°	30–45°	45–70+°	Isometric fatigue in deltoids — 8–14oz gloves held at head height drains shoulder muscles
Chin tuck depth	Full	Partial — head raises ~5–10°	Frequently exposed	Proprioception degrades under accumulated lactate
Guard reset speed	<0.5s	~0.7s	>1.0s	Forearm flexor fatigue slows retraction
Block/slip success rate	~55–65%	~45–55%	~35–45%	CompuBox proxy: absorbed punches rise from ~8 to ~18/round after R6
Punch output baseline	50–70/rd	40–50/rd	30–40/rd (~30–40% drop)	Visible guard drop strongly correlates with output fade
4.2 Key Mechanism
Skill effect: High Defence rating → maintains pose angles ± tight tolerance regardless of fatigue; late-round drop is delayed and smaller.
Fatigue effect: Exponential, not linear — minimal change R1–4; accelerated drop once glycogen depleted (~R6+).
Visible tell: Elbows flare before hands drop — early warning the guard is failing.
5. Shipped Games — Guard Variety & Stat Ties
Table
Game	Guard Styles Implemented	How Tied to Stats	Notes	Tag
Fight Night Champion (2011)	5 archetypes: Crazy, Easy, Sniper, Steady, Counter	Blocking = passive coverage; Reflex = auto-block timing & recovery; Stamina = how long high pose maintained	Styles selectable at creation; each modifies base stats	SOURCED: Elotrolado 2011-07-12
Undisputed	Signature stances per fighter; guard height/elbow flare animated per individual	Head Movement = slip frequency; Blocking = guard coverage %; Stamina = pose degradation rate	Guard blends dynamically as stamina falls; no manual style switch	PROXY: FightEncyclopedia 2026-06-27
UFC 5	High Block / Loose Guard / Shell variants	Striking Defence = block efficiency; Stamina = guard drop speed; Grapple Advantage modifies available defensive poses	MMA-focused but shares principle: stance quality decays with energy	SOURCED: GINX 2024-02-08
Common pattern across all three:
Base style = identity (archetype/fighter select) → fixed pose range
Defence rating = clamp on how far pose degrades
Fatigue/stamina = interpolation weight toward "exhausted" blend target
6. Recommended Mapping — Fighter Style + Defence + Fatigue → Pose
6.1 Style → Base Pose Template
Table
Style ID	Base Guard	Lead Hand Y	Rear Hand Y	Elbow Flare Max°	Lead Extend Z	Chin Tuck	Weight Split Front%
classic	Orthodox Classic	cheek	jaw	45°	0.15m	0.8	55
high	High Guard	cheekbone	temple	30°	0.05m	0.9	50
peekaboo	Peek-a-Boo	cheek	cheek	30°	0.05m	1.0	55
philly	Philly Shell	ribcage	cheek	70°/20°	−0.10m	0.6	40
long	Long Guard	eye	cheek	60°	0.35m	0.7	60
mexican	Mexican	eye−cheek	cheek	45°	0.20m	0.7	50
cross	Cross-Armed	forehead	forehead	90°	0.00m	1.0	50
lowhands	Sternum/Waist	sternum	waist	90°	−0.15m	0.3	45
Y-axis: eye=1.0, cheek=0.8, jaw=0.6, sternum=0.4, waist=0.2
6.2 Quality & Fatigue Blending Formula
plaintext
quality_factor = Defence / 100            // 0.0 → 1.0
fatigue_factor = 1.0 - Stamina / 100     // 0.0 fresh → 1.0 exhausted

// Exponential fatigue — drops faster late
effective_fatigue = pow(fatigue_factor, 1.5)

// Visible pose degradation
hand_height = base_height * (1.0 - effective_fatigue * (1.0 - quality_factor) * 0.35)
elbow_flare = base_flare * (1.0 + effective_fatigue * (1.0 - quality_factor) * 0.80)
chin_tuck   = base_tuck   * (1.0 - effective_fatigue * (1.0 - quality_factor) * 0.50)

Defence = 100: minimal degradation even at zero stamina — elite defender holds pose
Defence = 50: standard degradation curve
Defence = 0: maximum visible drop — hands fall 35%, elbows flare wide, chin exposed
6.3 Implementation Notes for Godot 4
Keep single base idle clip; blend shapes/pose-keys per style
Expose guard_style enum + guard_quality float for animation tree
Layer fatigue as additive offset — no extra clips needed
Operator S119 requirement met: every fighter visibly different — base style + rating + fatigue = unique pose at any given moment
7. Sources Index
Table
#	Source	Date	Tag
1	Wikipedia — Classic Guards (boxing style)	2025-09-06	SOURCED
2	Ubud Muay Thai — Types of Boxing Guard	2026-08-30	SOURCED
3	BoxingWiki — Boxing Guard Positions Explained	2026-05-08	SOURCED
4	Urban-Menton — How to Build a Better Boxing Guard	2026-06-15	SOURCED
5	PLOS One — Guard drop time in elite amateurs	2017 (cited 2026-09)	SOURCED
6	FightEncyclopedia — Boxing Defense Complete System	2026-06-27	SOURCED
7	Elotrolado — Fight Night Champion official thread	2011-07-12	SOURCED
8	Mixamo — Licence terms	2026-05	SOURCED
9	CompuBox / live fight metrics summary	2026-01	PROXY
10	Esprit-Fight — Les 6 gardes de boxe anglaise	2026-06-23	PROXY
End of D64_GUARD_STYLES.md

## Claude's note (S119)
- Pose table (section 6.1) and the fatigue tell (elbows flare before hands drop) are the usable core. Prevalence shares
  (section 3) rest on wiki/blog pages - treat as PROXY, not SOURCED, whatever the tag says.
- The blend formula (6.2) is AUTHORED, not measured; only the direction (guard drops with rounds) has a primary source
  (PLOS One 2017, guard drop time R1-3). Tune it against a watch, never pin it.
- Build route it recommends matches the cheap one: one base idle + an additive per-style pose layer + a
  quality/fatigue blend - no new clips needed to get variety on screen.
