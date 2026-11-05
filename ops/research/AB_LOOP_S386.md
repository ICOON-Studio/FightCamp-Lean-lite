# Blind A/B quality loop (S386, operator: "a really harsh critic ... compare them side by side blind ... dont stop until
# each sub-agent is utterly wowed"; references "ufc6 and esbc reborn", "undisputed too"; "if you can have a more
# effective agent, use it too")

Tool: ops/Tools/blind_ab.py (random A/B sides, key kept apart; judges gemini | ollama; AB_OLLAMA_URL for the :11435 server).
Strong judge: a Claude sub-agent given ONLY neutral-folder contact sheets (8 fps, 2x5 tiles) and the harsh prompt.
References (outside the repo, never shipped): E:/FightCamp/tmp/s386/refs - ufc6_gxZTYdqDFkE (300-310 s), undisputed_G54PViaTZys
(120-130 s), esbc_revival_ts3Z7huWsWI (120-130 s). Gemini: prepay 402 (operator's money). Ollama: the app's server lost
E:/ollama/models; a second hidden `ollama serve` on 127.0.0.1:11435 with OLLAMA_MODELS=E:\ollama\models.

| round | ours | ref | judge | ours | ref | top flaws named |
|---|---|---|---|---|---|---|
| 0 | r4 career clip 154-160 s | Undisputed | ollama gemma4 | 1 | 3 | head in chest 1.9 s, arm through own torso 2.3 s, no reaction 4.3 s |
| 0 | same | Undisputed | Claude blind critic | 2 | 8 | (1) lunge pops in/out in 1/8 s (2) bodies merge close in (3) dead idle + receiver never reacts |
| 1 | r4 ropes film 13-19 s (HitSnap carry, punch->punch reach fade, BodyKeep) | Undisputed | Claude blind critic | 3 | 7 | (1) bodies through bodies on the body-shot lunge (head at hip) (2) frozen earmuff guard at mid range ~2.4 s (3) snapped jab recovery + teleport lunge mid->contact in 0.25 s |
| 1 | same | UFC 6 | Claude blind critic | 2 | 8 | (1) bodies through bodies close in (2) frozen mannequins, no knee bend (3) no weight: no recoil, no reactions, range closed by sliding |
| 2 | r6 ropes film 13-19 s (+ lunge stops at head need, head-trunk 0.27, live sway) | Undisputed | Claude blind critic | 3 | 7 | (1) bodies through bodies 16.4-17.2 s: head in abdomen, arm through torso, heads fused 1.5 s - drawn TRUNK bar PASSES here = the bar is blind (spheres too small, arms not checked) (2) frozen guard ~2 s, no punch thrown (sim pacing too) (3) no hit reactions in the pocket |
| 2 | same | UFC 6 | Claude blind critic | 2 | 8 | same three; plus snaps: jab recovery 1 tile, red's deep bend 1 tile, arms overhead 1 tile |

## Next round (3) - order
1. Make the bars see what the critic sees: capsule bodies (head 0.12, chest 0.17, belly 0.15, hips 0.16, upper/fore arms 0.05) and
   count ANY overlap > 0.02 m, incl. arm-through-torso; re-run on r6 film's frames - must FAIL at 16.4-17.2 before fixing.
2. Then the close-range rule the critics ask for: below a gap the pair either ties up (real clinch hold) or breaks (push-off);
   never stands mashed (sim: inside beats with no punches = clinch or step out).
3. Hit reactions in the pocket (HitSnap on every landed punch at inside range); jab recovery over >= 3 frames.
4. The frozen stretch: an exchange with no punches gets feints / steps (sim pacing) - check Exchanges for empty beats.
