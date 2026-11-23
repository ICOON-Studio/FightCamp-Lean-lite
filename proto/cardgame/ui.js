// The page. Every game decision lives in engine.mjs / plan.mjs / career.mjs; this file only renders and clicks.
import { CARDS, N, fighter, STYLES } from './cards.mjs';
import { newBout, beginTurn, answerOptions, doAnswer, startAct, declare, endAct, posKey, cost, canPay, legalNow } from './engine.mjs';
import { aiPilot, actions } from './plan.mjs';
import { freshCareer, RUNGS, TITLE_SHOT, CUT_AT_LOSSES, TRAINING, train, resultCareer, playerFighter, rivalFighter, rivalPilot, takesTitle } from './career.mjs';
import { esc, names, cardText, card, previewTraining, rangeStrip, answerTable, howtoLines } from './ui-text.mjs';
import { GUIDE, guideLines, nextGuideLine } from './guide.mjs';
import { newLog, logEntry, stopAt, playLogText } from './playlog.mjs';

const root = document.querySelector('#screen'), where = document.querySelector('#where');
export const state = { career: null, fight: null, first: 0, actor: 0, turn: 0, round: 0, logs: [], note: '', humanPhase: '', careers: 0, champion: false, cut: false, playlog: null, lastLogText: null, why: '', volleyFlag: null,
  guide: true, guideSeen: [], howto: false, bell: false, rivalActed: false };
// S542 (Claude's by-hand play of round 8): a card that could not be laid looked alive and said nothing. It is greyed
// (index.html #hand button[disabled]) and says why: an answer, the wrong range, or not enough wind.
function whyDead(S, me, id) {
  const parts = cardText(id).split(' · ');
  if (parts[1] === 'ANSWER') return 'An answer: you lay it against his volley, not in your own turn.';
  if (!legalNow(S.pj || S, 0, id)) return `Works at ${parts[1]} range - the bout is not there now.`;
  const need = cost(S, 0, id)[0];
  if (!canPay(me, cost(S, 0, id))) return `Costs ${need} wind - you have ${me.wind}.`;
  return 'Cannot be laid now.';
}
function rungBar() { return `<div class="sheet"><div class="row"><b>CAREER LADDER</b><span class="spacer"></span><b>Rank #${state.career.rank}</b></div><div class="rungs">${RUNGS.map((r, i) => `<span class="rung ${i === state.career.rung ? 'current' : i < state.career.rung ? 'done' : ''}">${esc(r)}</span>`).join('')}</div><small>${state.career.wins} wins · ${state.career.losses} losses · loss drops one rung · ${CUT_AT_LOSSES} losses and the gym cuts you</small></div>`; }
// ---- the coach (round 8) ------------------------------------------------------------------------------
// what the coach can see of the bout: the answer table, your own hand, his first turn taken, a point or a point of
// health moved, the bell rung (or the bout ended). Read off the state, never stored by hand, so it cannot drift.
function coachCtx() {
  const S = state.fight;
  return { answer: state.humanPhase === 'answer', act: state.humanPhase === 'act', rivalActed: state.rivalActed,
    scored: !!S && (S.f[0].hp < N.hp || S.f[1].hp < N.hp || S.f[0].pts > 0 || S.f[1].pts > 0), bell: state.bell };
}
// the coach speaks in the first bout of a career (and at its verdict, if a line is still unsaid there) while the
// switch is on. The switch is on for a new career and off after the first bout; the How to play page turns it.
function coachDue() {
  if (!state.guide || !state.career || state.howto) return null;
  if (!(state.career.bouts === 0 || (state.career.bouts === 1 && state.result))) return null;
  return nextGuideLine(state.guideSeen, coachCtx());
}
function coachCard(due) {
  return `<div class="coach-veil"></div><div class="coach" id="coach"><span class="tag">Coach</span><b>${esc(due.title)}</b><p>${esc(due.text)}</p><button class="btn primary" id="gotit">Got it</button></div>`;
}
// one screen: the page's html, with the coach's one line over it when a line is due (and then only Got it is wired),
// else the screen's own buttons. The coach's line points at its element: the element carries the class coach-target.
function paint(html, due, wire) {
  root.innerHTML = html + (due ? coachCard(due) : '');
  if (!due) return wire();
  root.querySelector('#gotit').onclick = () => {
    state.guideSeen.push(due.id);
    if (state.playlog) logEntry(state.playlog, 'coach', `coach: ${due.title}`);
    render();
  };
}
// the class of an element the coach may point at: its own class, plus coach-target while it is the line's target
const aimed = (due, id, base = '') => ` class="${base}${due && due.target === id ? ' coach-target' : ''}"`;
// the How to play button (round 8, item 4): on every screen
function howtoButton() { root.querySelector('#howto').onclick = () => { state.howto = true; render(); }; }
// the first-10-minutes script (plan section 3), minute 0:00: two fighters to pick, two lines each - where he wins,
// his one rule. Round 8: the first bout is against the other art, and a coach stands beside it.
function renderPick() {
  where.textContent = 'ROUND 8 · PICK YOUR FIGHTER';
  const due = coachDue();
  const html = `<h1>FightCamp: the card ladder</h1><p class="lead muted">Pick one of two fighters. Your first bout is club level, against the other art, with a coach beside you: one line at each new thing, the first time it happens. A win climbs one rung; a loss drops one, never below the club.</p><div class="pick">${STYLES.map((s) => `<button class="fighter" data-style="${s}">${s === 'bjj'
    ? '<span class="style">Brazilian jiu-jitsu</span><small><b>Where he wins:</b> on the ground, from underneath - the tap or the pass points.</small><small><b>His one rule:</b> the guard. He sits to guard from any range, and his holds and sweeps work from underneath.</small>'
    : '<span class="style">Boxing</span><small><b>Where he wins:</b> standing, in the pocket - clean punches and the knockout.</small><small><b>His one rule:</b> combinations. A punch laid behind a punch costs 1 less, and the jab steps in by itself.</small>'}<div class="deckpeek">${fighter(s).deck.map((id) => `<span>${esc(names(id))}</span>`).join('')}</div></button>`).join('')}</div><p class="muted">Every card below shows its wind cost, legal range, and result before you play it. The coach can be turned off on the How to play page.</p><div class="row"><span class="spacer"></span><button class="btn" id="howto">How to play</button></div>`;
  paint(html, due, () => {
    root.querySelectorAll('[data-style]').forEach((b) => b.onclick = () => {
      state.careers++; state.career = freshCareer(b.dataset.style, 539 + state.careers * 101); state.champion = state.cut = false; state.note = 'Choose one training turn before your first bout.';
      state.playlog = newLog(); state.lastLogText = null; state.why = ''; state.volleyFlag = null;
      state.guide = true; state.guideSeen = []; state.howto = false; // the guide is on for a new career
      logEntry(state.playlog, 'pick', `picked ${b.dataset.style === 'bjj' ? 'the BJJ man (the guard)' : 'the boxer (combinations)'}`);
      renderTraining();
    });
    howtoButton();
  });
}
function renderTraining() {
  const career = state.career, options = TRAINING[career.style], due = coachDue();
  where.textContent = `TRAINING · ${RUNGS[career.rung].toUpperCase()} · ENERGY ${career.energy}`;
  const html = `${rungBar()}<h1>Training turn</h1><p class="lead muted">Pick one of four. Training costs energy; failure chance is printed here. Failure spends the energy but causes no card/stat loss.</p><div class="offers">${options.map((o) => `<button class="card corner" data-train="${o.id}" ${career.energy < o.cost || career.trainingDone ? 'disabled' : ''}><span class="tiny">${o.cost} energy · ${Math.round(o.fail * 100)}% failure</span><b>${esc(o.label)}</b><small>${esc(previewTraining(o))}</small><small>${career.deck.some((id) => id === o.id || id.startsWith(`${o.id}+`)) ? 'Upgrades one card already in your deck: one card in, one card out.' : `Adds ${esc(names(o.id))} to your deck.`} No stat decay.</small></button>`).join('')}</div><div class="row"><span class="spacer"></span><button class="btn primary" id="skip">${career.trainingDone ? 'Start the bout' : 'Skip training'}</button><button class="btn" id="howto">How to play</button></div><p class="muted">${esc(state.note)}</p><div class="sheet"><b>Current deck</b><div class="offers">${career.deck.map((id) => card(id, 'small')).join('')}</div></div>`;
  paint(html, due, () => {
    root.querySelectorAll('[data-train]').forEach((b) => b.onclick = () => { const o = options.find((x) => x.id === b.dataset.train); const r = train(career, o, seeded(career.seed + career.bouts * 97 + career.energy)); state.note = r.message; if (state.playlog) logEntry(state.playlog, 'training', r.message); if (!r.ok && !r.failed) return renderTraining(); career.trainingDone = true; renderTraining(); });
    root.querySelector('#skip').onclick = () => { if (!career.trainingDone) { career.trainingDone = true; if (state.playlog) logEntry(state.playlog, 'training', 'skipped training'); } if (state.playlog) logEntry(state.playlog, 'bout', `bout ${career.bouts + 1} starts: ${RUNGS[career.rung]} challenger${career.bouts === 0 ? ', his first volley is one card' : ''}`); startFight(); };
    howtoButton();
  });
}
function seeded(seed) { let a = seed >>> 0; return () => { a = (a + 0x6d2b79f5) | 0; let t = Math.imul(a ^ (a >>> 15), 1 | a); t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t; return ((t ^ (t >>> 14)) >>> 0) / 4294967296; }; }
// the first-10-minutes script, minute 0:30: in the first bout the rival's first volley is one card, so the first
// answer is one card against one. His later volleys, and every later bout, are the pilot's full line. Pure, so the
// limit is tested directly: flag.declared is what the player actually sees, flag.full what the pilot wanted.
export function oneCardFirstVolley(base, flag) {
  return { ...base, act(S, k) { const seq = base.act(S, k); if (flag.on) { flag.on = false; flag.full = seq.length; flag.declared = seq.length ? 1 : 0; return seq.slice(0, 1); } return seq; } };
}
function startFight() {
  const career = state.career; career.trainingDone = true;
  state.fight = newBout(playerFighter(career), rivalFighter(career, career.rung), career.seed + career.bouts * 127 + 1);
  state.volleyFlag = { on: career.bouts === 0, full: null, declared: null };
  state.rival = oneCardFirstVolley(rivalPilot(career.rung, career), state.volleyFlag);
  // the first bout opens with his volley (plan section 3, minute 0:30), so the coach's first line has its moment;
  // later bouts keep the coin flip for who leads
  state.first = career.bouts === 0 ? 1 : (state.fight.r() < 0.5 ? 0 : 1);
  state.actor = 0; state.turn = 0; state.round = 0; state.logs = []; state.humanPhase = ''; state.result = null; state.bell = false; state.rivalActed = false;
  state.fight.round = 0; state.note = `${RUNGS[career.rung]} challenger · ${N.rounds} rounds · one visible hand.`;
  advance();
}
function addLog(text) { state.logs.unshift(text); state.logs = state.logs.slice(0, 7); }
function finishTurn(k, seq) {
  endAct(state.fight, k);
  if (seq.length) addLog(`${state.fight.f[k].name}: ${seq.map(names).join(' → ')}`);
  state.actor++;
  if (state.actor >= 2) { state.actor = 0; state.turn++; }
  state.humanPhase = '';
}
// the first-10-minutes script, minute 3:30: one line says why the bout ended. Built from the engine's own final
// state, never from a template that could drift from it.
function whyLine(r) {
  const S = state.fight, W = S.f[r.winner], L = S.f[1 - r.winner], score = (f) => (((N.clkPts ? f.pts : 0) + f.dealt / N.dmgPer)).toFixed(1);
  const his = (f) => (f.name === 'You' ? 'Your' : `${f.name}'s`); // S541 owner's log: "You's health reached 0"
  if (r.how === 'ko') return `Knockout - ${his(L)} health reached 0.`;
  if (r.how === 'lead') return `Points lead - ${W.name} got ahead by ${Math.abs(W.pts - L.pts)} points; a lead of ${N.lead} ends the bout early.`;
  if (r.how === 'tap') return `Tap - ${L.name} tapped out of a submission.`;
  if (r.how === 'pin') return `Pin - ${W.name}'s hold-down ran out its count and scored the bout.`;
  return `Cards - no early finish; the judges counted points and damage: ${W.name} ${score(W)} to ${L.name} ${score(L)}.`;
}
function finishBout() {
  const S = state.fight, a = S.f[0], b = S.f[1];
  const scoreA = (N.clkPts ? a.pts : 0) + a.dealt / N.dmgPer, scoreB = (N.clkPts ? b.pts : 0) + b.dealt / N.dmgPer;
  const winner = S.over ? S.over.win : scoreA !== scoreB ? (scoreA > scoreB ? 0 : 1) : a.hp !== b.hp ? (a.hp > b.hp ? 0 : 1) : S.r() < 0.5 ? 0 : 1;
  const how = S.over?.how || (scoreA === scoreB ? 'cards' : 'points');
  state.result = { winner, how, scoreA, scoreB, hpA: a.hp, hpB: b.hp, ptsA: a.pts, ptsB: b.pts, dealtA: a.dealt, dealtB: b.dealt };
  state.why = whyLine(state.result);
  state.humanPhase = ''; state.bell = true; // the bout is over: any line the coach has not said is said at the verdict
  if (state.playlog) logEntry(state.playlog, 'bout', `the bout ended: ${state.why}`);
  const lastDefence = state.career.rung === RUNGS.length - 1; // read before resultCareer moves the rung
  const wonTitle = takesTitle(state.career, winner === 0); // the belt is won at the title shot (career.mjs)
  const rungBefore = state.career.rung; // S541 owner's log: "Dropped to Club" while already at Club
  const rung = resultCareer(state.career, winner === 0);
  state.champion = state.career.rung > TITLE_SHOT; // he holds the belt while he sits on a defence rung; a lost defence is a title shot again
  state.cut = state.career.losses >= CUT_AT_LOSSES;
  state.complete = winner === 0 && lastDefence; // the career ends at the last defence WON, as in simulateLadder
  state.note = wonTitle ? `Win by ${how}. YOU TAKE THE TITLE at ${RUNGS[TITLE_SHOT]}; rank #${state.career.rank}. The defences are next.`
    : winner === 0 ? `Win by ${how}. ${state.career.rung > TITLE_SHOT ? 'Title defended' : 'Advance'} at ${rung}; rank #${state.career.rank}.`
      : `Loss by ${how}. ${state.career.rung > TITLE_SHOT ? 'The title is gone; back to' : state.career.rung === rungBefore ? 'Stays at' : 'Dropped to'} ${rung}; rank #${state.career.rank}.${state.cut ? ` ${CUT_AT_LOSSES} losses: the gym cuts you.` : ''}`;
  if (state.playlog) logEntry(state.playlog, 'verdict', `verdict: ${state.note}`);
  renderResult();
}
function wrapRound() {
  const S = state.fight;
  state.bell = true; // the bell: the coach's last line has its moment
  if (S.inc.length && !S.over) {
    const k = state.first; beginTurn(S, k, true); const opts = answerOptions(S, k), ans = opts.length > 1 ? state.rival.answer(S, k, opts) : null;
    doAnswer(S, k, ans); addLog('Bell: last volley resolved.'); if (state.playlog) logEntry(state.playlog, 'bout', 'the bell: last volley resolved');
  }
  if (S.over) return finishBout();
  if (S.hold) {
    for (let j = 0; j < 8 && S.hold && !S.over; j++) {
      const k = 1 - S.hold.by; beginTurn(S, k, false); const opts = answerOptions(S, k); const ans = opts.length > 1 ? (k === 0 ? null : state.rival.answer(S, k, opts)) : null; doAnswer(S, k, ans);
    }
  }
  if (S.over || state.round >= N.rounds - 1) return finishBout();
  state.round++; state.turn = 0; state.actor = 0; S.pos = 'K'; S.top = -1; S.rung = 0; S.inc = []; S.grip = S.tie = null; S.hold = null;
  for (const F of S.f) F.wind = Math.min(N.cap, F.wind + N.stool);
  state.first = 1 - state.first; advance();
}
function takeHumanTurn() {
  const S = state.fight, k = 0;
  beginTurn(S, k, false);
  // his volley is on screen whenever he has laid one (round 8): the answer table says what each answer stops, and
  // Take it when nothing does. A volley that is only a step is shown too - the coach's first line points at it.
  const answering = !!S.inc.length || !!(S.hold && S.hold.by !== k);
  const opts = answering ? answerOptions(S, k) : [null];
  state.humanPhase = answering ? 'answer' : 'act';
  if (!answering) { doAnswer(S, k, null); if (S.hold || S.over) { finishTurn(k, []); return advance(); } startAct(S); }
  renderFight(answering ? opts : []);
}
function doAiTurn(k) {
  const S = state.fight, agent = state.rival; beginTurn(S, k, false);
  const opts = S.inc.length || (S.hold && S.hold.by !== k) ? answerOptions(S, k) : [null];
  const ans = opts.length > 1 ? agent.answer(S, k, opts) : null; doAnswer(S, k, ans);
  if (!S.over && !S.hold) { startAct(S); const seq = agent.act(S, k); for (const id of seq) if (legalNow(S.pj, k, id) && canPay(S.f[k], cost(S, k, id))) declare(S, k, id); endAct(S, k); addLog(`${S.f[k].name}: ${seq.map(names).join(' → ') || 'holds range'}`); }
  state.rivalActed = true;
  state.actor++; if (state.actor >= 2) { state.actor = 0; state.turn++; }
}
function advance() {
  const S = state.fight; if (S.over || S.f.some((f) => f.hp <= 0)) return finishBout();
  let guard = 0;
  while (guard++ < 30 && state.turn < N.turns) {
    const k = [state.first, 1 - state.first][state.actor];
    if (k === 0) return takeHumanTurn();
    doAiTurn(k);
    if (S.over || S.f.some((f) => f.hp <= 0)) return finishBout();
  }
  if (state.turn >= N.turns) wrapRound();
}
export function renderFight(answerOpts) {
  const S = state.fight, me = S.f[0], foe = S.f[1];
  const options = answerOpts || (state.humanPhase === 'answer' ? answerOptions(S, 0) : []);
  const due = coachDue();
  where.textContent = `ROUND ${state.round + 1} / ${N.rounds} · TURN ${Math.min(state.turn + 1, N.turns)} / ${N.turns} · ${posKey(S, 0)}`;
  const answering = state.humanPhase === 'answer';
  const playable = answering ? [] : actions(S, 0).filter((id) => legalNow(S.pj || S, 0, id) && canPay(me, cost(S, 0, id)));
  const floorNames = { '@in': 'Step in', '@out': 'Step out', '@stand': 'Let him up', '@up': 'Get up', '@pull': 'Pull guard' };
  const floorActions = playable.filter((id) => id.startsWith('@')).map((id) => `<button class="btn" data-floor="${id}">${floorNames[id] || id} · ${cost(S, 0, id)[0]} wind</button>`).join('');
  const body = answering
    ? `<section${aimed(due, 'volleysheet', 'sheet')} id="volleysheet">${answerTable(S, options)}</section>`
    : `<section class="sheet"><h2>Choose a card or end your turn</h2><div${aimed(due, 'hand', 'hand')} id="hand">${me.hand.map((id, i) => `<button data-card="${i}" ${!playable.includes(id) ? 'disabled' : ''}>${card(id)}<small>${playable.includes(id) ? `Preview · ${esc(cardText(id))}` : esc(whyDead(S, me, id))}</small></button>`).join('')}</div><div class="row">${floorActions}</div><div class="row"><button class="btn primary" id="endTurn">End turn</button><span class="muted">Cards resolve exactly as previewed unless an answer stops them.</span></div></section>`;
  const html = `${rungBar()}<div${aimed(due, 'score', 'scorestrip')} id="score"><b>${esc(me.name)} · ${state.career.style}</b><span>HP ${me.hp}/${N.hp}</span><span>Points ${me.pts}</span><span${aimed(due, 'wind', 'stat')} id="wind">Wind ${me.wind}/${N.cap}</span><span${aimed(due, 'rounds', 'stat')} id="rounds">Round ${state.round + 1}/${N.rounds} · turn ${Math.min(state.turn + 1, N.turns)}/${N.turns}</span>${rangeStrip(posKey(S, 0), due && due.target === 'range' ? 'coach-target' : '')}<span class="spacer"></span><b>${esc(foe.name)} · ${foe.style}</b><span>HP ${foe.hp}</span><span>Points ${foe.pts}</span><span>Wind ${foe.wind}</span><button class="btn" id="howto">How to play</button></div>${body}<div class="sheet"><b>Fight log</b>${state.logs.map((x) => `<small>${esc(x)}</small>`).join('')}</div>`;
  paint(html, due, () => {
    howtoButton();
    root.querySelectorAll('[data-answer]').forEach((b) => b.onclick = () => { const ans = options[+b.dataset.answer]; if (state.playlog) logEntry(state.playlog, 'bout', ans ? `answered ${names(ans.id)} to ${S.inc[ans.i] ? names(S.inc[ans.i].id) : 'the hold'}` : 'took the volley with no answer'); doAnswer(S, 0, ans); if (S.over) return finishBout(); if (S.hold) { finishTurn(0, []); return advance(); } startAct(S); state.humanPhase = 'act'; renderFight(); });
    root.querySelectorAll('[data-card]').forEach((b) => b.onclick = () => { const id = me.hand[+b.dataset.card]; try { declare(S, 0, id); addLog(`You laid ${names(id)} · ${cardText(id)}.`); if (state.playlog) logEntry(state.playlog, 'bout', `laid ${names(id)}`); renderFight(); } catch (e) { state.note = e.message; } });
    root.querySelectorAll('[data-floor]').forEach((b) => b.onclick = () => { const id = b.dataset.floor; try { declare(S, 0, id); addLog(`You chose ${floorNames[id]} · ${cost(S, 0, id)[0]} wind.`); if (state.playlog) logEntry(state.playlog, 'bout', `chose ${floorNames[id]}`); renderFight(); } catch (e) { state.note = e.message; } });
    const endTurn = root.querySelector('#endTurn');
    if (endTurn) endTurn.onclick = () => { const seq = S.inc.filter((x) => x.id && x.id[0] !== '@').map((x) => x.id); if (state.playlog) logEntry(state.playlog, 'bout', 'ended the turn'); finishTurn(0, seq); advance(); };
  });
}
function renderResult() {
  const r = state.result, won = r.winner === 0, due = coachDue();
  where.textContent = `VERDICT · RANK #${state.career.rank}`;
  const html = `${rungBar()}<h1 class="verdictline ${won ? 'win' : 'lose'}">${state.champion && !state.cut ? 'CHAMPION' : won ? 'Victory' : 'Defeat'}</h1><p class="lead">${esc(state.why)}</p><p class="lead muted">${esc(state.note)}</p><p${aimed(due, 'rounds', 'muted')} id="rounds">The bout ended in round ${state.round + 1} of ${N.rounds}.</p><div class="result"><section class="sheet"><b>Everything on the card table</b><table class="cards"><tr><th>Score</th><th>You</th><th>Opponent</th></tr><tr><td>Points</td><td>${r.ptsA}</td><td>${r.ptsB}</td></tr><tr><td>Damage</td><td>${r.dealtA}</td><td>${r.dealtB}</td></tr><tr><td>Health</td><td>${r.hpA}</td><td>${r.hpB}</td></tr><tr><td>Finish</td><td colspan="2">${esc(r.how)}</td></tr></table></section><section class="sheet"><b>Training outcomes</b><p>Energy restored by 2 (maximum 6). No stat decay.</p><p>Deck size: ${state.career.deck.length}. Ladder: ${RUNGS[state.career.rung]}.</p></section></div><div class="row"><button class="btn primary" id="trainNext">${state.cut || state.complete ? 'Start another career' : state.champion ? 'Defend the title' : 'Train for the next bout'}</button><button class="btn" id="newCareer">New career</button><button class="btn" id="copyLog">Copy play log</button><button class="btn" id="howto">How to play</button></div><p class="muted">The play log has every decision of this career with its seconds and where it stopped; the button copies it so you can paste the bout back to us.</p>`;
  paint(html, due, () => {
    // the guide is off after the first bout: leaving its verdict ends the coach's work for this career
    root.querySelector('#trainNext').onclick = () => { if (state.career.bouts === 1) state.guide = false; if (state.cut || state.complete) { if (state.playlog) stopAt(state.playlog, 'verdict', `the career ends (${state.cut ? CUT_AT_LOSSES + ' losses, the gym cuts you' : 'the last defence is won'})`); state.career = null; state.fight = null; state.champion = state.cut = state.complete = false; return renderPick(); } state.note = 'Every option adds or upgrades exactly one card.'; renderTraining(); };
    root.querySelector('#newCareer').onclick = () => { if (state.career.bouts === 1) state.guide = false; if (state.playlog) stopAt(state.playlog, 'verdict', 'the player left the career (New career)'); state.career = null; state.fight = null; state.champion = state.cut = state.complete = false; renderPick(); };
    root.querySelector('#copyLog').onclick = () => { copyPlayLog(); };
    howtoButton();
  });
}
// the How to play page (round 8, item 4): one page, plain words, the rules in six lines with a small picture of the
// strip, and the switch that turns the coach off (item 5)
function renderHowTo() {
  where.textContent = 'HOW TO PLAY';
  const html = `<h1>How to play</h1><p class="lead muted">The whole game in six lines, and the strip it is fought on. The coach says the same lines, one at a time, in your first bout.</p>${rangeStrip(null, 'picture')}<div class="howto">${howtoLines()}</div><div class="row"><button class="btn" id="guideSwitch">Coach lines: ${state.guide ? 'ON' : 'OFF'}</button><button class="btn primary" id="back">Back</button><button class="btn" id="howto">How to play</button></div>`;
  paint(html, null, () => {
    root.querySelector('#back').onclick = () => { state.howto = false; render(); };
    root.querySelector('#guideSwitch').onclick = () => { state.guide = !state.guide; renderHowTo(); };
    root.querySelector('#howto').onclick = () => renderHowTo();
  });
}
// one button copies the play log (plan section 7): the browser takes it to the clipboard; the stub document has no
// clipboard, so the same text is left on the table (state.lastLogText) for a reader or a test.
export function copyPlayLog() {
  const text = playLogText(state.playlog);
  state.lastLogText = text;
  try { if (typeof navigator !== 'undefined' && navigator.clipboard && navigator.clipboard.writeText) navigator.clipboard.writeText(text).catch(() => {}); } catch (e) { /* node: no clipboard; the text is on the table */ }
  return text;
}
function render() { if (state.howto) return renderHowTo(); if (!state.career) return renderPick(); if (state.result) return renderResult(); if (state.fight && state.humanPhase) return renderFight(); renderTraining(); }
// back to the art pick, with nothing of the old career on the table (the page's New career button, and the tests)
export function reset() { state.career = null; state.fight = null; state.result = null; state.humanPhase = ''; state.champion = state.cut = state.complete = false; state.logs = []; state.why = ''; state.volleyFlag = null; state.lastLogText = null; state.guide = true; state.guideSeen = []; state.howto = false; state.bell = false; state.rivalActed = false; render(); }
render();
