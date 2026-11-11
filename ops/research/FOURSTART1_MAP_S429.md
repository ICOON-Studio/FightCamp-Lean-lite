# FOURSTART1 design map: a career starts with four fighters (S429)

Status: DRAFT for critics. Not on the operator's board until two fresh critics score its depth 7 or more.
Source: the operator's S428 scope change (ops/research/SCOPE_FOUR_FIGHTERS_S428.md): "we sshould force the player to have 4
fighters,different weight classes and bjj so menus shows better and players has more things to do", and his S429 message:
"on the new 3-4 fighter start try to use the guide to pinpoint different trainings according to different ratings and styles
of fighters".

## 1. What the player decides
You take over a small club. The last head coach left; four fighters stayed. In the first week you make four kinds of choice:

1. WHO TRAINS FULL TIME. The club can pay one $250 stipend. That fighter trains mornings and evenings. The other three keep a
   day job and train evenings only (they gain 15% slower: GymSpend.DAY_JOB_GAIN 0.85, already in the game). You choose who.
   More stipends can be bought later, when the money allows.
2. WHAT EACH ONE TRAINS. Each fighter needs something different. The guide (the old trainer) reads each fighter and points at
   one training (section 3). You can follow it or not.
3. WHO GETS REID'S HANDS. The assistant coach holds pads on three evenings, two fighters an evening: six pad places a week.
   Three boxers want three evenings each (nine). You deal the six. A boxer without pads that night works the bag (half the
   pad gain). The BJJ fighter trains on the mat with her own coach and takes no pad place.
4. WHO FIGHTS FIRST. One of the four already has an offer on the table for a club show ten days away.

## 2. The four starters (all exist in the game's data today)
| Fighter | Class | Style | Age, record | What stands out | Potential |
|---|---|---|---|---|---|
| Lucy Jackson | Lightweight | Out-boxer | 21, 3-1 | Speed 63, all-round, nothing low | 84 |
| Samira Khan | Welterweight | Slugger | 18, 2-1 | Power 66, defence 50 (the lowest number in the gym) | 82 |
| Tess Reilly | Middleweight | Pressure fighter | 23, 6-4 | Conditioning 64, chin 67, near her ceiling | 76 |
| Ana Ribeiro | BJJ, no-gi | Grappler | (as today) | Plays the mat side: belt road, open nights | (as today) |

Four weight classes, three boxing styles, three ages: a prospect, a raw puncher, a veteran, a grappler. Kira, Danny and Josh
stay in the scouting list as later signings.

Staggered start, so day one is not four problems at once:
- Monday week 1: the guide introduces them one at a time (section 3). Tess has the offer waiting. Lucy is fresh. Samira has a
  signing goal due in three weeks (FighterGoal exists). Ana's first open night is in week 3.

## 3. The guide points at a different training for each fighter (his S429 ask)
One pure rule, the COACH'S READ, looks at a fighter's numbers and style and returns one of five reads. It runs in this order:

| Read | When | What the guide points at |
|---|---|---|
| FIGHT | a bout within 14 days | no building: tape, one plan line, light mornings |
| REST | tiredness 70 or more, or hurt | a rest morning |
| FIX THE HOLE | the lowest trainable number is 6 or more under the fighter's own average, and it still grows at full pace | the session that builds that number |
| SHARPEN THE WEAPON | the number the style is built on (Recruit.CLASSES) still grows at half pace or better | the session that builds the weapon |
| TEACH A PUNCH | every number is near its ceiling | pads: a new move or a combination (numbers barely move, craft still does) |

"Grows at pace" is the game's own rule: gain a focused week = clamp((potential - number) / 25, 0.10, 1.25).

On the four starters, with today's numbers, the rule gives four different answers:
- Samira: FIX THE HOLE. Defence 50.5, her average 57.9, gain 1.25 a week (the fastest gain in the gym).
  Guide: "Samira hits hard and gets hit. Slip rope first." The light rings the slip rope session on Samira's week.
- Lucy: SHARPEN THE WEAPON. No hole (lowest is 3.5 under her average). An out-boxer is built on speed: 63.2, gain 0.83 a week.
  Guide: "Lucy wins at range. Speed bag, and the jab on pads." The light rings the speed bag.
- Tess: FIGHT now (the offer). After the bout: TEACH A PUNCH (conditioning gains only 0.48 a week).
  Guide: "Tess fights in ten days. Keep the legs fresh." Later: "Tess is what she is. Teach a new punch."
- Ana: the mat's own read (the escape she fails most, from the BJJ tree). Guide: "Ana gets held down. Drill the escape."

Rules for the guide's words (kept from today): one line, under 12 words, the fighter's name, never he or she. The numbers
behind the line sit in the bubble's tooltip as two lines: "Slip rope: defence +1.25 a week. Heavy bag: power +0.64 a week."
So the player sees why, and what the other choice would give.

The read is advice, never a lock. Reasons to go against it, all already in the game: the next opponent's file asks for
something else (OppFile); the fighter's goal names another number (FighterGoal); a day-job fighter has no mornings.
The read changes as the fighter changes: when Samira's defence reaches her average, her read flips to SHARPEN THE WEAPON.
After week 1 the read stays as a small chip on each fighter's card (icon + one word), so it is useful for the whole career.
The Monday review says what the week gave and what the read's pick would have given, for each fighter, in one line.

## 4. The numbers
- Roster places: the first unit holds 4 (today 3: GymUpgrades.PREMISES[0].places), so the four fit and a fifth needs the
  second coach or bigger premises, as today.
- Stipend: $250 a week, ONE at the start. Day job: gain x0.85, no mornings on the week board.
- Pad places: 3 pad evenings x 2 fighters = 6 a week for three boxers (today every fighter has her own 3 pad nights, which
  four fighters would turn into 12 evenings of one man's hands). To be measured before the build (how many answers a boxer
  owns by fight night with 2 pad evenings instead of 3; HANDSPROBE1 measured one fighter only: 6% of camps owned every answer).
- Money: weekly costs today with one stipend are about $1,320 (rent $416, power $129 in winter, insurance $24, fees $7, kit
  $45, Reid $450, stipend $250) against dues of $242 and classes $350. Four stipends would add $750 a week: the start cash
  ($17,200 in the code) would last about 12 weeks. One stipend keeps today's balance. MONEYFOUR1 (Qwen, running) plays a year
  in five stipend cells and gives the real numbers; the start cash and the ticket income of four fighters are set from it.
- Bouts: four fighters bring more club shows (each amateur bout pays the club a $450 ticket cut). How many a year: MONEYFOUR1.

## 5. Every menu the four fighters appear on, and what each is wired to
| Menu | What it shows | Wired to |
|---|---|---|
| Create, step 2 (start cards) | "Four fighters stayed" on each start card; the cash for that start | ClubStart.CARDS, Career.start_cash |
| Home | four fighter rows, each with the one thing that needs you; the guide's bubble | Home.gd rows, GuideLines.line, FirstWeek steps |
| Gym picture | the guide's light on the place to go (training, fights, reception) | GuideLines.place, GuideLight |
| Fighters | four cards: class, style, the read chip, stipend or day job | Fighters.gd, the new read module, GymSpend.set_stipend |
| Fighter page, Overview | the read in one line with its two numbers; the stipend switch | FighterPage.gd, the read module, TrainingPreview |
| Fighter page, Training (week board) | the guide's light on the session the read names; no mornings for a day-job fighter | WeekBoard, WeekCoach.BUILDS, GuideLines.target_names |
| Training, evenings | six pad places a week, who holds which; a boxer without pads is on the bag | PadWeek (new: shared places), WeekEditors |
| Grappler page (Ana) | the mat's read and the drill it names | GrapplerPage.gd, BjjTree, drill pick |
| Fights / Bout page | Tess's offer; the compare card; rank before the fight | Fights.gd, BoutPage.gd, BoutCompare, RankLine |
| Money | a stipend line per fighter, the runway with four | Money.gd, GymBills, GymSpend |
| Week review (Monday) | per fighter: what the week gave and what the read's pick would have given | the week review, the read module |

## 6. What is built, in order (each a small task)
1. The read module (pure, with tests): read(fighter, day) -> {kind, number, session, say, why}. Qwen.
2. Four starters in Career.quick_start and from_create; places 4; one stipend, three day jobs; the first-week steps for four
   (meet, stipend, week, go). Cursor (screens) after the module.
3. The guide's line and light per fighter (GuideLines, GuideLight targets), the chip on the cards. Cursor.
4. Shared pad places (rule module + tests, then the evenings editor). Qwen, then Cursor. Measured first.
5. One golden-path test walks it: start, four on the roster, pick the stipend, follow two reads, deal the pads, Continue.

## 7. Risks, said plainly
- If the read is always right, following it is a lookup, not a choice. The opponent's file, the goal and the day job must
  really pull against it; the critics should test exactly this.
- Ana is the thinnest of the four (her live bout has one decision today).
- Shared pads change every boxer's learning speed: it must be measured before it is built.
- Day one could still be too much: the guide brings one fighter at a time, and only the stipend and the week block time.
