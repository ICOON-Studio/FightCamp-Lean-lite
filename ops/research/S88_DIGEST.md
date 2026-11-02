# S88 DIGEST - training floor step 4b: tiers 3-4, the build-a-wing event, wing doors, presets, a hired sparring partner
Claude, 2026-09-26. Roadmap `now` from S87.

## Shipped
- **TIERS 3-4 AND THE WING (G118).** `GymWing.gd` (pure, zero preloads): tier 3 "<discipline> academy" 14 x 10 cells
  (21 x 15 m, 315 m2), tier 4 "<discipline> team HQ" 18 x 14 (27 x 21 m, 567 m2). Past tier 2 `expand_floor` refuses
  ("BUILD A WING"); `start_wing_build` pays $55 / sq ft for the added bay (G118 $40-80) plus the wing's pieces at half the
  catalogue price (used, G118) - tier 3: two mats ($124k on a 12-col floor), tier 4: a second ring + a physio table
  ($159k); 6 / 10 weeks; station capacity x0.80 while the builders are in; `_advance_wing_build` in `advance_week`
  (news "Builders in ..." then "The wall is down ..."). On landing the floor grows, the pieces stand and
  `apply_floor_preset` re-hangs every owned item: slot by catalogue id, leftovers first-fit outside every ring apron.
  Nothing bought or dropped. The gym hub's expand button reads BUILD A WING · $ · N WEEKS / BUILDERS IN · N WEEKS LEFT.
- **MEMBERS:** `Membership.natural_members` + `GymWing.member_bonus` (+60 at tier 3, +80 more at 4) and the tier cap
  (180 / 350, G118). Tiers 1-2 untouched.
- **PRESETS (G121):** one hand-authored layout per new tier (15 / 22 stations) from G121's T2/T3 plates; `violations()`
  checks the grid, overlaps and G121's three hard rules (1 empty cell = ~2 m apron round a ring; bag centres >= 2 m; no
  mat against a ring's apron). Tiers 1-2 keep the S84 starter layout - a tier-1 room (~90 m2) cannot hold G121's 2 m
  apron, and G121's own smallest plan is 224 m2. G121 as written violates its own rule 1 (T3's bags touch its cage);
  our presets are authored from it and CHECKED, not copied.
- **WING DOORS:** tier 3 adds MAT ROOM · CLASSES (-> FINANCE: the classes are the members' money, G118), tier 4 adds
  STAFF ROOM (-> staff) and PHYSIO (-> fighters). Shells coloured per tier.
- **HIRE A SPARRING PARTNER (G120 + Q190):** a fighter in camp gets four offers from `SparPartnerMarket`, spec = his
  booked opponent's stance and height, level by his OVR (<50 amateur, <70 regional, else world), the opponent's
  `fight_plan` copied onto the partner, a record in his level's band. `hire_spar_partner` books him through `book_spar`
  (G117 caps count him) and takes the day rate x (1 + travel days) only if the coach agrees and the save lands. The
  partner is a spar-only row in `career.spar_partners` (`_spar_body`), never on the roster; he fights through
  `spar_fight_setup`, so WATCHED == SETTLED holds with him in it; no rivalry with a man who goes home tonight. Ring card:
  "X is in camp for Y - bring in a man who fights like him:" / name · level · stance · cm · N% like him / HIRE HIM · $.
- **D33 acted on:** the pair line is now two columns with bars (`Cole 63 kg 4-1 OVR 58 | Dario ... | RISK LOW`), a hired
  man shows HIRED instead of an OVR.

## Collected
- **U182 (Cursor):** the spar plays in the gym ring (club spec per ruleset, gym shell, half-width kept in step).
  Merged without its 55 MB AVI. Its digest found the raised knee in boxing spars (dodge clips on boxing footwork) -> U183.
- **Q190 (Qwen), verified, not taken at face value:** its two "mutants" only inspected hand-built dicts. Added real
  checks (no partner is the fighter, own palette per partner, KB partners kick, a man never has a female first name) and
  proved them with FOUR real mutants on the module (class gate dropped, fighter's own stats, one palette per level,
  unfiltered name pool) - all red. Fixed three defects: every partner at a level shared one tier-sorted palette; male
  partners drawn from a pool with 13 female names; partner classes named from weight_classes.json ("Super
  Featherweight") that the game's ladder does not have - the caller's ladder now wins.
- **G121 (Grok):** `G121_REAL_GYM_FLOOR_PLANS.md`. **D33 (Dola):** `D33_FRESH_EYES_WATCH_THE_SPAR.md`.

## Tests
- NEW `gym_wing_test` 0 failures: presets legal + 4 checker mutants; tier 1 expands, tier 2 refuses columns; tier 3 and 4
  quoted inside G118's $/sq ft and weeks, cash out, capacity 80% during works, one wing at a time, the floor grows to the
  tier's size after N weeks, pieces stand, every item kept, the re-hung floor legal, news lines; tier 4 is the top;
  member cap/bonus; every wing door routes; a hired partner is legal (boxing, sex, +-1 class on the GAME's ladder), not
  the fighter, not the opponent, stands like the opponent, priced in G120's band, costs cash, never joins the roster,
  WATCHED == SETTLED field by field, a real spar (punches landed), no rivalry, a second hire the same day refused; the
  ring card offers HIRE HIM, pressing it books the ring, the booked card shows the pair side by side with HIRED.
  Mutants: no preset on landing, no capacity cut - both red.
- `spar_partner_market_test` 10/10 with the stronger checks.
- Subset (gym_, training_floor, membership, smoke, spar, fight_camp, floor, wing, day_feed, career_loop, menu_clarity,
  home_pin): **25 tests, 0 red**; after the last card edit training_floor, gym_wing, spar_watch, gym_sparring,
  spar_partner: 5/5. Nightly: `AgentComms/nightly/latest.txt`.

## Renders
`docs/previews/s88/floor_tier3.png` (Boxing academy, HIRE row), `floor_tier4.png` (Boxing team HQ, two rings, six doors).

## Assigned
U183 (Cursor): boxing footwork clips that never lift a knee, measured on the game skeleton. Q191 (Qwen): does a hired
partner fight like the opponent - three arms (reference / matched / control). G122 (Grok): what the walls do (decor,
trophy walls) for a later decor layer. D34 (Dola): fresh eyes on the S88 renders.

## Not done
The visiting-pro floor event and open-spar night (G120 s6) - S89.
