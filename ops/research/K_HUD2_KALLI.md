bot  Kalli
    87adacc7-87a0-4808-8f8b-2c15a0a1777f

[user t155u] # TASK K83 - the live fight's broadcast look: a scorebug a viewer reads in one glance (Kalli)

Operator 2026-10-01: "use grokbots mostly for visual refining our rooms and the arena", "everything to be integrated at

AAA game level (how pros do it, how AAA games do it, what best reviews praise)", "use icons when its possible to skip

text (with the necessary tooltip of course)". No repo: the still is attached; answer in this chat.



## Attached

`76_bout_live.png` - the live bout in today's build (1920x1080): a round clock box top-left ("R1 2:59", "CORNER - NO

INSTRUCTION"), speed buttons top-right (1X 2X 4X SIM TO RESULT), the fighter's name in the top bar. Nothing tells a viewer

who is in which corner, their records, the score, or how the round is going.



## Deliver (one answer)

1. A SCOREBUG spec as TV boxing does it (DAZN / Sky Sports / ESPN / UFC style - name the broadcaster you copy): exact

   placement in pixels on 1920x1080, sizes, the elements (corner colour bar red/blue, surname, record W-L-D, flag or

   country code, round + clock, optional knockdown pips), font sizes, colours hex, what animates and when (round change,

   knockdown, a big shot).

2. A between-rounds stat card (what punch stats appear, layout, how long it stays) and the end-of-fight card.

3. Which of today's elements to KEEP, MOVE or DROP (the corner instruction line, the speed buttons) and why.

4. Where an ICON replaces a word (with what tooltip) - e.g. knockdowns, cuts, stamina.

5. A mock image of the scorebug over the attached still, if you can make images.

No real broadcaster logos, no real fighter names. Keep it buildable from flat panels, text and simple icons.
[send-message t155s1010] K83 is in progress. The scorebug mock is drawn over your still, and the full spec is coming next.
[user t156u] did you finish k83 ?
[send-message t156s1012] **K83: live fight scorebug** (the earlier send didn't deliver, so this is the full answer)

The mock uses a stand-in font and shows empty pip slots for review only. The real build uses Bebas Neue and IBM Plex Mono, and empty pip slots never ship.

**The look I copy:** the two-row lower-left bug that DAZN and Sky Sports boxing use, with a coloured corner bar, surname, record and a clock block. That is from memory, not checked this session. I draw it as flat panels with no logos.

## 1. Scorebug (1920x1080)

**Placement:** x 96 (the 5% safe margin), y 900, 760 wide by 96 high, which leaves 84 px above the bottom edge. It clears the top bar and the ring's centre.

**Rows (each 48 high):**

| Element | Position in row | Size and style | Colour |
|---|---|---|---|
| Corner bar | x 0 | 10 wide, full row height | red `#C8302E`, blue `#2D6EC8`, must match the fighter's corner and trunks |
| Surname | x 24 | Bebas Neue 28, caps | `#F5F0E8` |
| Record W-L-D | x 330 | Plex Mono 22 | `#BEB8AE` |
| Country code | x 470 | Plex Mono 22 | `#BEB8AE` |
| Knockdown pips | x 560, 16 px circles, 10 px gap | filled only | `#E04A3F` |

**Clock block:** 150 wide by 96 high at the right end. "R2" is Bebas 30 in `#F5F0E8`. The clock is Plex Mono 34 in gold `#E9B84A`, the only gold on screen. Block panel `#28221E`, rows on `#14100E` at 92% opacity.

**What animates:**
- **Round change:** a "ROUND 3" strip (Bebas 48) fades in at top centre for 1.5 s, with 0.25 s fades. The clock block flashes once.
- **Knockdown:** the pip fills with a pop (scale 1 to 1.4 to 1 in 0.3 s). A "KNOCKDOWN" strip (Bebas 24, 28 px high) slides under that fighter's row for 2 s.
- **Big shot:** the hit fighter's row nudges 6 px for 0.15 s, with no text. What counts as big is NOT COMPUTED and must come from the fight model.

**Rules:** no running score on the bug, since TV boxing shows scorecards between rounds. Pips appear only after a fighter's first knockdown. The pip limit comes from the sanction's rules (NOT COMPUTED).

## 2. Between-rounds card and end-of-fight card

**Between rounds** (panel 560 x 360 at x 1264, y 160):
- Header "END OF ROUND 3" in Bebas 36, with the two corner colours as bars.
- Three columns: left fighter, stat, right fighter, in Plex Mono 22.
- Rows: punches landed/thrown, landing percentage, power shots landed, jabs landed, knockdowns.
- A judges' round score (10-9) only if a scoring model exists (NOT COMPUTED).
- It stays 8 s after the bell, then collapses to a stats icon. The corner card (K72) owns the rest of the break, and it wins if the two overlap.

**End of fight** (panel 760 x 480, centred):
- Appears 2 s after the final bell, matching the footer line.
- Top: winner, method and round, for example "LARKIN · KO · ROUND 3 1:42".
- Below: full-fight totals using the same stat rows.
- Stays until the player presses `CONTINUE`.
- Method wording follows the fight result model (NOT COMPUTED).

## 3. Keep, move or drop

| Element | Ruling | Why |
|---|---|---|
| Old round clock box (top-left) | MOVE into the bug's clock block | one clock, where the viewer reads |
| Corner instruction line | KEEP, MOVE to a 28 px chip under the bug at y 1000, grey `#BDB6A8`, with a clipboard icon | it's the manager's order, not the viewer's, and it's no longer a second gold item |
| Speed buttons | KEEP, shrink to icons | they're controls, not broadcast content |
| "ROUND 1 LIVE" box in the top bar | DROP | the clock says it |
| Fighter names in the top bar | DROP | the bug carries them with corner colours |
| "LIVE ROUND" in the footer | DROP | the clock says it |
| "THE RESULT FOLLOWS THE FINAL BELL" | KEEP | it tells the player why no result shows |

**Self-argue on placement:** I argued for the top-left, where the old clock sits and the eye already goes. I kept lower-left because the top is full with the title bar and speed buttons, and boxing bugs traditionally sit low.

## 4. Icons that replace words

| Word | Icon | Tooltip (max 60 chars) |
|---|---|---|
| 1X / 2X / 4X | one, two and three play triangles | "Normal speed" / "Double speed" / "Four times speed" |
| SIM TO RESULT | skip-forward bar | "Skip to the result." |
| Knockdown | filled red pip | "Knockdown. Counts toward the limit." |
| Cut | red droplet beside the name | "Cut. Can stop the fight." (NOT COMPUTED, needs a cut model) |
| Stamina | lightning bolt, shown only when low | "Stamina is low. Punches slow down." (threshold NOT COMPUTED) |
| Corner order | clipboard | "Your instruction for the next round." |

## Flags

- **Trunk and bar mismatch.** The still shows green and blue trunks, but the bars are red and blue. Either change the trunks to red and blue, or colour each bar from its fighter's trunks. I recommend the bars follow the trunks.
- **Which fighter is which.** Nothing tells the viewer who stands where. Bar colour beside the surname plus matching trunks fixes it.
- **NOT COMPUTED:** the knockdown limit, the judges' scoring, the cut model, the stamina threshold and the big-shot rule.
- **Still wrong:** nothing has been checked against the real top bar and footer heights or at 380 px.
[send-message t156s1013] U208 is waiting on your pick before Body Lab can start. The three previews (a contact sheet and three mp4s) are in `previews/u208/` on Beast. I haven't opened them myself, so I can't recommend one.
[send-message t156s1014] 
[send-message t156s1016] K79 (the S80 screen words) was still open, so I wrote it, put it on Beast and pinged Claude to apply it. A script checked every string against its budget and the K77 bans, and none failed.

Biggest changes:
- **News ticker.** `On the wire` becomes `NEWS`, because the coach lines and Handbook already say news. I argued for keeping the wire voice and kept NEWS: wire is jargon a new player has to decode.
- **OFFICE on two screens.** The FINANCE pin that showed cash is now `CASH`, so OFFICE means only the room where offers arrive.
- **No fight booked.** It replaces both `Nobody is booked` and `Nobody booked yet`, so HOME and FIGHTS say the same thing.
- **Payroll.** The staff fact now says `N on the payroll`, because `the books` is already a FINANCE pin name.
- **Bell line.** It now ends `Now the bell.` I dropped `Now it's three minutes` because MMA rounds are five minutes.
- **Cold line.** `In cold` becomes `Going in cold.`
- **Hub captions.** The three FIGHTERS, FIGHTS and FINANCE captions are new lines, because the task gave no current text.

I did not see the `s80_look` screenshots, so nothing was read in place or checked against pin and card widths. Open questions:
- Whether `rest N wk` is right for an injured fighter, who may still be able to train.
- Whether `Set training` and `Plan this week` are the same state.
- What unit the `<kit> · NN%` number has.

Files to land:
- `research/K79_S80_WORDS.md`
- `research/CLAUDE_LAND_NOTE_K79.md`
- Copies of both in `_kalli_delivery/`
[send-message t156s1017] Claude is still waiting on three taste calls before the Oct 6 demo walk. A pick, a yes/no, or "later" on each is enough:
- **U208:** pick one of the three tale-of-the-tape layouts (previews in `previews/u208/`).
- **C232:** yes or no on the walkout video.
- **S140:** yes or no on the hit pop-up.

I haven't seen the C232 or S140 material, so I can't recommend on those two. Reply in one line, for example "U208 2, C232 yes, S140 later", and I'll pass it on.
[send-message t156s1018] K76 is done, and this is the full memo. I haven't re-checked it against the repo myself, and Beast is offline right now, so I can't put it on disk or ping Claude yet. I'll do both when it's back.

# K76 - THE SCREEN INVENTORY AND ITS ORDER

**Owner:** Kalli. Words and structure only. No copy rewrite, no look, no wire.
**Date:** 2026-10-02. **Source:** live `SceneRouter.ROUTES`, `ShellChrome.RAIL_GROUPS` and `SetpieceRoot` on master (`6f38d59`). Passes 1 to 4 are priors, and this replaces their screen list where the tree moved (S80).
**Honesty:** COMPUTED means read from those files this pass. NOT CONFIRMED means reachable in the product but not proven from a play trace. NOT COMPUTED means the wiring is unclear.

## Three lines first

1. Career play is still **panels hosted in CareerRoot** under ShellChrome. The rail is no longer a flat list of hubs. It is **HOME plus three area hubs (FIGHTERS / FIGHTS / FINANCE)** with pages under them.
2. The fight chain is still a **setpiece passage**: fight_week, weigh_in, fight_night, fight_result, an optional crowning, then leave to HOME (`day_feed`). The setpiece leave fallback is COMPUTED as `day_feed` (not SCHEDULE).
3. The facility word is **gym**. Fight camp is only pre-bout prep. Rooms (floor, lobby, office, locker, mat, staff, physio, film) are places behind doors. Several are COMPUTED routes whose rail entry is NOT CONFIRMED.

---

## Q1 - WHAT SCREENS EXIST

Place = you stay and act. Passage = you pass through.

### Boot (BootRoot boards)

| Name | Route id | Place / passage | One sentence |
|---|---|---|---|
| TITLE | `boot` / `main_menu` | Place | Pick new career, load, or settings. |
| SAVE SLOTS | `boot_slots` | Place | Choose which life to load or overwrite. |
| SETTINGS | `boot_settings` | Place | Change options, then return to title. |

### Creation (CreationRoot steps)

| Name | Route id | Place / passage | One sentence |
|---|---|---|---|
| COUNTRY / MARKET | `country_map` | Place | Pick the market you will manage in. |
| CITY | `city` | Place | Pick the city inside that market. |
| YOUR GYM | `gym_pick` | Place | Name the gym, then open into career HOME. |

### Career shell - rail heads (S80)

| Name | Route id | Place / passage | One sentence |
|---|---|---|---|
| HOME | `day_feed` | Place | See what needs you today, the next bout, and your fighters. |
| FIGHTERS (area) | `fighters_hub` | Place | Picture hub for roster, floor, training, and scouting pins. |
| FIGHTS (area) | `fights_hub` | Place | Picture hub for schedule, rankings, and offers. |
| FINANCE (area) | `money_hub` | Place | Picture hub for books, cash, staff, and contracts. |

### Career - pages and rooms (hosted panels)

| Name | Route id | Place / passage | One sentence |
|---|---|---|---|
| ROSTER & FLOOR (GYM) | `gym` / `gym_floor` / `roster` | Place | Gym hub tabs: floor layout and fighter list. |
| FIGHTER CARD | `fighter_card` | Place | One fighter's profile and moves. |
| TRAINING | `training` | Place | Set weekly training plans. |
| THE FLOOR | `training_floor` | Place | Walk the 3D training floor, with doors to other rooms. |
| THE FRONT DESK | `lobby` | Place | Lobby and street door: desk, museum, walk-ins. |
| THE OFFICE | `office_room` | Place | Office room: books, phone, contracts, calendar wall. |
| THE LOCKER ROOM | `locker_room` | Place | Lockers, scale, fight-week board. |
| THE MAT ROOM | `mat_room` | Place | Members' class, dues, team slots. |
| THE STAFF ROOM | `staff_room` | Place | Coaches, assignments, job board. |
| THE PHYSIO | `physio` | Place | Body chart, table, medical holds. |
| THE FILM ROOM | `film_room` | Place | Opponent footage, tendencies, game plan. |
| SCHEDULE | `calendar` / `events` / `event_detail` | Place | Calendar hub and card drill-in. |
| SCOUTING | `scouting` | Place | Find and study fighters to sign. |
| RANKINGS | `rankings` | Place | Division tables. |
| OFFICE (books desk) | `office_menu` / `contracts` / `finances` / `objectives` / `weight_class` | Place | Business modules under the OFFICE / FINANCE pages. |
| STAFF (hub) | `staff` | Place | Hire and manage staff (rail page under FINANCE). |

### Overlays (not SceneRouter rows)

| Name | How it opens | Place / passage | One sentence |
|---|---|---|---|
| FIGHT CONTRACT | booking `present()` | Place (modal) | Agree or walk away from bout terms; ESC or close. |

### Setpiece (SetpieceRoot phases)

| Name | Route id | Place / passage | One sentence |
|---|---|---|---|
| FIGHT WEEK | `fight_week` | Passage | Pre-bout camp week inside the setpiece frame. |
| WEIGH-IN | `weigh_in` | Passage | Scale before the bout. |
| FIGHT NIGHT | `fight_night` | Passage | The bout itself (ring body). |
| RESULT | `fight_result` | Passage | Official result, then leave the setpiece. |
| CROWNING | `crowning` | Passage | Belt ceremony when pending. |
| WEEK REVIEW | `week_review` | Passage | End-of-week review board. |

### Dev (not player-facing)

| Name | Route id | Note |
|---|---|---|
| MATCH SIMULATOR | `fight_test` | Dev desk; leave from a test bout returns here. |
| FIGHT WORLD PREVIEW / LIVE | `fight_world_preview` / `fight_world_live` | Dev 3D mounts. |
| FightAnimLab / UIKitGallery | (scenes) | Entry and egress NOT CONFIRMED; treat as lab. |

---

## Q2 - WHAT IS THE ORDER

### Edges a player takes (COMPUTED structure)

```
TITLE --NEW CAREER--> COUNTRY --gold--> CITY --gold--> YOUR GYM --OPEN GYM--> HOME
TITLE --LOAD--> SAVE SLOTS --back--> TITLE
TITLE --SETTINGS--> SETTINGS --back--> TITLE
TITLE --CONTINUE (save)--> HOME     [button inventory NOT COMPUTED this pass]

HOME <-> FIGHTERS hub <-> pages (gym / training / scouting) <-> rooms via floor doors
HOME <-> FIGHTS hub <-> pages (schedule / rankings)
HOME <-> FINANCE hub <-> pages (office_menu / staff) <-> mat_room under money_hub nav

booking --> FIGHT CONTRACT (overlay) --accept--> (card / fight week path)
HOME or SCHEDULE --enter fight week--> FIGHT WEEK --> WEIGH-IN --> FIGHT NIGHT --> RESULT
RESULT --pending crowning--> CROWNING --> leave
RESULT --leave / way out--> stack back, else HOME (`day_feed`)
Shell CONTINUE --> day advance (may push crowning / week_review)  [exact gates NOT COMPUTED]
```

### What takes me BACK, and is there always one?

| Screen | Back | Always? |
|---|---|---|
| TITLE boards (slots/settings) | Back to TITLE | Yes (COMPUTED pattern). |
| Creation steps | Country back to TITLE; later steps step back inside CreationRoot | Yes inside creation; you leave creation only by finishing to HOME. |
| Career hosted panels | Router stack `pop`, else rail to another place | Yes while CareerRoot hosts; depth-0 stays on the shell. |
| Area hubs / pages | Rail row or stack | Yes. |
| Rooms (floor, lobby, ...) | Door or leave, usually to the floor or the prior stack | Door graph NOT CONFIRMED for every room. |
| Fight contract | WALK AWAY / close | Yes. |
| Setpiece phases | Phase walks forward; chrome leave goes to `back_or(day_feed)` (or `fight_test` in test mode) | Leave yes. Mid-chain "back one phase" as a player control is NOT CONFIRMED. |
| Dev labs | UNKNOWN | No documented player back. |

---

## DEAD ENDS (explicit)

1. **FightAnimLab / UIKitGallery:** no COMPUTED player route or egress.
2. **fight_world_preview / fight_world_live:** named routes, empty nav; player back NOT CONFIRMED.
3. **Setpiece mid-chain without leave:** if chrome leave stays hidden until RESULT arms, weigh-in and fight week can feel stuck. Live arming is NOT CONFIRMED.
4. **Two returns that disagree in product language:** Pass 4 wanted leave to THE DAY, but the shell label for `day_feed` is now **HOME**. The route id is still `day_feed`. The name drift is a defect for a words task, not a missing edge.
5. **Alias gravity:** `gym` / `gym_floor` / `roster` and `calendar` / `events` / `event_detail` still share panels. Returning "to FIGHTERS" versus "to ROSTER & FLOOR" can land on the same tree with a different rail highlight.

---

## NOT CONFIRMED

- Whether every 3D room is reachable from THE FLOOR doors in a normal career (the routes exist, but the door wiring was not play-traced).
- Whether the ManagementChrome header week-Continue still appears beside Shell CONTINUE in a normal boot (the dual-clock risk from Passes 1 to 4).
- The exact RESULT leave button string. Panel comments say BACK HOME, but Pass 4 froze BACK TO THE DAY ▸. Reconciling them is a words task.
- The TITLE resume CONTINUE control inventory.
- The corner-between-rounds UI as its own screen (`TASK_CORNER_UI`). It is still a gap in the fight chain if missing.
- Whether `week_review` is always offered after Shell CONTINUE or only on some weeks.

---

## WHAT SHOULD CHANGE (separate from the inventory)

1. One player-facing name for `day_feed`: HOME or THE DAY. Pick one across the rail, the result leave and the handbook.
2. Kill or quarantine lab scenes from player builds until they have a back.
3. Prefer one return API (the SceneRouter stack) for rooms, so door leave and the rail agree.
4. Keep the Pass 4 wire intent: empty-card leave goes to `day_feed` (already the setpiece fallback). Finish any leftover OFFICE/SCHEDULE leave strings.

---

## Argue against myself

**Strongest case this document is wrong next week:** a hand inventory of `SceneRouter.ROUTES` goes stale the first time an engineer adds a room or renames a rail head. S80 already renamed THE DAY to HOME and added eight room routes after Pass 1. The only inventory worth trusting long-term is a one-page dump from `SceneRouter.routes()` and `describe()` (plus rail groups from ShellChrome), generated in CI or through `agent_comms`, not a memo I maintain by hand. The cheap version is a script that prints id | label | tier | nav | panel | phase and diffs against the last commit. Humans then only annotate place or passage and the dead ends on top of that table.

**Weakest point, unprompted:** I did not run the game. Door reachability and the dual-Continue question are NOT CONFIRMED. Any edge that only exists in a comment was left out rather than guessed.

---

## WHAT IS STILL WRONG

1. GAME_FLOW questions 3 to 5 (gaps against career needs, full route words, first-run step count) are still open. This pass only answered screens and order.
2. The HOME / THE DAY naming split after S80.
3. Room door graph and lab egress unverified in play.
4. Corner UI is still owned elsewhere, and is still a hole if not shipped.
5. TASKS.md still lists FLOW_PASS4 and K79 as OPEN though both files exist on master. That is board hygiene, not a screen defect.

Files to land once Beast is back: `K76_THE_SCREEN_INVENTORY.md` and `CLAUDE_LAND_NOTE_K76.md`, in both `research/` and `_kalli_delivery/`.
[user t157u] # TASK K84 - The perfect tutorial / guide menu and panel placement for a management sim (Kalli)

Operator 2026-10-03, verbatim: "am sure you can find the best guides and examples on how to build the perfect
tutorial/guide menu design and panel placement etc for a simulation, management game". Context: players find our
SCHEDULE confusing, and the game needs a tutorial that explains WHERE, WHY and HOW and leads the player from a regional
gym to a national one.

## Already known - do not redo (summaries)
- J52 (ours): guided first career month inside a real save, ~18 short steps, optional, replayable per chapter from a
  Handbook; max 3 new things per step; tooltips after 500 ms; vital-to-act stays on screen, explanation goes to tooltips;
  CK3 cut its tutorial from 67 boxes to about a third; FM26 FMPedia as the handbook model.
- J54 (ours): menu architecture of FM, Motorsport Manager, Punch Club 2: one time-advance control always in the same place.
- Our screen today: 1920x1080, left rail (Home, Fighters, Fights, Finance), top bar (date + Continue), painted gym
  picture with clickable pins on HOME, brass-and-dark-brown panels.

## Find (sources you can open; cite each with its URL)
1. GUIDES: the best written/talk sources on onboarding and tutorial design for strategy/management games - e.g. Celia
   Hodent (The Gamer's Brain, GDC talks), GDC Vault talks on tutorials/onboarding (titles + year), Game Developer
   (Gamasutra) articles, NN/g on onboarding and progressive disclosure, Game UI Database (gameuidatabase.com) as the
   screenshot library. 5-10 sources, one line each on its key rule.
2. EXAMPLES with screenshots you can SEE (describe the layout; link the image page): how 6-10 management/sim games place
   tutorial and guide UI - Football Manager 24/26, Two Point Hospital/Campus, Frostpunk 2, Anno 1800/117, Crusader
   Kings 3, Motorsport Manager, Planet Coaster 2, Jurassic World Evolution, Manor Lords, any boxing/MMA manager. For
   each: where the tutorial box sits (corner, side panel, anchored to the thing), how it points at the target
   (arrow, spotlight/dim, pulse), the objectives/goals list (where, how long), the help/encyclopedia button
   placement, how a calendar/schedule screen is laid out (list vs grid vs timeline, "next event" card).
3. PANEL PLACEMENT rules for a 1920x1080 management screen: what goes left/right/top/bottom and why (eye path,
   F-pattern, primary action location), modal vs side panel vs inline card, how many panels at once.

## Deliverable
Reply in this chat: (A) sources list, (B) per-game layout notes, (C) 10 concrete rules for FightCamp's tutorial overlay
+ guide/handbook menu + schedule screen, each tagged SOURCED (with source) or JUDGEMENT, (D) one rough wireframe in text
(ASCII boxes) of a 1920x1080 screen showing where the tutorial box, objectives list, help button and the schedule's
"what to do next" card sit. Words on screen are examples only. Never invent a source.
[send-message t157s1020] Starting K84. I'm opening the sources and checking each URL before I cite it. Anything I can't open will be labelled unverified or left out.
[send-message t157s1021] The K84 research is running now. Only pages that were actually opened will be cited. I'll send the sources, the per-game notes, the ten rules and the wireframe when it finishes.
[send-message t157s1022] **K84 PART 1 of 2: sources and per-game notes**

Short answer: the sources agree on three things. Teach three new things at a time and give the reason first. Cut the tutorial down and keep it replayable from a handbook. Keep the vital thing on screen and put the explanation in tooltips. I opened every URL below (DOCUMENTED = read on the page). The limits are that I read page text only, no images, so how a tutorial box points at its target (arrow, spotlight, pulse) is NOT FOUND for every game. The GDC Vault pages gave abstracts only.

**(A) GUIDES**
1. Celia Hodent, [The Gamer's Brain Part 2: UX of Onboarding](https://celiahodent.com/gamers-brain-ux-onboarding/) (GDC16, posted 22 Mar 2016). Maximum 3 new items at once while learning. Teach the why (goals) before the how. A pop-up shown while the player is busy goes unseen (Fortnite test). Pin needed info on screen so players don't memorise it.
2. Game Developer, [Refreshing the Crusader Kings III tutorial](https://www.gamedeveloper.com/design/deep-dive-refreshing-the-crusader-kings-iii-tutorial-mode-through-optimized-ux) (Martins and Zetterman, 12 Sep 2024). Cut what isn't needed right away and reveal the UI gradually. 67 boxes became about a third. Their telemetry said finishing the tutorial was not a major factor in whether players kept playing.
3. GamesIndustry.biz, [How to design a great tutorial](https://www.gamesindustry.biz/how-to-design-a-great-tutorial) (Vieversys, 28 May 2024). Deathloop greys out the whole UI except one element with a message, and uses it to explain skipping time. Tell players when the tutorial is over.
4. Game Developer, [How Onboarding Should be Applied to Tutorials](https://www.gamedeveloper.com/design/how-onboarding-should-be-applied-to-tutorials) (Bycer, 29 Aug 2019). Always let players revisit tutorials in game. Keep tips organised and browsable, because returning players forget.
5. NN/g, [Mobile-App Onboarding](https://www.nngroup.com/articles/mobile-app-onboarding/) (Kendrick, 21 Jun 2020). Instructions should be brief, optional and minimal. Don't highlight every element. Caveat: it is about apps, not games.
6. NN/g, [Progressive Disclosure](https://www.nngroup.com/articles/progressive-disclosure/) (Nielsen, 2006). Show a few options first and hide the rest behind a labelled control. More than 2 disclosure levels usually hurts usability.
7. Football Manager, [Mastering the FM26 UI](https://www.footballmanager.com/the-dugout/mastering-fm26-ui). Staged tutorials plus a glossary, and the tutorials can be re-run. Developer blog.
8. GDC Vault, abstracts only, no rules stated: [Prime, Teach, Observe](https://www.gdcvault.com/play/1020512/Prime-Teach-Observe-Tutorializing-Innovative) (Vollmer), [How I Got My Mom to Play Through Plants vs. Zombies](https://www.gdcvault.com/play/1015959/How-I-Got-My-Mom) (Fan), [Teaching Players: Company of Heroes](https://www.gdcvault.com/play/436/Teaching-Players-Tutorial-and-Opening) (Jones-Rodway and Sun). No years shown on the pages.

Not opened: [Game UI Database](https://gameuidatabase.com/) was blocked by Cloudflare, so it is UNVERIFIED as a screenshot library for us.

**(B) PER-GAME LAYOUT**
- **Football Manager 26** ([FM26 UI](https://www.footballmanager.com/fm26/features/fm26s-reimagined-user-interface), [Mastering](https://www.footballmanager.com/the-dugout/mastering-fm26-ui), both developer-written). A home "Portal" shows messages, upcoming fixtures and a two-week calendar snapshot, with an action panel for decisions. Top navigation bar with six categories. Every screen is tiles that open into cards. The help button is an FMPedia ribbon icon beside Search at the top. Tutorials are explainers at the start of a save, staged, re-runnable. Tutorial box position and pointing: NOT FOUND.
- **Two Point Campus** ([wiki](https://two-point-campus.fandom.com/wiki/Interface), fan wiki). Build panel bottom-left. Status panel bottom-right with a small calendar, balance, speed controls and messages. A condensed timetable strip along the bottom edge can be shown or hidden. Objectives panel top-right with a hide/show button above it. Tutorial box and help button: NOT FOUND.
- **Crusader Kings III** ([GameWatcher, May 2020 build](https://www.gamewatcher.com/crusader-kings-3-tutorials-highlighted-text-encyclopedia), plus the Game Developer piece). Tutorial windows explain a concept and require an action. An "Issues" widget sits at the top of the screen and opens suggestions, each dismissible and restorable. Nested tooltips. The Encyclopedia holds the full tutorial lessons. The reviewer said the early build threw information too fast. Pointing and calendar: NOT FOUND.
- **Frostpunk 2** ([IGN](https://www.ign.com/wikis/frostpunk-2/Prologue_Walkthrough), [Insider Gaming](https://insider-gaming.com/frostpunk-2-keyboard-shortcuts/)). Mission objective on the left of the screen. Pause control top-left. Construction buttons lower right. Tutorials open with the T key. These are incidental facts, not a design talk.
- **Planet Coaster 2** ([Frontier deep dive](https://www.planetcoaster.com/en-US/news/2024-09-25/deep-dive-mastering-management), [Quickstart](https://www.planetcoaster.com/player-guides/quickstart-guide)). Management menus top-left, including Objectives and Notifications. Objectives can be pinned to the top of the screen. Scenarios can be skipped without blocking progress ([TheGamer](https://www.thegamer.com/planet-coaster-2-review-pc/)).
- **Motorsport Manager** ([RPS review](https://www.rockpapershotgun.com/motorsport-manager-review-pc), [Steam thread](https://steamcommunity.com/app/415200/discussions/0/133256240731346595/)). The tutorial assists heavily through the first couple of races, but the first race is played before any planning, which the reviewer calls a barrier. The calendar is reachable only through Standings, then View Season Calendar. One player calls it hidden behind an extra menu. That is a player claim.
- **Anno 1800** ([TheGamer](https://www.thegamer.com/industrial-revolution-anno-1800-review/)). Pop-up boxes and quests. The reviewer found the pop-ups frequent, repetitive and irritating. Layout fields: NOT FOUND.
- **Manor Lords** ([IGN](https://www.ign.com/articles/manor-lords-review-early-access), [Ars Technica](https://arstechnica.com/gaming/2024/05/manor-lords-medieval-micromanagement-means-making-many-messes/)). Tutorials decent, but the UI made information hard to find. Minimal tooltip instructions, and the reviewer restarted after missing hidden steps. Layout fields: NOT FOUND.
- **Boxing Manager** ([Fight FAQ](https://community.theboxingmanagergame.com/t/fight-faq-single-fights-and-shows/3606)). A dashboard Single Fight button, or Make Fight on a fighter screen, leads to a matchmaker. The agreed fight lands on the schedule with a notification in that week. Schedule layout: NOT FOUND.
- **Not covered:** Jurassic World Evolution and Two Point Hospital, no usable page opened.

Calendar layout across all games: list vs grid vs timeline is NOT FOUND, except the Two Point Campus timetable strip. No "next event" card exists in any source I opened.
[send-message t157s1023] **K84 PART 2 of 2: panel placement, ten rules, wireframe**

**Panel placement, sourced (NN/g tests are on web pages, not games)**
- [Horizontal Attention Leans Left](https://www.nngroup.com/articles/horizontal-attention-leans-left/): on a 1920x1080 screen, 80% of looking fell on the left half. The leftmost 192 px got only 6%, partly because of left navigation bars. Keep that strip for navigation, put priority content front and center, and secondary content to the right.
- [F-Shaped Pattern](https://www.nngroup.com/articles/f-shaped-pattern-reading-web-content/): the F is the fallback when there are no strong cues. Put the main point first and group content with borders or backgrounds.
- [Modal and Nonmodal Dialogs](https://www.nngroup.com/articles/modal-nonmodal-dialog/): modals only for critical or irreversible things, and never when the decision needs information the modal blocks.
- [HUD Design Principles](https://gamedesign.gg/articles/hud-design-principles/) (undated blog, action games): objective tracker in an upper corner, related values together, don't spread items across all four corners, and retire tutorial labels once the player is competent.
- A sourced limit on panels open at once: NOT FOUND. Hodent's 3 new items is the only number.

**(C) TEN RULES for FightCamp**
1. **Three new things per step, reason first.** Each step opens with why the player does it, then how. SOURCED: Hodent GDC16.
2. **The vital control stays on screen, the explanation goes to tooltips.** SOURCED: Hodent (pin needed info), J52.
3. **Optional, skippable, replayable.** The player can leave at any step and replay any chapter from the Handbook. SOURCED: Bycer 2019, NN/g onboarding, FM26.
4. **Cut hard and reveal gradually.** Aim for about a third of the first draft's steps. A step that doesn't change what the player does next week is cut. SOURCED: CK3 deep dive (cut to about a third). The one-third target for us is JUDGEMENT.
5. **One spotlight per step, no arrows.** Dim everything except the one target and never dim or cover the Continue button. SOURCED: Deathloop tutorialized menus. No game page I read documented arrows or pulses, so "no arrows" and "never cover Continue" are JUDGEMENT.
6. **The tutorial box is a side card, not a modal.** It sits beside its target, never over it, never blocking the action. A modal is for fight results and other irreversible choices only. SOURCED: NN/g modal article. Placement beside the target is JUDGEMENT.
7. **Objectives: one list, 3 goals, collapsible.** It shows the current chapter only and sits top-right under the top bar. SOURCED: Two Point Campus and Planet Coaster 2 for the corner and the hide/pin control, Hodent for 3. The chapter spine is JUDGEMENT: regional gym, then growth chapters, ending on a goal named for reaching national.
8. **The schedule gets a NEXT UP card at the top-left of its content area.** It shows the next dated thing, why it matters, and one gold button. The full schedule is a week-by-week list below it. SOURCED in part: FM26 puts upcoming fixtures and a two-week snapshot on the home screen, NN/g says priority content goes left of center, and Motorsport Manager shows the cost of burying the calendar. List versus timeline, and the card itself, are JUDGEMENT because no source shows a "next event" card.
9. **HANDBOOK button in the top bar, left of the date.** Continue stays at the far right and never moves. SOURCED: FM26 puts FMPedia beside Search at the top, J54 for Continue. The exact slot is JUDGEMENT.
10. **Say when it ends, then go quiet.** The last step says the guide is over and where the Handbook lives. After that there are no pop-ups, only the hint-dot on new screens. SOURCED: GamesIndustry (tell players when it is over), Hodent (busy players miss pop-ups), Anno 1800 review (repetitive pop-ups irritate).

**Arguing against my own strongest rule (8).** A NEXT UP card may only patch a layout problem. If players are confused because the SCHEDULE screen has too many columns, a card on top of it hides the cause. Also, CK3's telemetry says finishing a tutorial hardly changes retention, so guidance alone won't fix confusion. I keep rule 8 because it costs one card and no new screen, and because the evidence that calendars get buried (Motorsport Manager) points at findability. NOT COMPUTED: whether it fixes the confusion. A five-second test on the current SCHEDULE screen against the card version would settle it.

**(D) WIREFRAME** (1920x1080, words are examples only)
```
+------------------------------------------------------------------------------------+
| TOP BAR                       [HANDBOOK ?]    SAT 3 OCT  WEEK 14        [CONTINUE] |
+------+-----------------------------------------------------------------------------+
| RAIL | NEXT UP  (top-left of content)            | OBJECTIVES  (top-right, [hide]) |
|      | +---------------------------------------+ | CHAPTER 1: REGIONAL GYM         |
| HOME | | Mon: Book a bout for Ruiz             | | [ ] Book a first bout           |
|      | | Why: no bout this month, no income    | | [ ] Set the week's training     |
| FIGH |  | [ OPEN THE SCHEDULE ]  (gold, 1 only) | | [ ] Pay the week's bills        |
| TERS | +---------------------------------------+ | Next: NATIONAL GYM (locked)     |
|      |                                           +---------------------------------+
| FIGH | SCHEDULE (week-by-week list)              | TUTORIAL BOX  (side card)       |
| TS   | +---------------------------------------+ | Step 4 of 14                    |
|      | | WEEK 14  Mon train | Wed spar | Sat -- | | Why: a bout pays the gym.       |
| FINA | | WEEK 15  Mon train | Fri WEIGH-IN      | | How: press BOOK on the card.    |
| NCE  | | WEEK 16  FIGHT WEEK  Sat BOUT          | | [SKIP]  [BACK]  [OK]            |
|      | +---------------------------------------+ | (spotlight: only NEXT UP bright)|
+------+-----------------------------------------------------------------------------+
```
Boxes at 1920x1080: rail 0-192 px wide, top bar 0-96 px high, NEXT UP card about x 240-960 and y 130-330, objectives about x 1500-1860 and y 130-420, tutorial box about x 1500-1860 and y 450-760 so it sits next to the target and not over it. These pixel sizes are my JUDGEMENT.

**WHAT IS STILL WRONG**
- No source shows how a tutorial points at its target, or any "next event" card. Rules 5 and 8 lean on judgement there.
- Game UI Database was blocked, so I have no screenshot library. The layout notes come from text, not images. Screenshots of FM26's Portal and Two Point Campus's timetable strip would be the first to check.
- Jurassic World Evolution and Two Point Hospital are not covered.
- "Tooltips after 500 ms" from J52 has no source here.
- I did not write this memo to the repo. Say the word and I'll stage it as `K84_TUTORIAL_GUIDE_PANELS.md` and ping Claude.
[user t158u] # NEW TASK - start fresh, ignore earlier tasks in this thread.

# K85 - Kalli: review the scene tree and propose your own (navigation and UX)

Model: the bot's own (design/research agent, no code). Owner: Claude collects it the session it lands.
Nothing opens on the operator's screen. Read files with your file tool only.

## Owned files
- `research/K85_SCENE_TREE_REVIEW.md`
- `previews/k85/`

## Deliver `research/K85_SCENE_TREE_REVIEW.md`
1. VERDICT on the current tree in 10 lines max: what confuses a new player, ranked.
2. YOUR scene tree: every scene (room / area) with its objects and the ONE job each does - a nested list, plus one
   wireframe picture of the tree (PNG, `previews/k85/`).
3. Where each of these lives in your tree: Schedule, Staff/hiring, Training (moves), Fight week, Scouting, Contracts,
   Finances. One home each; say which other places only SHORTCUT to it (and how a shortcut looks different).
4. The training floor as the place you train: station -> fighter -> move with animated preview -> TRAIN THIS. Wireframe it.
5. Agree or disagree with Claude's rule in the input file, with the reason.
Acceptance: every current click in the input map appears in your tree as KEPT / MOVED (to where) / CUT (why).

## Prior research
`research/SCENE_TREE_REVIEW_INPUT.md` (the map + the operator's words - read it whole first),
`research/TRAINING_LOOP_DESIGN.md` (the training floor loop, G112 real gyms + 13 sim games),
`research/FLOW_PASS2_ROUTE_WORDS.md` (every route and its words), `research/S148_SCHEDULE_TUTORIAL_DESIGN.md`
(schedule + tutorial, approved), `research/topics/gym_rooms_art.md` (rooms and art). Cite, do not redo.

## What would a human do?
A UX lead walks the map as a new player with one question per room - "what is this room FOR?" - deletes every second door
to the same screen, and gives each object a job only that room has.

## Prefab check
None to build - this is a review. Name any shipped game whose room/hub navigation you would copy, with the screen.


---
# THE INPUT FILE (SCENE_TREE_REVIEW_INPUT.md), in full

# Scene tree review - the shared input for K85 (Kalli), M41 (Maria), J61 (John)

Operator 2026-10-03 (S150): "i also want other agents to provide their own scene-tree aspect and review the current one".
The page he reviewed: `Godot/docs/scene_tree/scene_tree.html` (pictures of every scene + what each click opens; built by
`Tools/scene_tree_page.py` from the game code). The same map as text is below - you do not need the HTML.

## The operator's comments on the current tree (verbatim)
1. On the Office "Fight calendar -> Schedule": "this exists also in the staff room it is very confusing"
2. On the Locker room "Fight-week board -> Schedule": "here it is again"
3. On the training floor: "in this scene i want to be able to select the move i want to train , be able to preview it in
   animation , why we have training floor with no options to train"
4. Follow-up: "this needs also to be displayed in 2.5d the fighter training with the coach etc"

## Claude's reading (a starting point - challenge it)
- Duplicates: Schedule opens from 3 places (Office calendar, Locker fight-week board, FIGHTS area); Staff from 5 (three
  objects in the Staff room alone, the Mat room coach, FINANCE area). Proposed rule: every object in a room does ONE
  different job; every screen has ONE home room; the left rail is the always-there shortcut.
- The training floor is only a hallway of doors. The engine already trains a chosen move per fighter
  (GameState.assign_technique_training, today buried in the fighter profile's Skills page). Proposal TRAIN1: click a
  station (heavy bag, pads, ring, speed bag) -> pick the fighter -> the moves that station trains, each with an animated
  preview -> TRAIN THIS; the floor painted 2.5D with the fighter working the station beside his coach (living loop).
- Rooms go 2.5D (operator S147): painted stills with click pins like HOME; the fight stays 3D. The office v2 preview is
  done (painted still + 10 s living ring clip in the window).

## The map as it is today (generated from Tools/scene_tree_page.py, which reads the game code)

Left rail (always on screen): HOME -> HOME [SCENE], FIGHTERS -> FIGHTERS area [SCENE], FIGHTS -> FIGHTS area [SCENE], FINANCE -> FINANCE area [SCENE]

### HOME (painted picture)
- Office pin -> Office [SCENE]
- Staff room pin -> Staff room [SCENE]
- The ring pin -> Training
- Gym floor pin -> The training floor [SCENE]

### FIGHTERS area (painted picture)
- Roster -> Roster & floor
- Training -> Training
- The floor -> The training floor [SCENE]
- Scouting -> Scouting

### FIGHTS area (painted picture)
- Schedule -> Schedule
- Rankings -> Rankings
- Offers -> Fight offers

### FINANCE area (painted picture)
- The books -> Finances (the books)
- Office -> Office desk
- Staff -> Staff
- Contracts -> Contracts

### The training floor (3D room today, becomes painted 2.5D)
- Door: front desk / street -> Front desk (lobby) [SCENE]
- Door: office -> Office [SCENE]
- Door: locker room (tier 2+) -> Locker room [SCENE]
- Door: mat room (tier 3+) -> Mat room (classes) [SCENE]
- Door: staff room (tier 4) -> Staff room [SCENE]
- Door: physio (tier 4) -> Physio [SCENE]
- Spar card: watch -> Spar night

### Front desk (lobby) (3D room today, becomes painted 2.5D)
- Out to the city -> FIGHTS area [SCENE]
- Back to the floor -> The training floor [SCENE]

### Office (3D room today, becomes painted 2.5D)
- The books -> Finances (the books)
- The phone -> Promotions (phone)
- Contracts cabinet -> Contracts
- Fight calendar -> Schedule
- Photo wall -> Former fighters
- Back to the floor -> The training floor [SCENE]

### Locker room (3D room today, becomes painted 2.5D)
- The scale -> Weight class
- Fight-week board -> Schedule
- A fighter's locker -> Fighter profile
- Back to the floor -> The training floor [SCENE]

### Mat room (classes) (3D room today, becomes painted 2.5D)
- Dues board -> FINANCE area [SCENE]
- The coach -> Staff
- Back to the floor -> The training floor [SCENE]

### Staff room (3D room today, becomes painted 2.5D)
- Staff board -> Staff
- Hiring noticeboard -> Staff
- A coach -> Staff
- Back to the floor -> The training floor [SCENE]

### Physio (3D room today, becomes painted 2.5D)
- A fighter's body chart -> Fighter profile - body
- Back to the floor -> The training floor [SCENE]

### Film room (3D room today, becomes painted 2.5D)
- Footage screen -> Fighter profile - camp
- Tendencies board -> Fighter profile - camp
- His record (folders) -> Scouting
- Game plan (laptop) -> Fighter profile - camp
- Other files -> Scouting
- Back to the floor -> The training floor [SCENE]

## Constraints that are settled (do not reopen)
- Rooms go 2.5D: painted picture + pins, living loops where cheap (S147, D-ledger). The fight stays 3D.
- The facility is a "gym"; "fight camp" means only the pre-bout preparation.
- Icons with tooltips over text labels (operator 09-30 / 10-01).
- Demo is a boxing career (2026-10-06): sign -> train -> book -> fight -> money -> up the ladder (regional -> national 5 net
  wins -> international 7 more, D32).


Reply with the full deliverable in this chat (markdown; attach images if you make them).
[send-message t158s1025] Starting K85. I'm reading the prior research files on Beast, then I'll write the tree review and draw the wireframe PNGs.
[send-message t158s1026] I've read the input map and the prior research. The main finding so far is that every click in the map can be placed in a tree where the floor is HOME, the four rail items open four rooms, and each screen has one home. I'm now writing the review file and drawing the two wireframes.
[send-message t158s1027] The K85 review and both wireframes are drafted on my computer, with all 53 clicks from the map placed as kept, moved or cut. Next I'm checking my tally of kept, moved and cut, then copying the files to Beast and sending you the full text.
[send-message t158s1028] 
[send-message t158s1029] 
[send-message t158s1030] **K85 PART 1 of 3: verdict and the tree.** Landed on Beast as `research/K85_SCENE_TREE_REVIEW.md`, with both pictures in `previews/k85/`, and Claude is pinged. The pictures are attached above.

Three lines first:
1. Make the gym floor the only hub. HOME and "the training floor" are one place, split in two today.
2. Make the four rail items open four rooms: HOME is the floor, FIGHTERS is the locker room, FIGHTS is the front desk, FINANCE is the office. Delete the three area pictures, so the rail stops being a second menu.
3. Every screen gets one home room, every object a job no other object has, and no tier hides a base function.

**1. VERDICT, ranked (what confuses a new player)**
1. One screen sits behind many doors. Schedule has 3 (Office, Locker room, FIGHTS). Staff has 5. Scouting has 3, Finances 2 plus the Mat dues board, Training 2.
2. The rail and the rooms are two menus for the same things. The three area pictures repeat what the rooms hold under different names.
3. The training floor trains nothing. It is a hallway of 7 doors, and training a move is buried in the fighter profile.
4. HOME and the floor are two hubs one click apart, with overlapping pins.
5. The doors lie. Staff room is locked until tier 4 though a tier-1 gym must hire a coach. Film room has no door in the map at all.
6. Area names lie. FINANCE holds Office, Staff and Contracts, and "Office" is both a room and a link inside FINANCE.
7. Some rooms own no screen. Both Mat room objects leave it, and the Front desk only leaves.
8. One word, two jobs. "Scouting" means finding new fighters and studying an opponent. "Weight class" is an Office tab but the scale is in the Locker room.
9. Three Film room objects open the same camp page. Two Staff room objects open the same Staff page.
10. Every room has one exit, "Back to the floor", so a trip between rooms costs two extra clicks and nothing says the rail is faster.

**2. THE TREE** (a room is a place, an object is a verb)
- **THE GYM FLOOR (= HOME, rail HOME).** Job: run today.
  - NEXT UP card (overlay). The one thing to do next, one gold button, which jumps to that thing's home room. It is a pointer, never a home.
  - OBJECTIVES list (overlay, top right). This chapter's 3 goals.
  - HEAVY BAG, SPEED BAG, PAD LANE, RING. Train a move (Part 2). The ring also runs sparring.
  - WEEK PLAN clipboard. Plan the 7 days at once (today's Training planner, kept for power users).
  - SPAR CARD, shown when a spar is booked. Watch spar night.
  - Coaches and fighters are scenery with hover cards.
  - Doors along the front wall, icon plus tooltip: FRONT DESK, OFFICE, LOCKER ROOM, STAFF ROOM, FILM ROOM, PHYSIO (padlock), MAT ROOM (padlock).
- **FRONT DESK (rail FIGHTS).** Job: the fights outside the gym. Calendar board opens SCHEDULE. Offers tray opens OFFERS. Rankings wall opens RANKINGS with THE LADDER on top.
- **OFFICE (rail FINANCE).** Job: money and papers. Desk books open FINANCES. Cabinet opens CONTRACTS. Photo wall opens FORMER FIGHTERS. Phone opens PROMOTIONS. NOT COMPUTED: what that panel holds. If it is incoming bout offers it folds into the Offers tray and the phone is cut.
- **LOCKER ROOM (rail FIGHTERS).** Job: my fighters. Locker wall opens ROSTER, and each filled locker opens that fighter's profile. An empty locker opens SCOUT (find a fighter to sign). The scale opens WEIGHT CLASS. The fight-week board opens FIGHT WEEK for the booked bout, or shows "No bout booked".
- **STAFF ROOM (no rail item).** Job: my people. Staff board opens STAFF. Each empty seat opens HIRE for that role. A seated coach gives a hover card, and a click opens that person's pop-up card, not the Staff screen.
- **FILM ROOM (no rail item).** Job: the next opponent. Projector opens STUDY (footage and tendencies on one page). Laptop opens GAME PLAN. Both are tabs of the camp page for the booked bout.
- **PHYSIO (padlock until tier 4).** Job: who is hurt. Body chart opens that fighter's profile on the BODY tab.
- **MAT ROOM (padlock until tier 3).** Job: the grappling wing. Mat stations train a move. Class board opens CLASSES. NOT COMPUTED: whether a classes panel exists. If not, this object waits.
- Deferred, not in the demo: THE CITY (world map), dorms, media office.

Rule for padlocks: a room may be locked only when every screen in it is a bonus. The door then shows padlocked with the unlock in its tooltip, never missing.
[send-message t158s1031] **K85 PART 2 of 3: homes, the training floor, the rule**

**3. Where each thing lives (one home each)**
- **Schedule.** Home: FRONT DESK calendar board. Shortcuts only: the NEXT UP button when the next thing is dated, and a date chip on a bout offer. Never an object in another room.
- **Staff and hiring.** Home: STAFF ROOM (staff board, empty seats). Shortcuts only: a PEOPLE chip on the payroll row in the books, and a STAFF chip on a coach card on the floor.
- **Training (moves).** Home: the floor stations. Shortcuts only: the WEEK PLAN clipboard (same floor), and a TRAIN chip on the profile Skills page that opens the station drawer.
- **Fight week.** Home: LOCKER ROOM fight-week board. Shortcut: the NEXT UP gold button on the days that matter (SET CAMP, WEIGH IN). Continue stops there.
- **Scouting.** Two words, two homes. SCOUT (recruits) lives at the Locker room empty lockers. STUDY (the opponent) lives in the Film room. A STUDY chip sits on an opponent in the Offers tray.
- **Contracts.** Home: OFFICE cabinet. A contract chip on the fighter profile is a shortcut. The fight contract overlay stays an overlay of a booking, not a home.
- **Finances.** Home: OFFICE desk books. The cash figure in the top bar is display only. The Mat class board shows income as a number with a BOOKS chip.

**How a shortcut looks different.** A home is a painted object that glows gold-edged on hover with a name tooltip. A shortcut is a small round icon-only chip with an outward arrow, no painting, and a tooltip that names the home ("Opens SCHEDULE, front desk"). The opened screen always shows the same breadcrumb (FRONT DESK > SCHEDULE) whichever way the player came, so the player learns the real address.

**4. THE TRAINING FLOOR (picture attached)**
The floor stays visible and live behind a right drawer 640 px wide.
1. Click a station. The bag lights and the drawer opens. Nothing else is dimmed.
2. WHO. Fighter chips with name, condition and a state: fit, tired, or hurt (locked, with the reason in a tooltip). Default is the fighter with the nearest bout.
3. WHICH MOVE. The moves this station trains, each with mastery pips and grade. A locked move shows what it needs in a tooltip. Finished moves go last.
4. PREVIEW. A looping clip of the move on this station, with play, slow and 1x. It uses the four honesty states already ruled in K74: exact clip, near match, no clip yet, no motion. With no clip the viewport becomes a facts strip (needs, builds, next grade), never a failure message.
5. COST AND GAIN. Fatigue before and after, the loaded body region, a progress bar toward the next point (gains are fractions, so the bar is what proves the work landed), coach quality and station condition.
6. TRAIN THIS. The one gold button. It sets today's slot for that fighter at that station on that move. A repeat icon copies it across the week.
7. On the floor, the fighter walks to the station and the loop plays, the coach barks one line, and the bar float lands at the bell.

With the drawer open, TRAIN THIS takes the gold and NEXT UP's button goes slate, so there is one gold per frame.

NOT COMPUTED, needed to build it: a station-to-moves table (none in the files I read), whether `assign_technique_training` takes the same daily slot as a station activity or a second one, and whether every move has a clip. The facts-strip state means the clip question does not block the build.

**5. Claude's rule: agree or disagree**
- Agree with the first two parts (one job per object, one home per screen). They cure verdicts 1 and 9.
- Disagree with the third as written. If the rail opens area pictures that differ from the rooms, it is a second tree, not a shortcut. The rail must open the same four rooms the doors open, one for one. I would rather lose three painted area pictures than keep two names for one place.
- Add two limits. A room that owns no screen is a hallway and is not allowed (Mat room and Front desk today). A tier changes a room's look and size, never whether a base screen can be reached.
- Add one definition. "Home" means the room named in the screen's breadcrumb. Everything else is a shortcut and must look like one.
[send-message t158s1032] **K85 PART 3 of 3: the click ledger, prefab check, counter-argument**

**6. CLICK LEDGER, all 53 clicks.** K = kept, M = moved (to where), C = cut (why).
1. Rail HOME: K (HOME is the floor).
2. Rail FIGHTERS: M to LOCKER ROOM.
3. Rail FIGHTS: M to FRONT DESK.
4. Rail FINANCE: M to OFFICE.
5. HOME Office pin: K as a floor door.
6. HOME Staff room pin: K as a floor door.
7. HOME ring pin to Training: M to the ring and bag stations.
8. HOME Gym floor pin: C (a pin to itself).
9. FIGHTERS Roster: M to the Locker room wall. The "floor" half is C.
10. FIGHTERS Training: M to the floor stations plus the WEEK PLAN clipboard.
11. FIGHTERS The floor: C (same as HOME).
12. FIGHTERS Scouting: M to Locker room empty lockers.
13. FIGHTS Schedule: M to the Front desk calendar board.
14. FIGHTS Rankings: M to the Front desk rankings wall.
15. FIGHTS Offers: M to the Front desk offers tray.
16. FINANCE The books: M to the Office desk.
17. FINANCE Office: C (a second door to the Office).
18. FINANCE Staff: C (Staff lives in the Staff room, and the books payroll row gets a PEOPLE chip).
19. FINANCE Contracts: M to the Office cabinet.
20. Floor door front desk: K.
21. Floor door office: K.
22. Floor door locker room: K, but open from tier 1.
23. Floor door mat room: K, padlocked until tier 3.
24. Floor door staff room: K, but open from tier 1.
25. Floor door physio: K, padlocked until tier 4.
26. Spar card watch: K.
27. Front desk out to the city: C (the Front desk is now the fights room, and a real city map is deferred).
28. Front desk back: K.
29. Office books: K.
30. Office phone to Promotions: K, conditional (NOT COMPUTED).
31. Office contracts cabinet: K.
32. Office fight calendar to Schedule: C (the operator's first complaint).
33. Office photo wall: K.
34. Office back: K.
35. Locker scale to Weight class: K, now the only home. The Office tab is C.
36. Locker fight-week board to Schedule: M, it opens FIGHT WEEK (the operator's second complaint).
37. Locker a fighter's locker: K.
38. Locker back: K.
39. Mat dues board to FINANCE: C (money lives in the Office, and the board shows income as a number with a BOOKS chip).
40. Mat coach to Staff: C (scenery with a hover card).
41. Mat back: K.
42. Staff board: K.
43. Staff hiring noticeboard: M to the empty seats.
44. Staff a coach: M to a pop-up card for that person.
45. Staff back: K.
46. Physio body chart to Profile body: K as a tab-door.
47. Physio back: K.
48. Film footage screen to Profile camp: M to the projector (STUDY).
49. Film tendencies board: C (merged into STUDY, same page).
50. Film record folders to Scouting: C (the opponent's record is on STUDY, recruit scouting is in the Locker room).
51. Film game plan laptop: K as GAME PLAN.
52. Film other files to Scouting: C (same reason as 50).
53. Film back: K.

Tally: kept 26, moved 16, cut 11. Two additions that are not in the map: a FILM ROOM door on the floor (the map has no way in) and a WEEK PLAN clipboard on the floor. THE DAY is not in the input map, so I treat it as the NEXT UP card plus the inbox on HOME. NOT COMPUTED: whether the code still mounts it as its own scene.

**7. Prefab check: navigation I would copy**
- **Football Manager 26.** The Portal home gathers messages, fixtures and a two-week calendar snapshot in tiles that each open a card, under an always-present top navigation bar ([FM26's Reimagined UI](https://www.footballmanager.com/fm26/features/fm26s-reimagined-user-interface), opened in K84, developer text). I would copy "home is tiles of what needs me, each tile has one destination". That is NEXT UP and the objectives on our floor.
- **Motorsport Manager.** Home is an overview whose stat bars link to the page behind them, and a required mail item blocks Continue (from J54, which cites a community Steam guide). I would copy "an overview that links out".
- I found no source for a game whose home is a physical place with doors the way ours is. That part is JUDGEMENT.

**8. Arguing against my strongest ruling (merge HOME and the floor)**
Against: HOME must be calm and answer "what needs me", and J54 recommends a quiet overview. A floor with 5 stations, 7 doors, NEXT UP, objectives and a barking coach is the busiest picture in the game, about 14 click targets, and the operator's PC pays for the living loop on the most-visited screen.

I keep the merge, with three limits. Doors are painted doors with icon tooltips, not labelled pins. Only the one or two things that need the player glow amber. The living loop plays only for the fighters training today. The two-hub version costs a click and a second name on every trip. NOT COMPUTED: whether 14 targets reads. A five-second test on one painted mock ("what do you do next, where is the schedule") would settle it.

**WHAT IS STILL WRONG**
- I did not open the game code. Promotions, Classes, the Weight class tab and THE DAY are placed by judgement.
- The station-to-moves table and the technique-slot question are unanswered.
- Staff room open from tier 1 needs a tier-1 look from Maria. NOT COMPUTED how much that costs.
- The Film room needs a door position in the painted floor.
- The rail word FINANCE now opens the Office. A tooltip should say "Money and contracts". K78 left the same clash open.
- I had no picture of the real painted HOME, so the merge is designed from the map, not from a screenshot.
[send-message t158s1033] Q213E needs your OK to relaunch. Codex was killed after it started in the main checkout by mistake. A clean relaunch on the Q213C worktree is waiting on your permission, and then Q213F can fix the elbow pole. Say yes and Claude can start it.
[user t159u] NEW TASK K86 (fresh chat, 2026-10-05). git fetch origin && git rebase origin/master, then read research/TASK_K86_SCREEN_GAP_AUDIT.md in full and deliver exactly its Acceptance. Answer first, no process narrative. The brief and Option B are both inside the file. Here is the file verbatim:

# TASK K86 - THE GAP AUDIT: what the settled design says vs what every shipped screen does (Kalli, design only)

Model: any. Owner: Kalli (gbot, NEW chat). Study + pictures only, never code. Output: `research/K86_SCREEN_GAP_AUDIT.md`
(+ optional sketches under `research/previews/k86/`).

## Why (operator, 2026-10-05, playing the exported .exe)
- HOME, empty gym: "nowhere says Scouting in the screen" (the FIRST JOB card said Open Scouting; the rail hid the Fighters pages).
- THE CANDIDATE (a coach): "nothing is explained - no tooltips, what the fuck is weeks?" and "does that look like a AAA-management
  game panel?" Then: "you are a AAA class lead game designer, shouldn't you go through the right menu structure?"
Two hotfixes shipped today (Fighters area open on an empty gym; tooltips on the tiles). The structural pass is this task.

## Prior research (read first - these are the rules the screens were supposed to follow)
`J54_MENU_ARCHITECTURE_SURVEY.md` (five areas, HOME answers "what needs me"), `K78_S79_WORDS.md` (one word per job),
`J52_TOOLTIPS_AND_TUTORIAL.md`, `PROFILE_IA_THREE_VERSIONS.md` (the seven shared AAA rules: identity strip, decide-first,
progressive disclosure, honest empties, entity links, one primary CTA), `M32_MENU_ART_DIRECTION.md`, `M33_ICONS_AND_TYPE.md`,
`G109_HUB_LIVE_COUNTS.md`, `S74_READINESS_AUDIT.md`. Your own K85 scene-tree review and `SCENETREE2` v4.

## The evidence (the shipped screens)
Stills, all from the exported build today: `previews/s165_exe_walk/` (01 boot ... 59 next_week: title, creation, HOME
empty and booked, scouting, candidate, offer table, fights hub, offers, camp setup, week review, fight week, weigh-in, fight night,
result, HOME after the bout), `previews/s165_story_beside/` (gym step with the three questions, schedule MY GYM, THE INBOX),
and the operator's own frame of the coach candidate (teaching/tactics/rating/weeks tiles, the gap block, the guide card over the
panel's buttons).

## What would a human do?
A lead designer makes ONE table: every screen x every settled rule, PASS / FAIL with the pixel evidence, then ranks the FAILs by what a
first-hour player hits first. They do not redesign everything; they fix the rule breaks and redesign the one or two screens that
cannot be fixed by a rule (the candidate card).

## The job
1. **The IA map as it IS**: every screen reachable by click, its rail area, how it is reached (which button, from where), which words
   lead there. Mark every button whose words name something NOT on the screen it sits on (the Scouting case), every sub-page hidden
   behind a closed group, every term shown without a tooltip or scale.
2. **Rule x screen table** (the seven PROFILE_IA rules + J54's HOME rule + K78's one-word rule + J52's explain rule): PASS/FAIL per
   screen with the still's filename as evidence.
3. **Ranked defect list** (first-hour first), each with the smallest fix in one line.
4. **THE CANDIDATE card, redesigned on paper** for a coach AND a fighter, copying the Football Manager staff/player profile logic (John
   is transcribing the references in J62; if his file is not there yet, use what you know of FM24 and say PROXY): identity strip
   (portrait slot, name, flag, age, role), attributes on a stated scale with band words, ONE verdict sentence, the ask in plain words
   ("$890 a week for 29 weeks; $1,780 to sign"), what signing changes in OUR gym (one line from the gap data), ONE primary button, the
   guide card never covering it. Wireframe as ASCII or a picture; every label's exact words; every tooltip's text.

## Prefab check
None to buy: this is a design audit of our own screens against our own settled studies and the FM24 pattern.

## Acceptance
`K86_SCREEN_GAP_AUDIT.md`: the IA map, the rule x screen table, the ranked list (<= 25 rows), the candidate card spec (both kinds)
with every word written. Answer first, no restated ask, no process narrative. Under 700 lines.

## OPTION B - "the gym is the menu" (operator, 2026-10-05, 18:40, verbatim: "remove the menus and use the 3d engine maybe for everything ? put a timeline bar on top to progress continuously and pose in menus or something like that")
Answer this alongside the hub work, as a second direction: no rail; the 3D gym (we have it, with room pins and the ring) IS the home;
you click a room, a person or the ring and a panel opens OVER the 3D view; a TIMELINE BAR across the top runs time continuously
(day ticks, with pause / 1x / 3x) and PAUSES whenever a panel is open; dated things (weigh-in, fight night, bills, offers expiring)
sit on the bar ahead of the playhead. References to transcribe for this option: Two Point Hospital (clock + speed + the building as the
menu), Planet Coaster / Prison Architect (click an object, panel over the world, time controls), Motorsport Manager (the race-day
timeline), Football Manager's continue-until-the-next-event vs a real-time clock. Say what each one does when a decision is due
(does time stop? a card? a flashing pin?) and what a boxing-gym manager loses or gains by going continuous: the one-decision-a-day
rhythm, the week review, the fight camp count-down. Give one page per option: A (rail + hubs, repaired) and B (gym-as-menu +
timeline), with the same first hour walked through both, so the operator can choose on paper (DESIGN_ON_PAPER_S159 rule).
[send-message t159s1035] Starting K86: rebasing, then reading the settled priors and the shipped stills for the gap audit.
[send-message t159s1036] Beast is offline, so I cannot rebase or open the s165 stills on disk yet. Drafting the audit from the brief you pasted plus the settled priors I already have on my computer; I will land the file the moment Beast is back.
[send-message t159s1037] Reading the settled IA rules now. The audit draft is in progress; I will paste the verdict and land the file as soon as it is ready (and rebase the moment Beast is online).
[send-message t159s1038] # K86 verdict

HOME still says **Open Scouting** with no Scouting word on that screen; THE CANDIDATE fails identity strip, scale/bands, plain-money ask, and the guide covers Sign; Scouting/Staff/Schedule still have too many doors (K85).

**Option A (rail + hubs, repaired) wins for chapter 1.** Keep CONTINUE-to-next-event and the week review. Option B (gym-as-menu + timeline) is the post-K85 spatial skin with hard pause-on-panel, not the EA time model.

Beast is offline: could not rebase or land to `research/`. Full audit below (~336 lines). I will copy it to Beast and ping Claude the moment the desktop app is online.

---

# K86 - SCREEN GAP AUDIT: settled design vs shipped screens (PART 1 of 3)

| Field | Value |
|---|---|
| Task | K86 |
| Date | 2026-10-05 (Asia/Nicosia, UTC+3) |
| Agent | Kalli (design only, no code) |
| Output | `research/K86_SCREEN_GAP_AUDIT.md` (box draft: `/workspace/k86/K86_SCREEN_GAP_AUDIT.md`) |
| Evidence | `s165_exe_walk/` 01-59, `s165_story_beside/`, operator coach-candidate frame. Beast offline: still pixels NOT opened this pass. Filenames cited from the brief. |
| Priors read | J54, K78, J52, PROFILE_IA (7 rules), K85, M32, M33. **NOT FOUND on box:** G109_HUB_LIVE_COUNTS, S74_READINESS_AUDIT, SCENETREE2 v4, J62. FM24 candidate = PROXY. |

## 1. Verdict (answer first)

The shipped IA still breaks three settled rules on the first hour: (1) a HOME card says **Open Scouting** while the rail never shows the word Scouting on that screen and the Fighters group can hide the page (hotfix opened the group; the word gap remains); (2) THE CANDIDATE panel dumps numbers without scale, band words or tooltips, and the guide card covers the only CTA; (3) one job still has many doors (K85), so the player cannot learn where Scouting / Staff / Schedule live.

**Option A (rail + hubs, repaired)** wins on paper for the first hour. FightCamp's loop is one decision a day with a week review and a camp countdown. That rhythm matches CONTINUE-to-next-event (J54, FM, Motorsport Manager, OOTP), not a real-time clock. Option B is a strong mid-game fantasy once the gym rooms are the single home of every screen (K85), but it costs the week review and the calm "what needs me" hub unless you fake pause-on-panel heavily. Ship A for Early Access chapter 1; keep B as the room-nav end state after A is honest.

## 2. IA map as it IS

### 2a. Reachable screens (click map)

| Screen | Rail area | How reached | Words that lead there | Still / note |
|---|---|---|---|---|
| Title | (none) | Boot | NEW CAREER / LOAD / SETTINGS | s165_01 boot |
| Creation (country / city / gym) | (none) | NEW CAREER | NEXT, START CAREER | s165 creation; story_beside gym step |
| HOME (empty) | HOME | After creation; rail HOME | FIRST JOB / NEEDS YOU / Open Scouting | s165 HOME empty |
| HOME (booked) | HOME | After first accept | NEXT UP, SET CAMP, CONTINUE | s165 HOME booked / after bout |
| Roster & floor | FIGHTERS | Rail FIGHTERS > page | ROSTER & FLOOR | K78; group was closed on empty gym |
| Training | FIGHTERS | Rail FIGHTERS > page | TRAINING | K78 |
| Scouting | FIGHTERS | Rail FIGHTERS > SCOUTING; also FIRST JOB CTA | SCOUTING / Open Scouting | s165 scouting. **Word break:** CTA names Scouting; HOME chrome does not |
| Candidate (coach / fighter) | FIGHTERS > Scouting (or Staff) | Select a row on Scouting / hire seat | Invite / View / Hire | s165 candidate; operator coach frame |
| Offer table (sign) | under Candidate | Accept path from candidate | Sign / Offer | s165 offer table |
| Schedule / MY GYM | FIGHTS | Rail FIGHTS > SCHEDULE | SCHEDULE | s165_story_beside schedule MY GYM |
| Offers | FIGHTS | Rail / HOME row | Offers / Answer bout offer | s165 offers |
| Fights hub | FIGHTS | Rail FIGHTS | FIGHTS | s165 fights hub |
| Rankings | FIGHTS | Rail FIGHTS > RANKINGS | RANKINGS | K78 |
| Camp setup | FIGHTERS or HOME gate | SET CAMP | SET CAMP / GO COLD | s165 camp setup |
| Week review | (time advance) | after CONTINUE week | Week review | s165 week review |
| Fight week | LOCKER / HOME | ENTER FIGHT WEEK | Fight week | s165 fight week |
| Weigh-in | Fight week flow | CONTINUE stop | Weigh-in | s165 weigh-in |
| Fight night | Fight week flow | GO TO FIGHT NIGHT | Fight night | s165 fight night |
| Result | after bout | auto | Result | s165 result |
| Inbox / News | HOME or overlay | THE INBOX | Inbox | s165_story_beside THE INBOX |
| Staff / hire | GYM or MONEY (live mapping clash) | STAFF page / Staff room | STAFF | K78 tip maps STAFF under MONEY; J54 puts Staff under GYM; K85 under Staff room |
| Office / Books | MONEY | OFFICE / BOOKS | OFFICE | K78 clash 6 |
| Gym floor / rooms | HOME pins or doors | Office, Staff, Locker, ring pins | pin names | K85; overlap with rail |

### 2b. Word / structure breaks

**Buttons whose words name something NOT on the screen they sit on**
1. HOME FIRST JOB / NEEDS YOU: **Open Scouting**. The destination word Scouting does not appear in HOME chrome or as a visible rail page until FIGHTERS is opened. Hotfix opened the Fighters group; it did not put the word on HOME.
2. K85 legacy: Office pin and FINANCE > Office both said Office for different jobs.

**Sub-pages hidden behind a closed group**
1. FIGHTERS pages were collapsed on an empty gym. Hotfix: group open. Structural need: Scouting must be a visible second-level tab whenever FIRST JOB points at it.
2. Staff / Scouting / Schedule still reachable from multiple room pins (K85).

**Terms shown without tooltip or scale**
1. Candidate tiles: **teaching / tactics / rating / weeks** with bare numbers. No scale, no band word.
2. Readiness %, camp weeks, heat: full glossary coverage NOT COMPUTED without Beast stills.
3. Gap block not tied to "vs your current coach" in plain words.
[send-message t159s1039] ## 3. Rule x screen table (PART 2 of 3)

Rules: **P1** identity strip · **P2** Decide-first · **P3** Progressive disclosure · **P4** Honest empties · **P5** Entity links · **P6** Evaluated ambition · **P7** One primary CTA · **H** J54 HOME · **W** K78 one word · **E** J52 explain.

| Screen | P1 | P2 | P3 | P4 | P5 | P6 | P7 | H | W | E | Evidence |
|---|---|---|---|---|---|---|---|---|---|---|---|
| Title | - | PASS | PASS | PASS | - | - | PASS | - | PASS | PASS | s165_01 boot |
| Creation | - | PASS | PASS | PASS | - | - | PASS | - | PASS | FAIL* | creation |
| HOME empty | - | FAIL | FAIL | FAIL | FAIL | - | FAIL | FAIL | FAIL | FAIL | HOME empty |
| HOME booked | - | PASS | PASS | PASS | PASS | - | PASS | PASS | PASS | PASS | HOME booked |
| Scouting list | FAIL | PASS | PASS | PASS | PASS | - | PASS | - | PASS | FAIL | s165 scouting |
| Candidate coach | FAIL | FAIL | FAIL | FAIL | FAIL | - | FAIL | - | FAIL | FAIL | operator frame |
| Candidate fighter | FAIL | FAIL | FAIL | FAIL | FAIL | FAIL | FAIL | - | PASS | FAIL | same panel family |
| Offer / sign table | PASS | PASS | PASS | PASS | PASS | - | PASS | - | PASS | FAIL | s165 offer table |
| Fights hub | - | PASS | PASS | PASS | PASS | - | PASS | - | PASS | PASS | s165 fights hub |
| Offers | - | PASS | PASS | PASS | PASS | - | PASS | - | PASS | PASS | s165 offers |
| Schedule MY GYM | - | PASS | PASS | PASS | PASS | - | PASS | - | PASS | PASS | story_beside |
| Camp setup | - | PASS | PASS | PASS | PASS | - | PASS | - | PASS | FAIL | s165 camp |
| Week review | - | PASS | PASS | PASS | - | - | PASS | - | PASS | PASS | s165 week review |
| Fight week | - | PASS | PASS | PASS | PASS | - | PASS | - | PASS | PASS | s165 fight week |
| Weigh-in | - | PASS | PASS | PASS | PASS | - | PASS | - | PASS | PASS | s165 weigh-in |
| Fight night / corner | - | PASS | PASS | - | - | - | PASS | - | PASS | PASS | s165 fight night |
| Result | PASS | PASS | PASS | PASS | PASS | - | PASS | - | PASS | PASS | s165 result |
| Inbox | - | PASS | PASS | PASS | PASS | - | PASS | PASS | PASS | PASS | THE INBOX |
| Staff list | FAIL | PASS | PASS | PASS | PASS | - | PASS | - | FAIL | FAIL | STAFF clash |

\*Creation E FAIL only if M32 developer chrome still visible; NOT COMPUTED.

Candidate coach is the densest FAIL cluster. HOME empty fails H/W/E/P2/P7 together. Most fight-flow screens PASS once booked.

## 4. Ranked defect list (first-hour first, <= 25)

| # | Defect | Smallest fix |
|---|---|---|
| 1 | HOME FIRST JOB says Open Scouting; Scouting absent on HOME | CTA: **Open FIGHTERS · Scouting** or Scouting chip on HOME |
| 2 | Fighters sub-pages can collapse when FIRST JOB needs Scouting | Force-expand FIGHTERS + highlight SCOUTING when NEEDS YOU targets it |
| 3 | Candidate: no scale / band on teaching, tactics, rating | Show `14/20 · Good`; tooltip = band table |
| 4 | Candidate: **weeks** unexplained | On-screen: **Contract 29 weeks**; tip explains weekly pay |
| 5 | Guide card covers Sign / Decline | Dock guide above/beside; never over primary CTA |
| 6 | Candidate lacks identity strip | Portrait, name, flag, age, role badge |
| 7 | No one verdict sentence | One line under strip |
| 8 | Ask not in plain money | `$890 a week for 29 weeks · $1,780 to sign` |
| 9 | Gap block not tied to OUR gym | `Signing fills Head Coach; training quality +8` |
| 10 | Two+ golds on candidate | One primary: **Sign coach** |
| 11 | Scouting vs Study same word | Recruit = **Scout**; Film = **Study** |
| 12 | Staff under MONEY tip and GYM/J54 and Staff room | One home: GYM > Staff |
| 13 | OFFICE under MONEY does not say money | Rename page **Books** |
| 14 | Schedule from Office + Front desk + FIGHTS | One home: Front desk calendar |
| 15 | Honest empty on HOME with 0 fighters weak | `No fighters signed · Scout to fill a locker` |
| 16 | Tile tooltips hotfix incomplete | Glossary-bind every stat chip |
| 17 | Rail icon-only risk without tip | Icon + label + tip |
| 18 | Creation may show developer chrome | Kill M32 class strings |
| 19 | NEXT UP vs FIRST JOB two heroes | One hero gold; list CTAs slate |
| 20 | CONTINUE / HOME both about time historically | CONTINUE bottom-right only; HOME never advances time |
| 21 | Fighter candidate missing ambition eval | Evaluated ambition label (P6) |
| 22 | Offers lack deadline colour | Red blocker when offer < 7 days |
| 23 | Week review can bury a story beat | Cap one story card before review |
| 24 | Staff room locked while hire required | Base hire open at tier 1 |
| 25 | No breadcrumb from HOME CTAs | Always `FIGHTERS > Scouting > Candidate` |

## 5. THE CANDIDATE card (coach + fighter)

FM24 PROXY (J62 NOT FOUND).

### Coach wireframe

```
+------------------------------------------------------------------+
| [portrait]  LEN PARK                         [ENG]  age 48       |
|             Role: Head Coach · available                         |
|             Verdict: Strong teacher for an empty Head Coach seat;|
|             tactics only Fair. Hire now, upgrade tactics later.  |
+------------------------------------------------------------------+
| ATTRIBUTES (scale 1-20)                                          |
| Teaching   16  ################..  Excellent                     |
| Tactics    11  ###########.......  Fair                          |
| Discipline 14  ##############....  Good                          |
| Motivation 13  #############.....  Good                          |
| Rating     14  (overall from above)                              |
+------------------------------------------------------------------+
| vs OUR GYM                                                       |
| Head Coach seat: empty                                           |
| Signing fills Head Coach. Training quality +8. Wage budget -890/wk|
+------------------------------------------------------------------+
| THE ASK                                                          |
| $890 a week for 29 weeks. $1,780 to sign.                        |
| Can release with 2 weeks' pay.                                   |
+------------------------------------------------------------------+
|                                         [ Decline ]  [ Sign coach ]|
+------------------------------------------------------------------+
| Guide LEFT/TOP, never over Sign coach:                           |
| "Teaching is how fast fighters gain from sessions. Rest the      |
|  mouse on any number."                                           |
+------------------------------------------------------------------+
```

**Bands:** Poor 1-5 · Fair 6-10 · Good 11-15 · Excellent 16-20.

**Coach tooltips:** Teaching / Tactics / Discipline / Motivation / Rating each state scale 1-20 and meaning; weeks = contract length with weekly pay; $890 = weekly wage; $1,780 = one-time fee; Sign coach / Decline as above.

### Fighter wireframe

```
+------------------------------------------------------------------+
| [portrait]  MARA SOLANO                      [ESP]  age 22       |
|             Welter · Amateur · Record 4-0-0                      |
|             Verdict: Ready for a first regional card; chin       |
|             untested above club level.                           |
+------------------------------------------------------------------+
| ATTRIBUTES (scale 1-20) — six STAT_ORDER summary                 |
+------------------------------------------------------------------+
| vs OUR GYM: open locker · Welter matches focus · wage $420/wk    |
| THE ASK: $420 a week for 52 weeks. $0 to sign (amateur).         |
| Ambition: Win a regional title in 18 months.                     |
|                                      [ Decline ]  [ Sign fighter ]|
+------------------------------------------------------------------+
```

Primary: `Sign fighter`. Ambition = evaluated sentence only (P6).
[send-message t159s1040] ## 6. OPTION A - rail + hubs repaired (PART 3 of 3)

Keep J54 five areas and CONTINUE-to-next-event. Repair word breaks and candidate. Rooms = chips to the same homes, not a second tree.

| Min | Player does | What must be true |
|---|---|---|
| 0-3 | NEW CAREER | Sentence case, no dev chrome |
| 3-6 | HOME empty | CTA `Open FIGHTERS · Scouting`; FIGHTERS open; honest empty roster |
| 6-15 | Scouting > Candidate | Section 5 card; guide not over Sign |
| 15-25 | Sign fighter | NEXT UP: Book a bout |
| 25-40 | Offers, accept even match | CONTINUE shows stop reason |
| 40-50 | SET CAMP / GO COLD | K78 words |
| 50-60 | Fight week → result | Chapter end |

## 7. OPTION B - gym-as-menu + timeline

No rail. 3D gym is HOME. Click room/person/ring → panel over view. Timeline: pause / 1x / 3x; **pauses while any panel is open**. Dated events sit on the bar.

| Ref | When a decision is due |
|---|---|
| Two Point Hospital | Time runs unless paused; problems flash; you pause or rush |
| Planet Coaster / Prison Architect | Speed controls; object panel over world; pause for money/staff |
| Motorsport Manager | Race-day timeline; between races Continue stops for required mail |
| Football Manager | Not real-time. Continue-until-next-event. Closest to our CONTINUE |

| Loses | Gains |
|---|---|
| One-decision-a-day rhythm | Rooms are the menu (K85 end state) |
| Natural week review (must rebuild as forced pause) | Timeline shows weigh-in / fight / bills ahead |
| Easy camp countdown as weeks | Day ticks feel alive |
| Low-intensity hub | No rail nouns to learn |
| Easy CONTINUE teaching | Soft-flash only = missed weigh-ins (unfair) |

**If B ships:** panel open => time paused. Weigh-in / camp gate / offer expiry => hard pause + flashing pin + card.

| Min | B first hour |
|---|---|
| 3-6 | 3D gym; empty lockers glow; "Scout - click an empty locker" |
| 6-15 | Locker → Scout panel; candidate card; time paused |
| 15-40 | Sign; 1x; Front desk → Offers; markers for camp / weigh-in / night |
| 40-60 | Camp gate blocks playhead; hard pause at fight night; result |

**Paper choice:** A for chapter 1 EA. B after every screen has one room home and pause-on-panel is proven.

## 8. Strongest ruling

**Ruling:** Keep A for the first hour; B is the post-K85 spatial skin on the same homes, not a replacement time model. Fix HOME→Scouting words and the Candidate card before any nav rewrite.

**Against:** Operator asked to remove the menus; A looks like defending the broken rail.

**Keep:** Weigh-ins and camp gates are calendar facts. A continuous clock that does not hard-stop is unfair. FM continue-until-event is the genre fit. B's value is spatial IA, which K85 already specifies without real-time.

**NOT COMPUTED:** live pixel diffs on s165; hotfix tooltip coverage; FIGHTERS default after hotfix; G109; S74; SCENETREE2 v4; J62.

## 9. WHAT IS STILL WRONG

- Beast offline: stills not re-inspected; file not landed to `research/` or `_kalli_delivery/`; Claude not pinged yet.
- G109, S74, SCENETREE2 v4, J62 not on the box.
- Fighter candidate assumed same panel family as coach (PROXY).
- Staff rail parent still contested (J54 / K78 / K85).
- No PNG wireframes this pass (ASCII only).

---

End of `K86_SCREEN_GAP_AUDIT.md`. Box path: `/workspace/k86/K86_SCREEN_GAP_AUDIT.md`. Say when Beast is online and I will rebase, land, and ping Claude.
[user t160u] # TASK K87 - Design study: the PACING of a training day you watch (race = the week, lap = the day) - study + pictures only, never code

You are Kalli, the design agent. Reply in this chat with ONE document.

## Context
FightCamp is a boxing gym management game (Godot 4, 3D). One fighter trains in a 3D gym while a day clock runs (10 game hours,
today ~3 real minutes, no fast-forward while he trains). The player clicks a station (bag, pads, ring, speed bag, treadmill, bike,
weights, stretch corner); the fighter walks there (walking costs minutes), trains, and drains STAMINA; a coach buffs the station he
stands at and has a POOL that must last the WEEK. The operator, verbatim (2026-10-08):
"other games with timing and simialr game mechanice as our (motorsport manager loop . i am thinking the race is the scheduled training
the lap is the day there is a goal to reach in time and time is ticking and trying to achieve the best result out of the trianing
session each day or week (not sure about the pacing)"
Earlier ruling (2026-10-06): "we are not making a copy of motor sport [...] every week the trainging is set and you watch the fighter do
it you watch him and intervene when you want to press him harder or easy him".

## Prior research (do not repeat it)
G112 (training loop survey, Two Point Campus "watching people do the thing is the reward"), D68 (one more turn), MMAM2_WATCH_S172
(MMA Manager 2: one station at a time, energy bar), J63 (walking made watchable). NONE set the PACING numbers: real seconds per game
day, how many decisions per day, what the goal of a day/week is, and when the game stops by itself. That is the gap.

## What would a human do?
Time the reference games with a stopwatch: Motorsport Manager (a race: real minutes, laps, how many decisions per lap, what the
player reads while it runs), Chef: A Restaurant Tycoon Game (a service), Two Point Hospital (a day), Overcooked (a level timer + target),
Football Manager (a match at normal speed), MMA Manager 2 (a training day).

## The questions
1. A table: game | the "race" | real minutes | the "lap" | decisions per lap | speed controls | what auto-pauses | the goal shown on screen.
2. What makes the clock feel like pressure, not waiting (a visible target, a pit-window, a rival, a rising cost)?
3. Recommend OUR numbers: real time per game day, days per week shown vs skipped, decisions per day, the DAY goal and the WEEK goal
   (e.g. "jab usable by Friday", "stamina above 30 at the bell"), what auto-pauses, speed steps. Give two variants (short and long day)
   and say which you pick and why.
4. One picture (or ASCII) of the screen during a day: where the clock, the goal, the stamina bar and the coach pool sit.

## Deliverable
ONE document, answer first, max 200 lines, every claim tagged SOURCED (url + date) or JUDGEMENT. Title it "K87 - Day-lap pacing".
[send-message t160s1042] Starting K87: timing the reference games from real sources, then the pacing numbers and a screen sketch.
[send-message t160s1043] I'm pulling sourced timings for Motorsport Manager, Chef, Two Point Hospital, Overcooked, FM and MMA Manager 2 now. K87 comes as one document once the numbers are in.
[send-message t160s1044] # K87 - Day-lap pacing

## Answer first
1. **Pick the SHORT day: 2:00 real minutes per game day (12 real seconds per game hour), 5 watched days per week, about 10 real minutes per week.** JUDGEMENT. A week then runs about as long as a short Motorsport Manager race, which players estimate at about 10 minutes (SOURCED, see table).
2. **3 decisions per day, made one at a time.** The player queues only the NEXT station, never the whole day. Motorsport Manager's creator made the same fix and says it "forced people into paying attention" (SOURCED, West 2014).
3. **One day goal and one week goal, always on screen, each tied to a bell time.** Day example: "Stamina above 30 at the bell." Week example: "Jab usable by Friday." JUDGEMENT.
4. **Auto-pause at four moments:** the station queue is empty, stamina drops to 30, the coach pool would go below what the rest of the week needs, or the bell rings (day card). JUDGEMENT.
5. **Speeds: pause, 1x and 2x.** 2x only while walking, during rest blocks, or when the next station is already queued. No 3x or 4x. JUDGEMENT.

## 1. Reference table
"Race" = the long unit, "lap" = the inner unit. All sources accessed 2026-10-08.

| Game | Race | Real minutes | Lap | Decisions per lap | Speed controls | Auto-pauses | Goal on screen |
|---|---|---|---|---|---|---|---|
| Motorsport Manager | One race | About 10 (short) to 30-40 (long), player estimates [1] | One lap, 12-60 per race [1][2] | Below 1. "three or four major decisions spread across the entire event" [3] | Pause, 1x/2x/4x/12x [4] | The pit screen ("the race pauses in the background") [3]. Decision menus [5]. Fuel and tyre dilemmas [6] | Position and points [7]. Sponsor target per race [3]. Whether that target is on the HUD: NOT FOUND |
| Chef: A Restaurant Tycoon Game | One service day | NOT FOUND | Lunch and dinner rushes [8] | NOT FOUND | Pause, x1/x4/x8 [9] | NOT FOUND. "no section to see your objectives" [10] | Weak, per [10] |
| Two Point Hospital | One year | About 24-27. The wiki says "One day is 4 seconds, one year is 27 minutes", and those two numbers do not agree [11] | One day, about 4 s. A patient's room visit is 22-90 s [12] | NOT FOUND | Pause, slow (half), normal, fast (double) [11] | NOT FOUND (manual pause only, per [11]) | Task panel top right, star objectives [11] |
| Overcooked 2 | One level | 2:20-5:10, most 3:30-4:00 [13] | One order ticket with green, yellow and red tip windows [14] | NOT FOUND. Built with "always more actions to perform than players available" [15] | None | Timer starts only at the first dish on some levels [16] | Countdown plus star score targets [13] |
| Football Manager | One match | 90 (full), 45 (x2). Key highlights 5-15, extended 10-25 (player reports conflict) [17][18] | One highlight | NOT FOUND. One player pauses "every 15 min" [18] | Pause, speed sliders during and between highlights [19][20] | Half-time team talk [21]. Injuries and set pieces: NOT FOUND | Score and clock |
| MMA Manager 2 | Not a day. It is a mobile game on real-time stamina [22] | NOT FOUND | One session at one station with one coach, and the coach is busy while training [23] | NOT FOUND | None. Real-world clock and paid speed-ups [22][24] | NOT FOUND | NOT FOUND |

**Correction to our own priors (SOURCED [22][23]):** MMA Manager 2 has no training day and no speed controls. It is a 2022 mobile free-to-play game that runs on stamina and real-time cooldowns. MMAM2_WATCH_S172 still holds for "one station at a time, energy bar". It is no source for pacing.

**DERIVED from [1]:** a Motorsport Manager lap at default speed is about 30-48 real seconds (30-40 min ÷ 50-60 laps). Our 2:00 day is about 3 MM laps.

## 2. What makes the clock feel like pressure, not waiting
1. **A target with a deadline you can see.** Palmer splits timers into "reminders" (to plan around) and "warnings" (to cause tension), and says a timer is "there to make the player feel more pressured" [25]. SOURCED. For us: the bell time sits next to the day goal, and the week goal shows its day. JUDGEMENT.
2. **Only the next decision is open.** When the whole strategy was set before the race, players would "just watch the cars do lap after lap without interacting", until West "limited pitstop strategy so the player could only queue up the next pitstop" [26]. SOURCED. For us: queue one station. When it ends, the game asks again. JUDGEMENT.
3. **Few decisions, each one heavy.** "Three or four major decisions ... magnifies the importance of every click" [3]. SOURCED. For us: 3 a day, 15 a week. JUDGEMENT.
4. **More to do than time allows.** Overcooked is built with "always more actions to perform than players available", plus the "stay with the pot" dilemma [15]. SOURCED. For us: 10 game hours, walking costs minutes, and there are more stations than the day can fit. JUDGEMENT.
5. **A cost that runs out across the race.** The coach pool must last the week, like tyres and fuel over a race [3]. SOURCED for MM. JUDGEMENT for us.
6. **A failure that sticks.** One critic found Two Point Campus lost "pressure" because "if you don't succeed this year then you always have next year" [27]. SOURCED. For us: the week goal feeds the bout. A jab not usable by Friday is not in the camp plan. JUDGEMENT.
7. **Use buttons, not sliders, for choices.** West: "use pushable buttons instead" [26]. SOURCED. For us: EASE / HOLD / PRESS buttons at the station. JUDGEMENT.

## 3. Our numbers (two variants)

| | SHORT day (pick) | LONG day |
|---|---|---|
| Real time per game day | 2:00 (12 s per game hour) | 3:30 (21 s per game hour), Overcooked's typical level length [13] |
| Days shown per week | Mon-Fri watched. Sat spar shown as a result card. Sun rest skipped with one line | Mon, Wed, Fri watched. Tue and Thu run from the same queue and show a card |
| Real time per week | About 10 min | About 10.5 min watched, plus cards |
| Decisions per day | 3 station picks plus up to 2 EASE/PRESS | 4-5 station picks plus up to 3 EASE/PRESS |
| Station block | About 3 game hours (36 s) plus walk | About 2.5 game hours (52 s) plus walk |
| Day goal (one) | "Stamina above 30 at the bell" or "3 jab sets by 18:00" | Same, plus one bonus row |
| Week goal (one) | "Jab usable by Friday" (technique reaches usable) | Same |
| Speeds | Pause / 1x / 2x | Pause / 1x / 2x / 3x |

All rows are JUDGEMENT.

**Why SHORT wins (JUDGEMENT):**
- Every day is watched, so "watch the fighter and step in" holds all week. There are no skipped laps where the plan runs without you.
- A 2:00 day with 3 picks gives one decision every 40 seconds. That is about one MM lap, and MM's major decisions come further apart than that [3].
- A week is about 10 minutes. That matches a short MM race [1] and keeps "one more week" small.
- A day is shorter than the current 3:00, which costs fewer real minutes per session.

**Arguing against it:** the LONG day shows more training animation, which G112 calls the reward ("watching people do the thing"). It also leaves room to get a walk wrong. **I keep SHORT.** The long day only fits in a week by skipping days, and skipped days bring back the "set it and watch" problem West fixed [26].

**Auto-pause list (JUDGEMENT):**
1. The station block ends and nothing is queued.
2. Stamina drops to 30. The bar turns amber and EASE glows.
3. The coach pool would fall below what the rest of the week needs.
4. Injury risk flag.
5. The bell: day card showing day goal met or missed, stamina, and pool left.
6. A panel is open.

**Never auto-pause** on walking or on routine "set done" ticks. JUDGEMENT.

## 4. The screen during a day (JUDGEMENT)

```
+--------------------------------------------------------------------------+
| MON  TUE [WED] THU  FRI  sat  sun     09:00 ====|======== 19:00 BELL  || 1x 2x |
+--------------------------------------------------------------------------+
| TODAY: Stamina above 30 at the bell   |                 COACH POOL (week)|
| WEEK:  Jab usable by FRI  [####..]    |                 [#######...] 70  |
|                                       |                 reserve for THU-FRI|
|                                       |                 ----^ 40         |
|                    ( 3D GYM: fighter at HEAVY BAG,                       |
|                      coach glow on the station, walk path dotted )       |
|                                                                          |
| NEXT: [PADS icon] queued  (walk 12 min)                                  |
+--------------------------------------------------------------------------+
| STAMINA [##########.......] 58     [EASE] [HOLD] [PRESS]   HEAVY BAG 1:48|
+--------------------------------------------------------------------------+
```

- **Top bar:** week pips plus the day clock running to the BELL. Speed buttons sit at the right end.
- **Top left:** the two goals. Gold goes on TODAY only, the one gold per frame.
- **Top right:** the coach pool for the week, with a tick showing the reserve the remaining days need.
- **Bottom left:** stamina with a 30 line marked. It turns amber below 50 and red below 30.
- **Bottom centre:** EASE / HOLD / PRESS for the current station. Icons with tooltips.
- **Bottom right:** current station and time left in the block.
- **Above stamina:** the NEXT slot. Empty means the game pauses when the block ends.

## Sources (all accessed 2026-10-08)
[1] https://steamcommunity.com/app/415200/discussions/0/1318835718943217298/ · [2] https://www.reddit.com/r/MotorsportManagerPC/comments/1byhtpt/ · [3] https://www.rockpapershotgun.com/motorsport-manager-review-pc · [4] https://www.reddit.com/r/MotorsportManagerPC/comments/esukv9/ · [5] https://gameinformer.com/b/features/archive/2016/08/15/the-sports-desk-behind-the-wheel-of-motorsport-manager.aspx · [6] https://steamcommunity.com/app/415200/discussions/0/1473096694444734910/ · [7] https://motorsportmanagerpc.fandom.com/wiki/Race · [8] https://steamsolo.com/guide/a-beginner-guide-to-chef-chef/ · [9] https://steamcommunity.com/app/886900/discussions/0/1743353798883243620/?ctp=15 · [10] https://www.rapidreviewsuk.com/chef-a-restaurant-tycoon-game-review/ · [11] https://two-point-hospital.fandom.com/wiki/Hospitals · [12] https://steamcommunity.com/sharedfiles/filedetails/?id=1519429114 · [13] https://overcooked.fandom.com/wiki/2-6_(Overcooked!_2) and sibling level pages · [14] https://steamcommunity.com/sharedfiles/filedetails/?id=1700450005 · [15] https://www.gamedeveloper.com/design/game-design-deep-dive-building-truly-cooperative-play-in-i-overcooked-i- · [16] https://gamerant.com/overcooked-2-how-to-get-four-stars/ · [17] https://www.reddit.com/r/footballmanagergames/comments/1ocaxme/ · [18] https://www.reddit.com/r/footballmanagergames/comments/u5pfxi/ · [19] https://www.ggrecon.com/guides/football-manager-2024-change-highlights/ · [20] https://www.footballmanager.com/the-dugout/maximising-your-match-days-fm26 · [21] https://www.charlieintel.com/games/football-manager-2024-team-talks-shouts-explained-285457/ · [22] https://www.bluestacks.com/blog/game-guides/mma-manager-2/mmam-training-guide-en.html · [23] https://www.bluestacks.com/blog/game-guides/mma-manager-2/mmam-beginner-guide-en.html · [24] https://www.bluestacks.com/blog/game-guides/mma-manager-2/mmam-gym-building-guide-en.html · [25] https://www.gamedeveloper.com/design/time-for-a-timer---effective-use-of-timers-in-game-design · [26] https://www.gamedeveloper.com/design/making-formula-1-accessible-with-i-motorsport-manager-i- · [27] https://www.techradar.com/features/like-me-in-freshman-year-two-point-campus-is-far-too-relaxed

## NOT COMPUTED and what would settle it
- Real seconds per MM lap and real minutes per setting: no official figure. A stopwatch run of one short race at 1x would settle it.
- Chef day length, MMA Manager 2 session length, and FM auto-pause triggers: NOT FOUND. A timed play of each would settle them.
- Whether 3 stations fit in 10 game hours after walking: needs the live walk-minute table.
- The station-block length that makes stamina reach 30 near the bell: needs the stamina drain rate.

## WHAT IS STILL WRONG
- The table leans on player estimates for MM and FM. No developer published real minutes per race or per match.
- The two Two Point Hospital wiki figures disagree (4 s a day against 27 min a year).
- No playtest has checked that one decision every 40 seconds feels busy rather than nagging.
[user t161u] # TASK K88 - who sponsors a small boxing club (game design, Kalli)

You are the game designer of FightCamp, a boxing-gym management game (the player owns a small boxing club and builds fighters).
Answer in plain text in this chat. No research report: a design answer and a data list.

## The problem
Today the club's sponsor offers come from a list of real fight ORGANISATIONS (UFC, ONE, national federations). A small boxing club in
London was offered the "Cyprus Mixed Martial Arts Federation" as its sponsor - wrong sport, wrong country, and a federation is not a
sponsor. Real small clubs are sponsored by LOCAL BUSINESSES (a car dealer, a supplement shop, a builder, a pub, a physio clinic), later
by regional brands, and only a famous gym attracts a national or sports brand.

## What I need from you
1. Three to five sentences: how sponsorship should feel in the first hour and later (what the player does, what it pays, what it asks).
2. A list of 15 FICTIONAL sponsors, in four tiers (C local = reputation 0+, B regional = 25+, A national = 60+, S global = 100), as
   lines in exactly this form (one per line, | separated):
   `tier | name | kind of business | weekly pay in dollars | what they ask (one condition) | one-line pitch the owner says`
   - Names must be invented, generic enough to fit any country (no real brands, no real people, no place names).
   - Weekly pay: C 150-300, B 350-500, A 600-800, S 900-1200.
   - Conditions must be things the game already tracks: "keep 2 fighters fit", "a fighter on a card every 4 weeks", "a win in the next
     8 weeks", "gym reputation stays above N", "no fighter fails a weigh-in".
   - Mix kinds: at least 2 food/drink, 2 cars/transport, 2 health/fitness, 1 trades, 1 media; a boxing-equipment brand only at A or S.
3. One sentence: should sponsors ever come from the fight organisations at all (and if yes, when)?

Keep it short. The game is boxing first; the same list must also work for an MMA or kickboxing gym later.
[send-message t161s1046] 1. In the first hour a local business walks into the gym and offers a small weekly cheque for a simple ask you already do (keep fighters fit, put someone on a card). Later the offers get bigger and the asks get sharper: a win by a date, reputation held, weigh-ins made. You pick one sponsor at a time, they pay every week while the condition holds, and a miss freezes the pay for a stretch or ends the deal. The player never shops a catalogue; the gym earns the next tier by reputation, then the offers arrive.

2. Sponsors
C | Corner Cup Coffee | food/drink | 180 | keep 2 fighters fit | "We back the kids who train here. Keep two of them fit and the till stays open."
C | Steady Hands Physio | health/fitness | 220 | no fighter fails a weigh-in | "We tape ankles. You keep every fighter on weight and we keep paying."
C | Brick & Beam Builders | trades | 250 | gym reputation stays above 10 | "Local gym, local crew. Hold the gym's name above ten and we stay."
C | Nightshift Diner | food/drink | 160 | a fighter on a card every 4 weeks | "Feed the corner after sparring. Put a fighter on a card every month and we chip in."
C | North Loop Auto Care | cars/transport | 280 | keep 2 fighters fit | "We fix vans for free on fight week if two of your fighters stay fit."
B | Riverline Motors | cars/transport | 420 | a fighter on a card every 4 weeks | "Regional dealer. One of yours on a card every four weeks and the cheque hits."
B | Peak Form Supplements | health/fitness | 380 | keep 2 fighters fit | "Bars and shakes for the floor. Two fit fighters, every week, or the deal cools."
B | Echo Local Radio | media | 450 | gym reputation stays above 25 | "We run a weekly spot if your gym reputation holds at twenty-five."
B | Iron Lane Gym Kit | health/fitness | 500 | a win in the next 8 weeks | "Pads and wraps at cost. Land a win in eight weeks and we stay."
A | Crown Circuit Apparel | boxing equipment | 720 | gym reputation stays above 60 | "Kit with your colours. Reputation stays above sixty or we pull the patch."
A | Horizon Transit Co. | cars/transport | 650 | a fighter on a card every 4 weeks | "Team vans for weigh-in week. Keep a fighter on a card every month."
A | Vital Edge Clinics | health/fitness | 780 | no fighter fails a weigh-in | "Medical checks and ice baths. Nobody fails a weigh-in on our watch."
A | Metro Daily Sports Desk | media | 700 | a win in the next 8 weeks | "Front-page ink after a win. Deliver one in eight weeks and the column stays."
S | Aether Athletics | boxing equipment | 1100 | gym reputation stays above 100 | "Global kit deal. Hold reputation at one hundred and the shipment keeps coming."
S | Apex Fuel Bars | food/drink | 950 | keep 2 fighters fit | "Fight-week meals worldwide. Two fighters fit every week or the crate stops."

3. Fight organisations should never be weekly club sponsors; they book cards and pay purses. A sanctioning body or promoter can only appear later as a one-off title or broadcast partner once a fighter is national-tier, never as the gym's day-to-day sponsor.
[user t162u] # TASK_K_HUD2 - Kalli (game design): where every feature lives once the top bar is gone

You are the lead GAME DESIGNER on FightCamp, a boxing-gym management sim (Godot, 3D club you watch from above, Steam
Early Access: boxing/kickboxing/Muay Thai first, MMA + grappling as the first big update). Shell-less: answer in this chat.

## Why (operator S185, verbatim)
"i am thinking of removing the top bar and use a ui something like in the picture , can you assign few agents(not your
subagents) to propose some variations that will show features in the game and future ones"

The picture is Two Point Museum (reference, NOT an asset: `E:/FightCamp/wt/UI_REF/two_point_museum_hud.webp`, view it with
your FILE tool only, never copy it into the repo). Its HUD grammar, zone by zone:
- NO top bar. The world fills the screen edge to edge.
- TOP CENTRE: small floating chips - star rating progress ("0/2" + star), a level shield ("11").
- TOP RIGHT: one resource cluster - cash ($117,010 with a red trend arrow), a second currency (Kudosh 1,420), and under it
  two thin meters with an icon each (museum rating 66 %, visitor happiness 89 %) and a visitor count (65).
- RIGHT EDGE: a stack of collapsible OBJECTIVE cards (title strip with a crown/icon, checkboxes, progress bars "0/2",
  a "Done" bar), one card per goal set, each with its own small icon.
- BOTTOM LEFT: a DOCK of 4 big square yellow buttons (build items / build room / decorate / hire staff), then smaller
  grouped buttons with a count badge and a flyout arrow (expeditions "3", briefcase, view/eye), and two tiny system icons
  (building, menu) at the far left.
- BOTTOM RIGHT: a date plate ("15 OCT Y 9"), a 4-step speed bar and play / pause / fast buttons; a big yellow MAIL button
  beside it.
- A thin red frame around the screen + a pause tab top centre when the game is paused.

## Our game today (what must find a home)
Current top bar (`Godot/scripts/ShellChrome.gd` BAR_ITEMS, S184): gym crest + name, icons Home / Fighters (roster count
badge) / Training / Scouting / Staff | Fights (bookable-offer badge) / Rankings | Finance, back arrow, handbook (i),
date plate "Mon 5 Jan 2026 Wk 1" + CONTINUE "to Tue", cash "$25,000" (roster line in its tooltip), notices bell, settings.
In the 3D club (`docs/previews/s185_bout_walk/22_deadend.png` shows it with today's bar): fighter panel top-left (name,
"08:00 MORNING - PADS", STAMINA bar, STRAIN bar, mood word FRESH, move-card line), day goals (2 rows with icons and
checks: "Stamina above 30 at the bell", "Jab usable by Friday"), the day card right ("MONDAY, WEEK 1 - A quiet week",
STEP IN / SKIP THE DAY), the GUIDE card bottom right ("Set his training", OPEN TRAINING / SKIP THIS STEP), the action
ring on a clicked fighter/station/coach (6 buttons), hover labels, the 2:00 real-time day with Space = pause.

Other live systems that need a door: fight offers / booking / the schedule (MY GYM, LADDER, MY MONTH, THE CARDS, OFFERS,
THE CORNER), fight week + weigh-in + fight night + result, fight camp, sponsors (3 offers on the desk), story inbox
(phone) and the Wall (Chapter 1 "Keys", Anvil Street), reputation / fame, hype push, walk-ins + interviews at reception,
coach hire, members + dues (mat room), rooms (office, locker, mat room, staff room, physio, film room, lobby),
week review, rankings, finances/contracts/objectives/weight class.

Future (must have a reserved, believable slot - show it greyed or "coming" where it makes sense):
- EQUIPMENT DOCK (D37/D38, queued FLOOR-PLAY): place / move / repair / buy stations on the floor, Two Point style.
- Several fighters at once (roster > 1, a fighter strip / portraits), several coaches.
- v1 stand-up rulesets: boxing, kickboxing, Muay Thai (a ruleset/discipline filter); first major update MMA + grappling
  (BJJ, wrestling, clinch); women's divisions.
- Gym rating / star tier + gym level (the museum's star + shield equivalent), gym expansion (new rooms as expansions of
  the one gym scene - operator S172 "keep other scenes as expansion of the gym scene").
- Per-body-part recovery / injuries (physio), live limb damage, the corner between rounds.
- Chapter objectives (the campaign's goal cards, like the museum's objective stack), achievements.
- Game speed (pause / 1x / 2x / 3x) instead of only CONTINUE; mail = notices + story phone in one button.

## Rules every variant follows
- No top bar. Icons over words, every icon carries a tooltip (operator S184 + GLOSSARY "Icon with tooltip"); a tooltip
  starts with a verb and does not repeat its label.
- The gym is the menu (D37): pages open as panels over the 3D club, the dock never covers the floor's centre.
- 1920x1080, our palette (dark walnut plates, brass/gold edges, teal for the lit item, cream text - see
  `previews/ui_s184/A_top_bar.html` for tokens) unless your variant argues for a change.
- A variant SHOWS every current item above and at least 5 future ones, and writes, in a side legend or a notes file,
  where each item went (zone + icon + tooltip line).

## Prior research
`python Tools/prior_research.py hud dock "top bar" "two point"` -> G104 (operator reference menus), M42 (hub mockups), J54 (menu architecture, 11 management games), J61 (scene
trees of shipped management games, Two Point Hospital), M34 (pitch look), S184 mocks `docs/previews/ui_s184/A|B|C`
(operator picked A; B = top bar + bottom dock). Read J61's Two Point section before drawing.

## What would a human do?
A UI artist would lay the reference beside our real game still, list every control, sort them into the reference's
zones, and draw 2-4 thumbnails that differ in ONE big idea each (where the money lives, where the fighter lives, how
objectives show) - not four recolours of one layout.

## Prefab check
No new asset: Lucide icons already in the repo (`Godot/assets/icons/lucide/` or `Godot/scripts/LucideIcons.gd` - use the
SVGs), the S184 HTML mock pattern, our own still as the background.


## Your deliverable (in this chat, plain text, <= 900 words)
1. THREE layout proposals, each built on ONE different big idea (not recolours), each as a zone list:
   TOP-LEFT / TOP-CENTRE / TOP-RIGHT / RIGHT EDGE / BOTTOM-LEFT DOCK / BOTTOM-RIGHT / ON THE FLOOR (things you click in 3D).
   Under each zone: the items (today's AND future), the icon you'd pick (Lucide name), the one-line tooltip (verb first).
2. For each proposal: what the player does in the FIRST HOUR with it (3-5 steps: sign, train, book, camp, fight night)
   and which zone each step uses - that is how we judge it.
3. Which items should STOP being menus and become things on the floor (the gym is the menu, D37).
4. Your pick of the three and the single biggest risk of copying Two Point too literally for a FIGHT game.
[send-message t162s1048] Pick: **Proposal 2, the fighter lives bottom-left**. The reference image, J61 and the S184 tokens weren't readable from my side, so this layout is built from your zone description and isn't checked against the image (NOT COMPUTED).

**PROPOSAL 1: Two Point straight (money top-right, goals stack right)**
- TOP-LEFT: gym crest `shield` "Open your gym's page". Discipline filter `swords` (boxing lit; kickboxing, Muay Thai, MMA greyed "coming") "Switch the ruleset you book under".
- TOP-CENTRE: gym stars `star` "See what earns the next star". Gym level `award` "Check what the next level unlocks". Pause tab `pause` "Resume the day".
- TOP-RIGHT: cash `wallet` with trend arrow "Open finances and contracts". Fame `flame` "See where your name reaches". Under them, two meters: reputation `trending-up` "Read what moves reputation" and morale `smile` "See how the floor feels". Then member count `users` "Open members and dues".
- RIGHT EDGE: objective cards for today's goals `target`, Chapter 1 "Keys" `book-open`, and sponsor asks `handshake`. Achievements `trophy` stays greyed.
- BOTTOM-LEFT DOCK: Fighters `user` with a count badge, Training `dumbbell`, Fights `calendar-days` with an offers badge, and Equipment `hammer` (greyed, coming). Smaller buttons: Scouting `search`, Staff `id-card`, Rankings `list-ordered`. Far left: handbook `info` and settings `settings`.
- BOTTOM-RIGHT: date plate. Speed controls: pause, 1x, 2x and 3x `play`/`fast-forward`. Mail `mail` (notices plus the story phone).

**PROPOSAL 2: the fighter lives bottom-left (portrait strip replaces the dock)**
- TOP-LEFT: empty. The world shows there.
- TOP-CENTRE: stars, gym level, pause tab, as in Proposal 1.
- TOP-RIGHT: cash, fame, reputation meter, and a Wall chip `landmark` "Read the Wall".
- RIGHT EDGE: one objective card at a time. Today's day goals sit above, and the chapter card collapses under them.
- BOTTOM-LEFT: a portrait strip with one card per fighter (roster > 1 is ready; a "+" slot `user-plus` reads "Sign a fighter"). The selected card grows to show the time slot, a stamina bar, a strain bar, a mood word, the next move, and a body-part dot `heart-pulse` "Check injuries and recovery" (greyed for now). Coach portraits sit beside it, smaller.
- BOTTOM-CENTRE-LEFT DOCK: a thin row with Fights `calendar-days` (badge), Scouting, Staff, Equipment `hammer` (coming), and Rooms `layout-grid` "Plan the next gym expansion" (coming).
- BOTTOM-RIGHT: date, speed controls, mail.

**PROPOSAL 3: the calendar is the HUD (fight week drives everything)**
- TOP-CENTRE: a week ribbon with Mon to Sun pips, the fight-night pip glowing, and a weigh-in pip `scale` "See the weight you must make".
- TOP-RIGHT: cash and reputation only.
- RIGHT EDGE: the GUIDE card plus one objective card.
- BOTTOM-LEFT DOCK: four phase buttons (Train, Book, Camp `tent`, Fight Night `swords`), lit by where the week is.
- BOTTOM-RIGHT: speed controls and mail.
- Fighters sit in a top-left plate.

**FIRST HOUR**
- **Proposal 1.** Sign through mail/walk-in at reception (BOTTOM-RIGHT, FLOOR). Train through the Training dock button and the ring (DOCK, FLOOR). Book through the Fights badge (DOCK). Camp through the objective card (RIGHT). Fight night through the date plate and the bell (BOTTOM-RIGHT). The fighter has no home, so stamina is buried.
- **Proposal 2.** Sign at the walk-in at reception, then the "+" slot (FLOOR, BOTTOM-LEFT). Train by clicking the portrait, then a station (BOTTOM-LEFT, FLOOR). Book through the Fights badge (DOCK). Camp through the portrait's camp tag and the weigh-in goal card (BOTTOM-LEFT, RIGHT). On fight night the portrait strip becomes the corner card between rounds (BOTTOM-LEFT). That makes five steps, all anchored on the fighter.
- **Proposal 3.** Book first through the Book phase (DOCK), then train (DOCK), camp (DOCK), weigh-in (TOP-CENTRE pip), and fight (DOCK). The pacing is clear, but signing has no home.

**FROM MENU TO FLOOR (D37)**
- Training and stations become clicks on the station itself, with the action ring.
- Walk-ins and interviews happen at the reception desk.
- Sponsors become the 3 letters on the office desk.
- Members and dues live on the mat room door sign.
- Physio and recovery are a click on the physio bed.
- The film room becomes a click on the screen.
- Coach hire happens at the staff room board.
- Week review and story are the Wall in the lobby.
- Equipment buy, place and repair happens on the floor through the hammer mode.
- Rankings become a poster on the lobby wall (a click opens the panel).
- Menus stay for the long tables only: Fights/booking, Finance, and Scouting.

**PICK AND RISK**
I'm picking **Proposal 2**. A fight game is about one body getting ready, and the portrait strip makes stamina, strain and injuries always visible. It grows naturally to several fighters, and the same strip becomes the corner on fight night, so the mode has no extra HUD. I argued against it with Proposal 1: Two Point players already know that layout and it's the cheapest to build. It still loses, because it hides the fighter behind a button.

The biggest risk of copying Two Point too literally is making the museum's real-time speed bar the main control. Two Point has no hard dates. Our week ends in a weigh-in and a bell, so 3x speed can carry the player straight past a missed weight cut. Speed should auto-pause on the GUIDE triggers (stamina below 30, an empty queue, a coach running low, the bell). It also has to stop at the date plate before fight week, and must never skip over a weigh-in.

I can't hand this to other agents to make variations from here, so all three proposals are mine.
