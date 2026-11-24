# TASK COACHMAP1 - the coaches map as cut: ONE clean page, written from the sources and the code (S548)

Kind: design (a map written from settled sources; no new rule, no number tuned, no run). Model: claude-opus-5-5 or
Arena. Discipline: boxing (demo path). Estimate: 1.5-2 hours.

## Why
Coaches went nine rounds on numbers (`ops/research/DESIGN_COACHDEEP9.md` is v7 with v8 and v9 marks layered on top:
345 lines nobody can read whole). The stop rule ended it (s16), and the owner has now made the last cut:
- Board Q-329, S548, asked "Coach trial week is the wrong buy in 9 of 10 gyms. Cut it, show chemistry on the hire
  card?": **"Cut it, show chemistry"**.
- The falling-out is cut as a decision by v9's stop rule: the gym backs the coach, the player sees one news line
  (`docs/COACHDEEP9_RESULT.md`; 6 of 7 bars after the cut).
The critics (a code-checked critic first, then Kalli and Dola) need ONE page that says what the mechanic IS now.

## METHOD (quote in your first message)
- WRITE FROM THE SOURCES, NOT FROM MEMORY: every rule on the page carries where it comes from - the owner's answer
  (`ops/research/COACH_INTERVIEW_S542.md` number, `ops/research/COACHDEEP_GRILL_S539.md` Q number, board Q-329), the
  measured result (`docs/COACHDEEP9_RESULT.md` table), or the code line (`scripts/...gd` l.N) when it is already in
  the game. A claim about the code that you did not open is not written. Mark every number that is still a guess ESTIMATE.
- NO NEW DESIGN. Where the two cuts leave a hole (a bar that leaned on the trial; a menu row that showed it), say so
  in a section "What the cuts leave open" - do not fill it.
- PLAIN WORDS (owner S545): staff, gym, coach; no jargon; a reader who never saw v1-v9 must follow it.
- THE BAR IS 8 on depth and 8 on play (owner S534). Say honestly, in the last section, which decisions the player
  still makes about coaches after the cuts (the hire, the pairing, the raise, the rival offer, the style push, the
  course) and what each one trades - the critics will score exactly that list.

## What the page holds (`ops/research/DESIGN_COACHMAP1.md`, 150 lines at most)
1. The mechanic in ten lines: what a coach is, what the player decides, what it costs.
2. The rules as they stand after the cuts, one short section each: the coach's ratings and ceilings; the wage rule;
   the hire list (three candidates a month) and the HIRE CARD - which now SHOWS the chemistry word with each boxer
   (bond / fine / clash, reasons on hover) with no trial and no price; pairing on the week plan; chemistry (one-way);
   the moments that are still decisions; the falling-out as a news line; warnings and their fade; loyalty and leaving.
3. What changed against v9, in a table: the rule, v9, now, why (the owner's words or the measured number).
4. The seven bars re-read after both cuts: which are met, which no longer apply (bar 6 was the trial), from
   `docs/COACHDEEP9_RESULT.md` only - no new measurement; say what would have to be re-run and why.
5. One fact from another probe the map must not contradict: in a simmed bout the coach's rating buys nothing
   (`docs/CORNERBASE1_RESULT.md` verdict 4: rating 80 v 35 is +0.4 to +0.7 wins in 100). If the hire card promises
   "the boxers win about X more a season with this coach", say where that X comes from (training, not the corner).
6. EVERY MENU THE MECHANIC APPEARS ON, as a table: the menu, what it shows, what it is wired to, and whether it is
   in the game today (open `scripts/ui/StaffDesk.gd`, `StaffDeskCard.gd`, the hire flow, the week plan, the boxer
   card, the money page; name the file and line, or write "not built").
7. What the cuts leave open. 8. Feedback loops and their caps (carry v9's s13 and s17, minus the trial).
9. The decisions the critics score (see METHOD).

## Not allowed
No change under scripts/, tests/ or tools/. No Godot run. No edit of DESIGN_COACHDEEP9.md (it is the history).

## Feedback loops
None new: this task writes down existing rules and removes one purchase (the trial). Removing the trial removes the
loop "trial -> chemistry known -> better pairing"; chemistry is now known at hiring for free, which makes the hire
decision better informed in every gym - say in section 7 whether that leaves the hire a real choice (v9's bar 1 table).

## Prior research
`ops/research/DESIGN_COACHDEEP9.md`, `docs/COACHDEEP9_RESULT.md`, `ops/research/COACH_INTERVIEW_S542.md`,
`ops/research/COACHDEEP_GRILL_S539.md`, `docs/CORNERBASE1_RESULT.md`. Run
`python ops/Tools/prior_research.py coach hire chemistry wage loyalty` and name what you used.

## What would a human do?
A lead designer handed nine layered revisions and two cuts would rewrite the page from scratch for someone who was
not in the room, and put the list of player decisions last so a reviewer can argue with it.

## Prefab check
None: this is our own design page.

## Contract
OWNS: ops/research/DESIGN_COACHMAP1.md
RED_TEST: none (a document)
REGRESSION: none (no code changes)
VISUAL: none

## Result
`ops/research/DESIGN_COACHMAP1.md` committed on main by pathspec (`git commit -m "..." -- <path>`); do not push; do
not ask questions: decide, and write what you decided at the top of the page under "Decided while writing".
