# K40 — KALLI — WHICH FREE UNITY TOOLS COULD FIX OUR RETARGETING AND ANIMATION, AND STILL LAND IN GODOT?

> Delivered by Kalli in its Grok Bot chat on 2026-09-14, collected by Claude with `grokbots.py read --to Kalli`.
> Tab-separated tables kept as Kalli wrote them. Task: `research/TASK_K40.md`.
>
> **Claude's reading:** the answer to the operator's question is that no FREE Unity tool beats a Blender or Godot
> route for our Tripo fighters. Unity's Humanoid retarget reaches a file only through the Recorder (Generic FBX, with
> reported dropped frames), and Animation Rigging cannot bake onto a Humanoid. UMotion Pro is the one Unity tool that
> plants feet AND writes FBX on the destination skeleton, and it is paid and hands-on. Animancer and AnimFuse cannot
> produce a Godot-importable file. Worth following up: K40 names Godot's own BoneMap/SkeletonProfileHumanoid retarget
> and Blender's free Rokoko retarget as the routes to compare against our GDScript retargeter.

## DECISIONS
Best free Unity bake path: Mecanim Humanoid retarget onto each Tripo fighter → Play Mode Recorder + FBX Exporter → Generic FBX. Biggest risk: Humanoid clips won’t export directly; feet still slide when proportions differ; Godot may need BoneMap / axis fix.
Free foot-plant bake: Animation Rigging Two-Bone IK → Transfer motion to skeleton → FBX — only on Generic, not Humanoid. Biggest risk: converting Humanoid mocap → Generic before IK bake is a second quality cliff.
Honest call: No free Unity Asset Store tool clearly beats Blender (Rokoko free + Expy Kit / Retarget fork) → glTF, or Godot 4 BoneMap + SkeletonProfileHumanoid, for your “painful to watch” Tripo retarget. The Unity tool that does match plant-feet + FBX-on-destination-skeleton is UMotion Pro (paid).

Labels: DOCUMENTED = tool page / Unity docs; SECONDARY = forums; NOT FOUND = no cite.

1. Unity’s own free packages (Package Manager)
Tool	Finding	BAKE?	Label	Source
Mecanim Humanoid / Avatar (Unity)	Retargets Humanoid clips across configured Avatars via muscle space; Avatar Muscle / Foot IK / Hand IK on Animator	ONLY WITH Recorder or Timeline+FBX path (direct FBX Exporter does not export Humanoid). Output is typically Generic bone curves.	DOCUMENTED	Retarget Humanoid animations; FBX Exporter notes below
FBX Exporter com.unity.formats.fbx	Exports Model/Animation to FBX; Humanoid rigs not supported for direct animation export; Legacy/Generic OK; Timeline “Export Clip to FBX” same limit	YES for Generic/Legacy; NO for raw Humanoid .anim	DOCUMENTED	Unity Discussions Nov 2024: “FBXExport doesnt support convert Humanoid w/ clips to FBX directly” — thread; package manuals 4.x/5.x
Recorder com.unity.recorder (+ FBX Exporter)	Play-mode FBX Recorder / Timeline Recorder Track samples live GameObject transforms (hierarchy) to FBX	YES — this is the documented Humanoid→file workaround. Risk: wrong frame count / sped-up playback reported	DOCUMENTED	Record FBX via Timeline Recorder Track; FBX Recorder properties; Discussions incomplete-frame reports
Animation Rigging com.unity.animation.rigging	Constraints (Two Bone IK, Multi-Parent, etc.); Bidirectional Motion Transfer bakes constraint result onto skeleton	YES on Generic via Transfer motion to skeleton / BakeUtils; Humanoid bake unsupported	DOCUMENTED	Bidirectional Motion Transfer; staff: “we had to disable Bidirectional baking for humanoid” — Discussions
Timeline	Author blends/transitions; can drive Animator for recording	ONLY WITH FBX Exporter / Recorder to bake evaluated motion	DOCUMENTED	Package docs + bake-Timeline Discussions
Licence	Unity Companion License / Package Manager packages	—	DOCUMENTED	Package Manager licence text

Retarget quality (Mecanim): Uses Unity Humanoid underneath. Known artefacts: foot slide / hand miss when limb proportions differ unless Foot/Hand IK enabled at runtime; Muscle settings tweak stretch. Foot IK is evaluation, not stored in the Humanoid clip — baking requires recording the evaluated pose (Recorder) or a baker that writes FK. SECONDARY: Final IK docs describe baking Humanoid Foot IK out for mobile (paid Final IK — mention only as evidence that Foot IK isn’t “in the clip”).

2. Free Asset Store + asked paid rows
Tool	Publisher / link / versions / update	What it does	BAKE?	Quality / licence	Label
IK Helper Tool	Kevin Iglesias — Asset Store 148408 — FREE; v1.0.2 9 Jun 2026; Unity 2022.3.50+; Store EULA	Runtime helper to fix misplaced hands/feet after Humanoid retarget	ONLY WITH Recorder/FBX if you record the corrected playback; not an offline baker by itself. Older forum post claimed deprecated — store page still lists FREE/updated	Runtime Mecanim IK helper; limited Animator graphs. Standard Unity Asset Store EULA	DOCUMENTED (store); SECONDARY (deprecate claim)
Animancer Lite	Kybernetik — docs download / itch — FREE; Unity 2022.3+ / 6000; Asset Store EULA	Runtime playback API (play any clip without Animator Controller)	NO — does not bake/export FBX/glTF. Pro (id 293522, ~EUR 82.80) is still a playback library, not a retarget baker	N/A for bake quality	DOCUMENTED
UMotion Community	Soxware — 95986 — FREE	In-Unity animation editor for new clips from scratch	.anim YES; FBX NO (Pro-only). Cannot import existing mocap to edit (Pro). No IK / IK Pinning	Create-only; reviews note Pro wall	DOCUMENTED
UMotion Pro (asked, paid)	Soxware — 95991 — ~EUR 64–70; Windows/Intel Mac FBX (M1 FBX not yet)	Import Humanoid mocap → edit on your character; IK Pinning, layers, Foot/Hand IK on import	YES — FBX (Pro). Assign destination humanoid to Pose Editor; Mecanim retargets on import; export Update Existing File or Export As New File with that skeleton. IK Pinning / override layers included in exported bone curves if keyed. Editor API: ExportCurrentClip / ExportAllClips / import — export settings path not fully scriptable (YAML hack). Hands-on for pose work; batch export possible via API	Euler FBX can gimbal; Humanoid Avatar match needs update-existing carefully. Godot/Blender import of UMotion FBX: general FBX pipeline applies; NOT FOUND a dedicated “UMotion→Godot broke X” case study beyond generic FBX issues	DOCUMENTED (manual + support); NOT FOUND (Godot-specific case study)
AnimFuse (asked, paid)	Finite Machine Studio — 393674 — ~EUR 18.39; Unity 6000.4 only	Body-part blend two Humanoid clips + pose edit → bake .anim	ONLY WITH Recorder/FBX Exporter (or 3rd-party AnimToFBX). Page: “FBX export is not included”. Path: bake .anim → play on Humanoid → FBX Recorder → Generic FBX	Same Humanoid→FBX risks (empty export, dropped frames). Store EULA	DOCUMENTED
Other free store “retarget bakers”	—	Dedicated free Humanoid baker like paid Retarget Pro	NOT FOUND as free (Retarget Pro / Humanoid Baker are paid)	—	NOT FOUND (free equivalent)

Ruled out (per brief): PromptMotion Lite and any text-to-motion — not listed as a recommendation.

3. Round trip: FBX in → Unity Humanoid → baked FBX out → Godot / Blender / Unreal
Finding	Number / rule	Label	Source
Humanoid .anim → FBX Exporter alone	Often “Nothing to Export” / no keys	DOCUMENTED	Unity Discussions Nov 2024
Workaround	Recorder FBX in Play mode; result is Generic, not Humanoid	DOCUMENTED	Same thread; Unity staff Timeline bake notes
Recorder pitfalls	Incomplete frame counts (e.g. 77 / 1200), sped-up scene playback while recording	SECONDARY	Same thread Aug 2025 follow-up
Animation Rigging Humanoid	Bidirectional bake disabled for Humanoid; staff suggest GameObjectRecorder → Generic → FBX	DOCUMENTED	BakeUtils thread
Godot 4 import of shared humanoid FBX/glTF	Use BoneMap + SkeletonProfileHumanoid; Overwrite Axis / Retarget Modifier; “Unimportant Positions” can strip stride; Fix Silhouette weak on bone roll	DOCUMENTED	Godot 4.7 retargeting docs; GH #96153
Common breakages	Scale / Apply Transform, bone roll, root/hips position tracks, twist bones not in Humanoid map	DOCUMENTED / SECONDARY	Godot docs + community Mixamo→Godot writeups
4. Free non-Unity comparison (short rows)
Tool	Finding	BAKE / export	Label	Source
Rokoko Studio Blender plugin	Free retarget (no premium required for retarget feature)	Retarget in Blender → export FBX/glTF for Godot	DOCUMENTED	Rokoko support
Expy Kit / Retarget fork	Free Mixamo↔Rigify / preset retarget; Retarget fork = Blender 5+	Bake action on target armature → glTF/FBX	DOCUMENTED	BlenderNation Expy Kit; extensions.blender.org/retarget (GPLv3)
Auto-Rig Pro	Remap retarget is in paid full package; free trial character only — no free Remap	Paid	DOCUMENTED	Blender Market
Godot 4.x	BoneMap, SkeletonProfileHumanoid, import retarget options; later 4.x Retarget Modifier	Native share between mapped humanoids — no Unity	DOCUMENTED	Godot docs above; engine article
GAPS
No free Asset Store tool that both plants feet with IK and writes FBX without Recorder gymnastics.
No published Tripo / single-mesh → Mecanim → Godot bake quality study.
UMotion→Godot specific breakage report: NOT FOUND.
IK Helper Tool: bake pipeline undocumented; deprecate vs store listing conflict.

Bottom line for FightCamp: Use free Unity only as a recorder oven (Mecanim retarget + FBX Recorder). For real retarget quality on Tripo bodies, prefer Blender free retarget → glTF or Godot BoneMap first; buy UMotion Pro only if you want planted-foot edits and FBX out of Unity on the destination skeleton.

Claude can collect as research/K40_FREE_UNITY_ANIMATION_TOOLS.md. Kalli pushes nothing.
