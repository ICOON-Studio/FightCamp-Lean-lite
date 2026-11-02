Task Q213G-AB (a measurement; no code change except the new files below). Repository: Godot 4.7.2 GDScript game, project folder `Godot/`.

WORKFLOW: create your own branch `arena/<this-chat-id>-FightCamp` from master, commit there, push, open a pull request into master. Never push to master, never merge the PR yourself.

SETUP in your sandbox: `bash Tools/cloud_setup.sh` (Godot 4.7.2 to /opt/godot, sets GODOT_EXE), then `$GODOT_EXE --headless --path Godot --import` once (slow). Read `research/Q213G_DIGEST.md` sections 3 and 10.

BACKGROUND: a new option `glove_hand` makes the contact solve use the glove's volume for the hand and the head's drawn surface (`Godot/scripts/FightBodyCapsules.gd` `_fit_glove_parts` / `_fit_head_part`, `Godot/scripts/FightContactSolve.gd` `pair_contact`). Risk: a bigger hand volume could push a LANDING punch off the head so the glove hovers instead of touching.

TASK: run the C223 production gate both ways (one rig per process; use a long timeout, each arm can take 15-60 min):
  python3 Tools/c223_parallel.py production --jobs 4 -- plant phase live_contact bound report=/tmp/c223_base.json
  python3 Tools/c223_parallel.py production --jobs 4 -- plant phase live_contact bound glove_hand report=/tmp/c223_glove.json
Write `Tools/c223_ab_diff.py` that compares the two reports row by row (rows = candidate x rig; read the JSON keys yourself: accepted, g147, contact/landing/reach/glove-to-target distances, pin pops, body_overlap_pass).

DELIVER (only these new files): `research/Q213G_C223_AB.md` (both commands, per-arm totals, a table of every row whose accepted/pass status changed or whose contact/landing number changed by more than 1 cm or 5%, and a plain verdict: do landing punches still reach the head with glove_hand - yes/no with the evidence), the reports copied to `previews/c223/q213g_c223_base.json` and `q213g_c223_glove.json`, and `Tools/c223_ab_diff.py`. Paste the verdict and totals in the PR description. CI must be green.
