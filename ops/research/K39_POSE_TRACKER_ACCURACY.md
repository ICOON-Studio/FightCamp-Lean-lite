# K39 — CAN A 2D POSE TRACKER MEASURE HOW FAST A FIGHTER'S JOINTS TURN?

Kalli (Grok Bot), research, 2026-09-13, one pass. Task: `research/TASK_K39.md`. Written into the repo by Claude
from Kalli's reply; the tables are Kalli's.

## DECISIONS (Claude's reading, for the R144 / Absolver capture)

1. **A monocular 2D MediaPipe capture can claim about 1.5x, not 1.2x, as the smallest peak joint-speed ratio** -
   Kalli's synthesis: sagittal angle errors ~5-12 deg even in gait (BlazePose peak RMSE 12.5 deg at fast gait; MediaPipe
   ~8.6 deg MAE vs Qualisys), boxing markerless angle RMSD 7-20+ deg on some axes (Lahkar 2022), and differentiating
   degree-level jitter at 60 fps makes hundreds of deg/s of noise. **R5's 1.2x bound is judged on the engine's exact
   joints, not on a tracker - so the capture can confirm a gap the size of R5's 2.09x, not R5b's 1.38x.**
2. **Linear segment speed agrees far better than angles**: Theia3D (multi-camera) boxing hand/forearm/upper-arm speed
   RMSD <= 0.17 m/s, R^2 0.96-0.98 vs 300 Hz markers at 60 Hz video (Lahkar 2022). Report it beside angular speed.
3. **No study validates MediaPipe angular velocity on punches or kicks, on game footage, or across fps and blur**
   (NOT FOUND x4) - our pipeline is unvalidated in the literature; its first numbers are exploratory.
4. **How to capture:** >= 60 fps with little blur; side-on so the limb stays within ~20 deg of the image plane (beyond
   that 2D angles can be ~100% off - Stevens 2006); VIDEO mode with real timestamps; light smoothing then a zero-phase
   Butterworth with a cut-off well above the motion (boxing work used 8 Hz on multi-camera data; never gait-style
   1-3 Hz); the SAME instrument on our own room; check timing against K37's start-ups.

## KALLI'S TABLES
### 1. Accuracy vs marker mocap (position & joint angle)

| Tracker | Finding | Number (mean ± SD, sample) | Label | Source |
|---|---|---|---|---|
| BlazePose / MediaPipe | Gait sagittal angles vs Vicon: BlazePose RMSE often lower than AlphaPose; peaks rise with speed | Slow gait peak RMSE <8° (BlazePose) vs AlphaPose max 14.2° (L knee); normal peak 10.4° (R knee BlazePose); fast peak 12.5° (L hip BlazePose); n = 10 subjects | DOCUMENTED | Accuracy of CV pose algorithms… gait (preprint). DOI 10.21203/rs.3.rs-3239200/v1 |
| MediaPipe + Seq2Seq | Gait MAE vs Vicon (with learned smoother) | Hip 7.8–10°; knee 8–10°; ankle 5.3–7.5° (L) / 5.5–5.7° (R); multi-speed gait | DOCUMENTED | BlazePose-Seq2Seq… IEEE TNSRE 2024. DOI 10.1109/TNSRE.2024.3391908 |
| MediaPipe (RGB) | Upper/lower limb angles vs Qualisys | Mean absolute error ~8.57° overall (authors: within short/long-arm goniometer error band 10–14°); 60 recordings × limb × two camera configs | DOCUMENTED | Sensors 2023, “Validation of Angle Estimation… RGB-D and RGB”. DOI 10.3390/s23010003 |
| OpenPose | Sagittal hip/knee gait vs marker mocap | Hip 3.7 ± 1.3°; knee 5.1 ± 2.5° abs error over gait cycle; n = 32 walkers | DOCUMENTED | Washabaugh et al. comparing open-source pose methods for gait kinematics (SSRN / published follow-on). Abstract 4013255 |
| MoveNet Thunder / Lightning | Same gait comparison | Thunder: hip 4.6 ± 1.8°, knee 7.5 ± 2.5°; Lightning: hip 5.9 ± 3.6°, knee 9.1 ± 3.0° | DOCUMENTED | Same Washabaugh comparison (quoted in SJSP review PDF) |
| OpenPose / DeepLabCut | Running kinematics RMSE vs markers | At 2.78 m/s: hip/knee/ankle RMSE ≈ 5.1 / 7.9 / 5.6° (DLC) and 5.9 / 7.8 / 5.7° (OpenPose); at 3.33 m/s higher (e.g. DLC knee 10.9°) | DOCUMENTED | Scand J Med Sci Sports running markerless study. DOI 10.1111/sms.14319 |
| OpenPose (multi-cam 3D) | Upper-limb joint position MAE during throwing | Wrist up to 4 cm; elbow 4.7 cm; shoulder 2.2 cm | DOCUMENTED (cited in boxing paper) | Nakano et al. 2020 Front Sports Act Living; quoted in Lahkar 2022 |
| BlazePose GHUM (Google) | 2D mAP / 3D MPJPE on fitness-style images — not joint-angle vs optical mocap | Heavy: Yoga mAP 68.1, 3D mae 36 mm (table); Holistic lifter MPJPE 121 mm / PA 78 mm on 10k hard poses | DOCUMENTED | Grishchenko et al. BlazePose GHUM Holistic arXiv 2206.11678; MediaPipe Pose docs |
| RTMPose / ViTPose | COCO AP / speed benchmarks | RTMPose-m 75.8% AP @ 90+ FPS (CPU); ViTPose high COCO AP — no joint-angle° vs marker mocap found in this pass | DOCUMENTED (AP) / NOT FOUND (° vs mocap) | Jiang et al. RTMPose arXiv 2303.07399 |
| MediaPipe vs Qualisys (ROM CoV) | Knee/elbow ROM during selected activities | CoV of joint angles <10% for tested activities (reliability-style, not absolute°) | DOCUMENTED | Comparison of HRNet/MediaPipe vs 3D mocap (Clinical Biomechanics / SciDirect). DOI 10.1016/j.clinbiomech.2024… |

### 2. Fast movements (punches, kicks, high velocity, fps / blur)

| Tracker | Finding | Number (mean ± SD, sample) | Label | Source |
|---|---|---|---|---|
| Theia3D (multi-cam commercial; not MediaPipe) | Boxing shadow punches: segment linear velocity vs Qualisys 300 Hz | Hand / forearm / upper-arm / thorax velocity RMSD ≤0.17 m/s; R² 0.96–0.98; peak hand ~7.0–7.5 m/s; video 60 Hz, marker 300 Hz; 3 elite boxers, 5 trial types | DOCUMENTED | Lahkar et al. Front Sports Act Living 2022. DOI 10.3389/fspor.2022.939980 |
| Same | Boxing joint angles vs markers | Flex/Ext RMSD often ~7–14°; Int/Ext poor (elbow RMSD 18–23°); shoulder better (~6–12°) | DOCUMENTED | Same Lahkar 2022, Table 3 |
| Pose2Sim + GoPros | Boxing jab/hook KPIs vs markers | Waveform CMC >0.94; time-to-peak within <1 frame (17 ms); jab fist peak velocity differ by 1.2 m/s; hook rotations up to ~20° off; 1 elite, 6 reps × 3 punches | DOCUMENTED | Pagnon et al. ECSS 2022 abstract (Pose2Sim boxing KPI) |
| OpenPose / AlphaPose / BlazePose | Fast gait worse than slow | BlazePose peak RMSE rises to 12.5° (hip) at fast gait (see §1) | DOCUMENTED | rs.3.rs-3239200 gait speed study |
| MediaPipe monocular | Angular velocity error on punches/kicks vs mocap | NOT FOUND (no primary MediaPipe ω error table for combat) | NOT FOUND | — |
| Any | Quantified motion-blur × fps (30 vs 60 vs 120) effect on MediaPipe punch peaks | NOT FOUND as a controlled MediaPipe study in this pass | NOT FOUND | — |
| Capture context | Lahkar used 60 Hz video for boxing markerless vs 300 Hz markers; still got strong linear-velocity agreement after 8 Hz filter | Sample as above | DOCUMENTED | Lahkar 2022 methods |

### 3. Filtering before differentiating

| Tracker / method | Finding | Number or rule | Label | Source |
|---|---|---|---|---|
| One Euro filter | Adaptive low-pass: low cutoff when slow (kill jitter), higher when fast (kill lag); 2 params (fcmin, β) | Design paper; less lag than fixed LPF at matched jitter | DOCUMENTED | Casiez, Roussel, Vogel. 1€ Filter, CHI 2012. DOI 10.1145/2207676.2208639 |
| MediaPipe | Built-in landmark smoothing is One-Euro–style for live use | Docs/community; researchers still add offline Butterworth for derivatives | SECONDARY (architecture) | MediaPipe issues / DSP.SE discussion of LandmarkSmoothing |
| Boxing markerless (Theia3D) | Angles & segment velocities filtered 4th-order Butterworth, 8 Hz before analysis | Cutoff 8 Hz | DOCUMENTED | Lahkar 2022 methods |
| Gait kinematics | Very low cutoffs (1–3 Hz) significantly change peak angular velocities; residual analysis often picks ~10 Hz | 4th-order zero-lag Butterworth sweep 1–25 Hz | DOCUMENTED | Sinclair et al. Digital Filtering of 3D Lower Extremity Kinematics. DOI 10.2478/hukin-2013-0065 |
| Classic gait filter | Traditional 6 Hz Butterworth can underestimate displacement peaks by >10 mm on modern high-res data | Technical note | DOCUMENTED | Marker displacement filtering note. DOI 10.1016/j.bspc.2021.102974 |
| Fast sport (pitching / kicking) | High-speed skills need much higher cutoffs than gait (pitching filters often ~18 Hz; kicking near impact >70 Hz discussed) | Filter choice changes peak interpretation | DOCUMENTED | Pitching sample/filter study (Sports Biomechanics 2026 abstract); kicking time-frequency filter study |
| MediaPipe → ω | Published % peak angular-velocity reduction from One Euro / Butterworth specifically on MediaPipe combat angles | NOT FOUND (no MediaPipe punch ω attenuation table) | NOT FOUND | — |

### 4. Rendered / stylised / game humans

| Tracker | Finding | Number | Label | Source |
|---|---|---|---|---|
| MediaPipe / OpenPose on Absolver / fighting-game screen capture vs known engine joints | NOT FOUND | — | NOT FOUND | — |
| MediaPipe on real humans → drive game avatars | Pipelines exist (UPose, DigiHuman, Mixamo demo); qualitative success, no °/ω error vs engine GT | Demo / engineering reports | SECONDARY | MediaPipe avatar demo (arXiv 2206.11678 §5); UPose / DigiHuman repos |
| Wayang / WebGL character driven by MediaPipe | Optimal 0.5–3 m; lighting-sensitive; leg/body transfer issues; no quantitative FPS/accuracy vs GT | Qualitative | DOCUMENTED (limits) | Motion Capture 3D Wayang… MediaPipe. DOI 10.17509/seict.v6i1.84585 |
| Illustrated / cartoon characters | Domain gap: need illustration-specific models; COCO-trained human pose is wrong domain | Transfer-learning paper metrics on illustrations (OKS etc.) — not game 3D fighters | DOCUMENTED (illustration domain) | Transfer Learning for Pose Estimation of Illustrated Characters arXiv 2108.01819 |
| Synthetic Unreal humans | UnrealPose-1M provides engine GT for training/eval; real→synthetic transfer measured on detection/pose tasks | Dataset paper — not MediaPipe Absolver eval | DOCUMENTED (synthetic GT exists) | UnrealPose arXiv 2601.00991 |

### 5. Side-on 2D vs true 3D (foreshortening)

| Tracker / method | Finding | Number | Label | Source |
|---|---|---|---|---|
| 2D film-plane angles (classic) | Elbow/knee <20° out of plane ≈ little measurable difference from 3D; >20° out of plane → joint can look much more extended | Rule of thumb from Plagenhoef 1979, restated | DOCUMENTED | Stevens et al. 2006 Am J Phys Anthropol. DOI 10.1002/ajpa.20359; PDF ohio.edu |
| Same | Uncorrected out-of-plane error can reach ~100% of true angle; trigonometric correction → <2° at 45° OOP, <3° at 90° OOP in their apparatus | Table 1d in Stevens et al. | DOCUMENTED | Same Stevens 2006 |
| Monocular clinical HPE | 2D projected flexion MAE often better than monocular 3D MAE when motion is near-planar; depth error 2–3× in-plane error | Study reports 2D vs 3D MAE ranges by model (e.g. order ~9–22° 2D / ~14–26° 3D in synthesis of that paper) | DOCUMENTED | Sci Rep 2025 clinical monocular HPE. DOI 10.1038/s41598-025-22626-7 |
| Single-camera OpenPose | Knee angle accuracy varies strongly with camera azimuth; oblique views matter | Camera-orientation thesis/study | DOCUMENTED | Influence of camera orientation… DOI 10.14288/1.0451781 |

#### GAPS
No primary MediaPipe / BlazePose angular-velocity validation on punches or kicks.

No 30 vs 60 vs 120 fps × blur factorial for MediaPipe combat peaks.

No evaluation of MediaPipe on stylized fighting-game silhouettes (Absolver-class) against known joint angles.

RTMPose / ViTPose lack published joint-angle° vs optical mocap in this pass (COCO AP only).

One Euro / Butterworth % peak-ω attenuation on MediaPipe combat time series: not tabulated.

Your exact pipeline (screen-capture game pixels → Pose Landmarker VIDEO → 2D ω at join frames) is unvalidated in the literature.

#### Closing — smallest peak-speed difference you can trust
Treat ~1.5× (not 1.2×) as the smallest peak joint angular-speed ratio a monocular MediaPipe 2D capture can claim with moderate confidence, and only when the compared clips share the same camera, filter, and near-planar view. Ground that in what is published: sagittal angle errors are typically ~5–12° even in gait; boxing multi-cam markerless still shows ~7–20°+ angle RMSD on some DOFs while linear segment speeds stay within ~0.1–0.2 m/s RMSD and jab peak fist speed can miss by 1.2 m/s; differentiation turns degree-level jitter into hundreds of °/s of ω noise at 60 fps unless you filter. A 1.2× ω ratio is optimistic for single-camera MediaPipe on game footage (domain gap unmeasured) and should be treated as exploratory only.

To get there (or to argue for 1.2× later): film at ≥60 fps with short exposure / little motion blur; keep the punch/kick near the image plane (side-on for sagittal elbow/knee; reject frames with obvious foreshortening or OOP >~20°); use VIDEO mode with real timestamps; smooth landmarks lightly then differentiate (prefer zero-phase Butterworth offline, cutoff well above the motion of interest — boxing papers used 8 Hz on already-multicam data; do not use gait-style 1–3 Hz if you care about peaks); report linear segment speed as a parallel metric (literature agreement is stronger than for angles/ω); and, if possible, sanity-check one clip against Absolver’s own deck-editor startups (K37) so timing peaks land on the right frames even if magnitudes stay relative.

