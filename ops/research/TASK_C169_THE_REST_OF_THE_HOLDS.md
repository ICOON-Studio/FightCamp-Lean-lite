# C169 — THE REST OF THE HOLDS: CLOSED GUARD, HALF GUARD, BACK CONTROL

**Owner:** codex. **MODEL: `CODEX_MODEL=gpt-6-astra`, `CODEX_EFFORT=medium`** —
3D animation design, which is the domain the operator's 2026-09-21 ruling gives
astra: *"so only use astra for 3d animation design and use luna for other
tasks"*.
**Operator instruction, 2026-09-22: "can codex start working on the rest of
clips?" — this is that. Yes.**

## YOUR C168 WORKED AND THIS IS THE SAME PROCEDURE, THREE MORE TIMES

Side control is authored, exported, bound and **passing**: all six declared
contacts under the 30% ceiling, **worst 15%** (14.8173% on the stronger
all-sample check), down from 133%, both hard controls unchanged, plus a source
fix nobody asked for — attacker knee centres **4.84 cm** above the mat instead
of ~31 cm.

**Three things made it work and all three are required again:**

1. **You reported the failure honestly before anyone asked you to fix it** —
   the 133% digest carried the full drift table and said *"There is no claim
   that the 30% gate passed."*
2. **You did the diagnostic step before the edit and reported the stages that
   did NOTHING** — `isolate contact loss to retarget; graft and mount change
   zero`. That is what found the real cause.
3. **You asked before widening scope** instead of quietly editing the solver.

**The pipeline is no longer the unknown.** C168 fixed the defect that made
direction-preserving retargeting lose endpoint contacts across different
segment lengths. So each hold below is a REPEAT of a known-good procedure, not
an open problem.

## WHAT TO BUILD — THREE HOLDS, IN THIS ORDER, ONE AT A TIME

This completes the five the operator committed to when they kept Cascadeur Pro:
the clinch (S31) and side control (C168) are done.

1. **Closed guard** — bottom man's legs locked around the top man's waist, top
   man posted upright on his knees.
2. **Half guard** — bottom man has ONE of the top man's legs trapped between
   his own; top man is flattening out to pass.
3. **Back control** — attacker behind, both hooks in, seat-belt grip.

**FINISH AND PUSH EACH ONE BEFORE STARTING THE NEXT. DO NOT AUTHOR ALL THREE
AND THEN INTEGRATE.** This is the hard constraint of the task and it is not
negotiable.

**WHY, AND IT IS A REAL FAILURE FROM THIS PROJECT RATHER THAN CAUTION:** C134
ran FIVE continuations on this model against an unbounded animation goal, burned
the 5-hour usage limit at 189,061 tokens in run 1 alone with **not one thing
committed**, and closed "Visual acceptance NOT met". Nothing was lost only
because somebody went looking in the worktree afterwards. **An honest two of
three, pushed, beats three uncommitted.**

## THE STOP RULE — read this before you start hold 1

**ONE fix cycle per hold. If a hold still fails the 30% ceiling after one
diagnose-and-fix pass, PUSH THE FAILURE with its table, write what you learned,
and MOVE TO THE NEXT HOLD.**

Do not spend the run on hold 1. A measured negative with a drift table is a
real deliverable here — C168's 133% digest was, and it is what produced the
fix. **Three holds with two passing and one honestly failed is a better outcome
than one perfect hold and two not attempted.**

## PER HOLD — the procedure, unchanged from C168

**1. Find the technique id in the catalogue FIRST.**
`Godot/assets/data/technique_catalog.json`. Candidates to check:
`bjj_closed_guard`, `bjj_half_guard`, `bjj_back_control` — **but verify each
actually exists and is unbound before using it.** `bjj_back_control` is known
to exist (tier 1, role `control`, phase `ground_top`). **If an id you need is
not in the catalogue, say so and skip that hold — do NOT invent an id**, and do
not bind a position to an id that means something else.

**2. Declare the contacts BEFORE you author.** Put them in the probe first,
then author to them. Each hold has a defining contact and if it is not touching
you have authored a different position:

- **closed guard** — the ankle lock behind the top man's back. **This is a
  SAME-BODY pair** (the bottom man's own two feet), not a cross-body one. Your
  side-control contract was six cross-body pairs; **check the probe can express
  a same-body pair before you author**, and if it cannot, fix that first and
  say so.
- **half guard** — the trapped knee between the bottom man's thighs, plus the
  top man's cross-face or underhook.
- **back control** — both hooks (attacker's insteps inside the opponent's
  thighs) and the seat-belt: one arm over the shoulder, one under the armpit.

**3. Decide who is `_Att` and say why.** It is a real question, not a
convention. In closed guard and half guard the bottom man has the active frame;
in back control the attacker is unambiguous. Make the contact contract
consistent with the choice.

**4. Bind it in `PAIRED_STRIKE_BINDINGS`** in `Godot/scripts/FightClipBinding.gd`
— the technique-keyed table, exactly as `bjj_side_control` went in. **NOT
`PAIRED_BINDINGS`**, which is keyed by the `grapple_*` ids `_log_grapple`
emits. Six fields, clips named `Cascy_ClosedGuard_Att/_Vic.glb`,
`Cascy_HalfGuard_Att/_Vic.glb`, `Cascy_BackControl_Att/_Vic.glb` in
`CASCADEUR_DIR`.

**5. Measure, gate, commit, push, then next hold.**

## THE GATE — per hold, and the controls are the real one

**Every declared contact at 30% drift or better. THAT IS A CEILING, NOT AN
EQUALITY** — if you land lower, say so and push; never hold a better result
back, and never gate on an exact number.

```
RamsterZ control              0.302639 / 0.304671   byte-identical
clinch att_lhand_to_vic_neck  15% or better
side control (C168)           still passing - you must not regress your own work
--only clip      SUITE total=10 fails=0
--only grapple   SUITE total=10 fails=0
--only pair      SUITE total=7  fails=1   (only the operator-parked fight_pair_live_test)
```

**One `--only` per invocation — a second `--only` REPLACES the first.** Read the
`total=` line each time to confirm the filter matched; `total=0` means your
filter is wrong, not that it passed.

**Do NOT run the full suite** — Claude runs it once at integration, and a
second Godot in this checkout while the suite is up produces false all-failed
results.

**IF A CHANGE MAKES A CONTROL WORSE, REVERT IT AND REPORT THE TABLE.** A change
that degrades the measured thing does not ship because its failure was
informative.

## SCOPE

**OPEN:** `Godot/scripts/FightClipBinding.gd` (binding entries),
`FightClipRetarget.gd` and `PairedStagePlayer.gd` (you repaired them in C168),
your Cascadeur build scripts under `Tools/cascadeur/`, your own probes and
tests, your digest.

**CLOSED: `Godot/scripts/FightPoseSolver.gd`.** It is wired to nothing in the
live path, so a change there cannot move the number you are measuring. If you
come to believe otherwise, **prove it with a measurement and ask**, as you did
last time.

**Do NOT edit `HANDOFF.md`. Do NOT fetch or rebase** — the checkout is current,
and `git rebase` refuses over the untracked `.uid`/`.import`/scratch files this
tree always carries. **Never `git stash`, `reset --hard`, `checkout .` or
`clean`** in this shared checkout.

## TRAPS

- **Closed guard and half guard INTERLOCK the two bodies.** Limbs cross the
  other body's volume by design, so a naive interpenetration check reports a
  defect that is actually the position. **Name which overlaps are authored and
  expected**, and gate on declared CONTACT pairs rather than on penetration for
  those.
- **C168's fix preserves source contact offsets across target ARM
  proportions.** Closed guard's defining contact is a **LEG** one and back
  control's hooks are too. **Verify the same fix covers legs before assuming
  it does** — and if it does not, that is the headline finding of this task.
- **Parse gate FIRST on every touched `.gd`** — a parse error HANGS a headless
  test for 600 s instead of failing it.
- **`rc=0` IS NOT A PASS.** A GDScript runtime error exits 0. Read the `SUITE`
  line, never the exit code.
- **Backticks in a `git commit -m` string run as commands in bash** and get
  silently deleted from the message. Use `git commit -F -` with a quoted
  heredoc for any message containing them.

## FINISH — per hold, not once at the end

1. **Commit after each step**, explicit paths on the commit line
   (`git add -- <files>`), then `git show --stat HEAD` to confirm nothing else
   rode along — a pre-staged mail file will otherwise ride in.
2. **Push master after each hold.**
3. `research/C169_DIGEST.md`, appended per hold: the contact table before
   and after, who is `_Att` and why, which overlaps are authored, the control
   block quoted, and **the measured elapsed time for that hold**. C168 gave
   17.3 minutes as a lower bound for one hold and that is the only real datum
   this project has on authoring cost — **three more points turns it into a
   trend**, which is exactly what your own objection about 376 sessions needs.
4. One line at the end: `python Tools/agent_comms.py send --from codex --to
   claude --subject "C169" --body "<which holds landed, worst drift each, and
   the controls>"`.

## YOUR OBJECTION IS ON THE RECORD

You wrote that authoring holds one at a time will never close the 376-clip gap,
and that one hold per session is 376 sessions. **It has not been dismissed** —
it is in the session record and in the roadmap. The operator committed to FIVE
authored holds when they kept Cascadeur, and this task is holds three, four and
five. Nobody is extrapolating this batch to 376. **Your per-hold timings are
the evidence that will decide what happens after these five**, so measure them
honestly.
