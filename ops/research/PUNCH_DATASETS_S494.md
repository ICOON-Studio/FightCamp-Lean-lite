# Labelled punch datasets (S494, his ask after the Reddit fight-analysis video)

Operator: "can you search and find those" (the hand-labelled fight clips a punch detector learns from).
Web search 2026-11-15; licences NOT yet checked on each page - read the page before any download or use.

| Set | What it is | Labels | Where |
|---|---|---|---|
| Olympic Boxing Punch Classification Video Dataset (Stefanski, Kozak) | Real Olympic-style bouts, full HD 50 fps, cameras behind each corner | Punches labelled by licensed referees | kaggle.com/datasets/piotrstefaskiue/olympic-boxing-punch-classification-video-dataset (+ an unlabelled companion set); code: github.com/piotr-stefanski/boxing-fight-video-analysis (classification + detection notebooks); paper MDPI Entropy 26(8):617 "Boxing Punch Detection with Single Static Camera" |
| BoxingVI (IIT Gandhinagar et al., arXiv 2511.16524) | 6,915 punch clips from 20 public YouTube sparring sessions, 18 boxers | 6 types (jab, cross, lead hook, rear hook, lead uppercut, rear uppercut), time segments, 2D pose | Paper only; no download link found - check the paper |
| FACTS (arXiv 2412.16454) | Clips cut from the Olympic set, one action each | Fine-grained classes | Paper |
| MMA Fighter Detection / Pose (Mendeley c456bnk8bm) | 5,106 images from 20 UFC fights, stand-up only | Fighter boxes (YOLOv8); v2 adds 17-point keypoints (model-made) | data.mendeley.com/datasets/c456bnk8bm - images, not strike labels |
| Roboflow "MMA Striking", "kick and punch" | ~100 images | Boxes | Too small |
| RWF-2000 copies | Violence clips | - | Avoid: the owner asked that it not be redistributed |

Gap: no public MMA video set labels individual strikes over time. Boxing has two usable ones (Olympic/Kaggle, BoxingVI).
For FightCamp none is needed: our sim logs every punch, so a fight-analysis page is screen work (S494 question to him).
