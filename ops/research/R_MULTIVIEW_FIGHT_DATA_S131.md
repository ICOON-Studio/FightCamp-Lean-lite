# Multi-view / two-person fight data - where real paired motion exists (S131, 2026-09-30)

Operator: "find the videos [BoxMAC] and search for footage of a fight being recorded from different angles and sync it".
Read-only web research by a helper agent, collected by Claude. Nothing downloaded.

## BoxMAC - dead end
arXiv 2412.18204 was WITHDRAWN (v2, 17 Feb 2025: "submission was made without the full agreement of all co-authors").
No public copy (GitHub/Kaggle/HF/Zenodo none). Author page https://sks200.github.io/ (IIT Madras IPCV lab) gives no link.
Citing papers: BoxingVI (arXiv 2511.16524) notes BoxMAC "lacks skeletal pose data".

## Ranked for "two fighters in close contact, 3D, usable for game animation"
1. Harmony4D (NeurIPS 2024) - MMA (5 sets), karate (3), grappling (2) + others; 20+ synced 4K GoPros 60 fps, COLMAP
   calibrated; SMPL per frame for BOTH people + 3D keypoints (20 fps); 208 sequences / 1.66M images; MIT on repo and
   Hugging Face, not gated (MMA zips ~67 GB). https://jyuntins.github.io/harmony4d/ ,
   https://huggingface.co/datasets/Jyun-Ting/Harmony4D . FLAG: the SMPL body model is non-commercial
   (https://smpl.is.tue.mpg.de/modellicense.html ; commercial via Meshcapade) - advice before shipping derived motion.
2. ReMoCap / ReMoS (MPI, ECCV 2024) - two-person Ninjutsu + Lindy Hop, 2.04 h, BVH per performer; commercial use
   "strictly prohibited". https://vcai.mpi-inf.mpg.de/projects/remos/
3. InterHuman (InterGen 2023) - 76 cameras, 6.56 h, includes boxing/taekwondo; CC BY-NC-SA 4.0. https://github.com/tr3e/InterGen
4. Inter-X (CVPR 2024) - optical mocap 120 fps SMPL-X both people, punch/kick interactions; CC BY-NC-SA, no commercial training.
5. CHI3D (CVPR 2020) - Vicon + 4 RGB, grab/push/hit/kick, GHUM/SMPL-X; non-commercial (licenses@imar.ro).
6. Physics-based combat-sports pose, ETS Montreal (CVPR 2025) - ELITE BOXING SPARRING, 4 calibrated views, SMPL + two-person
   OptiTrack ground truth - "Dataset (Coming Soon)". https://hosseinfeiz.github.io/physpose/ - WATCH THIS ONE.
7. Hi4D (CVPR 2023), 8. NSD boxing (EPFL 2019, on request, research), 9. ExPI (Lindy Hop) - all research-only.
Comparison: CMU Panoptic (no fighting, non-commercial), EgoHumans (fencing, Apache-2.0 repo), AIST++ (single dancer),
BoxingVI (monocular YouTube, 2D only).
No publicly available synced multi-angle boxing/MMA recordings were found (YouTube sparring = single edited feeds).

## Tools for our own multi-phone capture (two people)
- EasyMocap (Zhejiang U.) - multi-view multi-person SMPL/SMPL-X; needs synced calibrated cameras; PRL v1.0: commercial
  "Project Use" allowed after free registration. https://github.com/zju3dv/EasyMocap
- MAMMA (MPI, CVPR 2026) - two-person close contact, SMPL-X, demoed with 4 iPhones; non-commercial.
- Theia3D (price on request), Move.ai multi-person (Enterprise; third-party listing, not verified).

## Claude's recommendation (S131)
A Harmony4D PROBE: one MMA sequence set (a few GB, operator's download OK needed) through our pipeline (SMPL -> our rig,
qm2p_pair_check-style overlap) - does real close contact survive onto our fighters? Licence question only before shipping.
For boxing: film real boxers ourselves (fixed phones, separated drills), EasyMocap/QuickMagic; watch the ETS dataset.
