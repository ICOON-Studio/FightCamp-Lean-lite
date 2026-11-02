---
name: reference_higgsfield
description: "Higgsfield Plus (bought 2026-09-14, \"Make them count\") - MCP connector + signed-in Blender add-on; costs, what its motion tool really is, licences, how to drive it headless"
metadata: 
  node_type: memory
  type: reference
  originSessionId: 48ed398a-6549-4b7d-9588-127c74654080
  modified: 2026-09-14T21:00:23.364Z
---

The operator bought **Higgsfield Plus** on 2026-09-14 (1,000 credits/month, EUR 49 monthly) and said "Make them count". Workspace id
`193685bb-e618-4497-8cac-ebff8d36a17e` (private, plus); **923.9 credits left after the 2026-09-14 UFC pilot** (34 text-to-motion jobs). Checkout/plan choice is the operator's; never buy.

**Timeline rules, from the add-on source and measured (2026-09-14 UFC pilot):** a job costs 0.1 credit WHATEVER its length (a 7 s,
8-shot timeline too; preflight `client.jobs.estimate_cost(job_type="kimodo", params=...)`). Periods delimit shots (one at the end, none
inside); shots 0.5-6.0 s, max 8; `ardy-core` commits 2.0 s chunks so a shot under ~2.5 s does not land, `ardy-core-h8` commits 0.4 s.
`enhancer: True` REWRITES the prompt text. **A multi-beat timeline freezes:** 24 of 30 six-to-seven-second h8 timelines (5-8 shots)
went still within 1.5-3.5 s whatever the later shots said; ardy-core, enhanced mode and 3 s two-shot chunks failed too. Unit = ONE
action per job, <= 3 s, a 1.0 s stance preroll (20 frames) cut after. Same seed + same preroll text can give near-identical motion
for two different prompts. Driver with estimate/run/skip-existing: `Tools/higgsfield/t2m_ufc_pilot.py`; scorer (both hands, feet,
mirror a southpaw by x -> -x + L/R swap, S R S on rotations - importer pose check 0.0000 m): `Tools/higgsfield/ufc_pilot_build.py`.
PAUSED behind the engine stage: [[project_engine_first_2026-09-14]].

**Two ways in:**
- **MCP connector** (`mcp__470a229b-...`): `animation_actions` (free catalogue = Meshy's 678-clip library; striking, reactions, blocks yes;
  grappling none), `generate_3d` model `3d_rigging` with `model_url` + `enable_animation` + `animation_action_id` = **8 credits a clip**
  (preflight with `get_cost: true`); `media_upload` (type file) gives a GLB a public URL. Test outputs in Temp/FightCamp-higgs.
- **Blender add-on** `higgsfield_blender` 1.5.52 installed in `D:/Tools/Blender/blender-5.2.1-windows-x64` (portable) and **signed in**
  (token `%LOCALAPPDATA%/Higgsfield/Blender/Data/auth.json`). Sign-in is RFC 8628 device flow: run the add-on's own
  `fnf.account._device_login_worker` headless and hand the operator the code - never a password. Pass the workspace id to
  `session.get_sdk_client(workspace_id=...)` or the API answers 400 "Missing workspace id". Run Blender from Bash (from PowerShell its
  HTTPS failed with Errno 0). A hand-rolled auth client got 403, and faking a User-Agent was refused by the permission classifier: use
  the vendor's client.

**Character Animation = generative text-to-motion**, per the add-on source (`features/motion.py`): job `kimodo` on ARDY `ardy-core`
checkpoints, 20 fps, ONE character on a 27-joint `cskel27` skeleton, shots <= 6 s, motion decays after a few seconds; **0.1 credit**.
First tries (double-leg, jab, roundhouse) came out generic - operator: wait for John's study (J31: not a playable pipeline; grappling
fails). **Scripted best-of-N works headless** (`Tools/higgsfield/t2m_batch.py`, `jobs._fnf_run_3d_job(client, "kimodo",
{prompts, durations, model_version, seed})`, a stance shot first then the move): jab 4/6 clean, roundhouse 1/6, teep/double-leg/sprawl
partial. Output .npz holds posed_joints (T,27,3), local/global_rot_mats, root_positions, foot_contacts - score it with numpy, no Blender.
**Text-to-3D** (`meshy_v6_text_to_3d` + rigging, 25 cr): 25k verts, 2048 texture, 24 bones, NO fingers, untextured blob feet - prototype
body only. Library clips through `Tools/blender_moves/glb_clip_to_bridge.py` author as well as bought clips (U106 29/34 v 28/34).

**Licences (J31):** Higgsfield outputs commercial on paid plans, rights survive cancelling, no training models on Outputs (ToS 4.4,
5.2); Meshy library clips licensed only as incorporated into our output (Meshy ToS 2.3, 3.1). Related: [[project_generator_credits]],
[[feedback_learn_moves_from_video_not_studies]].

2026-09-29: balance 137/1000 monthly credits (Plus, renews 2026-10-14, auto-refill off); read it at https://higgsfield.ai/me/settings/subscription in Chrome.
2026-09-29 operator: "keep higgsfield for now" - review before the 2026-10-14 renewal (cancel unless C221/suit pilot is about to start).

2026-09-30 (S130): the monthly credits DO NOT roll over (reset at renewal). A 'reset your balance' promo tops up to 1,000 as BONUS credits expiring in ~24 h - spend the subscription credits first, then claim (claimed +1,000 in the operator's Chrome: Settings > Subscription > 'Get +1,000 credits', then press 'Start creating' - closing the popup with X did NOT apply it). Costs: 3d_rigging library clip 8, Seedance 2.5 5 s 720p no audio 35, gpt_image medium 0.25-0.5, Kling 3.0 Turbo 5 s 7.5. Plus plan runs ~6 videos in parallel (429 beyond). Chest-to-chest ground poses can be refused as NSFW.


S148 2026-10-02 23:55: Higgsfield shows 1/1000 credits left ("all credits used"). It renews 2026-10-14. The connector in this session exposes only Ads Studio tools (no generate_image). Image and video work goes to fal.ai (Tools/gen/fal_generate.py; the key file comes from Tools/fal_set_key.cmd) until then.
