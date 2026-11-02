# TASK GLOBE2C (S226) - the market card is "too blunt": rebuild it from Ludo round 67

Seat: cloud Cursor (label `cursor`), branch cursor/issue-<n>, PR to master; never master. Builds on master (GLOBE2/2B + Claude's fixes -
read `git log -5 -- Godot/scripts/CreationFlowPanel.gd` and keep them: card padding in the StyleBox content margins, flag SHRINK_CENTER).
Operator (verbatim, with a screenshot of today's card): "this to blunt on the right". Ships ON (globe_picker screen); no new switch.

## THE SPEC (binding): `research/LUDO_ROUND67_REPLY_S226.txt`
Blocks top to bottom, heights in px at 1080p, fonts/colours/textures/motion as written there:
01 Heritage header (116) - flag 54x36 in a 2 px brass bezel, nation title, tier ribbon badge, heritage seal.
02 The big three pillars (168) - COMBAT POPULARITY / TALENT DEPTH / ECONOMY as recessed 12 px gauges with value + label.
03 Combat sport culture matrix (144) - one row/chip per sport the country HAS (from `specialties`: label + 0-100), sorted high to low.
04 Sanctioning bodies & federations (88) - the country's real organisations (from the city board's `organizations`).
05 Metropolitan hubs (336) - city tabs (segmented), the selected city's rival gyms and events (from the city board).
06 The CTA (92, pinned bottom) - keep the label **CHOOSE MARKET** (Claude: Ludo's "ESTABLISH HEADQUARTERS" is not taken; the flow's
   wording stays), Ludo's button style.
Motion on a new pick (Ludo C): count-up numbers, gauges filling, header slide, timings as written. Tooltips (Ludo D) on each block.

## DATA (real only - never invent a value)
- `GameState.get_creation_markets()` rows: economy, talent_depth, combat_popularity, specialties [{discipline,label,value}], city_count,
  gym_count (already in `_markets`).
- `GameState.get_creation_city_board(country)` -> cities [{name, rival gym names, organizations, events ...}] - read it once per pick,
  cache it in the panel; grep its return shape at GameState.gd ~20153 (never read the whole file).
- Ludo's RISK (binding): small countries have 1 city, no federation, few sports. Every block must render well with little or no data:
  hide an empty block and let the others breathe (no "N/A" walls), the CTA stays pinned. Test it with the smallest market in the data.

## Code (exact)
`Godot/scripts/CreationFlowPanel.gd` `_build_globe_card` (~382) + `_globe_stat_bar` (~485) + helpers; split the card into
`Godot/scripts/creation/MarketCard.gd` (new, a Control built from (market row, city board)) so CreationFlowPanel stays readable.

## Gate (CI)
Parse + `globe_picker_test`, `globe_uv_sphere_test`, `globe2_look_test` green (do not weaken). NEW `tests/market_card_test.gd`: for
the UK and for the smallest market in the data: blocks present/hidden as the data says, no block overlaps another, the CTA stays at the
bottom, the sport chips match `specialties`, no text overflows its block at 1920x1080 and 1280x720. Claude renders on the PC and shows
Ludo + the operator.

## The one trap
The city board is built from a preview world - it can be slow; build it ONCE per pick (cache), never per frame or per tween step.
