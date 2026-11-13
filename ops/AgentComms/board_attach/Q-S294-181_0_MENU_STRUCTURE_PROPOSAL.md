# Menus and the look of the game: a proposal (S430, 2026-11-11)

The owner's words: "make the game look a serious AAA simulator/management. the menus/submenus still do not make much , can you
try and follow a structure like boxing managers scoped for our game . do you agree with this idea , or what do you rate the
current menu structure ?" and, on the fighter page: "it doesnt look good at all those wooden panels i think need to go and
change the design".

Short answer: yes, I agree with the idea. Today's structure is a 4 out of 10. Boxing Manager's is a 7. We should take how it
is organised and leave its tables, its codes and its empty weeks behind. Nothing here is built. He picks first.

Pictures (each 1920x1080, same Monday, same four fighters):

| Look | Dashboard | Squad |
|---|---|---|
| A, "Ringside" | `shell_a_dashboard.png` | `shell_a_squad.png` |
| B, "Fight week" | `shell_b_dashboard.png` | `shell_b_squad.png` |
| C, "The long view" | `shell_c_dashboard.png` | `shell_c_squad.png` |

## 1. The two ratings

### Today's menus: 4 out of 10
Checked against the code (`scripts/ui/Shell.gd`, `Main.gd`, `Routes.gd`, `GymHub.gd`, `areas/*.gd`). I agree with the 4.

1. ONE DOOR. The top bar has only "Gym" and "Mail". Every other place is a pin on the gym picture. Going from a fighter to
   the money is: back to the gym, find the pin, click. You never see where you are or what else exists.
2. THE NAMES DO NOT SAY WHAT IS BEHIND THEM. "Mail" opens the region's news, not messages for you. "Club office" is the
   money. "Reception" is the staff. "Equip the gym" is spending again. "Playbook" is a pin, but a playbook belongs to one
   fighter, so the pin has to guess whose.
3. NO PLACE FOR ALL FOUR. Training is planned one fighter at a time, four trips for four fighters. There is no page that puts
   the four side by side, and no compare outside a bout offer.
4. PAGES RUN OFF THE SCREEN WITH NO SCROLL BAR. The page scrolls but the bar is switched off, so what is below the fold is
   invisible unless you try the wheel. Home even needs a "More below" button.
5. IT DOES NOT FEEL LIKE ONE PROGRAM. Three looks (wood on slate, dark TV, cream whiteboard), and two shapes for the same
   thing: a boxer's page has four or five tabs, the grappler's page is one long page with a single tab.

What already works and must be kept: one button that runs the clock and says what it will stop for; the list of what needs
you; nothing opens by itself; every name is a link.

### Boxing Manager's menus: 7 out of 10
Good: a rail that is always there; a dashboard that leads with your boxers, each with a countdown; one gold button, always
in the same place, that runs time and turns into "go to the fight"; any row opens a page; a boxer's page with tabs across and
his actions down the side. Weak: more than fifteen things in the rail with halls of fame and settings mixed in; eight tabs on a boxer,
several nearly empty; half the dashboard is news about strangers; tables of short codes; weeks with nothing to do.

## 2. How Boxing Manager is organised (read from our 185 playtest screenshots, in our words)

| Where | What is there |
|---|---|
| Rail, always on the left | The advance button with a small menu (four weeks, to my next fight, to the next news), a "make a fight" button, then: my promotion, gyms, rankings, titles, amateurs, bouts, news, promoters, three halls of fame, create, options, load, community links, manual |
| Dashboard | A header strip (club, date, money, record). Two tabs: my stable, the world. My boxers as a short list with a countdown on each row, upcoming fights, my gym, news, a ticker along the bottom |
| One boxer | A header with his name, record and three ranking chips. Eight tabs across: overview, titles, schedule, attributes, record, career, condition, business. Down the left: his actions (training, growth, edit, kit) and one gold "make a fight" |
| Making a fight | Pick your boxer on the left. A table of possible opponents, or title shots. Under it five tabs about the picked man: overview, form, style, compare, terms. The answer is shown before you ask |
| Gym | Overview, scouting, trainers, upgrade, all gyms |
| Rankings | Weight classes as chips down the left, the bodies and regions as chips across the top |
| Fight night | The ring with a side panel (commentary, numbers, compare, officials). A card after each round. A result told judge by judge, then four report tabs |

The lessons we take: sections always visible; a dashboard that leads with your people and their countdowns; one gold button in
one place; a row always opens a page; tabs across, actions beside. What we do not take: codes for words, a rail of fifteen and more,
tables as the main picture, quiet weeks, a plan with no feedback.

## 3. The proposed structure for our game

Seven sections, always visible, in this order: **Home, Squad, Training, Fights, Gym, Money, World**. In the top bar, on every
page: the club, the date, back and forward, **Mail** with its count, the cash (click it for Money), the menu (save, load,
settings, handbook) and **the one gold button**.

The gold button is the only gold thing on any screen. It always does the next step: while something blocks the week it names
that thing and takes you to it ("Next: York Hall's one place"); when nothing blocks it runs the clock and says where it will
stop; on fight day it becomes "Go to the fight". This is today's CONTINUE button with the same rules (`Needs.go_state`,
`Main.on_go`), given one fixed place.

Each line: what the player does there, and what it is made from.

### Home
| Page | What the player does | Made from |
|---|---|---|
| Needs you | Answers what blocks the week, most urgent first. Each row is a picture or a number, one line, one button. Beside it: what is coming, the club's week in numbers, the four with their countdowns | `areas/Home.gd` with `HomeNeeds`, `HomeMatch`, `HomeRows`, `HomeSide` |
| Last week's review | Reopens Monday's report: what the week gave each fighter and what it cost | `modals/WeekReview.gd` (today it is a pop-up you cannot get back to) |

### Squad
| Page | What the player does | Made from |
|---|---|---|
| All four | Sees the four on the same rows, so comparing is reading across: numbers with the weapon and the weak spot marked, tiredness, weight, mornings, mood, the coach's one call, the next date. Opens one, or goes to plan the week | `areas/Fighters.gd` with `RosterCards`, `RosterTable`, `RosterSummary`, `FighterCard` |
| Compare two | Puts two of yours, or one of yours and an opponent, number against number. First use: who gets the one place on a card | `BoutCompare.gd`, `VersusPanel.gd` (today only inside a bout offer); new as a page |
| Find a fighter | Trials and walk-ins. Grey while all four places are taken | The "Find a fighter" part of `Fighters.gd`, `modals/Interview.gd`, `modals/Trial.gd` |

### One fighter (opens from any name, anywhere). Six tabs, the same six for a boxer and for the grappler
| Tab | What the player does | Made from |
|---|---|---|
| Profile | Reads who this is: numbers with their ceilings, style, traits, the goal, the contract. Sets the next goal, answers a rival gym's offer | `FighterPage.gd` Overview, `DarkOverview`, `AttrBoard` (this is the page the other designer is drawing: `overview_a/b/c`) |
| Condition | Watches weight against the limit, tiredness across the week, injuries, mood. Sets the diet, gives a rest day, answers an injury | The body half of today's Overview (`BodyFigure`, `WeekTired`, the injury row); split out so the Profile is not two pages in one |
| Training | Plans this fighter's week: mornings, evenings, pads | `WeekBoard.gd` and the `Week*` files |
| Playbook | Teaches moves, builds and drills combinations | `areas/Playbook.gd`, `ComboBuilder`, `DrillTray` |
| Fight plan | Reads the opponent's file, writes the plan's lines, sets the camp. Always in the same place; with no bout booked it says so and shows who is likely next | `FightPrep.gd`, `OppFileCard`, the "Game plan" page inside the Playbook, `modals/Camp.gd` |
| History | Looks back: every bout with its Why, the coach's notes, awards | `BoutHistory.gd`, coach notes, `AwardCard` |

The grappler keeps her own content inside the same six tabs: Profile, Condition, Training (her classes and the drill),
Playbook (her tree of moves), Fight plan (her next open), History (the belt road and her opens). Made from
`areas/GrapplerPage.gd`, `MatOpens.gd`, `MatTreeInfo.gd`.

### Training
| Page | What the player does | Made from |
|---|---|---|
| Club week | Deals the whole week for all four on one board: who has the paid seat, who gets the coached mornings and the pad places, who spars with whom. Every move shows what it gives one and costs another | New: the Club week board agreed in the four-fighter plan (`fourstart_map.md`). Until it is built this page shows the four weeks as four strips (`WeekStrip.gd`), each opening that fighter's Training tab |

### Fights
| Page | What the player does | Made from |
|---|---|---|
| Offers and asks | Answers offers, asks for a bout, sees what a fight week takes from the others | `areas/Fights.gd`, `OfferCard` |
| Calendar | Sees every dated thing ahead: bouts, weigh-ins, opens, championships, shows | `Fixtures.gd` (today drawn twice, on Fights and on World) |
| Results | Opens any past bout for its Why; the club's records | The results half of `Fights.gd`, `RecordsPage.gd` |
| One bout (from an offer) | Tale of the tape, the opponent's file, the terms, accept or pass | `areas/BoutPage.gd` |
| Later: host a show | The small hosted club show, when it is built | New, later |

**Fight night is a straight line, not a page.** The gold button starts it: weigh-in (`modals/WeighIn.gd`), the tape
(`Tape.gd`), the fight with the corner minute (`modals/FightNight.gd` and the 3D ring), the result and the Why, the goal
talk (`modals/GoalTalk.gd`), then back to Home. The sections are hidden while it runs. It keeps its own dark broadcast look.

### Gym
| Page | What the player does | Made from |
|---|---|---|
| Floor | The gym picture. Click a place to go there: the ring, the bags, the scales, the office, reception. Places that need you are lit | `GymHub.gd`, `IsoGym`, `GymFloorPeople` |
| Kit | Repairs, buys and upgrades equipment, and sees what each piece gives training | `GymEquip.gd`, the facilities list in `areas/Gym.gd`, the kit buys in `areas/ClubSpend.gd` |
| Staff | Hires and places coaches, the cutman, the staff jobs | `StaffCard.gd` (today's "People") |
| Members | Sets dues and classes, watches members come and go | `DuesBoards.gd`, the members parts of `areas/Money.gd` |

### Money
| Page | What the player does | Made from |
|---|---|---|
| Books | Cash, the week in and out, the weeks the cash lasts, the forecast | `areas/Money.gd`, `CashChart`, `MoneyPanels` |
| Deals and spending | Answers sponsors and grants, makes the bigger buys | `areas/ClubSpend.gd`, `MoneyTags` |

### World
| Page | What the player does | Made from |
|---|---|---|
| Ladder | The regional table by weight, yours marked, the next rung with its rule | `WorldLadder.gd` |
| Rivals | Rival clubs and their fighters beside yours | The rival compare in `WorldLadder.gd`; grows with the small living world |
| Championships | Enters the nationals, follows the draw | `NationalsView.gd`, `Bracket.gd` |
| News | What the other clubs did | The news list in `areas/World.gd` |

### Mail (top bar, with a count)
| Page | What the player does | Made from |
|---|---|---|
| Inbox | Reads what was sent to YOU and answers it from the message: a bout offer, a sponsor, a fighter's ask, a rival gym's approach. Read mail stays as the record | The club's own news items and the needs list; today "Mail" opens the World news. Partly new |

### What is cut or merged, and why
| Today | Becomes | Why |
|---|---|---|
| The gym picture as the only way around | One page, Gym > Floor (and a small picture on the dashboard in looks A and C) | It was a second menu hiding the first |
| Pins "Club office", "Reception", "Equip the gym" | Money, Gym > Staff, Gym > Kit | Each place named for what you do there |
| Pin "Playbook" | Only a tab on the fighter | A playbook has an owner |
| "Fight prep" tab that comes and goes, plus "Game plan" inside the Playbook | One Fight plan tab, always there | Same thing in two places, one of them sometimes missing |
| The grappler's separate page | The same six tabs | One shape for a fighter |
| The fixture list on Fights and on World | Once, Fights > Calendar | Said twice |
| "People, Money, Records" as one area | Staff in Gym, Money on its own, records in Fights > Results | Three unrelated jobs under one name |
| Mail = news | Mail = your inbox, News in World | The name now tells the truth |
| Hidden scrolling, "More below" | Pages are laid out to fit the screen. A long list scrolls inside its own panel with a bar you can see | Nothing important below a fold you cannot see |
| Three looks | One look for every menu, one broadcast look for fight night | One program |

## 4. Where the gym picture goes
It stays, as **Gym > Floor**, with its pins. It stops being the menu. The pins remain honest shortcuts (ring to Fights, bags
to Training, scales to a fighter's Condition, office to Money, reception to Members) and light up when that place needs you.
On the dashboard: look A shows it small, as a tile that opens the floor. Look C makes it the dashboard's picture. Look B
keeps it out of the dashboard.

## 5. The three looks

All three: flat dark surfaces, no wood, no rivets, no marker fonts for numbers, nothing under 20 px. Red is always your
corner, blue the other corner, gold only the one button. Green marks a fighter's weapon, amber the weak spot or a risk.
Portraits are grey stand-ins for photographs. The type is the game's own (Barlow, and Bebas Neue for A's big numbers); C uses
Windows' Bahnschrift as a stand-in for Barlow Condensed, a free sister of the font we already ship.

| Look | The frame | What it is best at | Its weakest point |
|---|---|---|---|
| A, Ringside (graphite, white type) | Sections down the left, then a second column with the section's pages and "Your four" always in reach. Gold button top right | Any fighter is one click from anywhere; the most familiar frame for a manager game; room to grow | Two columns take 500 px before the page starts, so the page is the narrowest of the three (1,420 px), and "Your four" repeats what the Squad page shows |
| B, Fight week (warm black, cream type) | Sections across the top, the section's pages in a second row under them, and a right column that is always the week: seven days, what comes after, the gold button at its foot | The clearest map (two rows, always the same place) and the week is always in sight, which is what our game is about. The dashboard leads with the decision itself | The week column costs 400 px on every page; wide boards (club week, playbook) will need it to fold away. The top row is full at seven words |
| C, The long view (steel grey, narrow bold type) | A slim rail of icons with words, and along the bottom the next six weeks, a lane for each fighter and one for the club, with the gold button at the end | Anticipation: you always see what is coming for whom. The widest page (1,800 px) for boards. The gym picture leads the dashboard | The page is only about 800 px tall, tight for a fighter's profile with a body figure. For a small club the six weeks are mostly empty. The busiest frame of the three |

My pick: **B**. It answers "the menus do not make sense" most directly, and it shows the week all the time. If the 400 px
column bothers him on the big boards, A is the safe second choice. The looks and the frames can be mixed: B's frame in A's
graphite is a fair request.

## 6. Build order (each step ends with a playable .exe)

| Step | What changes | What could break |
|---|---|---|
| 0 | He picks a look and a frame. Nothing is built | Nothing |
| 1 | The seven sections appear in the frame, each opening the page that exists today (Training opens the fighters for now). The gym picture stays on Home one more build | The first-hour guide still says "click the pin"; tests that look for the single "Gym" button; the saved stills |
| 2 | The new frame is drawn: top bar, sections, the gold button in its place, the new colours and type sizes, scroll bars you can see | Pages inside still wear the old look, so two looks side by side for a few builds. The wood and wall effects behind the pages must be switched off page by page |
| 3 | Home becomes the dashboard. The gym picture moves to Gym > Floor | The guide's steps, the walk-through test and anything that clicks a pin on Home |
| 4 | The Squad page, and the fighter page with its six fixed tabs (Profile from the chosen `overview` drawing). The grappler moves into the same tabs | Old links to tab numbers (kept alive through `Routes.gd`), tests that name tabs, links into the grappler's page |
| 5 | Mail becomes the inbox. News moves to World | The unread count and the "mail" button's old target |
| 6 | Fights in three pages; Gym as Floor, Kit, Staff, Members; Money as Books and Deals | The old "People, Money, Records" addresses |
| 7 | Training > Club week, the one board for all four | It depends on the four-fighter rules being built first; until then the four strips stand in |
| 8 | World pages redrawn, Compare two, the wood kit and the whiteboard page look removed. Fight night keeps its broadcast look and takes the new type and colours | Stills and any test that reads the old theme |

Steps 1 and 2 are small and change nothing in the rules. Steps 3 to 6 are one page family each and can go to the screen seat
one brief at a time. Until step 8 the game shows two looks at once; that is the price of staying playable every week.

## 7. Notes for whoever builds it
- Nothing of the reference was copied: no text, icon, colour, layout tracing or screenshot. The icons and the stand-in
  portraits are drawn here.
- The HTML files are self-contained (inline CSS, no network). They read the game's own fonts from `assets/fonts` by a
  relative path; moved elsewhere they fall back to Windows fonts.
- `tools/render_mockup.py` sometimes returns a picture with rows 1017 to 1079 left blank, in whole or in part (the headless
  browser lays the page out 63 px short and does not always paint below it). The six pictures here were rendered again
  until whole and checked row by row. Worth a fix in the tool.
- The Monday in the pictures is the four-fighter start from `fourstart_map.md`: York Hall has one place and Tess and Samira
  both want it. The numbers are the game's (`Data.PROSPECTS`, `NoGi`), the events are from that map.
