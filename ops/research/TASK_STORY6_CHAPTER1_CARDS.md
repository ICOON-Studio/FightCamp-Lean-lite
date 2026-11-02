# TASK STORY6 - write the Chapter 1 cards ("Keys") for FightCamp (Dola and John, one draft each)

Model: any. Deliverable: ONE JSON file in one code block, `story_cards_ch1.json`, plus 5 lines of notes. Writing only - no code, no repo commands.

## Prior research
searched: story campaign narrative. Design of record = the plan pasted below (the repo is private; this brief is self-contained).

## What would a human do?
A game writer for a short-form management sim: every card is read in 3 seconds between weeks. Voice of a tired, warm, funny gym.
Concrete nouns (tape, ledger, rent, a bag), no speeches.

## Prefab check
Structure only (inheritance, a mentor's secret, a promotion with a clause). No text or names from other works.

## The story (Chapter 1 "Keys", boxing, fictional)
You were the cutman and bookkeeper of **Anvil Street Boxing Club** for nine years and never boxed. Founder **Dessa Marlowe** (71) has a stroke in
week 1 and leaves you the keys. Head coach **Hollis "Holl" Dagget** (58, memory slipping, repeats three cues: "jab, jab, jab"). First fighter
**Kit Alvarado** (19, fast, impatient, mother's rent is late; his women's-division twin is **Dee Okafor**, 19, hides a glass chin with jokes).
Reporter **Naomi Brandt** writes the column Crown quotes. The promotion **Crown Ring Promotions** (owner **Victor Lasko**) is polite, pays on time,
and quietly holds the gym's loan and a right-of-first-refusal clause (Dessa's secret; NOT revealed in Chapter 1 - only hinted). Rival fighter
**Joaquin "Jax" Mireles** (21, Crown-contracted) calls Kit out at the END of Chapter 1.
Tone: warm in the gym, cold in the office, honest in the ring. Never script a fight result: the fight is simulated; cards set stakes only.

## The cards (write exactly these 12; each id fixed)
1. `welcome` - game start: Dessa's call from the hospital, the keys, the bill list. 1 choice-less card, button "Open the gym".
2. `style` - Kit's first training focus. 3 choices: pressure / boxer / counter.
3. `bills` - first week review: rent due in 4 weeks, the lender's letter (name it "Teague Capital", do not say it is Crown's). 1 button.
4. `book_him` - Holl: "He can fight. Book him." Choices: cheap local show in 3 weeks / better card in 6 weeks.
5. `fight_week` - camp done, weigh-in tomorrow. 1 button. (Dee version: same text, she/her.)
6. `result_win` - after a win (the cards fire on the result; never imply the result before it). Naomi's write-up line. 1 button.
7. `result_loss` - after a loss. Same slot, honest and kind. 1 button.
8. `hire_holl` - choice: hire Holl full time (wages on the weekly bill) / keep the cash.
9. `wall` - the first framed clipping goes on the Wall. 1 button.
10. `rent_close` - optional card if the bank is below the rent with 1 week left. Choices: pay late fee / hold off.
11. `chapter_end` - "Chapter 1 ends: Keys". Hook line: "Jax is calling." 1 button "Continue to Chapter 2" (Chapter 2 is not in the demo: this button
    shows a "Coming next" screen).
12. `welcome_dee` - the Dee variant of card 1 (same facts, she/her, one line of her humour).

## JSON schema (use exactly)
```json
{"cards":[{"id":"welcome","title":"<=4 words","body":"<=3 short lines, each <=70 chars","speaker":"Dessa","choices":[{"label":"<=3 words","tip":"<=8 words tooltip","effect":"one plain-words consequence on a real system: money / morale / coach pay / hype / stamina"}],"default":"label that fires after 7 days"}]}
```
Rules: body max 3 lines; labels max 3 words; every choice names its real consequence; the facility is a "gym" (never "camp" except
"fight camp" = pre-bout prep); no real people or brands; no slurs; keep it PG-13.

## Notes (5 lines)
Which card is your strongest, which line you would cut first, and one idea for Chapter 2's first card.
