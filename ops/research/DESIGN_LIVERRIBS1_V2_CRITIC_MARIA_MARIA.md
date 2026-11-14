# DESIGN_LIVERRIBS1_V2_CRITIC_MARIA_MARIA - Maria answer (seat queue SQ92)

Brief: research/DESIGN_LIVERRIBS1_V2_CRITIC_MARIA.md
Sent: 2026-11-14 01:11 | collected: 2026-11-14 01:41 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I give LIVERRIBS1 v2 **DEPTH 7, GENERAL DESIGN 6, PLAY 7**, so it clears the owner's 6+ / 6+ bar. The split between liver (stamina drain and delayed fold tonight, no layoff) and ribs (dropped guard and weakened arm tonight, cracked rib recovery after the bell) is sharp, anatomically right for both orthodox and southpaw boxers, and well wired to the corner. What keeps it from a higher design score is a set of rule collisions with the existing game: conflicting healing times, free scouting leaks on amateur offers, an unbuildable pad-lock rule, and live round scorecards on the 10/10 page.

## Scores

**1. DEPTH: 7/10**
This creates real two-way trade-offs in every stance matchup. Against an orthodox opponent, `Aim Liver` throws quick lead left hooks into 60% rear cover to drain the tank and chase an 8-count fold, while `Aim Ribs` throws committed rear right shots into 30% lead cover to pull down their left guard (`−5`) and weaken their jab (`×0.85`). Against a southpaw, the geometry flips: the liver sits on the 30% lead side and the left ribs protect their rear power hand. Between rounds, `Right elbow in` and `Left elbow in` trade `+20` side cover for `−10` head guard on that side, and the opponent adapts after two rounds of heavy cover. The three-choice crack card (`Pull your boxer out`, `Defend the side`, `Fight through`) forces a real call between tonight's bout and weeks on the shelf.

What holds it back:
- **Unresolved lock on `4b` and `2b` mastery.** By the game's rules, a move only fires in a bout once pad work brings it to mastery `30` (Usable). Because `3b` only hits the defender's right side for orthodox attackers and left side for southpaws, an orthodox boxer whose `4b`/`2b` are still under `30` cannot target left ribs, and a southpaw whose `4b`/`2b` are under `30` cannot target the liver at all. The map doesn't say whether `4b`/`2b` start usable or how `Aim` behaves before they unlock.
- **Crack-card healing jumps skew the choice.** `Defend the side` throws zero punches with the cracked arm, yet jumps recovery from `35` days (`Pull out`) to `63` days—longer than Rule 9's own `35–56` day range for a cracked rib. Meanwhile `Pull out` triggers the 30-day suspension and ~8-week rest after a stoppage loss, so the player isn't told whether `63` days or `Pull out` actually gets the boxer back in the ring sooner.
- **"Commitment" on `4b`/`2b` isn't defined.** Rear body shots cost more energy and "commitment" than `3b`, but without a real number (such as a counter-hit window or lower base accuracy), the rear-vs-lead trade is guesswork until the probe runs.
- **Overlap with `Elbows in`.** The corner already has `Elbows in` (which routes half of body shots to the head and is measured not to change who wins). Keeping it beside `Right elbow in` and `Left elbow in` muddies `ONE CHANGE`.

**2. GENERAL DESIGN: 6/10**
The map fixes the big v1 errors: `BodyMap` now places the liver on the defender's right side for both stances, fold power uses `Strength`, `Explosiveness` and move mastery instead of the `Power` summary stat, the invented `"legs bar"` and `"Cover up"` shout are gone, `Knockdowns` matches amateur RSC limits (`3` in a round, `4` in a bout), names stay in headers only, pronouns stay neutral, and rival news is gated behind unbuilt NPC injuries.

What holds it back:
- **Two healing scales for the same cracked rib.** Section 4.1 prints `35 / 63 / 84 (+28)` days on the crack card, while Rule 9 sets cracked-rib recovery at `35–56` days (matching real-world NHS guidance of 2 to 6 weeks for a simple rib fracture, plus return-to-sparring clearance). Pick one consistent scale.
- **Free scouting leak on amateur offers.** Section 5 and 6 show `"Hunts the liver"`, `"Breaks ribs"`, and `"Body threat: Moderate rib injury risk"` on `Bout offer` / `BoutRead`. By the game's rules (section 4.6 and S410), there is **no scouting before accepting an amateur offer**; hidden tendencies open only through tape study in camp (or `$250` pro scouting, with weapon public).
- **Unbuildable `"no pads on left side"` lock and mismatched bruised penalty.** `PadWeek` schedules moves and combinations, not left-side vs right-side filters, so `"no pads on left side"` can't be enforced without naming which moves lock (which would block almost every orthodox lead punch). And bruised ribs invent a `−5` energy penalty when `Injuries` already has a `fight hurt` rule (`−10 / −15 / −20` energy for minor / moderate / serious).
- **Live scorecards in the 10/10 Fight night header.** Section 8 puts a `"live scorecard read"` in the top bar, which breaks the owner's agreed Fight night rules (section 6: `"scorecards after each round"` is held back).
- **Playbook and `Aim` mismatches.** `"When opponent's ribs are hurt -> Attack the head"` isn't a Playbook situation or move (`GamePlan` answers are punches/arrows, and `Attack the head` is an `Aim`). In `Aim`, section 6 swaps `Liver` and `Ribs` into the shout bar while section 8 drops `Own game` and leaves `"Target opponent's hurt side (head)"` unclear alongside the existing `the hurt head` aim.
- **Missing corner-slot rule and a raw code string.** The map doesn't say whether `Defend the side` / `Fight through` uses one of the two corner `ONE CHANGE` slots or sits free behind the divider like the cutman card. Also, `STOP_REST_WEEKS` is printed raw inside the quoted button text on the crack card, and `"3D fold animation"` isn't flagged as an unbuilt 3D asset need.

**3. PLAY: 7/10**
Players already see `"liver"` and `"ribs"` in the round hit feed today; this turns those words into something the player actively hunts and defends. Dropping an opponent's guard from rib work, catching a corner warning that the opponent switched sides, and staring at the three-way crack card between rounds all create real fight-night drama and feed directly back into `Playbook`, `Week`, and `The Why`. What dulls it is the risk of `Aim` feeling stuck when `4b`/`2b` aren't at mastery `30` yet, and a confusing `"left-side pads"` lock on `Week`.

## Options: missing, useless, and what each changes

**Missing**
- **Starting mastery / fallback for `4b` and `2b`** when a boxer hasn't drilled them to `30` (otherwise half of `Aim` fails silently by stance).
- **A clear corner-slot rule** on the crack card (whether `Defend the side` is free behind the divider, and whether it locks out `Left elbow in`).
- **A concrete counter-risk or accuracy cost** for `"commitment"` on `4b` and `2b`.
- **Which moves lock on `Week`** when a boxer has a cracked rib (or simply lock sparring and heavy bag, keeping pads light/technique only).
- **Clarification of `FightMeters` energy ceiling `−25`** on a liver fold: whether it recovers at the bell or stays lowered for the rest of the bout.
- **Whether the 3D body-fold knockdown animation exists** or must be added to the build list.

**Useless or conflicting as written**
- **Generic `Elbows in`** sitting next to `Right elbow in` and `Left elbow in` in `ONE CHANGE`.
- **`"When opponent's ribs are hurt -> Attack the head"`** as written (an Aim masquerading as a GamePlan move line).
- **Pre-accept `"Body threat"` and scout lines on amateur `Bout offer`**, which can't be shown without breaking amateur no-scout rules.
- **Live scorecards in the 10/10 header**, which is held back by the owner.

**What each option changes**
- **`Aim: Liver (right side)`:** directs left-hand body shots to the defender's right side for `1.3×` stamina drain and delayed fold knockdowns at `HURT` (`<=55`), with zero post-bout injury.
- **`Aim: Ribs (left side)`:** directs right-hand body shots to the defender's left side (`0.55×` drain), dropping left head guard (`−5`) and left-hand output (`×0.85`) at `HURT`, risking mid-bout crack (`×0.6` left punches, `−10` left guard, `40–65%` opponent corner stop) and post-bout bruised/cracked layoffs.
- **`Right elbow in` / `Left elbow in` (`ONE CHANGE`):** `+20` cover on that body side, `−10` head guard on that side; after two rounds of heavy cover, the opponent switches sides.
- **`Switch Aim` corner button:** switches persistent `Aim` between rounds to the open side or the opponent's dropped left-side guard.
- **`Pull your boxer out`:** stops the bout now (stoppage loss, 30-day suspension, ~8-week matchmaking gap, reputation/member/morale hit, lowest rib recovery time).
- **`Defend the side`:** stays in the bout with `0` punches from the left arm and `−4` left guard, avoiding stoppage penalties at a longer layoff than pulling out.
- **`Fight through`:** stays in the bout at `×0.6` left-hand output and `−10` left guard, trading the highest win chance for the longest layoff and a `1 in 10` chance of making the break worse.
- **Drill `4b` / `2b` and combos (`1-2b-3`, `2b-3`, `3b-4b`):** unlocks and sharpens rear-hand body shots to target the opposite side.

## To reach 10/10

1. **Unify the cracked-rib healing scale.** Keep one table across Rule 9 and Section 4.1: `Pull your boxer out` = `28–35` days (boxer stopped taking shots early, though the 30-day suspension and ~8-week stoppage rest still apply); `Defend the side` = `42` days; `Fight through` = `56` days (`+21` days `1 in 10` worse, up to `77` days). Show both the medical layoff and the stoppage rest clearly so the player can compare `Pull out` against `Defend the side` honestly.
2. **Solve the `4b`/`2b` unlock gap by stance.** Give every newly generated boxer starting mastery `30` (Usable) on whichever single body shot hits the *opposite* side from `3b`, OR let `3b` / `2b` start at Raw (`20`) and make `Aim` still throw them at Raw efficiency until drilled to `30` (`LIVERPROBE1` checks both stances in Week 1). Quantify rear-hand `"commitment"` as a concrete rule (for example `+15%` counter-hit window for the opponent and `1.25×` attacker stamina cost vs `3b`).
3. **Move `"Body threat"` and body-hunter lines behind scouting.** On amateur `Bout offer`, show `"Body threat: unknown (open in camp)"`. Reveal `"Hunts the liver"`, `"Breaks ribs"`, and `"Body threat: Low / Moderate / High"` only after camp tape study (or on `$250` pro scouting / public weapon tape). Mirror `Aim` in `BoutRead` using only what has been scouted, plus a generic estimate when unscouted.
4. **Replace `"no pads on left side"` with buildable `Week` locks.** Bruised ribs: sparring locked, pads allowed, and fighting bruised uses the game's existing `fight hurt` minor energy penalty (`−10`, or adjust to `−5` explicitly in `Injuries`). Cracked rib: sparring and heavy bag locked for the layoff; pads restricted to half-speed shadow/footwork (no `3b` or `4b`/`2b` power drills), or simply lock all pads and sparring while keeping roadwork, film, and footwork open.
5. **Fold `Elbows in` into the new side fixes.** Remove generic `Elbows in` from `ONE CHANGE` so `Right elbow in` and `Left elbow in` stand cleanly beside `Gloves high` and habit fixes, without a dead duplicate.
6. **Settle the crack card's corner rules.** State that the crack card sits free behind the divider (like the cutman card) and does not eat one of the two corner `ONE CHANGE` slots; picking `Defend the side` locks out `Left elbow in` for the rest of the bout. Strip raw `STOP_REST_WEEKS` from button copy and write `"next bout ~8 weeks"`.
7. **Fix the Playbook line and `Aim` consistency.** Rewrite the Playbook line as `"When opponent drops a hand -> Lead hook / Cross"` (a real `GamePlan` move/arrow), or add `"Opponent's ribs are hurt"` as a `GamePlan` situation paired with specific head punches (`Jab`, `Cross`, `Lead hook`). Keep `Own game`, `Head`, `Liver (right side)`, `Ribs (left side)`, and `Head (hurt side)` consistent across the shout bar, `CornerRead`, and `BoutRead`, and state that clicking `"Switch Aim"` in the corner costs no shout slot.
8. **Clarify `FightMeters` energy ceiling `−25` and the 3D fold asset.** State that the `−25` energy ceiling drop on a liver knockdown persists for the bout (matching `body_taken` ceiling cuts) or recovers `15` at the bell, and list the 3D body-fold knockdown animation explicitly under needed assets if it isn't in the rig yet.
9. **Remove live scorecards from the 10/10 Fight night header.** Replace `"live scorecard read"` with round number, corner clock, and knockdown/RSC counts only.

These need things the game can't do yet: the `Rear body hook (4b)` / `Rear straight to the body (2b)` move definitions and animations (plus a 3D body-fold knockdown clip if missing), the `OpponentAI` 2-round side switch, and living-world NPC injuries for the gated rival-news hook.

**My 10/10: Fight night corner minute after round 2, 1920×1080 (dark and tight)**
- **Header strip (88 px):** dark fight-night bar with your boxer's name once on the left and the opponent's name once on the right, round `2 of 3`, 60-second corner clock, and knockdown / RSC tally (`1 of 3 round · 1 of 4 bout`). No live scorecards.
- **Left column (560 px) — `YOUR BOXER`:**
  - Body read showing the six zones as marker rings with clear band labels (`Fine / Hurt / Critical`), `Liver (right)` and `Ribs (left)` labelled unambiguously, and a `"CRACKED"` stamp on left ribs when triggered.
  - `FightMeters` energy bar and ceiling marker (showing any `−25` liver-fold ceiling drop clearly).
- **Centre column (800 px) — `CORNER MINUTE`:**
  - *Standard corner (top):* handwritten coach note (`"Left ribs took heavy shots — watch the switch"`), `RECOVER` (3 points), `SET-UP`, `TALK`, and `ONE CHANGE` (`2` picks max) with **`Right elbow in (guard liver)`** (`+20` right cover / `−10` right head guard), **`Left elbow in (guard ribs)`** (`+20` left cover / `−10` left head guard), `Gloves high`, and habit fixes.
  - *One-click Aim chip* when triggered (`"Switch Aim: Ribs (left side)"` or `"Head (left side open)"`), free of shout cost.
  - *Crack card (below a heavy divider, shown only on crack, never pre-selected, free of `ONE CHANGE` slots):* three cream cards side by side using neutral wording (`Pull your boxer out`, `Defend the side`, `Fight through`), each showing live `BoutRead` win chance, exact ring penalties, suspension/rest wait, and unified medical layoff (`35` / `42` / `56` days, `1 in 10` `+21`).
- **Right column (560 px) — `THE OPPONENT`:**
  - Opponent body read with `Liver (right)` and `Ribs (left)` bands.
  - Handwritten `CornerRead` notes (`"Left ribs hurt — left head guard −5"`, `"Switched aim to your right side"`, `"Opponent's corner talking about stopping it"`).
  - Persistent `Aim` selector (`Own game`, `Head`, `Liver (right side)`, `Ribs (left side)`, `Head (left side open)`) with numeric hover tooltips showing `1.3×` vs `0.55×` drain, fold chance, and guard drops.
- **Bottom strip (120 px):** handwritten corner summary line (no names, no fixed pronouns), `Say nothing / No fix`, and the single round-bell button.
