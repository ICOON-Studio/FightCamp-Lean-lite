# TASK C136 — CODEX — USE THE TOOLS TO MAKE THE FILMS WE ALREADY OWN WORK

**Agent:** Codex · `gpt-6-astra`, medium · worktree `FightCamp-C134`
**Assigned:** 2026-09-20 by Claude.

## THE OPERATOR'S GRANT, AND ITS EXACT SCOPE

> "Codex may use Cascadeur, Blender, and available automation tools to author, refine, export, and
> test original paired BJJ animations. … Paid services or purchases require separate spending
> approval." — operator, 2026-09-20
>
> "codex has full access to all tools" — operator, 2026-09-20

Then, clarifying what that was for:

> "i meant access to tools for the task" — operator, 2026-09-20

**SO THIS IS TOOL ACCESS, NOT A NEW MANDATE. HAND-AUTHORING A HOLD FROM NOTHING STAYS CLOSED.** You
closed it yourself after four iterations and you were right; I briefly read the grant as reopening
it and the operator has corrected that. **Do not start a hold from scratch.** The tools are here to
serve the task you already have.

**MONEY IS STILL RESERVED.** No purchases, no subscriptions, **no Higgsfield credits on this task**
(the MCP works now — 88 tools, logged in — but it is a paid service and this is not its spending
approval), and **do not touch the Cascadeur trial that bills EUR 37.66 on 2026-09-27.** If any tool
prompts for a licence or payment action, stop and quote it verbatim.

---

## THE TASK, AND WHY THE TOOLS CHANGE IT

The numbers from your own last run: **BJJ 144 beats, 0 named clips, 144 honest degrades.** MMA 73 /
40 / 28. Both end by decision. Contacts still drift, both submissions remain refused, and all four
transition refusals survived the hip-travel fix.

**And here is the shape of the problem: we own 244 FBX and 16 RamsterZ FullMount pairs, and the live
paired library is TWO entries — both the same boxing jab.** The films exist. They do not survive the
journey onto our rigs. **That journey is a Blender problem, and you now have the Blender that has
the Retarget add-on.**

You already proved the mechanism: **retargeting discarded 1.020 m X and 0.844 m Z of the attacker's
hip travel.** You fixed it at the *runtime* end. **Fixing it at the ASSET end — re-baking the bought
pairs so the exported clip carries its root motion — is refining and exporting content we own, which
is squarely inside the grant and is not authoring.**

### In order

1. **Re-bake one bought FullMount pair through the portable Blender, preserving root motion**, and
   land it as a correct `<Key>_Att` / `<Key>_Vic` pair. `Paired_FullMount_1HM_*` are in
   `Godot/assets/anim/audition/ramsterz/`. **Trap 3 is the one that bites here: the add-on's own
   bake makes no action while reporting FINISHED — use
   `nla.bake(visual_keying=True, clear_constraints=True)`.**
2. **Re-check the armbar and strangle contacts against the re-baked source.** If the drift was the
   retarget all along, they may simply come right. Measure it — contact residual in metres,
   interpenetration as a share of frames. You have the method.
3. **Then the four transition refusals** (clinch break, sweep, escape, stand-up). They survived the
   runtime fix; test whether they survive an asset-level re-bake too.
4. **Bind and show whatever now holds up. Refuse whatever does not, with the number.**

**A wrong position is worse than no clip. Unshown and reported is success.**

### Cascadeur is available, for refining — not for building from nothing

If a bought clip is nearly right and needs a pass — a limb cleaned up, a contact settled, physics
smoothing — **that is refining an existing animation and it is in scope.** Its ML/physics posing on
an existing clip is exactly the kind of use the grant covers. **Starting an empty scene and posing
two bodies from scratch is not.**

Cascadeur 2026.2.2 at `C:\Program Files\Cascadeur\cascadeur.exe`, licence active,
`--run-python-code` verified exit 0. GUI use is approved by the operator's grant above; if a
Computer Use prompt appears, approve and proceed. **Trap: calling a `csc` function that does not
exist crashes the app with exit −1 and a Qt stack trace** — that looks like a tool failure and is
not. Check `C:\Program Files\Cascadeur\resources\scripts\stubs\` first.

---

## WHAT YOU HAVE — VERIFIED ON DISK 2026-09-20

| tool | path |
|---|---|
| **Blender 5.2.1 portable** | `D:\Tools\Blender\blender-5.2.1-windows-x64\blender.exe` — **the ONLY copy with Retarget + Higgsfield** |
| **Cascadeur 2026.2.2** | `C:\Program Files\Cascadeur\cascadeur.exe` |
| Blender (operator's) | `C:\Program Files\Blender Foundation\Blender 5.2\blender.exe` — no add-ons |
| Rokoko Studio | `C:\Program Files (x86)\Rokoko Electronics ApS\Rokoko Studio\Rokoko Studio.exe` — needs two humans; not an agent workflow |
| Unreal 5.8 | `C:\Program Files\Epic Games\UE_5.8\Engine\Binaries\Win64\UnrealEditor.exe` — reference |

**Rigs:** twelve `*_rigged.glb` in `Godot/assets/models/fighters/`. **Use f05_m_mma_light and
f06_m_mma_lhw** — the pair the BJJ route already selects (66.0 / 66.5 kg).

**Animation:** 244 FBX. `audition/ramsterz/` has the 16 FullMount pairs (12 unarmed);
`audition/motifect/unpacked/Motifect_martial_arts_v1_0/` has FBX + BVH including
`wrestling_guard_position`. `anim/pairs/` has the two live jab entries. `anim/authored/` has your
`C134_TAP_GESTURE.json` and the rejected `c134_side_candidate/` — keep it, it is the before.

**Source projects: NONE exist** (no `.blend`, no `.casc` anywhere). **Commit whatever you create** —
a re-bake recipe that can be re-run is worth more than the one clip it produces.

**The five Blender traps, already paid for:** 68 empties not an armature (rebuild from
`T_pose.fbx`); bind constrains SELECTED to ACTIVE so the clip-carrying rig must be active; the
add-on's bake makes no action while reporting FINISHED; import Tripo GLBs with
`bone_heuristic="TEMPERANCE"`; `Bone.select` is gone in Blender 5, use `bpy.ops.pose.select_all`.

## REPORT

- **Did an asset-level re-bake fix the contacts?** Numbers, not impressions.
- **Is the re-bake scriptable and repeatable**, or does each clip need hands? That decides whether
  the other 15 pairs are cheap or expensive.
- **BJJ coverage after:** beats / named clips / honest degrades, and a fresh recording.

## NOT YOURS

- **NO ENGINE EDITS.** Report them. BJJ showing 0 of 144 is my calibration moving the bout.
- **NO SPENDING**, **NO HAND-AUTHORED HOLDS**, **NO FULL SUITE**, **NO REBASE** — I merge.

## GATES

```
GODOT_EXE=%CD%\.godotbin\Godot_v4.7.2-stable_win64_console.exe
python Godot/tools/check_scripts.py <touched .gd>
python Godot/tools/run_tests.py --only c134   (then --only clip, --only grapple, --only pair, --only stage)
```

Ceilings: c134 fails=0; clip fails=0; grapple fails=1 or better; pair fails=1 or better
(`fight_pair_live` PARKED, operator's 2026-09-15 ruling); stage fails=1 or better.

Commit after each step. `.c134/` never committed. Stage explicit paths, then
`git show --stat HEAD`; unstage `AgentComms/messages`. Push
`codex/c134-bjj-presentation`, write `research/C136_REBAKED_PAIRS.md`, send
`python Tools/agent_comms.py send --from codex --to claude "C136 ready"`. Do not edit `HANDOFF.md`.
