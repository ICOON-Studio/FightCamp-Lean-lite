# Progressive knowledge: you find out what you have (S411, v2, 2026-11-09)

Owner: "these should be unlocked progressively or why we have scouting then ? what do you think ?", then "Yes, design it". v1 scored 5/10 (designer, three hard fails) and 6.5/10 (player): reviews in S411_GYM_CRITICS/knowledge_designer.md and knowledge_player.md; their pictures in docs/mockups/s411/knowledge. v2 takes their fixes and has not been re-scored. Numbers are starting game values (G). John has the real-world question (SQ30). Waits for the fighter model.

## The one idea
What is true about a boxer never changes because you looked. What changes is how much you can see, and **you choose what to find out and pay for it**: in money, in risk, or in a session you could have used for something else.

**The range never lies.** The true number is always inside it. The bout always reads the truth, so the fight's balance does not move.

## One system, one word: Scouting
Today's scouting (opponent tells) and knowing your own boxer become the same thing: **reads**. A read is something you do to find something out, about anyone.
| Read | About | Costs | Finds |
|---|---|---|---|
| Scout (the existing button) | An opponent, **or a prospect** | $250 (G) | Opponent: a tell. Prospect: one group sharpened |
| Trial | A prospect | Four weeks' stipend on a trial contract (G) | They train with you; walk away at the end with no roster penalty |
| Test day | Your boxer | A morning session, a small fee (G) | Body group sharpened at once |
| Spar them harder | Your boxer | Named injury and fatigue risk, shown before you agree | Under-fire group sharpens up to half way |
| A real bout | Your boxer | The bout | The only way to finish the under-fire group |

## What you can see
| Group (one fading bar each; open it for the rows) | Day one | Sharpens by |
|---|---|---|
| **Body**: strength, explosiveness, speed, stamina, recovery, flexibility, and fatigue | Rough, fatigue in three colours | Sessions, Test day; strength coach and physio |
| **Skills**: accuracy, timing, defence, footwork, inside, fight IQ | Wider | Pads and sparring; second coach |
| **Under fire**: durability, composure, heart | Unknown | Hard rounds and bouts; sparring only half way |
| **Potential** | Coach's guess in words | Months, age; never exact, except the Amateur coach's edge as now |
| Traits and habits | One first impression | Each appears when it happens |
| Your building, weight, height, stance, a visible injury | Exact | Always |

Sharpening counts **exposure, not weeks** (sessions, hard rounds), so the first bout at about week 4 teaches a lot.

Cut (owner, on Coach's eye: "what do you mena watches it ? for what ? isnt that to o much work for nothing ?"): a weekly pick of what the coach watches. Skills sharpen through the training you already planned.

## Hype: why a read can be wrong
A prospect's shown centre leans high by their **hype**, shown as a tag: "Hyped". The rest of the offset is small. A flop is then a read you could have made and did not, never a rigged roll. Every wide range carries the coach's lean in words: "I think she can take a shot."

## Knowledge goes stale
A knockout, a long layoff, ageing or a big step up widens the under-fire group again. A chin that held at club level has not been tested at regional. So year three still has things to find.

## The moment you find out
Not a Monday line. **The game stops at the spar or round where it happened**: the old range ghosted beside the new one, one sentence, and one button to act on it ("Rebuild his defence", "Book the step up"). The Monday report carries at most three unknowns per boxer.

## Hires are instruments
| You pay for | You can see |
|---|---|
| Strength coach | Strength, explosiveness, stamina exact; exact fatigue |
| Physio | Recovery, flexibility, speed; the injury meter over each boxer |
| Second coach | Skills sharpen faster |
| Cutman | Cut risk, named |
| Head coach edge | Amateur coach: exact potential. Ex-pro: one tell. Old hand: habits appear sooner (G) |

## Rules that keep it fair
1. Never blank for anything the week's plan needs.
2. A goal's own attribute counts as measured: setting a goal is one more way of finding out. Taken as a deliberate choice; the designer read it as a leak.
3. **Win chance comes from what you know**, not the truth, so a bout can surprise you. It widens with what you do not know.
4. Old saves and boxers already at the club start fully seen.

## Earlier decisions it touches
- Signing card (S354): stars become a range, two traits and a habit become one first impression. **Change.**
- "Scouting means opponents" (CRITIC_PACK): now also prospects. **Change.**
- Attribute board and potential ticks: three bars first, rows on opening. **Change.**
- The trial contract is new: **needs care** with roster places and money.
- Weekly gain lines, goals clearable about 70%, the world's rivals: no change.

## First, prove it
Before any screen: bots on the real rules, signing from prospects, same seeds. A reading bot against a blind bot, and a bad-signing arm. Bar: the reading bot's boxers reach the top 10 at least 5 more times per 60 worlds, after what it paid for reads. If it misses, the reads are decoration and the design changes.

## Build order, after the fighter model
1. `Knowledge.gd`, pure, with the truth-inside test. 2. The bots test: stop here if it fails. 3. Reads and exposure wired into training, bouts and the Week board. 4. The moment. 5. Fighter page, signing card and floor bars. 6. Hires as instruments.

## Proved (S463, build step 2 done)
KNOWBOTS3 (docs/KNOWBOTS3_RESULT.md, Qwen, rerun by Claude on the same seeds, identical): 60 worlds, 4 years, prospects drawn
at random, the truth = each boxer's real attribute levels. A perfect scout (ORACLE) lands 14 more top-10 boxers than a blind
signer, so the test can see scouting; a bad signer lands the fewest (control holds). The READER, who pays the read prices
above, lands 6 more top-10s than the blind signer after paying (bar: 5), closing 43% of the gap to perfect; with wider
day-one ranges, +8. It paid about $10,000 a world over four years for that. Next: build step 3 (reads and exposure wired
into training, bouts and the week) once two critics score this map 6+ on depth and on general design (S459 loop).
