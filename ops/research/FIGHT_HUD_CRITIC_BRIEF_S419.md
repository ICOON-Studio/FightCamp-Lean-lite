# Critic brief: the fight's live display, approach B with A's best parts (S419)

The operator, on three drawn approaches: "i like b too , also a is not bad but i want it carefully designed what it will show and how , hint things to player by him looking numbers graphics visual effects etc". Before that, on the display the game has today: "this looks like low-tier ai ... during the fight some real time stats needs to be shown"; on a bar captioned "LUCY JACKSON AHEAD": "wtf is that"; on body tags "head 4", "liver 1": "wtf is that ... do we only have 2 hit points on the whole body ?"; on "POWER 18/46": "i do not understand what power 19/52 means".

## Read first, in this order
1. `ops/research/CRITIC_PACK.md` (the whole game) and `ops/research/CRITIC_ACCESS.md`. Read the fight, corner, damage, injury, scouting and plan sections closely: you must know what the player can DO during a round (one corner call every 30 seconds), between rounds (the corner minute) and before the fight (the plan, the camp, the film on the opponent), because a display is only worth what the player can do with it.
2. `ops/research/FIGHT_HUD_BRIEF_S419.md`: the list of what the fight really has, live.
3. The screen under review: `docs/mockups/s419/fight_b.png` (the corner's eyes). The other two for parts worth taking: `docs/mockups/s419/fight_a.png` (the telecast: its scorebug and its punch tug bars), `docs/mockups/s419/fight_c.png`.

Do NOT read scripts/ or any still of the fight as it is in the game today, and do not read the other critics' files.

## Your review
1. THE LOOK FIRST, 0 to 10, with hard fails that cap it at 4: type under 22 px; a bare number with no icon or word; a meter whose meaning needs a manual; a list where a picture should be; more than 45% of the screen covered.
2. WHAT IT SHOWS, element by element (each of the six damage places and its number, the face close-up, the cut and the closing eye, the three tanks and their band ticks, the drain arrow, the punch counts, the exchange blocks, the clock, the fight bar, the plan chip, the scouted habit chip, the unknowns on the opponent, the corner's call with its three effect chips, the two other calls, the timer ring, the big-shot burst). For each: KEEP, CHANGE (how), CUT; and the one thing the player learns or does from it.
3. THE HINTS. This is the heart of the review. The operator wants the display to hint things to the player through numbers, graphics and visual effects, so that a player who watches learns boxing and learns the fight. List at least ten hints, each as: WHAT IS TRUE in the fight (for example: the opponent's guard drops when tired; the liver side has taken three shots; the last call is not working; an eye is closing and the next clean shot may bring the doctor; the opponent always answers the jab with a right hand) / HOW THE SCREEN SHOWS IT without a sentence (which element, which colour, which motion, which sound, for how long) / WHAT THE PLAYER DOES about it (which call, which plan change in the corner, which training next week). Rank them by how much they would change a player's decisions. Say which are honest only when scouted, and how an unscouted one looks.
4. WHAT IS MISSING and WHAT IS USELESS, each with where it goes.
5. THE MOMENTS: how the display changes for a knockdown and the count, a cut, a hurt (rocked) boxer, the last 10 seconds of a round, the corner minute opening. One line each.
6. Scores 0 to 10: look, read in two seconds, depth for the player who looks longer, how well it teaches.
7. HOW TO REACH 10/10: the concrete list, most important first, specific enough to build.
8. DRAW YOUR 10/10 at the path in your prompt: 1920x1080 HTML, self-contained CSS, the ring drawn simply behind, at least 55% of the picture clear, nothing under 22 px, at most 45 words not counting names and numbers. Show at least three of your hints in action in the drawing (a pulse, a ring, a ghost bar, a flash: draw the frozen frame and mark it). Render with `python tools/render_mockup.py <your html>` from the repo root, open the PNG with your file tool, fix what is cut or overlapping, render again.

## Rules
Never "he" or "she" for a boxer. Nothing opens on a monitor: file tools only. Write only your own two files in `docs/mockups/s419/`.

## Hand back, in at most 450 words
Your four scores; the five most important hints (true / shown / done), one line each; the five changes that matter most; what to cut; the PNG path. Put the full review (everything above) in a text file beside your drawing: `<your drawing's name>.md`.
