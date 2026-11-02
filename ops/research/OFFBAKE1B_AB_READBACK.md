# OFFBAKE1B game-camera A/B readback

Candidate evidence only. Claude opens every still; operator closes visual acceptance.

`animfix2_pose_room.gd -- as_game bench1=1 pose_log=1 seed=930093 offbake1=1 native_mh_clips=0/1`; MH09 Vance / MH08 Miller. Both players paused, source phase sought, four render frames settled. Broadcast camera; every saved still passed `still_framing.save_if_framed`. These frames verify source pose presentation, not hit timing, sliding or live fight contact.

Both runs saved ten framed stills without script errors. Shutdown reported three resources and PagedAllocator pages still in use; recorded in capture_receipt.txt, not hidden as a clean engine exit.

## Nose direction at contact and +4 frames

Angles below are Miller relative to Vance; zero means toward the opponent. +4 is exactly 4/30 seconds after each source contact clock.

| Source | Hook contact | Hook +4 | Uppercut contact | Uppercut +4 |
|---|---:|---:|---:|---:|
| legacy OFF | 5.52 deg | 34.50 deg | 15.10 deg | 0.88 deg |
| rejected OFFBAKE1 | 90.48 deg | 38.00 deg | 15.14 deg | 8.60 deg |
| new ON | 2.15 deg | 22.25 deg | 1.64 deg | 22.58 deg |

New hook: contact chest yaw 7.53 deg, lead elbow 90.03 deg, wrist L/R 0.19/0.32 deg. It reads as a compact short hook from this camera; operator must judge the silhouette. New uppercut: declared left fist 0.353 m ahead of head, head 0.048 m behind lead shoulder, wrists 0.19/0.32 deg. Source chamber-to-contact rise is 0.2854 m.

Guard/jab/cross bakes are byte-identical to the selected OFFBAKE1 sources. Their final ON nose angles remain 37.96/53.92/20.59 deg; the jab is oblique, as in the prior accepted-three reference. Guard sole pitch L/R 20.18/23.37 deg and roll 18.58/23.11 deg remain visible. The task explicitly assigns this foot defect to ANIMFIX4; no foot/mirror runtime code was changed.

## Per-still inspection

Primary opened every before/after file individually via the file-image tool. Each caption follows gap / noses / wrists / feet / defect / bodies. Historical rejected-native and wrong-hand candidates have their own readbacks/captions and are not the final ON set.

### Legacy OFF: guard

[Open still](../docs/previews/offbake1b/before/guard.png)

Gap: bodies remain a step apart without visible overlap; head centres 1.77 m apart. No live hit is demonstrated.  
Noses: Both look toward the other man. Vance yaw 1.91 deg; Miller yaw 1.91 deg.  
Wrists: Both guards are open, with gloves away from cheeks. Bone angles L/R: Vance 16.97/19.82 deg; Miller 17.53/21.16 deg.  
Feet: Wide uncrossed stance, feet meet the mat with rolled edges and raised heels; sliding cannot be established from a still.  
Defect: Legacy guard reference.  
Bodies: MH09 Vance, red shorts; MH08 Miller, purple shorts. before; guard.

### Native ON candidate: guard

[Open still](../docs/previews/offbake1b/after/guard.png)

Gap: bodies remain a step apart without visible overlap; head centres 1.56 m apart. No live hit is demonstrated.  
Noses: Both look obliquely toward the other man. Vance yaw 37.96 deg; Miller yaw 37.96 deg.  
Wrists: Both gloves sit high and close to the cheeks. Bone angles L/R: Vance 0.52/1.05 deg; Miller 0.19/0.32 deg.  
Feet: Uncrossed stance with visibly rolled feet and raised rear heel; existing ANIMFIX4 issue. Sliding cannot be established from a still.  
Defect: Unchanged straight-guard regression reference.  
Bodies: MH09 Vance, red shorts; MH08 Miller, purple shorts. native ON candidate; guard.

### Legacy OFF: jab_between

[Open still](../docs/previews/offbake1b/before/jab_between.png)

Gap: bodies remain a step apart without visible overlap; head centres 1.56 m apart. No live hit is demonstrated.  
Noses: Miller turns his torso away while his face stays oblique to Vance. Vance yaw 2.55 deg; Miller yaw 34.61 deg.  
Wrists: Left arm extends; right glove is drawn behind the torso. Bone angles L/R: Vance 16.97/19.82 deg; Miller 16.68/16.33 deg.  
Feet: Wide uncrossed stance, feet meet the mat with rolled edges and raised heels; sliding cannot be established from a still.  
Defect: Legacy jab between-frame already has almost full extension.  
Bodies: MH09 Vance, red shorts; MH08 Miller, purple shorts. before; jab_between.

### Native ON candidate: jab_between

[Open still](../docs/previews/offbake1b/after/jab_between.png)

Gap: bodies remain a step apart without visible overlap; head centres 1.58 m apart. No live hit is demonstrated.  
Noses: Miller faces obliquely toward Vance. Vance yaw 38.48 deg; Miller yaw 45.98 deg.  
Wrists: Left fist leaves guard with a bent elbow; right glove stays high. Bone angles L/R: Vance 0.52/1.05 deg; Miller 0.19/0.32 deg.  
Feet: Uncrossed stance with visibly rolled feet and raised rear heel; existing ANIMFIX4 issue. Sliding cannot be established from a still.  
Defect: Unchanged native jab between-frame.  
Bodies: MH09 Vance, red shorts; MH08 Miller, purple shorts. native ON candidate; jab_between.

### Legacy OFF: jab_contact

[Open still](../docs/previews/offbake1b/before/jab_contact.png)

Gap: bodies remain a step apart without visible overlap; head centres 1.52 m apart. No live hit is demonstrated.  
Noses: Miller looks obliquely toward Vance over the extended arm. Vance yaw 2.52 deg; Miller yaw 36.42 deg.  
Wrists: Lead glove droops relative to the forearm; rear glove is out of view. Bone angles L/R: Vance 16.97/19.82 deg; Miller 16.60/15.97 deg.  
Feet: Wide uncrossed stance, feet meet the mat with rolled edges and raised heels; sliding cannot be established from a still.  
Defect: Legacy jab contact is a reaching pose with an exposed rear guard.  
Bodies: MH09 Vance, red shorts; MH08 Miller, purple shorts. before; jab_contact.

### Native ON candidate: jab_contact

[Open still](../docs/previews/offbake1b/after/jab_contact.png)

Gap: bodies remain a step apart without visible overlap; head centres 1.60 m apart. No live hit is demonstrated.  
Noses: Miller looks across Vance instead of directly at him. Vance yaw 38.91 deg; Miller yaw 53.92 deg.  
Wrists: Left arm extends; right glove stays by the cheek. Bone angles L/R: Vance 0.52/1.05 deg; Miller 0.19/0.32 deg.  
Feet: Uncrossed stance with visibly rolled feet and raised rear heel; existing ANIMFIX4 issue. Sliding cannot be established from a still.  
Defect: Unchanged native jab contact; glove silhouette droops despite its straight bone line.  
Bodies: MH09 Vance, red shorts; MH08 Miller, purple shorts. native ON candidate; jab_contact.

### Legacy OFF: cross_contact

[Open still](../docs/previews/offbake1b/before/cross_contact.png)

Gap: bodies remain a step apart without visible overlap; head centres 1.41 m apart. No live hit is demonstrated.  
Noses: Miller looks at Vance while leaning forward. Vance yaw 4.90 deg; Miller yaw 4.91 deg.  
Wrists: Right arm extends and left glove rests near the chest. Bone angles L/R: Vance 16.97/19.82 deg; Miller 25.03/12.18 deg.  
Feet: Wide stance, lead foot flatter and rear heel raised; no crossed legs. Sliding cannot be established from a still.  
Defect: Legacy cross has a lower opposite glove than the native reference.  
Bodies: MH09 Vance, red shorts; MH08 Miller, purple shorts. before; cross_contact.

### Native ON candidate: cross_contact

[Open still](../docs/previews/offbake1b/after/cross_contact.png)

Gap: bodies remain a step apart without visible overlap; head centres 1.49 m apart. No live hit is demonstrated.  
Noses: Miller looks toward Vance behind his lead glove. Vance yaw 32.41 deg; Miller yaw 20.59 deg.  
Wrists: Right arm extends; left glove protects the face. Bone angles L/R: Vance 0.52/1.05 deg; Miller 0.19/0.32 deg.  
Feet: Uncrossed stance with visibly rolled feet and raised rear heel; existing ANIMFIX4 issue. Sliding cannot be established from a still.  
Defect: Unchanged native cross contact.  
Bodies: MH09 Vance, red shorts; MH08 Miller, purple shorts. native ON candidate; cross_contact.

### Legacy OFF: hook_between

[Open still](../docs/previews/offbake1b/before/hook_between.png)

Gap: bodies remain a step apart without visible overlap; head centres 1.79 m apart. No live hit is demonstrated.  
Noses: Miller looks toward Vance. Vance yaw 0.82 deg; Miller yaw 11.64 deg.  
Wrists: Lead glove is low near the waist; rear glove stays at the cheek. Bone angles L/R: Vance 16.97/19.82 deg; Miller 21.25/10.00 deg.  
Feet: Wide uncrossed stance, feet meet the mat with rolled edges and raised heels; sliding cannot be established from a still.  
Defect: Legacy hook starts from a low chamber.  
Bodies: MH09 Vance, red shorts; MH08 Miller, purple shorts. before; hook_between.

### Native ON candidate: hook_between

[Open still](../docs/previews/offbake1b/after/hook_between.png)

Gap: bodies remain a step apart without visible overlap; head centres 1.55 m apart. No live hit is demonstrated.  
Noses: Miller keeps his face toward Vance during the turn. Vance yaw 36.65 deg; Miller yaw 12.02 deg.  
Wrists: Left elbow rises outward; rear glove remains at the cheek. Bone angles L/R: Vance 0.52/1.05 deg; Miller 0.19/0.34 deg.  
Feet: Uncrossed stance with visibly rolled feet and raised rear heel; existing ANIMFIX4 issue. Sliding cannot be established from a still.  
Defect: New hook between-frame shows the lateral elbow and curved lead-arm path.  
Bodies: MH09 Vance, red shorts; MH08 Miller, purple shorts. native ON candidate; hook_between.

### Legacy OFF: hook_contact

[Open still](../docs/previews/offbake1b/before/hook_contact.png)

Gap: bodies remain a step apart without visible overlap; head centres 1.71 m apart. No live hit is demonstrated.  
Noses: Miller turns his chest but keeps his face toward Vance. Vance yaw 0.39 deg; Miller yaw 5.52 deg.  
Wrists: Left elbow bends; the lead wrist bends upward. Bone angles L/R: Vance 16.97/19.82 deg; Miller 21.57/5.14 deg.  
Feet: Wide uncrossed stance, feet meet the mat with rolled edges and raised heels; sliding cannot be established from a still.  
Defect: Legacy hook contact shows a bent elbow and a visibly angled glove.  
Bodies: MH09 Vance, red shorts; MH08 Miller, purple shorts. before; hook_contact.

### Native ON candidate: hook_contact

[Open still](../docs/previews/offbake1b/after/hook_contact.png)

Gap: bodies remain a step apart without visible overlap; head centres 1.55 m apart. No live hit is demonstrated.  
Noses: Miller faces Vance instead of turning his head away. Vance yaw 35.85 deg; Miller yaw 2.15 deg.  
Wrists: Left elbow bends near a right angle; rear glove stays at the chin. Bone angles L/R: Vance 0.52/1.05 deg; Miller 0.19/0.32 deg.  
Feet: Uncrossed stance with visibly rolled feet and raised rear heel; existing ANIMFIX4 issue. Sliding cannot be established from a still.  
Defect: New short hook has a compact contact silhouette; the old wrong-way head/chest turn is absent in this still.  
Bodies: MH09 Vance, red shorts; MH08 Miller, purple shorts. native ON candidate; hook_contact.

### Legacy OFF: hook_plus4

[Open still](../docs/previews/offbake1b/before/hook_plus4.png)

Gap: bodies remain a step apart without visible overlap; head centres 1.69 m apart. No live hit is demonstrated.  
Noses: Miller turns farther away after contact. Vance yaw 4.62 deg; Miller yaw 34.50 deg.  
Wrists: Both gloves retract near the face with elbows raised. Bone angles L/R: Vance 16.97/19.82 deg; Miller 12.87/7.80 deg.  
Feet: Wide uncrossed stance, feet meet the mat with rolled edges and raised heels; sliding cannot be established from a still.  
Defect: Legacy hook follow-through turns the chest and gaze farther away.  
Bodies: MH09 Vance, red shorts; MH08 Miller, purple shorts. before; hook_plus4.

### Native ON candidate: hook_plus4

[Open still](../docs/previews/offbake1b/after/hook_plus4.png)

Gap: bodies remain a step apart without visible overlap; head centres 1.56 m apart. No live hit is demonstrated.  
Noses: Miller remains obliquely facing Vance after contact. Vance yaw 37.20 deg; Miller yaw 22.25 deg.  
Wrists: Both gloves return toward guard. Bone angles L/R: Vance 0.52/1.05 deg; Miller 0.19/0.32 deg.  
Feet: Uncrossed stance with visibly rolled feet and raised rear heel; existing ANIMFIX4 issue. Sliding cannot be established from a still.  
Defect: New hook recovery does not repeat the old sideways contact turn.  
Bodies: MH09 Vance, red shorts; MH08 Miller, purple shorts. native ON candidate; hook_plus4.

### Legacy OFF: uppercut_between

[Open still](../docs/previews/offbake1b/before/uppercut_between.png)

Gap: bodies remain a step apart without visible overlap; head centres 1.83 m apart. No live hit is demonstrated.  
Noses: Miller tilts his head while looking toward Vance. Vance yaw 3.97 deg; Miller yaw 0.26 deg.  
Wrists: Active left glove is low; right glove folds under the chin with its elbow raised. Bone angles L/R: Vance 16.97/19.82 deg; Miller 147.49/38.17 deg.  
Feet: Wide uncrossed stance, feet meet the mat with rolled edges and raised heels; sliding cannot be established from a still.  
Defect: Legacy uppercut chamber has a distorted non-striking arm.  
Bodies: MH09 Vance, red shorts; MH08 Miller, purple shorts. before; uppercut_between.

### Native ON candidate: uppercut_between

[Open still](../docs/previews/offbake1b/after/uppercut_between.png)

Gap: bodies remain a step apart without visible overlap; head centres 1.62 m apart. No live hit is demonstrated.  
Noses: Miller keeps his face toward Vance. Vance yaw 37.05 deg; Miller yaw 12.55 deg.  
Wrists: Left fist rises in front of the face; the right glove stays close to the chin. Bone angles L/R: Vance 0.52/1.05 deg; Miller 0.19/0.32 deg.  
Feet: Uncrossed stance with visibly rolled feet and raised rear heel; existing ANIMFIX4 issue. Sliding cannot be established from a still.  
Defect: The left fist is separated from the guard and rising while the knees remain bent.  
Bodies: MH09 Vance, red shorts; MH08 Miller, purple shorts. native ON candidate; uppercut_between.

### Legacy OFF: uppercut_contact

[Open still](../docs/previews/offbake1b/before/uppercut_contact.png)

Gap: bodies remain a step apart without visible overlap; head centres 1.84 m apart. No live hit is demonstrated.  
Noses: Miller looks across Vance with his head tilted. Vance yaw 3.82 deg; Miller yaw 15.10 deg.  
Wrists: Left glove rises; right glove remains tucked under the chin with the elbow high. Bone angles L/R: Vance 16.97/19.82 deg; Miller 135.25/59.41 deg.  
Feet: Wide uncrossed stance, feet meet the mat with rolled edges and raised heels; sliding cannot be established from a still.  
Defect: Legacy uppercut rises clearly, but both wrist lines are bent.  
Bodies: MH09 Vance, red shorts; MH08 Miller, purple shorts. before; uppercut_contact.

### Native ON candidate: uppercut_contact

[Open still](../docs/previews/offbake1b/after/uppercut_contact.png)

Gap: bodies remain a step apart without visible overlap; head centres 1.64 m apart. No live hit is demonstrated.  
Noses: Miller faces Vance with his head behind the lead shoulder. Vance yaw 36.31 deg; Miller yaw 1.64 deg.  
Wrists: Left fist is raised with its elbow below; the right glove protects the cheek. Bone angles L/R: Vance 0.52/1.05 deg; Miller 0.19/0.32 deg.  
Feet: Uncrossed stance with visibly rolled feet and raised rear heel; existing ANIMFIX4 issue. Sliding cannot be established from a still.  
Defect: The declared left-hand uppercut is extended ahead of the face instead of remaining a crouched guard.  
Bodies: MH09 Vance, red shorts; MH08 Miller, purple shorts. native ON candidate; uppercut_contact.

### Legacy OFF: uppercut_plus4

[Open still](../docs/previews/offbake1b/before/uppercut_plus4.png)

Gap: bodies remain a step apart without visible overlap; head centres 1.69 m apart. No live hit is demonstrated.  
Noses: Miller looks toward Vance as the lead arm lowers. Vance yaw 4.03 deg; Miller yaw 0.88 deg.  
Wrists: Left arm remains out; right glove stays by the chin. Bone angles L/R: Vance 16.97/19.82 deg; Miller 161.73/32.71 deg.  
Feet: Wide uncrossed stance, feet meet the mat with rolled edges and raised heels; sliding cannot be established from a still.  
Defect: Legacy recovery retains the folded rear arm.  
Bodies: MH09 Vance, red shorts; MH08 Miller, purple shorts. before; uppercut_plus4.

### Native ON candidate: uppercut_plus4

[Open still](../docs/previews/offbake1b/after/uppercut_plus4.png)

Gap: bodies remain a step apart without visible overlap; head centres 1.60 m apart. No live hit is demonstrated.  
Noses: Miller remains obliquely facing Vance. Vance yaw 37.52 deg; Miller yaw 22.58 deg.  
Wrists: Left fist returns toward the high guard. Bone angles L/R: Vance 0.52/1.05 deg; Miller 0.19/0.32 deg.  
Feet: Uncrossed stance with visibly rolled feet and raised rear heel; existing ANIMFIX4 issue. Sliding cannot be established from a still.  
Defect: The left uppercut has begun recovery without the old delayed high-fist pose.  
Bodies: MH09 Vance, red shorts; MH08 Miller, purple shorts. native ON candidate; uppercut_plus4.

