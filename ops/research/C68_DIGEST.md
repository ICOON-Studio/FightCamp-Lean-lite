# C68 digest

Added the advisory `GameState.get_weight_read()` contract read and attached
its dictionary to successful `book_fight()` results as `weight_read`. It does
not refuse a bout. Missing walk weight, or an unknown class limit, returns
`evidence: "unknown"` and `makes_it: false`.

Authored bands use `over_by / limit`: `under` at 0 or below, `routine` through
3%, `hard` through 5%, `dangerous` through 8%, and `impossible` above 8%.
The 3% and 8% boundaries are anchored to `WeightCut.night_penalty()`'s free
cut and maximum-water-cut shape; the band names and cut points are authored
for this read.

`DoubleChamp.can_make_limit()` now delegates to the shared
`WeightCut.can_make_limit()` composition (status first, then moderate
projection). The existing arithmetic and expected answer are unchanged.
`WeightCut.projection()` retains its existing internal status-family behavior;
that pre-existing ambiguity was not silently changed.
