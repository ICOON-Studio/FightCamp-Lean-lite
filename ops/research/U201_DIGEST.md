# U201 digest — GF1 part A: card, skill tree, home tooltips

## Shipped
- Glossary terms for fight stats (power, speed, defense, grappling, takedown defence, top control), attribute marks, quiet week, and home-card status lines.
- Profile overview: every attribute row, discipline proficiency bar, growth/moves captions, and the BASE legend tip use `UIKit.tip` + Handbook ids; grade scale matches `_grade` (A 85+, B 70+, C 55+, D 40+, E below).
- Skills & Moves: proficiency strip scale tip; each LOCKED tree node’s hit target explains catalogue `requires` (proficiency, attributes, prerequisites, reps, weeks).
- Home card: fighter status line tipped; coach “Quiet week” lines tipped (`CoachVoice` fatigue &lt; 50). Body Condition tip unchanged (S133).

## Evidence
- `tests/gf1_card_skills_tips_test.gd` green; focused `run_tests.py` slice green; career-walk stills under `previews/u201/`.

## Notes
- Stat “why” lines follow `FightRealtime.gd` / `GrappleResolve.gd` usage; `StatWords.gd` glosses were cross-checked.
- No edits to Q219-owned screens or `GameState.gd`.
