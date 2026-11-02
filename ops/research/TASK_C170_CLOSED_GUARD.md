# TASK_C170 — CLOSED GUARD, THE HOLD C169 SKIPPED FOR A NAME

**Model: `gpt-6-astra`, medium effort.** This is 3D animation design — authoring
motion on a skeleton — which is the domain the operator's 2026-09-21 ruling
assigns to astra.

**Owned files.** Author only these:
- `Godot/assets/anim/audition/cascadeur/Cascy_ClosedGuard_Att.glb` (new)
- `Godot/assets/anim/audition/cascadeur/Cascy_ClosedGuard_Vic.glb` (new)
- `Godot/scripts/FightClipBinding.gd` — ONE new entry in `PAIRED_STRIKE_BINDINGS`
- `research/C170_DIGEST.md` (new)

Do NOT touch `FightPoseSolver.gd`, `FightClipRetarget.gd` or
`PairedStagePlayer.gd`. C168 already fixed the retarget contact loss; if you
believe one of them is wrong, say so in the digest and stop.

---

## WHY THIS TASK EXISTS, AND IT IS NOT YOUR MISTAKE

C169 did the right thing under the brief it was given and still lost a hold.
Its brief said *"candidates to check: `bjj_closed_guard`, `bjj_half_guard`,
`bjj_back_control` — but verify each actually exists"*. You verified. It did
not exist. You correctly refused to invent one and recorded the skip.

**The brief was wrong, not you.** It handed you a list of candidate IDs and you
treated the list as the search space. Closed guard is in the catalogue and
always was:

> **`bjj_guard`** — name **"Closed Guard"**, branch `positions`, discipline
> `brazilian_jiu_jitsu`, tier 1, role `control`, phase `ground_top`.

**THE RULE THAT COMES OUT OF IT, and it is now a test rather than a note:**
search for the THING, not for the name you expect it to have. When an id is
missing, grep the catalogue for the position's human NAME before concluding it
is absent. `Godot/tests/technique_id_reference_test.gd` now fails the suite on
any technique id referenced from code that is not in the catalogue, so a
guessed id can no longer reach a digest.

---

## THE HOLD

**`bjj_guard`, Closed Guard.** The bottom man has his legs wrapped around the
top man's waist, ankles crossed behind his back. The bottom man's frame is the
active one — he controls the position, he is not surviving it.

**WHO IS `_Att`.** The BOTTOM man. In closed guard the man on his back owns the
position: he decides whether it opens. C169 raised exactly this question for
half guard and got it right there; keep the same reasoning. Say in the digest
which you chose and why, and make the contact contract consistent with it.

**THE DEFINING CONTACT, AND IT IS A SAME-BODY PAIR.** The ankle lock behind the
top man's back is the bottom man's OWN TWO FEET touching each other. Your
side-control contract was six cross-body pairs; this one is not. C169 already
established that the probe can express it — its digest says *"the existing s31
probe represents each endpoint as bone plus actor (`a`/`b`), so a same-body
ankle pair is expressible without changing its schema"*. That finding is the
one thing C169 left you and it is worth having: **use it, do not re-derive it.**

Declare the contacts in the probe BEFORE you author, not after. If a declared
contact is not touching, you have authored a different position.

Contacts to declare, at minimum:
- `att_lfoot_to_att_rfoot` — the crossed ankles, SAME BODY
- `att_lknee_to_vic_torso` and `att_rknee_to_vic_torso` — the knees squeezing
  the top man's ribs. Without these he is lying between someone's legs, not in
  a guard.
- one grip: the bottom man's hand on the top man's collar, wrist or head.

---

## GATE — a CEILING, and over-delivery is welcome

- Every declared contact at **30% drift or better**. If you land lower, say so
  and push; never hold back a better result.
- The hard controls must be **unchanged**, byte for byte:
  - RamsterZ `0.302639 / 0.304671`
  - clinch left hand **15% or better**
  - side control **14.8173% or better**
- Tests: parse gate first on every touched `.gd`
  (`python Godot/tools/check_scripts.py <files>`), then
  `python Godot/tools/run_tests.py --only clip` (expect 10/0),
  `--only grapple` (10/0), `--only pair` (7/1 — `fight_pair_live_test` is
  PARKED by the operator and red on purpose).
- **ALSO RUN `--only technique_id`.** That is the new gate from this defect and
  your binding is one of the things it checks.
- **DO NOT run the full suite.** It is the integrator's, once, and it costs
  twenty minutes.

---

## SHOW IT, DO NOT JUST BIND IT

`render_paired_hold.gd` works now — S57 found why it wrote 24 frames of empty
floor four times: the posed pair sat 0.85 m UNDER the mat, because the grafted
clip's root track writes away the mount's feet-on-deck offset. It now rests the
pair on the deck from the posed bones and refuses any frame that matches a
photograph of the empty room.

So finish with:

```
Godot_v4.7.2-stable_win64_console.exe --path Godot \
  --script tools/render_paired_hold.gd -- Cascy_ClosedGuard
python Tools/paired_contact_sheet.py Cascy_ClosedGuard
```

Both must pass their own gates (`RENDER total=1 fails=0`,
`SHEET total=1 fails=0`). **Open the sheet and say what you see** — whether it
reads as closed guard to a human, not just whether the numbers passed. This
project has bound four clips nobody watched.

---

## THE ONE TRAP SPECIFIC TO THIS HOLD

**A closed guard and an open guard look nearly identical from one camera.** The
difference is entirely whether the ankles are crossed and locked behind the
back. `render_paired_hold.gd` shoots four angles for exactly this reason — the
`high` and `low` views are the ones that show the ankle lock. If the ankles are
not visibly crossed in at least one view, you have authored open guard and
bound it to `bjj_guard`, which is worse than skipping it.

`bjj_open_guard` is a separate catalogue node. Do not bind to it.

---

When done: commit, push, write `C170_DIGEST.md`, and send one line with
`python Tools/agent_comms.py send --from codex --to claude --subject C170`.
Do NOT edit `HANDOFF.md`. Do not fetch or rebase — the checkout is current.

---

## THE READ SET — added 2026-09-23 after C170 run 1 blocked on it, correctly

Run 1 stopped and asked rather than guessing, which is the right instinct and
the reason the C167 cause was ever found. The brief was too tight: it named the
files to WRITE and forgot the ones to READ. **You may read all of these, and you
should.**

**The authoring channel** — `Tools/cascadeur/README.md`. Cascadeur 2026.2 is
scriptable from inside the running GUI and **no click is needed any more**:
`python Tools/cascadeur/ensure_server.py` opens the channel once per launch.

**The three holds you already authored, which are the pattern to copy:**
- `Tools/cascadeur/build_side_control.py` (C168)
- `Tools/cascadeur/build_half_guard.py` (C169)
- `Tools/cascadeur/build_back_control.py` (C169)
- and their working dirs `Tools/cascadeur/c169_half_guard/`,
  `Tools/cascadeur/c169_back_control/`

`build_side_control.py` states its own honest caveat in its docstring — *"ratios
below are artistic choices, not footage measurements or retarget tuning"*. Keep
that discipline and keep saying it.

**The helpers:** `dump_rig.py`, `apply_pose.py`, `apply_clip.py`,
`export_pair.py`, `measure_contacts.py`, `place_second.py`, `inspect_glb.py`,
`csend.py`, `ensure_server.py`, `casc.ps1`.

**The source rig:** `Godot/assets/anim/audition/cascadeur/Cascy_rest_reference.glb`.

**The probe:** `Godot/tools/s31_contact_probe.gd` — this is where you declare the
contacts before authoring, and where your C169 same-body finding applies.

**The render and sheet tools:** `Godot/tools/render_paired_hold.gd`,
`Tools/paired_contact_sheet.py`.

You may also read `research/C168_DIGEST.md` and
`research/C169_DIGEST.md` — your own two digests, and nothing else from
`research/`.

**Still forbidden:** `HANDOFF.md`, `CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md`,
any other agent's digest, and any edit to `FightPoseSolver.gd`,
`FightClipRetarget.gd` or `PairedStagePlayer.gd`.
