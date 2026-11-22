# proto/cardscope3 - the bot probe of the card game scope, round 3 (CARDSCOPE3, S537)

A greybox, not a game: rules and bots only, no page. It measures the round 3 bars of
`ops/research/DESIGN_CARDGAME_SCOPE.md` (section 4c). Result: `docs/CARDSCOPE3_PROBE.md`.
Rounds 1 and 2 (the three-beat exchange) are `proto/cardscope`, untouched.

Round 3 in one line: the rally. He throws face up; on your turn you answer with one guard, his volley lands, you throw
back; one face-down trap each that watches the lead punch. Same wind and hands on both sides.

```sh
node proto/cardscope3/engine.test.mjs                            # 29 checks
node proto/cardscope3/probe.mjs run2 per=400 card=800 runs=400   # every measurement -> out/run2.json (about 5 minutes)
node proto/cardscope3/report.mjs run2                            # the bar table
node proto/cardscope3/calib.mjs per=40 [cls=3] [name=value ...]  # sizing aid on its own seeds (300000+)
node proto/cardscope3/diag.mjs per=100                           # the same reader in both chairs
```

`name=value` resizes one number for one run without editing a file: a key of `N` (`kd=16`), a card (`parry.w=0`) or a
bot weight (`reader.wKeep=1.2`). Run 1 of the report was: `parry.w=0 tieup.w=2 leadDry=2 kd=16 kdHurt=12
checkhook.dmg=6 xcounter.dmg=6 pullcounter.dmg=6 ice=10`.

Files: `cards.mjs` (cards, every number, boxers, habits, classes, deck rules), `engine.mjs` (the turn, the volley, the
trap, rounds, judges, corner), `plan.mjs` (one planner with profiles: greedy, table player, reader, all-seeing, the
opponent classes), `bots.mjs` (random, fixed line, beginner, the forced arms), `probe.mjs` + `report.mjs`
(measurements and bars), `calib.mjs`, `diag.mjs` (sizing aids).
