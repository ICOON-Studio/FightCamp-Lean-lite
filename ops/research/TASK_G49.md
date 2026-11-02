# TASK G49 — GROK — A FIGHT IS NOT A SEQUENCE OF COIN FLIPS

Tier: **Expert**. Research only — no code, no module, no test.
Owner: grok. You have no checkout and no Godot; you are never given a repo
command. Deliver as **plain chat text**, pasted into the conversation.

## Why this exists — a line of our own code

The operator's bar for this simulator: **the UFC should be able to use it to see
how fights can go.** So we have started auditing our engine against reality, and
the audits keep finding the same shape of defect — a real quantity replaced by a
constant nobody ever revisited. Today that found movement running at 2.26× a real
fighter's pace.

Here is the next one, and it is one line:

> **`FightRealtime.gd:1287` — who throws the next strike is an unweighted coin
> flip. `rng.randf() < 0.5`.**

Every single time a strike is resolved, the engine flips a fair coin to decide
which man threw it. **Not weighted by who is pressing, who has initiative, who
is fresher, who is better, or who just landed.** The consequences follow
directly:

- **There are no combinations.** A fighter throws twice in a row only by luck,
  never by intent, and never because the first one landed.
- **There are no counters.** Being hit does not make you more or less likely to
  answer.
- **There is no initiative or momentum.** A man who has taken over a round is, at
  the next strike, exactly 50% likely to be the one throwing.
- **Skill does not buy output.** A far better striker throws exactly as often as
  the man he is beating.

We are not asking you to design the fix. **We are asking what a real exchange is
made of**, so that whatever replaces the coin flip is built against evidence
rather than against somebody's intuition about boxing.

## The question

1. **What is the unit of a striking exchange?** Is it a single strike, a
   combination, or an "engagement" that opens and closes? What do fight analysts
   and fight-science researchers actually count?
2. **Combinations: the real numbers.** How many strikes are in a typical thrown
   combination in boxing and in MMA? What is the distribution — is it mostly
   singles with occasional threes, or mostly twos? **Is there a published
   distribution at all, or only coaching lore?**
3. **Who throws next — the real conditional.** Given fighter A just threw, what
   is the probability the next strike in the fight is also A's? This is exactly
   the number our coin flip fixes at 0.5. **If it is published anywhere, that is
   the single most valuable number you can return.** If it is not, say NOT
   PUBLISHED and give the closest evidence.
4. **Counters and the answer.** After a fighter is hit cleanly, what happens
   next — does he answer immediately, cover, or reset? Is the immediate counter a
   real and common event or a highlight-reel rarity? Numbers if they exist.
5. **What drives output?** Real strike rates vary enormously between fighters and
   within a fight. What do the sources attribute that to — style, fatigue,
   score, the opponent's pressure, the round? **We already model attributes,
   fatigue, damage, range and position**, so the useful answer is which of those
   the literature says actually drives volume.
6. **Initiative and momentum — is it real or a narrator's illusion?** Do fight
   statistics show genuine streakiness in who is landing, beyond what randomness
   would produce? **Be sceptical here and say so if the honest answer is that
   momentum is mostly a story told after the fact** — that refusal would be as
   valuable to us as a confirmation, because it would mean the coin flip is less
   wrong than it looks.
7. **What does a fight look like when this is modelled badly?** If you can find
   sources on fight simulations or analytics models that got exchange structure
   wrong, what were the symptoms?

## Standards

- Cite sources: fight-science papers, combat-sports analytics, CompuBox and UFC
  Stats methodology, coaching literature clearly marked as such, GDC talks on
  fighting-game AI.
- **Separate MEASURED from NOT PUBLISHED**, exactly as your last two studies did.
  That discipline is why they are being spent against. A fabricated "62% of
  strikes come in combinations" would be turned into engine code within a day.
- Distinguish **boxing from MMA** wherever the answer differs — our engine runs
  both off one core.
- Research only. No GDScript, no implementation, no proposed formula.
- Do not reopen the metres, the IK bound, or the no-reach-variants decision.

## Deliverable

Plain chat text. Lead with a short table of the numbers you found, then the
prose. Close with a section headed **VERDICT** answering in one line each:
*(a) is an unweighted coin flip for "who throws next" a material defect or a
tolerable simplification*, and *(b) what is the single highest-value quantity to
condition it on*.

Verify the tier chip reads **Expert** before you submit.
