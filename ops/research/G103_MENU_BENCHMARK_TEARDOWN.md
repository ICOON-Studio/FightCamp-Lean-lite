# G103 — Tear down the menus the operator named

Grok (Expert), delivered 2026-09-25 as `G103_UI_BENCHMARK_MEMO.md` in https://grok.com/c/4bc97d7f-bc42-43a0-924c-8ca7a869e357 (119 sources).
Collected S79 by Claude from the in-page document preview; tables re-set as markdown, text otherwise as delivered.

Research only. FightCamp front-end benchmark vs Motorsport Manager (2016) and Hollywood Animal (EA 2025), plus Steam boxing / combat-management comps and 2025–26 upcoming gym/MMA sims.

Date: 2026-09-25
Scope: UI techniques, review praise/hate, adopt/improve/avoid. No production work.

## What a UI lead does before a redesign
- Inventory every screen type in the two admired titles (boot, hub, list, card, clock, modal, overlay, transition).
- Name the technique on each (video loop, parallax, 3D lot, fade, slide, hover sheen, stagger-in).
- Pull dated reviews (press + Steam + Reddit/community) for what was praised vs hated.
- Tag each claim: SOURCED (named review/store), PROXY (inferred from footage/screens, duration unknown), JUDGEMENT (FightCamp mapping).
- Copy what reviewers loved, improve what they liked but found incomplete, avoid what they punished.

## 1. Motorsport Manager (2016) and Hollywood Animal (2025)

### Motorsport Manager (Playsport / SEGA) — Steam Very Positive, ~14.2k reviews, ~92% / Metacritic 81

| Screen | Technique | Duration | Reviews said |
|---|---|---|---|
| Title / boot | Branded 3D car / circuit presentation; frontend uses a looping video/Bink background (FrontendBackgound.bk2 in StreamingAssets — players rename the file to stop motion if it bothers them). PROXY technique; SOURCED file name (NamuWiki player note). | Loop; length not published | Presentation called "sleek, appealing… better and more intuitive than many spreadsheet simulators" (Motorsport.com, 11 Nov 2016). Stuff.tv (9 Mar 2017): "from menus to tracks… interface is clean and fluid." |
| Hub (HQ) | 3D isometric / toy-set HQ campus you build (wind tunnel, factory, design centre). Rival-comparison bars sit beside the scene. Bottom nav strip. Time frozen on HQ. SOURCED | N/A (paused time) | SomersF1 (11 Nov 2016): 3D backdrop "scaled and moved." GamingTrend (28 Nov 2016): "menu spreads across the bottom… tutorial takes you through almost everything." RPS (7 Nov 2016): screens "beautifully and coherently constructed." |
| List / card cells | Dense but coherent tables; stats shown vs rivals, not raw orphans. Thumbnail portraits + short bios. SOURCED | Instant | Eurogamer (17 Nov 2016): personalities emerge through "small thumbnail portraits and biographies." PCGamesN (10 Aug 2016): start-of-season hub "a lot to take in at first." Playground.ru (16 Nov 2016) hated first-hour tab/slider overload. |
| Time control | Race-weekend clock + sim speed; HQ is turn-frozen. Mid-race modal pauses the 3D race behind it (pit planner). SOURCED | Modal = pause | RPS (7 Nov 2016): pit screen "pops up and the race pauses in the background." RaceFans (7 Nov 2016): data boxes "a click or two away"; pit menu can feel fiddly. |
| Transitions | Instant screen swap + modal overlay on live 3D. No published fade timings. PROXY | Unknown | Reviews praise coherence, not cinema. Nobody cites a signature wipe. |
| Background motion | 3D HQ + tilt-shift 3D race (Eurogamer: "expensive toy set"). Frontend video loop. SOURCED | Continuous | Stuff.tv loved the tilt-shift; not everyone does. NamuWiki: some players disable the frontend video. |
| Button hover / press | Standard PC highlight; mouse-only (no pad). No published sheen spec. PROXY | — | WindyCornerTV (8 Dec 2016): "interface is very intuitive… entire game with just the mouse." |
| New items on screen | Lists populate immediately; tutorial avatar walks each panel. SOURCED | First hours | SomersF1: ex-driver avatar ("Our Nige") narrates each screen. Motorsport.com: tutorial should have been a standalone multi-race mode. Playground.ru: tooltips explain even "quit" — "hell." |

Praised: rebuilt-for-PC coherence; numbers always visible; HQ as a place; rival-relative stats; bottom nav.
Hated: first-hour density; over-talkative tutorial; extra clicks for some decisions; pit modal fiddly.

### Hollywood Animal (Weappy) — EA 10 Apr 2025. Steam Mostly Positive, ~4.2k reviews, ~73%. Est. ~88k sold.

| Screen | Technique | Duration | Reviews said |
|---|---|---|---|
| Title | Period title treatment; jazz / strings. PROXY | — | Digitec (25 Apr 2025): swing, jazz, Hollywood strings. |
| Hub | Isometric studio-lot diorama — Art Deco buildings, sepia / muted earth, cars on streets, camera from ~100 ft up. Buildings are 2D-iso with 3D-ish extrusion. SOURCED | Persistent scene | Digitec: "studio unfolds like a diorama… Art Deco… soft sepia… cars liven up the streets." Indie Games Substack (19 Feb 2025): "2D isometric buildings, rendered with 3D detail." Game8 (15 Apr 2025): "beautiful, era-specific architecture… from a hundred feet in the air." Cloud Gaming Catalogue (3 Jun 2025): interface "largely static… little to continually impress." |
| List / card cells | Illustrated character cards; art-deco swagger on management panels; small icons under portraits for type/role. Filler events as multiple-choice pop-ups. SOURCED | Pop-up interrupt | Substack: "management menus are crisp and readable while retaining… art deco swagger." Steam review Sharkzy (11 Apr 2025): "tiny icons below portraits" force squinting; casting is click-heavy. YouTube comment on review video (Apr 2025): "I love the clean UI." |
| Time control | Bottom film-pipeline / date bar (conception → release) + fast-forward with snappy SFX. SOURCED | FF is instant-step | Orbital Potato (10 Apr 2025): "down at the bottom… film timeline from conception up until release." Game8: "snappy sound cues when you fast-forward." |
| Transitions | Full-screen prompts + unskippable tutorial/cutscenes. Menu freezes reported. SOURCED | Cutscenes too long (hate) | Game8: "Menu freezes common… QoL (skip animations) nonexistent." Steam Sharkzy: "repetitive cutscenes drag pacing." Outsider Gaming (15 Apr 2025): tutorial forced on every restart. |
| Background motion | Living lot: cars, staff, subtle shadows. Not full video. SOURCED | Ambient loop | Digitec / Game8 praise the lot; Cloud Gaming Catalogue says it goes stale. |
| Button hover / press | Stylised period buttons; no published sheen/spec. Clicks sometimes fail to register in EA. SOURCED (bugs) | — | Try Hard Guides (12 Apr 2025): UI "wouldn't let me click continue." Steam: freeze when balance goes red; long loads. |
| New items on screen | Event cards / scandal pop-ups drop over the lot. Buildings place onto the diorama. SOURCED | Interrupt | Game8: random multiple-choice pop-ups "from your ever-needy cast and crew." |

Praised: lot as a character; art-deco readability; jazz + architecture; clean panels.
Hated: unskippable tutorial; pop-up flood; no skip-anim; EA click/freeze bugs; static lot after the honeymoon; information overload (Cloud Gaming Catalogue, 3 Jun 2025).

## 2. Hollywood Animal lot + tutorial layering
SOURCED. The tutorial is not a separate classroom. It is the first ~year of the live lot:
- Player is dropped onto the isometric studio with the starter buildings already placed (HR / Maintenance / Post / Distribution).
- Full-screen / modal prompts fire on top of the living lot and walk hiring, script, shoot, poster, opening weekend.
- A starter picture ("Limpin Luke" in demo coverage) is the tutorial vehicle — you produce it while the lot stays visible underneath.
- Tutorial is mandatory and long; Outsider Gaming (15 Apr 2025) and Orbital Potato (10 Apr 2025): cannot skip; replays in full on every new save.
- Try Hard Guides and Game8 both asked for a skip. Guides still call it a good mechanics intro — it just overstays and blocks sandbox.

FightCamp map (JUDGEMENT): gym-floor hub as the lot. Tutorial as one real fight-week on that floor, skippable after first completion, never again on new career without a "show hints" toggle.

## 3. Most popular boxing game, and best-reviewed combat-sports management game

### Most popular boxing game on Steam (by owners / money)
SOURCED — Undisputed (Steel City Interactive, 1.0 8 Oct 2024).
- PC Gamer (25 Oct 2024): sold over 1 million copies (studio announcement; some EA copies included).
- games-stats boxing tag ranking: Undisputed ~$18M net, ~19k reviews — far ahead of any other boxing title on revenue.
- Steam rating: Mixed (~58% in list aggregators). Players wanted authenticity + licensed roster; they punished online desync, half-broken netcode, and a career that did not carry the 1M launch.
- Why it sold: only modern licensed boxing sim after publishers abandoned the sport; "aggressively complex" ring feel (PC Gamer). Not a management game.
- Review-score leader in the Boxing tag: The Thrill of the Fight — VR Boxing — Overwhelmingly Positive (~95%, ~4k reviews). Fitness/authenticity, not menus.

### Most popular boxing management game, and why
SOURCED — Punch Club (Lazy Bear / tinyBuild, 8 Jan 2016).
- ~15.8k Steam reviews, Very Positive ~80% (Steambase, Sep 2026). Highest review volume of any boxing manager/tycoon on Steam.
- Kotaku (13 Jan 2016): "Steam's latest hit"; sat on Steam top charts at launch.
- Why players say it worked: life-sim loop you can see (eat / sleep / work / gym / fight) — IGN 15 Jan 2016; Gert Lush 9 Jan 2016 "simple easy to understand UI." Pixel personality + 80s/90s references (praised) vs grind + stat decay + RNG fights (hated; sequel advertised "no more stat decay," PC Gamer 19 Feb 2023). Story branches, not a spreadsheet with a boxing skin.
- Boxing Club Manager (2022): Mixed, 87 reviews, 57%. Closest "run a gym" Steam peer. Hate: shallow tactics, sim-fight lottery, thin content, abandoned-feeling EA (Steam Feb–Jun 2022). Praise: the idea of gym + ringside.

### Best-reviewed combat-sports management game on Steam
SOURCED — Punch Club is still the score + volume champion. Runners that are actually management:

| Title | Score | n | Note |
|---|---|---|---|
| Punch Club | ~80% VP | ~16k | Life-sim boxing tycoon |
| MMA Empire | 79% MP | 24 | Tiny n; text/promotion |
| Pound for Pound demo | 93% Positive | 33 | Demo only, Mar 2026 |
| Boxing Club Manager | 57% Mixed | 87 | Gym + 3D fights, shallow |
| MMA Simulator | 34% Mostly Neg | 29 | Text gym, dead |

There is no high-n, high-score MMA/gym management game on Steam in 2026. That vacuum is the commercial fact FightCamp is walking into.

## 4. Upcoming / EA 2025–26 gym · fighter · MMA · boxing management

| Title | Store | Menus / trailers show | Wishlist / comment asks |
|---|---|---|---|
| Pound for Pound (EA 20 Mar 2026) | store.steampowered.com/app/4289560 | Promo office: sign, contracts, cards, divisions, PPV. Fight engine is sim, not gym-floor 3D. Aug 2026 "Rivals" update adds gyms + scouting. | Depth of living world, rival promotions, styles-make-fights. Demo 93%/33. |
| Cage Empire: MMA Manager (EA 1 Sep 2026) | store.steampowered.com/app/5062590 | Region pick (Vegas / Rio / Dagestan), contract clauses, training camp, round-by-round + live cornering. Spreadsheet + fight feed. | Cornering that matters; grow from club show to brand. Almost no reviews yet. |
| Elite MMA Manager (Q4 2026; demo promised Sep 2026) | store.steampowered.com/app/4496420 | Client-manager (not gym owner): scout, contracts, camps, politics. Dev posts show early profile lists + placeholder UI. | Personality/loyalty, living world. Demo: 10-month cap, one low-tier promo. |
| THE FIGHT BUSINESS: BOXING MANAGER (coming soon) | store.steampowered.com/app/5249680 | Promoter or Trainer+Promoter. Small hall → stadium, broadcast/PPV. | Dual-role (gym + promo) — closest store-copy to FightCamp's gym+bookings loop. No reviews. |
| Boxing School 2 (announced Apr 2025, Steam 23 Apr 2025 per Games Press) | Millendream / Raptor Claw | Ringside between-round calls, gym tree, office, staff specialists. Successor to 2019 Boxing School (~89% VP, small n). | Better combat + gym tree. Treat as lightweight, not Motorsport-depth. |
| MMA Career Simulator (planned 22 Mar 2027) | store.steampowered.com/app/4465410 | Fighter-career, not gym. Training camp + gameplan. | Perks / leagues. Out of FightCamp's owner seat. |
| Also live/adjacent | MMA Empire 2.0 (global cities, 25 rivals, Sep 2026 patch); mobile The MMA Manager Game / BM Ringside (subs, 4.2–4.5★) | Text + lists | Economy bugs, ranking loops, "don't make it a sub." |

Trailer pattern (PROXY across pages): office lists, fighter cards, a timeline/clock, a sim or 3D fight feed. Almost none show a living gym floor as the main menu. That is FightCamp's open lane.

## 5. Adopt / improve / avoid — FightCamp

| # | Technique | Source | Verdict | FightCamp note |
|---|---|---|---|---|
| 1 | Living place-as-hub (HQ campus / studio lot) | MM HQ; HA lot | ADOPT | Gym floor is the menu. Stations, bags, ring, office door — not a dark list. |
| 2 | Looping video / Bink behind chrome | MM frontend .bk2 | ADOPT (quiet) | Slow gym-floor plate or parallax, not a loud trailer loop. Let players kill motion (MM players already do). |
| 3 | Bottom date / pipeline / clock bar, always on | HA film timeline; MM race/HQ clock | ADOPT | FightCamp already thinks in days and fight-weeks. Pin date + camp phase + next bout. |
| 4 | Fast-forward with a sharp tick SFX | HA (Game8, Apr 2025) | ADOPT | One tick per day/hour. Never silent skip. |
| 5 | Modal that pauses a live scene behind it | MM pit planner (RPS, Nov 2016) | ADOPT | Corner / booking / medical sheet over a still-breathing gym or bout. |
| 6 | Rival-relative stats on every cell | MM (RPS preview, Aug 2016) | ADOPT | "Power vs next opponent," not a naked 74. |
| 7 | Art-deco / period material language on chrome | HA panels (Substack, Feb 2025) | IMPROVE | Keep FightCamp charcoal #0B0C0A + acid lime #C6FF3D + paper #F2F4EC. HA's sepia is their era; lime sheen is ours. |
| 8 | Shiny button hover / press | Operator HA sheet; MM mouse-only highlight | IMPROVE | Lime edge-light + 80–120ms press squash. HA never shipped a documented sheen; do the one they implied. |
| 9 | Stagger-in for new cards / bookings | HA event cards; Punch Club map unlocks | IMPROVE | 40–80ms cascade, cap 6 items. After that, snap. HA pop-ups were praised as flavour and hated as flood. |
| 10 | Tutorial layered on the real hub | HA lot tutorial | IMPROVE | First fight-week on the gym floor. Skip after one clear. Never force on new save. |
| 11 | Bottom tab strip, few top-level verbs | MM (GamingTrend, Nov 2016) | ADOPT | Gym / Roster / Office / Card / Fight. Depth lives inside, not in 12 top tabs. |
| 12 | Unskippable cutscenes + unskippable tutorial | HA (Outsider 15 Apr 2025; Game8) | AVOID | Players wrote this in blood. |
| 13 | Pop-up storm / "continue" that doesn't click | HA EA (Try Hard Guides 12 Apr 2025; Steam) | AVOID | Queue events. One modal at a time. Hit-target ≥ 44px. |
| 14 | Spreadsheet with no place | Boxing Club Manager / MMA Simulator reviews | AVOID | Those games had the systems and still lost because the gym never felt like a room. |
| 15 | Stat decay + grind as the loop | Punch Club hate; sequel dropped it (PC Gamer, Feb 2023) | AVOID as daily tax | Recovery/conditioning already exist — don't make the menu a hunger clock. Personality and bookings carry the week. |
| 16 | Video fadeouts between every screen | Operator brief | IMPROVE | 200–350ms fade only hub ↔ fight / hub ↔ office. List ↔ list = instant. HA/MM were not praised for long fades; they were praised for place and clarity. |

## Read this in one line
Motorsport Manager won menus by making HQ a readable place and freezing time until you decide. Hollywood Animal won first glance with a living lot and art-deco chrome, then spent a year getting punished for an unskippable tutorial and pop-ups. Punch Club won Steam boxing-management by making the week visible and the UI small. FightCamp should put all depth on a moving gym floor, keep the clock and the lime sheen, and never trap the operator in a video they cannot skip.

## Sources
Motorsport Manager: Rock Paper Shotgun review, 7 Nov 2016 — https://www.rockpapershotgun.com/motorsport-manager-review-pc · RPS preview, 24 Aug 2016 — https://www.rockpapershotgun.com/motorsport-manager-preview-pc · Eurogamer, 17 Nov 2016 — https://www.eurogamer.net/motorsport-manager-review · SomersF1, 11 Nov 2016 — http://www.somersf1.co.uk/2016/11/review-motorsport-manager.html · Motorsport.com, 11 Nov 2016 — https://www.motorsport.com/gaming/news/motorsport-manager-review-worth-the-wait-848575/ · GamingTrend, 28 Nov 2016 — https://gamingtrend.com/reviews/take-road-watching-to-the-next-level-motorsport-manager-review/ · Stuff.tv, 9 Mar 2017 — https://www.stuff.tv/review/motorsport-manager-review/ · RaceFans, 7 Nov 2016 — https://www.racefans.net/2016/11/07/motorsport-manager-the-f1-fanatic-review/ · PCGamesN, 10 Aug 2016 — https://www.pcgamesn.com/motorsport-manager/motorsport-manager-gameplay-details-f1 · Playground.ru, 16 Nov 2016 — https://www.playground.ru/motorsport_manager/opinion/dolgo_dorogo_i_kruto_retsenziya_na_motorsport_manager-452906 · Steambase reviews snapshot, Sep 2026 — https://steambase.io/games/motorsport-manager/reviews · NamuWiki (frontend .bk2 note) — https://en.namu.wiki/w/모터스포츠%20매니저

Hollywood Animal: Steam / Steamproxy store, EA 10 Apr 2025, app 2680550 · Steambase + Raijin review/sales snapshots, Sep 2026 — ~4.2k reviews, ~73%, ~88k sold · Digitec, 25 Apr 2025 — https://www.digitec.ch/en/page/hollywood-animal-the-glitz-sleaze-and-glamour-of-tinseltown-37695 · Game8 EA review, 15 Apr 2025 — https://game8.co/reviews/hollywood-animal/hollywood-animal-review-early-access · Try Hard Guides EA review, 12 Apr 2025 — https://tryhardguides.com/hollywood-animal-early-access-review/ · Outsider Gaming guide, 15 Apr 2025 — https://outsidergaming.com/hollywood-animal-guide-strategies-how-to-make-money/ · Indie Games Substack, 19 Feb 2025 — https://indiegames.substack.com/p/movie-mogul-hollywood-animal · Cloud Gaming Catalogue, 3 Jun 2025 — https://www.cloudgamingcatalogue.com/2025/06/03/hollywood-animal-review-a-blockbuster-experience-or-a-straight-to-dvd-flop/ · Steam user Sharkzy, 11 Apr 2025 — UI overload / tiny icons / cutscenes · Orbital Potato gameplay, 10 Apr 2025 — lot + bottom timeline + unskippable tutorial

Boxing / combat management: Punch Club Steam — https://store.steampowered.com/app/394310/Punch_Club/ · Steambase Punch Club reviews, Sep 2026 · Kotaku, 13 Jan 2016 — https://kotaku.com/steams-latest-hit-has-you-manage-a-starving-kickboxer-1752552389 · IGN, 15 Jan 2016 — https://www.ign.com/articles/2016/01/15/punch-club-review · Gert Lush, 9 Jan 2016 — https://gertlushgaming.co.uk/review-punch-club-steam/ · PC Gamer Punch Club 2 / stat decay, 19 Feb 2023 · PC Gamer Undisputed 1M sales, 25 Oct 2024 — https://www.pcgamer.com/games/sports/the-boxing-game-that-only-exists-because-most-big-publishers-wont-touch-the-sport-has-now-sold-over-a-million-copies/ · Steambase / games-stats boxing tag rankings · Boxing Club Manager Steam, Mixed 87 reviews — https://store.steampowered.com/app/1652490/Boxing_Club_Manager/ · MMA Simulator Steam, Mostly Negative 29 — https://store.steampowered.com/app/913820/MMA_Simulator/

Upcoming 2025–26: Pound for Pound — https://store.steampowered.com/app/4289560/Pound_for_Pound/ · Cage Empire: MMA Manager — https://store.steampowered.com/app/5062590/Cage_Empire_MMA_Manager/ · Elite MMA Manager — https://store.steampowered.com/app/4496420/Elite_MMA_Manager/ · THE FIGHT BUSINESS: BOXING MANAGER — https://store.steampowered.com/app/5249680/THE_FIGHT_BUSINESS_BOXING_MANAGER/ · MMA Empire — https://store.steampowered.com/app/4201270/MMA_Empire/ · MMA Career Simulator — https://store.steampowered.com/app/4465410/MMA_Career_Simulator/ · Games Press, Boxing School 2, 18 Apr 2025

Tags used in body: SOURCED / PROXY / JUDGEMENT as marked.

## Claude's collection note (S79)
- Row 7's palette (charcoal + acid lime + paper) is Grok's JUDGEMENT and conflicts with M34's four directions; the operator's pick among M34 A-D governs the palette, not this row.
- Row 16 agrees with M34's transition amendment (cinematic only hub <-> fight night, lists instant) - adopt.
- Section 2 (tutorial layered on the real hub, skippable, never forced on a new save) matches the S78/S79 CoachMarks design (SKIP, F1 replay, starts once per profile).
