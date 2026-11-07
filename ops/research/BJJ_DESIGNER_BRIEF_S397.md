# Designer brief: the BJJ fight, deep (S397)

You are a game designer for FightCamp, a Steam gym-management game (Godot 4): boxing + no-gi Brazilian jiu-jitsu in one gym.
The player coaches Ana, a no-gi grappler, from white belt to black. Each week the player picks what Ana drills (moves on a
game tree of positions: grey -> felt -> owned); Ana enters opens (single-elimination, IBJJF no-gi rules) against generated
opponents; each match is simulated beat by beat (one beat ~33 s) or played live with 3 corner calls.

The operator (CEO and playtester, 40 years of games) wants "proper and deep mechanism implementation of the bjj fight":
how a match is really fought - grips and hand fighting, the standing exchange (shot / sprawl / guard pull), guard
retention vs passing, scrambles, back takes, submissions and their defence, fatigue, the referee - and every opponent
distinct, with the player able to see WHY things happened and act on it.

Read: ops/research/BJJ_REALISM_S397.md (measured state, real numbers with sources, design v1, verdicts, design v2 as built)
and ops/research/BJJ_CRITICS_R1_S397.md (three critics' reviews of v1: 6, 6 and 5 out of 10). If you can read the repo, the
code is scripts/rules/BjjWalk.gd, BjjTree.gd, BjjBody.gd, BjjRef.gd, BjjOpp.gd, assets/data/bjj_tree.json.

Task: write the version of the BJJ fight design that would score 8/10 from a black-belt coach, a game systems designer and
a sports-sim veteran, judged against shipped management games (Football Manager, Open Guard on Steam, Two Point). Split it
into these PARTS so each can be judged and built alone, and for each part say: what changes from v2 and why, the rule in
plain words with its numbers (mark real-world numbers [R] with a source, our choices [G]), what the player sees and decides,
and one measurable bar that would prove it works:
 A. Belt meaning (mat time, the belt-gap table, defence vs attack)
 B. The grappler (body + mind attributes, what each move reads, how Ana trains them)
 C. The five-plus games (archetypes, the matchup wheel, a back-taker/scrambler?)
 D. The standing exchange and grips (hand fighting, shot vs sprawl vs guard pull, who gets top)
 E. Guard vs pass and scrambles (retention, frames, the pass as a contest of several beats, scrambles)
 F. Submissions and defence (the finish gate, near subs as advantages, leg-lock knowledge, tap vs injury)
 G. Fatigue and pace (gas, tired odds, the beat length)
 H. The referee (stalling by position, advantages, penalties, the decision)
 I. The coach's part (posture Hunt / Steady / Hold, scouting tells, the counter drill, 3 live calls, what the result card says)
Limits: no new art; one simulated match must stay fast (hundreds a second headless); files under 500 lines; IBJJF adult
no-gi rules (heel hooks only at brown/black); keep what v2 already does well; no pronouns he/she in player text.
Plain text, under 2,000 words, no code.
