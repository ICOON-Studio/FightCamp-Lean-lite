# TASK C137 — CODEX — ONE SYNCHRONISED TWO-FIGHTER BJJ SEQUENCE, PLAYING IN THE GAME

**Agent:** Codex · `gpt-6-astra`, medium · worktree `FightCamp-C134`, branch `codex/c134-bjj-presentation`
**Assigned:** 2026-09-20 by Claude, from the operator's own words.

---

## WHAT DONE MEANS, AND IT IS THE ONLY DEFINITION THAT COUNTS

**Produce and demonstrate ONE synchronised two-fighter BJJ animation sequence inside FightCamp:**
a stable ground position, **one** transition, and a stable ending position.

Completion requires **all four**:

1. **Both fighters animate together through the sequence** — not one actor, not two clips that happen
   to run at once.
2. **Contact, alignment and transitions are visibly INSPECTED** for clipping, sliding and snapping,
   and the findings reported.
3. **The exported sequence plays inside FightCamp.**
4. **A runnable demonstration AND a recording of actual in-game playback are delivered.**

**THESE DO NOT COUNT AS COMPLETION, IN THE OPERATOR'S OWN WORDS:** rigging, import/export success,
screenshots of static poses, or passing code tests. **Do not substitute AI-generated video for
in-game animation.** C135 is the cautionary case: it rigged both fighters successfully and produced
no pose, and it was right to report that as "no verified solution" rather than dress the rigging up
as progress.

**THIS TASK PROVES ONE SEQUENCE. IT DOES NOT PROMISE A COMPLETE BJJ MATCH.** Do not widen it.

## START FROM THE ASSETS YOU ALREADY RE-BAKED — AUTHORING MAY NOT BE NEEDED AT ALL

**Your own C136 re-baked FIVE bought pairs with root motion preserved**, as native f05/f06 Att/Vic
variants, 30 GLBs, in `Godot/assets/anim/audition/c136_rebaked/`:

| clip | what it is |
|---|---|
| `C136_H2H_ArmBar_f05_Att.glb` / `_f06_Vic.glb` | a submission from a hold |
| `C136_H2H_Strangle_f05_Att.glb` / `_f06_Vic.glb` | a submission from a hold |
| `C136_PushOff_*` | **a transition** |
| `C136_Reversal_*` | **a transition** |
| `C136_Takedown_BodyLock_End_*` | ends in a ground position |

**So the simplest useful sequence is very likely already on disk: a bought FullMount hold as the
stable start, `Reversal` or `PushOff` as the one transition, and whatever it ends in as the stable
ending.** Sixteen FullMount pairs are in `Godot/assets/anim/audition/ramsterz/`
(`Paired_FullMount_1HM_*_Att.fbx` / `_Vic.fbx`, 12 unarmed).

**PICK THE SEQUENCE THE EXISTING ASSETS ALREADY SUPPORT. Do not author anything you do not have to.**
You are authorised to author, but authoring is the fallback, not the plan.

## STEP 0 — A 30-MINUTE FEASIBILITY CHECKPOINT, AND IT IS A CEILING

Report each in one line, then **STOP AND REPORT IF BLOCKED — do not spend the run fighting it**:

1. **Can the sequence be assembled from existing assets?** Name the three clips you will use.
2. **Does native Cascadeur GUI control actually work?** The operator authorises GUI-driven work, and
   C135 established that the HEADLESS `AutoPosingTool` surface (`activate`, `add`, `deactivate`,
   `update`) exposes no paired pose solve. **Confirm GUI control before spending a minute on
   authoring.** If a Computer Use prompt appears, approve and proceed. C135 found **no targetable
   Cascadeur window** during a stalled headless call — so prove a window exists and responds before
   you rely on it.
3. **Can the paired player take the sequence?** A hold needs two clips named `<Key>_Att` / `<Key>_Vic`
   plus a six-field `PAIRED_BINDINGS` entry (`FightClipBinding.gd:882`) — **never**
   `FightMoveScript`'s strike-shaped `PAIR_KEYS`.

**BLOCKED ON (2) ALONE DOES NOT STOP THIS TASK — that was wrong in the first issue of this file and
it cost a run.** Cascadeur is the FALLBACK. If question 1 answers yes, the sequence comes from
existing assets and the GUI is not needed at all: **record the GUI blocker in one paragraph and
carry straight on to the demonstration.** Only a NO on question 1 makes the GUI load-bearing.

**If question 1 answers no AND the GUI is blocked, report the EXACT failure and STOP. Do not retry
repeatedly.** A precise blocker at 30 minutes is a good outcome; six hours of attempts is not.

**ALREADY ANSWERED ON 2026-09-20, so do not re-derive it:** question 1 is **YES** —
`Paired_FullMount_Takedown_BodyLock_Loop` (stable start) -> `Paired_FullMount_Reversal` (the one
transition) -> `Paired_FullMount_Takedown_BodyLock_End` (stable ending), all `_Att`/`_Vic` present in
`ramsterz/`. Question 2 is **BLOCKED**: Cascadeur launches and responds (PID observed) but Codex's
Computer Use returns `apps: []` with no targetable window, and the native APIs are missing in this
session (`computer.launch_app` undefined, `cua.listWindows` not a function). **That is a limitation
of Codex's own harness in `exec` mode, not proof that Cascadeur's GUI cannot be driven.** Take the
asset route and go.

## EXACT FILE SCOPE

**Rigs** — `Godot/assets/models/fighters/f05_m_mma_light_rigged.glb`, `f06_m_mma_lhw_rigged.glb`
(1.6 MB each; the pair the BJJ route already selects).

**Clips** — `Godot/assets/anim/audition/c136_rebaked/` (your 30 re-baked GLBs),
`Godot/assets/anim/audition/ramsterz/` (16 bought FullMount pairs),
`Godot/assets/anim/pairs/` (the two live jab entries — the only working `.pair.json` examples,
`BOX_JAB_HEAD_LAND_F01_F09.pair.json` is your template).

**Cascadeur** — `C:\Program Files\Cascadeur\cascadeur.exe` (2026.2.2, licence active). Your own
scripts: `Godot/tools/c135_cascadeur_import.py`, `c135_cascadeur_rig.py`, `c135_cascadeur_probe.py`,
`c135_inspect_exports.py`. Stubs at `C:\Program Files\Cascadeur\resources\scripts\stubs\`.

**Blender** — `D:\Tools\Blender\blender-5.2.1-windows-x64\blender.exe`, the ONLY copy with the
Retarget add-on. Your re-bake recipe is `Godot/tools/c136_rebake.py`.

**Player and bindings** — `Godot/scripts/FightStagePlayer.gd` (129 KB — **windows only, never whole**),
`Godot/scripts/FightClipBinding.gd` (60 KB — `PAIRED_BINDINGS` at `:882`, windows only).

**Harnesses** — `Godot/tools/c134_hold_review.gd` (four camera views; it currently auditions the
bound `grapple_control` film, so **point it at your sequence or it will show bought mount footage
instead**), `Godot/tools/c134_pair_review.gd`, `Godot/tools/record_room.gd` (the in-game recorder).

**Your deliverables** — `research/C137_BJJ_SEQUENCE.md` and the recording.

## AUTHORISED, AND STILL FORBIDDEN

**Authorised:** GUI-driven Cascadeur work; scoped changes to animation assets, bindings and the
demonstration harness.

**Forbidden, unchanged:** **NO PURCHASES AND NO SUBSCRIPTION CHANGES OF ANY KIND** — do not
subscribe, do not unsubscribe, do not enter payment details, and **do not touch the Cascadeur trial
that bills EUR 37.66 on 2026-09-27**. No engine edits (`FightRealtime.gd` is Claude's and is being
edited this session). No `HANDOFF.md` edit. No rebase, no branch switch. Never commit `.c134/`.

**IDENTIFY ANYTHING THAT NEEDS AN OPERATOR DECISION** and report it rather than deciding it
yourself — a method that would cost money, change a subscription, or commit us to a pipeline.

## GATES

```
python Godot/tools/check_scripts.py <each touched .gd>
python Godot/tools/run_tests.py --only c134      (then --only clip, --only pair)
```

Ceilings, and they are CEILINGS — land lower and say so: `c134` fails=0, `clip` fails=0, `pair`
fails=1 or better (`fight_pair_live` is PARKED by the operator's 2026-09-15 ruling). **Never the full
suite** — Claude runs it at integration and a second concurrent Godot gives both of us false
failures.

## WHEN DONE

Commit with explicit paths, `git show --stat HEAD` to verify what went in, unstage
`AgentComms/messages`. Push `codex/c134-bjj-presentation`, write
`research/C137_BJJ_SEQUENCE.md`, and send one line with
`python Tools/agent_comms.py send --from codex --to claude --topic "C137 ready" --body "<one line>"`.

## THE TRAP SPECIFIC TO THIS TASK

**A PAIR THAT PLAYS IS NOT A PAIR THAT LOOKS RIGHT, AND YOUR OWN RECORD PROVES IT.** C134 bound
clips that played and the operator rejected the result on sight; C136's contacts are still refused
at measured residuals. So **watch the recording before you report**, and if the men slide, clip or
snap, say so with the number and call it unfinished. **A wrong position is worse than no clip.
Unshown and reported is success; faked is failure.** That judgement has been right every time you
have applied it.
