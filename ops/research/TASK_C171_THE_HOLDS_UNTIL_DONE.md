# TASK_C171 — THE HOLDS, UNTIL THEY ARE DONE

**STANDING TASK. It does not finish at one clip.** You work the queue below from
the top, one hold at a time, and you keep going until the queue is empty or you
hit a stop condition this file names. **SUPERSEDES C170** — closed guard is
queue item 2 here.

**Model: `gpt-6-astra`, medium effort.** 3D animation design is astra's domain
(operator ruling 2026-09-21). **If you were started from the Codex desktop app,
the model must be picked BY HAND** — the app ignores `codex_task.cmd`'s pin and
falls back to `gpt-5.6-sol` from the global config.

---

## THE QUEUE, ORDERED BY MEASURED GROUND TIME, NOT BY TASTE

S56 measured 120 MMA bouts on the shipped engine and counted where the fight
actually spends its time on the floor. **The order below is that measurement,
not a preference** — author the seats the game is actually in.

| # | id | name | why here |
|---|---|---|---|
| 1 | `bjj_mount` | Mount Control | **37.9% of all ground time — the single largest seat in the game, and it has no clip.** |
| 2 | `bjj_guard` | Closed Guard | the `guard` seat is 27.3% of ground time. This is the hold C169 skipped for a name. |
| 3 | `bjj_turtle` | Turtle | the standard scramble position between a failed shot and back control |
| 4 | `bjj_north_south` | North-South | a real top position, reachable from side |
| 5 | `bjj_knee_on_belly` | Knee-on-Belly | a real top position, reachable from side |
| 6 | `bjj_open_guard` | Open Guard | **author AFTER closed guard and make them visibly different** — see the trap |
| 7 | `bjj_front_headlock` | Front Headlock Control | |
| 8 | `bjj_5050` | 50/50 Guard | lowest value, do last |

**Already done, do not redo:** `bjj_side_control` (C168, 14.8%),
`bjj_half_guard` (C169, 21.9%), `bjj_back_control` (C169, 17.5%).

**Every id above is verified present in the catalogue.** Do not guess ids and do
not substitute. `Godot/tests/technique_id_reference_test.gd` now fails on any
technique id referenced from code that is not in the catalogue.

---

## THE LOOP — this is the whole job

For each hold, in order:

1. **Declare the contacts in `Godot/tools/s31_contact_probe.gd` BEFORE you
   author.** Author to the declared contacts, never the other way round. If a
   declared contact is not touching, you have authored a different position.
2. **Author** in Cascadeur. Pattern: your own `Tools/cascadeur/build_*.py`.
3. **Export** `Cascy_<Name>_Att.glb` and `Cascy_<Name>_Vic.glb`.
4. **Bind** one entry in `PAIRED_STRIKE_BINDINGS` in
   `Godot/scripts/FightClipBinding.gd`.
5. **Gate** (below).
6. **RENDER IT AND LOOK AT IT** (below). A number is not a picture.
7. **Commit and push** that hold on its own. One hold, one commit — never batch
   three holds into one commit, because a bad one then cannot be reverted alone.
8. **Send one line** immediately:
   `python Tools/agent_comms.py send --from codex --to claude --subject C171`
   with the hold name, the worst contact drift, and whether the render reads.
   **Send after EVERY hold, not once at the end.** If you die at hold 5, the
   four before it must already be reported.
9. **Go to the next hold.** Do not stop to ask.

---

## WHEN SOMETHING IS WRONG — AND THIS IS THE PART THAT KEEPS YOU MOVING

C170 run 1 stopped and asked permission to read a file. That instinct is right
in general and it cost a whole run here. **So the boundary is now explicit.**

### YOU MAY FIX THESE YOURSELF. Fix, record in the digest, carry on.

- Anything in `Tools/cascadeur/` — helpers, build scripts, working dirs.
- `Godot/tools/s31_contact_probe.gd` — including extending its schema if a hold
  needs an endpoint kind it cannot express.
- `Godot/tools/render_paired_hold.gd` and `Tools/paired_contact_sheet.py` if
  they fail on a hold whose shape they did not anticipate. **They were written
  against a ground hold; a turtle or a 50/50 may break their camera framing or
  their deck-rest, and fixing that is part of this task.** Keep their gates
  intact — never widen a threshold to make a run pass.
- A wrong or missing entry in `PAIRED_STRIKE_BINDINGS`.
- A test that is red because of something you changed.
- Anything under `research/` that is your own.

### STOP, RECORD, AND SKIP TO THE NEXT HOLD — do not halt the run.

- A contact that will not come under 30% after **two** honest attempts. Record
  the number you got and what you tried, skip that hold, go to the next one.
  **A skipped hold does not end the queue.**
- A catalogue id that is genuinely absent. Grep the position's human NAME first
  (that is exactly how closed guard was lost), and if it is truly not there,
  record it and move on.
- Any need to touch `FightPoseSolver.gd`, `FightClipRetarget.gd` or
  `PairedStagePlayer.gd`. C168 already fixed the retarget contact loss. If you
  believe one of them is now wrong, **write the evidence in the digest and skip
  the hold** — do not edit them, and do not stop the queue.

### STOP THE WHOLE RUN ONLY FOR THESE

- A hard control moved: RamsterZ is not `0.302639 / 0.304671`, or clinch is
  worse than 15%, or side control is worse than 14.8173%. That means something
  global broke and every hold after it is suspect.
- You cannot reach Cascadeur at all after `ensure_server.py`.

---

## GATE, PER HOLD — a CEILING, and over-delivery is welcome

- Every declared contact at **30% drift or better.** If you land lower, say so
  and push. Never hold back a better result to match a number in a brief.
- Hard controls **unchanged**: RamsterZ `0.302639 / 0.304671`, clinch 15% or
  better, side control 14.8173% or better.
- Parse gate first on every touched `.gd`:
  `python Godot/tools/check_scripts.py <files>`
- Then `python Godot/tools/run_tests.py --only clip` (10/0), `--only grapple`
  (10/0), `--only pair` (7/1 — `fight_pair_live_test` is PARKED by the operator
  and red on purpose), and `--only technique_id` (the id gate).
- **NEVER run the full suite.** It is the integrator's, once, and costs twenty
  minutes you should spend authoring.

---

## RENDER EVERY HOLD AND SAY WHAT YOU SEE

```
Godot_v4.7.2-stable_win64_console.exe --path Godot \
  --script tools/render_paired_hold.gd -- Cascy_<Name>
python Tools/paired_contact_sheet.py Cascy_<Name>
```

Both must pass their own gates (`RENDER total=1 fails=0`,
`SHEET total=1 fails=0`). The render tool photographs the empty mat from each
camera and refuses any frame that does not differ from it, so an empty sheet
cannot pass — but **a populated sheet is not a correct sheet.** Open it and say
in one sentence whether a human would name that position.

This project bound four clips nobody watched. `boxing_double_jab` was a single
jab, two uppercuts were the same unreadable move, and
`muay_thai_horizontal_elbow` was a spinning elbow aimed behind him.

---

## TRAPS, ONE PER HOLD WHERE THERE IS ONE

- **mount** — mount and side control read almost identically from a high
  camera. The difference is whether his knees are either side of the torso or
  both on one side. Check the `establishing` and `high` views.
- **closed guard** — closed and open guard look identical except that the
  ankles are **crossed and locked** behind the top man's back. The ankle lock is
  a **SAME-BODY** contact — the bottom man's own two feet. Your C169 digest
  already established the probe expresses this (`bone plus actor a/b`); use that
  finding, do not re-derive it. `_Att` is the **BOTTOM** man: in closed guard he
  owns the position.
- **open guard** — author it AFTER closed guard and put the two sheets side by
  side. If you cannot tell them apart, one of them is wrong.
- **turtle** — one man is folded over his own knees and the other is behind
  him. `_Att` is the man ON TOP. The render tool rests the pair on the deck from
  the lowest posed bone; a turtle is tall and narrow and may frame badly. Fixing
  the framing is yours.
- **north-south** — the two men are head-to-toe. `_pair_bounds` will report a
  long thin pair and the camera may end up inside a body. Yours to fix.
- **50/50** — the legs are entangled symmetrically, so "who is `_Att`" is a
  genuine question with no obvious answer. Pick one, say why.

---

## WHAT TO WRITE

`research/C171_DIGEST.md`, appended **per hold** as you go — not written
at the end. Each entry: the hold, its id, who is `_Att` and why, the declared
contacts, the worst drift, the control readings, what the render shows in one
sentence, and anything you fixed along the way.

Do NOT edit `HANDOFF.md`. Do not fetch or rebase — the checkout is current and
a rebase will refuse over the untracked files it always carries.

---

## THE READ SET

`Tools/cascadeur/README.md` (the channel: `python
Tools/cascadeur/ensure_server.py`, no click needed since 2026-09-22), all of
`Tools/cascadeur/` including `build_side_control.py`, `build_half_guard.py`,
`build_back_control.py` and the `c169_*` working dirs, the helpers
(`dump_rig.py`, `apply_pose.py`, `apply_clip.py`, `export_pair.py`,
`measure_contacts.py`, `place_second.py`, `inspect_glb.py`, `csend.py`,
`casc.ps1`), the source rig
`Godot/assets/anim/audition/cascadeur/Cascy_rest_reference.glb`, the probe
`Godot/tools/s31_contact_probe.gd`, the render tools, the technique catalogue,
and your own `C168_DIGEST.md` / `C169_DIGEST.md`.

**Not** `HANDOFF.md`, `CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md`, or another
agent's digest.

---

## HOW THIS ENDS

The queue is empty, or every remaining hold has been attempted and recorded as
skipped. Then send a final line with the tally: how many authored, how many
skipped, and the worst drift across all of them.
