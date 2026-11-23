# Card game round 8 - the owner's play (S543, 2026-11-23): what the first screen failed to tell him

He opened http://127.0.0.1:8799/, picked the BRAZILIAN JIU-JITSU fighter, covered up against the first jab, and stopped
at his first own turn (screenshot in the session). His words, verbatim:

"i do n ot understand where to base my card choice , can you explain this screen ? whatis my opponent doing, why i have no
punch card ?  how i see my deck ?"

The screen he saw (reproduced by Claude in a second browser, same state): "You · bjj, Wind 4/5, turn 1/7", the strip
KICK / PUNCH / CLINCH / GROUND with PUNCH lit, five cards ALL GREY (Sweep "2 wind · B0 / B1", Escape "ANSWER", Triangle
"B0", Kimura "B1 / T1 / T2", Sweep), three buttons (Step in, Step out, Pull guard · 2 wind), End turn, and a fight log
with one line: "Club challenger: Jab".

## His four questions, and what the screen should have said by itself
| His question | The answer in the rules | What is wrong on the screen |
|---|---|---|
| "where to base my card choice" | Every card works only at one place of the bout. Standing at PUNCH none of the jiu-jitsu cards works; **Pull guard** (2 wind) takes the bout to the ground with the fighter underneath, and then Sweep (2 wind) is playable in the same turn (checked: wind 4 -> 2, Sweep and Escape light up, Triangle "costs 3 wind - you have 2"). | A whole hand is grey and nothing says "none of your cards works standing: Pull guard first". The one move that opens the hand looks like the two step buttons beside it. |
| (the codes on the cards) | "B0 / B1" = on the ground, underneath (Bottom), how far the top man has passed (0 = full guard); "T1 / T2" = on top. | The codes are printed raw on every card and in the grey reason ("Works at B0 / B1 range - the bout is not there now"). Never explained. Plain words needed: "on the ground, underneath". |
| "whatis my opponent doing" | His cards are shown face up only at the moment they are laid (the jab, answered with Cover up). After that the only trace is one log line at the bottom. Nothing says what he is likely to do next or what the boxer wants (to stay standing at PUNCH). | No opponent panel during the player's own turn: what he just did, what it did, what his art wants. |
| "why i have no punch card" | The jiu-jitsu deck has no strikes: 2 Sweep, 3 Guard pass, 2 Triangle, 2 Armbar, Rear choke, 2 Kimura, 2 Sprawl, Escape. It wins on the ground. | The pick screen says so in two small lines; the bout screen never repeats "your art: the ground". |
| "how i see my deck" | Only on the pick screen and the training screen ("Current deck"). Not during a bout. | No deck button in the bout: all cards, which are in hand, which are spent. |

Also seen while reproducing: while a coach note is up, the buttons behind it do not react, and the notes come one after
another ("Got it" three times before the first move). Cover up spent 1 wind without the screen saying so beforehand.

## Round 9 opens with these, before anything else (his play is the gate)
1. A hand that is all grey says what to do: one line and the opening move highlighted ("None of your cards works
   standing. Pull guard takes the bout to the ground, where they do").
2. Places in plain words on every card and reason: KICK, PUNCH, CLINCH, "ground, underneath", "ground, on top" - no B0 /
   T1 codes anywhere.
3. An opponent panel that stays: his art and what it wants, his last card and what it did, and what he can do from here.
4. A deck button during the bout: the whole deck, in hand / still to come / spent.
5. The bout screen names the player's own art and its one rule in a line under the name.
6. The coach's notes: at most one at a time, never blocking the buttons, each tied to the thing it points at.
7. Start-of-bout check for both arts: the first hand must hold at least one playable line (a card or the move that opens it).
