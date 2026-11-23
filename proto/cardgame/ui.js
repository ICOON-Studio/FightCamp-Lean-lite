import { CARDS, N, fighter, STYLES } from './cards.mjs';
import { newBout, beginTurn, answerOptions, doAnswer, startAct, actions, declare, endAct, bout, posKey, cost, canPay, legalNow, clone } from './engine.mjs';
import { aiPilot, impatient } from './plan.mjs';
import { freshCareer, RUNGS, TRAINING, train, resultCareer, playerFighter, rivalFighter, measureTraining, assertCareer } from './career.mjs';

const root = document.querySelector('#screen'), where = document.querySelector('#where');
const esc = (s) => String(s).replace(/[&<>"']/g, (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' })[c]);
const state = { career: null, fight: null, first: 0, actor: 0, turn: 0, round: 0, logs: [], note: '', humanPhase: '' };
const names = (id) => CARDS[id]?.n || id;
function cardText(id) {
  const c = CARDS[id], at = c.at ? c.at.map((x) => ({ K: 'KICK', P: 'PUNCH', C: 'CLINCH', G: 'GROUND', T: 'TOP', B: 'GUARD' }[x] || x)).join(' / ') : 'ANSWER';
  const effect = c.k === 'strike' ? `${c.dmg} damage${c.pts ? ` + ${c.pts} point${c.pts === 1 ? '' : 's'}` : ''}${c.drain ? ' · drains wind' : ''}` : c.k === 'shot' ? `Takedown · rung ${c.to} · ${c.pts} points${c.dmg ? ` · ${c.dmg} damage` : ''}` : c.k === 'hold' ? `${c.hk === 'sub' ? 'Submission' : 'Pin'} · countdown ${c.count}${c.brk ? ` · break at ${c.brk} wind` : ''}` : c.k === 'adv' ? `Advance one rung · ${c.pts} points` : c.k === 'setup' ? 'Grip setup · makes throws reliable' : c.fx === 'block' ? `a strike: ${c.guard || N.block} off` : c.fx ? `${c.vs}` : c.act ? 'Escape / stand up' : c.vs || 'Move';
  return `${c.w} wind · ${at} · ${effect}`;
}
function card(id, extra = '') {
  const c = CARDS[id];
  return `<article class="card ${c.k === 'strike' ? 'punch' : c.k === 'ans' ? 'defence' : 'corner'} ${extra}"><b>${esc(names(id))}</b><small>${esc(cardText(id))}</small></article>`;
}
function rungBar() { return `<div class="sheet"><div class="row"><b>CAREER LADDER</b><span class="spacer"></span><b>Rank #${state.career.rank}</b></div><div class="rungs">${RUNGS.map((r, i) => `<span class="rung ${i === state.career.rung ? 'current' : i < state.career.rung ? 'done' : ''}">${esc(r)}</span>`).join('')}</div><small>${state.career.wins} wins · ${state.career.losses} losses · loss drops one rung</small></div>`; }
function renderPick() {
  where.textContent = 'ROUND 6 · PICK YOUR ART';
  root.innerHTML = `<h1>FightCamp: the card ladder</h1><p class="lead muted">Two arts, one visible rule per card. Boxing owns the combinations; Brazilian jiu-jitsu owns the guard.</p><div class="pick">${['boxing', 'bjj'].map((s) => `<button class="fighter" data-style="${s}"><span class="style">${s === 'bjj' ? 'Brazilian jiu-jitsu' : 'Boxing'}</span><b>${s === 'bjj' ? 'Take the guard' : 'Own the pocket'}</b><small>${s === 'bjj' ? 'Pull guard; attack from underneath.' : 'Jab to enter; build the combination.'}</small><div class="deckpeek">${fighter(s).deck.map((id) => `<span>${esc(names(id))}</span>`).join('')}</div></button>`).join('')}</div><p class="muted">Every card below shows its wind cost, legal range, and result before you play it.</p>`;
  root.querySelectorAll('[data-style]').forEach((b) => b.onclick = () => { state.career = freshCareer(b.dataset.style, 539); state.note = 'Choose one training turn before your first bout.'; renderTraining(); });
}
function previewTraining(option) {
  const c = CARDS[option.id];
  if (c.k === 'strike') return `Preview: ${c.dmg} damage${c.pts ? `, ${c.pts} point` : ''}; trained version: ${c.dmg + 1} damage.`;
  if (c.fx === 'block') return `Preview: ${cardText(option.id)}; trained version blocks ${N.block + 1} damage.`;
  if (c.k === 'hold') return `Preview: ${cardText(option.id)}; trained version shortens the hold countdown by one.`;
  if (c.pts) return `Preview: ${cardText(option.id)}; trained version scores ${c.pts + 1} points.`;
  return `Preview: ${cardText(option.id)}; trained version costs ${Math.max(0, c.w - 1)} wind.`;
}
function renderTraining() {
  const career = state.career, options = TRAINING[career.style];
  where.textContent = `TRAINING · ${RUNGS[career.rung].toUpperCase()} · ENERGY ${career.energy}`;
  root.innerHTML = `${rungBar()}<h1>Training turn</h1><p class="lead muted">Pick one of four. Training costs energy; failure chance is printed here. Failure spends the energy but causes no card/stat loss.</p><div class="offers">${options.map((o) => `<button class="card corner" data-train="${o.id}" ${career.energy < o.cost || career.trainingDone ? 'disabled' : ''}><span class="tiny">${o.cost} energy · ${Math.round(o.fail * 100)}% failure</span><b>${esc(o.label)}</b><small>${esc(previewTraining(o))}</small><small>${career.deck.includes(o.id) ? 'Upgrades one card already in your deck.' : `Adds ${esc(names(o.id))} to your deck.`} No stat decay.</small></button>`).join('')}</div><div class="row"><span class="spacer"></span><button class="btn primary" id="skip">Skip training</button></div><p class="muted">${esc(state.note)}</p><div class="sheet"><b>Current deck</b><div class="offers">${career.deck.map((id) => card(id, 'small')).join('')}</div></div>`;
  root.querySelectorAll('[data-train]').forEach((b) => b.onclick = () => { const o = options.find((x) => x.id === b.dataset.train); const rng = seeded(career.seed + career.bouts * 97 + career.energy); const r = train(career, o, rng); state.note = r.message; if (!r.ok && !r.failed) return renderTraining(); career.trainingDone = true; renderTraining(); });
  root.querySelector('#skip').onclick = () => { career.trainingDone = true; startFight(); };
  if (career.trainingDone) { root.querySelector('#skip').textContent = 'Start the bout'; root.querySelector('#skip').onclick = startFight; }
}
function seeded(seed) { let a = seed >>> 0; return () => { a = (a + 0x6d2b79f5) | 0; let t = Math.imul(a ^ (a >>> 15), 1 | a); t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t; return ((t ^ (t >>> 14)) >>> 0) / 4294967296; }; }
function startFight() {
  const career = state.career; if (!career.trainingDone) career.trainingDone = true;
  state.fight = newBout(playerFighter(career), rivalFighter(career, career.rung), career.seed + career.bouts * 127 + 1);
  state.first = state.fight.r() < 0.5 ? 0 : 1; state.actor = 0; state.turn = 0; state.round = 0; state.logs = []; state.humanPhase = '';
  state.fight.round = 0; state.note = `${RUNGS[career.rung]} challenger · two rounds · one visible hand.`;
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
function finishBout() {
  const S = state.fight, a = S.f[0], b = S.f[1];
  const scoreA = (N.clkPts ? a.pts : 0) + a.dealt / N.dmgPer, scoreB = (N.clkPts ? b.pts : 0) + b.dealt / N.dmgPer;
  const winner = S.over ? S.over.win : scoreA !== scoreB ? (scoreA > scoreB ? 0 : 1) : a.hp !== b.hp ? (a.hp > b.hp ? 0 : 1) : S.r() < 0.5 ? 0 : 1;
  const how = S.over?.how || (scoreA === scoreB ? 'cards' : 'points');
  state.result = { winner, how, scoreA, scoreB, hpA: a.hp, hpB: b.hp, ptsA: a.pts, ptsB: b.pts, dealtA: a.dealt, dealtB: b.dealt };
  const wonTitle = winner === 0 && state.career.rung === RUNGS.length - 1;
  const rung = resultCareer(state.career, winner === 0);
  state.champion = wonTitle;
  state.note = `${winner === 0 ? 'Win' : 'Loss'} by ${how}. ${winner === 0 ? 'Advance' : 'Dropped/held'} at ${rung}; rank #${state.career.rank}.${wonTitle ? ' TITLE DEFENDED — career complete.' : ''}`;
  renderResult();
}
function wrapRound() {
  const S = state.fight;
  if (S.inc.length && !S.over) {
    const k = state.first; beginTurn(S, k, true); const opts = answerOptions(S, k), ans = opts.length > 1 ? aiPilot().answer(S, k, opts) : null;
    doAnswer(S, k, ans); addLog('Bell: last volley resolved.');
  }
  if (S.over) return finishBout();
  if (S.hold) {
    for (let j = 0; j < 8 && S.hold && !S.over; j++) {
      const k = 1 - S.hold.by; beginTurn(S, k, false); const opts = answerOptions(S, k); const ans = opts.length > 1 ? aiPilot().answer(S, k, opts) : null; doAnswer(S, k, ans);
    }
  }
  if (S.over || state.round >= N.rounds - 1) return finishBout();
  state.round++; S.round = state.round; state.turn = 0; state.actor = 0; S.pos = 'K'; S.top = -1; S.rung = 0; S.inc = []; S.grip = S.tie = null; S.hold = null;
  for (const F of S.f) F.wind = Math.min(N.cap, F.wind + N.stool);
  state.first = 1 - state.first; advance();
}
function takeHumanTurn() {
  const S = state.fight, k = 0, bell = false;
  beginTurn(S, k, bell);
  const opts = S.inc.length || (S.hold && S.hold.by !== k) ? answerOptions(S, k) : [null];
  state.humanPhase = opts.length > 1 ? 'answer' : 'act';
  if (opts.length <= 1) { doAnswer(S, k, null); if (S.hold || S.over) { finishTurn(k, []); return advance(); } startAct(S); }
  renderFight(opts.length > 1 ? opts : []);
}
function doAiTurn(k) {
  const S = state.fight, agent = aiPilot(); beginTurn(S, k, false);
  const opts = S.inc.length || (S.hold && S.hold.by !== k) ? answerOptions(S, k) : [null];
  const ans = opts.length > 1 ? agent.answer(S, k, opts) : null; doAnswer(S, k, ans);
  if (!S.over && !S.hold) { startAct(S); const seq = agent.act(S, k); for (const id of seq) if (legalNow(S.pj, k, id) && canPay(S.f[k], cost(S, k, id))) declare(S, k, id); endAct(S, k); addLog(`${S.f[k].name}: ${seq.map(names).join(' → ') || 'holds range'}`); }
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
function renderFight(answerOpts) {
  const S = state.fight, me = S.f[0], foe = S.f[1], options = answerOpts || (state.humanPhase === 'answer' ? answerOptions(S, 0) : []);
  where.textContent = `ROUND ${state.round + 1} / ${N.rounds} · TURN ${Math.min(state.turn + 1, N.turns)} / ${N.turns} · ${posKey(S, 0)}`;
  let preview = options.length ? `<h2>Answer the visible volley</h2><div class="offers">${options.map((o, i) => `<button class="card defence" data-answer="${i}"><b>${o ? esc(names(o.id)) : 'Take it'}</b><small>${o ? esc(cardText(o.id)) : 'No answer cost; incoming cards resolve in order.'}</small></button>`).join('')}</div>` : '';
  const playable = state.humanPhase === 'act' ? actions(S, 0).filter((id) => legalNow(S.pj || S, 0, id) && canPay(me, cost(S, 0, id))) : [];
  const floorNames = { '@in': 'Step in', '@out': 'Step out', '@stand': 'Stand', '@up': 'Get up', '@pull': 'Pull guard' };
  const floorActions = playable.filter((id) => id.startsWith('@')).map((id) => `<button class="btn" data-floor="${id}">${floorNames[id] || id} · ${cost(S, 0, id)[0]} wind</button>`).join('');
  root.innerHTML = `${rungBar()}<div class="scorestrip"><b>${esc(me.name)} · boxing / BJJ</b><span>HP ${me.hp}/${N.hp}</span><span>Points ${me.pts}</span><span>Wind ${me.wind}/${N.cap}</span><span>Range ${posKey(S, 0)}</span><span class="spacer"></span><b>${esc(foe.name)} · ${foe.style}</b><span>HP ${foe.hp}</span><span>Points ${foe.pts}</span><span>Wind ${foe.wind}</span></div>${preview}<section class="sheet"><h2>${state.humanPhase === 'act' ? 'Choose a card or end your turn' : 'Opponent’s visible hand / action'}</h2><div class="hand">${me.hand.map((id, i) => `<button data-card="${i}" ${!playable.includes(id) ? 'disabled' : ''}>${card(id)}<small>Preview · ${esc(cardText(id))}</small></button>`).join('')}</div><div class="row">${floorActions}</div><div class="row"><button class="btn primary" id="endTurn" ${state.humanPhase !== 'act' ? 'disabled' : ''}>End turn</button><span class="muted">Cards resolve exactly as previewed unless an answer stops them.</span></div></section><div class="sheet"><b>Fight log</b>${state.logs.map((x) => `<small>${esc(x)}</small>`).join('')}</div>`;
  root.querySelectorAll('[data-answer]').forEach((b) => b.onclick = () => { const ans = options[+b.dataset.answer]; doAnswer(S, 0, ans); if (S.over) return finishBout(); if (S.hold) { finishTurn(0, []); return advance(); } startAct(S); state.humanPhase = 'act'; renderFight(); });
  root.querySelectorAll('[data-card]').forEach((b) => b.onclick = () => { const id = me.hand[+b.dataset.card]; try { declare(S, 0, id); addLog(`You laid ${names(id)} · ${cardText(id)}.`); renderFight(); } catch (e) { state.note = e.message; } });
  root.querySelectorAll('[data-floor]').forEach((b) => b.onclick = () => { const id = b.dataset.floor; try { declare(S, 0, id); addLog(`You chose ${floorNames[id]} · ${cost(S, 0, id)[0]} wind.`); renderFight(); } catch (e) { state.note = e.message; } });
  root.querySelector('#endTurn').onclick = () => { const seq = S.inc.filter((x) => x.id && x.id[0] !== '@').map((x) => x.id); finishTurn(0, seq); advance(); };
}
function renderResult() {
  const r = state.result, won = r.winner === 0;
  where.textContent = `VERDICT · RANK #${state.career.rank}`;
  root.innerHTML = `${rungBar()}<h1 class="verdictline ${won ? 'win' : 'lose'}">${won ? 'Victory' : 'Defeat'}</h1><p class="lead">${esc(state.note)}</p><div class="result"><section class="sheet"><b>Everything on the card table</b><table class="cards"><tr><th>Score</th><th>You</th><th>Opponent</th></tr><tr><td>Points</td><td>${r.ptsA}</td><td>${r.ptsB}</td></tr><tr><td>Damage</td><td>${r.dealtA}</td><td>${r.dealtB}</td></tr><tr><td>Health</td><td>${r.hpA}</td><td>${r.hpB}</td></tr><tr><td>Finish</td><td colspan="2">${esc(r.how)}</td></tr></table></section><section class="sheet"><b>Training outcomes</b><p>Energy restored by 2 (maximum 6). No stat decay.</p><p>Deck size: ${state.career.deck.length}. Ladder: ${RUNGS[state.career.rung]}.</p></section></div><div class="row"><button class="btn primary" id="trainNext">${state.champion ? 'Start another career' : 'Train for the next bout'}</button><button class="btn" id="newCareer">New career</button></div>`;
  root.querySelector('#trainNext').onclick = () => { if (state.champion) { state.career = null; state.fight = null; state.champion = false; return renderPick(); } state.note = 'Every option adds or upgrades exactly one card.'; renderTraining(); };
  root.querySelector('#newCareer').onclick = renderPick;
}
function render() { if (!state.career) return renderPick(); if (state.fight && state.humanPhase) return renderFight(); renderTraining(); }
render();
