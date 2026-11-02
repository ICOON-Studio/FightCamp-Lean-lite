# THE CAMPAIGN PLAN - "Anvil Street" (showrunner merge of STORY1)
Claude (lead designer / showrunner), 2026-10-05. Merged from four full pitches: Claude "The Ledger", John "Anvil Street", Dola "Step Into
the Ring" (+ her Part A survey), Maria (section 10 only, rest not captured). Kalli's is still being written and will be folded in as a
patch. Where pitches disagreed this page says which won and why. Nothing here changes the demo until the operator OKs section 9.

## 0. What the four pitches agreed on (so it is settled, not debated)
- A story that SETS STAKES and never scripts a fight result (all four, Dola's rule 1).
- Three acts on the career LADDER: Amateur->Regional, Regional->National, National->World.
- An inherited / struggling gym, a mentor with a secret, a promotion that wants your best fighter, a rival who becomes a person.
- Every choice writes a flag on a REAL system (money, rivalry heat, contract, morale, access); every card defaults after 7 days to the
  quiet option; the story is a layer over free play and can be turned off.
- The week is the spine: one promise always visible ("fight in 3 weeks", "bill due Friday", "he calls Friday").
- Chapter 1 ends at the first fight; the demo's last screen is a chapter end with a hook.
- Endings are read from game state, three of them, and the campaign never ends the game: free play continues with the same gym.

## 1. Decisions where the pitches differed
| Question | Winner | Why |
|---|---|---|
| Who is the player? | The bookkeeper/cutman who inherits the gym (John, Claude) - NOT a retired boxer (Dola) | A management game's fantasy is the person who notices and keeps the lights on; it also fits any player, and a boxing past would need its own stats. |
| Mentor | The founder **Dessa Marlowe**, stroke in week 1 (John) over Pat Halloran (Claude) | A living, reachable mentor gives calls and a hospital-bed confession; a dead one only gives notes. Pat's "notebook" survives as a handbook device (section 6). |
| Antagonist | **Crown Ring Promotions + Victor Lasko** (John) - clean shows, a loan, a right-of-first-refusal clause | Not a cartoon; the clause is a real contract mechanic. Dola's Apex/Hale and my Meridian/Voss merge into this. |
| First fighter | **Kit Alvarado**, 19, lightweight (John and Maria both chose Kit). Women's path: **Dee Okafor** (Claude) swaps in with the same beats | Men and women never fight each other; one New Career question picks who walks in. |
| Head coach | **Hollis "Holl" Dagget**, slipping memory (John) | The corner hook is great: a cue repeated ("jab, jab, jab") shows decline without a new rule. |
| Rival fighter | **Joaquin "Jax" Mireles**, Crown-contracted (John). Dola's "Jax" first fighter is dropped to avoid the clash | Rival with a sympathetic secret (his contract is Crown's, he dislikes it too). |
| Press | **Naomi Brandt** (John) over Priya (Claude) | Same role; Naomi also writes the column Crown quotes. |
| Dola's "accept the buyout = game ends early" | REJECTED | The campaign never ends the game (section 0). Selling becomes the "Sold" ending, followed by a smaller free-play gym. |
| Story switch | **On / Beside / Off** (John) | Beside = cards sit in the inbox, never interrupt; Off = free play only. |

## 2. Spine
Logline: You were the cutman and bookkeeper of Anvil Street Boxing Club for nine years. When founder Dessa Marlowe has a stroke, you inherit
the keys, a debt you did not know about and one fast, impatient teenager. Every week the rent is due, and the one promotion that runs
clean shows also owns the loan and has a clause on your best fighter.
Tone: warm in the gym, cold in the office, honest in the ring.
Acts: **I "Keys"** (amateur->regional, "can you keep the doors open?"), **II "Terms"** (regional->national, "what will you sign?"),
**III "Last Bell"** (national->world, "what do you owe the people who built this?"). Chapters 1-4 / 5-8 / 9-12.

## 3. Cast (14 people, 8 needed for the slice)
| Name | Role | Secret | Systems |
|---|---|---|---|
| Dessa Marlowe, 71 | founder, in hospital | sold Crown a right of first refusal on any Anvil fighter reaching national level to pay a hospital bill | Office, calls, money |
| **Kit Alvarado**, 19 (or **Dee Okafor**) | first fighter | has a Crown business card in his bag (Dee: hides a glass chin with jokes) | profile, morale, contract |
| Hollis "Holl" Dagget, 58 | head coach | memory slipping, repeats three cues | staff, corner reads, decline |
| Victor Lasko | Crown owner | Dessa trained him as a teenager and dropped him | offers, contracts, rival promotions |
| Joaquin "Jax" Mireles, 21 | rival fighter | Crown owns his contract | rivalry heat, rematches |
| Rhea Castellan | rival gym owner (Ironworks) | last person to visit Dessa in hospital | sparring wars, hype |
| Naomi Brandt | reporter | writes the column Crown quotes | press, inbox |
| Lila Reyes (Dola) | independent local promoter, wants out of Crown's orbit | under a Crown contract but looking to leave | fight access, the independent route |
| **Elena Park** (Dola's Elena, renamed) | ring doctor / physio | was let go by Crown's circuit for questioning medical shortcuts | injuries, the medical flag beat |
| Big Ray Carter (Dola) | retired ex-champ volunteer | early neurological damage, keeps load light | training boost, tips, the cost of the sport |
Folded in from Maria's partial: Tomas (the letter that opens Ch.1 = Dessa's call), Rafi (coach = Holl), Ines (reporter = Naomi),
Vale (the regional door), Soren (the film-room scout, kept as a Film Room scene), Hana (physio = Elena).

## 4. Twelve beats (merged; trigger = existing game state)
1. **Keys** - new career, week 1. Dessa's call, the bill list (rent, dues, lender letter). Choice: Kit's first focus (pressure / boxer / counter). -> starting spread + first move.
2. **Book him** - Kit trained 2 weeks. Holl: "He can fight." Two amateur shows (cheap in 3 wk / better card in 6). -> purse+hype vs stamina and the bill date.
3. **Why it went your way** - first fight done (win or lose). Result screen + Naomi's write-up + the Wall clipping. Choice: hire Holl full time or keep the cash. -> coach pay; corner reads.
4. **The lender** - bank below 0 for 2 weeks. Teague Capital (a Crown company). Pay the fee / take a Crown-logo sponsor / sell Dessa's trophy case. -> money now, flag `crown_ties`.
5. **Callout** - Kit reaches regional. Jax calls him out. Accept/decline. -> rivalry heat 30 or 10; a fight booked or not.
6. **The sparring war** - heat > 70. Rhea at the front desk: spar hard / light / refuse. -> heat, injury risk, hype. (cut-first)
7. **The offer** - a second fighter signs or Kit's contract is up. Crown's number in the inbox: match / release / counter. -> money, morale, roster.
8. **The clause** - Kit reaches national. Dessa visits and confesses; a Crown envelope. Honour / fight it in court / buy it out. -> Crown first call on Kit, or a legal bill, or a big cash cost. **Central bargain.**
9. **The retirement** - any career-ending injury. Physio scene; coach job or release. -> a new coach or a photo-wall space and a morale hit.
10. **The medical flag** (Dola's beat, strong) - title week. Elena flags that the circuit wants the fighter cleared too soon. Pull him / proceed / demand a second opinion. -> fight off and purse lost, or injury risk up, or Crown heat and integrity up. Independent route: Lila's sanctioned card vs Crown's show.
11. **The offer for the gym** - first world-ranked fight booked. Lasko's final offer: sell / partner / refuse. -> cash, contract ownership, Crown logo on the ring.
12. **Last bell** - the last booked fight. Fight week, fight night, aftermath, credits. No choice; the simulation decides. -> ending flag.

## 5. Endings (read from state) and carry-over
**Standing** (solvent, a national-level fighter, clause dealt with), **Partnered** (Crown logo on the ring, money, a permanent rival-promotion flag),
**Sold** (cash and kept fighters, a smaller gym). Free play opens with the same gym, bank, roster and the Wall. Cut first: the Sold ending's
second half, beat 6, Naomi's column, and everything after beat 10 for the first slice (Acts I-II are a complete story).

## 6. Fight-night and system moments (no scripted outcomes)
- Corner: Holl's cue drawn from the player's own reads; repeated cues when his memory slips (flavour only). Dessa's old tapings/notebook pages
  are the handbook text, one page per chapter.
- Rival entrance with a callout line scaled to heat; at heat >= 70 a close-up (presentation only).
- Scorebug **grudge icon** (tooltip "Rivalry: this one is personal") and an **old-injury icon**; commentary names the date.
- Result screen keeps "why it went your way" as the lead plus ONE line tying the fight to the chapter.

## 7. Menus, UI and the loop (the operator's brief: the story shapes them)
**Title menu:** icons with tooltips: Continue, New Career, Free Play, Options. Continue plate = Chapter, week, next fight, who is waiting
("Chapter 2, week 14 - Kit in 3 wk - Jax is waiting"). **New Career asks three things:** your name, Story On/Beside/Off, the gym name
("Anvil Street" prefilled); the first fighter walks in (Kit or Dee by one division tap). No difficulty question.
**The week = THE BOARD** (Claude + Dola + John merged). One screen: the **NEXT UP** banner on top (the nearest fight, bill or call, always
one line), then three columns **Gym** (train/rest/spar), **Money** (due this week), **People** (inbox). Story cards interrupt ONLY in the
week review, never a fight, booking or training. One highlighted next action.
**Loop:** `NEXT UP -> plan the week -> week review (one story card at most, dismissible, default 7 days) -> fight (camp, fight week, night)
-> aftermath (result "why", press, purse, injuries) -> chapter beat -> NEXT UP names the next promise`.
**New screens (two, small):** the **Phone Inbox** (John: calls, letters, offers, with the choice buttons) and **The Wall** (Maria:
one framed photo per chapter beat and per fighter; a missing one is an outline with a lock, a fallen one hangs askew; each reopens its
chapter card; a pin on HOME). The rivalry/trust numbers live on the Wall's side strip.
**Existing screens:** MY GYM NEXT UP = the story promise; LADDER tiers labelled as acts with locked doors naming what opens them;
booking flags a story fight with a tooltip naming the person; week review ends on the three hooks (middle = nearest story promise);
corner = Holl's lines; scorebug = grudge icon; result screen as above; handbook = one page per chapter. **Rooms:** Office = Dessa,
the lender, Lasko; Locker = weigh-in and Kit/Jax face to face; Mat room = the kids' class and Naomi; Physio = injuries and
retirements (Elena); Staff = Holl; Film room = scouting.
**UI rules:** icons over text with tooltips; "gym" never "camp"; every state an icon AND a word; a card is two lines plus two buttons;
one clear next action per screen.
**First hour:** 0-2 title + 3 questions; 2-5 chapter card "Keys", Dessa's call, bill list, NEXT UP "bill due in 4 weeks"; 5-15 the handbook
walks the rooms, Kit's style (beat 1); 15-30 two training weeks, week review, meet Holl; 30-38 beat 2 "book him", two shows; 38-48 camp,
fight week, weigh-in; 48-55 fight night; 55-60 result, Naomi's write-up, the Wall clipping, chapter card **"Chapter 1 ends: Keys"**,
hook **"Jax is calling."** That last card is the demo's end.

## 8. Smallest build (no engine rules, no scripted fights)
- `story_beats.json`: id, trigger expression over EXISTING state (week, bank, ladder level, rivalry heat, contract expiry, career-ending injury,
  fight booked), card text (<= 3 lines), 2 choices, flag writes, 7-day default. 14 cards for chapters 1-4.
- ~9 flags in GameState: story_mode, kit_style, crown_ties, jax_accepted, clause_resolved, holl_hired, dessa_alive, sold_gym, partnered.
- A card renderer reusing the guide-card UI; one week-review hook; Inbox and Wall screens.
Proposed tasks (queue entries to add on the operator's OK): **STORY2** data + flag store + card renderer + chapter 1 (Claude);
**STORY3** NEXT UP/Board and week-review hook, Inbox (Claude/Cline); **STORY4** the Wall + HOME pin (Claude, Maria art);
**STORY5** corner/scorebug/result hooks (Claude); each with its own test and a still on the game's camera. Writing the full card text for
chapters 1-4 goes to the writers (Dola/John/Maria/Kalli) after the OK, as `story_cards_ch1.json` drafts.

## 9. The one question for the operator (scope)
Do we put **Chapter 1 (about 14 cards, the first hour above) inside the boxing demo**, or keep the demo as is and ship the story with Early Access?
My recommendation: **Chapter 1 inside the demo.** It adds only the card renderer, the NEXT UP promise and the chapter end; it needs no engine
change; it gives the first hour a reason to press Continue (the playtest pass-2 found that is the loop's weakest point). Risk: it adds work
before the exe rebuild. If you say no, everything above waits in the backlog unchanged.

## Credits
Spine, cast core, beats 1-9 and 11, endings, On/Beside/Off, Inbox: John. Board, Dee, the carry-over rules, first-hour timing: Claude.
10 rules, the medical-flag beat, Lila, Big Ray, Elena: Dola (Part A survey is in `STORY1_DOLA`). The Wall, chapter-as-handbook-page,
Continue plate: Maria. Kalli: pending.
