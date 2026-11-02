# K84 (Kalli, raw reply captured S148 2026-10-03 via gbot)

Starting K84. I'm opening the sources and checking each URL before I cite it. Anything I can't open will be labelled unverified or left out.
The K84 research is running now. Only pages that were actually opened will be cited. I'll send the sources, the per-game notes, the ten rules and the wireframe when it finishes.
**K84 PART 1 of 2: sources and per-game notes**

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
**K84 PART 2 of 2: panel placement, ten rules, wireframe**

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
