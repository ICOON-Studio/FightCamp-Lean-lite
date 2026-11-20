# GUIDETIPS1 - the standard for tooltips and the guide (S532, Fable session)

Status: DRAFT 2 (S532). Draft 1 scored by Dola: tooltips 6, guide 8, buildable 7 (ops/research/GUIDETIPS1_CRITIC_DOLA_DOLA.md);
the tooltip score is under the bar, so this draft answers its list (section 7 says what changed and what was not taken).
Draft 2 scored by Dola, round 2: tooltips 8, guide 8, buildable 8 (GUIDETIPS1_V2_CRITIC_DOLA_DOLA.md) - one seat passed.
Waiting for Arena (the independent critic with the real code check; 7+ needed), then the owner's yes. Nothing is built from this page yet.
Brief: ops/research/TASK_GUIDETIPS1.md. Picture of the standard: docs/mockups/s532/guidetips1_standard.png.

Owner, S532, playing the build: "your tooltips do not explain things"; "what is it for ? cost a week to do what"; "why you
repeat the description in the tooltip ? the tooltip should display explaining information"; "should the guide be structured a
bit better like give the player time to explore the tabs"; on the clock, "keep as is but explain all these things in the guide
how they work".

## 0. The short answer

1. The games praised for tooltips answer four questions in a small card: what is this, why is it this value now, what moves
   it, what can I do. The games hated for tooltips repeat the label, pile numbers into one long line, or hide the thing you
   needed.
2. The guides players praise let you play first and speak only when the thing is in front of you (Civilization V, RimWorld's
   learning helper, Plants vs. Zombies, Portal). A scripted start is praised when it is short and blended into play (Two Point
   Hospital, Against the Storm); it is hated when it is long, takes the mouse away and cannot be left (Motorsport Manager's
   first race, Football Manager's "barrage").
3. We already own most of the machine. scripts/ui/Tips.gd (S359, from study J90) is an index card that sits beside the
   control, wraps at 330 px, locks so the pointer can travel onto it, and opens a sticky note for a game word
   (scripts/rules/Glossary.gd, 10 words). Only 8 files use it. The other 268 tooltips are plain one-line strings written one
   by one: of the 146 that are fixed text, 75 are five words or fewer. No rule said what a tooltip must contain and no test
   checked one. That is why three earlier studies (J52, J90, K84) changed so little on screen.
4. So this standard is mostly a CONTENT rule plus a TEST that fails the build, on the card we have, and a guide that waits.

## 1. Research: what was praised, what was hated

Tags: READ = I opened the page this session. SUMMARY = from a search summary only. PRIOR = from our earlier study, not
re-read. Nothing below was taken from a game's files; REA was not needed, because what players praised is in reviews and
developer talks, not in the installed files.

### 1a. Guides
| Game / source | What it did | What players or the makers said | Tag |
|---|---|---|---|
| Plants vs. Zombies - George Fan, GDC 2012, ten tips ([notes](https://notes.hamatti.org/sources/talks/how-i-got-my-mom-to-play-through-plants-vs.-zombies), [talk](https://www.gdcvault.com/play/1015541/How-I-Got-My-Mom)) | The tutorial is the game. New things about every 5 levels. "Eight words on the screen at any given time." Messages that do not need an OK click. Adaptive: a hint only when the player gets it wrong ("If the player is doing the right thing already, there's no need to teach them"). | "Better to have the player do than read." "Don't rob your player of the sense of exploration." "People will press the shiny button." | READ (notes of the talk) |
| Portal - Valve's developer commentary ([wiki copy](https://theportalwiki.com/wiki/Portal_developer_commentary)) | One idea per room, then layered. A "gate": a short forced look at the new thing, only where testers kept missing it. | "Portal is effectively an extended player training exercise." A room that "introduced too many new concepts at once" frustrated testers and was split. | READ |
| Civilization V - Soren Johnson on Game Developer ([article](https://www.gamedeveloper.com/design/the-art-of-the-tutorial-when-to-hold-a-player-s-hand-when-to-let-it-go)) | Help arrives when the player opens the thing. | "It only teaches you about the tech tree, for example, when you open up the tech tree." "It's important to provide space for player discovery ... Tutorials can take that discovery away." | READ |
| RimWorld - learning helper ([wiki](https://rimworldwiki.com/wiki/Learning_helper), [Alpha 15 notes](https://ludeon.com/blog/2016/08/alpha-15-tutorial-and-drugs-released/)) | A small list in a corner. A lesson lights up when something happens that the player has not learned; it ticks itself off when the player does the thing; the whole list can be opened and searched any time. It replaced pop-up messages. | "You'll never be shown a lesson you already know, but always be shown the lessons you need to know now." | READ |
| Crusader Kings 3 - tutorial rework, Paradox UX ([Game Developer, 12 Sep 2024](https://www.gamedeveloper.com/design/deep-dive-refreshing-the-crusader-kings-iii-tutorial-mode-through-optimized-ux); [GameWatcher](https://www.gamewatcher.com/crusader-kings-3-tutorials-highlighted-text-encyclopedia)) | The old tutorial was 67 boxes in a row; it was cut hard and the screen revealed bit by bit ("progressive disclosure"). Advice keeps coming as new things appear, each tip dismissed with one click and all of them brought back with one button. The Encyclopedia holds every lesson. | The makers: the tutorial matters for keeping players, but FINISHING it "wasn't a major determining factor"; "a lot of information, not all of which is immediately useful". Reviewer: the reactive advice was "an indispensable companion". | READ |
| Two Point Hospital ([COGconnected](https://cogconnected.com/review/two-point-hospital-review/)) | Starts with a reception desk and one room; each new hospital adds one system. | "The beginning Tutorial is blended into the game seamlessly." Other reviews: mechanics "gently trickle in". | READ + SUMMARY |
| Into the Breach ([Game Developer, 5 Mar 2018](https://www.gamedeveloper.com/design/-i-into-the-breach-i-dev-on-ui-design-sacrifice-cool-ideas-for-the-sake-of-clarity-every-time-)) | Almost no tutorial: the screen shows what every unit will do before it does it. Things that could not be shown clearly were cut. | "We would sacrifice cool ideas for the sake of clarity every time." | READ |
| Against the Storm ([The Fandomentals](https://www.thefandomentals.com/against-the-storm-simple-and-achievable/)) | Two short tutorial phases, then a first settlement. | "Well paced with logical steps." Steam threads complain it is hard to find and covers only the basics. | READ + SUMMARY |
| Hades | No tutorial at the start; a training dummy after the first run; a short pop-up the first time a new system is met. | Praised as "no tutorial by design"; players still missed systems that were explained once and never again. | SUMMARY |
| Celia Hodent, The Gamer's Brain ([GDC16 write-up](https://celiahodent.com/gamers-brain-ux-onboarding/)) | - | Teach "when they can actually do it" and give the reason; text shown with nothing to try "will likely not be remembered". At most 3 new things at once (PRIOR, K84). | READ |

What was hated, and by whom:
- Motorsport Manager ([WCCFtech](https://wccftech.com/review/motorsport-manager-review-one-race-at-a-time/)): "detailed, albeit boring"; "it wasted fifteen minutes of my time. Any time I start a new game now, I simply turn the tutorial off and learn by reading the tooltips." Players restart after it because the scripted race hurt their season (SUMMARY). READ.
- Football Manager: "a barrage of tutorials ... the reality is that you often have to figure things out as you go along"; FM26 launched with "almost no tooltips" (PRIOR J52). SUMMARY.
- Civilization VI: the advisor's tips are "very generic"; the tutorial "is good at explaining how to click" and nothing more. SUMMARY.
- Anno 1800 pop-ups: "frequent, repetitive and irritating" (PRIOR K84). Frostpunk: praised overall, blamed where it never explained how two buildings work together. SUMMARY.
- Hades / Against the Storm: a thing explained once that cannot be found again.

### 1b. Tooltips
| Game / source | What was praised | Tag |
|---|---|---|
| Crusader Kings 3, Victoria 3, Old World, Europa Universalis V | A highlighted word inside a tooltip opens its own small card: "like having the game's official wiki sitting right alongside your mouse pointer" ([PCGamesN, 14 Jan 2022](https://www.pcgamesn.com/victoria-3/nested-tooltip-system)); CK3's tooltips "are really the star of the show". Victoria 3 shows what a choice WILL do before you click, with the sum behind it. Old World reviewers also warn that "tooltips within tooltips within tooltips" get hard to read. | READ (PCGamesN, GameWatcher) + PRIOR J90 |
| Slay the Spire, Factorio | One small card per game word, always the same card wherever the word appears, placed BESIDE the thing. | PRIOR J90 |
| Into the Breach | A weapon's tooltip plays a small loop of what it does: "a thousand times more effective" than text. | PRIOR J90 (READ then) |
| Civilization VII update 1.2.5 | Before and after values with green and red arrows, after launching with "missing or unhelpful" tooltips. | PRIOR J90 |
| Dota 2 (2022) | Plain card by default; hold a key for the exact numbers. | SUMMARY |
| Nielsen Norman Group ([Tooltip Guidelines](https://www.nngroup.com/articles/tooltip-guidelines/)), Atlassian ([usage](https://atlassian.design/components/tooltip/usage/)) | "Tooltips with obvious or redundant text are not beneficial ... If you can't think of particularly helpful content, don't offer a tooltip." Their bad example is a button "Add new line" whose tooltip says "Add new line". Nothing the player needs in order to act may live only in a tooltip. | READ |
| Diablo IV, 2023 (hated) | "Like a text wall": numbers and words in one colour, everything in one block. | PRIOR J90 |

### 1c. What the praise has in common
- Play first. The help waits until the thing is in front of the player, and goes quiet when the player already does it right.
- One idea at a time, in very few words, with the reason.
- Every lesson can be found again.
- A tooltip is a small card that EXPLAINS: never the label again, never a paragraph.
- Depth is a second step (hover a word), never a longer first card.
- Where a picture or a loop can say it, it beats the words.

### 1d. Measured on today's build (S532, tools/tooltip_census.gd - a probe, it changes nothing)
The probe plays a new career like a player (Home, reception, staff, the roster, a fighter's page, the week board, offers, a
booked bout's Fight prep, Money, Club, Playbook, World) and reads every tooltip on show against section 2e.
- 289 different tooltips seen; **216 break at least one rule** (75%).
- 129 run wider than the card and never wrap; 78 are under six words ("Champion", "Money", "Date", "Heavy bag");
  31 pile three or more numbers into one sentence; 26 say their label again ("Body 60" on a tile reading
  "60 Body"; "Drill stamina" on a button reading "Drill stamina"); 4 name a person.
- About 451 of 1190 numbers on those pages have no tooltip at all (rough: this count includes dates and clock
  times, which need none).
- This is a floor, not the full count: the probe's walk did not reach every tab (some Money, Club and fighter tabs did not
  switch for it), the fight screens are not walked, and it measures width by letter count (over 52 letters on a line), not pixels.
  The build's test (section 5, step 3) replaces it with a walk of every tab and a pixel measure.

## 2. THE TOOLTIP STANDARD

### 2a. Four kinds, and only four
| Kind | For | Built with |
|---|---|---|
| SHORT card | a plain value: a fixed price, a count, a date, a name of a thing. Nothing the player does this week moves it and it has no bands | the same card, a title and one or two lines |
| FULL card | a value the player's choices move, or one with bands, causes or a decision behind it: tiredness, mastery, loyalty, a coach's real cost, weight, load, an offer | Tips.gd card through one helper (section 5) |
| BUTTON line | a control whose label already says what it is | the same card, one line |
| MOVE card | every move, step and combination name, anywhere | MoveTip.gd (exists: plays the move on a loop on her own body) |

### 2b. The SHORT card
A title and WHAT, plus one more line only if there is something to do. Two lines at most, 20 words at most.
> **Signing fee  $1,000**
> Paid once, the day you hire this coach.

Which card a thing gets is decided by the question "can the player move this, or does it have a line he must not cross?"
Yes = FULL. No = SHORT. About half the numbers on screen are SHORT.

### 2b-2. The FULL card answers four questions, in this order
| Line | Answers | Rule |
|---|---|---|
| WHAT | what is this, or what does this money buy | one sentence, 14 words or fewer, no number unless the number IS the thing |
| NOW | why it has this value today | the value and its causes. Two or more causes = rows (label, amount, + or - in colour), 4 rows at most, with the total last |
| MOVES IT | what makes it go up and down | one sentence, 14 words or fewer |
| YOUR MOVE | what the player can do about it, here, now | starts with a verb; names the page or the button. Shown in the title colour |

- A card may drop NOW (a thing with no value) or MOVES IT (a fixed price). It may never drop WHAT.
- If nothing can be written for YOUR MOVE, the thing is information the player cannot act on: by the owner's S398 rule ("unless
  the player can really do something about it") it is cut from the screen, or the line says honestly "Nothing to do: it clears by
  itself in 3 days".
- A game word in a card (Tiredness, Mastery, Usable, Camp, Fight week, Reputation, Dues, Runway, the towel line...) is underlined;
  resting on it opens its sticky note. One note per word, the same note everywhere, from Glossary.gd.
- Guardrails on game words: only words this game gives its own meaning (never "week", "coach", "money"); at most TWO underlined
  words on a card; never the card's own title word; a note is plain text with nothing to hover, so there are exactly two levels
  (Old World's warning). The test checks all four.
- The lines carry no printed labels ("WHAT:", "NOW:"): the order and the look say it (plain, rows, quiet, title colour).

### 2c. Size
- Text column 330 px on a 1920 screen (the card is about 360 px, under a fifth of the screen). Never wider. Every line wraps.
- 45 words is the ceiling on a FULL card, not counting rows, not a target: shorter is better. One number per sentence; three
  numbers or more go into rows.
- The card sits beside the control, never over it or under the pointer (Tips.gd does this today).
- Opens after 0.3 s (today's setting); sweeping along a row of tiles swaps cards at once.

### 2d. The BUTTON line
One sentence, 6 words or more, that says what happens when you click, and what it costs if it costs something:
"Loads this combination back into the builder to change it." A greyed button says why and what would unlock it.
"Click: 50/50 -> 70/30 -> 30/70" becomes "Changes how the round is split between attack and defence. Now 50/50."

### 2e. A tooltip must NEVER
1. repeat its label or the words printed beside it (a test compares them);
2. run as one long line, or wider than 330 px;
3. pile three or more numbers into a sentence;
4. name a person - "your boxer", "the opponent", "your coach" (owner S448);
5. use a word the game has not taught - code names, short forms, "x1.3" (owner S422);
6. hold the only copy of something the player must know to act (that goes on the screen);
7. be empty where a number is shown: every number on a screen has a card.

### 2f. Worked examples (the three he asked about; every fact is from today's code)
COACH'S PAY tile (StaffCard). Was: "$450 wage a week" / "Cost a week".
> **Coach's pay**
> Buys a coach in the gym for every session, and the evening classes.
> Pay  -$450 a week | Classes bring in  +$350 a week | **Real cost  -$100 a week**
> With no coach, the sessions you cannot take run at 60% and there are no classes.

TIREDNESS column (Fighters roster). Was one line across the whole screen with four numbers.
> **Tiredness  38 of 100 - fresh**
> How worn your boxer is. Tired boxers train worse and get hurt more.
> Fresh under 50 | OK from 50 | Tired from 70 | **From 80 the next morning counts 60%**
> Fights and hard sessions raise it. A full rest day takes off about an eighth.
> *Give a rest day in the week plan before it reaches 80.*

MASTERY bar (Training). Was: nothing, then (S532) a four-line legend.
> **Mastery  24 -> 27  Learning**
> How well your boxer owns this move. Under 30 it is not thrown in a fight.
> Learning under 30 | **Usable from 30 (the flag)** | Sharp from 60 | Signature from 85
> Light strip: tonight's gain. Dashed box: one more night like this.
> *One more pad night like this reaches the flag.*

(The ladder is MoveMastery.LADDER, read from the rule. Draft 1 listed the bar's four parts and never said what the levels are
worth; Dola's rewrite put the levels first.)

"Camp: no time for one" beside an amateur bout becomes a state with a reason: "Amateur bouts need no camp. Your boxer gets a light
fight week instead: pick it on Fight prep." The numbers in the tiredness card (50, 70, 80) are read from the rule constants at build
time (WhiteboardKit AMBER_AT / RED_AT), never typed into the text. Found while writing this: the same thing is called "Tiredness" on
the roster and "fatigue" on the week board and in the Glossary. One word, Tiredness, everywhere.

## 3. THE GUIDE STANDARD

### 3a. What changes for the player
| Today | Standard |
|---|---|
| Every page dims at once and a ring points at the next click. | EXPLORE FIRST. No dim and no ring on a first visit. The old trainer says one line: what this page is FOR. |
| The guide is a list of steps in a fixed order. | The first week keeps its four jobs (sign, coach, week, Continue), because the days cannot run without them. They show as a small list in the trainer's corner, in any order. Everything after week 1 is a LESSON that arrives when its thing happens. |
| Help is pushed. | Help is asked for, or earned by being stuck: a SHOW ME button on the bubble lights the ring; after 20 s with no click on a page that holds the next job, the ring pulses softly, with no dim. The dim appears only after SHOW ME. |
| A lesson is said once. | Every lesson lives in "Ask the trainer" (Menu, and a ? on the bubble): read it again, press SHOW ME again. One button brings back every dismissed lesson. |
| The guide ends silently. | The trainer says it is over and where to find him. |

### 3b. Rules for every line the trainer says
- 11 words or fewer (today's rule; Fan: eight on screen). One idea. The reason first when there is room.
- Never blocks a click, never stops the days, never opens while a pop-up or a fight is on screen (owner S275).
- One lesson at a time; a second one waits. At most 3 new things on a page before the player has used one (Hodent).
- When two lessons are due together: a job that blocks the days first, then the thing under the pointer's page, then the oldest.
  At most one new lesson per page visit and one per game day. A lesson the player dismissed never returns by itself; it
  stays in "Ask the trainer".
- When lessons arrive, by stage: FIRST WEEK the four jobs, the clock 1-3, page lines. FIRST FIGHT fight week (or camp), the
  towel, tiredness, the mastery bar, the clock 4. AFTER the first bout: one lesson per new system as it is first met (money
  bills, the ladder, turning pro), each a row in the lessons table.
- The stuck wait is one named number (GUIDE_IDLE_PULSE_S = 20) so the owner's play can tune it.
- Off switches that exist today stay: "Skip the guide" on the bubble and the title screen's switch. Skipping keeps "Ask the trainer".
- Adaptive: a lesson whose thing the player has already done is marked learned and never shown.
- The lesson's MORE opens the same sticky note the tooltip uses. One text per game word, written once.
- No names: "your boxer", "the opponent" (S448).

### 3c. The lessons (each: when it appears -> what marks it learned)
| Lesson | Appears | Trainer's line (draft) | Learned when |
|---|---|---|---|
| The clock 1 | the first time Continue is ready | "Continue plays the days, one by one, to the next stop." | Continue pressed |
| The clock 2 | the days are running for the first time | "Press it again to pause. Change anything, then carry on." | paused once, or week 1 ends |
| The clock 3 | the first stop | "We stop for week's end, bills, weigh-ins, fights and offers." | the note is closed or Continue pressed |
| The clock 4 | first visit to Menu, or week 2 | "Days too fast or slow? Menu, then Settings." | Settings opened, or dismissed |
| Tiredness | a boxer first passes 50 | "Your boxer is getting heavy-legged. Look at the week." | the tiredness card or note is opened |
| Mastery bar | the first pad night is set | "That bar is the move. Reach the flag and it is usable." | the bar is hovered |
| Fight week, not camp | the first amateur bout is booked | "Amateur bout: no camp. Pick a light fight week." | fight week picked |
| Camp | the first bout that needs one (pro, title, nationals) | "This one needs a camp. Set it on Fight prep." | camp set |
| The towel | the first visit to Fight prep with a bout | "Tell the corner when to stop it. Your call." | the towel line is touched or the card hovered |
| Each page | first visit to Home, Fighters, a fighter's page, Training, Club, Money, Fights, Fight prep, Result | one line: what the page is for | the page is left |

The list is data (one table in scripts/rules), so a new mechanic adds one row. The S425 rule gains a line: a mechanic is not
"shown" until it has its sticky note and, if the player must do something new, its lesson.

### 3d. Teaching the clock without changing it (owner: "keep as is but explain")
The four clock lessons above, plus the Continue button's own card: WHAT "Plays the days one by one until something needs you",
NOW "Next stop: Sunday, week's end" (from Clock.next_stop), YOUR MOVE "Click again while it runs to pause".

## 4. Every screen this touches, and what it is wired to
| Screen | Shows | Wired to |
|---|---|---|
| Every page | EXPLAIN / BUTTON / MOVE cards on all controls | Tip helper -> Tips.gd -> Glossary.gd |
| Top bar | Continue's card with the next stop; each red or amber flag (a need) gets a FULL card: what it is, why now, where to fix it | Clock.next_stop, Needs.go_state, Needs.flags |
| Trainer's corner (FirstWeekStrip) | one line, SHOW ME, ?, the week-1 job list, Skip | GuideLines, the lessons table, GuideLight |
| Menu | "Ask the trainer": all lessons, replay, bring back dismissed | lessons table, Career.lessons (new, saved) |
| Playbook, learn cards, Training pad cards, Game plan, combination builder | the MOVE card with the looping move | MoveTip.attach (a move with no clip gets one baked from the fight's own clip) |
| Settings | "Hints from the trainer" on / off | prefs |

## 5. Build plan (after the owner's yes; nothing in scripts/fight3d)
1. Tip helper, about 120 lines, new file scripts/ui/Tip.gd: Tip.explain(control, {title, what, now|rows, moves, do, keys}),
   Tip.button(control, text), both ending in Tips.card. Tips.gd is 496 lines: the row and note drawing moves out to a small
   TipParts.gd so both stay under 500.
2. Glossary.gd grows from 10 words to every game word on screen (about 35), each with def + why; "fatigue" is renamed Tiredness
   to match the screens.
3. THE TEST (tests/tooltip_standard_test.gd), red on today's build first. It walks Home, Fighters, a fighter's page, Training,
   Club, Money, Fights, Fight prep and Result with the four-fighter test club, collects every control's tooltip, and fails one
   that: uses the engine's plain tooltip; repeats its label (same words after stripping numbers); is under 6 words; has a line
   over 14 words or 3+ numbers in a sentence; has no WHAT; contains a signed fighter's, coach's or opponent's name; or uses an
   underlined word with no Glossary note; has more than two underlined words; or is a SHORT card over 20 words. A Glossary note
   that contains another game word's name as a link fails too. A second check fails a visible number with no card at all.
   tools/tooltip_census.gd (section 1d) is the first, rough version of this walk.
4. Screens rewritten in the order he hovers them: fighter roster and coach cards, Training (bars, tiredness, load), Fight prep,
   Money, Home, Fights, Club, Result. Each screen is done when the test passes for it and a still of three of its cards has been
   opened and checked.
5. The guide: lessons table (scripts/rules/Lessons.gd, new) + Career.lessons (new: lesson id -> seen / learned / dismissed,
   saved with the career, so nothing is lost on a restart); GuideLight gets SHOW ME / idle pulse / no dim by default; FirstWeekStrip gets the
   job list, ?, MORE; "Ask the trainer" in Menu. guide_person_test, guide_ends_test, first_week_test, first_hour_test stay green;
   a new golden-path test plays week 1 without ever pressing SHOW ME and checks no dim was drawn.
6. Move cards: a census of every place a move is named; attach MoveTip there; bake a clip for each move that has none.

## 6. Open points for the critics
- Is 20 s the right wait before the soft pulse? No source gives a number; it is a first guess to tune on the owner's play.
- Should the week-1 jobs still block Continue (today they do)? Kept, because the days cannot run with no boxer and no plan.
- Is the four-line card too much for small things (a tile on a crowded card)? The rule lets NOW or MOVES IT drop, never WHAT.

## 7. What draft 2 changed after the first critic (Dola: tooltips 6, guide 8, buildable 7)
Taken:
- A SHORT card for plain values (its first point: the four-line card "is overkill for half the numbers on screen").
- Guardrails on underlined game words, and a test that there are only two levels.
- The mastery card now leads with the levels (Usable 30, Sharp 60, Signature 85) instead of the bar's parts.
- Rules for two lessons at once; where lessons are saved; the off switches named.
- The line about scripted tutorials is fairer: short and blended is praised, long and locked is hated.
Not taken, and why:
- "Show less / more" button inside a card: a tooltip that needs a click is no longer a tooltip; the second level is the sticky note.
- Dropping the 45-word ceiling: a test needs a number. It is now called a ceiling.
- Its tiredness bands ("Tired: 50-79") do not match the code (OK from 50, Tired from 70, 60% from 80). The card reads the rule.
- "Training -40%": the game's own words are "counts 60%".
- Its shorter trainer lines ("Continue advances days to what's next") lose the two facts the owner asked the guide to teach
  (one by one; up to the next stop). Kept ours.
- Three "overstated research claims" it listed are not in this page (it quoted sentences the standard does not contain).
- "No performance estimate": one card exists at a time and is rebuilt on hover, as Tips.gd does today on 8 screens.

## 8. Round 2 (Dola on draft 2: tooltips 8, guide 8, buildable 8)
Taken into this page: the OK band on the tiredness card, cards on the top bar's flags, lessons by stage, the stuck wait as one
named number. Left for the build: its tighter wording of the three example cards (the final words are set screen by screen and
checked by the test), a "Reset all tips" button (already here as "one button brings back every dismissed lesson"), F1 for "Ask
the trainer". Not taken: six rows on Money (a longer breakdown belongs on the Money page itself), "Speed: Menu -> Settings"
style lines (short forms and arrows are not the trainer's voice).
