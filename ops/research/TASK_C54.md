# TASK C54 — CODEX — WHAT A FEDERATION COSTS THE PLAYER

Model: gpt-5.6-luna, effort **high**, Fast off. One session, after C53.

**Agent:** codex · **Model:** gpt-5.6-luna, effort **high**, Fast **off** ·
**Opened:** 2026-09-08 · **C53 has LANDED (`09580c7`): start immediately.**

**Research only. Two markdown files. No script, no scene, no data, no test.**

## The hole

J2 settled that on a federation pathway money flows UP (the athlete or their
club pays to enter) and prize flows DOWN through a national body, and the code
took that literally:

* `EntityPathway.pays_purse()` (`Godot/scripts/EntityPathway.gd:183-190`)
  returns **false** for `national_selection` unless the organization is one of
  the `INTERNATIONAL_FEDERATIONS` (`:62`).
* `is_amateur()` (`:196`) makes the whole pathway amateur — the header comment
  at `:194` says a purse "would END the career being modelled".
* `entry_fee_cents()` (`:214-219`) is present and honest, but
  `GameState.gd:10266` charges it **only when `amateur_circuit` is true**.

**So a player whose fighter is on the Olympic pathway funds a career that
generates no income, and nobody has ever priced that against the gym's
ledger.** The gym pays wages, facilities and camps every week (C27's ledger)
against zero fight revenue from that athlete. Either the pathway is a money
pit no player would choose, or there is real-world funding the game has never
modelled — stipends, national-body grants, club support, sponsorship,
employment programmes, prize money at specific events.

## The 8 questions

Answer each with sourced evidence and an inline link, or write **UNKNOWN**.
The UNKNOWN answers are as valuable as the sourced ones — do not invent a
number, a rate, or a programme that you cannot cite.

**A. The money in.**
1. What does an athlete on a national/international federation pathway
   actually receive, and from whom? Name the mechanisms (athlete stipend,
   national federation grant, national olympic committee support, military /
   police / employment sport programmes, club salary, private sponsorship,
   event prize money) and say for which of the six R70 `event` disciplines
   each is documented.
2. Which international federations pay prize money at their own world-level
   events, and is any figure published? (UWW, IJF, WT, IBJJF, IWUF, FIAS.)
   A published figure is a number; an unpublished one is UNKNOWN, not an
   estimate.
3. Is any of this paid to the ATHLETE, to the CLUB, or to the NATIONAL
   FEDERATION? The game's ledger has to know which pocket it lands in.

**B. The money out.**
4. What does an athlete or club actually pay: entry fees, licence /
   membership fees, national ranking-event fees, travel, seconds. Which are
   published, and which are UNKNOWN?
5. Does the fee scale with anything the game already holds (grade, age
   division, event level), or is it flat?

**C. The game's decision.**
6. Given A and B, is the federation pathway a NET COST, a NET INCOME, or
   genuinely both depending on level? State it as a range with the evidence,
   and say plainly where the evidence runs out.
7. **What should the gym ledger see?** Price the options against C27's
   existing ledger categories — (i) leave it a pure cost and let the player
   feel it, (ii) model a stipend as recurring income, (iii) model the national
   body as a payer entity, (iv) treat the pathway as prestige-only with no
   money at all. Give each a cost in engineering terms and name which existing
   seam it lands on. **Recommend one.**
8. Does anything here contradict J2's "no purse, ever" ruling at
   `EntityPathway.gd:23`? If a sourced stipend is not a purse, say exactly
   what distinguishes them so the code can keep both.

## Owned files

Create only:

* `research/C54_WHAT_A_FEDERATION_COSTS.md` — the evidence record, one
  section per question, every claim carrying its link or the word UNKNOWN.
* `research/C54_DIGEST.md` — short: the decisions, the recommendation
  from question 7, and an explicit non-decisions list.

Do NOT edit `HANDOFF.md`, any `.gd`, any `.json`, or any test.

## The trap

C47 and C49 both proved this: a promotion's published figure is usually a
press release about ONE athlete at ONE event, not a rate. **Never generalise a
single reported payment into a scale.** If UWW published one world
championship prize table, that is the prize table for that event and nothing
else — say so in those words. The recommendation in question 7 must survive
the case where questions 1-5 come back mostly UNKNOWN, so write it to depend
on the shape of the answer, not on a number.
