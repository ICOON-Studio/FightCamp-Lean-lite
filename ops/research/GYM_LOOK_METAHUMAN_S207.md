# Gym look - what happens to our MetaHumans and fighters (S207 answer to your Q-S205-3 comment)

Your words: "i found already free alternatives for shrimple3d" / "what about our metahuman models ?"
And on the floor still: "we need textures" / "and the other visual effects".

## What we have today
- FIGHTERS: rigged MPFB/Tripo bodies (Godot/assets/models/fighters). Every certified move in the demo (certified_moves.json)
  was measured and passed on THESE rigs. Swapping the body = re-certifying every move.
- GYM STAFF: MetaHumans (coach, desk). Parked for the demo by your S155 call ("Not yet, keep OFF").

## My recommendation (decided as developer; the look is your call)
Keep our bodies - fighters AND MetaHumans. Do NOT swap to Quaternius characters: that is 16-30 h plus re-checking every
certified move, for a demo whose heart is the fight. The clash John found is mostly the PROPS and the LIGHT, not the people.
So:
1. Your free prop pack replaces the mixed photoreal/toy props - one style, one palette (no US$39.99 purchase).
2. Textures + visual effects (your C29/C31): proper floor/wall/mat materials, light shafts, dust in the air, warm key light,
   soft shadows - one lighting pass on the game camera.
3. Bodies stay; their skin/clothes get the same palette so they sit in the room.
If after that pass the people still look out of place, THEN we test one stylised character beside ours on a still.

## What I need from you
The link/name of the free pack you found (put it in the note), and which way to go.
