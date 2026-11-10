# BLOCKMEET1 result (S418)

Does a blocked punch meet the blocking glove? Measure only, no fix.
Pairs: A=mh_boxer_10 (162cm), B=mh_boxer_12 (178cm). Setups: A_B (A punches B), B_A (B punches A), A_A (A punches A).
Punches: pro_left_jab, pro_right_cross, pro_left_hook, pro_right_hook.
Fight path = BeatFire block at contact*0.8. Preview path = MoveStudio.defend (jab only, BLOCK_SET_S 0.25s before contact).
CTRL_LANDED = stage.land (ruler: to_face must be < 0.05 m). CTRL_NOBLOCK = aim but no block clip (defender stays in guard).

to_face = puncher glove front to blocker face. to_glove = puncher glove front to nearer blocking glove centre.
glove_y_minus_face_y = blocking glove height minus face height (positive = glove above face).
between = yes when blocking glove is closer to puncher shoulder than face is AND within 0.15 m of the glove-to-face line.
gap = hips to hips. VOID when gap outside 0.80-1.10 m.

| Setup | Path | Clip | to_face m | to_glove m | glove_y-face_y m | between | gap m |
|---|---|---|---|---|---|---|---|
| A_B | fight | pro_left_jab | 0.053 | 0.271 | -0.139 | no | 0.889 |
| A_B | preview | pro_left_jab | 0.064 | 0.191 | -0.057 | yes | 0.975 |
| A_B | noblock | pro_left_jab | 0.020 | 0.256 | -0.132 | no | 0.929 |
| A_B | fight | pro_right_cross | 0.021 | 0.256 | -0.134 | no | 0.932 |
| A_B | noblock | pro_right_cross | 0.102 | 0.281 | -0.126 | no | 0.896 |
| A_B | fight | pro_left_hook | 0.180 | 0.222 | -0.176 | no | 0.896 |
| A_B | noblock | pro_left_hook | 0.177 | 0.242 | -0.106 | no | 0.936 |
| A_B | fight | pro_right_hook | 0.269 | 0.157 | -0.175 | no | 0.950 |
| A_B | noblock | pro_right_hook | 0.338 | 0.177 | -0.117 | yes | 0.921 |
| B_A | fight | pro_left_jab | 0.104 | 0.310 | -0.111 | no | 0.957 |
| B_A | preview | pro_left_jab | 0.058 | 0.145 | -0.055 | yes | 1.050 |
| B_A | noblock | pro_left_jab | 0.243 | 0.245 | -0.058 | no | 1.007 |
| B_A | fight | pro_right_cross | 0.072 | 0.213 | -0.126 | no | 1.018 |
| B_A | noblock | pro_right_cross | 0.069 | 0.287 | -0.156 | no | 0.968 |
| B_A | fight | pro_left_hook | 0.228 | 0.169 | -0.194 | no | 1.047 |
| B_A | noblock | pro_left_hook | 0.239 | 0.272 | -0.106 | no | 1.013 |
| B_A | fight | pro_right_hook | 0.275 | 0.161 | -0.165 | no | 0.953 |
| B_A | noblock | pro_right_hook | 0.373 | 0.207 | -0.117 | yes | 1.001 |
| A_A | fight | pro_left_jab | 0.097 | 0.298 | -0.111 | no | 0.876 |
| A_A | preview | pro_left_jab | 0.073 | 0.177 | -0.060 | yes | 0.959 |
| A_A | noblock | pro_left_jab | 0.230 | 0.243 | -0.058 | no | 0.924 |
| A_A | fight | pro_right_cross | 0.073 | 0.217 | -0.126 | no | 0.934 |
| A_A | noblock | pro_right_cross | 0.063 | 0.287 | -0.156 | no | 0.887 |
| A_A | fight | pro_left_hook | 0.196 | 0.312 | -0.163 | no | 0.966 |
| A_A | noblock | pro_left_hook | 0.206 | 0.259 | -0.106 | no | 0.931 |
| A_A | fight | pro_right_hook | 0.243 | 0.145 | -0.165 | yes | 0.871 |
| A_A | noblock | pro_right_hook | 0.341 | 0.184 | -0.117 | yes | 0.913 |

In 15 blocked rows (non-void), the punch arrives nearer the face than a blocking glove in 11 rows. The blocking glove is between the punch and the face in 4 rows. Fight path: 1 of 12 between. Preview path: 3 of 3 between. The two paths differ.

