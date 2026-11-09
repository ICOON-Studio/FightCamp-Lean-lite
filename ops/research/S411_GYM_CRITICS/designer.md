# Gym design review (designer, S411)

Read: CRITIC_PACK, CRITIC_ACCESS, FACTS, all seven pictures, GymHub.gd, IsoGym.gd, gym_plans.json, GYM_LAYOUTS_S408. Earlier scores ignored.
My 10/10 picture: `E:/FightCamp/Lean/docs/mockups/s411/gym_10/designer.png` (source `designer.html` beside it). Triangles mark what the game does not do yet.

## Scores
**PRESENTATION: 5/10** (capped by hard fails; without them 6).
Hard fails:
1. A pin that sits on nothing. World hangs at the end of the bag wall and runs into the building edge; the owner sees it. Playbook is pinned on the mats, which are the no-gi zone, so it is the "playbook is on the door" error again (S408).
2. Layout B mixes three looks: a photo of another gym behind a vector isometric building, a lone 3D boxer floating at the right, and a flat sticky-note board. A gym drawn inside a photo of a gym. Layout A is consistent but the needs board, the first thing the player must act on, is under the fold.
3. The scene is a small object in empty pastel: 1200 px wide on 1920, with about 40% of the screen void, while the dark, full-bleed Fighters and Versus pages the owner likes fill the screen.
Good: the figures animate and read as boxers, the ring is a strong centrepiece, the data-driven plan is sound, the top bar works.

**OPTIONS: 5/10.** Six pins, five of which repeat the top bar word for word. Almost nothing on the gym is state: only Reception carries a badge (`needs()` returns 1 only for the walk-in). The people cannot be clicked. Nothing shows roster places, a booked fight, a bill due or a hurt boxer.

## Is the owner right that it feels small? Yes, but not because the building is small.
Real numbers (web search: a 20 ft amateur ring needs about 23-24 ft square with apron; startup guides say 2,500 sq ft minimum, 800-1,000 sq ft is the low end for a small club). Our plan: 24 x 18 cells, ring 8 x 8. A ring plus apron is about 7 m, so a cell is about 0.9 m, so the building is about 22 x 16 m, about 3,700 sq ft. **That is larger than a typical amateur club.** The ring is 15% of the floor; real small clubs give a ring 25-30%. Proportions are fine. So the feeling comes from:
1. Screen: the picture uses 700 of 1080 px and a diamond fills only half its bounding box. Real fix: scale up, full-bleed, let the corners go under the HUD (my picture: about 1390 px wide, 70% of the screen height).
2. Density: 2 + members/5 people, 8 at 30 members, each about 55 px tall. A 30-member gym on a Monday has 15-25 people. Real fix: more people (members as small ambient figures, the club's own fighters as the clickable ones), more props (speed bags, mirrors, wall posters, a scale).
3. It never grows. The whole career is one 24 x 18 plan, yet Money sells Unit 70 members / 3 places, Bigger unit 140 / 5, Club building 250 / 7. The four buildings picked at setup are all the same size class. A management player expects the picture to be a small unit first and to grow when he pays $12,000 to move. This is the largest real cause: the gym looks like the end of the game on day 1.
4. One camera, no zoom. Minor for a hub; a 3-step zoom helps only once the building is bigger than the screen.
What would only hide it: a bigger render of the same 24 x 18 plan, a darker backdrop, more labels.

## Which destinations belong in the scene
| Place | Verdict | Why and where |
|---|---|---|
| Fights (ring) | Belongs | The ring is the honest object. Click opens a small card on the gym (the offer, Accept / Pass / Full report), not a page. |
| Club office | Belongs | A desk is money and staff. Honest. |
| Reception | Belongs | Walk-ins and members. Badge when someone is waiting. |
| Fighters (bags) | Half | Bags are where boxers train, but the real click is a boxer. Make each club fighter clickable (opens that fighter), keep the bag wall as "all fighters". |
| Playbook | Does not belong as a place | A plan is per fighter and per opponent; it is a screen with a fighter in it, and the mat is the wrong zone. It lives on the fighter page and in Fight prep (where the plan is needed). In the gym it may be a **whiteboard on the wall** that opens the next booked fight's plan (a coach's board is a real object) - honest only if with no bout it opens a fighter picker. Never a pin on the floor. |
| World | Does not belong | There is no "world" in a building. Real object: a **wall TV** showing the news ticker and the ranking line ("Lucy enters at #6 on a win"), opens World. Honest, because the TV shows exactly what it opens. The top bar World pill stays. |
Gym or menu? Both, in the right order. The top bar is the menu. The gym is the club's status picture (who trains, the ring is booked, a need glows on its object, empty lockers show free roster places) with a few objects that are shortcuts to the same places. Click the gym floor: nothing. Click an object: the small card or the page. Click a boxer: that boxer. Labels on hover; badges always (only actionable ones, S398).

## Decisions table
| Decision | Verdict | Why | Rework cost |
|---|---|---|---|
| Isometric 2D gym as Home (S408) | KEEP, change scale | Right call; fill the screen | Small: fit and HUD layout |
| No left rail, top pills, bubbles on rooms (S408) | KEEP, change bubbles | Permanent dark labels cover the ring; badges always, names on hover | Small |
| Plans drawn from data, GymPlan.problems (S408) | KEEP | The base for growth and build-your-own | None |
| Four buildings picked once, small bonus each | CHANGE | Bonuses are real and good; but they must be the flavour of a small start, and Move premises must swap to a bigger plan of that flavour. Today a 70-member Unit starts in a 3,700 sq ft hall | Medium: 4 flavours x 3 sizes of data (or an extension overlay), same item art |
| Move premises (Money) as "later" | CHANGE: earlier | It is the cure for "small" | Medium |
| Build your own gym later (S408) | KEEP as later | Also conflicts with GAME_BIBLE line 54 ("facility building" out) and CLAUDE.md scope; reconcile in writing. Do growth first | None now |
| Rooms drawn empty, no pre-furnished room (S277/S278) | DROP for presets, KEEP for build-your-own | The presets are furnished; the rule belongs to the builder | Doc only |
| Planned 3D gym and Two Point alignment (S244) | DROP for the first release | A fixed 2D picture and a TPM free camera cannot both be the gym; CLAUDE.md already says "later, as views on the same data". Keep GymPlan as the one source; mark TWOPOINT_ALIGNMENT parked | Doc only |
| Gym is the menu | CHANGE | See above: status plus shortcuts | Small-medium |
| ONE top bar, nothing opens by itself (S268/S275) | KEEP | The click card opens only on a click | None |
| Home fewer words, bigger pictures (S411) | KEEP; A breaks it | A has The Job paragraph, Since last Monday, the notes board and the fighters table; B hides them. Home = scene + needs + next fight + club numbers; the rest to hover, Fighters, Club | Medium |
| Needs first (agreed Home) | KEEP | A puts it under the fold | Small |
| Fighters and Versus look (S410) | KEEP; bridge it | The dark warm photo style is the target; the pastel Home is the odd one out. Use the dark backdrop behind the building (my picture), not a second gym | Small |
| First-hour guide pointing at places | KEEP | Pulse the object, not a pin; guide strip stays one line | Small |
| People = 2 + members/5, cap 12 | CHANGE | Raise to the club's fighters (clickable) + ambient members up to about 20 | Small-medium (HubFigures) |
| Only actionable info (S398) | KEEP | Governs the badges | None |
| No-gi ships with boxing (mat zone) | KEEP | Mat becomes the no-gi athlete's object, hidden until she joins | Small |
| Roster places (3 at Unit) | ADD | Empty lockers = free places, click = Find a fighter | Small |

## Recommended direction
The gym is the Home screen and the club's status picture. Full-bleed on the dark backdrop, bigger, more people, objects not pins. A single small card opens on the gym for the ring. World becomes a wall TV, Playbook a wall whiteboard (or only on the fighter page). The start is a small unit and Move premises visibly grows the floor. Home text drops to needs, next fight and club numbers. Build neither layout as it stands: A for the buried needs and the empty void, B for the photo-in-a-photo and the missing note titles. Build my picture's arrangement (needs top left, next fight bottom left, club bottom right, gym full-bleed).

## To reach 10/10 (most important first)
1. Make the gym grow: start as a small unit plan (about 16 x 12 cells, one ring, 4 bags, 3 lockers), and make Move premises swap in the bigger plan of the same flavour (140 / 5, then 250 / 7), with the new floor shown as the dashed ghost before buying. Four flavours keep their bonuses.
2. Go full-bleed: scale the isometric plan to about 1400 px wide, centre it, let it use the whole screen under the top bar, and put the HUD cards in the empty corners. Drop the 700 px box and the scroll.
3. Remove the two lies: World pin becomes a wall TV (news line, new-mail count); Playbook pin leaves the mats and becomes a wall whiteboard that opens the next booked fight's plan (fighter picker if none), or goes to the fighter page only.
4. Make people the main clickable: each club fighter opens that fighter; members are ambient. 30 members shows about 20 figures, bigger props (speed bags, mirrors, posters, a scale).
5. Replace permanent labels with badges (actionable only: offer on the ring, walk-in at reception, bill at the desk, hurt boxer, weigh-in) and hover names; the first-hour guide pulses the object.
6. Click behaviour: the ring opens the small offer card (Accept / Pass / Full report); the desk, reception and boxers open their page; the empty floor does nothing; keys do not matter.
7. Show roster places as lockers (empty = Find a fighter), and the no-gi mat only when an athlete is signed.
8. One look: dark warm backdrop and light around the building, same as Fighters and Versus; delete the second photo gym and the lone 3D boxer from layout B.
9. Home keeps only needs, the next fight, the club numbers and one job line; The Job paragraph, Since last Monday and the fighters table move to hover, Fighters and Club.
10. Later: three zoom steps once a plan is larger than the screen; the builder after growth works; record in the docs that TWOPOINT and the old "empty rooms" rule are parked.
