# D50 - Dola: fresh eyes on the whole result screen (S102 render)

Collected S103 2026-09-27 from Cici chat 'D50 Result Screen' (cici read, raw capture of Dola's reply; tables flattened by the capture).
Claude's disposition is at the end.

Here’s your structured digest, ready for research/D50_DIGEST.md:
D50 Digest — S102 Result Screen Review
Source: s102/result_plans.png | Owner: Dola | Date: 2026-09-27
1. Eye Gaze Order (5-second scan)
Table
Rank	Element	Why it draws attention	Aligns with "did my choices matter?"
1st	MENSAH def. VELA / UNANIMOUS DECISION	Largest text, bold header, immediate result	✅ Right first: who won is foundational
2nd	THE CARDS (round scores)	High-contrast colour bars, numbered rounds, totals	✅ Right second: how each round scored ties directly to choices
3rd	THE READ (MENSAH / VELA stats columns)	Dense numbers, side-by-side comparison	⚠️ Misplaced third: THE PLANS (your choices & execution) should land here
Verdict: The visual priority is result → scores → opponent stats. For "did my choices matter?", it should be result → PLANS → scores. THE PLANS are buried last, which is the core misalignment.
2. Layout: Move THE PLANS left?
Yes — move THE PLANS into the empty space below THE CARDS.
Left column (wide, primary):
Result header → UNANIMOUS DECISION → THE CARDS → THE PLANS (expanded width, easier reading)
Right column (narrower, secondary):
Keep SETTLEMENT (administrative, low-priority)
Keep THE READ (stats/reference)
Keep WHAT THE NIGHT CHANGED (narrative footnote)
Rationale: THE PLANS are player-facing action/reaction — they deserve primary real estate and width. The right column works best for reference/stats/ledger that players scan second, not immediately.
3. One line vs two lines per corner in THE PLANS
One line is tight but readable; it loses context richness — recommend two lines.
Current (1 line):
plaintext
MENSAH · GREAT PLAN
Keep it standing · Stuffed 0 of 2 takedowns
VELA · OK PLAN
Take him down · 2 of 2 takedowns landed

With 2 lines: shows plan rating + intent + outcome clearly — critical for learning/feedback.
What gives way:
Remove the separate CAUSE paragraph block above THE CARDS — its info is redundant with THE CARDS totals and THE READ control numbers. Fold its key bits into a 1-line summary directly below totals instead.
Shrink SETTLEMENT vertically (all zeros here; it’s a placeholder anyway) to free vertical room.
4. Clutter / duplication / fake precision
Table
Issue	Detail	Fix
Duplication	"TIME AT BAND · LONG 12% · MID 23% · POCKET 44% · CLINCH 21%" appears in THE READ — was THE RANGE; label is vestigial, wording unclear	Rename to POSITION TIME % or WHERE FOUGHT; remove "AT BAND" jargon
Redundant narrative	"CAUSE" paragraph repeats totals, control units, unanimous decision — already on cards	Condense to 1 line or remove entirely
Fake precision	Output/min: 7.1 vs 7.3; Connect: 58% vs 48% — 1 decimal place implies precision the simulation may not meaningfully distinguish	Show whole numbers only: 7 / 7; 58 / 48 — cleaner, no false granularity
Vestigial labels	"READ" column header on judge cards = ambiguous; "SWING · FLIP IT AND THE BOUT FLIPS" = too verbose for tight UI	Shorten swing note to SWING — R1 decided the cards
Zero ledger noise	All $0 rows take space	Hide SETTLEMENT entirely until a bout has purse values; show placeholder only when relevant
5. ONE change to ship first
Move THE PLANS into the left column, directly below THE CARDS, at full width.
This single change fixes the priority order: players see result → scores → what I chose & how it worked within their first 5 seconds. Every other polish is secondary — this is the structural fix that makes the screen answer "did my choices matter?" immediately.
