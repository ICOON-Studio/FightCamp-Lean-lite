# Fight video analyzer - a strike log from any boxing video (S495)

Operator, S494: "can you find a way to automatically analyze the fight video (at least any boxing video)".
Then, S495: "maybe try a 3D pose estimation network, build a descriptor from the pose parameters and a classifier on top of that."

This is a research tool for the studio (comparison, scouting reference). It is not a game feature: the game's own fight
analysis page reads the simulation's punch log and needs no video.

## The answer in short

- **It exists and runs with one command.** `analyze.py <video> --out <dir>` writes a strike log: time, boxer, hand, punch,
  target, result, then totals per boxer, combinations and "hit right after throwing".
- **It is not accurate enough to trust as fight statistics yet.** On bouts it never saw it finds 54% of the punches the
  referees marked, and 51% of the punches it reports are real (44% and 53% before the picker fix of the same day, see
  "Update: the picker fix"). Where both boxers are tracked well it finds about 70%.
  Its calls on hand, head/body and landed/blocked/missed are barely better than always answering "left", "head",
  "landed". Punch type was right 64% of the time on people the model never saw (the no-training rule: 54%).
- **Where it works best:** amateur boxing with two different kit colours, a camera that shows both boxers whole.
- **Where it fails:** a boxer hidden behind the referee or the other boxer; TV footage of bare-chested professionals
  (who threw the punch gets mixed up); punch type (jab / hook / uppercut) from camera angles the type model never saw.
- **To sell it, the training data has to be ours.** Every piece of code is free for commercial use; the two labelled
  sets it learns from are not, and one pose-model file is doubtful. See "Can it make money".

## How to run it

```
E:\FightCamp\fight_video_data\venv\Scripts\python ops\Tools\fight_video\analyze.py <video> --out <dir> --stills 12
```

- `<dir>\strikes.txt` is the readable log, `<dir>\strikes.json` the same as data, `<dir>\stills*.jpg` picture strips of
  12 punches spread over the video (open them with a file viewer; nothing opens a window).
- That Python has the graphics-card build of ONNX Runtime and scikit-learn. Plain `python` also works, on the processor
  and with the hand-written rules only (slower, more false punches).
- Options: `--start S --end S` (a part of the video), `--stride 2` (every second frame), `--fighters 1` (bag or shadow
  work), `--no-models` (rules only), `--force` (start although the PC watchdog reads RED).
- The analyzer asks the PC watchdog before the pose pass and does not start on RED.
- Self-test of the rules, no video or graphics card needed: `python ops\Tools\fight_video\test_punches.py` ->
  `fight_video rules: all 12 checks passed`.

## How it works

1. **Pose** (`pose.py`): every person's skeleton in every frame (17 joints), with two open models run through rtmlib:
   YOLOX-m finds people, RTMPose-m marks their joints. On the Radeon RX 6800 XT through DirectML.
2. **Who are the boxers** (`track.py`): no training. The boxers are the two people who keep their hands up, keep moving
   and each wear their own colours (vest and shorts are sampled on a narrow strip, split into two groups). A referee
   walks with straight arms; a spectator sits. Cuts in the video are found two ways: the picture jumps, or everybody
   moves at once (an edited static-camera video hides its cuts from the first test).
3. **Punches by rule** (`punches.py`): everything is measured in the boxer's own trunk lengths, so zoom does not matter.
   A punch = the glove's speed against the boxer's own shoulders peaks, the glove travels far enough, and that travel
   takes it toward the opponent. Straight / hook / uppercut from the elbow angle and the rise; lead or rear hand from
   which foot is nearer the opponent; head or body from the opponent's shoulder line; landed / blocked / missed from
   how near the glove ends, whether the opponent's own glove is there, and whether his head snaps.
4. **Trained layer** (`descriptor.py`, `classify.py`): each candidate punch becomes a fixed list of numbers (the
   thrower's joints over the punch, resampled to 8 steps, punching arm first; the opponent's head, shoulders and
   gloves around the glove at impact). Three small classifiers (gradient-boosted trees) read it: is this a punch a
   referee would count; head / body / blocked / missed; and the punch type. `pose3d.py` adds a 3D pose network for
   the comparison below.

## What it was measured on

| Set | What it is | Used for |
|---|---|---|
| Olympic Boxing Punch Classification (Kaggle; Stefanski, Kozak, Jach) | 29 edited bouts, 104 minutes, 50 frames a second, two cameras behind ring corners; 4,609 punches marked by licensed referees: left or right hand x head / body / block / miss. **No punch type.** | Finding punches, hand, target, result |
| BoxingVI (arXiv 2511.16524) | 4,743 usable punch clips as ready-made skeletons, 6 types. Its sources are **single-person bag and shadow workouts filmed from the front**, not fights. | Punch type |
| Three outside clips | A handheld amateur show (Wikimedia Commons, CC BY-SA 4.0, "Day of the Town - Russian boxing" by Zelio007) and 90 s of a broadcast professional fight | Checking by eye |

How a detection is scored against the referees: it matches a label when its impact is within 0.16 s of the label and
its glove is within one box diagonal of the label's box; each label and each detection counts once.
**Recall** = how many of the referees' punches we found. **Precision** = how many of ours were real.
Every score below is on bouts the models never saw.

## Update: the picker fix (S495, later the same day)

Next step 1 below is done (`track.py`; measured in `ops/research/FIGHT_VIDEO_DATASET_S495.md`, "The picker fix"). The kit
pair is now chosen per bout inside a file, and an empty boxer slot takes the fighter standing next to the boxer that was
found. Nothing was trained for it. The tables under "The numbers" are the measurement BEFORE this fix and are kept as
they were; the same measurement after it:

| | Before | After |
|---|---|---|
| All 29 bouts: labels where both boxers are seen (the ceiling) | 74.4% | **87.1%** |
| All 29 bouts: labels the candidate net catches | 57.1% | **68.1%** |
| Per file, labels caught: worst / middle / best | 16% / 66% / 88% | **38% / 74% / 90%** |
| 6 bouts set aside, rules only: found / real | 50.0% / 28.2% | 60.5% / 28.1% |
| 6 bouts set aside, trained layer: found / real | 44.5% / 53.3% | **53.8% / 51.2%** |
| 6 bouts set aside, trained layer: hand / head-body / result | 69.0% / 78.0% / 57.8% | 72.4% / 83.8% / 61.2% |
| 23 bouts by folds, trained layer: found / real | 43.9% / 50.9% | **52.4% / 51.5%** |
| 23 bouts by folds, trained layer: hand / head-body / result | 71.9% / 82.5% / 56.2% | 72.7% / 81.2% / 57.2% |

So the fix finds about nine more punches in every hundred at the same share of real ones. Hand, target and result are
still at "always the commonest answer" (64% / 87% / 64%): the picker was never their problem.

## The numbers

### Finding punches, hand, target, result (Olympic set, referee labels)

All 29 bouts were processed. Six bouts were set aside before any tuning and scored once at the end; the other 23 were
scored five bouts at a time by models trained on the rest. Both readings agree.

| | Rules only (no training) | Trained layer | Always the commonest answer |
|---|---|---|---|
| **6 bouts set aside, 1,045 labels** | | | |
| Punches found (recall) | 50.0% | 44.5% | - |
| Reported punches that are real (precision) | 28.2% | **53.3%** | - |
| Hand right, on matched punches | 66.5% | 69.0% | 64% ("left") |
| Head or body right | 63.3% | 78.0% | 87% ("head") |
| Landed / blocked / missed right | 40.3% | 57.8% | 64% ("landed") |
| **23 bouts by folds, 3,564 labels** | | | |
| Punches found | 49.2% | 43.9% | - |
| Reported punches that are real | 27.8% | **50.9%** | - |
| Hand / head-body / result right | 70.7% / 64.4% / 37.7% | 71.9% / 82.5% / 56.2% | 64% / 87% / 64% |

What the table says, plainly:
- **Training nearly doubles how many reported punches are real** (28% -> 53%) and costs a little recall.
- **Hand, target and result are not learnt yet.** The trained layer is at or under "always say the commonest answer".
  On the six bouts it called 227 of 296 landed punches landed, but only 13 of 56 blocks and 29 of 113 misses.
  Telling a landed punch from a blocked or slipped one needs the picture around the glove, not only joint positions.
- **The ceiling is tracking, not the classifier.** A punch can only be found when the pose stage sees both boxers at
  that moment: 74% of all labelled punches. The candidate net catches 57% of all labels.

It depends heavily on the video (candidate net, all 29 bouts): worst 16%, middle 66%, best 88% of the labels caught.
- Bouts where both boxers are tracked (the two best of the six set aside, GH118416 and GH148416): **70% found, 57% real,
  hand 71-77%, result 59-64%.**
- Bouts where the picker breaks (GH178416, GH198416, GH208416, GH158416): 16-44% caught. The eye check showed why:
  those files hold **several different bouts cut together**, and the picker looks for one pair of kit colours per video.

Precision is a little understated: jabs thrown from out of range were seen in the pictures but are not in the referee
labels, so they count against us.

### Punch type (BoxingVI, 4,743 clips, 9 people, each person tested by a model that never saw him)

| | Accuracy | Straight (jab, cross) | Hook | Uppercut |
|---|---|---|---|---|
| Rule, no training, 3 families | 54.0% | precision 76% / recall 58% | 32% / 53% | 56% / 43% |
| Trained, 3 families | **64.2%** | 85% / 71% | 43% / 58% | 51% / 53% |
| Always "straight" | 56% | | | |

Trained, all six types: 56.3% right. Per type (precision / recall): jab 76% / 67%, cross 78% / 63%, lead hook 40% / 59%,
rear hook 19% / 17%, lead uppercut 35% / 38%, rear uppercut 46% / 45%.
Per person it swings from 34% to 84% (six types) and from 44% to 93% (three families): nine people are too few.

Two cautions. BoxingVI is one person on a bag or shadow boxing, filmed from the front, so this is not a fight number.
And on side-on fight pictures the trained type model called clear straight punches hooks, so in a two-boxer video the
rule keeps the type call and the model's answer is only recorded in the JSON (`model_type`). No labelled set gives
punch type for real fights; that needs our own labels.

## What it gets wrong (checked by eye)

Picture strips were opened for the final pipeline on three kinds of footage.

**A handheld amateur show it never trained on** (42 s, red against blue; 14 punches reported, 12 checked):
- 7 of 12 were real punches, 5 were not: a second arm moving with the punching one, the same punch counted on both
  arms once, arms over the top in a clinch, a boxer ducking. That matches the measured 53%.
- Of the real ones the type looked right on about 4 of 6 (two straight lefts were called hooks); the result call was
  wrong on 2 of 4 that could be judged.
- It finds both boxers by kit colour through a moving, zooming camera with ropes in front.

**A test bout set aside** (GH208416): the file holds several bouts. In one stretch boxer "A" was a man standing outside
the ring with his arms up while the real boxer was behind the referee. Where it had the right two boxers, a jab to the
head was found with the right hand, type and target but called "missed" where the referee marked it landed.

**90 seconds of a broadcast professional fight**: not usable yet. Both boxers are bare-chested, so kit colour hardly
separates them; close-ups and camera changes break the tracking; the referee's raised arms pass the "hands up" test.
Some real punches are found, but who threw them, and therefore target and result, cannot be trusted.

**The recurring causes, in order of damage:**
1. A boxer is hidden: behind the referee, behind the other boxer, at close range where the two skeletons merge.
2. The wrong people are picked: several bouts in one file, bare chests, a referee or a ringside man with raised arms.
3. Left and right arms are swapped by the pose model when a boxer is seen from behind or side-on (hand is 69-72%).
4. Depth is missing: a glove that passes beside the head and one that hits it look alike from one camera.
5. A punch straight at or away from the camera barely moves in the picture and is missed.

## Does a 3D pose network help

Tried as the operator suggested. A 3D pose network (RTMW3D-x) was run on six frames of every candidate punch, for the
thrower. It gives depth per joint, so the elbow angle and the reach are true angles and lengths in the boxer's own
body frame instead of being shortened by the camera angle. Those 66 numbers were added to the 2D descriptor and the
same classifiers were trained and scored on the same folds by bout.

| All 29 bouts, 4,609 labels | 2D descriptor | 2D + 3D descriptor |
|---|---|---|
| Punches found | 45.9% | 44.5% |
| Reported punches that are real | 49.8% | 50.1% |
| Both in one score (F1) | 0.477 | 0.471 |
| Hand right | 71.1% | 71.3% |
| Head or body right | 80.8% | 82.7% |
| Landed / blocked / missed right | 56.1% | 56.8% |

(A first reading on 10 bouts gave the same picture: F1 0.472 against 0.480.)

**No real gain.** The differences are a point or two either way, on every line. The 3D pose was found
for 97-100% of the candidates, so the network worked; it just did not add what is missing. Why, most likely:
- The network places each person in his own 3D box. It does **not** put the two boxers in one space, so the question
  that matters for landed / blocked / missed (where is the glove against the other man's head and gloves) stays 2D.
- The depth is a guess from one picture of a small, motion-blurred, half-hidden figure: it inherits the same errors.
- The descriptor-plus-classifier idea itself did pay off (precision 28% -> 53% above); it is the 3D part that did not.

Where 3D should help is punch **type** (straight against hook when the arm points at the camera), which could not be
measured: the only set with type labels (BoxingVI) ships skeletons, not video. That test belongs to our own labelled
clips. The full result is in `E:\FightCamp\fight_video_data\work\report_3d.json`.

## Speed and the PC

- Pose pass: 21-25 frames a second on the graphics card when the camera sees 3-4 people, 12-15 when it sees ten
  (one ring camera of the test set). A 3-minute round filmed at 50 frames a second takes about 6 to 12 minutes;
  `--stride 2` halves that.
- Everything after the pose pass takes seconds. The 3D pass is about 45 poses a second, run only on punch windows.
- Heat: the processor stayed at 51-60 C through the whole run (three pose jobs at once at the peak). The work is on
  the graphics card.
- One failure worth knowing: with a game open the PC ran out of memory (97%) and four pose jobs died; they were redone.
  A long batch should be one job at a time when he is using the PC.

## Can it make money (licences)

Read on each repository, model page and installed package on 2026-11-15. "Unknown" means not confirmed, not "fine".

| Piece | Licence as written | Commercial use | What it requires |
|---|---|---|---|
| rtmlib 0.0.16 (runs the pose models) | Apache-2.0 | Yes | Keep the licence and notice |
| OpenMMLab mmpose (RTMPose, RTMW3D code), Megvii YOLOX (code) | Apache-2.0 | Yes | Same |
| ONNX Runtime, onnxruntime-directml | MIT | Yes | Keep the licence |
| OpenCV 5.0 (opencv-python) | Apache-2.0; the wheel bundles FFmpeg (LGPL) | Yes | Keep the notices; do not statically relink FFmpeg |
| numpy, scipy, scikit-learn, joblib, threadpoolctl | BSD-3-Clause | Yes | Keep the licence |
| openpyxl, gdown (only for reading the datasets) | MIT | Yes | - |
| ultralytics YOLO | AGPL-3.0 unless their paid licence is bought | **Not used, on purpose** | - |
| RTMPose-m "body7" weights (2D pose) | Published by OpenMMLab in the Apache-2.0 mmpose project; no separate licence for the weights on the page | **Unknown** | Trained on 7 public sets (AI Challenger, COCO, CrowdPose, MPII, sub-JHMDB, Halpe, PoseTrack18) whose own terms were not checked |
| YOLOX-m "humanart" weights (finds people) | Same project; trained on Human-Art, whose page says: "request authorization to use Human-Art for non-commercial purposes" | **Doubtful** | Swap for a detector trained on commercially usable data before selling anything (task queued, below) |
| RTMW3D-x weights (3D pose, experiment only) | Hugging Face card (a conversion by a third party): apache-2.0; trained on 14 mixed sets | **Unknown** | Not needed: see the 3D result |
| Olympic Boxing Punch Classification set | "The data is for use in non-commercial settings: in academic institutions for teaching and research purposes and in non-profit research organizations." | **No** | Written permission from the authors (University of Economics in Katowice) |
| BoxingVI | No licence file in the repository; its videos are ordinary YouTube uploads | **No** (no licence = all rights reserved) | Permission from the authors and the video owners |

**A model trained on those two sets cannot be sold or run as a paid service.** The operator cleared the downloads for
measuring only. So: the datasets, the trained model files and the virtual environment live outside the repository in
`E:\FightCamp\fight_video_data\`, nothing learnt from them is committed, and nothing of it goes into the game.
The rules stage (no training) and all the code are ours and free to use.

(Update, same day: the detector now has a clean replacement and the pose weights turned out to be the blocking model
file; the synthetic clips hit a licence clause of the bought punch animations. All in
`ops/research/FIGHT_VIDEO_DATASET_S495.md`.)

What a sellable version needs: our own labelled clips (the operator's answer, S495: "make our own labelled clips then" -
synthetic clips rendered from our own 3D fight with exact labels from the sim, plus real footage we have rights to and
a labelling tool; planned in `ops/research/FIGHT_VIDEO_DATASET_S495.md`), a person detector with clean weights, and a
lawyer's reading of the pose weights.

## The commercial reference: Jabbr DeepStrike

jabbr.ai/deepstrike is a commercial boxing and MMA video-statistics AI: waitlist only, no public API, no export, no price.
Its terms forbid using its statistics to train another fight-statistics AI, and anything uploaded may train theirs.
So it is never a data source or a labeller for us, and no video of ours goes to it. It is the benchmark for **which
statistics matter**: landed against high-impact against thrown, pressure and aggression %, punch distance, power
commit, combinations by length. Of those, this prototype has thrown / landed / blocked / missed, punches a minute and
combinations; it has no measure of impact, pressure or distance yet.

## Next steps

In order of value for the effort:

1. **DONE (see "Update: the picker fix"). Pick the boxers per scene, not per video** (code, no training): choose the pair of kits for each stretch between
   cuts, leave a third colour group (the referee) out, and analyze wide shots only on broadcast footage. This alone
   should lift the four broken test files and is the step toward TV footage.
2. **Our own labelled clips** (the operator's call, queued as its own task): synthetic exchanges rendered from our 3D
   fight with exact labels, real footage we have rights to, and a confirm-or-fix labelling tool. Needed both to sell
   anything and to get punch type for real fights at all.
3. **A classifier that looks at the picture, not only the joints**, for landed / blocked / missed and for the hand: a
   small video model on the crop around the glove and the opponent's head. Training plan: the 4,609 Olympic punches
   are enough to prove it for research; our own set for the real one. On this PC the graphics card is AMD, where
   training tools are weak: estimate 1 to 2 days on the processor or roughly 6 to 10 hours through DirectML (not
   measured), against 1 to 2 hours on a rented 24 GB card for a few dollars. Inference stays on this PC.
4. **A sharper pose pass**: the larger RTMPose at 384 px for small, half-hidden boxers, and a pose model fine-tuned on
   our synthetic boxing renders (exact joints and gloves come free from the game's skeleton).
5. **The statistics the commercial reference shows** that we lack: impact (how far the head snaps), pressure (who moves
   whom across the ring), punch distance (the gap in trunk lengths turned into metres).

Follow-ups outside this task: `ops/RESEARCH_INDEX.md` has not been synced for this page (the main session's index);
the idle guard asked this session to brief the Qwen seat, which belongs to the main session's queue.

## Where everything is

- Code (in the repository): `ops/Tools/fight_video/` - `analyze.py` (the command), `pose.py`, `track.py`, `punches.py`,
  `descriptor.py`, `classify.py`, `stills.py`, `pose3d.py`; measuring: `evaluate_olympic.py`, `train_olympic.py`,
  `train_type.py`, `experiment_3d.py`; `fetch_olympic.py` (re-downloads the Olympic set); `test_punches.py`.
- Outside the repository, `E:\FightCamp\fight_video_data\` (about 4.5 GB): `olympic_kaggle` (3.3 GB), `boxingvi`
  (50 MB), `commons`, `broadcast`, `models` (the three trained classifiers and the 3D pose model), `venv`, `work`
  (pose files per bout, logs, `report_olympic.json`, `report_3d.json`), `out` (analyzer outputs of the three clips).
- To repeat the measurement: `pose.py` on each bout, then
  `train_olympic.py <olympic_kaggle> <work> <models> --test GH118416,GH148416,GH208416,GH089681,GH129681,GH199681`,
  `experiment_3d.py <olympic_kaggle> <work>` and `train_type.py <boxingvi> <models>`, all with the venv's Python.
