## DECISIONS

| kind | file:line | via | gate | what |
|------|-----------|-----|------|------|
| ground_entry | FightRealtime.gd:2157 | takedown | none | Standing shot lands, takedown_resolve returns success, seat moves to ground |
| ground_entry | FightRealtime.gd:2242 | throw | none | Clinch throw lands, takedown_resolve from clinch, seat moves to ground |
| ground_entry | FightRealtime.gd:2427 | pass | none | Top-man position advance (pass/mount/back) within ground stance |
| ground_entry | FightRealtime.gd:2446 | sweep | none | Bottom man sweeps from half guard to top in guard |
| ground_entry | FightRealtime.gd:2450 | escape | none | Bottom man escapes side/mount/back to full guard |
| submission_open | FightRealtime.gd:2409 | | none | Mount or back held long enough, low action roll opens attempt |
| submission_finish | FightRealtime.gd:2405 | | none | submission_advance returns finished, bout stops |
| palette | FightRealtime.gd:2040 | | none | grapple_arsenal builds technique list from ruleset discipline_tags |

A muay thai bout reaches the floor today through the palette at line 2040. `FightMoves.grapple_arsenal` resolves muay_thai's discipline_tags (muay_thai, boxing, clinch) to disciplines that carry takedown and throw nodes. Once the palette includes those techniques, the standing shot at line 2157 and the clinch throw at line 2242 land exactly as they would for MMA or judo: `Grapple.takedown_resolve` returns success, `_move_seat` moves the stance to ground, and from there every ground path is open - position advances, sweeps, escapes, submission opens and submission finishes, all with no ruleset check at any of them.

A ruleset check would have to cover all seven non-palette sites: the two ground entries from standing and clinch (lines 2157, 2242), the three ground-to-ground seat changes (lines 2427, 2446, 2450), the submission open (line 2409) and the submission finish (line 2405). None of them currently ask which ruleset the bout is under. The palette site at line 2040 is the upstream cause - if muay_thai's discipline_tags did not resolve to disciplines carrying takedown or throw nodes, the two entry sites would never fire - but the entries themselves are also unguarded and would need their own check as defence in depth.
