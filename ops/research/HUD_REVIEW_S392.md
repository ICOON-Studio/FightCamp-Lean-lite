# HUD review, S392 (blind sub-agent, film E:/FightCamp/tmp/s392/film/hud.mp4, bar 7, screens bar 8)

**5/10. Not shown to him.** "Tidy and mirrored, but it doesn't communicate hits."

## Findings
- **0:38.8, a bug of ours:** both stamina arcs drop 6-7 points with a flash and a chunk while the fighters are apart, on the 2:30 clock mark. Cause: stamina changes on the 30-second exchange clock, and Arc.set_bar makes a chunk on ANY drop. Fix: a chunk only from HudBars.hit, never from a read; stamina eases as before.
- **0:15-0:35:** real hits barely register. A hit is 1 point, about 1 degree of arc; the reviewer saw hairline slivers and no flash. So CHUNK_MIN 0.04 and the flash are too weak, or are not firing on these hits. Check first that `hit` runs on every landed punch.
- **0:53:** every arc still reads 93-100, so the rings look full and static. The whole first round barely moves them. That is the BodyMap scale (1.5-3 points a hit), not only drawing.
- **Liver never appeared** (sampled every 0.2 s, 0:09-0:53). A big liver shot may be rare. Count them in a bout before judging the feature, and force one in a film.
- Readability: grey digits on cream inner arcs are hard to read; twelve numbers and eight unlabelled icons are too much mid-fight; the top centre bar is unexplained; the caption at 0:32-0:39 is small.

## Next
1. Chunk from hits only. 2. Confirm `hit` fires per landed punch, then make the hit visible at normal play size. 3. Film a forced big liver shot. 4. Cut what the rings show mid-fight, and re-review to 7, then 8.
