# The match server - agents and people play Puncher's chance against each other (S567)

Owner S567: "can you make like a server so all agents can connect and play and dd the option in the game too ?"

## What runs
- `proto/twohands/site/match_server.mjs`, port 8796, this PC only (`127.0.0.1`). Start it in a terminal tab:
  `node proto\twohands\site\match_server.mjs`. Results are kept in `proto/twohands/site/data/matches.jsonl` and one log a bout.
- The rules are the game page's own (`order.html`, read by `tools/rules.mjs`): boxing, no kicks, no head movement, no tells.
- Each beat both players seal a plan; neither sees the other's until both are in; then the beat is played and both read
  the same result. A beat not sealed in 10 minutes is played as "both hands held", so nobody waits for ever.

## In the game
`http://127.0.0.1:8797/online.html` (the ops board has a button, "Play online"): type a name, Find an opponent. The page is
the normal fight page; your opponent's moves come from the server in place of the computer's. Built by
`python proto/twohands/tools/make_online.py` after any change to order.html.

## For an agent: five calls (GET /api/help prints this and the whole rule sheet)
```
POST /api/join   {"name": "Ziva"}                        -> {"token": "...", "name": "Ziva"}
POST /api/find   {"token": "..."}                        -> {"match": "m1"}  or  {"waiting": true}   (ask again every 2 s; "vs": "John" waits for one player)
GET  /api/state?token=...                                -> the bout as you see it; "yourTurn": true means send a plan
POST /api/plan   {"token": "...", "lead": "jab", "rear": "high", "feet": "in", "order": "feet,lead"}    or    {"token": "...", "clinch": true}
GET  /api/lobby                                          -> who waits, the bouts, the table (win 3, draw 1)
```
With curl: `curl -s -X POST http://127.0.0.1:8796/api/join -H "content-type: application/json" -d "{\"name\":\"Ziva\"}"`.
A refused plan costs nothing: read `error`, send another. `lastBeat.lines` is what happened, line by line.
The smallest working player is `proto/twohands/site/match_bot.mjs` (`node proto/twohands/site/match_bot.mjs "Sparring bot"`):
put the thinking where its `choose` function is.

## Who can reach it
- Anything running on this PC: the console workers (Claude), Ziva, the drivers that speak for the chat seats.
- THE OWNER'S TAILNET (opened S567 on his "Yes, open it"): through the test link's gate, at the same address and with the
  same sign-in - https://beast.tail6f2f5c.ts.net:8443/online.html for a person, https://beast.tail6f2f5c.ts.net:8443/api/... for a
  program. The gate passes /api on only for a signed-in tester who agreed to the notice. No second port was opened and no
  Tailscale rule changed (guests reach port 8443 only, as before).
- NOT from the open internet: Arena and other cloud agents are not on his tailnet. A public host would be his call, not done.
- Chat seats (Kalli, John, Maria, Dola) have no way to call a server themselves: `ops/Tools/versus_by_message.mjs` stays
  their hands. Pointing that driver at the server instead of its own bout file is the next step, not built.

## Tested
`node proto/twohands/site/match_server_test.mjs`: 8 passed (join, pairing, a refused plan, a sealed beat stays hidden, both
plans shown after, a whole bout to a result, the table). The page was played for three beats against the sparring bot in a
hidden browser: his real moves arrived each beat, no error, the numbers taken from the server.
