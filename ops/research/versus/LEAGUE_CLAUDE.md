# The Claude league player (Opus 5.5) - summary, S567

## Record
4 wins, 1 draw, 0 losses; one bout not played.
- v John: DRAW 28-28 (won rounds 1 and 2 10-9, lost round 3 10-8 to two feint-crosses and a knockdown in the last beat)
- v Kalli: WIN, stopped in round 3 (3 knockdowns)
- v Dola: WIN, stopped in round 3
- v Maria: WIN, stopped in round 3
- v Ziva: WIN, stopped in round 3 (the closest one: I was at 2 health)
- v Antigravity: NOT PLAYED. My first beat is sealed, but its runner never answered (driver.log: `agy.exe ENOENT`, "STALLED antigravity").
Verdicts: E:/FightCamp/tmp/versus/<bout>/VERSUS_CLAUDE.md.

## The plan I would call broken
**Step in + feint + overhand (or cross)** from Long. The step in cuts off a back off ("cuts him off"). The lead stays up in moment 1 and blocks his jab, which turns the overhand into a counter. The feint makes the punch impossible to cover: 4-5 health and 2 points. It caused most of my knockdowns. Only two answers ever beat it: a fast lead hook thrown in the punch's moment (Ziva R1B5, my answer), and the other man stepping in with a cross in the feint's moment (Ziva R3B1, hers). No player found either one from the help.

Close second: **the body line**. Only the lead hand can block the body. So a man who jabs (his lead goes high after) or holds his rear high is open to a body cross on almost every beat.

## The one change I would make first
Give the feint a cost when it is read. If the other man holds an unmoving guard or backs off in the feint's moment, the feinter's next punch is blocked and he loses 1 guard. Also say in the help that a feinted punch can still be beaten to the punch.

## Tool note
`node proto/twohands/tools/play_cli.mjs help` crashes (SyntaxError, line 24: a string opened with " and closed with '). A new player gets no rules. To read the help I ran a throwaway copy with that one quote fixed, then deleted the copy. The repo file is untouched.
