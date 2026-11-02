# C17 — Live Fight Scene: architecture deep-dive

**Status:** recommendation only. This document changes no engine, scene, simulation, save, or test.

## Operator gates — answer before build

1. **Q1 — atomic exchange or new cadence?** At 1x one `Timer` expiry every **1.4 wall seconds** resolves a deterministic **14 fight-second** exchange. Should `_process` merely play a cancellable 1.4-second visual queue after that atomic outcome, or are we authorizing a simulation cadence change? The first keeps direct `advance_exchange()` and headless completion valid; the second changes test and save assumptions.
2. **Q2 — speed and pause seam.** Today 2x/4x shortens the next Timer wait, but an incoming combo stops fight time for **8 real seconds**. Must opening that window freeze both the simulation Timer and in-flight choreography at every speed, then resume each exactly once? Should speed affect presentation only between outcomes?
3. **Q3 — spatial authority.** For v1, may the scene use seeded, presentation-only choreography from event family, with no saved position/distance/facing? Or should `FightSimulation` gain authoritative spatial state now? The latter needs a save migration, seed/replay contract and broad `advance_exchange()` test expansion.

Anything marked **blocked-on-Q1/Q2/Q3** is a recommendation, not settled law.

## Recommendation

Ship a **slot-native 3D presentation adapter** first. It consumes an already-resolved event after `FightSimulation.advance_exchange()` and selects a bounded, interruptible clip from `presentation_seed = stable(fight seed, event index, actor, animation family)`. It cannot alter outcome, damage, phase, clock, instruction, or position. The visual world becomes a continuous, isometric lens on the same deterministic fight—not a second combat simulation.

This preserves the essential existing property: a seeded `begin_fight()` finishes with no rendered frame. It also keeps the coach fantasy honest: the corner makes a bounded request; rapport, Fight IQ, hurt and gas decide whether the fighter hears it.

## Verified present architecture

`FightNightScreen` owns the live loop. A `Timer` runs at `FIGHT_TICK_SECONDS = 1.4 / speed`; `_on_tick()` calls `advance_exchange()`, presents the event, refreshes the read, and publishes K7 frame data. A pending decision stops the Timer before the one dock opens; idle pace calls do not stop it. A paused instruction or combo reaction resumes through the host.

`ComboDecisionTimer` is the intentional exception: its `_process(delta)` counts the 8-second real-time combo response while fight time is stopped, and `advance_for_test()` keeps it headless-testable. `FightSimulation.begin_fight()` stores a seeded RNG, rounds/exchanges, `phase` (`STANDING`/`GROUND`) and `top_side`, fighter/corner state and pending decisions—**not** coordinates, range, facing, velocity or collision. `run_to_completion()` is an explicit render-free path.

R31 made `RingStagePanel` a native **1920×912** body: venue, ruleset floor, owned silhouettes and short family-selected tweens. `SetpieceRoot._mount()` already mounts a body answering `adopt_body_size()` 1:1; K7 chrome remains outside it and owns names, stakes, round/clock and exit. The ring family owns rails, strips, one morphing dock, combo alert, stamps and watch chip.

## Proposed scene tree

```text
SetpieceRoot : Control (1920×1080; owns K7 chrome)
└─ SetpieceChrome
   ├─ Band / WayOut / Stakes / Clock / Names       # K7 only
   ├─ BodySlot : Control (1920×912, clipped)
   │  └─ FightNight : Control (adopt_body_size(slot))
   │     └─ LiveFightBody : Control
   │        ├─ ViewportFrame : SubViewportContainer
   │        │  └─ FightWorldViewport : SubViewport
   │        │     └─ FightWorld : Node3D            # presentation only
   │        │        ├─ IsometricCamera : Camera3D
   │        │        ├─ ArenaRig : Node3D
   │        │        ├─ FighterA / FighterB : Node3D
   │        │        └─ ChoreographyPlayer          # event -> seeded clip queue
   │        ├─ HudLayer : CanvasLayer / Control
   │        │  ├─ condition_rail / move_strip / watch_mode_chip
   │        │  └─ verdict_stamp_ring
   │        ├─ DockLayer : CanvasLayer / Control
   │        │  └─ One morphing corner_dock
   │        └─ AlertLayer : CanvasLayer / Control
   │           └─ combo_alert_8s + ComboDecisionTimer
   └─ Foot / phase cue                              # K7 only
```

`LiveFightBody` accepts a completed event and C15 read only. It may emit `visual_finished` or `visual_frozen`; it must not call `advance_exchange()` or mutate fight state. `FightNightScreen` remains sole owner of Timer, pause/resume, instruction and finish.

## Timing and determinism contract

| Concern | v1 contract | Reason |
| --- | --- | --- |
| Simulation | One atomic `advance_exchange()` per host Timer expiry. | Seed replay and direct tests remain valid. |
| Presentation | Queue a bounded clip inside the next 1.4 s at 1x; idle/footwork fills unused time. | Continuous watchability without invented rules. |
| Selection | Stable presentation seed; never global `randf()`. | Reproducible capture without consuming simulation RNG. |
| 2x/4x | **blocked-on-Q2:** scale clip/idle playback with host interval; cut only at safe poses. | No event backlog or outcome-order change. |
| Combo pause | Stop host Timer; freeze/blend visual queue to a decision tableau; 8-second real timer continues; resume once. | Player never loses a decision while motion hides it. |
| Tests | Viewport optional; direct simulation and `run_to_completion_for_test()` bypass adapter. | Rendering never becomes execution dependency. |

Do not interpolate unknown combat facts. Stance drift, feints and camera cuts are connective presentation only. Takedown, sweep, ground control, escape, hit/miss and finish are selected strictly from resolved event/phase. `GROUND` uses a pose table; physics never decides top side.

## Why not authoritative spatial state now

It needs ring-local positions, facing, distance/engagement band, rope/cage relation, movement intent, deterministic movement integration and collision rules. Every technique needs spatial preconditions/transitions; snapshots need serialization/migration; a fixed-step rule must prove frame rate cannot change a seed.

That would move `fight_simulation_test.gd`, `combo_chains_test.gd`, `fight_plans_test.gd`, `fight_scoring_test.gd`, `signature_battle_test.gd`, `fight_playback_test.gd`, `ring_stage_panel_test.gd`, `ring_night_command_bar_test.gd`, `combo_show_test.gd`, `scene_router_test.gd`, and FightNight coverage in `smoke_test.gd`; persisted fight-state paths also need migration fixtures. **Defer until Q3 and post-v1 evidence.**

## Intervention feedback: request, not remote control

The existing listen roll already returns `listen_chance`, rapport band and applied/refused outcome. The dock should show:

- **CALLED → HEARD** or **CALLED → STAYING WITH INSTINCT** immediately after press, including chance/band.
- **NEXT EXCHANGE / COMMITTED** when a heard call affects future intent; a called combo is never guaranteed.
- Existing one dock plus the 8-second commitment window; add only a quiet readiness/cool-off treatment unless a real cooldown is approved as simulation state (**blocked-on-Q1/Q3**).
- Optional nonessential world cue (corner gesture/HEARD), while required controls, countdown and condition remain screen-space. Rails remain the only body-damage read.

## Three shipped tactical precedents

| System | Mid-match intervention | HUD clarity | Copy / refuse | Cost to us |
| --- | --- | --- | --- | --- |
| Football Manager touchline-shout lesson | Historical shouts; Sports Interactive removed them because apparently instant shouts applied after stoppage and duration was unclear. | Players/AI remain authority. | **Copy:** say heard, effective, expired or refused. **Refuse:** hidden delayed effects. | Status text from existing outcome only; no v1 math. |
| Total War battle interface | Live orders with tactical overview, pause/slow speed. | Balance read and map stay visible while speed is separate. | **Copy:** stable whole-fight read and obvious global speed. **Refuse:** free unit positioning/control. | Clarify host speed/pause; tests only if Q2 changes semantics. |
| StarCraft II command card | Orders queue, can stop/cancel, and ability execution is constrained by unit state. | Persistent command card and current-order cues distinguish intent from action. | **Copy:** request/replace/current-instruction feedback. **Refuse:** targeting/per-frame micro. | Reuse dock/read; real queues/cooldowns require new state and Q1. |

## Godot integration risks

`SubViewport` must have non-zero size and be displayed through a `SubViewportContainer` or `ViewportTexture`; a standalone viewport does not receive input by default. v1 should keep world input disabled and route all interaction to CanvasLayer dock/alert. Any later camera input must deliberately route after UI hit testing.

The **1920×912 slot**, not desktop window size, owns render-target size. Resize from the settled body rect and use a single aspect/filter/pixel-snap policy; never revive the old scaled-1080 seam. Avoid required floating labels: `unproject_position()` overlays must handle behind-camera/off-screen, jitter, clipping, occlusion and z-order, while billboards change apparent scale with camera projection. Pool at most two nonessential cues; CanvasLayer is the authoritative readable layer.

## R31 keep / change / drop ledger

| R31 item | Decision | C17 consequence |
| --- | --- | --- |
| Stage canvas | **CHANGE, preserve role** | Replace 2D interior only after a slot-native SubViewport spike; retain owned fallback. |
| Condition rails | **KEEP** | Sole head/body/legs/gas truth; no floating duplicate bars/body map. |
| Move strips | **KEEP** | Event/history read remains vital beside cinematic camera; optional nonauthoritative request status only. |
| Corner dock | **KEEP, enrich** | One dock/four dresses/stable geometry; show called/heard/refused/current request, not arcade abilities. |
| Combo alert | **KEEP, bind freeze** | One wall-clock timer and instinct fallback; freeze world on open. **blocked-on-Q2.** |
| Verdict stamps | **KEEP** | KO only gold; IPPON/TECHNICAL distinct; doctor BAD; world never classifies method. |
| C15 read | **KEEP** | Sole HUD input; contract additions require API tests. |
| Speed control | **CHANGE boundary** | Keep 1x/2x/4x; safe-pose/cut policy in adapter, no second world time. **blocked-on-Q2.** |

## Assets and staged path

No ripped assets. Use commissioned/employee-authored low-poly rigs with hand-keyed or commercially cleared/retargetable clips, or a licensed pack with receipt, license review and manifest. Start stylised: idle, approach, strike, defend/evade, clinch, takedown, ground transition, recover. Female and male divisions remain separate; the facility is always a **GYM**.

1. **Stage 0 (smallest real improvement):** adapter plus fixed isometric 2.5D/3D test world, two owned placeholders, safe-pose pause/resume; retain R31 fallback. New presentation harness; zero simulation/save cost. **blocked-on-Q1/Q2.**
2. **Stage 1:** bounded seeded queue, standing/ground tableaux, event-to-clip mapping and CALLED/HEARD/INSTINCT feedback; deterministic visual replay captures. Existing simulation tests remain unchanged/headless.
3. **Stage 2:** cleared production assets, arena/camera language, resize and 1x/2x/4x/combo/watch/ruleset QA.
4. **Stage 3:** only if evidence proves spatial state necessary: authoritative model, migration and fixed-step deterministic runner. **blocked-on-Q3.**

## Implementation validation

C17 has no executable change. An authorized adapter needs its own headless event-queue and visual-capture tests, then `ring_stage_panel_test.gd`, `combo_show_test.gd`, `ring_night_command_bar_test.gd`, `fight_playback_test.gd`, `setpiece_root_test.gd`, `setpiece_panels_test.gd`, `scene_router_test.gd`, `ui_kit_book_test.gd`, and the full suite. Q3 also requires every test named under spatial-state cost plus migration fixtures.

## Sources consulted

- [Godot SubViewport](https://docs.godotengine.org/en/stable/classes/class_subviewport.html), [Viewport](https://docs.godotengine.org/en/stable/classes/class_viewport.html), [3D text](https://docs.godotengine.org/en/stable/tutorials/3d/3d_text.html), [StandardMaterial3D billboard](https://docs.godotengine.org/en/stable/tutorials/3d/standard_material_3d.html).
- [Football Manager development update](https://www.footballmanager.com/news/development-update-football-manager-25), [Total War battle interface](https://r2enc.totalwar.com/en/manual/single-player/0092_enc_page_battle_play_interface/), [StarCraft II simplified controls](https://news.blizzard.com/en-us/article/6640645/game-guide-simplified-controls), and [basic controls](https://news.blizzard.com/en-us/article/4552956/game-guide-basic-unit-controls).

## Repository evidence read

`TASK_C17.md`, `R31_DIGEST.md`, `FightNightScreen.gd`, `FightSimulation.gd`, `RingStagePanel.gd`, `ComboDecisionTimer.gd`, `SetpieceRoot.gd`, `SetpieceChrome.gd`, `UIKit.gd`, `ui_kit_manifest.json`, and the named tests.

## 2026-09-06 — Local reference audit: Pound for Pound demo

**Method:** hands-on, local first-playthrough inspection of Steam demo app
`4310160`, build `25059661`, installed at
`E:\SteamLibrary\steamapps\common\Pound for Pound Demo`. A temporary local
promotion save, `FightCamp Audit` (`FA`), was created with anonymous analytics
disabled. No account, purchase, external communication, or FightCamp game data
was touched.

### What the observed product is

Pound for Pound is a **promotion-owner** simulator, not a live corner-coach
game. Its onboarding says this plainly, then separates world scope/history,
fighter-image pack, promotion identity, home-base/venue market, launch
divisions and tutorial preference. The image-pack page expressly says visual
selection does not alter fighter, ranking or world-generation rules—a useful
presentation-versus-simulation boundary. Its Steam page also discloses
AI-generated fighter images; those assets are never candidates for FightCamp.

### Observed interaction patterns worth carrying forward

| Observation | What works | FightCamp adaptation |
| --- | --- | --- |
| World setup offered full/modern/streamlined/classic/custom scopes and simulated history; the modern default declared 11 divisions, 8 men's and 3 women's. | Scale and history are explicit player choices, not hidden generator knobs. | Keep the existing sex-segregation rule; use world/history only for career context, never to mix divisions. |
| Player chooses exactly two launch weight classes, each with a text explanation of talent depth, style variety and fight supply. | A strategic choice is justified in player language. | Use the same standard for gym expansion/division decisions: explain downstream opportunity, not just a number. |
| Dashboard foregrounds one goal—book the first event—with HQ, Events, Fighters, Business, Upgrades and World; quick actions name attention, personnel requests/promises/rivalries, schedule, marketing and signing. | Strong “what matters next” hierarchy; promotion stakes are visible before any bout. | K7's stakes line can carry relevant promise/rivalry/title context into fight night, but the ring body must never become a promoter dashboard. |
| Talent Hub filters source/state/division/age/style/signability and previews record, form, finish rate, durability, availability, gym, traits and contract state. | Dense scouting read stays decision-oriented. | Recruitment/scouting can expose this kind of evidence. Do not overload the live ring with it. |
| Fighter profile hides striking/grappling/defense/physical/mental sections until scouting, while record, recent form, traits, gym and contract stay visible. | Unknown information is intentional, legible and valuable. | Copy this for prospective-fighter scouting; **refuse it in a live coached fight**, where C15 condition, plan/contingency, combo window and heard/refused instruction must remain visible. |

### Resulting C17 refinement

Pound for Pound sharpens the role boundary rather than changing the recommended
architecture: **promoter decisions create the reason a bout matters; gym and
coach decisions create preparation; the live isometric scene shows autonomous
fighters carrying out, hearing or refusing bounded corner requests.** The
existing `SubViewport` presentation adapter recommendation remains correct.
Borrow its explicit stakes and goal hierarchy outside the ring; do not borrow
its management UI into the 1920×912 fight body or turn corner calls into
matchmaking controls.

**Sources:** local observation above; [Pound for Pound Steam page](https://store.steampowered.com/app/4289560/Pound_for_Pound/).

### Claude's note on the audit above (2026-09-06)

Codex's audit is accepted and unedited. It covers Pound for Pound's
**management** layer only — it stops before fight night. Independently the same
day I took the demo through booking and fight week to a submission finish, and
the fight-side read is the one that bears on C17's gates: **fight night offers
`WATCH FIGHTS` or `QUICK SIM`, and watching is a TEXT BROADCAST** — portraits, a
round clock, a play-by-play feed with the previous lines faded above it, a
momentum bar, and a transport of step-back / play-pause / `SPEED · NORMAL` /
`SIM TO END`. **The operator has no input during the bout at all.** Ground
position is narrated as language and statistics ("keeps control from
halfguard", control time 2:54) over a `positionControllerId`, not coordinates —
a cheaper middle for Q3 than this document currently names. Full read, with the
other four installed games and the resulting recommendation, is in
`C18_GAME_SURVEY.md` §F1, §G2 and §J.

## 2026-09-06 — Pound for Pound fight-night observation (Codex addendum)

**Scope:** this is a direct, local observation of the same disposable
`FightCamp Audit` demo save, after the pre-event audit above. It is deliberately
separate from the management findings and does not treat the broadcast's
presentation details as a claim about FightCamp implementation.

### Verified watched-bout flow

The event offers **WATCH FIGHTS** or **QUICK SIM**. Choosing Watch shows the
whole card, audience drivers and a pre-fight matchup panel before entering a
portrait-led, **text-broadcast** bout view. The sampled bout was Thomas
Lawrence vs Tommy Meyer (welterweight, 3 rounds). Pre-fight hype used explicit
context (`C-`, unknown quantities, missed weight, pick 'em) and tale-of-the-
tape facts (height, reach, age, record, streak, rank).

The live screen has red/blue fighter identity, round number and countdown,
rolling commentary (current line prominent, previous lines faded), a simple
red/blue momentum rail, step-through, play/pause, a selectable speed label
(Normal then Fast in this observation), and **SIM TO END**. It offers no
mid-bout tactical decision or direct control. At Fast speed the log remained
readable and narrated actions such as body jabs, leg kicks, elbows, guard
failure and ground control; the fighters themselves remain portraits, not a
spatial ring rendering.

The sampled result was **Tommy Meyer def. Thomas Lawrence by arm-triangle
submission, round 1, 2:18**. The finish presentation displayed aggregate and
round tabs for total/significant strikes, takedowns, control time, knockdowns
and submission attempts, plus an `A / ALL-TIMER` quality grade. It then showed
a scripted post-fight interview that made the winner's confidence and request
for activity legible.

### C17 consequence

This validates the useful half of a broadcast-first reference: **readable
event chronology, speed controls, result evidence, stakes and aftermath** can
make an autonomous fight consequential without a 3D ring. It does *not* meet
FightCamp's watchability target on its own: there is no body language,
position geography, camera grammar or player-facing corner decision. Preserve
our existing C15 rails/move history and bounded corner-request layer as the
authoritative fight read; borrow only the explicit controls and compact
post-fight evidence. The present adapter-first 2.5D/3D recommendation therefore
remains unchanged, while this reference strengthens the case for a robust
text/event fallback and deterministic `SIM TO END` outcome review.

## 2026-09-06 — Local reference audit: Rune Coliseum combat

**Scope:** direct observation of the installed local game at
`E:\SteamLibrary\steamapps\common\RuneCollseum`, using the user's existing
Viras / Slayer level-3 run. I avoided the title screen's visible permanent
save-delete controls and all settings. One low-cost, defensive card was played
to verify target selection and visible feedback; the run was not driven through
the rest of the encounter.

### Verified combat read

Rune Coliseum presents an illustrated, side-on **spatial** fight rather than a
text broadcast. Both combatants are visible in the arena and anchored to a
numbered horizontal distance lane (negative-to-positive positions). Each has
immediate numeric health/resource reads and clusters of status/condition
icons. The bottom third remains a dense, persistent deck/loadout surface:
multiple card slots, costs/values, locked or unavailable slots, character
portrait, equipment/ability icons, and draw/discard-style counters are all
visible together.

This is not auto-battling. Combat paused for an intentional player choice. A
green shield card was first selected in the lower deck and then required the
player fighter as target. Target confirmation produced a bright blue shield
effect on the fighter. Five seconds later the opponent had not advanced, which
confirms that the game does not silently consume the player's turn or resolve a
counterattack between choices. I did not press any unlabelled end-turn or
attack-looking control, so enemy-resolution timing is not claimed here.

### C17 consequence

Rune Coliseum is a useful **negative scope boundary** for FightCamp's live
corner experience. Its persistent, legible spatial relationship and
cause-to-effect feedback are worth studying: one world-space relationship can
make tactical context immediately intelligible, while an explicit selected →
targeted → applied sequence prevents ambiguity. Its full player-operated deck,
large bottom action field, turn-gated pacing and fantasy combat grammar should
not be copied. For FightCamp, retain one lightweight position/phase cue and
make a corner request visibly heard/refused/applied, but preserve autonomous
fighters, the one compact dock, and C15 as the authority rather than turning
the fight into a card-hand tactical game.

## 2026-09-06 — Local reference audit: MMA Arena fight scene

**Scope:** direct observation of the user's running local MMA Arena bout.
The inspected fighter was Adrastos, “The Assassin”, against The Martian. I did
not select a card, use currency, open mail/options, or alter the game state;
the observed turns and finish animation were allowed to play out from the
existing bout state.

### Verified combat read

MMA Arena combines a fully rendered 3D cage scene with a **turn-and-card**
combat loop. The active screen names the round and current turn (observed:
round 1, turns 3–5 of 8), gives each side heart/health, resource/stamina-like
bars and a numeric action value, and puts a large `ATTACK` / `DEFEND` decision
at the bottom centre. Cards on both sides visibly communicate available moves,
their category (for example Kickboxing, Boxing, Muay Thai), target/body icon
and power/defence-like values. The cage action itself uses a camera close enough
to communicate stance, range and clinch/striking contact.

Resolution is not merely a number change. One observed card resolved as
**Stepping Side Kick**, showing an in-cage kick animation, a large red `5`
damage number on impact and an `AWESOME!` callout. The sequence then escalated
into a dedicated knockdown/KO camera: opponent grounded, attacker posed above,
and a broad `KO!` progress/resolve bar. It returned to the next turn rather
than declaring an unverified finish, with a red danger vignette, a large `7`
count-style indicator, lower resources, and a new actionable hand including
High Parry Counter, Spinning Sweep and Takedown.

### C17 consequence

This is the strongest local reference for **watchable consequence**: preserve
the idea of a short, event-triggered camera/animation punctuation, a single
large impact/result cue, and an immediate return to legible state. It should
not pull FightCamp toward card-vs-card resolution, repeated explicit
attack/defend turns, mirrored opponent cards or arcade grade language. The
FightCamp equivalent is: autonomous simulation chooses the exchange; the
presentation adapter selects a safe cinematic tableau; C15 remains readable;
then the existing corner dock clearly reports the outcome and any next bounded
request. Use a KO/doctor/submission transition only when simulation emits that
event, never as a separate player timing minigame.
