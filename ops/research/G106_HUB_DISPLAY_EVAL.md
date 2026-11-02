<!-- Grok (grok.com, Expert, in-app browser), collected verbatim by Claude S81 2026-09-25 from
https://grok.com/c/18d28657-d467-4424-bd2a-5a099d969aed . Screenshots could NOT be uploaded (local-server route refused);
Grok was told so and worked from a text description. Footnote link markers dropped; "120 sources" in the original. -->

A real management-game UI lead would treat HOME as a state instrument, not a render target: the picture must change with roster size, station occupancy, and upgrades, and fight-night 3D stays on fight night. They would ship the cheapest state-readable slice, then measure whether anyone still looks at the floor after hour 5.

# G106_HUB_DISPLAY_EVAL

Research memo. Claims dated and sourced. Inferences marked UNSOURCED.

## What players actually do with a hub

**Two Point Hospital / Campus (live isometric rooms).** Press praised watching the building: GamesRadar (30 Aug 2018) said you can play zoomed-out on queues, then zoom in for treatment gags. PC Gamer hands-on (9 May 2018) said zooming into janitor/treatment detail "makes your hospital… feel more real." Sega-Mag (21 Sep 2026) still called watching the little world "vraiment agréable," then noted it is "presque dommage" you spend so much time in menus. Steam: Hospital ~92/100 from ~35k reviews (Steambase, 24 Sep 2026); Campus ~88/100, ~8.2k reviews (Steambase, 23 Sep 2026). Campus complaints cluster on late-game repetition and "performance issues with large numbers" / Steam Deck (VaporLens, 4 Apr 2026). Official forums (17–21 Sep 2026) report laggy staff lists and pathfinding on the Full Health Collection. Read: animation is loved when the floor is the game (layout, queues, prestige). Even then, veterans live in overlays.

**Mad Games Tycoon 2 (3D isometric office, walking staff).** Steam user Legolas_Katarn (28 Jun 2023): fun if you chase numbers and "watch your office grow"; models/décor lack personality and that "hurts." Generación Pixel (6 Jun 2023) called furniture/animations "agradable," not spectacular. Read: growth of the room is the hook; looping desk work is not.

**Game Dev Tycoon (mostly static offices).** Destructoid (10 May 2013): production values "neither get in the way or make much of an impression"; AVForums (14 Oct 2013): "graphically underwhelming." The game still sold on systems. Read: a plain hub is tolerated if the loop is sharp; it does not create attachment.

**Football Manager (menu hub + decorative plates).** r/footballmanagergames (19 Aug 2024): "useful information takes up 10% of screen, the background is totally unnecessary distraction." SI forum on the FM26 portal (12 Nov 2025): players click away from the pretty hub every day to reach the inbox. Read: management players treat scenery as waste unless it carries data.

**Motorsport Manager / F1 Manager (HQ as upgrade tree; spectacle on the race).** Wccftech (16 Nov 2016): late-game "running of the team can become stale… no more HQ improvements." F1 Manager 2024 reviews call the product menu-heavy; TheSixthAxis (29 Jul 2024) and Impulse Gamer (21 Aug 2024) put the visual win on broadcast race cameras, not HQ — Impulse even saw HQ menus drop into the 30s fps. Read: spend 3D budget on the event, not the office.

**Hollywood Animal (authored lot + event anims).** NeonLightsMedia (6 Oct 2025) and Try Hard Guides (12 Apr 2025) praise atmosphere and detail; both flag bugs, load times, and (elsewhere) unskippable event anims that break rhythm. Steam ~73/100 from ~4.2k reviews (Steambase, 25 Sep 2026). Read: a beautiful lot helps once; forced motion is hated.

**Punch Club 1 / 2 (pixel rooms, training as a loop).** TouchArcade (22 Jan 2016): every screen "a masterpiece"; IGN (16 Jan 2016) still quit on grind. Punch Club 2: VaporLens (21 Jul 2025) — art/atmosphere praised (~34% of positive points); "excessive and unrewarding grind" dominates negatives. StopGame comments (30 Jul 2023) describe hours "watching pixels train." Read: authored stills work; watching the same exercise does not stay a toy.

**Undisputed career (3D fighter game, menu gym).** IGN (7 Oct 2024): no training minigames, missed chance to hit the bag. Gaming Trend (7 Oct 2024): training is "hitting the X button on menus." Push Square (13 Oct 2024): career is "far too dry"; "text-based presentation lacks pizazz." Shacknews (7 Oct 2024): "lesson in accounting." Read: owning a 3D fighter engine and not using it in career is a quoted complaint — but reviewers asked for interactive training, not an idle 3D wallpaper of NPCs jogging.

**Does watching staff stay engaging after hour 5?** Evidence says: only if occupancy/layout is a decision surface (Two Point). Otherwise it becomes ignored chrome (FM plates, Punch Club grind, Undisputed menus). **Does a static hub read cheap?** Only when it does not change with state. Game Dev Tycoon's bland offices were called cheap and the game still worked; an empty gym that looks identical at 3 and 30 fighters is the cheap tell (current FightCamp state, per operator brief — not independently viewed). **Performance:** yes, populated animated hubs and fat staff lists hitch on modest machines (Two Point Campus/FHC; F1 Manager HQ menus).

## Cage Legacy (app 5002990)

Steam store (retrieved 25 Sep 2026): Cage Legacy, solo dev Werner Viljoen, full release March 2027, demo live, no user reviews. Pixel-art gym management; fights in a "stylised 2.5D octagon" with corner orders and speed controls. Store discloses pre-rendered gen-AI pixel assets (portraits, venues, facility scenes), edited by the developer; no runtime AI. Dev Reddit post (4 Aug 2026, r/playmygame, reddit.com/r/playmygame/comments/1vfiu24): 20-turn demo, Steam median session ~11 minutes; later extended to 60 weeks / ~25 min after players finished rather than bounced. Press coverage of this title: none found as of 25 Sep 2026. Nearby names (Cage Empire app 5062590, itch.io "Cage Legacy" by Bobin03) are different products. Read: the listed competitor is betting on cheap consistent pixel stills + a 2.5D fight toy, not a live gym sim. No public hate or praise of "GYM CAM" banners exists yet — UNSOURCED if we claim players like or hate that banner.

## 1) A / B / C against that evidence

| Option | Fit to reception |
|---|---|
| A. Stills + tier variants | Matches Punch Club / GDT / Cage Legacy: art can carry a gym if rooms upgrade. Fails if the plate is one empty shot forever (FM "wasted background"). |
| B. 2.5D tiled rooms | What Two Point / MGT2 players praise — because those games are builders. FightCamp's core toy is camps, bookings, corner, 3D fights, not laying toilets. Building a second game. |
| C. Live 3D gym with real rigs | Undisputed players wanted to do training, not watch it. Two Point-style watching only pays if you also own layout/pathing/AI. Puts fight-rig cost on a screen players will click through after hour 5. |

## 2) Risks
- **A:** "AI poster over chrome" reads unfinished if occupancy never changes; competitor already ships pixel stills, so sameness is a store-page problem. Risk is stasis, not stills.
- **B:** Year of tile/pathing/furniture work. Campus-class lag at 30 fighters. Splits identity from the 3D fight USP. Players may still live in menus (Sega-Mag).
- **C:** Highest cost, highest hitch risk, lowest proven dwell. Idle loops on real rigs look worse than stylised 2.5D when animation budget is thin (UNSOURCED engineering judgment). Steals cycles from fight broadcast, which is where F1 Manager / Undisputed actually get credit.

## 3) One recommendation + first slice

**Do A with state, not C and not a Two Point rebuild.** Keep stills. Make HOME a dashboard of the gym you already simulate.

First slice (one session):
- Three authored plates: sparse / working / packed (or the existing plate with three occupancy grades). Swap on fighter-count and upgrade flags you already store.
- Existing clickable pins gain live badges: N at bag, N in ring, N in office, injured/medical hold mark.
- No new locomotion, no second art pipeline.

**Prove it right:** after a 6–8h playtest, HOME time after hour 5 is still mostly clicks on pins that changed, and testers can answer "how busy is the floor?" without opening FIGHTERS.

**Prove it wrong:** HOME dwell collapses to <5s transit; testers say the plate is still "the same empty gym"; they ask to skip it. Then stop decorating and route HOME to a list.

Do not spend the 3D engine on idle bag-work until a peek-cam on one assigned station beats the still+badge in that test. Spectacle belongs on fight night. Cage Legacy is not beating anyone on gym cinema; it is shipping a readable, cheap, consistent page. Match that discipline, then spend 3D where reviewers already look.
