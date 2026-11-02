# K85 - Scene tree review and Kalli's own tree (navigation and UX)

| Field | Value |
|---|---|
| Task | K85 |
| Date | 2026-10-03 |
| Agent | Kalli (words, flow, research; no code, no look work) |
| Reads | SCENE_TREE_REVIEW_INPUT.md (in the task), TRAINING_LOOP_DESIGN.md, FLOW_PASS2_ROUTE_WORDS.md, S148_SCHEDULE_TUTORIAL_DESIGN.md, topics/gym_rooms_art.md, J54_MENU_ARCHITECTURE_SURVEY.md |
| Pictures | `previews/k85/k85_scene_tree.png`, `previews/k85/k85_training_floor.png` |
| Honesty | COMPUTED = read in the input map or a prior file this pass. NOT COMPUTED = needs the game code or a play. I did not open the game code. |

## Three lines first

1. Make the gym floor the only hub. HOME and "the training floor" are the same place today, split in two. Merge them.
2. Make the four rail items open four rooms (HOME = floor, FIGHTERS = locker room, FIGHTS = front desk, FINANCE = office). Delete the three "area" pictures. The rail stops being a second menu.
3. Give every screen one home room, give every object in a room a job that no other object has, and never lock a base function behind a tier.

## 1. VERDICT on the current tree (ranked, what confuses a new player)

1. One screen sits behind many doors. Schedule has 3 (Office, Locker room, FIGHTS). Staff has 5 (three objects in the Staff room, the Mat room coach, FINANCE). Scouting has 3, Finances 2 (+ Mat dues board), Training 2. The player cannot learn where anything lives, because it lives everywhere.
2. The rail and the rooms are two menus for the same things. FIGHTERS, FIGHTS and FINANCE are three painted area pictures that repeat what the rooms hold, with different names.
3. The room called the training floor trains nothing. It is a hallway of 7 doors, and the only way to train a move is buried in the fighter profile.
4. HOME and the floor are two hubs one click apart, with overlapping pins (Office, Staff room, ring, floor).
5. The doors lie. Staff room is locked until tier 4 though a tier-1 gym must hire a coach. Film room has no door in the map at all.
6. Area names lie. FINANCE holds Office, Staff and Contracts, and "Office" is both a room and a link inside FINANCE.
7. Some rooms own no screen. The Mat room's two objects both leave it. The Front desk only leaves.
8. One word, two jobs. "Scouting" means finding new fighters (FIGHTERS area) and studying an opponent (Film room folders). "Weight class" is an Office tab but the scale is in the Locker room.
9. Three Film room objects open the same camp page, and two Staff room objects open the same Staff page. Three doors, one room.
10. Every room has one exit, "Back to the floor", so a trip between two rooms costs two extra clicks and the player is never told the rail is faster.

## 2. THE TREE (every scene, its objects, the ONE job each does)

Rule for the whole tree: a room is a place, an object is a verb. Tier changes the picture and the size of a room, never whether a base screen can be reached. A room may be locked only when every screen in it is a bonus (Physio, Mat room), and then the door shows padlocked with the unlock in its tooltip, never missing.

- **THE GYM FLOOR (= HOME, rail HOME).** Job: run today.
  - NEXT UP card (overlay, not an object). Job: the one thing to do next, one gold button, which jumps to the home room of that thing. It is a pointer, never a home.
  - OBJECTIVES list (overlay, top right). Job: this chapter's 3 goals (S148, K84 rule 7).
  - HEAVY BAG, SPEED BAG, PAD LANE, RING (stations). Job: train a move (section 4). Ring also runs gym sparring.
  - WEEK PLAN (clipboard). Job: plan the 7 days at once (the current Training planner, kept for power users).
  - SPAR CARD (appears when a spar is booked). Job: watch spar night.
  - Coaches and fighters (scenery). Job: none, hover card only.
  - DOORS (front wall, icon + tooltip): FRONT DESK, OFFICE, LOCKER ROOM, STAFF ROOM, FILM ROOM, PHYSIO (padlock), MAT ROOM (padlock).
- **FRONT DESK (rail FIGHTS).** Job: the fights outside the gym.
  - Calendar board. Job: when. Opens SCHEDULE (S148: NEXT UP, then my obligations by week).
  - Offers tray. Job: who wants us. Opens OFFERS.
  - Rankings wall. Job: where we stand. Opens RANKINGS with THE LADDER on top (S148 section C).
- **OFFICE (rail FINANCE).** Job: money and papers.
  - Desk books. Opens FINANCES (the books).
  - Contracts cabinet. Opens CONTRACTS.
  - Photo wall. Opens FORMER FIGHTERS.
  - Phone. Opens PROMOTIONS (NOT COMPUTED: what that panel holds today. If it is incoming bout offers it folds into the Offers tray and the phone is cut. If it is sponsors and promoters it stays.)
- **LOCKER ROOM (rail FIGHTERS).** Job: my fighters.
  - Locker wall. Opens ROSTER (list or lockers view). Each filled locker opens that fighter's PROFILE.
  - Empty locker. Opens SCOUT (find a fighter to sign). A free locker is the door to filling it.
  - Scale. Opens WEIGHT CLASS (weight, cut, weigh-in).
  - Fight-week board. Opens FIGHT WEEK for the booked bout. With no bout booked it shows "No bout booked" and nothing else.
- **STAFF ROOM (no rail item).** Job: my people.
  - Staff board. Opens STAFF (pay, assign, release).
  - Empty seat (one per open slot). Opens HIRE for that role.
  - A coach (seated). Hover card, click opens that person's card as a pop-up, not the Staff screen.
- **FILM ROOM (no rail item).** Job: the next opponent.
  - Projector. Opens STUDY (footage and tendencies on one page).
  - Laptop. Opens GAME PLAN (my plan for that bout).
  - Both are views of the camp page for the booked bout, one page with two tabs.
- **PHYSIO (padlock until tier 4).** Job: who is hurt.
  - Body chart. Opens that fighter's PROFILE on the BODY tab.
- **MAT ROOM (padlock until tier 3).** Job: the grappling wing.
  - Mat stations. Job: train a move, same as the floor.
  - Class board. Opens CLASSES (NOT COMPUTED: whether a classes panel exists. If not, this object waits until it does.)
- **Not in the demo tree, deferred:** THE CITY (world map, other gyms), Dorms, Media office.

Picture: `previews/k85/k85_scene_tree.png`.

## 3. Where each thing lives (one home each, and who only shortcuts)

| Thing | ONE home | Shortcuts to it (and nothing else) |
|---|---|---|
| Schedule | FRONT DESK, calendar board | NEXT UP gold button when the next thing is dated. A "date" chip on a bout offer. Never an object in another room. |
| Staff and hiring | STAFF ROOM (staff board, empty seats) | A "payroll" row in the books shows a PEOPLE chip. A coach card on the floor shows a STAFF chip. |
| Training (moves) | THE GYM FLOOR, the stations | WEEK PLAN clipboard (same floor). The profile Skills page shows a TRAIN chip that opens the station drawer. |
| Fight week | LOCKER ROOM, fight-week board | NEXT UP gold button (SET CAMP, WEIGH IN) on the days that matter. Continue stops there. |
| Scouting | Two homes by two words: SCOUT (recruits) in the LOCKER ROOM empty lockers. STUDY (opponent) in the FILM ROOM. | The Offers tray shows a STUDY chip on an opponent. |
| Contracts | OFFICE, cabinet | A contract chip on the fighter profile. The fight contract overlay stays an overlay of a booking, not a home. |
| Finances | OFFICE, desk books | A cash figure in the top bar is display only. Mat room class board shows income as a number with a BOOKS chip. |

**How a shortcut looks different from a home.** A home is a painted object that glows gold-edged on hover and has a name tooltip. A shortcut is a small round icon-only chip with an outward arrow, no painting, and a tooltip that names the home ("Opens SCHEDULE, front desk"). The screen it opens always shows the same breadcrumb (FRONT DESK > SCHEDULE) whichever way the player arrived, so the player learns the real address.

## 4. THE TRAINING FLOOR as the place you train (TRAIN1)

Loop: station, fighter, move with animated preview, TRAIN THIS. The floor stays visible and live behind a right drawer (640 px wide). It extends TRAINING_LOOP_DESIGN section 6 and the operator's S150 comment 3.

1. **Click a station** (heavy bag). The bag lights, the drawer opens. Nothing else on the floor is dimmed.
2. **WHO.** Fighter chips with name, condition and a state: fit, tired, hurt (locked, with the reason in a tooltip). The default is the fighter with the nearest bout (TRAINING_LOOP section 2).
3. **WHICH MOVE.** The moves this station trains, each with mastery pips and the grade. A locked move shows what it needs in a tooltip. Moves already trained to the top grade are listed last.
4. **PREVIEW.** A looping clip of the selected move on this station, with play, slow and 1x. It uses the four honesty states already ruled in K74: exact clip, near match, no clip yet, no motion. With no clip the viewport is replaced by a facts strip (needs, builds, next grade), never a failure message.
5. **COST AND GAIN.** Fatigue before to after, the loaded body region, progress toward the next point as a bar (the engine gains are fractions, so the bar is what proves the work landed), the coach quality, the station condition.
6. **TRAIN THIS.** The one gold button. It sets today's slot for that fighter at that station on that move. A repeat icon toggle copies it across the week.
7. **On the floor.** The fighter walks to the station and the loop plays, the coach barks one line, the bar float lands at the bell (TRAINING_LOOP sections 2 and 4).

Gold rule: with the drawer open, TRAIN THIS takes the gold and NEXT UP's button goes slate. One gold per frame.

Picture: `previews/k85/k85_training_floor.png`.

**NOT COMPUTED, needed to build this.**
- A station-to-moves table. Claude's proposal says each station trains certain moves, I found no such data in the files I read.
- Whether technique training (`GameState.assign_technique_training`) takes the same daily slot as a station activity or a second slot. If it is a second slot, TRAIN THIS must set both and the drawer must show it.
- Whether every move has a clip. The facts-strip state exists so that the answer does not block the build.

## 5. Agree or disagree with Claude's rule

Claude's rule: every object in a room does ONE different job, every screen has ONE home room, the left rail is the always-there shortcut.

- **Agree** with the first two. They are the cure for verdict 1 and 9.
- **Disagree with the third as written.** If the rail opens area pictures (FIGHTERS, FIGHTS, FINANCE) that differ from the rooms, it is a second tree, not a shortcut. The rail must open the same four rooms the doors open, one for one. I would rather lose three painted area pictures than keep two ways to name one place.
- **Add two limits the rule is missing.** (a) A room that owns no screen is a hallway and is not allowed (Mat room, Front desk today). (b) A tier may change a room's look and size, never whether a base screen can be reached.
- **Add one definition.** "Home" means the room whose name is in the screen's breadcrumb. Everything else is a shortcut and must look like one.

## 6. THE CLICK LEDGER (all 53 clicks in the input map)

K = KEPT, M = MOVED (to where), C = CUT (why).

| # | From | Click | Result | Fate |
|---|---|---|---|---|
| 1 | Rail | HOME | HOME | K. HOME is the gym floor. |
| 2 | Rail | FIGHTERS | FIGHTERS area | M to LOCKER ROOM. |
| 3 | Rail | FIGHTS | FIGHTS area | M to FRONT DESK. |
| 4 | Rail | FINANCE | FINANCE area | M to OFFICE. |
| 5 | HOME | Office pin | Office | K as a floor door. |
| 6 | HOME | Staff room pin | Staff room | K as a floor door. |
| 7 | HOME | The ring pin | Training | M to the RING and bag stations on the floor (section 4). |
| 8 | HOME | Gym floor pin | The training floor | C. HOME is the floor, a pin to itself. |
| 9 | FIGHTERS area | Roster | Roster & floor | M to LOCKER ROOM locker wall. The "floor" half is C. |
| 10 | FIGHTERS area | Training | Training | M to the floor: stations plus the WEEK PLAN clipboard. |
| 11 | FIGHTERS area | The floor | The training floor | C. Same as HOME. |
| 12 | FIGHTERS area | Scouting | Scouting | M to the LOCKER ROOM empty lockers (SCOUT, recruits). |
| 13 | FIGHTS area | Schedule | Schedule | M to FRONT DESK calendar board (the one home). |
| 14 | FIGHTS area | Rankings | Rankings | M to FRONT DESK rankings wall. |
| 15 | FIGHTS area | Offers | Fight offers | M to FRONT DESK offers tray. |
| 16 | FINANCE area | The books | Finances | M to OFFICE desk books. |
| 17 | FINANCE area | Office | Office desk | C. A second door to the Office. |
| 18 | FINANCE area | Staff | Staff | C. Staff lives in the STAFF ROOM. The books payroll row gets a PEOPLE chip. |
| 19 | FINANCE area | Contracts | Contracts | M to OFFICE cabinet. |
| 20 | Floor | Door: front desk / street | Front desk | K. |
| 21 | Floor | Door: office | Office | K. |
| 22 | Floor | Door: locker room (tier 2+) | Locker room | K, but open from tier 1. |
| 23 | Floor | Door: mat room (tier 3+) | Mat room | K, padlocked until tier 3 (bonus room). |
| 24 | Floor | Door: staff room (tier 4) | Staff room | K, but open from tier 1. A tier-1 gym must hire. |
| 25 | Floor | Door: physio (tier 4) | Physio | K, padlocked until tier 4 (bonus room). |
| 26 | Floor | Spar card: watch | Spar night | K. |
| 27 | Front desk | Out to the city | FIGHTS area | C. The Front desk is now the fights room. A real city map is deferred. |
| 28 | Front desk | Back to the floor | Floor | K. |
| 29 | Office | The books | Finances | K. |
| 30 | Office | The phone | Promotions | K, conditional (NOT COMPUTED, see section 2). |
| 31 | Office | Contracts cabinet | Contracts | K. |
| 32 | Office | Fight calendar | Schedule | C. The operator's first complaint. Schedule lives at the Front desk. |
| 33 | Office | Photo wall | Former fighters | K. |
| 34 | Office | Back to the floor | Floor | K. |
| 35 | Locker room | The scale | Weight class | K. It becomes the only home of WEIGHT CLASS (the Office tab is C). |
| 36 | Locker room | Fight-week board | Schedule | M. It opens FIGHT WEEK, not Schedule. The operator's second complaint. |
| 37 | Locker room | A fighter's locker | Fighter profile | K. |
| 38 | Locker room | Back to the floor | Floor | K. |
| 39 | Mat room | Dues board | FINANCE area | C. Money lives in the Office. The board shows class income as a number with a BOOKS chip. |
| 40 | Mat room | The coach | Staff | C. The coach is scenery with a hover card. |
| 41 | Mat room | Back to the floor | Floor | K. |
| 42 | Staff room | Staff board | Staff | K. The only home of STAFF. |
| 43 | Staff room | Hiring noticeboard | Staff | M to the empty seats (HIRE for that role). |
| 44 | Staff room | A coach | Staff | M to a pop-up card for that person. |
| 45 | Staff room | Back to the floor | Floor | K. |
| 46 | Physio | A fighter's body chart | Profile - body | K, as a tab-door. |
| 47 | Physio | Back to the floor | Floor | K. |
| 48 | Film room | Footage screen | Profile - camp | M to the projector (STUDY). |
| 49 | Film room | Tendencies board | Profile - camp | C. Merged into STUDY, same page. |
| 50 | Film room | His record (folders) | Scouting | C. The opponent's record is on STUDY. Recruit scouting is in the Locker room. |
| 51 | Film room | Game plan (laptop) | Profile - camp | K as the laptop (GAME PLAN). |
| 52 | Film room | Other files | Scouting | C. Same reason as 50. |
| 53 | Film room | Back to the floor | Floor | K. |

Tally: KEPT 26, MOVED 16, CUT 11. Two additions, not in the map: a FILM ROOM door on the floor (the map has no way in), and a WEEK PLAN clipboard on the floor (a home for the existing planner). THE DAY (`day_feed`) is not in the input map. I treat it as the NEXT UP card plus the inbox on HOME. NOT COMPUTED: whether the code still mounts it as its own scene (see FLOW_PASS2).

## 7. Prefab check: a shipped game whose navigation I would copy

- **Football Manager 26.** The Portal home gathers messages, upcoming fixtures and a two-week calendar snapshot in tiles that each open into a card, with a navigation bar always at the top ([FM26's Reimagined UI](https://www.footballmanager.com/fm26/features/fm26s-reimagined-user-interface), opened in K84, developer text). I would copy the rule that the home is a set of "what needs me" tiles and that every tile has one destination. That is what NEXT UP and the objectives overlay do on our floor.
- **Motorsport Manager.** Home is an overview whose stat bars link to the page behind them, and a required mail item blocks Continue until it is answered (J54, from the Steam guide S26 listed there, community source). I would copy "an overview that links out" for the floor overlays.
- I found no source in the files I read describing a game whose home is a physical place with doors the way ours is. That part is JUDGEMENT. TRAINING_LOOP_DESIGN cites Two Point's rooms for the door idea, I did not open a page for it this pass.

## 8. Arguing against my strongest ruling

My strongest ruling is merging HOME and the floor into one scene. Against it: HOME must be calm and answer "what needs me", and a floor with 5 stations, 7 doors, NEXT UP, objectives and a coach barking is the busiest picture in the game. J54 recommends a quiet overview (OOTP and Motorsport Manager style) as the home. On a 1920x1080 painted still that is about 14 click targets, past the point where a new player scans, and the operator's 87% CPU PC pays for the living loop on the most-visited screen.

I keep the merge, with three limits. Doors are painted doors with icon tooltips, not labelled pins. Only the one or two things that need the player glow amber, as HOME does today. The living loop plays only for the fighters training today. The two-hub version costs the player a click and a name on every trip. NOT COMPUTED: whether 14 targets reads. A five-second test on one painted mock (what do you do next, where is the schedule) would settle it, and the K80 five-second test is the same one.

## WHAT IS STILL WRONG

- I did not open the game code. Promotions, Classes, the Weight class tab and THE DAY are placed by judgement and marked NOT COMPUTED.
- The station-to-moves table and the technique-slot question (section 4) are unanswered.
- Staff room open from tier 1 costs Maria a tier-1 look for it. NOT COMPUTED how much.
- Film room has no door today, so the new floor door needs a place in the painted still.
- The rail word FINANCE now opens the Office. A tooltip should say "Money and contracts". K78 left the same clash open.
- The Handbook button is S148's top bar slot. This review adds no new Handbook rule.
- No picture of the real painted HOME was available to me, so the floor merge was designed from the map, not from the screenshot.
