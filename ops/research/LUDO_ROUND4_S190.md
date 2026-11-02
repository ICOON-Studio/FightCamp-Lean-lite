# Ludo project "FightCamp" - Round 4: ONE core loop from all 20 propositions (S190, 2026-10-09)

Operator 2026-10-09 (S190, verbatim): "i want you to prioritize the ludo , if we need to redesign everything to match its ideas do it ,
continue with ludo on this session and then evaluate our work against ludos propositions" (DECISION_LEDGER D39 LUDO FIRST).
Asked in the project's Ask Ludo chat (https://app.ludo.ai/project/6ac93f6894905495ba8795db), text only, one request (credits 235 -> 234
shown). The prompt listed Ludo's 20 propositions from rounds 1-3 and asked for its own suggested next step: consolidate into ONE core loop
with A) camp week day by day, B) fight-night single screen under 10 s, C) gym screen layout, D) first-hour build order + cuts, E) merges.
Read with the browser text tool; "=" "&" "?" were masked by the tool's filter and are restored here.

## Ludo's answer, verbatim

Here is the consolidated, production-ready system specification for FightCamp.

E) Consolidation & Pruning: The Overlap Audit

To prevent mechanical bloat and keep the simulation razor-sharp, the 20 propositions are consolidated into 13 focused systems:

| Original Items | Decision | Consolidation / Pruning Rationale |
| :--- | :--- | :--- |
| (4) Pad-Work Chain & (7) Treadmill Lateral Budget & (6) Heavy Bag Dead Arms | MERGE | Avoid station micro-clutter. Stations simply feed the primary combat engine: Pads build reactive counters; Treadmill fuels movement budget; Heavy Bag builds power at the direct risk of Dead Arms (-Snap). |
| (3) Film Tells & (8) Spy Day & (17) Leaked Plan | MERGE | Integrated into Intel Warfare. Up to 3 Tells per opponent. If you don't vet/pay your camp sparring partners, they leak your 3 drilled tells to the opponent's corner. |
| (9) Cut-Prone Scar & (13) Neurological Mileage | MERGE | Unified under the Mileage Ledger. Physical damage creates local scars (cut-prone tissue); head damage burns hidden neurological reserves. |
| (10) Corner Eye Test & Stool Tone | MERGE | Integrated into the Stool Diagnostic. You read the pulse/pupil gauge first; that diagnostic dictates which of the 3 tones works without backfiring. |
| (18) Youth Academy & (19) Smoker Circuit & (15) Promoter's Trap | TIER/PHASE | Cut from First-Hour Demo. Keep the Promoter's Trap as the mid-game milestone; move Smoker Circuit and Youth Academy to the Campaign progression layer. |
| (16) Gym Hierarchy / Stable Dynamic | SIMPLIFY | In the core loop, this operates simply through Sparring Chemistry: pairing a prospect with a veteran grants passive composure or inflicts panic. |

A) The Camp Week: Day-by-Day Cadence (Mon–Sat)

A 6-day cycle leading to Saturday fight night. Each day has one mandatory decision, takes under 30 seconds of management, and drives transparent tradeoffs.

MON TUE WED THU FRI SAT
[ Tactical Drill ] [ Heavy Sparring ] [ Active Recovery ] [ Film & Polish ] [ Weigh-in Cut ] [ FIGHT NIGHT ]
Pads & Routes Lock / Sacrifice Stamina / Roster 3 Tells Loaded Roulette Gamble Corner Warfare

Monday — The Tactical Blueprint (Pad Work & Routes)
Player Action: Program the fighter's 3-step Pad Chain (Trigger → Evasion → Counter) and draw/assign the color-coded drill route on the gym floor.
The One Decision: Focus on a high-damage counter vs. an evasive defensive route.
Cost & Risk: Burns 35% weekly stamina. If drilled too aggressively, fighter starts Tuesday with an amber fatigue marker.
Tuesday — Hard Sparring & The Commitment ("Lock One, Sacrifice One")
Player Action: Run a 2-round test spar against a stylistic partner who mimics the opponent.
The One Decision: At round 2 end, you must permanently Lock one weapon (+15% speed/crit for that drill) and Sacrifice one defense (-10% guard against opponent's secondary weapon).
Cost & Risk: Incurs permanent mileage risk and potential minor facial swelling before fight night.
Wednesday — Active Recovery & Stable Balance
Player Action: Review floor stamina meters. Toggle between Hydro/Massage vs. Light Technical Shadowboxing. Manage paying gym members.
The One Decision: Rest your fighter completely to regenerate chin/snap, OR push light conditioning to balance the weight-cut trajectory.
Cost & Risk: Resting burns gym operational income (coach time devoted to non-paying athlete); training risks pushing weight into the amber danger zone.
Thursday — Film Study & Tell Bank Locking
Player Action: Open the opponent's tape library.
The One Decision: Spend 3 Coach Hours to lock up to 3 Tells (e.g., "Drops left on cross", "Gasses in R6", "Over-hooks when cornered").
Cost & Risk: Sacrifices final cutman preparation time; incomplete tape review leaves tells hidden, granting the opponent uncountered stat buffs.
Friday — Weight-Cut Roulette (The 24-Hour Scale)
Player Action: Weigh-in confrontation. Check scale margin vs. contracted limit.
The One Decision: Select cut method:
Safe Sweat: 0% miss risk, -5% overall stamina on fight night.
Sauna Push: 10% fail risk; entering with depleted chin gauge (-15% punch resistance).
Extreme Dehydration: Bully size advantage (+10% power), 30% miss risk (forfeits 20% purse), chin compromised (flashing red).
Cost & Risk: Fighter enters the bout compromised or pays heavy financial commission penalties.
Saturday — Fight Night
Execute preparation across the 3-minute rounds and 60-second corner breaks.

B) Fight Night: Round Simulation & The 60-Second Corner

A unified, readable interface split into Live Round Mode (3D) and Corner Stool Mode (60s) without jarring screen transitions.

```
+-----------------------------------------------------------------------------------------+
| [FIGHTER A HUD: HP | STAMINA] [RND 2 - 01:45] (1x/2x/4x) [OPPONENT HUD: HP | STAM] |
| Pulse: 142 bpm | Head/Body Status Tells Exposed: [1][2][ ] |
+-----------------------------------------------------------------------------------------+
| 3D RING VIEW (Tactical Camera: High Isometric) |
| [PAD PROMPT POPUP]: "SLIP & RIP" -> (FIRED) |
+-----------------------------------------------------------------------------------------+
| [SHOUT 1: "OFF ROPES"] [SHOUT 2: "INVEST BODY"] [SHOUT 3: "CLINCH"] | [TOWEL TRAY: DRAG] |
+-----------------------------------------------------------------------------------------+
```

Screen Layout During the 3-Minute Round
Top-Left (Your Fighter Banner): Head integrity gauge, Body integrity gauge, Stamina bar, Real-time Pulse (BPM + Color: Green/Amber/Red).
Top-Center: Round counter, Round timer, Simulation speed buttons (1x, 2x, 4x), Referee icon (with active trait badge: e.g., "Strict Stopper").
Top-Right (Opponent Banner): Visual damage indicators (bruising, cuts), exposed Tell icons (e.g., "Counters active on left jab").
Center (3D Canvas): Dynamic camera framing both fighters. Floating combat prompts appear over your fighter's head when a drilled pad-work chain executes (e.g., "SLIP & RIP — 92% MASTERY").
Bottom-Center (Corner Shouts Drawer): Three one-click shout triggers. Cooldown circle overlay. Success probability based on Ring IQ × Trust.
Bottom-Right: Red Towel Tray (click-and-drag to ring center to stop the bout instantly).

```
+-----------------------------------------------------------------------------------------+
| CORNER BREAK (00:48) REFEREE: M. Lane (Strict Stopper) |
+-----------------------------------------------------------------------------------------+
| [THE STOOL: EYE TEST] [CUTMAN TRIAGE: 2 AP] [TACTICAL ADJUSTMENT] |
| Pupil Tracking: WOBBLY [ (AP 1) ICE LEFT EYE ] Current Routine: |
| Heart Rate: 188 BPM (RED) Swelling: -30% Vis -> Cleared [Slip & Rip Hook v] |
| Fighter: "I can take him." [ (AP 2) ADRENALINE CUT ] |
| Cut Risk: Severe -> Stable Round 3 Objective: |
| SELECT TONE: (•) Circle Outside |
| [Cold General] [WAR CRY] [ RESTORE STAMINA (+8%) ] ( ) Inside Phone Booth |
| (Selected) (0 AP Remaining) ( ) Hunt the Cut |
+-----------------------------------------------------------------------------------------+
| [CONFIRM & DISPATCH] (Takes < 10 seconds to read and lock) |
+-----------------------------------------------------------------------------------------+
```

The 60-Second Stool Transition (Readable in Under 10 Seconds)

The bell sounds, camera smoothly tracks down to your fighter sitting on the stool, bringing up a 3-column tactical bottom drawer:

Left: The Stool Diagnostic & Tone (3 seconds to read):
Diagnostic Readout: Pupil status (Focused / Glazed / Darting) + Pulse Gauge (BPM).
Action: 3 buttons: [Cold General], [War Cry], [Older Brother]. Matching tone to diagnostic restores 10% composure; mismatch causes panic.
Center: Cutman Triage (2 AP System) (3 seconds to decide):
Displays 3 damaged zones with simple meters: Left Eye Swelling, Bleeding Gash, Body Exhaustion.
Player clicks two buttons to spend the 2 Action Points (e.g., AP 1 on Swab Cut, AP 2 on Ice Neck).
Right: Round Strategy Override (4 seconds to confirm):
Select primary Pad Chain emphasis for next round.
Set ring positioning: Outside Orbit, Center Ring, or Inside Trench.
Bottom Bar: Large green [CONFIRM & SEND OUT] button. Displays auto-countdown if the player does not click.

C) Gym Screen Layout (Top-Down Management View)

A continuous, lively 3D gym floor with transparent management overlays.

```
+-----------------------------------------------------------------------------------------+
| FIGHTCAMP GYM - Tier 1 | FUNDS: $4,250 | RENT DUE: 11 DAYS | WEEK 3/4 TO FIGHT NIGHT    |
+-----------------------------------------------------------------------------------------+
| [ROSTER DRAWER] |                                                     [WEEK CALENDAR]   |
| Prospects (2)   |                     [RING: SPARRING]                 Mon: Pads [OK]   |
| Members (6)     |                                                      Tue: Spar [OK]   |
| Staff: Cutman 1 |    [SPEED BAGS]                    [HEAVY BAGS]      Wed: Rest [!]    |
|                 |    (Blue Route)                    (Red Route)       Thu: Film        |
|                 |                                                      Fri: Weight      |
|                 |    [TREADMILLS]                    [PAD WORK CAGE]   Sat: Fight       |
|                 |    (Green Route)                   (Gold Route)                       |
+-----------------+-----------------------------------------------------+-----------------+
| ACTIVE FIGHTER: Leo "The Kid" Vance | WT: 156.4 lbs (Target: 154) | STAMINA: [======  ] |
| DRILL ROUTE: [Treadmill -> Pads -> Heavy Bag] | 1-SEC CONFIRM: [ADVANCE DAY (SPACE)]    |
+-----------------------------------------------------------------------------------------+
```

The 3D Gym Floor (Center Viewport):
Central Elevated Ring: Houses active sparring sessions.
Surrounding Stations: Speed bags (brick wall), Heavy leather bags (steel frame), Pad work clearance zone, Treadmill line, Conditioning mats.
Visual Polish: Non-fighter background gym members pay dues and train at idle stations.
Tactical Floor Routes: Semi-transparent colored vector lines drawn across the floor connecting stations (e.g., Gold line = Lead Fighter's sequence; dashed red line = Sparring Partner's sequence).
Top Header: Gym Name, Bankroll Balance ($), Rent Countdown, Current Date, Active Opponent Portrait.
Left Sidebar (The Roster Tray): Compact cards showing active fighters, morale icons, and assigned sparring partners.
Right Sidebar (Weekly Calendar & Assistant Engine): Vertical 6-day track. Displays completed days, today's focus, and amber flags if weight trajectory is missing checkpoints. Clickable [Skip to Fight Night] button (delegates days to Assistant Coach at 80% efficiency).
Bottom Action Bar: Active fighter stat summary, selected 3-station drill queue, and the primary [ADVANCE DAY] prompt (with 1-second long-press confirmation).

D) Build Order for the First-Hour Playable Demo

The goal of the first hour is teaching the loop: Diagnose Flaw → Drill Routine → Guide Corner → Face Repercussion.

```
[Phase 1: Core Setup]      [Phase 2: Tactical Loop]     [Phase 3: The Climax]
1. 3D Match Viewer   --->  4. Pad-Work Chain System ---> 8. Weight Cut Roulette
2. Stool Diagnostic        5. Gym Floor Top-Down         9. Doctor Stoppage
3. Cutman 2-AP Triage      6. Sparring "Lock/Sacrifice" 10. Promoter Trap Choice
                           7. Film Tells Bank
```

The Top 10 Mechanics to Build (In Sequence):
The 3D Match Viewer & Camera: Basic ring simulation rendering two boxers trading punches, knockdowns, and decision rounds.
The Stool Diagnostic (Pulse & 3 Tones): 60-second break UI with pupil/heart-rate read and the 3 tone options.
Cutman 2-AP Triage: Interactive cutman screen with eye swelling, cuts, and stamina restorer.
Pad-Work Chain System: The 3-step Trigger → Evasion → Counter protocol executing autonomously during the round.
Gym Floor Stations & Day Advance: Top-down gym view with 3 functioning stations (Pads, Heavy Bag, Treadmill) and day-skip execution.
Sparring Test ("Lock One, Sacrifice One"): Tuesday pre-fight sparring milestone forcing irreversible tactical tradeoffs.
Film Study Tell Bank: Pre-fight screen unlocking up to 3 opponent vulnerabilities.
Weight-Cut Roulette: Friday weigh-in screen with the 3 cut options and chin depletion penalties.
Doctor Stoppage & Towel System: Referee/doctor inspection sequence forcing towel or permanent scar risk.
The First Promoter's Trap Offer: Post-demo career fork (safe amateur tournament vs. dangerous television debut contract).
What to Cut Completely from the Demo:
The Smoker Circuit (Underground Bouts): Save for full campaign debt mechanics.
Youth Academy Pipeline: Keep scope restricted to 1 active fighter and 1 sparring partner.
Staff Poaching & Gym Espionage: Keep focus on mastering the coach-fighter dynamic before introducing betrayal systems.
Custom Gym Building / Facility Upgrades: Start with a fixed, hand-crafted garage gym. Focus strictly on sports strategy.

(Ludo's suggested next steps: "Can you map the first-hour demo into a playable Godot 4 implementation plan with scenes, scripts, and
milestones?" / "Can you create a labeled top-down gym screen mockup showing floor stations, color-coded drill routes, fighters, and UI
panels?" / "Can you design the fight-night single-screen UI mockup with round telemetry, mid-round shouts, corner actions, and readable
positions?")

---

## Round 4b - the two mock-ups Ludo suggested (generated images, no reference given)
- `previews/ludo_s190/01_gym_screen.png` - "labeled top-down gym screen": high 3/4 view of a brick gym, ring in the centre
  with two boxers sparring; heavy bags on the left wall, speed bags at the back, treadmills and mats on the right; FOUR colour-coded
  drill routes painted on the floor with arrows (gold outer loop, cyan inner loop, red loop through the treadmills, a blue loop);
  LEFT: a roster column of 5 fighter portraits with heart/morale icons; RIGHT: a "WEEKLY TRAINING" list (one row per day/session with a
  green/amber/red dot); TOP bar: GYM, FUNDS, rent, a title, play/pause controls; BOTTOM centre: the active fighter's portrait between two
  bars (stamina/strain); BOTTOM right: a big gold ADVANCE DAY button. (Generated text is garbled - read the layout, not the words.)
- `previews/ludo_s190/02_fight_night_screen.png` - "fight-night single screen": the ring from a high 3/4 angle with the crowd;
  TOP-LEFT our fighter's portrait + health bar + stamina + a green ECG pulse line under it; TOP-CENTRE "ROUND 4 | 01:42 | 1X 2X 4X";
  TOP-RIGHT the opponent's portrait + bars + a row of 5 tell icons; BOTTOM a row of 5 panels: MID-ROUND shouts (two big icon buttons
  "OFF ROPES", "CLINCH"), the stool / eye test (a pulse bar + TONE with three buttons), CUTMAN TRIAGE ("2 AP", SEAL, ICE SWELLING, CUT),
  ROUND STRATEGY (two round icons), and a big red THROW TOWEL tray at the bottom right.

## Round 4c - "Map your first-hour demo onto OUR existing Godot 4 build" (verbatim; prompt described GymHall3D lap, move cards
## 120/600, the camp screen, FightRealtime + corner, judges, week review, the 80% auto day)

Here is the 10-mechanic migration plan mapped onto your existing Godot 4 architecture, ordered by build milestone:

Milestone 1: The Ring Engine & Corner Overhaul (FightRealtime)

3D Match Viewer & Telemetry HUD
Status: CHANGE (FightRealtime / HUD Overlay)
What to change: Wire your existing health and stamina bars into a top-screen fixed anchor layout; add a real-time pulse rate label (BPM) and a color tint (green/amber/flashing red) driven by instantaneous stamina and head damage.
Acceptance Test: Player watches fighter take an overhand right; pulse spikes to 180+ BPM and turns red instantly on the top-left HUD.

The Stool Diagnostic (Pulse + 3 Tones)
Status: CHANGE (FightRealtime / Corner Sub-Viewport)
What to change: Replace your generic "What you say" dropdown with a 3-button selector (Cold General, War Cry, Older Brother) that explicitly checks the fighter's end-of-round state (Groggy, Panicked, Complacent) revealed by their pulse/pupil readout.
Acceptance Test: Choosing 'Cold General' on a red-lining, panicked fighter displays a floating "+10% Composure" tag, whereas picking 'War Cry' causes stamina burn.

Cutman 2-AP Triage
Status: CHANGE (FightRealtime / Corner Cutman Panel)
What to change: Replace single cut-man pick with a strict 2 Action Point (2 AP) bank per break; clicking Ice Swelling, Adrenaline Swab, or Chest Ice decrements 1 AP and immediately updates the corresponding damage gauge.
Acceptance Test: Player spends 2 AP on 'Adrenaline Swab' over the left eye, visibly dropping cut hemorrhage risk from Critical to Stable before Round 2 starts.

Pad-Work Chain Auto-Execution
Status: CHANGE (GymHall3D & FightRealtime Combat Hook)
What to change: Convert move cards drilled at the Pad station into 3-step reactive sequences (Trigger → Evasion → Counter); in FightRealtime, hook into the AI state machine to override normal attacks with this chain when the opponent triggers it.
Acceptance Test: When opponent throws a lead jab, your fighter slips outside and throws a liver hook, spawning an in-ring banner: '[PAD CHAIN: SLIP & RIP FIRED]'.

Milestone 2: Gym Floor & Camp Systems (GymHall3D & CampScreen)

Gym Floor Stations & Day Advance Integration
Status: KEEP AS IS
What to change: Retain your existing GymHall3D station lap, clock, stamina drain, and 80% auto-day execution; merely expose the active tactical path visually between stations.
Acceptance Test: Player hits spacebar to auto-resolve remaining day hours, and assistant coach completes the lap at 80% stat yield with an on-screen toast.

Sparring Test ("Lock One, Sacrifice One")
Status: CHANGE (GymHall3D / Sparring Ring Logic)
What to change: In Week 4 Tuesday ring sparring, interrupt after Round 2 with an irreversible modal forcing the player to pick one drilled move to gain +15% execution crit while permanently reducing defense against the opponent's signature by 10%.
Acceptance Test: Completing Tuesday sparring pops a mandatory choice screen; choosing 'Lock Lead Hook' pins a golden buff icon on the hook and an amber debuff on cross defense.

Film Study Tell Bank Locking
Status: CHANGE (CampScreen / Film Study Module)
What to change: Bind your 0–3 film study depth directly to revealing 1 to 3 opponent-specific Tells that display on the top-right fight HUD instead of acting as a generic hidden roll modifier.
Acceptance Test: Investing depth 2 in camp renders two explicit weakness icons on the opponent's fight-night HUD (e.g., 'Drops Left Hand').

Milestone 3: Stakes, Climax, and Career Hook

Weight-Cut Roulette
Status: NEW (Scene: res://scenes/ui/WeighInCutModal.tscn)
What to change: Insert a mandatory Friday weigh-in screen between camp week 4 and fight night offering 3 cut strategies (Safe Sweat, Sauna Push, Extreme Drain) that modify chin and stamina limits for the bout.
Acceptance Test: Selecting 'Sauna Push' shows fighter hitting contracted 154 lbs on the scale, but their fight-night chin meter starts capped at 85%.

Doctor Stoppage & Towel Intervention
Status: CHANGE (FightRealtime / Damage & Referee Arbiter)
What to change: When cut damage reaches maximum, trigger an in-ring referee sequence bringing in the doctor; player must either drag the towel to quit or push through at the cost of a permanent "Cut-Prone" scar trait added to the fighter's sheet.
Acceptance Test: Player declines the towel after doctor inspection; fighter finishes the bout and gains a permanent 'Cut-Prone Scar' trait visible on the week review screen.

The First Promoter's Trap Offer
Status: NEW (Scene: res://scenes/ui/PromoterContractOfferModal.tscn)
What to change: Fires at the end of the first-hour demo during week review; presents two contracts: a low-pay amateur trophy tournament vs. an unsanctioned $5,000 televised bout against a hard-hitting gatekeeper.
Acceptance Test: After winning fight 2, an interactive contract letter appears where signing the TV deal immediately deposits $5,000 but locks the next fight against an unranked slugger.

---

## Round 5 - Ludo rules on 7 conflicts with what we built (S190; operator the same session: "you communicate with ludo for design and
## mechanics he is your lead game and art designer assistant .i approve final verdicts")
Prompt: Ludo named LEAD GAME AND ART DESIGNER; rule KEEP OURS / REPLACE WITH YOURS / MERGE on: 1 corner time (our 45 s, 3 parallel lanes,
pace, mistake chance vs its 2 AP), 2 tones (calm/fire/truth vs Cold General/War Cry/Older Brother + state word), 3 mid-round shouts vs our
"corner only speaks between rounds", 4 tells (our TELL from the partner + EXIT from film, 20 s, +2% one round vs its 3 named tells on the
HUD), 5 camp (our 4 weeks, focus track, protocol, auto taper vs its Mon-Sat), 6 training days (our 10-hour lap every day vs one decision a
day), 7 demo scope (our expandable 3D club + several fighters vs its garage gym + 1 fighter + 1 partner).

### Ludo's answer, verbatim
Here are my official design rulings:

1) Corner Time
Ruling: MERGE
The Integration: Keep your 3 parallel crew lanes and 45-second clock as the overarching structure, but replace the arbitrary pace slider with my 2 AP economy per lane (6 total AP across cutman, second, chief). Spending 1 AP takes 15 seconds (Careful = 0% mistake); spending 2 AP takes 30 seconds; cramming a 3rd emergency AP takes 15 seconds (Rushed = 35% blunder risk). This preserves your authentic corner bustle while giving the player crisp, readable numbers to manage under time pressure.
2) Tones
Ruling: MERGE
The Integration: Rename the 3 tones to your cleaner, more natural language (Calm, Fire Him Up, Tell Him the Truth), but discard the flat "punch volume only" output. The tone must be tested against the fighter's displayed Heart-Rate Zone & State Word (Groggy / Panicked / Complacent): matching the right tone restores 10% composure and aligns fight-plan execution, while picking the wrong one (e.g., Fire Him Up on a red-zone, panicked kid) spikes BPM past 190 and induces sloppy brawling.
3) Mid-Round Shouts
Ruling: REPLACE WITH YOURS (Keep Corner Silent During Live Rounds)
The Integration: Honor your pure design rule: the corner stays silent during the 3-minute round. It reinforces our core creative pillar—you prepare the athlete, but once the bell rings, they are entirely on their own in the cage. Dropping live shouts eliminates HUD clutter and frantic APM clicking, making the 60-second stool break the sole, high-pressure window where the coach commands the fight.
4) Tells
Ruling: MERGE
The Integration: Keep your structural distinction between TELL (from mimic sparring partner) and EXIT (from film study), but replace your weak +2% single-round buff with my permanent, named tactical unlocks visible on the HUD (e.g., "Drops Left on Cross: +12% counter-window"). During the corner break, the chief second spends 15 seconds (1 AP) to activate one unlocked read, making it live for the remainder of the bout rather than an ephemeral single-round tax.
5) Camp Structure
Ruling: MERGE
The Integration: Weeks 1 through 3 run under your macro system (Focus Track, Protocol, Sparring Partner mimic, Scientific Recovery / Diet). Week 4 switches to my Monday–Saturday Fight Week cadence: Monday polishes the pad route, Tuesday executes the 2-round test spar triggering the irreversible Lock One / Sacrifice One commitment, Wednesday handles active recovery, Thursday finalizes film study, Friday runs the 24-hour Weight-Cut Roulette, and Saturday is Fight Night.
6) Training Days
Ruling: MERGE
The Integration: Keep your real-time 10-hour/2-minute station lap as the interactive core, but limit active manual play to Monday and Tuesday of each camp week to eliminate repetitive management fatigue. For Wednesday through Friday, the assistant coach auto-runs the lap at 80% efficiency unless the player explicitly toggles "Manual Control"—allowing players to bypass micro-management while still facing my "One Critical Decision" modal each morning.
7) Demo Scope
Ruling: REPLACE WITH MINE (Lock Gym Expansion in Hour 1)
The Integration: In Hour 1, the player operates exclusively in the starter garage gym with 1 amateur prospect and 1 contracted mimic sparring partner; all equipment store buttons and expansion doors are visibly chained with clear tooltips ("Unlocks at Pro License Tier"). Keep the visual background members training in locked ambient zones to show life, but constrain the player's mechanical inputs to coaching, corner triage, and survival stakes until Fight 2 is won.

(Ludo's next suggestions: a prioritized Godot 4 implementation backlog for the seven rulings; the exact first-hour timeline minute by
minute; a mock-up of the starter garage gym with playable stations, locked expansion areas and ambient members.)


---

## Round 6 - V7 hour-1 start vs our career start (S190, after D40) - Ludo's ruling, verbatim
Prompt: today the career opens on THE COACH HIRE (assistant with a tag), then THE INTERVIEW (pick one recruit from a scouting board, choose
his three move cards), then the first morning; Ludo's timeline starts with Leo and Sal in the garage. Rule on (a) coach hire (b) interview
(c) 3 move cards (d) where Sal comes from (e) is Leo fixed or generated.

(a) The Coach Hire
Ruling: REPLACE WITH MINE (Delayed)
The Integration: Cut the hire from minute 0. You begin with zero payroll and a solo player-coach identity; hiring an assistant (Pad Man, Conditioner, Film Man) unlocks at minute 37 as the tangible reward for banking your first purse ($350).
(b) The Recruit Interview
Ruling: MERGE
The Integration: Open on the scouting board, but restrict it to a curated 3-prospect shortlist where the lead candidate is always Leo Vance alongside two alternative archetypes (e.g., glass cannon, fast runner). This preserves your roster agency while ensuring a guided onboarding baseline.
(c) Choosing the 3 Move Cards
Ruling: KEEP YOURS
The Integration: Keep the 3 move cards selection during the recruit's onboarding intake, but lock the 3rd slot strictly to our 3-step Pad Chain (Trigger → Evasion → Counter) so the combat engine hooks properly from day one.
(d) Where Sal Comes From
Ruling: REPLACE WITH MINE (Contracted Veteran Sparring Partner)
The Integration: Sal is not on the fighter roster; he is contracted by default on day one as the gym's resident house sparring partner at a flat $50/week wage. He cannot be booked for fights, serving solely as the camp training dummy and mimic yardstick.
(e) Leo Vance: Fixed Character vs. Generated Profile
Ruling: FIXED HANDCRAFTED CHARACTER FOR THE FIRST RUN
The Integration: Leo Vance is a fixed, hand-crafted character for onboarding (19yo, 82 chin, 14 head movement, Orthodox) to guarantee balanced combat encounters across Bouts 1 and 2; subsequent career saves unlock a procedural archetype generator using his profile template.
