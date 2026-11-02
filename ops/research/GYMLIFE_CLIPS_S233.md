# GYMLIFE batch - step 1: the missing-clip list (S233)

Approval: operator, via side session: "ok go with your recommndation then in the main session" - workout animations for the whole
gym as ONE batch under GYMLOOK3. Order: (1) this list, (2) Mixamo first, in CHROME (Browser 1), check disk first, whole batch in one
run, (3) Ludo `model animate` only for what Mixamo lacks, (4) wire per station (GAME_ON) + game-camera stills for his OK.
Starts in earnest when Goose C78MEMBERS (issue 212) lands.

Source of truth for today: `TrainingFloor3D.STATION_CLIPS` (heavy_bag, club_ring, speed_bag, cardio_floor) - every other station
plays the idle. Stations from `gym_club.json` places (17).

| Station (place) | Plays today | On disk already (C:\Users\user\Downloads, Mixamo FBX) | Still missing -> source |
|---|---|---|---|
| heavy_bag_1..4 | punching_bag_station | Punching_Bag__Various_Punches_To_A_Punching_Bag | - |
| speed_bag_1..2 | speedbag_station | Punching_A_Speedbag | - |
| ring (ring_sparring) | boxing_warm_up_station | Boxing_Warm_Up_Exercise | - |
| pads (focus_mitts) - FIGHTER | idle | (c209 shadowboxing take1/2 in repo) | punch combos at mitts -> Mixamo "Boxing" / "Punch Combo" |
| pads - COACH holding mitts | idle | none | mitt-holder catching punches -> Mixamo search "Focus Mitts"/"Catching"; else Ludo animate |
| defence_drill (slip_rope) | idle | Slipping/Edge_Slip are falls, NOT a slip drill | bob-and-weave under a rope -> Mixamo "Bob And Weave"/"Boxing Dodge"; catalogue has boxing_dodge_advance/retreat (baked) - try those first |
| mirror_strip (move_cards) | idle | c209 shadowboxing (repo) | - (wire c209 shadowboxing) |
| treadmill | idle | Jogging_Stumble only | jog in place -> Mixamo "Jogging" / "Running" (in place) |
| bike (exercise_bike) | idle | none (Bicycle_Crunch is floor work) | seated pedalling -> Mixamo "Bicycle"/"Pedaling"; else Ludo animate |
| recovery (stretch_mats) | idle | Arm_Stretching, Neck_Stretching, Warrior_Idle (stretch), Situps, Crunch, Circle_Crunch, Bicycle_Crunch | - |
| agility_ladder | idle | Cross_Jumps, Jumping_Jacks | quick-feet ladder drill -> Mixamo "Agility"/"Fast Feet"; else Ludo animate |
| power_rack | idle | none | barbell back squat -> Mixamo "Air Squat"/"Barbell Squat" |
| olympic_platform | idle | none | deadlift / clean -> Mixamo "Deadlift"/"Lifting" |
| weights (compact_weights) | idle | none | dumbbell curl / press -> Mixamo "Bicep Curl"/"Dumbbell" |
| cardio_floor (zone) | jumping_rope_station | jumping_rope.fbx | - |
| members (C78 + floor) | no bodies (Goose 212 adds 4) | Push_Up, Burpee, Jumping_Jacks, Situps (+ transitions) | - (reuse; skipping already baked) |

## Download list for step 2 (Mixamo, one run, Chrome Browser 1, FBX Binary, With Skin, 30 fps)
1. focus-mitt punch combo (fighter) 2. mitt holder / catching punches (coach) 3. bob and weave 4. jogging in place
5. stationary bike pedalling 6. agility / fast feet 7. air or barbell squat 8. deadlift 9. bicep curl
(9 clips; anything Mixamo lacks -> Ludo `model animate`, 0.2 credits each.)

## Already on disk, to wire without downloading
Push_Up__Basic_Push_Up, Situps__Situps, Burpee__Burpee_Workout, Jumping_Jacks__Standard_Jumping_Jacks, Arm_Stretching,
Neck_Stretching, Warrior_Idle, Crunch, Cross_Jumps, c209 shadowboxing take1/take2.

## Step 2 DONE (S233, operator signed Chrome in to Mixamo)
Downloaded in one run: Four Punch Combo (pads fighter), Treadmill Running, Back Squat (power rack), Clean And Jerk (olympic
platform), Bicep Curl (weights), Air Squat (members) -> `Godot/assets/anim/mixamo_gymlife/` with the 8 on-disk workouts
(provenance.json). Mixamo has NO focus-mitt holder, NO stationary-bike pedalling, NO agility-ladder drill -> step 3 Ludo
`model animate` (3 clips, ~0.6 credits). Slip rope reuses the baked boxing_dodge_advance/retreat; mirror strip reuses c209 shadowboxing.
