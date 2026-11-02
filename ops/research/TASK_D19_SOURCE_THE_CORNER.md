# TASK D19 - DOLA - SOURCE THE CORNER NUMBERS (research only, no code)
Owner: Dola. Assigned S75, 2026-09-25. Follows your D18 (research/D18_MIC_CORNER_CALLS.md), which we collected.

## Why
D18 is the design for the operator's mic corner calls. Several of its numbers will drive the "did the fighter hear
you" mechanic, but they carry no source: "short practiced cues land ~60% of the time; multi-word instructions drop to
<20%", "3-8 calls per minute", "at 90+ dB speech intelligibility drops below 40%", "Vosk 200-400 ms latency, Rhino
80-150 ms", "Rhino ~$200/app past the free tier". A game built on an invented number is built on nothing.

## What would a human do? (answer FIRST)
An audio engineer or sports scientist would look up (a) measured arena crowd levels at boxing/MMA events, (b) speech
intelligibility vs signal-to-noise ratio (the standard curves, e.g. ANSI S3.5 SII / STI), (c) the vendor's own
published benchmark and price page, and (d) any study of coach-to-athlete verbal cues under noise or stress. Do that.

## Questions (SOURCED with a link, or NOT FOUND - never invent a number)
1. Measured crowd noise at combat-sport events (dBA at ringside / corner distance), and at a small club show.
2. Speech intelligibility vs SNR: what % of short words are understood at -5, 0, +5, +10 dB SNR; how a shouted voice
   (dB at 1 m) compares with that crowd level at 1-3 m (corner to fighter).
3. Coach cues under stress: any study measuring how many instructions an athlete takes mid-play, how short they must be.
4. Vosk small English model: published latency, WER in noise, model size, licence text for commercial use; the same for
   Picovoice Rhino (current price page) and whisper.cpp tiny. Is there a maintained Vosk GDExtension/Godot 4 binding?
5. Correct or confirm every figure in D18's tables; mark each one SOURCED / NOT FOUND / CORRECTED.

## Deliverable
One document: the human answer, a table of every D18 figure with its verdict and link, the crowd-vs-voice curve a game
can use (SNR -> P(heard)), and the Godot 4 integration route for Vosk (binding name, maintenance state, licence).
