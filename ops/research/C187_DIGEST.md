# C187 - pelvis layer joins and the fist ceiling

Branch `codex/c187-hips-and-fist`; Godot 4.7.2; gpt-6-astra, medium.

## Result

All ten Hips movements above 0.25 m/frame in frames 0..1799 are removed in seed 92012, MMA, default gameplay options. The culprit is entry/exit of the lower-body walk splice inside the same action clip. It is not the room's root-placement writer. At A frame 279 the splice moves Hips 0.49392 m; final movement is 0.51229 m. The existing inertializer only detects action-clip changes, so this ownership change bypassed it.

`FightStagePlayer._smooth_layer_hips` retains the previous ungrounded pelvis position, detects lower-layer ownership changes, and catches up at an AUTHORED 4 m/s in world-scaled units. It runs after the clip inertializer and before foot locking/grounding. It stops limiting as soon as it catches the target, and resets for paired animation. It does not retime the action or change any arm rotation or source clip. No room mount/scale function was changed.

A focused-test regression exposed a second writer: boxing seed 94301, 60 Hz, B frame 2578. Root placement moves B 0.262468 m, intermediate overlap corrections move 0.019394 and 0.009773 m, then the common rope shift moves it 0.334429 m; the final sum is a 0.101281 m root jump. The baseline no-teleport test passes; a pelvis-only fix fails once. Reducing the pelvis catch-up to 3 m/s did not change that root jump and was rejected. `FightWorldLiveScreen._finish_root_frame` now bounds the composed standing-root movement once per frame at AUTHORED 4 m/s, after all rope/limb corrections and before wrist continuity. Paired grapples, mount blending, and the explicit uneased diagnostic retain their own movement. The first presented frame establishes its starting root; zero-time setup is also exempt. This preserves the walkout arrival gap (final walkout gate: 12 checks, zero failures). Interpolation between the two already-clamped roots remains within the convex floor. The final no-teleport test passes both checks (`TOTAL=2 fails=0`); the engine beat list remains identical between eased and uneased runs. This resolves the composed writer rather than loosening the test.

Final Hips maxima A/B: 0.195851 / 0.166810 m/frame (before 0.512291 / 0.545962). A frame 279 after: 0.195851 m/frame. The final write-point trace confirms the lead hook reaches 11.999999 m/s at frame 271 (also checked with the 620-frame wrist diagnostic before the root correction). Fist maxima remain 12.000 m/s (floating-point epsilon aside), so this fix has not bought smoothness by restoring C186's 4.2 m/s punch cap.

## Part 1 - literature and explicit fallback

**12.0 m/s remains AUTHORED, not a measured human maximum.** The available primary evidence retrieved below does not establish an upper observed peak for each of jab, cross, hook and uppercut. The task's fallback is used; no missing observed range is invented. Group mean +/- SD must not be passed off as an observed min/max or a physiological ceiling.

| Punch | Retrieved measurement | Population/method and limitations |
|---|---|---|
| Jab | Individual peak range unavailable in retrieved primary text | Piorkowski, Lees & Barton (2011), ten competition-standard volunteers, eight-camera optoelectronic 3D motion capture. Abstract includes jab, cross, lead/reverse hooks but only gives pooled contact speeds: single maximal 9.26 +/- 2.09 m/s; combination group means 7.49-8.01 m/s. These are not jab peaks. Full text was blocked by the publisher's browser challenge. |
| Cross | Peak group means 7.30 +/- 0.49 and 8.48 +/- 0.61 m/s; pooled mean-minus/plus-SD envelope 6.81-9.09, **not observed range** | Xu, Mao & Xi (2024), 20 boxing and 20 sanda athletes, high-speed cameras and 3D reconstruction. Table 2 labels 8.48 as sanda and 7.30 as boxing; prose reverses these. Both numbers are retained without silently resolving the inconsistency. |
| Hook | Individual peak range unavailable in retrieved primary text | Piorkowski et al. say lead/reverse hooks have higher contact speed than jab/cross. Dinu & Louis (2020), 15 elite national-team Olympic prospects and eight juniors, 17-IMU suit at 240 Hz, measure **impact** velocity, not the pre-impact peak. Across three punch types their pooled values are 9.8 +/- 2.3 (elite) and 8.1 +/- 1.2 m/s (junior); not a hook-specific peak maximum. |
| Uppercut | Peak group means 9.88 +/- 1.11 and 11.00 +/- 1.05 m/s; mean-minus/plus-SD envelope 8.77-12.05, **not observed range** | Xu et al. (2024), same population/method; Table 3 versus prose has the same group-label reversal. Dinu & Louis also includes uppercuts but reports impact measurements. |

Primary sources opened/read:
- Piorkowski BA, Lees A, Barton GJ (2011), *Single maximal versus combination punch kinematics*, Sports Biomechanics 10(1):1-11. https://doi.org/10.1080/14763141.2010.547590 ; abstract retrieved through https://pubmed.ncbi.nlm.nih.gov/?term=single+maximal+combination+punch&format=abstract .
- Dinu D, Louis J (2020), *Biomechanical Analysis of the Cross, Hook, and Uppercut in Junior vs. Elite Boxers*. https://pmc.ncbi.nlm.nih.gov/articles/PMC7739747/ ; https://doi.org/10.3389/fspor.2020.598861 . The limitations explicitly say analyses were performed at impact.
- Xu Q, Mao R, Xi C (2024), *A comparative analysis of punching in boxing and sanda*. https://pmc.ncbi.nlm.nih.gov/articles/PMC11466798/ ; https://doi.org/10.3389/fspor.2024.1441470 . Tables 2/3 and discussion are inconsistent about group labels.
- Further identified, but numeric results **not verified**: Stanley E, Thomson E, Smith G, Lamb KL (2018), *An analysis of the three-dimensional kinetics and kinematics of maximal effort punches among amateur boxers*, https://doi.org/10.1080/24748668.2018.1525651 (Crossref metadata only). It is not used to manufacture a ceiling.

The diagnostic hand threshold now shares `HAND_PRESENT_SPEED_MPS / 30` = 0.400 m/frame rather than 0.15. A 0.00001 m numerical tolerance excludes IK rounding at exactly the cap. It is an authored-policy crossing, not proof that a human cannot exceed it. Hips has its own requested 0.25 m threshold. Both traces use these definitions. Full 1,800-frame hand crossings A-L/A-R/B-L/B-R: **0/0/0/0 before and after**. The task's three crossings at 0.40 were boundary roundoff; the largest baseline hand step was 0.40000189 m. Final peaks A-L/A-R/B-L/B-R: 12.000008 / 12.000026 / 12.000057 / 11.736950 m/s.

## Part 2 - population and complete hip census

A id `a`, wrestler/grappler, `f05_m_mma_light_rigged.glb`, rendered 1.74 m; B id `b`, `f06_m_mma_lhw_rigged.glb`, rendered 1.82 m. Both engine height fields are 178 cm. Seed 92012, MMA, 30 Hz. These rendered and engine heights remain distinct. Trace samples both fighters, each writer and final post-room/post-hand frame.

Every baseline crossing above 0.25 m in frames 0..1799 follows. `animation_sample` on an exit means the action pelvis replaces the walk pelvis; `body_layer` on entry is the inverse. Stage displacement is an intermediate write, not the final frame displacement.

| Frame | Seconds | Body | Before m/frame | Dominant writer | After m/frame |
|---:|---:|:---:|---:|---|---:|
| 58 | 1.933 | A | 0.28213 | animation_sample (0.28551 m) | 0.12998 |
| 111 | 3.700 | B | 0.25395 | body_layer (0.30495 m) | 0.15201 |
| 115 | 3.833 | B | 0.49199 | animation_sample (0.49334 m) | 0.12679 |
| 118 | 3.933 | B | 0.54596 | body_layer (0.53647 m) | 0.14806 |
| 277 | 9.233 | A | 0.49506 | animation_sample (0.49675 m) | 0.17152 |
| 279 | 9.300 | A | 0.51229 | body_layer (0.49390 m) | 0.19585 |
| 726 | 24.200 | B | 0.51020 | animation_sample (0.53405 m) | 0.10953 |
| 737 | 24.567 | B | 0.31081 | body_layer (0.23536 m) | 0.16681 |
| 1390 | 46.333 | B | 0.38018 | animation_sample (0.37235 m) | 0.14120 |
| 1391 | 46.367 | B | 0.40398 | body_layer (0.41890 m) | 0.16503 |

No after crossings. In the target frame 279, read-track changes Hips 0.0241 m and room placement 0.0154 m, animation sampling 0.0089 m, then the body layer 0.4939 m. Separation, ropes, limb clamping and mount blending are not its dominant writer. The trace accepts optional `seed=`, `rules=`, `fps=` and `frames=` arguments and records node Root positions, making the boxing reproduction `seed=94301 rules=boxing fps=60 frames=2600`. The default remains seed 92012 / MMA / 30 Hz / 1800 frames. The trace now emits **every** hip crossing with write stages, including action-clip changes previously excluded, plus peak speeds and the population metadata.

Reproduce: parse the four edited scripts, then run `--headless --path Godot --script tools/c186_hand_writers.gd -- out=<absolute-jsonl-path>`. Frames are 0-based, 0..1799, with 1,799 inter-frame displacements per fighter. Baseline measurements came from unmodified HEAD before editing; final summary has zero crossings for both bodies. No clip data was edited.

## Part 3 - capture and visual review

- `research/_captures/watch_loop/take4_c187_seed92012.mp4`: H.264, 1280x720, 30 fps, 1,800 frames, 60.0 s, 14,279,181 bytes (<50 MB).
- `previews/c187_before_after.png`: paired take3-C186/take4-C187 views at 0,5,...,55 s.
- Windowed Godot ran through `Tools/godot_hidden.ps1`, using the existing C186 capture camera and default gameplay. The viewport rendered at 1920x1080 despite the requested launch resolution; encoding downsampled to the required 1280x720. Only the MP4 is delivered, not the intermediate AVI.
- Opened the MP4 in its registered application, decoded its frames, and opened the full sheet plus three readable four-row sections for inspection. Both fighters remain visible; the sheet exposes the existing close-range overlap/awkward poses and a lighting difference against historical take3. Those are not claimed fixed. Five-second stills do not prove single-frame continuity; the complete per-frame trace supplies that evidence. Historical take3 contains the old 4.2 m/s ceiling, whereas the numerical BEFORE is merged master at 12.0 m/s.

## Validation and delivery

Parse: `CHECK total=4 fails=0 autoload_refs=0 autoload_warnings=0`.
Focused command: `python Godot/tools/run_tests.py --only fight_stage,fight_world,fight_room,paired_stage,fight_body_layers,arena --godot <specified-4.7.2-exe>`. The 25-test run reported `SUITE total=25 fails=2`: the allowed realism test (`TOTAL=13 fails=8`) and the walkout initialization issue. After fixing first-frame initialization, the targeted no-teleport + walkout rerun is `SUITE total=2 fails=0` (2 and 12 internal checks respectively). The final-code realism rerun reports `SUITE total=1 fails=1` with `TOTAL=13 fails=8`, exactly the task ceiling. Thus the remaining failed test is the explicitly allowed baseline realism gate.

The initial pelvis-only run exposed the no-teleport regression; an isolated unmodified-HEAD comparison passed it. That regression was fixed, not reclassified as baseline. Capture and diagnostic logs contain no script/engine errors, but emit existing ObjectDB cleanup warnings. No assertions or test thresholds were weakened.

Task-specific isolation superseded the general entry workflow: no fetch/rebase/brief/inbox and no HANDOFF or other unlisted digest reads. Only the explicitly assigned task was executed. The required initial import generated unowned import/UID sidecars; none are staged or committed. Three requested one-line C187 messages (one per part) are included in this branch. No full suite run.
