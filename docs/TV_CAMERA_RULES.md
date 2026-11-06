# TV camera rules (S379, C222)

Operator, on the FIGHT9 round-9 film at 1:40.5 (comment C222): "the camera movement makes me dizzy, watch what angles are
used in televised events and try to do the same, why you keep zooming in and out and rotate all at the same time, it is
like you try to make the player throw up". At that moment the knockdown replay cut to a lens behind the downed boxer's
back that orbited at 8 deg/s while it followed the pair in and out.

## What televised boxing does (research S379)

1. **Fixed, elevated cameras on one main side.** Two at the top of the main seating (a long lens and a wider shot), a
   side camera at 90 degrees, a "beauty" camera over the ring. HBO's main 4K camera stood ~30 m from the action.
   (svgeurope.org Euroscena 12-camera OB van; plsn.com "Lighting for the camera: modern-day boxing"; FPI boxing
   production manual 2022; sportsvideo.org HBO 4K Golovkin-Jacobs.)
2. **8-12 cameras a show, most of them never move.** (DAZN, ESPN/Top Rank, Rio 2016 per-bout plans - svgeurope.org,
   sportsvideo.org.)
3. **Each operator holds one framing** - context (both head to toe) or tight - and does not zoom for nothing.
   (Shaun Roemich, dvinfo.net.)
4. **Change the angle with a cut, not a swing.** "Panning from one view to the other stands out as unnatural" (Bristol
   CHEEP guide); zoom "slow and steady, and don't zoom out again too soon" (Sheffield Hallam); zoom during a pan only to
   keep a fast subject in frame (Videomaker); NBC's 360 replay rig tracks, stops, then zooms - one move at a time.
5. **Pan no faster than one picture width in ~7 s** (RED, Sony): field of view / 7 deg/s - about 5.7 deg/s on a 40-degree
   lens. A changing FOV is itself listed as a cause of simulator sickness (arxiv 1611.06292).
6. **Moving cameras are for walk-ins, pyro, crowds and breaks**, used sparingly in rounds (Sky's Sara Chenery on the
   wire cam: "careful how and when you use it").
7. **Ringside handhelds work at apron level**, follow the action, cover corners and the post-fight.
8. **Replays go in the breaks**; after a knockdown: the referee's check first, then replays.
9. **A replay is a few fixed slow-motion angles joined by straight cuts**, 2-4 s each; key-punch close-ups are cut out of
   a still frame, the camera does not move. Live coverage cuts about every 9 s (soccer benchmark, arxiv 2011.13367).
10. **On a knockdown stay on the fallen boxer**: overhead looking down, or floor level.
11. **Geography first; leave a blocked angle immediately.** A camera behind a boxer's back is a blocked camera: cut
    away, never hold on it. Live work keeps one side of the line; boxing crosses it only with a dedicated opposite camera.

Conflict kept on purpose: real main cameras stand far outside the ring; ours stay INSIDE the ropes (S347: no rope ever
between the lens and the pair), so the main lens rides beside the pair instead of standing 30 m away.

## How the game applies them

| Camera | Script | Rule |
| --- | --- | --- |
| Live broadcast | `scripts/fight3d/RingCamera.gd` + `TvShot.gd` | Every shot is placed once at its cut: side-on to the pair (a little ahead of the way they circle), elevated (`main`, 1.85 m) or at apron height (`apron`, 1.4 m, now and then), FOV framing both head to feet and FIXED for the whole shot. While it holds the lens rides beside the pair at the same offset and only pans, eased, at most 8 deg/s. It cuts - never before 2.2 s - when it nears a boxer's back (58 deg), a boxer comes within 1.3 m, the pair leaves the frame, or its hold ends; the one exception is rule 11's emergency (under 50 deg of a boxer's back, or a boxer at the lens), which cuts at once. A new shot that would differ by less than 0.8 m and 25 deg becomes the apron angle (no jump cuts). |
| Knockdown replay | `scripts/fight3d/KnockdownReplay.gd` | Three FIXED slow-motion angles joined by straight cuts, 2.1-2.4 s each: the main side wide, the punch from the reverse three-quarter (low, toward the puncher: the hit face shows), the fall from high over the canvas. |
| Knockdown count | `scripts/fight3d/KnockdownCount.gd` | Fixed lenses: overhead on him while he is down, a straight cut to the wider count shot as he starts to rise, back to the broadcast once either boxer reaches the HUD panels. |
| Intro | `scripts/fight3d/FightIntro.gd` | Film shots with one slow move each, FOV fixed; no shot under 2 s. |

The probe: `tools/cam_motion_probe.gd` (headless, `-- show3d`) reads the drawn camera every frame and fails on a turn over
10 deg/s, a FOV change while the lens turns or moves, any frame behind a boxer, or a planned shot under 2 s.
