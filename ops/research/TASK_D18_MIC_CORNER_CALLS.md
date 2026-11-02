# TASK D18 - DOLA - MIC CORNER CALLS (research + design, no code)
Owner: Dola. Asked by the operator 2026-09-25, verbatim: "we are revolutionize we will add mic suppor tto call out the
orders to the fighter with a bit cowd noise to make realistic to pickup the call , but this should be an option in the
settings and a good selling point if implemented perfectly"

## What would a human do? (answer FIRST)
What does a real corner actually shout DURING a round (not between rounds)? Boxing, Muay Thai, MMA: the words, how
short, how often, how loud; which calls a fighter can take mid-exchange ("double the jab", "turn him", "hands up",
"go body", "sprawl", "get up") and which he ignores; how crowd noise decides whether the call is HEARD at all.

## Questions (SOURCED or NOT FOUND - never invent a number)
1. THE VOCABULARY: 30-60 real corner calls grouped by intent (pace, range, target, defence, grappling, recovery),
   with the in-game instruction each maps to. Keep calls 1-3 words.
2. RECOGNITION: offline keyword spotting vs full speech-to-text for a small command set inside a Godot 4 game on
   Windows (Vosk, whisper.cpp, Picovoice Porcupine/Rhino, Windows SAPI). Licence (commercial game!), size, CPU cost,
   latency (ms from end of word to command), accuracy in noise, languages. Recommend ONE and a fallback.
3. THE CROWD: how to make "the fighter didn't hear you" a mechanic that feels fair (loudness vs crowd level, fighter's
   composure/rocked state, distance to the corner) instead of a recognition failure the player blames on the game.
4. PRIOR ART: games that shipped voice commands (EndWar, There Came an Echo, Mass Effect 3 Kinect, Hey You Pikachu,
   Seaman, Lifeline, Phasmophobia) - what worked, what reviewers hated, opt-in settings, push-to-talk vs always-on.
5. SETTINGS: what the option screen needs (on/off, push-to-talk key, mic pick, test meter, language, sensitivity).

## Deliverable
One document: the human answer, the vocabulary table, the recognition recommendation with licence and latency, the
crowd-hearing mechanic, prior-art lessons, and the settings list. Every figure SOURCED/NOT FOUND.
