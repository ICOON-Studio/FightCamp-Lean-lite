# J52: HOW MANAGEMENT GAMES EXPLAIN THEMSELVES

- **Task:** J52, tooltips, glossary and first-career tutorial for FightCamp (Godot fight-gym management sim)
- **Date:** 2026-09-25 (every source read on this date)
- **Author:** John Research
- **Status:** RESEARCH ONLY. No code. Do not edit HANDOFF.
- **Trigger:** Operator, 2026-09-25: "i need tooltips start removing uneccessary text from the menus and use tooltips and also we will need a tutorial".
- **Tags:** SOURCED = a page I read says this. PROXY = a number borrowed from an engine or OS standard, not a management game. JUDGEMENT = my recommendation. NOT FOUND = I looked and could not verify it.
- **Source types:** DEV, BROADCAST, TRADE, ACADEMIC, PRESS, COUNT, COMMUNITY, STANDARD. Sources are listed in §7.

---

## §0 Headline answer

1. **Real gyms teach in three layers.** A short formal course covers safety, rules, coaching basics and weight making. Then you work under a senior coach. The hard parts are learned on live shows: matchmaking, weigh-ins, show paperwork and corner work. SOURCED (S52–S59). The game should copy this. Keep the tutorial short. Teach the rest through contextual hints the first time each thing happens. JUDGEMENT.
2. **What goes on screen and what goes in a tooltip.** If the player needs it to act right now, it stays on screen. If it explains or gives background, it moves to a tooltip or the glossary. A tooltip must never be the only place a task-critical fact lives. SOURCED (S8, S10). Keep new learning to about 3 items at once. SOURCED (S11).
3. **Tooltip timing.** Show after **500 ms** of stillness. When the cursor moves to a neighbouring item, re-show after **100 ms**. Stay open for **500 ms** after the cursor leaves. PROXY (Godot default 0.5 s S1/S3; Windows 500/100 ms S4; Material web 500/600 ms S5; NN/g 0.3–0.5 s wait and 0.5 s leave grace S9). No management game I checked publishes its own millisecond value. NOT FOUND.
4. **Glossary.** Use one entry per term, and every tooltip and handbook page reads from it. This is the CK3 Encyclopedia pattern (S13, S14) and the FM26 FMPedia pattern (S26). Nested term links can go at most 2 levels deep (S10). Add an explicit pin key, and do not make a slow fill-timer the default. CK3 players repeatedly lost tooltips that way (S17, S18, S20, S21).
5. **Tutorial.** Use a guided first career month inside a real save, not a separate mode. It should have about **18 short steps** of 1–2 sentences each. Make it optional at new career, cancellable at any time and replayable per chapter from the handbook. After it ends or is skipped, show one-time first-open hints. The model is CK3's 2024 cut from 67 boxes to about a third (S12), plus Apple's "fast, fun, and optional" (S7).

---

## §1 How a human learns to run a fight gym

### 1a. The formal ladder (boxing is the best documented)

| Step | What it is | Numbers | Tag / source |
|---|---|---|---|
| Join and affiliate | You coach inside an affiliated club. England Boxing L1 candidates are equipped "to work alongside an England Boxing Level 2 Full Coach within an England Boxing affiliated club". | L1 attendance age 17, coaching age 18 | SOURCED S52 |
| England Boxing Level 1 Assistant Coach | Four days, "usually two full weekends", assessed across all four days. Covers group coaching (IDEA principle), health and safety, **weight making**, nutrition, safeguarding and rules. | 4 days, 9am–5pm; £185 member / £250 non-member; valid 3 years | SOURCED S52, S54 |
| What an L1 may do | Can corner a boxer in competition (under the referee and the appointed official in charge). Cannot take sparring alone. Cannot run a club. | — | SOURCED S52, S54 |
| Licence extras | Enhanced DBS, England Boxing safeguarding course, face-to-face First Aid with AED, "minimum of 3 hours". | Each valid 3 years | SOURCED S52, S54 |
| England Boxing Level 2 Full Coach | Needs "a minimum of one year" as L1 and competence in pads and supervised sparring. You bring two boxers to the assessment day. After passing you can supervise sparring and "set up their own boxing clubs". | 4 days; £231; one free re-assessment within 12 months | SOURCED S53, S54 |
| Club rule since 1 June 2025 | Every club must list a licensed L2 as "Club Head Coach", or it cannot compete. | — | SOURCED S55 |
| England Boxing Level 3 Senior Coach | L2 for "a minimum of 3 years", two references, then a full-year course. | 1 year | SOURCED S54 (a grok lead says 5 years; see Appendix A) |
| USA Boxing Green | Free online course, 50 questions, needs 100%. Skills, rules, strength and conditioning, nutrition. | 50 Q / 100% | SOURCED S56 |
| USA Boxing Bronze | 2 days in person, 16 hours, "How to work a corner", preparing boxers for single-day events. | $100; recertify every 2 years | SOURCED S56 |
| USA Boxing Silver / Gold | Silver: 2 days, 16 hours, tournaments, periodization, film study. Gold: 7 days in Colorado Springs, max 8 coaches, by selection. | $150 / $1,000 | SOURCED S56 |
| MMA / Muay Thai equivalents | No federation course table verified. | — | NOT FOUND |

### 1b. What is learned only by doing (on real shows)

- **Matchmaking comes weeks before the show.** Clubs list carded boxers on a national database with age, weight and experience. Matchmakers "try to make competitive bouts". The maximum weight variance is **2 kg**. SOURCED S57. A community show guide calls matchmaking "the single most critical planning task", and says it "takes weeks, not days". SOURCED S59 (TRADE, vendor blog).
- **Sanctioning paperwork.** The show application goes through the County Association at least **8 weeks** ahead. A show needs **at least 6 bouts** to be viable. The guide says aim for **8–10** because bouts fall through. Boxers sell about **20–40 tickets** each. SOURCED S59 (TRADE).
- **Weigh-in is on show day.** "Every boxer will weigh in to confirm." If a boxer is off the agreed weight, "the bout will be called off by the Officer in Charge". SOURCED S57. The weigh-in window is about 2 hours, in underwear, and you may re-check. Over the limit means "you will not be allowed to compete", with "no grace period". A medical follows. SOURCED S58.
- **Making weight is managed over weeks, not hours.** A club blog puts maximum weekly loss at **2 kg**. It calls sweatsuits and bin-bag cutting "DANGEROUS". SOURCED S57.
- **After the bout.** A loss by KO or RSC to the head brings a standard **28-day** medical suspension. The corner has **60 seconds** between rounds. Senior amateur bouts are **3 x 3 min**. SOURCED S58 (club blog, 2026).
- **Show-night roles.** Show secretary ("the most important role in the planning process"), matchmaker, whip and corner teams. SOURCED S59.
- **Business side.** One new gym owner says permits delayed opening "by about 8 months". His advice is "pick one priority", and to split the work between partners ("If two people have one job it won't get done"). SOURCED S60 (BJJ, not striking).
- **Mentor or previous owner as teacher.** The only structured version I verified is the L1-under-L2 apprenticeship (S52, S54). No verified interview describes a handover from a previous owner. NOT FOUND.

### 1c. The order a new owner learns in (JUDGEMENT, built from 1a–1b)

1. Safety, rules and weight basics come first, in a short course (S52, S56).
2. Next, daily coaching under a senior head coach. Corner work begins at the junior level (S52).
3. Then your first show as a helper: matchmaking lists, the weigh-in table, the medical (S57–S59).
4. Only after that do you run your own shows: sanctioning, bout sheets, 8–10 bouts for a 6-bout minimum (S59).

For FightCamp this means the tutorial teaches steps 1–2 plus one supervised show. Steps 3–4 detail belongs in hints and the glossary.

### 1d. How the best management-game UX people decide screen vs tooltip vs tutorial

- **NN/g:** "Don't use tooltips for information that is vital to task completion." "Important information should always be on the page." Use tooltips consistently or players never find them. SOURCED S8.
- **Progressive disclosure:** "the very fact that something appears on the initial display tells users that it's important." Designs "beyond 2 disclosure levels typically have low usability". SOURCED S10.
- **Celia Hodent (GDC 2016):** Treat "3 items to process at the same time" as "THE MAXIMUM when in learning mode". Loading-screen tips should "don't explain more than 3 things and focus on the why". Learning by doing beats text. Avoid punishing players "WHILE THEY ARE JUST LEARNING". Use spaced reminders. SOURCED S11.
- **Paradox (CK3):** Petter Lundh: "there are often such significant gains to be made in presentation and UI flow alone that simplifying game mechanics is not needed." Jonas Wickerström on why nested tooltips exist: "Why can't I just move my mouse inside the tooltip?" SOURCED S15. The CK3 UX leads used telemetry, progressive disclosure and playtests on staff from other games, because of the "curse of knowledge". SOURCED S12.
- **Sports Interactive (FM):** Designs for **six player cohorts**, from new players to 1000+ hour players, aiming for **about 20%** of features per cohort. Every design doc names its target cohort on page one. SOURCED S28.
- **Apple HIG:** Onboarding should be "fast, fun, and optional". Prefer "a collection of context-specific tips" over one flow. If a tutorial is skipped, "don't present it again", but keep it findable. SOURCED S7. For tips, a feature needing "more than three actions" is "probably too complicated for a tip". SOURCED S6.

---

## §2 Tooltips in management sims

| Game | Show delay | Setting exposed? | Length rule | Nesting / lock | Same wording everywhere? | Sources |
|---|---|---|---|---|---|---|
| Football Manager 24 | ms value NOT FOUND | Yes. "Tooltip Speed" has 5 steps: Very Slow / Slow / Average / Fast / Very Fast. Default NOT FOUND. | NOT FOUND | NOT FOUND | NOT FOUND (FM attribute description text not verified) | S30 (COMMUNITY) |
| Football Manager 25 | — | — | — | — | — | Cancelled. Jacobson refers to "die Entscheidung ... den FM25 abzusagen". SOURCED S28 |
| Football Manager 26 | NOT FOUND | NOT FOUND | NOT FOUND | NOT FOUND | Yes. **FMPedia**, an in-game glossary of "10 different game areas", linked from search, with tiles that jump to the relevant screen. SOURCED S26 | S26 (DEV), S27, S32 |
| FM26 launch complaints | — | — | — | — | Steam, 23 Oct 2025: "There are almost no tooltips pop-ups". Eurogamer preview: "There's no 'i' button to hover over to quickly view a player's attributes". | S32 (COMMUNITY), S27 (PRESS) |
| Motorsport Manager | NOT FOUND | Tooltips "can also be disabled in the options" | NOT FOUND | NOT FOUND | NOT FOUND | S36 (COMMUNITY) |
| Punch Club 1 | NOT FOUND | NOT FOUND | NOT FOUND | NOT FOUND | NOT FOUND | — |
| Punch Club 2 | NOT FOUND | NOT FOUND | NOT FOUND | No | Partly. Hovering Strength, Agility and Stamina gives "very good" explanations. The top-left need icons and the hand symbols have no hover text. | S39, S41 (COMMUNITY) |
| Out of the Park Baseball | ms NOT FOUND | A player popup delay setting exists, including a "no popup" option. **Weak:** read only as a search-index summary of an OOTP forum thread; the page itself was blocked. The sister game FHM9 manual confirms player info popups can be turned off. | NOT FOUND | No nesting found | In-game tutorials added in OOTP 23 (see §4) | S44 (COMMUNITY, weak), S62 (DEV) |
| Crusader Kings 3 | Separate "Tooltip Delay" and "Lock Delay" sliders. Players report the show-delay slider "does nothing" or tooltips "appear instantly" (2020, 2023). Default lock delay "1.5 sec" per a player; one player lowered it to "0.7 seconds". Official default table NOT FOUND. | Yes. Modes: **Timer Lock (default)**, **Action Lock** (middle mouse), Mouse Tendency. | Press preview: tooltips "generally clear and concise" | **Nested "tooltips in tooltips"** on blue Game Concepts, "more and more information" (no stated depth cap) | Yes. **Encyclopedia** holds Game Concepts, tutorial recaps, reactive advice, traits and terrain. | S14 (DEV, via mirror), S13 (PRESS), S16–S19, S23, S24 (COMMUNITY) |
| Victoria 3 (Paradox, same system) | NOT FOUND | Same lock modes (per search summary) | NOT FOUND | Nested tooltips carried over from CK3, "like having the game's official wiki sitting right alongside your mouse pointer" | Concept terms highlighted | S51 (PRESS) |
| Frostpunk 1 | NOT FOUND | NOT FOUND | NOT FOUND | NOT FOUND | NOT FOUND | — |
| Frostpunk 2 | NOT FOUND | Pop-up / modal tutorials can be turned off (patch 1.6.1 fixes a bug "when modal tutorials were turned off") | NOT FOUND | No nesting found. Hover an item and press **T** for its tutorial window (player tip). | Tutorial panels act as the in-game manual. Many patches fix tooltip text: modifier order, missing requirement tooltips, leaking text. | S49 (DEV patch notes), S50 (COMMUNITY) |

**Engine and OS defaults (PROXY)**

| Standard | Value | Source |
|---|---|---|
| Godot `gui/timers/tooltip_delay_sec` | **0.5 s**, lowered from 0.7 s on 2019-04-10 "to match other applications' and OS' tooltip behaviors". Custom tooltips via `_make_custom_tooltip()`. Theme types "TooltipPanel" and "TooltipLabel". | S1, S2, S3 (DEV) |
| Windows common-controls tooltip | Initial **500 ms**, autopop **5000 ms**, reshow **100 ms** (derived from double-click time) | S4 (STANDARD) |
| Material Components Web tooltip | `SHOW_DELAY_MS: 500`, `HIDE_DELAY_MS: 600` | S5 (STANDARD) |
| NN/g hover timing | Feedback within 0.1 s, then wait **0.3–0.5 s**, then show. Hide only after the cursor has been out for **>0.5 s**. | S9 (STANDARD) |
| Apple HIG tooltip length | "limit tooltip content to a maximum of 60 to 75 characters". Begin with a verb. Do not repeat the control's name. | S6 (STANDARD) |
| Apple ms default | NOT FOUND (HIG gives none; a grok lead says 2000 ms, see Appendix A) | — |

---

## §3 On-screen text budget

Rules of thumb, each with its tag:

1. **Vital-to-act stays on screen.** Anything the player must read to complete the current step stays visible: the number they compare, the button label, a blocking warning. SOURCED S8.
2. **Explanation moves off screen.** Why a system works, what a stat means, and lore go to a tooltip or the glossary. SOURCED S8, S10.
3. **The first screen signals importance.** Whatever is on screen reads as important, so captions about minor behaviour ("what is drawn below is what gets saved") cost attention. SOURCED S10.
4. **Two levels maximum.** Screen, then tooltip, then one nested term. Beyond that, send the player to the handbook page. SOURCED S10 (">2 levels ... low usability"). JUDGEMENT to apply it as a hard cap.
5. **3 new items at once while learning.** No tutorial beat or first-open hint should introduce more than 3 new things. SOURCED S11.
6. **Label every icon or give every icon a tooltip, consistently.** Partial coverage makes tooltips undiscoverable. SOURCED S8. Punch Club 2 players complained exactly about unlabelled icons. SOURCED S39, S41.
7. **Tooltips must not cover what they explain.** Place them so they do not block related content. SOURCED S8. A CK3 player asked for the tooltip's top-left corner not to be "covered by the gigantic mouse". SOURCED S22.
8. **Explain the why, not only the what.** SOURCED S11.
9. **Show numbers and words together.** FM26 moved manager attributes to words only ("average, good, very good"). The Eurogamer editor disliked it: "If an attribute has a number behind the scenes we might as well be able to see it". SOURCED S27. JUDGEMENT: FightCamp keeps the number and adds a band word in the tooltip.
10. **Keep the full tutorial transcript off the screen.** Tutorial recaps belong in the handbook, as CK3 (S13) and FM26 (S26) do.

---

## §4 Tutorials per game

| Game | Form | Skip rules | Length | How players rate it (dated) | Sources |
|---|---|---|---|---|---|
| FM24 | Staff-led concept tutorials, opted in at manager creation: "Teach me about key management concepts". If unticked, they stay available via the "?" icon. Assistant advice arrives in the inbox. | Opt-in checkbox | NOT FOUND | Steam, 15 Nov 2023: "every time I start a new save the tutorial comes on ... how to stop it?" | S29, S31 |
| FM26 | Tutorials "rebuilt" as "useful explainers at the start of your saves", "broken down into stages". Run again any time. Plus FMPedia. Inductions come through the Portal (inbox) as "slide-like pages". | Replayable; skip rule NOT FOUND | Minutes NOT FOUND. Jacobson: without the tutorial bits some players may "vielleicht 20 Stunden brauchen" (maybe need 20 hours). Players with 200–300 hours understood the UI "nach einer halben bis einer Stunde" (after half an hour to an hour). | Eurogamer, 16 Oct 2025: "It took me a long time just to get through all my inductions". Induction pages "(slightly verbose)". "There's no 'back' button within the windows." Steam, 28 May 2026: tutorials shown "jedes mal" (every time). | S26 (DEV), S27 (PRESS), S28, S33 |
| FM Touch | NOT FOUND | — | — | — | — |
| Motorsport Manager | Guided career start: an "in-depth tutorial" over "the first couple of races". A tutorial on/off toggle sits in the first new-career dialog. A "cancel tutorial" button exists. | Toggle at career start, and cancel mid-way | RPS: a "somewhat tedious opening ten minutes or so" (a forced race). One player: "47 minutes and I'm still being forced to click on every button once". | RPS, 7 Nov 2016: "forcing you to play through an entire race before introducing the planning". Steam, 16 Feb 2017: it "takes the preseason away". Steam, 14 Jun 2018: "I've quit twice". | S34, S35, S36, S37 |
| Punch Club 1 | "Opening and ongoing tutorial" | NOT FOUND | NOT FOUND | Review, 9 Jan 2016: "A lot of hand holding and all the game play is very funnelled." | S38 |
| Punch Club 2 | Opening tutorial with guide dialogues ("mr paperclip") | A player reply (year not shown, likely 2026): skip "only if you completed the game once". Unconfirmed by the developer. | NOT FOUND | Steam, 21 Jul 2023: "there no explanation about any icon". 29 Dec 2023: icons were "one of my most difficult barriers". 22 Jul 2023: "I legit forgot what the tutorial said." 22 Aug 2024: "Bad tutorial ... You don't explain what half of these symbols mean". | S39, S40, S41, S42 |
| EA UFC 5 career | "Onboarding tutorials" required in the first career | "Can be skipped in every subsequent career mode save". Drills repeatable later. | NOT FOUND (grok lead: 40–45 min, unverified) | NOT FOUND | S45 (TRADE guide, updated 19 Jul 2024) |
| EA UFC 4 career | NOT FOUND | — | — | — | — |
| Undisputed | Early access (2023): the tutorial is "a work in progress". A key mechanic (power from a planted foot) "isn't communicated right now". Tutorial replay exists in game modes. | Skippable. A player "Skipped it by accident" and found replay under game modes (17 Apr 2023). | NOT FOUND | PC Gamer, 12 Apr 2023: "More practice modes and tutorial information would be nice". Career-mode tutorial at 1.0: NOT FOUND. | S46, S47 |
| WWE 2K25 MyGM | No standalone MyGM tutorial found. Guidance comes from Triple H "Commissioner Goals", an R3 "recommendations" button in the draft, and class-pairing hints at the top of the draft screen. | n/a | n/a | NOT FOUND | S48 (COMMUNITY guide) |
| OOTP 23 | "New In-Game Tutorials ... simple, powerful explainers", with "more ... added all season long based on feedback" | NOT FOUND | NOT FOUND | NOT FOUND | S62 |
| CK3 | Guided tutorial that opens the needed windows and highlights them, plus reactive advice. The Encyclopedia stores tutorial recaps. A second, shorter tutorial came in 2024. | Guided vs dive-in choice (DD16 mirror excerpt, fragmentary: weak). Both tutorials kept in game (S12). | Original: **67 sequential boxes**. New: "roughly one-third" (≈22, my arithmetic). One player needed **7–8 hours** and was "nowhere near done" (playing in German). | PC Gamer, 14 May 2020: "too wordy and a bit on the dull side". UX leads, 12 Sep 2024: "finishing the tutorial wasn't a major determining factor" in retention, though the tutorial overall "has a significant impact on the retention rates". A nested-tooltip tutorial step blocked players (2 Sep 2020; 20 Apr 2021). | S12 (DEV), S13, S14, S20, S21, S25 |
| Frostpunk 1 | NOT FOUND (verified) | — | — | — | — |
| Frostpunk 2 | "literally the first chapter is the tutorial". Hover and press T for a topic window. Patch 1.2.0 (27 Nov 2024) added "New pop-up tutorial panels". 8 May 2025 update: prologue "rebalanced ... added a midpoint start option", new tutorial modals. | Modal tutorials can be turned off (1.6.1). Midpoint start (2025). | NOT FOUND | Steam, 20 Sep 2024: "absolutely drop the ball with showing players how to actually play". The same day, a CK3/Vic3 player felt "sensory overload about the UI" and said those games "have a better tutorial". Patch 1.4.1 (3 Oct 2025) fixed pop-up tutorials that could "softlock" the game. | S49, S50 |

**Steam review percentages that isolate the tutorial:** NOT FOUND for any game.

---

## §5 Failure modes (real complaints, dated)

**Tutorials**

| Failure | Evidence | Source |
|---|---|---|
| Teaching the wrong thing first | MM forces a full race "before introducing the planning and preparation that make up most of the game" (7 Nov 2016) | S34 |
| Forced clicks | "47 minutes and I'm still being forced to click on every button once. Just let me play" (9 Nov 2016) | S36 |
| Tutorial costs real game time | MM tutorial "takes the preseason away" (16 Feb 2017) | S35 |
| Rage quits | "I've quit twice, couldn't get through it without rage quiting. It takes too long" (14 Jun 2018) | S37 |
| Too wordy / too long | CK3 "too wordy and a bit on the dull side" (14 May 2020). 67 boxes (2024 dev article). FM26 inductions "(slightly verbose)" (16 Oct 2025). | S13, S12, S27 |
| Repeats every save | FM24 (15 Nov 2023). FM26 (28 May 2026). | S31, S33 |
| Can't skip | PC2: "Is there a way to skip ... tutorials?" (29 Jul 2023) | S40 |
| Can't replay after skipping | Undisputed: "Skipped it by accident" (17 Apr 2023) | S47 |
| Forgotten right after | "I legit forgot what the tutorial said." (22 Jul 2023) | S42 |
| Tutorial blocks on the UI it teaches | CK3 tutorial asks you to hover inside a tooltip, and the tooltip vanishes (2 Sep 2020) | S20 |
| Tutorial bugs soft-lock the game | FP2 patch fixed pop-up tutorials that "enter an unresponsive state leading to softlock" (3 Oct 2025) | S49 |
| Navigation traps inside the tutorial | FM26: "no 'back' button within the windows", so you lose your place in the induction (16 Oct 2025) | S27 |

**Tooltips**

| Failure | Evidence | Source |
|---|---|---|
| Disappears when you move to it | CK3: "the tooltip box disappears as soon as I try to move the cursor onto the nested tooltip" (20 Apr 2021). "Half the time I can't get my mouse to the item" (5 Sep 2020). | S21, S18 |
| Lock timer too slow | Players lowered the default lock (~1.5 s) to 0.7 s: "Changed my life" (2 Sep 2020) | S17, S18 |
| Delay setting ignored | CK3 "tooltips always appear instantly" (1 Sep 2020). "the first slider does nothing" (25 Oct 2020). "no delay ... it is annoying" (30 Nov 2023). | S23, S16, S24 |
| Covers what you read | "top-left corner of every tooltip pop-up ... covered by the gigantic mouse" (3 Sep 2020) | S22 |
| Missing on the thing you need | PC2 need icons have no hover (29 Dec 2023). FM26 "almost no tooltips" (23 Oct 2025). FM26 no "i" hover for attributes (16 Oct 2025). | S39, S32, S27 |
| Unclear icons inside tooltips | PC2 attack tooltips: "Does the red and orange explosion looking symbol mean damage?" (23 Aug 2024) | S41 |
| Locked tooltip closes when path crosses another hot spot | CK3 player: locked tooltips disappear when the cursor crosses the map on the way (Reddit, date not shown) | S19 |
| Inconsistent or wrong text | FP2 patch notes repeatedly fix tooltip content (modifier order, mismatched info, raw `<positivesemibold>` strings, 2024–2026) | S49 |

**Instructions found inside fetched pages:** none aimed at me. No page tried to instruct the agent.

---

## §6 FightCamp spec

### 6a. Tooltip spec

| Item | Value | Tag | Basis |
|---|---|---|---|
| Show delay (mouse still on element) | **500 ms** (set `gui/timers/tooltip_delay_sec = 0.5`, which is already the Godot default) | PROXY | S1, S3, S4, S5; inside NN/g 300–500 ms S9 |
| Re-show when moving between adjacent tooltip items | **100 ms** | PROXY | Windows reshow S4 |
| Hide grace after cursor leaves element and tooltip | **500 ms** | PROXY | S9 (>0.5 s); MDC hide 600 ms S5 |
| Hover feedback (highlight on element) | **≤100 ms** | PROXY | S9 |
| Player setting | Tooltip speed: Instant 0 / Fast 250 / **Default 500** / Slow 1000 ms, plus Off. Setting must actually apply everywhere. | JUDGEMENT | FM 5-step speed S30; CK3 broken-slider complaints S16, S23, S24 |
| Keyboard / controller | Focused control shows its tooltip after the same delay | SOURCED rule | S8 ("Support both mouse and keyboard hover") |
| Max length, plain control tooltip | **≤75 characters**, start with a verb, do not repeat the label | PROXY | Apple 60–75 chars S6 |
| Max length, term tooltip (badges, stats) | 3 content lines, **≤40 words total**: name + definition (≤15 words), "Now:" line (≤12), "Why it matters" line (≤12) | JUDGEMENT | Hodent 3-item cap S11; brevity S6, S8 |
| Term tooltip template | **TERM (full name)** / one-line definition / **Now: value → band word** ("60 → Solid amateur") / **Why:** what it changes | JUDGEMENT | S11 (teach the why); S27 (keep numbers visible) |
| Nesting | Linked glossary terms inside a tooltip are highlighted in one colour. **Max depth 2** (tooltip → one nested term). Deeper links open the Handbook page. | SOURCED cap / JUDGEMENT colour | S10; CK3 blue concepts S14 |
| Lock / pin | Pin with **middle mouse or a keybind (default: Ctrl)**. Also auto-keep while the cursor travels into the tooltip within the 500 ms grace. **No fill-timer as the default.** A timer lock may exist as an option. | JUDGEMENT | CK3 complaints S17, S18, S20, S21; CK3 Action Lock S14 |
| Unpin / close | Esc or click outside closes the whole chain | JUDGEMENT | NN/g click-outside rule S9 |
| Placement | Never over the hovered element or the cursor. Offset below-right, flip at screen edge. Arrow when elements are close. | SOURCED rule | S8; S22 |
| Coverage | Every badge, abbreviation and icon gets a tooltip on every screen. No partial coverage. | SOURCED rule | S8; S39 |
| Content source | Term tooltips pull **only** from the glossary (see 6b). No hand-typed duplicate text. | JUDGEMENT | S13, S14, S26 pattern |

### 6b. Glossary rules ("Gym Handbook")

1. **One entry per term, one ID.** Fields: `id`, `name`, `abbr` (e.g. COND), `short` (≤15 words), `long` (≤80 words), `bands` (value → word), `why` (≤12 words), `related[]`, `screens[]`. JUDGEMENT.
2. **Single source of truth.** Tooltips, the handbook page, tutorial text and hints all read the same `short` and `long`. No copy-paste strings in scenes. JUDGEMENT, following the CK3 Encyclopedia (S13, S14) and FMPedia (S26).
3. **Abbreviations only if they have an entry.** Every on-screen abbreviation (COND, PROF, EXP, W-L-D) maps to an entry. JUDGEMENT.
4. **Handbook screen.** Searchable. Grouped into about 8–10 areas (Gym, Roster, Training, Condition, Matchmaking, Fight Week, Weigh-in, Fight Night, Money, Rules). Each page links to the screen where the term is used. SOURCED pattern (FMPedia's 10 areas with jump tiles, S26); area list is JUDGEMENT.
5. **Tutorial recaps live in the Handbook.** One page per tutorial chapter, with "Replay this chapter". SOURCED pattern S13, S26.
6. **Real-world terms match real usage.** Carded, matchmaker, agreed weight, weigh-in, medical, OIC, corner, RSC, suspension. Definitions checked against S52–S59. JUDGEMENT.
7. **Writing rules.** Plain words, sentence case, no lore in `short`, explain the why. SOURCED S6, S11.

### 6c. Text-cut rules (screen by screen)

1. Keep: values the player compares, action labels, blocking warnings, the current objective. SOURCED S8.
2. Cut to tooltip: definitions, how a stat is computed, consequences that do not block the current action. SOURCED S8, S10.
3. Cut to Handbook: multi-sentence explanations, history, edge cases. SOURCED S10.
4. Replace an explanatory caption with a visible behaviour where possible, such as a live preview or a greyed button with a reason tooltip. JUDGEMENT, based on the affordance point in S11.
5. No caption over **1 line (~60 characters)** survives on a menu screen. JUDGEMENT.

**Example 1: "THE NAME SEEDS THE FLOOR AND THE ROSTER, SO WHAT IS DRAWN BELOW IS WHAT GETS SAVED"**
- Remove the caption. JUDGEMENT.
- Show the floor and roster preview redrawing live as the name is typed. The behaviour then explains itself. JUDGEMENT (S11 affordances).
- Put a small (i) next to the Name field. Tooltip: **Gym name**, "Your gym's name also generates its floor layout and starting roster.", **Now:** "Preview below = your save." (21 words.) JUDGEMENT.
- Keep a 3–4 word field hint only if playtests show people miss it: "Name shapes gym + roster". JUDGEMENT.

**Example 2: bare badges "PROFICIENCY 60" and "COND 61%"**
- Keep both numbers on screen. They drive decisions. SOURCED rule S8. JUDGEMENT to keep the number (S27).
- Expand COND to CONDITION where width allows. Otherwise keep COND, but only because it has a glossary entry. JUDGEMENT.
- Add a colour band to the badge. JUDGEMENT.
- PROFICIENCY tooltip (placeholder wording, bands to be set by design): **Proficiency (technique)**, "How well this fighter executes their style's techniques.", **Now:** "60 → Solid amateur", **Why:** "Raises hit accuracy and defence in bouts." JUDGEMENT.
- CONDITION tooltip: **Condition**, "Current physical freshness. Training lowers it, rest restores it.", **Now:** "61% → Tired, risky to spar hard", **Why:** "Low condition cuts output and raises injury risk." JUDGEMENT. Gameplay effects must match real code. I have not checked them (no repo work).

### 6d. Tutorial: guided first career month

**Form.** A playable guided month inside a real save. It uses highlighted targets (coach marks) for the first action on each new screen, then free play. It is not a separate mode. SOURCED direction (Apple "Teach through interactivity" and "fast, fun, and optional" S7; Hodent learning by doing S11; CK3 in-save guided tutorial S14). The voice is a senior head coach or mentor, mirroring the real L1-under-L2 apprenticeship (S52) and FM staff-led concepts (S29). JUDGEMENT.

**Beat rules.** Each step is 1 action and at most 2 sentences (S6). At most 3 new items per step (S11). No failure state inside the tutorial: the first amateur opponent is a fair match and the fighter is safely on weight (S11 "avoid punishing states"). The tutorial must **not** consume the normal prep time a skipper would get (S35). All JUDGEMENT anchored as noted.

**Step list (18 steps, 8 phases).** Step count is JUDGEMENT, anchored to CK3's cut to about a third of 67 (≈22, S12). Target play time is **15–25 minutes**. JUDGEMENT; no benchmark minute value found (NOT FOUND). MM's "ten minutes" forced opening was already called tedious (S34).

| # | Phase | Player does | Teaches (max 3 items) |
|---|---|---|---|
| 1 | New career | Names the gym; preview redraws | Name seeds floor + roster; preview = save |
| 2 | New career | Confirms head coach / starting roster | Who is on the team |
| 3 | Open gym | Clicks a fighter on the floor | Fighter card; badges; hover = tooltip |
| 4 | Open gym | Hovers PROFICIENCY, pins it, hovers a linked term | Tooltip, pin, nested term (depth 2) |
| 5 | Open gym | Sets this week's training for one fighter | Training plan; condition cost |
| 6 | Open gym | Advances one day | Time controls; COND changes |
| 7 | Book amateur bout | Opens Matchmaking | Carded fighters; opponent list |
| 8 | Book amateur bout | Reads one suggested opponent | Weight, age, experience = fair match (S57) |
| 9 | Book amateur bout | Accepts the bout at an agreed weight | Agreed weight; ≤2 kg gap (S57) |
| 10 | Book amateur bout | Sees fight date + weigh-in on calendar | Calendar; weeks of lead time (S57, S59) |
| 11 | Build-up | Checks the weight tracker; skips ahead to fight week | Weight is managed over weeks (S57) |
| 12 | Fight week | Sets a lighter fight-week plan | Taper; condition peak |
| 13 | Fight week | Reviews the opponent card | Scouting basics |
| 14 | Weigh-in | Steps on the scale → on weight | Weigh-in on show day; off weight = bout off (told, not forced) (S57, S58) |
| 15 | Weigh-in | Medical clearance screen | Medical + record card (S58) |
| 16 | Fight night | Gives one corner instruction between rounds | Corner, 60-second break (S58) |
| 17 | Fight night | Watches / sims to the result | Result, scoring basics |
| 18 | Result | Reads result, recovery / suspension note; tutorial ends | Suspension rules (S58); Handbook + hints now on |

### 6e. Skip, replay and hints

| Rule | Value | Tag | Basis |
|---|---|---|---|
| Offer | New-career checkbox, **on by default for the first career, off by default afterwards** | JUDGEMENT | FM24 opt-in S29; MM toggle S35; UFC 5 required first time, skippable later S45 |
| Cancel anytime | "End tutorial" in the pause menu; the game continues in the same save with nothing lost | SOURCED pattern / JUDGEMENT | MM cancel button S36 |
| Never auto-repeat | Once finished or skipped on this profile, never auto-start again | SOURCED rule | Apple S7; complaints S31, S33 |
| Replay | Handbook → Tutorial → replay any chapter (1–8) in a sandbox copy | SOURCED pattern / JUDGEMENT | FM26 S26; CK3 recaps S13; Undisputed complaint S47 |
| First-open hints | Fire once per screen or feature on first open, only if the tutorial did not teach it. ≤2 sentences. Dismiss with one click. | SOURCED pattern / JUDGEMENT | Apple context tips S7, tip length S6; CK3 reactive advice S14 |
| Event hints | Fire on first occurrence of: first weigh-in miss risk, first injury, first suspension, first sanction deadline | JUDGEMENT | Real "learned by doing" list §1b |
| Hint rate cap | Max **1** unsolicited hint per screen visit, max **3** per in-game week | JUDGEMENT (Apple suggests a cadence like "once every 24 hours" for tips, PROXY S6) | S6 |
| Hint settings | Hints On/Off, plus "Reset hints" | JUDGEMENT | — |
| Tutorial must be bug-proof | No step may block input on failure. Every highlighted step has a timeout fallback ("Continue") so it can never soft-lock. | JUDGEMENT | FP2 softlock S49; MM stuck-step threads (S36 context) |

---

## §7 Sources index (all read 2026-09-25)

| ID | Source | Date | Type | URL |
|---|---|---|---|---|
| S1 | Godot docs, ProjectSettings `gui/timers/tooltip_delay_sec = 0.5` | stable docs, undated | DEV | https://docs.godotengine.org/en/stable/classes/class_projectsettings.html |
| S2 | Godot docs, Control `tooltip_text`, `_make_custom_tooltip` | stable docs, undated | DEV | https://docs.godotengine.org/en/stable/classes/class_control.html |
| S3 | Godot commit 73ad31c "Decrease the default tooltip delay to 0.5 seconds" | 2019-04-10 | DEV | https://github.com/godotengine/godot/commit/73ad31c0fa26c67c93561b42a934d69fb01c8f02 |
| S4 | Microsoft Learn, TTM_SETDELAYTIME | undated page | STANDARD | https://learn.microsoft.com/en-us/windows/win32/controls/ttm-setdelaytime |
| S5 | Material Components Web, mdc-tooltip constants.ts | master, undated | STANDARD | https://github.com/material-components/material-components-web/blob/master/packages/mdc-tooltip/constants.ts |
| S6 | Apple HIG, Offering help (tooltips, tips) | changelog 2023-12-05 | STANDARD | https://developer.apple.com/design/human-interface-guidelines/offering-help |
| S7 | Apple HIG, Onboarding | changelog 2024-06-10 | STANDARD | https://developer.apple.com/design/human-interface-guidelines/onboarding |
| S8 | NN/g, Tooltip Guidelines (A. Kendrick) | 2019-01-27 | STANDARD | https://www.nngroup.com/articles/tooltip-guidelines/ |
| S9 | NN/g, Timing Guidelines for Exposing Hidden Content (A. Harley) | 2015-01-11 | STANDARD | https://www.nngroup.com/articles/timing-exposing-content/ |
| S10 | NN/g, Progressive Disclosure (J. Nielsen) | 2006-12-03 | STANDARD | https://www.nngroup.com/articles/progressive-disclosure/ |
| S11 | Celia Hodent, The Gamer's Brain Part 2: UX of Onboarding (GDC16 slides/notes) | 2016-03-22 | ACADEMIC | https://celiahodent.com/gamers-brain-ux-onboarding/ |
| S12 | Game Developer, Deep Dive: Refreshing the CK3 tutorial (Martins, Zetterman, Paradox) | 2024-09-12 | DEV | https://www.gamedeveloper.com/design/deep-dive-refreshing-the-crusader-kings-iii-tutorial-mode-through-optimized-ux |
| S13 | PC Gamer, "Crusader Kings 3 sticks to what it does best" (F. Brown) | 2020-05-14 | PRESS | https://www.pcgamer.com/crusader-kings-3-sticks-to-what-it-does-best/ |
| S14 | CK3 Dev Diary #16, Tutorials, Tooltips and Encyclopedias (read via Reddit mirror excerpt; Paradox forum blocked by captcha) | 2020 (exact date not confirmed on page read) | DEV | https://www.reddit.com/r/CrusaderKings/comments/fcuo7j/dev_diary_16_tutorials_tooltips_and_encyclopedias/ |
| S15 | The Verge, "The hellish design of the Crusader Kings video games" (G. Jackson; Wickerström, Lundh quotes) | 2023-04-04 | PRESS | https://www.theverge.com/games/23653870/crusader-kings-3-design-ui |
| S16 | Reddit r/CrusaderKings, "CK3 Tooltip delay not working" (via search index) | 2020-10-23 | COMMUNITY | https://www.reddit.com/r/CrusaderKings/comments/jgsa6p/ck3_tooltip_delay_not_working/ |
| S17 | Reddit r/CrusaderKings, "Hovering longer keeps tooltip open" (via search index) | 2020-09-02 | COMMUNITY | https://www.reddit.com/r/CrusaderKings/comments/ild3dw/ck3tip_hovering_longer_keeps_tooltip_open/ |
| S18 | Reddit r/crusaderkings3, "Keep the popup open so I can mouse over!" (via search index) | 2020-09-05 | COMMUNITY | https://www.reddit.com/r/crusaderkings3/comments/in3a5b/keep_the_popup_open_so_i_can_mouse_over/ |
| S19 | Reddit r/crusaderkings3, "Problems with tooltip 'locking' in CK3" (via search index) | date not shown | COMMUNITY | https://www.reddit.com/r/crusaderkings3/comments/1jfxkej/problems_with_tooltip_locking_in_ck3/ |
| S20 | Steam CK3, "Tooltip tutorial bugged?" | 2020-09-02 | COMMUNITY | https://steamcommunity.com/app/1158310/discussions/0/2943620809067629379/ |
| S21 | Steam CK3, "Nested Tooltips Question" | 2021-04-20 | COMMUNITY | https://steamcommunity.com/app/1158310/discussions/0/4376911779077817214/ |
| S22 | Steam CK3, "Tooltip coverup" | 2020-09-03 | COMMUNITY | https://steamcommunity.com/app/1158310/discussions/0/2943620809073495013/ |
| S23 | Steam CK3, "Tooltip Delay Bug?" | 2020-09-01 | COMMUNITY | https://steamcommunity.com/app/1158310/discussions/0/2914346777827303312/ |
| S24 | Steam CK3, "mouseover tooltip delay" | 2023-11-30 | COMMUNITY | https://steamcommunity.com/app/1158310/discussions/0/4038102696016373908/ |
| S25 | Steam CK3, "Tutorial" (7–8 hours) | 2021-01-05 | COMMUNITY | https://steamcommunity.com/app/1158310/discussions/0/3007808519555121445/ |
| S26 | footballmanager.com, "Mastering the FM26 UI" (Bookmarks, Search, FMPedia, Tutorials) | undated (FM26 era) | DEV | https://www.footballmanager.com/the-dugout/mastering-fm26-ui |
| S27 | Eurogamer, FM26 preview (C. Tapsell) | 2025-10-16 | PRESS | https://www.eurogamer.net/brace-yourselves-football-manager-fans-ive-played-a-day-of-fm26-and-its-going-to-take-a-lot-of-getting-used-to |
| S28 | fm.zweierkette.de, interview with Miles Jacobson (German transcript) | Oct 2025 (comments 2025-10-21) | PRESS | https://fm.zweierkette.de/fm-releases/miles-jacobson-fm26/ |
| S29 | fifauteam, FM24 Beginners Guide ("Teach me about key management concepts") | undated | COMMUNITY | https://fifauteam.com/football-manager-2024-beginners/ |
| S30 | Linnet's How To, FM24 Tooltip Speed | undated | COMMUNITY | https://linnetshowto.com/how-to-change-tooltip-speed-football-manager-2024/ |
| S31 | Steam FM24, "Tutorial" | 2023-11-15 | COMMUNITY | https://steamcommunity.com/app/2252570/discussions/0/3977302832659711817/ |
| S32 | Steam FM26, "Go back to FM24 and give this game 6 months" | 2025-10-23 | COMMUNITY | https://steamcommunity.com/app/3551340/discussions/0/603044859897702024/ |
| S33 | Steam FM26, "Immer Tutorials" | May 28 (year not shown; Steam omits current year, so 2026) | COMMUNITY | https://steamcommunity.com/app/3551340/discussions/0/658233614222365970/ |
| S34 | Rock Paper Shotgun, Motorsport Manager review (A. Smith) | 2016-11-07 | PRESS | https://www.rockpapershotgun.com/motorsport-manager-review-pc |
| S35 | Steam MM, "Tutorial on Start" | 2017-02-16 | COMMUNITY | https://steamcommunity.com/app/415200/discussions/0/133257324789930859/ |
| S36 | Steam MM, "Tutorial" (47 minutes) | 2016-11-09 | COMMUNITY | https://steamcommunity.com/app/415200/discussions/0/217690940939240347/ |
| S37 | Steam MM, "PLS tutorial adaptation!" | 2018-06-14 | COMMUNITY | https://steamcommunity.com/app/415200/discussions/0/3051633726577827781/ |
| S38 | Gert Lush Gaming, Punch Club review | 2016-01-09 | PRESS | https://gertlushgaming.co.uk/review-punch-club-steam/ |
| S39 | Steam Punch Club 2, "how to play" | 2023-07-21 to 2023-12-29 | COMMUNITY | https://steamcommunity.com/app/1161590/discussions/0/3802777561345983874/ |
| S40 | Steam Punch Club 2, "tutorial skip" | 2023-07-29 | COMMUNITY | https://steamcommunity.com/app/1161590/discussions/1/3810659494978037905/ |
| S41 | Steam Punch Club 2, "Bad tutorial" | 2024-08-22 | COMMUNITY | https://steamcommunity.com/app/1161590/discussions/0/4427688336537160636/ |
| S42 | Steam Punch Club 2, "What does teaching students do exactly?" | 2023-07-22 | COMMUNITY | https://steamcommunity.com/app/1161590/discussions/0/3802777845418923999/ |
| S43 | (unused ID) | — | — | — |
| S44 | OOTP forum "Mouse Over Stats" (search-index summary only; page blocked by Cloudflare) | not shown | COMMUNITY | https://forums.ootpdevelopments.com/showthread.php?t=260466 |
| S45 | GINX, UFC 5 Career Mode guide | updated 2024-07-19 | TRADE | https://www.ginx.tv/en/career-mode |
| S46 | PC Gamer, Undisputed GDC interview (T. Wilde) | 2023-04-12 | PRESS | https://www.pcgamer.com/undisputed-boxing-game-interview-GDC/ |
| S47 | Steam Undisputed, "Replay tutorial?" | 2023-04-17 | COMMUNITY | https://steamcommunity.com/app/1451190/discussions/0/5789982181549133597/ |
| S48 | TheSmackDownHotel, WWE 2K25 MyGM full guide | undated (2025) | COMMUNITY | https://www.thesmackdownhotel.com/news/wwe2k25/wwe-2k25-mygm-mode-full-guide-all-features-tips-tricks |
| S49 | Frostpunk 2 Steam announcements via Steam News API (1.1.0 2024-10-21; 1.2.0 2024-11-27; 1.2.2 2024-12-12; content update 2025-05-08; 1.4.1 2025-10-03; 1.5.2 2025-12-17; 1.6.1 2026-07-02) | 2024–2026 | DEV | https://api.steampowered.com/ISteamNews/GetNewsForApp/v2/?appid=1601580&feeds=steam_community_announcements |
| S50 | Steam Frostpunk 2, "Love the no tutorial" | 2024-09-20 | COMMUNITY | https://steamcommunity.com/app/1601580/discussions/0/4853281047673668866/ |
| S51 | PCGamesN, Victoria 3 will use CK3's tooltip system | 2022-01-14 | PRESS | https://www.pcgamesn.com/victoria-3/nested-tooltip-system |
| S52 | England Boxing, Level 1 Assistant Coach | current page | STANDARD | https://www.englandboxing.org/england-boxing-level-1-assistant-coach/ |
| S53 | England Boxing, Level 2 Full Coach | current page | STANDARD | https://www.englandboxing.org/england-boxing-level-2-full-coach/ |
| S54 | England Boxing, Coaching Policy (PDF) | April 2025 | STANDARD | https://www.englandboxing.org/wp-content/uploads/2025/04/Coaching-Rules-Policy-Final-Apr-25.pdf |
| S55 | England Boxing, Further Update for Clubs, Members and Coaches | 2025-04-07 | STANDARD | https://www.englandboxing.org/news_articles/update-for-england-boxing-clubs-members-and-coaches/ |
| S56 | USA Boxing, Coach Membership (certification levels) | current page | STANDARD | https://www.usaboxing.org/coach |
| S57 | Stevenage ABC, "Between the Ropes: Weight and Amateur Boxing" | 2024-12-05 | COMMUNITY | https://www.stevenageboxing.com/post/between-the-ropes-weight-and-amateur-boxing |
| S58 | Honour & Glory Boxing, "Amateur Boxing Competition Day: What to Expect" | 2026-03-17 | COMMUNITY | https://www.honourandglory.co.uk/blog/amateur-boxing-competition-day-what-to-expect |
| S59 | TidyHQ, Boxing Show Night Planning Guide (UK) | undated | TRADE | https://tidyhq.com/blog/boxing-game-day-planning-guide-uk |
| S60 | The Grappler's Diary, "The Reality of Opening Up Your Own Gym" (interview) | 2024-09-30 | PRESS | https://thegrapplersdiary.substack.com/p/the-reality-of-opening-up-your-own |
| S61 | (unused ID) | — | — | — |
| S62 | OOTP 23 manual, What's New (plus FHM9 manual preferences page for popups) | undated manual | DEV | https://manuals.ootpdevelopments.com/index.php?man=ootp23 |

No COUNT or BROADCAST sources were found or used.

---

## §8 Still unknown (NOT FOUND)

- Any management game's published tooltip show delay in **ms**: FM, MM, Punch Club, OOTP, CK3 official default, Frostpunk.
- FM24 default "Tooltip Speed" step. FM attribute description wording. FM Touch tutorial.
- The official default of CK3's Tooltip Delay and Lock Delay sliders (only player reports of ~1.5 s lock).
- Tutorial length in **minutes** for FM24/26, CK3 (old or new), Punch Club 1/2, UFC 5, OOTP and Frostpunk 2.
- Steam review percentages that isolate tutorial quality.
- Punch Club 1 tooltip behaviour. Frostpunk 1 tutorial and tooltip facts (not verified).
- UFC 4 career tutorial. Undisputed 1.0 career tutorial. WWE 2K26 MyGM tutorial.
- MMA / Muay Thai coach or club course tables comparable to England Boxing and USA Boxing.
- A gym-owner interview describing a previous-owner or mentor handover for a striking gym.
- Tooltip word limits published by any management-game studio (the only numeric limit is Apple's 60–75 characters, which is a PROXY).

## §9 Limits

- Reddit and the Paradox forums blocked direct fetches (403 / captcha). Reddit items S16–S19 and S14 were read as search-index excerpts. Their wording is from those excerpts, and S14's exact date is unconfirmed.
- OOTP forums, the SI community site and GameWatcher were blocked by Cloudflare. The OOTP popup-delay claim (S44) is a search summary only. Treat it as weak.
- Several sources are community guides or single forum posts. They show that complaints exist, not how common they are.
- The Material Design 3 guidelines page needed JavaScript. I used the MDC Web source constants (S5) instead.
- No video was watched and no captions were used.
- No game was played, and no FightCamp code or repo was touched. Gameplay effects in the example tooltips (6c) are placeholders to be checked against real code.
- Boxing sources are UK/US amateur. Pro and MMA rules differ (e.g. day-before weigh-ins). Not verified here.

---

## Appendix A: grok leads, unverified (not counted anywhere)

Grok CLI ran (grok-4.6, reasoning xhigh, live search) on 2026-09-25 and exited normally. The leads below were **not** re-checked against the live page, or could not be because the page was blocked. **grok lead, unverified** applies to every line.

- grok lead, unverified: GameWatcher CK3 preview (14 May 2020) says Timer Lock "waits for a second or two"; four sliders (delay, lock, unlock, locked-open). https://www.gamewatcher.com/crusader-kings-3-tutorials-highlighted-text-encyclopedia (Cloudflare blocked)
- grok lead, unverified: Paradox dev comment that tooltips are Timer Locked by default, Action Lock in Settings > Game. devtrackers.gg (2021).
- grok lead, unverified: Victoria 3 Dev Diary #29 (12 Jan 2022) calls nested tooltips "one piece of technology we cannot see this game without".
- grok lead, unverified: Paradox forum thread "Reminder to the devs that nested tooltips is bad UX design" (3 Sep 2024).
- grok lead, unverified: CK3 guided tutorial is set in Ireland (Murchad of Munster). Settings include "reset reactive advice" (YouTube 4 Oct 2024).
- grok lead, unverified: FMPedia's 10 areas are Squad, Club, Staff, Training, Tactics, Recruitment, Match, World, Glossary, Stats (FM Scout 16 Sep 2025; Passion4FM).
- grok lead, unverified: FM26 patch 26.3.1 (26 May 2026) added hover tooltips on card carousels. An FM27 teaser (22 Sep 2026) promises "more tooltips" for staff attributes and medical reports.
- grok lead, unverified: Eurogamer interview with Miles Jacobson on what went wrong with FM25 (29 Aug 2025).
- grok lead, unverified: FM24 Touch/Console manual: status flags explained via hover/long-press tooltips (SI manual, 12 Oct 2023).
- grok lead, unverified: Punch Club 2 combat-tutorial dev blog on Steam (24 May 2023). Reddit says PC2 tutorials are "mandatory" (12 Jul 2024).
- grok lead, unverified: OOTP dev reply (28 Jun 2025) that tooltips/popups can be disabled. OOTP play-by-play delay configurable in ms (OOTP 12 manual).
- grok lead, unverified: Frostpunk 1 "A New Home" works as the onboarding, about 20 in-game days (IGN Hungary, 2 May 2018).
- grok lead, unverified: Frostpunk 2 console bug where a frostbreaking tutorial popup won't close (Reddit 28 Jan 2025; 19 Sep 2025). Reddit posts "I give up from the first few minutes" (20 Sep 2024) and "A Moan, 2 hours and given up" (24 Feb 2025). Titles were seen in search results; content and dates not verified.
- grok lead, unverified: UFC 5 onboarding takes about 40–45 minutes. Skipping to Contender Series gives about 60 vs 340 Evolution Points. A pause-menu "Skip tutorial" exists (YouTube, Oct–Nov 2023).
- grok lead, unverified: Undisputed career is the recommended learning path (GINX 7 Oct 2024; Game Rant 18 Feb 2023). Official "How to play Undisputed" tutorial video series.
- grok lead, unverified: WWE 2K26 MyGM guides (TheSmackDownHotel 17 Feb 2026; NoobFeed 6 Apr 2026). Confusion is about hidden match options.
- grok lead, unverified: Hodent GDC 2015 talk recommends a written onboarding plan listing every teachable, prioritised by pillars.
- grok lead, unverified: England Boxing L3 requires age 23+ and L2 for ≥5 years (June 2025 summary PDF). **This conflicts with the April 2025 policy PDF (S54), which says 3 years.** Also: L1 online refresher 3 h / £40; club membership £240/year; L1 £176 and L2 £220 in a Feb 2025 fee notice.
- grok lead, unverified: USA Boxing Silver is taken 6 months after Bronze, Gold 1 year after Silver (usaboxingeducation.org pathway page).
- grok lead, unverified: TidyHQ Australia guide: sanctioning 8–12 weeks out; weigh-in same day or day before; corner = head trainer + 1–2 seconds (7 Nov 2025).
- grok lead, unverified: FightCamp (the fitness company) blog: author trained ~6 months before a first sanctioned bout (17 Sep 2021).
- grok lead, unverified: NY Fights (4 Nov 2021) on the history of the shift to day-before pro weigh-ins.
- grok lead, unverified: A Touch of Business boxing-gym owner interviews (20 Jul 2026). Keith Keppner boxing-gym franchise interview (YouTube 26 May 2022).
- grok lead, unverified: Windows MouseHoverTime default 400 ms. macOS `NSInitialToolTipDelay` default ~2000 ms (Ask Different, 2023–2024).
- grok lead, unverified: Material Design (classic) says to display the tooltip for 1.5 seconds. Angular Material hides after 1500 ms on mobile. MUI touch long-press is 700 ms.
- grok lead, unverified: Philip Ardeljan blog (7 Sep 2020) suggests 2–3 nested tooltip levels as a sensible maximum.
