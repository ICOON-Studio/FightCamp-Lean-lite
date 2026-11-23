# PICS2D1 - the 2D picture test: our 3D as paired pictures, one real round beside its 3D film (S539)

Owner S539: "yes, run the 2D picture test" (ops/research/FIGHTBIZ1_COMPARE.md section 2 and section 4 item 1). A test only:
no game file changed. Seen on the review board: 127.0.0.1:8787/review, "2D pictures v 3D: one round" (17 files).

## What was made
- **14 pair pictures** (tools/pics2d_render.gd): guard, guard inside, and red/blue x jab / cross / lead hook x landed /
  missed. Both boxers are the game's MetaHuman bodies, drawn by the v2 player as it ships, frozen at each take's contact
  frame (clip_db contact_s), with the game's own toon look (ArtStyle, art=toon), a fixed side camera (orthographic, red on
  the left), transparent background, 1024 px. Ring, ropes, crowd and referee hidden. Every picture is framed head to feet
  (14 of 14 passed the framing check).
- **One real round, two ways** (tools/pics2d_round.gd). `3d` plays the real game to fight night (quick start, sign, camp,
  weigh-in; seed 7: Lucy Jackson v Priya Nair), watches round 1 in the game's 3D view from its broadcast camera, no corner
  call clicked, and saves the film plus the round (six exchanges, 181 beats). `pics` plays that same round as pictures:
  per exchange up to three of its punches (the first, the winner's best landed, a miss or block), each 1.1 s with the 0.24 s
  pop (0.90 -> 1.035 -> 1.0), a 0.48 s impact ring + flash on landed, a MISS / BLOCKED streak otherwise, and the exchange's
  line beside it. 17 pictures, 19 s.
- In ops/previews/s539_pics2d/ (not in git): stills/ (14 + contacts.json), picture_round.mp4, 3d_round.mp4 (3:00 at 10 fps),
  contact_sheet.png (1920x1080: each exchange's 3D frame beside the picture shown for it), round.json, pictures.json, logs/.

## Time it took
About 25 minutes of one session for the tools and all renders (5 still passes of ~35 s, one 6-minute 3D round film, one
20 s picture film). The FIGHTBIZ1 estimate was 1.5 days for this probe: the existing still tools (fp2pose_still, the
hidden desktop, the godot_slot queue, ArtStyle's toon) did most of it.

## Which pictures look wrong, and why
- **The v2 takes do not reach on their own.** As played at the game's range, the glove stops 0.5-0.8 m from the face (it
  lands on the other's guard glove at best); the pair placer then turns and re-seats the bodies, and in one early render
  blue's cross went through red's body. The tool therefore pauses the stage at contact, puts both back on their guard
  spots, and slides the puncher along the ring line until the glove is 0.10 m from the face (landed), or the target back
  until it is ~0.5 m short (missed). So the stills show the TAKE'S POSE at contact, at a range the tool picks - not the
  range the 3D player shows. This is the same reach gap the 3D fight has (FIGHTPLAYER2 territory; not fixed here).
- **Landed glove sits beside the face, not on it.** After the slide, the glove is 0.18-0.32 m from the head centre in 3D:
  the takes aim at guard height and to one side. Readable as "on the guard / temple", not a clean shot on the chin.
- **Hooks**: the lead hook (pro_left_hook_ft) at contact reads as a hook in red_lead_hook_landed and blue_lead_hook_landed;
  the missed hooks look very short (0.8 m), almost a different move.
- **Our pose problems show** (as FIGHTBIZ1 warned): the guard is tall and narrow, elbows tucked, which looks fine side-on;
  the rear foot is often turned flat. Nothing new beyond what the 3D shows.
- **Missing families**: the round's beats also had body hooks (9), rear hooks (4), uppercuts (8) and blocks (16). With
  only three pictured punches, body hooks show as the head lead hook and uppercuts as the cross; a blocked punch uses the
  missed picture with the word BLOCKED. The caption names the real punch.
- **3D side**: at the beat times the 3D film often shows the pair still apart (the beat is the start of a punch, its
  contact comes later), so the contact sheet's left frames are "the moment it was thrown", not the contact.

## What a full set would take
About 40-50 pairs for boxing (per corner: jab, cross, lead hook, rear hook, body hook, uppercut x landed / blocked /
missed, + guard, clinch, a knockdown in 3 frames, referee step-in, corner sit; both corners rendered, no mirroring):
- 0.5 day: add the families clip_db already has (body_hook, rear hook, uppercuts) and a BLOCKED picture (the defender's
  guard-catch at contact), aim the body shots at the body. The tool already loops families x results x corners.
- 0.5 day: clinch / knockdown / referee / corner pictures (they need their own clips placed, not punch contact frames).
- 0.5 day: wire it as a view (a TextureRect player on the settled exchanges, as pics2d_round's pics mode) + one golden-path
  test. Total about 1.5-2 days for boxing.
- The card game's other arts (karate, judo, wrestling, BJJ, kickboxing): about 20 pictures each, but we have no clips for
  most of them; each needs its own takes first (that, not the pictures, is the cost).
- The reach gap above means every new picture's range is set by the tool, not by the 3D: fine for pictures, but the 2D
  and 3D views will disagree on distance until the 3D reach is fixed.

## Decision for the owner (Claude puts it on the board)
Is the picture round readable, and does he like it beside the 3D: keep it (as the card game's resolution view and/or a
second view of our settled rounds), or drop it.
