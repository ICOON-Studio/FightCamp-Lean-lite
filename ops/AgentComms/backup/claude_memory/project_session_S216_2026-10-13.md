---
name: project-session-s216
description: "S216 - 115 Mixamo clips baked + merged, Ludo r48/r49 verdicts approved, 3 runs in flight (Arena MIXAMO1C, Qwen NIGHTLY5B FIX1, cloud Cursor RECOVERY1A), router disabled"
metadata:
  node_type: memory
  type: project
  originSessionId: 3467303b-2aab-40d0-b07e-019d836560b4
  modified: 2026-10-13T00:39:59.471Z
---

Operator asked why the 115 Mixamo clips (S215) were not in the game: they were downloaded last and no retarget task existed; the fight only plays
MetaHuman-skeleton clips. S216 work (state in AgentComms/roadmap.json `now.next_action`, which names every run and who owns it):
- MIXAMO1A merged 6bfe257a (PR #141, cloud Cursor): `assets/anim/mixamo_s215/mh/*.res` 115 bakes + `assets/data/mixamo_s215_catalogue.json`
  (107 PASS / 8 FAIL with reasons) + `tests/mixamo_s215_test.gd`. Cloud Cursor pushes the branch but CANNOT open the PR (Actions not permitted): `gh pr create` yourself.
- Ludo r48 (115 clips -> fight events): verbatim `LUDO_ROUND48_REPLY*_S216.txt`, verdict `LUDO_ROUND48_VERDICT_S216.md`, tags `assets/data/mixamo_s215_ludo_tags.json`.
  Operator override in chat "do what ludo suggests": 9 blocks, corner rest #115, liver two-stage in; engine mechanics NUMBERS from Ludo still out.
  Ludo's reply ceiling ~29.7k chars/message (then "continue"). Next Mixamo batch (southpaw, clinch, 8-count...) needs his Mixamo sign-in.
- MIXAMO1C (Arena, pure HitReactionPick) running; MIXAMO1B (wire into the fight behind `mixamo_reactions`, Codex) waits on it.
- Ludo r49 (9 stats from another game): add NO core stats; add RECOVERY RATE + CUT & SWELL RESISTANCE readouts; verdict `LUDO_ROUND49_VERDICT_S216.md`; approved Q-S212-7;
  RECOVERY1A on cloud Cursor issue #142. Our heart rate is READ from the stamina tank (Cardio.from_stamina), not its own state: Recovery Rate must multiply `FightStamina._recover_scale` (= conditioning/50) with factor(50) == 1.0.
- NIGHTLY5B: Qwen found face_drawn_foe red = separation_strip_velocity; its hard fallback snaps facing at 90 deg -> FIX1 smooths it.
- Traps: Brave extension blocks the tab after navigating to the 127.0.0.1:8799 receiver (use the built-in pane to save, then restart the receiver - it is single-threaded);
  receiver now writes to E:/FightCamp/tmp/ludo_s216; Arena sandbox cannot download Godot (it builds it from source - let it).
Related: [[feedback_router_off_and_no_remembered_numbers]], [[reference_ludo_ai]].
