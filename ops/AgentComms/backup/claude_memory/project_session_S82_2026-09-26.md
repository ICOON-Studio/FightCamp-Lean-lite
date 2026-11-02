---
name: project-session-S82-2026-09-26
description: S82 2026-09-26 - HOME live pin counts + occupancy picture swap; nightly triage found the open-slot bout-0 defect; Mixamo clips downloaded via the browser pane on the operator's sign-in
metadata:
  type: project
---

S82 shipped HOME with state: `HomePinReads.gd` (one count per pin from the page's own GameState read; zero said in
words; amber badge only when there is something to act on - G109) and a sparse/working/packed picture swap
(`home_gym_bg_working.jpg`/`_packed.jpg`, gpt_image_2_5 edits made through the Higgsfield MCP: media_upload + curl PUT +
media_confirm, then generate_image_batch; ~0.25 credit each).

Nightly triage: `weight_cut` exposed a real defect - every booked-event read used the card's bout 0 instead of the
open-slot bout (fixed with `open_slot_bout_index`). Two stale tests fixed to rulings; `CapsuleCoverage.gd` written to its
G73 blind contract; neck reach assigned as C211.

Operator asked to "try mixamo": he signed in to mixamo.com in MY browser pane and approved four clips; browser-pane
downloads land in `C:\Users\user\Downloads` (a first Download click can fire twice). Clips live in
`assets/anim/mixamo_audition/` as a manifest candidate; C212 (Codex) auditions them. Blender was never connected to the
Higgsfield bridge (get_host_status all false) - the add-on must be enabled in Blender to drive it.

**Why:** next session owns Q184, U178, C212 in flight and builds S83 (rooms, media hire, scouting file) from G110.
**How to apply:** collect those three before building; see [[project-session-S81-2026-09-26]] and [[feedback-no-popups]].

After S82 shipped, the operator and Claude designed the TRAINING FLOOR (TRAINING_LOOP_DESIGN.md, page https://claude.ai/artifact/EvCjFQjxSKjyMiRuUaDd5P): a big zoned scrollable 3D gym, doors as navigation (screen for depth, pop-up for quick checks), presets that grow, bought equipment shown accurately, a concept per room. Operator verdicts: the first ring-centred concept had "very [few] things visible"; wants real separated stations; said "training floor first, start with step 1 on next session" - S83 = show every training change on current screens. Google sign-in fails in the built-in browser pane; use Claude in Chrome for sites where he signs in with Google (Pinterest).
