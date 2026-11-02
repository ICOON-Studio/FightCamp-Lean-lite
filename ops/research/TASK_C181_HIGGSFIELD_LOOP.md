# TASK_C181 - Codex owns the Higgsfield loop: still -> check -> clip -> track, under a credit ceiling (Codex, full branch)

Model: gpt-5.6-luna, medium. Owner: codex. Assigned S62, 2026-09-24, on the operator's ruling:
"should codex handle higgsfield" -> yes, with a ceiling; and "make sure codex knows of your
previous prompts and their results, codex should be free to improve the prompts according to her
needs."

## What you inherit (read these, and only these)
- `research/HIGGSFIELD_PROMPT_LOG.md` - EVERY job so far, prompt verbatim, cost, verdict, and
  the six lessons that hold across all of them (image first; what passes the content filter;
  multi-camera in one frame works; hands smear; segment colours survive; branding appears).
  **You own the prompts from here.** Change wording, cameras, colours, grid density, duration -
  whatever your review said the data needs - and APPEND a row to the log for every job you run,
  with the result, in the same shape. A prompt without its row in the log did not happen.
- Your own review of the segment-suit idea (S62, quoted in the ground_video README): constraints
  not a solve; JSON per frame; a third oblique-high camera; marker dots at joints; a 2 s test before
  an 8 s spend. You wrote that; now you are the one spending.
- `research/_captures/ground_video/README.md` (the clips on disk and their verdicts) and
  `research/TASK_C180_SEGMENT_SUIT_TRACKER.md` / `C180_DIGEST.md` (the tracker - yours; run it
  on every clip you make).
- `Tools/higgsfield/t2m_ufc_pilot.py` - the existing headless client (text-to-motion). The Blender
  add-on's `client` is what it imports; the API key is in the environment as it was for that pilot
  and is NEVER written into the repo (grep your diff for `hf_` / `sk-` before every commit).

## The ceiling (enforced in code, not in prose)
`Tools/higgsfield/budget.py`: reads `Tools/higgsfield/spend.json` (append-only ledger: job id, model,
estimate, actual, purpose), preflights every job with the client's cost estimate, and REFUSES to
submit when `spent_this_task + estimate > 120`. Print the running total on every call. 120 credits
is the whole of C181. Balance was 370 on 2026-09-24; the operator said "Make them count". No
Seedance 2.5 (56/job) unless a 2.0 attempt has failed for a reason 2.5 fixes.

## Deliver, on branch `codex/c181-higgsfield-loop`
1. `Tools/higgsfield/loop.py <recipe.json>`: one recipe = still prompt (+ optional reference job
   id) -> download -> a CHECK step that prints the still's path and STOPS for a human eye unless
   `--auto` (the operator's rule: check the still first) -> clip prompt from the accepted still
   (duration from the recipe, default 4 s) -> download into `research/_captures/ground_video/`
   with a slug -> run `track_segment_suits.py` (C180) with `panels=` from the recipe -> append the
   README row and the prompt-log row automatically from the recipe + tracker summary.
2. Recipes for THREE clips, each from the corrected-grips still `closed_guard_segment_suits_single_grips.png`
   (job 5387ac51) as the reference: (a) 1x2 opposite sides, 4 s; (b) 1x3 with your third
   oblique-high camera added, 4 s; (c) the same 1x3 with joint marker dots (a contrasting dot at
   shoulder, elbow, wrist, hip, knee, ankle on every segment) if the still generator will keep them
   - test the still first, spend nothing on the clip if the dots do not survive the still.
3. Compare the three with the tracker: per-segment visible% and confidence, especially the TOP
   man's hips and thighs in the wrapped guard. That table is the finding.
4. `research/C181_DIGEST.md`: the table, what the third camera bought, what the dots bought,
   the ledger total, and the prompt changes you made and why.

## Gate
Python only. `py_compile` on the three scripts; `budget.py` has a unit check that a 121st credit is
refused (run it with a fake estimate, no network); the ledger and the prompt log carry every job.
No Godot, no suite. Commit with explicit paths (clips, stills, JSON under ground_video/), push,
one `agent_comms.py send --from codex --to claude --topic C181`. Do NOT edit HANDOFF.md.
Trap: the first segment-suit still was blocked as nsfw on "skin-tight full-body suits"; gloves,
mouthguards, "loose athletic tracking suits", a gym and "sports-science session" passed.

## FOUND AFTER THE FIRST RUN (Claude, 2026-09-24): WHERE THE CLIENT LIVES
Codex's first pass built the loop and the gate but could not import the client. Cause: the client is a
BLENDER EXTENSION module - `t2m_ufc_pilot.py` does
`importlib.import_module("bl_ext.user_default.higgsfield_blender.fnf.session")` and
`.fnf.jobs`, which only resolve inside Blender's own Python. So `loop.py` runs as
`"C:\Program Files\Blender Foundation\Blender 5.2\blender.exe" -b --python Tools/higgsfield/loop.py -- <recipe.json>`
(Blender 5.2.1 is installed on this PC - see reference_pc_animation_tools; the signed-in add-on holds the
key, nothing is typed). Make `loop.py` detect `bpy` and, when absent, print that exact command and exit
non-zero. The corrected-grips still is now on master: `research/_captures/ground_video/closed_guard_segment_suits_single_grips.png`
(job 5387ac51). Grok G83 gives the third camera: elevation 42 deg, azimuth 45 deg off the pair axis,
yaw-slaved - use it for recipe (b).
