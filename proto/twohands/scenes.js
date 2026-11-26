/* FAMOUS EXCHANGES, PLAYED WITH OUR SWITCHES (S567, owner: "find few clips of famous fights breakdowns and try to breakdown
   their actions with our game switches and play it like the real clip next to the one with our player, see how it feels
   and if it can help with balance"). One file, read by scene.html (the page) and tools/scene_check.mjs (the rules, in node).
   Each scene: who is blue (the player's side) and red, the range and health it starts at, and the beats - each man's
   switches as play_cli names them. `real` = what happened in the ring; `want` = what our rules must say for the beat to
   match it (checked by scene_check.mjs). The real footage is NOT in the repo: `watch` is a search phrase, for his eyes only.
   SOURCE: written from the well-known descriptions of each exchange, NOT yet checked against the film frame by frame. */
const RS_SCENES = [
  { id: 'counter_right', title: 'The counter right as he steps in', bout: 'Marquez v Pacquiao IV, 2012, round 6, the last second', blue: 'Marquez', red: 'Pacquiao', watch: 'Marquez Pacquiao 4 knockout round 6',
    lesson: 'A man who steps in behind his jab walks onto a rear hand that was waiting for him.', range: 3, hp: [9, 7], st: [6, 6],
    beats: [
      { real: 'Pacquiao feints and jabs from range; Marquez gives ground and blocks.', blue: { lead: 'high', rear: 'high', feet: 'back' }, red: { lead: 'jab', rear: 'high', feet: 'hold' }, want: { redHit: false } },
      { real: 'Pacquiao steps in behind a jab. Marquez plants his feet and throws the right hand over it: Pacquiao is out.', blue: { lead: 'low', rear: 'over', feet: 'hold', order: 'rear' }, red: { lead: 'jab', rear: 'high', feet: 'in', order: 'feet,lead' }, want: { blueHit: 'over', redDown: true } } ] },
  { id: 'rope_a_dope', title: 'Covering on the ropes until he is spent', bout: 'Ali v Foreman, 1974, round 8', blue: 'Ali', red: 'Foreman', watch: 'Ali Foreman round 8 knockout rope a dope',
    lesson: 'Punches thrown into a guard cost the puncher his stamina; the man who covered has his left for the finish.', range: 1, hp: [10, 8], st: [6, 6], ropes: [2, 0],
    beats: [
      { real: 'Ali on the ropes, gloves high. Foreman swings a hook and a body shot into the guard.', blue: { lead: 'low', rear: 'high', feet: 'hold' }, red: { lead: 'lbody', rear: 'over', feet: 'hold', order: 'rear,lead' }, want: { redHit: false } },
      { real: 'Foreman, arm-weary, pushes a slow right. Ali covers again.', blue: { lead: 'high', rear: 'high', feet: 'hold' }, red: { lead: 'high', rear: 'cross', feet: 'hold' }, want: { redHit: false, redTired: true } },
      { real: 'Ali comes off the ropes: a right hand, a left hook, a right hand. Foreman goes down.', blue: { lead: 'hook', rear: 'cross', feet: 'hold', order: 'rear,lead' }, red: { lead: 'high', rear: 'high', feet: 'hold' }, want: { blueHit: 'any', redDown: true } } ] },
  { id: 'feint_overhand', title: 'The jab to the body that hides the right hand', bout: 'Hearns v Duran, 1984, round 2', blue: 'Hearns', red: 'Duran', watch: 'Hearns Duran knockout round 2',
    lesson: 'A feint low draws the guard down; the right hand goes over the top.', range: 2, hp: [16, 4], st: [7, 5],
    beats: [
      { real: 'Hearns jabs to the body; Duran drops his lead hand to stop it.', blue: { lead: 'bjab', rear: 'high', feet: 'hold' }, red: { lead: 'low', rear: 'high', feet: 'hold' }, want: { blueHit: false } },
      { real: 'Hearns shows the same body jab and throws the right hand over the lowered guard. Duran falls on his face.', blue: { lead: 'feint', rear: 'over', feet: 'hold', order: 'lead,rear' }, red: { lead: 'low', rear: 'high', feet: 'hold' }, want: { blueHit: 'over', redDown: true } } ] },
  { id: 'check_hook', title: 'The check hook', bout: 'Mayweather v Hatton, 2007, round 10', blue: 'Mayweather', red: 'Hatton', watch: 'Mayweather Hatton check hook round 10',
    lesson: 'Give ground as he rushes and the short lead hook meets him on the way in.', range: 2, hp: [15, 5], st: [7, 4], ropes: [1, 0],
    beats: [
      { real: 'Hatton rushes in swinging a left hook. Mayweather pivots off and lands the lead hook as he comes: Hatton goes into the post.', blue: { lead: 'hook', rear: 'high', feet: 'back', order: 'feet,lead' }, red: { lead: 'hook', rear: 'high', feet: 'in', order: 'feet,lead' }, want: { blueHit: 'hook', redHit: false, redDown: true } } ] },
];
if (typeof window !== 'undefined') window.RS_SCENES = RS_SCENES;
