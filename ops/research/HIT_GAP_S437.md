# Hit gap, three measures on one bout (S437, animation D0 step 2)

Tool: tools/hit_gap_probe.gd, 150 s of the women's test bout on the hidden desktop, 32 landed punches each time (the bout
is the same every run; the logs are E:/FightCamp/tmp/s437_gap/*.txt, not kept in the repo).

| Contact data | p50 m | p90 m | max m | landed off by > 0.15 m |
|---|---|---|---|---|
| main (no short_m) | 0.036 | 0.093 | 0.254 | 3 (lead hook, jab, body hook) |
| main + short_m restored (tools/punch_reach.gd write=1) | 0.038 | 0.172 | 0.240 | 4 |
| re-measured file (CLIP_CONTACT_REMEASURED_S435), no short_m | 0.038 | 0.160 | 0.274 | 4 (lead hook x2, jab x2) |

Read:
- short_m does NOT help: FightStage.land no longer reads it (most rows are negative: the target is inside the arm at the
  jab gap). ANIM_AUDIT_S435 A5 is closed as "deleted".
- The re-measured file is in (58 rows; contact times within 0.03 s except pro_body_shot 0.583 -> 0.55 and
  pro_left_hook_hurt_ft 0.483 -> 0.40). The body hook went from one far hit (0.23 m) to none (max 0.07 m over 9). The
  rest is run-to-run spread: pro_left_jab_a, whose row did not change, read 0.20, 0.17 / 0.24 and 0.22 / 0.27 m.
- The punches that land off are NOT short: lead hook (pro_left_hook) about 0.21 m to the side at pelvis gap 0.84 m; jab
  (pro_left_jab_a) 0.15 to 0.26 m LOW at 0.84 to 0.95 m. Reach weight 1.00 on all of them, 5 to 62 glove pushes
  (GloveClear) in the bout. That is REACH1 / CONTACT1's bar: these two clips at these gaps, glove to face under 0.10 m.
- The probe is one bout of 32 punches and the same data moves p90 by 0.07 m: it can show a clip fixed (body hook), it
  cannot rank two files. The frozen real-bout ruler (D0 step 5) must run the bout several times and report the spread.
- block_meet_test after the change: 2 red rows, both the rear hook into the blocking glove (A_B 3.4 cm, A_A 3.0 cm at
  the 3.0 bar; S436 read 3.3 and one row). Its contact row did not change: the same known fault, CONTACT1's first target.
