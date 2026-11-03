# TASK K-WORLDNEWS1 - KALLI - the boxing world's news lines (lean restart, week 3)
Kind: research

Model: Kalli (Grok bot, game design). Discipline: boxing (demo). Content only: no code, no repo.

## The game
FightCamp: the player runs a small London boxing gym (default name Anvil Street Gym) and develops one amateur woman
lightweight, Lucy Jackson. Week 3 makes the WORLD tab live: a news feed, regional rankings (women's lightweight amateur,
London region) and club shows. Rival amateurs (fictional) fight each other on club-show Saturdays; their results move
the rankings. Thanks for the fight-night lines last time - they are in the game.

## What I need
Short news lines (each under 110 characters, plain past tense, like a local boxing newsletter, no real people) as JSON:
{
  "rival_win":   [8 lines],   // a rival beat another rival on points at a club show
  "rival_stop":  [6 lines],   // a rival stopped another rival (referee stopped it)
  "show":        [6 lines],   // a club show announced / took place
  "ranking_in":  [4 lines],   // our fighter enters the regional rankings
  "ranking_up":  [4 lines],   // our fighter moves up the rankings
  "gym_life":    [8 lines],   // small things about our gym (new members, a sparring night, the kit, the neighbourhood)
  "why_join":    [8 lines]    // one short reason a member gives for joining our gym (shown on the Members tab)
}
Placeholders you may use: {winner}, {loser}, {winner_club}, {loser_club}, {show} (e.g. "York Hall club show"),
{gym} (our gym), {her} (our fighter's full name), {rank} (a number), {members} (a number), {city} (London).

## Prior research
searched: boxing news lines world feed (none). Kalli's K-FIGHTWORDS1 bank (research/K_FIGHTWORDS1_KALLI.md) sets the tone.

## What would a human do?
A club secretary's newsletter: names, clubs, one fact per line, warm but plain.

## Prefab check
Original text for this game.

Reply with the JSON only.
