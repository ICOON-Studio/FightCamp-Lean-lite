# TASK DESIGNFIX1 (S222) - verify and fix the S172 design-review findings 4, 5, 7, 10 on today's game

Model: Goose (cloud, label goose). Repo ICOON-Studio/FightCamp, branch goose/issue-<n> from master. Open a PR, never merge.
No LFS-loading tests. Do not delete or shorten any existing test. GameState.gd / UIKit.gd are huge: grep, never read whole.
Source: research/DEMO_DESIGN_REVIEW_S172.md "The ten findings" (read 4, 5, 7, 10 whole). Written 2026-10-06 - some may be fixed since:
VERIFY EACH ON MASTER FIRST (a failing check), fix only what is still true, and say per finding: still true / already fixed (evidence).

## The four
4. Camp sheet MMA leftovers in a BOXING gym: "THE MAT MECHANIC" (ground game), "ANTI-WRESTLER", a JUDO visiting coach; decimals
   ("+0.03"). Fix: a boxing gym's camp offers boxing options only; effects shown as whole numbers in words.
5. One record, everywhere: amateur vs pro record shown inconsistently. `UIKit.shown_record` / `record_text` (UIKit.gd ~line 216) is the
   rule - find every screen that prints W-L-D without it and route it through it.
7. Result SETTLEMENT shows $0 on eight rows for an amateur bout: show one line ("Amateur bout - no purse") instead of the zero rows.
10. Wording: planner tile REST vs day OFF (pick REST everywhere); week review "Bills $0" beside "monthly bill so far $1,673" (one
    consistent bills line).

## Acceptance - NEW tests/design_review_s172_fixes_test.gd
One section per finding still true, each red on master first (paste it in the PR): (4) the boxing camp option list contains none of
mat/wrestl/judo/grappl ids or labels and no decimal effect text; (5) every record label on profile/offer/result/home for an amateur with
amateur bouts equals record_text(); (7) amateur result settlement = one line, no "$0" rows; (10) no "OFF" label for a rest day, one bills line.
Run the screens' existing tests too (grep camp_, result_, week_review, record). Parse gate python Godot/tools/check_scripts.py <touched .gd>.

## The one trap
MMA careers keep their MMA camp options - the filter is by the gym's ruleset, not a deletion.

## VISUAL GATE (.claude/skills/visual-gate/SKILL.md, screen form - added S223 at collect)
1. The defect must first read RED on master's shipped screen (a still of the screen as the game shows it, `-- as_game`).
2. Stills of the changed screen at 1920x1080 and 1280x720 from the game's own flow (no isolated widget renders).
3. For every still report: overlaps, clipped text, the changed element's position, what the player reads.
4. Do not call it accepted or fixed. Claude opens every still; the operator closes it.
