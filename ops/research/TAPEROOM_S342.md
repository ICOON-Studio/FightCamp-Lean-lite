# The tape room - decode her clips, build your plan (proposal S342, for approval)

Operator S342 (after GrappleFlows turned our grapple clip into a flow): "is it good idea to make this a mechanic in the
game to decode clips from opponent to make your own plan ?"

## Verdict: yes - as an OPTIONAL active layer on the tape study that already exists
It is what real coaches do, it turns the S340 goal ("each opponent needs to be a big deal to study and decode") from
waiting into playing, and almost every part is already built. It must stay optional: watching tape for every opponent
would become a chore, so the passive tape study (one tell every 2 camp days) keeps working for players who skip it.

## What a real coach does (the model)
He cuts her last fights into short clips and charts tendencies: what she throws after her jab, where she goes when
pressed, what she does when hurt, when she tires. Then he writes the counters into the camp and the corner's calls.

## The mechanic
1. CAMP > Tape room (needs film bought for that camp): 3-4 clips of 8-12 s from her REAL past bouts (RivalPast), played
   by our own fight engine with her style and habits, each clip hiding one tell.
2. The player watches and hits SPOT at the moment a tell shows, then picks what it was from a short list (e.g. "drops
   her right after the jab" / "lunges behind her jab" / "covers up"). Right = the tell opens NOW (saving camp days) and
   its answer is drilled faster. Wrong or missed = no penalty but the clip is used up (the passive study still finds it).
3. Her map: every tell found draws onto HER flow (GrappleFlows-style: a node = a still of that moment from the clip, a
   short title, the edge = what she does next). The plan board then suggests the answer as a WHEN arrow; the player
   places it.
4. Harder opponents hide it better: a top rival shows a tell once in a clip and late; a novice shows it twice.

## Already built
OppFile (tells, hidden/found, answers), tape study in camp, RivalPast (her past bouts), HabitBeats + TheRead (habits
fired in the 3D fight), the fight film tools, WHEN arrows on the plan board, MOVEPLAYER1 (Goose, in flight) for clips.

## The risk (and the test that decides it)
A tell is only fair if it READS on screen. Prototype ONE opponent first: 3 clips with the 3 clearest tells (drops her
right after the jab, lunges behind the jab, fades late = slower and fewer punches in round 3). The visual gate: can a
player who knows the tell list spot each one? If a tell does not read, it stays passive-only.

## Build order if approved
(1) clip cutter: her past bout -> 3 clips, each with a tell's timestamp (pure, testable); (2) the Tape room screen
(player, SPOT button, the pick list, result); (3) her flow map from found tells; (4) plan-board suggestion; (5) the
difficulty by rival tier. Agents: the clip rendering to Goose/Cursor (animation); Claude the screen and the rules.
