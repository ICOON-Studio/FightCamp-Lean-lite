---
name: feedback_no_exe_until_striking_clips_smooth
description: SUPERSEDED 2026-09-29 (S126, D27) - the demo .exe ships with the boxer's palette restricted to CERTIFIED moves; was "no exe until 36/36 boxing"
metadata:
  type: feedback
---

**SUPERSEDED 2026-09-29 (S126) by the operator working brief, verbatim:** "The demo .exe ships when the boxer's fight
palette is restricted to the CERTIFIED moves only - every move on screen is its own clean clip; the rest join as they pass."
DECISION_LEDGER D27 (D3 marked superseded).

History: S115 (09-27) "do not produce exe or clips until all boxing and kickboxing animation clips are completed and checked
they work smooth and perfect"; narrowed 09-28 to boxing.

**Why:** at 3-5 certified moves a session, 36/36 missed the date. Restricting the palette keeps the original reason - the
operator never sees a borrowed or wrong clip.
**How to apply:** the engine may throw only C223-certified boxing moves in the demo; an uncertified move joins the palette
the day it passes. `build_playable.py` is allowed once the restriction is in and tested. Still no borrowed clip on screen.
Related: [[project_demo_deadline_2026-10-04]], [[feedback_working_brief_2026-09-29]].
