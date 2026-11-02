# G83 - the clinch floor per seat, and the third camera (Grok) - FULL, collected S62 2026-09-24

Source: grok.com chat "G83 Clinch Distances & Third Camera", Expert mode, 97 sources; Grok's 4-page PDF
pasted as text and transcribed here by Claude. Task: TASK_G83_CLINCH_DISTANCE_AND_THIRD_CAMERA.md.
Labels: MEASURED / DERIVED / JUDGEMENT / NOT FOUND on every numeric cell.

## THE TWO INSTRUCTIONS CLAUDE TAKES FROM IT (lead's reading)
**Engine (S63+ follow-on to S62's single 0.28 m clinch floor):** split G79's one band into TWO floors -
**LOCK 0.24 m** (body lock, hips-in cage, compressed over-under) and **FRAME 0.38 m** (Thai plum,
hips-out cage). Single collar tie and the standing front headlock are NOT those floors: they need a
loose leash plus a LATERAL offset or they are the first visual error. Scale the clinch floors by the
pair's mean CHEST DEPTH / 0.254 m, not by arm length ("arm length does not set torso stack").
Closing: the pummel is a creep (<= 0.4 m/s); body lock and snap-down are pulses (>= 0.8 m/s).
**Capture (C181 recipe b):** third camera at ~42 deg elevation, ~45 deg azimuth off the pair axis,
YAW-SLAVED to the pair. No nadir. No end-on. Expect detection to rise from ~10% to maybe half, not to
100%: "seeing pixels of a hip is not the same as the tracker emitting a hip keypoint."

## Convention
Distances are COM-to-COM approximated as hips-to-hips along the line joining the pelvic origins,
metres, unscaled mid-weight male (ANSUR II working male: stature 1.756 m, chest depth 0.254 m).
Closing speed = relative COM speed in the last 0.3 s into the locked seat.

## 0. What does not exist
NOT FOUND: no published mocap, broadcast-tracking or marker study reports hips-to-hips or COM-COM
distance per named MMA / Thai / wrestling clinch seat. Trial & Wu (2014) is the only instrumented
clinch comparison (N=10 amateur MMA, 2D video 60 Hz, markers greater trochanter / lateral femoral
epicondyle / greater tubercle): they measured hip ANGLE, not distance - "the hip was farther away
from the target for the double collar-tie than for the double underhook." No UFC/IMMAF tracking
product publishes inter-fighter pelvic range. Harmony4D and Hi4D reconstruct wrestler meshes but do
not tabulate inter-COM by grip. Closing speeds are JUDGEMENT bounded by strike approach speeds
(6-10 m/s at the fist, far faster than a torso close) and by the pummel starting in contact.

## 1. Anthropometric kit for DERIVED cells
ANSUR II male N=4,082 (Gordon et al. 2015, NATICK/TR-15/007): chest depth mean 0.254 m (SD 0.026).
Two half-torsos flush, uncompressed = 0.254 m; hard squeeze compresses 10-15 mm per chest -> ~0.22 m.
ISO/TR 7250-2 German male P50 body depth standing 0.285 m (the hip stack if pelves meet square).
Upper-arm circumference ~0.34 m -> diameter ~0.108 m; one interposed upper arm adds ~0.05-0.06 m.
A clamped Thai plum's forearm frame props the chests apart by ~0.08-0.12 m beyond flush.
Identity: hips ~ 0.5 D_chest_A + 0.5 D_chest_B + G (interposed limb) + S (sit-back; ~0 in a body
lock, 0.08-0.16 m in a working plum).

## 2. PART A - one row per seat
Same-distance seats: body lock / double underhooks = hips-in cage pressure. Do NOT merge over-under
with body lock (the extra arm lives between the chests). Do NOT merge any collar-tie seat with any
underhook seat (Trial & Wu is the warrant).

| Seat | hips band (m) | how the number is made | close-in speed (m/s) | tag |
|---|---|---|---|---|
| Over-under (pummel) | 0.26-0.36, centre ~0.31 | flush 0.254 + one interposed upper-arm half-diameter ~0.055; tight pummel 0.26, loose 0.36; coaching "belt-to-belt / cup-to-cup" (Salvador, The Arena Gym) is this seat | 0.15-0.40, already in contact, the swim is a slow circle | DERIVED band / JUDGEMENT speed / measured NOT FOUND |
| Double collar tie / Thai plum | 0.34-0.48, centre ~0.40 | flush 0.254 + plum frame 0.08-0.12 + sit-back 0.06-0.12 for the knee lane; Trial & Wu N=10: hip flexion 103.2 +- 13.4 deg (collar) vs 88.4 +- 12.4 (underhook), p<0.001, "hip farther from the target" in collar tie; long-guard plum at the top of the band, clamped plum at the bottom | 0.60-1.20, step-in then clamp, not a pulse | DERIVED band / MEASURED angle only / JUDGEMENT speed |
| Single collar tie | 0.40-0.58, centre ~0.48 | one hand on the nape, free hand fighting; chests not stacked; the collar arm is a 0.4-0.5 m leash, not a frame; wrestling collar-and-elbow opening range, not a lock. Do not reuse G79's 0.28 here | 0.80-1.50, from the boxing pocket into the tie | JUDGEMENT / measured NOT FOUND |
| Body lock / double underhooks | 0.22-0.32, centre ~0.26 | two half-chests compressed 10-15 mm/side, no interposed arm (both under, hands gabled on the back); tightest standing stack; Trial & Wu: hip closer than collar tie. G79's 0.28 sits on the upper half - a shared floor with over-under only with a 4-6 cm error on the lock | 0.80-1.60 PULSE: level change + hip shoot | DERIVED band / JUDGEMENT speed |
| Standing front headlock (snap-down, pre-knee) | 0.28-0.44 along the pair axis + 0.15-0.30 LATERAL offset | COMs are not coaxial: attacker's hips beside/behind the snapped posture, victim folded at the waist; pair-axis hips-to-hips can look like a body lock while the true 3D gap has a large lateral part. Treating it as G79 0.28 on one axis plants the attacker inside the victim | 1.00-2.00 PULSE down-and-in | JUDGEMENT / measured NOT FOUND |
| Cage-pressure clinch (one back on the fence) | hips-in 0.22-0.32; hips-out knee 0.32-0.42 | the fence removes the escape DOF so hips-in is the SAME stack as the body lock; hips-out fence knee (Thai on the cage) reopens sit-back and inherits the plum floor. No cage-tracking study found | 0.50-1.20, drive into the fence then stall | DERIVED hips-in / JUDGEMENT hips-out and speed |

Engine instruction (Grok's words): "Keep two floors, not six: LOCK = 0.24 m (body lock, hips-in
cage, tight over-under compressed) and FRAME = 0.38 m (plum, hips-out cage, single collar lower edge
is above FRAME). Single collar and front-headlock need a third, looser floor plus an offset, or they
will be wrong. G79 0.28 is a LOCK-floor number. Using it on FRAME seats is the 'one metre for every
weight' error restated."

## 3. Sources that almost measured it
Trial & Wu 2014, "A kinematic analysis of the Thai boxing clinch", Adv. Biomech. Appl. 1(1):57-66 and
ISBS 2013 P04-14: N=10 amateur MMA (23 +- 5 y, 1.8 +- 0.1 m, 73.3 +- 11.4 kg), 2D JVC GR-D371V 60 Hz,
right-side markers, APAS 8 Hz filter, six dominant-leg knees per seat into a padded partner. Hip
angle collar 103.2 +- 13.4 vs underhook 88.4 +- 12.4 deg, p=0.00. Linear hip distance NOT reported.
ANSUR II chest depth MEASURED N=4,082 (mean 254 mm, SD 26). ISO 7250 national summaries, not
fighters. Coaching geometry, not data: Salvador "cup to cup or belt to belt" (over-under / body-lock
family); Sherdog / Evolve threads on sucking the hips in to kill the knee lane (the FRAME -> LOCK
transition the engine must allow).

## 4. PART B - the third camera
### 4.1 Occlusion geometry (JUDGEMENT; no measured hip-visibility study)
Closed guard: the top man's hip joints sit inside the cylinder of the bottom man's femurs + pelvis.
From azimuth 90 deg (true side - the two existing cameras) the near femur is a slab in front of the
greater trochanter; both side cameras see a thigh, not a hip. From 0/180 deg (end-on) the stack is
torso-pelvis-pelvis-legs and the hip crease is edge-on (3.6% on mount, worse in guard). From 90 deg
elevation (nadir) you see the top man's back and the dorsal ankle lock; the hips are under the iliac
crests (9.8% on mount even without a wrap - the top torso itself roofs the hips). Half guard: the
wrapped-side hip is hidden from its side camera, the free-side hip visible; one third camera cannot
cover both sides - prefer the free-leg side if the engine knows which half. Mount: the occluder is the
top man's own torso; hips appear once the camera looks over the near shoulder / lat past the head-hip
line - oblique, not nadir, not side.

### 4.2 What broadcast and mocap actually put in the air
| practice | geometry | sees top hips in a wrap? | tag |
|---|---|---|---|
| UFC live cage | 4 manned handhelds on the 8 catwalk platforms over the 1.95 m fence; 2 Talon robotics (one on the truss above the cage); jib; FenceCam; Sphere-era rig 32 ft (9.8 m) above canvas; platforms look down ~25-40 deg at 3-6 m | the perch/handheld high-oblique IS broadcast's answer to ground fighting; nadir robotic is for geography; FenceCam is the worst case for hips | MEASURED positions / hip yield NOT FOUND |
| IJF camera plan | 16+ cameras per tatami; Cam 1 "high up in venue, lined up with the centre of the tatami" 40x; Cam 2 matside within 1 m; jib >= 9 m; techno-crane 21 m at Worlds 2021; Japanese study (Research J Budo 55:27-37, 2022, 461 matches): one spectator-tier camera is not enough | high master + matside pair = judo's "two sides + one high"; osaekomi is nearer mount than guard | MEASURED plan / hip yield NOT FOUND |
| Harmony4D (arXiv 2410.20294, NeurIPS 2024) | >= 20 synced GoPros 4K/60 in a portable ring "roughly floor level" + optional Aria ego; 208 sequences incl. wrestling / MMA / grappling; HMR methods "fail under severe occlusion and contact" | a floor-height ring is the current 1x2 multiplied; beats occlusion by view count and ego cameras, not by one clever angle | MEASURED rig class / elev-az NOT FOUND |
| Hi4D (ETH, CVPR 2023) | 106 cameras (53 RGB + 53 IR), volume 2.8 m dia x 3.0 m; 20 pairs, 100 sequences; contact if point-to-surface < 1-2 cm | surround + height + implicit avatars; even 100 cameras fuse two torsos without a prior | MEASURED volume / per-view yield NOT FOUND |
| CMU Panoptic / BJJ_GNC | 480 cameras + Kinects in a dome (Nica Ross, "Permanent Visibility"); point clouds still tear on wrapped grappling | more views help identity more than they reveal a hidden trochanter | MEASURED dome / guard yield NOT FOUND |
| ViCoS BJJ Positions (Hudovernik & Skocaj) | 3 smartphone cameras, 6 sparring sequences, 120,279 labelled frames, 10 positions incl. closed / half / mount; accuracy collapses as bbox IoU (occlusion) rises | existence proof that a third view helps classification; angles not published | MEASURED 3-cam / angles NOT FOUND |

### 4.3 The angle to use (JUDGEMENT, from occlusion geometry + the UFC perch / IJF Cam-1 / Hi4D class)
| position | elevation above the canvas, relative to the pair COM | azimuth from the line joining the two men | why |
|---|---|---|---|
| Closed guard | 40 +- 8 deg | 40-50 deg off the pair axis, toward the top man's near-hip / free-shoulder side; never 0 (end-on), never 90 (pure side) | looks over the near femur into the trochanter; < 30 deg hits the thigh slab; > 55 deg starts to roof the hips like nadir |
| Half guard | 35 +- 8 deg | 35-55 deg off axis, on the FREE-LEG side | the trapped side is still a closed-guard problem; if the engine cannot pick a side keep 45/45 and accept one-sided loss |
| Mount | 45 +- 8 deg | 30-45 deg off axis, slightly toward the HEAD end | the occluder is the top torso; head-end oblique sees the belt line past the lat, foot-end sees glutes (the 3.6% miss) |
**Operational single setting: elevation 42 deg, azimuth 45 deg off the pair axis, on a shoulder of
the pair (not on the axis, not on the perpendicular), yaw-slaved to the pair axis** - the UFC
catwalk-perch angle compressed onto a pair-relative frame. A world-locked third camera becomes
end-on the next time the pair turns 45 deg.

## 5. Against itself
Which seat's number fails first: the standing front headlock - a 2D band for a 3D offset; a pair-axis
floor either buries the attacker in the victim's mesh or leaves a phantom gap the animation slides to
close. Second: single collar (not a lock; a wide guess with no marker). Least fragile: body lock /
hips-in cage (two half-chests plus compression). Why a third camera may still miss the hips: (1) wrap
+ own-torso double roof leaves a corridor, not a window, and it closes when the top man postures or
the bottom scoops a hip; (2) the pair rotates faster than a locked camera - world-locked becomes
end-on; UFC solves it with operators; (3) markerless detectors want a silhouette, not a crease - the
9.8% overhead figure is a detector number, not photons on the sensor; (4) mount was the easy case and
still died at nadir and end-on; closed guard is strictly harder. Budget for ~10% -> maybe half, not
100%. The lab answer is many views plus a body prior, not a lucky third angle.

## References (opened by Grok)
Trial & Wu 2014 (Adv Biomech Appl 1(1):57-66; ISBS 2013 P04-14); Gordon et al. 2015 ANSUR II
NATICK/TR-15/007; ISO/TR 7250-2:2024; Khirodkar et al. Harmony4D arXiv:2410.20294; Yin et al. Hi4D
CVPR 2023; IJF Host Broadcaster TV Guide; Chimoiu "Judo Eyes" IJF.org 2021-06-09; Sports Video Group
UFC Fight Island / UFC 306 Sphere camera plots; Hudovernik & Skocaj ViCoS BJJ Positions; Ross,
Permanent Visibility / BJJ_GNC (CMU Panoptic); Salvador, The Arena Gym 2020; Research J Budo 2022
55(1):27-37.
