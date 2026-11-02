# LUDO ROUND 50 VERDICT (S217) - the rejected lead body hook (operator: "wtf is that"; "ask ludo if in unsure how to proceed")
Reply: LUDO_ROUND50_REPLY_S217.txt (27,516 chars, one message). Claude's verdict, for Codex TASK_ANIMSOURCE1D_FIX2.

TAKEN as the spec (numbers are acceptance bands, measured per frame on the skinned bodies / MetaHuman bones):
- Spacing (A): chest(spine_03)-to-chest horizontal 78±4 cm guard, 66±3 at the dip, 52±2.5 at contact, 53±2.5 follow-through,
  78±4 reset; hard fail < 48 cm on any frame. Lead toe-to-toe 54/44/36/36/54 cm. Skin gap (non-glove vertices) >= 5 cm at contact,
  >= 16 cm at the dip, >= 28 cm in guard. Attacker head 14-18 cm to his left and 10-12.5 cm down at the dip - no centre-line lunge.
- Facing (B): attacker head forward within ±8 deg yaw of the line to the receiver, pitch -12..-16 deg; receiver within ±6 deg
  (unseen) / ±4 deg (read) - his head NEVER turns away before contact. Shoulder-line yaw vs the pelvis-to-pelvis line: attacker
  +42 guard / +52 dip / +12..16 contact / -6 follow-through; receiver -38 guard / -22..-26 at contact. Neck counter-rotates.
- Wrists (C): forearm(lowerarm->hand) vs hand(hand->middle_01) <= 2.5 deg from 0.200 to 0.333 s; guard flexion 0±3, deviation 0±2.
  Guard roll: lead glove ~45 deg semi-pronated, rear glove 75-85 deg palm to own jaw; glove-to-face gap 4-6 cm, top edge at the
  cheekbone. Hook at contact: VERTICAL fist (thumb up, roll 85-95 deg), elbow 88-94 deg; rear glove within 2-3.5 cm of the jaw,
  no >15 deg roll drift frames 4-12.
- Key table (D) is the authoring target for the hook (frames 0,2,4,6,8,10,13,16,20).
- Checklist (E) items 1-10 become automatic gates (Codex: start with 1, 2, 3, 4, 5, 9 - the three defects + rear hand + roll + neck).
- Palette (F.1): ONE canonical orthodox high-guard pose; frames 0 and last of every one of the 22 clips locked to it.

NOT TAKEN / CORRECTED:
- F.2 "Range 1 outside/jab 145-165 cm chest-to-chest": physically wrong - shoulder-to-glove reach is ~70-80 cm, so a jab from
  145+ cm chest-to-chest cannot land. Codex measures jab/cross range bands from the real-footage landmarks in CODEX_TOOLKIT
  and reports them; the pocket band (48-56 cm) is kept.
- F.1 hand anchors "Y +152 cm relative to pelvis origin": read as height above the FLOOR (pelvis is ~100 cm high); X/Z relative to
  the pelvis. Use the guard's measured cheekbone height of each body instead of fixed numbers (bodies differ in height).
- "Compute shader 6,800-vertex hull": any per-frame skinned-mesh distance test is fine; it must be red on f7b7080c.
