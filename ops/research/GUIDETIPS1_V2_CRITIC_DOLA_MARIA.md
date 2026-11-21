# GUIDETIPS1_V2_CRITIC_DOLA_MARIA - Maria answer (seat queue SQ266)

Brief: research/GUIDETIPS1_V2_CRITIC_DOLA.md
Sent: 2026-11-21 01:40 | collected: 2026-11-21 01:57 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

**GUIDETIPS1 draft 2: TOOLTIPS 7, GUIDE 7, BUILDABLE 6.** It clears the 7 bar on both scored lines, but only just. The tooltip rules are right. One of the three worked examples is now factually wrong, and the button example is wrong too. The lesson table misses fight night and the game plan, which are the two things the game is about. And the standard leans on several code facts the excerpts can't support.

**TOOLTIPS 7/10**
- **The four-question card (what, now, what moves it, your move) is the right core.** It's what made Crusader Kings 3 and Victoria 3 tooltips praised: "why is it this value" with the sum behind it, plus a way to act. "Your move, or cut it" is the owner's actionable-information rule turned into a test, and that's the best line on the page.
- **The SHORT card fixes draft 1's overkill.** Splitting cards by "can the player move this?" is a clean test.
- **The limits are mostly right:**
  - 330 px is right (Slay the Spire and Factorio cards sit around that width at 1080p).
  - Two levels is right (Old World's warning is real).
  - At most two underlined words is right.
  - 20 words on a SHORT card is right.
- **The 45-word ceiling is high for a hover.** The three worked examples come to 30–40 words plus rows, and that already reads long. A 35-word ceiling would still fit every example.
- **Missing: a rule for the Largest text size.** At Largest, a 330 px column wraps into a tower. The column should grow with text size (330 at Medium, about 420 at Largest), or the word ceiling should drop.
- **YOUR MOVE often repeats MOVES IT.** In the tiredness card, "Fights and hard sessions raise it" followed by "Give a rest day" is fine. But the rule should say YOUR MOVE must name a page or button, which the mastery example doesn't.
- **The lock and pin go untaught.** Tips.gd's lock, Shift-pin and Esc close are the praised Crusader Kings 3 behaviour, but no lesson teaches them. A player who never learns the card can be held never reaches the sticky notes.

**GUIDE 7/10**
- **Explore first, help on asking, lessons that fire on events and tick themselves off.** That's RimWorld's learning helper plus Civilization V's "teach the tech tree when you open it", and it's the right model for this game. "Ask the trainer" with replay and "bring back every dismissed lesson" matches Crusader Kings 3's rework.
- **Priority rules (blocking job first, at most one lesson per page visit and per day) are good,** and stricter than Anno 1800, whose pop-ups were hated.
- **Compared honestly with the best:**
  - Factorio's tips-and-tricks panel replays a short clip with every tip. This standard has MoveTip loops for moves but none for lessons.
  - Two Point Hospital paces one new system per level. This guide has no pacing past week 1 beyond "when it happens".
  - Plants vs. Zombies teaches by changing the playfield itself. Here the first week still runs as a checklist.
- **The lesson table misses the core.** There are no lessons for:
  - the game plan (writing a line, Beats it / Works / Walks into it), which is the game's star;
  - fight night (the shout bar, best / ok / wrong calls, the corner minute, NOW!);
  - the Why;
  - accepting an offer and weighing in;
  - the goal talk;
  - the Monday review;
  - runway and money.
  
  A player could finish the guide without being told how the corner works. Since the rules forbid a lesson while a fight is on screen, fight-night lessons must sit on the tale-of-the-tape screen and the corner minute card, which are both pauses.
- **The 20-second soft pulse is a reasonable first guess.** Plants vs. Zombies hints after a mistake, not a wait. I'd tie it to the player opening and leaving the right page twice without acting, with 20 seconds as the fallback.
- **A page lesson ticks itself off when the page is left.** That's wrong: leaving a page isn't learning it. Mark it learned on the page's first real action.

**BUILDABLE 6/10**
- The plan fits the code it shows: a helper over Tips.gd, Glossary growing to about 35 words, a red-first test, and a lessons table saved on the career.
- **What the test can and can't catch:**
  - **It can catch:** plain `tooltip_text`, label repeats, short or long lines, three numbers in a sentence, names (from a roster and opponent list), too many underlines, notes with links, pixel width, and numbers with no card.
  - **It can't catch:**
    - whether WHAT actually explains, which the owner's exact complaint was about ("Cost a week" passes the word count);
    - paraphrased repeats ("Pay a week" on a tile reading "Weekly wage");
    - a wrong fact (the 50/50 example below would pass).
  - So "has no WHAT" can only be checked if the helper requires a `what` field. Say so, and add a human check: one still of three cards per screen, already in step 4.
- **"A visible number with no card" needs a definition.** Digits in a Label, minus dates, clock times and a named exempt list. Without it the test is either noisy or toothless.
- **Fight night isn't walked** (the corner, the result screens), though the shout bar and corner are where tooltips matter most. And "nothing in fight3d" means the dark fight-night cards need their own look rule.

**CODE CHECK: statements the excerpts contradict or can't support**
1. **"Wraps at 330 px"** (sections 0.3 and 2c, "Tips.gd does this today"). The Tips.gd header says nothing about 330 px or wrapping. Not supported.
2. **"Opens after 0.3 s (today's setting)."** The header names LOCK_S and NOTE_DELAY, but no 0.3 s open delay. Not supported.
3. **"Every page dims at once"** (3a, Today). GuideLight dims only when the target is on the open page, at 38%, never over a pop-up. Overstated.
4. **"The first week's four jobs ... in any order"** is presented as a small change. Today FirstWeek's sign, coach, week and go block Continue in that order. It's a real change to FirstWeek, and the plan should list it.
5. **COACH'S PAY: "With no coach, the sessions you cannot take run at 60%."** Today with no coach, all training runs at 60%. The head coach rates nothing, and coached mornings aren't wired. The phrase invents a split the code doesn't have.
6. **"Real cost −$100 a week."** The classes' +$350 is in the pack, but "Buys a coach for every session" is true only of the one coach the game has today. Fine as written, but the card must read the hired coach's real wage ($450 or $1,090), not type it.
7. **Mastery "Learning under 30".** The code ladder (`MoveMastery.LADDER`) says Learning, but the pack and Tips use Raw (New, Raw, Usable, Sharp, Signature). That's two words for one concept, so pick one in code and Glossary.
8. **The tiredness bands drop OK (50–70) and OVERCOOKED (from 80)**, the code's own words in WhiteboardKit. The card says "fresh" and "Tired from 70" but never names the 80 band. Use the code's band words, read from the constants.
9. **"Clock.next_stop" and "Needs.go_state"** don't appear in the excerpts. Not supported.
10. **"The towel line" (2b keys, and the 3c lesson "The towel" on Fight prep).** No towel exists in the pack or the excerpts. The stop-or-go card is AGREED, NOT BUILT, and for fight night, not Fight prep. Cut the lesson until it's built.
11. **"Pick a light fight week" / "fight week picked" (3c).** Today the fight week is the code's automatic TAPER (`WeekPhase`). Nothing in the excerpts lets the player pick it.
12. **"Camp: the first bout that needs one (pro, title, nationals)."** `Bouts.camp_due`'s rule isn't shown. The excerpts only say amateur bouts get no camp (S428). The nationals case is unsupported.
13. **"MOVE card ... on her own body" (2a) and "a line he must not cross" (2b)** are fixed pronouns in the standard itself, breaking S412.
14. **The button rewrite "split between attack and defence" is wrong.** The 50/50 → 70/30 → 30/70 pill splits a pad night's minutes between its two drill cards (pack 4.2). The example would teach a false rule.
15. **"Glossary grows ... fatigue renamed Tiredness."** That's right, but the Glossary's `def` still says "by night", and the week board's word is set elsewhere (WhiteboardKit). The rename touches more than Glossary.gd.

**Research claims, wrong or overstated**
- **The Civilization V quote is credited to Soren Johnson.** Johnson was lead designer on Civilization III and IV and had left Firaxis before Civilization V. The Game Developer piece may quote him on tutorials in general, but crediting him with Civ V's tutorial design is very likely wrong. Re-read the article and credit the author correctly.
- **"Hades: no tutorial at the start" is overstated.** The first run has on-screen prompts and in-world teaching from the first room, and the training dummy in the House is reached after the first death. "Light, in-world tutorial" is fairer.
- **"Dota 2 (2022): plain card, hold a key for numbers" is dated too late.** Alt-for-details has been in Dota 2 for years. Mark it SUMMARY and drop the year.
- **FM26 "almost no tooltips" and Civilization VII 1.2.5** are both PRIOR and unverified this session. They shouldn't carry weight until re-read.
- **Correct as far as I know:** George Fan's "eight words on screen", Portal's one idea per room, RimWorld's learning helper replacing pop-ups, and Into the Breach's clarity-over-cool-ideas line. "Crusader Kings 3's 67 boxes" I can't confirm either way.

**The three worked examples: would the owner's questions be answered?**
- **Coach's pay:** yes, mostly. "Cost a week to do what" is answered by WHAT and the real-cost row. But the 60% line is wrong (CODE CHECK 5) and there's no YOUR MOVE. Rewrite:
  > **Coach's pay**
  > Buys a coach for every training session and the evening classes.
  > Pay −$450 a week · Classes +$350 a week · **Real cost −$100 a week**
  > With no coach, all training counts 60% and no classes run.
  > *Compare coaches on Club > People.*
- **Tiredness:** yes. Use the code's band words. Rewrite:
  > **Tiredness 38 of 100: fresh**
  > How worn your boxer is. Worn boxers train worse and get hurt more.
  > Fresh under 50 · OK 50–69 · Tired 70–79 · **Overcooked 80+: next morning counts 60%**
  > Fights and hard sessions raise it. A full rest day takes off about an eighth.
  > *Put a rest day in the week before 80.*
- **Mastery:** nearly. "The flag" is a new word nobody has taught, and "Light strip / dashed box" explains the drawing, not the game. Rewrite:
  > **Mastery 24 → 27: Raw**
  > How well your boxer owns this move. Under 30 it isn't thrown in a fight.
  > **Usable 30** · Sharp 60 · Signature 85
  > Each pad night on this move adds about 3.
  > *Keep it on tonight's pad card to reach 30 by Friday.*
  
  "Raw" or "Learning" should be whichever word code and Glossary settle on. "About 3" should be read from the forecast.
- **The button example:** "Splits tonight's pad time between its two moves. Now 50/50."

**Trainer lines, rewritten (11 words or fewer, no names)**
- **Clock 1:** "Continue runs the days one by one to the next stop." (11)
- **Clock 3:** "We stop on Mondays, bill days, weigh-ins, fights and offers." (10)
- **Tiredness:** "Your boxer is tiring. Past 80, training counts far less." (9)
- **Mastery bar:** "That bar is the move. At 30 it gets thrown." (10)
- **Fight week:** "Amateur bout: no camp. The last week runs light by itself." (10)
- **The towel:** cut until built.
- **New, the game plan:** "Write one line the opponent can't answer. That's the plan." (10)
- **New, the first fight's tale of the tape:** "Every thirty seconds you get one shout. Pick it well." (10)
- **New, the first corner minute:** "One change, three points of recovery. Spend them where it hurts." (11)
- **New, the first Why:** "This is why it went that way. Read the plan line." (11)
- **New, the tooltip pin:** "Rest on a card to hold it. Shift pins it." (9)

**The refused points: are the refusals right?**
- **"Show less / more" in a card:** right to refuse. The sticky note is the second level.
- **Dropping the 45-word ceiling:** right to keep a number. I'd lower it to 35 (see above).
- **Dola's tiredness bands:** right to refuse, because they don't match the code. But the standard's own card also drops the code's band words (CODE CHECK 8).
- **"Training −40%":** right. "Counts 60%" is the game's word.
- **The shorter trainer lines:** right. "One by one" and "next stop" are what the owner asked for.
- **The "overstated claims not in the page":** I can't check Dola's list. The page as it stands still has the Civilization V and Hades overstatements above.
- **Performance:** right. One card at a time is fine.

**Missing, and useless**
- **Missing:**
  - lessons for the game plan, fight night, the corner minute, the Why, the offer, weigh-in, the goal talk, the Monday review and runway;
  - a lesson for the card lock and pin;
  - a text-size rule for the 330 px column;
  - a definition of "a visible number" for the test;
  - fight-night cards (dark look) in scope;
  - a rule that YOUR MOVE names a page or button.
- **Useless or premature:** the towel lesson; "pick a light fight week"; and the "Each page" lesson ticking off on leaving.

**To reach 10/10**
1. **Fix the examples' facts:** the 60% line, the band words, the Raw/Learning word, the 50/50 button. Then add a review step: every worked example and every Glossary note is checked against the named constant by Claude before it ships.
2. **Add the missing lessons:** game plan, tale of the tape, corner minute, the Why, offer, weigh-in, goal talk, Monday review, runway, and the card pin. Place fight lessons only on pause screens.
3. **Cut or rewrite every claim the CODE CHECK flags:** 330 px and 0.3 s (add them to Tips.gd as constants, or say they're new), the towel, fight-week picking, camp_due, next_stop.
4. **Make WHAT testable:** the helper refuses to build a card without `what`. The test also fails a WHAT that shares 60% of its words with the label or the tile text.
5. **Define a "visible number"** for the test (digits in a Label, minus dates, times and a named exempt list), and walk fight night and the result screen too.
6. **Lower the FULL card ceiling to 35 words.** Scale the 330 px column with text size.
7. **Mark a page lesson learned on its first real action,** not on leaving. Tie the soft pulse to two visits without acting, with 20 seconds as the fallback.
8. **Fix the research table:** credit the Civilization V quote correctly, soften Hades, drop Dota's year, re-read the PRIOR items or mark them as not counting.
9. **Remove the fixed pronouns** in 2a and 2b, and run the name and pronoun test on the standard itself.
10. **Give each lesson in "Ask the trainer" a 3-second loop or a still,** like Factorio's tips panel. The game already bakes move clips, and the same pipeline can record UI.

**The 10/10 page (1920×1080, the Training board with one card and the trainer's corner)**
- **Background:** the fighter's Week page on the Look B whiteboard, untouched and not dimmed.
- **Top bar:** dark, with CONTINUE (the only green) reading "to Mon 9 Feb, the week review".
- **The tooltip card, beside a mastery bar on Wednesday's pad card (never over it):**
  - a cream index card, 360 px wide, about 200 px tall, with a small magnet at the top filling to show the lock;
  - title in the title colour, "Mastery 24 → 27: Raw";
  - one plain WHAT line;
  - a row strip, "**Usable 30** · Sharp 60 · Signature 85", with Usable bold;
  - one quiet line, "Each pad night on this move adds about 3";
  - YOUR MOVE in the title colour, "Keep it on tonight's pad card to reach 30 by Friday";
  - "Usable" underlined in dashed red, with its yellow sticky note open beside the card on the far side: "Usable: a move at 30+. It gets thrown on fight night. Why: under 30 the corner can't call it." The note itself has no links;
  - tiny grey key hints at the foot, "Shift: pin · Esc: close".
- **The trainer's corner, bottom-left (about 420×180):**
  - a stylised comic portrait of the old trainer;
  - a cream speech bubble, "That bar is the move. At 30 it gets thrown.";
  - three small buttons: SHOW ME (red), ? (opens Ask the trainer), MORE (opens the same Usable note);
  - under the bubble, the week-1 job list with ticks in words: "Sign ✓ · Coach ✓ · Week · Continue";
  - "Skip the guide" in small text.
- **No dim and no ring on the page,** because SHOW ME hasn't been pressed.
