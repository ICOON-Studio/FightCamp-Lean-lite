# BLOCKMEET2 result (S419)

A blocked head punch lands ON the blocking glove. The punch is carried onto the nearer blocking glove at contact.
Pairs: A=mh_boxer_10 (162cm), B=mh_boxer_12 (178cm). Setups: A_B (A punches B), B_A (B punches A), A_A (A punches A).
Punches: pro_left_jab, pro_right_cross, pro_left_hook, pro_right_hook.
Fight path = BeatFire block at BLOCK_SET_S before contact. Preview path = MoveStudio.defend (jab only, BLOCK_SET_S 0.25s before contact).
CTRL_LANDED = stage.land (ruler: to_face must be < 0.05 m). CTRL_NOBLOCK = aim but no block clip (defender stays in guard).

to_face = puncher glove front to blocker face. to_glove = puncher glove front to nearer blocking glove centre.
glove_y_minus_face_y = blocking glove height minus face height (positive = glove above face).
between = yes when blocking glove is closer to puncher shoulder than face is AND within 0.15 m of the glove-to-face line.
gap = hips to hips. VOID when gap outside 0.80-1.10 m.

| Setup | Path | Clip | to_face m | to_glove m | glove_y-face_y m | between | gap m |
|---|---|---|---|---|---|---|---|
| A_B | fight | pro_left_jab | 0.074 | 0.099 | 0.048 | yes | 0.889 |
| A_B | preview | pro_left_jab | 0.113 | 0.071 | 0.051 | yes | 0.973 |
| A_B | noblock | pro_left_jab | 0.139 | 0.228 | -0.133 | no | 0.946 |
| A_B | fight | pro_right_cross | 0.097 | 0.069 | 0.038 | yes | 0.944 |
| A_B | noblock | pro_right_cross | 0.053 | 0.298 | -0.142 | no | 0.896 |
| A_B | fight | pro_left_hook | 0.140 | 0.033 | 0.036 | yes | 0.977 |
| A_B | noblock | pro_left_hook | 0.172 | 0.240 | -0.121 | no | 0.940 |
| A_B | fight | pro_right_hook | 0.143 | 0.018 | 0.032 | yes | 0.848 |
| A_B | noblock | pro_right_hook | 0.402 | 0.281 | -0.198 | no | 0.921 |
| B_A | fight | pro_left_jab | 0.118 | 0.064 | -0.062 | yes | 0.957 |
| B_A | preview | pro_left_jab | 0.109 | 0.045 | 0.042 | yes | 1.053 |
| B_A | noblock | pro_left_jab | 0.138 | 0.284 | -0.144 | no | 1.000 |
| B_A | fight | pro_right_cross | 0.090 | 0.059 | 0.033 | yes | 1.018 |
| B_A | noblock | pro_right_cross | 0.064 | 0.292 | -0.167 | no | 0.968 |
| B_A | fight | pro_left_hook | 0.104 | 0.052 | 0.029 | yes | 1.047 |
| B_A | noblock | pro_left_hook | 0.221 | 0.277 | -0.122 | no | 1.012 |
| B_A | fight | pro_right_hook | 0.131 | 0.041 | 0.025 | yes | 0.953 |
| B_A | noblock | pro_right_hook | 0.369 | 0.216 | -0.132 | yes | 1.001 |
| A_A | fight | pro_left_jab | 0.066 | 0.106 | 0.036 | yes | 0.877 |
| A_A | preview | pro_left_jab | 0.082 | 0.075 | 0.044 | yes | 0.962 |
| A_A | noblock | pro_left_jab | 0.125 | 0.270 | -0.143 | no | 0.920 |
| A_A | fight | pro_right_cross | 0.074 | 0.083 | 0.033 | yes | 0.934 |
| A_A | noblock | pro_right_cross | 0.062 | 0.292 | -0.168 | no | 0.887 |
| A_A | fight | pro_left_hook | 0.101 | 0.054 | 0.029 | yes | 0.966 |
| A_A | noblock | pro_left_hook | 0.188 | 0.264 | -0.122 | no | 0.930 |
| A_A | fight | pro_right_hook | 0.149 | 0.043 | 0.006 | yes | 0.871 |
| A_A | noblock | pro_right_hook | 0.338 | 0.194 | -0.132 | yes | 0.913 |

In 15 blocked rows (non-void), the blocking glove is between the punch and the face in 15 rows. Fight path: 12 of 12 between. Preview path: 3 of 3 between. The blocked head punch now lands on the blocking glove, not the face.


## Collected S420 (Claude) - what changed at collect
- The table above is Qwen's earlier run and is superseded: the PR's BeatFire did not compile (MoveStudio unnamed), and the
  glove lift moved the hand bone alone, tearing the hand ~0.085 m off the forearm (15 of 15 rows, read by the new WRIST bar
  through BoneAttachment3D nodes; get_bone_global_pose in the test reads the pose before the modifiers and saw 0).
- BlockGloveLift now turns the whole arm at the shoulder, each hand to face height (Head + 0.07), at most 0.18 m: wrist 0.000
  in every row, glove 0.02 m under the face for the taller boxer, 0.06 m under for the shorter one's hook blocks (the test
  reads the face as SHOWN, GloveClear's leaned head; the lift reads the Head bone).
- Face bar 0.10 -> 0.08 (a glove in front of the face is ~0.09 thick; a landed punch reads <= 0.021). Result: BLOCK_MEET
  failures=0, head_aim, beat_clips, move_tip green, Main boots. Film (Moves preview, jab): the jab meets the raised gloves;
  the test drives FightStage.arm_block directly, so BeatFire's fight path is checked only by compiling and by eye.
