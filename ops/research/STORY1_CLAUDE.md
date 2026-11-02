# STORY1 - the lead designer's pitch: "THE LEDGER"
Claude, 2026-10-05. Structure used: the underdog-institution arc (Rocky/Creed shape) crossed with a management ledger that never
stops asking "can you afford this?". Boxing first; MMA hooks marked [MMA].

## 1. Logline and tone
You inherit a dying neighbourhood gym and one stubborn kid with a good jab. Every week the rent is due and the sport keeps offering you
easier money for a smaller soul. Tone: warm, working-class, funny in the corners, honest about bodies and money - a sports drama told
through a ledger. At hour 10 the player feels *responsible* for specific people; at the credits, the gym's name on the wall means something.

## 2. The spine
- **Protagonist (you):** the new owner of **Halloran's Gym**, left to you by Old Pat Halloran, your trainer when you were young. You are
  not a champion; you are the one who stayed and did the books. Name/appearance chosen by the player; the voice is Pat's memory.
- **First fighter:** **Dee Okafor**, 19, a raw lightweight with a fast jab and a glass chin she hides with jokes. (Female fighters box
  women only; the cast also includes a male prospect, **Tomasz "Tommo" Wren**, so either path has a first fighter.)
- **Antagonistic force:** **Meridian Boxing Group**, the promotion that "develops" talent by buying contracts - and, under it, the
  sport's arithmetic: purses vs bills vs a body that wears out. Face of it: **Gale Voss**, a charming promoter who is usually right.
- **Three acts = the ladder.** Act I Amateur -> Regional ("Keep the lights on"), Act II National ("Keep your fighter"), Act III World
  ("Keep your name"). A chapter ends when a fighter clears a level; the demo ends at the end of Chapter 1.

## 3. Recurring cast (fictional)
| Name | Role | Wants | Secret | Meets the player | Systems |
|---|---|---|---|---|---|
| **Pat Halloran** | dead mentor, voice of the notebook | the gym to outlive him | he took Meridian money once | notebook pages unlock per chapter | tutorial tips, corner lines |
| **Dee Okafor** | first fighter | to buy her mum a house | chin trouble, hides it | week 0 | injuries, morale, ladder |
| **Marguerite "Mags" Ito** | head coach (staff hire) | one real title shot | owes Voss a favour | week 1, locker room | coach pay, corner reads |
| **Gale Voss** | Meridian promoter | your best fighter, signed | he loved the gym once | first offer after win 2 | contracts, rival promotions |
| **Rico Dane** | rival gym owner (Ironworks) | to beat Halloran's publicly | his fighters are tired | after first regional win | rivalry heat, hype |
| **Priya Nair** | sports reporter | a real story | will print the truth | weigh-in | press/hype |
| **Tommo Wren** | second fighter | to be seen | holds back to protect a friend | scouting | scouting, sparring |
| **The Landlord (Mr Aldous)** | owns the building | rent on time, or a sale | wants the gym to survive | monthly | bills, money |

## 4. Twelve beats (trigger is the game's own state)
| # | Beat | Trigger | The player sees | Choice | Consequence |
|---|---|---|---|---|---|
| 1 | Pat's notebook | new career | gym at dawn, notebook, rent due in 6 weeks | name the gym's motto | tutorial tone + first sponsor flavour |
| 2 | First raw boxer | week 0 | Dee at the door | train her or scout Tommo first | which fighter leads Chapter 1 |
| 3 | First fight booked | first booking | corner call-sheet card | cheap local show vs a better stage | purse vs hype |
| 4 | The notebook page | first win | Pat's page: "fear is a bill" | spend the purse on gloves or the rent | bank vs fighter edge |
| 5 | Voss calls | win 2 | phone inbox card | take a meeting | opens/blocks Meridian offers |
| 6 | Ironworks challenges | regional level reached | Rico on the rivalry wall | accept the grudge match | rivalry heat +, hype + |
| 7 | The bad night | knockdown or heavy damage taken | corner, physio, towel decision | stop the fight or let her go | injury, morale, trust with Mags |
| 8 | The rent | bank < next bill | landlord letter | sell sponsor space or cut coach pay | money, staff morale |
| 9 | The offer | national level | Meridian contract on the desk | sign Dee away, co-promote, or refuse | fighter leaves / split purse / lose access |
| 10 | The truth in print | after a controversial result | Priya's piece | give the interview or stonewall | hype, public trust |
| 11 | Pat's secret | world qualifier | the old Meridian cheque found | tell Dee or bury it | trust, a door opens or shuts |
| 12 | The name on the wall | title fight | the whole gym in the corner | who works the corner | ending variant |

## 5. Choices that matter (and ignoring them)
Beats 4, 8, 9, 11 and 12. Each writes a flag on a real system (money, rivalry heat, fighter trust, a contract, access to a promotion).
If the player ignores a story card it defaults to the *cautious* option after a week and the sandbox continues. A switch turns the
story layer off: beats stop, the ladder, money and rivals run as free play (the campaign is a skin over systems that already exist).

## 6. Fight-night moments (never scripted results)
1) Corner talk: Pat's notebook line is picked by the fight state (hurt, ahead, behind). 2) A rival's entrance with the grudge named on
the scorebug. 3) A "grudge round" label when rivalry heat > 70 (pure presentation + commentary, engine unchanged). 4) An injury
callback: a hand she hurt in beat 7 is mentioned when she throws it. The result screen's "why it went your way" can tie back to the
decision that shaped the camp.

## 7. Endings and carry-over
Three: **Independent** (refuse Meridian; smaller, proud), **Partner** (co-promote; richer, compromised), **Sold** (Dee leaves; you
keep the building and a fortune, Pat's notebook goes quiet). Carry-over: the gym, its rooms and staff, the notebook pages and an
"alumni" wall of retired fighters continue into free play and the next career.

## 8. Smallest build and what to cut
Minimal slice: a `story_beats.json` (id, trigger expression over existing state, card text, 2 choices, flag writes); a card renderer
reusing the guide-card UI; a flag store in GameState; 12 beats. No branching dialogue trees, no cutscenes, no voice. **Cut first:**
(1) press interview mini-game, (2) the second fighter's parallel arc, (3) the Sold ending (keep Independent + Partner).

## 10. The story shapes the menus, the UI and the loop
**(a) Title menu / new career.** "New Career" asks three things only: your name, the gym's motto, and *who walks in first* (Dee or
Tommo). A returning player's title menu shows a single card: **Chapter, Next Fight (weeks away), Who is waiting** (e.g. "Ch.2 - Dee vs
Ironworks - 3 weeks - Voss left a message"), then Continue. Credits board stays.
**(b) The weekly loop = The Board.** Each week opens on one screen, **THE BOARD**: top row the *story promise* (the next fight or the
next due bill, always one line), then three columns: **Gym** (train/rest/spar for each fighter), **Money** (due this week), **People**
(inbox: Voss, Priya, the landlord). One clear next action is highlighted. Story cards interrupt only at the week boundary, never mid-fight
or mid-training. "One more week" is pulled by a visible promise: a date on a fight, a bill, a call.
**(c) The first hour.** 0-5 min: dawn, Pat's notebook, rent in 6 weeks (the clock). 5-15: Dee in the door, set her first plan (the
camp plan is the default, one tap). 15-30: week 1-2 on the Board, first spar, meet Mags. 30-45: book the first local fight (beat 3),
see the corner call-sheet. 45-60: watch the fight; the result screen; Pat's page (beat 4). The first pro debut is the **end of
Chapter 1** and the demo's last screen: "Chapter 2 - Coming next" with the Voss call as the hook.
**(d) Existing screens.** *MY GYM tab:* NEXT UP becomes the story promise; YOUR FIGHTERS carry a one-line arc ("Dee - chin worry").
*LADDER tab:* tiers are labelled as chapters. *Booking:* offers show the story stake ("Meridian show: more money, Voss owns the
card"). *Week review:* ends with the one beat consequence in plain words. *Corner:* Pat's notebook line + Mags's read. *Scorebug:*
grudge label at heat > 70. *Result screen:* the "why" ties back to a choice. *Handbook:* chapters become notebook pages. *Rooms:* Office =
contracts and the landlord; Locker = Dee/Tommo scenes and Mags; Mat room = Rico's challenge; Physio = beat 7; Staff room = pay
disputes; Gym floor = the notebook on the wall.
**(e) New screen: THE RIVALRY WALL + INBOX.** One screen, text mock-up:
```
 THE BOARD      Ch.2  "Keep your fighter"
 NEXT: Dee vs Ironworks - 3 wk      BILL: rent 1,200 (week 2)
 INBOX   [Voss: meeting?]  [Priya: 3 questions]  [Landlord: reminder]
 WALL    Rico Dane  heat 74 (!)   Voss  trust 40   Mags  trust 66
```
**(f) UI rules implied.** Icons with tooltips over text; the facility is a "gym"; every screen ends in one highlighted next action;
the story is never a wall of text (a card is 3 lines + 2 buttons).
**Loop diagram:** `Board (promise) -> plan the week -> story card at the week boundary -> fight (simulated, never scripted) ->
aftermath (result "why", injuries, money) -> chapter beat -> Board`.
