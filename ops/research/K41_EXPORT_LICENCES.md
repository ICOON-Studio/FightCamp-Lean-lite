# K41 — KALLI — CAN ANIMATION WE RETARGET IN UNREAL, CASCADEUR OR ROKOKO SHIP IN A GODOT GAME?

> Delivered by Kalli in its Grok Bot chat on 2026-09-14, collected by Claude with `grokbots.py read --to Kalli`.
> Tab-separated tables kept as Kalli wrote them. Task: `research/TASK_K41.md`.
>
> **Claude's reading:** an Unreal-exported retarget of OUR mesh and OUR licensed clips ships in a Godot game as a
> royalty-free Non-Engine Product (the EULA names character models and animations explicitly) - never with Epic
> mannequin assets inside. Cascadeur Free cannot ship anything (non-commercial, `.casc` only); Indie exports FBX but
> retargeting is Pro-only. Its AI runs locally and it states it does not train on imports. DeepMotion Freemium and
> Move.ai are out for store mocap (non-commercial output, training grants). The operator installed Cascadeur and started
> its Pro trial on 2026-09-14 for Claude to evaluate.

## DECISIONS
Unreal export → Godot ship: YES WITH CONDITIONS — export FBX of your Tripo mesh + your (Unity-licensed) clips processed by Editor tools; ship as Non-Engine Product asset files (no Engine Code, no Starter/UE-Only Content in the file). No Epic royalty on that Non-Engine Product path.
Manny/Quinn as intermediate: YES WITH CONDITIONS — do not ship mannequin mesh, materials, or Epic skeleton/IK Rig assets. Prefer IK Rig built on your Tripo skeleton; if Manny is only a temporary bridge, bake onto Tripo and strip Epic content from the export.
Cascadeur free commercial: NO (Free = non-commercial + .casc only). Indie can sell under $100k/yr revenue and export FBX, but Animation Retargeting is Pro-only. AI tools run local; Nekki says they do not train on your imports.
Rokoko free commercial: YES via Blender plugin retarget (no premium). Studio Starter cannot import custom Tripo. Studio is cloud-sync (AWS) when used — Blender path keeps clips local if you never open them in Studio.

Labels: DOCUMENTED / SECONDARY / NOT FOUND.

1. Unreal Engine EULA
Q	Finding	Label	Source
Current EULA	Live text at unrealengine.com/eula/unreal. Change history: eula-change-log/unreal. Exact “last updated” calendar stamp on the HTML page: NOT FOUND in this pass (page fetch timed out; quotes from live search extract of that URL).	DOCUMENTED (URL + quote); NOT FOUND (precise date stamp)	Epic EULA pages
“Engine Tools”	EULA defines Engine Tools as editors/tools in Engine Code; Developer/Editor modules; software used to develop standalone products based on Licensed Technology. Public Distribution of Engine Tools is restricted (Fab / Epic GitHub fork). You are not shipping Engine Tools — only using them offline.	DOCUMENTED	EULA “Restrictions on Engine Tools” (search extract of same page); Unreal Containers summary
“Licensed Technology” vs Content	Licensed Technology ≠ Fab/marketplace Content. Content is under separate Epic Content License Agreement.	DOCUMENTED	unrealengine.com/eula/unreal extract
Ship processed assets in another engine?	Royalty-free Non-Engine Products: products that “(i) do not include any Engine Code, (ii) do not require any Engine Code to run and (iii) do not include Starter Content in source format.” Explicit example: “asset files, such as character models and animations, other than Starter Content, that you developed using Engine Code. Such asset files remain Non-Engine Products even if included in Products that use or rely on other video game engines.”	DOCUMENTED	Same EULA page extract; older forum paste of similar Non-Engine Product language UE forum
Royalty / notice	No royalty owed for Distributing Non-Engine Products under that royalty-free section. Royalty Addendum applies to Royalty Products (UE runtime games over thresholds), not this asset-export case. No Epic trademark notice requirement found specifically for exported third-party FBX.	DOCUMENTED (royalty carve-out); NOT FOUND (export notice clause)	EULA Non-Engine Products + Royalty Addendum extract
UE-Only / mannequins	Content EULA: “UE-Only Content means Licensed Content that is designated as only permitted for use in conjunction with Unreal Engine and Unreal Engine-based products…” EULA also: “certain assets … available for use only with Unreal Engine.” Forum consensus: default mannequin OK inside UE commercial games, not brought into another engine.	DOCUMENTED (UE-Only); SECONDARY (mannequin forum)	eula/content; mannequin commercial UE
Intermediate Manny taint?	NOT FOUND Epic staff Q&A that says “temporary IK Retargeter bridge then bake to your skeleton for Godot is fine.” Safe reading: export must contain your animation on your bones — no mannequin mesh/Starter Content in the Godot package.	NOT FOUND (staff blessing); DOCUMENTED (cannot ship Starter/UE-Only as Non-Engine)	—
Staff/forum: export retarget to Unity/Godot	Community cites Non-Engine Product asset-file language for other engines. Dedicated Epic staff “Godot FBX from IK Retargeter OK” thread: NOT FOUND.	SECONDARY	Forum thread above

Practical Unreal path for FightCamp: Import Unity FBX + Tripo FBX → IK Retargeter / Control Rig → export FBX of Tripo hierarchy only → Godot. Do not package Manny/Quinn assets.

2. Cascadeur (Nekki)
Topic	Finding	Label	Source
Plans / prices (as of this pass)	Free $0 — non-commercial; export .casc only. Indie ~$19/mo or ~$8–14/mo yearly — FBX/DAE (+ plans page also lists USD/GLTF for paid); revenue < $100k/yr. Pro ~$49/mo or ~$25–37/mo yearly — unlimited commercial + retargeting. Teams ~$33–49/user/mo.	DOCUMENTED	cascadeur.com/plans (fetched); FAQ (rev. note Oct 1, 2024)
Free commercial?	No. Plans FAQ: “Free and Educational plans don’t allow any commercial use.”	DOCUMENTED	Plans page FAQ
Export limits	Frame/joint caps removed since 2024.1 (blog FAQ). Free = no FBX. Indie/Pro: FBX/DAE/USD/(GLTF on plans matrix).	DOCUMENTED	Plans; licensing FAQ blog
Retargeting feature	Listed under Pro (“Animation retargeting”). Indie FAQ: retargeting / scene linking / env AutoPhysics unavailable on Indie.	DOCUMENTED	Plans + FAQ
Indie EULA quote	EULA §1.6 (via FAQ): Indie requires aggregate gross revenue/funding < US $100,000 in the twelve months ending on download and each renewal.	DOCUMENTED	FAQ quoting EULA; agreement
AI local vs upload	Official AI doc: tools “work on your local machine, without needing to connect to external servers.” (Video Mocap plugin downloaded once, then local.)	DOCUMENTED	Use Of AI Tools
Train on user content?	Same doc Q4: “No, Cascadeur doesn’t collect the animations you produce and/or import to use as a training data.” Trained on Nekki + licensed packs. EULA §7 describes assistive AI under user control.	DOCUMENTED	AI Tools page; cascadeur.com/agreement

Note vs Unity Store 2.2.1.1(g): Cascadeur says it does not train on your imports — lower conflict than cloud AI video services. Still: Free plan cannot ship commercially.

3. Rokoko
Topic	Finding	Label	Source
Account for Blender retarget?	Support: “the retargeting feature is not a paid feature and does not need a premium account.” Plans listed: Starter / Plus / Pro / Enterprise. Plugin install typically still uses a Rokoko login in practice — mandatory login for Blender-only retarget: not proven beyond “no premium.”	DOCUMENTED (no premium); NOT FOUND (zero-account)	Retarget in Blender
Studio free retarget to Tripo?	Starter: “Retarget to Character: Yes” but “Import custom Character: No.” Custom import/retarget = Plus+. Free Studio retarget = Rokoko default characters only — not your Tripo fighters.	DOCUMENTED	Plans explained; Retargeting Guide (Plus Pro Enterprise)
Free filters (foot lock, etc.)	Starter: “Motion capture clean-up w/ filters: Yes.” Product page lists foot locking, root locking, knee pop, etc. as Studio filters.	DOCUMENTED	Plans table; rokoko.com/products/studio
Cloud upload?	Studio is cloud-first: edits stored locally then synced to AWS (US-East-1 / EU-Central-1). Starter offline allowance 1 day. Enterprise marketing mentions local-storage options — Starter syncs. Blender plugin retarget of local FBX: no Studio cloud step if you never import clips into Studio.	DOCUMENTED (Studio sync); NOT FOUND (Blender plugin uploads FBX)	Support Offline Mode & Cloud Syncing (article cited in search; Cloudflare blocked raw fetch)
4. DeepMotion Animate 3D / Move.ai (one row each)
Tool	Free output licence	Training / upload terms	Label	Source
DeepMotion Animate 3D	Freemium: “exclusively for non-commercial purposes” (revocable Non-Commercial License). Commercial licence only on Paid Plans. Terms last updated March 30, 2025.	You keep ownership of uploads, but grant DeepMotion licences to “Process uploaded Content through machine learning models” and “for the sole purpose of improving the Site and services.” Credit-program labeling feeds their models. Uploading Unity Store mocap risks conflict with Asset Store EULA 2.2.1.1(g) (no AI training).	DOCUMENTED	animate-3d.com/terms-of-use; pricing FAQ
Move.ai (Move One)	Free: 30s video + 30 one-time credits (pricing docs). EULA Permitted Purpose includes importing Output into a “visualisation or ingestion engine”; clause 8 (ownership/licence to you of Output) does not apply to free accounts — paid terms kick in when you pay. Free commercial clarity is therefore weak.	§7.2: you grant Move AI a perpetual licence to use Video Data/Materials for “development, training and improvement of our products…” Cloud processing + training grant = high conflict with Unity Store 2.2.1.1(g).	DOCUMENTED	move.ai/move-one-eula
GAPS
Unreal HTML “last modified” date stamp not captured (fetch timeout).
No Epic staff answer specifically blessing “Manny as temporary IK bridge → Godot FBX.”
Rokoko Blender: whether a free Rokoko account is required (vs premium) not fully closed.
Move One free-account Output ownership vs paid clause 8: grey.

Operator takeaway: Prefer Unreal offline retarget → Tripo FBX (Non-Engine Product) or Rokoko Blender free retarget (local). Skip Cascadeur Free for ship; need Indie+ for FBX and Pro for retarget. Avoid DeepMotion Freemium and Move.ai for store mocap (non-commercial / training-upload conflict with Unity EULA).

Claude can collect as research/K41_EXPORT_LICENCES.md. Kalli pushes nothing.
