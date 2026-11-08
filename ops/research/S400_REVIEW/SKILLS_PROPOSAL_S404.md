# Skills: agreed in plain words (S404, 2026-11-08)

AGREED, 12 skills. Operator, 2026-11-08: "Ok 12".

Skills are how good a fighter is at one sport. The primary attributes (the agreed 10) and the moves in the Playbook are separate layers.

Three fresh critics who had read the whole game judged the 17-skill draft on their own: a fight coach 5/10, a sim designer 4/10, a veteran player 4.5/10.
All three said the same thing first: 17 bars is too many, and the profile mockup already hides 10 of them in a paragraph. Their limit: 5 to 7 bars per sport can be read at a glance.
Their reports: SKILLS_CRITIC_S404_coach.md, _designer.md, _player.md in this folder.

## The proposal: 12 skills, at most 6 on a page for one sport
| Sport | Skills | Count |
|---|---|---|
| Boxing | Accuracy, Timing, Defence, Footwork, Inside fighting | 5 |
| Kickboxing | The boxing five + Clinch | 6 |
| Muay Thai | The boxing five + Clinch | 6 |
| No-gi BJJ | Takedowns, Guard, Top game, Submissions, Escapes | 5 |
| MMA | Three groups: Striking (the boxing five); Standing grappling (Clinch, Takedowns, Takedown defence); Ground (Guard, Top game, Submissions, Escapes) | 12 |

## Every change, one by one
| # | Change | Coach | Designer | Player | My call |
|---|---|---|---|---|---|
| 1 | Passing + Control become one skill, Top game | Yes | Yes | Yes | Yes |
| 2 | Submission defence goes into Escapes | Yes | Folds it, but into Submissions | Yes | Yes |
| 3 | Blocking + Head movement become one skill, Defence | No, keep two | Yes | Yes | Yes. They are the same training decision for the player |
| 4 | Kick defence leaves the list | Keep it | Into Defence | Into Playbook moves | Into Defence: a check or a catch is a move, and a boxer never needs the bar |
| 5 | Scrambling is cut | Doubtful | Keep | Cut | Cut: it is mostly Explosiveness, Speed and Fight IQ |
| 6 | Accuracy stays | Merge into Timing | Keep | Keep | Keep: it is today's Technique, so the fight already uses it |
| 7 | Clinch stays, for kickboxing, Muay Thai and MMA | Keep | Merge into Inside | Keep | Keep. In boxing, Inside fighting covers it |
| 8 | Takedowns and Takedown defence stay two skills | Keep two | One, called Wrestling | Keep two | Keep two: great sprawlers are not great shooters. BJJ shows only Takedowns |
| 9 | Escapes stays a skill | Keep | Into Playbook moves | Keep | Keep |

Nothing was added: no critic asked for a new one that all the others wanted.

## What has to be true for these to work (from the critics, checked against the code where marked)
- Footwork is worked out today from Speed and Defence (scripts/rules/RoundStyle.gd, checked). It must become its own trained number, or it counts Speed twice.
- Timing can overlap Fight IQ. All three flagged this. If the fight cannot tell them apart, Timing merges into Fight IQ and boxing has 4 skills.
- A bar named after a technique is a move; a bar named after an area of the sport is a skill.
- The perks (Iron chin, Counter sense, Ring general and others) must be re-pointed at the new numbers.

## Not settled by this page
- How much of a skill carries between sports. The critics' numbers are guesses (striking to striking 55-90%, grappling to MMA ground 65-100%, striking to grappling about 0), and John's real-world answer (SQ29) is still queued.
- Kickboxing, Muay Thai and MMA have no fight engine yet, so those rows are the plan and nothing more.

## What it costs
Boxing is the cheap part: Technique becomes Accuracy, Defence stays, Footwork gets stored, and Timing and Inside fighting need real effects in the fight. BJJ skills would be one more term in the existing fight weights. Agreed; the fighter model is re-briefed for the 10 attributes and these skills (ops/research/TASK_FIGHTERMODEL4A.md). Nothing is built yet.
