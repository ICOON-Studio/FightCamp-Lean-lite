# G90 - OFFICIALS AS PEOPLE, AND COACHES RANKED (Research, no code) - FightCamp, 2026-09-24

FightCamp is a combat-sports gym management game (Godot). You can read the repo through your GitHub connector (this brief
is research/G90_BRIEF.md). The operator asked: "should we implement referees and judges as personalities with their
own stats? add coaches leaderboards?"

WHAT ALREADY EXISTS: `Godot/scripts/JudgePanel.gd` seats N judges per bout, each with a small ANONYMOUS multiplier on the
secondary scoring criteria only, drawn fresh per bout (damage and knockdowns never perturbed - J1 section 3.2). Research
already on file: `research/J1_ORGANIZATION_RULES_AND_JUDGES.md`, `M5_SCORECARD_THREE_JUDGES.md`,
`J14_THE_REFEREE.md` (its ruling: most referee material is scenery; engine-worthy facts are the count, announced
deductions, the stoppage reason - "not a ref AI"), `G35_REFEREE_AND_METHODS.md`. Coaches exist as staff with
technical_teaching / tactical_rating / youth_development / capacity, and rival gyms seed one coach each.

## The questions
1. JUDGES AS PEOPLE - MEASURED. Do individual judges have stable, measurable tendencies? Per-judge records and dissent
   rates (MMADecisions.com judge pages, BoxRec official records, CompuBox vs card studies, academic work on judge bias:
   home-country bias in Olympic boxing, the 2016 Rio scandal, AIBA/IBA judge evaluation, "damage vs volume" preferences in
   MMA, 10-8 frequency by judge). How large is the between-judge spread compared with the within-judge noise? Do
   commissions assign judges by grade / experience? Is there a public "judge rating"?
2. REFEREES AS PEOPLE - MEASURED. Per-referee stoppage timing (early/late), foul strictness (warnings, deductions),
   stand-up speed in MMA, standing-count habits in amateur boxing; any counted dataset (e.g. referee stoppage stats per
   ref in UFC Stats scrapes, MMA referee analytics). Famous controversies and what they changed. If only anecdote exists,
   say NOT FOUND.
3. COACHES RANKED. How the real world ranks trainers: BWAA Trainer of the Year, Ring Magazine, MMA Junkie/World MMA Awards
   Coach of the Year, fighters-trained records, title-winning pupils, gym rankings (e.g. MMA gym rankings by active
   ranked fighters, Tapology). What metric actually gets used, and what does it reward?
4. HOW GAMES DO IT: Football Manager referees (named officials with leniency / card tendencies), sports sims with judges,
   manager leaderboards (FM Manager of the Year, reputation tables), any fight game with named officials.
5. PROPOSE FOR FIGHTCAMP: which official traits are evidenced enough to model (with the band and its source), which must
   stay invented or out, how a player would SEE and USE them (scouting a panel, choosing a fight style for a volume judge),
   and a coach leaderboard's metric. Rank by evidence strength, and name what would be unfair or unreal (e.g. a judge who
   robs you as pure RNG).

## Deliverable
ONE markdown document titled "G90 - OFFICIALS AS PEOPLE, AND COACHES RANKED", sources inline, ending with one line saying
what is still unknown. PASTE THE WHOLE DOCUMENT IN THE CHAT as your reply (the operator cannot open files in your sandbox).
