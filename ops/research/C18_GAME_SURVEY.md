# C18 — The wider game survey: what the fight should BE

**Complete.** Two parts by two authors.

**Part 1 (Codex, 2026-09-06)** is the wider market scan: a ranking caution, a
combat-management table, and five-item tables for auto-battlers, deckbuilders,
deckbuilding × auto-resolution hybrids and management games. It is entirely
**second-hand** — store pages, patch notes, press — and it says so. It was
written before `TASK_C18.md` existed, as an addendum inside
`C17_FIGHT_SCENE.md`, and was moved here verbatim; nothing in it was rewritten.

**Part 2 (Claude, 2026-09-06)** is the part the task was actually for, and it is
**first-hand**: five of the games installed on `E:` were launched and driven,
three shipped assemblies were read, and the survey ends where it was supposed
to — with a recommendation for what FightCamp's live fight should BE, the two
nearest alternatives it rejects, and a mapping onto C17's three deferred
operator gates. Part 2 frames those gates; it does not answer them.

The short version, if you read nothing else: **our nearest commercial neighbour,
Pound for Pound, ships its fight as a text broadcast with a playback transport
and no player input whatsoever** — and it is a promoter game, not a coach game.
The recommendation is a broadcast the corner can talk into: the model resolves,
the scene presents, and the only live surface is a small, priced hand of corner
calls that the fighter may refuse.


# Part 1 — the wider market scan (Codex, all second-hand)

## Addendum — wider market scan (2026-09-06)

### Method and caution

“Most successful” cannot be ranked rigorously across free-to-play, mobile and
premium games from public data alone. The lists below are **five high-impact
reference products per category**, selected for documented commercial/player
reach, persistence, genre influence and a clear transferable interaction
pattern. They are not a claim of a single universal revenue ranking. The useful
question for FightCamp is: *where does player agency happen, how is resolution
made legible, and what must a coaching game refuse?*

### Combat-management references

| Product | What its loop proves | C17 takeaway |
| --- | --- | --- |
| **Pound for Pound: MMA Promotion Simulator** | A current Early Access promotion sim: sign/manage fighters, negotiate and track contracts, form divisions, book cards/venues and schedule events in a procedural world where rival promotions contest talent and dates. Fighter relationships, demands and promises create long-term booking consequences; fights are watched through its simulation engine. | It is the strongest direct reference for the *promoter* layer: promises, star building, title lineage and rival competition should give bout stakes before the bell. FightCamp must keep that layer distinct from the **gym/coach** layer: the promoter books the consequence; the coach makes bounded in-fight requests. Its simulation is useful evidence for a watchable abstract fight, but it does not replace C17's active coaching objective. |
| **Elite MMA Manager** | Its current Showcase is a pre-release manager loop: sign clients, negotiate, balance training/recovery, game-plan, handle personalities/events and read live text fights. | Its strength is career causality and personality. FightCamp should keep that, but make live intervention visible and bounded rather than text-only. It is not a shipped-success benchmark yet. |
| **Tennis Elbow Manager** | It intentionally makes matches score/event based rather than playable tennis. The broader Tennis Manager series demonstrates game plans, 3D match view, coaching and post-match analysis. | A deep manager can work with abstract resolution, but FightCamp’s stated “watch and coach” promise justifies a visual event adapter—never player-controlled striking. |
| **Motorsport Manager** | Long-horizon staff/parts/sponsor/cash decisions culminate in real-time race calls; strategic information and race speed coexist. | Use race-day structure: pre-bout plan, legible live state, few high-value calls, and a post-bout explanation linking outcome back to preparation. Avoid turning the fight into pit-wall spreadsheet noise. |
| **MMA Arena** (installed locally) | Steam app **1047380**, installed on E:, is a 2019 turn-based fighting game built around acquiring/training hundreds of moves and assembling a custom fight deck. Local assets include move animations, training disciplines, equipment, fighter info, leagues/leaderboards, teams and arenas. | It proves moves can make fighter identity tangible. Its deck is pre-fight loadout/turn combat, not coaching. Borrow technique identity and readable move discovery; refuse turn-by-turn fighter puppeteering and its weak managerial ownership. |

### Five high-impact auto-battler references

| Game | Core agency before auto-resolution | Readability lesson for FightCamp |
| --- | --- | --- |
| **Teamfight Tactics** | Economy, drafting, formation, traits and items in a preparation window. | Give preparation and coaching a strong authored plan; the live view should explain why that plan is succeeding/failing. Do not copy grid placement. |
| **Hearthstone Battlegrounds** | Recruit/sell, board capacity, triples and hero powers before automatic combat. | Separate durable build choices from rare active moments; show a compact causal recap after resolution. |
| **Dota Auto Chess** | Synergy composition, shop odds, economy and formation create the original high-stakes preparation/resolution rhythm. | Use a readable “build → observe → adjust” cadence, not an endless stream of buttons. |
| **Dota Underlords** | Auto Chess readable through a polished spectator surface, speed controls and an explicit underlord layer. | The camera/HUD must make autonomous decisions intelligible; speed should not change the truth of resolution. |
| **Super Auto Pets** | Small teams, transparent triggers and low input pressure make auto-combat easy to parse. | Keep the rail/strip language concise: show a few decisive causes, not every hidden calculation. |

### Five high-impact deckbuilder references

| Game | What produces meaningful choice | FightCamp use / refusal |
| --- | --- | --- |
| **Slay the Spire** (and the exceptionally large 2026 sequel launch) | Tight deck thinning, future-risk choices and readable enemy intent. | Copy: limited, consequential options and explicit intent/read. Refuse: drawing a random command hand during a live bout. |
| **Balatro** | Simple base language plus explosive, understandable synergies and run-level adaptation. | Copy: technique/plan synergies stated in plain language; never hide a corner call’s probability. |
| **Marvel Snap** | Short commitment windows, reveal tension and location-dependent plans. | Copy: a visible commitment moment before resolution; the combo alert is exactly this sort of beat. Refuse: bluff-heavy PvP economy. |
| **Inscryption** | Strong presentation turns card rules into narrative stakes. | Copy: presentation should make a rule emotionally legible. Refuse: surprise-rule changes that obscure athletic causality. |
| **Monster Train** | Distinct faction identities and deliberately powerful combinations reward planning. | Copy: fighter style + camp + technique identity can create a coherent plan; balance it with opponent counters and listen/fatigue limits. |

### Five closest deckbuilding × auto-resolution hybrid references

This overlap is smaller than either parent genre. These are the most relevant
established references, not a false claim that every one is a top-five global
seller.

| Game | Hybrid mechanism | Specific FightCamp lesson |
| --- | --- | --- |
| **MMA Arena** | Build a fight deck, then resolve turn-based move contests. | Move collection must express style, but live coaching must not become card-play. |
| **Backpack Battles** | Shop/build and spatial inventory synergies, then asynchronous automatic fights. | Preparation can be deep while the fight remains watchable; show synergy cause, not all arithmetic. |
| **Backpack Brawl** | Item-build inventory auto-battler with tick-based combat. | A deterministic tick can be visually rich if each tick is explained by a few stable cues. |
| **Tales & Tactics / Storybook of Tactics** | Roguelite deck building creates an army that auto-battles. | A long-run meta layer belongs around the bout; the live screen needs only the current plan and its consequences. |
| **Storybook Brawl** | Card-based shop/build phase followed by auto-battle. | Keep roster/strategy construction separate from live spectator clarity; the player needs time to think *before* the dramatic resolution. |

### Five management-game references

| Game | Management strength | Direct rule for FightCamp |
| --- | --- | --- |
| **Football Manager** | Dense player/world simulation, plans and match-day observation. | Persistent athlete personality, staff and plans must matter live; feedback timing must be explicit. |
| **RimWorld** | Emergent stories from legible individual needs and cascading systems. | Traits/injuries/morale should create memorable career consequences, but FightCamp must surface the causal chain clearly. |
| **Factorio** | Transparent production constraints and immediately visible bottlenecks. | Make readiness, fatigue, damage and tactical mismatch observable; never make players hunt invisible variables. |
| **Cities: Skylines** | Strategic intent is judged by visible city-level outcomes over time. | Present the gym as a living system with a clean high-level read; avoid micromanaging every training action during a fight. |
| **Planet Zoo** | Cohesive management layers turn individual welfare into long-term performance and presentation. | Staff/facility/recovery decisions should visibly influence athlete readiness and career durability, not merely stats. |

### Synthesized design decisions

1. **Keep the three-layer loop:** long-horizon gym/career management → bout plan and opponent read → sparse, time-bounded live requests. No single layer should invalidate the others.
2. **Make causal feedback first-class:** after every meaningful event, identify the relevant event family, plan/condition fact, and whether the corner was heard. This is the auto-battler/deckbuilder “trigger log,” translated into sports broadcast language.
3. **Use commitment windows, not action spam:** the combo window is a good real-time beat. Add only a small number of similarly meaningful calls after simulation authority and player comprehension are proven.
4. **Let technique identity build over time, not in a live hand:** take MMA Arena’s technique discovery and deckbuilder synergy language for training/fight-plan construction; resolve it through athlete agency, fatigue and opponent contest.
5. **Treat a loss as explainable story, not bad RNG:** Motorsport Manager and Football Manager succeed because a result feeds the next management decision. Post-bout should name preparation, plan adherence, damage/energy and decisive exchanges.
6. **Keep promoter and coach roles deliberately separate:** Pound for Pound turns fighter promises, card placement, contracts and division history into pre-bout stakes. FightCamp should surface those stakes in K7's existing frame, but its live dock must remain a coach's limited request surface—not a promoter menu appearing during combat.

### Addendum sources

- [Elite MMA Manager Showcase](https://digital-realms-studio.itch.io/elite-mma-manager) and its [Steam news/gameplay overview](https://steamcommunity.com/app/4496420/allnews/).
- [Pound for Pound: MMA Promotion Simulator on Steam](https://store.steampowered.com/app/4289560/Pound_for_Pound/) — current Early Access scope, fighter promises/relationships, procedural promotion world and fight simulation.

### Local Pound for Pound demo audit (read-only)

The local demo is installed at `E:\SteamLibrary\steamapps\common\Pound for
Pound Demo` (Steam app `4310160`, build `25059661`, about 2.17 GB). It is a
Godot-packaged build (`mma.exe`, `mma.pck`, `fighters_p4p_base.pck` and
`fighters_legacy.pck`) and had never been launched on this machine at the time
of inspection. Package names and strings corroborate a large fighter-content
layer and explicitly describe semi-realistic “vector-realism” fighter sprites.
This must not be treated as a reusable FightCamp asset source: the Steam page
discloses AI-generated fighter images/marketing material, and C17's rule remains
that FightCamp ships only assets it owns or has commercially cleared.

The installed demo confirms Pound for Pound is most useful as a **promotion
management** comparator, not as a solved live-coach benchmark. A proper
interaction teardown would require an intentional first-run/playthrough, which
will create local save/settings data; it is not needed to establish the current
architecture recommendation.
- [Tennis Elbow Manager Steam page](https://store.steampowered.com/app/528110/Tennis_Elbow_Manager/), [Tennis Manager match-engine description](https://www.tennismanager.com/pc), and [Motorsport Manager Switch description](https://www.nintendo.com/en-gb/Games/Nintendo-Switch-download-software/Motorsport-Manager-for-Nintendo-Switch--1526161.html).
- [MMA Arena Steam page](https://store.steampowered.com/app/1047380/MMA_Arena/); local install evidence: `E:\SteamLibrary\steamapps\appmanifest_1047380.acf` and `E:\SteamLibrary\steamapps\common\MMA Arena`.
- [Backpack Battles publisher page](https://game.shochiku.co.jp/games/backpack-battles/), [Backpack Brawl combat explanation](https://rapidfire-games.helpshift.com/hc/en/4-backpack-brawl/faq/158-understanding-combat-auto-battle/), and [Storybook of Tactics Steam page](https://store.steampowered.com/app/2511340/Storybook_of_Tactics/).
- [Football Manager touchline-shout lesson](https://www.footballmanager.com/news/development-update-football-manager-25), [Total War battle interface](https://r2enc.totalwar.com/en/manual/single-player/0092_enc_page_battle_play_interface/), [StarCraft II controls](https://news.blizzard.com/en-us/article/6640645/game-guide-simplified-controls), and market context on the [Slay the Spire 2 launch](https://www.pcgamer.com/games/roguelike/analysts-say-slay-the-spire-2-best-performing-deckbuilder-of-all-time-and-the-competition-isnt-close/).

---

# Part 2 — first-hand reads (Claude, 2026-09-06)

Everything above this line is Codex's second-hand market scan. Everything below
was produced by opening the games and the game code on this machine. Each claim
carries its evidence grade:

- **PLAYED** — the game was launched and driven to the stated screen; the
  screenshots are in this session's scratchpad, not committed (they are other
  studios' art; the standing rule keeps ripped assets out of the repo).
- **CODE** — read out of the shipped assembly or data file. Primary evidence,
  but it names symbols, not behaviour: a constant called
  `REQUIRED_TICKS_IN_ROUND` proves a tick loop exists, not what it feels like.
- **INSTALLED, NOT RUN** — on disk, inspected only as files.

## F — The games already on this machine

### F1. Pound for Pound (demo, app 4310160) — PLAYED, full loop to a finish

The closest commercial comparator we have, and the read changes the picture:
**it is a promoter game, not a coach game.** Its own welcome text: an "MMA
promotion management sim where you build an organization from nothing into a
global brand."

New-save setup is five steps: world size (`MODERN CORE` = 11 divisions, men 8 /
women 3), a fighter-portrait art pack, promotion name and auto-generated
abbreviation, a home state that resolves to a city list with market grades and a
starting venue tier (Clubs and Theaters, 300–1,000 seats), and two launch weight
classes each carrying a modifier (`KO POWER 1.00x`). A slider sets **years of
simulated history** (default 3) and the world generates in the background while
you finish the wizard.

The shell is a weekly-pass management game with a left rail (Dashboard, HQ,
Events, Fighters, Business, Upgrades, World), a date, an `ADVANCE WEEK` button,
a currency pair, a `CURRENT GOAL` block, and a QUICK ACTIONS column whose rows
carry attention badges ("HQ — 1 needs attention", "Sign Fighter — roster thin,
355 free agents"). We already ship this shape; theirs is not better than R32.

Four things in the booking flow ARE better than anything we have:

1. **The contested-week calendar.** Picking an event week shows every rival
   promotion's card on that week, by name, with a prestige number and its
   marquee bout. Weeks are chipped `TOO SOON` / `CONTESTED WEEK`; gold weeks are
   premium, blue weeks are TV obligations. The date is a decision with named
   opposition, not a slot.
2. **Graded card craft with reasons.** Each bout carries a `FIGHT HYPE` letter
   grade and the reasons for it as chips — `TWO UNFAMILIAR NAMES`, `NOBODY HAS
   HEARD OF EITHER OF THEM`, `+ PICK 'EM FIGHT`. The card as a whole gets a
   `CARD CRAFT` grade with a one-line diagnosis (`THE MAIN CARD DRAGS`).
3. **Venue fill projection tied to the card you have actually booked.** Each
   venue shows a projected fill percentage and a verdict: "Moderate fill — card
   has room to grow", "Too large for your current card".
4. **`Smart Fill`** — one button that fills the legal, agreeable bouts, next to a
   `Matchmaking Board` for doing it by hand. The convenience is not the point;
   the point is that the game never makes you fill five slots to see a grade.

Fight week is a **seven-step ceremony**, not a screen: weigh-ins step through
the card, and a fighter missing weight raises a decision with four options and
their consequences spelled out — cover it yourself for 1 token (+relationship),
dock his purse (no cost, "Edward Johnson will resent it"), negotiate a
catchweight (fans and opponent lukewarm), or cancel the bout (both lose their
payday, the card weakens). The weigh-in board itself is good: `RISKY CUT` /
`TOUGH CUT` chips, `157.7 · +1.7 OVER` in red against `155.8 · ON WEIGHT` in
green, and the line "THE COMMISSION IS WAITING ON YOUR CALL".

**And then the fight itself.** Fight night offers exactly two buttons:
`WATCH FIGHTS` (gold) and `QUICK SIM`. Watching is a per-bout reveal sequence:
pre-fight hype grade and tale of the tape, a `Reveal` button, then the bout —
**and the bout is a text broadcast.** Two portraits, a round clock
(`ROUND 1 | 4:37`), one highlighted play-by-play line with the two previous
lines faded above it and an elapsed marker (`(6s)`), and a thin momentum bar.
No animation of the fighters at all. The transport is step-back, play/pause,
`SPEED · NORMAL`, `SIM TO END`, with `← → Step Through | Space Play/Pause`
printed under it. At NORMAL the broadcast runs roughly 1:1 with fight time
(4:37 → 3:41 across about 50 wall seconds).

The ground game is narrated in language, not drawn: "Dzhalilov tries scrambling
to his feet from halfguard but French keeps control." The finish came as
`SUBMISSION (ARM TRIANGLE) - ROUND 2, 1:08` over a `FIGHT STATISTICS` panel —
total strikes, significant strikes, takedowns, control time, knockdowns, sub
attempts.

**The operator has no input during the fight. None.** Every control on that bar
is a playback control. This is the single most important finding in the survey:
our nearest commercial neighbour ships the fight as a broadcast you watch, and
sells the game on everything around it.

### F2. KungFuCard (app 3340780) — PLAYED, one duel round resolved

Opens straight into a duel (tutorial opponent, a Wooden Dummy) with no story
gate: your fighter portrait and 30 HP bottom-left, the dummy and 5 HP top-right,
`Deck 42 Left` / `Discard Pile 0 Left`, and a hand of five cards. Cards carry a
cost pip and a type letter (P / L / F / E / DEF); some are **stances**
(`Offensive Stance`, `Defensive Stance`, `Feint Stance` — "Once per round,
discard one card, then draw a card") which sit in their own slot beside the
lane.

The loop is commit-then-resolve, not real time: select a card, a `Play` button
appears, the card moves into the centre lane facing the opponent's card with
both values showing (my 8 against its 5), you may keep playing, and `End Round`
— behind a full-width "Do you want to end the round?" confirm — resolves the
board, applies damage (dummy 5 → 2), clears the lane, refills the hand and hands
the turn over (`Opponent's Move`, with 攻 / 防 icons for its intent).

**The fight IS the card game.** There is no simulation underneath it to present:
the cards are the events. `CODE` corroborates the shape — `SetBattleCard`,
`IndexOfBattleCard`, `RetractBattleCard`, `AttachCardToCard`, `CoolDownCard`,
`AddCoolDownToCard`, `BattleGroupDamageRule`, `OnRoundStart` / `OnRoundEnd`,
`AllowFillHandCard`, `HandCardLimitAdd`, plus a counter-card layer named in
Chinese terms (`ShowPozhaoCard` 破招, `DrawJuezhaoToHand` 绝招).

### F3. 足球经理：自走棋 Demo — "Football Manager as auto-chess" (app 5029930) — PLAYED, into a live match

The most directly relevant game on the machine, and nobody had opened it. It is
a single-file Godot export (the folder's executable is misnamed
`Football Championship Megapack - Top-Down Pixel Art Sports Collection.exe`),
and it is in English.

Character creation is a **coach quiz** — nine steps of "What decides matches on
the pitch?" / "What should players do more actively on the pitch?" — and your
answers do not set a stat, they hand you **training programs** (`Dribble Cones ·
Technique+2`, `Passing Wall · Accuracy+2`) and **coach order cards** (`Order
Pass`, cost 1, "Order a pass").

Then the match, and this is the fusion in one screen:

- A top-down pixel pitch that **plays itself**, with a score, a running clock
  (`1st 11'`) and a `Team Morale` bar.
- `Home bonds` / `Away bonds` panels — `Iron Wall T4`, `Midfield Engine T3`,
  `Spear Tip T3`, `Village Super T4`. These are auto-chess **synergy tiers**,
  earned by squad composition, shown for both sides. Tabs beside them: Bonds /
  Energy / Missions.
- A `Match Feed` log filling with per-event lines — "1' Trainee 7 Tackle
  misses", "3' Trainee 1 Passes to Trainee 6", "11' 大厨 Holds the duel".
- A **coach hand** across the bottom (`Order Pass`, `Order Shot` — "Order the
  ball carrier to shoot") played by dragging a card onto the pitch, paid for out
  of a **`CP 12/12`** pool in the corner. The tutorial line is literally
  "Sideline Coach — Bottom is the coach hand: drag cards to issue".
- **Pitch Missions** — "Complete 1 coach-card shot(s) · Progress 0/1 · 893s left
  · Reward: Morale +8, Fans +0". The game pays you for intervening, and puts a
  clock on it.

The match does **not** pause for the coach hand. Play continues while you drag.

### F4. Punch Club 2: Fast Forward (demo, app 2362100) — PLAYED to the city map; the fight is story-gated

Launched, new game, and the demo opens on a long scripted intro: dialogue in the
gym, at home, in a shop, then an isometric city map with a quest marker over the
player's house and a location-entry flow ("Old House"). Roughly ten minutes of
clicking did not reach a fight — the demo gates the first bout behind story
beats. The management shell (iso city, timed locations, quest markers) is
first-hand; **the fight is not**, and is described from code in section G.

### F5. The King is Watching (app 2753900) — PLAYED, an existing save at Week 36

Worth the two minutes purely for its central verb. The left half of the screen
is a grid of buildings; a highlighted square is the **king's gaze**, and
buildings only produce while they are being watched. The right half is the
world. Speed controls sit top-right — pause, play, ×2, ×3 — and building/unit
cards line the bottom over a resource strip.

**Attention is the resource.** That is the mechanic our fight scene is reaching
for from the other end: we are asking what a coach can do while watching, and
this game answers "watching *is* the doing" by making the spotlight the only
production input. It is not a fight game and nothing transfers directly, but the
framing is the cleanest statement of the idea in the set.

### F6. Installed, not run

| Game | App | Why it stayed unopened |
|---|---|---|
| Master of Command | 2878450 | Unity, Napoleonic real-time battles with pause; relevant to the pause/speed seam, but nothing here that the Total War read in Part 1 does not already cover second-hand. |
| Football Manager 2020 | 1100600 | The genre's reference match engine. A useful first-hand read (touchline shouts, the 2D engine) but a long install-and-load for a point Part 1 already sources. |
| Your Football Life / Football Rising: Zero to Hero | 4327760 | Godot + GodotSteam build (`FootballRising.pck`). Player-career game rather than a coach game. |
| Corner King: Boxing Tycoon | 4259990 | Named on the operator's list; a boxing tycoon game, closest to our promoter-adjacent surfaces rather than the fight. |
| MMA Arena · MMA Empire · Rune Coliseum | 1047380 · 4201270 · 2360210 | Already have teardowns in `DesignLibrary/teardowns/`; not re-read. |

## G — What the code says about fights the demos would not show

### G1. Punch Club 2 — a tick loop with authoritative 2D space (CODE)

From `Punch Club 2 Fast Forward Demo_Data/Managed/Assembly-CSharp.dll`:

- **A tick model, explicitly:** `REQUIRED_TICKS_IN_ROUND`, `ticksInRound`,
  `fightTick`, `FightTickResultType`, `PAUSE_BETWEEN_TICKS`, `fightPhaseLength`,
  `tickAnimationEnded`.
- **Authoritative spatial state:** `DISTANCE_BETWEEN_FIGHTERS`,
  `MAX_DISTANCE_TO_LEFT` / `_RIGHT` / `_TOP` / `_BOT`, `DISTANCE_MULTIPLY`,
  `moveArea`, `movementState`, `FightActionMovementType`, `movementNotAllowed`.
  The fighters occupy a 2D area and the model owns the coordinates.
- **A resource economy per round:** `START_HEALTH`, `MAX_ENERGY`,
  `HP_RESTORED_BETWEEN_ROUNDS`, `ENERGY_RESTORED_BETWEEN_ROUNDS`,
  `MAX_HEALTH_MODIFICATOR_IN_BORDER`, `KNOCK_DAMAGE`.
- **Per-move damage fields** rather than one formula: `damagePunchHead`,
  `damageSideKickBody`, `damageSpinKickHead`, `damageUpperCut`, each with block
  and dodge counterparts, driven by `FightActionFormulaData` and
  `GetFormattedFormula`.
- **Live input during the fight:** `FightButtonOnClick`, `fightButtonBlockedSprite`,
  `usePreviewInFightStatsGUI`.

This is the design C17's Q3 describes as the expensive branch, shipped: own the
positions, and the fight becomes a tactical game with movement, distance and a
button you press.

### G2. Pound for Pound — simulate, then play the result back (CODE)

From `data_MMA_windows_x86_64/MMA.dll`: `SimulateAsync`,
`BenchmarkFightSimulationAsync`, `TickPerformanceData`, and then a separate
presentation layer — `GetPlaybackData`, `PlaybackSpeed`, `PopulateFeed`,
`ClearFeed`, `RenderFeed`, `IsBeatResolved`, `IsBeatTriggerAllowed`,
`DefaultMaxActionsPerRound`, `BuzzerBeaterSecondsIntoRound`. The fight model
carries pace as a distribution (`FightPaceSharedSigma`,
`FightPaceIndividualSigma`), scoring as data (`SetScoreData`, `JudgesDisagreed`,
`scoreDelta`), and outcome facts the feed narrates (`GetSigStrikesLanded`,
`takedownLanded`, `hurtFighterId`, `positionControllerId`, control time).

Note the last one: P4P **does** track who controls position — as a controller id
and a time, not as coordinates. That is the cheap middle of C17's Q3.

## H — The fusion read: what makes a deck plus an auto-battle feel like one game

Three of the games above resolve fights without the player's hands on the
fighter, and they hold together for the same three reasons.

1. **One economy, spent in one place.** The auto-chess football demo has exactly
   one in-match currency (`CP`), one place to spend it (the coach hand) and one
   effect class (an order to the ball carrier). KungFuCard has one (cards in
   hand). P4P has none at all during the bout. None of them run two live
   economies at once. The failure mode a fusion invites — a deck AND a stance
   AND a stamina bar AND a call — is avoided by every one of them.
2. **The preparation layer is where identity is built; the live layer only
   spends it.** Bonds tiers in the football demo are earned by squad
   composition before kickoff and merely *displayed* during the match. Stances
   in KungFuCard come out of the deck you built. Nothing meaningful is
   constructed during resolution.
3. **A causal feed carries the whole fight.** Every one of them narrates itself
   in a running log — P4P's play-by-play, the football demo's Match Feed,
   KungFuCard's value-on-value lane. The log is not decoration; it is the entire
   comprehension budget. When the fight is not under your hands, the feed is how
   you know why you are losing.

And one thing they all do that we should copy verbatim: **the game pays you for
intervening and tells you when.** The football demo's Pitch Missions put a
timer and a reward on using a coach card; P4P's weigh-in decision is a modal
that will not proceed until you rule. Live agency the game never asks for goes
unused.

## I — Recommendation: what the fight should BE

**A broadcast the corner can talk into.**

Concretely, the fight is a paced presentation of an already-resolved exchange
stream — P4P's spine — with exactly one interactive surface: the corner's
bounded request economy, the football demo's coach hand rebuilt as *asking*
rather than *ordering*, on K19's iso stage. Four commitments:

1. **The model resolves; the scene presents.** `advance_exchange()` stays
   authoritative and a seeded `begin_fight()` still finishes with no rendered
   frame. This is C17's adapter recommendation and the survey backs it: our
   nearest neighbour ships exactly this split, and the one game that does not
   (Punch Club 2) pays for it with a coordinate system.
2. **The operator controls the pace, not the fight.** Pause, speed and step are
   playback verbs, and P4P proves they are enough to make watching feel active.
   Ours is the same bar with one addition: the calls.
3. **Calls are a small hand against a visible pool.** One economy, one place,
   one effect class — a corner call, priced, spent from something the operator
   can see running out. Not a stance system and a call system and a plan system
   competing for the same seconds.
4. **A call is a request, and it can be refused.** K19 already named the states —
   HEARD / HALF-HEARD / WAVED OFF. This is the thing no game in the survey does,
   and it is the whole difference between a coach and a puppeteer.

The feed is not optional. Everything in section H says the running log is where
comprehension lives, and ours has an advantage none of them have: our events
already know their own causes (event family, plan, condition), so our feed can
say *why*, not just *what*.

### The two nearest alternatives, and why they lose

**Rejected 1 — Punch Club 2's live tactical fight.** Give `FightSimulation`
authoritative position, distance and facing; let the operator move and press a
button; the fight becomes a real-time tactical game with a management shell
around it. It is a proven design — it is shipping, twice — and it is the most
seductive answer to "the operator wants a live scene."

It loses on two counts. First, cost, exactly as C17's Q3 frames it: a save
migration, a seed/replay contract, and an `advance_exchange()` test matrix
several times wider, before a single frame is prettier. Second, and worse, it
deletes the premise. A coach who moves the fighter is not a coach. Every
FightCamp surface built so far — the plan, the corner, the listen roll, the
athlete with their own read — assumes the fighter is a person acting on
instructions they may or may not follow. Puppeteering them makes the gym, the
relationships and the whole preparation layer decorative.

**Rejected 2 — KungFuCard's card duel, or the auto-chess round, as the fight
itself.** Make the bout a hand: the fight IS the deck resolving, round by round,
and training builds the deck.

It loses because it makes the fight a second economy competing with the one we
already have. Our preparation layer is the game; a live hand would either
duplicate it (the deck is the fight plan, played twice) or overrule it (the
plan stops mattering because the hand decides). It also cannot express a
three-round bout with fatigue, damage carry and a doctor's stoppage without
growing into a different game. Cards belong in **preparation** — the fight plan,
the camp — where the fusion read says identity is supposed to be built.

Worth naming a third, further alternative for completeness: **results only**, the
`QUICK SIM` button. Rejected by the operator's own brief — the live scene is the
ask — but note that P4P ships it *beside* the broadcast, and we should too. Some
weeks nobody wants to watch the prelims.

## J — The recommendation against C17's three gates

The operator has deferred Q1, Q2 and Q3 deliberately. This section frames them
against what the survey found; it does not answer them.

| Gate | Which way the recommendation falls | What the survey does NOT settle |
|---|---|---|
| **Q1** — atomic exchange or a new cadence | **Atomic.** P4P resolves the bout first and plays it back with a transport; the only surveyed game that retimed its model into ticks (Punch Club 2) did so because it owns space, and paid for it. | Whether 14 fight-seconds is the right *presentation* granularity. P4P's feed lands a line every few fight seconds and reads as continuous; a 1.4 s clip per 14 fight-seconds may read as a slideshow. That is a playtest question, not a market question. |
| **Q2** — the speed / pause seam | **Speed and pause are presentation-only.** P4P ships exactly that (`SPEED · NORMAL`, `SIM TO END`, space to pause) and it never has to reconcile them with live input, because it has none. | Whether our 8 s combo window freezes the sim clock. The two live-input games split: the football demo keeps playing while the coach hand is open; P4P has no window at all. **Nobody in the survey ships both a real-time fight and a stopping input window**, so this is genuinely ours to decide. |
| **Q3** — spatial authority | **No authoritative spatial state in v1.** P4P narrates ground position as *language and statistics* — "keeps control from halfguard", control time 2:54 — with a `positionControllerId` behind it, not coordinates, and it reads convincingly. | Whether the feed stays honest without a small enumerated position/phase state. P4P clearly has one. The choice is not "coordinates vs nothing" — there is a cheap middle (a phase enum plus a control-time accumulator) the gate does not currently name. |

## K — What we already do better, and should not trade away

Modestly, and only where the comparison is first-hand:

- **The fight has a person on the other end of the instruction.** Nothing in the
  survey has a listen roll. P4P's fights cannot be influenced at all; the
  football demo's orders are obeyed. HEARD / HALF-HEARD / WAVED OFF is our
  mechanic and it is the reason our fight scene has a reason to exist.
- **Attention is already modelled as a scarce thing.** C16's attention read and
  R32's briefing hero make the week's demands compete for one slot. P4P's
  equivalent is an unranked QUICK ACTIONS list with badge counts.
- **The gym is a place with people in it.** P4P is promoter-side: its fighters
  are contracts, promises and rivalries seen from outside. Our coach-side
  framing is the differentiated position, not a smaller version of theirs.
- **The rules are rules.** Females never fight males and booking matches weight
  classes; P4P models divisions properly, but this is not a genre norm.
- **Our result language is disciplined.** K19's ruling — gold once per board,
  green only on the way out, doctor as BAD, IPPON/TECHNICAL ≠ KO — is stricter
  than P4P's grade soup (letter grades on bouts, cards, hype and craft at once).

### Things to take, named, so they are not lost

From P4P: the contested-week calendar with rivals' cards on it; graded booking
with the *reasons* as chips; venue fill projected against the card you actually
booked; the missed-weight decision with four named consequences; the
post-fight statistics panel; and the playback transport itself.

From the football auto-chess demo: one visible in-match pool (`CP`), a small
hand, and **missions that pay you for using it** on a timer.

From The King is Watching: attention as the production input — the thing you
watch is the thing that acts.
