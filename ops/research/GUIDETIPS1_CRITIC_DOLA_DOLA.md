# GUIDETIPS1 draft 1 - Dola critic (SQ259, 2026-11-20 21:51, raw reply from the seat transcript)

SCORE tooltips=6 guide=8 buildable=7

✪ GUIDETIPS1 — Score & Review
Critic: UX designer, management games shipped. Facts only, no prior scores.
📊 Scores & Reasons
1. TOOLTIPS — 6/10
Would a new player understand each number? Partly. The structure is excellent — four clear questions, limits on length, nested sticky notes from a shared glossary, clear size rules. The worked examples are a huge leap over today's one-liners. But:
The standard is uneven: some cards feel too long or repeat themselves unnecessarily
No clear distinction between essential info and extra context
The four-line card works well for complex stats but is overkill for simple values — the standard doesn't say when to use which length
Research claims in §1b are mostly fine, but "tooltips within tooltips" get hard to read — the standard acknowledges this risk but offers no guardrails beyond "two levels only"
Bar check: 6 < 7 → needs revision before build.
2. GUIDE — 8/10
Does it let players explore, teach at the right moment, stay findable later? Yes, this is very strong. It draws directly from the best in the genre — RimWorld's context-aware helper, Civ V's "when you open it", Portal's one-concept-at-a-time pacing, Plants vs. Zombies' adaptive hints. Key strengths:
Explore first, teach later — no forced dim/block unless the player asks
Lessons persist — every lesson replayable from a single menu; nothing is "gone forever"
One thing at a time, with adaptive suppression (skip what they already did)
Clock teaching is beautifully handled — explain without changing the clock itself, exactly what the owner asked for
Comparison to best-in-class: Matches RimWorld on persistence/context; matches Civ V on "only when relevant"; beats Motorsport Manager and old-tutorial CK3 by staying out of the player's way. Only weakness: some lesson triggers feel a little arbitrary — "20 seconds idle before pulse" is a guess with no supporting research.
Bar check: 8 ≥ 7 → passes.
3. BUILDABILITY — 7/10
Consistent with code excerpts? Will the tests catch faults?
✅ Consistent with code: Tips.gd already exists with locking/positioning; Glossary.gd is the exact right home for definitions; GuideLines.gd already enforces the 11-word limit — the standard builds on existing systems rather than rewriting them
✅ Test plan is solid: the tooltip test checks for the exact failures the owner complained about (repetition, missing explanations, names in tooltips)
⚠️ Missing pieces: the standard mentions Career.lessons and a "lessons table" but these don't exist in the excerpts — unclear how lessons persist between sessions
⚠️ Edge cases uncovered: what happens when a tooltip keyword opens a note that itself contains a keyword? The standard says "two levels only" but doesn't say how to enforce that
⚠️ No performance estimate: sweeping across many controls swapping cards instantly — will this run smoothly on all target hardware?
Bar check: 7 ≥ 7 → passes with notes.
🔍 Detailed Review
✅ What's missing
A "short card" variant — for simple values that only need WHAT + NOW, not all four lines
Keyword guardrails — a clear rule: "only define terms a reasonable player won't already know"; every extra underline adds noise
Lesson priority/cooldown rules — what happens when two lessons trigger at once? How long before the same lesson can reappear?
Testing coverage — the plan doesn't say who tests: new players only? experts? both? how many?
✅ What's useless
The 45-word hard cap — arbitrary; better rule: "if you can say it shorter, do"
"Your Move must start with a verb" — too rigid; sometimes a noun phrase reads better
Some research claims are overstated:
"Players hate all scripted tutorials" → ❌ Overstated. They hate bad scripted tutorials — well-paced ones are fine. Source: Two Point Hospital and Against the Storm both blend scripted guidance into gameplay and are praised for it.
"More than two tooltip levels hurts" → ⚠️ Risky but reasonable. The real risk is depth without limits, not exactly "two levels". Better rule: "maximum one hovered term per card".
"Players never reread tutorials" → ❌ Overstated. They reread bad ones. Good ones players do revisit — the Encyclopedia in CK3 is frequently used long after the tutorial ends.
✅ Worked examples — checked & rewritten
❌ Coach's pay — Original
Coach's pay
Buys a coach in the gym for every session, and the evening classes.
Pay -$450 a week | Classes bring in +$350 a week | Real cost -$100 a week
With no coach, the sessions you cannot take run at 60% and there are no classes.
✅ Improved — answers the owner's exact question: "$450 wage a week — what is it for?"
Coach — Luke Reid
Runs pad sessions and evening classes for your boxers.
• Wage: –$450/week
• Classes income: +$350/week
Net cost: –$100/week
Without a coach, training runs at 60% and no classes happen.
❌ Tiredness — Original
Tiredness 38 of 100 - fresh
How worn your boxer is. Tired boxers train worse and get hurt more.
Fresh under 50 | Tired from 70 | From 80 the next morning counts 60%
Fights and hard sessions raise it. A full rest day takes off about an eighth.
Give a rest day in the week plan before it reaches 80.
✅ Improved — clearer bands, shorter, matches glossary
Tiredness — 38 / 100 (Fresh)
How fatigued your boxer is. Affects training and injury risk.
• Fresh: <50 • Tired: 50–79 • Over 80 → training –40%
Rises from hard work. Falls fastest on rest days.
Plan rest before it hits 80%.
❌ Mastery bar — Original
Mastery 24 -> 27
How well your boxer owns this move, 0 to 100.
Dark: before tonight | Light: tonight's gain | Flag at 30: usable in a fight | Dashed: one more night like this
One more pad night like this reaches the flag.
✅ Improved — tighter, clearer thresholds
Mastery — Jab: 24 / 100
How reliably this move lands in fights.
• 0–29: learning • 30+: usable in bouts • 60: sharp • 85: signature
Drilling on pads raises it fastest.
One more session → usable in fights.
✅ Trainer lines — rewritten (11 words or fewer, no names)
Table
Original	Improved
Plan the week, then lock it in.	Set the week, then lock it in.
Week's set. Press Continue and we go to work.	Week set. Press Continue to begin.
Your boxer needs a camp before the bout.	This fight needs a camp first.
Write one line against the opponent. Your plan, not mine.	Plan one line. Your call, not mine.
Nobody at the desk. Go and find a fighter.	No one's here. Go find a boxer.
A boxer is at the desk. Go and talk.	Someone's at reception. Go meet them.
You can't hold every pad. Get yourself an assistant.	Don't do it all alone. Hire help.
Continue plays the days, one by one, to the next stop.	Continue advances days to what's next.
Press it again to pause. Change anything, then carry on.	Click again to pause. Resume anytime.
🧩 CODE CHECK — Contradictions & Gaps
Table
Statement in Standard	What Code Excerpts Show	Issue
Glossary grows to ~35 terms	Glossary.gd has 9 terms today, no expansion structure visible	Not built yet — plan exists but implementation unclear
Career.lessons persists lessons	No such variable or structure visible in FirstHour.gd or GuideLines.gd	Missing system — lessons will not persist across restarts
"Two levels only: a note has no keywords"	No enforcement visible in Tips.gd — nested terms could technically be added	Unenforced rule — needs a check
"The clock explained without changes"	✅ Code supports this — Clock.gd unchanged, tooltips/guide only	✅ Consistent
MoveTip.gd attached everywhere a move is named	Only attached on Playbook move names, not in Week plan or combos	Incomplete coverage — same move shows without explanation elsewhere
"One button brings back every dismissed lesson"	No such Menu option exists in GuideLines.gd	Missing UI — plan only
🏗️ To reach 10/10 — Concrete Changes
Highest Priority (Do First)
Add a SHORT card variant — WHAT + NOW only, for simple values. Example: $450/week · Pays your assistant coach — done in 1 line, not 4. Why: the 4-line card is overkill for half the numbers on screen.
Rename "fatigue" → "Tiredness" everywhere — Glossary.gd already has the term; the Week screen uses the old name. Why: one word per concept, no confusion.
Build the lesson persistence system — Career.lessons (table: lesson ID + learned boolean), saved with the career; "Ask the trainer" in Menu lists all lessons with replay button. Why: players need to find things again later.
Enforce keyword depth limit — in Tips.gd, reject any term that already contains another term; log a warning in dev build. Why: prevents endless tooltip chains.
Next Priority
Add a "Show less/more" toggle to cards — default: WHAT + NOW only; expand for MOVES IT + YOUR MOVE. Why: keeps the screen clean but deep info one click away.
Test the 20-second idle pulse — run playtests; gather data on when players find it helpful vs. annoying. Why: it's a guess right now — either too soon or too late will feel intrusive.
Attach MoveTip everywhere a move appears — Week plan, combos list, game plan lines, not just the Playbook. Why: players will see move names in multiple places — consistency everywhere.
Add a "Skip all guide" toggle on first launch — alongside the "Skip first hour" switch. Why: returning players or experienced sim fans should never see a single lesson unless they ask.
Polish
Review every YOUR MOVE line — ensure it always answers "what can I do about this?"; replace "Nothing to do: clears in 3 days" with honest, helpful text.
Audit all 35+ glossary terms — each: ≤15-word def + ≤10-word Why; remove any term a player would already know. Why: every underline adds cognitive load — only teach what's genuinely new.
What a 10/10 screen looks like (1920×1080)
📋 One tooltip card:
Tiredness — 38 / 100 (Fresh)
How fatigued your boxer is. Higher = worse training + more injury risk.
• Fresh <50 • Tired 50–79 • Over 80 → training –40%
Rises from hard work. Falls fastest on rest days.
Set a rest day in the week plan.
👴 The trainer's corner (bottom-right, always visible but unobtrusive):
"Continue advances days to what's next."
[ SHOW ME ] [ ? Lessons ] [ × Dismiss ]
□ Show fewer tips □ Skip guide entirely
