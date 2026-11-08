# Möbius motion model: can it help our animation? (S402, 2026-11-08)

Operator: "check mobius and see if it can help us with animation". Paper: https://arxiv.org/abs/2611.05279 (HKUST, Tencent Games Motus, MIT). Repo: https://github.com/JiazhiShu/mobius-code.
Read: the paper (partly via a summary). The repo page could not be opened; a search snippet of it says code availability is under internal review.

What it does: one model for text-to-motion, motion-to-text, completion (in-betweening, prediction, keyframe infill) and instruction editing. About 5 s a clip on one GPU, 30 fps, up to 300 frames (10 s).

Why not now:
- Not obtainable yet: code under review; no weights or licence stated in what was read.
- One person only. Multi-person interaction, fingers and retargeting are listed as future work. Our hardest shots are two boxers touching.
- No foot-sliding or contact number reported. Our measured problem is conversion onto MetaHuman, foot slide and layers fighting each other (S399).
- Data: its small model trains on HumanML3D, whose source data has non-commercial terms as far as we know (check before any use); its large model on a private 1,700-hour set.

Worth a look when released, as tools, never as the source of fight motion:
1. Motion-to-text to label and search our clip library.
2. In-betweening for joins between clips, judged by our usual film tests.

Recheck the repo when weights and a licence appear. Bar: raw-vs-ours table on foot slide, then a blind film at 8/10.
