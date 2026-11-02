# GYMCLIPS2_JOHN_JOHN - John answer (seat queue SQ12)

Brief: research/TASK_GYMCLIPS2_JOHN.md
Sent: 2026-10-23 02:10 | collected: 2026-10-23 02:40 by Tools/seat_queue.py (the 30-min reconcile)
Attachments on the bot's box (not downloaded): GYMCLIPS2.md
Verify the sources before using it.

---

Starting GYMCLIPS2 now. I'll look for free and marketplace sources for a stationary-bike loop and an agility-ladder loop, checking licences and fit, and paste the full answer here.

The GYMCLIPS2 research is underway, and I'll post the full ranked answer here once it's done.

GYMCLIPS2's first pass came back too thin, so a deeper second pass is running now. Neither motion has a free ready-made clip so far. CMU has no bike or agility-ladder trials; its closest are 143_40 "Walk Sideways" and 143_31 "Hopscotch", and those would only work as a base to edit.

- **Bike:** the only confirmed seated pedal loop is AssetLoom's "Bicycle Ride Loop", in its [Vehicle and Seated pack](https://assetloom.io/assets/vehicle-and-seated-pack).
  - It's FBX, GLB or BVH on UE5-style bone names, 30 fps, about 1 s, in-place or root-motion, with seat-alignment proxies.
  - It costs "300 credits", and I haven't checked the cash value or the full licence yet.
- **Ladder:** the best lead is the Fab [Fitness Workout Mocap pack](https://www.fab.com/listings/f2694ada-a459-4e53-b2e5-e998970d9d3a), which has High Knees only. Its price and licence are UNVERIFIED.
- **Zero-budget fallback:** hand-key both loops in Cascadeur before 2026-10-27, or capture the ladder drills with Rokoko Vision.

The second pass checks those licences and covers Rokoko's library, Uthana, Move AI, SayMotion, ActorCore, Truebones and others. I'll post the full ranked answer when it's done.

**GYMCLIPS2 is done (part 1 of 2: bike).** The top pick is AssetLoom's "Bicycle Ride Loop", in its [Vehicle and Seated pack](https://assetloom.io/assets/vehicle-and-seated-pack). It costs 300 credits, which is US$3 at "1 Loom Credit = US$0.01". New accounts get "500 welcome bonus credits", so it's effectively free.

**AssetLoom Bicycle Ride Loop** (page opened):
- **Format:** FBX, plus a GLB per clip, BVH, .blend and bone_map.json. The skeleton uses UE5-style bone names.
- **Timing:** 30 fps, loops, 31 frames (about 1 s, one crank turn). In-place and root-motion versions are both included.
- **Pose:** seated, with feet on the pedals. Hands on the bars are confirmed: version 1.2.0 added an "overhand grip on ... bicycle handlebars".
- **Seat height:** the pelvis height isn't stated. The root sits "on the floor under the seated hips", and the pack ships alignment proxies and a contact_points.json. It's a road-bike pose, so fitting a 0.75 m spin-bike seat needs a hip offset (GUESS).
- **Licence** ([AssetLoom licences](https://assetloom.io/licenses)): "Can I use it in a game I sell? Yes." Attribution is not required, and resale or sharing of the files isn't allowed.
- **Caveat:** the vendor is new (v1.0.0 dated 2026-10-06) and has no reviews.
- **Matching prop:** the [Grab3D exercise bike](https://grab3d.com/models/sports/exercise-bike/) is a CC0 GLB/FBX model, 0.96 × 0.58 × 1.14 m, with a separately pivoted crank.

**Other bike sources:**
- [Unity "Bicycle Animation"](https://assetstore.unity.com/packages/3d/animations/bicycle-animation-330896): $15, with clips anim_Relaxed_Pedal_Seated_Loop and Seat_Up_Pedal_Loop.
  - Its format, fps and length are UNVERIFIED, and it's an outdoor bike.
  - **Licence:** Unity Support says the assets "are not restricted to Unity projects", so Godot is fine (quoted from a search snippet).
- **Sketchfab "Cycles (All)":** the licence isn't shown and the rig's origin is unclear, so avoid it.
- **CGTrader "Bicycle Stationary Exercise Man":** seen only in a search summary, so it's UNVERIFIED and may not exist.
- **Uthana free plan** (CC BY 4.0, with the credit line "Animation generated with Uthana (uthana.com)") or **NVIDIA Kimodo** (weights "commercially usable"): free text-to-motion, but the quality is a GUESS.

**No bike clip found:**
- **CMU:** none. Its "motorcycle" trials are only seated pantomimes.
- **Rokoko library, ActorCore, Mocap Online, Truebones, Kevin Iglesias:** nothing confirmed. For several I could only search, not open the store.

**Excluded:**
- **DeepMotion free tier:** "exclusively for non-commercial purposes".
- **Bandai Namco, AMASS, HumanML3D and Motion-X:** non-commercial licences.
- **Movekit:** video only.

**GYMCLIPS2 (part 2 of 2: agility ladder).** No ready-made clip covers in-in-out-out or the lateral shuffle. There are real high-knees clips, but their licences aren't checked yet.

**Ladder sources, best first:**
1. [Fab Fitness Workout Mocap pack](https://www.fab.com/listings/f2694ada-a459-4e53-b2e5-e998970d9d3a): 22 HIIT clips, including High Knees In, Loop and Out.
   - The page's "License terms" field is blank, and it says "Allows usage with AI: Yes".
   - Its price, skeleton and fps were blocked by Cloudflare (UNVERIFIED).
2. [Fab Fitness Mocap Collection](https://www.fab.com/listings/547dfdc1-48f9-4881-941f-e947ef2092e5): 25 looping clips, including High Knee Running, Walking in Place, Square Walking and Tap Step & Turning. I only saw a search snippet, so details are UNVERIFIED.
3. [Unity StockMoves01 Footwork](https://assetstore.unity.com/packages/3d/animations/stockmoves01-footwork-79393): $15, FBX on Unity's humanoid rig, from 2017. The page has no clip list.
4. [Unity AA_Aerobic_Exercise](https://assetstore.unity.com/packages/3d/animations/aa-aerobic-exercise-283245): 61 looping clips with generic names (type01 to type14). A review says characters slip.
5. [Fab "36 Fitness exercices set 2"](https://www.fab.com/listings/b5327bd1-4851-4fd5-86e1-584ab2be1490): UE5 Mannequin, with knees-to-chest and heel-to-butt clips but no ladder drills (UNVERIFIED).
6. **CMU, free:** there are no agility trials. 143_40 "Walk Sideways" and 143_31 "Hopscotch" could serve as a base to edit; they're 120 Hz BVH files.
   - **Licence:** "You may include this data in commercially-sold products."

**Travel per loop:** no source says whether these move forward or stay in place, or how far. A standard ladder box is about 0.45 m, so one in-in-out-out cycle covers about 0.45 m (GUESS). I'd use in-place loops and move the boxer along the ladder in code.

**Top pick for the ladder:**
- **In-in-out-out and lateral shuffle:** hand-key them in Cascadeur before 2026-10-27, as about 24–32-frame in-place loops on a Mixamo skeleton (GUESS). Or film a real drill and run it through [Rokoko Vision](https://www.rokoko.com/insights/tutorial-start-animating-with-our-free-ai-mocap-tool-rokoko-video), then clean it up in Cascadeur.
- **High knees:** take them from a Fab fitness pack once its licence is confirmed in a browser.
- **Last resort:** Uthana's free plan (CC BY 4.0, with the credit line).

The report is attached. I didn't download or buy anything.
