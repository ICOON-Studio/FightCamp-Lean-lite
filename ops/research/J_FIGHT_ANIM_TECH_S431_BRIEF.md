# J_FIGHT_ANIM_TECH_S431 - John - how the big fight games build their fight animation (sourced)

The owner asked (S431): "is that how boxing manager/esbc/ufc does the animations ?" about our plan to let code place the
feet and the distance and bring captured clips back one at a time. Answer with sources, plain words, tables.

Label every row OFFICIAL (developer talk, paper, patch notes, developer interview) / REPORTED (press) / OPINION / no source
found, with the link and its year. Say when you saw something only in a search snippet.

1. EA SPORTS UFC 3, 4, 5 and Fight Night Champion: how is movement built? ("Real Player Motion Tech": what it is, how many
   captured animations, whether feet and position are driven by code picking short captured pieces (motion matching or
   similar), how punches are layered over footwork, how a punch is steered to its target, how hit reactions are made.)
2. Undisputed (formerly ESBC, Steel City Interactive): the same questions. What did they capture, with whom, how many
   punches, how is footwork built ("loose movement"), what do players and reviewers criticise in its animation?
3. Boxing Manager (Steam, the management game with a 3D ring): anything the developer has said about how the fight
   animation is made, how many animations, and what reviewers say about it.
4. Other manager games that show a fight or a match in 3D without a simulation-grade animation budget (for example World
   Championship Boxing Manager 2, Football Manager's match engine, MMA manager games): what do they do to make a small
   animation set read well (camera cuts, short exchanges, captions, replays)?
5. For a small team with about 100 captured boxing clips and no capture studio: which published techniques are within
   reach (foot locking, inverse kinematics for hands to target, blending a few frames at clip starts, pose limits, a
   procedural idle) and which are not (full motion matching needs hours of purpose-shot capture: how many hours do the
   published systems use?).

End with one table: technique, who uses it, what it fixes on screen, what it needs.
