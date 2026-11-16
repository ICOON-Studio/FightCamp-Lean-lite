# Our own labelled boxing-punch clips - plan, licences, first counts (S495)

Operator, S495, after reading that the fight video analyzer learns from two sets we may not sell from:
"make our own labelled clips then".

The analyzer itself is described in `ops/research/FIGHT_VIDEO_ANALYZER_S495.md`. This page is about the data it should
learn from: a training and test set the studio owns outright, so a model trained on it can be sold or run as a paid service.

## The answer in short

- **The first set is rendered and labelled, and it may not be used for AI yet.** 160 clips, 34.7 minutes, 1,579
  punches with exact labels (who, hand, type, target, result, frames, both boxers' joints), from four kinds of camera.
  But every one of those punches is a bought motion-capture clip (MoCap Online), and its licence says any AI use
  "requires explicit and prior written permission". So no model was trained on the set and no pose pass was run over
  it (three small slips are listed below). **The synthetic-to-real numbers the task asked for were not measured.** One email to the vendor, or punches
  we own, unlocks it; everything needed to measure is written and waiting.
- **The bodies are a second open question.** They are Epic MetaHumans; Epic's terms could not be read without a
  login. He has to read them once.
- **What did improve the real numbers today: the boxer picker.** On bouts the analyzer never saw it now finds 54% of
  the referees' punches (was 44%) with 51% of its reports real (was 53%). The worst file went from 16% of its labels
  caught to 63%.
- **The person detector has a clean replacement** (RF-DETR Small, Apache-2.0 by the maker's own text), exported and
  tested on two real bouts: a little better on one, worse on the other, slower. Not the default yet.
- **The joint model is now the blocking model file:** one of its training sets forbids commercial use.
- **Free footage: 67 clips checked, 26 usable candidates** (64 minutes, 1.0 GB, mostly old newsreels), none
  downloaded. The two clips already on disk are held back: the boxers' ages are not known.
- **The labelling tool for clips he films is ready** and tested; nobody has labelled a real clip with it yet.

**Decisions that are his:** send the permission email to MoCap Online (draft below) or go for punches we own; read
Epic's MetaHuman terms; say yes or no to downloading the 26 candidates (1.0 GB); film the first sparring clips with
written consent.

## The plan

A sellable analyzer needs three things to be ours or cleanly licensed: the labelled clips it learns from, the model
files that find people and joints, and the code. The code already is. This page covers the first two.

**Track 1 - synthetic clips from our own game.** A tool plays scripted exchanges through the fight's own code and
saves the picture and, for every punch, exactly what was played. Cheap (about 50 frames a second on this PC),
unlimited, every label exact. Weakness one: it is not real video. Weakness two, found while building it: the game is
ours but not everything in the picture is - the punches are bought motion-capture clips and the bodies are MetaHuman
characters, and the punch clips' licence asks for written permission before any AI use (next section).

**Track 2 - real footage we have rights to.**
- (a) Freely licensed boxing video (Wikimedia Commons, US-government public domain, CC-BY elsewhere), each clip with its
  licence, author and attribution text in a manifest. ShareAlike clips are flagged: whether a trained model counts as
  an "adaptation" of the videos is unsettled, so they are kept apart until a lawyer has read it.
- (b) Clips he films at a gym with everyone's written consent, labelled with a confirm-or-fix tool: the analyzer
  proposes punches, a person presses one key per punch.

**How the two fit together.** Synthetic clips give volume and exact labels (including punch type, which no real set
has for fights). Real clips close the gap between a rendered picture and a filmed one, and are the honest test set.
How big that gap is could not be measured yet (see "What the synthetic clips teach").

**Rules kept.** Everything not ours stays outside the repository (`E:\FightCamp\fight_video_data\`). The Olympic set
and BoxingVI are used only to MEASURE; models fitted on them stay outside the repository and are never shipped. No video of minors enters
our set. Nothing is uploaded to the commercial reference (Jabbr DeepStrike), and it is never a data source.

## The rights problem found on the way

The task assumed "we own every pixel" of a clip rendered from our game. We own the game, the ring, the code and the
labels. We do not own everything that moves in the picture, and one licence says so in plain words.

| In the picture | Whose it is | May an AI use it? |
|---|---|---|
| Every punch thrown (all `pro_*` clips: 100% of the punches in the rendered set), the hit reactions, slips, weaves and pulls | MoCap Online, Punch Pro pack (bought, Standard License) | **Only with their written permission.** Licence §3.1: "any use of MoCap Online's animations, character models, or any other digital assets ... in connection with artificial intelligence applications, systems, or solutions (collectively, "AI Applications") requires explicit and prior written permission from MoCap Online. This requirement applies irrespective of whether the AI Application is intended for commercial purposes or personal use." Their "AI Usage Permit" page: needed for "Running AI pipelines that process, transform, or analyze our animation files"; yearly, case by case, by email. |
| The guard between punches (`rk_guard`) | Rokoko's free fight pack | **Unclear.** The pack's page allows "any animation, VFX, game, 3D art etc project ... commercial use"; Rokoko's general terms (§5.4) forbid using Rokoko's own assets for "developing, training, or enhancing machine learning and/or AI models" without written consent, and the page does not say which terms govern the free pack. Ask in writing. (Motion we capture ourselves with a Rokoko suit is ours: §6.3.) |
| The bodies | Epic MetaHuman (made with MetaHuman Creator, Unreal 5.8) | **Unknown.** Epic's licence pages need a login and could not be read. Unverified pointer: Epic is reported to have removed its ban on using MetaHumans to train AI on 29-30 October 2026 ("UE devs can now choose to train AI Models on their projects") for characters under the Unreal Engine licence. He has to read https://www.unrealengine.com/eula/unreal signed in. |
| The glove | "Boxing Glove" by Incg5764, Sketchfab, CC BY 4.0 | Yes, with the credit line |
| Steps and range, head snap, block catch, breathing, the glove carried onto the target; the ring, lights, gym room, kits | Our code | Ours |
| The labels (who, hand, type, target, result, frames, joints) | Written by our code | Ours, but the joints trace the bought motion |

The project had already written this down for the game itself (`ops/research/CLIP_LICENCE_LIST_S392.md`, flag 5:
"Using their assets in AI applications needs written consent ... no model is trained on them"). It applies to this
dataset with full force: training a punch classifier on renders of their punches is exactly an AI use of their
animations.

**What was therefore done and not done.**
- Done: the clips were rendered and labelled (rendering our game with bought clips is the licensed use), and stills
  were looked at to check the labels.
- Not done, on purpose: the pose pass over the clips, any training on them, and the comparison of detectors on them.
  The queued jobs were stopped when the clause was read. **The synthetic-to-real numbers the task asked for were not
  measured.**
- Three things did run, all small, none kept. Before the clause was found: one in-memory trial fit of the small
  classifiers on the exact joints of 16 clips (nothing saved), and the new detector on four frames to check its
  wrapper. After it: a queued job that had been stopped survived as an orphan process and ran the pose pass on two
  clips for under a minute before it was found and killed; its output was deleted. (Lesson for the tools: stopping a
  background chain on this PC does not stop the script it started; the processes are now killed by their own id.)

**Three ways forward, cheapest first.**
1. **Ask MoCap Online for the permit.** One email (draft below). If they say yes, everything built here runs as it is:
   the pose pass takes about 80 minutes, the measurement a few more. Price unknown ("case by case", yearly).
2. **Punches we own.** (a) Our own four authored clips (jab, cross, lead hook, guard pose) can drive an "owned motion"
   render mode: three punch types, stiff, no slips or uppercuts; roughly half a day of work, and a weak teacher.
   (b) Capture our own punches (a mocap suit session is ours outright under Rokoko's terms), then the renderer gives
   all six types with our motion. (c) **When the mocap packs are bought at the end of November: read the AI clause
   first, or get machine-learning rights in writing with the purchase.**
3. **Leave the renders for the game and build the set from filmed clips** (Track 2b) and free footage (Track 2a).
   Slower per punch, and it is the data that closes the real-video gap anyway.

**SENT on 2026-11-16 at 11:38** from his mailbox, on his "You send it": the text below with his name, the product
name as it stands on his order ("Punch - 3D Character Animations", PRO and STARTER) and the PRO order number. No answer
yet; until one arrives in writing nothing changes: no AI runs over the clips.

**The email.** Their permit page says how: "Email us at mocap@motusdigital.com with" your name and
company, a description of the AI use, which packs, and the expected scope (research, production, commercial
deployment). No order number is asked for and no price is shown ("Annual term, renewable", "Case-by-case review";
they say they answer in 2-3 business days). The page lists "Model Training" among what the permit covers.

> To: mocap@motusdigital.com
> Subject: AI Usage Permit request - Punch Pro and Punch Starter
>
> Hello,
>
> Name / company: [his name], ICOON Studio. We hold the Standard License for Punch Pro and Punch Starter and use both
> packs in our boxing game.
>
> AI use case: we render video of our own game characters playing your animations and want to use those renders,
> together with labels written by our own game code (which punch, which hand, where it lands, the characters' joint
> positions in the picture), to test and to train our own computer-vision models that read boxing video: finding
> people and their joints, and classifying punches. The models do not generate or synthesize motion. Your animation
> files are never given to an AI tool and are never redistributed; only rendered video of our game is used, inside
> our studio.
>
> Packs: Punch Pro, Punch Starter.
>
> Expected scope: research now (measuring how well such a model does on real boxing video); if it works, commercial
> deployment of the trained model in our own products.
>
> Could you tell us whether this needs the AI Usage Permit under section 3.1 of the licence, what it costs per year,
> and whether it would cover a trained model that we sell or run as a paid service?
>
> Thank you,
> [his name]

## Track 1 - the synthetic clips

### What was built

- `tools/fight_video_synth.gd` (+ `_script`, `_set`, `_pose`): one run = one pair of bodies and several clips. Each clip
  gets its own camera, light, room, canvas colour, kits and exchanges.
- `ops/Tools/fight_video/synth_render.py`: runs the batch on the never-shown desktop, one render at a time, through the
  Godot job queue; asks the PC watchdog before every run; packs each clip's frames into one video and writes
  `manifest.json`. Split by body: a test clip never shows a body that a training clip shows.
- Every punch is thrown through the fight's own beat switch (`BeatFire`), the same code a round in the game uses, so
  a landed punch is carried onto the face, a blocked one stops on the glove, a missed one is slipped, weaved or pulled
  away from, and the hit reaction plays. The exchanges are scripted for a balanced set (all six punch types, three
  results), not simulated bouts.

How to render more (venv Python, the PC must not read RED):

```
E:\FightCamp\fight_video_data\venv\Scripts\python ops\Tools\fight_video\synth_render.py E:\FightCamp\fight_video_data\synth --runs 40 --clips 4 --secs 13 --seed 1
```

A different `--seed` gives new clips; `--from-run N` continues a batch. First counts: `synth_data.py counts <dir>`.

### What a clip holds

`clip_NNNN.mp4` (1280 x 720, 50 frames a second, 13 seconds) and `clip_NNNN.json`:

- `punches`: for each punch the boxer (0 or 1), hand (left / right), lead or rear, type (jab, cross, lead hook, rear
  hook, lead uppercut, rear uppercut), target (head / body), result (landed / blocked / missed), the defence played
  (block, slip, weave, pull), the start, contact and end frame, the punch clip played, and three honesty flags:
  `shown` (false when the game replaced the punch before it arrived; such punches are not used as labels), `graze`
  (the game drew a landed punch as a glancing touch) and the glove-to-target distance at contact in metres.
- Per frame, for both boxers: the 17 COCO joints in the picture (`joints`: x, y, inside the picture or not) and in
  metres in the ring (`joints3d`), both glove fronts, a box round the body, and the camera (shot name, cuts, lens angle,
  position).
- The clip's plan: camera, room, light, canvas, kits, bodies, stance, body scale.

The joints are read off the skeletons as drawn (after every body correction the game applies) and projected through the
lens that drew the frame. Checked by eye on all four camera types: they sit on the bodies.

### What varies

| | Values |
|---|---|
| Camera | **tv**: the game's own broadcast lens, with its cuts between shots. **corner**: a still wide lens above a ring corner (how the Olympic set was filmed). **phone**: hand-held at ringside, late to follow, shaking, looking between or over the ropes. **tripod**: a still lens further back, low or high. One of each in every run. |
| Room | The fight-night arena with its crowd (55%) or a gym room: painted walls, heavy bags, posters, bright light (45%). The gym is plain boxes and cylinders built by the tool, not a modelled gym. |
| Light | Ring lights 65-135%, exposure, warmth, ambient level. |
| Canvas | Six colours. |
| Kits | 13 colours for vest, trunks and gloves; in about one clip in eight both boxers wear the same colours (the hard case). The men are bare-chested (their bodies have no vest), the women wear vests. |
| Bodies | 19 MetaHuman boxers (5 men, 14 women), men against men and women against women, scaled 96-104%; one boxer in five is a southpaw. |
| Ring place | The pair opens anywhere in the middle third of the ring, on any line. |

### First counts

Rendered on 2026-11-16, seed 1, 40 runs of 4 clips. Every clip file was checked after the batch (video length against
its labels, manifest row, camera rule).

| | |
|---|---|
| Clips | **160** (13 s each, 50 frames a second, 1280 x 720) |
| Video | **34.7 minutes**, 104,000 frames, 0.8 GB on disk |
| Labelled punches | **1,579** (0 dropped as "not shown"; 12 of the landed ones drawn by the game as a glancing touch) |
| Training / test split (by body) | 128 clips, 1,259 punches / 32 clips, 320 punches |
| Bodies used | 18 of the 19 boxers; 108 women's clips, 52 men's; 60 of 320 boxer places are southpaws |
| Room | arena 92 clips, gym 68 |

| Punch type | Count | | Result | Count | | Camera | Clips | Punches |
|---|---|---|---|---|---|---|---|---|
| Jab | 364 | | Landed | 644 | | tv | 40 | 384 |
| Cross | 344 | | Blocked | 474 | | corner | 40 | 397 |
| Lead hook | 234 | | Missed | 461 | | phone | 40 | 408 |
| Rear hook | 330 | | | | | tripod | 40 | 390 |
| Lead uppercut | 129 | | To the head | 1,402 | | | | |
| Rear uppercut | 178 | | To the body | 177 | | | | |

Left hand 753, right hand 826. All 177 body punches are the game's one body shot, a rear-hand hook, which is why "rear
hook" is larger than "lead hook". The punch motion is 20 different bought clips (jab and cross four takes each, the
others one or two), so 1,579 punches are 20 motions seen on different bodies, from different lenses, at different
ranges - not 1,579 different punches.

Speed: a run of four clips takes 50 to 95 seconds (render and save about 50 frames a second, plus loading two
bodies), so the whole set is about 50 minutes of rendering. The processor stayed at 51-62 C.

### Checked by eye

Stills only, opened with the file viewer: 20 frames with the joints, boxes and glove points drawn over them (all four
cameras, women and men, a southpaw), 12 frames at a punch's contact with the label printed on them, 6 first frames.

- The joints sit on the bodies in every one, through the game's own cutting broadcast lens as well. (The first test
  drew them 50 pixels off: the engine's own "where is this point on screen" answers in stretched window units. The
  tool now projects through the lens itself and checks the window is exactly the size asked.)
- In the 12 contact frames the ring drawn at the labelled glove sat on the punching glove of the named boxer wherever
  it could be seen (in two it was behind the post or rope of the defect below). Whether "landed", "blocked" and
  "missed" read right was judged at a glance on small stills, not measured.
- **Defect found and fixed:** the ringside phone camera stood right behind a corner post or with a rope across the
  lens in 3 of 12 frames. It now stands beside a side of the ring, between two ropes or above the top one, and the 22
  phone clips rendered before the fix were rendered again.
- Left as it is: the corner camera sometimes cuts a near boxer off at the frame edge (real corner cameras do); the gym
  room is plainly boxes and cylinders; one clip in eight has both boxers in the same kit by design.
- No clip was watched as moving video by a person. He should watch three or four before anyone relies on the set.

### What the synthetic clips do not have yet

- A referee, corner men or anyone else in the ring. In real video the referee is the main cause of a hidden boxer.
- Clinches, knockdowns, body jabs and straight punches to the body (the game throws only hooks to the body).
- Whether a joint is hidden behind the other boxer: the label says only "inside the picture or not".
- Nose, eyes and ears are fixed points on the head bone (right to about 2 cm), not face joints.
- Real cloth, sweat, motion blur of a real shutter, compression of a phone, a real crowd, real gyms.
- Head guards (amateur youth and women's bouts wear them; ours do not).

## What the synthetic clips teach - the measurement

**Not measured.** The task asked: train the classifiers on synthetic clips only, score them on the real Olympic set,
and say how big the synthetic-to-real gap is. That needs an AI to learn from renders of the bought punch clips, which
their licence does not allow without written permission (previous section). It was not run, so there is no gap
number on this page, and nothing here should be read as one.

**What is ready the day the permission (or our own punch motion) is there**, with the venv's Python:

```
python ops\Tools\fight_video\synth_data.py pose <synth> <synth_work>
python ops\Tools\fight_video\synth_eval.py <synth> <synth_work> --olympic <olympic_kaggle> <work_scene> --boxingvi <boxingvi> --json out.json --save <models_ours>
```

- The first line is the pose pass over every clip (about 80 minutes on the graphics card, one clip at a time, the
  watchdog asked every ten clips).
- The second trains the punch filter, the result classifier and a six-type punch classifier on the training clips
  only (their bodies never appear in a test clip) and prints, for the rules and for the trained layer: punches found,
  reported punches that are real, who threw it, hand, head/body, result and - new - punch type, on the synthetic test
  clips, per camera; then the same models on the 29 real Olympic bouts beside the reference "trained on real labels,
  folds by bout"; then the type classifier on BoxingVI's 4,743 real clips. Each synthetic clip is read twice: through
  the analyzer's own eyes (pose model and picker on the video) and from the exact joints (the ceiling).
- `synth_eval.py ... --no-train --models <dir>` is the test-only version: nothing is learnt, the rules and the research
  models are scored against the exact labels, and the pose model's joints are compared with the exact ones.

**The one look that happened** before the clause was read (16 training and 8 test clips, exact joints, in memory,
not saved, not repeated; too small to rely on): the candidate net caught 88% of the labelled punches; the rules found
64% of them with 52% of their reports real; the fitted layer 68% and 71%, punch type right on 53% of 51 punches against
24% for the commonest type. It says the label and matching code works end to end, and nothing about real video.

**What was measured on real footage today** is in the two sections further down: the picker fix (punches found on the
real bouts 44% -> 54% at the same share of real ones) and the detector swap.

## Track 2a - footage with a free licence

`ops/research/fight_video_cc_manifest.json`: 67 clips whose licence was read on the clip's own page (Wikimedia Commons
64, Internet Archive 3), each with page and file address, licence, author, the attribution text to print, a ShareAlike
flag, length, size, what it shows, a minors flag, a 1-5 score for punch labelling, and our decision (`use_in_our_set`).
39 more are listed as rejected with the reason (NonCommercial, a licence review still pending, doubtful
public-domain claims, not boxing). **Nothing was downloaded** by this task; content was judged from still frames and
the page text, never from watching a clip through.

| Our decision | Clips | Minutes | Size |
|---|---|---|---|
| **Candidate** (adults, score 3 or more, no ShareAlike) | 26 | 64 | 1.0 GB |
| Candidate but ShareAlike (kept apart, see the licence table) | 6 | 6 | 35 MB |
| Held: ages not confirmed | 10 | | |
| Excluded: shows minors | 7 | | |
| Low value for punch labels (score under 3) | 14 | | |
| A weaker copy of another clip | 4 | | |

What the 26 candidates are: 22 public domain (US military boxing nights filmed by the services; Dutch newsreels of
professional bouts, 1931-1949; US films of 1891-1907) and 4 CC BY (three Finnish newsreel items of 1947-1961, one
100-frames-a-second heavy-bag clip). Honest value: only six adult clips score 4 and they total under five minutes;
most of the rest is black-and-white newsreel with cuts. Good as a varied TEST set of real boxing, thin as training
data. The best modern two-boxer material is ShareAlike (four technique and sparring lessons from Colombia's sports
ministry, 320 x 224) or mixes youth and adult bouts (a 44-minute national championship: excluded).

Rules applied:
- **The two clips already on disk are held.** "Day of the Town - Russian boxing 0025 / 0029" (CC BY-SA 4.0, Zelio007)
  show head guards and young-looking boxers; ages are not known, so they stay out of the set. They were used only to
  look at the analyzer and to test the labelling tool.
- A copyright licence is not consent: the boxers, referees and spectators in these clips agreed to nothing. For the
  public-domain newsreels that is a small risk; for recent clips it is a question for a lawyer before anything trained
  on them is sold.
- The 26 candidates are about 1.0 GB: at the limit he set for asking first, so they wait for his yes.
- More public-domain material exists and is not listed: the US military's own video site (dvidshub.net) holds many
  boxing nights and refused automated reading on the day. The manifest's notes say how to filter YouTube and Vimeo
  for CC BY.

## Track 2b - the labelling tool for clips he films

`ops/Tools/fight_video/label_tool.py`. It opens nothing by itself: he starts it, then opens the address it prints.

```
E:\FightCamp\fight_video_data\venv\Scripts\python ops\Tools\fight_video\label_tool.py <video> --out <folder>
```

1. If the folder has no proposals yet, the analyzer runs first (a few minutes per minute of video; it asks the PC
   watchdog itself).
2. It prints `Open this address in your browser to label: http://127.0.0.1:8791/`. Open that in Chrome. Ctrl+C in the
   terminal stops it.
3. The page plays each proposed punch in a slow loop with a ring round the glove. Keys:

| Key | Does |
|---|---|
| Enter | Right as shown: next punch |
| X | Not a punch |
| A / S | Other boxer / other hand |
| 1 2 3 4 5 6 | Jab, cross, lead hook, rear hook, lead uppercut, rear uppercut |
| H / B | Head / body |
| L / K / M | Landed / blocked / missed |
| N | Add a punch the analyzer missed, at the frame on screen |
| [ C ] | Start here / contact here / end here |
| Arrows, R, Space, comma, full stop, F | Previous / next, replay, pause, one frame back / on, free play |

4. Every change is saved at once to `<folder>\labels.json`: the same punch records as the synthetic clips, plus what
   the analyzer proposed and whether the person confirmed, fixed, added or rejected it.
5. The clip counts as **ready for training** only when every punch is checked and both consent boxes are ticked:
   "everyone filmed agreed in writing to this use" and "nobody filmed is under 18". Who filmed it, where and when go in
   the same record.

The video must be one a browser plays (H.264 .mp4 or .webm). A phone's HEVC file is converted first:
`ffmpeg -i in.mov -c:v libx264 -crf 18 -an out.mp4`.

Tested in a headless browser on the Commons clip: confirm, reject, fix, add, the refusal of a punch without a type,
saving and the consent gate all work. Not yet used by a person on a full clip, so the time per punch is not measured.
Expect the analyzer to propose about half of the real punches and about half of its proposals to be real (its measured
numbers), so `N` and `X` will be used a lot until the models improve.

**What to film** (to make the first real clips worth the most): two boxers sparring, whole bodies in the picture,
from outside the ropes at chest height and from a corner, 50 or 60 frames a second, two different kit colours, 3 to 5
rounds, several pairs. Written consent from everyone in the picture, adults only.

## The picker fix (several bouts in one file)

The analyzer page named this as the first thing to fix: the picker looked for one pair of kit colours per video, and
files holding several bouts broke it. Two changes in `track.py`, both without training, measured on all 29 Olympic
bouts (4,609 referee labels) against the picker as it was:

1. **The kit pair is chosen per bout.** The stretches between cuts are grouped into bouts where the kit colours change
   (the cheapest split of the file into runs whose boxer candidates fall into at most three colour groups: two boxers
   and a referee). Each bout gets its own two kits, its own referee group left out, and its own lead hand per boxer.
   Five files turned out to hold two bouts; the other 24 stay whole.
2. **The opponent is the fighter next to him.** When one boxer is found by his kit and the other slot is empty (his kit
   is misread in that light), a boxer candidate standing right beside the found one, of his size and not in the
   referee's colours, is taken as the other boxer. This was the cause of the worst file (one boxer seen on 26% of
   frames), not a second bout.

| All 29 bouts | Picker as it was | Per-bout pair only | Both changes |
|---|---|---|---|
| Labels where both boxers are seen (the ceiling) | 74.4% | 76.2% | **87.1%** |
| Labels the candidate net catches | 57.1% | 59.4% | **68.1%** |
| Rules only: punches found | 49.4% | 51.5% | **60.3%** |
| Rules only: reported punches that are real | 27.8% | 28.2% | 27.5% |
| Both boxers picked, share of frames (mean over bouts) | 68% | - | 80% |
| Per file, labels caught: worst / middle / best | 16% / 66% / 88% | 16% / 67% / 88% | **38% / 74% / 90%** |

The files that were broken (labels caught, before -> after): GH178416 16% -> 63%, GH198416 19% -> 85%, GH208416
25% -> 74%, GH158416 44% -> 81%, GH089681 47% -> 70%, GH098416 30% -> 51%. Files that were already good gain 2 to 4
points; two files lose one point (74% -> 73%, 75% -> 74%). Precision of the rules does not move: the picker finds more
real punches and about as many false ones in proportion.

The trained layer on top of the new picker is in the measurement above ("trained on real labels, folds by bout").
`test_dataset.py` holds three checks on the bout split (one bout stays whole, two are split where the kits change, a
referee does not cause a split); the check goes red when the split is switched off.

## The person detector: a clean replacement

The detector used until now (YOLOX-m "humanart") was trained on a set offered for non-commercial use only. Its
replacement is in place as a switch, not yet as the default:

- **RF-DETR Small** (Roboflow), exported by us from the official package to one model file
  (`models\rfdetr_small.onnx`, 122 MB) with `detector.py export small <file>`. The maker's licence text names this
  size as Apache-2.0 and "commercially usable out of the box" (full quote in the licence table).
- Our own small wrapper (`detector.py`); `pose.py` and `analyze.py` take `--detector <file>`.

Measured on two real Olympic bouts, same pose model, same picker and rules, only the detector changed:

| | GH118416 (one bout) | | GH208416 (two bouts in the file) | |
|---|---|---|---|---|
| | YOLOX-m humanart | RF-DETR Small | YOLOX-m humanart | RF-DETR Small |
| People reported a frame | 5.5 | 8.8 | 4.9 | 8.0 |
| Labels where both boxers are seen | 90% | **96%** | 78% | 76% |
| Labels the candidate net catches | 80% | 82% | **74%** | 64% |
| Rules: punches found / real | 74% / 35% | 77% / 32% | **67% / 20%** | 56% / 18% |
| Hand right | 74% | 77% | 69% | 68% |
| Both boxers picked, share of frames | 81% | 87% | 81% | 75% |
| Pose pass speed | - | 13.4 frames a second | - | 14.4 frames a second |

Plainly: it works as a drop-in and is a little better on the clean bout, and it is worse on the harder file. It
reports eight or nine people a frame where the old one reported five (it also picks up the people at ringside), which
slows the pose pass to 13-14 frames a second (the old one runs 21-25 with three or four people in view) and hands the
picker more wrong candidates. The score threshold (0.4) and the cap of ten people are first guesses, not tuned, and
two bouts are too few to settle it: the full 29-bout run with it is about two hours of the graphics card and was not
done. Before the switch becomes the default it needs that run and a threshold that drops the ringside.

The detector is the smaller half of the problem. The joint model (RTMPose "body7") learnt from seven sets, one of
which says "Commercial use is not allowed" (licence table). Swapping the detector does not make the tool sellable.

## Licences - every source and model

Read on the page or file named, 2026-11-15 and 2026-11-16. "Unknown" means not confirmed, not "fine".

### Data

| Source | Licence as written | Commercial use | What it requires |
|---|---|---|---|
| **Our synthetic clips** (`synth\`) | Rendered from our own game, but the punches are MoCap Online clips (AI use "requires explicit and prior written permission"), the guard is from Rokoko's free pack (AI terms unclear), the bodies are Epic MetaHumans (terms not readable without a login) and the glove is CC BY 4.0 | **No, not for AI, until MoCap Online agrees in writing**; unknown for the bodies | See "The rights problem found on the way". With the permit: training our own models. Selling the clips themselves as a dataset is a further question (MoCap Online §2.1 forbids redistributing the items "as-is or as part of any other collection of files"; rendered video is not named). |
| Synthetic clips rendered with motion we own (our authored clips, our own captures) | Ours, apart from the MetaHuman bodies | **Yes once the Epic terms are read** | Not built yet |
| Clips he films himself, with consent | Ours, with each person's written consent on record (the labelling tool stores who, where, when) | **Yes** | Written consent that names training and commercial use; adults only |
| Wikimedia Commons clips, CC BY | Creative Commons Attribution | **Yes** | Print author, title and licence (the manifest has the text per clip) |
| Wikimedia Commons clips, CC BY-SA | Attribution-ShareAlike | **Yes, with a flag** | Attribution; anything "adapted" from them must carry the same licence. Whether a trained model is an adaptation is unsettled: kept apart (flag in the manifest) until a lawyer has read it. People in the clips did not consent to anything: a personality-rights question in some countries. |
| US-government public-domain clips | Public domain (works of the US federal government) | **Yes** | Nothing by copyright; service members shown still have personality rights |
| Olympic Boxing Punch Classification (Kaggle) | "The data is for use in non-commercial settings: in academic institutions for teaching and research purposes and in non-profit research organizations." | **No** | Written permission from the authors. Used here to measure only. Its youth bouts never enter our set. |
| BoxingVI | No licence file; its videos are ordinary YouTube uploads | **No** | Permission from the authors and the video owners. Measure only. |
| Jabbr DeepStrike output | Its terms forbid training a fight-statistics AI on its statistics | **No** | Never a data source or labeller; no video of ours goes to it |

### Models and code

| Piece | Licence as written | Commercial use | What it requires |
|---|---|---|---|
| Models trained on our synthetic clips | None exist: not trained (the permit comes first) | - | `synth_eval.py --save` writes them once it may run |
| The three models trained on the Olympic set and BoxingVI (`models\punch_*.pkl`) | Inherit those sets' terms | **No** | Research only; never shipped |
| RF-DETR Nano / Small / Medium / Large (the detector we now export) | Repository text: "The `rfdetr` package, RF-DETR Nano, Small, Medium and Large detection ... are released under the Apache 2.0 license, so they're commercially usable out of the box: you can ship them in closed-source, commercial products, including self-hosted deployments, without paying a license fee" | **Yes, by the maker's written statement** | Keep the Apache licence and notice. Still unknown: the docs say the checkpoints are "COCO-pretrained"; whether Objects365 ("available for the academic purpose only") was also used for these sizes is not stated on the repository pages. COCO's own terms: annotations CC BY 4.0, images "must abide by the Flickr Terms of Use". |
| RF-DETR XL, 2XL, Atto, Femto, Pico | "Roboflow Platform Model License (PML 1.0)": "commercial self-hosting requires the Enterprise add-on" | Only with that paid add-on (no price shown) | Not needed: Small is enough |
| YOLOX-m "humanart" (the detector used until now) | Apache-2.0 project; trained on Human-Art: "request authorization to use Human-Art for non-commercial purposes" | **No** (research only) | Replaced by RF-DETR for anything sold |
| RTMPose-m "body7" (2D joints) | Apache-2.0 project, no licence line for the weights; trained on seven sets, one of which (MPII Human Pose) says "Commercial use is not allowed due to the fact that the authors do not have the copyright for the images themselves" | **No, as it stands** | This is now the blocking piece. Options, cheapest first: (1) train our own pose model on our synthetic clips (exact joints for every frame) plus consented footage; (2) MediaPipe BlazePose (model card: "LICENSED UNDER Apache License, Version 2.0", trained on consented images), one person per crop, behind our detector: not tested here; (3) a vendor model with a paid licence. |
| rtmlib 0.0.16, mmpose and YOLOX code, ONNX Runtime (+DirectML), OpenCV, numpy, scipy, scikit-learn | Apache-2.0 / MIT / BSD | **Yes** | Keep the notices (OpenCV's wheel bundles FFmpeg under LGPL: do not relink it statically) |
| rtmlib's own `RFDETR` wrapper file | Says "Code modified from" a repository whose licence is Attribution-NonCommercial 4.0 | **Not used** | We wrote our own wrapper (`detector.py`) |
| PyTorch, the `rfdetr` package (export step only, `venv_rfdetr\`) | BSD-3 / Apache-2.0 | **Yes** | Not shipped: needed once to export the detector |
| FFmpeg with x264 (packs the frames into a video) | GPL build | **Yes** as a tool | Its output is not covered; do not bundle the program itself in a product without reading the GPL |
| ultralytics YOLO | AGPL-3.0 unless a paid licence is bought | **Not used, on purpose** | - |

## What is still missing

In order of what blocks a sellable version:

1. **Rights to train on the synthetic clips** (see "The rights problem found on the way"): written consent from the
   motion-capture vendor, or punches we own in the renderer. Until then the synthetic clips are a test set only.
2. **A pose model we may sell.** The detector is solved (RF-DETR); the joint model is not (one of its training sets
   forbids commercial use). The clean route is our own pose model trained on our renders and consented footage, which
   depends on item 1; the fallback is a model trained on consented images (BlazePose), not tested here.
3. **Real clips of our own.** None filmed yet. The labelling tool is ready; nobody has labelled a full clip with it, so
   the minutes of work per minute of video are unknown.
4. **The free-licence clips are listed, not downloaded** (two were already on disk). ShareAlike and people's own rights
   in those clips need a lawyer's one-page reading before they train anything sold.
5. **A referee and corner men in the synthetic ring**, clinches, knockdowns, straight punches to the body, head guards,
   and "hidden behind the other boxer" labels per joint.
6. **A classifier that looks at the picture** round the glove for landed / blocked / missed (the analyzer page's
   step 3): the synthetic clips have the exact answer for every punch, which is what that classifier needs.
7. **The synthetic-to-real number for a model trained on our clips.** The tool that measures it is written
   (`synth_eval.py` without `--no-train`) and was not run, for the reason in item 1.
8. Not done by this task: `ops/RESEARCH_INDEX.md` sync, the push, a lawyer's reading of anything on this page.

## Where everything is

- In the repository: `tools/fight_video_synth.gd`, `fight_video_synth_script.gd`, `fight_video_synth_set.gd`,
  `fight_video_synth_pose.gd` (the renderer); `ops/Tools/fight_video/synth_render.py` (the batch), `synth_data.py` (loaders,
  pose pass, counts), `synth_eval.py` (the measurement), `label_tool.py`, `detector.py`, `test_dataset.py` (10 checks);
  changed: `track.py`, `punches.py`, `pose.py`, `analyze.py`; `ops/research/fight_video_cc_manifest.json`.
- Outside the repository, `E:\FightCamp\fight_video_data\`: `synth` (the clips, labels, `manifest.json`, render logs),
  `work_scene` (the 29 Olympic bouts re-read with the new picker, `picker_compare.json`, `report_olympic_newpicker.json`),
  `models_scene` (the filter and result models retrained on the Olympic set with the new picker: research only),
  `work_rfdetr` (two Olympic bouts read with the new detector), `models\rfdetr_small.onnx` and its checkpoint,
  `venv_rfdetr` (PyTorch, needed only to export the detector).
- Shared notes of this group of sessions hold the helpers' full licence reports (detector and pose weights; the asset
  licences' AI clauses) and the first manifest file.
- No dataset, video or trained model is in git.
