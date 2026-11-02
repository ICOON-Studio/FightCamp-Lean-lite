# U71 digest

Replaced two pinned `evade == 0` boxing assertions and the hardcoded `expected`
table with kinds derived from `FightMoves.guard_arsenal` + `answering_guards` on
`_boxer()` and `_wrestler()`. S1's catalogue now has four tier 1-2 evade nodes
(Q71); the engine was right, the test kept the old tree.

Before: 3 FAIL lines (two evasion + leg share). After: 1 FAIL (leg share 7.9%,
unchanged, S2's). Boxing derived kinds: block, evade. Parse gate clean.
