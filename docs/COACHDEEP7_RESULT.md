# COACHDEEP7 - coaches v7, a staff game: the map and the greybox probe (S542)

Task: `ops/research/TASK_COACHDEEP7.md`. Map: `ops/research/DESIGN_COACHDEEP7.md`. Bars in map s10 were committed BEFORE any run
(commit b2b23c4); trial fixes in map s14. Probe: `tools/coachdeep7.gd` + `tools/coachdeep7_rules.gd` (greybox from
tools/coachdeep6*), summary `tools/coachdeep7_sum.py`. Nothing under scripts/ changed.
Raw (outside the repo): E:/FightCamp/tmp/coachdeep7/ - trial.txt (the last fixed trial), trial_final.txt + trial_final_sum.txt,
full.txt + full_sum.txt (every arm, every cell, score parts). All runs went through `godot_slot.py --who COACHDEEP7`, one at a time,
headless, Dummy audio, with the watchdog checked first (the first start waited ~4 min: memory AMBER with ArcheAge open). 0 script
errors in the full run. Full run: 100 careers a cell per arm, 15 arms, 10 cells = 15,000 careers, 22 min.

## 1. Verdict: FAIL - 4 of 7 (bars 1, 3, 5 fail; 2, 4, 6, 7 pass)
Stop here (FAIL): no critic brief written, nothing queued for kalli or dola, no code-checked critic owed yet.

| Bar | Needed | Full run (100 reps) | |
|---|---|---|---|
| (1) no hire best in > 6 of 10 | <= 6 | **M 7**, L 3 (ties count for each; none) | FAIL |
| (2) K > NOHIRE by > 2 SE with a pro / title boxer; not above +2 SE without | 6 + 4 cells | pro/title: +18.8 +- 0.8, +29.2 +- 0.8, +25.8 +- 1.0, +36.1 +- 1.0, +9.1 +- 0.8, +36.5 +- 1.0; without: -10.3, -6.0, -26.9, -44.9 | PASS |
| (3) no answer best in > 6 of 10, each moment | <= 6 | falling-out **back the coach 7**, split 2, back the boxer 1; raise match 6, refuse 4; style push **refuse 7**, allow 3 | FAIL |
| (4) corner: tactician right >= 25%, bonded >= 25% (fights where they differ) | both | tactician 57%, bonded 43% (1,297 differing fights a career-set, all 10 cells) | PASS |
| (5) careless loses someone in >= 2 cells; careful in <= 1 | both | careless 5 cells; **careful 2** (big_am, big_title: the solid coach S, 0.78 and 0.91 a career) | FAIL |
| (6) trial week right (> +2 SE) in >= 2, wrong (< 0) in >= 2 | both | right 5 (small_am +15.1, big_am +27.4, small_pro +2.8, big_title +12.1, big_hot +35.8), wrong 5 | PASS |
| (7) nothing runs away | all | members = catchment in every arm; cash -$22,483 to +$122,502; 0 months with two moments; bond max 0.25 (cap); chemistry max 0.72 (<= 1) | PASS |

## 2. The ten cells (population named in the output)
TEST CLUB (TestClub.make on Career.quick_start, seed 5391): Lucy (women's lightweight, Out-boxer, 21, temper 72), Kira (women's
featherweight, Out-boxer, 18), Josh (men's welterweight, Pressure fighter, 23), Ana (no-gi, Counter-puncher, 22). No two identical;
each boxes their own sex and class. Cells: small_am, big_am (all four); small_pro, big_pro (Josh a ranked pro, 12th, stats +6);
small_title, big_title (Josh a champion, 1st, +12); small_novice (no Ana, all 18-19, stats -8, no record); big_hot (no Ana, tempers
75-80); small_pro_hot (Josh ranked pro with temper 82, no Ana); big_title_mix (Josh champion, Lucy + Kira novices, Ana).
Hire options: NOHIRE (you + Reid) and v6's five cards (L local pressure $200, M local mat coach $250, S solid engine room $550,
F solid film room $480, K known name $1,000). "Pays for itself at about N members" as the card computes it (map s2): L 24, M 36,
S 60, F 60, K never (needs a pro or title boxer).

## 3. Score by cell (lines over two years; map s10 score: cash/$1,000 + reputation/3 + (W-L)/0.5 + morale/5 + next year)
| Cell | NOHIRE | L | M | S | F | K | best | K-NOHIRE | trial-blind (fav -> alt) |
|---|---|---|---|---|---|---|---|---|---|
| small_am | 269.7 | 290.0 | **305.3** | 267.2 | 276.5 | 259.4 | M | -10.3 +- 1.8 | +15.1 +- 1.3 (L -> M) |
| big_am | 295.1 | 324.4 | **346.6** | 296.5 | 310.9 | 289.1 | M | -6.0 +- 1.6 | +27.4 +- 1.1 (S -> L) |
| small_pro | 337.4 | 360.1 | **373.3** | 330.6 | 336.9 | 356.2 | M | +18.8 +- 0.8 | +2.8 +- 0.8 (K -> L) |
| big_pro | 362.9 | 395.7 | **415.2** | 360.6 | 372.6 | 392.0 | M | +29.2 +- 0.8 | -20.4 +- 0.9 (K -> F) |
| small_title | 334.7 | 356.4 | **368.6** | 325.2 | 332.8 | 360.5 | M | +25.8 +- 1.0 | -28.7 +- 1.1 (K -> F) |
| big_title | 360.1 | 392.1 | **410.5** | 355.8 | 368.5 | 396.3 | M | +36.1 +- 1.0 | +12.1 +- 0.9 (S -> F) |
| small_novice | 10.3 | **32.4** | 30.2 | -1.4 | 16.3 | -16.6 | L | -26.9 +- 1.8 | -2.3 +- 1.0 (L -> M) |
| big_hot | 194.0 | **232.3** | 224.0 | 195.9 | 210.7 | 149.2 | L | -44.9 +- 0.2 | +35.8 +- 0.1 (S -> L) |
| small_pro_hot | 234.9 | **262.6** | 256.4 | 226.0 | 234.7 | 244.0 | L | +9.1 +- 0.8 | -6.3 +- 0.3 (L -> M) |
| big_title_mix | 260.5 | 292.9 | **311.0** | 256.4 | 270.2 | 297.0 | M | +36.5 +- 1.0 | -0.5 +- 0.0 (F, no clash) |
Score parts per arm (cash / rep / W-L / morale / next) are in full_sum.txt; e.g. small_pro K: cash 17.8, rep 98.8, W-L 88.6,
morale 14.6, next 136.4 v NOHIRE 35.0 / 90.6 / 86.7 / 14.0 / 111.1: the known name costs cash and pays in reputation and the
pro's next year (the name fee).

## 4. Forced moments (bar 3), every answer from the same state, the careful line after
| Cell | falling-out: coach / boxer / split | raise: match / refuse | push: allow / refuse |
|---|---|---|---|
| small_am | 289.4 / 288.9 / **304.2** | 287.5 / **289.6** | 286.5 / **290.0** |
| big_am | **295.7** / 294.7 / 286.7 | **291.1** / 279.6 (S lost 3.0x as often) | **297.8** / 295.9 |
| small_pro | **355.9** / 354.5 / 344.0 | **356.1** / 332.7 (K lost) | 352.7 / **356.2** |
| big_pro | **391.7** / 390.3 / 375.2 | **391.9** / 364.3 (K lost) | 388.5 / **392.0** |
| small_title | **360.1** / 358.7 / 348.3 | **359.8** / 334.7 | 357.0 / **360.5** |
| big_title | 355.4 / **357.0** / 345.4 | **352.3** / 332.2 | 353.9 / **355.8** |
| small_novice | 32.0 / 31.8 / **46.6** | 29.9 / **31.7** | **34.6** / 32.4 |
| big_hot | **195.6** / 193.4 / 191.9 | 191.8 / **193.6** | 190.8 / **195.9** |
| small_pro_hot | **262.4** / 261.0 / 255.1 | 259.7 / **262.1** | 258.6 / **262.6** |
| big_title_mix | **269.1** / 268.4 / 265.9 | **264.1** / 254.9 | **272.8** / 270.2 |
The raise is a real call (match where the coach is worth his raise, refuse where he is not). The falling-out's two backing
answers differ by 0.5-2.2 lines in every cell: backing the coach "wins" 7 cells by a hair; only splitting differs (-3 to -17,
except +15 where the clash pair was dragging her down). The style push: refuse wins 7 by 2-4 lines.

## 5. Feedback loops (task s Feedback loops; map s13)
1. Hire -> evenings -> class nights -> members -> dues: members end at the catchment in every arm (66 small / 96 big), never
   above. Class nights run v wanted: NOHIRE 1.2-1.3 a week v 5.9 (small) / 8.9 (big); a 5-evening hire runs 5.8 of 5.9 small and
   6.1-6.7 of 8.9 big (the big club stays ~2.5 nights short: the free evenings run out first). Cash at week 104 per arm: e.g.
   small_am NOHIRE $34k, L $63k, M $58k, S $31k, F $33k, K $13k; big_title NOHIRE $84k, L $122k, M $123k, K $82k (full_sum.txt).
   Bounded by the catchment and class demand; at most 4 coaches (you, Reid, the mat coach where a no-gi fighter is, one hire).
2. Known name -> name fee -> cash: fees over two years $41.7k-$47.9k in the pro / title cells (the $4,000 cap binds in the title
   cells: 12 bouts x $4,000 = $48k); $0 without a pro. The fee needs a pro bout; it cannot feed itself.
3. Bond -> corner listened to -> wins: chemistry is one-way in the code (traits + coached weeks; `_train`'s bond line is the only
   writer; wins and losses move loyalty and morale only). Bond max 0.25 = the cap in every arm.
4. Falling-out -> loss -> more falling-outs: longest run of months with a person lost: mean 0.03-1.24 a career; never a cascade
   (one moment a month, two warnings first, a person who left fires nothing).
5. Style push -> learning -> more pushes: one push a boxer a season (`push_s`); the bonus tops at the fit's +15%.
6. Course -> ratings: +2 to the lowest of pads / tactics / teaching, never past rating + 3.
ONE-REP TRIAL (printed in full, raw trial*.txt): first run FAIL 2 of 7 and showed the greybox could not measure the map (map s14);
after the fixes 3 of 7, then 4 of 7 on the last trial. No stop rule fired: members stayed at the catchment, the best hire differed
by cell (M / L), and people were lost (S, K, F, Josh, Lucy in some arms).

## 6. What the trial found (fixed before the full run, map s14; bars untouched)
- **The game's win-chance read ignores the corner coach.** `BoutRead.chance(f, opp, camp, coach)` returned the same chance at
  coach 0, 30, 55, 80 and 100 for all three boxers v three opponents each, and two OppFile tapes changed nothing. v5/v6's tactics
  and film levers were dead in their greyboxes. v7 prices the corner's calls with `Exchanges.EDGE` on `BoutRead.round_edges`.
  **For the build (step 5, the corner pick): the corner coach must reach the game's read; today it does not.**
- The no-gi fighter had no mat coach (one card won 8 of 10 cells by giving her a career); a $150 sessional mat coach now comes
  with her.
- The "no" answers cost nothing (refuse won every raise); a matched raise compounded to ~$1,950 a week. Both fixed (map s14 4, 6).

## 7. Why each failed bar fails, and the one change that would fix it
- **Bar 1 (M best in 7):** M wins exactly the seven cells with the no-gi fighter (by 12-22 lines over L) and L the three without:
  the right hire flips with the roster, but one card is a boxing class teacher (teaching 15) AND a mat coach for $250, a superset
  of the cheap local. ONE CHANGE (inside the interview, grill Q17 "wages scale with ratings"): a coach who teaches two arts is a
  solid-band coach ($400-600), not a local - price the second art, so the two-art coach is a real trade against a cheaper
  one-art local plus the sessional mat coach.
- **Bar 3 (falling-out back the coach 7; style push refuse 7):** one warning alone never loses anyone (a person leaves only on
  a second warning, interview 15), and after a backing answer the careful "change" unpairs the clash pair, so the falling-out
  never comes back. So "back the coach" and "back the boxer" differ by 1-2 lines, and refusing a push is nearly free.
  ONE CHANGE (inside interview 3 and 15): a warning costs something by itself while it stands - the warned boxer trains and
  listens worse (morale and trust down) and the warned coach works worse, until it fades after a season - so who carries the
  warning decides the answer, not only whether someone leaves.
- **Bar 5 (careful line loses the solid coach in 2 cells):** the careful line trusts the card's "pays for itself at N members"
  line; at S's raise to his band top ($600) the line flips to "never pays on members alone" ($585 a week of class nights is
  the most his evenings earn), so it refuses and S (loyalty 10) leaves - yet the forced raise shows matching is worth +11.5
  and +20.1 lines there. The line counts only class nights and dues, not what a coach does for the boxers. ONE CHANGE (inside
  interview 6, the plain line on the wage): the card and the raise pop-up count the boxer side too ("his boxers win about X
  more a season"), from the game's own coached-v-alone gain, so the line says when a coach pays in results as well as in
  members.
The change I would make first: bar 3's (a warning costs something on its own) - it is the one that makes the moments real
two-way calls, the heart of interview 8. Bars 1 and 5 are a card price and a card line.

## 8. Decided in this task (no questions asked)
- K's wage $1,000 (inside $800-1,100); the name fee 60% of the purse, cap $4,000 a bout, +2 reputation a pro win - sized from
  the Matchmaking purse table so a ranked pro's ~13 bouts in two years cover the wage gap measured in v5/v6 (-29 to -39 lines).
  Real-world reasons: grill Q17 wage bands (today $450 and $1,090); the trainer's ~10% of the purse (Matchmaking.GYM_SHARE note:
  manager 15% + trainer 10%); famous trainers bring the bigger cards (ops/research/topics/staff_coaches.md, G135).
- Trial price = one week of his wage; course $600 (England Boxing course GBP 300-500 x 1.25); raise +25% capped at the band top.
- Pro bouts every 8 weeks (title every 12), opponents from the top of the rival list, rank +1 a win, -2 a loss (greybox, said in
  map s11); the pro's 3-round read stands in for the longer card.
- The careful line (map s12) reads the warnings, uses the free "change", and matches a raise only when the card says he pays.
- Ties count for every tied answer or hire (stricter than first-listed, as v5/v6).
- The verdict is the full run; the trial fixes went in before it and nothing was changed after it.
