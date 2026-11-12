# DAMAGESHOW1 audit: where the game could show damage, and what it draws (S439, 2026-11-12)

Operator, Q-S294-192: "Stop, show damage". No new damage or recovery decisions: show what `scripts/rules/BodyMap.gd`
already computes. This is the table asked for before any brief. Read from the code by one Explore agent and checked by
Claude against `AfterFight.gd`, `Aftermath.gd`, `BodyLive.gd`, `BodyCallouts.gd`, `FaceMarks.gd`, `FightView.gd`.

## What BodyMap holds

- Six places a boxer: head, left eye, right eye, nose, left ribs, right ribs (the liver side). Each 100 down to 0.
- Bands: above 55 fine, above 35 hurt ("sore"), above 15 badly hurt, else the doctor may stop it.
- Cuts: a face place at 35 or under is cut; an open cut takes 1.5 times the damage there.
- The corner's work (enswell, ice, closing a cut) lasts one round. Nothing heals inside a bout.
- It lives only for the bout: it is not in the save. What carries to the next week is the injury (if the roll says so),
  the stand-down after head damage, the knockout history and the tiredness. A sore place does not carry over.

## The table

| Screen | What BodyMap has there | What is drawn today |
|---|---|---|
| Live 3D round: side strips | the live map, both boxers | three bars (energy, legs, guard) and one word for the worst place (HEAD, EYE, NOSE, RIBS), red when badly hurt |
| Live 3D round: body figures at the screen edges | the live map, both boxers | the muscle figure glows on hurt places, a hit place blinks, a big hit pops the brain, liver or ribs card. Face marks are switched off here |
| Live 3D round: the two boxers' 3D faces | nothing reaches them | nothing from the bout. Old scars from the record only |
| Corner card between rounds | her side of the live map, what each place took | her figure tinted by band, this round's hit spots, hover cards HEAD / LIVER / RIBS with a line; the HEAD card is her photo with the cut, the swelling, the shut eye, the red nose (FaceMarks). The ONLY place face marks are drawn |
| Corner card: stats table | the live map | a "Worst spot" row for both boxers |
| Corner minute in 3D (the cutman) | nothing | the cutman reaches her cheek in pro bouts whatever the map says |
| Round page (2D) | the map, both sides | both figures tinted by band, a tooltip per place. No face marks |
| Fight result page | the map; the tiles | both figures tinted by band; the DAMAGE tile (see below) |
| Tale of the tape, bout offer, bout page | nothing | nothing |
| Fighters page, roster cards, fighter tiles | nothing | portraits; "Injured, back on a date" only |
| A fighter's own page | nothing | photo; an Injuries row while she is out |
| Home rows, week review, injury pop-up, nationals | nothing (the injury only) | injury words and days out |
| Training and week screens | nothing | injury risk and tiredness |
| Playbook combos | the damage a punch does (no state) | head and rib damage if every punch lands |

## Defects found (the page did not tell the truth)

1. THE MAP WAS ONLY THE ROUNDS WATCHED IN 3D. "Skip bout" settles the rest of the fight without the ring, so the map
   stopped at the last watched round. A bout skipped after round 1 that ended in a stoppage loss said "Nothing
   lasting". A bout never watched had no map at all: no figures on the result page and "Nothing lasting" always.
   FIXED S439: `scripts/fight3d/BoutMarks.gd` builds the map from the settled rounds on the ring's own path
   (ExchangeBeats, same seeds) whenever the ring did not ring every bell; `AfterFight.book` uses it.
2. THE TILE NAMED ONLY THE WORST PLACE. Three sore places and a cut read as one name. FIXED S439: worst first in big
   words, "Also sore: ..." and each cut under it, every place with its number on the hover.
3. OFF BY ONE. A place at exactly 55 is "hurt" by its band but the tile said nothing; at exactly 35 the tile said
   "sore" while the band says badly hurt. FIXED S439: the tile reads the band.
4. NO MAP SAID "NOTHING LASTING". FIXED S439 in the pure rule too: with no map the tile says how many punches she took.
5. NOT FIXED, a balance call: the injury roll reads eyes, nose and ribs from the map only when the bout was watched to
   the end (`Injuries.after_bout` runs before the map is rebuilt, on purpose, so S439 changed no injury rate). A
   skipped or unwatched bout rolls on head damage alone, so it can never give a cut or a rib injury from its places.
   Making every bout roll on the full map is right, but it moves the injury rates measured in S434/S438: measure first.
6. NOT FIXED, visuals to come (the order he set): the 3D faces during the fight show nothing; no portrait anywhere
   outside fight night shows a mark; and a sore place does not last past the result page, so "the portrait afterwards"
   needs a rule for how long a mark stays visible (display only, no gameplay): for him to say.

## Where each next visual can attach (no new art needed to start)

- Result page: her figure already exists there; `BodyCallouts` already draws hooked lines from a place to a card with a
  line of words, and the HEAD card is her photo with `FaceMarks`. Today they show on hover only.
- 3D face in the fight: `FighterFace._scars()` already puts decals on the head bone at brow, cheek and nose spots; the
  eye shader already has a `lid` value (0 open, 1 shut). A cut, a swollen eye and a red nose can use those.
- Portraits: every portrait goes through `PromoShot` / `FaceFrame` by picture name only; `FaceMarks.layout` already
  knows each promo photo's eyes and nose (`assets/ui/face/promo_face.json`).
