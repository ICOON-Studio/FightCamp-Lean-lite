# TASK GUIDETIPSCRITIC1A - judge the tooltip and guide standard (GUIDETIPS1), fresh critic

Kind: research
Status: OPEN (S532, written by the GUIDETIPS1 Fable session; a normal session with a browser launches it). Discipline:
boxing. Model: Arena (cloud). Work on FightCamp-Lean-lite main, your own arena/ branch, a PR into main there; never merge.
RESEARCH ONLY - no game code changes. Do not run Godot.

## Your job
You are a fresh, independent critic: a UX designer who has shipped management games. Read the whole brief
`ops/research/GUIDETIPS1_V2_CRITIC_DOLA.md` (draft 2 of the standard) (the scoring questions, the critic pack, code excerpts, then the standard at the
end) and do exactly what it asks: score TOOLTIPS, GUIDE and BUILDABLE out of 10 with reasons, say what is missing or
useless, rewrite the worked examples and trainer lines you can improve, and end with "To reach 10/10" - the concrete
changes, most important first, each specific enough to build - and your 10/10 as a 1920x1080 HTML page.
CODE CHECK (required, from the real files, not the excerpts): open scripts/ui/Tips.gd, scripts/ui/TipMeter.gd,
scripts/rules/Glossary.gd, scripts/ui/MoveTip.gd, scripts/ui/GuideLight.gd, scripts/rules/GuideLines.gd,
scripts/ui/FirstWeekStrip.gd, scripts/rules/FirstWeek.gd, scripts/rules/FirstHour.gd, scripts/state/Clock.gd,
scripts/ui/Shell.gd (lines 145-185), scripts/ui/StaffCard.gd (the CoachTiles), scripts/ui/DarkOverview.gd (the tiredness
row), scripts/ui/TrainBits.gd (bar_tip), scripts/ui/WhiteboardKit.gd (fatigue_word). For every statement the standard makes
about today's code (counts, file sizes, what a component does, the numbers in the worked examples 2f, the clock in 3d) say
whether the code really does that; list each wrong one. Then say whether the build plan (section 5) is workable: can the
test in step 3 find every tooltip on a screen, what would it miss, and is one helper on top of Tips.gd the right shape.
Count for yourself: `grep -rc "tooltip_text" scripts` and `grep -rl "Tips.card(" scripts`.
Do NOT read any other critic's answer (no file named GUIDETIPS1_*CRITIC_DOLA_DOLA.md or *_ARENA.md; section 7 of the standard summarises the first critic - judge its refusals yourself) before writing. Say which
code files you read.

## Deliverable
ONE new file `ops/research/GUIDETIPS1_CRITIC_ARENA.md` (the scores on their own line:
`SCORE tooltips=<n> guide=<n> buildable=<n>`), and optionally `docs/mockups/s532/guidetips1_10_arena.html`. A PR that adds
only those files.

## Contract
OWNS: ops/research/GUIDETIPS1_CRITIC_ARENA.md, docs/mockups/s532/guidetips1_10_arena.html
RED_TEST: none (research)
REGRESSION: none
VISUAL: no

## Prior research
CRITIC_PACK.md (inside the brief); J52_TOOLTIPS_AND_TUTORIAL.md, J90_TOOLTIPS_PRAISED.md, K84_TUTORIAL_GUIDE_PANEL_PLACEMENT.md.
## What would a human do?
A UX lead reads the rules, then tries to write five real tooltips with them and sees where the rules fail.
## Prefab check
None (a design review).
