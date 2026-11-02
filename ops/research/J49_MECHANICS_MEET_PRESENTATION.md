# J49 - HOW THE INDUSTRY JOINS MECHANICS, ANIMATION AND UI

**Task:** J49, from the operator's question on 2026-09-25: *"i want to see the professional workflow that is done during the mechanics and the ui ? how industry mix those to achieve what their audience expects"*
**All sources read:** 2026-09-25 (Asia/Nicosia). Each source's own publication or talk date is given where known.
**Tags:** **DEV** = developer talk, postmortem, dev blog or dev interview (the developer's own words). **PRESS** = journalist summary, review or marketing copy. **COMMUNITY** = player datamine or forum post (not counted as a studio claim). **COUNT** = a number I counted myself from public data, with the method stated. **JUDGEMENT** = my inference, not a sourced fact. **NOT FOUND** = searched and not found.
**Method:** WebSearch/WebFetch/curl on primary pages. For five GDC/Unity talks and two dev videos I pulled YouTube auto-captions with yt-dlp and read the transcripts. Quotes taken from auto-captions may have small transcription errors, and numbers from them are marked "(auto-caption)". A Grok CLI live-search pass (grok-4.6, xhigh) ran to completion and gave leads only. Every Grok lead cited below was re-checked by me. Leads I did not re-check are listed in Appendix A as "grok lead, unverified" and are **not counted**.

---

## 0. Headline answers and summary table

**The one-line answer:** every studio on both sides of FightCamp keeps a **hidden logic layer that decides the result** and a **presentation layer that only shows it**. Animation and UI are built to *read* that logic. They never own it. The best teams then go back and let presentation *ask the logic what happened* (which punch, which goal) so that cameras, replays and highlights can pick the best shot.

| # | Question | Headline answer | Strongest sources (tag) |
|---|---|---|---|
| 1 | Fight games: where motion comes from, runtime system, resolve vs show, HUD | Motion comes from a **mocap stage using real fighters where possible and trained mimics otherwise**, then cleanup, half of it outsourced (EA UFC). The runtime moved from **layered state machines + IK** (EA MMA's ANT, UFC 1) to **motion-database / motion matching** (UFC 3 "Real Player Motion", Undisputed moved off Mecanim to motion matching). Hits are **resolved in gameplay code/data** (FN4 physics contact at 120 Hz with hot-spots; Undisputed damage zones + velocity + fatigue data; For Honor's "simple timed state-machine, playable without animation"). They are **shown** through physics reactions, damage shaders, camera moves and replays. HUDs trend **minimal or HUD-less** (FN Round 3 on 360, UFC 1 no health bars, Undisputed hides opponent meters), with one exception: fighting games (SF6) keep few, readable gauges. | EA GDC 2015/2016/2018 talks (DEV); GameSpot/ESPN FN4 Q&A 2009 (DEV quotes); Unity GDC 2023 Undisputed (DEV); Clavet GDC 2016 (DEV); FN3 Tsunoda interview (DEV) |
| 2 | Management sims with a watched match | **The sim decides and the 3D is a "viewer".** FM: "we called it a match viewer rather than a match engine... The AI... whether you're watching commentary only, 2D or 3D is absolutely identical" (Jacobson, DEV). The engine makes decisions every ¼-second "slice". OOTP's first 3D showed only ball flight, with "no animated players or crowds". **Live vs summary:** FM26 "Dynamic Highlight mode" shows more highlights in dramatic games and fewer when you are 4-0 up, with a 2D overview between clips. Motorsport Manager runs the race live with fast-forward and driver radio. **What gets cut:** FM keeps a zoomed-out camera, OOTP cut animated players, Punch Club cut interactive fighting (one artist, "play with one hand"), FN4 cut the tedious corner mini-game. | Jacobson interview 2011/2012 (DEV); SI FM21/FM24/FM26 blogs (DEV); OOTP newsletter 2014 (DEV); App2top Punch Club 2016 (DEV); MM dev video 2016 (DEV) |
| 3 | Pipeline order | **Mechanic/logic first, proven with placeholder or procedural animation, then sign-off, then "go wide" on content, then presentation polish.** EA UFC 2: "validate your design before going wide with content... get some sign off from production". They had "a template for almost all the transitions" in pre-production so they "could actually prove out the design... if we hadn't had that early prototype no way anyone would have signed off". FN4 prototyped full-body collision and punch physics as separate simultaneous prototypes. Tekken 8 white-boxed stages and play-tested them with planner and director before real assets. For Honor's logic is playable with debug display only. UI/HUD comes late and is iterated on player feedback (Punch Club "rebuilt the interface too many times to remember"; FM26 UI shipped and was then reworked after backlash). | UFC GDC 2015 + 2016 transcripts (DEV); GameSpot FN4 2009 (DEV quote); Autodesk Tekken 8 2025 (DEV interview); Clavet slides (DEV) |
| 4 | What the audience judges first | Counted evidence says **the first thing judged differs by genre**. In fight games it is **feel/intent-to-screen and authentic motion**. UFC 6's #1 community ask was "more control... connect player intent to what's happening on screen" (DEV). UFC 1's ground game "felt linear... turn-based and visual feedback was lacking... we ended up with 7 out of 10 on Metacritic" (DEV). In management sims it is **the menus/UI and the sim's credibility, not animation**: my count of 500 negative FM26 Steam reviews gives UI/menus 44%, bugs/performance 34%, match engine/tactics 20%, animation 5%. FM26 sits at 35.6% positive vs FM24 at 91.6%. For Undisputed (59.0% positive) the top complaint is price/DLC (30%), then animation/movement (13%) and content/career (13%). | EA UFC 6 Q&A 2026 (DEV); UFC 2 GDC transcript (DEV); Steam API (COUNT) |
| 5 | Motion matching | Clavet (For Honor, GDC 2016): "capture 5 or 10 minutes of a person running around", game logic is a "simple timed state-machine", MM picks the frame and procedural warping fits it to gameplay. Zadziuk (GDC 2016): **dance cards**, takes of "upwards of four minutes", a prototype "with maybe 10 minutes worth of data", a locomotion set built "in 4 hours that would take the best teams... at least three months". Data cost: Ubisoft La Forge says MM memory "grows" with data. Their example controller was **590 MB** (learned MM compresses it to 8.5 MB). **Fight use:** For Honor (shipped), EA UFC 3 RPM (motion-database, GDC 2018), Undisputed (Unity, switched to MM). **No mocap stage:** Unreal's free Game Animation Sample ships "over 500 AAA-quality animations" with MM. Unity's Kinematica sample used "45 minutes of mocap". A Godot 4.4 MM GDExtension exists. | GDC Vault + archive slides (DEV); Zadziuk transcript (DEV); Ubisoft La Forge 2020 (DEV); Epic blog 2024 (DEV); Unity docs (DEV) |

---

## 1. Fight games

### 1.1 EA Sports UFC 1 (EA Canada, 2014)

| Aspect | Finding | Source (tag) |
|---|---|---|
| Motion source | Right talent for each shoot: "high level Jiu-Jitsu guys or... professional MMA fighters" for ground work, and "professional muay thai guys or capoeira guys, professional boxers" for stand-up. UFC fighters themselves when possible. Presentation (taunts, intros) was "good solid acting and fighting talent that can emulate them" using video reference. Rehearsals with a pro trainer happened before the shoot, with "at least four angles" of video on the ground game. | S3 (DEV, auto-caption) |
| Cleanup and volume | In-house team of **4 gameplay animators + 1 presentation animator**, and **"6 to 7,000 animation assets"** at ship. **"Over half our gameplay animations"** and "pretty much all of our presentation work" went to an outsource partner (caption: "technicala", likely Technicolor). 26 submissions × ~21 animations each, captured in ~9 takes. About **"a month's worth of work per submission"**. Production was **20 months**, bootstrapped on EA Sports MMA's design docs, mocap and animation libraries "for prototyping in the early days". | S3 (DEV, auto-caption) |
| Runtime animation | Export MotionBuilder into **ANT** (EA's in-house animation engine), then sequencing, tagging, retiming. **"Relative IK"** constraints are authored between fighters so a 7-ft and a 6-ft fighter can share two-man animations. Fighters are **secretly scaled down during takedowns** ("no one noticed"). Locomotion = a functional **movement state machine** + a per-fighter **idle state machine**, plus an **additive copy** of the movement state machine on hips/spine. The layers are procedural foot planting, head tracking, toe splay, cage squaring and procedural turning. | S3 (DEV, auto-caption) |
| Physics vs IK | "Physics was fighting with IK... ik would go first... then physics would run and it would move this arm out of place". Soft-body look = vertex shader driven by tagged penetration amounts: "brute force... did not scale". | S3 (DEV) |
| Knockouts | "On UFC 1 all the knockouts were actually motion-captured animations" (Hayes). | S10 (DEV interview) |
| Frame rate choice | "The game sim is running at 60 FPS, but rendering at 30 FPS with motion blur... when we focus tested the two, the majority of people preferred the 30FPS experience with motion blur" (Hayes). | S11 (DEV interview, 2013-11-06) |
| Style reuse | "Not every single fighter has such a unique style... some fighters just use the same moves as other fighters with the same style." | S11 (DEV) |
| HUD | "Since there are no on-screen health bars, knowing when your opponent is going down for the count is difficult. This pulled me into the action more." | S12 (PRESS review, 2014-06-18) |

### 1.2 EA Sports UFC 2 (2016)

| Aspect | Finding | Source (tag) |
|---|---|---|
| Motion source | A mocap shot list is built from design breakdowns (each ground transition = 5 parts: start, ready, success, deny, cancel), with an **87-page pose library** as "our Bible" at the shoot. | S4 (DEV, auto-caption) |
| Volume | UFC 1: **600** two-player ground animations. UFC 2: **"over 1,957"**. Much of UFC 2's was **"procedural mocap"** generated by a tool from existing data, with outsourced cleanup. | S4 (DEV, auto-caption) |
| Runtime | IK was moved **into the physics engine** to stop the UFC 1 fight between them. | S4 (DEV) |
| Hit/KO show | "Procedurally driven in-game physics... simulation of musculature and limitations of the human body so when the fighters fall... they look like a real human being that has just lost consciousness." FN4's pure ragdoll "looked like a marionette puppet that's had its strings cut". The trade-off was stated as canned = repetitive, ragdoll = ridiculous. | S10 (DEV interview, 2015-12-14) |
| UI clarity | "Grapple assist... make it relatively clear to people as soon as they go to ground what their options are... whether they're likely to succeed or fail... the ground game is a murky place for a lot of people." | S10 (DEV) |

### 1.3 EA Sports UFC 3 (2018): Real Player Motion

| Aspect | Finding | Source (tag) |
|---|---|---|
| Motion source | "We capture unobstructed motion data... it's no more two to three second stops... they move in different shapes, diamonds, and for **30-40 second patterns**." "We've fully-revamped **5,000 animations**." | S5 (DEV interview, 2017-11-03) |
| Runtime | "In a specific frame, it chooses the specific animation... always picking the theoretical best frame." GDC 2018 talk: rebuilt "gameplay and animation systems around the new Real Player Motion Tech". It covers path generation for "coherence between the captured motion data and the motion requests going into RPM database query", an **"RPM Event System"** for "temporal constraints... problems that require tighter controls on timing" (i.e., strikes), and layered techniques for pose variety. | S5 (DEV); S6 (DEV, GDC Vault abstract) |
| Gameplay effect | "Locomotion is your first line of defense... you can actually throw jabs moving forward, you can jab moving backward." | S5 (DEV) |

### 1.4 EA Sports UFC 4 (2020)

| Aspect | Finding | Source (tag) |
|---|---|---|
| Runtime | RPM "expanded... beyond just locomotion and striking into an all new clinch system" and takedowns. "Striking animations blend seamlessly into the specific strike when holding a button versus tapping"; hold threshold **8 frames (~0.25 s)** "but that doesn't mean there is an 8 frame delay". | S7 (DEV, EA blog); S8 (DEV interview quoted in PRESS) |
| Why | "We decided to focus on the clinch based on feedback from the community." | S7 (DEV) |

### 1.5 EA Sports UFC 5 (2023, first on Frostbite)

| Aspect | Finding | Source (tag) |
|---|---|---|
| Hit resolve vs show | "Real Impact System": damage accumulates in **8 body regions × 5 levels**, "about **64,000** possible damage combinations". It is not cosmetic: "a cut bleeding into his eye... will lower defensive abilities on that side", and leg kicks make a fighter "limp and mobility will decline". Doctor stoppages get "specific dynamic camera capabilities" with "six areas that the camera can focus on". | S9a, S9b (DEV/marketing, EA blog, 2023-09-22 and 2023-10-06) |
| Replays (presentation reads logic) | "In UFC 5, we actually have knowledge of the action in the replay, so we know whether it's a right fist or a left fist... With this information, the system can place the cameras in the most compelling and dramatic positions." | S9b (DEV/marketing) |
| UI cut | "Submissions have been built on lengthy multi-stage animations with a variety of hard minigames. The Seamless Submission system removes the minigames completely." | S9a (DEV/marketing) |

**UFC 6 (June 2026), newest data point:** markerless mocap of fighters at the UFC Apex during fight week, "Frostbite Physics and our Real-Time Contact technology". The #1 community feedback was "more control over the outcome... how do we better connect player intent to what's happening on screen?" S13 (DEV, EA Q&A with Associate Producer Raman Bassi, 2026-06-18).

### 1.6 Fight Night Round 3 / Round 4 / Champion (EA Chicago, then EA Canada)

| Aspect | Finding | Source (tag) |
|---|---|---|
| FN3 motion source | "For every boxer possible, we brought the fighters in to the office... capture and give feedback on movement styles, punching styles, and defensive style... we amassed an enormous amount of fight footage for all boxers - cataloging with video each animation we wanted to capture." | S14 (DEV, Kudo Tsunoda interview, c. early 2006) |
| FN3 HUD | "On the Xbox 360, there is no HUD for Fight Night Round 3. You are able to see the damage of your punches right on your opponent's face... how hard they are breathing, if their hands are sagging." | S14 (DEV) |
| FN3 physics | "Physics only showed up during the knockdowns in Round 3. In the punch-by-punch gameplay, physics wasn't involved." | S15 (DEV quote, GameSpot 2009-04-03) |
| FN4 hit resolve | "Speed, direction, friction, degree of contact, and angle of impact all play a factor... The game runs at 60fps, but the physics calculations are actually running at **120fps**." Punches "slide off... or skate over the top of the head". Hot-spots on chin, temple, liver, ribs replace a "simple two-sided punching bag where if you hit it, it means ten points of damage". | S15 (DEV quote); S16 (DEV quote, ESPN 2009-03-10) |
| FN4 cut for readability | Old corner mini-game made players "rub a guy's face for 30 seconds... took away from what people really want". It was replaced by a quick menu for spending points on health/stamina/cuts. | S16 (DEV quote) |
| FNC runtime | "Refined physics-based animation system... improved locomotion, punching and stamina". Muscle flex, deformation and jiggle are "all driven by the physics system itself". A Canadian amateur boxer was gridded for slow-motion reference to allow "1:1 comparisons during production and in reviews". | S17 (PRESS/marketing, EA 2010); S18 (DEV, EA art blog) |
| FNC controls from telemetry | "Based on a lot of user feedback and telemetry... it was a lot easier to extend the thumb outwards and throw left handed punches" → removed quarter/half-circle gestures. | S19 (DEV quote, PS Blog 2011-01-04) |
| GDC talk | Only rendering talks found (FN4 skin shaders; FNC "Iterating Realistic Human Rendering"). **NOT FOUND:** a GDC talk on FN physics/animation. | S20 (DEV, GDC Vault) |

### 1.7 Precursors: EA Sports MMA (2010) and THQ/Yuke's UFC 2009 Undisputed

| Aspect | Finding | Source (tag) |
|---|---|---|
| EA MMA runtime | "Character animations were exported out of MotionBuilder and imported into ANT, placed into controllers and eventually added to a **layered state-machine** where they were triggered. This allowed us to add new punches or ground positions, change the timing windows." HumanIK for "procedural awareness, foot pinning, touch tags and player scaling" and "Relative IK". | S21 (DEV diary, MCV 2010-12-03) |
| UFC 2009 (Yuke's) | GDC talk: "full-scale physics simulation... Physics and Character Animation Blending... Full-body IK Targeting and Character Navigation." | S22 (DEV, GDC Vault abstract) |

### 1.8 Undisputed (Steel City Interactive, Unity; EA Jan 2023, 1.0 Oct 2024)

| Aspect | Finding | Source (tag) |
|---|---|---|
| Motion source | "Get as many fighters as possible into our motion capture suits... footwork, punches, slips, dodges – and even taunts... animation teams spend days processing the output." Dalton Smith captured his own style and "mimic[ked] some of the fighters who are no longer with us". Roy Jones Jr refused an imitator and did his own capture. | S23 (DEV, PS Blog 2024-10-02); S24 (DEV quotes, PC Gamer 2023-04-12); S25 (DEV quotes, Digital Trends 2024-08-22) |
| Prototype origin | Started Feb 2020 as the CEO's first Unity project: "that was my animation tree... basically how not to use an animation tree." Studio of ~50 at GDC 2023. | S26 (DEV, Unity GDC 2023, auto-caption); S24 |
| Runtime | "We switched from using Mecanim [caption: 'Macadam'] to a **motion matching** system." Custom tools create punches and movesets (clip + events + curves). Punch data (damage, stamina, flash-knockdown chances) lives in ScriptableObjects, with separate **"simulation" and "casual" damage sets**. | S26 (DEV, auto-caption) |
| Hit resolve | "Multiple damage zones... neutral zones, harmful zones, critical zones, and then the velocity of the punch and impact." Strength, location, inertia and fatigue combine, plus up to 3 traits per fighter. Real reach (Fury's 85-inch wingspan): "There's a reason other games don't do this." | S25 (DEV quote); S24 (DEV quote) |
| Hit show | Damage via Shader Graph cuts levels 1–3 + swelling blend shapes. **Cinemachine** state camera: when hurt "the camera will zoom in onto him to show that he's in danger". On a dodge "the camera sort of tilts towards me to say hey you've got the counter window open". Shake scales with punch type and force. | S26 (DEV, auto-caption) |
| HUD / broadcast | "You don't get to see your opponent's health or stamina meters" (PRESS, early access). Real announcer, commentators and corner teams; Todd Grisham called real rounds that were played back to him. | S24 (PRESS); S25 (DEV quotes) |

### 1.9 Street Fighter 6 and Tekken 8 (production talks)

| Aspect | Finding | Source (tag) |
|---|---|---|
| SF6 motion source | "For characters like Dee Jay... actual dancers were contracted to do motion capture." | S27 (DEV interview, Rolling Stone 2023-06-03) |
| SF6 presentation | CEDEC 2024 "anime physics" session: a dedicated physics section does cloth and destruction with RE ENGINE Chain + Havok Cloth, "like a single manga panel". **Vega alone has ~100 authored "direction wind" setups per move**, tuned per frame. When sim looks wrong they **overwrite it with baked animation**. Background props stay out of the "battle area". | S28 (PRESS report of DEV talk, 4Gamer 2024-08-31) |
| SF6 HUD/feedback | Graffiti splash is both style and HUD: "if something cool and good happens, then you get to see this big graffiti paint splash." Director: "In fighting games, you want to try to limit the amount of different gauges as much as possible." SF5's stun gauge "felt a bit too much like a 'game system'". | S27 (DEV); S29 (DEV via Famitsu translation, 2024-06-06) |
| Tekken 8 pipeline | Stages: "first creating a simple model (white box)... verifying the sense of size and ease of play... play-tested with the planner and director... then the team would get to work on the actual assets." "We needed to ensure 60fps throughout." Battle motions are owned by the **planning team**, entrances/victories by planners + animators, story by the direction team. | S30 (DEV interview, Autodesk 2025-01-28) |
| Tekken 8 volume | Lead animator's CEDEC 2024 talk: animators did home body+face capture (Xsens MVN, MocapX) and auto-facial from audio to handle volume. | S31 (DEV, CEDEC session page) |
| Hit resolve (frame data, hitboxes) | **NOT FOUND** in any SF6/Tekken 8 production talk I could read. |  |

### 1.10 For Honor (Ubisoft): the one shipped melee game built on motion matching

| Aspect | Finding | Source (tag) |
|---|---|---|
| Resolve vs show | Slide: **"Game Logic: Simple timed state-machine. Possible to play the game without animation! (just debug display)."** The pipeline is gameplay code/state machine → request → pose/trajectory/event matching → "Procedural Warping... We modify the result to precisely match gameplay". | S1b (DEV, Clavet slides GDC 2016) |
| Markup | "Manual markup is necessary for logical information that can't be inferred automatically, like attack types and defense stances." | S1a (DEV, GDC Vault abstract) |

---

## 2. Management sims with a watched match

| Game | How the sim decides and the visuals illustrate | Live vs summarised | What they cut to keep it readable | Source (tag) |
|---|---|---|---|---|
| **Football Manager** (SI) | "The idea was that we were going to take exactly the instructions that were going into the 2D and display them in 3D... we called it a **match viewer rather than a match engine**... The AI that you get, whether you're watching commentary only, whether you're watching 2D or whether you're watching 3D is absolutely identical." Players and officials each make "a decision every quarter of a second, which we call a 'slice'". FM21: "the decision-making code [supplies] the best information from the AI into the animation system". FM24 added **motion matching + IK** on real-match data. FM26 uses **Hawk-Eye skeletal volumetric data** "combined with SI's bespoke motion capture", blended "based on the context of the match situation". | Commentary-only, 2D or 3D views of one sim. FM26 **Dynamic Highlight Mode**: "the more important and more dramatic a game, the more highlights you'll see. If you're already 4-0 up... the number of highlights will drop." A new Match Overview between highlights embeds "the classic 2D pitch view" plus xG-based assistant advice. Replays use "information on the type of goal scored to determine the replay you're shown". | "We will always have a more zoomed out view than you have in FIFA because in FM you have to be able to see more of the pitch." The 3D engine took "about 3 years. Most of the early iterations had failed." It "wasn't a feature begged for by the hardcore forum audience – so of course the classic text-only commentary stays". | S32 (DEV, Jacobson interview, end-2011, posted 2012-10-06); S33 (DEV, SI 2020-11-02); S34 (DEV, SI 2023-09-26); S35 (DEV, SI 2025-09-23); S36 (DEV, FM26 blog 2025); S37 (DEV quote in PRESS, PC Gamer 2010-09-20) |
| **Out of the Park Baseball** | The game engine decides and 3D shows ball flight. The stadium editor defines a "hidden grid and fences (used to outline the field in a way the game engine can understand)". Crowd textures adapt "to roughly match the announced attendance" so visuals don't contradict the sim. | 3D view with user-defined cameras. Other modes: NOT FOUND in a dev source (Grok lead only). | First 3D (OOTP 15): "**no animated players or crowds**, just... when a ball is hit, you'll see the path it travels". Shipped 3D incomplete: "Rather than delay the release... improve on the feature with a series of free updates". "OOTP is always going to be, first and foremost, about management and strategy." | S38 (DEV, OOTP 15 newsletter, 2014) |
| **Motorsport Manager** (Playsport) | CTO Christian West: working on "the race simulation into a really good fun place that kind of **mimics what you see on television at the weekend**." Lap time comes from part **rank**, not raw value, plus tyre phases, fuel weight, engine mode and driving style (datamined numbers). | Race is live, with player orders (engine mode, tyre conserve, pit speed) and time acceleration ("fast forward... towards the end"). Driver radio messages question your calls. Post-session "Twitter feed"-style media report. Tyre-cliff shown by "flashing of the red light at the back of the car" (COMMUNITY). | Players say AI overtaking looks like "single file snake" (COMMUNITY); dev statement on what was cut: NOT FOUND. | S39 (DEV, official video 2016-08-10, auto-caption); S40 (DEV quotes, RaceFans 2016-08-10); S41 (COMMUNITY datamine guide, 2017) |
| **Punch Club** (Lazy Bear) | Fight = "indirect control with strikes chosen at random from a pre-set pool". Later reworked into a skill tree and perks. | Whole fight plays out automatically; player picks strategy between rounds. | Interactive fighting was **never planned**: "would have required a greater variety of characters and their animations, and with our one artist we were very constrained... we wanted a strategic game... comfortable to play with one hand, lounging in a chair." Post-launch lesson: players felt random opponent choice was "not random enough... could be solved by giving players a 'look under the hood'." | S42 (DEV, App2top interview 2016-01-21, Russian, my translation); S43 (DEV talk report, White Nights 2016-06-30) |
| **World Championship Boxing Manager 2** (Mega Cat) | Sequel to the 1990 original. "In the original game, announcers would simply tell players how the boxing match was going, but in WCBM2, players will see the fights play out... Between rounds, the player will be able to restore either their boxer's health or endurance a bit, then tell them whether to stick with their current strategy." | Watched fight + between-round decisions. | NOT FOUND | S44 (DEV interview summarised by PRESS, IGN 2023-05-25) |
| **MMA Federation** (MMA manager, Kickstarter 2014) | "Core gameplay is more of a management simulation game, as opposed to 3D characters... We wanted the fight itself to be just as Live as the real thing, but be more **strategy-based as opposed to skill-based**... assess the current fight situation, the damage taken... listening to the advice of their 'real' corner-men." | Live strategy fight. | NOT FOUND | S45 (DEV blog, Game Developer 2014-01-13) |
| **Undisputed career mode** | PC Gamer (2023): the planned career will include "contract negotiations and training decisions which can affect a boxer's stamina and skill". In fight: "ringside judges who weigh performances differently... mid-fight score predictions, which may not be accurate." | Full played fight. | NOT FOUND (no dev source on career-mode UI) | S24 (PRESS/DEV quotes) |
| **Fight Night Round 4 corner** (sim within an action game) | "Based on your fighter's performance in the previous round, they earn a certain number of points that their trainer can then use towards... health... stamina or healing physical damage." It is a "menu-based interface" both players use at once, with the cinematic optional. | Cinematic is skippable. | Cut the 30-second face-rubbing mini-game. | S16 (DEV quote) |

**Prose.** The management side makes the same split the fight games make, only more openly. SI's own words are that the 3D is a *viewer* of a sim that also runs as text or 2D. SI spent years putting animation tech (FM21 decision→animation handoff, FM24 motion matching, FM26 Hawk-Eye data) behind that viewer without changing who decides. Readability comes from three levers: **camera distance** (FM's zoomed-out rule), **amount shown** (highlight modes, now drama-weighted in FM26), and **the 2D/number layer beside the 3D** (FM26's Match Overview, MM's tyre/fuel panels). Small teams cut animation first. Punch Club and OOTP both said so explicitly and tied it to headcount.

---

## 3. Pipeline order: who locks what, and when

| Step | What studios did | Who signs off | Placeholder used | Source (tag) |
|---|---|---|---|---|
| 1. Borrow a foundation | UFC 1 started from EA MMA's design docs, mocap, animation libraries, engine and interaction controllers: "for prototyping in the early days it was fantastic". | — | Other game's mocap | S3 (DEV) |
| 2. Prototype the mechanic separately | FN4: "Prototyping is a very important part... You don't build the entire thing at once... We had early prototypes to test the full-body collisions of two boxer models and prototypes to test the physics impact from punches... at the same time." | — | Prototype quality "not... meant for store shelves" | S15 (DEV quote) |
| 3. Make logic playable without final animation | For Honor: "Possible to play the game without animation! (just debug display)." UFC 2: "a template for almost all the transitions... we could actually prove out the design... even if the animations weren't perfect or beautiful they were a hundred percent functional." | Production ("no way anyone would have signed off on this feature" without it) | Procedural "mixed idle"/template animation | S1b (DEV); S4 (DEV) |
| 4. Validate small, then go wide | UFC 1 lesson: "you need a ton of content before you can objectively start... playing... designs were changing as we were adding tons of content... **validate Your Design before going wide with content**... validate the new design... with the very small set of core positions... then we'll only go wide once we're happy... and we get some sign off from production." | Production | Small core set | S3 (DEV) |
| 5. Lock the rig early | "Lock down your animation template as quickly as you can... we'd be halfway through production and we'd realize there's an error in our rig and then we'd have to retarget all of our animations." | Rigging + animation | — | S3 (DEV) |
| 6. Greybox space and play-test | Tekken 8: white box → check "sense of size and ease of play" → play-test "with the planner and director" → real assets. | Planner + director | White box | S30 (DEV) |
| 7. Content at scale, outsourced | UFC 1: over half of gameplay animation outsourced; UFC 2 used outsourced cleanup "to a huge success". | Animation director reviews | — | S3, S4 (DEV) |
| 8. Presentation and UI tuned by players | FN4 corner game, FNC control telemetry, UFC 4 clinch "based on feedback from the community", Punch Club UI reworked "countless" times from alpha/beta feedback, FM26 UI reworked post-launch. | Players (telemetry, reviews) | — | S16, S19, S7, S42 (DEV); S46 (DEV statement via PRESS) |
| Team shape examples | EA UFC 1: 4 gameplay animators + 1 presentation animator in-house. Tekken 8: battle motion owned by planners (designers), not animators. SI: "we don't have designers at the studio... all of our coders like to be designers as well." Undisputed: 4 → 12 → ~50. | — | — | S3, S30, S32, S24/S25 (DEV) |

**Short answer to the operator:** the order is **logic → playable ugly → sign-off → content → presentation → UI tuned by players**. No source described a formal greybox → vertical slice → alpha milestone doc for these specific games (**NOT FOUND**). The published habits above all point the same way.

---

## 4. What the audience expects (counted where possible)

| Evidence | Number | What it says | Source (tag) |
|---|---|---|---|
| UFC 1 postmortem | Metacritic "7 out of 10... we really wanted that 8" | Ground game "felt linear... turn-based and visual feedback was lacking... we needed more animations" | S4 (DEV statement, auto-caption) |
| UFC 2 player research | Career was "one of the most-played modes, which had the highest dissatisfaction" | So it took "the lion's share of our team's efforts" in UFC 3. Found through "four or five months post-launch" of listening. | S5 (DEV statement) |
| UFC focus test | "the majority of people preferred the 30FPS experience with motion blur" over 60 fps | Visual smoothness beat raw frame rate for this audience (no count published) | S11 (DEV statement) |
| UFC 6 community | #1: "more control over the outcome", i.e. intent → screen. #2: "fighters to feel more distinct" | Feel and authenticity come first | S13 (DEV statement) |
| FN control telemetry | Left punches easier than right with gestures | Controls redesigned from telemetry | S19 (DEV statement) |
| FM playtime | Average FM11 player time "140 hours", expected to exceed 200 | The menus are where the time goes | S32 (DEV statement) |
| Steam, Football Manager 26 | **35.6% positive** (12,875 / 36,206), "Mostly Negative" | vs FM24 **91.6%** (26,189 / 28,587). Same sim lineage, new UI/engine. | S47 (COUNT, Steam appreviews API, read 2026-09-25) |
| Steam, FM26 negative reviews by theme | Of 500 English negative reviews (Steam default helpfulness order): **UI/menus 44%**, bugs/performance 34%, match engine/tactics 20%, price/DLC 11%, **animation/movement 5%**, commentary/presentation 2% | In a management sim, players judge menus first. Animation barely registers. | S47 (COUNT; keyword regex, one review can hit several themes) |
| SI response | "The end result was ultimately detrimental to some of your experiences... what we released has failed to meet the expectations of many" | Studio statement confirming the UI verdict | S46 (DEV statement via PRESS, 2026-05-11) |
| Steam, Undisputed | **59.0% positive** (13,481 / 22,850), "Mixed" | — | S47 (COUNT) |
| Steam, Undisputed negative reviews by theme | 500 English negative: **price/DLC 30%**, animation/movement 13%, content/career/roster 13%, bugs/performance 8%, hit detection/physics 3%, commentary 2%, UI 0% | Among gameplay complaints, motion is the top one | S47 (COUNT) |
| Steam, others (context) | Motorsport Manager 91.7% (14,228); Punch Club 80.2% (15,807); OOTP 26 82.5% (838); WCBM2 67.6% (108) | Sims with simple visuals score well when the sim is readable | S47 (COUNT) |
| Undisputed early-access reviews (press summary) | — | Negatives covered modes, online issues, graphics, "unintentionally comedic commentary system", "don't understand why their power punches aren't earning them knockdowns" | S24 (PRESS, 2023-04-12) |
| Punch Club reviews (dev reading them) | 95% of found errors fixed; negatives "decreased significantly" | Unexplained randomness read as unfair → "look under the hood" | S43 (DEV statement) |

**Prose.** For **fight games**, the dev statements and counts agree that players judge **feel (intent → screen), then authentic motion, then depth**. UFC 1's 7/10 was blamed on thin, unclear ground-game feedback, and UFC 6's top ask was control. For **management sims**, players judge **the menus and whether the sim is believable**. FM26's collapse from 91.6% to 35.6% positive is overwhelmingly about UI and bugs, not the new Hawk-Eye animation. Watch the second-order point: **unexplained outcomes read as unfair** (Punch Club "not random enough", Undisputed's "why no knockdown"). The fix both studios name is to *show the reason*.

---

## 5. Motion matching

| Item | Finding | Source (tag) |
|---|---|---|
| Clavet, GDC 2016 ("Motion Matching and The Road to Next-Gen Animation", Ubisoft Montreal, For Honor) | "Declarative animation... small structured markup on top of long animations"; "capture **5 or 10 minutes** of a person running around and import it directly"; "every frame, look at all mocap and jump at the best place"; each candidate has a cost from current pose + future trajectory; the "responsivity" weight on future cost. Workflow: simple timed state machine for game logic, then procedural warping. Conclusion: "high quality, controllable responsiveness, minimal manual work... DATA!" | S1a (DEV, GDC Vault); S1b (DEV, archive.org slide text, 2016-10-17 upload) |
| Zadziuk, GDC 2016 Animation Bootcamp ("Motion Matching: The Future of Games Animation... Today", Ubisoft Toronto) | **Dance cards** = ordered capture routines covering a core locomotion set (walk/jog/run). "One shot could last upwards of **four minutes**", so they split cards into starts/stops, plant turns, circles, accel/decel. Early prototype "maybe **10 minutes** worth of data". "Better looking and feeling locomotion system in **4 hours** that would take the best teams in Ubisoft at least **three months**." Animator worries raised: "what if we can't get access to the mocap facility, how do we prototype new ideas". | S2a (DEV, GDC Vault); S2b (DEV, GDC YouTube transcript, auto-caption) |
| Data size | "Motion Matching works best when combined with lots of motion capture data... large memory usage." An AAA design can reach "many hundreds of megabytes, perhaps gigabytes". MM "does not combine data for you" (walking + drinking needs a walking-drinking clip). Their example: **590 MB** controller → **17 MB** (8.5 MB quantised) with Learned MM. | S48 (DEV, Ubisoft La Forge, 2020-07-30) |
| EA | UFC 3 RPM is a motion-database query with timing constraints for strikes (GDC 2018). "EA began integrating Motion Matching into its games over five years ago" (GDC 2023 "Motion Matching at EA: Five Years Later"). Which EA titles: **NOT FOUND** in the abstract. FM (SEGA/SI) uses MM since FM24. | S6 (DEV); S49 (DEV, GDC Vault); S34 (DEV) |
| The Last of Us Part II | GDC 2021 (Mach, Zhuravlov): "switch to... pretty experimental animation system called Motion Matching... initial joy, later frustration and ultimate fear". Data volumes: **NOT FOUND** (talk not transcribed). | S50 (DEV, GDC Vault abstract) |
| Unreal 5 | Game Animation Sample (2024-06-12): "animation database of **over 500** AAA-quality animations, complete with a fully functional character", "multiple Motion Matching databases", "a dense dataset with hundreds of animations versus a sparser set with less than a hundred", Pose Warping fills coverage gaps, Rewind Debugger. For indies: "plug-and-play locomotion... retarget them to your own characters". Minutes of mocap: **NOT FOUND** (Epic counts clips, not minutes). | S51 (DEV, Epic blog) |
| Unity Kinematica | Sample: "a complete character locomotion made of **45 minutes of mocap** animations with only 2 function calls". Package stopped at 0.8.0-preview (2020). Unity's 2022 roadmap says an all-new animation system is coming. I found **no official statement that Kinematica ships**; treat it as abandoned (JUDGEMENT). | S52 (DEV, Unity docs); S53 (DEV, Unity forum 2022-04-11) |
| Godot | "A Motion Matching plugin for Godot 4" (GuilhermeGSousa, GDExtension, Godot Asset Library #3822, ~242 GitHub stars when read). Needs root motion and an animation library as the pose database (per listing). | S54 (DEV repo); S55 (asset library) |
| Fight-game use | Shipped: **For Honor** (melee), **EA UFC 3/4** (RPM motion database), **Undisputed** (switched from Mecanim to MM). **NOT FOUND:** SF6/Tekken 8 using MM for combat. | S1, S5–S7, S26 |
| Small team without a stage | Undisputed (~50 people) mocaps but had no in-house engine team (Unity). Unreal's sample is explicitly pitched at indies. The Kinematica sample shipped its own mocap. Clavet/Zadziuk both rely on a stage for their own data. **NOT FOUND:** a named shipped small-team game built only on the free Unreal set. | S26, S51, S52 |

**Prose.** Motion matching does not decide anything. In For Honor the game logic is a timed state machine that runs with debug boxes, and MM picks the frame that best fits what the logic asked for, then warping forces it to fit. That is the same split as FM's "viewer". The cost is **data**: minutes of well-planned capture (dance cards) for locomotion, far more for combat variety, and memory that grows with it. For punches that must land on a frame, EA had to add an **event/timing system** on top (RPM Event System). For a small Godot team this is the part to plan for.

---

## 6. What FightCamp should take (gate table)

| # | Gate for FightCamp | Tag | Basis |
|---|---|---|---|
| G1 | **The match engine must run headless with debug display and give the same result whatever is watching.** The 3D room is a viewer. | SOURCED | FM "match viewer" (S32); For Honor "playable without animation" (S1b) |
| G2 | **The engine emits a typed event log** (who, what strike, where, how clean, damage delta, state change). The 3D room, commentary text, highlight picker and replay camera all read it. | SOURCED (pattern) + JUDGEMENT (format) | UFC 5 replay "knowledge of the action... right fist or left fist" (S9b); FM26 replay by goal type (S36); FM21 AI → animation info (S33) |
| G3 | **Resolve hits in data (zones × velocity × fatigue × traits), not in physics collisions.** Physics/ragdoll only shows. | SOURCED + JUDGEMENT | Undisputed zones + data sets (S25, S26); FN4 physics-resolved hits needed a 120 Hz sim and a big team (S15). JUDGEMENT: a sim-first manager should not let a render-side collision change the result. |
| G4 | **Knockdowns/KOs: avoid pure ragdoll.** Use authored falls or physics with muscle limits. | SOURCED | Hayes: FN4 ragdoll "marionette", UFC 1 canned, UFC 2 muscle-limited physics (S10) |
| G5 | **Prove the mechanic with ugly, complete coverage before buying or authoring animation.** Get sign-off on a small core set, then go wide. | SOURCED | UFC 1/2 lessons (S3, S4); FN4 separate prototypes (S15) |
| G6 | **Lock skeleton/rig and naming conventions before any content.** | SOURCED | UFC rig-retarget pain, naming lesson (S3, S4) |
| G7 | **Minimal in-fight HUD: show state on the body and camera** (hurt zoom, counter-window tilt, fatigue posture). Keep at most a couple of readable meters. | SOURCED | FN3 HUD-less (S14); UFC 1 no health bars (S12); Undisputed Cinemachine cues (S26); SF6 "limit the amount of different gauges" (S29) |
| G8 | **Drama-weighted highlights + a 2D/number overview between clips** rather than a full 3-minute-per-round live render as the only option. | SOURCED | FM26 Dynamic Highlight + Match Overview (S36); FM commentary/2D/3D parity (S32) |
| G9 | **Always offer text-only / fast-sim.** Hardcore sim players did not ask for 3D. | SOURCED | Jacobson on FM11 (S37); FM "commentary only" parity (S32) |
| G10 | **Explain outcomes on screen** (why a punch didn't drop him: blocked, glancing, low fatigue). Hidden randomness reads as unfair. | SOURCED | Punch Club "look under the hood" (S43); Undisputed "why no knockdowns" + "not communicated right now" (S24) |
| G11 | **Menus are the product for a manager sim.** Budget UI testing like gameplay testing and don't ship a navigation rewrite untested. | SOURCED (COUNT) | FM26: 44% of negatives about UI, 35.6% positive vs 91.6% FM24 (S47); SI statement (S46) |
| G12 | **Camera distance rule:** default to a readable wide/broadcast view, with close cinematics only for events. | SOURCED + JUDGEMENT | FM zoomed-out rule (S32); UFC 5 cinematic replay/doctor cams only on events (S9b); Tekken "camera rarely zooms in during battle" (S30) |
| G13 | **Motion matching is optional, not a v1 gate.** If used, start from the free Unreal set or the Godot MM addon for locomotion only, keep strikes as event-timed clips, and plan dance-card style capture if you ever go to a stage. | SOURCED + JUDGEMENT | Epic sample (S51); Godot addon (S54); RPM Event System (S6); dance cards (S2b); memory growth (S48) |
| G14 | **Reuse animation by style archetype, not per fighter.** Per-fighter uniqueness goes into idles/taunts only. | SOURCED | UFC 1: fighters with same style share moves (S11); unique idle per fighter over shared locomotion (S3) |
| G15 | **Physics secondary motion must serve readability.** Bake over simulation when it looks wrong. | SOURCED | SF6 bake-over + "anime physics" (S28) |
| G16 | **Frame-rate: fixed sim tick, render can differ.** | SOURCED | UFC sim 60 / render 30 (S11); FN4 physics 120 / game 60 (S15) |
| G17 | A formal industry milestone doc (greybox → VS → alpha) for these genres | NOT FOUND | — |

---

## Sources index (all read 2026-09-25)

| ID | Source | Date | Type | URL |
|---|---|---|---|---|
| S1a | Clavet, "Motion Matching and The Road to Next-Gen Animation", GDC Vault | GDC 2016 | DEV (GDC talk) | https://www.gdcvault.com/play/1023280/Motion-Matching-and-The-Road |
| S1b | Same talk, slide text (Internet Archive) | talk Mar 2016; upload 2016-10-17 | DEV (slides) | https://archive.org/stream/GDC2016Clavet/GDC2016-Clavet_djvu.txt |
| S2a | Zadziuk, "Motion Matching: The Future of Games Animation... Today", GDC Vault | GDC 2016 | DEV (GDC talk) | https://www.gdcvault.com/play/1023478/Animation-Bootcamp-Motion-Matching-The |
| S2b | Same talk, GDC YouTube (transcript read) | GDC 2016 | DEV | https://www.youtube.com/watch?v=KSTn3ePDt50 |
| S3 | Dowsett & Harrower, "Animation Bootcamp: UFC Animation System" (Vault + YouTube transcript "Inside The UFC Animation System", uploaded 2015-08-14) | GDC 2015 | DEV (GDC talk) | https://www.gdcvault.com/play/1021794/Animation-Bootcamp-UFC-Animation ; https://www.youtube.com/watch?v=Xw47OUed9vE |
| S3b | Game Developer write-up of S3 | 2015-08-17 | PRESS | https://www.gamedeveloper.com/production/video-watch-a-blow-by-blow-account-of-animating-ea-s-ufc-games |
| S4 | Harrower & Mathiesen, "Embracing Animation Complexity in EA UFC 2 Through Procedural Techniques" (Vault + YouTube transcript, uploaded 2017-10-13) | GDC 2016 | DEV (GDC talk) | https://www.gdcvault.com/play/1023474/Animation-Bootcamp-Embracing-Animation-Complexity ; https://www.youtube.com/watch?v=1nSshgQ3HM4 |
| S5 | DualShockers, Marc De Vellis (UFC 3 senior producer) interview | 2017-11-03 | DEV interview | https://www.dualshockers.com/ufc-3-interview-marc-de-vellis/ |
| S6 | Harrower, "Real Player Motion Tech in 'EA Sports UFC 3'", GDC Vault | GDC 2018 | DEV (GDC talk abstract) | https://www.gdcvault.com/play/1025228/Real-Player-Motion-Tech-in |
| S7 | EA, "UFC 4 New Gameplay Features Deepdive" | 2020 | DEV (EA blog) | https://www.ea.com/news/new-gameplay-deepdive |
| S8 | GameSpot, UFC 4 dev interview | 2020-07 | DEV quotes in PRESS | https://www.gamespot.com/articles/ea-sports-ufc-4-dev-on-the-biggest-gameplay-change/1100-6480126/ |
| S9a | EA, "UFC 5 Gameplay Deep Dive" | 2023-09-22 | DEV/marketing (EA blog) | https://www.ea.com/games/ufc/ufc-5/news/ufc-5-gameplay |
| S9b | EA, "UFC 5 Presentation Deep Dive" | 2023-10-06 | DEV/marketing (EA blog) | https://www.ea.com/games/ufc/ufc-5/news/ufc-5-presentation |
| S10 | GodisaGeek, Brian Hayes (UFC 2 creative director) interview | 2015-12-14 | DEV interview | https://godisageek.com/2015/11/ea-sports-ufc-2-interview/ |
| S11 | GamingBolt, Brian Hayes (UFC 1) interview | 2013-11-06 | DEV interview | https://gamingbolt.com/ea-sports-ufc-interview-gameplay-mechanics-realistic-ai-animations-and-more |
| S12 | Game Informer, EA Sports UFC review | 2014-06-18 | PRESS | https://gameinformer.com/games/ea%5Fsports%5Fufc/b/playstation4/archive/2014/06/18/ea-sports-ufc-game-informer-review |
| S13 | EA, "Inside EA SPORTS UFC 6" (Raman Bassi Q&A) | 2026-06-18 | DEV (EA blog) | https://www.ea.com/news/ufc-6-developer-qa |
| S14 | GameVortex, Kudo Tsunoda (FN Round 3 EP) interview | c. 2006 | DEV interview | https://psillustrated.com/gamevortex/interview.php/2 |
| S15 | GameSpot, "Fight Night Round 4: The Physics of Fighting" (Brian Hayes Q&A) | 2009-04-03 | DEV quotes | https://www.gamespot.com/articles/fight-night-round-4-the-physics-of-fighting/1100-6233939/ |
| S16 | ESPN, "Fight Night Round 4: Five things you need to know" (Hayes) | 2009-03-10 | DEV quotes in PRESS | https://www.espn.com/espn/thelife/videogames/news/story?id=3968745 |
| S17 | EA, FNC announcement | 2010 | PRESS/marketing | https://www.ea.com/en-ca/news/ea-to-redefine-the-sports-gaming-experience-with-fight-night-champion |
| S18 | EA, "Fight Night Champion Art" | 2011 | DEV (art blog) | https://www.ea.com/en-gb/news/fight-night-champion-art |
| S19 | PlayStation Blog, FNC Full Spectrum Punch Control (Hayes quotes) | 2011-01-04 | DEV quotes | https://blog.playstation.com/2011/01/04/fight-night-champion-full-spectrum-punch-control-saves-your-thumbs-controllers/ |
| S20 | GDC Vault, FN4 skin shaders / FNC rendering talks | 2009 / 2011 | DEV | https://gdcvault.com/play/1012344/Blood-Sweat-and-Tears-An ; https://gdcvault.com/play/1014661/Iterating-Realistic-Human-Rendering-Boxers |
| S21 | MCV, "EA Diaries: How we built MMA" | 2010-12-03 | DEV diary | https://mcvuk.com/development-news/ea-diaries-how-we-built-mma/ |
| S22 | Ueno (Yuke's), "Physics & Animation in UFC 2009 Undisputed", GDC Vault | GDC 2010 (approx.) | DEV (abstract) | https://gdcvault.com/play/1012871/The-Next-Generation-of-Fighting |
| S23 | PlayStation Blog, Undisputed body scans / mocap | 2024-10-02 | DEV (studio blog) | https://blog.playstation.com/2024/10/02/undisputed-launches-oct-11-how-body-scans-deliver-boxing-authenticity/ |
| S24 | PC Gamer, Ash Habib at GDC | 2023-04-12 | DEV quotes + PRESS | https://www.pcgamer.com/undisputed-boxing-game-interview-GDC/ |
| S25 | Digital Trends, Undisputed with Ash Habib | 2024-08-22 | DEV quotes + PRESS | https://www.digitaltrends.com/gaming/undisputed-is-by-and-for-boxing-fans/ |
| S26 | Habib & Bruins, "Undisputed: Punching Above Class", Unity at GDC 2023 (Vault + YouTube transcript, 2023-04-05) | 2023 | DEV (GDC sponsored talk) | https://www.gdcvault.com/play/1029388/Undisputed-Punching-Above-Class-(Presented) ; https://www.youtube.com/watch?v=h2CmZRN2pfo |
| S27 | Rolling Stone, SF6 creators (Nakayama, Matsumoto) | 2023-06-03 | DEV interview | https://www.rollingstone.com/culture/rs-gaming/street-fighter-6-what-we-learned-1234746230/ |
| S28 | 4Gamer, CEDEC 2024 SF6 physics session report | 2024-08-31 | PRESS report of DEV talk | https://www.4gamer.net/games/635/G063504/20240830070/ |
| S29 | EventHubs, Nakayama/Famitsu on Drive System | 2024-06-06 | DEV quotes (translated) | https://www.eventhubs.com/news/2024/jun/06/sf6-director-drive-system-expression/ |
| S30 | Autodesk, Tekken 8 art team interview | 2025-01-28 | DEV interview | https://blogs.autodesk.com/media-and-entertainment/2025/01/28/tekken-8-legacy-meets-innovation-with-the-combined-power-of-maya-and-unreal-engine/ |
| S31 | CEDEC 2024 session page, Tekken 8 home capture | 2024-08-21 | DEV (session abstract) | https://cedec.cesa.or.jp/2024/session/detail/s6603b39f2bb66/ |
| S32 | funambulism, Miles Jacobson interview (for PC Gamer) | interviewed end-2011; posted 2012-10-06 | DEV interview | https://funambulism.com/2012/10/06/miles-jacobsen-on-not-talking-about-football-manager/ |
| S33 | SI, "Match Engine AI in FM21" | 2020-11-02 | DEV (SI blog) | https://www.footballmanager.com/news/match-engine-ai-fm21 |
| S34 | SI, "Truer Football Motion..." (FM24) | 2023-09-26 | DEV (SI blog) | https://www.footballmanager.com/features/truer-football-motion-match-authenticity-positional-play |
| S35 | SI, Hawk-Eye partnership (FM26) | 2025-09-23 | DEV (SI news) | https://www.sports-interactive.com/news/hawk-eye-and-sports-interactive-team-power-football-managers-new-era |
| S36 | SI, "Where Storytelling Evolves: FM26's Match Day Experience" | 2025 | DEV (SI blog) | https://www.footballmanager.com/fm26/features/where-storytelling-evolves-fm26s-match-day-experience |
| S37 | PC Gamer, FM2011 preview (Jacobson) | 2010-09-20 | DEV quotes in PRESS | https://www.pcgamer.com/preview-why-football-manager-2011-will-score-big/ |
| S38 | OOTP Developments, "OOTP 15 Road to Release #3: First Step into 3D" | 2014 | DEV (newsletter) | http://www.ootpdevelopments.com/newsletters/nl0139/ |
| S39 | Motorsport Manager official, "Features 3: Win the Race" (Christian West) | 2016-08-10 | DEV (video, auto-caption) | https://www.youtube.com/watch?v=IBy0kDiIwPI |
| S40 | RaceFans, Christian West interview | 2016-08-10 | DEV interview | https://www.racefans.net/2016/08/10/meeting-man-behind-motorsport-manager/ |
| S41 | Steam guide "Understanding the Simulation" (datamine) | 2017-02-26 | COMMUNITY | https://steamcommunity.com/sharedfiles/filedetails/?id=872854237 |
| S42 | App2top.ru, Nikita Kulaga (Lazy Bear) interview | 2016-01-21 | DEV interview (Russian) | https://app2top.ru/industry/lazy-bear-games-my-delali-igru-ne-dlya-togo-chtoby-zarabotat-mnogo-deneg-a-dlya-togo-chtoby-sdelat-igru-72983.html |
| S43 | App2top, "Game design mistakes in Punch Club" (White Nights 2016) | 2016-06-30 | DEV talk report | https://app2top.com/industry/white-nights-st-petersburg-2016-game-design-mistakes-in-punch-club-81613.html |
| S44 | IGN, WCBM2 creative director interview | 2023-05-25 | DEV via PRESS | https://www.ign.com/articles/world-championship-boxing-manager-2-developer-interview-experience-the-journeys-of-classic-boxers |
| S45 | Game Developer blog, Phil Goddard, MMA Federation | 2014-01-13 | DEV blog | https://www.gamedeveloper.com/business/merging-a-real-world-fan-lifestyle-with-a-fantasy-game |
| S46 | Operation Sports, Jacobson FM26 statement | 2026-05-11 | DEV statement via PRESS | https://www.operationsports.com/football-manager-26-director-admits-game-failed-to-meet-expectations-in-candid-statement/ |
| S47 | Steam appreviews API (appids 1451190, 3551340, 2252570, 394310, 415200, 3116890, 1903970) | read 2026-09-25 | COUNT | https://store.steampowered.com/appreviews/<appid>?json=1 |
| S48 | Ubisoft La Forge, "Introducing Learned Motion Matching" | 2020-07-30 | DEV (research blog) | https://www.ubisoft.com/en-us/studio/laforge/news/6xXL85Q3bF2vEj76xmnmIu/introducing-learned-motion-matching |
| S49 | Delannoy, "Motion Matching at EA: Five Years Later", GDC Vault | GDC 2023 | DEV (abstract) | https://www.gdcvault.com/play/1028821/Animation-Summit-Motion-Matching-at |
| S50 | Mach & Zhuravlov, "Motion Matching in The Last of Us Part II", GDC Vault | GDC 2021 | DEV (abstract) | https://www.gdcvault.com/play/1027378/Motion-Matching-in-The-Last |
| S51 | Epic, "Get over 500 free animations with the Game Animation Sample Project" | 2024-06-12 | DEV (Epic blog) | https://www.unrealengine.com/blog/game-animation-sample |
| S52 | Unity, Kinematica 0.8 "Getting Started" | 2020 | DEV (docs) | https://docs.unity3d.com/Packages/com.unity.kinematica@0.8/manual/Getting-Started.html |
| S53 | Unity forum, "Animation Status Update (Q2 2022)" | 2022-04-11 | DEV (official post) | https://discussions.unity.com/t/animation-status-update-q2-2022/877939 |
| S54 | GitHub, GuilhermeGSousa/godot-motion-matching | read 2026-09-25 | DEV (addon repo) | https://github.com/GuilhermeGSousa/godot-motion-matching |
| S55 | Godot Asset Library #3822 | — | addon listing | https://godotengine.org/asset-library/asset/3822 |

---

## Still unknown (NOT FOUND after searching)

1. A GDC/CEDEC talk on **Fight Night** physics/animation. Only rendering talks exist in the Vault.
2. **SF6 / Tekken 8 hit resolution** (hitbox/frame-data pipeline) in a production talk. Also any SF6 GDC talk on HUD or hit reactions.
3. **Minutes/hours of mocap** behind UFC 3 RPM, the Unreal Game Animation Sample (Epic gives a clip count only) and TLOU2.
4. **Which EA titles** use motion matching (GDC 2023 abstract says "its games" only). No EA source says UFC 5/6 RPM *is* "motion matching" by name. The Springer encyclopedia cites the UFC 3 talk under motion matching (secondary).
5. A published **milestone plan / greybox → vertical slice doc** for any of these games.
6. **Undisputed career-mode UI** and **OOTP display modes** (text/2D/3D) from a dev source.
7. **Motorsport Manager** dev statement on what was cut from the race view.
8. Any **counted player survey** (not reviews) for fight or manager games.
9. **Punch Club fight animation pipeline** (sprite counts etc.).

## Limits of this research

- Several key numbers come from **YouTube auto-captions** of GDC talks (S3, S4, S26, S2b, S39). Wording is near-verbatim but may have small errors (e.g. "Macadam" = Mecanim, "technicala" = likely Technicolor). I did not watch GDC Vault members-only videos.
- GDC Vault pages for S6, S22, S49, S50 were read as **abstracts only**.
- Steam theme counts (S47) use **simple keyword regex** on 500 English negative reviews per game, in Steam's default helpfulness order. One review can count in several themes. "price/dlc" includes the word "money", which may over-count. Treat these as directional.
- EA blog pages are part dev writing, part marketing; tagged DEV/marketing.
- GameSpot and OOTP forum pages block the fetch tool; GameSpot was read via curl. The OOTP forum was not read.

## Appendix A: Grok leads NOT re-checked (not counted)

- UFC 3 PlayStation Blog 2018-01-30 and UFC 4 PS Blog 2020-08-13 details: grok lead, unverified.
- TLOU2 "hundreds and hundreds" of walk/turn clips (GameSpot 2019-10-01): grok lead, unverified.
- Tekken 8 CEDEC+Kyushu 2024: mocap of martial artists restyled for readability (4Gamer): grok lead, unverified.
- FM22 new animation engine / "In The Studio" video; RPS 2013 Jacobson interview; FM 2009 mocap from Virtua Striker (GameWatcher): grok leads, unverified.
- OOTP "3D/top-down/text/radio are views of the same sim" (PC Gamer review); The Athletic OOTP feature: grok leads, unverified.
- Undisputed BBC mocap feature; Eurogamer Habib interview; Shacknews/IGN Undisputed reviews; IGN/Dexerto UFC 5 reviews; Forbes FM26 hands-on: grok leads, unverified.
- Bit by Bit "MMA Manager" play-by-play text fight (Sherdog forum); Punch Club documentary; Punch Club 2 interview: grok leads, unverified.
- Epic tutorial "Motion Matching in a fighting game" (community tutorial, 2025): grok lead, unverified.
