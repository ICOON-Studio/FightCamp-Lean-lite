# J_FIGHT_ANIM_TECH_S431_BRIEF_JOHN - John answer (seat queue SQ41)

Brief: research/J_FIGHT_ANIM_TECH_S431_BRIEF.md
Sent: 2026-11-11 12:41 | collected: 2026-11-11 13:10 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

On it. I'm starting with EA's UFC and Fight Night developer talks, then Undisputed, Boxing Manager and the other manager games. Your computer is still offline, so my browsing goes over my own network.

I've started the research. Question 5 will include the actual capture hours the published motion-matching systems used. I'll paste the whole memo here as text when it's done.

# J_FIGHT_ANIM_TECH_S431: how the big fight games build fight animation
All sources checked 11 Nov 2026. (?) means I saw it only in a search snippet.

**Short answer to "is that how Boxing Manager / ESBC / UFC do it?"**
- **UFC 3–5:** partly. Since UFC 3, code works out where the fighter should go. The game then searches a motion database for the captured frame that best fits that path, jumping between short pieces of long takes. That's motion matching, which EA calls Real Player Motion Tech (RPM). It rests on about 5,000 animations captured as 30–40 second takes, not on about 100 clips.
- **Fight Night Round 4 and Champion:** physics drove the bodies, and punches retargeted to wherever the other boxer stood.
- **Undisputed (ESBC):** the studio has published nothing about its runtime animation system. Only the capture work and patch notes are public.
- **Boxing Manager (Steam, out 10 Nov 2026):** the developer has said nothing about how its 3D fights are animated.
- **Our plan:** code sets the feet and the distance, and clips play one at a time, with foot locking and IK on top. That's the code-driven half of what For Honor and Epic's sample project publish. The other half, picking the best frame from a big database, needs long purpose-shot takes, which we don't have.

## Q1. EA SPORTS UFC 3/4/5 and Fight Night Round 4/Champion

| Point | Detail | Label | Source (year) |
|---|---|---|---|
| What RPM is | A motion database. Code builds a path from the player's request, then finds captured motion that fits it. An event system adds timing limits, and "layered techniques" on top add pose variety | OFFICIAL (GDC talk page, Geoff Harrower, EA) | [GDC Vault: RPM Tech in UFC 3](https://gdcvault.com/play/1025228/Real-Player-Motion-Tech-in) (2018) |
| How RPM picks motion | Older EA games stitched 2–3 second loops. For UFC 3 they captured "unobstructed" 30–40 second takes moving in set shapes (diamonds and so on), and the system picks "the theoretical best frame". He says "there's no blending happening there", which is a marketing claim; motion matching normally blends a little | OFFICIAL (interview, producer Marc DeVellis) | [DualShockers interview](https://www.dualshockers.com/ufc-3-interview-marc-de-vellis/) (2017) |
| How many animations | UFC 3: "we've fully-revamped 5,000 animations" | OFFICIAL | same (2017); [PlayStation Blog](https://blog.playstation.com/archive/2018/01/30/how-ea-sports-ufc-3-overhauls-its-systems-for-a-truly-authentic-sporting-experience) (2018) |
| Punching while moving | In UFC 2, "every time you punched, your feet were firmly cemented to the ground". UFC 3 lets strikes combine with slips and lunges "while in motion" | OFFICIAL | same two (2017, 2018) |
| How punches sit on top of footwork | Only the talk abstract covers it ("layered techniques ... over top of RPM"). The full talk is paywalled, so I couldn't see how the upper and lower body are split | OFFICIAL (abstract only) | GDC link above (2018) |
| UFC 4 | RPM extended from movement and striking to the clinch and takedowns, which now depend on context such as timing and stamina | OFFICIAL (interview, Brian Hayes) | [GameSpot](https://www.gamespot.com/articles/ea-sports-ufc-4-dev-on-the-biggest-gameplay-change/1100-6480126/) (2020) |
| UFC 4 responsiveness | Strikes start 1–2 frames sooner after the button press | OFFICIAL (Hayes, quoted by press) | [Den of Geek](https://www.denofgeek.com/games/ufc-4-gameplay-changes-updates/) (2020) |
| UFC 2 hit reactions and KOs | UFC 1 used canned KO animations, which repeated. Fight Night 2004's full ragdoll looked "like a marionette had his strings cut". UFC 2's KOs use physics simulating "a semi-conscious person trying to maintain their balance", driven by strike direction and momentum | OFFICIAL (Hayes interview) | [MMA Fighting](https://www.mmafighting.com/2015/11/13/9724426/one-on-one-with-brian-hayes-creative-director-of-ea-sports-ufc-2) (2015) |
| UFC 5 (Frostbite engine) | Damage across 8 body regions × 5 levels, with "64,000 possible facial damage combinations". New hit reactions mixing animation and physics, a slow-motion KO replay, and a doctor-check camera. How the reactions are built isn't public | OFFICIAL (EA press release) | [EA press release](https://news.ea.com/press-releases/press-releases-details/2023/EA-SPORTS-UFC-5-Arrives-October-27-Feel-the-Fight-With-Visceral-Gameplay-and-Graphics-Powered-by-Frostbite/default.aspx) (2023); [UFC 5 presentation](https://www.ea.com/games/ufc/ufc-5/news/ufc-5-presentation) (2023) |
| EA engine ragdolls | Ragdolls that follow animation and react to hits, adding variety "without animators [needing] to increase animation coverage". The talk covers EA sports games but doesn't name UFC | OFFICIAL (GDC abstract, Jalpesh Sachania) | [GDC Vault](https://www.gdcvault.com/play/1025210/Motion-Matching-The-Future-of) (2018) |
| Fight Night Round 4: physics | Full-body collision, so arms stop passing through bodies. Punch effect comes from speed, direction, contact and angle. Physics runs at 120 fps; the game at 60 | OFFICIAL (Hayes interview) | [GameSpot](https://www.gamespot.com/articles/fight-night-round-4-the-physics-of-fighting/1100-6233939/) (2009) |
| Fight Night Round 4: punch steering | "the way punches retarget based on boxer proximity". As a side effect, tall boxers became weaker on the inside without any rule saying so | OFFICIAL | same (2009) |
| Fight Night Champion | "fundamentally the same as the physics engine we introduced in Fight Night Round 4, with 18 more months" | OFFICIAL (Hayes interview) | [GamingBolt](https://gamingbolt.com/fight-night-champion-an-exclusive-interview-with-brian-hayes-lead-gameplay-designer) (2010) |
| Players on punch homing | One forum poster says UFC 4's hooks "tend to be less auto homing" than UFC 3's; another disagrees | OPINION | [Operation Sports forum](https://forums.operationsports.com/forums/forum/combat-sports/ea-sports-ufc/898630-geoff-breaks-down-and-explains-real-player-motion-tech-in-ufc-3-gdc-2018) (2020) |

## Q2. Undisputed (formerly eSports Boxing Club), Steel City Interactive

| Point | Detail | Label | Source (year) |
|---|---|---|---|
| Who was captured | "As many fighters as possible" in mocap suits for footwork, punches, slips, dodges and taunts. Dalton Smith (British and Commonwealth super-lightweight champion) spent "a few days" being captured and also imitated boxers who have died. Fighters' looks come from body scans | OFFICIAL (studio blog, CEO Ash Habib) | [PlayStation Blog](https://blog.playstation.com/2024/10/02/undisputed-launches-oct-11-how-body-scans-deliver-boxing-authenticity/) (2024) |
| Stand-ins | When a famous boxer couldn't do the capture, a boxer who copied their style did it. Roy Jones Jr came to Sheffield and did his own | OFFICIAL (Habib, quoted) | [PC Gamer](https://www.pcgamer.com/undisputed-boxing-game-interview-GDC/) (2023) |
| How many punches | "More than 60" punch variations, with modifiers for power, body, stepping and pivoting. Real reach is kept, which Habib calls "a huge pain" for animators | REPORTED (from Habib) | same (2023) |
| Capture studio | A Vicon partnership; the page wouldn't open | REPORTED (?) | [Trusted Reviews](https://test2.trustedreviews.com/news/esports-boxing-club-will-set-the-standard-for-combat-games-4039844) (?) |
| Footwork design | A boxer has to finish shifting weight after a step forward before stepping back. Punches thrown while moving are weaker than ones off a planted front foot. Tiredness slows punches | REPORTED (from Habib) | PC Gamer (2023) |
| "Loose movement" | A separate movement mode that's faster but leaves the boxer more open. Each boxer has their own loose idle animation; one patch fixed Calzaghe's, which "slightly floats off the canvas" | REPORTED + OFFICIAL (patch notes) | [Game Rant](https://gamerant.com/undisputed-beginner-tips/) (2025); [patch notes, 5 Jul](https://playundisputed.com/news/update-notes-05july2023) (2023) |
| Tired movement set | Below 40% max stamina, the normal movement set is swapped for a "Flat Footed" set and loose movement is locked | OFFICIAL (patch notes) | [patch notes](https://playundisputed.com/news/career-mode-and-character-creator) (2024) |
| Punch aim | A patch fixed close hooks whose "targeting zones" were "aiming too high", so punches aim at a zone per punch. How they're steered isn't disclosed | OFFICIAL | 5 Jul patch notes (2023) |
| Animation bugs fixed | Opponents "would sometimes lock up instead of stumbling, causing the opponent to appear to slide". Also a lunge that didn't move the boxer and drifting after a flash KO | OFFICIAL | patch notes (2023, 2024) |
| Runtime animation system | Nothing public on motion matching, IK or how hit reactions work | no source found | — |
| Critics on animation | IGN gave it 6/10: knockdown and get-up animations "are identical each time", and "the fluidity of its gameplay animations ... don't come close" to Fight Night. Cameras and cornermen block the view | REPORTED (review by Andrew Mcmahon) | [IGN review](https://za.ign.com/undisputed-1/201764/review/undisputed-review) (Oct 2024) |
| Critics on footwork | Footwork "LOOKS nice" but feels unresponsive, with no small adjustments. Boxers spin to face each other "and there isnt even an animation" | OPINION (Reddit) | [r/undisputedboxing](https://www.reddit.com/r/undisputedboxing/comments/141wreg/footwork_is_bad_and_the_animations_have_you_fooled/) (Jun 2023) |
| Early access | Some Steam reviews said "the movement feels unnatural"; the PC Gamer writer felt the heavy feel matched real boxing | REPORTED | PC Gamer (Apr 2023) |

## Q3. Boxing Manager (Steam, by Sport and Financial)

| Point | Detail | Label | Source (year) |
|---|---|---|---|
| What it is | Out 10 Nov 2026 on PC and macOS. The developer has "taken our world-leading blow-by-blow fight simulation and added a fully customised 3D fight and fighter model" | OFFICIAL (Steam page) | [Steam: Boxing Manager](https://store.steampowered.com/app/1605370) (2026) |
| Earlier plan | In Aug 2024 they were trying both 2D and 3D fight views and preferred 3D, built in Unity | OFFICIAL (dev FAQ) | [r/BoxingManager](https://www.reddit.com/r/BoxingManager/comments/1eljb7f/boxing_manager_ios_update/) (2024) |
| 2026 fight engine | A "brand new fight engine (our first in over a decade)" with two views, Ring and Classic. An earlier patch dropped announcer intro cards so "fights start straight away", added a judges tab, and added a button to record a fight as video | OFFICIAL (dev forum) | [26.2.0 notes](https://community.theboxingmanagergame.com/t/26-2-0-boxing-manager-update/4246) (Aug 2026); [26.1.4 notes](https://community.theboxingmanagergame.com/t/26-1-4-ringside-update/4240) (Jul 2026) |
| How the 3D is animated, how many clips | Nothing on the Steam page, the developer's site or their forum | no source found | [Boxing Manager site](https://theboxingmanagergame.com) (2026) |
| Reviews | 4 Steam reviews on day one, 3 positive. The negative one says "nobody wanted 3d animations that look stupid". No press reviews yet | OPINION | [Steam reviews](https://steamcommunity.com/app/1605370/reviews/) (10 Nov 2026) |
| The older Boxing Manager (2007, a different game) | "Realistic 3D bouts and faithful, motion-captured animations", with rounds shortened to one minute each and orders given between rounds | OFFICIAL (developer Q&A) | [Worthplaying Q&A](https://worthplaying.com/article/2006/12/16/interviews/38503-boxing-manager-developer-qa/) (2006) |

## Q4. Manager games with a small animation budget

| Game | What it does | Why it works or doesn't | Label | Source (year) |
|---|---|---|---|---|
| Football Manager 26 | Dynamic highlights: "the more important and more dramatic a game, the more highlights". Data cards and a 2D view fill the gaps; broadcast mode cuts between cameras; the replay angle depends on the kind of goal | It shows fewer, better moments | OFFICIAL (developer blog) | [FM26 match day](https://www.footballmanager.com/fm26/features/where-storytelling-evolves-fm26s-match-day-experience) (2025) |
| Football Manager 24/26 | FM24 added motion matching and IK built on real match tracking data, mostly for off-ball movement. FM26 adds "hundreds" of on-ball animations blended by context | Even FM now leans on large data sets | OFFICIAL | [FM motion matching](https://www.footballmanager.com/features/truer-football-motion-match-authenticity-positional-play) (2023) |
| Boxing Manager (2007) | One-minute rounds, with tactics set between rounds | Less screen time to fill | OFFICIAL | Worthplaying (2006) |
| World Championship Boxing Manager 2 | Hand-drawn 2D sprites with "fight cams" and a "cinematic Fight Camera"; strategy picked between rounds | The camera makes a small art set readable | OFFICIAL (Steam page) | [Steam: WCBM2](https://store.steampowered.com/app/1903970/World_Championship_Boxing_Manager_2/) (2023) |
| WCBM2 reviews | The boxers "just stand in middle of the ring and trade punches"; a KO is just an empty health bar with "no count". Rated Mixed, 67% of 90 reviews | No ring movement and no knockdown moment reads as shallow | OPINION | [Steam reviews](https://steamcommunity.com/app/1903970/reviews/) (2023–24) |
| MMA Team Manager | A "3D fight engine ... with up to 100 motion captured animations"; 3D can be turned off on slow PCs | The same clip budget as ours | OFFICIAL (Steam page) | [Steam: MMA Team Manager](https://store.steampowered.com/app/914180/MMA_Team_Manager/) (2019) |
| MMA Team Manager reviews | "3D model bad and weird"; players asked to see knockouts and submissions. Rated Mostly Negative, 33% of 56 reviews | With 100 clips and no finishing moments, the big moments are missing | OPINION | [Steam reviews](https://steamcommunity.com/app/914180/reviews/) (2018–21) |
| The Fight Business (MMA, not out yet) | Promises "smoother transitions, improved fighter reactions" during early access | Transitions and hit reactions are the known weak spots | OFFICIAL (Steam page) | [Steam: The Fight Business](https://store.steampowered.com/app/5457790/) (2026) |
| UFC 5 and Undisputed | Slow-motion KO replay in UFC 5; an instant replay of knockdowns in Undisputed | The deciding moment gets shown twice | OFFICIAL | EA (2023); Undisputed patch notes (2023) |

## Q5. What a small team with about 100 clips can and can't do

| Technique | Published use and data needed | Within reach? | Label | Source (year) |
|---|---|---|---|---|
| Code drives position; the animation sits on top | In For Honor, code sets the path and the character's centre stays within 15 cm of it. "The goal is not to be as responsive as possible, the goal is to be as predictable as possible" | Yes; this is our plan | OFFICIAL (GDC 2016 talk by Simon Clavet, via a write-up) | [Game Anim write-up](https://www.gameanim.com/2016/05/03/motion-matching-ubisofts-honor/) (2016) |
| Foot locking | Pins the toe to the ground at runtime, because "switching animations rapidly always causes foot-sliding". Ubisoft also adds foot locking plus IK as the last polish step | Yes | OFFICIAL | same (2016); [Ubisoft La Forge LMM](https://www.ubisoft.com/en-us/studio/laforge/news/6xXL85Q3bF2vEj76xmnmIu/introducing-learned-motion-matching) (2020) |
| Slide with foot IK instead of speeding clips up | Clavet's limit: never play a clip more than 10% faster or 20% slower. Slide the body instead and let the foot IK hide it | Yes | OFFICIAL | Game Anim (2016) |
| Pose limits | Lowering the hips "must never break the pose or hyper-extend the knees"; only small corrections toward the target | Yes | OFFICIAL | Game Anim (2016) |
| Hands steered to the target (IK) | Fight Night Round 4 retargets punches by distance; Undisputed uses target zones per punch. Godot 4.6 brought back IK nodes (two-bone, FABRIK, CCD) and a node that limits sudden swings | Yes, Godot 4.6+ has it built in | OFFICIAL | GameSpot (2009); [Godot: IK returns in 4.6](https://godotengine.org/article/inverse-kinematics-returns-to-godot-4-6/) (2025) |
| Short blends when a clip starts (inertialization) | Fades out the pose difference between the old and new clip instead of playing both (Gears of War, GDC 2018). Godot has cross-fades built in, but inertialization only in third-party add-ons | Cross-fade: yes. Inertialization: with custom code | OFFICIAL / no source found for Godot core | [GDC: Inertialization](https://www.gdcvault.com/play/1025331/Inertialization-High-Performance-Animation-Transitions) (2018); [godot-motion-matching add-on](https://github.com/GuilhermeGSousa/godot-motion-matching) (?) |
| Stride and orientation warping, distance matching | Stride warping fits step length to the actual speed; orientation warping turns the hips toward the direction of travel, covering directions "where no animation data is present". Distance matching plays a clip by distance moved rather than by time | Yes, custom in Godot; the ideas are simple | OFFICIAL (Epic docs) | [Pose warping](https://dev.epicgames.com/documentation/en-us/unreal-engine/pose-warping-in-unreal-engine); [Distance matching](https://dev.epicgames.com/documentation/en-us/unreal-engine/distance-matching-in-unreal-engine) (2024–26) |
| Body allowed to drift from the code position | In Epic's sample the mesh may stray from the code position "within a fixed radius" on starts and turns, then blends back | Yes | OFFICIAL | [Game Animation Sample docs](https://dev.epicgames.com/documentation/en-us/unreal-engine/game-animation-sample-project-in-unreal-engine) (2024) |
| Movement from very few key poses | Overgrowth made "interactive and fluid animations using very few key frames" with springs, IK and physics. A "13 keyframes" figure appeared only in a snippet | Yes, for the idle, breathing, guard sway and weight shifts | OFFICIAL / (?) for the 13 | [GDC: An Indie Approach](https://gdcvault.com/play/1020583/Animation-Bootcamp-An-Indie-Approach) (2014) |
| Physics-blended hit reactions | UFC 2's knockout physics and EA's animation-following ragdolls. Godot has partial ragdoll built in | Partly: a simple flinch is doable, a full balance-keeping KO is a big job | OFFICIAL | MMA Fighting (2015); [Godot PhysicalBoneSimulator3D](https://docs.godotengine.org/en/stable/classes/class_physicalbonesimulator3d.html) |
| **Full motion matching** | **For Honor:** long uncut takes of about 5–10 minutes per movement plan (walks, runs, starts, stops, turns, strafes); the prototype used "5 minutes of guy stumbling randomly". **UFC 3:** 30–40 second takes, about 5,000 animations. **Ubisoft's paper:** basic movement about 24.9 min, rough ground about 47.4 min, chair about 6.2 min, interactions about 10.8 min (DERIVED from the paper's frame counts), and plain motion matching took up to 590 MB of memory. **Ubisoft's public dataset (LaFAN1):** about 4.6 h, 77 takes, 5 performers. **Holden's open-source demo:** about 8.3 min of walk, run and idle, about 16.5 min once mirrored (DERIVED). **Unreal's sample:** "500+ game-ready animations". As Ubisoft puts it, motion matching "will only play back the data you provide" | **No**, not with about 100 short clips; each movement type needs minutes of continuous purpose-shot capture | OFFICIAL / DERIVED | Game Anim (2016); DualShockers (2017); [Learned Motion Matching paper](https://static-wordpress.ubisoft.com/montreal.ubisoft.com/wp-content/uploads/2020/07/09154101/Learned_Motion_Matching.pdf) (2020); [LaFAN1 dataset](https://github.com/ubisoft/ubisoft-laforge-animation-dataset) (2020); [Holden's Motion-Matching repo](https://github.com/orangeduck/Motion-Matching) (2021); [Fab: Game Animation Sample](https://www.fab.com/listings/880e319a-a59e-4ed2-b268-b32dac7fa016) (2024) |

## Summary

| Technique | Who uses it | What it fixes on screen | What it needs |
|---|---|---|---|
| Code sets position and distance, the clip plays on top | For Honor (GDC 2016); Epic's sample | Predictable spacing, no clips drifting the boxers apart | A movement model in code; clips' own forward motion ignored |
| Foot locking | For Honor; Ubisoft (2020) | Feet sliding when clips switch | Foot-contact marks per clip; two-bone leg IK |
| Slide with IK, playback speed capped at +10% / −20% | For Honor | Clips that look sped up or slowed down | Speed limits in code; foot IK |
| Hands steered to the target | Fight Night Round 4 (2009); Undisputed (2023) | Punches landing in thin air or passing through the head | Target points on the opponent; arm IK that fades in and out over the punch |
| Pose and joint limits | For Honor; Godot 4.6 | Bent-back knees and snapping limbs | Joint limits; a cap on IK reach |
| Short blend at clip start | Gears of War (2018); Ubisoft (2020) | A pop when the clip changes | A cross-fade of a few frames (built into Godot) or custom inertialization |
| Stride and orientation warping, distance matching | Epic docs | Feet out of step with speed; directions with no clip | Foot and hip bones; speed and direction from code |
| Body may drift a little from the code position | Epic's sample | Jitter on starts and turns | A drift limit; a blend back when standing |
| Procedural idle, sway and breathing | Overgrowth (2014) | Boxers standing like statues between exchanges | Springs or noise on spine, head and guard; a few key poses |
| Physics-blended hit reactions | UFC 2 (2015); EA (2018) | The same reaction to every punch | Partial ragdoll plus tuning; full KOs are a big job |
| A separate tired movement set | Undisputed (2024) | Tired boxers moving like fresh ones | A second small movement set, or a procedural slump |
| Camera cuts, highlights, replays | FM26 (2025); UFC 5 (2023); Undisputed (2023); WCBM2 (2023) | Hides a small clip set and shows the moments that matter | A camera rig; event tags from the fight sim |
| Full motion matching | UFC 3+ (2017–18); For Honor (2016); FM24 (2023) | Fluid, varied movement with no hand-built transitions | Minutes to hours of continuous capture (about 25 min for basic movement alone in Ubisoft's paper); out of reach with about 100 clips |

## Could not find
- The full UFC 3 RPM talk, which is paywalled: minutes captured, how punches are layered over footwork, and whether IK steers strikes
- Any EA statement on how UFC 3–5 steer strikes, or a technical write-up of UFC 5's hit reactions
- Undisputed's runtime animation system and clip count, and a working copy of the Vicon article
- Anything from Sport and Financial on how Boxing Manager's 3D fights are animated, or how many clips it has; there are no press reviews yet
- WCBM2's sprite count, and how many minutes of capture Football Manager uses
- An inertialization node in core Godot, and a checked source for Overgrowth's "13 keyframes"

That's the full memo. The ~24.9 and ~8.3 minute figures are my own arithmetic from published frame counts, and the Boxing Manager section is thin because the game came out yesterday with 4 reviews. It's saved at `/workspace/jfightanim/J_FIGHT_ANIM_TECH_S431.md`. I haven't told Claude yet because your computer is offline, so it'll land with the rest of the backlog once you're back.
