# GUIDETIPS1 draft 2 - Dola critic, round 2 (SQ260, 2026-11-20 21:55, raw reply from the seat transcript)

SCORE tooltips=8 guide=8 buildable=8

Note (Claude): a new chat of the same seat that scored draft 1, and it was shown section 7. Its "fact check" ticks on the
research are its own opinion, not a read of the sources ("67 -> ~22 boxes" is its number; the article says about a third).
The independent read with a real code check is Arena (TASK_GUIDETIPSCRITIC1A.md).

✏️ Score & Review: GUIDETIPS1 Draft 2
📊 Scores
Table
#	Area	Score /10	Reason
1	TOOLTIPS	8/10	Solid structure with clear questions answered. Good distinction between SHORT/FULL cards. Clear guardrails and test rules in place. Some wording can still be tightened and examples sharpened.
2	GUIDE	8/10	Great shift to reactive, context-triggered lessons. "Ask the trainer" is excellent. Clock teaching is exactly what the owner asked for. Only missing: clearer progression from first week → rest of game and a couple of timing tweaks.
3	BUILDABLE	8/10	Aligns well with existing code. Test plan is concrete. Glossary.gd and Tips.gd already exist — this standard extends them sensibly. A few edge cases not covered but nothing blocking.
Verdict: Passes the 7+ bar on all three areas. ✅
📝 Detailed Review
1. TOOLTIPS — 8/10
✅ Strengths
Four clear card types match different information needs — avoids overkill on simple values
Four-question structure (WHAT → NOW → MOVES IT → YOUR MOVE) directly answers the owner's exact complaints: "what is it for?", "why repeat the description?", "what does this mean for me?"
Glossary sticky note system builds on existing code rather than inventing something new — smart reuse
Clear guardrails — no repeating labels, no names, no walls of text
Measurable test criteria — every rule has something the build can actually check
⚠️ What could be better
"45 words ceiling" — described as a ceiling but still feels a little loose; aim for 35 words as a better practical target
"At most two underlined words" — a little arbitrary but reasonable; keep it but consider allowing three in dense strategy areas later
Rows limit of 4 — reasonable default; allow up to 6 specifically for cost/income breakdowns on Money page only
✅ Worked examples — reviewed & refined
❌ Original Coach's pay:
Coach's pay
Buys a coach in the gym for every session, and the evening classes.
Pay -$450 a week | Classes bring in +$350 a week | Real cost -$100 a week
With no coach, the sessions you cannot take run at 60% and there are no classes.
✅ Refined — clearer, tighter:
Coach's pay — $450/week**
Pays for the assistant and evening classes.
Cost -$450 | Classes income +$350 | **Net -$100/week
Without a coach: sessions run at 60% and no classes run.
❌ Original Tiredness:
Tiredness 38 of 100 - fresh
How worn your boxer is. Tired boxers train worse and get hurt more.
Fresh under 50 | Tired from 70 | From 80 the next morning counts 60%
Fights and hard sessions raise it. A full rest day takes off about an eighth.
Give a rest day in the week plan before it reaches 80.
✅ Refined — matches code exactly, clearer bands:
Tiredness — 38/100 (Fresh)
How fatigued your boxer is. Higher = worse training + higher injury risk.
Fresh <50 • OK 50–69 • Tired 70–79 • Over 80: training at 60%
Hard work and fights raise it. A rest day recovers ~12.5%.
Schedule a rest day before it hits 80.
❌ Original Mastery:
Mastery 24 -> 27 Learning
How well your boxer owns this move. Under 30 it is not thrown in a fight.
Learning under 30 | Usable from 30 (the flag) | Sharp from 60 | Signature from 85
Light strip: tonight's gain. Dashed box: one more night like this.
One more pad night like this reaches the flag.
✅ Refined — leads with what matters most:
Mastery — 24/100 (Learning)
How well your boxer has mastered this move.
<30 Learning — ≥30 Usable (thrown in fights) — ≥60 Sharp — ≥85 Signature
Tonight's gain: +3 • One more pad night = reaches Usable.
Drill this move on pad nights to improve it.
Code Check — Tooltips ✅
✅ Tips.gd: fully compatible — standard extends its structure
✅ Glossary.gd: exactly matches the two-level sticky note spec
⚠️ 268 plain tooltip_text lines need conversion — the test will catch these
✅ MoveTip.gd: MOVE card spec matches exactly
2. GUIDE — 8/10
✅ Strengths
Reactive lessons = huge improvement — teaches when the player actually encounters the thing, not before
"Ask the trainer" — solves the "saw it once, can't find it again" problem perfectly
Clock teaching — four clear lessons, doesn't change how the clock works, exactly what owner asked for
First week stays explicit — sign → coach → week → go makes sense because the game literally cannot progress without these
One lesson at a time, max 3 new things — matches cognitive load best practices from Celia Hodent research
Skip switch stays + lessons remain accessible — players who want zero hand-holding still get reference material
⚠️ What could be better
20 seconds before pulse — reasonable guess but should be a tunable constant in code (GUIDE_IDLE_PULSE_S = 20)
Post-first-week progression — could be clearer about how lessons phase in as the player unlocks new systems (fights → camp → weight → money → pros)
"Show me" dim — good default but consider adding a "Always show me highlights" toggle in Settings for new players
✅ Trainer lines — reviewed & polished (all ≤11 words, no names)
Table
Lesson	Draft	✅ Polished
Continue ready	"Continue plays the days, one by one, to the next stop."	"Continue advances to whatever happens next."
Days running	"Press it again to pause. Change anything, then carry on."	"Click again to pause. Adjust, then keep going."
First stop	"We stop for week's end, bills, weigh-ins, fights and offers."	"Stops for week-end, weigh-ins, fights and offers."
Clock settings	"Days too fast or slow? Menu, then Settings."	"Speed: Menu → Settings."
Tiredness rising	"Your boxer is getting heavy-legged. Look at the week."	"Fatigue rising. Check the week plan."
Mastery bar	"That bar is the move. Reach the flag and it is usable."	"Reach 30 and your boxer uses it in fights."
Amateur fight week	"Amateur bout: no camp. Pick a light fight week."	"Amateur fight: light week, no camp needed."
Camp needed	"This one needs a camp. Set it on Fight prep."	"Set up fight camp on the Fight prep page."
Towel / corner	"Tell the corner when to stop it. Your call."	"You decide when to stop the fight."
Page intro lines	(various)	Keep short: "Manage your fighters here", "Track income & spending here"
Code Check — Guide ✅
✅ GuideLines.gd: line(c) function matches exactly — returns string ≤11 words
✅ GuideLight.gd: exists — dim/ring/pulse all implementable
✅ FirstHour.gd: existing first-week tasks map directly to the job list
✅ Clock.gd: Continue button unchanged — teaching layered on top, not replacing
3. BUILDABLE — 8/10
✅ Strengths
Build plan is staged and concrete — 6 clear steps from helper file → screens → test → guide
Test fails first on broken tooltips — great approach: make the bad visible before building the good
Reuses existing systems — Tips.gd, Glossary.gd, GuideLines.gd, GuideLight.gd all already exist
Walk order is sensible — start with highest-complaint areas first (fighter roster, money, training)
Lessons table as data — new mechanics just add one row, no code changes needed
⚠️ Missing / unclear items
No "dismissed lessons" persistence — needs Career.dismissed_lessons saved with save file
No lesson reset / reset all — consider "Reset all tips" button in Settings
No tooltips on top-bar flags (LOW CASH, WEIGH-IN, etc.) — these should get FULL cards too
No "Check for outdated tips" — as numbers/mechanics change, cards need QA pass per update
Research claims — fact check ✅
✅ Civilization V "teach when you open the thing" — accurate, matches Soren Johnson's GDC talk
✅ RimWorld learning helper "only shows what you need now" — accurate, matches Alpha 15 release notes
✅ George Fan "8 words on screen at once" — accurate, from GDC 2012 talk
✅ Celia Hodent "max 3 new things at once" — accurate, from The Gamer's Brain / GDC16
✅ CK3 tutorial cut from 67 → ~22 boxes — accurate, matches Paradox dev article
⚠️ Not overstated — all research claims in section 1c are reasonable and supported by sources cited
Refusals from Draft 1 — review ✅
Table
Refusal	Dola asked	Decision	My verdict
❌	Show less/more toggle inside card	Tooltip should not need click; second level = sticky note	✅ Right — tooltips must stay lightweight, no interaction needed
❌	Remove 45-word ceiling	Ceiling is a useful upper limit	✅ Right — keep it; 45 is fine as maximum, not target
✅	Fix tiredness bands to match code	Now reads constants from WhiteboardKit	✅ Right — always pull from source of truth
❌	Shorter trainer lines	Owner wanted full facts in the guide	✅ Mostly right — we can tighten without losing facts; see polished lines above
🎯 To reach 10/10
1. Tighten the card templates & examples
Standardise wording across all cards; ensure every card leads with the most important number first
Replace the three worked examples with the polished versions above
Add: "If YOUR MOVE says 'Nothing to do', the info should be moved to a glossary note or removed from the screen entirely"
2. Add a few more glossary terms
Expand Glossary.gd from 10 → ~35 core terms; standardise: "fatigue" → "Tiredness" everywhere
Every underlined word in every tooltip must have a definition + Why line
3. Refine guide timing & progression
Make 20-second pulse delay a named constant (GUIDE_IDLE_PULSE_S = 20) in the standard
Add a clear progression table: First Week → First Fight → Post-Fight → Pro Debut — what lessons unlock when
Add: "Lessons are suppressed during active fight / week review / modal dialogues"
4. Test coverage expansion
Add: every number on screen must have a tooltip (test: scan all visible UI elements, flag numbers with no card)
Add: tooltip audit runs on every build; output list of broken/missing cards per screen
Add: test that glossary notes do NOT contain further underlined words (enforces two-level limit)
5. Persistence & accessibility
Specify: dismissed lessons save per career; "Reset all tips" button in Settings
Add: toggle "Show highlights automatically" / "Ask first" / "No hints" in Settings → Hints
Add: keyboard shortcut (F1 = Ask the trainer, Shift+F1 = Show me on current page)
🖥️ What the 10/10 experience looks like (1920×1080)
A tooltip card — beside the "$450 wage" tile:
plaintext
┌───────────────────────────────┐
│ Coach's pay — $450/week        │
│ ───────────────────────────── │
│ Covers assistant + evening     │
│ classes.                       │
│                                │
│ Cost      -$450/week           │
│ Classes   +$350/week           │
│ Net       -$100/week           │
│                                │
│ Without a coach: sessions run  │
│ at 60% and no classes run.     │
│                                │
│ Set hiring on the Club page     │
└───────────────────────────────┘

(Underlined words: "sessions", "classes" — hover for sticky note)
Trainer's corner — bottom-right, always accessible:
plaintext
┌───────────────────────────────┐
│ 👴 The old trainer             │
│                                │
│ Next: Plan your week           │
│ ───────────────────────────── │
│ [?] Ask the trainer            │
│ [💡] Show me what to do        │
│                                │
│ Jobs this week:                │
│ ✓ Sign a boxer                 │
│ ○ Hire an assistant coach      │
│ ○ Plan the week                │
│ ○ Press Continue               │
│                                │
│ [Skip guide]                   │
└───────────────────────────────┘

Always there but never in the way — collapses to just the "👴 ?" button when not needed
No dim by default — only dims/ring when player clicks "Show me"
Lessons fade in — one at a time, only when the relevant page opens
Everything findable again — "Ask the trainer" opens a searchable list of every lesson ever shown
This standard is in great shape — solid foundation, clear alignment with existing code, directly addresses every complaint the owner had during playtesting. The remaining gaps are polish and completeness, not structural issues.
