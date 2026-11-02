# TASK J51 - JOHN - HOW PROFESSIONALS SHOOT A FIGHT (research only, no code)
Owner: john. Assigned S76, 2026-09-25, from the operator's own report on our clips: "why is the camera so shaky, how
professional shooters handle the cameras? ... i want proper camera setup when i watch the videos".

## Why
Our fight camera re-aims every frame at the bounding box of both fighters' flailing limbs, so every punch jerks the shot
and every extended kick pumps the zoom. We need the real craft, with numbers, before we rebuild it.

## What would a human do?
A combat-sports broadcast director and camera crew: which camera positions exist (hard/high camera, ringside handhelds
on gimbals or Steadicam, overhead/cage cams), which one carries most of the live fight, how the main operator frames two
moving fighters (shot size, headroom, lead room, how much he lets them drift before reframing), how fast he pans and
zooms, when the director CUTS instead of moving the camera, and what never happens on air (whip pans, constant zoom).
Then the game side: how UFC 5 / Fight Night Champion / Undisputed / sports games smooth their fight cameras (dead zones,
damped springs, aiming at the pelvis/chest midpoint instead of the hands, rotation and zoom rate limits).

## Do
1. Broadcast: camera plan for a boxing ring and an MMA cage (positions, lens/shot size, which is the "main" live camera).
2. The main operator's rules for framing two fighters: shot size, margins, reframing threshold, pan/zoom speed - quote
   operators, directors, SVG/TVB/broadcast-trade articles; tag SOURCED (URL + quote) / JUDGEMENT / NOT FOUND.
3. Cutting: typical shot length on the live feed, what triggers a cut (clinch, knockdown, corner), replay angles.
4. Games: published talks/articles (GDC, dev blogs) on fight/sports camera smoothing - dead zone size, spring constants,
   aim target, rate limits.
5. A VERDICT: the camera spec a fight game should implement, as numbers.

## Deliverable
One markdown memo; Claude saves it as `research/J51_FIGHT_CAMERA_CRAFT.md`.
