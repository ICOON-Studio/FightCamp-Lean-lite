# K42 — KALLI — ROKOKO STUDIO LIVE FOR BLENDER: CAN WE RETARGET WITH IT, HEADLESS, ON BLENDER 5.2?

> Delivered by Kalli in its Grok Bot chat on 2026-09-14, collected by Claude with `grokbots.py read --to Kalli`.
> Tab-separated tables kept as Kalli wrote them. Task: `research/TASK_K42.md`.
>
> **Claude's reading:** skip it for the bake-off. The stable plugin (v1.4.3) breaks on Blender 5 (no `Action.fcurves`),
> a fix PR is unmerged; retargeting needs a one-time Rokoko login inside Blender (a website sign-in does not carry
> over); its bake is UI-heavy; and it is the same class of retarget as the Blender Retarget add-on already installed.

## DECISIONS
Blender 5.2: NO on stable 1.4.3; YES only via Beta (users confirm 5.0/5.1 Mixamo retarget). 5.2.1 specifically: NOT FOUND.
Login for retargeting: YES, ONE-TIME (Fernet-encrypted cache, max 90 days; then re-login). Free/Starter OK; not premium-gated.
Headless: PARTLY — rsl.build_bone_list / rsl.retarget_animation exist, but bake uses UI-heavy bpy.ops (nla.bake, mode switches, progress bar); login/browser path blocks pure CI without a prior cache.
Leaves the machine: Login + MixPanel session events (not the FBX clips). Retarget bake itself is local.
Bake-off worth? Low priority / skip next to Blender’s Retarget — same class (name map + copy-rotation bake + auto-scale), login tax, unstable on 5.x stable.
1. Where to get it
Item	Finding	Label	Source
Official source	GitHub: Rokoko/rokoko-studio-live-blender. Install guide: support article.	DOCUMENTED	GitHub + Rokoko Support
Latest stable	v1.4.3, published 2025-09-11 (published_at 08:44:49Z). Tag v1-4-3. Changelog: GQL library fix.	DOCUMENTED	GitHub Releases; API latest
File name / size	Download: https://github.com/Rokoko/rokoko-studio-live-blender/archive/refs/tags/v1-4-3.zip (GitHub zipball). Measured 96.0 KiB (98275 bytes).	DOCUMENTED	Release body + zip measure
Licence	Repo LICENSE.md = GNU LGPL v3. README badge also says “MIT” — badge contradicts file; treat LGPL-3.0 as authoritative.	DOCUMENTED	LICENSE.md; README badge mismatch = SECONDARY noise
Blender 5.0–5.2	Stable 1.4.3 breaks on Blender 5: Action has no .fcurves (#131, #135). Maintainer pushed Beta (Preferences → Install Beta Version); users report retarget OK on 5.0. Still broken on 5.1.1 for people on stable (Jul 2026). Open PR #141 (Aug 2026) for slotted Actions / PoseBone select — not merged as a tagged release. version_compatibility.json: 1.4.2 maximum_blender: null (no upper cap listed); no 5.2 row.	DOCUMENTED	Issues #131/#135; PR #141; version_compatibility.json

bl_info: 'version': (1, 4, 3), 'blender': (2, 80, 0) — no hard max in __init__.py.

2. Login
Finding	Label	Source
Retargeting is not a premium Studio feature	DOCUMENTED	Support: “retargeting feature is not a paid feature and does not need a premium account” — Retarget in Blender
Account login is required to see the Retargeting panel	DOCUMENTED	__init__.py: RetargetingPanel is in classes_logged_in only. Logged-out UI = Login + Updater + Info. Maintainer: “we won’t remove the login” — #43
How login works	Browser OAuth to id.rokoko.com/?request_id=…; GraphQL/AppSync (rmp-gql-public.rokoko.com, AWS AppSync US-East). Install guide: “Sign in via the Rokoko ID panel.”	DOCUMENTED
Saved token?	Yes. LoginCache writes encrypted .cache under add-on resources/cache/ (Fernet). Valid ≤ 90 days, then “Login expired”; auto_login() + silent Cognito refresh on startup.	DOCUMENTED
3. Headless / scriptable
Finding	Label	Source
Operator IDs	rsl.build_bone_list, rsl.add_bone_list_item, rsl.clear_bone_list, rsl.retarget_animation	DOCUMENTED
Scene props	rsl_retargeting_armature_source, _target, _auto_scaling, _use_pose (REST/CURRENT), _bone_list	DOCUMENTED
Headless fitness	Retarget execute calls bpy.ops.object.mode_set, duplicate_move, transform_apply, bpy.ops.nla.bake, window_manager.progress_*, edit/pose mode bone rebuild. These often need a valid 3D View / non-background context. No official blender --background recipe.	DOCUMENTED (ops list); NOT FOUND (official headless guide)
Login in CI	First run needs browser login + libs install; after cache exists, auto_login() can refresh without UI — still talks to Cognito.	DOCUMENTED

Verdict: scriptable in principle after login cache; not a clean headless bake tool.

4. Quality (beyond name map?)
Finding	Label	Source
What it does	(1) Auto bone-name detection + editable list / custom schemes. (2) Optional Auto Scale (height from root→lowest mapped bone Z). (3) REST or CURRENT pose for alignment. (4) Rebuilds target-shaped bones under source, Copy Rotation (+ Copy Location on animated roots), then bake.	DOCUMENTED
Not Unreal IK Retargeter	No chain IK, no foot-plant solver, no retarget pose asset like UE. Docs tip: if feet go through floor / hips stick, disable Auto Scale or use Current pose.	DOCUMENTED
Vs Blender Retarget / Expy / UE IK Retargeter	Published bake-off numbers or quality study: NOT FOUND. Community fork webaverse/blender-retargeter strips Rokoko login and keeps the same retarget module (implies retarget ≠ Studio stream).	NOT FOUND (comparison); SECONDARY (fork)
5. Data leaving the machine
Finding	Label	Source
Retarget of local FBX	Bake path is local Blender ops — no upload of animation curves in retargeting.py.	DOCUMENTED
Does leave machine	(1) Login GraphQL + AppSync websocket. (2) MixPanel session_start / session_end with blender_version, plugin_version, distinct_id (username), session duration — not clip contents. (3) Install Libraries downloads Python deps. (4) Live stream is UDP to Studio (local network), separate from retarget.	DOCUMENTED
Studio cloud ToS	Separate from this plugin; Studio sync/AI ToS is out of scope for local Blender retarget (held in K41).	—
GAPS
No tagged release proving Blender 5.2.1 (only Beta anecdotes for 5.0).
No headless CI example.
No quality bake-off vs official Retarget extension.

Claude can collect as research/K42_ROKOKO_BLENDER_RETARGET.md. Kalli pushes nothing.
