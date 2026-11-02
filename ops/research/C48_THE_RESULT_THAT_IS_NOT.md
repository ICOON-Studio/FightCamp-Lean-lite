# C48 — THE RESULT THAT IS NOT A RESULT

**Status:** research and proposals only. No script or data writes in C48.

## Decisions page

| Call | Recommendation | Why |
|---|---|---|
| Canonical non-result | Store an explicit `no_contest` result type. It is not W, L, or D; it does not alter either record, ranking points, streak result, or the belt. | ABC MMA places an accidental-foul stoppage before the scoring threshold in the NC/DQ branch; an NC is not a competitive verdict. |
| Scored early stoppage | Store `technical_decision` separately from the participant outcome. It uses the filed cards, including the incomplete round, and may yield the existing W/L/D outcome. | ABC MMA sends a post-threshold accidental-foul stoppage to the cards and awards the fighter ahead. |
| Threshold | MMA: before **2 of 3** or **3 of 5** scheduled rounds, NC (with the rule's DQ alternative); after that threshold, technical decision. Preserve the exact scheduled-round count. | The current ABC MMA text uses scheduled-round thresholds, not a generic elapsed-time guess. |
| Boxing contrast | Use the boxing equivalent as a fixed **four completed rounds** gate: before four, `NO DECISION`; after four, technical decision; partial rounds are scored. Canonical game storage may normalize `NO DECISION` to `no_contest` while retaining the source label if needed. | ABC Unified Boxing does not use the MMA 2-of-3 / 3-of-5 threshold. |
| Authority and review | The referee makes the in-bout stop and foul/continuation call. A commission or applicable regulatory authority handles a later protest or result change. Do not invent a universal appeal clock: `appeal_window = UNKNOWN`. | ABC makes the referee the sole arbiter/only authorized stopper, while Nevada limits post-bout changes to specified errors/collusion and gives an anti-doping exception. |
| Anti-doping overlay | Keep J3 D9 separate. Nevada may change a win or draw to NC in its sole discretion after an anti-doping violation; a positive test must not auto-flip every result. | The regulation says “may,” and requires a note in the combatant's record. |
| Belt | An NC in a title bout leaves the belt, interim state, and champion unchanged. It still was a title bout for history/participation if the booking flag says so; it is never a title win or defense. | The title flag is booked before the result; the result must not be allowed to masquerade as a W/L and enter title resolution. |
| Cheapest first step | Add/read the explicit type and teach every consumer to preserve or skip it. Do not generate NCs yet. Add generation only after the result contract is stable. | The current vocabulary is authored, but no script currently carries it end to end. |

## Evidence

### ABC Unified Rules of MMA

The [ABC Unified Rules of MMA, August 2026 PDF](https://www.abcboxing.com/wp-content/uploads/2026/08/Unified-Rules-of-MMA-8.2026.pdf) says:

- The referee is the sole arbiter and the only person authorized to stop a contest; video or other review remains possible through the applicable regulatory authority after a protest alleging a clear rule violation (rule 2, p. 1).
- For an accidental foul severe enough to stop the bout, a pre-threshold stoppage is **NO CONTEST or DISQUALIFICATION**: before 2 of 3 scheduled rounds or before 3 of 5 scheduled rounds (rule B.1, pp. 5–6).
- After that threshold, the bout goes to a **TECHNICAL DECISION** for the fighter ahead; incomplete rounds are scored (rule B.2, p. 6).
- The same document separately defines No Contest as a premature accidental-injury stoppage before enough time has been completed to render a card decision, and identifies ordinary unanimous/split/majority decisions as card outcomes (p. 9).

The C48 build contract should therefore not make `no_contest` a disguised draw. A technical decision is scored; an NC is not. If the post-threshold cards are level, the cited accidental-foul clause does not state the tie disposition: that edge is **UNKNOWN**, not a reason to invent a winner.

### Boxing equivalent

The [ABC Unified Rules of Boxing](https://www.abcboxing.com/unified-rules-boxing/), section 12.B, uses a fixed gate: an accidental-foul injury stopped before four completed rounds is **NO DECISION**; after four completed rounds it is a **TECHNICAL DECISION** for the boxer ahead, and partial/incomplete rounds are scored. The boxing page also gives the referee the sole-arbiter/stop authority and permits review under the applicable regulatory procedure. This differs from MMA's scheduled 2-of-3 / 3-of-5 threshold. No separate universal accidental-foul threshold was established here for the other disciplines: **UNKNOWN**.

### Later changes and anti-doping

[Nevada NAC 467.579](https://www.law.cornell.edu/regulations/nevada/NAC-467-579) permits the Commission, in its sole discretion, to change a win or draw to no contest when the combatant is found to have committed an anti-doping violation, and requires a note in the combatant's record. This is a commission overlay, not an automatic engine consequence of every positive test; J3 D9 owns the overlay.

[Nevada NAC 467.770](https://www.law.cornell.edu/regulations/nevada/NAC-467-770) says the Commission will not change a decision except for collusion, a scorecard-compilation error showing the wrong winner, or a referee/review-official error in interpreting the chapter. The cited provision gives no universal post-bout filing deadline. The game's general overturn window is therefore **UNKNOWN** and must not be authored as a number in C48.

## What the game does today

### Result entry and settlement

- `GameState.gd:11308-11323` reads only `winner_side`; an empty side becomes `result = "draw"`. A future NC with no winner therefore becomes a draw before settlement unless the type is read first.
- `GameState.gd:11336-11370` freezes `result`, `method`, cards, `decision_type`, and scoring style, but no explicit result type. This is the durable entry seam.
- `GameState.gd:11470-11516` settles money and reputation. Missing/unknown outcomes default to `loss` at `:11478`; only `draw` and `loss` receive reputation reductions at `:11513-11516`, so an unhandled NC would receive the base reputation. Contract settlement is also passed the three-valued `result` at `:11505`.
- `GameState.gd:11576-11586` updates only `wins`, `losses`, or `draws`, then sends the same three-valued result to `TaleOfTape`. There is no persisted player `nc` counter. The initial player record is W/L/D-only at `:3381`; generated offer records are W/L/D-only at `:5386`.
- `GameState.gd:11739-11824` writes `last_fight`, `fight_history`, and `fight_log`. These rows already preserve an arbitrary result string, but the player settlement row does not write `title_fight`; the booked title flag is only consumed by the title resolver. Additive result typing can be persisted here without rewriting old rows.

### World and watched bouts

- `WorldPopulation.gd:968-1008` (`apply_watched_bout`) always increments one winner and one loser, awards `+24/-6` ranking points, calls the tape as win/loss, and appends winner/loser IDs. It has no NC branch. Gym wins/losses are updated at `:1009-1010`.
- `GameState.gd:2427-2497` (`record_watched_world_bout`) derives a side from `winner_id` and routes to the world path. The API has no explicit result type; a no-winner watched bout cannot be represented honestly. `:2510-2524` then writes W/L history for both world athletes.
- `GameState.gd:2533-2552` (`_close_player_bout_on_card`) requires a winner ID and appends only winner/loser/method to the card result. The broadcast read at `:2111-2152` exposes winner/method/round/time but no result type.
- `WorldPopulation.gd:1659-1697` (`_resolve_world_event`) always chooses a winner, applies W/L records and `+24/-6`, updates fatigue/tape/time, and appends winner/loser data. It currently generates no NC, which is correct for the cheapest first step; do not silently add one to world generation.
- `GameState.gd:8704-8737` does the same W/L-only work for an automatic Grand Prix bout. `GameState.gd:8847-8952` is more dangerous for a future player NC: `:8867` defines every non-win as the opponent's win, then records elimination, advances the bracket, or crowns the opponent. NC must stop this path without advancing either side.

### Belt, rankings, and streaks

- `GameState.gd:11623-11653` calls `WorldPopulation.resolve_title_bout` only for `win` or `loss` (`:11647-11650`). That currently protects the belt from an NC, but it also means an NC title bout never increments `title_fights` and cannot be represented as a title appearance unless the booking flag is copied to the row. `WorldPopulation.gd:1341-1440` is the belt mover: it increments title-fight/title-win counters and changes the belt only after a W/L result. An NC must bypass this mutation entirely; it must never call the resolver as a disguised draw.
- `WorldPopulation.gd:1526-1570` (`division_rankings`) sorts by `_leaderboard_points`; `:1587-1616` (`p4p_rankings`) does the same; `:1619-1639` snapshots both. `WorldPopulation.gd:1649-1656` derives fallback points from wins minus losses only. An NC should leave points unchanged and be visible only as an extra record field/read, never as a loss.
- `GameState.gd:11594-11600` applies player ranking points only for W/L, so preserving NC as its own type is naturally neutral; the initialization formula still needs a fourth-field-compatible read.
- `GameState.gd:6506-6512` (`_request_win_streak`) already stops on anything other than `win`; `:9123-9125` only treats a prior loss as a rematch/off-loss; `:4944-4947` only gives recent-win morale. These are safe once NC is not mapped to draw/loss, but belong in regression coverage.
- `FightRecordStats.gd:61-89` already treats any result other than W/L/D as `nc`, but this is an implicit catch-all: it counts malformed/unknown legacy values as NC. Its method buckets at `:5-14` omit technical decision; its canonical record string at `:128-140` remains W-L-D while exposing `nc` separately. `:150-161` makes NC break the current streak, which is correct. The build should make the type explicit and preserve the existing W-L-D display plus `nc`.
- `GameState.gd:11846-11849` is the wrapper feeding all record reads; `:11943-12038` copies stats into the Gym hub and currently omits `nc` from the visible record object. Raw record copies at `:6330-6340`, `:7486-7523`, `:7940`, `:10989-10994`, and `:13324-13333` will carry an additive field automatically, while shaped output at `:12031-12038` needs an explicit `nc` value.

### Career summaries and mileage

- `CareerEpilogue.gd:23-57` composes the finished career; `_peak_year` (`:76-104`), `_defining_win` (`:107-138`), and `_epitaph` (`:155-190`) select wins only. They do not currently count an NC as W/L/D, which is safe, but `rows.size()` still treats an NC as a career bout. The row must remain a bout while not becoming a loss; title participation also depends on the missing player `title_fight` row field.
- `CareerArc.gd:19-128` counts every dated row as a fight and only classifies W/L/D at `:54-60`; its yearly output at `:90-98` has no NC field. Keep NC in physical career span/fight count, add an explicit NC tally if the summary is to expose complete results, and do not let it enter the W/L comparison in `_better` (`:150-161`).
- `Mileage.gd:19-66` counts rows and usable rounds as physical mileage. Finish counters at `:41-46` only recognize W/L plus finish methods, so NC is already excluded from wins/losses. A real NC bout should remain physical mileage; a bout with no usable round remains an unknown-round bout. This is not a competitive record counter.
- `GameState.gd:11030-11034`, `:11622`, and `WorldPopulation.gd:1501-1509` count measured/generated fight time. That physical clock should remain neutral to the result type; do not remove a fought NC from mileage merely because it has no winner.

### Fight read and scorecard surfaces

- `BoutRead.gd:18-50` captures method, winner side, cards, rounds, and scoring style; `:55-66` reconstructs pending results with `win`/`loss`/empty winner logic; `:69-95` returns a stored scorecard/range but no result type. Additive NC storage must survive capture and reload, with no fabricated winner or scorecard.
- `PostFightRead.gd:8-39` totals every stored card and marks `scored` solely from card presence (`:36`). Its decision read has method/winner/scored but no result type. NC must return an explicit type and `scored = false`; technical decision may use the filed cards and keep `scored = true`.
- `GameState.gd:10684-10697` is the durable bout-read door and `:14005-14006` is the live post-fight-read door. Both must expose the fourth type without changing absent legacy evidence to an invented verdict.
- `RoundScoring.gd:97-153` is the scorecard constructor; `JudgePanel.gd:115-167` sums cards and types ordinary decision/unanimous/majority/split outcomes. These paths should score a technical decision, but must not be called to manufacture an NC. A later technical-decision wrapper can retain the ordinary card decision plus `result_type = technical_decision`.

### Other result-sensitive effects in the settlement seam

These are not record counters, but a build task must make the fourth answer explicit rather than inherit an L/D branch:

- `GameState.gd:11513-11516` reputation; `:11659-11667` morale; `:11668-11723` rivalry, short-notice goodwill/news, and fame; `:11681-11687` fame calculation. NC should not be narrated as a draw or loss, and should not create a loss-only rematch/grudge. Physical fatigue/body damage at `:11691-11729` may still apply because the bout occurred, but `:11728` currently gives every non-win the loss-side injury chance and needs an explicit NC decision.
- `GameState.gd:11611-11620` contract title-shot/rematch clauses: NC must not trigger a win guarantee or loss-only rematch.
- `GameState.gd:11766-11778` freezes decision metadata and `BoutRead` evidence; preserve the type in both history and log rows.

## Minimum change / build order

1. Define one additive, explicit result type at the recorded bout boundary. Preserve existing W/L/D participant outcomes for ordinary and technical decisions; represent NC as a fourth participant outcome with no winner side. Represent `technical_decision` as a scored result type/method carrying the existing card-derived W/L/D outcome. Migrate old rows by absence, never by guessing.
2. Thread that type through `record_live_fight_result` and `_apply_fight_result`, including pending/history/log rows, `BoutRead`, `PostFightRead`, broadcast reads, and the watched-bout APIs. Do not use an empty winner as a draw and do not require a winner ID for NC.
3. Teach record/stat consumers: persist/read `nc`; keep NC out of wins/losses/draws, ranking points, W/L streaks, loss rematches, win/loss clauses, and title wins. Keep a real NC in physical fight time/mileage. Add NC to career yearly summaries if those summaries promise a complete result breakdown.
4. Guard the title path: retain the booked title flag and count the title appearance if that is the existing title-history promise, but do not call belt mutation for NC. No belt move, defense, interim consumption, or vacancy follows NC.
5. Guard Grand Prix and world watched settlement: NC completes the evidence record but advances neither bracket side and changes neither world record/ranking/gym W/L. World auto-generation remains W/L-only.
6. Only after the contract is stable, add a separately authored foul/round decision generator. That generator must carry scheduled rounds, stoppage timing, foul intent/injury/official decision, cards for technical decisions, and the applicable authority. This is a larger simulation/appeal task and is not part of the cheapest first step.

**No test or parse gate was run, per the research-only task.**
