# S149 digest - U215 merged, LADDER1 launched, office v2 verdict (Claude, 2026-10-03)

Nightly read: 2026-10-02 at 86c8150f, 496 tests, 19 fail (AgentComms/nightly/latest.txt).

## What now works
- U215 (Cline 5cf6c5da -> master da105db8): Scouting lists the gym's own sport first on both tabs. It now asks
  the gym (`get_gym().primary_discipline`) instead of reading the board hint, which only appears when
  `career.scout_own_discipline_first` is set. After a signing, the top bar's cash and roster line repaint in place
  (`ShellChrome.refresh_top`). Evidence: `scouting_own_sport_topbar_test` fails 5 on the old code, 0 now (Cline
  transcript); after the merge I ran parse 3/3 and `run_tests --only scouting,first_job,ui_kit_shell,week_review,smoke_test --jobs 2` = 7/7.
- Gate defect fixed at the source: my U215 brief listed its owned files in prose and `check_workflow` could not read
  them (control 6). The brief now lists them as bullets. The gate was not touched.

## Operator verdicts (verbatim)
- Office v2: "office v2 is kind of ok the ropes of the ring should be covering the boxer inside".
- On Dola's redraw (doubled corner pads): "nope".
- Asked: "what other free platforms or ais can do the generation ? do you use text to video ?" Answered: image-to-video
  only (text-to-video can't match the painted still); candidate list given, marked as uncertain; J60 sent to John.

## Findings
- `ring_full_00.png` has NO near-side ropes, so the boxer stands at an open edge. The office composite also shows
  the still's own ring under the video: a doubled apron and a doubled left corner (office frame x940-1450, y380-640).
- Two Dola edits failed: the first moved the camera and doubled the pads, the second returned the original
  unchanged. Generator route stopped for this fix. The deterministic composite plan is in the ROOMS25D queue row.
- `cinemagraph.py` arguments for office_ring_living were never recorded. Record them in PIPELINE.md next time.

## Running at handover
LADDER1 on Cline (01:09), Q213D on Codex (00:55, wt Q213C), MH2 on Codex (C223 production gate), J60 on John (gbot).

## Next (decision)
Collect LADDER1, Q213C+Q213D, MH2, J60 -> build SCHED1 -> TUT1 -> rope fix on the first free seat.
